#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 448 "Job Queue Dispatcher"
{
    Permissions = TableData "Job Queue Entry"=rimd;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if not (Status in [Status::Ready,Status::"In Process"]) then
          exit; // user changed status since it was scheduled.

        if ("Expiration Date/Time" <> 0DT) and ("Expiration Date/Time" < CurrentDatetime) then begin
          Delete;
          exit;
        end;

        if Status <> Status::"In Process" then begin
          LockTable;
          Get(ID);
          Status := Status::"In Process";
          "User Session Started" := CurrentDatetime;
          Modify;
          Commit;
        end;

        if WaitForOthersWithSameCategory(Rec) then begin
          Reschedule(Rec);
          exit;
        end;

        if "Recurring Job" then begin
          "Earliest Start Date/Time" := CalcNextRunTimeForRecurringJob(Rec,CurrentDatetime);
          Modify;
        end;
        Commit;

        HandleRequest(Rec);
    end;

    local procedure HandleRequest(var JobQueueEntry: Record "Job Queue Entry")
    var
        StartDateTime: DateTime;
        LastError: Text;
        WasSuccess: Boolean;
    begin
        StartDateTime := CurrentDatetime;
        // Codeunit.Run is limited during write transactions because one or more tables will be locked.
        // To avoid NavCSideException we have either to add the COMMIT before the call or do not use a returned value.
        Commit;
        WasSuccess := Codeunit.Run(Codeunit::"Job Queue Start Codeunit",JobQueueEntry);
        LastError := GetLastErrorText;
        JobQueueEntry.LockTable;
        // user may have deleted it in the meantime
        if JobQueueEntry.Get(JobQueueEntry.ID) and (JobQueueEntry.Status <> JobQueueEntry.Status::"On Hold") then begin
          if WasSuccess then
            JobQueueEntry.Status := JobQueueEntry.Status::Finished
          else begin
            JobQueueEntry.Status := JobQueueEntry.Status::Error;
            JobQueueEntry.SetErrorMessage(LastError);
          end;
          JobQueueEntry.Modify;
        end;
        InsertLogEntry(JobQueueEntry,StartDateTime);
        Commit;
        if WasSuccess then
          JobQueueEntry.CleanupAfterExecution
        else
          JobQueueEntry.HandleExecutionError;
    end;


    procedure InsertLogEntry(var JobQueueEntry: Record "Job Queue Entry";StartDateTime: DateTime)
    var
        JobQueueLogEntry: Record "Job Queue Log Entry";
    begin
        JobQueueLogEntry.Init;
        JobQueueLogEntry.ID := JobQueueEntry.ID;
        JobQueueLogEntry."User ID" := JobQueueEntry."User ID";
        JobQueueLogEntry."Start Date/Time" := StartDateTime;
        JobQueueLogEntry."End Date/Time" := CurrentDatetime;
        JobQueueLogEntry."Object Type to Run" := JobQueueEntry."Object Type to Run";
        JobQueueLogEntry."Object ID to Run" := JobQueueEntry."Object ID to Run";
        JobQueueLogEntry.Description := JobQueueEntry.Description;
        if JobQueueEntry.Status = JobQueueEntry.Status::Error then begin
          JobQueueLogEntry.Status := JobQueueLogEntry.Status::Error;
          JobQueueLogEntry.SetErrorMessage(JobQueueEntry.GetErrorMessage);
        end else
          JobQueueLogEntry.Status := JobQueueLogEntry.Status::Success;
        JobQueueLogEntry."Processed by User ID" := UserId;
        JobQueueLogEntry."Job Queue Category Code" := JobQueueEntry."Job Queue Category Code";
        JobQueueLogEntry.Insert(true);
    end;

    local procedure WaitForOthersWithSameCategory(var JobQueueEntry: Record "Job Queue Entry"): Boolean
    var
        JobQueueEntry2: Record "Job Queue Entry";
    begin
        if JobQueueEntry."Job Queue Category Code" = '' then
          exit(false);

        JobQueueEntry2.SetFilter(ID,'<>%1',JobQueueEntry.ID);
        JobQueueEntry2.SetRange("Job Queue Category Code",JobQueueEntry."Job Queue Category Code");
        JobQueueEntry2.SetRange(Status,JobQueueEntry2.Status::"In Process");
        exit(not JobQueueEntry2.IsEmpty);
    end;

    local procedure Reschedule(var JobQueueEntry: Record "Job Queue Entry")
    begin
        if JobQueueEntry.Status = JobQueueEntry.Status::"In Process" then begin
          JobQueueEntry.Status := JobQueueEntry.Status::Ready;
          JobQueueEntry."User Session Started" := 0DT;
          Randomize;
          JobQueueEntry."System Task ID" :=
            TaskScheduler.CreateTask(
              Codeunit::"Job Queue Dispatcher",
              Codeunit::"Job Queue Error Handler",
              true,COMPANYNAME,CurrentDatetime + 1000 + Random(3000),JobQueueEntry.RecordId);
          JobQueueEntry.Modify;
        end;
    end;


    procedure CalcNextRunTimeForRecurringJob(var JobQueueEntry: Record "Job Queue Entry";StartingDateTime: DateTime): DateTime
    var
        NewRunDateTime: DateTime;
    begin
        if JobQueueEntry."No. of Minutes between Runs" > 0 then
          NewRunDateTime := StartingDateTime + 60000 * JobQueueEntry."No. of Minutes between Runs"
        else
          NewRunDateTime := CreateDatetime(Dt2Date(StartingDateTime) + 1,0T);

        exit(CalcRunTimeForRecurringJob(JobQueueEntry,NewRunDateTime));
    end;


    procedure CalcInitialRunTime(var JobQueueEntry: Record "Job Queue Entry";StartingDateTime: DateTime): DateTime
    var
        EarliestPossibleRunTime: DateTime;
    begin
        if (JobQueueEntry."Earliest Start Date/Time" <> 0DT) and (JobQueueEntry."Earliest Start Date/Time" > StartingDateTime) then
          EarliestPossibleRunTime := JobQueueEntry."Earliest Start Date/Time"
        else
          EarliestPossibleRunTime := StartingDateTime;

        if JobQueueEntry."Recurring Job" then
          exit(CalcRunTimeForRecurringJob(JobQueueEntry,EarliestPossibleRunTime));

        exit(EarliestPossibleRunTime);
    end;

    local procedure CalcRunTimeForRecurringJob(var JobQueueEntry: Record "Job Queue Entry";StartingDateTime: DateTime): DateTime
    var
        NewRunDateTime: DateTime;
        RunOnDate: array [7] of Boolean;
        StartingWeekDay: Integer;
        NoOfExtraDays: Integer;
        NoOfDays: Integer;
        Found: Boolean;
    begin
        JobQueueEntry.TestField("Recurring Job");
        RunOnDate[7] := JobQueueEntry."Run on Sundays";
        RunOnDate[1] := JobQueueEntry."Run on Mondays";
        RunOnDate[2] := JobQueueEntry."Run on Tuesdays";
        RunOnDate[3] := JobQueueEntry."Run on Wednesdays";
        RunOnDate[4] := JobQueueEntry."Run on Thursdays";
        RunOnDate[5] := JobQueueEntry."Run on Fridays";
        RunOnDate[6] := JobQueueEntry."Run on Saturdays";

        NewRunDateTime := StartingDateTime;
        NoOfDays := 0;
        if (JobQueueEntry."Ending Time" <> 0T) and (NewRunDateTime > JobQueueEntry.GetEndingDateTime(NewRunDateTime)) then begin
          NewRunDateTime := JobQueueEntry.GetStartingDateTime(NewRunDateTime);
          NoOfDays := NoOfDays + 1;
        end;

        StartingWeekDay := Date2dwy(Dt2Date(StartingDateTime),1);
        Found := RunOnDate[(StartingWeekDay - 1 + NoOfDays) MOD 7 + 1];
        while not Found and (NoOfExtraDays < 7) do begin
          NoOfExtraDays := NoOfExtraDays + 1;
          NoOfDays := NoOfDays + 1;
          Found := RunOnDate[(StartingWeekDay - 1 + NoOfDays) MOD 7 + 1];
        end;

        if (JobQueueEntry."Starting Time" <> 0T) and (NewRunDateTime < JobQueueEntry.GetStartingDateTime(NewRunDateTime)) then
          NewRunDateTime := JobQueueEntry.GetStartingDateTime(NewRunDateTime);

        if (NoOfDays > 0) and (NewRunDateTime > JobQueueEntry.GetStartingDateTime(NewRunDateTime)) then
          NewRunDateTime := JobQueueEntry.GetStartingDateTime(NewRunDateTime);

        if (JobQueueEntry."Starting Time" = 0T) and (NoOfExtraDays > 0) and (JobQueueEntry."No. of Minutes between Runs" <> 0) then
          NewRunDateTime := CreateDatetime(Dt2Date(NewRunDateTime),0T);

        if Found then
          NewRunDateTime := CreateDatetime(Dt2Date(NewRunDateTime) + NoOfDays,Dt2Time(NewRunDateTime));

        exit(NewRunDateTime);
    end;
}

