#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68024 "GEN-Audit Man. Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1902304208;"Account Manager Activities")
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
            action("&Bank Detail Trial Balance")
            {
                ApplicationArea = Basic;
                Caption = '&Bank Detail Trial Balance';
                Image = "Report";
                RunObject = Report "Bank Acc. - Detail Trial Bal.";
            }
            action("&Account Schedule")
            {
                ApplicationArea = Basic;
                Caption = '&Account Schedule';
                Image = "Report";
                RunObject = Report "Account Schedule";
            }
            action("Bu&dget")
            {
                ApplicationArea = Basic;
                Caption = 'Bu&dget';
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
            action("Trial Balance by &Period")
            {
                ApplicationArea = Basic;
                Caption = 'Trial Balance by &Period';
                Image = "Report";
                RunObject = Report "Trial Balance by Period";
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
            action("Reconcile Cus&t. and Vend. Accs")
            {
                ApplicationArea = Basic;
                Caption = 'Reconcile Cus&t. and Vend. Accs';
                Image = "Report";
                RunObject = Report "Reconcile Cust. and Vend. Accs";
            }
            separator(Action53)
            {
            }
            action("&VAT Registration No. Check")
            {
                ApplicationArea = Basic;
                Caption = '&VAT Registration No. Check';
                Image = "Report";
                RunObject = Report "VAT Registration No. Check";
            }
            action("VAT E&xceptions")
            {
                ApplicationArea = Basic;
                Caption = 'VAT E&xceptions';
                Image = "Report";
                RunObject = Report "VAT Exceptions";
            }
            action("VAT &Statement")
            {
                ApplicationArea = Basic;
                Caption = 'VAT &Statement';
                Image = "Report";
                RunObject = Report "VAT Statement";
            }
            action("VAT - VIES Declaration Tax Aut&h")
            {
                ApplicationArea = Basic;
                Caption = 'VAT - VIES Declaration Tax Aut&h';
                Image = "Report";
                RunObject = Report "VAT- VIES Declaration Tax Auth";
            }
            action("VAT - VIES Declaration Dis&k")
            {
                ApplicationArea = Basic;
                Caption = 'VAT - VIES Declaration Dis&k';
                Image = "Report";
                RunObject = Report "VAT- VIES Declaration Disk";
            }
            action("EC Sales &List")
            {
                ApplicationArea = Basic;
                Caption = 'EC Sales &List';
                Image = "Report";
                RunObject = Report "EC Sales List";
            }
            separator(Action60)
            {
            }
            action("&Intrastat - Checklist")
            {
                ApplicationArea = Basic;
                Caption = '&Intrastat - Checklist';
                Image = "Report";
                RunObject = Report "Intrastat - Checklist";
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
            action("Cost Accounting P/L Statement")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Accounting P/L Statement';
                Image = "Report";
                RunObject = Report "Cost Acctg. Statement";
            }
            action("CA P/L Statement per Period")
            {
                ApplicationArea = Basic;
                Caption = 'CA P/L Statement per Period';
                Image = "Report";
                RunObject = Report "Cost Acctg. Stmt. per Period";
            }
            action("CA P/L Statement with Budget")
            {
                ApplicationArea = Basic;
                Caption = 'CA P/L Statement with Budget';
                Image = "Report";
                RunObject = Report "Cost Acctg. Statement/Budget";
            }
            action("Cost Accounting Analysis")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Accounting Analysis';
                Image = "Report";
                RunObject = Report "Cost Acctg. Analysis";
            }
            separator(Action144)
            {
            }
            action("Vendor - T&op 10 List")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor - T&op 10 List';
                Image = "Report";
                RunObject = Report "Vendor - Top 10 List";
            }
            action("Vendor/&Item Purchases")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor/&Item Purchases';
                Image = "Report";
                RunObject = Report "Vendor/Item Purchases";
            }
            separator(Action14)
            {
            }
            group(Procurement)
            {
                Caption = 'Procurement Reports';
            }
            action("Inventory - &Availability Plan")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - &Availability Plan';
                Image = ItemAvailability;
                RunObject = Report "Inventory - Availability Plan";
            }
            action("Inventory &Purchase Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory &Purchase Orders';
                Image = "Report";
                RunObject = Report "Inventory Purchase Orders";
            }
            action("Inventory - &Vendor Purchases")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - &Vendor Purchases';
                Image = "Report";
                RunObject = Report "Inventory - Vendor Purchases";
            }
            action("Inventory &Cost and Price List")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory &Cost and Price List';
                Image = "Report";
                RunObject = Report "Inventory Cost and Price List";
            }
            action("Purchase Quote Request Report")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Quote Request Report';
                Image = "Report";
                RunObject = Report "Purchase Quote Request Report";
            }
            action(Action20)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Quote Request Report';
                Image = "Report";
                RunObject = Report UnknownReport39005490;
            }
            action("Local Purchase Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Local Purchase Orders';
                Image = "Report";
                RunObject = Report "Local Purchase Orders";
            }
            action("Purchase Requisition")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Requisition';
                Image = "Report";
                RunObject = Report "HR Appraisal Reports";
            }
            action("Purchase Order")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Order';
                Image = "Report";
                RunObject = Report "Purchase Order1";
            }
            group(payroll_Reports)
            {
                Caption = 'Payroll Reports';
                action("Company Payroll Master")
                {
                    ApplicationArea = Basic;
                    Caption = 'Company Payroll Master';
                    Image = CompanyInformation;
                    Promoted = true;
                    RunObject = Report "Company Payroll Summary";
                }
                action("vew payslip")
                {
                    ApplicationArea = Basic;
                    Caption = 'vew payslip';
                    RunObject = Report "Individual Payslips mst";
                }
                action("Payroll summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll summary';
                    RunObject = Report "Individual Payslips mst";
                }
                action("payroll summary2")
                {
                    ApplicationArea = Basic;
                    Caption = 'payroll summary2';
                    RunObject = Report prPayrollSummary2;
                }
                action(deductions)
                {
                    ApplicationArea = Basic;
                    Caption = 'deductions';
                    RunObject = Report "prDeductions Report";
                }
                action("Staff pension")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff pension';
                    RunObject = Report "Staff Pension Report";
                }
                action("Gross Netpay")
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Netpay';
                    RunObject = Report prGrossNetPay;
                }
                action("Third Rule")
                {
                    ApplicationArea = Basic;
                    Caption = 'Third Rule';
                    RunObject = Report "A third Rule Report";
                }
                action("Co_op Remittance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co_op Remittance';
                    RunObject = Report "prCoop remmitance";
                }
                action(Transactions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transactions';
                    RunObject = Report "pr Transactions";
                }
                action("bank Schedule")
                {
                    ApplicationArea = Basic;
                    Caption = 'bank Schedule';
                    RunObject = Report "pr Bank Schedule";
                }
                action(Action143)
                {
                    ApplicationArea = Basic;
                    Caption = 'vew payslip';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "Individual Payslips mst";
                }
                action(Action142)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll summary';
                    Image = payslip;
                    RunObject = Report "Individual Payslips mst";
                }
                action(Action141)
                {
                    ApplicationArea = Basic;
                    Caption = 'payroll summary2';
                    Image = summary;
                    RunObject = Report prPayrollSummary2;
                }
                action(Action140)
                {
                    ApplicationArea = Basic;
                    Caption = 'deductions';
                    Image = DepositSlip;
                    RunObject = Report "prDeductions Report";
                }
                action(Action139)
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff pension';
                    Image = Aging;
                    RunObject = Report "Staff Pension Report";
                }
                action(Action138)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Netpay';
                    Image = Giro;
                    RunObject = Report prGrossNetPay;
                }
                action(Action137)
                {
                    ApplicationArea = Basic;
                    Caption = 'Third Rule';
                    Image = AddWatch;
                    RunObject = Report "A third Rule Report";
                }
                action(Action136)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co_op Remittance';
                    Image = CreateForm;
                    RunObject = Report "prCoop remmitance";
                }
                separator(Action135)
                {
                    Caption = 'setup finance';
                }
                action("receipt type")
                {
                    ApplicationArea = Basic;
                    Caption = 'receipt type';
                    Image = ServiceSetup;
                    RunObject = Page "FIN-Receipt Types";
                }
                action(Action133)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transactions';
                    RunObject = Report "pr Transactions";
                }
                action(Action132)
                {
                    ApplicationArea = Basic;
                    Caption = 'bank Schedule';
                    RunObject = Report "pr Bank Schedule";
                }
                separator(Action131)
                {
                }
                action("Paye Scheule")
                {
                    ApplicationArea = Basic;
                    Caption = 'Paye Scheule';
                    RunObject = Report "prPaye Schedule mst";
                }
                action("Employer Certificate")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employer Certificate';
                    RunObject = Report "Employer Certificate P.10 mst";
                }
                action("P.10")
                {
                    ApplicationArea = Basic;
                    Caption = 'P.10';
                    RunObject = Report "P.10 A mst";
                }
                action(NSSF)
                {
                    ApplicationArea = Basic;
                    Caption = 'NSSF';
                    Image = Replan;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Pop. By Prog./Gender/Settl.";
                }
                action(PAYE)
                {
                    ApplicationArea = Basic;
                    Caption = 'PAYE';
                    Image = Reconcile;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Population By Faculty";
                }
                action(HELB)
                {
                    ApplicationArea = Basic;
                    Caption = 'HELB';
                    Image = Hierarchy;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report UnknownReport52017866;
                }
                action(NHIF)
                {
                    ApplicationArea = Basic;
                    Caption = 'NHIF';
                    Image = RefreshText;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report UnknownReport52017867;
                }
            }
            group(Fixed_Reports)
            {
                Caption = 'Fixed Reports';
                separator(Action166)
                {
                    Caption = 'Fixed Assets';
                }
                action("Fixed Assets List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fixed Assets List';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - List";
                }
                action("Acquisition List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Acquisition List';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - Acquisition List";
                }
                action(Details)
                {
                    ApplicationArea = Basic;
                    Caption = 'Details';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - Details";
                }
                action("Book Value 01")
                {
                    ApplicationArea = Basic;
                    Caption = 'Book Value 01';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - Book Value 01";
                }
                action("Book Value 02")
                {
                    ApplicationArea = Basic;
                    Caption = 'Book Value 02';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - Book Value 02";
                }
                action(Analysis)
                {
                    ApplicationArea = Basic;
                    Caption = 'Analysis';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - Analysis";
                }
                action("Projected Value")
                {
                    ApplicationArea = Basic;
                    Caption = 'Projected Value';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - Projected Value";
                }
                action("G/L Analysis")
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L Analysis';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - G/L Analysis";
                }
                action(Register)
                {
                    ApplicationArea = Basic;
                    Caption = 'Register';
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset Register";
                }
            }
            group(ActionGroup123)
            {
                Caption = 'Approvals';
                Image = Alerts;
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
        area(processing)
        {
            separator(Action64)
            {
                Caption = 'Tasks';
                IsHeader = true;
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
            action("Calc. and Pos&t VAT Settlement")
            {
                ApplicationArea = Basic;
                Caption = 'Calc. and Pos&t VAT Settlement';
                Image = SettleOpenTransactions;
                RunObject = Report "Calc. and Post VAT Settlement";
            }
        }
    }
}

