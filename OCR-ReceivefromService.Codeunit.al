#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 881 "OCR - Receive from Service"
{

    trigger OnRun()
    var
        IncomingDocument: Record "Incoming Document";
        JobQueueEntry: Record "Job Queue Entry";
    begin
        GetDocuments;
        IncomingDocument.SetFilter(
          "OCR Status",'%1|%2',
          IncomingDocument."ocr status"::Sent,
          IncomingDocument."ocr status"::"Awaiting Verification");
        if IncomingDocument.IsEmpty then
          if JobQueueEntry.FindJobQueueEntry(
               JobQueueEntry."object type to run"::Codeunit,Codeunit::"OCR - Receive from Service")
          then
            JobQueueEntry.SetStatus(JobQueueEntry.Status::"On Hold");
    end;

    var
        DownloadCountMsg: label '%1 documents have been received.', Comment='%1 = a number, e.g. 0, 1, 4.';
        AwaitingCountMsg: label 'You have %1 documents that require you to manually verify the OCR values before the documents can be received.', Comment='%1 = a number, e.g. 0, 1, 4.';


    procedure GetDocuments()
    var
        IncomingDocument: Record "Incoming Document";
        OCRServiceMgt: Codeunit "OCR Service Mgt.";
        ResultMsg: Text;
        DownloadedDocCount: Integer;
        AwaitingDocCount: Integer;
    begin
        DownloadedDocCount := OCRServiceMgt.GetDocuments('');

        IncomingDocument.SetRange("OCR Status",IncomingDocument."ocr status"::"Awaiting Verification");
        AwaitingDocCount := IncomingDocument.Count;

        ResultMsg := StrSubstNo(DownloadCountMsg,DownloadedDocCount);
        if AwaitingDocCount > 0 then
          ResultMsg := StrSubstNo('%1\\%2',ResultMsg,StrSubstNo(AwaitingCountMsg,AwaitingDocCount));
        Message(ResultMsg);
    end;
}

