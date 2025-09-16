#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 131 "Posted Sales Shpt. Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Shipment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies a description of the record.';
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Package Tracking No.";"Package Tracking No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Package Tracking No. field on the sales line.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = false;
                    ToolTip = 'Specifies the number of units of the item specified on the line.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the unit of measure code for the item.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the item on the line have already been invoiced.';
                }
                field("Qty. Shipped Not Invoiced";"Qty. Shipped Not Invoiced")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the item on the line have been shipped and not yet invoiced.';
                    Visible = false;
                }
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date that the customer has asked for the order to be delivered.';
                    Visible = false;
                }
                field("Promised Delivery Date";"Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Planned Delivery Date";"Planned Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field("Planned Shipment Date";"Planned Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date when the sales shipment was posted.';
                    Visible = true;
                }
                field("Shipping Time";"Shipping Time")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';
                    Visible = false;
                }
                field(Correction;Correction)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies that this sales shipment line has been posted as a corrective entry.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Track Package")
                {
                    ApplicationArea = Basic;
                    Caption = '&Track Package';
                    Image = ItemTracking;

                    trigger OnAction()
                    begin
                        StartTrackingSite;
                    end;
                }
                action("Order Tra&cking")
                {
                    ApplicationArea = Basic;
                    Caption = 'Order Tra&cking';
                    Image = OrderTracking;

                    trigger OnAction()
                    begin
                        ShowTracking;
                    end;
                }
                action(UndoShipment)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Undo Shipment';
                    Image = UndoShipment;
                    ToolTip = 'Withdraw the line from the shipment. This is useful for making corrections, because the line is not deleted. You can make changes and post it again.';

                    trigger OnAction()
                    begin
                        UndoShipmentPosting;
                    end;
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        ShowLineComments;
                    end;
                }
                action(ItemTrackingEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    begin
                        ShowItemTrackingLines;
                    end;
                }
                action("Assemble-to-Order")
                {
                    AccessByPermission = TableData "BOM Component"=R;
                    ApplicationArea = Basic;
                    Caption = 'Assemble-to-Order';

                    trigger OnAction()
                    begin
                        ShowAsmToOrder;
                    end;
                }
                action(ItemInvoiceLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Invoice &Lines';
                    Image = ItemInvoice;

                    trigger OnAction()
                    begin
                        PageShowItemSalesInvLines;
                    end;
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        Codeunit.Run(Codeunit::"Shipment Line - Edit",Rec);
        exit(false);
    end;

    local procedure ShowTracking()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        TrackingForm: Page "Order Tracking";
    begin
        TestField(Type,Type::Item);
        if "Item Shpt. Entry No." <> 0 then begin
          ItemLedgEntry.Get("Item Shpt. Entry No.");
          TrackingForm.SetItemLedgEntry(ItemLedgEntry);
        end else
          TrackingForm.SetMultipleItemLedgEntries(TempItemLedgEntry,
            Database::"Sales Shipment Line",0,"Document No.",'',0,"Line No.");

        TrackingForm.RunModal;
    end;

    local procedure UndoShipmentPosting()
    var
        SalesShptLine: Record "Sales Shipment Line";
    begin
        SalesShptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(SalesShptLine);
        Codeunit.Run(Codeunit::"Undo Sales Shipment Line",SalesShptLine);
    end;

    local procedure PageShowItemSalesInvLines()
    begin
        TestField(Type,Type::Item);
        ShowItemSalesInvLines;
    end;
}

