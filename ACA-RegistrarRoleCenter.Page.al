#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 79002 "ACA-Registrar Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control10)
            {
                part(Control8;"ACA-Std Card List")
                {
                    Caption = 'Students List';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("General Setups")
            {
                Caption = 'Setups';
                group(SetupsG)
                {
                    Caption = 'General Setups';
                    Image = Administration;
                    action(Programs)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Programs';
                        Image = FixedAssets;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Programmes List";
                    }
                    action(Semesters)
                    {
                        ApplicationArea = Basic;
                        Image = FixedAssetLedger;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "ACA-Semesters - Academics";
                    }
                    action("Academic Year")
                    {
                        ApplicationArea = Basic;
                        Image = Calendar;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "ACA-Academic Year List";
                    }
                    action("General Setup")
                    {
                        ApplicationArea = Basic;
                        Image = SetupLines;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "ACA-General Set-Up";
                    }
                    action("Modes of Study")
                    {
                        ApplicationArea = Basic;
                        Image = Category;
                        Promoted = true;
                        RunObject = Page "ACA-Student Types";
                    }
                    action("Insurance Companies")
                    {
                        ApplicationArea = Basic;
                        Image = Insurance;
                        Promoted = true;
                        RunObject = Page "Casual Import List";
                    }
                    action("Application Setups")
                    {
                        ApplicationArea = Basic;
                        Image = SetupList;
                        Promoted = true;
                        RunObject = Page "ACA-Application Setup";
                    }
                    action("Admission Number Setup")
                    {
                        ApplicationArea = Basic;
                        Image = SetupColumns;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "ACA-Admn Number Setup";
                    }
                    action("Admission Subjects")
                    {
                        ApplicationArea = Basic;
                        Image = GeneralPostingSetup;
                        Promoted = true;
                        RunObject = Page "ACA-Appication Setup Subject";
                    }
                    action("Marketing Strategies")
                    {
                        ApplicationArea = Basic;
                        Image = MarketingSetup;
                        Promoted = true;
                        RunObject = Page "HRM-Courses Card";
                    }
                    action("Import Data for Update")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Import Data for Update';
                        Image = ImportDatabase;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Std. Data Buffer";
                    }
                    action("Import Course Reg. Buffer")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Import Course Reg. Buffer';
                        Image = RegisterPutAway;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Course Reg. Buffer";
                    }
                    action("Exam Setup")
                    {
                        ApplicationArea = Basic;
                        Caption = '<Exam Setup>';
                        Image = SetupColumns;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "ACA-Exam Setups";
                    }
                    action("Grading System")
                    {
                        ApplicationArea = Basic;
                        Image = Setup;
                        Promoted = true;
                        RunObject = Page "ACA-Grading Sys. Header";
                    }
                    action("Lecturer List")
                    {
                        ApplicationArea = Basic;
                        Image = Employee;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Lecturers Units";
                    }
                    action("Import Units")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Import Units';
                        Image = ImportCodes;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = XMLport UnknownXMLport50155;
                    }
                    action("Import Units (Buffered)")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Import Units (Buffered)';
                        Image = ImportLog;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Prog. Units Buffer";
                    }
                    action(ImportCerts)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Import Graduation Certificates';
                        Image = ImportExport;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Graduated Studnets Upload";
                    }
                    action(PostedCertUpdates)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Certificates';
                        Image = ImportLog;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Posted Graduants";
                    }
                }
            }
            group("Application and Admission")
            {
                group(AppliAdmin)
                {
                    Caption = 'Applications & General setup';
                    Image = Job;
                    action("Online Enquiries")
                    {
                        ApplicationArea = Basic;
                        Image = NewOrder;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Enquiry Form";
                    }
                    action("Online Applications")
                    {
                        ApplicationArea = Basic;
                        Image = NewCustomer;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "HRM-Activity Participants SF";
                    }
                    action("Admission Applications")
                    {
                        ApplicationArea = Basic;
                        Image = NewCustomer;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "PROC-Posted Store Reqs";
                    }
                    action("Approved Applications")
                    {
                        ApplicationArea = Basic;
                        Image = Archive;
                        Promoted = true;
                        RunObject = Page "ACA-Approved Applications List";
                    }
                    action("Admission Letters")
                    {
                        ApplicationArea = Basic;
                        Image = CustomerList;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Admn Letters Direct";
                    }
                    action("Admitted Applicants")
                    {
                        ApplicationArea = Basic;
                        Image = Archive;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Admitted Applicants List";
                    }
                }
            }
            group("Admission History")
            {
                group(AdminHist)
                {
                    Caption = 'Admissions History';
                    Image = History;
                    action("Pending Admissions")
                    {
                        ApplicationArea = Basic;
                        Image = History;
                        Promoted = true;
                        RunObject = Page "ACA-Pending Admissions List";
                    }
                    action("Rejected Applications")
                    {
                        ApplicationArea = Basic;
                        Image = Reject;
                        Promoted = true;
                        RunObject = Page "ACA-Rejected Applications List";
                    }
                    action("Cancelled Applications")
                    {
                        ApplicationArea = Basic;
                        Image = Cancel;
                        Promoted = true;
                        RunObject = Page "ACA-Cancelled ApplicsList";
                    }
                }
            }
            group("Admission Reports")
            {
                group(AdminReports)
                {
                    Caption = 'Admission Reports';
                    Image = ResourcePlanning;
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
                        RunObject = Report "Application List";
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
                    action("Application List")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Application List Academic New";
                    }
                    action("Email List")
                    {
                        ApplicationArea = Basic;
                        RunObject = Report "All Students222";
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
            group(Academics)
            {
                group(Academics2)
                {
                    Caption = 'Academic';
                    Image = Departments;
                    action("Student Registration")
                    {
                        ApplicationArea = Basic;
                        Image = Register;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Std Registration List";
                    }
                    action("Student Card")
                    {
                        ApplicationArea = Basic;
                        Image = Registered;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Std Card List";
                    }
                    action(Alumni)
                    {
                        ApplicationArea = Basic;
                        Image = History;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Student Aluminae List";
                    }
                    action("Lecturers List")
                    {
                        ApplicationArea = Basic;
                        Image = Resource;
                        Promoted = true;
                        RunObject = Page "ACA-Lecturer List";
                    }
                }
            }
            group("Periodic Activities")
            {
                group(PerAc)
                {
                    Caption = 'Periodic Activities';
                    Image = Transactions;
                    action("Graduation Charges (Unposted)")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Graduation Charges (Unposted)';
                        Image = UnApply;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Grad. Charges (Unposted)";
                    }
                    action(GenGraduInd)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Generate Graduation Charges (Individual Students)';
                        Image = GetEntries;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Graduation Fee Generator";
                    }
                }
            }
            group("Academic reports")
            {
                group(AcadReports)
                {
                    Caption = 'Academic reports';
                    Image = RegisteredDocs;
                    action("Norminal Roll")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Norminal Roll (Cont. Students)";
                    }
                    action("Enrollment Statistics")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Students Enrolment";
                    }
                    action("Student Balances")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "stud list new";
                    }
                    action("Fee Statements")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Student Fee Statement 2";
                    }
                    action("Statistics By Programme Category")
                    {
                        ApplicationArea = Basic;
                        Image = Statistics;
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Population By Prog. Category";
                    }
                }
            }
            group(StudClearHeader)
            {
                Caption = 'Student Clearance';
            }
            group(StudClear)
            {
                Caption = 'Student Clearance';
            }
            action("Clearance Levels")
            {
                ApplicationArea = Basic;
                Caption = 'Clearance Levels';
                Image = CreateInventoryPickup;
                Promoted = true;
                RunObject = Page "ACA-Clearance Code Levels";
            }
        }
        area(embedding)
        {
            group("Student Management Setups")
            {
                Caption = 'Academic Setups';
                action("program List")
                {
                    ApplicationArea = Basic;
                    Caption = 'program List';
                    Image = FixedAssets;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Programmes List";
                }
                action("Semester Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester Setup';
                    Image = FixedAssetLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "ACA-Semesters - Academics";
                }
                action("Academic Year Manager")
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Year Manager';
                    Image = Calendar;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "ACA-Academic Year List";
                }
            }
            group("Applications/Admissions")
            {
                action("Applications (Online)")
                {
                    ApplicationArea = Basic;
                    Image = NewCustomer;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Online Application List";
                }
                action("Applications - Direct ")
                {
                    ApplicationArea = Basic;
                    Image = NewCustomer;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Application Form H. list";
                }
                action("Applicant Admission Letters")
                {
                    ApplicationArea = Basic;
                    Image = CustomerList;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Admn Letters Direct";
                }
                action("Admissions (New)")
                {
                    ApplicationArea = Basic;
                    Image = NewItem;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-New Admissions List";
                }
            }
            group("General Academics")
            {
                action(Registration2)
                {
                    ApplicationArea = Basic;
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Std Registration List";
                }
                action("Students Card2")
                {
                    ApplicationArea = Basic;
                    Image = Registered;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Std Card List";
                }
            }
            group("Periodic Functions")
            {
            }
        }
        area(sections)
        {
            group("PSSP Admissions")
            {
                Caption = 'PSSP Admissions';
                Image = RegisteredDocs;
                action("Enquiry list")
                {
                    ApplicationArea = Basic;
                    Caption = 'Enquiry list';
                    RunObject = Page "ACA-Enquiry List";
                }
                action("Enquiry List (Pending)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Enquiry List (Pending)';
                    RunObject = Page "ACA-Enquiry (Pending Approval)";
                }
                action("Enquiry List (Rejected)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Enquiry List (Rejected)';
                    RunObject = Page "ACA-Enquiry (Rejected)";
                }
                action(Applications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Applications';
                    RunObject = Page "ACA-Application Form H. list";
                }
                action("Dean's Commitee")
                {
                    ApplicationArea = Basic;
                    Caption = 'Dean''s Commitee';
                    RunObject = Page "ACA-Applic. Form Board Process";
                    Visible = false;
                }
                action("Admissions letters list")
                {
                    ApplicationArea = Basic;
                    Caption = 'Admissions letters list';
                    RunObject = Page "ACA-Print Admn Letter SSP/DIP";
                    Visible = true;
                }
                action("pending documents verification (PSSP)")
                {
                    ApplicationArea = Basic;
                    Caption = 'pending documents verification (PSSP)';
                    RunObject = Page "ACA-Pending Admissions PSSP";
                    Visible = true;
                }
                action(Admitted_PSSP)
                {
                    ApplicationArea = Basic;
                    Caption = 'Admitted Students - PSSP';
                    RunObject = Page "ACA-Admitted PSSP";
                }
            }
            group("KUCCPS Admission")
            {
                Caption = 'KUCCPS Admission';
                Image = Transactions;
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
                    Visible = false;
                }
                action(Action46)
                {
                    ApplicationArea = Basic;
                    Caption = 'Admissions letters list';
                    RunObject = Page "ACA-Print Admn Letter SSP/DIP";
                    Visible = false;
                }
                action("pending documents verification")
                {
                    ApplicationArea = Basic;
                    Caption = 'pending documents verification';
                    RunObject = Page "ACA-Pending Admissions List";
                }
                action("pending payments confirmation")
                {
                    ApplicationArea = Basic;
                    Caption = 'pending payments confirmation';
                    RunObject = Page "ACA-Pending Payments List";
                    Visible = false;
                }
                action("pending Admission confirmation")
                {
                    ApplicationArea = Basic;
                    Caption = 'pending Admission confirmation';
                    RunObject = Page "ACA-Pending Admission Confirm.";
                    Visible = false;
                }
                action(Admitted_Kuccps)
                {
                    ApplicationArea = Basic;
                    Caption = 'Admitted Students - KUCCPS';
                    RunObject = Page "ACA-Admitted KUCCPS";
                }
            }
            group(NewKUCCPSFlow)
            {
                Caption = 'New KUCCPS Flow';
                Image = Transactions;
                action(NewKUCCPSAdmissions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Admission Batches';
                    Image = AdjustExchangeRates;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "ACA-Academic Year 4 Admissions";
                }
            }
            group("Students Management")
            {
                Caption = 'Students Management';
                Image = ResourcePlanning;
                action(Registration)
                {
                    ApplicationArea = Basic;
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Std Registration List";
                }
                action("Students Card")
                {
                    ApplicationArea = Basic;
                    Image = Registered;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Std Card List";
                }
                action(Programmes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Programmes';
                    RunObject = Page "ACA-Programmes List";
                }
                action("Signing of Norminal Role")
                {
                    ApplicationArea = Basic;
                    Caption = 'Signing of Norminal Role';
                    RunObject = Page "ACA-Norminal Role Signing";
                }
                action("Class Allocations")
                {
                    ApplicationArea = Basic;
                    Image = Allocate;
                    RunObject = Page "HRM-Class Allocation List";
                }
            }
            group(Clearances)
            {
                Caption = 'Student Clearance';
                Image = Intrastat;
                action(OpenClearance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Clearance (Open)';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Student Clearance (Open)";
                }
                action(ActiveClearance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Clearance (Active)';
                    Image = Registered;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Student Clearance (Active)";
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
            group(Setups)
            {
                Caption = 'Setups';
                Image = Setup;
                action(Action48)
                {
                    ApplicationArea = Basic;
                    Caption = 'Programmes';
                    RunObject = Page "ACA-Programmes List";
                }
                action(Nationality)
                {
                    ApplicationArea = Basic;
                    Caption = 'Nationality';
                    RunObject = Page "GEN-Nationality List";
                }
                action("Marketing Strategies")
                {
                    ApplicationArea = Basic;
                    Caption = 'Marketing Strategies';
                    RunObject = Page "ACA-Marketing Strategies";
                }
                action("Schools/Faculties")
                {
                    ApplicationArea = Basic;
                    Caption = 'Schools/Faculties';
                    RunObject = Page "ACA-Schools/Faculties";
                }
                action(Religions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Religions';
                    RunObject = Page "GEN-Religions";
                }
                action(Denominations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Denominations';
                    RunObject = Page "GEN-Denominations";
                }
                action("Insurance Companies")
                {
                    ApplicationArea = Basic;
                    Caption = 'Insurance Companies';
                    RunObject = Page "REG-Registry Files View";
                }
                action(Relationships)
                {
                    ApplicationArea = Basic;
                    Caption = 'Relationships';
                    RunObject = Page "GEN-Relationships";
                }
                action(Counties)
                {
                    ApplicationArea = Basic;
                    Caption = 'Counties';
                    RunObject = Page "GEN-Counties List";
                }
                action("Clearance Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Clearance Codes';
                    Image = Setup;
                    RunObject = Page "ACA-Clearance Code Levels";
                }
                action("Registration List")
                {
                    ApplicationArea = Basic;
                    Image = Allocations;
                    RunObject = Page "ACA-Course Reg. Listing";
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
        area(reporting)
        {
            group(Periodic)
            {
                Caption = 'Periodic Reports';
                group(AcadReports2)
                {
                    Caption = 'Academic Reports';
                    Image = AnalysisView;
                    action("CUE Report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'CUE Report';
                        Image = BreakRulesList;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "CUE Report";
                    }
                    action("All Students")
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        RunObject = Report "All Students";
                    }
                    action("Student Applications Report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Student Applications Report';
                        Image = "Report";
                        RunObject = Report "Student Applications Report";
                    }
                    action("Nominal Roll")
                    {
                        ApplicationArea = Basic;
                        RunObject = Report "Norminal Roll (Enrol Students)";
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
                    action(Action62)
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
                    action("Clearance report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Clearance report';
                        Image = AllocatedCapacity;
                        Promoted = true;
                        RunObject = Report "ACA-Student Clearance List";
                    }
                    action("Update Adm Documents Verified")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        RunObject = Report "Modify Adm Documents Verified";
                    }
                }
                group("Before Exams")
                {
                    Caption = 'Before Exams';
                    Visible = false;
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
                }
                group("Students Finance Reports")
                {
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
                    action("NFM Fee Letter")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        RunObject = Report "Fee Payment Letter";
                    }
                    action("NFM Household Fee Statement")
                    {
                        ApplicationArea = Basic;
                        RunObject = Report "Student Fee Statement Nfm";
                    }
                }
            }
        }
    }
}

