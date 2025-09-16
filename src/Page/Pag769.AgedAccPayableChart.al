#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 769 "Aged Acc. Payable Chart"
{
    Caption = 'Aged Accounts Payable';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    ShowFilter = false;
    SourceTable = Vendor;

    layout
    {
        area(content)
        {
            field(StatusText;StatusText)
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                ShowCaption = false;
                ToolTip = 'Specifies the status of the chart.';
            }
            usercontrol(BusinessChart;"Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = Basic,Suite;

                trigger DataPointClicked(point: dotnet BusinessChartDataPoint)
                begin
                    BusinessChartBuffer.SetDrillDownIndexes(point);
                    if PerVendor then
                      AgedAccPayable.DrillDown(BusinessChartBuffer,VendorNo,TempEntryNoAmountBuf)
                    else
                      AgedAccPayable.DrillDownByGroup(BusinessChartBuffer,TempEntryNoAmountBuf);
                end;

                trigger DataPointDoubleClicked(point: dotnet BusinessChartDataPoint)
                begin
                end;

                trigger AddInReady()
                begin
                    Initialize;
                end;

                trigger Refresh()
                begin
                    UpdatePage;
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(DayPeriod)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Day';
                Enabled = DayEnabled;
                ToolTip = 'View pending payments summed for one day. Overdue payments are shown as amounts on specific days from the due date going back two weeks from today''s date.';

                trigger OnAction()
                begin
                    BusinessChartBuffer."Period Length" := BusinessChartBuffer."period length"::Day;
                    UpdatePage;
                end;
            }
            action(WeekPeriod)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Week';
                Enabled = WeekEnabled;
                ToolTip = 'Show pending payments summed for one week. Overdue payments are shown as amounts within specific weeks from the due date going back three months from today''s date.';

                trigger OnAction()
                begin
                    BusinessChartBuffer."Period Length" := BusinessChartBuffer."period length"::Week;
                    UpdatePage;
                end;
            }
            action(MonthPeriod)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Month';
                Enabled = MonthEnabled;
                ToolTip = 'View pending payments summed for one month. Overdue payments are shown as amounts within specific months from the due date going back one year from today''s date.';

                trigger OnAction()
                begin
                    BusinessChartBuffer."Period Length" := BusinessChartBuffer."period length"::Month;
                    UpdatePage;
                end;
            }
            action(QuarterPeriod)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Quarter';
                Enabled = QuarterEnabled;
                ToolTip = 'Show pending payments summed for one quarter. Overdue payments are shown as amounts within specific quarters from the due date going back three years from today''s date.';

                trigger OnAction()
                begin
                    BusinessChartBuffer."Period Length" := BusinessChartBuffer."period length"::Quarter;
                    UpdatePage;
                end;
            }
            action(YearPeriod)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Year';
                Enabled = YearEnabled;
                ToolTip = 'Show pending payments summed for one year. Overdue payments are shown as amounts within specific years from the due date going back five years from today''s date.';

                trigger OnAction()
                begin
                    BusinessChartBuffer."Period Length" := BusinessChartBuffer."period length"::Year;
                    UpdatePage;
                end;
            }
            action(All)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'All';
                Enabled = AllEnabled;
                ToolTip = 'Show all accounts receivable in two columns, one with amounts not overdue and one with all overdue amounts.';

                trigger OnAction()
                begin
                    BusinessChartBuffer."Period Length" := BusinessChartBuffer."period length"::None;
                    UpdatePage;
                end;
            }
            separator(Action5)
            {
            }
            action(ChartInformation)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Chart Information';
                Image = Info;
                ToolTip = 'View a description of the chart.';

                trigger OnAction()
                begin
                    Message(AgedAccPayable.Description(PerVendor));
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if PerVendor and ("No." <> xRec."No.") then begin
          VendorNo := "No.";
          UpdateChart;
        end;
    end;

    trigger OnOpenPage()
    var
        BusChartUserSetup: Record "Business Chart User Setup";
    begin
        BusChartUserSetup.InitSetupPage(Page::"Aged Acc. Payable Chart");
        BusinessChartBuffer."Period Length" := BusChartUserSetup."Period Length";
    end;

    var
        BusinessChartBuffer: Record "Business Chart Buffer";
        TempEntryNoAmountBuf: Record "Entry No. Amount Buffer" temporary;
        AgedAccPayable: Codeunit "Aged Acc. Payable";
        isInitialized: Boolean;
        StatusText: Text;
        DayEnabled: Boolean;
        WeekEnabled: Boolean;
        MonthEnabled: Boolean;
        QuarterEnabled: Boolean;
        YearEnabled: Boolean;
        AllEnabled: Boolean;
        PerVendor: Boolean;
        VendorNo: Code[20];

    local procedure Initialize()
    begin
        isInitialized := true;
        UpdatePage;
    end;

    local procedure UpdatePage()
    begin
        EnableActions;
        UpdateStatusText;
        UpdateChart;
        SavePeriodSelection;
    end;

    local procedure UpdateChart()
    begin
        if not isInitialized then
          exit;

        if PerVendor and (VendorNo = '') then
          exit;

        BusinessChartBuffer."Period Filter Start Date" := WorkDate;
        if PerVendor then
          AgedAccPayable.UpdateDataPerVendor(BusinessChartBuffer,VendorNo,TempEntryNoAmountBuf)
        else
          AgedAccPayable.UpdateData(BusinessChartBuffer,TempEntryNoAmountBuf);
        BusinessChartBuffer.Update(CurrPage.BusinessChart);
    end;

    local procedure SavePeriodSelection()
    var
        BusChartUserSetup: Record "Business Chart User Setup";
    begin
        BusChartUserSetup."Period Length" := BusinessChartBuffer."Period Length";
        BusChartUserSetup.SaveSetupPage(BusChartUserSetup,Page::"Aged Acc. Payable Chart");
    end;

    local procedure EnableActions()
    var
        IsDay: Boolean;
        IsWeek: Boolean;
        IsMonth: Boolean;
        IsQuarter: Boolean;
        IsYear: Boolean;
        IsAnyPeriod: Boolean;
    begin
        IsAnyPeriod := BusinessChartBuffer."Period Length" = BusinessChartBuffer."period length"::None;
        IsDay := BusinessChartBuffer."Period Length" = BusinessChartBuffer."period length"::Day;
        IsWeek := BusinessChartBuffer."Period Length" = BusinessChartBuffer."period length"::Week;
        IsMonth := BusinessChartBuffer."Period Length" = BusinessChartBuffer."period length"::Month;
        IsQuarter := BusinessChartBuffer."Period Length" = BusinessChartBuffer."period length"::Quarter;
        IsYear := BusinessChartBuffer."Period Length" = BusinessChartBuffer."period length"::Year;

        DayEnabled := (not IsDay and isInitialized) or IsAnyPeriod;
        WeekEnabled := (not IsWeek and isInitialized) or IsAnyPeriod;
        MonthEnabled := (not IsMonth and isInitialized) or IsAnyPeriod;
        QuarterEnabled := (not IsQuarter and isInitialized) or IsAnyPeriod;
        YearEnabled := (not IsYear and isInitialized) or IsAnyPeriod;
        AllEnabled := (not IsAnyPeriod) and isInitialized;
    end;

    local procedure UpdateStatusText()
    begin
        StatusText := AgedAccPayable.UpdateStatusText(BusinessChartBuffer);
    end;


    procedure SetPerVendor()
    begin
        PerVendor := true;
    end;
}

