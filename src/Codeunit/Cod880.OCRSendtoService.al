#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 880 "OCR - Send to Service"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        SendAllReadyToOcr;
    end;

    var
        SendMsg: label 'Sending to the OCR Service @1@@@@@@@@@@@@@@@@@@@.';
        SendDoneMsg: label '%1 documents have been sent to the OCR service.', Comment='%1 is a number, e.g. 1';


    procedure SendAllReadyToOcr()
    var
        IncomingDocument: Record "Incoming Document";
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        TempIncomingDocumentAttachment: Record "Incoming Document Attachment" temporary;
        OCRServiceMgt: Codeunit "OCR Service Mgt.";
        IncDocAttsReadyforOCR: Query "Inc. Doc. Atts. Ready for OCR";
        Window: Dialog;
        NoOfDocuments: Integer;
        i: Integer;
    begin
        if not IncDocAttsReadyforOCR.Open then
          exit;  // empty

        Window.Open(SendMsg);

        // Find Document Count and lock records
        IncomingDocument.LockTable;
        IncomingDocumentAttachment.LockTable;
        while IncDocAttsReadyforOCR.Read do begin
          NoOfDocuments += 1;
          IncomingDocumentAttachment.Get(IncDocAttsReadyforOCR.Incoming_Document_Entry_No,IncDocAttsReadyforOCR.Line_No);
          IncomingDocument.Get(IncomingDocumentAttachment."Incoming Document Entry No.");  // lock
          TempIncomingDocumentAttachment := IncomingDocumentAttachment;
          TempIncomingDocumentAttachment.Insert;
        end;
        IncDocAttsReadyforOCR.Close;
        // Release locks
        Commit;

        if NoOfDocuments = 0 then
          exit;

        OCRServiceMgt.StartUpload(NoOfDocuments);

        TempIncomingDocumentAttachment.FindSet;
        repeat
          i += 1;
          Window.Update(1,10000 * i DIV NoOfDocuments);
          IncomingDocument.Get(TempIncomingDocumentAttachment."Incoming Document Entry No.");
          IncomingDocument.SendToOCR(false);
        until TempIncomingDocumentAttachment.Next = 0;

        Commit;
        Window.Close;
        Message(SendDoneMsg,NoOfDocuments);
    end;
}

