#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9027 "Accountant Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1902304208;"Accountant Activities")
                {
                    ApplicationArea = Basic,Suite;
                }
                part(Control1020030;"Team Member Activities")
                {
                    ApplicationArea = Suite;
                }
                part(Control1907692008;"My Accounts")
                {
                    ApplicationArea = Basic,Suite;
                }
                part(Control1020028;"My Vendors")
                {
                    ApplicationArea = Basic,Suite;
                }
                part(Control122;"Power BI Report Spinner Part")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
            group(Control1900724708)
            {
                part(Control1020027;"Finance Performance")
                {
                    ApplicationArea = Basic,Suite;
                }
                part(Control100;"Cash Flow Forecast Chart")
                {
                    ApplicationArea = Basic,Suite;
                }
                part(Control1020026;"Assisted Setup Part")
                {
                    AccessByPermission = TableData "Assisted Setup"=R;
                    ApplicationArea = Basic,Suite;
                }
                part(Control108;"Report Inbox Part")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group(Vendor)
            {
                Caption = 'Vendor';
                action("Aged Accounts Pa&yable")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Aged Accounts Pa&yable';
                    Image = "Report";
                    RunObject = Report "Aged Accounts Payable";
                    ToolTip = 'View, print, or save a list of aged remaining balances for each vendor.';
                }
            }
            group(Customer)
            {
                Caption = 'Customer';
                action("Customer Statement")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer Statement';
                    Image = "Report";
                    RunObject = Report "Customer Statement";
                    ToolTip = 'Open the list of customer statements. Use this report to print statements on generic forms or plain paper. You must enter a date filter to establish a statement date for open item statements or a statement period for balance forward statements.';
                }
                action("Aged Accounts &Receivable")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Aged Accounts &Receivable';
                    Image = "Report";
                    RunObject = Report "Aged Accounts Receivable";
                    ToolTip = 'View, print, or save an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';
                }
            }
            group("Trial Balance")
            {
                Caption = 'Trial Balance';
                action("Trial Balance Detail/Summary")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Trial Balance Detail/Summary';
                    Image = "Report";
                    RunObject = Report "Trial Balance Detail/Summary";
                    ToolTip = 'View general ledger account balances and activities for all the selected accounts, one transaction per line. You can include general ledger accounts which have a balance and including the closing entries within the period.';
                }
                action("Trial Bala&nce, Spread Periods")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Trial Bala&nce, Spread Periods';
                    Image = "Report";
                    RunObject = Report "Trial Balance, Spread Periods";
                    ToolTip = 'View a trial balance with amounts shown in separate columns for each time period.';
                }
            }
            group("Sales Tax")
            {
                Caption = 'Sales Tax';
                action("Sales Taxes Collected")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Taxes Collected';
                    Image = "Report";
                    RunObject = Report "Sales Taxes Collected";
                    ToolTip = 'View sales tax, including use tax, that you have submitted to the authorities.';
                }
                action("Sales Tax Details")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Tax Details';
                    Image = "Report";
                    RunObject = Report "Sales Tax Detail List";
                    ToolTip = 'View a complete or partial list of all sales tax details. For each jurisdiction, all tax groups with their tax types and effective dates are listed.';
                }
                action("Sales Tax Groups")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Tax Groups';
                    Image = "Report";
                    RunObject = Report "Sales Tax Group List";
                    ToolTip = 'View a complete or partial list of sales tax groups.';
                }
                action("Sales Tax Jurisdictions")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Tax Jurisdictions';
                    Image = "Report";
                    RunObject = Report "Sales Tax Jurisdiction List";
                    ToolTip = 'View a list of sales tax jurisdictions that you can use to identify tax authorities for sales and purchases tax calculations. This report shows the codes that are associated with a report-to jurisdiction area. Each sales tax area is assigned a tax account for sales and a tax account for purchases. These accounts define the sales tax rates for each sales tax jurisdiction.';
                }
                action("Sales Tax Areas")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Tax Areas';
                    Image = "Report";
                    RunObject = Report "Sales Tax Area List";
                    ToolTip = 'View a complete or partial list of sales tax areas.';
                }
                action("Sales Tax Detail by Area")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Tax Detail by Area';
                    Image = "Report";
                    RunObject = Report "Sales Tax Detail by Area";
                    ToolTip = 'Verify that each sales tax area is set up correctly. Each sales tax area includes all of its jurisdictions. For each jurisdiction, all tax groups are listed with their tax types and effective dates. Note that the same sales tax jurisdiction, along with all of its details, may appear more than once since the jurisdiction may be used in more than one area.';
                }
            }
            group(Inventory)
            {
                Caption = 'Inventory';
                action("Outstanding Purch. Order Aging")
                {
                    ApplicationArea = Basic;
                    Caption = 'Outstanding Purch. Order Aging';
                    Image = "Report";
                    RunObject = Report "Outstanding Purch. Order Aging";
                }
                action("Inventory Valuation")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Inventory Valuation';
                    Image = "Report";
                    RunObject = Report "Inventory Valuation";
                    ToolTip = 'View, print, or save a list of the values of the on-hand quantity of each inventory item.';
                }
                action("Item Turnover")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Turnover';
                    Image = "Report";
                    RunObject = Report "Item Turnover";
                }
            }
        }
        area(embedding)
        {
            action("Chart of Accounts")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Chart of Accounts';
                RunObject = Page "Chart of Accounts";
                ToolTip = 'View the chart of accounts.';
            }
            action("Bank Accounts")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Bank Accounts';
                Image = BankAccount;
                RunObject = Page "Bank Account List";
                ToolTip = 'View or set up your the customers and vendors bank accounts. You can set up any number of bank accounts for each.';
            }
            action(Customers)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
                ToolTip = 'Open the list of customers.';
            }
            action(Vendors)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = Page "Vendor List";
                ToolTip = 'View a list of vendors that you can buy items from.';
            }
            action("Purchase Invoices")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Purchase Invoices';
                Image = Invoice;
                RunObject = Page "Purchase Invoices";
            }
            action(Budgets)
            {
                ApplicationArea = Suite;
                Caption = 'Budgets';
                RunObject = Page "G/L Budget Names";
            }
        }
        area(sections)
        {
            group("Cash Sale")
            {
                Caption = 'Cash Sale';
                action(POS)
                {
                    ApplicationArea = Basic;
                    Caption = 'Point Of Sale (POS)';
                    RunObject = Page "Cash Sale List-Staff";
                }
                action("Petty Cash Vouchers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Petty Cash Vouchers';
                    RunObject = Page "FIN-Petty Cash Vouchers List";
                }
                action("Interbank Transfers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interbank Transfers';
                    RunObject = Page "FIN-Interbank Transfer";
                }
                action("Posted POS Sales")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted POS Sales';
                    Image = PostedReceipts;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Posted Direct Sales";
                }
                action("Posted Petty Cash Vouchers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Petty Cash Vouchers';
                    RunObject = Page "FIN-Posted Petty Cash V.";
                }
                action("Posted Interbank Transfers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Interbank Transfers';
                    RunObject = Page "FIN-Posted Interbank Trans.";
                }
                action("Credit Sales")
                {
                    ApplicationArea = Basic;
                    Caption = 'Credit Sales';
                    RunObject = Page "Credit Sale List";
                }
                action("Posted Credit Sales")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Credit Sales';
                    RunObject = Page "Posted Credit Sales";
                }
            }
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
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
                action(PurchaseJournals)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Journals';
                    Image = Purchasing;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(Purchases),
                                        Recurring=const(false));
                    ToolTip = 'Open the list of purchase journals where you can batch post purchase transactions to G/L, bank, customer, vendor and fixed assets accounts.';
                }
                action(PaymentJournals)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Payment Journals';
                    Image = PaymentJournal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(Payments),
                                        Recurring=const(false));
                    ToolTip = 'Open the list of payment journals where you can register payments to vendors.';
                }
                action(SalesJournals)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(Sales),
                                        Recurring=const(false));
                    ToolTip = 'Open the list of sales journals where you can batch post sales transactions to G/L, bank, customer, vendor and fixed assets accounts.';
                }
                action(CashReceiptJournals)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cash Receipt Journals';
                    Image = CashReceiptJournal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const("Cash Receipts"),
                                        Recurring=const(false));
                    ToolTip = 'Register received payments by applying them to the related customer, vendor, or bank ledger entries.';
                }
            }
            group("Fixed Assets")
            {
                Caption = 'Fixed Assets';
                Image = FixedAssets;
                action(Action17)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed Assets';
                    RunObject = Page "Fixed Asset List";
                    ToolTip = 'Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.';
                }
                action(Insurance)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Insurance';
                    RunObject = Page "Insurance List";
                }
                action("Fixed Assets G/L Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed Assets G/L Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(Assets),
                                        Recurring=const(false));
                    ToolTip = 'Post fixed asset transactions, such as acquisition and depreciation, in integration with the general ledger. The FA G/L Journal is a general journal, which is integrated into the general ledger.';
                }
                action("Fixed Assets Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed Assets Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = where(Recurring=const(false));
                    ToolTip = 'Post fixed asset transactions, such as acquisition and depreciation book without integration to the general ledger.';
                }
                action("Fixed Assets Reclass. Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed Assets Reclass. Journals';
                    RunObject = Page "FA Reclass. Journal Batches";
                    ToolTip = 'Transfer, split, or combine fixed assets by preparing reclassification entries to be posted in the fixed asset journal.';
                }
                action("Insurance Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Insurance Journals';
                    RunObject = Page "Insurance Journal Batches";
                }
                action("<Action3>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recurring General Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(General),
                                        Recurring=const(true));
                }
                action("Recurring Fixed Asset Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Recurring Fixed Asset Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = where(Recurring=const(true));
                }
            }
            group("Cash Flow")
            {
                Caption = 'Cash Flow';
                action("Cash Flow Forecasts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cash Flow Forecasts';
                    RunObject = Page "Cash Flow Forecast List";
                    ToolTip = 'Set up cash flow forecasts.';
                }
                action("Chart of Cash Flow Accounts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Chart of Cash Flow Accounts';
                    RunObject = Page "Chart of Cash Flow Accounts";
                    ToolTip = 'Set up the chart of cash flow accounts.';
                }
                action("Cash Flow Manual Revenues")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cash Flow Manual Revenues';
                    RunObject = Page "Cash Flow Manual Revenues";
                    ToolTip = 'Record manual revenues, such as rental income, interest from financial assets, or new private capital.';
                }
                action("Cash Flow Manual Expenses")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cash Flow Manual Expenses';
                    RunObject = Page "Cash Flow Manual Expenses";
                    ToolTip = 'Record manual expenses, such as salaries, interest on credit, or planned investments.';
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                ToolTip = 'View history for sales, shipments, and inventory.';
                action("Posted Sales Invoices")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'View the posted sales invoices.';
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'View the posted sales credit memos.';
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'View the posted purchase invoices.';
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                    ToolTip = 'View the posted purchase credit memos.';
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
                    ApplicationArea = Basic,Suite;
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                    ToolTip = 'View posted G/L entries.';
                }
                action("Posted Deposits")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Deposits';
                    Image = PostedDeposit;
                    RunObject = Page "Posted Deposit List";
                    ToolTip = 'View the posted deposit header, deposit header lines, deposit comments, and deposit dimensions.';
                }
                action("Posted Bank Recs.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Bank Recs.';
                    RunObject = Page "Posted Bank Rec. List";
                    ToolTip = 'View the entries and the balance on your bank accounts against a statement from the bank.';
                }
                action("Bank Statements")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Bank Statements';
                    RunObject = Page "Bank Account Statement List";
                    ToolTip = 'View posted bank statements and reconciliations.';
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;
                action(Currencies)
                {
                    ApplicationArea = Suite;
                    Caption = 'Currencies';
                    Image = Currency;
                    RunObject = Page Currencies;
                    ToolTip = 'View the different currencies that you trade in.';
                }
                action("Accounting Periods")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Accounting Periods';
                    Image = AccountingPeriods;
                    RunObject = Page "Accounting Periods";
                    ToolTip = 'Set up the number of accounting periods, such as 12 monthly periods, within the fiscal year and specify which period is the start of the new fiscal year.';
                }
                action("Number Series")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Number Series';
                    RunObject = Page "No. Series";
                    ToolTip = 'View or edit the number series that are used to organize transactions';
                }
                action("Payment Terms")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Payment Terms';
                    Image = Payment;
                    RunObject = Page "Payment Terms";
                    ToolTip = 'Set up the payment terms that you select from on customer cards to define when the customer must pay, such as within 14 days.';
                }
                action("Analysis Views")
                {
                    ApplicationArea = Basic;
                    Caption = 'Analysis Views';
                    RunObject = Page "Analysis View List";
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
                action(Dimensions)
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page Dimensions;
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                action("Bank Account Posting Groups")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Bank Account Posting Groups';
                    RunObject = Page "Bank Account Posting Groups";
                    ToolTip = 'Set up posting groups, so that payments in and out of each bank account are posted to the specified general ledger account.';
                }
                action("Tax Areas")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tax Areas';
                    RunObject = Page "Tax Area List";
                    ToolTip = 'View a complete or partial list of sales tax areas.';
                }
                action("Tax Jurisdictions")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tax Jurisdictions';
                    RunObject = Page "Tax Jurisdictions";
                    ToolTip = 'View a list of sales tax jurisdictions that you can use to identify tax authorities for sales and purchases tax calculations. This report shows the codes that are associated with a report-to jurisdiction area. Each sales tax area is assigned a tax account for sales and a tax account for purchases. These accounts define the sales tax rates for each sales tax jurisdiction.';
                }
                action("Tax Groups")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tax Groups';
                    RunObject = Page "Tax Groups";
                    ToolTip = 'View a complete or partial list of sales tax groups.';
                }
                action("Tax Details")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tax Details';
                    RunObject = Page "Tax Details";
                    ToolTip = 'View a complete or partial list of all sales tax details. For each jurisdiction, all tax groups with their tax types and effective dates are listed.';
                }
                action("Tax Business Posting Groups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Business Posting Groups';
                    RunObject = Page "VAT Business Posting Groups";
                }
                action("Tax Product Posting Groups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Product Posting Groups';
                    RunObject = Page "VAT Product Posting Groups";
                }
            }
            group("Cash Management")
            {
                Caption = 'Cash Management';
                action(Action1400017)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Bank Account List";
                    ToolTip = 'View or set up your the customers and vendors bank accounts. You can set up any number of bank accounts for each.';
                }
                action(Deposit)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Deposit';
                    Image = DepositSlip;
                    RunObject = Page Deposits;
                    ToolTip = 'Create a new deposit. ';
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
                    Gesture = None;
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
        area(creation)
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
            action("G/L Journal Entry")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'G/L Journal Entry';
                Image = GeneralLedger;
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type"=const(General),
                                    Recurring=const(false));
                ToolTip = 'Prepare to post any transaction to the company books.';
            }
            action("Recurring G/L Entry")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Recurring G/L Entry';
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type"=const(General),
                                    Recurring=const(true));
                ToolTip = 'Prepare to post any recurring transaction to the company books.';
            }
            action("Recurring Payable Entry")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Recurring Payable Entry';
                Image = PaymentJournal;
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type"=const(Purchases),
                                    Recurring=const(true));
                ToolTip = 'Prepare to post any recurring payables transaction to the company books.';
            }
            action(Action1020012)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Deposit';
                Image = DepositSlip;
                RunObject = Page Deposit;
                RunPageMode = Create;
                ToolTip = 'Create a new deposit. ';
            }
        }
        area(processing)
        {
            group(Bank)
            {
                Caption = 'Bank';
                action("Payment Reconciliation Journals")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Payment Reconciliation Journals';
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Pmt. Reconciliation Journals";
                    RunPageMode = View;
                    ToolTip = 'Open the list of journals where you can reconcile unpaid documents automatically with their related bank transactions by importing bank a bank statement feed or file.';
                }
            }
            group(Receivables)
            {
                Caption = 'Receivables';
                action("Cash Receipt Journals")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cash Receipt Journals';
                    Image = CashReceiptJournal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const("Cash Receipts"),
                                        Recurring=const(false));
                    ToolTip = 'Register received payments by applying them to the related customer, vendor, or bank ledger entries.';
                }
            }
            group(Payables)
            {
                Caption = 'Payables';
                action("Payment Journals")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Payment Journals';
                    Image = PaymentJournal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(Payments),
                                        Recurring=const(false));
                    ToolTip = 'Open the list of payment journals where you can register payments to vendors.';
                }
                action("Purchase Journals")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Journals';
                    Image = Purchasing;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(Purchases),
                                        Recurring=const(false));
                    ToolTip = 'Open the list of purchase journals where you can batch post purchase transactions to G/L, bank, customer, vendor and fixed assets accounts.';
                }
                action("Purchase Credit Memos")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Credit Memos';
                    Image = CreditMemo;
                    RunObject = Page "Purchase Credit Memo";
                    ToolTip = 'Open the list of purchase credit memos where you can manage returned items to a vendor.';
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                action("Assisted Setup & Tasks")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Assisted Setup & Tasks';
                    Image = QuestionaireSetup;
                    RunObject = Page "Assisted Setup";
                    ToolTip = 'Set up core functionality such as sales tax, sending documents as email, and approval workflow by running through a few pages that guide you through the information.';
                }
                action("Accounting /Periods")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Accounting /Periods';
                    Image = AccountingPeriods;
                    RunObject = Page "Accounting Periods";
                    ToolTip = 'Set up the number of accounting periods, such as 12 monthly periods, within the fiscal year and specify which period is the start of the new fiscal year.';
                }
                action("General &Ledger Setup")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'General &Ledger Setup';
                    Image = Setup;
                    RunObject = Page "General Ledger Setup";
                    ToolTip = 'Set up your company''s rules';
                }
                action("&Sales && Receivables Setup")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Sales && Receivables Setup';
                    Image = Setup;
                    RunObject = Page "Sales & Receivables Setup";
                    ToolTip = 'Open the Sales & Receivables Setup window.';
                }
                action("&Purchases && Payables Setup")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Purchases && Payables Setup';
                    Image = Setup;
                    RunObject = Page "Purchases & Payables Setup";
                    ToolTip = 'View and edit company policies for purchase invoicing and returns, or set up codes and values used in purchases and payables.';
                }
            }
            group(History)
            {
                Caption = 'History';
                action("Navi&gate")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Navi&gate';
                    Image = Navigate;
                    RunObject = Page Navigate;
                    ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                }
            }
        }
    }
}

