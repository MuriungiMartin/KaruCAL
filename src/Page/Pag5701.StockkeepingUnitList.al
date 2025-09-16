#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5701 "Stockkeeping Unit List"
{
    ApplicationArea = Basic;
    Caption = 'Stockkeeping Unit List';
    CardPageID = "Stockkeeping Unit Card";
    Editable = false;
    PageType = List;
    SourceTable = "Stockkeeping Unit";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item number to which the SKU applies.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a variant code for the item.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code (for example, the warehouse or distribution center) to which the SKU applies.';
                }
                field("Replenishment System";"Replenishment System")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of supply order that is created by the planning system when the SKU needs to be replenished.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description from the Item Card.';
                }
                field(Inventory;Inventory)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                }
                field("Reorder Point";"Reorder Point")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                    Visible = false;
                }
                field("Reorder Quantity";"Reorder Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                    Visible = false;
                }
                field("Maximum Inventory";"Maximum Inventory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
                    Visible = false;
                }
                field("Assembly Policy";"Assembly Policy")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which default order flow is used to supply this SKU by assembly.';
                    Visible = false;
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
                separator(Action1102601007)
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
                separator(Action1102601010)
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
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const(Item),
                                  "No."=field("Item No.");
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
                group(Statistics)
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
                group("&Item Availability By")
                {
                    Caption = '&Item Availability By';
                    Image = ItemAvailability;
                    action("<Action5>")
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
                    action("Bill of Material")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Bill of Material';
                        Image = BOM;

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
                action(Action1102601046)
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
                        Image = CustomerLedger;
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
        }
        area(creation)
        {
        }
        area(reporting)
        {
            action("Inventory - List")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory - List";
            }
            action("Inventory Availability")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Availability';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory Availability";
            }
            action("Inventory - Availability Plan")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - Availability Plan';
                Image = ItemAvailability;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory - Availability Plan";
            }
            action("Item/Vendor Catalog")
            {
                ApplicationArea = Basic;
                Caption = 'Item/Vendor Catalog';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Item/Vendor Catalog";
            }
        }
        area(processing)
        {
            group(New)
            {
                Caption = 'New';
                Image = NewItem;
                action("New Item")
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
                    ApplicationArea = Basic;
                    Caption = 'C&alculate Counting Period';
                    Image = CalculateCalendar;

                    trigger OnAction()
                    var
                        SKU: Record "Stockkeeping Unit";
                        PhysInvtCountMgt: Codeunit "Phys. Invt. Count.-Management";
                    begin
                        CurrPage.SetSelectionFilter(SKU);
                        PhysInvtCountMgt.UpdateSKUPhysInvtCount(SKU);
                    end;
                }
            }
        }
    }

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
}

