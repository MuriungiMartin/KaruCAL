#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 972 "Time Sheet Chart"
{
    Caption = 'Time Sheets';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(content)
        {
            field(StatusText;StatusText)
            {
                ApplicationArea = Jobs;
                Caption = 'Status Text';
                ShowCaption = false;
                ToolTip = 'Specifies the status of the chart.';
            }
            usercontrol(BusinessChart;"Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = Jobs;

                trigger AddInReady()
                begin
                    TimeSheetChartMgt.OnOpenPage(TimeSheetChartSetup);
                    UpdateStatus;
                    IsChartAddInReady := true;
                    if IsChartDataReady then
                      UpdateChart;
                end;

                trigger Refresh()
                begin
                    if IsChartDataReady and IsChartAddInReady then begin
                      NeedsUpdate := true;
                      UpdateChart;
                    end;
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Previous Period")
            {
                ApplicationArea = Jobs;
                Caption = 'Previous Period';
                Image = PreviousSet;
                ToolTip = 'Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.';

                trigger OnAction()
                begin
                    TimeSheetChartSetup.FindPeriod(Setwanted::Previous);
                    UpdateStatus;
                end;
            }
            action("Next Period")
            {
                ApplicationArea = Jobs;
                Caption = 'Next Period';
                Image = NextSet;
                ToolTip = 'View the next period.';

                trigger OnAction()
                begin
                    TimeSheetChartSetup.FindPeriod(Setwanted::Next);
                    UpdateStatus;
                end;
            }
            group("Show by")
            {
                Caption = 'Show by';
                Image = View;
                action(Status)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Status';
                    Image = "Report";
                    ToolTip = 'View the approval status of the time sheet.';

                    trigger OnAction()
                    begin
                        TimeSheetChartSetup.SetShowBy(TimeSheetChartSetup."show by"::Status);
                        UpdateStatus;
                    end;
                }
                action(Type)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Type';
                    ToolTip = 'Specifies the chart type.';

                    trigger OnAction()
                    begin
                        TimeSheetChartSetup.SetShowBy(TimeSheetChartSetup."show by"::Type);
                        UpdateStatus;
                    end;
                }
                action(Posted)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Posted';
                    Image = PostedTimeSheet;
                    ToolTip = 'Specifies the sum of time sheet hours for posted time sheets.';

                    trigger OnAction()
                    begin
                        TimeSheetChartSetup.SetShowBy(TimeSheetChartSetup."show by"::Posted);
                        UpdateStatus;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateChart;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        UpdateChart;
        IsChartDataReady := true;
    end;

    var
        TimeSheetChartSetup: Record "Time Sheet Chart Setup";
        OldTimeSheetChartSetup: Record "Time Sheet Chart Setup";
        TimeSheetChartMgt: Codeunit "Time Sheet Chart Mgt.";
        StatusText: Text[250];
        NeedsUpdate: Boolean;
        SetWanted: Option Previous,Next;
        IsChartDataReady: Boolean;
        IsChartAddInReady: Boolean;

    local procedure UpdateChart()
    begin
        if not NeedsUpdate then
          exit;
        if not IsChartAddInReady then
          exit;
        TimeSheetChartMgt.UpdateData(Rec);
        Update(CurrPage.BusinessChart);
        UpdateStatus;

        NeedsUpdate := false;
    end;

    local procedure UpdateStatus()
    begin
        NeedsUpdate := NeedsUpdate or IsSetupChanged;

        OldTimeSheetChartSetup := TimeSheetChartSetup;

        if NeedsUpdate then
          StatusText := TimeSheetChartSetup.GetCurrentSelectionText;
    end;

    local procedure IsSetupChanged(): Boolean
    begin
        exit(
          (OldTimeSheetChartSetup."Starting Date" <> TimeSheetChartSetup."Starting Date") or
          (OldTimeSheetChartSetup."Show by" <> TimeSheetChartSetup."Show by"));
    end;
}

