#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9028 "Team Member Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control2)
            {
                part(Control3;"Team Member Activities")
                {
                    ApplicationArea = Suite;
                }
                part(Control4;"My Time Sheets")
                {
                    ApplicationArea = Suite;
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action("Time Sheets")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Time Sheets';
                RunObject = Page "Time Sheet List";
                ToolTip = 'View all time sheets.';
            }
        }
        area(sections)
        {
            group(Finance)
            {
                Caption = 'Finance';
                Image = Journals;
                ToolTip = 'Collect and make payments, prepare statements, and reconcile bank accounts.';
                action(GeneralJournals)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(General),
                                        Recurring=const(false));
                    ToolTip = 'Open the list of general journal, for example, to record or post a payment that has no related document.';
                }
                action("Chart of Accounts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Chart of Accounts';
                    RunObject = Page "Chart of Accounts";
                    ToolTip = 'View the chart of accounts.';
                }
                action("Account Schedules")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Account Schedules';
                    RunObject = Page "Account Schedule Names";
                    ToolTip = 'Open your account schedules to analyze figures in general ledger accounts or to compare general ledger entries with general ledger budget entries.';
                }
                action("G/L Account Categories")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'G/L Account Categories';
                    RunObject = Page "G/L Account Categories";
                    ToolTip = 'View the categories that are created to organize G/L accounts.';
                }
                action(CashReceiptJournals)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cash Receipt Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const("Cash Receipts"),
                                        Recurring=const(false));
                    ToolTip = 'Register received payments by applying them to the related customer, vendor, or bank ledger entries.';
                }
                action(PaymentJournals)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Payment Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(Payments),
                                        Recurring=const(false));
                    ToolTip = 'Open the list of payment journals where you can register payments to vendors.';
                }
                action("Bank Accounts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Bank Account List";
                    ToolTip = 'View or set up your the customers and vendors bank accounts. You can set up any number of bank accounts for each.';
                }
                action("Payment Reconciliation Journals")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Payment Reconciliation Journals';
                    Image = ApplyEntries;
                    RunObject = Page "Pmt. Reconciliation Journals";
                    ToolTip = 'Open a list of journals where you can reconcile unpaid documents automatically with their related bank transactions by importing a bank statement feed or file.';
                }
                action("Bank Acc. Statements")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Bank Acc. Statements';
                    Image = BankAccountStatement;
                    RunObject = Page "Bank Account Statement List";
                    ToolTip = 'View statements for selected bank accounts. For each bank transaction, the report shows a description, an applied amount, a statement amount, and other information.';
                }
                action("Direct Debit Collections")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Direct Debit Collections';
                    RunObject = Page "Direct Debit Collections";
                    ToolTip = 'View and edit entries that are generated for the direct-debit collection.';
                }
                action(Currencies)
                {
                    ApplicationArea = Suite;
                    Caption = 'Currencies';
                    Image = Currency;
                    RunObject = Page Currencies;
                    ToolTip = 'View the different currencies that you trade in.';
                }
                action(Employees)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Employees';
                    RunObject = Page "Employee List";
                    ToolTip = 'View the list of employees.';
                }
                action("Tax Statements")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tax Statements';
                    RunObject = Page "VAT Statement Names";
                    ToolTip = 'View the Tax statements.';
                }
                action("Intrastat Journals")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Intrastat Journals';
                    RunObject = Page "Intrastat Jnl. Batches";
                    ToolTip = 'View the Intrastat Journals.';
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                Image = Sales;
                ToolTip = 'Make quotes, orders, and credit memos. See customers and transaction history.';
                action(Sales_CustomerList)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customers';
                    RunObject = Page "Customer List";
                    ToolTip = 'Open the list of customers.';
                }
                action("Sales Quotes")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Quotes';
                    RunObject = Page "Sales Quotes";
                    ToolTip = 'Open the list of sales quotes where you offer items or services to customers.';
                }
                action("Sales Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Orders';
                    RunObject = Page "Sales Order List";
                    ToolTip = 'Open the list of sales orders where you can sell items and services.';
                }
                action("Sales Invoices")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Invoices';
                    RunObject = Page "Sales Invoice List";
                    ToolTip = 'Open the list of sales invoices where you can invoice items or services.';
                }
                action("Sales Credit Memos")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Credit Memos';
                    RunObject = Page "Sales Credit Memos";
                    ToolTip = 'Open the list of sales credit memos where you can revert posted sales invoices.';
                }
                action(Reminders)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Reminders';
                    Image = Reminder;
                    RunObject = Page "Reminder List";
                    ToolTip = 'View the reminders that you have sent to the customer.';
                }
                action("Finance Charge Memos")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Finance Charge Memos';
                    Image = FinChargeMemo;
                    RunObject = Page "Finance Charge Memo List";
                    ToolTip = 'View the finance charge memos that you have sent to the customer.';
                }
                action("Posted Sales Invoices")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'View the posted sales invoices.';
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Sales Credit Memos';
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'View the posted sales credit memos.';
                }
                action("Issued Reminders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Issued Reminders';
                    Image = OrderReminder;
                    RunObject = Page "Issued Reminder List";
                    ToolTip = 'View the list of issued reminders.';
                }
                action("Issued Finance Charge Memos")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Issued Finance Charge Memos';
                    Image = PostedMemo;
                    RunObject = Page "Issued Fin. Charge Memo List";
                    ToolTip = 'View the list of issued finance charge memos.';
                }
            }
            group(Purchasing)
            {
                Caption = 'Purchasing';
                Image = AdministrationSalesPurchases;
                ToolTip = 'Manage purchase invoices and credit memos. Maintain vendors and their history.';
                action(Purchase_VendorList)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Vendors';
                    RunObject = Page "Vendor List";
                    ToolTip = 'View a list of vendors that you can buy items from.';
                }
                action("Incoming Documents")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Incoming Documents';
                    RunObject = Page "Incoming Documents";
                    ToolTip = 'View incoming documents.';
                }
                action("<Page Purchase Orders>")
                {
                    ApplicationArea = Suite;
                    Caption = 'Purchase Orders';
                    RunObject = Page "Purchase Order List";
                    ToolTip = 'Open the list of purchase orders where you can purchase items or services.';
                }
                action("<Page Purchase Invoices>")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Invoices';
                    RunObject = Page "Purchase Invoices";
                    ToolTip = 'Open the list of purchase invoices where you can purchase items or services.';
                }
                action("<Page Posted Purchase Invoices>")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'View the posted purchase invoices.';
                }
                action("<Page Purchase Credit Memos>")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Credit Memos';
                    RunObject = Page "Purchase Credit Memos";
                    ToolTip = 'Open the list of purchase credit memos where you can revert posted purchase invoices.';
                }
                action("<Page Posted Purchase Credit Memos>")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                    ToolTip = 'View the posted purchase credit memos.';
                }
                action("<Page Posted Purchase Receipts>")
                {
                    ApplicationArea = Suite;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                    ToolTip = 'View the posted purchase receipts.';
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;
                action("Pending My Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending My Approval';
                    RunObject = Page "Approval Entries";
                }
                action("My Approval requests")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approval requests';
                    RunObject = Page "Approval Request Entries";
                }
                action("Clearance Requests")
                {
                    ApplicationArea = Basic;
                    Caption = 'Clearance Requests';
                    RunObject = Page "ACA-Clearance Approval Entries";
                }
            }
            group(Common_req)
            {
                Caption = 'Common Requisitions';
                Image = LotInfo;
                action("Stores Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Stores Requisitions';
                    RunObject = Page "PROC-Store Requisition";
                }
                action("Imprest Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Requisitions';
                    RunObject = Page "FIN-Imprest List UP";
                }
                action("Leave Applications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Applications';
                    RunObject = Page "HRM-Leave Requisition List";
                }
                action("My Approved Leaves")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approved Leaves';
                    Image = History;
                    RunObject = Page "HRM-My Approved Leaves List";
                }
                action("File Requisitions")
                {
                    ApplicationArea = Basic;
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "REG-File Requisition List";
                }
            }
            group("Advanced Finance")
            {
                Caption = 'Advanced Finance';
                Image = AnalysisView;
                ToolTip = 'Manage budgets, cash flows, fixed assets, Tax, and analyze sales.';
                action("G/L Budgets")
                {
                    ApplicationArea = Suite;
                    Caption = 'G/L Budgets';
                    RunObject = Page "G/L Budget Names";
                    ToolTip = 'View summary information about the amount budgeted for each general ledger account in different time periods.';
                }
                action("Fixed Assets")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed Assets';
                    RunObject = Page "Fixed Asset List";
                    ToolTip = 'Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.';
                }
                action("Sales Analysis Reports")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Analysis Reports';
                    RunObject = Page "Analysis Report Sale";
                    ToolTip = 'Analyze the dynamics of your sales according to key sales performance indicators that you select, for example, sales turnover in both amounts and quantities, contribution margin, or progress of actual sales against the budget. You can also use the report to analyze your average sales prices and evaluate the sales performance of your sales force.';
                }
                action("Purchase Analysis Reports")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Analysis Reports';
                    RunObject = Page "Analysis Report Purchase";
                    ToolTip = 'Analyze the dynamics of your purchase volumes. You can also use the report to analyze your vendors'' performance and purchase prices.';
                }
                action("Inventory Analysis Reports")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Inventory Analysis Reports';
                    RunObject = Page "Analysis Report Inventory";
                    ToolTip = 'Analyze the dynamics of your inventory according to key performance indicators that you select, for example inventory turnover. You can also use the report to analyze your inventory costs, in terms of direct and indirect costs, as well as the value and quantities of your different types of inventory.';
                }
                action("Tax Reports")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tax Reports';
                    RunObject = Page "VAT Report List";
                    ToolTip = 'View the list of Tax reports.';
                }
                action("Cash Flow Forecasts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cash Flow Forecasts';
                    RunObject = Page "Cash Flow Forecast List";
                    ToolTip = 'View the list of cash flow forecasts.';
                }
                action("Chart of Cash Flow Accounts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Chart of Cash Flow Accounts';
                    RunObject = Page "Chart of Cash Flow Accounts";
                    ToolTip = 'View the chart of cash flow accounts.';
                }
                action("Cash Flow Manual Revenues")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cash Flow Manual Revenues';
                    RunObject = Page "Cash Flow Manual Revenues";
                    ToolTip = 'View the cash flow manual revenues.';
                }
                action("Cash Flow Manual Expenses")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cash Flow Manual Expenses';
                    RunObject = Page "Cash Flow Manual Expenses";
                    ToolTip = 'View the cash flow manual expenses.';
                }
            }
        }
    }
}

