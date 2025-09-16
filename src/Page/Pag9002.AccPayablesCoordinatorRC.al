#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9002 "Acc. Payables Coordinator RC"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1900601808;"Acc. Payables Activities")
                {
                }
                part(Control1905989608;"My Items")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control1902476008;"My Vendors")
                {
                }
                part(Control10;"Report Inbox Part")
                {
                }
                part(Control12;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control1903012608;"Copy Profile")
                {
                    Visible = false;
                }
                systempart(Control1901377608;MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("&Vendor - List")
            {
                ApplicationArea = Basic;
                Caption = '&Vendor - List';
                Image = "Report";
                RunObject = Report "Vendor - List";
            }
            action("Vendor - Listing")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor - Listing';
                Image = "Report";
                RunObject = Report "Vendor - Listing";
            }
            action("Vendor - &Balance to date")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor - &Balance to date';
                Image = "Report";
                RunObject = Report "Vendor - Balance to Date";
            }
            action("Aged Accounts Payable")
            {
                ApplicationArea = Basic;
                Caption = 'Aged Accounts Payable';
                Image = "Report";
                RunObject = Report "Aged Accounts Payable";
            }
            action("Vendor Account Detail")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor Account Detail';
                Image = "Report";
                RunObject = Report "Vendor Account Detail";
            }
            action("Open Vendor Entries")
            {
                ApplicationArea = Basic;
                Caption = 'Open Vendor Entries';
                Image = "Report";
                RunObject = Report "Open Vendor Entries";
            }
            action("Vendor - &Purchase List")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor - &Purchase List';
                Image = "Report";
                RunObject = Report "Vendor - Purchase List";
            }
            action("Pa&yments on Hold")
            {
                ApplicationArea = Basic;
                Caption = 'Pa&yments on Hold';
                Image = "Report";
                RunObject = Report "Payments on Hold";
            }
            action("Vendor Purchase Statistics")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor Purchase Statistics';
                Image = "Report";
                RunObject = Report "Vendor Purchase Statistics";
            }
            action("Cash Requirem. by Due Date")
            {
                ApplicationArea = Basic;
                Caption = 'Cash Requirem. by Due Date';
                Image = "Report";
                RunObject = Report "Cash Requirements by Due Date";
            }
            separator(Action63)
            {
            }
            action("Vendor &Document Nos.")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor &Document Nos.';
                Image = "Report";
                RunObject = Report "Vendor Document Nos.";
            }
            action("Purchase &Invoice Nos.")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase &Invoice Nos.';
                Image = "Report";
                RunObject = Report "Purchase Invoice Nos.";
            }
            action("Purchase &Credit Memo Nos.")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase &Credit Memo Nos.';
                Image = "Report";
                RunObject = Report "Purchase Credit Memo Nos.";
            }
            separator(Action29)
            {
            }
            action("Vendor 1099 Div")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor 1099 Div';
                Image = "Report";
                RunObject = Report "Vendor 1099 Div";
            }
            action("Vendor 1099 Information")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor 1099 Information';
                Image = "Report";
                RunObject = Report "Vendor 1099 Information";
            }
            action("Vendor 1099 Int")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor 1099 Int';
                Image = "Report";
                RunObject = Report "Vendor 1099 Int";
            }
            action("Vendor 1099 Misc")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor 1099 Misc';
                Image = "Report";
                RunObject = Report "Vendor 1099 Misc";
            }
        }
        area(embedding)
        {
            ToolTip = 'View and process vendor payments, and approve incoming documents.';
            action(Vendors)
            {
                ApplicationArea = Basic;
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = Page "Vendor List";
            }
            action(VendorsBalance)
            {
                ApplicationArea = Basic;
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Vendor List";
                RunPageView = where("Balance (LCY)"=filter(<>0));
            }
            action("Purchase Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action("Purchase Invoices")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Invoices';
                RunObject = Page "Purchase Invoices";
            }
            action("Purchase Return Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Return Orders';
                RunObject = Page "Purchase Return Order List";
            }
            action("Purchase Credit Memos")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Credit Memos';
                RunObject = Page "Purchase Credit Memos";
            }
            action("Bank Accounts")
            {
                ApplicationArea = Basic;
                Caption = 'Bank Accounts';
                Image = BankAccount;
                RunObject = Page "Bank Account List";
            }
            action(Items)
            {
                ApplicationArea = Basic;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            action(PurchaseJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Journals';
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type"=const(Purchases),
                                    Recurring=const(false));
            }
            action(PaymentJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Payment Journals';
                Image = Journals;
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type"=const(Payments),
                                    Recurring=const(false));
            }
            action(GeneralJournals)
            {
                ApplicationArea = Basic;
                Caption = 'General Journals';
                Image = Journal;
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type"=const(General),
                                    Recurring=const(false));
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                ToolTip = 'View posted purchase invoices and credit memos, and analyze G/L registers.';
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                }
                action("Posted Return Shipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
                }
                action("G/L Registers")
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                }
            }
        }
        area(creation)
        {
            action("&Vendor")
            {
                ApplicationArea = Basic;
                Caption = '&Vendor';
                Image = Vendor;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Vendor Card";
                RunPageMode = Create;
            }
            action("&Purchase Order")
            {
                ApplicationArea = Basic;
                Caption = '&Purchase Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Order";
                RunPageMode = Create;
            }
            action("Purchase &Invoice")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase &Invoice';
                Image = NewPurchaseInvoice;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Invoice";
                RunPageMode = Create;
            }
            action("Purchase Credit &Memo")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Credit &Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Credit Memo";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            separator(Action18)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Payment &Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Payment &Journal';
                Image = PaymentJournal;
                RunObject = Page "Payment Journal";
            }
            action("P&urchase Journal")
            {
                ApplicationArea = Basic;
                Caption = 'P&urchase Journal';
                Image = Journals;
                RunObject = Page "Purchase Journal";
            }
            action("Reconcile AP to GL")
            {
                ApplicationArea = Basic;
                Caption = 'Reconcile AP to GL';
                Image = "Report";
                RunObject = Report "Reconcile AP to GL";
            }
            separator(Action31)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("Purchases && Payables &Setup")
            {
                ApplicationArea = Basic;
                Caption = 'Purchases && Payables &Setup';
                Image = Setup;
                RunObject = Page "Purchases & Payables Setup";
            }
            separator(Action40)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                ApplicationArea = Basic;
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
            separator(Action1020001)
            {
                Caption = 'Customer';
                IsHeader = true;
            }
            action("Credit Management")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Credit Management';
                Image = CustomerList;
                RunObject = Page "Customer List - Credit Mgmt.";
                ToolTip = 'View the customer list with credit limit.';
            }
            action("Order Status")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Order Status';
                Image = OrderList;
                RunObject = Page "Customer List - Order Status";
                ToolTip = 'View the customer list.';
            }
        }
    }
}

