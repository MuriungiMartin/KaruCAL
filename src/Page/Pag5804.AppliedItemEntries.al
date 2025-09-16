#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5804 "Applied Item Entries"
{
    Caption = 'Applied Item Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Item Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the entry''s posting date.';
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which type of transaction that the entry is created from.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document number on the entry. The document is the voucher that the entry was based on, for example, a receipt.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the item in the entry.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the items.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code that the entry is linked to.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code that the entry is linked to.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location that the entry is linked to.';
                }
                field(ApplQty;ApplQty)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Applied Quantity';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies how many units of the item that have been applied.';
                }
                field(Qty;Qty)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Quantity';
                    ToolTip = 'Specifies the total quantity of items that have been applied.';
                }
                field("Invoiced Quantity";"Invoiced Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how many units of the item on the line have been invoiced.';
                    Visible = true;
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the quantity that remains in inventory in the Quantity field if the entry is an increase (a purchase or positive adjustment).';
                    Visible = true;
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item on the line have been reserved.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        ShowReservationEntries(true);
                    end;
                }
                field(Open;Open)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the entry has been fully applied to.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity per item unit of measure.';
                    Visible = false;
                }
                field("Drop Shipment";"Drop Shipment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the items on the line have been shipped directly to the customer.';
                    Visible = false;
                }
                field("Applied Entry to Adjust";"Applied Entry to Adjust")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether there is one or more applied entries, which need to be adjusted.';
                }
                field("Order Type";"Order Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which type of order that the entry was created in.';
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the order that created the entry.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the entry number for the entry.';
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
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("&Value Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Value Entries';
                    Image = ValueLedger;
                    RunObject = Page "Value Entries";
                    RunPageLink = "Item Ledger Entry No."=field("Entry No.");
                    RunPageView = sorting("Item Ledger Entry No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View amounts that relate to an item. Whenever you do something that changes a value for items in the inventory, like post an order, one or more value entries are added.';
                }
            }
            group("&Application")
            {
                Caption = '&Application';
                Image = Apply;
                action("Applied E&ntries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    ToolTip = 'View the ledger entries that have been applied to this record.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Show Applied Entries",Rec);
                    end;
                }
                action("Reservation Entries")
                {
                    AccessByPermission = TableData Item=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;
                    ToolTip = 'View information about reservation and item tracking.';

                    trigger OnAction()
                    begin
                        ShowReservationEntries(true);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Order &Tracking")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;
                    ToolTip = 'Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.';

                    trigger OnAction()
                    var
                        TrackingForm: Page "Order Tracking";
                    begin
                        TrackingForm.SetItemLedgEntry(Rec);
                        TrackingForm.RunModal;
                    end;
                }
            }
            action("&Navigate")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetApplQty;
    end;

    var
        Navigate: Page Navigate;
        ApplQty: Decimal;
        Qty: Decimal;

    local procedure GetApplQty()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.Get("Entry No.");
        ApplQty := Quantity;
        Qty := ItemLedgEntry.Quantity;
    end;
}

