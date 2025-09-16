#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9003 "Acc. Receivables Adm. RC"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1902899408;"Acc. Receivable Activities")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control1907692008;"My Customers")
                {
                }
                part(Control1905989608;"My Items")
                {
                    Visible = false;
                }
                part(Control38;"Report Inbox Part")
                {
                }
                part(Control1;"My Job Queue")
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
            action("Customer Listing")
            {
                ApplicationArea = Basic;
                Caption = 'Customer Listing';
                Image = "Report";
                RunObject = Report "Customer Listing";
            }
            action("Customer - &Balance to Date")
            {
                ApplicationArea = Basic;
                Caption = 'Customer - &Balance to Date';
                Image = "Report";
                RunObject = Report "Customer - Balance to Date";
            }
            action("Aged Accounts Receivable")
            {
                ApplicationArea = Basic;
                Caption = 'Aged Accounts Receivable';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
            }
            action("Customer - &Summary Aging Simp.")
            {
                ApplicationArea = Basic;
                Caption = 'Customer - &Summary Aging Simp.';
                Image = "Report";
                RunObject = Report "Customer - Summary Aging Simp.";
            }
            action("Customer - Trial Balan&ce")
            {
                ApplicationArea = Basic;
                Caption = 'Customer - Trial Balan&ce';
                Image = "Report";
                RunObject = Report "Customer - Trial Balance";
            }
            action("Customer Account Detail")
            {
                ApplicationArea = Basic;
                Caption = 'Customer Account Detail';
                Image = "Report";
                RunObject = Report "Customer Account Detail";
            }
            action("Customer/Item Statistics")
            {
                ApplicationArea = Basic;
                Caption = 'Customer/Item Statistics';
                Image = "Report";
                RunObject = Report "Customer/Item Statistics";
            }
            action("Daily Invoicing Report")
            {
                ApplicationArea = Basic;
                Caption = 'Daily Invoicing Report';
                Image = "Report";
                RunObject = Report "Daily Invoicing Report";
            }
            action("Outstanding Sales Order Aging")
            {
                ApplicationArea = Basic;
                Caption = 'Outstanding Sales Order Aging';
                Image = "Report";
                RunObject = Report "Outstanding Sales Order Aging";
            }
            action("Outstanding Sales Order Status")
            {
                ApplicationArea = Basic;
                Caption = 'Outstanding Sales Order Status';
                Image = "Report";
                RunObject = Report "Outstanding Sales Order Status";
            }
            separator(Action20)
            {
            }
            action("Customer &Document Nos.")
            {
                ApplicationArea = Basic;
                Caption = 'Customer &Document Nos.';
                Image = "Report";
                RunObject = Report "Customer Document Nos.";
            }
            action("Sales &Invoice Nos.")
            {
                ApplicationArea = Basic;
                Caption = 'Sales &Invoice Nos.';
                Image = "Report";
                RunObject = Report "Sales Invoice Nos.";
            }
            action("Sa&les Credit Memo Nos.")
            {
                ApplicationArea = Basic;
                Caption = 'Sa&les Credit Memo Nos.';
                Image = "Report";
                RunObject = Report "Sales Credit Memo Nos.";
            }
            action("Re&minder Nos.")
            {
                ApplicationArea = Basic;
                Caption = 'Re&minder Nos.';
                Image = "Report";
                RunObject = Report "Reminder Nos.";
            }
            action("Finance Cha&rge Memo Nos.")
            {
                ApplicationArea = Basic;
                Caption = 'Finance Cha&rge Memo Nos.';
                Image = "Report";
                RunObject = Report "Finance Charge Memo Nos.";
            }
            action("Cash Applied")
            {
                ApplicationArea = Basic;
                Caption = 'Cash Applied';
                Image = "Report";
                RunObject = Report "Cash Applied";
            }
            action("Projected Cash Payments")
            {
                ApplicationArea = Basic;
                Caption = 'Projected Cash Payments';
                Image = PaymentForecast;
                RunObject = Report "Projected Cash Payments";
            }
        }
        area(embedding)
        {
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(CustomersBalance)
            {
                ApplicationArea = Basic;
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Customer List";
                RunPageView = where("Balance (LCY)"=filter(<>0));
            }
            action("Sales Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
            }
            action("Sales Invoices")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page "Sales Invoice List";
            }
            action("Sales Return Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Return Orders';
                Image = ReturnOrder;
                RunObject = Page "Sales Return Order List";
            }
            action("Bank Accounts")
            {
                ApplicationArea = Basic;
                Caption = 'Bank Accounts';
                Image = BankAccount;
                RunObject = Page "Bank Account List";
            }
            action(Deposits)
            {
                ApplicationArea = Basic;
                Caption = 'Deposits';
                RunObject = Page "Deposit List";
            }
            action(Reminders)
            {
                ApplicationArea = Basic;
                Caption = 'Reminders';
                Image = Reminder;
                RunObject = Page "Reminder List";
            }
            action("Finance Charge Memos")
            {
                ApplicationArea = Basic;
                Caption = 'Finance Charge Memos';
                Image = FinChargeMemo;
                RunObject = Page "Finance Charge Memo List";
            }
            action(Items)
            {
                ApplicationArea = Basic;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            action(SalesJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Journals';
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type"=const(Sales),
                                    Recurring=const(false));
            }
            action(CashReceiptJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Cash Receipt Journals';
                Image = Journals;
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type"=const("Cash Receipts"),
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
            action("Direct Debit Collections")
            {
                ApplicationArea = Basic;
                Caption = 'Direct Debit Collections';
                RunObject = Page "Direct Debit Collections";
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Sales Shipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Sales Shipments";
                }
                action("Posted Sales Invoices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                }
                action("Posted Return Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page "Posted Return Receipts";
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
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
                action("Issued Reminders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Issued Reminders';
                    Image = OrderReminder;
                    RunObject = Page "Issued Reminder List";
                }
                action("Issued Fin. Charge Memos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Issued Fin. Charge Memos';
                    Image = PostedMemo;
                    RunObject = Page "Issued Fin. Charge Memo List";
                }
                action("G/L Registers")
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                }
                action("Posted Deposits")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Deposits';
                    Image = PostedDeposit;
                    RunObject = Page "Posted Deposit List";
                }
                action("Posted Bank Recs.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Bank Recs.';
                    RunObject = Page "Posted Bank Rec. List";
                }
                action("Bank Statements")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Statements';
                    RunObject = Page "Bank Account Statement List";
                }
            }
        }
        area(processing)
        {
            separator(Action64)
            {
                Caption = 'New';
                IsHeader = true;
            }
            action("C&ustomer")
            {
                ApplicationArea = Basic;
                Caption = 'C&ustomer';
                Image = Customer;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Customer Card";
                RunPageMode = Create;
            }
            group("&Sales")
            {
                Caption = '&Sales';
                Image = Sales;
                action("Sales &Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Order";
                    RunPageMode = Create;
                }
                action("Sales &Invoice")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Invoice';
                    Image = NewSalesInvoice;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Invoice";
                    RunPageMode = Create;
                }
                action("Sales &Credit Memo")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Credit Memo';
                    Image = CreditMemo;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Credit Memo";
                    RunPageMode = Create;
                }
                action("Sales &Fin. Charge Memo")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Fin. Charge Memo';
                    Image = FinChargeMemo;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Finance Charge Memo";
                    RunPageMode = Create;
                }
                action("Sales &Reminder")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Reminder';
                    Image = Reminder;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page Reminder;
                    RunPageMode = Create;
                }
            }
            separator(Action67)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Cash Receipt &Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Cash Receipt &Journal';
                Image = CashReceiptJournal;
                RunObject = Page "Cash Receipt Journal";
            }
            action(Deposit)
            {
                ApplicationArea = Basic;
                Caption = 'Deposit';
                Image = DepositSlip;
                RunObject = Page Deposit;
            }
            separator(Action111)
            {
            }
            action("Combine Shi&pments")
            {
                ApplicationArea = Basic;
                Caption = 'Combine Shi&pments';
                Ellipsis = true;
                Image = "Action";
                RunObject = Report "Combine Shipments";
            }
            action("Combine Return S&hipments")
            {
                ApplicationArea = Basic;
                Caption = 'Combine Return S&hipments';
                Ellipsis = true;
                Image = "Action";
                RunObject = Report "Combine Return Receipts";
            }
            action("Create Recurring Invoices")
            {
                ApplicationArea = Basic;
                Caption = 'Create Recurring Invoices';
                Ellipsis = true;
                Image = CreateDocument;
                RunObject = Report "Create Recurring Sales Inv.";
            }
            separator(Action84)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("Sales && Recei&vables Setup")
            {
                ApplicationArea = Basic;
                Caption = 'Sales && Recei&vables Setup';
                Image = Setup;
                RunObject = Page "Sales & Receivables Setup";
            }
            separator(Action89)
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
            separator(Action1020000)
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
            action("Sales Order Invoicing")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Order Invoicing';
                Image = SalesShipment;
                RunObject = Page "Sales Order Invoice List";
                ToolTip = 'View the sales order invoice list.';
            }
        }
    }
}

