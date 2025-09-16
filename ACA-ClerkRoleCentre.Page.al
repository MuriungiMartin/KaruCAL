#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80002 "ACA-Clerk Role Centre"
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
        }
        area(processing)
        {
            group(AcadReportss)
            {
                Caption = 'Academics';
                Image = AnalysisView;
            }
            group("Attendance Reports")
            {
                Caption = 'Attendance Reports';
                group("Attendance Sheets")
                {
                    Caption = 'Attendance Sheets';
                    Enabled = true;
                    Image = "Report";
                    Visible = true;
                    action(Attendance_Checklist)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Attendance Checklist';
                        Image = BulletList;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Exam Attendance Checklist2";
                    }
                    action(SuppExamAttendance)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Attendance Checklist (Supps)';
                        Image = AdjustItemCost;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Supp. Exam Att. Checklist";
                    }
                    action("Special Attendance Checklist")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Special Attendance Checklist';
                        Image = CalculateHierarchy;
                        RunObject = Report "Special Exam Att. Checklist";
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
            group("Academic Reports")
            {
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
            group("Time Table Reports")
            {
                Caption = 'Time Table Reports';
                group("Periodic Activities")
                {
                    Caption = 'Periodic Activities';
                    Image = LotInfo;
                    action(ResultsBuffer)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Results Buffer';
                        Image = BulletList;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Page "ACA-Results Buffer Header List";
                        Visible = false;
                    }
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
                    action("Update Buffering Setup")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Update Buffering Setup';
                        Image = UpdateShipment;
                        Promoted = true;
                        PromotedIsBig = true;
                        PromotedOnly = true;
                        RunObject = Report "ACA-Update Prog. Stage Buff.";
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
                    action("Process Marks")
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
            action("Update Student Password")
            {
                ApplicationArea = Basic;
                RunObject = Report "Student Portal Activation";
            }
        }
    }
}

