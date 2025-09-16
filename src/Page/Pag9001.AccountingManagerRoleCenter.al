#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9001 "Accounting Manager Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control99;"Finance Performance")
                {
                    Visible = false;
                }
                part(Control1902304208;"Account Manager Activities")
                {
                }
                part(Control1907692008;"My Customers")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control103;"Trailing Sales Orders Chart")
                {
                    Visible = false;
                }
                part(Control106;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control100;"Cash Flow Forecast Chart")
                {
                }
                part(Control1902476008;"My Vendors")
                {
                }
                part(Control108;"Report Inbox Part")
                {
                }
                part(Control1903012608;"Copy Profile")
                {
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
            action("&G/L Trial Balance")
            {
                ApplicationArea = Basic;
                Caption = '&G/L Trial Balance';
                Image = "Report";
                RunObject = Report "Trial Balance";
            }
            action("Chart of Accounts")
            {
                ApplicationArea = Basic;
                Caption = 'Chart of Accounts';
                Image = "Report";
                RunObject = Report "Chart of Accounts";
            }
            action("&Bank Detail Trial Balance")
            {
                ApplicationArea = Basic;
                Caption = '&Bank Detail Trial Balance';
                Image = "Report";
                RunObject = Report "Bank Acc. - Detail Trial Bal.";
            }
            action("Account Schedule Layout")
            {
                ApplicationArea = Basic;
                Caption = 'Account Schedule Layout';
                Image = "Report";
                RunObject = Report "Account Schedule Layout";
            }
            action("&Account Schedule")
            {
                ApplicationArea = Basic;
                Caption = '&Account Schedule';
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
            action(Budget)
            {
                ApplicationArea = Basic;
                Caption = 'Budget';
                Image = "Report";
                RunObject = Report Budget;
            }
            action("Trial Bala&nce/Budget")
            {
                ApplicationArea = Basic;
                Caption = 'Trial Bala&nce/Budget';
                Image = "Report";
                RunObject = Report "Trial Balance/Budget";
            }
            action("Trial Bala&nce, Spread Periods")
            {
                ApplicationArea = Basic;
                Caption = 'Trial Bala&nce, Spread Periods';
                Image = "Report";
                RunObject = Report "Trial Balance, Spread Periods";
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
            action("Trial Balance Detail/Summary")
            {
                ApplicationArea = Basic;
                Caption = 'Trial Balance Detail/Summary';
                Image = "Report";
                RunObject = Report "Trial Balance Detail/Summary";
            }
            action("&Fiscal Year Balance")
            {
                ApplicationArea = Basic;
                Caption = '&Fiscal Year Balance';
                Image = "Report";
                RunObject = Report "Fiscal Year Balance";
            }
            action("Balance Comp. - Prev. Y&ear")
            {
                ApplicationArea = Basic;
                Caption = 'Balance Comp. - Prev. Y&ear';
                Image = "Report";
                RunObject = Report "Balance Comp. - Prev. Year";
            }
            action("&Closing Trial Balance")
            {
                ApplicationArea = Basic;
                Caption = '&Closing Trial Balance';
                Image = "Report";
                RunObject = Report "Closing Trial Balance";
            }
            action("Consol. Trial Balance")
            {
                ApplicationArea = Basic;
                Caption = 'Consol. Trial Balance';
                Image = "Report";
                RunObject = Report "Consolidated Trial Balance";
            }
            separator(Action49)
            {
            }
            action("Cash Flow Date List")
            {
                ApplicationArea = Basic;
                Caption = 'Cash Flow Date List';
                Image = "Report";
                RunObject = Report "Cash Flow Date List";
            }
            separator(Action115)
            {
            }
            action("Aged Accounts &Receivable")
            {
                ApplicationArea = Basic;
                Caption = 'Aged Accounts &Receivable';
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
            action("Projected Cash Receipts")
            {
                ApplicationArea = Basic;
                Caption = 'Projected Cash Receipts';
                Image = "Report";
                RunObject = Report "Projected Cash Receipts";
            }
            action("Cash Requirem. by Due Date")
            {
                ApplicationArea = Basic;
                Caption = 'Cash Requirem. by Due Date';
                Image = "Report";
                RunObject = Report "Cash Requirements by Due Date";
            }
            action("Projected Cash Payments")
            {
                ApplicationArea = Basic;
                Caption = 'Projected Cash Payments';
                Image = PaymentForecast;
                RunObject = Report "Projected Cash Payments";
            }
            action("Reconcile Cust. and Vend. Accs")
            {
                ApplicationArea = Basic;
                Caption = 'Reconcile Cust. and Vend. Accs';
                Image = "Report";
                RunObject = Report "Reconcile Cust. and Vend. Accs";
            }
            action("Daily Invoicing Report")
            {
                ApplicationArea = Basic;
                Caption = 'Daily Invoicing Report';
                Image = "Report";
                RunObject = Report "Daily Invoicing Report";
            }
            action("Bank Account - Reconcile")
            {
                ApplicationArea = Basic;
                Caption = 'Bank Account - Reconcile';
                Image = "Report";
                RunObject = Report "Bank Account - Reconcile";
            }
            separator(Action53)
            {
            }
            separator(Action1480110)
            {
                Caption = 'Sales Tax';
                IsHeader = true;
            }
            action("Intrastat - For&m")
            {
                ApplicationArea = Basic;
                Caption = 'Intrastat - For&m';
                Image = "Report";
                RunObject = Report "Intrastat - Form";
            }
            separator(Action4)
            {
            }
            separator(Action1400022)
            {
            }
            action("Outstanding Purch. Order Aging")
            {
                ApplicationArea = Basic;
                Caption = 'Outstanding Purch. Order Aging';
                Image = "Report";
                RunObject = Report "Outstanding Purch. Order Aging";
            }
            action("Inventory Valuation")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Valuation';
                Image = "Report";
                RunObject = Report "Inventory Valuation";
            }
            action("Item Turnover")
            {
                ApplicationArea = Basic;
                Caption = 'Item Turnover';
                Image = "Report";
                RunObject = Report "Item Turnover";
            }
        }
        area(embedding)
        {
            action(Action2)
            {
                ApplicationArea = Basic;
                Caption = 'Chart of Accounts';
                RunObject = Page "Chart of Accounts";
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
            action("Purchase Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
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
                action(PurchaseJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(Purchases),
                                        Recurring=const(false));
                }
                action(SalesJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(Sales),
                                        Recurring=const(false));
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
                action(Insurance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Insurance';
                    RunObject = Page "Insurance List";
                }
                action("Fixed Assets G/L Journals")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fixed Assets G/L Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(Assets),
                                        Recurring=const(false));
                }
                action("Fixed Assets Journals")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fixed Assets Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = where(Recurring=const(false));
                }
                action("Fixed Assets Reclass. Journals")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fixed Assets Reclass. Journals';
                    RunObject = Page "FA Reclass. Journal Batches";
                }
                action("Insurance Journals")
                {
                    ApplicationArea = Basic;
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
                    ApplicationArea = Basic;
                    Caption = 'Recurring Fixed Asset Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = where(Recurring=const(true));
                }
                action("Asset  Transfer")
                {
                    ApplicationArea = Basic;
                    Caption = 'Asset  Transfer';
                    RunObject = Page "HR Asset Transfer List";
                }
            }
            group(Stores)
            {
                Caption = 'Stores';
                Image = Sales;
                action(Action1000000019)
                {
                    ApplicationArea = Basic;
                    Caption = 'Items';
                    Image = Item;
                    RunObject = Page "Item List";
                }
                action(Action1000000020)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Orders';
                    RunObject = Page "Purchase Order List";
                }
                action("Purchase Return Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Return Orders';
                    RunObject = Page "Purchase Return Order List";
                }
                action("Nonstock Items")
                {
                    ApplicationArea = Basic;
                    Caption = 'Nonstock Items';
                    Image = NonStockItem;
                    RunObject = Page "Catalog Item List";
                }
                action("Purchase Analysis Reports")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Analysis Reports';
                    RunObject = Page "Analysis Report Purchase";
                    RunPageView = where("Analysis Area"=filter(Purchase));
                }
                action("Inventory Analysis Reports")
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory Analysis Reports';
                    RunObject = Page "Analysis Report Inventory";
                    RunPageView = where("Analysis Area"=filter(Inventory));
                }
                action("Item Journals")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Item),
                                        Recurring=const(false));
                }
                action("Transfer Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer Orders';
                    RunObject = Page "Transfer Orders";
                }
                action("Issue Notes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Issue Notes';
                    RunObject = Page "PROC-Store Requisition";
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Good Receipt Notes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Good Receipt Notes';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action(" Posted Issue Notes")
                {
                    ApplicationArea = Basic;
                    Caption = ' Posted Issue Notes';
                    RunObject = Page "PROC-posted Store Req. list";
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
            }
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;
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
                action("Number Series")
                {
                    ApplicationArea = Basic;
                    Caption = 'Number Series';
                    RunObject = Page "No. Series";
                }
                action("Analysis Views")
                {
                    ApplicationArea = Basic;
                    Caption = 'Analysis Views';
                    RunObject = Page "Analysis View List";
                }
                action("Account Schedules")
                {
                    ApplicationArea = Basic;
                    Caption = 'Account Schedules';
                    RunObject = Page "Account Schedule Names";
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
                action("page CAT-Meal Booking List ")
                {
                    ApplicationArea = Basic;
                    Caption = 'Meal Booking List';
                    RunObject = Page "CAT-Meal Booking List";
                }
                action("Stores Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Stores Requisitions';
                    RunObject = Page "PROC-Store Requisition";
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
            action("P&urchase Credit Memo")
            {
                ApplicationArea = Basic;
                Caption = 'P&urchase Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Credit Memo";
                RunPageMode = Create;
            }
            action("Bank Account Reconciliation")
            {
                ApplicationArea = Basic;
                Caption = 'Bank Account Reconciliation';
                Image = BankAccountRec;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Bank Acc. Reconciliation List";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            separator(Action64)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Cas&h Receipt Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Cas&h Receipt Journal';
                Image = CashReceiptJournal;
                RunObject = Page "Cash Receipt Journal";
            }
            action("Pa&yment Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Pa&yment Journal';
                Image = PaymentJournal;
                RunObject = Page "Payment Journal";
            }
            action("Purchase Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Journal';
                Image = Journals;
                RunObject = Page "Purchase Journal";
            }
            action(Deposit)
            {
                ApplicationArea = Basic;
                Caption = 'Deposit';
                Image = DepositSlip;
                RunObject = Page Deposit;
            }
            separator(Action67)
            {
            }
            action("Analysis &Views")
            {
                ApplicationArea = Basic;
                Caption = 'Analysis &Views';
                Image = AnalysisView;
                RunObject = Page "Analysis View List";
            }
            action("Analysis by &Dimensions")
            {
                ApplicationArea = Basic;
                Caption = 'Analysis by &Dimensions';
                Image = AnalysisViewDimension;
                RunObject = Page "Analysis by Dimensions";
            }
            action("Calculate Deprec&iation")
            {
                ApplicationArea = Basic;
                Caption = 'Calculate Deprec&iation';
                Ellipsis = true;
                Image = CalculateDepreciation;
                RunObject = Report "Calculate Depreciation";
            }
            action("Import Co&nsolidation from Database")
            {
                ApplicationArea = Basic;
                Caption = 'Import Co&nsolidation from Database';
                Ellipsis = true;
                Image = ImportDatabase;
                RunObject = Report "Import Consolidation from DB";
            }
            action("Bank Account R&econciliation")
            {
                ApplicationArea = Basic;
                Caption = 'Bank Account R&econciliation';
                Image = BankAccountRec;
                RunObject = Page "Bank Acc. Reconciliation List";
            }
            action("Payment Reconciliation Journals")
            {
                ApplicationArea = Basic;
                Caption = 'Payment Reconciliation Journals';
                Image = ApplyEntries;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Pmt. Reconciliation Journals";
                RunPageMode = View;
            }
            action("Adjust E&xchange Rates")
            {
                ApplicationArea = Basic;
                Caption = 'Adjust E&xchange Rates';
                Ellipsis = true;
                Image = AdjustExchangeRates;
                RunObject = Report "Adjust Exchange Rates";
            }
            action("P&ost Inventory Cost to G/L")
            {
                ApplicationArea = Basic;
                Caption = 'P&ost Inventory Cost to G/L';
                Image = PostInventoryToGL;
                RunObject = Report "Post Inventory Cost to G/L";
            }
            separator(Action97)
            {
            }
            action("C&reate Reminders")
            {
                ApplicationArea = Basic;
                Caption = 'C&reate Reminders';
                Ellipsis = true;
                Image = CreateReminders;
                RunObject = Report "Create Reminders";
            }
            action("Create Finance Charge &Memos")
            {
                ApplicationArea = Basic;
                Caption = 'Create Finance Charge &Memos';
                Ellipsis = true;
                Image = CreateFinanceChargememo;
                RunObject = Report "Create Finance Charge Memos";
            }
            separator(Action73)
            {
            }
            action("Intrastat &Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Intrastat &Journal';
                Image = Journal;
                RunObject = Page "Intrastat Jnl. Batches";
            }
            action("Calc. and Pos&t Tax Settlement")
            {
                ApplicationArea = Basic;
                Caption = 'Calc. and Pos&t Tax Settlement';
                Image = SettleOpenTransactions;
                RunObject = Report "Calc. and Post VAT Settlement";
            }
            separator(Action80)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("General &Ledger Setup")
            {
                ApplicationArea = Basic;
                Caption = 'General &Ledger Setup';
                Image = Setup;
                RunObject = Page "General Ledger Setup";
            }
            action("&Sales && Receivables Setup")
            {
                ApplicationArea = Basic;
                Caption = '&Sales && Receivables Setup';
                Image = Setup;
                RunObject = Page "Sales & Receivables Setup";
            }
            action("&Purchases && Payables Setup")
            {
                ApplicationArea = Basic;
                Caption = '&Purchases && Payables Setup';
                Image = Setup;
                RunObject = Page "Purchases & Payables Setup";
            }
            action("&Fixed Asset Setup")
            {
                ApplicationArea = Basic;
                Caption = '&Fixed Asset Setup';
                Image = Setup;
                RunObject = Page "Fixed Asset Setup";
            }
            action("Cash Flow Setup")
            {
                ApplicationArea = Basic;
                Caption = 'Cash Flow Setup';
                Image = CashFlowSetup;
                RunObject = Page "Cash Flow Setup";
            }
            action("Cost Accounting Setup")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Accounting Setup';
                Image = CostAccountingSetup;
                RunObject = Page "Cost Accounting Setup";
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
            action("Export GIFI Info. to Excel")
            {
                ApplicationArea = Basic;
                Caption = 'Export GIFI Info. to Excel';
                Image = ExportToExcel;
                RunObject = Report "Export GIFI Info. to Excel";
            }
            group("POS Reports")
            {
                Caption = 'POS Reports';
                action(Action1000000021)
                {
                    ApplicationArea = Basic;
                    Caption = 'POS Reports';
                    Image = Agreement;
                    RunObject = Page "POS Sales Reports";
                }
                action("NEW SPOS Rolecenter")
                {
                    ApplicationArea = Basic;
                    Caption = 'New POS';
                    Image = AddToHome;
                    RunObject = Page "NEW SPOS Rolecenter";
                }
            }
        }
    }
}

