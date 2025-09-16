#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7304 "Bin Content"
{
    Caption = 'Bin Content';
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
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the location code of the bin.';
                    Visible = false;
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the zone code of the bin.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the bin code.';
                }
                field("Bin Type Code";"Bin Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin type that was selected for this bin.';
                    Visible = false;
                }
                field("Block Movement";"Block Movement")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how the movement of a particular item, or bin content, into or out of this bin, is blocked.';
                    Visible = false;
                }
                field("Bin Ranking";"Bin Ranking")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin ranking.';
                    Visible = false;
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
                field("Warehouse Class Code";"Warehouse Class Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the warehouse class code. Only items with the same warehouse class can be stored in this bin.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that will be stored in the bin.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the item in the bin.';
                    Visible = false;
                }
                field(CalcQtyUOM;CalcQtyUOM)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                }
                field("Quantity (Base)";"Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item, in the base unit of measure, are stored in the bin.';
                }
                field("Min. Qty.";"Min. Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the minimum number of units of the item that you want to have in the bin at all times.';
                    Visible = false;
                }
                field("Max. Qty.";"Max. Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the maximum number of units of the item that you want to have in the bin.';
                    Visible = false;
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of base units of measure that are in the unit of measure specified for the item in the bin.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item in the bin.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control3;"Lot Numbers by Bin FactBox")
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
        if xRec."Bin Code" <> '' then
          "Bin Code" := xRec."Bin Code";
        SetUpNewLine;
    end;
}

