#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9006 "Order Processor Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1901851508;"SO Processor Activities")
                {
                    AccessByPermission = TableData "Sales Shipment Header"=R;
                    ApplicationArea = Basic,Suite;
                }
                part(Control14;"Team Member Activities")
                {
                    ApplicationArea = Suite;
                }
                part(Control1907692008;"My Customers")
                {
                    ApplicationArea = Basic,Suite;
                }
                part(Control13;"Power BI Report Spinner Part")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
            group(Control1900724708)
            {
                part(Control1;"Trailing Sales Orders Chart")
                {
                    AccessByPermission = TableData "Sales Shipment Header"=R;
                    ApplicationArea = Basic,Suite;
                }
                part(Control4;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control1905989608;"My Items")
                {
                    AccessByPermission = TableData "My Item"=R;
                    ApplicationArea = Basic,Suite;
                }
                part(Control21;"Report Inbox Part")
                {
                    AccessByPermission = TableData "Report Inbox"=R;
                    ApplicationArea = Suite;
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
        area(embedding)
        {
            ToolTip = 'Manage sales processes. See KPIs and your favorite items and customers.';
            action(SalesOrders)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
                ToolTip = 'Open the list of sales orders where you can sell items and services.';
            }
            action(SalesOrdersShptNotInv)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Shipped Not Invoiced';
                RunObject = Page "Sales Order List";
                RunPageView = where("Shipped Not Invoiced"=const(true));
                ToolTip = 'View sales that are shipped but not yet invoiced.';
            }
            action(SalesOrdersComplShtNotInv)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Completely Shipped Not Invoiced';
                RunObject = Page "Sales Order List";
                RunPageView = where("Completely Shipped"=const(true),
                                    Invoice=const(false));
                ToolTip = 'View sales documents that are fully shipped but not fully invoiced.';
            }
            action("Dynamics CRM Sales Orders")
            {
                ApplicationArea = Suite;
                Caption = 'Dynamics CRM Sales Orders';
                RunObject = Page "CRM Sales Order List";
                RunPageView = where(StateCode=filter(Submitted),
                                    LastBackofficeSubmit=filter(''));
                ToolTip = 'View sales orders in Dynamics CRM that are coupled with sales orders in Dynamics NAV.';
            }
            action("Sales Quotes")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Quotes';
                Image = Quote;
                RunObject = Page "Sales Quotes";
                ToolTip = 'Open the list of sales quotes where you offer items or services to customers.';
            }
            action("Blanket Sales Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Blanket Sales Orders';
                RunObject = Page "Blanket Sales Orders";
            }
            action("Sales Invoices")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page "Sales Invoice List";
                ToolTip = 'Open the list of sales invoices where you can invoice items or services.';
            }
            action("Sales Return Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Return Orders';
                Image = ReturnOrder;
                RunObject = Page "Sales Return Order List";
            }
            action("Sales Credit Memos")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Credit Memos';
                RunObject = Page "Sales Credit Memos";
                ToolTip = 'Open the list of sales credit memos where you can revert posted sales invoices.';
            }
            action(Items)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                ToolTip = 'Open the list of items that you trade in.';
            }
            action(Customers)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
                ToolTip = 'Open the list of customers.';
            }
            action("Item Journals")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Item Journals';
                RunObject = Page "Item Journal Batches";
                RunPageView = where("Template Type"=const(Item),
                                    Recurring=const(false));
                ToolTip = 'Open a list of journals where you can adjust the physical quantity of items on inventory.';
            }
            action(SalesJournals)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Journals';
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type"=const(Sales),
                                    Recurring=const(false));
                ToolTip = 'Open the list of sales journals where you can batch post sales transactions to G/L, bank, customer, vendor and fixed assets accounts.';
            }
            action(CashReceiptJournals)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Cash Receipt Journals';
                Image = Journals;
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type"=const("Cash Receipts"),
                                    Recurring=const(false));
                ToolTip = 'Register received payments by applying them to the related customer, vendor, or bank ledger entries.';
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                ToolTip = 'View history for sales, shipments, and inventory.';
                action("Posted Sales Shipments")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Sales Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Sales Shipments";
                    ToolTip = 'View the posted sales shipments.';
                }
                action("Posted Sales Invoices")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'View the posted sales invoices.';
                }
                action("Posted Return Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page "Posted Return Receipts";
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'View the posted sales credit memos.';
                }
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'View the posted purchase invoices.';
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
            action("Sales &Quote")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales &Quote';
                Image = NewSalesQuote;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Quote";
                RunPageMode = Create;
                ToolTip = 'Offer items or services to a customer.';
            }
            action("Sales &Invoice")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales &Invoice';
                Image = NewSalesInvoice;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Invoice";
                RunPageMode = Create;
                ToolTip = 'Create a new invoice for items or services. Invoice quantities cannot be posted partially.';
            }
            action("Sales &Order")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Order";
                RunPageMode = Create;
                ToolTip = 'Create a new sales order for items or services that require partial posting.';
            }
            action("Sales &Return Order")
            {
                ApplicationArea = Basic;
                Caption = 'Sales &Return Order';
                Image = ReturnOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Return Order";
                RunPageMode = Create;
            }
            action("Sales &Credit Memo")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales &Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Credit Memo";
                RunPageMode = Create;
                ToolTip = 'Create a new sales credit memo to revert a posted sales invoice.';
            }
        }
        area(processing)
        {
            group(Tasks)
            {
                Caption = 'Tasks';
                action("Sales &Journal")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales &Journal';
                    Image = Journals;
                    RunObject = Page "Sales Journal";
                    ToolTip = 'Open a sales journal where you can batch post sales transactions to G/L, bank, customer, vendor and fixed assets accounts.';
                }
                action("Sales Price &Worksheet")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Price &Worksheet';
                    Image = PriceWorksheet;
                    RunObject = Page "Sales Price Worksheet";
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                action("&Prices")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Prices';
                    Image = SalesPrices;
                    RunObject = Page "Sales Prices";
                    ToolTip = 'Set up different prices for items that you sell to the customer. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
                }
                action("&Line Discounts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Line Discounts';
                    Image = SalesLineDisc;
                    RunObject = Page "Sales Line Discounts";
                    ToolTip = 'Set up different discounts for items that you sell to the customer. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
                }
                action("Credit Management")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Credit Management';
                    Image = CustomerRating;
                    RunObject = Page "Customer List - Credit Mgmt.";
                    ToolTip = 'Add comments to customer credit information or hold and block customers with bad credit before shipping or invoicing occurs.';
                }
                action("Order Status")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Order Status';
                    Image = CustomerList;
                    RunObject = Page "Customer List - Order Status";
                    ToolTip = 'View the status of the order.';
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                group(Customer)
                {
                    Caption = 'Customer';
                    Image = Customer;
                    action("Customer - &Order Summary")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Customer - &Order Summary';
                        Image = "Report";
                        RunObject = Report "Customer - Order Summary";
                        ToolTip = 'View the quantity not yet shipped for each customer in three periods of 30 days each, starting from a selected date. There are also columns with orders to be shipped before and after the three periods and a column with the total order detail for each customer. The report can be used to analyze a company''s expected sales volume.';
                    }
                    action("Customer - &Top 10 List")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Customer - &Top 10 List';
                        Image = "Report";
                        RunObject = Report "Customer - Top 10 List";
                        ToolTip = 'View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.';
                    }
                    action("Customer/Item Statistics")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Customer/Item Statistics';
                        Image = "Report";
                        RunObject = Report "Customer/Item Statistics";
                        ToolTip = 'View a list of item sales for each customer during a selected time period. The report contains information on quantity, sales amount, profit, and possible discounts. It can be used, for example, to analyze a company''s customer groups.';
                    }
                }
                group(ActionGroup31)
                {
                    Caption = 'Sales';
                    Image = Sales;
                    action("Cust./Item Stat. by Salespers.")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Cust./Item Stat. by Salespers.';
                        Image = "Report";
                        RunObject = Report "Cust./Item Stat. by Salespers.";
                        ToolTip = 'View amounts for sales, profit, invoice discount, and payment discount, as well as profit percentage, for each salesperson for a selected period. The report also shows the adjusted profit and adjusted profit percentage, which reflect any changes to the original costs of the items in the sales.';
                    }
                    action("List Price Sheet")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'List Price Sheet';
                        Image = "Report";
                        RunObject = Report "List Price Sheet";
                        ToolTip = 'View a list of your items and their prices, for example, to send to customers. You can create the list for specific customers, campaigns, currencies, or other criteria.';
                    }
                    action("Inventory - Sales &Back Orders")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Inventory - Sales &Back Orders';
                        Image = "Report";
                        RunObject = Report "Inventory - Sales Back Orders";
                        ToolTip = 'View a list with the order lines whose shipment date has been exceeded. The following information is shown for the individual orders for each item: number, customer name, customer''s telephone number, shipment date, order quantity and quantity on back order. The report also shows whether there are other items for the customer on back order.';
                    }
                    action("Sales Order Status")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Sales Order Status';
                        Image = "Report";
                        RunObject = Report "Sales Order Status";
                        ToolTip = 'View the status of partially filled or unfilled orders so you can determine what effect filling these orders may have on your inventory. NOTE: The Amount Remaining column may include sales taxes and therefore may not match the result of multiplying the remaining amount times the unit price and subtracting the discounts.';
                    }
                }
            }
            group(History)
            {
                Caption = 'History';
                action("Navi&gate")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Navi&gate';
                    Image = Navigate;
                    RunObject = Page Navigate;
                    ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                }
            }
        }
    }
}

