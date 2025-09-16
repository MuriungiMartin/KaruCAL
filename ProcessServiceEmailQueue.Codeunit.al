#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5917 "Process Service Email Queue"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        ServEmailQueue: Record "Service Email Queue";
        ServEmailQueue2: Record "Service Email Queue";
        ServMailMgt: Codeunit ServMailManagement;
        RecRef: RecordRef;
        Success: Boolean;
    begin
        if RecRef.Get("Record ID to Process") then begin
          RecRef.SetTable(ServEmailQueue);
          if not ServEmailQueue.Find then
            exit;
          ServEmailQueue.SetRecfilter;
        end else begin
          ServEmailQueue.Reset;
          ServEmailQueue.SetCurrentkey(Status,"Sending Date","Document Type","Document No.");
          ServEmailQueue.SetRange(Status,ServEmailQueue.Status::" ");
        end;
        ServEmailQueue.LockTable;
        if ServEmailQueue.FindSet then
          repeat
            Clear(ServMailMgt);
            Success := ServMailMgt.Run(ServEmailQueue);
            ServEmailQueue2.Get(ServEmailQueue."Entry No.");
            if Success then
              ServEmailQueue2.Status := ServEmailQueue2.Status::Processed
            else
              ServEmailQueue2.Status := ServEmailQueue2.Status::Error;
            ServEmailQueue2.Modify;
            Commit;
            Sleep(200);
          until ServEmailQueue.Next = 0;
    end;
}

