#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 137 "Posted Purchase Rcpt. Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Purch. Rcpt. Line";

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
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.';
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the item or service on the line.';
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the unit of measure code for the item.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies how many units of the item on the line have already been invoiced.';
                }
                field("Qty. Rcd. Not Invoiced";"Qty. Rcd. Not Invoiced")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the item on the line have been received and not yet invoiced.';
                    Visible = false;
                }
                field("Requested Receipt Date";"Requested Receipt Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date that you want the vendor to deliver to the ship-to address. The value in the field is used to calculate the latest date you can order the items to have them delivered on the requested receipt date. If you do not need delivery on a specific date, you can leave the field blank.';
                    Visible = false;
                }
                field("Promised Receipt Date";"Promised Receipt Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Planned Receipt Date";"Planned Receipt Date")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Receipt Date";"Expected Receipt Date")
                {
                    ApplicationArea = Basic;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date when the item is ordered. It is calculated backwards from the Planned Receipt Date field in combination with the Lead Time Calculation field.';
                }
                field("Lead Time Calculation";"Lead Time Calculation")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Inbound Whse. Handling Time";"Inbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the item ledger entry this receipt line was applied to.';
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
                    ApplicationArea = Basic;
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
                action(OrderTracking)
                {
                    ApplicationArea = Basic;
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;

                    trigger OnAction()
                    begin
                        ShowTracking;
                    end;
                }
                action("&Undo Receipt")
                {
                    ApplicationArea = Suite;
                    Caption = '&Undo Receipt';
                    ToolTip = 'Cancel the quantity posting on the selected posted receipt line. A corrective line is inserted under the selected receipt line. If the quantity was received in a warehouse receipt, then a corrective line is inserted in the posted warehouse receipt. The Quantity Received and Qty. Rcd. Not Invoiced fields on the related purchase order are set to zero.';

                    trigger OnAction()
                    begin
                        UndoReceiptLine;
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
                action(ItemInvoiceLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Invoice &Lines';
                    Image = ItemInvoice;

                    trigger OnAction()
                    begin
                        PageShowItemPurchInvLines;
                    end;
                }
            }
        }
    }

    local procedure ShowTracking()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        TrackingForm: Page "Order Tracking";
    begin
        TestField(Type,Type::Item);
        if "Item Rcpt. Entry No." <> 0 then begin
          ItemLedgEntry.Get("Item Rcpt. Entry No.");
          TrackingForm.SetItemLedgEntry(ItemLedgEntry);
        end else
          TrackingForm.SetMultipleItemLedgEntries(TempItemLedgEntry,
            Database::"Purch. Rcpt. Line",0,"Document No.",'',0,"Line No.");

        TrackingForm.RunModal;
    end;

    local procedure UndoReceiptLine()
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(PurchRcptLine);
        Codeunit.Run(Codeunit::"Undo Purchase Receipt Line",PurchRcptLine);
    end;

    local procedure PageShowItemPurchInvLines()
    begin
        TestField(Type,Type::Item);
        ShowItemPurchInvLines;
    end;
}

