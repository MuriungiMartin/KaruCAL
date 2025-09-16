#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 775 "Analysis Report Chart Setup"
{
    Caption = 'Analysis Report Chart Setup';
    SourceTable = "Analysis Report Chart Setup";

    layout
    {
        area(content)
        {
            group(DataSource)
            {
                Caption = 'Data Source';
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the specific chart.';

                    trigger OnValidate()
                    begin
                        SetEnabled;
                    end;
                }
                field("Analysis Report Name";"Analysis Report Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the analysis report that is used to generate the specific chart that is shown in, for example, the Sales Performance window.';

                    trigger OnValidate()
                    begin
                        SetEnabled;
                        SetAnalysisReportName("Analysis Report Name");
                        CurrPage.Update(false);
                    end;
                }
                field("Base X-Axis on";"Base X-Axis on")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how the values from the selected analysis report are displayed in the specific chart.';

                    trigger OnValidate()
                    begin
                        SetEnabled;
                        SetShowPer("Base X-Axis on");
                        CurrPage.Update(false);
                    end;
                }
                field("Analysis Line Template Name";"Analysis Line Template Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the analysis line template that is used to generate the specific chart that is shown in, for example, the Sales Performance window.';
                }
                field("Analysis Column Template Name";"Analysis Column Template Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the analysis column template that is used to generate the chart that is shown in, for example, the Sales Performance window.';
                }
                group(Control8)
                {
                    field("Start Date";"Start Date")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies the first date on which analysis report values are included in the chart.';
                    }
                    field("End Date";"End Date")
                    {
                        ApplicationArea = Basic;
                        Editable = IsEndDateEnabled;
                        ToolTip = 'Specifies the last date on which analysis report values are included in the chart.';
                    }
                    field("Period Length";"Period Length")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies the length of periods in the chart.';
                    }
                    field("No. of Periods";"No. of Periods")
                    {
                        ApplicationArea = Basic;
                        Enabled = IsNoOfPeriodsEnabled;
                        ToolTip = 'Specifies how many periods are shown in the chart.';
                    }
                }
            }
            group("Measures (Y-Axis)")
            {
                Caption = 'Measures (Y-Axis)';
                part(SetupYAxis;"Analysis Report Chart SubPage")
                {
                    ApplicationArea = Suite;
                    Caption = ' ';
                }
            }
            group("Dimensions (X-Axis)")
            {
                Caption = 'Dimensions (X-Axis)';
                Visible = IsXAxisVisible;
                part(SetupXAxis;"Analysis Report Chart SubPage")
                {
                    Caption = ' ';
                    Visible = IsXAxisVisible;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetEnabled;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Start Date" := WorkDate;
    end;

    trigger OnOpenPage()
    begin
        SetEnabled;
    end;

    var
        IsEndDateEnabled: Boolean;
        IsNoOfPeriodsEnabled: Boolean;
        IsXAxisVisible: Boolean;

    local procedure SetEnabled()
    begin
        IsNoOfPeriodsEnabled := "Base X-Axis on" = "base x-axis on"::Period;
        IsXAxisVisible := "Base X-Axis on" <> "base x-axis on"::Period;
        IsEndDateEnabled := "Base X-Axis on" <> "base x-axis on"::Period;
        CurrPage.SetupYAxis.Page.SetViewAsMeasure(true);
        CurrPage.SetupYAxis.Page.SetSetupRec(Rec);
        CurrPage.SetupXAxis.Page.SetViewAsMeasure(false);
        CurrPage.SetupXAxis.Page.SetSetupRec(Rec);
    end;
}

