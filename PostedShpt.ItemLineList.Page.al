#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5950 "Posted Shpt. Item Line List"
{
    Caption = 'Posted Service Shpt. Item Line List';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Service Shipment Item Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service shipment header linked to this shipment item line.';
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of this line.';
                }
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item registered in the Service Item table and associated with the customer.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item to which this posted service item is related.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of this service item.';
                }
                field("Warranty Ending Date (Parts)";"Warranty Ending Date (Parts)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the spare parts warranty expires for this service item.';
                }
                field("Loaner No.";"Loaner No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the loaner that has been lent to the customer to replace this service item.';
                }
                field(Warranty;Warranty)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that there is a warranty on either parts or labor for this service item.';
                }
                field("Warranty Ending Date (Labor)";"Warranty Ending Date (Labor)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the labor warranty expires on the posted service item.';
                }
                field("Warranty Starting Date (Parts)";"Warranty Starting Date (Parts)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the warranty starts on the service item spare parts.';
                }
                field("Warranty Starting Date (Labor)";"Warranty Starting Date (Labor)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the labor warranty for the posted service item starts.';
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contract associated with the posted service item.';
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

