#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 36603 "Credit & Collections Mgr. RC"
{
    Caption = 'Home';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1905739008;"Credit Manager Activities")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control1907692008;"My Customers")
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
                RunObject = Report "Customer Listing";
            }
            action("Customer Balance to Date")
            {
                ApplicationArea = Basic;
                Caption = 'Customer Balance to Date';
                RunObject = Report "Customer - Balance to Date";
            }
            action("Aged Accounts Receivable")
            {
                ApplicationArea = Basic;
                Caption = 'Aged Accounts Receivable';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
            }
            action("Customer Account Detail")
            {
                ApplicationArea = Basic;
                Caption = 'Customer Account Detail';
                RunObject = Report "Customer Account Detail";
            }
            separator(Action20)
            {
            }
            action("Cash Applied")
            {
                ApplicationArea = Basic;
                Caption = 'Cash Applied';
                RunObject = Report "Cash Applied";
            }
            action("Projected Cash Payments")
            {
                ApplicationArea = Basic;
                Caption = 'Projected Cash Payments';
                RunObject = Report "Projected Cash Payments";
            }
        }
        area(embedding)
        {
            action(Approvals)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                RunObject = Page "Approval Entries";
            }
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                RunObject = Page "Customer List - Collections";
            }
            action(Balance)
            {
                ApplicationArea = Basic;
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Customer List - Collections";
                RunPageView = where("Balance on Date (LCY)"=filter(>0));
            }
            action("Unlimited Credit")
            {
                ApplicationArea = Basic;
                Caption = 'Unlimited Credit';
                RunObject = Page "Customer List - Collections";
                RunPageView = where("Credit Limit (LCY)"=const(0));
            }
            action("Limited Credit")
            {
                ApplicationArea = Basic;
                Caption = 'Limited Credit';
                RunObject = Page "Customer List - Collections";
                RunPageView = where("Credit Limit (LCY)"=filter(<>0));
            }
            action("Invoices by Due Date")
            {
                ApplicationArea = Basic;
                Caption = 'Invoices by Due Date';
                RunObject = Page "Customer Ledger Entries";
                RunPageView = sorting(Open,"Due Date")
                              where(Open=const(true),
                                    "Document Type"=filter(Invoice|"Credit Memo"));
            }
            action("Sales Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Orders';
                RunObject = Page "Customer Order Header Status";
            }
            action("Sales Return Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Return Orders';
                RunObject = Page "Customer Order Header Status";
                RunPageView = where("Document Type"=const("Return Order"));
            }
            action("Sales Invoices")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Invoices';
                RunObject = Page "Sales Invoice List";
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
                    RunObject = Page "Posted Sales Shipments";
                }
                action("Posted Sales Invoices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page "Posted Sales Invoices";
                }
                action("Posted Return Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Receipts';
                    RunObject = Page "Posted Return Receipts";
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Credit Memos';
                    RunObject = Page "Posted Sales Credit Memos";
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
                    RunObject = Page "Issued Fin. Charge Memo List";
                }
                action("Posted Deposits")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Deposits';
                    RunObject = Page "Posted Deposit List";
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
            action("Fin. Charge Memo")
            {
                ApplicationArea = Basic;
                Caption = 'Fin. Charge Memo';
                RunObject = Page "Finance Charge Memo";
            }
            action(Reminder)
            {
                ApplicationArea = Basic;
                Caption = 'Reminder';
                Image = Reminder;
                RunObject = Page Reminder;
            }
        }
    }
}

