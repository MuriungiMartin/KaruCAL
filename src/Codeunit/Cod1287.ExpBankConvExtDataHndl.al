#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1287 "Exp. Bank Conv. Ext. Data Hndl"
{
    Permissions = TableData "Data Exch."=rimd,
                  TableData "Bank Data Conv. Service Setup"=r,
                  TableData "Service Password"=r;
    TableNo = "Data Exch.";

    trigger OnRun()
    var
        TempPaymentFileTempBlob: Record TempBlob temporary;
        FileMgt: Codeunit "File Management";
    begin
        ConvertPaymentDataToFormat(TempPaymentFileTempBlob,Rec);

        if FileMgt.BLOBExport(TempPaymentFileTempBlob,"Data Exch. Def Code" + TxtExtTok,true) = '' then
          Error(DownloadFromStreamErr);

        Get("Entry No.");
        "File Content" := TempPaymentFileTempBlob.Blob;
        Modify;
    end;

    var
        BodyContentErr: label 'The %1 XML tag was not found, or was found more than once in the body content of the SOAP request.', Comment='%1=XmlTag';
        DownloadFromStreamErr: label 'The file has not been saved.';
        NoRequestBodyErr: label 'The request body is not set.';
        NothingToExportErr: label 'There is nothing to export.';
        PaymentDataNotCollectedErr: label 'The bank data conversion service has not returned any payment data.\\For more information, go to %1.';
        ResponseNodeTxt: label 'paymentExportBankResponse', Locked=true;
        HasErrorsErr: label 'The bank data conversion service has found one or more errors.\\For each line to be exported, resolve the errors that are displayed in the FactBox.\\Choose an error to see more information.';
        IncorrectElementErr: label 'There is an incorrect file conversion error element in the response. Reference: %1, error text: %2.';
        BankDataConvServSysErr: label 'The bank data conversion service has returned the following error message:';
        AddnlInfoTxt: label 'For more information, go to %1.';
        BankDataConvServMgt: Codeunit "Bank Data Conv. Serv. Mgt.";
        TxtExtTok: label '.txt', Locked=true;


    procedure ConvertPaymentDataToFormat(var TempPaymentFileTempBlob: Record TempBlob temporary;DataExch: Record "Data Exch.")
    var
        TempRequestBodyTempBlob: Record TempBlob temporary;
    begin
        if not DataExch."File Content".Hasvalue then
          Error(NoRequestBodyErr);

        TempRequestBodyTempBlob.Init;
        TempRequestBodyTempBlob.Blob := DataExch."File Content";

        SendDataToConversionService(TempPaymentFileTempBlob,TempRequestBodyTempBlob,DataExch."Entry No.");

        if not TempPaymentFileTempBlob.Blob.Hasvalue then
          Error(NothingToExportErr);
    end;

    local procedure SendDataToConversionService(var TempPaymentFileTempBlob: Record TempBlob temporary;var TempBodyTempBlob: Record TempBlob temporary;DataExchEntryNo: Integer)
    var
        BankDataConvServiceSetup: Record "Bank Data Conv. Service Setup";
        SOAPWebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        BodyInStream: InStream;
        ResponseInStream: InStream;
    begin
        BankDataConvServMgt.CheckCredentials;

        PrepareSOAPRequestBody(TempBodyTempBlob);

        TempBodyTempBlob.Blob.CreateInstream(BodyInStream);

        BankDataConvServiceSetup.Get;

        SOAPWebServiceRequestMgt.SetGlobals(BodyInStream,
          BankDataConvServiceSetup."Service URL",BankDataConvServiceSetup.GetUserName,BankDataConvServiceSetup.GetPassword);

        if not SOAPWebServiceRequestMgt.SendRequestToWebService then
          SOAPWebServiceRequestMgt.ProcessFaultResponse(StrSubstNo(AddnlInfoTxt,BankDataConvServiceSetup."Support URL"));

        SOAPWebServiceRequestMgt.GetResponseContent(ResponseInStream);

        CheckIfErrorsOccurred(ResponseInStream,DataExchEntryNo);

        ReadContentFromResponse(TempPaymentFileTempBlob,ResponseInStream);
    end;

    local procedure PrepareSOAPRequestBody(var TempBodyTempBlob: Record TempBlob temporary)
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        BodyContentInputStream: InStream;
        BodyContentOutputStream: OutStream;
        BodyContentXmlDoc: dotnet XmlDocument;
    begin
        TempBodyTempBlob.Blob.CreateInstream(BodyContentInputStream);
        XMLDOMManagement.LoadXMLDocumentFromInStream(BodyContentInputStream,BodyContentXmlDoc);

        AddNamespaceAttribute(BodyContentXmlDoc,'amcpaymentreq');
        AddNamespaceAttribute(BodyContentXmlDoc,'bank');
        AddNamespaceAttribute(BodyContentXmlDoc,'language');

        Clear(TempBodyTempBlob.Blob);
        TempBodyTempBlob.Blob.CreateOutstream(BodyContentOutputStream);
        BodyContentXmlDoc.Save(BodyContentOutputStream);
    end;

    local procedure AddNamespaceAttribute(var XmlDoc: dotnet XmlDocument;ElementTag: Text)
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        XmlNode: dotnet XmlNode;
        XMLNodeList: dotnet XmlNodeList;
    begin
        XMLNodeList := XmlDoc.GetElementsByTagName(ElementTag);
        if XMLNodeList.Count <> 1 then
          Error(BodyContentErr,ElementTag);

        XmlNode := XMLNodeList.Item(0);
        if IsNull(XmlNode) then
          Error(BodyContentErr,ElementTag);
        XMLDOMMgt.AddAttribute(XmlNode,'xmlns','');
    end;

    local procedure CheckIfErrorsOccurred(var ResponseInStream: InStream;DataExchEntryNo: Integer)
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        ResponseXmlDoc: dotnet XmlDocument;
    begin
        XMLDOMManagement.LoadXMLDocumentFromInStream(ResponseInStream,ResponseXmlDoc);

        if ResponseHasErrors(ResponseXmlDoc) then
          DisplayErrorFromResponse(ResponseXmlDoc,DataExchEntryNo);
    end;

    local procedure ResponseHasErrors(ResponseXmlDoc: dotnet XmlDocument): Boolean
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        XmlNode: dotnet XmlNode;
    begin
        exit(XMLDOMMgt.FindNodeWithNamespace(ResponseXmlDoc.DocumentElement,
            BankDataConvServMgt.GetHeaderErrXPath(ResponseNodeTxt),'amc',BankDataConvServMgt.GetNamespace,XmlNode));
    end;

    local procedure DisplayErrorFromResponse(ResponseXmlDoc: dotnet XmlDocument;DataExchEntryNo: Integer)
    var
        GenJnlLine: Record "Gen. Journal Line";
        XMLDOMMgt: Codeunit "XML DOM Management";
        XMLNodeList: dotnet XmlNodeList;
        Found: Boolean;
        ErrorText: Text;
        i: Integer;
    begin
        Found := XMLDOMMgt.FindNodesWithNamespace(ResponseXmlDoc.DocumentElement,
            BankDataConvServMgt.GetConvErrXPath(ResponseNodeTxt),'amc',BankDataConvServMgt.GetNamespace,XMLNodeList);
        if Found then begin
          for i := 1 to XMLNodeList.Count do
            InsertPaymentFileError(XMLNodeList.Item(i - 1),DataExchEntryNo);

          GenJnlLine.SetRange("Data Exch. Entry No.",DataExchEntryNo);
          GenJnlLine.FindFirst;
          if GenJnlLine.HasPaymentFileErrorsInBatch then begin
            Commit;
            Error(HasErrorsErr);
          end;
        end;

        Found := XMLDOMMgt.FindNodesWithNamespace(ResponseXmlDoc.DocumentElement,
            BankDataConvServMgt.GetErrorXPath(ResponseNodeTxt),'amc',BankDataConvServMgt.GetNamespace,XMLNodeList);

        if Found then begin
          ErrorText := BankDataConvServSysErr;
          for i := 1 to XMLNodeList.Count do
            ErrorText += '\\' + XMLDOMMgt.FindNodeText(XMLNodeList.Item(i - 1),'text') + '\' +
              XMLDOMMgt.FindNodeText(XMLNodeList.Item(i - 1),'hinttext') + '\\' +
              StrSubstNo(AddnlInfoTxt,BankDataConvServMgt.GetSupportURL(XMLNodeList.Item(i - 1)));

          Error(ErrorText);
        end;
    end;

    local procedure InsertPaymentFileError(XmlNode: dotnet XmlNode;DataExchEntryNo: Integer)
    var
        PaymentExportData: Record "Payment Export Data";
        GenJnlLine: Record "Gen. Journal Line";
        XMLDOMMgt: Codeunit "XML DOM Management";
        PaymentLineId: Text;
        ErrorText: Text;
        HintText: Text;
        SupportURL: Text;
    begin
        PaymentLineId := XMLDOMMgt.FindNodeText(XmlNode,'referenceid');
        ErrorText := XMLDOMMgt.FindNodeText(XmlNode,'text');
        HintText := XMLDOMMgt.FindNodeText(XmlNode,'hinttext');
        SupportURL := BankDataConvServMgt.GetSupportURL(XmlNode);

        if (ErrorText = '') or (PaymentLineId = '') then
          Error(IncorrectElementErr,PaymentLineId,ErrorText);

        with PaymentExportData do begin
          SetRange("Data Exch Entry No.",DataExchEntryNo);
          SetRange("End-to-End ID",PaymentLineId);
          if FindFirst then begin
            GenJnlLine.Get("General Journal Template","General Journal Batch Name","General Journal Line No.");
            GenJnlLine.InsertPaymentFileErrorWithDetails(ErrorText,HintText,SupportURL);
          end else begin
            SetRange("End-to-End ID");
            SetRange("Payment Information ID",PaymentLineId);
            if not FindFirst then
              Error(IncorrectElementErr,PaymentLineId,ErrorText);
            GenJnlLine.Get("General Journal Template","General Journal Batch Name","General Journal Line No.");
            GenJnlLine.InsertPaymentFileErrorWithDetails(ErrorText,HintText,SupportURL);
          end;
        end;
    end;

    local procedure ReadContentFromResponse(var TempPaymentFileTempBlob: Record TempBlob temporary;ResponseInStream: InStream)
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        DataXmlNode: dotnet XmlNode;
        ResponseXmlDoc: dotnet XmlDocument;
        Found: Boolean;
    begin
        XMLDOMMgt.LoadXMLDocumentFromInStream(ResponseInStream,ResponseXmlDoc);

        Found := XMLDOMMgt.FindNodeWithNamespace(ResponseXmlDoc.DocumentElement,
            BankDataConvServMgt.GetDataXPath(ResponseNodeTxt),'amc',BankDataConvServMgt.GetNamespace,DataXmlNode);
        if not Found then
          Error(PaymentDataNotCollectedErr,BankDataConvServMgt.GetSupportURL(DataXmlNode));

        DecodePaymentData(TempPaymentFileTempBlob,DataXmlNode.Value);
    end;

    local procedure DecodePaymentData(var TempPaymentFileTempBlob: Record TempBlob temporary;Base64String: Text)
    var
        FileMgt: Codeunit "File Management";
        Convert: dotnet Convert;
        File: dotnet File;
        FileName: Text;
    begin
        FileName := FileMgt.ServerTempFileName('txt');
        File.WriteAllBytes(FileName,Convert.FromBase64String(Base64String));
        FileMgt.BLOBImportFromServerFile(TempPaymentFileTempBlob,FileName);
    end;
}

