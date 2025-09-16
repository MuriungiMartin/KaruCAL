#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9012 "Shop Supervisor Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1905423708;"Shop Supervisor Activities")
                {
                }
                part(Control1905989608;"My Items")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control1;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control3;"Report Inbox Part")
                {
                }
                part(Control1903012608;"Copy Profile")
                {
                    Visible = false;
                }
                systempart(Control1901377608;MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Routing &Sheet")
            {
                ApplicationArea = Basic;
                Caption = 'Routing &Sheet';
                Image = "Report";
                RunObject = Report "Routing Sheet";
            }
            separator(Action51)
            {
            }
            action("Inventory - &Availability Plan")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - &Availability Plan';
                Image = ItemAvailability;
                RunObject = Report "Inventory - Availability Plan";
            }
            separator(Action53)
            {
            }
            action("Capacity Tas&k List")
            {
                ApplicationArea = Basic;
                Caption = 'Capacity Tas&k List';
                Image = "Report";
                RunObject = Report "Capacity Task List";
            }
            action("Subcontractor - Dis&patch List")
            {
                ApplicationArea = Basic;
                Caption = 'Subcontractor - Dis&patch List';
                Image = "Report";
                RunObject = Report "Subcontractor - Dispatch List";
            }
            separator(Action42)
            {
            }
            action("Production Order Ca&lculation")
            {
                ApplicationArea = Basic;
                Caption = 'Production Order Ca&lculation';
                Image = "Report";
                RunObject = Report "Prod. Order - Calculation";
            }
            action("S&tatus")
            {
                ApplicationArea = Basic;
                Caption = 'S&tatus';
                Image = "Report";
                RunObject = Report Status;
            }
        }
        area(embedding)
        {
            action("Simulated Production Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Simulated Production Orders';
                RunObject = Page "Simulated Production Orders";
            }
            action("Planned Production Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Planned Production Orders';
                RunObject = Page "Planned Production Orders";
            }
            action("Firm Planned Production Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Firm Planned Production Orders';
                RunObject = Page "Firm Planned Prod. Orders";
            }
            action("Released Production Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Released Production Orders';
                RunObject = Page "Released Production Orders";
            }
            action("Finished Production Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Finished Production Orders';
                RunObject = Page "Finished Production Orders";
            }
            action(Routings)
            {
                ApplicationArea = Basic;
                Caption = 'Routings';
                RunObject = Page "Routing List";
            }
            action("Registered Absence")
            {
                ApplicationArea = Basic;
                Caption = 'Registered Absence';
                RunObject = Page "Registered Absences";
            }
            action(Items)
            {
                ApplicationArea = Basic;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            action(ItemsProduced)
            {
                ApplicationArea = Basic;
                Caption = 'Produced';
                RunObject = Page "Item List";
                RunPageView = where("Replenishment System"=const("Prod. Order"));
            }
            action(ItemsRawMaterials)
            {
                ApplicationArea = Basic;
                Caption = 'Raw Materials';
                RunObject = Page "Item List";
                RunPageView = where("Low-Level Code"=filter(>0),
                                    "Replenishment System"=const(Purchase),
                                    "Production BOM No."=filter(=''));
            }
            action("Stockkeeping Units")
            {
                ApplicationArea = Basic;
                Caption = 'Stockkeeping Units';
                Image = SKU;
                RunObject = Page "Stockkeeping Unit List";
            }
            action("Sales Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
            }
            action("Purchase Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action("Transfer Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Orders';
                Image = Document;
                RunObject = Page "Transfer Orders";
            }
            action("Work Centers")
            {
                ApplicationArea = Basic;
                Caption = 'Work Centers';
                RunObject = Page "Work Center List";
            }
            action("Machine Centers")
            {
                ApplicationArea = Basic;
                Caption = 'Machine Centers';
                RunObject = Page "Machine Center List";
            }
            action("Inventory Put-aways")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Put-aways';
                RunObject = Page "Inventory Put-aways";
            }
            action("Inventory Picks")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Picks';
                RunObject = Page "Inventory Picks";
            }
            action(RequisitionWorksheets)
            {
                ApplicationArea = Basic;
                Caption = 'Requisition Worksheets';
                RunObject = Page "Req. Wksh. Names";
                RunPageView = where("Template Type"=const("Req."),
                                    Recurring=const(false));
            }
            action(SubcontractingWorksheets)
            {
                ApplicationArea = Basic;
                Caption = 'Subcontracting Worksheets';
                RunObject = Page "Req. Wksh. Names";
                RunPageView = where("Template Type"=const("For. Labor"),
                                    Recurring=const(false));
            }
        }
        area(sections)
        {
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                action(ConsumptionJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Consumption Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Consumption),
                                        Recurring=const(false));
                }
                action(OutputJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Output Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Output),
                                        Recurring=const(false));
                }
                action(CapacityJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Capacity Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Capacity),
                                        Recurring=const(false));
                }
                action(RecurringCapacityJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Recurring Capacity Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Capacity),
                                        Recurring=const(true));
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;
                action("Work Shifts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Work Shifts';
                    RunObject = Page "Work Shifts";
                }
                action("Shop Calendars")
                {
                    ApplicationArea = Basic;
                    Caption = 'Shop Calendars';
                    RunObject = Page "Shop Calendars";
                }
                action("Capacity Constrained Resources")
                {
                    ApplicationArea = Basic;
                    Caption = 'Capacity Constrained Resources';
                    RunObject = Page "Capacity Constrained Resources";
                }
                action("Work Center Groups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Work Center Groups';
                    RunObject = Page "Work Center Groups";
                }
                action("Stop Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Stop Codes';
                    RunObject = Page "Stop Codes";
                }
                action("Scrap Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Scrap Codes';
                    RunObject = Page "Scrap Codes";
                }
                action("Standard Tasks")
                {
                    ApplicationArea = Basic;
                    Caption = 'Standard Tasks';
                    RunObject = Page "Standard Tasks";
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
            }
        }
        area(processing)
        {
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
            separator(Action67)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Consumptio&n Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Consumptio&n Journal';
                Image = ConsumptionJournal;
                RunObject = Page "Consumption Journal";
            }
            action("Output &Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Output &Journal';
                Image = OutputJournal;
                RunObject = Page "Output Journal";
            }
            action("&Capacity Journal")
            {
                ApplicationArea = Basic;
                Caption = '&Capacity Journal';
                Image = CapacityJournal;
                RunObject = Page "Capacity Journal";
            }
            separator(Action27)
            {
            }
            action("Change &Production Order Status")
            {
                ApplicationArea = Basic;
                Caption = 'Change &Production Order Status';
                Image = ChangeStatus;
                RunObject = Page "Change Production Order Status";
            }
            separator(Action55)
            {
            }
            action("Update &Unit Cost")
            {
                ApplicationArea = Basic;
                Caption = 'Update &Unit Cost';
                Image = UpdateUnitCost;
                RunObject = Report "Update Unit Cost";
            }
            separator(Action84)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("&Manufacturing Setup")
            {
                ApplicationArea = Basic;
                Caption = '&Manufacturing Setup';
                Image = ProductionSetup;
                RunObject = Page "Manufacturing Setup";
            }
            separator(Action89)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Item &Tracing")
            {
                ApplicationArea = Basic;
                Caption = 'Item &Tracing';
                Image = ItemTracing;
                RunObject = Page "Item Tracing";
            }
            action("Navi&gate")
            {
                ApplicationArea = Basic;
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
    }
}

