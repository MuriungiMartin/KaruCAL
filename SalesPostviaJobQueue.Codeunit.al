#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 88 "Sales Post via Job Queue"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
        SalesPostPrint: Codeunit "Sales-Post + Print";
        RecRef: RecordRef;
    begin
        TestField("Record ID to Process");
        RecRef.Get("Record ID to Process");
        RecRef.SetTable(SalesHeader);
        SalesHeader.Find;

        SetJobQueueStatus(SalesHeader,SalesHeader."job queue status"::Posting);
        if not Codeunit.Run(Codeunit::"Sales-Post",SalesHeader) then begin
          SetJobQueueStatus(SalesHeader,SalesHeader."job queue status"::Error);
          Error(GetLastErrorText);
        end;
        if SalesHeader."Print Posted Documents" then
          SalesPostPrint.GetReport(SalesHeader);

        SetJobQueueStatus(SalesHeader,SalesHeader."job queue status"::" ");
    end;

    var
        PostDescription: label 'Post Sales %1 %2.', Comment='%1 = document type, %2 = document number. Example: Post Sales Order 1234.';
        PostAndPrintDescription: label 'Post and Print Sales %1 %2.', Comment='%1 = document type, %2 = document number. Example: Post Sales Order 1234.';
        Confirmation: label '%1 %2 has been scheduled for posting.', Comment='%1=document type, %2=number, e.g. Order 123  or Invoice 234.';
        WrongJobQueueStatus: label '%1 %2 cannot be posted because it has already been scheduled for posting. Choose the Remove from Job Queue action to reset the job queue status and then post again.', Comment='%1 = document type, %2 = document number. Example: Sales Order 1234 or Invoice 1234.';

    local procedure SetJobQueueStatus(var SalesHeader: Record "Sales Header";NewStatus: Option)
    begin
        SalesHeader.LockTable;
        if SalesHeader.Find then begin
          SalesHeader."Job Queue Status" := NewStatus;
          SalesHeader.Modify;
          Commit;
        end;
    end;


    procedure EnqueueSalesDoc(var SalesHeader: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        JobQueueEntry: Record "Job Queue Entry";
        TempInvoice: Boolean;
        TempRcpt: Boolean;
        TempShip: Boolean;
    begin
        SalesSetup.Get;
        with SalesHeader do begin
          if not ("Job Queue Status" in ["job queue status"::" ","job queue status"::Error]) then
            Error(WrongJobQueueStatus,"Document Type","No.");
          TempInvoice := Invoice;
          TempRcpt := Receive;
          TempShip := Ship;
          if Status = Status::Open then
            Codeunit.Run(Codeunit::"Release Sales Document",SalesHeader);
          Invoice := TempInvoice;
          Receive := TempRcpt;
          Ship := TempShip;
          "Job Queue Status" := "job queue status"::"Scheduled for Posting";
          "Job Queue Entry ID" := CreateGuid;
          Modify;
          JobQueueEntry.ID := "Job Queue Entry ID";
          JobQueueEntry."Object Type to Run" := JobQueueEntry."object type to run"::Codeunit;
          JobQueueEntry."Object ID to Run" := Codeunit::"Sales Post via Job Queue";
          JobQueueEntry."Record ID to Process" := RecordId;
          JobQueueEntry."Job Queue Category Code" := SalesSetup."Job Queue Category Code";
          if "Print Posted Documents" then begin
            JobQueueEntry.Priority := SalesSetup."Job Q. Prio. for Post & Print";
            JobQueueEntry.Description :=
              CopyStr(StrSubstNo(PostAndPrintDescription,"Document Type","No."),1,MaxStrLen(JobQueueEntry.Description));
          end else begin
            JobQueueEntry.Priority := SalesSetup."Job Queue Priority for Post";
            JobQueueEntry.Description :=
              CopyStr(StrSubstNo(PostDescription,"Document Type","No."),1,MaxStrLen(JobQueueEntry.Description));
          end;
          JobQueueEntry."Notify On Success" := SalesSetup."Notify On Success";
          Codeunit.Run(Codeunit::"Job Queue - Enqueue",JobQueueEntry);
          Message(Confirmation,"Document Type","No.");
        end;
    end;


    procedure CancelQueueEntry(var SalesHeader: Record "Sales Header")
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        with SalesHeader do begin
          if "Job Queue Status" = "job queue status"::" " then
            exit;
          if not IsNullGuid("Job Queue Entry ID") then
            JobQueueEntry.SetRange(ID,"Job Queue Entry ID");
          JobQueueEntry.SetRange("Record ID to Process",RecordId);
          if not JobQueueEntry.IsEmpty then
            JobQueueEntry.DeleteAll(true);
          "Job Queue Status" := "job queue status"::" ";
          Modify;
        end;
    end;
}

