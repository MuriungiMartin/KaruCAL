#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 135 "Retrieve Document From OCR"
{
    TableNo = "Incoming Document";

    trigger OnRun()
    var
        SendIncomingDocumentToOCR: Codeunit "Send Incoming Document to OCR";
    begin
        SendIncomingDocumentToOCR.RetrieveDocFromOCR(Rec);
    end;
}

