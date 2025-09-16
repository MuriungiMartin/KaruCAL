#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 449 "Job Queue Start Codeunit"
{
    Permissions = TableData "Job Queue Entry"=rm;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if "User Language ID" <> 0 then
          GlobalLanguage("User Language ID");

        case "Object Type to Run" of
          "object type to run"::Codeunit:
            Codeunit.Run("Object ID to Run",Rec);
          "object type to run"::Report:
            RunReport("Object ID to Run",Rec);
        end;

        // Commit any remaining transactions from the target codeunit\report. This is necessary due
        // to buffered record insertion which may not have surfaced errors in CODEUNIT.RUN above.
        Commit;
    end;

    local procedure RunReport(ReportID: Integer;var JobQueueEntry: Record "Job Queue Entry")
    var
        ReportInbox: Record "Report Inbox";
        RecRef: RecordRef;
        OutStr: OutStream;
        RunOnRec: Boolean;
    begin
        ReportInbox.Init;
        ReportInbox."User ID" := JobQueueEntry."User ID";
        ReportInbox."Job Queue Log Entry ID" := JobQueueEntry.ID;
        ReportInbox."Report ID" := ReportID;
        ReportInbox.Description := JobQueueEntry.Description;
        ReportInbox."Report Output".CreateOutstream(OutStr);
        RunOnRec := RecRef.Get(JobQueueEntry."Record ID to Process");
        if RunOnRec then
          RecRef.SetRecfilter;

        case JobQueueEntry."Report Output Type" of
          JobQueueEntry."report output type"::"None (Processing only)":
            if RunOnRec then
              Report.Execute(ReportID,JobQueueEntry.GetReportParameters,RecRef)
            else
              Report.Execute(ReportID,JobQueueEntry.GetReportParameters);
          JobQueueEntry."report output type"::Print:
            if RunOnRec then
              Report.Print(ReportID,JobQueueEntry.GetReportParameters,JobQueueEntry."Printer Name",RecRef)
            else
              Report.Print(ReportID,JobQueueEntry.GetReportParameters,JobQueueEntry."Printer Name");
          JobQueueEntry."report output type"::Pdf:
            begin
              if RunOnRec then
                Report.SaveAs(ReportID,JobQueueEntry.GetReportParameters,Reportformat::Pdf,OutStr,RecRef)
              else
                Report.SaveAs(ReportID,JobQueueEntry.GetReportParameters,Reportformat::Pdf,OutStr);
              ReportInbox."Output Type" := ReportInbox."output type"::Pdf;
            end;
          JobQueueEntry."report output type"::Word:
            begin
              if RunOnRec then
                Report.SaveAs(ReportID,JobQueueEntry.GetReportParameters,Reportformat::Word,OutStr,RecRef)
              else
                Report.SaveAs(ReportID,JobQueueEntry.GetReportParameters,Reportformat::Word,OutStr);
              ReportInbox."Output Type" := ReportInbox."output type"::Word;
            end;
          JobQueueEntry."report output type"::Excel:
            begin
              if RunOnRec then
                Report.SaveAs(ReportID,JobQueueEntry.GetReportParameters,Reportformat::Excel,OutStr,RecRef)
              else
                Report.SaveAs(ReportID,JobQueueEntry.GetReportParameters,Reportformat::Excel,OutStr);
              ReportInbox."Output Type" := ReportInbox."output type"::Excel;
            end;
        end;

        case JobQueueEntry."Report Output Type" of
          JobQueueEntry."report output type"::"None (Processing only)":
            begin
              JobQueueEntry."Notify On Success" := true;
              JobQueueEntry.Modify;
            end;
          JobQueueEntry."report output type"::Print:
            ;
          else begin
            ReportInbox."Created Date-Time" := RoundDatetime(CurrentDatetime,60000);
            ReportInbox.Insert(true);
          end;
        end;
        Commit;
    end;
}

