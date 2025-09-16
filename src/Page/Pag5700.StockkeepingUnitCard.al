#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5700 "Stockkeeping Unit Card"
{
    Caption = 'Stockkeeping Unit Card';
    PageType = Card;
    SourceTable = "Stockkeeping Unit";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the item number to which the SKU applies.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description from the Item Card.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the location code (for example, the warehouse or distribution center) to which the SKU applies.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies a variant code for the item.';
                }
                field("Assembly BOM";"Assembly BOM")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies where to find the SKU in the warehouse.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies when the SKU card was last modified.';
                }
                field("Qty. on Purch. Order";"Qty. on Purch. Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                }
                field("Qty. on Prod. Order";"Qty. on Prod. Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many item units have been planned for production, which is how many units are on outstanding production order lines.';
                }
                field("Qty. in Transit";"Qty. in Transit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the SKUs in transit. These items have been shipped, but not yet received.';
                }
                field("Qty. on Component Lines";"Qty. on Component Lines")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many item units are needed for production, which is how many units remain on outstanding production order component lists.';
                }
                field("Qty. on Sales Order";"Qty. on Sales Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                }
                field("Qty. on Service Order";"Qty. on Service Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many item units are reserved for service orders, which is how many units are listed on outstanding service order lines.';
                }
                field(Inventory;Inventory)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                }
                field("Qty. on Job Order";"Qty. on Job Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item are allocated to jobs, meaning listed on outstanding job planning lines.';
                }
                field("Qty. on Assembly Order";"Qty. on Assembly Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the SKU are allocated to assembly orders, which is how many are listed on outstanding assembly order headers.';
                }
                field("Qty. on Asm. Component";"Qty. on Asm. Component")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many item units are allocated as assembly components, which is how many units are on outstanding assembly order lines.';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Standard Cost";"Standard Cost")
                {
                    ApplicationArea = Basic;
                    Enabled = StandardCostEnable;
                    ToolTip = 'Specifies the unit cost that is used as standard cost for this SKU.';

                    trigger OnDrillDown()
                    var
                        ShowAvgCalcItem: Codeunit "Show Avg. Calc. - Item";
                    begin
                        ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Item);
                    end;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    Enabled = UnitCostEnable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the cost per unit of this SKU.';

                    trigger OnDrillDown()
                    var
                        ShowAvgCalcItem: Codeunit "Show Avg. Calc. - Item";
                    begin
                        ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Item);
                    end;
                }
                field("Last Direct Cost";"Last Direct Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the most recent direct unit cost that was paid for the SKUs.';
                }
            }
            group(Replenishment)
            {
                Caption = 'Replenishment';
                field("Replenishment System";"Replenishment System")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the type of supply order that is created by the planning system when the SKU needs to be replenished.';
                }
                field("Lead Time Calculation";"Lead Time Calculation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a date formula for the amount of time it takes to replenish the item.';
                }
                group(Purchase)
                {
                    Caption = 'Purchase';
                    field("Vendor No.";"Vendor No.")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                    }
                    field("Vendor Item No.";"Vendor Item No.")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                    }
                }
                group(Transfer)
                {
                    Caption = 'Transfer';
                    field("Transfer-from Code";"Transfer-from Code")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies the code of the location from which you usually receive transfer items.';
                    }
                }
                group(Production)
                {
                    Caption = 'Production';
                    field("Manufacturing Policy";"Manufacturing Policy")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                    }
                    field("Flushing Method";"Flushing Method")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                    }
                    field("Components at Location";"Components at Location")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies the inventory location from where the production order components are to be taken when producing this SKU.';
                    }
                    field("Lot Size";"Lot Size")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                    }
                }
                group(Assembly)
                {
                    Caption = 'Assembly';
                    field("Assembly Policy";"Assembly Policy")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies which default order flow is used to supply this SKU by assembly.';
                    }
                }
            }
            group(Planning)
            {
                Caption = 'Planning';
                field("Reordering Policy";"Reordering Policy")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';

                    trigger OnValidate()
                    begin
                        EnablePlanningControls;
                    end;
                }
                field("Dampener Period";"Dampener Period")
                {
                    ApplicationArea = Basic;
                    Enabled = DampenerPeriodEnable;
                    ToolTip = 'Specifies a period of time during which you do not want the planning system to propose to reschedule existing supply orders forward.';
                }
                field("Dampener Quantity";"Dampener Quantity")
                {
                    ApplicationArea = Basic;
                    Enabled = DampenerQtyEnable;
                    ToolTip = 'Defines a dampener quantity to block insignificant change suggestions, if the quantity by which the supply would change is lower than the dampener quantity.';
                }
                field("Safety Lead Time";"Safety Lead Time")
                {
                    ApplicationArea = Basic;
                    Enabled = SafetyLeadTimeEnable;
                    ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                }
                field("Safety Stock Quantity";"Safety Stock Quantity")
                {
                    ApplicationArea = Basic;
                    Enabled = SafetyStockQtyEnable;
                    ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                }
                group("Lot-for-Lot Parameters")
                {
                    Caption = 'Lot-for-Lot Parameters';
                    field("Include Inventory";"Include Inventory")
                    {
                        ApplicationArea = Basic;
                        Enabled = IncludeInventoryEnable;
                        ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';

                        trigger OnValidate()
                        begin
                            EnablePlanningControls;
                        end;
                    }
                    field("Lot Accumulation Period";"Lot Accumulation Period")
                    {
                        ApplicationArea = Basic;
                        Enabled = LotAccumulationPeriodEnable;
                        ToolTip = 'Defines a period in which multiple demands are accumulated into one supply order, when you use the Lot-for-Lot reordering policy.';
                    }
                    field("Rescheduling Period";"Rescheduling Period")
                    {
                        ApplicationArea = Basic;
                        Enabled = ReschedulingPeriodEnable;
                        ToolTip = 'Defines a period within which any suggestion to change a supply date always consists of a Reschedule action and never a Cancel + New action.';
                    }
                }
                group("Reorder-Point Parameters")
                {
                    Caption = 'Reorder-Point Parameters';
                    grid(Control39)
                    {
                        GridLayout = Rows;
                        group(Control41)
                        {
                            field("Reorder Point";"Reorder Point")
                            {
                                ApplicationArea = Basic;
                                Enabled = ReorderPointEnable;
                                ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                            }
                            field("Reorder Quantity";"Reorder Quantity")
                            {
                                ApplicationArea = Basic;
                                Enabled = ReorderQtyEnable;
                                ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                            }
                            field("Maximum Inventory";"Maximum Inventory")
                            {
                                ApplicationArea = Basic;
                                Enabled = MaximumInventoryEnable;
                                ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                            }
                        }
                    }
                    field("Overflow Level";"Overflow Level")
                    {
                        ApplicationArea = Basic;
                        Enabled = OverflowLevelEnable;
                        Importance = Additional;
                        ToolTip = 'Specifies a quantity you allow projected inventory to exceed the reorder point before the system suggests to decrease existing supply orders.';
                    }
                    field("Time Bucket";"Time Bucket")
                    {
                        ApplicationArea = Basic;
                        Enabled = TimeBucketEnable;
                        Importance = Additional;
                        ToolTip = 'Specifies a time period for the recurring planning horizon of the SKU when you use Fixed Reorder Qty. or Maximum Qty. reordering policies.';
                    }
                }
                group("Order Modifiers")
                {
                    Caption = 'Order Modifiers';
                    Enabled = MinimumOrderQtyEnable;
                    grid(Control21)
                    {
                        GridLayout = Rows;
                        group(Control23)
                        {
                            field("Minimum Order Quantity";"Minimum Order Quantity")
                            {
                                ApplicationArea = Basic;
                                Enabled = MinimumOrderQtyEnable;
                                ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                            }
                            field("Maximum Order Quantity";"Maximum Order Quantity")
                            {
                                ApplicationArea = Basic;
                                Enabled = MaximumOrderQtyEnable;
                                ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                            }
                            field("Order Multiple";"Order Multiple")
                            {
                                ApplicationArea = Basic;
                                Enabled = OrderMultipleEnable;
                                ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                            }
                        }
                    }
                }
            }
            group(Control1907509201)
            {
                Caption = 'Warehouse';
                field("Special Equipment Code";"Special Equipment Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the equipment that you need to use when working with the SKU.';
                }
                field("Put-away Template Code";"Put-away Template Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the put-away template that the program uses when it performs a put-away for the SKU.';
                }
                field("Put-away Unit of Measure Code";"Put-away Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the unit of measure that the program uses when it performs a put-away for the SKU.';
                }
                field("Phys Invt Counting Period Code";"Phys Invt Counting Period Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the counting period that indicates how often you want to count the SKU in a physical inventory.';
                }
                field("Last Phys. Invt. Date";"Last Phys. Invt. Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which you last posted the results of a physical inventory for the SKU to the item ledger.';
                }
                field("Last Counting Period Update";"Last Counting Period Update")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last date on which you calculated the counting period.';
                }
                field("Next Counting Start Date";"Next Counting Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("Next Counting End Date";"Next Counting End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Use Cross-Docking";"Use Cross-Docking")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the SKU can be cross-docked.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Item")
            {
                Caption = '&Item';
                Image = Item;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Item Card";
                    RunPageLink = "No."=field("Item No.");
                    ShortCutKey = 'Shift+F7';
                }
                group(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    action(Action89)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Statistics';
                        Image = Statistics;
                        Promoted = true;
                        PromotedCategory = Process;
                        ShortCutKey = 'F7';

                        trigger OnAction()
                        var
                            ItemStatistics: Page "Item Statistics";
                        begin
                            ItemStatistics.SetItem(Item);
                            ItemStatistics.RunModal;
                        end;
                    }
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const(Item),
                                  "No."=field("Item No.");
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(27),
                                  "No."=field("Item No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                action("&Picture")
                {
                    ApplicationArea = Basic;
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Item Picture";
                    RunPageLink = "No."=field("Item No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Location Filter"=field("Location Code"),
                                  "Drop Shipment Filter"=field("Drop Shipment Filter"),
                                  "Variant Filter"=field("Variant Code");
                }
                separator(Action103)
                {
                }
                action("&Units of Measure")
                {
                    ApplicationArea = Basic;
                    Caption = '&Units of Measure';
                    Image = UnitOfMeasure;
                    RunObject = Page "Item Units of Measure";
                    RunPageLink = "Item No."=field("Item No.");
                }
                action("Va&riants")
                {
                    ApplicationArea = Basic;
                    Caption = 'Va&riants';
                    Image = ItemVariant;
                    RunObject = Page "Item Variants";
                    RunPageLink = "Item No."=field("Item No.");
                }
                separator(Action106)
                {
                }
                action(Translations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page "Item Translations";
                    RunPageLink = "Item No."=field("Item No."),
                                  "Variant Code"=field(filter("Variant Code"));
                }
                action("E&xtended Text")
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xtended Text';
                    Image = Text;
                    RunObject = Page "Extended Text List";
                    RunPageLink = "Table Name"=const(Item),
                                  "No."=field("Item No.");
                    RunPageView = sorting("Table Name","No.","Language Code","All Language Codes","Starting Date","Ending Date");
                }
            }
            group("&SKU")
            {
                Caption = '&SKU';
                Image = SKU;
                group(ActionGroup92)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    action("Entry Statistics")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Entry Statistics';
                        Image = EntryStatistics;
                        RunObject = Page "Item Entry Statistics";
                        RunPageLink = "No."=field("Item No."),
                                      "Date Filter"=field("Date Filter"),
                                      "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                      "Location Filter"=field("Location Code"),
                                      "Drop Shipment Filter"=field("Drop Shipment Filter"),
                                      "Variant Filter"=field("Variant Code");
                    }
                    action("T&urnover")
                    {
                        ApplicationArea = Basic;
                        Caption = 'T&urnover';
                        Image = Turnover;
                        RunObject = Page "Item Turnover";
                        RunPageLink = "No."=field("Item No."),
                                      "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                      "Location Filter"=field("Location Code"),
                                      "Drop Shipment Filter"=field("Drop Shipment Filter"),
                                      "Variant Filter"=field("Variant Code");
                    }
                }
                group("&Item Availability by")
                {
                    Caption = '&Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        var
                            Item: Record Item;
                        begin
                            Item.Get("Item No.");
                            Item.SetRange("Location Filter","Location Code");
                            Item.SetRange("Variant Filter","Variant Code");
                            Copyfilter("Date Filter",Item."Date Filter");
                            Copyfilter("Global Dimension 1 Filter",Item."Global Dimension 1 Filter");
                            Copyfilter("Global Dimension 2 Filter",Item."Global Dimension 2 Filter");
                            Copyfilter("Drop Shipment Filter",Item."Drop Shipment Filter");
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Item,ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        Image = Period;
                        RunObject = Page "Item Availability by Periods";
                        RunPageLink = "No."=field("Item No."),
                                      "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                      "Location Filter"=field("Location Code"),
                                      "Drop Shipment Filter"=field("Drop Shipment Filter"),
                                      "Variant Filter"=field("Variant Code");
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Basic;
                        Caption = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        var
                            Item: Record Item;
                        begin
                            Item.Get("Item No.");
                            Item.SetRange("Location Filter","Location Code");
                            Item.SetRange("Variant Filter","Variant Code");
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Item,ItemAvailFormsMgt.ByBOM);
                        end;
                    }
                    action(Timeline)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Timeline';
                        Image = Timeline;

                        trigger OnAction()
                        begin
                            ShowTimeline(Rec);
                        end;
                    }
                }
                action(Action124)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Stock. Unit Comment Sheet";
                    RunPageLink = "Item No."=field("Item No."),
                                  "Variant Code"=field("Variant Code"),
                                  "Location Code"=field("Location Code");
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                group("E&ntries")
                {
                    Caption = 'E&ntries';
                    Image = Entries;
                    action("Ledger E&ntries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ledger E&ntries';
                        Image = ItemLedger;
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Item No."=field("Item No."),
                                      "Location Code"=field("Location Code"),
                                      "Variant Code"=field("Variant Code");
                        RunPageView = sorting("Item No.",Open,"Variant Code");
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action("&Reservation Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = '&Reservation Entries';
                        Image = ReservationLedger;
                        RunObject = Page "Reservation Entries";
                        RunPageLink = "Item No."=field("Item No."),
                                      "Location Code"=field("Location Code"),
                                      "Variant Code"=field("Variant Code"),
                                      "Reservation Status"=const(Reservation);
                        RunPageView = sorting("Item No.","Variant Code","Location Code","Reservation Status");
                    }
                    action("&Phys. Inventory Ledger Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = '&Phys. Inventory Ledger Entries';
                        Image = PhysicalInventoryLedger;
                        RunObject = Page "Phys. Inventory Ledger Entries";
                        RunPageLink = "Item No."=field("Item No."),
                                      "Location Code"=field("Location Code"),
                                      "Variant Code"=field("Variant Code");
                        RunPageView = sorting("Item No.","Variant Code");
                    }
                    action("&Value Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = '&Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Item No."=field("Item No."),
                                      "Location Code"=field("Location Code"),
                                      "Variant Code"=field("Variant Code");
                        RunPageView = sorting("Item No.","Valuation Date","Location Code","Variant Code");
                    }
                    action("Item &Tracking Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item &Tracking Entries';
                        Image = ItemTrackingLedger;

                        trigger OnAction()
                        var
                            ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
                        begin
                            ItemTrackingDocMgt.ShowItemTrackingForMasterData(0,'',"Item No.","Variant Code",'','',"Location Code");
                        end;
                    }
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("&Bin Contents")
                {
                    ApplicationArea = Basic;
                    Caption = '&Bin Contents';
                    Image = BinContent;
                    RunObject = Page "Bin Contents List";
                    RunPageLink = "Location Code"=field("Location Code"),
                                  "Item No."=field("Item No."),
                                  "Variant Code"=field("Variant Code");
                    RunPageView = sorting("Location Code","Item No.","Variant Code");
                }
            }
        }
        area(processing)
        {
            group(New)
            {
                Caption = 'New';
                Image = NewItem;
                action(NewItem)
                {
                    ApplicationArea = Basic;
                    Caption = 'New Item';
                    Image = NewItem;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Item Card";
                    RunPageMode = Create;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("C&alculate Counting Period")
                {
                    AccessByPermission = TableData "Phys. Invt. Item Selection"=R;
                    ApplicationArea = Basic;
                    Caption = 'C&alculate Counting Period';
                    Image = CalculateCalendar;

                    trigger OnAction()
                    var
                        PhysInvtCountMgt: Codeunit "Phys. Invt. Count.-Management";
                    begin
                        PhysInvtCountMgt.UpdateSKUPhysInvtCount(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        InvtSetup.Get;
        Item.Reset;
        if Item.Get("Item No.") then begin
          if InvtSetup."Average Cost Calc. Type" = InvtSetup."average cost calc. type"::"Item & Location & Variant" then begin
            Item.SetRange("Location Filter","Location Code");
            Item.SetRange("Variant Filter","Variant Code");
          end;
          Item.SetFilter("Date Filter",GetFilter("Date Filter"));
        end;
        EnablePlanningControls;
        EnableCostingControls;
    end;

    trigger OnInit()
    begin
        UnitCostEnable := true;
        StandardCostEnable := true;
        OverflowLevelEnable := true;
        DampenerQtyEnable := true;
        DampenerPeriodEnable := true;
        LotAccumulationPeriodEnable := true;
        ReschedulingPeriodEnable := true;
        IncludeInventoryEnable := true;
        OrderMultipleEnable := true;
        MaximumOrderQtyEnable := true;
        MinimumOrderQtyEnable := true;
        MaximumInventoryEnable := true;
        ReorderQtyEnable := true;
        ReorderPointEnable := true;
        SafetyStockQtyEnable := true;
        SafetyLeadTimeEnable := true;
        TimeBucketEnable := true;
    end;

    var
        InvtSetup: Record "Inventory Setup";
        Item: Record Item;
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        [InDataSet]
        TimeBucketEnable: Boolean;
        [InDataSet]
        SafetyLeadTimeEnable: Boolean;
        [InDataSet]
        SafetyStockQtyEnable: Boolean;
        [InDataSet]
        ReorderPointEnable: Boolean;
        [InDataSet]
        ReorderQtyEnable: Boolean;
        [InDataSet]
        MaximumInventoryEnable: Boolean;
        [InDataSet]
        MinimumOrderQtyEnable: Boolean;
        [InDataSet]
        MaximumOrderQtyEnable: Boolean;
        [InDataSet]
        OrderMultipleEnable: Boolean;
        [InDataSet]
        IncludeInventoryEnable: Boolean;
        [InDataSet]
        ReschedulingPeriodEnable: Boolean;
        [InDataSet]
        LotAccumulationPeriodEnable: Boolean;
        [InDataSet]
        DampenerPeriodEnable: Boolean;
        [InDataSet]
        DampenerQtyEnable: Boolean;
        [InDataSet]
        OverflowLevelEnable: Boolean;
        [InDataSet]
        StandardCostEnable: Boolean;
        [InDataSet]
        UnitCostEnable: Boolean;

    local procedure EnablePlanningControls()
    var
        PlanningGetParam: Codeunit "Planning-Get Parameters";
        TimeBucketEnabled: Boolean;
        SafetyLeadTimeEnabled: Boolean;
        SafetyStockQtyEnabled: Boolean;
        ReorderPointEnabled: Boolean;
        ReorderQtyEnabled: Boolean;
        MaximumInventoryEnabled: Boolean;
        MinimumOrderQtyEnabled: Boolean;
        MaximumOrderQtyEnabled: Boolean;
        OrderMultipleEnabled: Boolean;
        IncludeInventoryEnabled: Boolean;
        ReschedulingPeriodEnabled: Boolean;
        LotAccumulationPeriodEnabled: Boolean;
        DampenerPeriodEnabled: Boolean;
        DampenerQtyEnabled: Boolean;
        OverflowLevelEnabled: Boolean;
    begin
        PlanningGetParam.SetUpPlanningControls("Reordering Policy","Include Inventory",
          TimeBucketEnabled,SafetyLeadTimeEnabled,SafetyStockQtyEnabled,
          ReorderPointEnabled,ReorderQtyEnabled,MaximumInventoryEnabled,
          MinimumOrderQtyEnabled,MaximumOrderQtyEnabled,OrderMultipleEnabled,IncludeInventoryEnabled,
          ReschedulingPeriodEnabled,LotAccumulationPeriodEnabled,
          DampenerPeriodEnabled,DampenerQtyEnabled,OverflowLevelEnabled);

        TimeBucketEnable := TimeBucketEnabled;
        SafetyLeadTimeEnable := SafetyLeadTimeEnabled;
        SafetyStockQtyEnable := SafetyStockQtyEnabled;
        ReorderPointEnable := ReorderPointEnabled;
        ReorderQtyEnable := ReorderQtyEnabled;
        MaximumInventoryEnable := MaximumInventoryEnabled;
        MinimumOrderQtyEnable := MinimumOrderQtyEnabled;
        MaximumOrderQtyEnable := MaximumOrderQtyEnabled;
        OrderMultipleEnable := OrderMultipleEnabled;
        IncludeInventoryEnable := IncludeInventoryEnabled;
        ReschedulingPeriodEnable := ReschedulingPeriodEnabled;
        LotAccumulationPeriodEnable := LotAccumulationPeriodEnabled;
        DampenerPeriodEnable := DampenerPeriodEnabled;
        DampenerQtyEnable := DampenerQtyEnabled;
        OverflowLevelEnable := OverflowLevelEnabled;
    end;

    local procedure EnableCostingControls()
    begin
        StandardCostEnable := Item."Costing Method" = Item."costing method"::Standard;
        UnitCostEnable := Item."Costing Method" <> Item."costing method"::Standard;
    end;
}

