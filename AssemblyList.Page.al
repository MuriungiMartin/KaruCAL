#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 904 "Assembly List"
{
    Caption = 'Assembly List';
    DataCaptionFields = "Document Type","No.";
    Editable = false;
    LinksAllowed = true;
    PageType = List;
    SourceTable = "Assembly Header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of assembly document the record represents in assemble-to-order scenarios.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number assigned to the assembly order from the number series that you set up in the Assembly Setup window.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the assembly item.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the assembled item is due to be available for use.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the assembly order is expected to start.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the assembly order is expected to finish.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that is being assembled with the assembly order.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly item that you expect to assemble with the assembly order.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit cost of the assembly item.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location to which you want to post output of the assembly item.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the item variant of the item that is being assembled.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin the assembly item is posted to as output and from where it is taken to storage or shipped if it is assembled to a sales order.';
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly item remain to be posted as assembled output.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control103;Links)
            {
                Visible = false;
            }
            systempart(Control104;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Show Document")
            {
                ApplicationArea = Basic;
                Caption = '&Show Document';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+F7';

                trigger OnAction()
                begin
                    case "Document Type" of
                      "document type"::Quote:
                        Page.Run(Page::"Assembly Quote",Rec);
                      "document type"::Order:
                        Page.Run(Page::"Assembly Order",Rec);
                      "document type"::"Blanket Order":
                        Page.Run(Page::"Blanket Assembly Order",Rec);
                    end;
                end;
            }
            action("Reservation Entries")
            {
                AccessByPermission = TableData Item=R;
                ApplicationArea = Basic;
                Caption = '&Reservation Entries';
                Image = ReservationLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ShowReservationEntries(true);
                end;
            }
            action("Item Tracking Lines")
            {
                ApplicationArea = Basic;
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+Ctrl+I';

                trigger OnAction()
                begin
                    OpenItemTrackingLines;
                end;
            }
        }
    }
}

