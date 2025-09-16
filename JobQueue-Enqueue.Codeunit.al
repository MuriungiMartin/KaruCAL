#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 453 "Job Queue - Enqueue"
{
    Permissions = TableData "Job Queue Entry"=rimd;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        EnqueueJobQueueEntry(Rec);
    end;


    procedure EnqueueJobQueueEntry(var JobQueueEntry: Record "Job Queue Entry")
    var
        DoNotScheduleTask: Boolean;
    begin
        RemoveFailedJobs(JobQueueEntry);
        JobQueueEntry.Status := JobQueueEntry.Status::"On Hold";
        JobQueueEntry."User Language ID" := GlobalLanguage;
        if not JobQueueEntry.Insert(true) then
          JobQueueEntry.Modify(true);

        OnBeforeJobQueueScheduleTask(DoNotScheduleTask);

        if DoNotScheduleTask then
          exit;

        JobQueueEntry."System Task ID" :=
          TaskScheduler.CreateTask(
            Codeunit::"Job Queue Dispatcher",
            Codeunit::"Job Queue Error Handler",
            true,
            COMPANYNAME,
            JobQueueEntry."Earliest Start Date/Time",
            JobQueueEntry.RecordId);
        JobQueueEntry.Status := JobQueueEntry.Status::Ready;
        JobQueueEntry.Modify;
        Commit;
    end;


    procedure RemoveFailedJobs(var JobQueueEntry: Record "Job Queue Entry")
    var
        JobQueueEntry2: Record "Job Queue Entry";
    begin
        JobQueueEntry2.SetRange("Object Type to Run",JobQueueEntry."Object Type to Run");
        JobQueueEntry2.SetRange("Object ID to Run",JobQueueEntry."Object ID to Run");
        JobQueueEntry2.SetRange("Record ID to Process",JobQueueEntry."Record ID to Process");
        JobQueueEntry2.SetRange(Status,JobQueueEntry2.Status::Error);
        if not JobQueueEntry2.IsEmpty then
          JobQueueEntry2.DeleteAll;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeJobQueueScheduleTask(var DoNotScheduleTask: Boolean)
    begin
    end;
}

