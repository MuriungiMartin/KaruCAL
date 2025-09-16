#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9026 "Sales & Relationship Mgr. RC"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control1;"Sales & Relationship Mgr. Act.")
            {
                ApplicationArea = RelationshipMgmt;
            }
            part(Control16;"Team Member Activities")
            {
                ApplicationArea = RelationshipMgmt;
            }
            part(Control4;"Sales Pipeline Chart")
            {
                ApplicationArea = RelationshipMgmt;
            }
            part(Control6;"Opportunity Chart")
            {
                ApplicationArea = RelationshipMgmt;
            }
            part(Control11;"Relationship Performance")
            {
                ApplicationArea = RelationshipMgmt;
            }
            part(Control2;"Power BI Report Spinner Part")
            {
                ApplicationArea = RelationshipMgmt;
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Customer - &Order Summary")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Customer - &Order Summary';
                Image = "Report";
                RunObject = Report "Customer - Order Summary";
                ToolTip = 'View the quantity not yet shipped for each customer in three periods of 30 days each, starting from a selected date. There are also columns with orders to be shipped before and after the three periods and a column with the total order detail for each customer. The report can be used to analyze a company''s expected sales volume.';
            }
            action("Customer - &Top 10 List")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Customer - &Top 10 List';
                Image = "Report";
                RunObject = Report "Customer - Top 10 List";
                ToolTip = 'View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.';
            }
            separator(Action17)
            {
            }
            action("S&ales Statistics")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'S&ales Statistics';
                Image = "Report";
                RunObject = Report "Customer Sales Statistics";
                ToolTip = 'View detailed information about sales to your customers.';
            }
            action("Salesperson - Sales &Statistics")
            {
                ApplicationArea = Suite,RelationshipMgmt;
                Caption = 'Salesperson - Sales &Statistics';
                Image = "Report";
                RunObject = Report "Salesperson Statistics by Inv.";
                ToolTip = 'View amounts for sales, profit, invoice discount, and payment discount, as well as profit percentage, for each salesperson for a selected period. The report also shows the adjusted profit and adjusted profit percentage, which reflect any changes to the original costs of the items in the sales.';
            }
            action("Salesperson - &Commission")
            {
                ApplicationArea = Suite,RelationshipMgmt;
                Caption = 'Salesperson - &Commission';
                Image = "Report";
                RunObject = Report "Salesperson Commissions";
                ToolTip = 'View a list of invoices for each salesperson for a selected period. The following information is shown for each invoice: Customer number, sales amount, profit amount, and the commission on sales amount and profit amount. The report also shows the adjusted profit and the adjusted profit commission, which are the profit figures that reflect any changes to the original costs of the goods sold.';
            }
            separator(Action22)
            {
            }
            action("Campaign - &Details")
            {
                ApplicationArea = Basic;
                Caption = 'Campaign - &Details';
                Image = "Report";
                RunObject = Report "Campaign - Details";
            }
        }
        area(embedding)
        {
            action("Sales Quotes")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Sales Quotes';
                Image = Quote;
                RunObject = Page "Sales Quotes";
                ToolTip = 'Open the list of sales quotes where you offer items or services to customers.';
            }
            action("Sales Orders")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
                ToolTip = 'Open the list of sales orders where you can sell items and services.';
            }
            action(Items)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                ToolTip = 'Open the list of items that you trade in.';
            }
            action(Contacts)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Contacts';
                Image = CustomerContact;
                RunObject = Page "Contact List";
                ToolTip = 'View a list of all your contacts.';
            }
            action(Customers)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
                ToolTip = 'Open the list of customers.';
            }
            action(Opportunities)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Opportunities';
                RunObject = Page "Opportunity List";
                ToolTip = 'View the sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.';
            }
            action("Active Segments")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Active Segments';
                RunObject = Page "Segment List";
                ToolTip = 'View segments that are currently used in active campaigns.';
            }
            action("Logged Segments")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Logged Segments';
                RunObject = Page "Logged Segments";
                ToolTip = 'View a list of the segments that you have logged.';
            }
            action("Sales Cycles")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Sales Cycles';
                RunObject = Page "Sales Cycles";
                ToolTip = 'View the different sales cycles that you use to manage sales opportunities.';
            }
            action("Sales Persons")
            {
                ApplicationArea = Suite,RelationshipMgmt;
                Caption = 'Sales Persons';
                RunObject = Page "Salespersons/Purchasers";
                ToolTip = 'View a list of your sales people.';
            }
        }
        area(sections)
        {
            group("Administration Sales/Purchase")
            {
                Caption = 'Administration Sales/Purchase';
                Image = AdministrationSalesPurchases;
                action("Salespeople/Purchasers")
                {
                    ApplicationArea = Suite,RelationshipMgmt;
                    Caption = 'Salespeople/Purchasers';
                    RunObject = Page "Salespersons/Purchasers";
                    ToolTip = 'View a list of your sales people and your purchasers.';
                }
                action("Cust. Invoice Discounts")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Cust. Invoice Discounts';
                    RunObject = Page "Cust. Invoice Discounts";
                    ToolTip = 'View or edit invoice discounts that you grant to certain customers.';
                }
                action("Vend. Invoice Discounts")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Vend. Invoice Discounts';
                    RunObject = Page "Vend. Invoice Discounts";
                    ToolTip = 'View the invoice discounts that your vendors grant you.';
                }
                action("Item Disc. Groups")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Item Disc. Groups';
                    RunObject = Page "Item Disc. Groups";
                    ToolTip = 'View or edit discount group codes that you can use as criteria when you grant special discounts to customers.';
                }
            }
            group(Analysis)
            {
                Caption = 'Analysis';
                action("Sales Analysis Reports")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Analysis Reports';
                    RunObject = Page "Analysis Report Sale";
                    ToolTip = 'Analyze the dynamics of your sales according to key sales performance indicators that you select, for example, sales turnover in both amounts and quantities, contribution margin, or progress of actual sales against the budget. You can also use the report to analyze your average sales prices and evaluate the sales performance of your sales force.';
                }
                action("Sales Analysis by Dimensions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Analysis by Dimensions';
                    RunObject = Page "Analysis View List Sales";
                }
                action("Sales Budgets")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Budgets';
                    RunObject = Page "Budget Names Sales";
                }
                action(Action38)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Contacts';
                    Image = CustomerContact;
                    RunObject = Page "Contact List";
                    ToolTip = 'View a list of all your contacts.';
                }
                action(Action21)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Customers';
                    Image = Customer;
                    RunObject = Page "Customer List";
                    ToolTip = 'Open the list of customers.';
                }
            }
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
        }
        area(processing)
        {
            group(New)
            {
                Caption = 'New';
                action(NewContact)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Contact';
                    Image = AddContacts;
                    RunObject = Page "Contact Card";
                    RunPageMode = Create;
                    ToolTip = 'Create a new contact.';
                }
                action(NewOpportunity)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Opportunity';
                    Image = NewOpportunity;
                    RunObject = Page "Opportunity Card";
                    RunPageMode = Create;
                    ToolTip = 'View the sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.';
                }
                action(NewSegment)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Segment';
                    Image = Segment;
                    RunObject = Page Segment;
                    RunPageMode = Create;
                    ToolTip = 'Create a new segment where you manage interactions with a contact.';
                }
            }
            group("Sales Prices")
            {
                Caption = 'Sales Prices';
                action("Sales Price &Worksheet")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Sales Price &Worksheet';
                    Image = PriceWorksheet;
                    RunObject = Page "Sales Price Worksheet";
                    ToolTip = 'Change the unit price for one or more items or change the price agreement for one or more customers.';
                }
                action("Sales &Prices")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Sales &Prices';
                    Image = SalesPrices;
                    RunObject = Page "Sales Prices";
                    ToolTip = 'Define how to set up sales price agreements. These sales prices can be for individual customers, for a group of customers, for all customers, or for a campaign.';
                }
                action("Sales Line &Discounts")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Sales Line &Discounts';
                    Image = SalesLineDisc;
                    RunObject = Page "Sales Line Discounts";
                    ToolTip = 'View the sales line discounts that are available. These discount agreements can be for individual customers, for a group of customers, for all customers or for a campaign.';
                }
            }
        }
    }
}

