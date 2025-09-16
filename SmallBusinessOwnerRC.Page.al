#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9020 "Small Business Owner RC"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control78;"Small Business Owner Act.")
                {
                }
                part(Control24;"Copy Profile")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control69;"Finance Performance")
                {
                }
                part(Control66;"Finance Performance")
                {
                    Visible = false;
                }
                part(Control70;"Sales Performance")
                {
                }
                part(Control68;"Sales Performance")
                {
                    Visible = false;
                }
                part(Control2;"Trailing Sales Orders Chart")
                {
                    Visible = false;
                }
                part(Control12;"Report Inbox Part")
                {
                }
                part(Control1907692008;"My Customers")
                {
                    Visible = false;
                }
                part(Control1902476008;"My Vendors")
                {
                    Visible = false;
                }
                part(Control99;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control1905989608;"My Items")
                {
                    Visible = false;
                }
                systempart(Control67;MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Customer Statement")
            {
                ApplicationArea = Basic;
                Caption = 'Customer Statement';
                RunObject = Report "Customer Statement";
            }
            separator(Action61)
            {
            }
            action("Customer - Order Su&mmary")
            {
                ApplicationArea = Basic;
                Caption = 'Customer - Order Su&mmary';
                Image = "Report";
                RunObject = Report "Customer - Order Summary";
            }
            action("Customer - T&op 10 List")
            {
                ApplicationArea = Basic;
                Caption = 'Customer - T&op 10 List';
                Image = "Report";
                RunObject = Report "Customer - Top 10 List";
            }
            action("Customer/Item Statistics")
            {
                ApplicationArea = Basic;
                Caption = 'Customer/Item Statistics';
                RunObject = Report "Customer/Item Statistics";
            }
            separator(Action75)
            {
            }
            action("Salesperson Statistics by Inv.")
            {
                ApplicationArea = Basic;
                Caption = 'Salesperson Statistics by Inv.';
                RunObject = Report "Salesperson Statistics by Inv.";
            }
            action("List Price Sheet")
            {
                ApplicationArea = Basic;
                Caption = 'List Price Sheet';
                RunObject = Report "List Price Sheet";
            }
            separator(Action93)
            {
            }
            action("Inventory - Sales &Back Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - Sales &Back Orders';
                Image = "Report";
                RunObject = Report "Inventory - Sales Back Orders";
            }
            separator(Action129)
            {
            }
            action("Trial Balance")
            {
                ApplicationArea = Basic;
                Caption = 'Trial Balance';
                Image = "Report";
                RunObject = Report "Trial Balance";
            }
            action("Trial Balance by &Period")
            {
                ApplicationArea = Basic;
                Caption = 'Trial Balance by &Period';
                Image = "Report";
                RunObject = Report "Trial Balance by Period";
            }
            action("Trial Balance, Spread Periods")
            {
                ApplicationArea = Basic;
                Caption = 'Trial Balance, Spread Periods';
                Image = "Report";
                RunObject = Report "Trial Balance, Spread Periods";
            }
            action("Consol. Trial Balance")
            {
                ApplicationArea = Basic;
                Caption = 'Consol. Trial Balance';
                Image = "Report";
                RunObject = Report "Consolidated Trial Balance";
            }
            action("Trial Balance Detail/Summary")
            {
                ApplicationArea = Basic;
                Caption = 'Trial Balance Detail/Summary';
                Image = "Report";
                RunObject = Report "Trial Balance Detail/Summary";
            }
            action("Trial Balance, per Global Dim.")
            {
                ApplicationArea = Basic;
                Caption = 'Trial Balance, per Global Dim.';
                Image = "Report";
                RunObject = Report "Trial Balance, per Global Dim.";
            }
            action("Trial Balance, Spread G. Dim.")
            {
                ApplicationArea = Basic;
                Caption = 'Trial Balance, Spread G. Dim.';
                Image = "Report";
                RunObject = Report "Trial Balance, Spread G. Dim.";
            }
            action("Closing T&rial Balance")
            {
                ApplicationArea = Basic;
                Caption = 'Closing T&rial Balance';
                Image = "Report";
                RunObject = Report "Closing Trial Balance";
            }
            separator(Action49)
            {
            }
            action("Aged Ac&counts Receivable")
            {
                ApplicationArea = Basic;
                Caption = 'Aged Ac&counts Receivable';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
            }
            action("Aged Accounts Pa&yable")
            {
                ApplicationArea = Basic;
                Caption = 'Aged Accounts Pa&yable';
                Image = "Report";
                RunObject = Report "Aged Accounts Payable";
            }
            action("Reconcile Cust. and &Vend. Accs")
            {
                ApplicationArea = Basic;
                Caption = 'Reconcile Cust. and &Vend. Accs';
                Image = "Report";
                RunObject = Report "Reconcile Cust. and Vend. Accs";
            }
            separator(Action53)
            {
            }
            action("Account Schedule Layout")
            {
                ApplicationArea = Basic;
                Caption = 'Account Schedule Layout';
                Image = "Report";
                RunObject = Report "Account Schedule Layout";
            }
            action("Account Schedule")
            {
                ApplicationArea = Basic;
                Caption = 'Account Schedule';
                Image = "Report";
                RunObject = Report "Account Schedule";
            }
            action("Account Balances by GIFI Code")
            {
                ApplicationArea = Basic;
                Caption = 'Account Balances by GIFI Code';
                Image = "Report";
                RunObject = Report "Account Balances by GIFI Code";
            }
            separator(Action1480005)
            {
            }
            action("Sales Tax Details")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Tax Details';
                Image = "Report";
                RunObject = Report "Sales Tax Detail List";
            }
            action("Sales Tax Groups")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Tax Groups';
                Image = "Report";
                RunObject = Report "Sales Tax Group List";
            }
            action("Sales Tax Jurisdictions")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Tax Jurisdictions';
                Image = "Report";
                RunObject = Report "Sales Tax Jurisdiction List";
            }
            action("Sales Tax Areas")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Tax Areas';
                Image = "Report";
                RunObject = Report "Sales Tax Area List";
            }
            action("Sales Tax Detail by Area")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Tax Detail by Area';
                Image = "Report";
                RunObject = Report "Sales Tax Detail by Area";
            }
            action("Sales Taxes Collected")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Taxes Collected';
                Image = "Report";
                RunObject = Report "Sales Taxes Collected";
            }
            action("VAT Statement")
            {
                ApplicationArea = Basic;
                Caption = 'VAT Statement';
                Image = "Report";
                RunObject = Report "VAT Statement";
            }
        }
        area(embedding)
        {
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
            action("Sales Order Shipment")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Order Shipment';
                RunObject = Page "Sales Order Shipment List";
            }
            action("Sales Order Invoice")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Order Invoice';
                RunObject = Page "Sales Order Invoice List";
            }
            action("Dynamics CRM Sales Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Dynamics CRM Sales Orders';
                RunObject = Page "CRM Sales Order List";
                RunPageView = where(StateCode=filter(Submitted),
                                    LastBackofficeSubmit=filter(''));
            }
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
            action("Purchase Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
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
            action(Items)
            {
                ApplicationArea = Basic;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
        }
        area(sections)
        {
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                action(ItemJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Item),
                                        Recurring=const(false));
                }
                action(PhysicalInventoryJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Physical Inventory Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const("Phys. Inventory"),
                                        Recurring=const(false));
                }
                action(RevaluationJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Revaluation Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Revaluation),
                                        Recurring=const(false));
                }
                action("Resource Journals")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Journals';
                    RunObject = Page "Resource Jnl. Batches";
                    RunPageView = where(Recurring=const(false));
                }
                action("FA Journals")
                {
                    ApplicationArea = Basic;
                    Caption = 'FA Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = where(Recurring=const(false));
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
                action(RecurringJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Recurring Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(General),
                                        Recurring=const(true));
                }
            }
            group(Worksheets)
            {
                Caption = 'Worksheets';
                Image = Worksheets;
                action("Requisition Worksheets")
                {
                    ApplicationArea = Basic;
                    Caption = 'Requisition Worksheets';
                    RunObject = Page "Req. Wksh. Names";
                    RunPageView = where("Template Type"=const("Req."),
                                        Recurring=const(false));
                }
            }
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
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                }
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
            group(Finance)
            {
                Caption = 'Finance';
                Image = Bank;
                action("VAT Statements")
                {
                    ApplicationArea = Basic;
                    Caption = 'VAT Statements';
                    RunObject = Page "VAT Statement Names";
                }
                action("Chart of Accounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Chart of Accounts';
                    RunObject = Page "Chart of Accounts";
                }
                action("Bank Accounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Bank Account List";
                }
                action(Currencies)
                {
                    ApplicationArea = Basic;
                    Caption = 'Currencies';
                    Image = Currency;
                    RunObject = Page Currencies;
                }
                action("Accounting Periods")
                {
                    ApplicationArea = Basic;
                    Caption = 'Accounting Periods';
                    Image = AccountingPeriods;
                    RunObject = Page "Accounting Periods";
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page Dimensions;
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                action("Bank Account Posting Groups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Account Posting Groups';
                    RunObject = Page "Bank Account Posting Groups";
                }
            }
            group(Marketing)
            {
                Caption = 'Marketing';
                Image = Marketing;
                action(Contacts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Contacts';
                    Image = CustomerContact;
                    RunObject = Page "Contact List";
                }
                action("To-dos")
                {
                    ApplicationArea = Basic;
                    Caption = 'To-dos';
                    Image = TaskList;
                    RunObject = Page "Task List";
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                Image = Sales;
                action("Assembly BOM")
                {
                    ApplicationArea = Basic;
                    Caption = 'Assembly BOM';
                    Image = AssemblyBOM;
                    RunObject = Page "Assembly BOM";
                }
                action("Sales Credit Memos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Credit Memos';
                    RunObject = Page "Sales Credit Memos";
                }
                action("Standard Sales Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Standard Sales Codes';
                    RunObject = Page "Standard Sales Codes";
                }
                action("Salespeople/Purchasers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Salespeople/Purchasers';
                    RunObject = Page "Salespersons/Purchasers";
                }
                action("Customer Invoice Discount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Invoice Discount';
                    RunObject = Page "Cust. Invoice Discounts";
                }
            }
            group(Purchasing)
            {
                Caption = 'Purchasing';
                Image = Purchasing;
                action("Standard Purchase Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Standard Purchase Codes';
                    RunObject = Page "Standard Purchase Codes";
                }
                action("Vendor Invoice Discounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor Invoice Discounts';
                    RunObject = Page "Vend. Invoice Discounts";
                }
                action("Item Discount Groups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Discount Groups';
                    RunObject = Page "Item Disc. Groups";
                }
            }
            group(Resources)
            {
                Caption = 'Resources';
                Image = ResourcePlanning;
                action(Action126)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resources';
                    RunObject = Page "Resource List";
                }
                action("Resource Groups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Groups';
                    RunObject = Page "Resource Groups";
                }
                action("Resource Price Changes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Price Changes';
                    Image = ResourcePrice;
                    RunObject = Page "Resource Price Changes";
                }
                action("Resource Registers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Registers';
                    Image = ResourceRegisters;
                    RunObject = Page "Resource Registers";
                }
            }
            group("Human Resources")
            {
                Caption = 'Human Resources';
                Image = HumanResources;
                action(Employees)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employees';
                    Image = Employee;
                    RunObject = Page "Employee List";
                }
                action("Absence Registration")
                {
                    ApplicationArea = Basic;
                    Caption = 'Absence Registration';
                    Image = AbsenceCalendar;
                    RunObject = Page "Absence Registration";
                }
            }
            group("Fixed Assets")
            {
                Caption = 'Fixed Assets';
                Image = FixedAssets;
                action(Action17)
                {
                    ApplicationArea = Basic;
                    Caption = 'Fixed Assets';
                    RunObject = Page "Fixed Asset List";
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;
                action("User Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'User Setup';
                    Image = UserSetup;
                    RunObject = Page "User Setup";
                }
                action("Data Templates List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Data Templates List';
                    RunObject = Page "Config. Template List";
                }
                action("Base Calendar List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Base Calendar List';
                    RunObject = Page "Base Calendar List";
                }
                action("ZIP Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'ZIP Codes';
                    RunObject = Page "Post Codes";
                }
                action("Reason Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reason Codes';
                    RunObject = Page "Reason Codes";
                }
                action("Extended Text")
                {
                    ApplicationArea = Basic;
                    Caption = 'Extended Text';
                    Image = Text;
                    RunObject = Page "Extended Text List";
                }
                action("IRS 1099 Form-Box")
                {
                    ApplicationArea = Basic;
                    Caption = 'IRS 1099 Form-Box';
                    Image = "1099Form";
                    RunObject = Page "IRS 1099 Form-Box";
                }
                action("GIFI Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'GIFI Codes';
                    RunObject = Page "GIFI Codes";
                }
                action("Tax Areas")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Areas';
                    RunObject = Page "Tax Area List";
                }
                action("Tax Jurisdictions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Jurisdictions';
                    RunObject = Page "Tax Jurisdictions";
                }
                action("Tax Groups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Groups';
                    RunObject = Page "Tax Groups";
                }
                action("Tax Details")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Details';
                    RunObject = Page "Tax Details";
                }
                action("Tax  Business Posting Groups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax  Business Posting Groups';
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
                action("Deposits to Post")
                {
                    ApplicationArea = Basic;
                    Caption = 'Deposits to Post';
                    RunObject = Page Deposits;
                }
                action("Bank Rec. to Post")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Rec. to Post';
                    RunObject = Page "Bank Acc. Reconciliation List";
                }
            }
        }
        area(creation)
        {
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
            action("Sales Credit &Memo")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Credit &Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Credit Memo";
                RunPageMode = Create;
            }
            action("&Sales Reminder")
            {
                ApplicationArea = Basic;
                Caption = '&Sales Reminder';
                Image = Reminder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page Reminder;
                RunPageMode = Create;
            }
            action(Deposit)
            {
                ApplicationArea = Basic;
                Caption = 'Deposit';
                Image = DepositSlip;
                RunObject = Page Deposit;
            }
            separator(Action5)
            {
            }
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
        }
        area(processing)
        {
            separator(Action13)
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
            action("Vendor Pa&yment Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor Pa&yment Journal';
                Image = VendorPaymentJournal;
                RunObject = Page "Payment Journal";
            }
            action("Purchase Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Journal';
                Image = Journals;
                RunObject = Page "Purchase Journal";
            }
            action("Sales Price &Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Price &Worksheet';
                Image = PriceWorksheet;
                RunObject = Page "Sales Price Worksheet";
            }
            action("Sales P&rices")
            {
                ApplicationArea = Basic;
                Caption = 'Sales P&rices';
                Image = SalesPrices;
                RunObject = Page "Sales Prices";
            }
            action("Sales &Line Discounts")
            {
                ApplicationArea = Basic;
                Caption = 'Sales &Line Discounts';
                Image = SalesLineDisc;
                RunObject = Page "Sales Line Discounts";
            }
            separator(Action19)
            {
            }
            action("&Bank Account Reconciliation")
            {
                ApplicationArea = Basic;
                Caption = '&Bank Account Reconciliation';
                Image = BankAccountRec;
                RunObject = Page "Bank Acc. Reconciliation List";
            }
            action("Payment Registration")
            {
                ApplicationArea = Basic;
                Caption = 'Payment Registration';
                Image = Payment;
                RunObject = Codeunit "Payment Registration Mgt.";
            }
            action("Adjust E&xchange Rates")
            {
                ApplicationArea = Basic;
                Caption = 'Adjust E&xchange Rates';
                Ellipsis = true;
                Image = AdjustExchangeRates;
                RunObject = Report "Adjust Exchange Rates";
            }
            action("Adjust &Item Costs/Prices")
            {
                ApplicationArea = Basic;
                Caption = 'Adjust &Item Costs/Prices';
                Image = AdjustItemCost;
                RunObject = Report "Adjust Item Costs/Prices";
            }
            action("Adjust &Cost - Item Entries")
            {
                ApplicationArea = Basic;
                Caption = 'Adjust &Cost - Item Entries';
                Image = AdjustEntries;
                RunObject = Report "Adjust Cost - Item Entries";
            }
            action("Post Inve&ntory Cost to G/L")
            {
                ApplicationArea = Basic;
                Caption = 'Post Inve&ntory Cost to G/L';
                Ellipsis = true;
                Image = PostInventoryToGL;
                RunObject = Report "Post Inventory Cost to G/L";
            }
            action("Calc. and Post Tax Settlem&ent")
            {
                ApplicationArea = Basic;
                Caption = 'Calc. and Post Tax Settlem&ent';
                Ellipsis = true;
                Image = SettleOpenTransactions;
                RunObject = Report "Calc. and Post VAT Settlement";
            }
            separator(Action31)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("General Le&dger Setup")
            {
                ApplicationArea = Basic;
                Caption = 'General Le&dger Setup';
                Image = Setup;
                RunObject = Page "General Ledger Setup";
            }
            action("S&ales && Receivables Setup")
            {
                ApplicationArea = Basic;
                Caption = 'S&ales && Receivables Setup';
                Image = Setup;
                RunObject = Page "Sales & Receivables Setup";
            }
            separator(Action41)
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
            action("Export GIFI Info. to Excel")
            {
                ApplicationArea = Basic;
                Caption = 'Export GIFI Info. to Excel';
                Image = ExportToExcel;
                RunObject = Report "Export GIFI Info. to Excel";
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
                Visible = false;
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

