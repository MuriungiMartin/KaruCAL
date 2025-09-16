#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69250 "Management Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control21;"Finance Performance")
                {
                }
                part(Control4;"Finance Performance")
                {
                    Visible = false;
                }
                part(Control1907692008;"My Customers")
                {
                }
                part(Control26;"Copy Profile")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control24;"Cash Flow Forecast Chart")
                {
                }
                part(Control27;"Sales Performance")
                {
                }
                part(Control28;"Sales Performance")
                {
                    Visible = false;
                }
                part(Control29;"Report Inbox Part")
                {
                }
                part(Control25;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control1902476008;"My Vendors")
                {
                    Visible = false;
                }
                part(Control1905989608;"My Items")
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
            Description = 'Reports';
            group(FinRep)
            {
                Caption = 'Financial Reports';
                Description = 'Financial Reports';
                Image = Ledger;
                group(Fin_Reports)
                {
                    Caption = 'Financial Reports';
                    Description = 'Financial Reports';
                    Image = Ledger;
                    action("Recei&vables-Payables")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Recei&vables-Payables';
                        Image = ReceivablesPayables;
                        RunObject = Report "Receivables-Payables";
                    }
                    action("&Trial Balance/Budget")
                    {
                        ApplicationArea = Basic;
                        Caption = '&Trial Balance/Budget';
                        Image = "Report";
                        RunObject = Report "Trial Balance/Budget";
                    }
                    action("&Closing Trial Balance")
                    {
                        ApplicationArea = Basic;
                        Caption = '&Closing Trial Balance';
                        Image = "Report";
                        RunObject = Report "Closing Trial Balance";
                    }
                    action("&Fiscal Year Balance")
                    {
                        ApplicationArea = Basic;
                        Caption = '&Fiscal Year Balance';
                        Image = "Report";
                        RunObject = Report "Fiscal Year Balance";
                    }
                    separator(Action6)
                    {
                    }
                    action("Customer - &Balance")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Customer - &Balance';
                        Image = "Report";
                        RunObject = Report "Customer - Balance to Date";
                    }
                    action("Customer - T&op 10 List")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Customer - T&op 10 List';
                        Image = "Report";
                        RunObject = Report "Customer - Top 10 List";
                    }
                    action("Customer - S&ales List")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Customer - S&ales List';
                        Image = "Report";
                        RunObject = Report "Customer - Sales List";
                    }
                    action("Customer Sales Statistics")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Customer Sales Statistics';
                        Image = "Report";
                        RunObject = Report "Customer Sales Statistics";
                    }
                    separator(Action11)
                    {
                    }
                    action("Vendor - &Purchase List")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Vendor - &Purchase List';
                        Image = "Report";
                        RunObject = Report "Vendor - Purchase List";
                    }
                    action("Detailed Trial Balance")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Detailed Trial Balance';
                        RunObject = Report "Detail Trial Balance";
                    }
                    action("Balance Sheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Balance Sheet';
                        RunObject = Report "Account Schedule";
                    }
                    action("Dimension Details")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimension Details';
                        RunObject = Report "Dimensions - Detail";
                    }
                    action("Trial Balance/Prev. Year")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Trial Balance/Prev. Year';
                        RunObject = Report "Trial Balance/Previous Year";
                    }
                    action("Bank Ac. Detailed TB")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Bank Ac. Detailed TB';
                        RunObject = Report "Bank Acc. - Detail Trial Bal.";
                    }
                    action("Inventory Valuation")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Inventory Valuation';
                        RunObject = Report "Inventory Valuation";
                    }
                    separator(Action1000000047)
                    {
                        Caption = 'Ageing Reports';
                    }
                    action("Customer Ageing Report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Customer Ageing Report';
                        RunObject = Report "Aged Accounts Receivable";
                    }
                    action("Vendor Ageing Balances")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Vendor Ageing Balances';
                        RunObject = Report "Aged Accounts Payable";
                    }
                }
            }
            group(FundsRep)
            {
                Caption = 'Funds Reports';
                Description = 'Funds Reports';
                Image = FiledPosted;
                group(Funds_Rep)
                {
                    Caption = 'Funds Reports';
                    Description = 'Funds Reports';
                    Image = FiledPosted;
                    action("Imprest Register")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Imprest Register';
                        RunObject = Report "Imprest Register1";
                    }
                    action("Claim Statement")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Claim Statement';
                        RunObject = Report Statement;
                    }
                }
            }
            group(Admissions_Reps1)
            {
                Caption = 'Admissions Reports';
                Description = 'Admissions Reports';
                Image = Intrastat;
                group(Admissions_Reps)
                {
                    Caption = 'Admissions Reports';
                    Description = 'Admissions Reports';
                    Image = Intrastat;
                    action("Admissions Summary")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Admissions Summary';
                        Image = "Report";
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "KUCCPS & PSSP Admissions List";
                    }
                    action("Admission By Program")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Admission By Program';
                        Image = "Report";
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "KUCCPS & PSSP Adm. By Program";
                    }
                    action("Admission Summary 2")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Admission Summary 2';
                        Image = "Report";
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "PRL-Payroll Variance Report2";
                    }
                    action("New Applications")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Application List Academic New";
                    }
                    action("Online Applications Report")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Earnings Summary 2 Ext";
                    }
                    action(Enquiries)
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Staff Pension Ext";
                    }
                    action("Marketing Strategies Report")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Recover From Payroll";
                    }
                    action("Direct Applications")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Direct Applications Form Reg";
                    }
                    action("Pending Applications")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Application List Academic New";
                    }
                    action("Application Summary")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Application Summary";
                    }
                    action("Applicant Shortlisting (Summary)")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Shortlisted Students Summary";
                    }
                    action("Applicant Shortlisting (Detailed)")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Shortlisted Students Status";
                    }
                }
            }
            group(Acad_Reports1)
            {
                Caption = 'Academic Reports';
                Description = 'Academic Reports';
                Image = Departments;
                group(Acad_Reports)
                {
                    Caption = 'Academic Reports';
                    Description = 'Academic Reports';
                    Image = Departments;
                    action("All Students")
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        RunObject = Report "All Students";
                    }
                    action("Norminal Roll")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Norminal Roll';
                        Image = Report2;
                        RunObject = Report "Norminal Roll (Cont. Students)";
                    }
                    action("Class List (By Stage)")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Class List (By Stage)';
                        Image = List;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "ACA-Class List (List By Stage)";
                    }
                    action("Signed Norminal Roll")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Signed Norminal Roll';
                        Image = Report2;
                        Promoted = true;
                        RunObject = Report "Signed Norminal Role";
                    }
                    action("Program List By Gender && Type")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Program List By Gender && Type';
                        Image = PrintReport;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Pop. By Prog./Gender/Settl.";
                    }
                    action("population By Faculty")
                    {
                        ApplicationArea = Basic;
                        Caption = 'population By Faculty';
                        Image = PrintExcise;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Population By Faculty";
                    }
                    action("Multiple Record")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Multiple Record';
                        Image = Report2;
                        RunObject = Report "Multiple Student Records";
                    }
                    action("Classification By Campus")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Classification By Campus';
                        Image = Report2;
                        RunObject = Report "Population Class By Campus";
                    }
                    action("Population By Campus")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Population By Campus';
                        Image = Report2;
                        RunObject = Report "Population By Campus";
                    }
                    action("Population by Programme")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Population by Programme';
                        Image = Report2;
                        RunObject = Report "Population By Programme";
                    }
                    action("Prog. Category")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Prog. Category';
                        Image = Report2;
                        RunObject = Report "Population By Prog. Category";
                    }
                    action("List By Programme")
                    {
                        ApplicationArea = Basic;
                        Caption = 'List By Programme';
                        Image = "report";
                        RunObject = Report "List By Programme";
                    }
                    action("List By Programme (With Balances)")
                    {
                        ApplicationArea = Basic;
                        Caption = 'List By Programme (With Balances)';
                        Image = PrintReport;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "ACA-List By Prog.(Balances)";
                    }
                    action("Type. Study Mode, & Gender")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Type. Study Mode, & Gender';
                        Image = "report";
                        RunObject = Report "Stud Type, Study Mode & Gende";
                    }
                    action("Study Mode & Gender")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Study Mode & Gender';
                        Image = "report";
                        RunObject = Report "List By Study Mode & Gender";
                    }
                    action("County & Gender")
                    {
                        ApplicationArea = Basic;
                        Caption = 'County & Gender';
                        Image = "report";
                        RunObject = Report "List By County & Gender";
                    }
                    action("List By County")
                    {
                        ApplicationArea = Basic;
                        Caption = 'List By County';
                        Image = "report";
                        RunObject = Report "List By County";
                    }
                    action("Prog. Units")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Prog. Units';
                        Image = "report";
                        RunObject = Report "Programme Units";
                    }
                    action("Enrollment By Stage")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Enrollment By Stage';
                        Image = Report2;
                        RunObject = Report "Enrollment by Stage";
                    }
                    action("Import Units")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Import Units';
                        Image = ImportExcel;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Prog. Units Buffer";
                    }
                    action("Hostel Allocations")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Hostel Allocations';
                        Image = PrintCover;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Hostel Allocations";
                    }
                    action("Students List (By Program)")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Students List (By Program)';
                        Image = "Report";
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "ACA-Norminal Roll (New Stud)";
                    }
                    action("Programme Units")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Programme Units';
                        Image = "report";
                        Promoted = true;
                        RunObject = Report "Programme Units";
                    }
                }
            }
            group("Students Finance Reports1")
            {
                Description = 'Students Finance Reports';
                Image = Statistics;
                group("Students Finance Reports")
                {
                    Description = 'Students Finance Reports';
                    Image = Statistics;
                    action("Students Balances")
                    {
                        ApplicationArea = Basic;
                        Image = PrintInstallment;
                        Promoted = true;
                        RunObject = Report "Student Balances";
                    }
                    action("Per Programme Balances")
                    {
                        ApplicationArea = Basic;
                        Image = PrintInstallment;
                        Promoted = true;
                        RunObject = Report "Summary Enrollment - Programme";
                    }
                    action("Per Stage Balances")
                    {
                        ApplicationArea = Basic;
                        Image = PrintInstallment;
                        RunObject = Report "Summary Enrollment - Stage";
                    }
                    action("Students Faculty Income Summary")
                    {
                        ApplicationArea = Basic;
                        Image = PrintInstallment;
                        RunObject = Report "Students Revenue Summary";
                    }
                    action("Student Invoices Per Charge")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Student Invoices Per Charge';
                        Image = PrintInstallment;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Student Inv. And Payments";
                    }
                    action("Fee Structure Report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Fee Structure Report';
                        Image = "Report";
                        RunObject = Report "Fee Structure Summary Report";
                    }
                    action("Student Receipts per Charge")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Student Receipts per Charge';
                        Image = PrintReport;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Student Receipts per Charge";
                    }
                }
            }
            group(Exams_Reports1)
            {
                Caption = 'Examination Reports';
                Description = 'Examination Reports';
                Image = ExecuteBatch;
                group(Exams_Reports)
                {
                    Caption = 'Examination Reports';
                    Description = 'Examination Reports';
                    Image = ExecuteBatch;
                    action("Course Loading")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Course Loading';
                        Image = LineDiscount;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Lecturer Course Loading";
                    }
                    action("Examination Cards")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Examination Cards';
                        Image = Card;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Report "Examination Cards";
                    }
                    action("Exam Card Stickers")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Exam Card Stickers';
                        Image = Split;
                        Promoted = true;
                        RunObject = Report "Exam Card Stickers";
                    }
                    action("Consolidated Marksheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Consolidated Marksheet';
                        Image = Completed;
                        Promoted = true;
                        RunObject = Report "Sem Consolidated Marksheet";
                    }
                    action("Consolidated Marksheet 2")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Consolidated Marksheet 2';
                        Image = CompleteLine;
                        Promoted = true;
                        RunObject = Report "Final Consolidated Marksheet";
                    }
                    action("Consolidated Marksheet 3")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Consolidated Marksheet 3';
                        RunObject = Report "Consolidated Marksheet 2";
                    }
                    action(Attendance_Checklist)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Attendance Checklist';
                        RunObject = Report "Exam Attendance Checklist2";
                    }
                    action("Class Grade Sheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Class Grade Sheet';
                        Image = CheckDuplicates;
                        Promoted = true;
                        RunObject = Report "ACA-Class Roster Grade Sheet";
                    }
                    action("Consolidated Gradesheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Consolidated Gradesheet';
                        Image = CheckDuplicates;
                        Promoted = true;
                        RunObject = Report "ACA-Consolidated Gradesheet";
                    }
                    action("Official College Transcript")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Official College Transcript';
                        Image = FixedAssets;
                        Promoted = true;
                        RunObject = Report "Official University Transcript";
                    }
                    action("Official College Resultslip")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Official College Resultslip';
                        Image = Split;
                        Promoted = true;
                        RunObject = Report "Official College Resultslip";
                    }
                    action("Resultslip 2")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Resultslip 2';
                        Image = CheckList;
                        Promoted = true;
                        RunObject = Report "Official Provisional TS";
                    }
                    action("Resultslip 3")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Resultslip 3';
                        Image = CheckJournal;
                        Promoted = true;
                        RunObject = Report "Official University Resultslip";
                    }
                }
            }
            group(Cafe_Man1)
            {
                Caption = 'Cafeteria Reports';
                Description = 'Cafeteria Reports';
                Image = CashFlow;
                group(Cafe_Man)
                {
                    Caption = 'Cafeteria Reports';
                    Description = 'Cafeteria Reports';
                    Image = CashFlow;
                    action("Receipts Register")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Receipts Register';
                        Image = Report2;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "CAT-Sales Register";
                    }
                    action("Daily Summary Saless")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Daily Summary Saless';
                        Image = Report2;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "CAT-Catering Daily Sum. Saless";
                    }
                    action("Daily Sales Summary")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Daily Sales Summary';
                        Image = Report2;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "CAT-Daily Sales Summary (All)";
                    }
                    action("Cafe Revenue Report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cafe Revenue Report';
                        Image = Report2;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "CAT-Cafe Revenue Reports";
                    }
                    action("Sales Summary")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sales Summary';
                        Image = Report2;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "CAT-Daily Sales Summary (Std)";
                    }
                    action("Cafe` Menu")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cafe` Menu';
                        Image = Report2;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "CAT-Cafeteria Menu";
                    }
                }
            }
            group(Host_Reps1)
            {
                Caption = 'Hostel Reports';
                Description = 'Hostel Reports';
                Image = Alerts;
                group(Host_Reps)
                {
                    Caption = 'Hostel Reports';
                    Description = 'Hostel Reports';
                    Image = Alerts;
                    action("Hostel Status Summary Report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Hostel Status Summary Report';
                        Image = Status;
                        Promoted = true;
                        PromotedIsBig = true;
                        PromotedOnly = true;
                        RunObject = Report "Hostel Status Summary Report";
                    }
                    action("AlloCation Analysis")
                    {
                        ApplicationArea = Basic;
                        Caption = 'AlloCation Analysis';
                        Image = Interaction;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Hostel Status Summary Graph";
                    }
                    action("Incidents Report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Incidents Report';
                        Image = Register;
                        Promoted = true;
                        PromotedIsBig = true;
                        PromotedOnly = true;
                        RunObject = Report "Hostel Incidents Report";
                    }
                    action(Action1000000133)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Hostel Allocations';
                        Image = Allocations;
                        Promoted = true;
                        PromotedIsBig = true;
                        PromotedOnly = true;
                        RunObject = Report "Hostel Allocations Per Block";
                    }
                    action("Detailled Allocations")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Detailled Allocations';
                        Image = AllocatedCapacity;
                        Promoted = true;
                        PromotedIsBig = true;
                        PromotedOnly = true;
                        RunObject = Report "Hostel Allo. Per Room/Block";
                    }
                    action("Room Status")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Room Status';
                        Image = Status;
                        Promoted = true;
                        PromotedIsBig = true;
                        PromotedOnly = true;
                        RunObject = Report "Hostel Vaccant Per Room/Block";
                    }
                    action("Allocations List")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Allocations List';
                        Image = Allocate;
                        Promoted = true;
                        PromotedIsBig = true;
                        PromotedOnly = true;
                        RunObject = Report "Hostel Allo. Per Room (Det.)";
                    }
                }
            }
            group(HR_Rep1)
            {
                Caption = 'HR Reports';
                Description = 'HR Reports';
                Image = AdministrationSalesPurchases;
                group(HR_Rep)
                {
                    Caption = 'HR Reports';
                    Description = 'HR Reports';
                    Image = AdministrationSalesPurchases;
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
            group(Payroll_Reps1)
            {
                Caption = 'Payroll Reports';
                Description = 'Payroll Reports';
                Image = Administration;
                group(Payroll_Reps)
                {
                    Caption = 'Payroll Reports';
                    Description = 'Payroll Reports';
                    Image = Administration;
                    action("vew payslip")
                    {
                        ApplicationArea = Basic;
                        Caption = 'vew payslip';
                        Image = "report";
                        Promoted = true;
                        RunObject = Report "Individual Payslips mst";
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
                    action("bank Schedule")
                    {
                        ApplicationArea = Basic;
                        Caption = 'bank Schedule';
                        Image = "report";
                        Promoted = true;
                        RunObject = Report "pr Bank Schedule";
                    }
                    action("Master Payroll Summary")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Master Payroll Summary';
                        Image = "Report";
                        Promoted = true;
                        RunObject = Report "PRL-Company Payroll Summary 3";
                    }
                    action("Payroll summary")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Payroll summary';
                        Image = payslip;
                        RunObject = Report "PRL-Company Payroll Summary 3";
                    }
                    action("Deductions Summary")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Deductions Summary';
                        Image = summary;
                        RunObject = Report "PRL-Deductions Summary";
                    }
                    action("Earnings Summary")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Earnings Summary';
                        Image = DepositSlip;
                        RunObject = Report "PRL-Earnings Summary";
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
                    action("Staff pension")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Staff pension';
                        Image = Aging;
                        RunObject = Report "Staff Pension Report";
                    }
                    action("Gross Netpay")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Gross Netpay';
                        Image = Giro;
                        RunObject = Report prGrossNetPay;
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
                    action("Third Rule")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Third Rule';
                        Image = AddWatch;
                        RunObject = Report "A third Rule Report";
                    }
                    action("Co_op Remittance")
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
                }
            }
        }
        area(embedding)
        {
            action("<Page FIN-Posted Interbank Trans1")
            {
                ApplicationArea = Basic;
                Caption = 'Posted Intetrbank Transfers';
                RunObject = Page "FIN-Posted Interbank Trans.";
            }
            action("<Page FIN-Posted Receipts list1>")
            {
                ApplicationArea = Basic;
                Caption = 'Posted Receipts';
                RunObject = Page "FIN-Posted Receipts list";
            }
            action("Posted PVs")
            {
                ApplicationArea = Basic;
                Caption = 'Posted PVs';
                RunObject = Page "FIN-Posted Payment Vouch.";
            }
            action("Posted Imprest")
            {
                ApplicationArea = Basic;
                Caption = 'Posted Imprest';
                RunObject = Page "FIN-Posted imprest list";
            }
            action("Posted Imp. Surrender")
            {
                ApplicationArea = Basic;
                Caption = 'Posted Imp. Surrender';
                RunObject = Page "FIN-Posted Travel Advs. Acc.";
            }
            action("Poste Staff Advance")
            {
                ApplicationArea = Basic;
                Caption = 'Poste Staff Advance';
                RunObject = Page "FIN-Posted Staff Advance List";
            }
            action("Posted Advance Retiring")
            {
                ApplicationArea = Basic;
                Caption = 'Posted Advance Retiring';
                RunObject = Page "FIN-Posted staff Advance Surr.";
            }
            action("Account Schedules")
            {
                ApplicationArea = Basic;
                Caption = 'Account Schedules';
                RunObject = Page "Account Schedule Names";
            }
            action("Analysis by Dimensions")
            {
                ApplicationArea = Basic;
                Caption = 'Analysis by Dimensions';
                Image = AnalysisViewDimension;
                RunObject = Page "Analysis View List";
            }
            action("Sales Analysis Report")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Analysis Report';
                RunObject = Page "Analysis Report Sale";
                RunPageView = where("Analysis Area"=filter(Sales));
            }
            action(Budgets)
            {
                ApplicationArea = Basic;
                Caption = 'Budgets';
                RunObject = Page "G/L Budget Names";
            }
            action("Sales Budgets")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Budgets';
                RunObject = Page "Item Budget Names";
                RunPageView = where("Analysis Area"=filter(Sales));
            }
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Contacts)
            {
                ApplicationArea = Basic;
                Caption = 'Contacts';
                Image = CustomerContact;
                RunObject = Page "Contact List";
            }
        }
        area(sections)
        {
            Description = 'Management Menu Items';
            group(Financial_Management)
            {
                Caption = 'Financial Management';
                Description = 'Financial Management';
                Image = ResourcePlanning;
                action("Accounts/Votes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Accounts/Votes';
                    RunObject = Page "Chart of Accounts";
                }
                action(Budget)
                {
                    ApplicationArea = Basic;
                    Caption = 'Budget';
                    RunObject = Page "G/L Budget Names";
                }
                action(A_C_Categories)
                {
                    ApplicationArea = Basic;
                    Caption = 'Account Categories';
                    RunObject = Page "G/L Budget Names";
                }
                action("Bank Accounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Accounts';
                    RunObject = Page "Bank Account List";
                }
                action(Custo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customers';
                    RunObject = Page "Bank Account List";
                }
                action("Vendor/Suppliers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor/Suppliers';
                    RunObject = Page "Bank Account List";
                }
                action("Fixed Assets")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fixed Assets';
                    RunObject = Page "Fixed Asset List";
                }
                separator(Action1000000017)
                {
                }
                separator(Action1000000016)
                {
                    Caption = 'Historical Documents (Financial)';
                }
                separator(Action1000000019)
                {
                    Caption = 'Receivables';
                }
                action("Posted Shipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Shipments';
                    RunObject = Page "Posted Sales Shipments";
                }
                action("Posted Sales Invoices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page "Posted Sales Invoices";
                }
                action("Posted Receipt returns")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Receipt returns';
                    RunObject = Page "Posted Return Receipts";
                }
                action("Posted Sales Credir memos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Credir memos';
                    RunObject = Page "Posted Sales Credit Memos";
                }
                separator(Action1000000023)
                {
                    Caption = 'Payables';
                }
                separator(Action1000000024)
                {
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
                separator(Action1000000028)
                {
                    Caption = 'Fixed Assets';
                }
                separator(Action1000000027)
                {
                }
                action("FA Register")
                {
                    ApplicationArea = Basic;
                    Caption = 'FA Register';
                    RunObject = Page "FA Registers";
                }
                action("Insurance Register")
                {
                    ApplicationArea = Basic;
                    Caption = 'Insurance Register';
                    RunObject = Page "Insurance Registers";
                }
                action("Maintenance Register")
                {
                    ApplicationArea = Basic;
                    Caption = 'Maintenance Register';
                    RunObject = Page "Maintenance Ledger Entries";
                }
            }
            group(Funds_Man)
            {
                Caption = 'Funds Management';
                Description = 'Funds Management';
                Image = ReferenceData;
                action("Posted Inter-Bank Transfer")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Inter-Bank Transfer';
                    RunObject = Page "FIN-Posted Interbank Trans.";
                }
                action("Posted Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Receipts';
                    RunObject = Page "FIN-Posted Receipts list";
                }
                action(Action1000000111)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted PVs';
                    RunObject = Page "FIN-Posted Payment Vouch.";
                }
                action(Action1000000112)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Imprest';
                    RunObject = Page "FIN-Posted imprest list";
                }
                action(Action1000000113)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Imp. Surrender';
                    RunObject = Page "FIN-Posted Travel Advs. Acc.";
                }
                action(Action1000000114)
                {
                    ApplicationArea = Basic;
                    Caption = 'Poste Staff Advance';
                    RunObject = Page "FIN-Posted Staff Advance List";
                }
                action(Action1000000115)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Advance Retiring';
                    RunObject = Page "FIN-Posted staff Advance Surr.";
                }
            }
            group(Admissions)
            {
                Caption = 'Student Applications';
                Description = 'Student Applications';
                Image = LotInfo;
                action("Enquiry list")
                {
                    ApplicationArea = Basic;
                    Caption = 'Enquiry list';
                    RunObject = Page "ACA-Enquiry List";
                }
                action("Import Jab Admissions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Jab Admissions';
                    RunObject = Page "KUCCPS Imports";
                }
                action("Processed Jab Admissions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Processed Jab Admissions';
                    RunObject = Page "ACA-Processed GOK Admn Buffer";
                }
                action("<Page ACA-Print Admn Letter SSP")
                {
                    ApplicationArea = Basic;
                    Caption = 'Admissions letters list';
                    RunObject = Page "ACA-Print Admn Letter SSP/DIP";
                }
            }
            group(Student_Man)
            {
                Caption = 'Student Management';
                Description = 'Student Management';
                Image = Receivables;
                action(Registration)
                {
                    ApplicationArea = Basic;
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Std Registration List";
                }
                action(Cleared)
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Clearance(Cleared)';
                    RunObject = Page "ACA-Student Clearance(Cleared)";
                }
                action(AllumniList)
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Aluminae List';
                    RunObject = Page "ACA-Student Aluminae List";
                }
            }
            group(Exams)
            {
                Caption = 'Exams Management';
                Description = 'Exams Management';
                Image = SNInfo;
                action("Programmes List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Programmes List';
                    Image = FixedAssets;
                    RunObject = Page "ACA-Programmes List";
                }
                action("Grading System")
                {
                    ApplicationArea = Basic;
                    Caption = 'Grading System';
                    Image = SetupColumns;
                    Promoted = true;
                    RunObject = Page "ACA-Grading Sys. Header";
                }
                action(Examiners)
                {
                    ApplicationArea = Basic;
                    Caption = 'Examiners';
                    Image = HRSetup;
                    Promoted = true;
                    RunObject = Page "ACA-Examiners List";
                }
            }
            group(Cafeteria_Management)
            {
                Caption = 'Cafeteria Management';
                Description = 'Cafeteria Management';
                Image = CostAccounting;
                action("Receipts (Cancelled)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Receipts (Cancelled)';
                    RunObject = Page "CAT-Cancelled Cafeteria Recpts";
                }
                action("Receipts (Posted)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Receipts (Posted)';
                    RunObject = Page "CAT-Posted Cafeteria Receipts";
                }
            }
            group(Hostel_Management)
            {
                Caption = 'Hostel Management';
                Description = 'Hostel Management';
                Image = Marketing;
                action("Allocation (Uncleared)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Allocation (Uncleared)';
                    RunObject = Page "ACAHostel Bookings (All. List)";
                }
                action("Allocation History (Cleared)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Allocation History (Cleared)';
                    Image = Invoice;
                    Promoted = true;
                    RunObject = Page "ACA-Hostel Bookings (History)";
                }
            }
            group(HRM)
            {
                Caption = 'Human Resources Man.';
                Description = 'Human Resources Man.';
                Image = HumanResources;
                action(Action1000000158)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee List';
                    RunObject = Page "HRM-Employee List";
                }
                action("Posted Leaves")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Leaves';
                    RunObject = Page "HRM-Leave Requisition Posted";
                }
                action("Employee Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Requisitions';
                    Image = ApplicationWorksheet;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "HRM-Employee Requisitions List";
                }
            }
            group(Payroll)
            {
                Caption = 'Payroll management';
                Description = 'Payroll management';
                Image = HRSetup;
                action("Salary Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary Card';
                    Image = Employee;
                    Promoted = true;
                    RunObject = Page "HRM-Employee-List";
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Description = 'Approvals';
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
                Description = 'Common Requisitions';
                Image = FixedAssets;
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

