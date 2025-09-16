#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9007 "Purchasing Agent Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1907662708;"Purchase Agent Activities")
                {
                }
                part(Control1902476008;"My Vendors")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control25;"Purchase Performance")
                {
                }
                part(Control37;"Purchase Performance")
                {
                    Visible = false;
                }
                part(Control21;"Inventory Performance")
                {
                }
                part(Control44;"Inventory Performance")
                {
                    Visible = false;
                }
                part(Control45;"Report Inbox Part")
                {
                }
                part(Control35;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control1905989608;"My Items")
                {
                }
                systempart(Control43;MyNotes)
                {
                }
                part(Control1903012608;"Copy Profile")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Top __ Vendor List")
            {
                ApplicationArea = Basic;
                Caption = 'Top __ Vendor List';
                RunObject = Report "Top __ Vendor List";
            }
            action("Vendor/Item Statistics")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor/Item Statistics';
                RunObject = Report "Vendor/Item Statistics";
            }
            separator(Action28)
            {
            }
            action("Availability Projection")
            {
                ApplicationArea = Basic;
                Caption = 'Availability Projection';
                RunObject = Report "Availability Projection";
            }
            action("Purchase Order Status")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Order Status';
                RunObject = Report "Purchase Order Status";
            }
            action("Vendor Purchases by Item")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor Purchases by Item';
                RunObject = Report "Vendor Purchases by Item";
            }
            action("Item Cost and Price List")
            {
                ApplicationArea = Basic;
                Caption = 'Item Cost and Price List';
                RunObject = Report "Item Cost and Price List";
            }
            separator(Action1020000)
            {
            }
            action("Outstanding Order Stat. by PO")
            {
                ApplicationArea = Basic;
                Caption = 'Outstanding Order Stat. by PO';
                Image = "Report";
                RunObject = Report "Outstanding Order Stat. by PO";
            }
            action("Outstanding Purch. Order Aging")
            {
                ApplicationArea = Basic;
                Caption = 'Outstanding Purch. Order Aging';
                Image = "Report";
                RunObject = Report "Outstanding Purch. Order Aging";
            }
            separator(Action1000000030)
            {
            }
            action("Outstanding Purch.Order Status")
            {
                ApplicationArea = Basic;
                Caption = 'Outstanding Purch.Order Status';
                Image = "Report";
                RunObject = Report "Outstanding Purch.Order Status";
            }
            action("Purchase Advice")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Advice';
                Image = "Report";
                RunObject = Report "Purchase Advice";
            }
        }
        area(embedding)
        {
            action(PurchaseOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action(PurchaseOrdersPendConf)
            {
                ApplicationArea = Basic;
                Caption = 'Pending Confirmation';
                RunObject = Page "Purchase Order List";
                RunPageView = where(Status=filter(Open));
            }
            action(PurchaseOrdersPartDeliv)
            {
                ApplicationArea = Basic;
                Caption = 'Partially Delivered';
                RunObject = Page "Purchase Order List";
                RunPageView = where(Status=filter(Released),
                                    Receive=filter(true),
                                    "Completely Received"=filter(false));
            }
            action("Purchase Quotes")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Quotes';
                RunObject = Page "Purchase Quotes";
            }
            action("Blanket Purchase Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Blanket Purchase Orders';
                RunObject = Page "Blanket Purchase Orders";
            }
            action("Purchase Invoices")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Invoices';
                RunObject = Page "Purchase Invoices";
            }
            action("Purchase Return Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Return Orders';
                RunObject = Page "Purchase Return Order List";
            }
            action("Purchase Credit Memos")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Credit Memos';
                RunObject = Page "Purchase Credit Memos";
            }
            action("Assembly Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Assembly Orders';
                RunObject = Page "Assembly Orders";
            }
            action("Sales Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
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
            action("Nonstock Items")
            {
                ApplicationArea = Basic;
                Caption = 'Nonstock Items';
                Image = NonStockItem;
                RunObject = Page "Catalog Item List";
            }
            action("Stockkeeping Units")
            {
                ApplicationArea = Basic;
                Caption = 'Stockkeeping Units';
                Image = SKU;
                RunObject = Page "Stockkeeping Unit List";
            }
            action("Purchase Analysis Reports")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Analysis Reports';
                RunObject = Page "Analysis Report Purchase";
                RunPageView = where("Analysis Area"=filter(Purchase));
            }
            action("Inventory Analysis Reports")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Analysis Reports';
                RunObject = Page "Analysis Report Inventory";
                RunPageView = where("Analysis Area"=filter(Inventory));
            }
            action("Item Journals")
            {
                ApplicationArea = Basic;
                Caption = 'Item Journals';
                RunObject = Page "Item Journal Batches";
                RunPageView = where("Template Type"=const(Item),
                                    Recurring=const(false));
            }
            action("Purchase Journals")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Journals';
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type"=const(Purchases),
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
            action("Standard Cost Worksheets")
            {
                ApplicationArea = Basic;
                Caption = 'Standard Cost Worksheets';
                RunObject = Page "Standard Cost Worksheet Names";
            }
            action("Fixed Assets")
            {
                ApplicationArea = Basic;
                Caption = 'Fixed Assets';
                RunObject = Page "Fixed Asset List";
            }
        }
        area(sections)
        {
            group(prequalification)
            {
                action(Years)
                {
                    ApplicationArea = Basic;
                    Image = AutofillQtyToHandle;
                    RunObject = Page "Proc-Prequalification Years";
                }
                action(Categories)
                {
                    ApplicationArea = Basic;
                    Image = CollapseDepositLines;
                    RunObject = Page "Proc-Prequalif. Categories";
                }
                action("Category/Year")
                {
                    ApplicationArea = Basic;
                    Image = WorkCenter;
                    RunObject = Page "Proc-Preq. Categories/Year";
                }
                action("Supplier/Category")
                {
                    ApplicationArea = Basic;
                    Caption = 'Supplier Category';
                    Image = AbsenceCalendar;
                }
            }
            group("Procurement Process")
            {
                Caption = 'Procurement Process';
                action("Purchase Requisition")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Requisition';
                    RunObject = Page "FIN-Purchase Requisition";
                }
                action(RFQ)
                {
                    ApplicationArea = Basic;
                    Caption = 'RFQ';
                    RunObject = Page "PROC-Purchase Quote List";
                }
                action(Action1000000024)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Quotes';
                    RunObject = Page "Purchase Quotes";
                }
                action("Purchase Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Orders';
                    RunObject = Page "Purchase Order List";
                }
                action(Action1000000022)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Return Orders';
                    RunObject = Page "Purchase Return Order List";
                }
                action(Action1000000021)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Invoices';
                    RunObject = Page "Purchase Invoices";
                }
                action(Action1000000020)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Credit Memos';
                    RunObject = Page "Purchase Credit Memos";
                }
            }
            group(Stores)
            {
                Caption = 'Stores';
                Image = Sales;
                action(Action1000000018)
                {
                    ApplicationArea = Basic;
                    Caption = 'Items';
                    Image = Item;
                    RunObject = Page "Item List";
                }
                action(Action1000000017)
                {
                    ApplicationArea = Basic;
                    Caption = 'Nonstock Items';
                    Image = NonStockItem;
                    RunObject = Page "Catalog Item List";
                }
                action(Action1000000016)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stockkeeping Units';
                    Image = SKU;
                    RunObject = Page "Stockkeeping Unit List";
                }
                action(Action1000000015)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Analysis Reports';
                    RunObject = Page "Analysis Report Purchase";
                    RunPageView = where("Analysis Area"=filter(Purchase));
                }
                action(Action1000000014)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory Analysis Reports';
                    RunObject = Page "Analysis Report Inventory";
                    RunPageView = where("Analysis Area"=filter(Inventory));
                }
                action(Action1000000013)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Item),
                                        Recurring=const(false));
                }
                action("Store Requisition")
                {
                    ApplicationArea = Basic;
                    Caption = 'Store Requisition';
                    RunObject = Page "PROC-Store Requisition";
                }
                action("Approved Store Requisition")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Store Requisition';
                    Image = AdjustItemCost;
                    RunObject = Page "PROC-Store Req.-Approved";
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                action("Posted Return Shipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
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
                action("Meal Booking")
                {
                    ApplicationArea = Basic;
                    Caption = 'Meal Booking';
                    RunObject = Page "CAT-Meal Booking List";
                }
            }
        }
        area(creation)
        {
            action("<Procurement Plan Report>")
            {
                ApplicationArea = Basic;
                Caption = 'Procurement Plan Report';
                Image = ChartOfAccounts;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Report "Consolidated Procurement Plan";
            }
            action("Stock Summary Report ")
            {
                ApplicationArea = Basic;
                Caption = 'Stock Summary Report ';
                Image = Certificate;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Stock Summary";
            }
            action("Purchase &Quote")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase &Quote';
                Image = Quote;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Quote";
                RunPageMode = Create;
            }
            action("Purchase &Invoice")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase &Invoice';
                Image = NewPurchaseInvoice;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Invoice";
                RunPageMode = Create;
            }
            action("Purchase &Order")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Order";
                RunPageMode = Create;
            }
            action("Purchase &Return Order")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase &Return Order';
                Image = ReturnOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Return Order";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            separator(Action24)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("&Purchase Journal")
            {
                ApplicationArea = Basic;
                Caption = '&Purchase Journal';
                Image = Journals;
                RunObject = Page "Purchase Journal";
            }
            action("Item &Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Item &Journal';
                Image = Journals;
                RunObject = Page "Item Journal";
            }
            action("Order Plan&ning")
            {
                ApplicationArea = Basic;
                Caption = 'Order Plan&ning';
                Image = Planning;
                RunObject = Page "Order Planning";
            }
            separator(Action38)
            {
            }
            action("Requisition &Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'Requisition &Worksheet';
                Image = Worksheet;
                RunObject = Page "Req. Wksh. Names";
                RunPageView = where("Template Type"=const("Req."),
                                    Recurring=const(false));
            }
            action("Pur&chase Prices")
            {
                ApplicationArea = Basic;
                Caption = 'Pur&chase Prices';
                Image = Price;
                RunObject = Page "Purchase Prices";
            }
            action("Purchase &Line Discounts")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase &Line Discounts';
                Image = LineDiscount;
                RunObject = Page "Purchase Line Discounts";
            }
            separator(Action36)
            {
                Caption = 'History';
                IsHeader = true;
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

