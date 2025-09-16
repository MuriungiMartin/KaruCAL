#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9011 "Shop Supervisor Mfg Foundation"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1907234908;"Shop Super. basic Activities")
                {
                }
                part(Control1905989608;"My Items")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control21;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control27;"Report Inbox Part")
                {
                    Visible = false;
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
            action("Production Order - &Shortage List")
            {
                ApplicationArea = Basic;
                Caption = 'Production Order - &Shortage List';
                Image = "Report";
                RunObject = Report "Prod. Order - Shortage List";
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
            action("Production &Order Calculation")
            {
                ApplicationArea = Basic;
                Caption = 'Production &Order Calculation';
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
            action("Inventory Valuation &WIP")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Valuation &WIP';
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
            action(ProductionBOM)
            {
                ApplicationArea = Basic;
                Caption = 'Production BOM';
                Image = BOM;
                RunObject = Page "Production BOM List";
            }
            action(ProductionBOMUnderDevelopment)
            {
                ApplicationArea = Basic;
                Caption = 'Under Development';
                RunObject = Page "Production BOM List";
                RunPageView = where(Status=const("Under Development"));
            }
            action(ProductionBOMCertified)
            {
                ApplicationArea = Basic;
                Caption = 'Certified';
                RunObject = Page "Production BOM List";
                RunPageView = where(Status=const(Certified));
            }
            action("Work Centers")
            {
                ApplicationArea = Basic;
                Caption = 'Work Centers';
                RunObject = Page "Work Center List";
            }
            action(Routings)
            {
                ApplicationArea = Basic;
                Caption = 'Routings';
                RunObject = Page "Routing List";
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
            action("Standard Cost Worksheets")
            {
                ApplicationArea = Basic;
                Caption = 'Standard Cost Worksheets';
                RunObject = Page "Standard Cost Worksheet Names";
            }
            action(SubcontractingWorksheets)
            {
                ApplicationArea = Basic;
                Caption = 'Subcontracting Worksheets';
                RunObject = Page "Req. Wksh. Names";
                RunPageView = where("Template Type"=const("For. Labor"),
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
        }
        area(sections)
        {
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                action(RevaluationJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Revaluation Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Revaluation),
                                        Recurring=const(false));
                }
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
                action(RecurringConsumptionJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Recurring Consumption Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Consumption),
                                        Recurring=const(true));
                }
                action(RecurringOutputJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Recurring Output Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Output),
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
        }
        area(creation)
        {
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
            action("P&urchase Order")
            {
                ApplicationArea = Basic;
                Caption = 'P&urchase Order';
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
            action("Co&nsumption Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Co&nsumption Journal';
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
            separator(Action9)
            {
            }
            action("Requisition &Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'Requisition &Worksheet';
                Image = Worksheet;
                RunObject = Page "Req. Worksheet";
            }
            action("Order &Planning")
            {
                ApplicationArea = Basic;
                Caption = 'Order &Planning';
                Image = Planning;
                RunObject = Page "Order Planning";
            }
            separator(Action28)
            {
            }
            action("&Change Production Order Status")
            {
                ApplicationArea = Basic;
                Caption = '&Change Production Order Status';
                Image = ChangeStatus;
                RunObject = Page "Change Production Order Status";
            }
            separator(Action110)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("Manu&facturing Setup")
            {
                ApplicationArea = Basic;
                Caption = 'Manu&facturing Setup';
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

