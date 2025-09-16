#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 505 "Reservation Summary"
{
    Caption = 'Reservation Summary';
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Entry Summary";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Summary Type";"Summary Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which type of line or entry is summarized in the entry summary.';
                }
                field("Total Quantity";"Total Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total quantity of the item in inventory.';
                }
                field("Total Reserved Quantity";"Total Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total quantity of the relevant item that is reserved on documents or entries of the type on the line.';
                }
                field("Total Available Quantity";"Total Available Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity available for the user to request, in entries of the type on the line.';
                }
                field("Current Reserved Quantity";"Current Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of items in the entry that are reserved for the line that the Reservation window is opened from.';
                }
            }
        }
    }

    actions
    {
    }
}

