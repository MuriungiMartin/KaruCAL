#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68907 "REG-Registry Role Centre"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control29)
            {
                part(Reg_Cue;"REG-Registry Cue")
                {
                    Caption = 'REGISTRY';
                }
                systempart(Control27;Outlook)
                {
                }
            }
            group(Control26)
            {
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
        area(processing)
        {
            action(Outbound)
            {
                ApplicationArea = Basic;
                Caption = 'Outbound Mails';
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Out-bound Mails";
            }
            action(Inbound_Rep)
            {
                ApplicationArea = Basic;
                Caption = 'Inbound Mails';
                Image = Report2;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "In-bound Mails";
            }
            action(Reg_Files)
            {
                ApplicationArea = Basic;
                Caption = 'Registry Files';
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Registry Files";
            }
        }
        area(sections)
        {
            group("Security Management")
            {
                Caption = 'Security Management';
                Image = Travel;
                action("Visits Ledger")
                {
                    ApplicationArea = Basic;
                    Caption = 'Visits Ledger';
                    Image = ValueLedger;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Exam Time Slots";
                }
                action("Visitors Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Visitors Card';
                    RunObject = Page "Automated Notification";
                }
                action("Visits History")
                {
                    ApplicationArea = Basic;
                    Caption = 'Visits History';
                    RunObject = Page "Item Disposal List";
                }
                separator(Action1000000014)
                {
                }
                action("Staff Register")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Register';
                    RunObject = Page "ACA-Supp. Gen. Rubrics Nursing";
                }
                action("Staff Register History")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Register History';
                    RunObject = Page "Student Submission";
                }
            }
            group(Inbound)
            {
                Caption = 'Out-bound Mails';
                Image = Reconcile;
                action("New (Outbound)")
                {
                    ApplicationArea = Basic;
                    Caption = 'New (Outbound)';
                    RunObject = Page "REG-New Outbound Mails List";
                }
                action(Dispatch)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dispatch';
                    RunObject = Page "REG-Outbound Mail (Disp.) List";
                }
                action(Released)
                {
                    ApplicationArea = Basic;
                    Caption = 'Released';
                    RunObject = Page "REG-Released Outbnd Mails List";
                }
            }
            group(In_bound)
            {
                Caption = 'In-bound Mails';
                Image = Capacities;
                action("New Inbound Mails")
                {
                    ApplicationArea = Basic;
                    Caption = 'New Inbound Mails';
                    RunObject = Page "REG-New Inbound Mails List";
                }
                action("Inbound (Sorting)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Inbound (Sorting)';
                    RunObject = Page "REG-Inbound Mails (Sort.) List";
                }
                action(Sorted)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sorted';
                    RunObject = Page "REG-Sorted Inbound Mails List";
                }
            }
            group(File_Movement)
            {
                Caption = 'File Movement';
                Image = ResourcePlanning;
                action("New Reg. Files")
                {
                    ApplicationArea = Basic;
                    Caption = 'New Reg. Files';
                    RunObject = Page "REG-Registry Files List";
                }
                action("Active Reg. Files")
                {
                    ApplicationArea = Basic;
                    Caption = 'Active Reg. Files';
                    RunObject = Page "REG-Active Files List";
                }
                action("Partially Active Files")
                {
                    ApplicationArea = Basic;
                    Caption = 'Partially Active Files';
                    RunObject = Page "REG-Partially Active Files Lst";
                }
                action("Bring-up Reg. Files")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bring-up Reg. Files';
                    RunObject = Page "REG-Bringup Files List";
                }
                action("Archived Reg. Files")
                {
                    ApplicationArea = Basic;
                    Caption = 'Archived Reg. Files';
                    RunObject = Page "REG-Arch. Registry Files List";
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

