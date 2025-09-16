#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9008 "Whse. Basic Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1906245608;"Whse Ship & Receive Activities")
                {
                }
                part(Control1907692008;"My Customers")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control4;"Trailing Sales Orders Chart")
                {
                    Visible = false;
                }
                part(Control18;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control19;"Report Inbox Part")
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
            action("Warehouse &Bin List")
            {
                ApplicationArea = Basic;
                Caption = 'Warehouse &Bin List';
                Image = "Report";
                RunObject = Report "Warehouse Bin List";
            }
            separator(Action51)
            {
            }
            action("Physical &Inventory List")
            {
                ApplicationArea = Basic;
                Caption = 'Physical &Inventory List';
                Image = "Report";
                RunObject = Report "Phys. Inventory List";
            }
            separator(Action54)
            {
            }
            action("Customer &Labels")
            {
                ApplicationArea = Basic;
                Caption = 'Customer &Labels';
                Image = "Report";
                RunObject = Report "Customer - Labels";
            }
        }
        area(embedding)
        {
            action(SalesOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
            }
            action(SalesOrdersReleased)
            {
                ApplicationArea = Basic;
                Caption = 'Released';
                RunObject = Page "Sales Order List";
                RunPageView = where(Status=filter(Released));
            }
            action(SalesOrdersPartShipped)
            {
                ApplicationArea = Basic;
                Caption = 'Partially Shipped';
                RunObject = Page "Sales Order List";
                RunPageView = where(Status=filter(Released),
                                    "Completely Shipped"=filter(false));
            }
            action("Purchase Return Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Return Orders';
                RunObject = Page "Purchase Return Order List";
                RunPageView = where("Document Type"=filter("Return Order"));
            }
            action("Transfer Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Orders';
                Image = Document;
                RunObject = Page "Transfer Orders";
            }
            action("Released Production Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Released Production Orders';
                RunObject = Page "Released Production Orders";
            }
            action(PurchaseOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action(PurchaseOrdersReleased)
            {
                ApplicationArea = Basic;
                Caption = 'Released';
                RunObject = Page "Purchase Order List";
                RunPageView = where(Status=filter(Released));
            }
            action(PurchaseOrdersPartReceived)
            {
                ApplicationArea = Basic;
                Caption = 'Partially Received';
                RunObject = Page "Purchase Order List";
                RunPageView = where(Status=filter(Released),
                                    "Completely Received"=filter(false));
            }
            action("Assembly Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Assembly Orders';
                RunObject = Page "Assembly Orders";
            }
            action("Sales Return Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Return Orders';
                Image = ReturnOrder;
                RunObject = Page "Sales Return Order List";
            }
            action("Inventory Picks")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Picks';
                RunObject = Page "Inventory Picks";
            }
            action("Inventory Put-aways")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Put-aways';
                RunObject = Page "Inventory Put-aways";
            }
            action("Inventory Movements")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Movements';
                RunObject = Page "Inventory Movements";
            }
            action("Internal Movements")
            {
                ApplicationArea = Basic;
                Caption = 'Internal Movements';
                RunObject = Page "Internal Movement List";
            }
            action("Bin Contents")
            {
                ApplicationArea = Basic;
                Caption = 'Bin Contents';
                Image = BinContent;
                RunObject = Page "Bin Contents List";
            }
            action(Items)
            {
                ApplicationArea = Basic;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Vendors)
            {
                ApplicationArea = Basic;
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = Page "Vendor List";
            }
            action("Shipping Agents")
            {
                ApplicationArea = Basic;
                Caption = 'Shipping Agents';
                RunObject = Page "Shipping Agents";
            }
            action(ItemReclassificationJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Item Reclassification Journals';
                RunObject = Page "Item Journal Batches";
                RunPageView = where("Template Type"=const(Transfer),
                                    Recurring=const(false));
            }
            action(PhysInventoryJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Phys. Inventory Journals';
                RunObject = Page "Item Journal Batches";
                RunPageView = where("Template Type"=const("Phys. Inventory"),
                                    Recurring=const(false));
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Invt. Picks")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Invt. Picks';
                    RunObject = Page "Posted Invt. Pick List";
                }
                action("Posted Sales Shipment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Shipment';
                    RunObject = Page "Posted Sales Shipments";
                }
                action("Posted Transfer Shipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Transfer Shipments';
                    RunObject = Page "Posted Transfer Shipments";
                }
                action("Posted Return Shipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
                }
                action("Posted Invt. Put-aways")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Invt. Put-aways';
                    RunObject = Page "Posted Invt. Put-away List";
                }
                action("Registered Invt. Movements")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registered Invt. Movements';
                    RunObject = Page "Registered Invt. Movement List";
                }
                action("Posted Transfer Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Transfer Receipts';
                    RunObject = Page "Posted Transfer Receipts";
                }
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Return Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page "Posted Return Receipts";
                }
                action("Posted Assembly Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Assembly Orders';
                    RunObject = Page "Posted Assembly Orders";
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
            action("T&ransfer Order")
            {
                ApplicationArea = Basic;
                Caption = 'T&ransfer Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Transfer Order";
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
            separator(Action9)
            {
            }
            action("Inventory Pi&ck")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Pi&ck';
                Image = CreateInventoryPickup;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Inventory Pick";
                RunPageMode = Create;
            }
            action("Inventory P&ut-away")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory P&ut-away';
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
            separator(Action52)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Edit Item Reclassification &Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Edit Item Reclassification &Journal';
                Image = OpenWorksheet;
                RunObject = Page "Item Reclass. Journal";
            }
            separator(Action53)
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
            separator(Action1020000)
            {
                Caption = 'Customer';
                IsHeader = true;
            }
            action("Credit Management")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Credit Management';
                Image = CustomerList;
                RunObject = Page "Customer List - Credit Mgmt.";
                ToolTip = 'View the customer list with credit limit.';
            }
            action("Order Status")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Order Status';
                Image = OrderList;
                RunObject = Page "Customer List - Order Status";
                ToolTip = 'View the customer list.';
            }
            action("Sales Order Shipping")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Order Shipping';
                Image = SalesShipment;
                RunObject = Page "Sales Order Shipment List";
                ToolTip = 'View the sales order shipping list.';
            }
        }
    }
}

