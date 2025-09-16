#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 759 "Job Chart Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        XAxisStringTxt: label 'Job';
        Job: Record Job;
        TotalRevenueTxt: label 'Total Revenue';
        TotalCostTxt: label 'Total Cost';
        ProfitMarginTxt: label 'Profit Margin';
        JobCalcStatistics: Codeunit "Job Calculate Statistics";
        CL: array [16] of Decimal;
        PL: array [16] of Decimal;
        ActualTotalCostTxt: label 'Actual Total Cost';
        BudgetTotalCostTxt: label 'Budget Total Cost';
        CostVarianceTxt: label 'Cost Variance';
        ActualTotalPriceTxt: label 'Actual Total Price';
        BudgetTotalPriceTxt: label 'Budget Total Price';
        PriceVarianceTxt: label 'Price Variance';


    procedure CreateJobChart(var BusChartBuf: Record "Business Chart Buffer";var TempJob: Record Job temporary;ChartType: Option Point,,Bubble,Line,,StepLine,,,,,Column,StackedColumn,StackedColumn100,"Area",,StackedArea,StackedArea100,Pie,Doughnut,,,Range,,,,Radar,,,,,,,,Funnel;JobChartType: Option Profitability,"Actual to Budget Cost","Actual to Budget Price")
    begin
        InitializeBusinessChart(BusChartBuf);
        SetJobRangeByMyJob(TempJob);
        if NothingToShow(TempJob) then
          exit;

        AddMeasures(BusChartBuf,ChartType,JobChartType);
        SetXAxis(BusChartBuf);
        SetJobChartValues(BusChartBuf,TempJob,JobChartType);
    end;


    procedure SetJobRangeByMyJob(var TempRangeJob: Record Job temporary)
    var
        MyJob: Record "My Job";
    begin
        TempRangeJob.DeleteAll;

        with MyJob do begin
          SetRange("User ID",UserId);
          SetRange("Exclude from Business Chart",false);
          if FindSet then
            repeat
              if Job.Get("Job No.") then begin
                TempRangeJob := Job;
                TempRangeJob.Insert;
              end;
            until Next = 0;
        end;
    end;


    procedure DataPointClicked(var BusChartBuf: Record "Business Chart Buffer";var RangeJob: Record Job)
    begin
        with BusChartBuf do begin
          FindCurrentJob(BusChartBuf,RangeJob);
          DrillDownJobValue(RangeJob);
        end;
    end;

    local procedure FindCurrentJob(var BusChartBuf: Record "Business Chart Buffer";var RangeJob: Record Job)
    begin
        with RangeJob do begin
          FindSet;
          Next(BusChartBuf."Drill-Down X Index");
        end;
    end;

    local procedure DrillDownJobValue(var RangeJob: Record Job)
    begin
        Page.Run(Page::"Job Card",RangeJob);
    end;

    local procedure NothingToShow(var RangeJob: Record Job): Boolean
    begin
        with RangeJob do
          exit(IsEmpty);
    end;

    local procedure InitializeBusinessChart(var BusChartBuf: Record "Business Chart Buffer")
    begin
        with BusChartBuf do
          Initialize;
    end;

    local procedure AddMeasures(var BusChartBuf: Record "Business Chart Buffer";ChartType: Option Point,,Bubble,Line,,StepLine,,,,,Column,StackedColumn,StackedColumn100,"Area",,StackedArea,StackedArea100,Pie,Doughnut,,,Range,,,,Radar,,,,,,,,Funnel;JobChartType: Option Profitability,"Actual to Budget Cost","Actual to Budget Price")
    begin
        with BusChartBuf do
          case JobChartType of
            Jobcharttype::Profitability:
              begin
                AddMeasure(TotalRevenueTxt,1,"data type"::Decimal,ChartType);
                AddMeasure(TotalCostTxt,2,"data type"::Decimal,ChartType);
                AddMeasure(ProfitMarginTxt,3,"data type"::Decimal,ChartType);
              end;
            Jobcharttype::"Actual to Budget Cost":
              begin
                AddMeasure(ActualTotalCostTxt,1,"data type"::Decimal,ChartType);
                AddMeasure(BudgetTotalCostTxt,2,"data type"::Decimal,ChartType);
                AddMeasure(CostVarianceTxt,3,"data type"::Decimal,ChartType);
              end;
            Jobcharttype::"Actual to Budget Price":
              begin
                AddMeasure(ActualTotalPriceTxt,1,"data type"::Decimal,ChartType);
                AddMeasure(BudgetTotalPriceTxt,2,"data type"::Decimal,ChartType);
                AddMeasure(PriceVarianceTxt,3,"data type"::Decimal,ChartType);
              end;
          end;
    end;

    local procedure SetXAxis(var BusChartBuf: Record "Business Chart Buffer")
    begin
        with BusChartBuf do
          SetXAxis(XAxisStringTxt,"data type"::String);
    end;

    local procedure SetJobChartValues(var BusChartBuf: Record "Business Chart Buffer";var RangeJob: Record Job;JobChartType: Option Profitability,"Actual to Budget Cost","Actual to Budget Price")
    var
        Index: Integer;
        JobRevenue: Decimal;
        JobCost: Decimal;
        ActualCost: Decimal;
        BudgetCost: Decimal;
        ActualPrice: Decimal;
        BudgetPrice: Decimal;
    begin
        with RangeJob do
          if FindSet then
            repeat
              case JobChartType of
                Jobcharttype::Profitability:
                  begin
                    CalculateJobRevenueAndCost(RangeJob,JobRevenue,JobCost);
                    SetJobChartValue(BusChartBuf,RangeJob,Index,JobRevenue,JobCost,JobChartType);
                  end;
                Jobcharttype::"Actual to Budget Cost":
                  begin
                    CalculateJobCosts(RangeJob,ActualCost,BudgetCost);
                    SetJobChartValue(BusChartBuf,RangeJob,Index,ActualCost,BudgetCost,JobChartType);
                  end;
                Jobcharttype::"Actual to Budget Price":
                  begin
                    CalculateJobPrices(RangeJob,ActualPrice,BudgetPrice);
                    SetJobChartValue(BusChartBuf,RangeJob,Index,ActualPrice,BudgetPrice,JobChartType);
                  end;
              end;
            until Next = 0;
    end;

    local procedure SetJobChartValue(var BusChartBuf: Record "Business Chart Buffer";var RangeJob: Record Job;var Index: Integer;Value1: Decimal;Value2: Decimal;JobChartType: Option Profitability,"Actual to Budget Cost","Actual to Budget Price")
    begin
        with BusChartBuf do begin
          AddColumn(RangeJob."No.");
          SetValueByIndex(0,Index,Value1);
          SetValueByIndex(1,Index,Value2);
          if JobChartType = Jobcharttype::Profitability then
            SetValueByIndex(2,Index,(Value1 - Value2));
          if (JobChartType = Jobcharttype::"Actual to Budget Cost") or (JobChartType = Jobcharttype::"Actual to Budget Price") then
            SetValueByIndex(2,Index,(Value2 - Value1));
          Index += 1;
        end;
    end;

    local procedure CalculateJobRevenueAndCost(var RangeJob: Record Job;var JobRevenue: Decimal;var JobCost: Decimal)
    begin
        Clear(JobCalcStatistics);
        JobCalcStatistics.JobCalculateCommonFilters(RangeJob);
        JobCalcStatistics.CalculateAmounts;
        JobCalcStatistics.GetLCYCostAmounts(CL);
        JobCalcStatistics.GetLCYPriceAmounts(PL);
        JobRevenue := PL[16];
        JobCost := CL[8];
    end;

    local procedure CalculateJobCosts(var RangeJob: Record Job;var ActualCost: Decimal;var BudgetCost: Decimal)
    begin
        Clear(JobCalcStatistics);
        JobCalcStatistics.JobCalculateCommonFilters(RangeJob);
        JobCalcStatistics.CalculateAmounts;
        JobCalcStatistics.GetLCYCostAmounts(CL);
        JobCalcStatistics.GetLCYPriceAmounts(PL);
        ActualCost := CL[8];
        BudgetCost := CL[4];
    end;

    local procedure CalculateJobPrices(var RangeJob: Record Job;var ActualPrice: Decimal;var BudgetPrice: Decimal)
    begin
        Clear(JobCalcStatistics);
        JobCalcStatistics.JobCalculateCommonFilters(RangeJob);
        JobCalcStatistics.CalculateAmounts;
        JobCalcStatistics.GetLCYCostAmounts(CL);
        JobCalcStatistics.GetLCYPriceAmounts(PL);
        ActualPrice := PL[16];
        BudgetPrice := PL[4];
    end;
}

