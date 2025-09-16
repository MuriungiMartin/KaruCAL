#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1315 "Chart Management"
{

    trigger OnRun()
    begin
    end;

    var
        AccountSchedulesChartSetup: Record "Account Schedules Chart Setup";
        TempEntryNoAmountBuf: Record "Entry No. Amount Buffer" temporary;
        SalesByCustGrpChartSetup: Record "Sales by Cust. Grp.Chart Setup";
        AccSchedChartManagement: Codeunit "Acc. Sched. Chart Management";
        TopTenCustomersChartMgt: Codeunit "Top Ten Customers Chart Mgt.";
        TopFiveCustomersChartMgt: Codeunit "Top Five Customers Chart Mgt.";
        AgedInventoryChartMgt: Codeunit "Aged Inventory Chart Mgt.";
        SalesByCustGrpChartMgt: Codeunit "Sales by Cust. Grp. Chart Mgt.";
        AgedAccReceivable: Codeunit "Aged Acc. Receivable";
        AgedAccPayable: Codeunit "Aged Acc. Payable";
        Period: Option " ",Next,Previous;
        MediumStatusTxt: label '%1 | View by %2', Comment='%1 Account Schedule Chart Setup Name, %2 Period Length, %3 Current time';
        LongStatusTxt: label '%1 | %2..%3 | %4', Comment='%1 Account Schedule Chart Setup Name, %2 = Start Date, %3 = End Date, %4 Period Length, %5 Current time';
        TopTenCustomerChartNameTxt: label 'Top Ten Customers by Sales Value';
        TopFiveCustomerChartNameTxt: label 'Top Five Customers by Sales Value';
        AgedInventoryChartNameTxt: label 'Aged Inventory';
        SalesByCustomerGroupNameTxt: label 'Sales Trends by Customer Groups';
        SalesByCustomerGroupDescriptionTxt: label 'This chart shows sales trends by customer group in the selected period.';
        TopTenCustomersChartDescriptionTxt: label 'This chart shows the ten customers with the highest total sales value. The last column shows the sum of sales values of all other customers.';
        TopFiveCustomersChartDescriptionTxt: label 'This Pie chart shows the five customers with the highest total sales value.';
        AgedInventoryChartDescriptionTxt: label 'This chart shows the total inventory value, grouped by the number of days that the items are on inventory.';
        AgedAccReceivableNameTxt: label 'Aged Accounts Receivable';
        AgedAccPayableNameTxt: label 'Aged Accounts Payable';
        XCashFlowChartNameTxt: label 'Cash Flow';
        XIncomeAndExpenseChartNameTxt: label 'Income & Expense';
        XCashCycleChartNameTxt: label 'Cash Cycle';
        NoEnabledChartsFoundErr: label 'There are no enabled charts. Choose Select Chart to see a list of charts that you can display.';
        ChartDefinitionMissingErr: label 'There are no charts defined.';


    procedure AddinReady(var ChartDefinition: Record "Chart Definition";var BusinessChartBuffer: Record "Business Chart Buffer")
    var
        LastUsedChart: Record "Last Used Chart";
        LastChartRecorded: Boolean;
        LastChartExists: Boolean;
        LastChartEnabled: Boolean;
    begin
        LastChartRecorded := LastUsedChart.Get(UserId);
        LastChartExists :=
          LastChartRecorded and ChartDefinition.Get(LastUsedChart."Code Unit ID",LastUsedChart."Chart Name");
        LastChartEnabled := LastChartExists and ChartDefinition.Enabled;
        if ChartDefinition.IsEmpty then
          exit;
        if not LastChartEnabled then begin
          ChartDefinition.SetRange(Enabled,true);
          if not ChartDefinition.FindLast then
            Dialog.Error(NoEnabledChartsFoundErr);
        end;
        SetDefaultPeriodLength(ChartDefinition,BusinessChartBuffer);
        UpdateChart(ChartDefinition,BusinessChartBuffer,Period::" ");
    end;


    procedure ChartDescription(ChartDefinition: Record "Chart Definition"): Text
    begin
        case ChartDefinition."Code Unit ID" of
          Codeunit::"Acc. Sched. Chart Management":
            exit(AccountSchedulesChartSetup.Description);
          Codeunit::"Top Ten Customers Chart Mgt.":
            exit(TopTenCustomersChartDescriptionTxt);
          Codeunit::"Aged Inventory Chart Mgt.":
            exit(AgedInventoryChartDescriptionTxt);
          Codeunit::"Sales by Cust. Grp. Chart Mgt.":
            exit(SalesByCustomerGroupDescriptionTxt);
          Codeunit::"Aged Acc. Receivable":
            exit(AgedAccReceivable.Description(false));
          Codeunit::"Aged Acc. Payable":
            exit(AgedAccPayable.Description(false));
          Codeunit::"Top Five Customers Chart Mgt.":
            exit(TopFiveCustomersChartDescriptionTxt);
        end;
    end;


    procedure CashFlowChartName(): Text[30]
    begin
        exit(XCashFlowChartNameTxt)
    end;


    procedure CashCycleChartName(): Text[30]
    begin
        exit(XCashCycleChartNameTxt)
    end;


    procedure IncomeAndExpenseChartName(): Text[30]
    begin
        exit(XIncomeAndExpenseChartNameTxt)
    end;


    procedure DataPointClicked(var BusinessChartBuffer: Record "Business Chart Buffer";var ChartDefinition: Record "Chart Definition")
    begin
        case ChartDefinition."Code Unit ID" of
          Codeunit::"Acc. Sched. Chart Management":
            AccSchedChartManagement.DrillDown(BusinessChartBuffer,AccountSchedulesChartSetup);
          Codeunit::"Top Ten Customers Chart Mgt.":
            TopTenCustomersChartMgt.DrillDown(BusinessChartBuffer);
          Codeunit::"Top Five Customers Chart Mgt.":
            TopFiveCustomersChartMgt.DrillDown(BusinessChartBuffer);
          Codeunit::"Aged Inventory Chart Mgt.":
            AgedInventoryChartMgt.DrillDown(BusinessChartBuffer);
          Codeunit::"Sales by Cust. Grp. Chart Mgt.":
            SalesByCustGrpChartMgt.DrillDown(BusinessChartBuffer);
          Codeunit::"Aged Acc. Receivable":
            AgedAccReceivable.DrillDownByGroup(BusinessChartBuffer,TempEntryNoAmountBuf);
          Codeunit::"Aged Acc. Payable":
            AgedAccPayable.DrillDownByGroup(BusinessChartBuffer,TempEntryNoAmountBuf);
        end;
    end;


    procedure PopulateChartDefinitionTable()
    begin
        InsertChartDefinition(Codeunit::"Top Five Customers Chart Mgt.",TopFiveCustomerChartNameTxt);
        InsertChartDefinition(Codeunit::"Top Ten Customers Chart Mgt.",TopTenCustomerChartNameTxt);
        InsertChartDefinition(Codeunit::"Aged Inventory Chart Mgt.",AgedInventoryChartNameTxt);
        InsertChartDefinition(Codeunit::"Sales by Cust. Grp. Chart Mgt.",SalesByCustomerGroupNameTxt);
        InsertChartDefinition(Codeunit::"Aged Acc. Receivable",AgedAccReceivableNameTxt);
        InsertChartDefinition(Codeunit::"Aged Acc. Payable",AgedAccPayableNameTxt);
        InsertChartDefinition(Codeunit::"Acc. Sched. Chart Management",XCashFlowChartNameTxt);
        InsertChartDefinition(Codeunit::"Acc. Sched. Chart Management",XIncomeAndExpenseChartNameTxt);
        InsertChartDefinition(Codeunit::"Acc. Sched. Chart Management",XCashCycleChartNameTxt);
    end;


    procedure SelectChart(var BusinessChartBuffer: Record "Business Chart Buffer";var ChartDefinition: Record "Chart Definition")
    var
        ChartList: Page "Chart List";
    begin
        if ChartDefinition.IsEmpty then
          if ChartDefinition.WritePermission then begin
            PopulateChartDefinitionTable;
            Commit;
          end else
            Error(ChartDefinitionMissingErr);
        ChartList.LookupMode(true);

        if ChartList.RunModal = Action::LookupOK then begin
          ChartList.GetRecord(ChartDefinition);
          SetDefaultPeriodLength(ChartDefinition,BusinessChartBuffer);
          UpdateChart(ChartDefinition,BusinessChartBuffer,Period::" ");
        end;
    end;


    procedure SetDefaultPeriodLength(ChartDefinition: Record "Chart Definition";var BusChartBuf: Record "Business Chart Buffer")
    var
        BusChartUserSetup: Record "Business Chart User Setup";
    begin
        case ChartDefinition."Code Unit ID" of
          Codeunit::"Aged Inventory Chart Mgt.":
            SetPeriodLength(ChartDefinition,BusChartBuf,BusChartBuf."period length"::Month,true);
          Codeunit::"Aged Acc. Receivable":
            begin
              BusChartUserSetup.InitSetupCU(Codeunit::"Aged Acc. Receivable");
              SetPeriodLength(ChartDefinition,BusChartBuf,BusChartUserSetup."Period Length",true);
            end;
          Codeunit::"Aged Acc. Payable":
            begin
              BusChartUserSetup.InitSetupCU(Codeunit::"Aged Acc. Payable");
              SetPeriodLength(ChartDefinition,BusChartBuf,BusChartUserSetup."Period Length",true);
            end;
          Codeunit::"Acc. Sched. Chart Management":
            begin
              AccountSchedulesChartSetup.Get('',ChartDefinition."Chart Name");
              SetPeriodLength(ChartDefinition,BusChartBuf,AccountSchedulesChartSetup."Period Length",true);
            end;
        end;
    end;


    procedure SetPeriodLength(ChartDefinition: Record "Chart Definition";var BusChartBuf: Record "Business Chart Buffer";PeriodLength: Option;IsInitState: Boolean)
    var
        NewStartDate: Date;
    begin
        case ChartDefinition."Code Unit ID" of
          Codeunit::"Acc. Sched. Chart Management":
            begin
              AccountSchedulesChartSetup.Get('',ChartDefinition."Chart Name");
              AccountSchedulesChartSetup.SetPeriodLength(PeriodLength);
              BusChartBuf."Period Length" := PeriodLength;
              if AccountSchedulesChartSetup."Look Ahead" then
                NewStartDate := GetBaseDate(BusChartBuf,IsInitState)
              else
                NewStartDate :=
                  CalcDate(
                    StrSubstNo(
                      '<-%1%2>',AccountSchedulesChartSetup."No. of Periods",BusChartBuf.GetPeriodLength),
                    GetBaseDate(BusChartBuf,IsInitState));
              if AccountSchedulesChartSetup."Start Date" <> NewStartDate then begin
                AccountSchedulesChartSetup.Validate("Start Date",NewStartDate);
                AccountSchedulesChartSetup.Modify(true);
              end;
            end;
          Codeunit::"Sales by Cust. Grp. Chart Mgt.":
            SalesByCustGrpChartSetup.SetPeriodLength(PeriodLength);
          else
            BusChartBuf."Period Length" := PeriodLength;
        end;
    end;


    procedure UpdateChart(var ChartDefinition: Record "Chart Definition";var BusinessChartBuffer: Record "Business Chart Buffer";Period: Option)
    begin
        case ChartDefinition."Code Unit ID" of
          Codeunit::"Acc. Sched. Chart Management":
            begin
              AccSchedChartManagement.GetSetupRecordset(AccountSchedulesChartSetup,ChartDefinition."Chart Name",0);
              AccSchedChartManagement.UpdateData(BusinessChartBuffer,Period,AccountSchedulesChartSetup);
            end;
          Codeunit::"Aged Inventory Chart Mgt.":
            AgedInventoryChartMgt.UpdateChart(BusinessChartBuffer);
          Codeunit::"Sales by Cust. Grp. Chart Mgt.":
            begin
              SalesByCustGrpChartSetup.SetPeriod(Period);
              SalesByCustGrpChartMgt.UpdateChart(BusinessChartBuffer);
            end;
          Codeunit::"Aged Acc. Receivable":
            begin
              BusinessChartBuffer."Period Filter Start Date" := WorkDate;
              AgedAccReceivable.UpdateDataPerGroup(BusinessChartBuffer,TempEntryNoAmountBuf);
              AgedAccReceivable.SaveSettings(BusinessChartBuffer);
            end;
          Codeunit::"Aged Acc. Payable":
            begin
              BusinessChartBuffer."Period Filter Start Date" := WorkDate;
              AgedAccPayable.UpdateData(BusinessChartBuffer,TempEntryNoAmountBuf);
              AgedAccPayable.SaveSettings(BusinessChartBuffer)
            end;
          Codeunit::"Top Five Customers Chart Mgt.":
            TopFiveCustomersChartMgt.UpdateChart(BusinessChartBuffer);
          else
            TopTenCustomersChartMgt.UpdateChart(BusinessChartBuffer);
        end;
        UpdateLastUsedChart(ChartDefinition);
    end;


    procedure UpdateNextPrevious(var ChartDefinition: Record "Chart Definition"): Boolean
    begin
        exit(ChartDefinition."Code Unit ID" in
          [Codeunit::"Acc. Sched. Chart Management",
           Codeunit::"Sales by Cust. Grp. Chart Mgt."]);
    end;


    procedure UpdateStatusText(var ChartDefinition: Record "Chart Definition";var BusinessChartBuffer: Record "Business Chart Buffer";var StatusText: Text)
    var
        StartDate: Date;
        EndDate: Date;
    begin
        StartDate := BusinessChartBuffer."Period Filter Start Date";
        EndDate := BusinessChartBuffer."Period Filter End Date";
        case ChartDefinition."Code Unit ID" of
          Codeunit::"Acc. Sched. Chart Management":
            with AccountSchedulesChartSetup do
              case "Base X-Axis on" of
                "base x-axis on"::Period:
                  StatusText := StrSubstNo(MediumStatusTxt,ChartDefinition."Chart Name","Period Length");
                "base x-axis on"::"Acc. Sched. Line",
                "base x-axis on"::"Acc. Sched. Column":
                  StatusText := StrSubstNo(LongStatusTxt,ChartDefinition."Chart Name",StartDate,EndDate,"Period Length");
              end;
          Codeunit::"Sales by Cust. Grp. Chart Mgt.",
          Codeunit::"Aged Acc. Receivable",
          Codeunit::"Aged Acc. Payable",
          Codeunit::"Aged Inventory Chart Mgt.":
            StatusText := StrSubstNo(MediumStatusTxt,ChartDefinition."Chart Name",BusinessChartBuffer."Period Length");
          else
            StatusText := ChartDefinition."Chart Name";
        end;
    end;

    local procedure UpdateLastUsedChart(ChartDefinition: Record "Chart Definition")
    var
        LastUsedChart: Record "Last Used Chart";
    begin
        with LastUsedChart do
          if Get(UserId) then begin
            Validate("Code Unit ID",ChartDefinition."Code Unit ID");
            Validate("Chart Name",ChartDefinition."Chart Name");
            Modify;
          end else begin
            Validate(UID,UserId);
            Validate("Code Unit ID",ChartDefinition."Code Unit ID");
            Validate("Chart Name",ChartDefinition."Chart Name");
            Insert;
          end;
    end;

    local procedure InsertChartDefinition(ChartCodeunitId: Integer;ChartName: Text[60])
    var
        ChartDefinition: Record "Chart Definition";
    begin
        if not ChartDefinition.Get(ChartCodeunitId,ChartName) then begin
          ChartDefinition."Code Unit ID" := ChartCodeunitId;
          ChartDefinition."Chart Name" := ChartName;
          ChartDefinition.Enabled := true;
          ChartDefinition.Insert;
        end;
    end;

    local procedure GetPeriodLength(): Text[1]
    begin
        case AccountSchedulesChartSetup."Period Length" of
          AccountSchedulesChartSetup."period length"::Day:
            exit('D');
          AccountSchedulesChartSetup."period length"::Week:
            exit('W');
          AccountSchedulesChartSetup."period length"::Month:
            exit('M');
          AccountSchedulesChartSetup."period length"::Quarter:
            exit('Q');
          AccountSchedulesChartSetup."period length"::Year:
            exit('Y');
        end;
    end;

    local procedure GetBaseDate(var BusChartBuf: Record "Business Chart Buffer";IsInitState: Boolean): Date
    var
        ColumnIndex: Integer;
        StartDate: Date;
        EndDate: Date;
    begin
        if AccountSchedulesChartSetup."Look Ahead" then
          ColumnIndex := 0
        else
          ColumnIndex := AccountSchedulesChartSetup."No. of Periods" - 1;

        if IsInitState then
          exit(WorkDate);

        BusChartBuf.GetPeriodFromMapColumn(ColumnIndex,StartDate,EndDate);

        if AccountSchedulesChartSetup."Look Ahead" then
          exit(StartDate);

        exit(CalcDate(StrSubstNo('<1%1>',GetPeriodLength),EndDate));
    end;
}

