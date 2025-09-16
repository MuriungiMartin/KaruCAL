#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1421 "Doc. Exch. Serv. - Recv. Docs."
{

    trigger OnRun()
    var
        DocExchServiceSetup: Record "Doc. Exch. Service Setup";
        DocExchServiceMgt: Codeunit "Doc. Exch. Service Mgt.";
    begin
        DocExchServiceSetup.Get;
        DocExchServiceMgt.ReceiveDocuments(DocExchServiceSetup.RecordId);
    end;
}

