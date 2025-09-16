#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5985 "Service Item Replacement"
{
    Caption = 'Service Item Replacement';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                group("Old Service Item")
                {
                    Caption = 'Old Service Item';
                    field(ServItemNo;ServItemNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Item No.';
                        Editable = false;
                    }
                    field("Item.""No.""";Item."No.")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item No.';
                        Editable = false;
                    }
                    field("Item.Description";Item.Description)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item Description';
                        Editable = false;
                    }
                    field(ServItemVariantCode;ServItemVariantCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant Code';
                        Editable = false;
                    }
                    field(OldSerialNo;OldSerialNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Serial No.';
                        Editable = false;
                    }
                }
                group("New Service Item")
                {
                    Caption = 'New Service Item';
                    field("Item No.";Item."No.")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item No.';
                        Editable = false;
                    }
                    field("Item Description";Item.Description)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item Description';
                        Editable = false;
                    }
                    field(VariantCode;VariantCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant Code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            ItemVariant.Reset;
                            ItemVariant.SetRange("Item No.",ItemNo);
                            if Page.RunModal(Page::"Item Variants",ItemVariant) = Action::LookupOK then
                              VariantCode := ItemVariant.Code;
                        end;

                        trigger OnValidate()
                        begin
                            if VariantCode <> '' then begin
                              ItemVariant.Reset;
                              ItemVariant.SetRange("Item No.",ItemNo);
                              ItemVariant.SetRange(Code,VariantCode);
                              if not ItemVariant.FindFirst then
                                Error(
                                  Text000,
                                  ItemVariant.TableCaption,ItemNo,VariantCode);
                            end;
                        end;
                    }
                    field(NewSerialNo;NewSerialNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Serial No.';

                        trigger OnAssistEdit()
                        var
                            ItemLedgEntry: Record "Item Ledger Entry";
                        begin
                            Clear(ItemLedgEntry);
                            ItemLedgEntry.SetCurrentkey("Item No.",Open);
                            ItemLedgEntry.SetRange("Item No.",ItemNo);
                            ItemLedgEntry.SetRange(Open,true);
                            ItemLedgEntry.SetRange("Variant Code",VariantCode);
                            ItemLedgEntry.SetFilter("Serial No.",'<>%1','');
                            if Page.RunModal(0,ItemLedgEntry) = Action::LookupOK then
                              NewSerialNo := ItemLedgEntry."Serial No.";
                        end;
                    }
                    field(CopyComponents;CopyComponentsFrom)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Copy Components From';
                        Enabled = CopyComponentsEnable;
                        OptionCaption = 'None,Item BOM,Old Service Item,Old Service Item w/o Serial No.';

                        trigger OnValidate()
                        begin
                            case CopyComponentsFrom of
                              Copycomponentsfrom::"Item BOM":
                                if not Item."Assembly BOM" then
                                  Error(
                                    Text002,
                                    Item.FieldCaption("Assembly BOM"),
                                    Item.TableCaption,
                                    Item.FieldCaption("No."),
                                    Item."No.");
                              Copycomponentsfrom::"Old Service Item",
                              Copycomponentsfrom::"Old Service Item w/o Serial No.":
                                if not ServItem."Service Item Components" then
                                  Error(
                                    Text002,
                                    ServItem.FieldCaption("Service Item Components"),
                                    ServItem.TableCaption,
                                    ServItem.FieldCaption("No."),
                                    ServItem."No.")
                            end;
                        end;
                    }
                }
                field(Replacement;Replacement)
                {
                    ApplicationArea = Basic;
                    Caption = 'Replacement';
                    OptionCaption = 'Temporary,Permanent';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CopyComponentsEnable := true;
    end;

    trigger OnOpenPage()
    begin
        ServItem.Get(ServItemNo);
        OldSerialNo := ServItem."Serial No.";
        ServItemVariantCode := ServItem."Variant Code";
        if not Item.Get(ServItem."Item No.") then
          Clear(Item);

        ServItem.CalcFields("Service Item Components");
        Item.CalcFields("Assembly BOM");
        CopyComponentsEnable := ServItem."Service Item Components" or Item."Assembly BOM"
    end;

    var
        Text000: label 'The %1 %2,%3 does not exists.', Comment='The Item Variant LS-10PC , LS-10PC-B does not exists.';
        Item: Record Item;
        ServItem: Record "Service Item";
        ItemVariant: Record "Item Variant";
        Replacement: Option "Temporary",Permanent;
        OldSerialNo: Code[20];
        NewSerialNo: Code[20];
        ServItemNo: Code[20];
        ItemNo: Code[20];
        VariantCode: Code[10];
        ServItemVariantCode: Code[10];
        CopyComponentsFrom: Option "None","Item BOM","Old Service Item","Old Service Item w/o Serial No.";
        Text002: label 'There is no %1 in the %2 %3 %4.', Comment='There is no Assembly BOM in the Item No. 1002';
        [InDataSet]
        CopyComponentsEnable: Boolean;


    procedure SetValues(ServItemNo2: Code[20];ItemNo2: Code[20];VariantCode2: Code[10])
    begin
        ServItemNo := ServItemNo2;
        ItemNo := ItemNo2;
        VariantCode := VariantCode2;
    end;


    procedure ReturnSerialNo(): Text[20]
    begin
        exit(NewSerialNo);
    end;


    procedure ReturnReplacement(): Integer
    begin
        exit(Replacement);
    end;


    procedure ReturnVariantCode(): Text[10]
    begin
        exit(VariantCode);
    end;


    procedure ReturnCopyComponentsFrom(): Integer
    begin
        exit(CopyComponentsFrom);
    end;


    procedure SetParameters(VariantCodeFrom: Code[10];NewSerialNoFrom: Code[20];NewCopyComponentsFrom: Option;ReplacementFrom: Option)
    begin
        VariantCode := VariantCodeFrom;
        NewSerialNo := NewSerialNoFrom;
        CopyComponentsFrom := NewCopyComponentsFrom;
        Replacement := ReplacementFrom;
    end;
}

