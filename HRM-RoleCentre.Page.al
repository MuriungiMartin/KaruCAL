#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69042 "HRM-Role Centre"
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
                part("`";"Approval Entries")
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
        area(creation)
        {
            action("Employees on Leave")
            {
                ApplicationArea = Basic;
                Caption = 'Employees on Leave';
                Image = ChangeStatus;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "HRM-Active Leaves";
            }
            action("Study Leave")
            {
                ApplicationArea = Basic;
                Caption = 'Study Leave';
                Image = ClearFilter;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "HRM-Employees on Study Leave";
            }
            action("Employee List")
            {
                ApplicationArea = Basic;
                Caption = 'Employee List';
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "HR Employee List";
            }
            action("Beneficiary Report")
            {
                ApplicationArea = Basic;
                RunObject = Report "Event Report";
            }
            action("Next of kin")
            {
                ApplicationArea = Basic;
                RunObject = Report "Trial Balance Detail/Summary";
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
            action("Inactive Employees Report")
            {
                ApplicationArea = Basic;
                RunObject = Report "Periodic Incident Report";
            }
            action("Job Applications")
            {
                ApplicationArea = Basic;
                Caption = 'Job Applications';
                Image = "report";
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Job Application List";
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
            action("HRM - Payment Information")
            {
                ApplicationArea = Basic;
                Caption = 'HRM - Payment Information';
                Image = "Report";
                RunObject = Report "HRM - Payment Information";
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
            action("<XMLport Import HR Tribe")
            {
                ApplicationArea = Basic;
                Caption = 'Import HR Tribe';
                RunObject = XMLport "Import HR Tribe";
            }
        }
        area(sections)
        {
            group(EmployeeMan)
            {
                Caption = 'Employee Manager';
                Image = HumanResources;
                action(Action22)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee List';
                    RunObject = Page "HRM-Employee List";
                    RunPageView = where("Employee Category"=filter(<>'PART TIME'));
                }
                action("Lecturer List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Lecturer List';
                    RunObject = Page "HRM-Lecturer List";
                }
                action("Leave Applications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Applications';
                    RunObject = Page "HRM-View Leave List";
                }
                action("Page Approval User Setup")
                {
                    ApplicationArea = Basic;
                    Caption = ' Approval  Setup';
                    RunObject = Page "Approval User Setup";
                }
                action("Page User Setup")
                {
                    ApplicationArea = Basic;
                    Caption = ' Users Setup';
                    RunObject = Page "User Setup";
                }
                action("Part Timers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Part Timers';
                    RunObject = Page "HRM-Employee List";
                    RunPageView = where("Employee Category"=filter('PART TIME'));
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
                action("New Applications")
                {
                    ApplicationArea = Basic;
                    Caption = 'New Applications';
                    RunObject = Page "HRM-Job Applications List";
                    RunPageView = where("Ready for Shortlisting"=filter(false));
                }
                action("Confirmed Applications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Confirmed Applications';
                    RunObject = Page "HRM-Job Applications List";
                    RunPageView = where("Ready for Shortlisting"=filter(true));
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
                action("Recruitment Mail Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recruitment Mail Setup';
                    Image = CoupledInvoice;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "JobRecruitment Inv/Regret Mail";
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
    }
}

