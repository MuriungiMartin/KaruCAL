#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5790 "Available to Promise"
{

    trigger OnRun()
    begin
    end;

    var
        OldRecordExists: Boolean;
        ReqShipDate: Date;


    procedure QtyAvailabletoPromise(var Item: Record Item;var GrossRequirement: Decimal;var ScheduledReceipt: Decimal;AvailabilityDate: Date;PeriodType: Option Day,Week,Month,Quarter,Year;LookaheadDateFormula: DateFormula): Decimal
    begin
        ScheduledReceipt := CalcScheduledReceipt(Item);
        GrossRequirement := CalcGrossRequirement(Item);

        if Format(LookaheadDateFormula) <> '' then
          GrossRequirement :=
            GrossRequirement +
            CalculateLookahead(
              Item,PeriodType,
              AvailabilityDate + 1,
              AdjustedEndingDate(CalcDate(LookaheadDateFormula,AvailabilityDate),PeriodType));

        exit(
          CalcAvailableInventory(Item) +
          (ScheduledReceipt - CalcReservedReceipt(Item)) -
          (GrossRequirement - CalcReservedRequirement(Item)));
    end;


    procedure CalcAvailableInventory(var Item: Record Item): Decimal
    begin
        Item.CalcFields(Inventory,"Reserved Qty. on Inventory");
        exit(Item.Inventory - Item."Reserved Qty. on Inventory");
    end;


    procedure CalcGrossRequirement(var Item: Record Item): Decimal
    begin
        with Item do begin
          CalcFields(
            "Scheduled Need (Qty.)",
            "Planning Issues (Qty.)",
            "Planning Transfer Ship. (Qty).",
            "Qty. on Sales Order",
            "Qty. on Service Order",
            "Qty. on Job Order",
            "Trans. Ord. Shipment (Qty.)",
            "Qty. on Asm. Component",
            "Qty. on Purch. Return");

          exit(
            "Scheduled Need (Qty.)" +
            "Planning Issues (Qty.)" +
            "Planning Transfer Ship. (Qty)." +
            "Qty. on Sales Order" +
            "Qty. on Service Order" +
            "Qty. on Job Order" +
            "Trans. Ord. Shipment (Qty.)" +
            "Qty. on Asm. Component" +
            "Qty. on Purch. Return");
        end;
    end;


    procedure CalcReservedRequirement(var Item: Record Item): Decimal
    begin
        with Item do begin
          CalcFields(
            "Res. Qty. on Prod. Order Comp.",
            "Reserved Qty. on Sales Orders",
            "Res. Qty. on Service Orders",
            "Res. Qty. on Job Order",
            "Res. Qty. on Outbound Transfer",
            "Res. Qty. on  Asm. Comp.",
            "Res. Qty. on Purch. Returns");

          exit(
            "Res. Qty. on Prod. Order Comp." +
            "Reserved Qty. on Sales Orders" +
            "Res. Qty. on Service Orders" +
            "Res. Qty. on Job Order" +
            "Res. Qty. on Outbound Transfer" +
            "Res. Qty. on  Asm. Comp." +
            "Res. Qty. on Purch. Returns");
        end;
    end;


    procedure CalcScheduledReceipt(var Item: Record Item): Decimal
    begin
        with Item do begin
          CalcFields(
            "Scheduled Receipt (Qty.)",
            "Planned Order Receipt (Qty.)",
            "Qty. on Purch. Order",
            "Trans. Ord. Receipt (Qty.)",
            "Qty. in Transit",
            "Qty. on Assembly Order",
            "Qty. on Sales Return");

          exit(
            "Scheduled Receipt (Qty.)" +
            "Planned Order Receipt (Qty.)" +
            "Qty. on Purch. Order" +
            "Trans. Ord. Receipt (Qty.)" +
            "Qty. in Transit" +
            "Qty. on Assembly Order" +
            "Qty. on Sales Return");
        end;
    end;


    procedure CalcReservedReceipt(var Item: Record Item): Decimal
    begin
        with Item do begin
          CalcFields("Reserved Qty. on Prod. Order",
            "Reserved Qty. on Purch. Orders",
            "Res. Qty. on Inbound Transfer",
            "Res. Qty. on Assembly Order",
            "Res. Qty. on Sales Returns");

          exit("Reserved Qty. on Prod. Order" +
            "Reserved Qty. on Purch. Orders" +
            "Res. Qty. on Inbound Transfer" +
            "Res. Qty. on Assembly Order" +
            "Res. Qty. on Sales Returns");
        end;
    end;


    procedure EarliestAvailabilityDate(var Item: Record Item;NeededQty: Decimal;StartDate: Date;ExcludeQty: Decimal;ExcludeOnDate: Date;var AvailableQty: Decimal;PeriodType: Option Day,Week,Month,Quarter,Year;LookaheadDateFormula: DateFormula): Date
    var
        Date: Record Date;
        DummyItem: Record Item;
        AvailabilityAtDate: Record "Availability at Date" temporary;
        QtyIsAvailable: Boolean;
        ExactDateFound: Boolean;
        ScheduledReceipt: Decimal;
        GrossRequirement: Decimal;
        AvailableQtyPeriod: Decimal;
        AvailableDate: Date;
        PeriodStart: Date;
        PeriodEnd: Date;
    begin
        AvailableQty := 0;
        if Format(LookaheadDateFormula) = '' then
          exit;

        Item.Copyfilter("Date Filter",DummyItem."Date Filter");
        Item.SetRange("Date Filter",0D,AdjustedEndingDate(CalcDate(LookaheadDateFormula,StartDate),PeriodType));
        CalculateAvailability(Item,AvailabilityAtDate);
        UpdateScheduledReceipt(AvailabilityAtDate,ExcludeOnDate,ExcludeQty);
        CalculateAvailabilityByPeriod(AvailabilityAtDate,PeriodType);

        Date.SetRange("Period Type",PeriodType);
        Date.SetRange("Period Start",0D,StartDate);
        if Date.FindLast then begin
          AvailabilityAtDate.SetRange("Period Start",0D,Date."Period Start");
          if AvailabilityAtDate.FindSet then
            repeat
              if PeriodStart = 0D then
                PeriodStart := AvailabilityAtDate."Period Start";
              ScheduledReceipt += AvailabilityAtDate."Scheduled Receipt";
              GrossRequirement += AvailabilityAtDate."Gross Requirement";
            until AvailabilityAtDate.Next = 0;
          AvailableQty := Item.Inventory - Item."Reserved Qty. on Inventory" + ScheduledReceipt - GrossRequirement;
          if AvailableQty >= NeededQty then begin
            QtyIsAvailable := true;
            AvailableDate := Date."Period End";
            PeriodEnd := Date."Period End";
          end else
            PeriodStart := 0D;
        end;

        AvailabilityAtDate.SetRange("Period Start",StartDate + 1,CalcDate(LookaheadDateFormula,StartDate));
        AvailabilityAtDate."Period Start" := 0D;
        while AvailabilityAtDate.Next <> 0 do begin
          AvailableQtyPeriod := AvailabilityAtDate."Scheduled Receipt" - AvailabilityAtDate."Gross Requirement";
          if AvailabilityAtDate."Scheduled Receipt" <= AvailabilityAtDate."Gross Requirement" then begin
            AvailableQty := AvailableQty + AvailableQtyPeriod;
            AvailableDate := AvailabilityAtDate."Period End";
            if AvailableQty < NeededQty then
              QtyIsAvailable := false;
          end else
            if QtyIsAvailable then
              AvailabilityAtDate.FindLast
            else begin
              AvailableQty := AvailableQty + AvailableQtyPeriod;
              if AvailableQty >= NeededQty then begin
                QtyIsAvailable := true;
                AvailableDate := AvailabilityAtDate."Period End";
                PeriodStart := AvailabilityAtDate."Period Start";
                PeriodEnd := AvailabilityAtDate."Period End";
                AvailabilityAtDate.FindLast;
              end;
            end;
        end;

        if QtyIsAvailable then begin
          if PeriodType <> Periodtype::Day then begin
            Item.SetRange("Date Filter",PeriodStart,PeriodEnd);
            CalculateAvailability(Item,AvailabilityAtDate);
            if (ExcludeOnDate >= PeriodStart) and (ExcludeOnDate <= PeriodEnd) then
              UpdateScheduledReceipt(AvailabilityAtDate,ExcludeOnDate,ExcludeQty);
          end;
          AvailabilityAtDate.SetRange("Period Start",PeriodStart,PeriodEnd);
          if AvailabilityAtDate.Find('+') then
            repeat
              if (AvailableQty - AvailabilityAtDate."Scheduled Receipt") < NeededQty then begin
                ExactDateFound := true;
                AvailableDate := AvailabilityAtDate."Period Start";
              end else
                AvailableQty := AvailableQty - AvailabilityAtDate."Scheduled Receipt";
            until (AvailabilityAtDate.Next(-1) = 0) or ExactDateFound;
          if not ExactDateFound then begin
            AvailableDate := StartDate;
            if AvailabilityAtDate.Find then
              AvailableQty := AvailableQty + AvailabilityAtDate."Scheduled Receipt";
          end;
        end else
          AvailableDate := 0D;

        DummyItem.Copyfilter("Date Filter",Item."Date Filter");
        exit(AvailableDate);
    end;


    procedure CalculateLookahead(var Item: Record Item;PeriodType: Option Day,Week,Month,Quarter,Year;StartDate: Date;EndDate: Date): Decimal
    var
        DummyItem: Record Item;
        AvailabilityAtDate: Record "Availability at Date" temporary;
        LookaheadQty: Decimal;
        Stop: Boolean;
    begin
        Item.Copyfilter("Date Filter",DummyItem."Date Filter");
        Item.SetRange("Date Filter",StartDate,EndDate);
        CalculateAvailability(Item,AvailabilityAtDate);
        CalculateAvailabilityByPeriod(AvailabilityAtDate,PeriodType);
        AvailabilityAtDate.SetRange("Period Start",0D,StartDate - 1);
        if AvailabilityAtDate.FindSet then
          repeat
            LookaheadQty += AvailabilityAtDate."Gross Requirement" - AvailabilityAtDate."Scheduled Receipt";
          until AvailabilityAtDate.Next = 0;

        AvailabilityAtDate.SetRange("Period Start",StartDate,EndDate);
        if AvailabilityAtDate.FindSet then
          repeat
            if AvailabilityAtDate."Gross Requirement" > AvailabilityAtDate."Scheduled Receipt" then
              LookaheadQty += AvailabilityAtDate."Gross Requirement" - AvailabilityAtDate."Scheduled Receipt"
            else
              if AvailabilityAtDate."Gross Requirement" < AvailabilityAtDate."Scheduled Receipt" then
                Stop := true;
          until (AvailabilityAtDate.Next = 0) or Stop;

        if LookaheadQty < 0 then
          LookaheadQty := 0;

        DummyItem.Copyfilter("Date Filter",Item."Date Filter");
        exit(LookaheadQty);
    end;


    procedure CalculateAvailability(var Item: Record Item;var AvailabilityAtDate: Record "Availability at Date")
    var
        Item2: Record Item;
    begin
        Item2.CopyFilters(Item);
        Item.SetRange("Bin Filter");
        Item.SetRange("Global Dimension 1 Filter");
        Item.SetRange("Global Dimension 2 Filter");

        Item.CalcFields(Inventory,"Reserved Qty. on Inventory");

        AvailabilityAtDate.Reset;
        AvailabilityAtDate.DeleteAll;
        OldRecordExists := false;

        UpdateSchedRcptAvail(AvailabilityAtDate,Item);
        UpdatePurchReqRcptAvail(AvailabilityAtDate,Item);
        UpdatePurchOrderAvail(AvailabilityAtDate,Item);
        UpdateTransOrderRcptAvail(AvailabilityAtDate,Item);
        UpdateSchedNeedAvail(AvailabilityAtDate,Item);
        UpdatePlanningIssuesAvail(AvailabilityAtDate,Item);
        UpdateSalesOrderAvail(AvailabilityAtDate,Item);
        UpdateServOrderAvail(AvailabilityAtDate,Item);
        UpdateJobOrderAvail(AvailabilityAtDate,Item);
        UpdateTransOrderShptAvail(AvailabilityAtDate,Item);
        UpdateAsmOrderAvail(AvailabilityAtDate,Item);
        UpdateAsmCompAvail(AvailabilityAtDate,Item);

        Item.CopyFilters(Item2);
    end;

    local procedure UpdateScheduledReceipt(var AvailabilityAtDate: Record "Availability at Date";ReceiptDate: Date;ScheduledReceipt: Decimal)
    begin
        UpdateAvailability(AvailabilityAtDate,ReceiptDate,ScheduledReceipt,0);
    end;

    local procedure UpdateGrossRequirement(var AvailabilityAtDate: Record "Availability at Date";ShipmentDate: Date;GrossRequirement: Decimal)
    begin
        UpdateAvailability(AvailabilityAtDate,ShipmentDate,0,GrossRequirement);
    end;

    local procedure UpdateAvailability(var AvailabilityAtDate: Record "Availability at Date";Date: Date;ScheduledReceipt: Decimal;GrossRequirement: Decimal)
    var
        RecordExists: Boolean;
    begin
        if (ScheduledReceipt = 0) and (GrossRequirement = 0) then
          exit;

        if OldRecordExists and (Date = AvailabilityAtDate."Period Start") then
          RecordExists := true
        else begin
          AvailabilityAtDate."Period Start" := Date;
          if AvailabilityAtDate.Find then
            RecordExists := true
          else begin
            AvailabilityAtDate.Init;
            AvailabilityAtDate."Period End" := Date;
          end;
        end;

        AvailabilityAtDate."Scheduled Receipt" += ScheduledReceipt;
        AvailabilityAtDate."Gross Requirement" += GrossRequirement;

        if RecordExists then
          AvailabilityAtDate.Modify
        else
          AvailabilityAtDate.Insert;

        OldRecordExists := true;
    end;

    local procedure CalculateAvailabilityByPeriod(var AvailabilityAtDate: Record "Availability at Date";PeriodType: Option Day,Week,Month,Quarter,Year)
    var
        AvailabilityInPeriod: Record "Availability at Date";
        Date: Record Date;
    begin
        if PeriodType = Periodtype::Day then
          exit;

        if AvailabilityAtDate.FindSet then
          repeat
            Date.SetRange("Period Type",PeriodType);
            Date."Period Type" := PeriodType;
            Date."Period Start" := AvailabilityAtDate."Period Start";
            if Date.Find('=<') then begin
              AvailabilityAtDate.SetRange("Period Start",Date."Period Start",Date."Period End");
              AvailabilityInPeriod.Init;
              AvailabilityInPeriod."Period Start" := Date."Period Start";
              AvailabilityInPeriod."Period End" := NormalDate(Date."Period End");
              repeat
                AvailabilityInPeriod."Scheduled Receipt" += AvailabilityAtDate."Scheduled Receipt";
                AvailabilityInPeriod."Gross Requirement" += AvailabilityAtDate."Gross Requirement";
                AvailabilityAtDate.Delete;
              until AvailabilityAtDate.Next = 0;
              AvailabilityAtDate.SetRange("Period Start");
              AvailabilityAtDate := AvailabilityInPeriod;
              AvailabilityAtDate.Insert;
            end;
          until AvailabilityAtDate.Next = 0;
    end;


    procedure AdjustedEndingDate(PeriodEnd: Date;PeriodType: Option Day,Week,Month,Quarter,Year): Date
    var
        Date: Record Date;
    begin
        if PeriodType = Periodtype::Day then
          exit(PeriodEnd);

        Date.SetRange("Period Type",PeriodType);
        Date.SetRange("Period Start",0D,PeriodEnd);
        Date.FindLast;
        exit(NormalDate(Date."Period End"));
    end;


    procedure SetPromisingReqShipDate(OrderPromisingLine: Record "Order Promising Line")
    begin
        ReqShipDate := OrderPromisingLine."Requested Shipment Date";
    end;

    local procedure CalcReqShipDate(SalesLine: Record "Sales Line"): Date
    begin
        if SalesLine."Requested Delivery Date" = 0D then
          exit(SalesLine."Shipment Date");

        SalesLine."Planned Delivery Date" := SalesLine."Requested Delivery Date";
        if Format(SalesLine."Shipping Time") <> '' then
          SalesLine."Planned Shipment Date" := SalesLine.CalcPlannedDeliveryDate(SalesLine.FieldNo("Planned Delivery Date"))
        else
          SalesLine."Planned Shipment Date" := SalesLine.CalcPlannedShptDate(SalesLine.FieldNo("Planned Delivery Date"));
        exit(SalesLine.CalcShipmentDate);
    end;

    local procedure UpdateSchedRcptAvail(var AvailabilityAtDate: Record "Availability at Date";var Item: Record Item)
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
        with ProdOrderLine do
          if FindLinesWithItemToPlan(Item,true) then
            repeat
              CalcFields("Reserved Qty. (Base)");
              UpdateScheduledReceipt(AvailabilityAtDate,"Due Date","Remaining Qty. (Base)" - "Reserved Qty. (Base)");
            until Next = 0;
    end;

    local procedure UpdatePurchReqRcptAvail(var AvailabilityAtDate: Record "Availability at Date";var Item: Record Item)
    var
        ReqLine: Record "Requisition Line";
    begin
        with ReqLine do begin
          if FindLinesWithItemToPlan(Item) then
            repeat
              CalcFields("Reserved Qty. (Base)");
              UpdateScheduledReceipt(AvailabilityAtDate,"Due Date","Quantity (Base)" - "Reserved Qty. (Base)");
            until Next = 0;
        end;
    end;

    local procedure UpdatePurchOrderAvail(var AvailabilityAtDate: Record "Availability at Date";var Item: Record Item)
    var
        PurchLine: Record "Purchase Line";
    begin
        with PurchLine do begin
          if FindLinesWithItemToPlan(Item,"document type"::Order) then
            repeat
              CalcFields("Reserved Qty. (Base)");
              UpdateScheduledReceipt(AvailabilityAtDate,"Expected Receipt Date","Outstanding Qty. (Base)" - "Reserved Qty. (Base)");
            until Next = 0;

          if FindLinesWithItemToPlan(Item,"document type"::"Return Order") then
            repeat
              CalcFields("Reserved Qty. (Base)");
              UpdateGrossRequirement(AvailabilityAtDate,"Expected Receipt Date","Outstanding Qty. (Base)" - "Reserved Qty. (Base)")
            until Next = 0;
        end;
    end;

    local procedure UpdateTransOrderRcptAvail(var AvailabilityAtDate: Record "Availability at Date";var Item: Record Item)
    var
        TransLine: Record "Transfer Line";
    begin
        with TransLine do
          if FindLinesWithItemToPlan(Item,true,false) then
            repeat
              CalcFields("Reserved Qty. Inbnd. (Base)");
              UpdateScheduledReceipt(AvailabilityAtDate,"Receipt Date",
                "Outstanding Qty. (Base)" + "Qty. Shipped (Base)" - "Qty. Received (Base)" - "Reserved Qty. Inbnd. (Base)");
            until Next = 0;
    end;

    local procedure UpdateSchedNeedAvail(var AvailabilityAtDate: Record "Availability at Date";var Item: Record Item)
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        with ProdOrderComp do
          if FindLinesWithItemToPlan(Item,true) then
            repeat
              CalcFields("Reserved Qty. (Base)");
              UpdateGrossRequirement(AvailabilityAtDate,"Due Date","Remaining Qty. (Base)" - "Reserved Qty. (Base)");
            until Next = 0;
    end;

    local procedure UpdatePlanningIssuesAvail(var AvailabilityAtDate: Record "Availability at Date";var Item: Record Item)
    var
        PlanningComp: Record "Planning Component";
    begin
        with PlanningComp do
          if FindLinesWithItemToPlan(Item) then
            repeat
              CalcFields("Reserved Qty. (Base)");
              UpdateGrossRequirement(AvailabilityAtDate,"Due Date","Expected Quantity (Base)" - "Reserved Qty. (Base)");
            until Next = 0;
    end;

    local procedure UpdateSalesOrderAvail(var AvailabilityAtDate: Record "Availability at Date";var Item: Record Item)
    var
        SalesLine: Record "Sales Line";
    begin
        with SalesLine do begin
          if FindLinesWithItemToPlan(Item,"document type"::Order) then
            repeat
              if (ReqShipDate = 0D) or (CalcReqShipDate(SalesLine) <= ReqShipDate) then begin
                CalcFields("Reserved Qty. (Base)");
                UpdateGrossRequirement(AvailabilityAtDate,"Shipment Date","Outstanding Qty. (Base)" - "Reserved Qty. (Base)")
              end
            until Next = 0;

          if FindLinesWithItemToPlan(Item,"document type"::"Return Order") then
            repeat
              CalcFields("Reserved Qty. (Base)");
              UpdateScheduledReceipt(AvailabilityAtDate,"Shipment Date","Outstanding Qty. (Base)" - "Reserved Qty. (Base)")
            until Next = 0;
        end;
    end;

    local procedure UpdateServOrderAvail(var AvailabilityAtDate: Record "Availability at Date";var Item: Record Item)
    var
        ServLine: Record "Service Line";
    begin
        with ServLine do
          if FindLinesWithItemToPlan(Item) then
            repeat
              CalcFields("Reserved Qty. (Base)");
              UpdateGrossRequirement(AvailabilityAtDate,"Needed by Date","Outstanding Qty. (Base)" - "Reserved Qty. (Base)");
            until Next = 0;
    end;

    local procedure UpdateJobOrderAvail(var AvailabilityAtDate: Record "Availability at Date";var Item: Record Item)
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        with JobPlanningLine do
          if FindLinesWithItemToPlan(Item) then
            repeat
              CalcFields("Reserved Qty. (Base)");
              UpdateGrossRequirement(AvailabilityAtDate,"Planning Date","Remaining Qty. (Base)" - "Reserved Qty. (Base)");
            until Next = 0;
    end;

    local procedure UpdateTransOrderShptAvail(var AvailabilityAtDate: Record "Availability at Date";var Item: Record Item)
    var
        TransLine: Record "Transfer Line";
    begin
        with TransLine do
          if FindLinesWithItemToPlan(Item,false,false) then
            repeat
              CalcFields("Reserved Qty. Outbnd. (Base)");
              UpdateGrossRequirement(AvailabilityAtDate,"Shipment Date","Outstanding Qty. (Base)" - "Reserved Qty. Outbnd. (Base)");
            until Next = 0;
    end;

    local procedure UpdateAsmOrderAvail(var AvailabilityAtDate: Record "Availability at Date";var Item: Record Item)
    var
        AsmHeader: Record "Assembly Header";
    begin
        with AsmHeader do
          if FindLinesWithItemToPlan(Item,"document type"::Order) then
            repeat
              CalcFields("Reserved Qty. (Base)");
              UpdateScheduledReceipt(AvailabilityAtDate,"Due Date","Remaining Quantity (Base)" - "Reserved Qty. (Base)");
            until Next = 0;
    end;

    local procedure UpdateAsmCompAvail(var AvailabilityAtDate: Record "Availability at Date";var Item: Record Item)
    var
        AsmLine: Record "Assembly Line";
    begin
        with AsmLine do
          if FindLinesWithItemToPlan(Item,"document type"::Order) then
            repeat
              CalcFields("Reserved Qty. (Base)");
              UpdateGrossRequirement(AvailabilityAtDate,"Due Date","Remaining Quantity (Base)" - "Reserved Qty. (Base)");
            until Next = 0;
    end;
}

