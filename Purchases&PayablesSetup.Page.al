#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 460 "Purchases & Payables Setup"
{
    ApplicationArea = Basic;
    Caption = 'Purchases & Payables Setup';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Purchases & Payables Setup";
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
                    ToolTip = 'Specifies the type of purchase discounts to post separately.';
                }
                field("Receipt on Invoice";"Receipt on Invoice")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies that a posted receipt and a posted invoice are automatically created when you post an invoice.';
                }
                field("Return Shipment on Credit Memo";"Return Shipment on Credit Memo")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Automatically creates a posted return shipment and a posted purchase credit memo when you post a credit memo.';
                }
                field("Invoice Rounding";"Invoice Rounding")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that amounts are rounded for purchase invoices.';
                }
                field("Ext. Doc. No. Mandatory";"Ext. Doc. No. Mandatory")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether it is mandatory to enter an external document number.';
                }
                field("Allow VAT Difference";"Allow VAT Difference")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether to allow the manual adjustment of tax amounts in purchase documents.';
                }
                field("Calc. Inv. Discount";"Calc. Inv. Discount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the invoice discount amount is automatically calculated with purchase documents.';
                }
                field("Calc. Inv. Disc. per VAT ID";"Calc. Inv. Disc. per VAT ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the invoice discount is calculated according to Tax Identifier.';
                }
                field("Appln. between Currencies";"Appln. between Currencies")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies to what extent the application of entries in different currencies is allowed in the Purchases and Payables application area.';
                }
                field("Default Posting Date";"Default Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how to use the Posting Date field on purchase documents.';
                }
                field("Default Qty. to Receive";"Default Qty. to Receive")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the default value inserted in the Qty. to Receive field in purchase order lines and in the Return Qty. to Ship field in purchase return order lines.';
                }
                field("Copy Comments Blanket to Order";"Copy Comments Blanket to Order")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to copy comments from blanket orders to purchase orders.';
                }
                field("Copy Comments Order to Invoice";"Copy Comments Order to Invoice")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to copy comments from purchase orders to purchase invoices.';
                }
                field("Copy Comments Order to Receipt";"Copy Comments Order to Receipt")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to copy comments from purchase orders to receipts.';
                }
                field("Copy Cmts Ret.Ord. to Cr. Memo";"Copy Cmts Ret.Ord. to Cr. Memo")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to copy comments from purchase return orders to sales credit memos.';
                }
                field("Copy Cmts Ret.Ord. to Ret.Shpt";"Copy Cmts Ret.Ord. to Ret.Shpt")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies that comments are copied from the return order to the posted return shipment.';
                }
                field("Exact Cost Reversing Mandatory";"Exact Cost Reversing Mandatory")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that a return transaction cannot be posted unless the Appl.-to Item Entry field on the purchase order line Specifies an entry.';
                }
                field("Check Prepmt. when Posting";"Check Prepmt. when Posting")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies that a warning message is shown when you receive or invoice an order that has an unpaid prepayment amount.';
                }
                field("Archive Quotes and Orders";"Archive Quotes and Orders")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to automatically archive purchase quotes and purchase orders before they are deleted during the make order or posting processes.';
                }
                field("Combine Special Orders Default";"Combine Special Orders Default")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if special orders for purchases and payables should be combined.';
                }
                field("Use Vendor's Tax Area Code";"Use Vendor's Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies where the tax area code for purchase sales tax calculations will come from. The tax area code combines with the tax group to determine how sales taxes are calculated and posted.';
                }
                field("Allow Document Deletion Before";"Allow Document Deletion Before")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies if and when posted purchase documents can be deleted. If you enter a date, posted purchase documents with a posting date on or after this date cannot be deleted.';
                }
                field("Requisition Default Vendor";"Requisition Default Vendor")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Number Series")
            {
                Caption = 'Number Series';
                field("Vendor Nos.";"Vendor Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to vendors.';
                }
                field("Quote Nos.";"Quote Nos.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to purchase quotes.';
                }
                field("Blanket Order Nos.";"Blanket Order Nos.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to blanket purchase orders.';
                }
                field("Order Nos.";"Order Nos.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to purchase orders.';
                }
                field("Return Order Nos.";"Return Order Nos.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the number series that is used to assign numbers to new purchase return orders.';
                }
                field("Invoice Nos.";"Invoice Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to purchase invoices.';
                }
                field("Posted Invoice Nos.";"Posted Invoice Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to purchase invoices when they are posted.';
                }
                field("Credit Memo Nos.";"Credit Memo Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to purchase credit memos.';
                }
                field("Posted Credit Memo Nos.";"Posted Credit Memo Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to purchase credit memos when they are posted.';
                }
                field("Posted Receipt Nos.";"Posted Receipt Nos.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to posted receipts.';
                }
                field("Posted Return Shpt. Nos.";"Posted Return Shpt. Nos.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the number series to be used when you post return shipments.';
                }
                field("Posted Prepmt. Inv. Nos.";"Posted Prepmt. Inv. Nos.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the number series that is used to assign numbers to purchase prepayment invoices when they are posted.';
                }
                field("Medical Vendors";"Medical Vendors")
                {
                    ApplicationArea = Basic;
                }
                field("Posted Prepmt. Cr. Memo Nos.";"Posted Prepmt. Cr. Memo Nos.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to purchase prepayment credit memos.';
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
                        ApplicationArea = Suite;
                        ToolTip = 'Specifies if your business process uses job queues in the background to post documents, including orders, invoices, return orders, and credit memos.';
                    }
                    field("Job Queue Priority for Post";"Job Queue Priority for Post")
                    {
                        ApplicationArea = Suite;
                        ToolTip = 'Specifies the priority of the job queue when you run it in the context of background posting. You can set different priorities for the post and post and print settings. The default setting is 1000.';
                    }
                }
                group("Post & Print")
                {
                    Caption = 'Post & Print';
                    field("Post & Print with Job Queue";"Post & Print with Job Queue")
                    {
                        ApplicationArea = Suite;
                        ToolTip = 'Specifies whether your business process uses job queues to post and print purchase documents. Select this check box to enable background posting and printing.';
                    }
                    field("Job Q. Prio. for Post & Print";"Job Q. Prio. for Post & Print")
                    {
                        ApplicationArea = Suite;
                        ToolTip = 'Specifies the priority of the job queue when you run it in the context of background posting. You can set different priorities for the post and post and print settings. The default setting is 1000.';
                    }
                }
                group(Control9)
                {
                    Caption = 'General';
                    field("Job Queue Category Code";"Job Queue Category Code")
                    {
                        ApplicationArea = Suite;
                        ToolTip = 'Specifies the code for the category of the job queue that you want to associate with background posting.';
                    }
                    field("Notify On Success";"Notify On Success")
                    {
                        ApplicationArea = Suite;
                        ToolTip = 'Specifies if a notification is sent when posting and printing is successfully completed.';
                    }
                }
            }
            group("Default Accounts")
            {
                Caption = 'Default Accounts';
                field("Debit Acc. for Non-Item Lines";"Debit Acc. for Non-Item Lines")
                {
                    ApplicationArea = Suite;
                    Caption = 'Default Debit Account for Non-Item Lines';
                    ToolTip = 'Specifies the debit account that is inserted on purchase credit memo lines by default.';
                }
                field("Credit Acc. for Non-Item Lines";"Credit Acc. for Non-Item Lines")
                {
                    ApplicationArea = Suite;
                    Caption = 'Default Credit Account for Non-Item Lines';
                    ToolTip = 'Specifies the debit account that is inserted on purchase credit memo lines by default.';
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
            action("Vendor Posting Groups")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Vendor Posting Groups';
                Image = Vendor;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Vendor Posting Groups";
                ToolTip = 'Set up the posting groups to select from when you set up vendor cards to link business transactions made for the vendor with the appropriate account in the general ledger.';
            }
            action("Incoming Documents Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Incoming Documents Setup';
                Image = Documents;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Incoming Documents Setup";
                ToolTip = 'Set up the journal template that will be used to create general journal lines from electronic external documents, such as invoices from your vendors on email.';
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

