#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 198 "Acc. Sched. KPI WS Dimensions"
{
    Caption = 'Account Schedule KPI WS Dimensions';
    Editable = false;
    PageType = List;
    SourceTable = "Acc. Sched. KPI Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Number;Number)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date on which the KPI figures are calculated.';
                }
                field("Closed Period";"Closed Period")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the accounting period is closed or locked. KPI data for periods that are not closed or locked will be forecasted values from the general ledger budget.';
                }
                field("Account Schedule Name";"Account Schedule Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the account schedule that the KPI web service is based on.';
                }
                field("KPI Code";"KPI Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code for the account-schedule KPI web service.';
                }
                field("KPI Name";"KPI Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a name of the account-schedule KPI web service.';
                }
                field("Net Change Actual";"Net Change Actual")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies changes in the actual general ledger amount, for closed accounting periods, up until the date in the Date field.';
                }
                field("Balance at Date Actual";"Balance at Date Actual")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the actual general ledger balance, based on closed accounting periods, on the date in the Date field.';
                }
                field("Net Change Budget";"Net Change Budget")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies changes in the budgeted general ledger amount, based on the general ledger budget, up until the date in the Date field.';
                }
                field("Balance at Date Budget";"Balance at Date Budget")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the budgeted general ledger balance, based on the general ledger budget, on the date in the Date field.';
                }
                field("Net Change Actual Last Year";"Net Change Actual Last Year")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies actual changes in the general ledger amount, based on closed accounting periods, up until the date in the Date field in the previous accounting year.';
                }
                field("Balance at Date Actual Last Year";"Balance at Date Act. Last Year")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the actual general ledger balance, based on closed accounting periods, on the date in the Date field in the previous accounting year.';
                }
                field("Net Change Budget Last Year";"Net Change Budget Last Year")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies budgeted changes in the general ledger amount, based on the general ledger budget, up until the date in the Date field in the previous year.';
                }
                field("Balance at Date Budget Last Year";"Balance at Date Bud. Last Year")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the budgeted general ledger balance, based on the general ledger budget, on the date in the Date field in the previous accounting year.';
                }
                field("Net Change Forecast";"Net Change Forecast")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies forecasted changes in the general ledger amount, based on open accounting periods, up until the date in the Date field.';
                }
                field("Balance at Date Forecast";"Balance at Date Forecast")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the forecasted general ledger balance, based on open accounting periods, on the date in the Date field.';
                }
                field("Dimension Set ID";"Dimension Set ID")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Number := "No.";
    end;

    trigger OnOpenPage()
    begin
        Initialize;
        PrecalculateData;
    end;

    var
        AccSchedKPIWebSrvSetup: Record "Acc. Sched. KPI Web Srv. Setup";
        TempAccScheduleLine: Record "Acc. Schedule Line" temporary;
        AccSchedKPIDimensions: Codeunit "Acc. Sched. KPI Dimensions";
        Number: Integer;

    local procedure Initialize()
    var
        LogInManagement: Codeunit LogInManagement;
    begin
        if not GuiAllowed then
          WorkDate := LogInManagement.GetDefaultWorkDate;

        SetupActiveAccSchedLines;
    end;

    local procedure SetupColumnLayout(var TempColumnLayout: Record "Column Layout" temporary)
    begin
        with TempColumnLayout do begin
          InsertTempColumn(TempColumnLayout,"column type"::"Net Change","ledger entry type"::Entries,false);
          InsertTempColumn(TempColumnLayout,"column type"::"Balance at Date","ledger entry type"::Entries,false);
          InsertTempColumn(TempColumnLayout,"column type"::"Net Change","ledger entry type"::"Budget Entries",false);
          InsertTempColumn(TempColumnLayout,"column type"::"Balance at Date","ledger entry type"::"Budget Entries",false);
          InsertTempColumn(TempColumnLayout,"column type"::"Net Change","ledger entry type"::Entries,true);
          InsertTempColumn(TempColumnLayout,"column type"::"Balance at Date","ledger entry type"::Entries,true);
          InsertTempColumn(TempColumnLayout,"column type"::"Net Change","ledger entry type"::"Budget Entries",true);
          InsertTempColumn(TempColumnLayout,"column type"::"Balance at Date","ledger entry type"::"Budget Entries",true);
        end;
    end;

    local procedure SetupActiveAccSchedLines()
    var
        AccScheduleLine: Record "Acc. Schedule Line";
        AccSchedKPIWebSrvLine: Record "Acc. Sched. KPI Web Srv. Line";
        LineNo: Integer;
    begin
        AccSchedKPIWebSrvSetup.Get;
        AccSchedKPIWebSrvLine.FindSet;
        AccScheduleLine.SetRange(Show,AccScheduleLine.Show::Yes);
        AccScheduleLine.SetFilter(Totaling,'<>%1','');
        repeat
          AccScheduleLine.SetRange("Schedule Name",AccSchedKPIWebSrvLine."Acc. Schedule Name");
          AccScheduleLine.FindSet;
          repeat
            LineNo += 1;
            TempAccScheduleLine := AccScheduleLine;
            TempAccScheduleLine."Line No." := LineNo;
            TempAccScheduleLine.Insert;
          until AccScheduleLine.Next = 0;
        until AccSchedKPIWebSrvLine.Next = 0;
    end;

    local procedure InsertTempColumn(var TempColumnLayout: Record "Column Layout" temporary;ColumnType: Option;EntryType: Option;LastYear: Boolean)
    begin
        with TempColumnLayout do begin
          if FindLast then;
          Init;
          "Line No." += 10000;
          "Column Type" := ColumnType;
          "Ledger Entry Type" := EntryType;
          if LastYear then
            Evaluate("Comparison Date Formula",'<-1Y>');
          Insert;
        end;
    end;

    local procedure PrecalculateData()
    var
        TempAccSchedKPIBuffer: Record "Acc. Sched. KPI Buffer" temporary;
        TempColumnLayout: Record "Column Layout" temporary;
        StartDate: Date;
        EndDate: Date;
        FromDate: Date;
        ToDate: Date;
        LastClosedDate: Date;
        C: Integer;
        NoOfPeriods: Integer;
        ForecastFromBudget: Boolean;
    begin
        SetupColumnLayout(TempColumnLayout);

        AccSchedKPIWebSrvSetup.GetPeriodLength(NoOfPeriods,StartDate,EndDate);
        LastClosedDate := AccSchedKPIWebSrvSetup.GetLastClosedAccDate;

        for C := 1 to NoOfPeriods do begin
          FromDate := AccSchedKPIWebSrvSetup.CalcNextStartDate(StartDate,C - 1);
          ToDate := AccSchedKPIWebSrvSetup.CalcNextStartDate(FromDate,1) - 1;
          with TempAccSchedKPIBuffer do begin
            Init;
            Date := FromDate;
            "Closed Period" := (FromDate <= LastClosedDate);
            ForecastFromBudget :=
              ((AccSchedKPIWebSrvSetup."Forecasted Values Start" =
                AccSchedKPIWebSrvSetup."forecasted values start"::"After Latest Closed Period") and
               not "Closed Period") or
              ((AccSchedKPIWebSrvSetup."Forecasted Values Start" =
                AccSchedKPIWebSrvSetup."forecasted values start"::"After Current Date") and
               (Date > WorkDate));
          end;

          with TempAccScheduleLine do begin
            FindSet;
            repeat
              if TempAccSchedKPIBuffer."Account Schedule Name" <> "Schedule Name" then begin
                InsertAccSchedulePeriod(TempAccSchedKPIBuffer,ForecastFromBudget);
                TempAccSchedKPIBuffer."Account Schedule Name" := "Schedule Name";
              end;
              TempAccSchedKPIBuffer."KPI Code" := "Row No.";
              TempAccSchedKPIBuffer."KPI Name" :=
                CopyStr(Description,1,MaxStrLen(TempAccSchedKPIBuffer."KPI Name"));
              SetRange("Date Filter",FromDate,ToDate);
              SetRange("G/L Budget Filter",AccSchedKPIWebSrvSetup."G/L Budget Name");
              AccSchedKPIDimensions.GetCellDataWithDimensions(TempAccScheduleLine,TempColumnLayout,TempAccSchedKPIBuffer);
            until Next = 0;
          end;
          InsertAccSchedulePeriod(TempAccSchedKPIBuffer,ForecastFromBudget);
        end;
        Reset;
        FindFirst;
    end;

    local procedure InsertAccSchedulePeriod(var TempAccSchedKPIBuffer: Record "Acc. Sched. KPI Buffer" temporary;ForecastFromBudget: Boolean)
    begin
        with TempAccSchedKPIBuffer do begin
          Reset;
          if FindSet then
            repeat
              InsertData(TempAccSchedKPIBuffer,ForecastFromBudget);
            until Next = 0;
          DeleteAll;
        end;
    end;

    local procedure InsertData(AccSchedKPIBuffer: Record "Acc. Sched. KPI Buffer";ForecastFromBudget: Boolean)
    var
        TempAccScheduleLine2: Record "Acc. Schedule Line" temporary;
    begin
        Init;
        "No." += 1;
        TransferFields(AccSchedKPIBuffer,false);

        with TempAccScheduleLine2 do begin
          Copy(TempAccScheduleLine,true);
          SetRange("Schedule Name",AccSchedKPIBuffer."Account Schedule Name");
          SetRange("Row No.",AccSchedKPIBuffer."KPI Code");
          FindFirst;
        end;

        "Net Change Actual" :=
          AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Net Change Actual");
        "Balance at Date Actual" :=
          AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Balance at Date Actual");
        "Net Change Budget" :=
          AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Net Change Budget");
        "Balance at Date Budget" :=
          AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Balance at Date Budget");
        "Net Change Actual Last Year" :=
          AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Net Change Actual Last Year");
        "Balance at Date Act. Last Year" :=
          AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Balance at Date Act. Last Year");
        "Net Change Budget Last Year" :=
          AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Net Change Budget Last Year");
        "Balance at Date Bud. Last Year" :=
          AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Balance at Date Bud. Last Year");

        if ForecastFromBudget then begin
          "Net Change Forecast" := "Net Change Budget";
          "Balance at Date Forecast" := "Balance at Date Budget";
        end else begin
          "Net Change Forecast" := "Net Change Actual";
          "Balance at Date Forecast" := "Balance at Date Actual";
        end;
        Insert;
    end;
}

