#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9013 "Machine Operator Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1900316508;"Machine Operator Activities")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control3;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control1905989608;"My Items")
                {
                }
                part(Control5;"Report Inbox Part")
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
            action("&Capacity Task List")
            {
                ApplicationArea = Basic;
                Caption = '&Capacity Task List';
                Image = "Report";
                RunObject = Report "Capacity Task List";
            }
            action("Prod. Order - &Job Card")
            {
                ApplicationArea = Basic;
                Caption = 'Prod. Order - &Job Card';
                Image = "Report";
                RunObject = Report "Prod. Order - Job Card";
            }
        }
        area(embedding)
        {
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
            action("Capacity Ledger Entries")
            {
                ApplicationArea = Basic;
                Caption = 'Capacity Ledger Entries';
                Image = CapacityLedger;
                RunObject = Page "Capacity Ledger Entries";
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
        area(sections)
        {
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
            action("Inventory P&ick")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory P&ick';
                Image = CreateInventoryPickup;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Inventory Pick";
                RunPageMode = Create;
            }
            action("Inventory Put-&away")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Put-&away';
                Image = CreatePutAway;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Inventory Put-away";
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
            separator(Action6)
            {
            }
            action("Register Absence - &Machine Center")
            {
                ApplicationArea = Basic;
                Caption = 'Register Absence - &Machine Center';
                Image = CalendarMachine;
                RunObject = Report "Reg. Abs. (from Machine Ctr.)";
            }
            action("Register Absence - &Work Center")
            {
                ApplicationArea = Basic;
                Caption = 'Register Absence - &Work Center';
                Image = CalendarWorkcenter;
                RunObject = Report "Reg. Abs. (from Work Center)";
            }
        }
    }
}

