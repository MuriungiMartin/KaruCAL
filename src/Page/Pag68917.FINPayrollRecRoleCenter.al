#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68917 "FIN-Payroll & Rec. Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1902899408;"PRL-Emp. Cue (Payroll)")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control1907692008;"My Customers")
                {
                }
                part(Control1905989608;"My Items")
                {
                }
                part(Control1;"My Job Queue")
                {
                    Visible = false;
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
                    RunObject = Report "PRL-Payee 2";
                }
            }
        }
        area(sections)
        {
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
                    RunPageView = where(Status=filter(Normal));
                }
                action("Salary Card (Inactive)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary Card (Inactive)';
                    Image = Employee;
                    Promoted = true;
                    RunObject = Page "HRM-Employee-List";
                    RunPageView = where(Status=filter(<>Normal));
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
                action("Payroll Mass Changes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Mass Changes';
                    Image = AddAction;
                    Promoted = true;
                    RunObject = Page "HRM-Import Emp. Trans Buff";
                }
                action(" payment Vouchers")
                {
                    ApplicationArea = Basic;
                    Caption = ' payment Vouchers';
                    RunObject = Page "FIN-Payment Vouchers";
                }
            }
            group("Salary Increaments")
            {
                Caption = 'Salary Increaments';
                Image = Intrastat;
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
                action("Leave Allowance Buffer")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Allowance Buffer';
                    Image = Bins;
                    Promoted = true;
                    RunObject = Page "HRM-Leave Allowance Buffer";
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;
                action("<Page ACA-Std Billing List>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Billing';
                    Image = UserSetup;
                    RunObject = Page "ACA-Std Billing List";
                }
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
                Image = Employee;
                Promoted = true;
                RunObject = XMLport "Import payroll transactions";
            }
            action("Import basic")
            {
                ApplicationArea = Basic;
                Caption = 'Import basic';
                Image = PaymentJournal;
                Promoted = true;
                RunObject = XMLport "Import Basic Pay";
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
                action(Action7)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transcation Codes';
                    Image = Setup;
                    Promoted = true;
                    RunObject = Page "PRL-Transaction Codes List";
                }
                action(Action6)
                {
                    ApplicationArea = Basic;
                    Caption = 'NHIF Setup';
                    Image = SetupLines;
                    Promoted = true;
                    RunObject = Page "PRL-NHIF SetUp";
                }
                action("NSSF Setup")
                {
                    ApplicationArea = Basic;
                    Image = SetupLines;
                    Promoted = true;
                    RunObject = Page "PRL-NSSF";
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
                action(Action69)
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary Increament Process';
                    Image = AddAction;
                    Promoted = true;
                    RunObject = Page "HRM-Emp. Categories";
                }
                action(Action68)
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary Increament Register';
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "HRM-Salary Increament Register";
                }
                action(Action66)
                {
                    ApplicationArea = Basic;
                    Caption = 'Un-Afected Salary Increaments';
                    Image = UndoCategory;
                    Promoted = true;
                    RunObject = Page "HRM-Unaffected Sal. Increament";
                }
                action(Action9)
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
                action(Action108)
                {
                    ApplicationArea = Basic;
                    Caption = 'Master Payroll Summary';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Company Payroll Summary 3";
                }
                action(Action56)
                {
                    ApplicationArea = Basic;
                    Caption = 'Earnings Summary';
                    Image = DepositSlip;
                    RunObject = Report "PRL-Earnings Summary";
                }
                action(Action109)
                {
                    ApplicationArea = Basic;
                    Caption = 'Deductions Summary 2';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Deductions Summary 2";
                }
                action(Action110)
                {
                    ApplicationArea = Basic;
                    Caption = 'Earnings Summary 2';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Payments Summary 2";
                }
                action(Action57)
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
                action(Action58)
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
                action("Payroll Variance Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Variance Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Payroll Variance Report";
                }
                action("Payroll Variance 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Variance 2';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "PRL-Payroll Variance Report";
                }
                action("Payroll Comparison")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Comparison';
                    Image = Alerts;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Payroll Variance Report 2";
                }
            }
            group(PayrollPeoro)
            {
                Caption = 'Periodic Reports';
                Image = RegisteredDocs;
                action(Action8)
                {
                    ApplicationArea = Basic;
                    Caption = 'P9 Report';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "P9 Report (Final)";
                }
                action(Action61)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transactions';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "pr Transactions";
                }
                action(Action62)
                {
                    ApplicationArea = Basic;
                    Caption = 'bank Schedule';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "PRL-Payee 2";
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
                action(Action59)
                {
                    ApplicationArea = Basic;
                    Caption = 'Third Rule';
                    Image = AddWatch;
                    RunObject = Report "A third Rule Report";
                }
                action(Action60)
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
                action("Housing Levy Fund Report")
                {
                    ApplicationArea = Basic;
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "House Levy Report";
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
                action("SHA/SHIF Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'SHA/SHIF Report';
                    Image = Aging;
                    RunObject = Report prSHIF;
                }
            }
            group(CummReports)
            {
                Caption = 'Cummulative Reports';
                Image = RegisteredDocs;
                action("Periodic Deductions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Periodic Deductions';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "PRL-Periodic Deductions Summar";
                }
                action("Periodic Deductions (Summary)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Periodic Deductions (Summary)';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "PRL-Cummulative Deductions";
                }
                action("Periodic Allowances")
                {
                    ApplicationArea = Basic;
                    Caption = 'Periodic Allowances';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "PRL-Periodic Payments Summar";
                }
                action("Periodic Allowances (Summary)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Periodic Allowances (Summary)';
                    Image = "report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "PRL-Cummulative Allowances";
                }
            }
        }
    }
}

