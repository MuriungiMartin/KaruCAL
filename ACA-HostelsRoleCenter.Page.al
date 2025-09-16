#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69177 "ACA-Hostels Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control10)
            {
                part(Control8;"ACA-Hostel List")
                {
                    Caption = 'Hostels';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
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
            action("Hostel Allocations")
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
            action("Send Booking Emails")
            {
                ApplicationArea = Basic;
                Caption = 'Send Booking Emails';
                Image = Answers;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Report "Send Hostel E-Mails";
            }
            action("Download hostel form")
            {
                ApplicationArea = Basic;
                RunObject = Report "Resident Room Agreement";
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
        area(sections)
        {
            group("Hostel Management")
            {
                Caption = 'Hostel Management';
                Image = FixedAssets;
                action(HostelsList)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hostels';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Hostel List";
                }
                action(Allocations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hostel Allocations';
                    Image = Registered;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Std Hostel Lists";
                }
                action("Hostel Bookings (Unallocated)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Hostel Bookings (Unallocated)';
                    RunObject = Page "ACA-Hostel Bookings (Unalloc.)";
                }
                action("Posted Allocations")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Allocations';
                    Image = Aging;
                    Promoted = true;
                    RunObject = Page "ACA-Std Hostel Lists Hist";
                }
                action("Student Information")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Information';
                    RunObject = Page "ACA-Std Information (Hostels)";
                }
                action("Hostel Billing")
                {
                    ApplicationArea = Basic;
                    Caption = 'Hostel Billing';
                    Image = Invoice;
                    Promoted = true;
                    RunObject = Page "ACA-Std Billing List";
                    Visible = true;
                }
                action(ProformaBatch)
                {
                    ApplicationArea = Basic;
                    Caption = 'Proforma Batch Allocation';
                    RunObject = Page "ACA-Batch Hostel Booking LST";
                }
            }
            group(Setups)
            {
                Caption = 'Hostel Setups';
                Image = Setup;
                action("Hostels List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Hostels List';
                    RunObject = Page "ACA-Hostel List";
                }
                action("Inventory Items")
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory Items';
                    Image = InventorySetup;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Hostel Invtry Items List";
                }
            }
            group(hist)
            {
                Caption = 'Hostel History';
                Image = History;
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
                action("Historical Allocations")
                {
                    ApplicationArea = Basic;
                    Caption = 'Historical Allocations';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "ACA-Std Information (Hostels)h";
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

