#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5524 "Get Alternative Supply"
{
    Caption = 'Get Alternative Supply';
    DataCaptionFields = "No.",Description;
    Editable = false;
    PageType = Worksheet;
    SourceTable = "Requisition Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account or item to be entered on the line.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a variant code for the item.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for an inventory location where the items that are being ordered will be registered.';
                }
                field("Demand Date";"Demand Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the demanded date of the demand that the planning line represents.';
                }
            }
            repeater(Control1)
            {
                field("No.2";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account or item to be entered on the line.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies text that describes the entry.';
                }
                field("Transfer-from Code";"Transfer-from Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location that the item will be transferred from.';
                }
                field("Needed Quantity";"Needed Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the demand quantity that is not available and must be ordered to meet the demand represented on the planning line.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code used to determine the unit price.';
                    Visible = false;
                }
                field("Demand Qty. Available";"Demand Qty. Available")
                {
                    ApplicationArea = Basic;
                    Caption = 'Available Quantity';
                    ToolTip = 'Specifies how many of the demand quantity are available.';
                }
                field("Demand Quantity";"Demand Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity on the demand that the planning line represents.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
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
}

