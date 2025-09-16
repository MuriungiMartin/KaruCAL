#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68975 "ACA-Admissions Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control10)
            {
                part(Control7;"ACA-Enquiry List")
                {
                    Caption = 'Admission Enquiries';
                    Visible = true;
                }
                part(Control8;"ACA-Application Form H. list")
                {
                    Caption = 'Application List';
                }
                part(Control9;"ACA-Pending Admissions List")
                {
                }
            }
            group(Control5)
            {
                systempart(Control2;MyNotes)
                {
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
                    RunObject = Page "ACA-Semesters List";
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
            }
            group("Application and Admission")
            {
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
                action(" multiplestudents")
                {
                    ApplicationArea = Basic;
                    Caption = ' multiplestudents';
                    RunObject = Page "ACA-Multple Records";
                }
                action("New Admissions")
                {
                    ApplicationArea = Basic;
                    Image = NewItem;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "HRM-Dates";
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
            group("Admission Reports")
            {
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
        area(embedding)
        {
            group(Application_Setups)
            {
                Caption = 'Application Setups';
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
        }
        area(sections)
        {
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

