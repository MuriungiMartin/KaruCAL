#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 137 "OCR Inc. Doc. via Job Queue"
{
    Permissions = TableData "Job Queue Entry"=rimd;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        IncomingDocument: Record "Incoming Document";
        SendIncomingDocumentToOCR: Codeunit "Send Incoming Document to OCR";
        RecRef: RecordRef;
    begin
        TestField("Record ID to Process");
        RecRef.Get("Record ID to Process");
        RecRef.SetTable(IncomingDocument);
        IncomingDocument.Find;
        SetJobQueueStatus(IncomingDocument,IncomingDocument."job queue status"::Processing);

        case IncomingDocument."OCR Status" of
          IncomingDocument."ocr status"::Ready:
            if not SendIncomingDocumentToOCR.TrySendToOCR(IncomingDocument) then begin
              SetJobQueueStatus(IncomingDocument,IncomingDocument."job queue status"::Error);
              Error(GetLastErrorText);
            end;
          IncomingDocument."ocr status"::Sent,IncomingDocument."ocr status"::"Awaiting Verification":
            if not (SendIncomingDocumentToOCR.TryRetrieveFromOCR(IncomingDocument) and
                    (IncomingDocument."OCR Status" = IncomingDocument."ocr status"::Success))
            then begin
              SetJobQueueStatus(IncomingDocument,IncomingDocument."job queue status"::Processing);
              Error(GetLastErrorText);
            end;
        end;

        SetJobQueueStatus(IncomingDocument,IncomingDocument."job queue status"::" ");
    end;

    var
        OCRSendReceiveDescriptionTxt: label 'OCR Incoming Document No. %1.', Comment='%1 = document type, %2 = document number. Example: Post Purchase Order 1234.';
        IncomingDocumentScheduledMsg: label 'Incoming Document No. %1 has been scheduled for OCR.', Comment='%1=document type, %2=number, e.g. Order 123  or Invoice 234.';
        WrongJobQueueStatusErr: label 'Incoming Document No. %1 cannot be processed because it has already been scheduled for OCR. Choose the Remove from Job Queue action to reset the job queue status and then OCR again.', Comment='%1 = document type, %2 = document number. Example: Purchase Order 1234 or Invoice 1234.';

    local procedure SetJobQueueStatus(var IncomingDocument: Record "Incoming Document";NewStatus: Option)
    begin
        IncomingDocument.LockTable;
        if IncomingDocument.Find then begin
          IncomingDocument."Job Queue Status" := NewStatus;
          IncomingDocument.Modify;
          Commit;
        end;
    end;


    procedure EnqueueIncomingDoc(var IncomingDocument: Record "Incoming Document")
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        with IncomingDocument do begin
          if not ("Job Queue Status" in ["job queue status"::" ","job queue status"::Error]) then
            Error(WrongJobQueueStatusErr,"Entry No.");
          if Status = Status::New then
            Codeunit.Run(Codeunit::"Release Incoming Document",IncomingDocument);
          "Job Queue Status" := "job queue status"::Scheduled;
          "Job Queue Entry ID" := CreateGuid;
          Modify;
          JobQueueEntry.ID := "Job Queue Entry ID";
          JobQueueEntry."Object Type to Run" := JobQueueEntry."object type to run"::Codeunit;
          JobQueueEntry."Object ID to Run" := Codeunit::"OCR Inc. Doc. via Job Queue";
          JobQueueEntry."Record ID to Process" := RecordId;
          JobQueueEntry."Job Queue Category Code" := '';
          // Set Timeout to prevent the Job Queue from hanging (eg. as a result of a printer dialog).
          JobQueueEntry."Maximum No. of Attempts to Run" := 10;
          JobQueueEntry."Rerun Delay (sec.)" := 5;
          JobQueueEntry.Priority := 1000;
          JobQueueEntry.Description :=
            CopyStr(StrSubstNo(OCRSendReceiveDescriptionTxt,"Entry No."),1,MaxStrLen(JobQueueEntry.Description));
          JobQueueEntry."Notify On Success" := true;
          Codeunit.Run(Codeunit::"Job Queue - Enqueue",JobQueueEntry);
          Message(IncomingDocumentScheduledMsg,"Entry No.");
        end;
    end;


    procedure CancelQueueEntry(var IncomingDocument: Record "Incoming Document")
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        with IncomingDocument do begin
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

