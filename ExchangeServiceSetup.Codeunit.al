#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5324 "Exchange Service Setup"
{

    trigger OnRun()
    begin
    end;


    procedure Store(ClientID: Guid;CertificateThumbprint: Text[40];AuthenticationEndpoint: Text[250];ExchangeEndpoint: Text[250];ExchangeResourceUri: Text[250])
    var
        ExchangeServiceSetup: Record "Exchange Service Setup";
    begin
        ExchangeServiceSetup.Init;
        ExchangeServiceSetup."Azure AD App. ID" := ClientID;
        ExchangeServiceSetup."Azure AD App. Cert. Thumbprint" := CertificateThumbprint;
        ExchangeServiceSetup."Azure AD Auth. Endpoint" := AuthenticationEndpoint;
        ExchangeServiceSetup."Exchange Service Endpoint" := ExchangeEndpoint;
        ExchangeServiceSetup."Exchange Resource Uri" := ExchangeResourceUri;
        if not ExchangeServiceSetup.Insert then
          ExchangeServiceSetup.Modify;
    end;
}

