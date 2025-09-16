#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78121 "ACA-Exams2 Man. Role Centre"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1904484608;"ACA-Programmes List")
                {
                    Caption = 'Programmes List';
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action("Students List")
            {
                ApplicationArea = Basic;
                Caption = 'Students List';
                Image = UserSetup;
                RunObject = Page "ACA-Examination Stds List";
            }
            action("<Page ACA-Std Card List>")
            {
                ApplicationArea = Basic;
                Caption = 'Students Card';
                Image = Registered;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "ACA-Std Card List";
            }
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
            action("Results Status List")
            {
                ApplicationArea = Basic;
                Caption = 'Results Status List';
                Image = Status;
                Promoted = true;
                RunObject = Page "ACA-Senate Report Lubrics";
            }
        }
        area(processing)
        {
            group("General Setups")
            {
                Caption = 'Setups';
                action("Process Marks")
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Marks';
                    Image = AdjustEntries;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Process Exams Central Gen.";
                }
                action("Process Graduation")
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Graduation';
                    Image = AddAction;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Process Graduation Params";
                }
                action("Senate Preview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Senate Preview';
                    Image = PreviewChecks;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Exam. Senate Review";
                }
                action("1st Supp. Preview")
                {
                    ApplicationArea = Basic;
                    Caption = '1st Supp. Preview';
                    Image = PrintAttachment;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-1st Supp Senate Review";
                }
                action("2nd Supp. Preview")
                {
                    ApplicationArea = Basic;
                    Caption = '2nd Supp. Preview';
                    Image = Reserve;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-2nd Supp Senate Review";
                }
                action("Graduation Review")
                {
                    ApplicationArea = Basic;
                    Caption = 'Graduation Review';
                    Image = AddToHome;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Graduation Overview";
                }
                action("Student List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student List';
                    Image = CalculateConsumption;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Deans Student List";
                }
                action("Examination Module Guide")
                {
                    ApplicationArea = Basic;
                    Caption = 'Examination Module Guide';
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report UnknownReport99930;
                }
                action("Import Results")
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Results';
                    Image = UserSetup;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Exam Results Buffer 2";
                }
            }
            group(ExamReports)
            {
                Caption = 'Examination Reports';
                action(ExamCards)
                {
                    ApplicationArea = Basic;
                    Caption = 'Exam Card';
                    Image = ActivateDiscounts;
                    Promoted = true;
                    RunObject = Report "Exam Card 2";
                }
            }
            group(AcadReportss)
            {
                Caption = 'Academics';
                Image = AnalysisView;
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
                    action("Clearance report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Clearance report';
                        Image = AllocatedCapacity;
                        Promoted = true;
                        RunObject = Report "ACA-Student Clearance List";
                    }
                }
            }
            group("Exam Reports")
            {
                Caption = 'Exam Reports';
                group(ExamExams)
                {
                    Caption = 'After Exams';
                    Enabled = true;
                    Image = "Report";
                    Visible = true;
                    action(ConsMarkssheet)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Consolidated Marksheet';
                        Image = CompleteLine;
                        Promoted = true;
                        RunObject = Report "ACA-Consolidated Marksheet 1";
                    }
                    action("Supp. Consolidated Marksheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Supp. Consolidated Marksheet';
                        Image = Completed;
                        Promoted = true;
                        RunObject = Report "ACA-Supp. Cons. Marksheet";
                    }
                    action("Supp. Consolidated Marksheet B")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Supp. Consolidated Marksheet B';
                        Image = Completed;
                        Promoted = true;
                        RunObject = Report "ACA-Supp. Cons. Marksheet 2";
                        Visible = false;
                    }
                    action("Supplementary Senate Summary")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Supplementary Senate Summary';
                        Image = Alerts;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Aca-Supp. Senate Summary";
                    }
                    action("2nd Supp. Marksheet")
                    {
                        ApplicationArea = Basic;
                        Caption = '2nd Supp. Marksheet';
                        Image = Completed;
                        Promoted = true;
                        RunObject = Report "ACA-2nd Supp. Cons. Marksheet";
                    }
                    action("2nd Supp. Marksheet B")
                    {
                        ApplicationArea = Basic;
                        Caption = '2nd Supp. Marksheet B';
                        Image = Completed;
                        Promoted = true;
                        RunObject = Report "ACA-2ndSupp. Cons. Marksheet 2";
                        Visible = false;
                    }
                    action("2nd Supp. Senate Summary")
                    {
                        ApplicationArea = Basic;
                        Caption = '2nd Supp. Senate Summary';
                        Image = Alerts;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Aca-2NdSupp. Senate Summary";
                    }
                    action("Consolidated Marksheet 2")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Consolidated Marksheet 2';
                        Image = CompleteLine;
                        Promoted = true;
                        RunObject = Report "Final Consolidated Marksheet";
                        Visible = false;
                    }
                    action("Consolidated Marksheet 3")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Consolidated Marksheet 3';
                        RunObject = Report "Consolidated Marksheet 2";
                        Visible = false;
                    }
                    action("Senate Report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Senate Report';
                        Image = Agreement;
                        Promoted = true;
                        RunObject = Report "Aca-General Senate Summary";
                    }
                    action("Senate Summary Report 2")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Senate Summary Report 2';
                        Image = "report";
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report UnknownReport81800;
                        Visible = false;
                    }
                    action(Attendance_Checklist)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Attendance Checklist';
                        Image = BulletList;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Exam Attendance Checklist2";
                    }
                    action("Class Grade Sheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Class Grade Sheet';
                        Image = CheckDuplicates;
                        Promoted = true;
                        RunObject = Report "ACA-Class Roster Grade Sheet";
                        Visible = false;
                    }
                    action("Consolidated Gradesheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Consolidated Gradesheet';
                        Image = CheckDuplicates;
                        Promoted = true;
                        RunObject = Report "ACA-Consolidated Gradesheet";
                        Visible = false;
                    }
                    action("Provisional Transcript")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Provisional Transcript';
                        Image = FixedAssets;
                        Promoted = true;
                        RunObject = Report "Provisional College Transcrip3";
                    }
                    action("Official University Resultslip")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Official University Resultslip';
                        Image = Giro;
                        Promoted = true;
                        RunObject = Report "Official University Resultslip";
                    }
                    action("Marks Entry Statistics")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Marks Entry Statistics';
                        Image = "Report";
                        RunObject = Report "Lecturer Exam Entry Statistics";
                    }
                    action("Official Transcript")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Official Transcript';
                        Image = Split;
                        Promoted = true;
                        RunObject = Report "Final Transcript";
                    }
                    action("Check Exam Results")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Check Exam Results';
                        Image = Design;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Check Marks";
                    }
                    action("Student Progress Report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Student Progress Report';
                        Image = Agreement;
                        RunObject = Report "Student Progress Report";
                    }
                }
                group(GradReports)
                {
                    Caption = 'Graduation Reports';
                    Enabled = true;
                    Image = "Report";
                    action("Classification List")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Classification List';
                        Image = Completed;
                        Promoted = true;
                        RunObject = Report "ACA-Classification List";
                    }
                    action("Classification (Incompletes)")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Classification (Incompletes)';
                        Image = InsertBalanceAccount;
                        Promoted = true;
                        RunObject = Report "ACA-Classification Incomplete";
                    }
                    action("Graduation List")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Graduation List';
                        Image = CompleteLine;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "ACA-Graduation List";
                    }
                    action("Final Consolidated Marksheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Final Consolidated Marksheet';
                        Image = CompleteLine;
                        Promoted = true;
                        RunObject = Report "ACA-Final Cons. Grad.";
                    }
                    action(GradMarkshee2)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Final Consolidated Marksheet';
                        Image = CompleteLine;
                        Promoted = true;
                        RunObject = Report "ACA-Grad. Cons. Marksheet";
                        Visible = false;
                    }
                    action("Summary Classification Marksheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Summary Classification Marksheet';
                        Image = Aging;
                        Promoted = true;
                        PromotedIsBig = false;
                        RunObject = Report "Aca-Summ. Classification List";
                    }
                    action("Incomplete List (Detailed)")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Incomplete List (Detailed)';
                        Image = Continue;
                        Promoted = true;
                        RunObject = Report "Reasons for Incomplete";
                    }
                    action("Failed Units List")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Failed Units List';
                        Image = ContractPayment;
                        Promoted = true;
                        RunObject = Report "ACA-Classification Incomplete";
                    }
                    action("Graduation Progress Report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Graduation Progress Report';
                        Image = CreateJobSalesCreditMemo;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report UnknownReport66629;
                    }
                    action(SenateReport)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Senate Report';
                        Image = Agreement;
                        Promoted = true;
                        RunObject = Report "Aca-General Senate Summary";
                    }
                    action("Cummulative Resit List")
                    {
                        ApplicationArea = Basic;
                        Image = BulletList;
                        Promoted = true;
                        RunObject = Report UnknownReport78045;
                    }
                    action("Cummulative Halt List")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cummulative Halt List';
                        Image = CalcWorkCenterCalendar;
                        Promoted = true;
                        RunObject = Report "Reversal Register";
                    }
                }
                group(OldReports)
                {
                    Caption = 'Old Exam Reports';
                    Image = Transactions;
                    Visible = false;
                    action(Cons1)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Semester Consolidated Marksheet';
                        Image = Completed;
                        Promoted = true;
                        RunObject = Report "Sem Consolidated Marksheet";
                        Visible = false;
                    }
                    action(FinCons1)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Consolidated Marksheet';
                        Image = CompleteLine;
                        Promoted = true;
                        RunObject = Report "Final Consolidated Marksheet";
                    }
                    action(ResultsCat)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Results Senate Summary';
                        Image = CheckDuplicates;
                        Promoted = true;
                        RunObject = Report "Results Category Summary";
                    }
                    action(FinCons2)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Supp. Consolidated Marksheet';
                        Image = Components;
                        Promoted = true;
                        RunObject = Report "Supp. Final Cons. Marksheet";
                    }
                    action(SuppCons)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Supp. Results Senate Summary';
                        Image = CheckJournal;
                        Promoted = true;
                        RunObject = Report "Supp. Results Category Summary";
                    }
                    action(FinalCOnsSumm)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Final Consolidated Marksheet';
                        Image = ContactFilter;
                        Promoted = true;
                        RunObject = Report "Final Consolidate Marksheet 1";
                    }
                    action(FinSenate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Classification Summary';
                        Image = CompareContacts;
                        Promoted = true;
                        RunObject = Report "Final Senate Classification";
                    }
                    action(GradSumm)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Graduation Summary';
                        Image = ApplyTemplate;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Senate Summary of Graduation";
                    }
                    action(ClassMarkSheet)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Classification Marksheet';
                        Image = Worksheet;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Classification Marksheet";
                    }
                    action(ConsD)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Consolidated Marksheet 3';
                        RunObject = Report "Consolidated Marksheet Detaile";
                        Visible = false;
                    }
                    action(AttendCheck)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Attendance Checklist';
                        RunObject = Report "Exam Attendance Checklist2";
                    }
                    action(Transc)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Official University Transcript';
                        Image = FixedAssets;
                        Promoted = true;
                        RunObject = Report "Official University Transcript";
                    }
                    action(ResultSlip)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Official University Resultslip';
                        Image = Split;
                        Promoted = true;
                        RunObject = Report "Official University Resultslip";
                    }
                    action(OfficialProv)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Provisional Transcript';
                        Image = CheckJournal;
                        Promoted = true;
                        RunObject = Report "Official Provisional TS";
                        Visible = true;
                    }
                    action(LectCoload)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Course Loading';
                        Image = LineDiscount;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Lecturer Course Loading";
                    }
                }
            }
            group("Time Table")
            {
                Caption = 'Time Tabling';
                Image = Statistics;
                action("Automatic Timetable")
                {
                    ApplicationArea = Basic;
                    Caption = 'Automatic Timetable';
                    Image = ListPage;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "ACA-Auto_Time Table";
                }
                action("Manual Timetable")
                {
                    ApplicationArea = Basic;
                    Caption = 'Manual Timetable';
                    Image = ListPage;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "ACA-Manual Time Table";
                }
                action("Semi Auto Time Table")
                {
                    ApplicationArea = Basic;
                    Caption = 'Semi Auto Time Table';
                    Image = ListPage;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "ACA-Time Table Header";
                }
            }
            group("Time Table Reports")
            {
                Caption = 'Time Table Reports';
                group("Periodic Activities")
                {
                    Caption = 'Periodic Activities';
                    Image = LotInfo;
                    action("Raw Marks")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Raw Marks';
                        Image = ImportExcel;
                        Promoted = true;
                        RunObject = Page "ACA-Exam Results Raw Buffer";
                    }
                    action("Exam Results Buffer")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Exam Results Buffer';
                        Image = UserSetup;
                        RunObject = Page "ACA-Exam Results Buffer 2";
                    }
                    action(Action1000000051)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Students List';
                        Image = UserSetup;
                        RunObject = Page "ACA-Examination Stds List";
                    }
                    action("Export Template")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Export Template';
                        Image = Export;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = XMLport UnknownXMLport39005508;
                    }
                    action(Import_Exam_Results)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Import Exam Results';
                        Image = ImportCodes;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = XMLport UnknownXMLport39005507;
                    }
                    action("Validate Exam Marks")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Validate Exam Marks';
                        Image = ValidateEmailLoggingSetup;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Report "Validate  Units";
                    }
                    action("Check Marks")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Check Marks';
                        Image = CheckList;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Report "Check Marks";
                    }
                    action(Action1000000046)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Process Marks';
                        Image = Accounts;
                        RunObject = Report "Process Marks";
                    }
                    action(Timetable)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Timetable';
                        Image = Template;
                        Promoted = true;
                        RunObject = Page "ACA-Timetable Header";
                    }
                    action("Validate Units")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Validate Units';
                        RunObject = Report "Validate  Units";
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
                group(ActionGroup1000000037)
                {
                    Caption = 'Time Table Reports';
                    Image = Statistics;
                    action(Master)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Master';
                        Image = Report2;
                        //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedIsBig = true;
                        RunObject = Report "Time Table";
                    }
                    action(Individual)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Individual';
                        Image = Report2;
                        //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedIsBig = true;
                        RunObject = Report "Individual Time Table-General";
                    }
                    action(TT)
                    {
                        ApplicationArea = Basic;
                        Caption = 'TT';
                        Image = Addresses;
                        RunObject = Report "Time table2";
                    }
                    action(Stage)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Stage';
                        Image = Report2;
                        //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedIsBig = true;
                        RunObject = Report "Time Table - By Stage";
                    }
                    action("Lecturer Room")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Lecturer Room';
                        Image = Report2;
                        //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedIsBig = true;
                        RunObject = Report "Time Table - By Lecturer Room";
                    }
                    action(Lecturer)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Lecturer';
                        Image = Report2;
                        //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedIsBig = true;
                        RunObject = Report "Time Table - By Lecturer";
                    }
                    action(Exam)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Exam';
                        Image = Report2;
                        //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedIsBig = true;
                        RunObject = Report "Time Table - By Exam";
                    }
                    action(Course)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Course';
                        Image = Report2;
                        //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedIsBig = true;
                        RunObject = Report "Time Table - By Courses";
                    }
                    action("Course 2")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Course 2';
                        Image = Report2;
                        //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedIsBig = true;
                        RunObject = Report "Time Table - By Courses 2";
                    }
                }
            }
            group(Setups1)
            {
                Caption = 'Exam Setups';
                group(Setups)
                {
                    Caption = 'Setups';
                    Image = Setup;
                    action("Lecturers Units")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Lecturers Units';
                        Image = VendorLedger;
                        Promoted = true;
                        RunObject = Page "ACA-Lecturers Units";
                    }
                    action("Programme List")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Programme List';
                        Image = FixedAssets;
                        RunObject = Page "ACA-Programmes List";
                    }
                    action("Exam Setups")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Exam Setups';
                        Image = SetupLines;
                        Promoted = true;
                        RunObject = Page "ACA-Exam Setups";
                    }
                    action(Action1000000022)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Grading System';
                        Image = Setup;
                        Promoted = true;
                        PromotedCategory = New;
                        RunObject = Page "ACA-Grading Sys. Header";
                    }
                    action(Action1000000021)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Lecturers Units';
                        Image = VendorLedger;
                        Promoted = true;
                        RunObject = Page "ACA-Lecturers Units";
                    }
                    action("General Setup")
                    {
                        ApplicationArea = Basic;
                        Caption = 'General Setup';
                        Image = GeneralPostingSetup;
                        Promoted = true;
                        RunObject = Page "ACA-General Set-Up";
                    }
                    action("Academic Year")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Academic Year';
                        Image = Calendar;
                        Promoted = true;
                        RunObject = Page "ACA-Academic Year List";
                    }
                    action(Rubrics)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Rubrics';
                        Image = Status;
                        RunObject = Page "ACA-Senate Report Lubrics";
                    }
                    action("Rubrics (Med/Nursing)")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Rubrics (Med/Nursing)';
                        Image = StopPayment;
                        RunObject = Page "ACA-BMED Senate Rubrics";
                        Visible = false;
                    }
                    action("Classification Rubrics")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Classification Rubrics';
                        Image = AddWatch;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Class/Grad. Lubrics";
                    }
                    action("Supplementary Rubrics")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Supplementary Rubrics';
                        Image = StepInto;
                        RunObject = Page "ACA-Supp. Gen. Rubrics";
                        Visible = false;
                    }
                    action("BulkUnitsRegistration ")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Bulk Units Registration';
                        Image = BinContent;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Bulk Units Reg. List";
                    }
                    action(UpdateUnitsForEvaluation)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Update Evaluation Units';
                        Image = BreakRulesOff;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report Update_Lect_Evaluation_Params;
                    }
                }
            }
        }
        area(sections)
        {
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;
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
                    RunObject = Page "ACA-Semesters List";
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
                action("Clearance Requests")
                {
                    ApplicationArea = Basic;
                    Caption = 'Clearance Requests';
                    RunObject = Page "ACA-Clearance Approval Entries";
                }
                action("test report")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}

