#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 515 "Item Avail. by Location Lines"
{
    Caption = 'Lines';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SaveValues = true;
    SourceTable = Location;
    SourceTableView = where("Use As In-Transit"=const(false));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a location code for the warehouse or distribution center where your items are handled and stored before being sold.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name or address of the location.';
                }
                field(GrossRequirement;GrossRequirement)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Requirement';
                    DecimalPlaces = 0:5;

                    trigger OnDrillDown()
                    begin
                        ShowItemAvailLineList(0);
                    end;
                }
                field(ScheduledRcpt;ScheduledRcpt)
                {
                    ApplicationArea = Basic;
                    Caption = 'Scheduled Receipt';
                    DecimalPlaces = 0:5;

                    trigger OnDrillDown()
                    begin
                        ShowItemAvailLineList(2);
                    end;
                }
                field(PlannedOrderRcpt;PlannedOrderRcpt)
                {
                    ApplicationArea = Basic;
                    Caption = 'Planned Receipt';
                    DecimalPlaces = 0:5;

                    trigger OnDrillDown()
                    begin
                        ShowItemAvailLineList(1);
                    end;
                }
                field(ProjAvailableBalance;ProjAvailableBalance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Projected Available Balance';
                    DecimalPlaces = 0:5;

                    trigger OnDrillDown()
                    begin
                        ShowItemAvailLineList(4);
                    end;
                }
                field("Item.Inventory";Item.Inventory)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Hand';
                    DecimalPlaces = 0:5;
                    DrillDown = true;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        SetItemFilter;
                        ItemAvailFormsMgt.ShowItemLedgerEntries(Item,false);
                    end;
                }
                field("Item.""Qty. on Purch. Order""";Item."Qty. on Purch. Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Purch. Order';
                    DecimalPlaces = 0:5;
                    DrillDown = true;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        SetItemFilter;
                        ItemAvailFormsMgt.ShowPurchLines(Item);
                    end;
                }
                field("Item.""Qty. on Sales Order""";Item."Qty. on Sales Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Sales Order';
                    DecimalPlaces = 0:5;
                    DrillDown = true;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        SetItemFilter;
                        ItemAvailFormsMgt.ShowSalesLines(Item);
                    end;
                }
                field("Item.""Qty. on Service Order""";Item."Qty. on Service Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Service Order';
                    DecimalPlaces = 0:5;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        SetItemFilter;
                        ItemAvailFormsMgt.ShowServLines(Item);
                    end;
                }
                field("Item.""Qty. on Job Order""";Item."Qty. on Job Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Job Order';
                    DecimalPlaces = 0:5;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        SetItemFilter;
                        ItemAvailFormsMgt.ShowJobPlanningLines(Item);
                    end;
                }
                field("Item.""Trans. Ord. Shipment (Qty.)""";Item."Trans. Ord. Shipment (Qty.)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Trans. Ord. Shipment (Qty.)';
                    DecimalPlaces = 0:5;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        SetItemFilter;
                        ItemAvailFormsMgt.ShowTransLines(Item,Item.FieldNo("Trans. Ord. Shipment (Qty.)"));
                    end;
                }
                field("Item.""Qty. on Asm. Component""";Item."Qty. on Asm. Component")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Asm. Comp. Lines';
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
                    begin
                        ItemAvailFormsMgt.ShowAsmCompLines(Item);
                    end;
                }
                field("Item.""Qty. on Assembly Order""";Item."Qty. on Assembly Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Assembly Order';
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
                    begin
                        ItemAvailFormsMgt.ShowAsmOrders(Item);
                    end;
                }
                field("Item.""Qty. in Transit""";Item."Qty. in Transit")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. in Transit';
                    DecimalPlaces = 0:5;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        SetItemFilter;
                        ItemAvailFormsMgt.ShowTransLines(Item,Item.FieldNo("Qty. in Transit"));
                    end;
                }
                field("Item.""Trans. Ord. Receipt (Qty.)""";Item."Trans. Ord. Receipt (Qty.)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Trans. Ord. Receipt (Qty.)';
                    DecimalPlaces = 0:5;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        SetItemFilter;
                        ItemAvailFormsMgt.ShowTransLines(Item,Item.FieldNo("Trans. Ord. Receipt (Qty.)"));
                    end;
                }
                field(ExpectedInventory;ExpectedInventory)
                {
                    ApplicationArea = Basic;
                    Caption = 'Expected Inventory';
                    DecimalPlaces = 0:5;
                    Visible = false;
                }
                field(QtyAvailable;QtyAvailable)
                {
                    ApplicationArea = Basic;
                    Caption = 'Available Inventory';
                    DecimalPlaces = 0:5;
                    Visible = false;
                }
                field("Item.""Scheduled Receipt (Qty.)""";Item."Scheduled Receipt (Qty.)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Scheduled Receipt (Qty.)';
                    DecimalPlaces = 0:5;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        SetItemFilter;
                        ItemAvailFormsMgt.ShowSchedReceipt(Item);
                    end;
                }
                field("Item.""Scheduled Need (Qty.)""";Item."Scheduled Need (Qty.)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Scheduled Issue (Qty.)';
                    DecimalPlaces = 0:5;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        SetItemFilter;
                        ItemAvailFormsMgt.ShowSchedNeed(Item);
                    end;
                }
                field(PlannedOrderReleases;PlannedOrderReleases)
                {
                    ApplicationArea = Basic;
                    Caption = 'Planned Order Releases';
                    DecimalPlaces = 0:5;

                    trigger OnDrillDown()
                    begin
                        ShowItemAvailLineList(3);
                    end;
                }
                field("Item.""Net Change""";Item."Net Change")
                {
                    ApplicationArea = Basic;
                    Caption = 'Net Change';
                    DecimalPlaces = 0:5;
                    DrillDown = true;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        SetItemFilter;
                        ItemAvailFormsMgt.ShowItemLedgerEntries(Item,true);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalcAvailQuantities(
          GrossRequirement,PlannedOrderRcpt,ScheduledRcpt,
          PlannedOrderReleases,ProjAvailableBalance,ExpectedInventory,QtyAvailable);
    end;

    trigger OnInit()
    begin
        PeriodStart := 0D;
        PeriodEnd := 20991231D;
    end;

    var
        Item: Record Item;
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ExpectedInventory: Decimal;
        QtyAvailable: Decimal;
        AmountType: Option "Net Change","Balance at Date";
        PlannedOrderReleases: Decimal;
        GrossRequirement: Decimal;
        PlannedOrderRcpt: Decimal;
        ScheduledRcpt: Decimal;
        ProjAvailableBalance: Decimal;
        PeriodStart: Date;
        PeriodEnd: Date;


    procedure Set(var NewItem: Record Item;NewAmountType: Option "Net Change","Balance at Date")
    begin
        Item.Copy(NewItem);
        PeriodStart := Item.GetRangeMin("Date Filter");
        PeriodEnd := Item.GetRangemax("Date Filter");
        AmountType := NewAmountType;
        CurrPage.Update(false);
    end;

    local procedure SetItemFilter()
    begin
        if AmountType = Amounttype::"Net Change" then
          Item.SetRange("Date Filter",PeriodStart,PeriodEnd)
        else
          Item.SetRange("Date Filter",0D,PeriodEnd);
        Item.SetRange("Location Filter",Code);
    end;

    local procedure ShowItemAvailLineList(What: Integer)
    begin
        SetItemFilter;
        ItemAvailFormsMgt.ShowItemAvailLineList(Item,What);
    end;

    local procedure CalcAvailQuantities(var GrossRequirement: Decimal;var PlannedOrderRcpt: Decimal;var ScheduledRcpt: Decimal;var PlannedOrderReleases: Decimal;var ProjAvailableBalance: Decimal;var ExpectedInventory: Decimal;var QtyAvailable: Decimal)
    begin
        SetItemFilter;
        ItemAvailFormsMgt.CalcAvailQuantities(
          Item,AmountType = Amounttype::"Balance at Date",
          GrossRequirement,PlannedOrderRcpt,ScheduledRcpt,
          PlannedOrderReleases,ProjAvailableBalance,ExpectedInventory,QtyAvailable);
    end;
}

