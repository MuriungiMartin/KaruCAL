#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9022 "Business Manager Role Center"
{
    // CurrPage."Help And Setup List".ShowFeatured;

    Caption = 'Business Manager Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control16;"O365 Activities")
            {
                AccessByPermission = TableData "G/L Entry"=R;
                ApplicationArea = Basic,Suite;
            }
            part(Control55;"Help And Chart Wrapper")
            {
                AccessByPermission = TableData "Assisted Setup"=R;
                ApplicationArea = Basic,Suite;
                Caption = '';
                ToolTip = 'Specifies the view of your business assistance';
            }
            part(Control46;"Team Member Activities")
            {
                ApplicationArea = Suite;
            }
            part(Control7;"My Accounts")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Favorite Accounts';
            }
            part(Control9;"Trial Balance")
            {
                AccessByPermission = TableData "G/L Entry"=R;
                ApplicationArea = Basic,Suite;
            }
            part(Control96;"Report Inbox Part")
            {
                ApplicationArea = Basic,Suite;
            }
            part(Control98;"Power BI Report Spinner Part")
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(New)
            {
                Caption = 'New';
                action("Sales Quote")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Quote';
                    Image = NewSalesQuote;
                    RunObject = Page "Sales Quote";
                    RunPageMode = Create;
                    ToolTip = 'Create a new sales quote where you offer items or services to a customer.';
                }
                action("Sales Order")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Order';
                    Image = NewOrder;
                    RunObject = Page "Sales Order";
                    RunPageMode = Create;
                    ToolTip = 'Create a new sales order for items or services that require partial posting or order confirmation.';
                }
                action("Sales Invoice")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Invoice';
                    Image = NewSalesInvoice;
                    RunObject = Page "Sales Invoice";
                    RunPageMode = Create;
                    ToolTip = 'Create a new sales invoice for items or services. Quantities cannot be posted partially.';
                }
                action("<Page Purchase Order>")
                {
                    ApplicationArea = Suite;
                    Caption = 'Purchase Order';
                    Image = NewOrder;
                    RunObject = Page "Purchase Order";
                    RunPageMode = Create;
                    ToolTip = 'Create a new purchase order.';
                }
                action("Purchase Invoice")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Invoice';
                    Image = NewPurchaseInvoice;
                    RunObject = Page "Purchase Invoice";
                    RunPageMode = Create;
                    ToolTip = 'Create a new purchase invoice for items or services.';
                }
                action(Customer)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer';
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageMode = Create;
                    ToolTip = 'Register a new customer.';
                }
                action(Vendor)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Vendor';
                    Image = Vendor;
                    RunObject = Page "Vendor Card";
                    RunPageMode = Create;
                    ToolTip = 'Register a new vendor.';
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                group("Process Payments")
                {
                    Caption = 'Process Payments';
                    Image = Reconcile;
                    action("Payment Reconciliation Journals")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Reconcile Imported Payments';
                        Image = ApplyEntries;
                        RunObject = Codeunit "Pmt. Rec. Journals Launcher";
                        ToolTip = 'Reconcile your bank account by importing transactions and applying them, automatically or manually, to open customer ledger entries, open vendor ledger entries, or open bank account ledger entries.';
                    }
                    action("Import Bank Transactions")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Import Bank Transactions...';
                        Image = Import;
                        RunObject = Codeunit "Pmt. Rec. Jnl. Import Trans.";
                        ToolTip = 'To start the process of reconciling new payments, import a bank feed or electronic file containing the related bank transactions.';
                    }
                    action("Register Customer Payments")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Register Customer Payments';
                        Image = Payment;
                        RunObject = Page "Payment Registration";
                        ToolTip = 'Process you customers'' payments by matching amounts received on your bank account with the related unpaid sales invoices, and then post the payments.';
                    }
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                group("Financial Statements")
                {
                    Caption = 'Financial Statements';
                    Image = ReferenceData;
                    action("Balance Sheet")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Balance Sheet';
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        PromotedIsBig = true;
                        RunObject = Codeunit "Run Acc. Sched. Balance Sheet";
                        ToolTip = 'View a report that shows your company''s assets, liabilities, and equity.';
                    }
                    action("Income Statement")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Income Statement';
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        PromotedIsBig = true;
                        RunObject = Codeunit "Run Acc. Sched. Income Stmt.";
                        ToolTip = 'View a report that shows your company''s income and expenses.';
                    }
                    action("Statement of Cash Flows")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Statement of Cash Flows';
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        PromotedIsBig = true;
                        RunObject = Codeunit "Run Acc. Sched. CashFlow Stmt.";
                        ToolTip = 'View a financial statement that shows how changes in balance sheet accounts and income affect the company''s cash holdings, displayed for operating, investing, and financing activities respectively.';
                    }
                    action("Statement of Retained Earnings")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Statement of Retained Earnings';
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        PromotedIsBig = true;
                        RunObject = Codeunit "Run Acc. Sched. Retained Earn.";
                        ToolTip = 'View a report that shows your company''s changes in retained earnings for a specified period by reconciling the beginning and ending retained earnings for the period, using information such as net income from the other financial statements.';
                    }
                    action("Sales Taxes Collected")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Sales Taxes Collected';
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        PromotedIsBig = true;
                        RunObject = Report "Sales Taxes Collected";
                        ToolTip = 'View a report that shows the sales taxes that have been collected on behalf of the authorities.';
                    }
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                Image = Setup;
                action("Company Settings")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Company Settings';
                    Image = CompanyInformation;
                    RunObject = Page "Company Information";
                    ToolTip = 'Enter the company name, address, and bank information that will be inserted on your business documents.';
                }
                action("Assisted Setup & Tasks")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Assisted Setup & Tasks';
                    Image = QuestionaireSetup;
                    RunObject = Page "Assisted Setup";
                    ToolTip = 'Set up core functionality such as sales tax, sending documents as email, and approval workflow by running through a few pages that guide you through the information.';
                }
                group("Services & Extensions")
                {
                    Caption = 'Services & Extensions';
                    Image = ServiceSetup;
                    action(Extensions)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Extensions';
                        Image = NonStockItemSetup;
                        RunObject = Page "Extension Management";
                        ToolTip = 'Install Extensions for greater functionality of the system.';
                    }
                    action("Service Connections")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Service Connections';
                        Image = ServiceTasks;
                        RunObject = Page "Service Connections";
                        ToolTip = 'Enable and configure external services, such as exchange rate updates, Microsoft Social Engagement, and electronic bank integration.';
                    }
                }
            }
        }
        area(embedding)
        {
            ToolTip = 'Manage your business. See KPIs, trial balance, and favorite customers.';
            action(Customers)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customers';
                RunObject = Page "Customer List";
                ToolTip = 'Open the list of customers.';
            }
            action(Vendors)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Vendors';
                RunObject = Page "Vendor List";
                ToolTip = 'View a list of vendors that you can buy items from.';
            }
            action(Items)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Items';
                RunObject = Page "Item List";
                ToolTip = 'Open the list of items that you trade in. Items can be either an inventory item and a service.';
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
                    ApplicationArea = Basic;
                    Caption = 'Direct Debit Collections';
                    RunObject = Page "Direct Debit Collections";
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
                    ApplicationArea = Basic;
                    Caption = 'Employees';
                    RunObject = Page "Employee List";
                }
                action("VAT Statements")
                {
                    ApplicationArea = Basic;
                    Caption = 'VAT Statements';
                    RunObject = Page "VAT Statement Names";
                }
                action("Intrastat Journals")
                {
                    ApplicationArea = Basic;
                    Caption = 'Intrastat Journals';
                    RunObject = Page "Intrastat Jnl. Batches";
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
                    ApplicationArea = Basic;
                    Caption = 'Issued Reminders';
                    Image = OrderReminder;
                    RunObject = Page "Issued Reminder List";
                }
                action("Issued Finance Charge Memos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Issued Finance Charge Memos';
                    Image = PostedMemo;
                    RunObject = Page "Issued Fin. Charge Memo List";
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
                    Gesture = None;
                    RunObject = Page "Incoming Documents";
                    ToolTip = 'Specifies the Incoming Documents';
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
            group(ActionGroup76)
            {
                Caption = 'Approvals';
                ToolTip = 'Approve requests made by other users.';
                action("Requests to Approve")
                {
                    ApplicationArea = Suite;
                    Caption = 'Requests to Approve';
                    Image = Approvals;
                    RunObject = Page "Requests to Approve";
                    ToolTip = 'View the number of approval requests that require your approval.';
                }
            }
            group("Advanced Finance")
            {
                Caption = 'Advanced Finance';
                Image = AnalysisView;
                ToolTip = 'Manage budgets, cash flows, fixed assets, tax, and analyze sales.';
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
                    ApplicationArea = Basic;
                    Caption = 'Sales Analysis Reports';
                    RunObject = Page "Analysis Report Sale";
                    ToolTip = 'Analyze the dynamics of your sales according to key sales performance indicators that you select, for example, sales turnover in both amounts and quantities, contribution margin, or progress of actual sales against the budget. You can also use the report to analyze your average sales prices and evaluate the sales performance of your sales force.';
                }
                action("Purchase Analysis Reports")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Analysis Reports';
                    RunObject = Page "Analysis Report Purchase";
                    ToolTip = 'Analyze the dynamics of your purchase volumes. You can also use the report to analyze your vendors'' performance and purchase prices.';
                }
                action("Inventory Analysis Reports")
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory Analysis Reports';
                    RunObject = Page "Analysis Report Inventory";
                    ToolTip = 'Analyze the dynamics of your inventory according to key performance indicators that you select, for example inventory turnover. You can also use the report to analyze your inventory costs, in terms of direct and indirect costs, as well as the value and quantities of your different types of inventory.';
                }
                action("Tax Reports")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Reports';
                    RunObject = Page "VAT Report List";
                }
                action("Cash Flow Forecasts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cash Flow Forecasts';
                    RunObject = Page "Cash Flow Forecast List";
                }
                action("Chart of Cash Flow Accounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Chart of Cash Flow Accounts';
                    RunObject = Page "Chart of Cash Flow Accounts";
                }
                action("Cash Flow Manual Revenues")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cash Flow Manual Revenues';
                    RunObject = Page "Cash Flow Manual Revenues";
                }
                action("Cash Flow Manual Expenses")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cash Flow Manual Expenses';
                    RunObject = Page "Cash Flow Manual Expenses";
                }
            }
            group("Self-Service")
            {
                Caption = 'Self-Service';
                Image = HumanResources;
                ToolTip = 'Manage your time sheets and assignments.';
                action("Time Sheets")
                {
                    ApplicationArea = Suite;
                    Caption = 'Time Sheets';
                    RunObject = Page "Time Sheet List";
                    ToolTip = 'View all time sheets.';
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
                action("Meal Booking")
                {
                    ApplicationArea = Basic;
                    Caption = 'Meal Booking';
                    RunObject = Page "CAT-Meal Booking List";
                }
            }
        }
    }
}

