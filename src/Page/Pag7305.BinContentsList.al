#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7305 "Bin Contents List"
{
    Caption = 'Bin Contents List';
    DataCaptionExpression = GetCaption;
    Editable = false;
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
                    ToolTip = 'Specifies the location code of the bin.';
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
                    ToolTip = 'Specifies the bin code.';
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
                field(Default;Default)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the bin is the default bin for the associated item.';
                }
                field("Fixed";Fixed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the item (bin content) has been associated with this bin, and that the bin should normally contain the item.';
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
                field(CalcQtyAvailToTakeUOM;CalcQtyAvailToTakeUOM)
                {
                    ApplicationArea = Basic;
                    Caption = 'Available Qty. to Take';
                    DecimalPlaces = 0:5;
                    Visible = false;
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
                field("Cross-Dock Bin";"Cross-Dock Bin")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the bin content is in a cross-dock bin.';
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

    trigger OnOpenPage()
    begin
        if Initialized then begin
          FilterGroup(2);
          SetRange("Location Code",LocationCode);
          FilterGroup(0);
        end;
    end;

    var
        LocationCode: Code[10];
        Initialized: Boolean;


    procedure Initialize(LocationCode2: Code[10])
    begin
        LocationCode := LocationCode2;
        Initialized := true;
    end;
}

