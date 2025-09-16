#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 915 "Asm.-to-Order Whse. Shpt. Line"
{
    Caption = 'Asm.-to-Order Whse. Shpt. Line';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Warehouse Shipment Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Lines';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number of the shipment to which the line belongs.';
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the warehouse shipment line.';
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the table that is the source of the receipt line.';
                    Visible = false;
                }
                field("Source Subtype";"Source Subtype")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source subtype of the document to which the line relates.';
                    Visible = false;
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source number of the document from which the line originates.';
                    Visible = false;
                }
                field("Source Line No.";"Source Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source line number of the document from which the entry originates.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code of the item in the line, if any.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location from which the items on the line are being shipped.';
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone where the bin on this shipment line is located.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin in which the items will be placed before shipment.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that should be shipped.';
                }
                field("Qty. Outstanding";"Qty. Outstanding")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that still needs to be handled.';
                    Visible = false;
                }
                field("Qty. to Ship";"Qty. to Ship")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that will be shipped when the warehouse shipment is posted.';
                }
                field("Qty. to Ship (Base)";"Qty. to Ship (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity, in base units of measure, that will be shipped when the warehouse shipment is posted.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item on the line.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the related warehouse activity, such as a pick, must be completed to ensure items can be shipped by the shipment date.';
                    Visible = false;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipment date of the warehouse shipment and the source document.';
                }
                field("Destination Type";"Destination Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of destination associated with the warehouse shipment line.';
                    Visible = false;
                }
                field("Destination No.";"Destination No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer, vendor, or location to which the items should be shipped.';
                    Visible = false;
                }
                field("Assemble to Order";"Assemble to Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the warehouse shipment line is for items that are assembled to a sales order before it is shipped.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

