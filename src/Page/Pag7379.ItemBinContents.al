#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7379 "Item Bin Contents"
{
    Caption = 'Item Bin Contents';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Bin Content";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that will be stored in the bin.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the item in the bin.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code of the bin.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin code.';
                }
                field("Fixed";Fixed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the item (bin content) has been associated with this bin, and that the bin should normally contain the item.';
                }
                field(Default;Default)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the bin is the default bin for the associated item.';
                }
                field(Dedicated;Dedicated)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the bin is used as a dedicated bin, which means that its bin content is available only to certain resources.';
                }
                field(CalcQtyUOM;CalcQtyUOM)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item in the bin.';
                }
                field("Quantity (Base)";"Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item, in the base unit of measure, are stored in the bin.';
                }
                field("Bin Type Code";"Bin Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin type that was selected for this bin.';
                    Visible = false;
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the zone code of the bin.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control7;"Lot Numbers by Bin FactBox")
            {
                SubPageLink = "Item No."=field("Item No."),
                              "Variant Code"=field("Variant Code"),
                              "Location Code"=field("Location Code");
                Visible = false;
            }
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if xRec."Location Code" <> '' then
          "Location Code" := xRec."Location Code";
    end;

    local procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "Object Translation";
        ItemNo: Code[20];
        VariantCode: Code[10];
        BinCode: Code[20];
        FormCaption: Text[250];
        SourceTableName: Text[250];
    begin
        SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,14);
        FormCaption := StrSubstNo('%1 %2',SourceTableName,"Location Code");
        if GetFilter("Item No.") <> '' then
          if GetRangeMin("Item No.") = GetRangemax("Item No.") then begin
            ItemNo := GetRangeMin("Item No.");
            if ItemNo <> '' then begin
              SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,27);
              FormCaption := StrSubstNo('%1 %2 %3',FormCaption,SourceTableName,ItemNo)
            end;
          end;

        if GetFilter("Variant Code") <> '' then
          if GetRangeMin("Variant Code") = GetRangemax("Variant Code") then begin
            VariantCode := GetRangeMin("Variant Code");
            if VariantCode <> '' then begin
              SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,5401);
              FormCaption := StrSubstNo('%1 %2 %3',FormCaption,SourceTableName,VariantCode)
            end;
          end;

        if GetFilter("Bin Code") <> '' then
          if GetRangeMin("Bin Code") = GetRangemax("Bin Code") then begin
            BinCode := GetRangeMin("Bin Code");
            if BinCode <> '' then begin
              SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,7354);
              FormCaption := StrSubstNo('%1 %2 %3',FormCaption,SourceTableName,BinCode);
            end;
          end;

        exit(FormCaption);
    end;
}

