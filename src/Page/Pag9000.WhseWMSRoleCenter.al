#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9000 "Whse. WMS Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1903327208;"WMS Ship & Receive Activities")
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
                part(Control37;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control40;"Report Inbox Part")
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
            action("&Picking List")
            {
                ApplicationArea = Basic;
                Caption = '&Picking List';
                Image = "Report";
                RunObject = Report "Picking List";
            }
            action("P&ut-away List")
            {
                ApplicationArea = Basic;
                Caption = 'P&ut-away List';
                Image = "Report";
                RunObject = Report "Put-away List";
            }
            action("M&ovement List")
            {
                ApplicationArea = Basic;
                Caption = 'M&ovement List';
                Image = "Report";
                RunObject = Report "Movement List";
            }
            separator(Action49)
            {
            }
            action("Whse. &Shipment Status")
            {
                ApplicationArea = Basic;
                Caption = 'Whse. &Shipment Status';
                Image = "Report";
                RunObject = Report "Whse. Shipment Status";
            }
            action("Warehouse &Bin List")
            {
                ApplicationArea = Basic;
                Caption = 'Warehouse &Bin List';
                Image = "Report";
                RunObject = Report "Warehouse Bin List";
            }
            action("Whse. &Adjustment Bin")
            {
                ApplicationArea = Basic;
                Caption = 'Whse. &Adjustment Bin';
                Image = "Report";
                RunObject = Report "Whse. Adjustment Bin";
            }
            separator(Action51)
            {
            }
            action("Whse. Phys. Inventory &List")
            {
                ApplicationArea = Basic;
                Caption = 'Whse. Phys. Inventory &List';
                Image = "Report";
                RunObject = Report "Whse. Phys. Inventory List";
            }
            action("P&hys. Inventory List")
            {
                ApplicationArea = Basic;
                Caption = 'P&hys. Inventory List';
                Image = "Report";
                RunObject = Report "Phys. Inventory List";
            }
            separator(Action54)
            {
            }
            action("&Customer - Labels")
            {
                ApplicationArea = Basic;
                Caption = '&Customer - Labels';
                Image = "Report";
                RunObject = Report "Customer - Labels";
            }
            action("Shipping Labels")
            {
                ApplicationArea = Basic;
                Caption = 'Shipping Labels';
                Image = "Report";
                RunObject = Report "Shipping Labels";
            }
        }
        area(embedding)
        {
            action(WhseShpt)
            {
                ApplicationArea = Basic;
                Caption = 'Warehouse Shipments';
                RunObject = Page "Warehouse Shipment List";
            }
            action(WhseShptReleased)
            {
                ApplicationArea = Basic;
                Caption = 'Released';
                RunObject = Page "Warehouse Shipment List";
                RunPageView = sorting("No.")
                              where(Status=filter(Released));
            }
            action(WhseShptPartPicked)
            {
                ApplicationArea = Basic;
                Caption = 'Partially Picked';
                RunObject = Page "Warehouse Shipment List";
                RunPageView = where("Document Status"=filter("Partially Picked"));
            }
            action(WhseShptComplPicked)
            {
                ApplicationArea = Basic;
                Caption = 'Completely Picked';
                RunObject = Page "Warehouse Shipment List";
                RunPageView = where("Document Status"=filter("Completely Picked"));
            }
            action(WhseShptPartShipped)
            {
                ApplicationArea = Basic;
                Caption = 'Partially Shipped';
                RunObject = Page "Warehouse Shipment List";
                RunPageView = where("Document Status"=filter("Partially Shipped"));
            }
            action(WhseRcpt)
            {
                ApplicationArea = Basic;
                Caption = 'Warehouse Receipts';
                RunObject = Page "Warehouse Receipts";
            }
            action(WhseRcptPartReceived)
            {
                ApplicationArea = Basic;
                Caption = 'Partially Received';
                RunObject = Page "Warehouse Receipts";
                RunPageView = where("Document Status"=filter("Partially Received"));
            }
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
            action(Picks)
            {
                ApplicationArea = Basic;
                Caption = 'Picks';
                RunObject = Page "Warehouse Picks";
            }
            action(PicksUnassigned)
            {
                ApplicationArea = Basic;
                Caption = 'Unassigned';
                RunObject = Page "Warehouse Picks";
                RunPageView = where("Assigned User ID"=filter(''));
            }
            action(Putaway)
            {
                ApplicationArea = Basic;
                Caption = 'Put-away';
                RunObject = Page "Warehouse Put-aways";
            }
            action(PutawayUnassigned)
            {
                ApplicationArea = Basic;
                Caption = 'Unassigned';
                RunObject = Page "Warehouse Put-aways";
                RunPageView = where("Assigned User ID"=filter(''));
            }
            action(Movements)
            {
                ApplicationArea = Basic;
                Caption = 'Movements';
                RunObject = Page "Warehouse Movements";
            }
            action(MovementsUnassigned)
            {
                ApplicationArea = Basic;
                Caption = 'Unassigned';
                RunObject = Page "Warehouse Movements";
                RunPageView = where("Assigned User ID"=filter(''));
            }
            action("Movement Worksheets")
            {
                ApplicationArea = Basic;
                Caption = 'Movement Worksheets';
                RunObject = Page "Worksheet Names List";
                RunPageView = where("Template Type"=const(Movement));
            }
            action("Bin Contents")
            {
                ApplicationArea = Basic;
                Caption = 'Bin Contents';
                Image = BinContent;
                RunObject = Page "Bin Contents List";
            }
            action("Whse. Item Journals")
            {
                ApplicationArea = Basic;
                Caption = 'Whse. Item Journals';
                RunObject = Page "Whse. Journal Batches List";
                RunPageView = where("Template Type"=const(Item));
            }
        }
        area(sections)
        {
            group("Reference Data")
            {
                Caption = 'Reference Data';
                Image = ReferenceData;
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
                action(Locations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Locations';
                    Image = Warehouse;
                    RunObject = Page "Location List";
                }
                action("Shipping Agent")
                {
                    ApplicationArea = Basic;
                    Caption = 'Shipping Agent';
                    RunObject = Page "Shipping Agents";
                }
            }
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                action(WhseItemJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Item Journals';
                    RunObject = Page "Whse. Journal Batches List";
                    RunPageView = where("Template Type"=const(Item));
                }
                action(WhseReclassJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Reclass. Journals';
                    RunObject = Page "Whse. Journal Batches List";
                    RunPageView = where("Template Type"=const(Reclassification));
                }
                action(WhsePhysInvtJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Phys. Invt. Journals';
                    RunObject = Page "Whse. Journal Batches List";
                    RunPageView = where("Template Type"=const("Physical Inventory"));
                }
                action(ItemJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Item),
                                        Recurring=const(false));
                }
                action(ItemReclassJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Reclass. Journals';
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
            group(Worksheet)
            {
                Caption = 'Worksheet';
                Image = Worksheets;
                action(PutawayWorksheets)
                {
                    ApplicationArea = Basic;
                    Caption = 'Put-away Worksheets';
                    RunObject = Page "Worksheet Names List";
                    RunPageView = where("Template Type"=const("Put-away"));
                }
                action(PickWorksheets)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pick Worksheets';
                    RunObject = Page "Worksheet Names List";
                    RunPageView = where("Template Type"=const(Pick));
                }
                action(MovementWorksheets)
                {
                    ApplicationArea = Basic;
                    Caption = 'Movement Worksheets';
                    RunObject = Page "Worksheet Names List";
                    RunPageView = where("Template Type"=const(Movement));
                }
                action("Internal Put-aways")
                {
                    ApplicationArea = Basic;
                    Caption = 'Internal Put-aways';
                    RunObject = Page "Whse. Internal Put-away List";
                }
                action("Internal Picks")
                {
                    ApplicationArea = Basic;
                    Caption = 'Internal Picks';
                    RunObject = Page "Whse. Internal Pick List";
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Whse Shipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Whse Shipments';
                    RunObject = Page "Posted Whse. Shipment List";
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
                action("Posted Whse Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Whse Receipts';
                    RunObject = Page "Posted Whse. Receipt List";
                }
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Transfer Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Transfer Receipts';
                    RunObject = Page "Posted Transfer Receipts";
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
            group("Registered Documents")
            {
                Caption = 'Registered Documents';
                Image = RegisteredDocs;
                action("Registered Picks")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registered Picks';
                    Image = RegisteredDocs;
                    RunObject = Page "Registered Whse. Picks";
                }
                action("Registered Put-aways")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registered Put-aways';
                    Image = RegisteredDocs;
                    RunObject = Page "Registered Whse. Put-aways";
                }
                action("Registered Movements")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registered Movements';
                    Image = RegisteredDocs;
                    RunObject = Page "Registered Whse. Movements";
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
            action("Whse. &Shipment")
            {
                ApplicationArea = Basic;
                Caption = 'Whse. &Shipment';
                Image = Shipment;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Warehouse Shipment";
                RunPageMode = Create;
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
            action("&Whse. Receipt")
            {
                ApplicationArea = Basic;
                Caption = '&Whse. Receipt';
                Image = Receipt;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Warehouse Receipt";
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
            action("P&ut-away Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'P&ut-away Worksheet';
                Image = PutAwayWorksheet;
                RunObject = Page "Put-away Worksheet";
            }
            action("Pi&ck Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'Pi&ck Worksheet';
                Image = PickWorksheet;
                RunObject = Page "Pick Worksheet";
            }
            action("M&ovement Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'M&ovement Worksheet';
                Image = MovementWorksheet;
                RunObject = Page "Movement Worksheet";
            }
            separator(Action38)
            {
            }
            action("W&hse. Item Journal")
            {
                ApplicationArea = Basic;
                Caption = 'W&hse. Item Journal';
                Image = BinJournal;
                RunObject = Page "Whse. Item Journal";
            }
            action("Whse. Phys. &Invt. Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Whse. Phys. &Invt. Journal';
                Image = InventoryJournal;
                RunObject = Page "Whse. Phys. Invt. Journal";
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
            separator(Action1020004)
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

