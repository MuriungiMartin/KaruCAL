#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 730 "Job Act to Bud Cost Chart"
{
    Caption = 'Job Act to Bud Cost Chart';
    PageType = CardPart;
    SourceTable = Job;

    layout
    {
        area(content)
        {
            usercontrol(Chart;"Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = Jobs;

                trigger DataPointClicked(point: dotnet BusinessChartDataPoint)
                begin
                    BusChartBuf.SetDrillDownIndexes(point);
                    JobChartMgt.DataPointClicked(BusChartBuf,TempJob);
                end;

                trigger DataPointDoubleClicked(point: dotnet BusinessChartDataPoint)
                begin
                end;

                trigger AddInReady()
                begin
                    ChartIsReady := true;
                    UpdateChart(DefaultChartType);
                end;

                trigger Refresh()
                begin
                    if ChartIsReady then
                      UpdateChart(CurrentChartType);
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Options)
            {
                Caption = 'Options';
                group("Chart Type")
                {
                    Caption = 'Chart Type';
                    action(Default)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Default';
                        ToolTip = 'Select the default graphing option for this chart.';

                        trigger OnAction()
                        begin
                            UpdateChart(DefaultChartType);
                        end;
                    }
                    action(Column)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column';
                        ToolTip = 'Select the column graphing option for this chart.';

                        trigger OnAction()
                        begin
                            UpdateChart(Charttype::Column);
                        end;
                    }
                    action(Line)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Line';
                        ToolTip = 'Select the line graphing option for this chart.';

                        trigger OnAction()
                        begin
                            UpdateChart(Charttype::Line);
                        end;
                    }
                    action("Stacked Column")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Stacked Column';
                        ToolTip = 'Select the stacked column graphing option for this chart.';

                        trigger OnAction()
                        begin
                            UpdateChart(Charttype::StackedColumn);
                        end;
                    }
                    action("Stacked Area")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Stacked Area';
                        ToolTip = 'Select the stacked area graphing option for this chart.';

                        trigger OnAction()
                        begin
                            UpdateChart(Charttype::StackedArea);
                        end;
                    }
                }
            }
        }
    }

    var
        BusChartBuf: Record "Business Chart Buffer";
        TempJob: Record Job temporary;
        JobChartMgt: Codeunit "Job Chart Mgt";
        ChartIsReady: Boolean;
        ChartType: Option Point,,Bubble,Line,,StepLine,,,,,Column,StackedColumn,StackedColumn100,"Area",,StackedArea,StackedArea100,Pie,Doughnut,,,Range,,,,Radar,,,,,,,,Funnel;
        JobChartType: Option Profitability,"Actual to Budget Cost","Actual to Budget Price";
        CurrentChartType: Option;

    local procedure UpdateChart(NewChartType: Option Point,,Bubble,Line,,StepLine,,,,,Column,StackedColumn,StackedColumn100,"Area",,StackedArea,StackedArea100,Pie,Doughnut,,,Range,,,,Radar,,,,,,,,Funnel)
    begin
        if not ChartIsReady then
          exit;

        JobChartMgt.CreateJobChart(BusChartBuf,TempJob,NewChartType,Jobcharttype::"Actual to Budget Cost");
        BusChartBuf.Update(CurrPage.Chart);
        CurrentChartType := NewChartType;
    end;

    local procedure DefaultChartType(): Integer
    begin
        exit(Charttype::Column);
    end;
}

