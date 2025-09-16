#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6515 "Enter Customized SN"
{
    Caption = 'Enter Customized SN';
    PageType = StandardDialog;
    SaveValues = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ItemNo;ItemNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item No.';
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Item."No." := ItemNo;
                        Page.RunModal(0,Item);
                    end;
                }
                field(VariantCode;VariantCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Variant Code';
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ItemVariant.Reset;
                        ItemVariant.SetRange("Item No.",ItemNo);
                        ItemVariant."Item No." := ItemNo;
                        ItemVariant.Code := ItemNo;
                        Page.RunModal(0,ItemVariant);
                    end;
                }
                field(CustomizedSN;CustomizedSN)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customized SN';
                }
                field(Increment;Increment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Increment';
                }
                field(QtyToCreate;QtyToCreate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity to Create';
                }
                field(CreateNewLotNo;CreateNewLotNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create New Lot No.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        ItemNo := InitItemNo;
        VariantCode := InitVariantCode;
        QtyToCreate := InitQtyToCreate;
        CreateNewLotNo := InitCreateNewLotNo;
    end;

    var
        Item: Record Item;
        ItemVariant: Record "Item Variant";
        ItemNo: Code[20];
        VariantCode: Code[10];
        QtyToCreate: Integer;
        CreateNewLotNo: Boolean;
        InitItemNo: Code[20];
        InitVariantCode: Code[10];
        InitQtyToCreate: Integer;
        InitCreateNewLotNo: Boolean;
        CustomizedSN: Code[20];
        Increment: Integer;


    procedure SetFields(SetItemNo: Code[20];SetVariantCode: Code[10];SetQtyToCreate: Integer;SetCreateNewLotNo: Boolean)
    begin
        InitItemNo := SetItemNo;
        InitVariantCode := SetVariantCode;
        InitQtyToCreate := SetQtyToCreate;
        InitCreateNewLotNo := SetCreateNewLotNo;
    end;


    procedure GetFields(var GetQtyToCreate: Integer;var GetCreateNewLotNo: Boolean;var GetCustomizedSN: Code[20];var GetIncrement: Integer)
    begin
        GetQtyToCreate := QtyToCreate;
        GetCreateNewLotNo := CreateNewLotNo;
        GetCustomizedSN := CustomizedSN;
        GetIncrement := Increment;
    end;
}

