#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9010 "Production Planner Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1905113808;"Production Planner Activities")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control54;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control1905989608;"My Items")
                {
                }
                part(Control55;"Report Inbox Part")
                {
                }
                part(Control1903012608;"Copy Profile")
                {
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
            action("Ro&uting Sheet")
            {
                ApplicationArea = Basic;
                Caption = 'Ro&uting Sheet';
                Image = "Report";
                RunObject = Report "Routing Sheet";
            }
            separator(Action109)
            {
            }
            action("Inventory - &Availability Plan")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - &Availability Plan';
                Image = ItemAvailability;
                RunObject = Report "Inventory - Availability Plan";
            }
            action("&Planning Availability")
            {
                ApplicationArea = Basic;
                Caption = '&Planning Availability';
                Image = "Report";
                RunObject = Report "Planning Availability";
            }
            action("&Capacity Task List")
            {
                ApplicationArea = Basic;
                Caption = '&Capacity Task List';
                Image = "Report";
                RunObject = Report "Capacity Task List";
            }
            action("Subcontractor - &Dispatch List")
            {
                ApplicationArea = Basic;
                Caption = 'Subcontractor - &Dispatch List';
                Image = "Report";
                RunObject = Report "Subcontractor - Dispatch List";
            }
            separator(Action111)
            {
            }
            action("Production Order - &Shortage List")
            {
                ApplicationArea = Basic;
                Caption = 'Production Order - &Shortage List';
                Image = "Report";
                RunObject = Report "Prod. Order - Shortage List";
            }
            action("D&etailed Calculation")
            {
                ApplicationArea = Basic;
                Caption = 'D&etailed Calculation';
                Image = "Report";
                RunObject = Report "Detailed Calculation";
            }
            separator(Action113)
            {
            }
            action("P&roduction Order - Calculation")
            {
                ApplicationArea = Basic;
                Caption = 'P&roduction Order - Calculation';
                Image = "Report";
                RunObject = Report "Prod. Order - Calculation";
            }
            action("Sta&tus")
            {
                ApplicationArea = Basic;
                Caption = 'Sta&tus';
                Image = "Report";
                RunObject = Report Status;
            }
            action("Inventory &Valuation WIP")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory &Valuation WIP';
                Image = "Report";
                RunObject = Report "Inventory Valuation - WIP";
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
            action("Production Forecast")
            {
                ApplicationArea = Basic;
                Caption = 'Production Forecast';
                RunObject = Page "Demand Forecast Names";
            }
            action("Blanket Sales Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Blanket Sales Orders';
                RunObject = Page "Blanket Sales Orders";
            }
            action("Sales Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
            }
            action("Blanket Purchase Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Blanket Purchase Orders';
                RunObject = Page "Blanket Purchase Orders";
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
            action(Vendors)
            {
                ApplicationArea = Basic;
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = Page "Vendor List";
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
            action(ProductionBOMs)
            {
                ApplicationArea = Basic;
                Caption = 'Production BOMs';
                RunObject = Page "Production BOM List";
            }
            action(ProductionBOMsCertified)
            {
                ApplicationArea = Basic;
                Caption = 'Certified';
                RunObject = Page "Production BOM List";
                RunPageView = where(Status=const(Certified));
            }
            action(Routings)
            {
                ApplicationArea = Basic;
                Caption = 'Routings';
                RunObject = Page "Routing List";
            }
        }
        area(sections)
        {
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                action(ItemJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Item),
                                        Recurring=const(false));
                }
                action(ItemReclassificationJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Reclassification Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Transfer),
                                        Recurring=const(false));
                }
                action(RevaluationJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Revaluation Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Revaluation),
                                        Recurring=const(false));
                }
            }
            group(Worksheets)
            {
                Caption = 'Worksheets';
                Image = Worksheets;
                action(PlanningWorksheets)
                {
                    ApplicationArea = Basic;
                    Caption = 'Planning Worksheets';
                    RunObject = Page "Req. Wksh. Names";
                    RunPageView = where("Template Type"=const(Planning),
                                        Recurring=const(false));
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
                action("Standard Cost Worksheet")
                {
                    ApplicationArea = Basic;
                    Caption = 'Standard Cost Worksheet';
                    RunObject = Page "Standard Cost Worksheet Names";
                }
            }
            group("Product Design")
            {
                Caption = 'Product Design';
                Image = ProductDesign;
                action(ProductionBOM)
                {
                    ApplicationArea = Basic;
                    Caption = 'Production BOM';
                    Image = BOM;
                    RunObject = Page "Production BOM List";
                }
                action(ProductionBOMCertified)
                {
                    ApplicationArea = Basic;
                    Caption = 'Certified';
                    RunObject = Page "Production BOM List";
                    RunPageView = where(Status=const(Certified));
                }
                action(Action26)
                {
                    ApplicationArea = Basic;
                    Caption = 'Routings';
                    RunObject = Page "Routing List";
                }
                action("Routing Links")
                {
                    ApplicationArea = Basic;
                    Caption = 'Routing Links';
                    RunObject = Page "Routing Links";
                }
                action("Standard Tasks")
                {
                    ApplicationArea = Basic;
                    Caption = 'Standard Tasks';
                    RunObject = Page "Standard Tasks";
                }
                action(Families)
                {
                    ApplicationArea = Basic;
                    Caption = 'Families';
                    RunObject = Page "Family List";
                }
                action(ProdDesign_Items)
                {
                    ApplicationArea = Basic;
                    Caption = 'Items';
                    Image = Item;
                    RunObject = Page "Item List";
                }
                action(ProdDesign_ItemsProduced)
                {
                    ApplicationArea = Basic;
                    Caption = 'Produced';
                    RunObject = Page "Item List";
                    RunPageView = where("Replenishment System"=const("Prod. Order"));
                }
                action(ProdDesign_ItemsRawMaterials)
                {
                    ApplicationArea = Basic;
                    Caption = 'Raw Materials';
                    RunObject = Page "Item List";
                    RunPageView = where("Low-Level Code"=filter(>0),
                                        "Replenishment System"=const(Purchase));
                }
                action(Action37)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stockkeeping Units';
                    Image = SKU;
                    RunObject = Page "Stockkeeping Unit List";
                }
            }
            group(Capacities)
            {
                Caption = 'Capacities';
                Image = Capacities;
                action(WorkCenters)
                {
                    ApplicationArea = Basic;
                    Caption = 'Work Centers';
                    RunObject = Page "Work Center List";
                }
                action(WorkCentersInternal)
                {
                    ApplicationArea = Basic;
                    Caption = 'Internal';
                    Image = Comment;
                    RunObject = Page "Work Center List";
                    RunPageView = where("Subcontractor No."=filter(=''));
                }
                action(WorkCentersSubcontracted)
                {
                    ApplicationArea = Basic;
                    Caption = 'Subcontracted';
                    RunObject = Page "Work Center List";
                    RunPageView = where("Subcontractor No."=filter(<>''));
                }
                action("Machine Centers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Machine Centers';
                    RunObject = Page "Machine Center List";
                }
                action("Registered Absence")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registered Absence';
                    RunObject = Page "Registered Absences";
                }
                action(Action44)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendors';
                    Image = Vendor;
                    RunObject = Page "Vendor List";
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
        area(creation)
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
            action("&Item")
            {
                ApplicationArea = Basic;
                Caption = '&Item';
                Image = Item;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Item Card";
                RunPageMode = Create;
            }
            action("Production &Order")
            {
                ApplicationArea = Basic;
                Caption = 'Production &Order';
                Image = "Order";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Planned Production Order";
                RunPageMode = Create;
            }
            action("Production &BOM")
            {
                ApplicationArea = Basic;
                Caption = 'Production &BOM';
                Image = BOM;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Production BOM";
                RunPageMode = Create;
            }
            action("&Routing")
            {
                ApplicationArea = Basic;
                Caption = '&Routing';
                Image = Route;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page Routing;
                RunPageMode = Create;
            }
            action("&Purchase Order")
            {
                ApplicationArea = Basic;
                Caption = '&Purchase Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Order";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            separator(Action67)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Item &Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Item &Journal';
                Image = Journals;
                RunObject = Page "Item Journal";
            }
            action("Re&quisition Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'Re&quisition Worksheet';
                Image = Worksheet;
                RunObject = Page "Req. Worksheet";
            }
            action("Planning Works&heet")
            {
                ApplicationArea = Basic;
                Caption = 'Planning Works&heet';
                Image = PlanningWorksheet;
                RunObject = Page "Planning Worksheet";
            }
            action("Item Availability by Timeline")
            {
                ApplicationArea = Basic;
                Caption = 'Item Availability by Timeline';
                Image = Timeline;
                RunObject = Page "Item Availability by Timeline";
            }
            action("Subcontracting &Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'Subcontracting &Worksheet';
                Image = SubcontractingWorksheet;
                RunObject = Page "Subcontracting Worksheet";
            }
            separator(Action45)
            {
            }
            action("Change Pro&duction Order Status")
            {
                ApplicationArea = Basic;
                Caption = 'Change Pro&duction Order Status';
                Image = ChangeStatus;
                RunObject = Page "Change Production Order Status";
            }
            action("Order Pla&nning")
            {
                ApplicationArea = Basic;
                Caption = 'Order Pla&nning';
                Image = Planning;
                RunObject = Page "Order Planning";
            }
            separator(Action84)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("Order Promising S&etup")
            {
                ApplicationArea = Basic;
                Caption = 'Order Promising S&etup';
                Image = OrderPromisingSetup;
                RunObject = Page "Order Promising Setup";
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

