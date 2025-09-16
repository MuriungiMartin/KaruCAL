#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 248 "VAT Lookup Ext. Data Hndl"
{
    Permissions = TableData "VAT Registration Log"=rimd;
    TableNo = "VAT Registration Log";

    trigger OnRun()
    begin
        VATRegistrationLog := Rec;

        LookupVatRegistrationFromWebService(true);

        Rec := VATRegistrationLog;
    end;

    var
        NamespaceTxt: label 'urn:ec.europa.eu:taxud:vies:services:checkVat:types', Locked=true;
        VATRegistrationLog: Record "VAT Registration Log";
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
        VatRegNrValidationWebServiceURLTxt: label 'http://ec.europa.eu/taxation_customs/vies/services/checkVatService', Locked=true;
        MissingWebServiceURLErr: label 'The Tax Registration No. Validation URL is not specified in the General Ledger Setup window.';

    local procedure LookupVatRegistrationFromWebService(ShowErrors: Boolean)
    var
        RequestBodyTempBlob: Record TempBlob;
    begin
        RequestBodyTempBlob.Init;

        SendRequestToVatRegistrationService(RequestBodyTempBlob,ShowErrors);

        InsertLogEntry(RequestBodyTempBlob);

        Commit;
    end;

    local procedure SendRequestToVatRegistrationService(var BodyTempBlob: Record TempBlob;ShowErrors: Boolean)
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        SOAPWebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        InStream: InStream;
        ResponseOutStream: OutStream;
    begin
        PrepareSOAPRequestBody(BodyTempBlob);

        BodyTempBlob.Blob.CreateInstream(InStream);

        GeneralLedgerSetup.Get;
        if GeneralLedgerSetup."VAT Reg. No. Validation URL" = '' then
          Error(MissingWebServiceURLErr);
        SOAPWebServiceRequestMgt.SetGlobals(InStream,GeneralLedgerSetup."VAT Reg. No. Validation URL",'','');
        SOAPWebServiceRequestMgt.DisableHttpsCheck;
        SOAPWebServiceRequestMgt.SetTimeout(60000);

        if SOAPWebServiceRequestMgt.SendRequestToWebService then begin
          SOAPWebServiceRequestMgt.GetResponseContent(ResponseInStream);

          BodyTempBlob.Blob.CreateOutstream(ResponseOutStream);
          CopyStream(ResponseOutStream,ResponseInStream);
        end else
          if ShowErrors then
            SOAPWebServiceRequestMgt.ProcessFaultResponse('');
    end;

    local procedure PrepareSOAPRequestBody(var BodyTempBlob: Record TempBlob)
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        BodyContentInputStream: InStream;
        BodyContentOutputStream: OutStream;
        BodyContentXmlDoc: dotnet XmlDocument;
        EnvelopeXmlNode: dotnet XmlNode;
        CreatedXmlNode: dotnet XmlNode;
    begin
        BodyTempBlob.Blob.CreateInstream(BodyContentInputStream);
        BodyContentXmlDoc := BodyContentXmlDoc.XmlDocument;

        XMLDOMMgt.AddRootElementWithPrefix(BodyContentXmlDoc,'checkVat','',NamespaceTxt,EnvelopeXmlNode);
        XMLDOMMgt.AddElement(EnvelopeXmlNode,'countryCode',VATRegistrationLog.GetCountryCode,NamespaceTxt,CreatedXmlNode);
        XMLDOMMgt.AddElement(EnvelopeXmlNode,'vatNumber',VATRegistrationLog.GetVATRegNo,NamespaceTxt,CreatedXmlNode);

        Clear(BodyTempBlob.Blob);
        BodyTempBlob.Blob.CreateOutstream(BodyContentOutputStream);
        BodyContentXmlDoc.Save(BodyContentOutputStream);
    end;

    local procedure InsertLogEntry(ResponseBodyTempBlob: Record TempBlob)
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLDocOut: dotnet XmlDocument;
        InStream: InStream;
    begin
        ResponseBodyTempBlob.Blob.CreateInstream(InStream);
        XMLDOMManagement.LoadXMLDocumentFromInStream(InStream,XMLDocOut);

        VATRegistrationLogMgt.LogVerification(VATRegistrationLog,XMLDocOut,NamespaceTxt);
    end;


    procedure GetVATRegNrValidationWebServiceURL(): Text[250]
    begin
        exit(VatRegNrValidationWebServiceURLTxt);
    end;
}

