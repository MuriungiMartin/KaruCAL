#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69160 "FLT-Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control10)
            {
                part(Control8;"FLT-Cue")
                {
                    Caption = 'Fleet Management';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Reports)
            {
                Caption = 'FLT Reports';
                Image = SNInfo;
            }
            action("Change Password")
            {
                ApplicationArea = Basic;
                Caption = 'Change Password';
                Image = ChangeStatus;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Change Password";
            }
            action("Central Setup")
            {
                ApplicationArea = Basic;
                Caption = 'Central Setup';
                Image = AdjustVATExemption;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "FLT-Central Setup";
            }
            action(Vehicles)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle List';
                Image = "Report";
                Promoted = true;
                RunObject = Report "FLT Vehicle List";
            }
            action(Drivers)
            {
                ApplicationArea = Basic;
                Caption = 'Driver List';
                Image = "Report";
                Promoted = true;
                RunObject = Report "FLT Driver List";
            }
            action(Fuel)
            {
                ApplicationArea = Basic;
                Caption = 'Fuel Analysis';
            }
            action(WT)
            {
                ApplicationArea = Basic;
                Caption = 'Work Ticket';
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "FLT Daily Work Ticket";
            }
            action("Fuel Requisition Per Month")
            {
                ApplicationArea = Basic;
                Caption = 'Fuel Requisition Per Month';
                Image = AllocatedCapacity;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "FLT-Vehicle Fuel/Month";
            }
            action("Maintenance Schedule")
            {
                ApplicationArea = Basic;
                Image = "Report";
                RunObject = Report "FLT-Maintenance Schedule New";
            }
            action("FLT-Maintenance Schedule 2")
            {
                ApplicationArea = Basic;
                Image = "Report";
                RunObject = Report "FLT-Maintenance  Per Vehicle";
            }
            action("Maintenance Schedule-Detailed")
            {
                ApplicationArea = Basic;
                RunObject = Report "FLT-Maintenance Schedule2";
            }
            action("Maintenance Per Vehicle Report")
            {
                ApplicationArea = Basic;
                RunObject = Report "FLT-Maintenance Per Vehicle";
            }
            action("FLT-Maintenance with Amount")
            {
                ApplicationArea = Basic;
                Image = "Report";
                RunObject = Report "FLT-Maintenance with Amount";
            }
            action("Fuel Register")
            {
                ApplicationArea = Basic;
                RunObject = Report "FLT-Fuel Vehicle Statement";
            }
            action(FuelPerMonth)
            {
                ApplicationArea = Basic;
                Caption = 'Fuel Type/Month Analysis';
                Image = BinLedger;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "FLT-Fuel Vehicle Statement";
            }
        }
        area(sections)
        {
            group(Vehicle_Man)
            {
                Caption = 'Vehicle Management';
                Image = AnalysisView;
                action("Driver Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Driver Card';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT-Driver List";
                }
                action("Vehicle Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Card';
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "FLT-Vehicle Card List";
                }
            }
            group(Transport_re)
            {
                Caption = 'Transport Requisitions';
                Image = Travel;
                action("Transport Requisition")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transport Requisition';
                    RunObject = Page "FLT-Transport Req. List";
                }
                action("Submitted Transport Requisition")
                {
                    ApplicationArea = Basic;
                    Caption = 'Submitted Transport Requisition';
                    RunObject = Page "FLT-Submitted Transport List";
                }
                action("Approved Transport Requisition")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Transport Requisition';
                    RunObject = Page "FLT-Approved transport Req";
                }
                action("Closed Transport Requisition")
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed Transport Requisition';
                    RunObject = Page "FLT-Transport - Closed List";
                }
            }
            group(Safari_Notices)
            {
                Caption = 'Travel Notices';
                Image = ResourcePlanning;
                action(Travel_Notices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Travel Notice';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "FLT-Safari Notices List";
                }
                action("Approved Travel Notices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Travel Notices';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT-Posted Safari Notices List";
                }
            }
            group(Fuel_req)
            {
                Caption = 'Fuel Requisitions';
                Image = Intrastat;
                action(Fuel_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Fuel Requisitions';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "FLT-Fuel Req. List";
                }
                action(sub_Fuel_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Submitted Fuel Requisitions';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT-Fuel Req. Submitted List";
                }
                action(Unpaid_Fuel_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unpaid Fuel Requisitions';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT-Fuel Req. Unpaid";
                }
                action(Closed_Fuel_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed/Paid Fuel Requisitions';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT-Fuel Req. Closed List";
                }
                action(Batch_fuel_Pay)
                {
                    ApplicationArea = Basic;
                    Caption = 'Batch Fuel Payments';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT-Fuel Pymnt Batch List";
                }
            }
            group("Work Tickets")
            {
                Caption = 'Work Tickets';
                Image = Marketing;
                action(workTick)
                {
                    ApplicationArea = Basic;
                    Caption = 'Daily Work Tickets';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "FLT-Daily Work Ticket List";
                }
                action(Closed_Work_Tick)
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed Daily Work Tickets';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT-Closed Work Ticket List";
                }
            }
            group(Maint_Req)
            {
                Caption = 'Maintenance Request';
                Image = Receivables;
                action(main_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Maintenance Request';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "FLT-Maint. Req. List";
                }
                action(subMmain_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Submitted Maintenance Request';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT-Maint. Req. Sub. List";
                }
                action(Appr_main_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Maintenance Request';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "FLT-Approved  Maintenance Req";
                }
                action(Closed_main_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed Maintenance Request';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT-Closed Maint. Req. List";
                }
            }
            group(Setup)
            {
                Caption = 'Setups';
                Image = Setup;
                action(FleetMan_setup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Fleet Mgt Setup';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "FLT-Setup";
                }
                action(flet_man_app_setup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Fleet Mgt Approval Setup';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT-Approval Setup";
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
                action("Page FLT Transport Requisition2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transport Requisition';
                    RunObject = Page "FLT-Transport Req. List";
                }
                action(Travel_Notices2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Travel Notice';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "FLT-Safari Notices List";
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

