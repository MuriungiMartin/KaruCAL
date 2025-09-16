#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 763 "Account Schedules Chart Setup"
{
    Caption = 'Account Schedules Chart Setup';
    SourceTable = "Account Schedules Chart Setup";

    layout
    {
        area(content)
        {
            group(DataSource)
            {
                Caption = 'Data Source';
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the specific chart.';

                    trigger OnValidate()
                    begin
                        SetEnabled;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the description of the specific chart.';
                }
                field("Account Schedule Name";"Account Schedule Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the account schedule that is used to generate the chart that is shown in the Finance Performance window.';

                    trigger OnValidate()
                    begin
                        SetEnabled;
                        SetAccScheduleName("Account Schedule Name");
                        CurrPage.Update(false);
                    end;
                }
                field("Column Layout Name";"Column Layout Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the column layout in the account schedule that is used to generate the advanced chart that is shown in the Finance Performance window.';

                    trigger OnValidate()
                    begin
                        SetEnabled;
                        SetColumnLayoutName("Column Layout Name");
                        CurrPage.Update(false);
                    end;
                }
                field("Base X-Axis on";"Base X-Axis on")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how the values from the selected account schedule are displayed in the specific chart.';

                    trigger OnValidate()
                    begin
                        SetEnabled;
                        SetShowPer("Base X-Axis on");
                        CurrPage.Update(false);
                    end;
                }
                group(Control15)
                {
                    field("Start Date";"Start Date")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the first date on which account schedule values are included in the chart.';
                    }
                    field("End Date";"End Date")
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = IsEndDateEnabled;
                        ToolTip = 'Specifies the last date on which account schedule values are included in the chart.';
                    }
                    field("Period Length";"Period Length")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the length of periods in the chart.';
                    }
                    field("No. of Periods";"No. of Periods")
                    {
                        ApplicationArea = Basic,Suite;
                        Enabled = IsNoOfPeriodsEnabled;
                        ToolTip = 'Specifies how many periods are shown in the chart.';
                    }
                }
            }
            group("Measures (Y-Axis)")
            {
                Caption = 'Measures (Y-Axis)';
                part(SetupYAxis;"Acc. Sched. Chart SubPage")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = ' ';
                }
            }
            group("Dimensions (X-Axis)")
            {
                Caption = 'Dimensions (X-Axis)';
                Visible = IsXAxisVisible;
                part(SetupXAxis;"Acc. Sched. Chart SubPage")
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

