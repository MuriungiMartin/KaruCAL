#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9014 "Job Resource Manager RC"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1904257908;"Resource Manager Activities")
                {
                }
                part(Control1907692008;"My Customers")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control19;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control18;"Time Sheet Chart")
                {
                }
                part(Control22;"Report Inbox Part")
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
            action("Resource &Statistics")
            {
                ApplicationArea = Basic;
                Caption = 'Resource &Statistics';
                Image = "Report";
                RunObject = Report "Resource Statistics";
            }
            action("Resource &Utilization")
            {
                ApplicationArea = Basic;
                Caption = 'Resource &Utilization';
                Image = "Report";
                RunObject = Report "Resource Usage";
            }
            action("Resource List")
            {
                ApplicationArea = Basic;
                Caption = 'Resource List';
                RunObject = Report "Resource List";
            }
            action("Cost &Breakdown")
            {
                ApplicationArea = Basic;
                Caption = 'Cost &Breakdown';
                RunObject = Report "Cost Breakdown";
            }
            action("Completed Jobs")
            {
                ApplicationArea = Basic;
                Caption = 'Completed Jobs';
                Image = "Report";
                RunObject = Report "Completed Jobs";
            }
            action("Job List")
            {
                ApplicationArea = Basic;
                Caption = 'Job List';
                Image = "Report";
                RunObject = Report "Job List";
            }
            action("Job Cost Transaction Detail")
            {
                ApplicationArea = Basic;
                Caption = 'Job Cost Transaction Detail';
                Image = "Report";
                RunObject = Report "Job Cost Transaction Detail";
            }
        }
        area(embedding)
        {
            action(Resources)
            {
                ApplicationArea = Basic;
                Caption = 'Resources';
                RunObject = Page "Resource List";
            }
            action(ResourcesPeople)
            {
                ApplicationArea = Basic;
                Caption = 'People';
                RunObject = Page "Resource List";
                RunPageView = where(Type=filter(Person));
            }
            action(ResourcesMachines)
            {
                ApplicationArea = Basic;
                Caption = 'Machines';
                RunObject = Page "Resource List";
                RunPageView = where(Type=filter(Machine));
            }
            action("Resource Groups")
            {
                ApplicationArea = Basic;
                Caption = 'Resource Groups';
                RunObject = Page "Resource Groups";
            }
            action(ResourceJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Resource Journals';
                RunObject = Page "Resource Jnl. Batches";
                RunPageView = where(Recurring=const(false));
            }
            action(RecurringResourceJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Recurring Resource Journals';
                RunObject = Page "Resource Jnl. Batches";
                RunPageView = where(Recurring=const(true));
            }
            action(Jobs)
            {
                ApplicationArea = Basic;
                Caption = 'Jobs';
                Image = Job;
                RunObject = Page "Job List";
            }
            action("Time Sheets")
            {
                ApplicationArea = Basic;
                Caption = 'Time Sheets';
                RunObject = Page "Time Sheet List";
            }
            action("Manager Time Sheets")
            {
                ApplicationArea = Basic;
                Caption = 'Manager Time Sheets';
                RunObject = Page "Manager Time Sheet List";
            }
        }
        area(sections)
        {
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;
                action("Resource Costs")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Costs';
                    RunObject = Page "Resource Costs";
                }
                action("Resource Prices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Prices';
                    RunObject = Page "Resource Prices";
                }
                action("Resource Service Zones")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Service Zones';
                    Image = Resource;
                    RunObject = Page "Resource Service Zones";
                }
                action("Resource Locations")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Locations';
                    Image = Resource;
                    RunObject = Page "Resource Locations";
                }
                action("Work Types")
                {
                    ApplicationArea = Basic;
                    Caption = 'Work Types';
                    RunObject = Page "Work Types";
                }
            }
        }
        area(processing)
        {
            separator(Action17)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Adjust R&esource Costs/Prices")
            {
                ApplicationArea = Basic;
                Caption = 'Adjust R&esource Costs/Prices';
                Image = "Report";
                RunObject = Report "Adjust Resource Costs/Prices";
            }
            action("Resource P&rice Changes")
            {
                ApplicationArea = Basic;
                Caption = 'Resource P&rice Changes';
                Image = ResourcePrice;
                RunObject = Page "Resource Price Changes";
            }
            action("Resource Pr&ice Chg from Resource")
            {
                ApplicationArea = Basic;
                Caption = 'Resource Pr&ice Chg from Resource';
                Image = "Report";
                RunObject = Report "Suggest Res. Price Chg. (Res.)";
            }
            action("Resource Pri&ce Chg from Prices")
            {
                ApplicationArea = Basic;
                Caption = 'Resource Pri&ce Chg from Prices';
                Image = "Report";
                RunObject = Report "Suggest Res. Price Chg.(Price)";
            }
            action("I&mplement Resource Price Changes")
            {
                ApplicationArea = Basic;
                Caption = 'I&mplement Resource Price Changes';
                Image = ImplementPriceChange;
                RunObject = Report "Implement Res. Price Change";
            }
            action("Create Time Sheets")
            {
                ApplicationArea = Basic;
                Caption = 'Create Time Sheets';
                Image = NewTimesheet;
                RunObject = Report "Create Time Sheets";
            }
        }
    }
}

