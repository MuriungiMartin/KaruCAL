#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5431 "Calc. Item Plan - Plan Wksh."
{
    TableNo = Item;

    trigger OnRun()
    begin
        Item.Copy(Rec);
        Code;
        Rec := Item;
    end;

    var
        Item: Record Item;
        MfgSetup: Record "Manufacturing Setup";
        TempPlanningCompList: Record "Planning Component" temporary;
        TempItemList: Record Item temporary;
        InvtProfileOffsetting: Codeunit "Inventory Profile Offsetting";
        MPS: Boolean;
        MRP: Boolean;
        NetChange: Boolean;
        PeriodLength: Integer;
        CurrTemplateName: Code[10];
        CurrWorksheetName: Code[10];
        UseForecast: Code[10];
        FromDate: Date;
        ToDate: Date;
        Text000: label 'You must decide what to calculate.';
        Text001: label 'Enter a starting date.';
        Text002: label 'Enter an ending date.';
        Text003: label 'The ending date must not be before the order date.';
        Text004: label 'You must not use a variant filter when calculating MPS from a forecast.';
        ExcludeForecastBefore: Date;
        RespectPlanningParm: Boolean;

    local procedure "Code"()
    var
        ReqLineExtern: Record "Requisition Line";
        PlannedProdOrderLine: Record "Prod. Order Line";
        PlanningAssignment: Record "Planning Assignment";
        ProdOrder: Record "Production Order";
        CurrWorksheetType: Option Requisition,Planning;
    begin
        with Item do begin
          if not PlanThisItem then
            exit;

          ReqLineExtern.SetCurrentkey(Type,"No.","Variant Code","Location Code");
          Copyfilter("Variant Filter",ReqLineExtern."Variant Code");
          Copyfilter("Location Filter",ReqLineExtern."Location Code");
          ReqLineExtern.SetRange(Type,ReqLineExtern.Type::Item);
          ReqLineExtern.SetRange("No.","No.");
          if ReqLineExtern.Find('-') then
            repeat
              ReqLineExtern.Delete(true);
            until ReqLineExtern.Next = 0;

          PlannedProdOrderLine.SetCurrentkey(Status,"Item No.","Variant Code","Location Code");
          PlannedProdOrderLine.SetRange(Status,PlannedProdOrderLine.Status::Planned);
          Copyfilter("Variant Filter",PlannedProdOrderLine."Variant Code");
          Copyfilter("Location Filter",PlannedProdOrderLine."Location Code");
          PlannedProdOrderLine.SetRange("Item No.","No.");
          if PlannedProdOrderLine.Find('-') then
            repeat
              if ProdOrder.Get(PlannedProdOrderLine.Status,PlannedProdOrderLine."Prod. Order No.") then begin
                if (ProdOrder."Source Type" = ProdOrder."source type"::Item) and
                   (ProdOrder."Source No." = PlannedProdOrderLine."Item No.")
                then
                  ProdOrder.Delete(true);
              end else
                PlannedProdOrderLine.Delete(true);
            until PlannedProdOrderLine.Next = 0;

          Commit;

          InvtProfileOffsetting.SetParm(UseForecast,ExcludeForecastBefore,Currworksheettype::Planning);
          InvtProfileOffsetting.CalculatePlanFromWorksheet(
            Item,MfgSetup,CurrTemplateName,CurrWorksheetName,FromDate,ToDate,MRP,RespectPlanningParm);

          // Retrieve list of Planning Components handled:
          InvtProfileOffsetting.GetPlanningCompList(TempPlanningCompList);

          Copyfilter("Variant Filter",PlanningAssignment."Variant Code");
          Copyfilter("Location Filter",PlanningAssignment."Location Code");
          PlanningAssignment.SetRange(Inactive,false);
          PlanningAssignment.SetRange("Net Change Planning",true);
          PlanningAssignment.SetRange("Item No.","No.");
          if PlanningAssignment.Find('-') then
            repeat
              if PlanningAssignment."Latest Date" <= ToDate then begin
                PlanningAssignment.Inactive := true;
                PlanningAssignment.Modify;
              end;
            until PlanningAssignment.Next = 0;

          Commit;

          TempItemList := Item;
          TempItemList.Insert;
        end;
    end;


    procedure Initialize(NewFromDate: Date;NewToDate: Date;NewMPS: Boolean;NewMRP: Boolean;NewRespectPlanningParm: Boolean)
    begin
        FromDate := NewFromDate;
        ToDate := NewToDate;
        MPS := NewMPS;
        MRP := NewMRP;
        RespectPlanningParm := NewRespectPlanningParm;

        MfgSetup.Get;
        CheckPreconditions;
    end;


    procedure Finalize()
    var
        ReservMgt: Codeunit "Reservation Management";
    begin
        // Items already planned for removed from temporary list:
        if TempPlanningCompList.Find('-') then
          repeat
            if TempItemList.Get(TempPlanningCompList."Item No.") then
              TempPlanningCompList.Delete;
          until TempPlanningCompList.Next = 0;

        // Dynamic tracking is run for the remaining Planning Components:
        if TempPlanningCompList.Find('-') then
          repeat
            ReservMgt.SetPlanningComponent(TempPlanningCompList);
            ReservMgt.AutoTrack(TempPlanningCompList."Net Quantity (Base)");
          until TempPlanningCompList.Next = 0;

        Commit;
    end;

    local procedure CheckPreconditions()
    var
        ForecastEntry: Record "Production Forecast Entry";
    begin
        if not MPS and not MRP then
          Error(Text000);

        if FromDate = 0D then
          Error(Text001);
        if ToDate = 0D then
          Error(Text002);
        PeriodLength := ToDate - FromDate + 1;
        if PeriodLength <= 0 then
          Error(Text003);

        if MPS and
           (Item.GetFilter("Variant Filter") <> '') and
           (UseForecast <> '')
        then begin
          ForecastEntry.SetCurrentkey("Production Forecast Name","Item No.","Location Code","Forecast Date","Component Forecast");
          ForecastEntry.SetRange("Production Forecast Name",UseForecast);
          Item.Copyfilter("No.",ForecastEntry."Item No.");
          if MfgSetup."Use Forecast on Locations" then
            Item.Copyfilter("Location Filter",ForecastEntry."Location Code");
          if not ForecastEntry.IsEmpty then
            Error(Text004);
        end;
    end;


    procedure SetTemplAndWorksheet(TemplateName: Code[10];WorksheetName: Code[10];NetChange2: Boolean)
    begin
        CurrTemplateName := TemplateName;
        CurrWorksheetName := WorksheetName;
        NetChange := NetChange2;
    end;

    local procedure PlanThisItem(): Boolean
    var
        SKU: Record "Stockkeeping Unit";
        ForecastEntry: Record "Production Forecast Entry";
        SalesLine: Record "Sales Line";
        ServLine: Record "Service Line";
        PurchaseLine: Record "Purchase Line";
        ProdOrderLine: Record "Prod. Order Line";
        PlanningAssignment: Record "Planning Assignment";
        JobPlanningLine: Record "Job Planning Line";
    begin
        SKU.SetCurrentkey("Item No.");
        Item.Copyfilter("Variant Filter",SKU."Variant Code");
        Item.Copyfilter("Location Filter",SKU."Location Code");
        SKU.SetRange("Item No.",Item."No.");
        if SKU.IsEmpty and (Item."Reordering Policy" = Item."reordering policy"::" ") then
          exit(false);

        Item.Copyfilter("Variant Filter",PlanningAssignment."Variant Code");
        Item.Copyfilter("Location Filter",PlanningAssignment."Location Code");
        PlanningAssignment.SetRange(Inactive,false);
        PlanningAssignment.SetRange("Net Change Planning",true);
        PlanningAssignment.SetRange("Item No.",Item."No.");
        if NetChange and PlanningAssignment.IsEmpty then
          exit(false);

        if MRP = MPS then
          exit(true);

        SalesLine.SetCurrentkey("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Shipment Date");
        SalesLine.SetFilter("Document Type",'%1|%2',SalesLine."document type"::Order,SalesLine."document type"::"Blanket Order");
        SalesLine.SetRange(Type,SalesLine.Type::Item);
        Item.Copyfilter("Variant Filter",SalesLine."Variant Code");
        Item.Copyfilter("Location Filter",SalesLine."Location Code");
        SalesLine.SetRange("No.",Item."No.");
        SalesLine.SetFilter("Outstanding Qty. (Base)",'<>0');
        if not SalesLine.IsEmpty then
          exit(MPS);

        ForecastEntry.SetCurrentkey("Production Forecast Name","Item No.","Location Code","Forecast Date","Component Forecast");
        ForecastEntry.SetRange("Production Forecast Name",UseForecast);
        if MfgSetup."Use Forecast on Locations" then
          Item.Copyfilter("Location Filter",ForecastEntry."Location Code");
        ForecastEntry.SetRange("Item No.",Item."No.");
        if ForecastEntry.FindFirst then begin
          ForecastEntry.CalcSums("Forecast Quantity (Base)");
          if ForecastEntry."Forecast Quantity (Base)" > 0 then
            exit(MPS);
        end;

        if ServLine.LinesWithItemToPlanExist(Item) then
          exit(MPS);

        if JobPlanningLine.LinesWithItemToPlanExist(Item) then
          exit(MPS);

        ProdOrderLine.SetCurrentkey("Item No.");
        ProdOrderLine.SetRange("MPS Order",true);
        ProdOrderLine.SetRange("Item No.",Item."No.");
        if not ProdOrderLine.IsEmpty then
          exit(MPS);

        PurchaseLine.SetCurrentkey("Document Type",Type,"No.");
        PurchaseLine.SetRange("Document Type",PurchaseLine."document type"::Order);
        PurchaseLine.SetRange(Type,PurchaseLine.Type::Item);
        PurchaseLine.SetRange("MPS Order",true);
        PurchaseLine.SetRange("No.",Item."No.");
        if not PurchaseLine.IsEmpty then
          exit(MPS);

        exit(MRP);
    end;


    procedure SetParm(Forecast: Code[10];ExclBefore: Date;var Item2: Record Item)
    begin
        UseForecast := Forecast;
        ExcludeForecastBefore := ExclBefore;
        Item.Copy(Item2);
    end;


    procedure SetResiliencyOn()
    begin
        InvtProfileOffsetting.SetResiliencyOn;
    end;


    procedure GetResiliencyError(var PlanningErrorLogEntry: Record "Planning Error Log"): Boolean
    begin
        exit(InvtProfileOffsetting.GetResiliencyError(PlanningErrorLogEntry));
    end;
}

