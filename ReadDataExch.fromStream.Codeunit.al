#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1413 "Read Data Exch. from Stream"
{
    TableNo = "Data Exch.";

    trigger OnRun()
    var
        TempBlob: Record TempBlob temporary;
        EventHandled: Boolean;
    begin
        // Fire the get stream event
        OnGetDataExchFileContentEvent(Rec,TempBlob,EventHandled);

        if EventHandled then begin
          "File Name" := 'Data Stream';
          "File Content" := TempBlob.Blob;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetDataExchFileContentEvent(DataExchIdentifier: Record "Data Exch.";var TempBlobResponse: Record TempBlob temporary;var Handled: Boolean)
    begin
        // Event that will return the data stream from the identified subscriber
    end;
}

