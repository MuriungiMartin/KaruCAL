#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1392 "Help And Chart Wrapper"
{
    Caption = 'Business Assistance';
    DeleteAllowed = false;
    PageType = CardPart;
    SourceTable = "Assisted Setup";
    SourceTableView = sorting(Order,Visible)
                      where(Visible=const(true),
                            Featured=const(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'How To:';
                Visible = not ShowChart;
                field("Item Type";"Item Type")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Icon;Icon)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = IsSaaS;
                }
            }
            field("Status Text";StatusText)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Status Text';
                Editable = false;
                ShowCaption = false;
                Style = StrongAccent;
                StyleExpr = true;
                ToolTip = 'Specifies the status of the chart.';
                Visible = ShowChart;
            }
            usercontrol(BusinessChart;"Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = Basic,Suite;
                Visible = ShowChart;

                trigger AddInReady()
                begin
                    IsChartAddInReady := true;
                    ChartManagement.AddinReady(SelectedChartDefinition,BusinessChartBuffer);
                    InitializeSelectedChart;
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Select Chart")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Select Chart';
                Image = SelectChart;
                ToolTip = 'Change the chart that is displayed. You can choose from several charts that show data for different performance indicators.';
                Visible = ShowChart;

                trigger OnAction()
                begin
                    ChartManagement.SelectChart(BusinessChartBuffer,SelectedChartDefinition);
                    InitializeSelectedChart;
                end;
            }
            action("Previous Chart")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Previous Chart';
                Image = PreviousSet;
                ToolTip = 'View the previous chart.';
                Visible = ShowChart;

                trigger OnAction()
                begin
                    SelectedChartDefinition.SetRange(Enabled,true);
                    if SelectedChartDefinition.Next(-1) = 0 then
                      if not SelectedChartDefinition.FindLast then
                        exit;
                    InitializeSelectedChart;
                end;
            }
            action("Next Chart")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next Chart';
                Image = NextSet;
                ToolTip = 'View the next chart.';
                Visible = ShowChart;

                trigger OnAction()
                begin
                    SelectedChartDefinition.SetRange(Enabled,true);
                    if SelectedChartDefinition.Next = 0 then
                      if not SelectedChartDefinition.FindFirst then
                        exit;
                    InitializeSelectedChart;
                end;
            }
            group(PeriodLength)
            {
                Caption = 'Period Length';
                Image = Period;
                Visible = ShowChart;
                action(Day)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Day';
                    Image = DueDate;
                    ToolTip = 'Each stack covers one day.';
                    Visible = ShowChart;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart(BusinessChartBuffer."period length"::Day);
                    end;
                }
                action(Week)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Week';
                    Image = DateRange;
                    ToolTip = 'Each stack except for the last stack covers one week. The last stack contains data from the start of the week until the date that is defined by the Show option.';
                    Visible = ShowChart;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart(BusinessChartBuffer."period length"::Week);
                    end;
                }
                action(Month)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Month';
                    Image = DateRange;
                    ToolTip = 'Each stack except for the last stack covers one month. The last stack contains data from the start of the month until the date that is defined by the Show option.';
                    Visible = ShowChart;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart(BusinessChartBuffer."period length"::Month);
                    end;
                }
                action(Quarter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Quarter';
                    Image = DateRange;
                    ToolTip = 'Each stack except for the last stack covers one quarter. The last stack contains data from the start of the quarter until the date that is defined by the Show option.';
                    Visible = ShowChart;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart(BusinessChartBuffer."period length"::Quarter);
                    end;
                }
                action(Year)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Year';
                    Image = DateRange;
                    ToolTip = 'Each stack except for the last stack covers one year. The last stack contains data from the start of the year until the date that is defined by the Show option.';
                    Visible = ShowChart;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart(BusinessChartBuffer."period length"::Year);
                    end;
                }
            }
            action(PreviousPeriod)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Previous Period';
                Enabled = PreviousNextActionEnabled;
                Image = PreviousRecord;
                ToolTip = 'Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.';
                Visible = ShowChart;

                trigger OnAction()
                begin
                    ChartManagement.UpdateChart(SelectedChartDefinition,BusinessChartBuffer,Period::Previous);
                    BusinessChartBuffer.Update(CurrPage.BusinessChart);
                end;
            }
            action(NextPeriod)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next Period';
                Enabled = PreviousNextActionEnabled;
                Image = NextRecord;
                ToolTip = 'Scroll the chart to the left to display the next period.';
                Visible = ShowChart;

                trigger OnAction()
                begin
                    ChartManagement.UpdateChart(SelectedChartDefinition,BusinessChartBuffer,Period::Next);
                    BusinessChartBuffer.Update(CurrPage.BusinessChart);
                end;
            }
            action(ChartInformation)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Chart Information';
                Image = AboutNav;
                ToolTip = 'View a description of the chart.';
                Visible = ShowChart;

                trigger OnAction()
                var
                    Description: Text;
                begin
                    if StatusText = '' then
                      exit;
                    Description := ChartManagement.ChartDescription(SelectedChartDefinition);
                    if Description = '' then
                      Message(NoDescriptionMsg)
                    else
                      Message(Description);
                end;
            }
            action("Show Setup and Help Resources")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show Setup and Help Resources';
                ToolTip = 'Get assistance for setup and view help topics, videos, and other resources.';
                Visible = ShowChart;

                trigger OnAction()
                begin
                    PersistChartVisibility(false);
                    Message(RefreshPageMsg)
                end;
            }
            action(View)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'View';
                Image = View;
                Promoted = true;
                PromotedCategory = Category4;
                RunPageMode = View;
                ShortCutKey = 'Return';
                ToolTip = 'View extension details.';
                Visible = not ShowChart;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
            action("Show Chart")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show Chart';
                Image = AnalysisView;
                ToolTip = 'View your business performance on a pie chart.';
                Visible = not ShowChart;

                trigger OnAction()
                begin
                    SetRange(Featured,true);
                    PersistChartVisibility(true);
                    Message(RefreshPageMsg)
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        CompanyInformation: Record "Company Information";
        PermissionManager: Codeunit "Permission Manager";
    begin
        CompanyInformation.Get;
        ShowChart := CompanyInformation."Show Chart On RoleCenter";

        IsSaaS := PermissionManager.SoftwareAsAService;
        if ShowChart then
          InitializeSelectedChart;

        Initialize;
    end;

    var
        SelectedChartDefinition: Record "Chart Definition";
        BusinessChartBuffer: Record "Business Chart Buffer";
        ChartManagement: Codeunit "Chart Management";
        StatusText: Text;
        Period: Option " ",Next,Previous;
        [InDataSet]
        PreviousNextActionEnabled: Boolean;
        NoDescriptionMsg: label 'A description was not specified for this chart.';
        IsChartAddInReady: Boolean;
        ShowChart: Boolean;
        RefreshPageMsg: label 'Refresh the page for the change to take effect.';
        IsSaaS: Boolean;

    local procedure InitializeSelectedChart()
    begin
        ChartManagement.SetDefaultPeriodLength(SelectedChartDefinition,BusinessChartBuffer);
        ChartManagement.UpdateChart(SelectedChartDefinition,BusinessChartBuffer,Period::" ");
        PreviousNextActionEnabled := ChartManagement.UpdateNextPrevious(SelectedChartDefinition);
        ChartManagement.UpdateStatusText(SelectedChartDefinition,BusinessChartBuffer,StatusText);
        UpdateChart;
    end;

    local procedure SetPeriodAndUpdateChart(PeriodLength: Option)
    begin
        ChartManagement.SetPeriodLength(SelectedChartDefinition,BusinessChartBuffer,PeriodLength,false);
        ChartManagement.UpdateChart(SelectedChartDefinition,BusinessChartBuffer,Period::" ");
        ChartManagement.UpdateStatusText(SelectedChartDefinition,BusinessChartBuffer,StatusText);
        UpdateChart;
    end;

    local procedure UpdateChart()
    begin
        if not IsChartAddInReady then
          exit;
        BusinessChartBuffer.Update(CurrPage.BusinessChart);
    end;

    local procedure PersistChartVisibility(VisibilityStatus: Boolean)
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Validate("Show Chart On RoleCenter",VisibilityStatus);
        CompanyInformation.Modify;
    end;
}

