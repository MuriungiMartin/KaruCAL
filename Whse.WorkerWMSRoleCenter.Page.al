#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9009 "Whse. Worker WMS Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1901138408;"Warehouse Worker Activities")
                {
                }
                part(Control1905989608;"My Items")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control1006;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control4;"Report Inbox Part")
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
            action("Warehouse &Bin List")
            {
                ApplicationArea = Basic;
                Caption = 'Warehouse &Bin List';
                Image = "Report";
                RunObject = Report "Warehouse Bin List";
            }
            action("Warehouse A&djustment Bin")
            {
                ApplicationArea = Basic;
                Caption = 'Warehouse A&djustment Bin';
                Image = "Report";
                RunObject = Report "Whse. Adjustment Bin";
            }
            separator(Action51)
            {
            }
            action("Whse. P&hys. Inventory List")
            {
                ApplicationArea = Basic;
                Caption = 'Whse. P&hys. Inventory List';
                Image = "Report";
                RunObject = Report "Whse. Phys. Inventory List";
            }
            separator(Action19)
            {
            }
            action("Prod. &Order Picking List")
            {
                ApplicationArea = Basic;
                Caption = 'Prod. &Order Picking List';
                Image = "Report";
                RunObject = Report "Prod. Order - Picking List";
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
            action(Picks)
            {
                ApplicationArea = Basic;
                Caption = 'Picks';
                RunObject = Page "Warehouse Picks";
            }
            action("Put-aways")
            {
                ApplicationArea = Basic;
                Caption = 'Put-aways';
                RunObject = Page "Warehouse Put-aways";
            }
            action(Movements)
            {
                ApplicationArea = Basic;
                Caption = 'Movements';
                RunObject = Page "Warehouse Movements";
            }
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
            action(WhseReceipts)
            {
                ApplicationArea = Basic;
                Caption = 'Warehouse Receipts';
                RunObject = Page "Warehouse Receipts";
            }
            action(WhseReceiptsPartReceived)
            {
                ApplicationArea = Basic;
                Caption = 'Partially Received';
                RunObject = Page "Warehouse Receipts";
                RunPageView = where("Document Status"=filter("Partially Received"));
            }
            action("Transfer Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Orders';
                Image = Document;
                RunObject = Page "Transfer Orders";
            }
            action("Assembly Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Assembly Orders';
                RunObject = Page "Assembly Orders";
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
            action("Warehouse Employees")
            {
                ApplicationArea = Basic;
                Caption = 'Warehouse Employees';
                RunObject = Page "Warehouse Employee List";
            }
            action(WhsePhysInvtJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Whse. Phys. Invt. Journals';
                RunObject = Page "Whse. Journal Batches List";
                RunPageView = where("Template Type"=const("Physical Inventory"));
            }
            action("WhseItem Journals")
            {
                ApplicationArea = Basic;
                Caption = 'Whse. Item Journals';
                RunObject = Page "Whse. Journal Batches List";
                RunPageView = where("Template Type"=const(Item));
            }
            action(PickWorksheets)
            {
                ApplicationArea = Basic;
                Caption = 'Pick Worksheets';
                RunObject = Page "Worksheet Names List";
                RunPageView = where("Template Type"=const(Pick));
            }
            action(PutawayWorksheets)
            {
                ApplicationArea = Basic;
                Caption = 'Put-away Worksheets';
                RunObject = Page "Worksheet Names List";
                RunPageView = where("Template Type"=const("Put-away"));
            }
            action(MovementWorksheets)
            {
                ApplicationArea = Basic;
                Caption = 'Movement Worksheets';
                RunObject = Page "Worksheet Names List";
                RunPageView = where("Template Type"=const(Movement));
            }
        }
        area(sections)
        {
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
                action("Posted Whse. Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Whse. Receipts';
                    Image = PostedReceipts;
                    RunObject = Page "Posted Whse. Receipt List";
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
            action("Whse. P&hysical Invt. Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Whse. P&hysical Invt. Journal';
                Image = InventoryJournal;
                RunObject = Page "Whse. Phys. Invt. Journal";
            }
            action("Whse. Item &Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Whse. Item &Journal';
                Image = BinJournal;
                RunObject = Page "Whse. Item Journal";
            }
            action("Sales Order Shipment")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Order Shipment';
                RunObject = Page "Sales Order Shipment";
            }
            separator(Action12)
            {
            }
            action("Pick &Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'Pick &Worksheet';
                Image = PickWorksheet;
                RunObject = Page "Pick Worksheet";
            }
            action("Put-&away Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'Put-&away Worksheet';
                Image = PutAwayWorksheet;
                RunObject = Page "Put-away Worksheet";
            }
            action("M&ovement Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'M&ovement Worksheet';
                Image = MovementWorksheet;
                RunObject = Page "Movement Worksheet";
            }
        }
    }
}

