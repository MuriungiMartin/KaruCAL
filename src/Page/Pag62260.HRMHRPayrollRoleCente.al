#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 62260 "HRM-HR&Payroll Role Cente"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control29)
            {
                part(Control28;"HRM-Employee Cue")
                {
                    Caption = 'Employees Cue';
                }
                systempart(Control27;Outlook)
                {
                }
            }
            group(Control26)
            {
                part(Control25;"Approval Entries")
                {
                    Caption = 'My Approval Entries';
                }
                systempart(Control24;Links)
                {
                }
                systempart(Control23;MyNotes)
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
                action(Payslips)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payslips';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "Individual Payslips mst";
                }
                action("Master Payroll Summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Master Payroll Summary';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Company Payroll Summary 3";
                }
                action("Payroll Summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Summary';
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
                action("vew payslip")
                {
                    ApplicationArea = Basic;
                    Caption = 'vew payslip';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "Individual Payslips mst";
                }
                action("Payroll summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll summary';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "Payroll Summary 2";
                }
                action("Deductions Summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Deductions Summary';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Deductions Summary";
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
            group(Reports3)
            {
                Caption = 'HR Reports';
                Image = Payables;
                action("Employee List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee List';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HR Employee List";
                }
                action("Employee Beneficiaries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Beneficiaries';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HR Employee Beneficiaries";
                }
                action("Commission Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Commission Report';
                    Image = Report2;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HRM-Commission For Univ. Rep.";
                }
                action("Leave Balances")
                {
                    ApplicationArea = Basic;
                    Image = Balance;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Employee Leaves";
                }
                action("Leave Transactions")
                {
                    ApplicationArea = Basic;
                    Image = Translation;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Standard Leave Balance Report";
                }
                action("Leave Statement")
                {
                    ApplicationArea = Basic;
                    Image = LedgerEntries;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HR Leave Statement";
                }
                action("Employee By Tribe")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee By Tribe';
                    Image = DepositLines;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Employee Distribution by Tribe";
                }
                action("Employee CV Sunmmary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee CV Sunmmary';
                    Image = SuggestGrid;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Employee Details Summary";
                }
            }
        }
        area(sections)
        {
            group(JobMan)
            {
                Caption = 'Jobs Management';
                Image = ResourcePlanning;
                action("Jobs List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Jobs List';
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "HRM-Jobs List";
                }
            }
            group(Recruit)
            {
                Caption = 'Recruitment Management';
                action("Employee Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Requisitions';
                    Image = ApplicationWorksheet;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "HRM-Employee Requisitions List";
                }
                action("Job Applications List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Applications List';
                    RunObject = Page "HRM-Job Applications List";
                }
                action("Short Listing")
                {
                    ApplicationArea = Basic;
                    Caption = 'Short Listing';
                    RunObject = Page "HRM-Shortlisting List";
                }
                action("Qualified Job Applicants")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualified Job Applicants';
                    RunObject = Page "HRM-Job Applicants Qualified";
                }
                action("Unqualified Applicants")
                {
                    ApplicationArea = Basic;
                    Caption = 'Unqualified Applicants';
                    RunObject = Page "HRM-Job Applicants Unqualified";
                }
                action("Advertised Jobs")
                {
                    ApplicationArea = Basic;
                    Caption = 'Advertised Jobs';
                    RunObject = Page "HRM-Advertised Job List";
                }
            }
            group(EmployeeMan)
            {
                Caption = 'Employee Manager';
                Image = HumanResources;
                action(Action22)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee List';
                    RunObject = Page "HRM-Employee List";
                }
                action("Leave Applications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Applications';
                    RunObject = Page "HRM-View Leave List";
                }
            }
            group(LeaveMan)
            {
                Caption = 'Leave Management';
                Image = Capacities;
                action(Action14)
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Applications';
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "HRM-Leave Requisition List";
                }
                action("Posted Leaves")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Leaves';
                    RunObject = Page "HRM-Leave Requisition Posted";
                }
                action("Staff Movement Form")
                {
                    ApplicationArea = Basic;
                    RunObject = Page "HRM-Back To Office List";
                }
                action("Leave Journals")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Journals';
                    Image = Journals;
                    Promoted = true;
                    RunObject = Page "HRM-Emp. Leave Journal Lines";
                }
                action("Posted Leave")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Leave';
                    RunObject = Page "HRM-Posted Leave Journal";
                }
            }
            group(PayRollData)
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
            group(SalInc)
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
            group(train)
            {
                Caption = 'Training Management';
                action("Training Applications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Applications';
                    RunObject = Page "HRM-Training Application List";
                }
                action("Training Courses")
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Courses';
                    RunObject = Page "HRM-Course List";
                }
                action("Training Providers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Providers';
                    RunObject = Page "HRM-Training Providers List";
                }
                action("Training Needs")
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Needs';
                    RunObject = Page "HRM-Train Need Analysis List";
                }
                action("Back To Office")
                {
                    ApplicationArea = Basic;
                    Caption = 'Back To Office';
                    RunObject = Page "HRM-Back To Office List";
                }
            }
            group(Welfare)
            {
                Caption = 'Welfare Management';
                Image = Capacities;
                action("Company Activity")
                {
                    ApplicationArea = Basic;
                    Caption = 'Company Activity';
                    RunObject = Page "HRM-Company Activities List";
                }
            }
            group(setus)
            {
                Caption = 'Setups';
                Image = HRSetup;
                action("Institutions List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Institutions List';
                    Image = Line;
                    Promoted = true;
                    RunObject = Page "HRM-Institutions List";
                }
                action("Base Calendar")
                {
                    ApplicationArea = Basic;
                    Caption = 'Base Calendar';
                    RunObject = Page "Base Calendar List";
                }
                action("Hr Setups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Hr Setups';
                    RunObject = Page "HRM-SetUp List";
                }
                action(Committees)
                {
                    ApplicationArea = Basic;
                    Caption = 'Committees';
                    RunObject = Page "HRM-Committees";
                }
                action("Look Up Values")
                {
                    ApplicationArea = Basic;
                    Caption = 'Look Up Values';
                    RunObject = Page "HRM-Lookup Values List";
                }
                action("Hr Calendar")
                {
                    ApplicationArea = Basic;
                    Caption = 'Hr Calendar';
                    RunObject = Page "Base Calendar List";
                }
                action(" Email Parameters List")
                {
                    ApplicationArea = Basic;
                    Caption = ' Email Parameters List';
                    RunObject = Page "HRM-Email Parameters List";
                }
                action("No.Series")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.Series';
                    RunObject = Page "No. Series";
                }
            }
            group(pension)
            {
                Caption = 'Pension Management';
                Image = History;
                action(Action40)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Beneficiaries';
                    RunObject = Page "HRM-Emp. Beneficiaries List";
                }
                action("Pension Payments List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pension Payments List';
                    RunObject = Page "HRM-Pension Payments List";
                }
            }
            group(exitInterview)
            {
                Caption = 'Exit Interviews';
                Image = Alerts;
                action(" Exit Interview")
                {
                    ApplicationArea = Basic;
                    Caption = ' Exit Interview';
                    RunObject = Page "HRM-Exit Interview List";
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
                action(Action1000000003)
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
                action(Action1000000047)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transcation Codes';
                    Image = Setup;
                    Promoted = true;
                    RunObject = Page "PRL-Transaction Codes List";
                }
                action(Action1000000046)
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
                action(Action1000000040)
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary Increament Process';
                    Image = AddAction;
                    Promoted = true;
                    RunObject = Page "HRM-Emp. Categories";
                }
                action(Action1000000039)
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary Increament Register';
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "HRM-Salary Increament Register";
                }
                action(Action1000000038)
                {
                    ApplicationArea = Basic;
                    Caption = 'Un-Afected Salary Increaments';
                    Image = UndoCategory;
                    Promoted = true;
                    RunObject = Page "HRM-Unaffected Sal. Increament";
                }
                action(Action1000000037)
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
                action(Action1000000035)
                {
                    ApplicationArea = Basic;
                    Caption = 'vew payslip';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "Individual Payslips mst";
                }
                action(Action1000000034)
                {
                    ApplicationArea = Basic;
                    Caption = 'Master Payroll Summary';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Company Payroll Summary 3";
                }
                action(Action1000000033)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll summary';
                    Image = payslip;
                    RunObject = Report "PRL-Company Payroll Summary 3";
                }
                action(Action1000000032)
                {
                    ApplicationArea = Basic;
                    Caption = 'Deductions Summary';
                    Image = summary;
                    RunObject = Report "PRL-Deductions Summary";
                }
                action(Action1000000031)
                {
                    ApplicationArea = Basic;
                    Caption = 'Earnings Summary';
                    Image = DepositSlip;
                    RunObject = Report "PRL-Earnings Summary";
                }
                action(Action1000000030)
                {
                    ApplicationArea = Basic;
                    Caption = 'Deductions Summary 2';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Deductions Summary 2";
                }
                action(Action1000000029)
                {
                    ApplicationArea = Basic;
                    Caption = 'Earnings Summary 2';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "PRL-Payments Summary 2";
                }
                action(Action1000000028)
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff pension';
                    Image = Aging;
                    RunObject = Report "Staff Pension Report";
                }
                action(Action1000000027)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Netpay';
                    Image = Giro;
                    RunObject = Report prGrossNetPay;
                }
            }
            group(PayrollPeoro)
            {
                Caption = 'Periodic Reports';
                Image = RegisteredDocs;
                action(Action1000000025)
                {
                    ApplicationArea = Basic;
                    Caption = 'P9 Report';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "P9 Report (Final)";
                }
                action(Action1000000024)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transactions';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "pr Transactions";
                }
                action(Action1000000023)
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
                action("Paye Scheule")
                {
                    ApplicationArea = Basic;
                    Caption = 'Paye Scheule';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "prPaye Schedule mst";
                }
                action("NHIF Schedult")
                {
                    ApplicationArea = Basic;
                    Caption = 'NHIF Schedult';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "prNHIF mst";
                }
                action("NSSF Schedule")
                {
                    ApplicationArea = Basic;
                    Caption = 'NSSF Schedule';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "prNSSF mst";
                }
                action(Action1000000017)
                {
                    ApplicationArea = Basic;
                    Caption = 'Third Rule';
                    Image = AddWatch;
                    RunObject = Report "A third Rule Report";
                }
                action(Action1000000016)
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
            }
            action("mass update Transactions")
            {
                ApplicationArea = Basic;
                Caption = 'mass update Transactions';
                Image = PostBatch;
                Promoted = true;
                RunObject = Report "Mass Update Transactions";
            }
        }
    }
}

