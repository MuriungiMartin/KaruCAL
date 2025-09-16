#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5949 "Posted Serv. Shpt. Line List"
{
    Caption = 'Posted Serv. Shpt. Line List';
    Editable = false;
    PageType = List;
    SourceTable = "Service Shipment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service line was posted.';
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the shipment line.';
                }
                field("Service Item Line No.";"Service Item Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item line to which this service line is linked.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of this shipment.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of this shipment line.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item, general ledger account, resource code, or cost on the line.';
                }
                field("Service Item Serial No.";"Service Item Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of the service item to which this shipment line is linked.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location, such as warehouse or distribution center, from which the items should be taken and where they should be registered.';
                    Visible = false;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service order, to which the lines are linked, was created.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer who owns the items on the service order.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the customer'' s address where you have sent the shipment.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of an item, resource, cost, or a standard text on the service line.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional description of the item, resource, or cost.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of one unit of measure of the item, resource time, general ledger account, or cost on the shipment line.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of item units, resource hours, general ledger account payments, or cost that have been shipped to the customer.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the price per unit of the item, resource, cost, or general ledger account payment on this service shipment line.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the percentage of the discount provided on this shipment line.';
                }
                field("Component Line No.";"Component Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the line in the Service Item Component List window.';
                }
                field("Replaced Item No.";"Replaced Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item component replaced by the item on the service line.';
                }
                field("Spare Part Action";"Spare Part Action")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the item has been used to replace the whole service item, one of the service item components, installed as a new component, or as a supplementary tool in the service process.';
                    Visible = false;
                }
                field("Fault Reason Code";"Fault Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the fault reason for the service shipment line.';
                    Visible = false;
                }
                field("Exclude Warranty";"Exclude Warranty")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the warranty discount is excluded on this service shipment line.';
                }
                field(Warranty;Warranty)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a warranty discount is available on this service shipment line of type Item or Resource.';
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contract associated with the posted service order.';
                }
                field("Contract Disc. %";"Contract Disc. %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contract discount percentage valid for the items, resources, and costs on the service shipment line.';
                }
                field("Warranty Disc. %";"Warranty Disc. %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the percentage of the warranty discount valid for the items or resources on the service shipment line.';
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cost per unit of item, resource, or cost on this shipment line.';
                }
                field("Work Type Code";"Work Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the type of work performed under the posted service order.';
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
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("&Show Document")
                {
                    ApplicationArea = Basic;
                    Caption = '&Show Document';
                    Image = View;
                    RunObject = Page "Posted Service Shipment";
                    RunPageLink = "No."=field("Document No.");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }
}

