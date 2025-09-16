#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7338 "Posted Whse. Shipment Subform"
{
    Caption = 'Lines';
    DelayedInsert = true;
    Editable = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Posted Whse. Shipment Line";

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
                    Visible = false;
                }
                field("Source Line No.";"Source Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source line number of the document from which the entry originates.';
                    Visible = false;
                }
                field("Destination Type";"Destination Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of destination associated with the posted warehouse shipment line.';
                    Visible = false;
                }
                field("Destination No.";"Destination No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer, vendor, or location to which the items have been shipped.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that has been shipped.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant number of the item on the line, if any.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the item on the line.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the a second description of the item on the line, if any.';
                    Visible = false;
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone where the bin on this posted shipment line is located.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin on the posted warehouse shipment line.';
                    Visible = false;
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number of the item for informational use.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that was shipped.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the line.';
                }
                field("Shipping Advice";"Shipping Advice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipping advice for the posted warehouse shipment line.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Posted Source Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Source Document';
                    Image = PostedOrder;

                    trigger OnAction()
                    begin
                        ShowPostedSourceDoc;
                    end;
                }
                action("Whse. Document Line")
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Document Line';
                    Image = Line;

                    trigger OnAction()
                    begin
                        ShowWhseLine;
                    end;
                }
                action("Bin Contents List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bin Contents List';
                    Image = BinContent;

                    trigger OnAction()
                    begin
                        ShowBinContents;
                    end;
                }
            }
        }
    }

    var
        WMSMgt: Codeunit "WMS Management";

    local procedure ShowPostedSourceDoc()
    begin
        WMSMgt.ShowPostedSourceDoc("Posted Source Document","Posted Source No.");
    end;

    local procedure ShowBinContents()
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.ShowBinContents("Location Code","Item No.","Variant Code","Bin Code");
    end;

    local procedure ShowWhseLine()
    begin
        WMSMgt.ShowWhseDocLine(2,"Whse. Shipment No.","Whse Shipment Line No.");
    end;
}

