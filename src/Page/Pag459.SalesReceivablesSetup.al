#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 459 "Sales & Receivables Setup"
{
    ApplicationArea = Basic;
    Caption = 'Sales & Receivables Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Customer Groups,Payments';
    SourceTable = "Sales & Receivables Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Discount Posting";"Discount Posting")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of sales discounts to post separately.';
                }
                field("Credit Warnings";"Credit Warnings")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether to warn about the customer''s status when you create a sales order or invoice.';
                }
                field("Stockout Warning";"Stockout Warning")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if a warning is displayed when you enter a quantity on a sales document that brings the item''s inventory level below zero.';
                }
                field("Shipment on Invoice";"Shipment on Invoice")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies that a posted shipment and a posted invoice are automatically created when you post an invoice.';
                }
                field("Return Receipt on Credit Memo";"Return Receipt on Credit Memo")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies that a posted return receipt and a posted sales credit memo are automatically created when you post a credit memo.';
                }
                field("Invoice Rounding";"Invoice Rounding")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that amounts are rounded for sales invoices.';
                }
                field(DefaultItemQuantity;"Default Item Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Default Item Quantity';
                    ToolTip = 'Specifies that the Quantity field is set to 1 when you fill the Item No. field.';
                }
                field("Create Item from Description";"Create Item from Description")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the system will suggest to create a new item when no item matches the description.';
                }
                field("Ext. Doc. No. Mandatory";"Ext. Doc. No. Mandatory")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies whether it is mandatory to enter an external document number in the External Document No. field on a sales header or the External Document No. field on a general journal line.';
                }
                field("Appln. between Currencies";"Appln. between Currencies")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies whether it is allowed to apply customer payments in different currencies.';
                }
                field("Logo Position on Documents";"Logo Position on Documents")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the position of your company logo on business letters and documents.';
                }
                field("Freight G/L Acc. No.";"Freight G/L Acc. No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account that must be used for freight charges.';
                }
                field("Default Posting Date";"Default Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how to use the Posting Date field on sales documents.';
                }
                field("Default Quantity to Ship";"Default Quantity to Ship")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the default value that is inserted in the Qty. to Ship field on sales order lines and in the Return Qty. to Receive field on sales return order lines.';
                }
                field("Copy Comments Blanket to Order";"Copy Comments Blanket to Order")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to copy comments from blanket orders to sales orders.';
                }
                field("Copy Comments Order to Invoice";"Copy Comments Order to Invoice")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to copy comments from sales orders to sales invoices.';
                }
                field("Copy Comments Order to Shpt.";"Copy Comments Order to Shpt.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to copy comments from sales orders to shipments.';
                }
                field("Copy Cmts Ret.Ord. to Cr. Memo";"Copy Cmts Ret.Ord. to Cr. Memo")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to copy comments from sales return orders to sales credit memos.';
                }
                field("Copy Cmts Ret.Ord. to Ret.Rcpt";"Copy Cmts Ret.Ord. to Ret.Rcpt")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies that comments are copied from the sales credit memo to the posted return receipt.';
                }
                field("Allow VAT Difference";"Allow VAT Difference")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether to allow the manual adjustment of tax amounts in sales documents.';
                }
                field("Calc. Inv. Discount";"Calc. Inv. Discount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the invoice discount amount is automatically calculated with sales documents.';
                }
                field("Calc. Inv. Disc. per VAT ID";"Calc. Inv. Disc. per VAT ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the invoice discount is calculated according to Tax Identifier.';
                }
                field("VAT Bus. Posting Gr. (Price)";"VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a tax business posting group for customers for whom you want the item price including tax, to apply.';
                }
                field("Exact Cost Reversing Mandatory";"Exact Cost Reversing Mandatory")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies that a return transaction cannot be posted unless the Appl.-from Item Entry field on the sales order line Specifies an entry.';
                }
                field("Check Prepmt. when Posting";"Check Prepmt. when Posting")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies that you cannot ship or invoice an order that has an unpaid prepayment amount.';
                }
                field("Archive Quotes and Orders";"Archive Quotes and Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to automatically archive sales quotes and sales orders when a sales quote/order is deleted.';
                }
                field("Allow Document Deletion Before";"Allow Document Deletion Before")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies if and when posted sales documents can be deleted. If you enter a date, posted sales documents with a posting date on or after this date cannot be deleted.';
                }
            }
            group(Dimensions)
            {
                Caption = 'Dimensions';
                field("Customer Group Dimension Code";"Customer Group Dimension Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension code for customer groups in your analysis report.';
                }
                field("Salesperson Dimension Code";"Salesperson Dimension Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension code for salespeople in your analysis report';
                }
            }
            group("Number Series")
            {
                Caption = 'Number Series';
                field("Customer Nos.";"Customer Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to customers.';
                }
                field("Quote Nos.";"Quote Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to sales quotes.';
                }
                field("Blanket Order Nos.";"Blanket Order Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to blanket sales orders.';
                }
                field("Order Nos.";"Order Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to sales orders.';
                }
                field("Return Order Nos.";"Return Order Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series that is used to assign numbers to new sales return orders.';
                }
                field("Invoice Nos.";"Invoice Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to sales invoices.';
                }
                field("Posted Invoice Nos.";"Posted Invoice Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to sales invoices when they are posted.';
                }
                field("Credit Memo Nos.";"Credit Memo Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to sales credit memos.';
                }
                field("Posted Credit Memo Nos.";"Posted Credit Memo Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to sales credit memos when they are posted.';
                }
                field("Posted Shipment Nos.";"Posted Shipment Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to shipments.';
                }
                field("Posted Return Receipt Nos.";"Posted Return Receipt Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to posted return receipts.';
                }
                field("Reminder Nos.";"Reminder Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to reminders.';
                }
                field("Issued Reminder Nos.";"Issued Reminder Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to reminders when they are issued.';
                }
                field("Fin. Chrg. Memo Nos.";"Fin. Chrg. Memo Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to finance charge memos.';
                }
                field("Issued Fin. Chrg. M. Nos.";"Issued Fin. Chrg. M. Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to finance charge memos when they are issued.';
                }
                field("Posted Prepmt. Inv. Nos.";"Posted Prepmt. Inv. Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to sales prepayment invoices.';
                }
                field("Posted Prepmt. Cr. Memo Nos.";"Posted Prepmt. Cr. Memo Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that is used to assign numbers to sales prepayment credit memos when they are posted.';
                }
                field("Direct Debit Mandate Nos.";"Direct Debit Mandate Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series for direct-debit mandates.';
                }
            }
            group("Background Posting")
            {
                Caption = 'Background Posting';
                group(Post)
                {
                    Caption = 'Post';
                    field("Post with Job Queue";"Post with Job Queue")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies if your business process uses job queues in the background to post sales and purchase documents, including orders, invoices, return orders, and credit memos.';
                    }
                    field("Job Queue Priority for Post";"Job Queue Priority for Post")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the priority of the job queue when you run it in the context of background posting. You can set different priorities for the post and post and print settings. The default setting is 1000.';
                    }
                }
                group("Post & Print")
                {
                    Caption = 'Post & Print';
                    field("Post & Print with Job Queue";"Post & Print with Job Queue")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies if your business process uses job queues to post and print sales documents.';
                    }
                    field("Job Q. Prio. for Post & Print";"Job Q. Prio. for Post & Print")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the priority of the job queue when you run it in the context of background posting. You can set different priorities for the post and post and print settings. The default setting is 1000.';
                    }
                }
                group(Control7)
                {
                    Caption = 'General';
                    field("Job Queue Category Code";"Job Queue Category Code")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the code for the category of the job queue that you want to associate with background posting.';
                    }
                    field("Notify On Success";"Notify On Success")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies if a notification is sent when posting and printing is successfully completed.';
                    }
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
            action("Customer Posting Groups")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customer Posting Groups';
                Image = CustomerGroup;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Customer Posting Groups";
                ToolTip = 'Set up the posting groups to select from when you set up customer cards to link business transactions made for the customer with the appropriate account in the general ledger.';
            }
            action("Customer Price Groups")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customer Price Groups';
                Image = Price;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Customer Price Groups";
                ToolTip = 'Set up the posting groups to select from when you set up customer cards to link business transactions made for the customer with the appropriate account in the general ledger.';
            }
            action("Customer Disc. Groups")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customer Disc. Groups';
                Image = Discount;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Customer Disc. Groups";
                ToolTip = 'Set up discount group codes that you can use as criteria when you define special discounts on a customer, vendor, or item card.';
            }
            group(Payment)
            {
                Caption = 'Payment';
                action("Payment Registration Setup")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Payment Registration Setup';
                    Image = PaymentJournal;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Payment Registration Setup";
                    ToolTip = 'Set up the payment journal template and the balancing account that is used to post received customer payments. Define how you prefer to process customer payments in the Payment Registration window.';
                }
                action("Payment Methods")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Payment Methods';
                    Image = Payment;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Payment Methods";
                    ToolTip = 'Set up the payment methods that you select from the customer card to define how the customer must pay, for example by bank transfer.';
                }
                action("Payment Terms")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Payment Terms';
                    Image = Payment;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Payment Terms";
                    ToolTip = 'Set up the payment terms that you select from on customer cards to define when the customer must pay, such as within 14 days.';
                }
                action("Finance Charge Terms")
                {
                    ApplicationArea = Basic;
                    Caption = 'Finance Charge Terms';
                    Image = FinChargeMemo;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Finance Charge Terms";
                    ToolTip = 'Set up the finance charge terms that you select from on customer cards to define how to calculate interest in case the customer''s payment is late.';
                }
                action("Reminder Terms")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reminder Terms';
                    Image = ReminderTerms;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Reminder Terms";
                    ToolTip = 'Set up reminder terms that you select from on customer cards to define when and how to remind the customer of late payments.';
                }
                action("Rounding Methods")
                {
                    ApplicationArea = Basic;
                    Caption = 'Rounding Methods';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Rounding Methods";
                    ToolTip = 'Define how amounts are rounded when you use functions to adjust or suggest item prices or standard costs.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
    end;
}

