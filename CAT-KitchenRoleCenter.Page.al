#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68884 "CAT-Kitchen Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control10)
            {
                part(Control8;"CAT-Food Menu List")
                {
                    Caption = 'Food Menu List';
                    Visible = true;
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
                action(Meals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Meals Setup';
                    Image = FixedAssets;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "CAT-Cafe. Meals Setup List";
                }
                action(GenSet)
                {
                    ApplicationArea = Basic;
                    Caption = 'Catering Setups';
                    Image = FixedAssetLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "CAT-Menu Sales SetUp";
                }
                action("Meals Inventory")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Points';
                    Image = Calendar;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "CAT-Sales Point List";
                }
                action("Sales Points")
                {
                    ApplicationArea = Basic;
                    Image = SetupLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "CAT-Waiters List";
                }
                action("Daily Menu")
                {
                    ApplicationArea = Basic;
                    Image = GeneralPostingSetup;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "CAT-Daily Menu";
                }
                action("Food Menu Card")
                {
                    ApplicationArea = Basic;
                    Image = Category;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "CAT-Food Menu Card";
                }
            }
        }
        area(embedding)
        {
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
                action("Report Catering Daily Summary S")
                {
                    ApplicationArea = Basic;
                    Caption = 'Catering Daily SUmmary Sales';
                    Image = Report2;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Report "Catering Daily Summary Sales";
                }
                action("Summary Sales Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Summary Sales Report';
                    Image = PrintReport;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Report "Catering Sales Summary";
                }
                action("Daily Sales Summary (All)")
                {
                    ApplicationArea = Basic;
                    Image = Report2;
                    RunObject = Report "CAT-Daily Sales Summary (All)";
                }
                action("Student Summary Prepayment")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Report "CAT-Student Summary Prepayment";
                }
            }
        }
    }
}

