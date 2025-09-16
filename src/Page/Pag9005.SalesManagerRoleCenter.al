#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9005 "Sales Manager Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control21;"Copy Profile")
                {
                }
                part(Control1907692008;"My Customers")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control11;"Sales Performance")
                {
                }
                part(Control4;"Trailing Sales Orders Chart")
                {
                }
                part(Control1;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control1902476008;"My Vendors")
                {
                    Visible = false;
                }
                part(Control6;"Report Inbox Part")
                {
                }
                systempart(Control31;MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Customer - &Order Summary")
            {
                ApplicationArea = Basic;
                Caption = 'Customer - &Order Summary';
                Image = "Report";
                RunObject = Report "Customer - Order Summary";
            }
            action("Customer - &Top 10 List")
            {
                ApplicationArea = Basic;
                Caption = 'Customer - &Top 10 List';
                Image = "Report";
                RunObject = Report "Customer - Top 10 List";
            }
            separator(Action17)
            {
            }
            action("Customer Sales Statistics")
            {
                ApplicationArea = Basic;
                Caption = 'Customer Sales Statistics';
                Image = "Report";
                RunObject = Report "Customer Sales Statistics";
            }
            action("Customer/Item Statistics")
            {
                ApplicationArea = Basic;
                Caption = 'Customer/Item Statistics';
                Image = "Report";
                RunObject = Report "Customer/Item Statistics";
            }
            action("Cust./Item Stat. by Salespers.")
            {
                ApplicationArea = Basic;
                Caption = 'Cust./Item Stat. by Salespers.';
                Image = "Report";
                RunObject = Report "Cust./Item Stat. by Salespers.";
            }
            action("Salesperson Commissions")
            {
                ApplicationArea = Basic;
                Caption = 'Salesperson Commissions';
                Image = "Report";
                RunObject = Report "Salesperson Commissions";
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
            action("Sales Analysis Reports")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Analysis Reports';
                RunObject = Page "Analysis Report Sale";
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
            action("Sales Quotes")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Quotes';
                Image = Quote;
                RunObject = Page "Sales Quotes";
            }
            action(SalesOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
            }
            action(SalesOrdersOpen)
            {
                ApplicationArea = Basic;
                Caption = 'Open';
                Image = Edit;
                RunObject = Page "Sales Order List";
                RunPageView = where(Status=filter(Open));
                ShortCutKey = 'Return';
            }
            action("Dynamics CRM Sales Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Dynamics CRM Sales Orders';
                RunObject = Page "CRM Sales Order List";
                RunPageView = where(StateCode=filter(Submitted),
                                    LastBackofficeSubmit=filter(''));
            }
            action(SalesInvoices)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page "Sales Invoice List";
            }
            action(SalesInvoicesOpen)
            {
                ApplicationArea = Basic;
                Caption = 'Open';
                Image = Edit;
                RunObject = Page "Sales Invoice List";
                RunPageView = where(Status=filter(Open));
                ShortCutKey = 'Return';
            }
            action(Items)
            {
                ApplicationArea = Basic;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            action(Contacts)
            {
                ApplicationArea = Basic;
                Caption = 'Contacts';
                Image = CustomerContact;
                RunObject = Page "Contact List";
            }
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Campaigns)
            {
                ApplicationArea = Basic;
                Caption = 'Campaigns';
                Image = Campaign;
                RunObject = Page "Campaign List";
            }
            action(Segments)
            {
                ApplicationArea = Basic;
                Caption = 'Segments';
                Image = Segment;
                RunObject = Page "Segment List";
            }
            action("To-dos")
            {
                ApplicationArea = Basic;
                Caption = 'To-dos';
                Image = TaskList;
                RunObject = Page "Task List";
            }
            action(Teams)
            {
                ApplicationArea = Basic;
                Caption = 'Teams';
                Image = TeamSales;
                RunObject = Page Teams;
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
                    ApplicationArea = Basic;
                    Caption = 'Salespeople/Purchasers';
                    RunObject = Page "Salespersons/Purchasers";
                }
                action("Cust. Invoice Discounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cust. Invoice Discounts';
                    RunObject = Page "Cust. Invoice Discounts";
                }
                action("Vend. Invoice Discounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vend. Invoice Discounts';
                    RunObject = Page "Vend. Invoice Discounts";
                }
                action("Item Disc. Groups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Disc. Groups';
                    RunObject = Page "Item Disc. Groups";
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
            separator(Action48)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Sales Price &Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Price &Worksheet';
                Image = PriceWorksheet;
                RunObject = Page "Sales Price Worksheet";
            }
            separator(Action2)
            {
            }
            action("Sales &Prices")
            {
                ApplicationArea = Basic;
                Caption = 'Sales &Prices';
                Image = SalesPrices;
                RunObject = Page "Sales Prices";
            }
            action("Sales Line &Discounts")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Line &Discounts';
                Image = SalesLineDisc;
                RunObject = Page "Sales Line Discounts";
            }
        }
    }
}

