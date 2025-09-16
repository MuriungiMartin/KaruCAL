#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69251 "Deans Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control21;"ACA-Programmes List")
                {
                }
                part(Control1000000179;"ACA-Grading Sys. Header")
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
        }
        area(embedding)
        {
            action("Programmes List")
            {
                ApplicationArea = Basic;
                Caption = 'Programmes List';
                Image = FixedAssets;
                RunObject = Page "ACA-Programmes List";
            }
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
            action("Allocation (Uncleared)")
            {
                ApplicationArea = Basic;
                Caption = 'Allocation (Uncleared)';
                RunObject = Page "ACAHostel Bookings (All. List)";
            }
            action("Pending My Approval")
            {
                ApplicationArea = Basic;
                Caption = 'Pending My Approval';
                RunObject = Page "Approval Entries";
            }
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
        }
        area(sections)
        {
            Description = 'Management Menu Items';
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
                action(Registration1)
                {
                    ApplicationArea = Basic;
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Std Registration List";
                }
                action(Cleared2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Clearance(Cleared)';
                    RunObject = Page "ACA-Student Clearance(Cleared)";
                }
                action(AllumniList3)
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
                action(Action1000000118)
                {
                    ApplicationArea = Basic;
                    Caption = 'Programmes List';
                    Image = FixedAssets;
                    RunObject = Page "ACA-Programmes List";
                }
                action(Action1000000117)
                {
                    ApplicationArea = Basic;
                    Caption = 'Grading System';
                    Image = SetupColumns;
                    Promoted = true;
                    RunObject = Page "ACA-Grading Sys. Header";
                }
                action(Action1000000116)
                {
                    ApplicationArea = Basic;
                    Caption = 'Examiners';
                    Image = HRSetup;
                    Promoted = true;
                    RunObject = Page "ACA-Examiners List";
                }
            }
            group(Hostel_Management)
            {
                Caption = 'Hostel Management';
                Description = 'Hostel Management';
                Image = Marketing;
                action(Action1000000145)
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
            group(Approvals)
            {
                Caption = 'Approvals';
                Description = 'Approvals';
                Image = Alerts;
                action(Action1000000100)
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
                action(Action1000000096)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stores Requisitions';
                    RunObject = Page "PROC-Store Requisition";
                }
                action(Action1000000095)
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Requisitions';
                    RunObject = Page "FIN-Imprest List UP";
                }
                action(Action1000000094)
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

