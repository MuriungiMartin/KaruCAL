#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6507 "Item Tracking List"
{
    Caption = 'Item Tracking List';
    Editable = false;
    PageType = List;
    SourceTable = "Reservation Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of the item that is being handled on the document line.';
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the lot number of the item that is being handled with the associated document line.';
                }
                field("Warranty Date";"Warranty Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last day of the serial/lot number''s warranty.';
                    Visible = false;
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the expiration date of the lot or serial number on the item tracking line.';
                    Visible = false;
                }
                field("Quantity (Base)";"Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the item that has been reserved in the entry.';
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

