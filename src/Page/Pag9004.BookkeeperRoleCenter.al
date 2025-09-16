#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9004 "Bookkeeper Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1901197008;"Bookkeeper Activities")
                {
                }
                part(Control1907692008;"My Customers")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control17;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control1902476008;"My Vendors")
                {
                }
                part(Control18;"Report Inbox Part")
                {
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
            action("Chart of Accounts")
            {
                ApplicationArea = Basic;
                Caption = 'Chart of Accounts';
                RunObject = Report "Chart of Accounts";
            }
            action("G/L Register")
            {
                ApplicationArea = Basic;
                Caption = 'G/L Register';
                Image = GLRegisters;
                RunObject = Report "G/L Register";
            }
            group("&Trial Balance")
            {
                Caption = '&Trial Balance';
                Image = Balance;
                action("Trial Balance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Trial Balance';
                    Image = "Report";
                    RunObject = Report "Trial Balance";
                }
                action("Bank &Detail Trial Balance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank &Detail Trial Balance';
                    Image = "Report";
                    RunObject = Report "Bank Acc. - Detail Trial Bal.";
                }
                action("T&rial Balance/Budget")
                {
                    ApplicationArea = Basic;
                    Caption = 'T&rial Balance/Budget';
                    Image = "Report";
                    RunObject = Report "Trial Balance/Budget";
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
                action("Closing Trial Balance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Closing Trial Balance';
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
            }
            action("&Fiscal Year Balance")
            {
                ApplicationArea = Basic;
                Caption = '&Fiscal Year Balance';
                Image = "Report";
                RunObject = Report "Fiscal Year Balance";
            }
            action("Balance C&omp. . Prev. Year")
            {
                ApplicationArea = Basic;
                Caption = 'Balance C&omp. . Prev. Year';
                Image = "Report";
                RunObject = Report "Balance Comp. - Prev. Year";
            }
            separator(Action44)
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
            separator(Action49)
            {
            }
            action("Aged Accounts Receivable")
            {
                ApplicationArea = Basic;
                Caption = 'Aged Accounts Receivable';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
            }
            action("Aged Accou&nts Payable")
            {
                ApplicationArea = Basic;
                Caption = 'Aged Accou&nts Payable';
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
            action("Bank Account - Reconcile")
            {
                ApplicationArea = Basic;
                Caption = 'Bank Account - Reconcile';
                Image = "Report";
                RunObject = Report "Bank Account - Reconcile";
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
            separator(Action1400017)
            {
            }
            action("Inventory Valuation")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Valuation';
                Image = "Report";
                RunObject = Report "Inventory Valuation";
            }
        }
        area(embedding)
        {
            ToolTip = 'Collect and make payments, prepare statements, and manage reminders.';
            action(Action2)
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
            action(VendorsPaymentonHold)
            {
                ApplicationArea = Basic;
                Caption = 'Payment on Hold';
                RunObject = Page "Vendor List";
                RunPageView = where(Blocked=filter(Payment));
            }
            action("VAT Statements")
            {
                ApplicationArea = Basic;
                Caption = 'VAT Statements';
                RunObject = Page "VAT Statement Names";
            }
            action("Purchase Invoices")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Invoices';
                RunObject = Page "Purchase Invoices";
            }
            action("Purchase Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action("Sales Invoices")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page "Sales Invoice List";
            }
            action("Sales Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
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
            action(RecurringGeneralJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Recurring General Journals';
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type"=const(General),
                                    Recurring=const(true));
            }
            action("Intrastat Journals")
            {
                ApplicationArea = Basic;
                Caption = 'Intrastat Journals';
                RunObject = Page "Intrastat Jnl. Batches";
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                ToolTip = 'View posted invoices and credit memos, and analyze G/L registers.';
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
                action("Posted Return Shipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
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
                action("Issued Fi. Charge Memos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Issued Fi. Charge Memos';
                    RunObject = Page "Issued Fin. Charge Memo List";
                }
                action("G/L Registers")
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                }
                action("Posted Deposit List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Deposit List';
                    RunObject = Page "Posted Deposit List";
                }
                action("Posted Bank Rec. List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Bank Rec. List';
                    RunObject = Page "Posted Bank Rec. List";
                }
                action("Bank Statements")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Statements';
                    RunObject = Page "Bank Account Statement List";
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
                action(Action1400001)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Bank Account List";
                }
                action(Deposit)
                {
                    ApplicationArea = Basic;
                    Caption = 'Deposit';
                    Image = DepositSlip;
                    RunObject = Page Deposits;
                }
                action("Bank Rec.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Rec.';
                    RunObject = Page "Bank Acc. Reconciliation List";
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
            separator(Action554)
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
            action("&Purchase Invoice")
            {
                ApplicationArea = Basic;
                Caption = '&Purchase Invoice';
                Image = NewPurchaseInvoice;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Invoice";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            separator(Action67)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Cash Re&ceipt Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Cash Re&ceipt Journal';
                Image = CashReceiptJournal;
                RunObject = Page "Cash Receipt Journal";
            }
            action("Payment &Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Payment &Journal';
                Image = PaymentJournal;
                RunObject = Page "Payment Journal";
            }
            separator(Action77)
            {
            }
            action("Bank Account Reconciliations")
            {
                ApplicationArea = Basic;
                Caption = 'Bank Account Reconciliations';
                Image = BankAccountRec;
                RunObject = Page "Bank Acc. Reconciliation List";
            }
            action("Adjust E&xchange Rates")
            {
                ApplicationArea = Basic;
                Caption = 'Adjust E&xchange Rates';
                Ellipsis = true;
                Image = AdjustExchangeRates;
                RunObject = Report "Adjust Exchange Rates";
            }
            action("Reconcile AP to GL")
            {
                ApplicationArea = Basic;
                Caption = 'Reconcile AP to GL';
                Image = "Report";
                RunObject = Report "Reconcile AP to GL";
            }
            action("Post Inventor&y Cost to G/L")
            {
                ApplicationArea = Basic;
                Caption = 'Post Inventor&y Cost to G/L';
                Ellipsis = true;
                Image = PostInventoryToGL;
                RunObject = Report "Post Inventory Cost to G/L";
            }
            action("Calc. and Pos&t Tax Settlement")
            {
                ApplicationArea = Basic;
                Caption = 'Calc. and Pos&t Tax Settlement';
                Ellipsis = true;
                Image = SettleOpenTransactions;
                RunObject = Report "Calc. and Post VAT Settlement";
            }
            separator(Action84)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("General Ledger Setup")
            {
                ApplicationArea = Basic;
                Caption = 'General Ledger Setup';
                Image = Setup;
                RunObject = Page "General Ledger Setup";
            }
            action("Sa&les && Receivables Setup")
            {
                ApplicationArea = Basic;
                Caption = 'Sa&les && Receivables Setup';
                Image = Setup;
                RunObject = Page "Sales & Receivables Setup";
            }
            action("Inventory to G/L Reconcile")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory to G/L Reconcile';
                RunObject = Report "Inventory to G/L Reconcile";
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
                RunObject = Report "Export GIFI Info. to Excel";
            }
            action(Action21)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                RunObject = Page "Requests to Approve";
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';
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
            group(ActionGroup22)
            {
                Caption = 'Approvals';
                ToolTip = 'Request approval of your documents, cards, or journal lines or, as the approver, approve requests made by other users.';
                action("Requests Sent for Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Requests Sent for Approval';
                    Image = Approvals;
                    RunObject = Page "Approval Entries";
                    RunPageView = sorting("Record ID to Approve","Workflow Step Instance ID","Sequence No.")
                                  order(ascending)
                                  where(Status=filter(Open));
                }
                action(RequestsToApprove)
                {
                    ApplicationArea = Basic;
                    Caption = 'Requests to Approve';
                    Image = Approvals;
                    RunObject = Page "Requests to Approve";
                }
            }
            action("Payment Registration")
            {
                ApplicationArea = Basic;
                Caption = 'Payment Registration';
                Image = Payment;
                RunObject = Page "Payment Registration";
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
        }
    }
}

