#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7342 "Whse. Receipt Lines"
{
    Caption = 'Whse. Receipt Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Receipt Line";

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
                    ToolTip = 'Specifies the number of the source document from which the entry originates.';
                }
                field("Source Line No.";"Source Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source line number of the document from which the entry originates.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location where the items should be received.';
                    Visible = false;
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the zone in which the items are being received.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin into which the items will be put upon receipt.';
                    Visible = false;
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number of the item for information use.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that is expected to be received.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant number of the item in the line.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the item in the line.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a second description of the item on the line.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that should be received.';
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity to be received, in the base unit of measure.';
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
                    ToolTip = 'Specifies the quantity that still needs to be handled, in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. Received";"Qty. Received")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity for this line that has been posted as received.';
                }
                field("Qty. Received (Base)";"Qty. Received (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity received, in the base unit of measure.';
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
                    ToolTip = 'Specifies the number of base units of measure, that are in the unit of measure specified for the item on the line.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the warehouse receipt.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number.';
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line number.';
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
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        WhseRcptHeader: Record "Warehouse Receipt Header";
                    begin
                        WhseRcptHeader.Get("No.");
                        Page.Run(Page::"Warehouse Receipt",WhseRcptHeader);
                    end;
                }
                action("&Show Source Document Line")
                {
                    ApplicationArea = Basic;
                    Caption = '&Show Source Document Line';
                    Image = ViewDocumentLine;

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

