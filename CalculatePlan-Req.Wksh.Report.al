#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 699 "Calculate Plan - Req. Wksh."
{
    Caption = 'Calculate Plan - Req. Wksh.';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("Low-Level Code") where(Type=const(Inventory));
            RequestFilterFields = "No.","Search Description","Location Filter";
            column(ReportForNavId_8129; 8129)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Counter MOD 5 = 0 then
                  Window.Update(1,"No.");
                Counter := Counter + 1;

                if SkipPlanningForItemOnReqWksh(Item) then
                  CurrReport.Skip;

                PlanningAssignment.SetRange("Item No.","No.");

                ReqLine.LockTable;
                ActionMessageEntry.LockTable;

                PurchReqLine.SetRange("No.","No.");
                PurchReqLine.ModifyAll("Accept Action Message",false);
                PurchReqLine.DeleteAll(true);

                ReqLineExtern.SetRange(Type,ReqLine.Type::Item);
                ReqLineExtern.SetRange("No.","No.");
                if ReqLineExtern.Find('-') then
                  repeat
                    ReqLineExtern.Delete(true);
                  until ReqLineExtern.Next = 0;

                InvtProfileOffsetting.SetParm(UseForecast,ExcludeForecastBefore,CurrWorksheetType);
                InvtProfileOffsetting.CalculatePlanFromWorksheet(
                  Item,
                  MfgSetup,
                  CurrTemplateName,
                  CurrWorksheetName,
                  FromDate,
                  ToDate,
                  true,
                  RespectPlanningParm);

                if PlanningAssignment.Find('-') then
                  repeat
                    if PlanningAssignment."Latest Date" <= ToDate then begin
                      PlanningAssignment.Inactive := true;
                      PlanningAssignment.Modify;
                    end;
                  until PlanningAssignment.Next = 0;

                Commit;
            end;

            trigger OnPreDataItem()
            begin
                SKU.SetCurrentkey("Item No.");
                Copyfilter("Variant Filter",SKU."Variant Code");
                Copyfilter("Location Filter",SKU."Location Code");

                Copyfilter("Variant Filter",PlanningAssignment."Variant Code");
                Copyfilter("Location Filter",PlanningAssignment."Location Code");
                PlanningAssignment.SetRange(Inactive,false);
                PlanningAssignment.SetRange("Net Change Planning",true);

                ReqLineExtern.SetCurrentkey(Type,"No.","Variant Code","Location Code");
                Copyfilter("Variant Filter",ReqLineExtern."Variant Code");
                Copyfilter("Location Filter",ReqLineExtern."Location Code");

                PurchReqLine.SetCurrentkey(
                  Type,"No.","Variant Code","Location Code","Sales Order No.","Planning Line Origin","Due Date");
                PurchReqLine.SetRange(Type,PurchReqLine.Type::Item);
                Copyfilter("Variant Filter",PurchReqLine."Variant Code");
                Copyfilter("Location Filter",PurchReqLine."Location Code");
                PurchReqLine.SetFilter("Worksheet Template Name",ReqWkshTemplateFilter);
                PurchReqLine.SetFilter("Journal Batch Name",ReqWkshFilter);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate;FromDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date';
                    }
                    field(EndingDate;ToDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ending Date';
                    }
                    field(UseForecast;UseForecast)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Use Forecast';
                        TableRelation = "Production Forecast Name".Name;
                    }
                    field(ExcludeForecastBefore;ExcludeForecastBefore)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Exclude Forecast Before';
                    }
                    field(RespectPlanningParm;RespectPlanningParm)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Respect Planning Parameters for Supply Triggered by Safety Stock';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            MfgSetup.Get;
            UseForecast := MfgSetup."Current Production Forecast";
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        ProductionForecastEntry: Record "Production Forecast Entry";
    begin
        Counter := 0;
        if FromDate = 0D then
          Error(Text002);
        if ToDate = 0D then
          Error(Text003);
        PeriodLength := ToDate - FromDate + 1;
        if PeriodLength <= 0 then
          Error(Text004);

        if (Item.GetFilter("Variant Filter") <> '') and
           (MfgSetup."Current Production Forecast" <> '')
        then begin
          ProductionForecastEntry.SetRange("Production Forecast Name",MfgSetup."Current Production Forecast");
          Item.Copyfilter("No.",ProductionForecastEntry."Item No.");
          if MfgSetup."Use Forecast on Locations" then
            Item.Copyfilter("Location Filter",ProductionForecastEntry."Location Code");
          if not ProductionForecastEntry.IsEmpty then
            Error(Text005);
        end;

        ReqLine.SetRange("Worksheet Template Name",CurrTemplateName);
        ReqLine.SetRange("Journal Batch Name",CurrWorksheetName);

        Window.Open(
          Text006 +
          Text007);
    end;

    var
        Text002: label 'Enter a starting date.';
        Text003: label 'Enter an ending date.';
        Text004: label 'The ending date must not be before the order date.';
        Text005: label 'You must not use a variant filter when calculating MPS from a forecast.';
        Text006: label 'Calculating the plan...\\';
        Text007: label 'Item No.  #1##################';
        ReqLine: Record "Requisition Line";
        ActionMessageEntry: Record "Action Message Entry";
        ReqLineExtern: Record "Requisition Line";
        PurchReqLine: Record "Requisition Line";
        SKU: Record "Stockkeeping Unit";
        PlanningAssignment: Record "Planning Assignment";
        MfgSetup: Record "Manufacturing Setup";
        InvtProfileOffsetting: Codeunit "Inventory Profile Offsetting";
        Window: Dialog;
        CurrWorksheetType: Option Requisition,Planning;
        PeriodLength: Integer;
        CurrTemplateName: Code[10];
        CurrWorksheetName: Code[10];
        FromDate: Date;
        ToDate: Date;
        ReqWkshTemplateFilter: Code[50];
        ReqWkshFilter: Code[50];
        Counter: Integer;
        UseForecast: Code[10];
        ExcludeForecastBefore: Date;
        RespectPlanningParm: Boolean;


    procedure SetTemplAndWorksheet(TemplateName: Code[10];WorksheetName: Code[10])
    begin
        CurrTemplateName := TemplateName;
        CurrWorksheetName := WorksheetName;
    end;


    procedure InitializeRequest(StartDate: Date;EndDate: Date)
    begin
        FromDate := StartDate;
        ToDate := EndDate;
    end;

    local procedure SkipPlanningForItemOnReqWksh(Item: Record Item): Boolean
    begin
        with Item do
          if (CurrWorksheetType = Currworksheettype::Requisition) and
             ("Replenishment System" = "replenishment system"::Purchase) and
             ("Reordering Policy" <> "reordering policy"::" ")
          then
            exit(false);

        with SKU do begin
          SetRange("Item No.",Item."No.");
          if Find('-') then
            repeat
              if (CurrWorksheetType = Currworksheettype::Requisition) and
                 ("Replenishment System" in ["replenishment system"::Purchase,
                                             "replenishment system"::Transfer]) and
                 ("Reordering Policy" <> "reordering policy"::" ")
              then
                exit(false);
            until Next = 0;
        end;

        exit(true);
    end;
}

