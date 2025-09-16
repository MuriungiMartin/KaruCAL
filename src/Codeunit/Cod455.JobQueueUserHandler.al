#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 455 "Job Queue User Handler"
{

    trigger OnRun()
    begin
        RescheduleJobQueueEntries;
    end;

    local procedure RescheduleJobQueueEntries()
    var
        JobQueueEntry: Record "Job Queue Entry";
        TempJobQueueEntry: Record "Job Queue Entry" temporary;
        User: Record User;
    begin
        JobQueueEntry.SetFilter(Status,'<>%1&<>%2',JobQueueEntry.Status::"On Hold",JobQueueEntry.Status::Finished);
        if not JobQueueEntry.FindSet then
          exit;
        repeat
          if JobQueueEntry."User ID" = UserId then begin
            JobQueueEntry.CalcFields(Scheduled);
            if not JobQueueEntry.Scheduled then begin
              TempJobQueueEntry := JobQueueEntry;
              TempJobQueueEntry.Insert;
            end
          end else begin
            User.SetRange("User Name",JobQueueEntry."User ID");
            if User.IsEmpty then begin
              TempJobQueueEntry := JobQueueEntry;
              TempJobQueueEntry.Insert;
            end;
          end;
        until JobQueueEntry.Next = 0;

        if not TempJobQueueEntry.FindSet then
          exit;
        JobQueueEntry.LockTable;
        repeat
          if JobQueueEntry.Get(TempJobQueueEntry.ID) then
            if JobQueueEntry.Status in [JobQueueEntry.Status::"On Hold",JobQueueEntry.Status::Finished] then
              TempJobQueueEntry.Delete
            else
              JobQueueEntry.Cancel;
        until TempJobQueueEntry.Next = 0;

        if not TempJobQueueEntry.FindSet then
          exit;

        // Platform work-around because first "Schedule Task" gets userid = nullguid
        JobQueueEntry."Earliest Start Date/Time" := CreateDatetime(99990101D,0T);
        Codeunit.Run(Codeunit::"Job Queue - Enqueue",JobQueueEntry);
        JobQueueEntry.Cancel;

        repeat
          JobQueueEntry := TempJobQueueEntry;
          JobQueueEntry.ID := CreateGuid;
          Codeunit.Run(Codeunit::"Job Queue - Enqueue",JobQueueEntry);
        until TempJobQueueEntry.Next = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnAfterCompanyOpen', '', true, true)]
    local procedure RescheduleJobQueueEntriesOnCompanyOpen()
    var
        JobQueueEntry: Record "Job Queue Entry";
        User: Record User;
        s: Integer;
    begin
        if not GuiAllowed then
          exit;
        if not (JobQueueEntry.WritePermission and JobQueueEntry.ReadPermission) then
          exit;
        if not User.Get(UserSecurityId) then
          exit;

        s := 0;
        if StartSession(s,Codeunit::"Job Queue User Handler") then;
    end;
}

