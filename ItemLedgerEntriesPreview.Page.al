#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 167 "Item Ledger Entries Preview"
{
    Caption = 'Item Ledger Entries Preview';
    DataCaptionFields = "Item No.";
    Editable = false;
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableTemporary = true;

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
                    ToolTip = 'Specifies which type of transaction the entry is created from.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies what type of document was posted to create the item ledger entry.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document number on the entry. The document is the voucher that the entry was based on, for example, a receipt.';
                }
                field("Document Line No.";"Document Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the line on the posted document that corresponds to the item ledger entry.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the item in the entry.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Shows the variant code for the items.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains a code that explains why the item is returned.';
                    Visible = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Shows the dimension value code that the entry is linked to.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Shows the dimension value code that the entry is linked to.';
                    Visible = false;
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the last date that the item on the line can be used.';
                    Visible = false;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains a serial number if the posted item carries such a number.';
                    Visible = false;
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains a lot number if the posted item carries such a number.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Shows the code for the location that the entry is linked to.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of units of the item in the item entry.';
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
                    ToolTip = 'Specifies the quantity that remains in inventory in the Quantity field if the entry is an increase (a purchase or positive adjustment). If the entry is a decrease (a sale or negative adjustment), the field shows the quantity that remains to be applied to by an increase entry.';
                    Visible = true;
                }
                field("Shipped Qty. Not Returned";"Shipped Qty. Not Returned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the quantity for this item ledger entry that was shipped and has not yet been returned.';
                    Visible = false;
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Shows how many units of the item on the line have been reserved.';
                    Visible = false;
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Shows the quantity per item unit of measure.';
                    Visible = false;
                }
                field(SalesAmountExpected;SalesAmountExpected)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Amount (Expected)';
                    Visible = false;
                }
                field(SalesAmountActual;SalesAmountActual)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Amount (Actual)';
                    ToolTip = 'Specifies the sum of the actual sales amounts if you post.';
                }
                field(CostAmountExpected;CostAmountExpected)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Amount (Expected)';
                    Visible = false;
                }
                field(CostAmountActual;CostAmountActual)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cost Amount (Actual)';
                    ToolTip = 'Specifies the sum of the actual cost amounts if you post.';
                }
                field(CostAmountNonInvtbl;CostAmountNonInvtbl)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cost Amount (Non-Invtbl.)';
                    ToolTip = 'Specifies the sum of the actual non-inventoriable cost amounts if you post. Typical non-inventoriable costs come from item charges.';
                }
                field(CostAmountExpectedACY;CostAmountExpectedACY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Amount (Expected) (ACY)';
                    Visible = false;
                }
                field(CostAmountActualACY;CostAmountActualACY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Amount (Actual) (ACY)';
                    Visible = false;
                }
                field(CostAmountNonInvtblACY;CostAmountNonInvtblACY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Amount (Non-Invtbl.) (ACY)';
                    Visible = false;
                }
                field("Completely Invoiced";"Completely Invoiced")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Shows if the entry has been fully invoiced or if more posted invoices are expected. Only completely invoiced entries can be revalued.';
                    Visible = false;
                }
                field(Open;Open)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the entry has been fully applied to.';
                }
                field("Drop Shipment";"Drop Shipment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Shows whether the items on the line have been shipped directly to the customer.';
                    Visible = false;
                }
                field("Assemble to Order";"Assemble to Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the posting represents an assemble-to-order sale.';
                    Visible = false;
                }
                field("Applied Entry to Adjust";"Applied Entry to Adjust")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether there is one or more applied entries, which need to be adjusted.';
                    Visible = false;
                }
                field("Order Type";"Order Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which type of transaction the entry is created from.';
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the number of the order that created the entry.';
                    Visible = false;
                }
                field("Order Line No.";"Order Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the line number of the order that created the entry.';
                    Visible = false;
                }
                field("Prod. Order Comp. Line No.";"Prod. Order Comp. Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Shows the line number of the production order component.';
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the number of the job associated with the entry.';
                    Visible = false;
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the number of the job task associated with the entry.';
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
                    ToolTip = 'View all reservations for the item. For example, items can be reserved for production orders or production orders.';

                    trigger OnAction()
                    begin
                        ShowReservationEntries(true);
                    end;
                }
                action("Application Worksheet")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Application Worksheet';
                    Image = ApplicationWorksheet;
                    ToolTip = 'View item applications that are automatically created between item ledger entries during item transactions.';

                    trigger OnAction()
                    var
                        ApplicationWorksheet: Page "Application Worksheet";
                    begin
                        Clear(ApplicationWorksheet);
                        ApplicationWorksheet.SetRecordToShow(Rec);
                        ApplicationWorksheet.Run;
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
                        OrderTrackingForm: Page "Order Tracking";
                    begin
                        OrderTrackingForm.SetItemLedgEntry(Rec);
                        OrderTrackingForm.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcAmounts;
    end;

    var
        TempValueEntry: Record "Value Entry" temporary;
        SalesAmountExpected: Decimal;
        SalesAmountActual: Decimal;
        CostAmountExpected: Decimal;
        CostAmountActual: Decimal;
        CostAmountNonInvtbl: Decimal;
        CostAmountExpectedACY: Decimal;
        CostAmountActualACY: Decimal;
        CostAmountNonInvtblACY: Decimal;


    procedure Set(var TempItemLedgerEntry2: Record "Item Ledger Entry" temporary;var TempValueEntry2: Record "Value Entry" temporary)
    begin
        if TempItemLedgerEntry2.FindSet then
          repeat
            Rec := TempItemLedgerEntry2;
            Insert;
          until TempItemLedgerEntry2.Next = 0;

        if TempValueEntry2.FindSet then
          repeat
            TempValueEntry := TempValueEntry2;
            TempValueEntry.Insert;
          until TempValueEntry2.Next = 0;
    end;

    local procedure CalcAmounts()
    begin
        SalesAmountExpected := 0;
        SalesAmountActual := 0;
        CostAmountExpected := 0;
        CostAmountActual := 0;
        CostAmountNonInvtbl := 0;
        CostAmountExpectedACY := 0;
        CostAmountActualACY := 0;
        CostAmountNonInvtblACY := 0;

        TempValueEntry.SetFilter("Item Ledger Entry No.",'%1',"Entry No.");
        if TempValueEntry.FindSet then
          repeat
            SalesAmountExpected += TempValueEntry."Sales Amount (Expected)";
            SalesAmountActual += TempValueEntry."Sales Amount (Actual)";
            CostAmountExpected += TempValueEntry."Cost Amount (Expected)";
            CostAmountActual += TempValueEntry."Cost Amount (Actual)";
            CostAmountNonInvtbl += TempValueEntry."Cost Amount (Non-Invtbl.)";
            CostAmountExpectedACY += TempValueEntry."Cost Amount (Expected) (ACY)";
            CostAmountActualACY += TempValueEntry."Cost Amount (Actual) (ACY)";
            CostAmountNonInvtblACY += TempValueEntry."Cost Amount (Non-Invtbl.)(ACY)";
          until TempValueEntry.Next = 0;
    end;
}

