#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9656 "Report Layout Update Log"
{

    trigger OnRun()
    begin
    end;


    procedure ViewLog(IReportChangeLogCollection: dotnet IReportChangeLogCollection)
    var
        TempReportLayoutUpdateLog: Record "Report Layout Update Log" temporary;
    begin
        if ApplyLogEntriesToTableData(TempReportLayoutUpdateLog,IReportChangeLogCollection) > 0 then
          Page.RunModal(Page::"Report Layout Update Log",TempReportLayoutUpdateLog);
    end;

    local procedure ApplyLogEntriesToTableData(var TempReportLayoutUpdateLog: Record "Report Layout Update Log" temporary;IReportChangeLogCollection: dotnet IReportChangeLogCollection): Integer
    var
        IReportChangeLog: dotnet IReportChangeLog;
        LogCollection: dotnet ReportChangeLogCollection;
        intValue: Integer;
        startValue: Integer;
    begin
        if IsNull(IReportChangeLogCollection) then
          exit(0);
        LogCollection := IReportChangeLogCollection;

        // TODO: FOREACH IReportChangeLog IN IReportChangeLogCollection DO BEGIN
        foreach IReportChangeLog in LogCollection do begin
          startValue += 1;
          with TempReportLayoutUpdateLog do begin
            Init;
            "No." := startValue;
            intValue := IReportChangeLog.Status;
            Status := intValue;
            "Field Name" := IReportChangeLog.ElementName;
            Message := IReportChangeLog.Message;
            "Report ID" := IReportChangeLog.ReportId;
            "Layout Description" := IReportChangeLog.LayoutName;
            intValue := IReportChangeLog.LayoutFormat;
            if intValue = 0 then
              intValue := 1;
            "Layout Type" := intValue - 1;
            Insert;
          end;
        end;

        exit(startValue - 1);
    end;
}

