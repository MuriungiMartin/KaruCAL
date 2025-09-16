#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 291 "Req. Worksheet"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Req. Worksheet';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Requisition Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName;CurrentJnlBatchName)
            {
                ApplicationArea = Jobs;
                Caption = 'Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the record.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    ReqJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ReqJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type of requisition worksheet line you are creating.';

                    trigger OnValidate()
                    begin
                        ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                    end;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the general ledger account or item to be entered on the line.';

                    trigger OnValidate()
                    begin
                        ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Action Message";"Action Message")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an action to take to rebalance the demand-supply situation.';
                }
                field("Accept Action Message";"Accept Action Message")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether to accept the action message proposed for the line.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a variant code for the item.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies text that describes the entry.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies additional text describing the entry, or a remark about the requisition worksheet line.';
                    Visible = false;
                }
                field("Transfer-from Code";"Transfer-from Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code of the location that the item will be transferred from.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for an inventory location where the items that are being ordered will be registered.';
                }
                field("Original Quantity";"Original Quantity")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity stated on the production or purchase order, when an action message proposes to change the quantity on an order.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of units of the item.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit of measure code used to determine the unit price.';
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the direct unit cost of this item.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Jobs;
                    AssistEdit = true;
                    ToolTip = 'Specifies the currency code for the requisition lines.';
                    Visible = false;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WorkDate);
                        if ChangeExchangeRate.RunModal = Action::OK then
                          Validate("Currency Factor",ChangeExchangeRate.GetParameter);

                        Clear(ChangeExchangeRate);
                    end;
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the discount percentage used to calculate the purchase line discount.';
                    Visible = false;
                }
                field("Original Due Date";"Original Due Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the due date stated on the production or purchase order, when an action message proposes to reschedule an order.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date when you can expect to receive the items.';
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the order date that will apply to the requisition worksheet line.';
                    Visible = false;
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the vendor who will ship the items in the purchase order.';

                    trigger OnValidate()
                    begin
                        ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Vendor Item No.";"Vendor Item No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the vendor''s item number for this item.';
                }
                field("Order Address Code";"Order Address Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the order address code linked to the relevant vendor''s order address.';
                    Visible = false;
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the customer for whom the purchase line items will be ordered, if the line is a drop shipment.';
                    Visible = false;
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the ship-to code for the customer for which the purchase line items will be ordered, if the line is a drop shipment.';
                    Visible = false;
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a value when you calculate the production order.';
                    Visible = false;
                }
                field("Requester ID";"Requester ID")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the ID of the user who is ordering the items on the line.';
                    Visible = false;
                }
                field(Confirmed;Confirmed)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the items on the line have been approved for purchase.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(4),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(5),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(6),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(7),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(8),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Ref. Order No.";"Ref. Order No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the relevant production or purchase order.';
                    Visible = false;
                }
                field("Ref. Order Type";"Ref. Order Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the order is a purchase order, a production order, or a transfer order.';
                    Visible = false;
                }
                field("Replenishment System";"Replenishment System")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies which kind of order to use to create replenishment orders and order proposals.';
                }
                field("Ref. Line No.";"Ref. Line No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the purchase or production order line.';
                    Visible = false;
                }
                field("Planning Flexibility";"Planning Flexibility")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the supply, represented by the requisition worksheet line, is considered by the planning system, when calculating action messages.';
                    Visible = false;
                }
                field("Blanket Purch. Order Exists";"Blanket Purch. Order Exists")
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    ToolTip = 'Specifies if a blanket purchase order exists for the item on the requisition line.';
                    Visible = false;
                }
            }
            group(Control20)
            {
                fixed(Control1901776201)
                {
                    group(Control1902759801)
                    {
                        Caption = 'Description';
                        field(Description2;Description2)
                        {
                            ApplicationArea = Jobs;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies an additional part of the worksheet description.';
                        }
                    }
                    group("Buy-from Vendor Name")
                    {
                        Caption = 'Buy-from Vendor Name';
                        field(BuyFromVendorName;BuyFromVendorName)
                        {
                            ApplicationArea = Jobs;
                            Caption = 'Buy-from Vendor Name';
                            Editable = false;
                            ToolTip = 'Specifies the vendor according to the values in the Document No. and Document Type fields.';
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control1903326807;"Item Replenishment FactBox")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No."=field("No.");
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;
                    RunObject = Codeunit "Req. Wksh.-Show Card";
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the item or resource.';
                }
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Event';
                        Image = "Event";
                        ToolTip = 'View how the actual and projected inventory level of an item will develop over time according to supply and demand events.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Period';
                        Image = Period;
                        ToolTip = 'Show the actual and projected quantity of an item over time according to a specified time interval, such as by day, week or month.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Variant';
                        Image = ItemVariant;
                        ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByVariant)
                        end;
                    }
                    action(Location)
                    {
                        AccessByPermission = TableData Location=R;
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'BOM Level';
                        Image = BOMLevel;
                        ToolTip = 'View how the inventory level of an item develops over time according to the bill of materials level that you select.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByBOM)
                        end;
                    }
                    action(Timeline)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Timeline';
                        Image = Timeline;
                        ToolTip = 'Get a graphical view of an item’s projected inventory based on future supply and demand events, with or without planning suggestions. The result is a graphical representation of the inventory profile.';

                        trigger OnAction()
                        begin
                            ShowTimeline(Rec);
                        end;
                    }
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Jobs;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                action("Item &Tracking Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CalculatePlan)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Calculate Plan';
                    Ellipsis = true;
                    Image = CalculatePlan;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Use a batch job to help you calculate a supply plan for items and stockkeeping units that have the Replenishment System field set to Purchase or Transfer.';

                    trigger OnAction()
                    begin
                        CalculatePlan.SetTemplAndWorksheet("Worksheet Template Name","Journal Batch Name");
                        CalculatePlan.RunModal;
                        Clear(CalculatePlan);
                    end;
                }
                group("Drop Shipment")
                {
                    Caption = 'Drop Shipment';
                    Image = Delivery;
                    action("Get &Sales Orders")
                    {
                        AccessByPermission = TableData "Drop Shpt. Post. Buffer"=R;
                        ApplicationArea = Jobs;
                        Caption = 'Get &Sales Orders';
                        Ellipsis = true;
                        Image = "Order";
                        ToolTip = 'Copy sales lines to the requisition worksheet. You can use the batch job to create requisition worksheet proposal lines from sales lines for drop shipments or special orders.';

                        trigger OnAction()
                        begin
                            GetSalesOrder.SetReqWkshLine(Rec,0);
                            GetSalesOrder.RunModal;
                            Clear(GetSalesOrder);
                        end;
                    }
                    action("Sales &Order")
                    {
                        AccessByPermission = TableData "Sales Shipment Header"=R;
                        ApplicationArea = Jobs;
                        Caption = 'Sales &Order';
                        Image = Document;
                        ToolTip = 'Create a new sales order for an item that is shipped directly from the vendor to the customer. The Drop Shipment check box must be selected on the sales order line, and the Vendor No. field must be filled on the item card.';

                        trigger OnAction()
                        begin
                            SalesHeader.SetRange("No.","Sales Order No.");
                            SalesOrder.SetTableview(SalesHeader);
                            SalesOrder.Editable := false;
                            SalesOrder.Run;
                        end;
                    }
                }
                group("Special Order")
                {
                    Caption = 'Special Order';
                    Image = SpecialOrder;
                    action(Action53)
                    {
                        AccessByPermission = TableData "Drop Shpt. Post. Buffer"=R;
                        ApplicationArea = Jobs;
                        Caption = 'Get &Sales Orders';
                        Ellipsis = true;
                        Image = "Order";
                        ToolTip = 'Copy sales lines to the requisition worksheet. You can use the batch job to create requisition worksheet proposal lines from sales lines for drop shipments or special orders.';

                        trigger OnAction()
                        begin
                            GetSalesOrder.SetReqWkshLine(Rec,1);
                            GetSalesOrder.RunModal;
                            Clear(GetSalesOrder);
                        end;
                    }
                    action(Action75)
                    {
                        AccessByPermission = TableData "Sales Shipment Header"=R;
                        ApplicationArea = Jobs;
                        Caption = 'Sales &Order';
                        Image = Document;
                        ToolTip = 'Create a new sales order for an item that is shipped directly from the vendor to the customer. The Drop Shipment check box must be selected on the sales order line, and the Vendor No. field must be filled on the item card.';

                        trigger OnAction()
                        begin
                            SalesHeader.SetRange("No.","Sales Order No.");
                            SalesOrder.SetTableview(SalesHeader);
                            SalesOrder.Editable := false;
                            SalesOrder.Run;
                        end;
                    }
                }
                separator(Action81)
                {
                }
                action(Reserve)
                {
                    ApplicationArea = Jobs;
                    Caption = '&Reserve';
                    Image = Reserve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Reserve one or more units of the item on the job planning line, either from inventory or from incoming supply.';

                    trigger OnAction()
                    begin
                        CurrPage.SaveRecord;
                        ShowReservation;
                    end;
                }
                action(CarryOutActionMessage)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Carry &Out Action Message';
                    Ellipsis = true;
                    Image = CarryOutActionMessage;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Use a batch job to help you create actual supply orders from the order proposals.';

                    trigger OnAction()
                    var
                        PerformAction: Report "Carry Out Action Msg. - Req.";
                    begin
                        PerformAction.SetReqWkshLine(Rec);
                        PerformAction.RunModal;
                        PerformAction.GetReqWkshLine(Rec);
                        CurrentJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
            group("Order Tracking")
            {
                Caption = 'Order Tracking';
                Image = OrderTracking;
                action("Order &Tracking")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.';

                    trigger OnAction()
                    var
                        TrackingForm: Page "Order Tracking";
                    begin
                        TrackingForm.SetReqLine(Rec);
                        TrackingForm.RunModal;
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Inventory Availability")
            {
                ApplicationArea = Jobs;
                Caption = 'Inventory Availability';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory Availability";
                ToolTip = 'View a list of the individual items'' inventory and much other information about them: quantity on sales order, quantity on purchase order, back orders from vendors, minimum inventory, and whether there is a reorder. The list can be used, for example, as the basis for deciding when to purchase items.';
            }
            action(Status)
            {
                ApplicationArea = Jobs;
                Caption = 'Status';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report Status;
                ToolTip = 'View the status of the worksheet.';
            }
            action("Inventory - Availability Plan")
            {
                ApplicationArea = Jobs;
                Caption = 'Inventory - Availability Plan';
                Image = ItemAvailability;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory - Availability Plan";
                ToolTip = 'View a list of the quantity of each item in customer, purchase, and transfer orders and the quantity available in inventory. The list is divided into columns that cover six periods with starting and ending dates as well as the periods before and after those periods. The list is useful when you are planning your inventory purchases.';
            }
            action("Inventory Order Details")
            {
                ApplicationArea = Jobs;
                Caption = 'Inventory Order Details';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory Order Details";
                ToolTip = 'View a list of the orders that have not yet been shipped or received and the items in the orders. It shows the order number, customer''s name, shipment date, order quantity, quantity on back order, outstanding quantity and unit price, as well as possible discount percentage and amount. The quantity on back order and outstanding quantity and amount are totaled for each item. The list can be used to find out whether there are currently shipment problems or any can be expected.';
            }
            action("Inventory Purchase Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Purchase Orders';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory Purchase Orders";
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        "Accept Action Message" := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ReqJnlManagement.SetUpNewLine(Rec,xRec);
        Clear(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        OpenedFromBatch := ("Journal Batch Name" <> '') and ("Worksheet Template Name" = '');
        if OpenedFromBatch then begin
          CurrentJnlBatchName := "Journal Batch Name";
          ReqJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
          exit;
        end;
        ReqJnlManagement.TemplateSelection(Page::"Req. Worksheet",false,0,Rec,JnlSelected);
        if not JnlSelected then
          Error('');
        ReqJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    end;

    var
        SalesHeader: Record "Sales Header";
        GetSalesOrder: Report "Get Sales Orders";
        CalculatePlan: Report "Calculate Plan - Req. Wksh.";
        ReqJnlManagement: Codeunit ReqJnlManagement;
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ChangeExchangeRate: Page "Change Exchange Rate";
        SalesOrder: Page "Sales Order";
        CurrentJnlBatchName: Code[10];
        Description2: Text[50];
        BuyFromVendorName: Text[50];
        ShortcutDimCode: array [8] of Code[20];
        OpenedFromBatch: Boolean;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        ReqJnlManagement.SetName(CurrentJnlBatchName,Rec);
        CurrPage.Update(false);
    end;
}

