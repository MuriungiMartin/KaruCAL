#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9019 "CEO and President Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control21;"Finance Performance")
                {
                }
                part(Control4;"Finance Performance")
                {
                    Visible = false;
                }
                part(Control1907692008;"My Customers")
                {
                }
                part(Control26;"Copy Profile")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control24;"Cash Flow Forecast Chart")
                {
                }
                part(Control27;"Sales Performance")
                {
                }
                part(Control28;"Sales Performance")
                {
                    Visible = false;
                }
                part(Control29;"Report Inbox Part")
                {
                }
                part(Control25;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control1902476008;"My Vendors")
                {
                    Visible = false;
                }
                part(Control1905989608;"My Items")
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
            action("Change Password")
            {
                ApplicationArea = Basic;
                Caption = 'Change Password';
                Image = ChangeStatus;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Change Password";
            }
            action("Recei&vables-Payables")
            {
                ApplicationArea = Basic;
                Caption = 'Recei&vables-Payables';
                Image = ReceivablesPayables;
                RunObject = Report "Receivables-Payables";
            }
            action("&Trial Balance/Budget")
            {
                ApplicationArea = Basic;
                Caption = '&Trial Balance/Budget';
                Image = "Report";
                RunObject = Report "Trial Balance/Budget";
            }
            action("&Closing Trial Balance")
            {
                ApplicationArea = Basic;
                Caption = '&Closing Trial Balance';
                Image = "Report";
                RunObject = Report "Closing Trial Balance";
            }
            action("&Fiscal Year Balance")
            {
                ApplicationArea = Basic;
                Caption = '&Fiscal Year Balance';
                Image = "Report";
                RunObject = Report "Fiscal Year Balance";
            }
            separator(Action6)
            {
            }
            action("Customer - &Balance")
            {
                ApplicationArea = Basic;
                Caption = 'Customer - &Balance';
                Image = "Report";
                RunObject = Report "Customer - Balance to Date";
            }
            action("Customer - T&op 10 List")
            {
                ApplicationArea = Basic;
                Caption = 'Customer - T&op 10 List';
                Image = "Report";
                RunObject = Report "Customer - Top 10 List";
            }
            action("Customer - S&ales List")
            {
                ApplicationArea = Basic;
                Caption = 'Customer - S&ales List';
                Image = "Report";
                RunObject = Report "Customer - Sales List";
            }
            action("Customer Sales Statistics")
            {
                ApplicationArea = Basic;
                Caption = 'Customer Sales Statistics';
                Image = "Report";
                RunObject = Report "Customer Sales Statistics";
            }
            separator(Action11)
            {
            }
            action("Vendor - &Purchase List")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor - &Purchase List';
                Image = "Report";
                RunObject = Report "Vendor - Purchase List";
            }
        }
        area(embedding)
        {
            action("Account Schedules")
            {
                ApplicationArea = Basic;
                Caption = 'Account Schedules';
                RunObject = Page "Account Schedule Names";
            }
            action("Analysis by Dimensions")
            {
                ApplicationArea = Basic;
                Caption = 'Analysis by Dimensions';
                Image = AnalysisViewDimension;
                RunObject = Page "Analysis View List";
            }
            action("Sales Analysis Report")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Analysis Report';
                RunObject = Page "Analysis Report Sale";
                RunPageView = where("Analysis Area"=filter(Sales));
            }
            action(Budgets)
            {
                ApplicationArea = Basic;
                Caption = 'Budgets';
                RunObject = Page "G/L Budget Names";
            }
            action("Sales Budgets")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Budgets';
                RunObject = Page "Item Budget Names";
                RunPageView = where("Analysis Area"=filter(Sales));
            }
            action("Sales Quotes")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Quotes';
                Image = Quote;
                RunObject = Page "Sales Quotes";
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
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Contacts)
            {
                ApplicationArea = Basic;
                Caption = 'Contacts';
                Image = CustomerContact;
                RunObject = Page "Contact List";
            }
        }
        area(sections)
        {
        }
    }
}

