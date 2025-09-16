#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7341 "Whse. Shipment Lines"
{
    Caption = 'Whse. Shipment Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Shipment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Source Document";"Source Document")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document to which the line relates.';
                    Visible = false;
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source number of the document from which the line originates.';
                }
                field("Source Line No.";"Source Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source line number of the document from which the entry originates.';
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
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location from which the items on the line are being shipped.';
                    Visible = false;
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
                    Visible = false;
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number of the item for informational use.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that should be shipped.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code of the item in the line, if any.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the item in the line.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a second description of the item in the line, if any.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that should be shipped.';
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that should be shipped, in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. Outstanding";"Qty. Outstanding")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that still needs to be handled.';
                }
                field("Qty. Outstanding (Base)";"Qty. Outstanding (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that still needs to be handled, expressed in the base unit of measure.';
                    Visible = false;
                }
                field("Pick Qty.";"Pick Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity in pick instructions assigned to be picked for the warehouse shipment line.';
                    Visible = false;
                }
                field("Pick Qty. (Base)";"Pick Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity, in the base unit of measure, in pick instructions, that is assigned to be picked for the warehouse shipment line.';
                    Visible = false;
                }
                field("Qty. Picked";"Qty. Picked")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many of the total shipment quantity have been registered as picked.';
                }
                field("Qty. Picked (Base)";"Qty. Picked (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many of the total shipment quantity in the base unit of measure have been registered as picked.';
                    Visible = false;
                }
                field("Qty. Shipped";"Qty. Shipped")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the item on the line that is posted as shipped.';
                    Visible = false;
                }
                field("Qty. Shipped (Base)";"Qty. Shipped (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that is posted as shipped expressed in the base unit of measure.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item on the line.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of base units of measure that are in the unit of measure specified for the item on the line.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the shipment line.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the related warehouse activity, such as a pick, must be completed to ensure items can be shipped by the shipment date.';
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipment date of the warehouse shipment and the source document.';
                }
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
                action("Show &Whse. Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show &Whse. Document';
                    Image = ViewOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        WhseShptHeader: Record "Warehouse Shipment Header";
                    begin
                        WhseShptHeader.Get("No.");
                        Page.Run(Page::"Warehouse Shipment",WhseShptHeader);
                    end;
                }
                action(ShowSourceDocumentLine)
                {
                    ApplicationArea = Basic;
                    Caption = '&Show Source Document Line';
                    Image = ViewDocumentLine;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        WMSMgt: Codeunit "WMS Management";
                    begin
                        WMSMgt.ShowSourceDocLine(
                          "Source Type","Source Subtype","Source No.","Source Line No.",0)
                    end;
                }
            }
        }
    }
}

