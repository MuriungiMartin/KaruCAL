#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70071 "Finance Manager Role Center"
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
            group("Finance reports")
            {
                Caption = 'Finance reports';
                action("Student Balances")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Balances';
                    RunObject = Report "ACA-Student Balances";
                }
                action("Statement 1")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statement 1';
                    RunObject = Report Statement;
                }
                action("Statement 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statement 2';
                    RunObject = Report "Customer Balance";
                }
                action("Stud. List With Balances")
                {
                    ApplicationArea = Basic;
                    Caption = 'Stud. List With Balances';
                    RunObject = Report UnknownReport51258;
                }
                action("Fee Collection")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fee Collection';
                    RunObject = Report "Fee Collection";
                }
                action("Fee Receipt")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fee Receipt';
                    RunObject = Report "Student Receipts";
                }
                action("Student List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student List';
                    RunObject = Report "stud list";
                }
            }
            group("Receipts Reports")
            {
                Caption = 'Receipts Reports';
                action("Cashier Transactions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cashier Transactions';
                    RunObject = Report "Cashier Transactions";
                }
                action("Receipt Entries By User")
                {
                    ApplicationArea = Basic;
                    Caption = 'Receipt Entries By User';
                    RunObject = Report "Receipts Entries - By Users";
                }
            }
            group(Reports2)
            {
                Caption = 'Payroll Reports';
                Image = Payables;
                action("Master Payroll Summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Master Payroll Summary';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Company Payroll Summary 3";
                }
                action("Deductions Summary 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Deductions Summary 2';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Deductions Summary 2";
                }
                action("Earnings Summary 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Earnings Summary 2';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Payments Summary 2";
                }
                action("Earnings Summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Earnings Summary';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Earnings Summary";
                }
                action("Staff pension")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff pension';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "Staff Pension Report";
                }
                action("Gross Netpay")
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Netpay';
                    Image = "Report";
                    RunObject = Report prGrossNetPay;
                }
                action("Third Rule")
                {
                    ApplicationArea = Basic;
                    Caption = 'Third Rule';
                    Image = "Report";
                    RunObject = Report "A third Rule Report";
                }
                action("P9 Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'P9 Report';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "P9 Report (Final)";
                }
                action("Co_op Remittance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co_op Remittance';
                    Image = "Report";
                    RunObject = Report "prCoop remmitance";
                }
                action(Transactions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transactions';
                    Image = "Report";
                    RunObject = Report "pr Transactions";
                }
                action("bank Schedule")
                {
                    ApplicationArea = Basic;
                    Caption = 'bank Schedule';
                    Image = "Report";
                    RunObject = Report "pr Bank Schedule";
                }
            }
            group(StudClearance)
            {
                Caption = 'Student Clearance Reports';
                Image = Payables;
                action("Clearance Reports")
                {
                    ApplicationArea = Basic;
                    Caption = 'Clearance Reports';
                    RunObject = Report "ACA-Student Clearance List";
                }
                action("Clearance Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Clearance Report';
                    RunObject = Report "ACA-Student Clearance List";
                }
            }
            action("<XMLport Import Bank details")
            {
                ApplicationArea = Basic;
                Caption = 'Import Bank details';
                RunObject = XMLport "Import Bank details";
                Visible = false;
            }
            action("Import Employee Transactions")
            {
                ApplicationArea = Basic;
                Caption = 'Import Employee Transactions';
                RunObject = XMLport "Import payroll transactions";
            }
            group(Payroll_Setups)
            {
                Caption = 'Payroll Setups';
                Image = HRSetup;
                action("Payroll Period")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Period';
                    Image = Period;
                    RunObject = Page "PRL-Payroll Periods";
                }
                action("Pr Rates")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pr Rates';
                    Image = SetupColumns;
                    Promoted = true;
                    RunObject = Page "PRL-Rates & Ceilings";
                }
                action("paye Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'paye Setup';
                    Image = SetupPayment;
                    Promoted = true;
                    RunObject = Page "PRL-P.A.Y.E Setup";
                }
                action("Transcation Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transcation Codes';
                    Image = Setup;
                    Promoted = true;
                    RunObject = Page "PRL-Transaction Codes List";
                }
                action("NHIF Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'NHIF Setup';
                    Image = SetupLines;
                    Promoted = true;
                    RunObject = Page "PRL-NHIF SetUp";
                }
                action("Hr Employee Card")
                {
                    ApplicationArea = Basic;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "HRM-Employee (C)";
                }
                action("Bank Structure")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Structure';
                    Image = Bank;
                    Promoted = true;
                    RunObject = Page "PRL-Bank Structure (B)";
                }
                action("control information")
                {
                    ApplicationArea = Basic;
                    Caption = 'control information';
                    Image = CompanyInformation;
                    Promoted = true;
                    RunObject = Page "GEN-Control-Information";
                }
                action("Salary Grades")
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary Grades';
                    Image = EmployeeAgreement;
                    Promoted = true;
                    RunObject = Page "PRL-Salary Grades";
                }
                action("posting group")
                {
                    ApplicationArea = Basic;
                    Caption = 'posting group';
                    Image = PostingEntries;
                    Promoted = true;
                    RunObject = Page "PRL-Employee Posting Group";
                }
                action("Salary Increament Process")
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary Increament Process';
                    Image = AddAction;
                    Promoted = true;
                    RunObject = Page "HRM-Emp. Categories";
                }
                action("Salary Increament Register")
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary Increament Register';
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "HRM-Salary Increament Register";
                }
                action("Un-Afected Salary Increaments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Un-Afected Salary Increaments';
                    Image = UndoCategory;
                    Promoted = true;
                    RunObject = Page "HRM-Unaffected Sal. Increament";
                }
                action(" payment Vouchers")
                {
                    ApplicationArea = Basic;
                    Caption = ' payment Vouchers';
                    RunObject = Page "FIN-Payment Vouchers";
                }
            }
            group(PayRepts2)
            {
                Caption = 'Payroll Reports';
                Image = ResourcePlanning;
                action("Detailed Payroll Summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Detailed Payroll Summary';
                    Image = Report2;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Payroll Summary 3";
                }
                action("Departmental Summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Departmental Summary';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Payroll Summary Depts.";
                }
                action(Action1000000045)
                {
                    ApplicationArea = Basic;
                    Caption = 'Master Payroll Summary';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Company Payroll Summary 3";
                }
                action(Action1000000046)
                {
                    ApplicationArea = Basic;
                    Caption = 'Earnings Summary';
                    Image = DepositSlip;
                    RunObject = Report "PRL-Earnings Summary";
                }
                action(Action1000000043)
                {
                    ApplicationArea = Basic;
                    Caption = 'Deductions Summary 2';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Deductions Summary 2";
                }
                action(Action1000000044)
                {
                    ApplicationArea = Basic;
                    Caption = 'Earnings Summary 2';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Payments Summary 2";
                }
                action(Action1000000041)
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff pension';
                    Image = Aging;
                    RunObject = Report "Staff Pension Report";
                }
                action("Staff Provident Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Provident Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "prStaff Providence Contrib";
                }
                action("<Report prDeductions Variance>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Deductions Variance Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "PRL-Payroll Variance Report";
                }
                action(Action1000000040)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Netpay';
                    Image = Giro;
                    RunObject = Report prGrossNetPay;
                }
                action("Company Payslip")
                {
                    ApplicationArea = Basic;
                    Caption = 'Company Payslip';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "PRL-Company Payslip";
                }
            }
            group(PayrollPeoro)
            {
                Caption = 'Periodic Reports';
                Image = RegisteredDocs;
                action(Action1000000035)
                {
                    ApplicationArea = Basic;
                    Caption = 'P9 Report';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "P9 Report (Final)";
                }
                action(Action1000000036)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transactions';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "pr Transactions";
                }
                action(Action1000000033)
                {
                    ApplicationArea = Basic;
                    Caption = 'bank Schedule';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "pr Bank Schedule";
                }
                action("Employer Certificate")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employer Certificate';
                    Image = "report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Employer Certificate P.10 mst";
                }
                action("P.10")
                {
                    ApplicationArea = Basic;
                    Caption = 'P.10';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "P.10 A mst";
                }
                action(Action1000000032)
                {
                    ApplicationArea = Basic;
                    Caption = 'Third Rule';
                    Image = AddWatch;
                    RunObject = Report "A third Rule Report";
                }
                action(Action1000000029)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co_op Remittance';
                    Image = CreateForm;
                    RunObject = Report "prCoop remmitance";
                }
                action("payroll Journal Transfer")
                {
                    ApplicationArea = Basic;
                    Caption = 'payroll Journal Transfer';
                    Image = Journals;
                    Promoted = true;
                    RunObject = Report prPayrollJournalTransfer;
                }
                action("mass update Transactions")
                {
                    ApplicationArea = Basic;
                    Caption = 'mass update Transactions';
                    Image = PostBatch;
                    Promoted = true;
                    RunObject = Report "Mass Update Transactions";
                }
                action("Staff Pension Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Pension Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Staff Pension Report";
                }
            }
            group(TaxReturns)
            {
                Caption = 'Tax Return Reports';
                Image = Intrastat;
                action(p9Fin)
                {
                    ApplicationArea = Basic;
                    Caption = 'P9 Report';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "P9 Report (Final)";
                }
                action(EmpCert)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employer Certificate';
                    Image = "report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Employer Certificate P.10 mst";
                }
                action(p10)
                {
                    ApplicationArea = Basic;
                    Caption = 'P.10';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "P.10 A mst";
                }
                action(PAYE2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Paye Scheule';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "prPaye Schedule 1a";
                }
                action(NHIF2)
                {
                    ApplicationArea = Basic;
                    Caption = 'NHIF Schedult';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "prNHIF 1a";
                }
                action(NSSF2)
                {
                    ApplicationArea = Basic;
                    Caption = 'NSSF Schedule';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "prNSSF 1a";
                }
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
            group(" Finance Operations")
            {
                Caption = ' Finance Operations';
                Image = SNInfo;
                action("Official Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Official Receipts';
                    RunObject = Page "FIN-Receipts List";
                }
                action("Payment Vouchers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment Vouchers';
                    RunObject = Page "FIN-Payment Vouchers";
                }
                action("Interbank Transfer")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interbank Transfer';
                    RunObject = Page "FIN-Interbank Transfer";
                }
                action(Imprest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest';
                    RunObject = Page "FIN-Imprests List";
                }
            }
            group(" Student Finance")
            {
                Caption = ' Student Finance';
                Image = SNInfo;
                action("Tuition Fee Tagging")
                {
                    ApplicationArea = Basic;
                    RunObject = Page "Tuition Fee Tagging";
                }
                action("Student Billing")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Billing';
                    Image = UserSetup;
                    RunObject = Page "ACA-Std Billing List";
                }
                action("Missing Balance Imports")
                {
                    ApplicationArea = Basic;
                    Caption = 'Missing Balance Imports';
                    Image = Migration;
                    Promoted = true;
                    RunObject = Page "GEN-Journal Buffer";
                }
                action("No. Series")
                {
                    ApplicationArea = Basic;
                    Caption = 'No. Series';
                    RunObject = Page "No. Series";
                }
                action("Approval Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approval Entries';
                    RunObject = Page "Approval Entries";
                }
                action("Approval Request Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approval Request Entries';
                    RunObject = Page "Approval Request Entries";
                }
                action("Reason Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reason Codes';
                    RunObject = Page "ACA-Programmes List";
                }
                action("Students Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Students Card';
                    RunObject = Page "ACA-All Students List";
                }
            }
            group(POS)
            {
                Caption = 'POS';
                Image = SNInfo;
                action("POS Reports")
                {
                    ApplicationArea = Basic;
                    Caption = 'POS Reports';
                    RunObject = Page "POS Sales Reports";
                }
            }
            group(Payroll)
            {
                Caption = 'Payroll';
                Image = SNInfo;
                action("Salary Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary Card';
                    Image = Employee;
                    Promoted = true;
                    RunObject = Page "HRM-Employee-List";
                }
                action(Action1000000087)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transcation Codes';
                    Image = Setup;
                    Promoted = true;
                    RunObject = Page "PRL-Transaction Codes List";
                }
                action(Action1000000086)
                {
                    ApplicationArea = Basic;
                    Caption = 'NHIF Setup';
                    Image = SetupLines;
                    Promoted = true;
                    RunObject = Page "PRL-NHIF SetUp";
                }
                action("Payroll Mass Changes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Mass Changes';
                    Image = AddAction;
                    Promoted = true;
                    RunObject = Page "HRM-Import Emp. Trans Buff";
                }
                action(Action1000000084)
                {
                    ApplicationArea = Basic;
                    Caption = ' payment Vouchers';
                    RunObject = Page "FIN-Payment Vouchers";
                }
                action(Action1000000083)
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary Increament Register';
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "HRM-Salary Increament Register";
                }
                action(Action1000000082)
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary Increament Process';
                    Image = AddAction;
                    Promoted = true;
                    RunObject = Page "HRM-Emp. Categories";
                }
                action(Action1000000081)
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary Increament Register';
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "HRM-Salary Increament Register";
                }
                action(Action1000000080)
                {
                    ApplicationArea = Basic;
                    Caption = 'Un-Afected Salary Increaments';
                    Image = UndoCategory;
                    Promoted = true;
                    RunObject = Page "HRM-Unaffected Sal. Increament";
                }
                action("Leave Allowance Buffer")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Allowance Buffer';
                    Image = Bins;
                    Promoted = true;
                    RunObject = Page "HRM-Leave Allowance Buffer";
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

