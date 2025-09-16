#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9024 "Security Admin Role Center"
{
    Caption = 'Security Admin Role Center';
    Description = 'Manage users, users groups and permissions';
    Editable = false;
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group("CueGroup")
            {
                Caption = 'Cue Group';
                part(Control7;"User Security Activities")
                {
                    ApplicationArea = Basic,Suite;
                }
                part(Control15;"Team Member Activities")
                {
                    ApplicationArea = Suite;
                }
            }
            group(Lists)
            {
                Caption = 'Lists';
                part(Control12;"Users in User Groups Chart")
                {
                }
                part(Control3;"Plans FactBox")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Subscription Plans';
                    Editable = false;
                }
                part(Control4;"User Groups FactBox")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                }
                part(Control14;"Plan Permission Set")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Plan Permission Set';
                    Editable = false;
                    ToolTip = 'Specifies the permission sets included in plans.';
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action("User Groups")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'User Groups';
                RunObject = Page "User Groups";
                ToolTip = 'Set up or modify user groups as a fast way of giving users access to the functionality that is relevant to their work.';
            }
            action(Users)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Users';
                RunObject = Page Users;
            }
            action("User Review Log")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'User Review Log';
                RunObject = Page "Activity Log";
                RunPageView = where("Table No Filter"=filter(9062));
                ToolTip = 'View a log of users'' activities in the database.';
            }
            action("Permission Sets")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Permission Sets';
                RunObject = Page "Permission Sets";
                ToolTip = 'View or edit which feature objects that users need to access and set up the related permissions in permission sets that you can assign to the users of the database.';
            }
            action(Plans)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Plans';
                RunObject = Page Plans;
                RunPageMode = View;
                ToolTip = 'View subscription plans.';
            }
        }
        area(sections)
        {
            group("Self-Service")
            {
                Caption = 'Self-Service';
                Image = HumanResources;
                ToolTip = 'Manage your time sheets and assignments.';
                action("Time Sheets")
                {
                    ApplicationArea = Suite;
                    Caption = 'Time Sheets';
                    Gesture = None;
                    RunObject = Page "Time Sheet List";
                    ToolTip = 'View all time sheets.';
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
    }
}

