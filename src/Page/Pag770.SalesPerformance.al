#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 770 "Sales Performance"
{
    Caption = 'Sales Performance';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(content)
        {
            field(StatusText;StatusText)
            {
                ApplicationArea = Basic,Suite;
                Enabled = false;
                ShowCaption = false;
                Style = StrongAccent;
                StyleExpr = true;
                ToolTip = 'Specifies the status of the chart.';
            }
            usercontrol(BusinessChart;"Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = Basic,Suite;

                trigger AddInReady()
                begin
                    UpdateChart(Period::" ");
                end;

                trigger Refresh()
                begin
                    InitializePeriodFilter(0D,0D);
                    UpdateChart(Period::" ");
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SelectChart)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Select Chart';
                Image = SelectChart;
                ToolTip = 'Select the analysis report that the chart will be based on.';

                trigger OnAction()
                begin
                    if AnalysisReportChartMgt.SelectChart(AnalysisReportChartSetup,Rec) then
                      UpdateChart(Period::" ");
                end;
            }
            separator(Action5)
            {
            }
            group(PeriodLength)
            {
                Caption = 'Period Length';
                Image = Period;
                action(Day)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Day';
                    ToolTip = 'Each stack covers one day.';

                    trigger OnAction()
                    begin
                        AnalysisReportChartSetup.SetPeriodLength(AnalysisReportChartSetup."period length"::Day);
                        UpdateChart(Period::" ");
                    end;
                }
                action(Week)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Week';
                    ToolTip = 'Each stack except for the last stack covers one week. The last stack contains data from the start of the week until the date that is defined by the Show option.';

                    trigger OnAction()
                    begin
                        AnalysisReportChartSetup.SetPeriodLength(AnalysisReportChartSetup."period length"::Week);
                        UpdateChart(Period::" ");
                    end;
                }
                action(Month)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Month';
                    ToolTip = 'Each stack except for the last stack covers one month. The last stack contains data from the start of the month until the date that is defined by the Show option.';

                    trigger OnAction()
                    begin
                        AnalysisReportChartSetup.SetPeriodLength(AnalysisReportChartSetup."period length"::Month);
                        UpdateChart(Period::" ");
                    end;
                }
                action(Quarter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Quarter';
                    ToolTip = 'Each stack except for the last stack covers one quarter. The last stack contains data from the start of the quarter until the date that is defined by the Show option.';

                    trigger OnAction()
                    begin
                        AnalysisReportChartSetup.SetPeriodLength(AnalysisReportChartSetup."period length"::Quarter);
                        UpdateChart(Period::" ");
                    end;
                }
                action(Year)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Year';
                    ToolTip = 'Each stack except for the last stack covers one year. The last stack contains data from the start of the year until the date that is defined by the Show option.';

                    trigger OnAction()
                    begin
                        AnalysisReportChartSetup.SetPeriodLength(AnalysisReportChartSetup."period length"::Year);
                        UpdateChart(Period::" ");
                    end;
                }
            }
            action(PreviousPeriod)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Previous';
                Image = PreviousRecord;
                ToolTip = 'Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.';

                trigger OnAction()
                begin
                    UpdateChart(Period::Previous);
                end;
            }
            action(NextPeriod)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next';
                Image = NextRecord;
                ToolTip = 'Show the information based on the next period.';

                trigger OnAction()
                begin
                    UpdateChart(Period::Next);
                end;
            }
        }
    }

    var
        AnalysisReportChartSetup: Record "Analysis Report Chart Setup";
        AnalysisReportChartMgt: Codeunit "Analysis Report Chart Mgt.";
        StatusText: Text[250];
        Period: Option " ",Next,Previous;

    local procedure UpdateChart(Period: Option ,Next,Previous)
    begin
        AnalysisReportChartMgt.UpdateChart(
          Period,AnalysisReportChartSetup,AnalysisReportChartSetup."analysis area"::Sales,Rec,StatusText);
        Update(CurrPage.BusinessChart);
    end;
}

