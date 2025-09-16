#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 450 "Job Queue Error Handler"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        JobQueueLogEntry: Record "Job Queue Log Entry";
        JobQueueDispatcher: Codeunit "Job Queue Dispatcher";
    begin
        if not Find then
          exit;
        SetError(GetLastErrorText);
        JobQueueLogEntry.SetRange(ID,ID);
        if JobQueueLogEntry.FindFirst then begin
          JobQueueLogEntry.SetErrorMessage(GetLastErrorText);
          JobQueueLogEntry.MarkAsError;
        end else
          JobQueueDispatcher.InsertLogEntry(Rec,CurrentDatetime);
    end;
}

