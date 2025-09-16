#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1288 "Imp. Bank Conv. Ext. Data Hndl"
{
    Permissions = TableData "Bank Data Conv. Service Setup"=r,
                  TableData "Service Password"=r;
    TableNo = "Data Exch.";

    trigger OnRun()
    var
        TempBankStmtTempBlob: Record TempBlob temporary;
        FileMgt: Codeunit "File Management";
    begin
        "File Name" :=
          CopyStr(FileMgt.BLOBImportWithFilter(TempBankStmtTempBlob,ImportBankStmtTxt,'',FileFilterTxt,FileFilterExtensionTxt),1,250);
        if "File Name" = '' then
          exit;

        ConvertBankStatementToFormat(TempBankStmtTempBlob,Rec);
    end;

    var
        NoRequestBodyErr: label 'The request body is not set.';
        FileFilterTxt: label 'All Files(*.*)|*.*|XML Files(*.xml)|*.xml|Text Files(*.txt;*.csv;*.asc)|*.txt;*.csv;*.asc';
        FileFilterExtensionTxt: label 'txt,csv,asc,xml', Locked=true;
        FinstaNotCollectedErr: label 'The bank data conversion service has not returned any statement transactions.\\For more information, go to %1.';
        ResponseNodeTxt: label 'reportExportResponse', Locked=true;
        ImportBankStmtTxt: label 'Select a file to import.';
        BankDataConvServSysErr: label 'The bank data conversion service has returned the following error message:';
        AddnlInfoTxt: label 'For more information, go to %1.';
        BankDataConvServMgt: Codeunit "Bank Data Conv. Serv. Mgt.";


    procedure ConvertBankStatementToFormat(var TempBankStatementTempBlob: Record TempBlob temporary;var DataExch: Record "Data Exch.")
    var
        TempResultTempBlob: Record TempBlob temporary;
    begin
        SendDataToConversionService(TempResultTempBlob,TempBankStatementTempBlob);
        DataExch."File Content" := TempResultTempBlob.Blob;
    end;

    local procedure SendDataToConversionService(var TempStatementTempBlob: Record TempBlob temporary;var TempBodyTempBlob: Record TempBlob temporary)
    var
        BankDataConvServiceSetup: Record "Bank Data Conv. Service Setup";
        SOAPWebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        InStream: InStream;
    begin
        BankDataConvServMgt.CheckCredentials;

        if not TempBodyTempBlob.Blob.Hasvalue then
          Error(NoRequestBodyErr);

        PrepareSOAPRequestBody(TempBodyTempBlob);

        BankDataConvServiceSetup.Get;

        TempBodyTempBlob.Blob.CreateInstream(InStream);

        SOAPWebServiceRequestMgt.SetGlobals(InStream,
          BankDataConvServiceSetup."Service URL",BankDataConvServiceSetup.GetUserName,BankDataConvServiceSetup.GetPassword);

        if not SOAPWebServiceRequestMgt.SendRequestToWebService then
          SOAPWebServiceRequestMgt.ProcessFaultResponse(StrSubstNo(AddnlInfoTxt,BankDataConvServiceSetup."Support URL"));

        SOAPWebServiceRequestMgt.GetResponseContent(ResponseInStream);

        CheckIfErrorsOccurred(ResponseInStream);

        ReadContentFromResponse(TempStatementTempBlob,ResponseInStream);
    end;

    local procedure PrepareSOAPRequestBody(var TempBodyTempBlob: Record TempBlob temporary)
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        BodyContentOutputStream: OutStream;
        BodyContentXmlDoc: dotnet XmlDocument;
        EnvelopeXmlNode: dotnet XmlNode;
        HeaderXmlNode: dotnet XmlNode;
        PackXmlNode: dotnet XmlNode;
        DataXmlNode: dotnet XmlNode;
        MsgTypeXmlNode: dotnet XmlNode;
    begin
        BodyContentXmlDoc := BodyContentXmlDoc.XmlDocument;

        with XMLDOMMgt do begin
          AddRootElementWithPrefix(BodyContentXmlDoc,'reportExport','',BankDataConvServMgt.GetNamespace,EnvelopeXmlNode);

          AddElementWithPrefix(EnvelopeXmlNode,'amcreportreq','','','',HeaderXmlNode);
          AddAttribute(HeaderXmlNode,'xmlns','');

          AddElementWithPrefix(HeaderXmlNode,'pack','','','',PackXmlNode);

          AddNode(PackXmlNode,'journalnumber',DelChr(Lowercase(Format(CreateGuid)),'=','{}'));
          AddElementWithPrefix(PackXmlNode,'data',EncodeBankStatementFile(TempBodyTempBlob),'','',DataXmlNode);

          AddElementWithPrefix(EnvelopeXmlNode,'messagetype','finsta','','',MsgTypeXmlNode);
        end;

        Clear(TempBodyTempBlob.Blob);
        TempBodyTempBlob.Blob.CreateOutstream(BodyContentOutputStream);
        BodyContentXmlDoc.Save(BodyContentOutputStream);
    end;

    local procedure EncodeBankStatementFile(TempBodyTempBlob: Record TempBlob temporary): Text
    var
        FileMgt: Codeunit "File Management";
        Convert: dotnet Convert;
        File: dotnet File;
        FileName: Text;
    begin
        FileName := FileMgt.ServerTempFileName('txt');
        FileMgt.BLOBExportToServerFile(TempBodyTempBlob,FileName);
        exit(Convert.ToBase64String(File.ReadAllBytes(FileName)));
    end;

    local procedure CheckIfErrorsOccurred(var ResponseInStream: InStream)
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        ResponseXmlDoc: dotnet XmlDocument;
    begin
        XMLDOMManagement.LoadXMLDocumentFromInStream(ResponseInStream,ResponseXmlDoc);

        if ResponseHasErrors(ResponseXmlDoc) then
          DisplayErrorFromResponse(ResponseXmlDoc);
    end;

    local procedure ResponseHasErrors(ResponseXmlDoc: dotnet XmlDocument): Boolean
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        XmlNode: dotnet XmlNode;
    begin
        exit(XMLDOMMgt.FindNodeWithNamespace(ResponseXmlDoc.DocumentElement,
            BankDataConvServMgt.GetErrorXPath(ResponseNodeTxt),'amc',BankDataConvServMgt.GetNamespace,XmlNode));
    end;

    local procedure DisplayErrorFromResponse(ResponseXmlDoc: dotnet XmlDocument)
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        XMLNodeList: dotnet XmlNodeList;
        Found: Boolean;
        ErrorText: Text;
        i: Integer;
    begin
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

    local procedure ReadContentFromResponse(var TempStatementTempBlob: Record TempBlob temporary;ResponseInStream: InStream)
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        FinstaXmlNode: dotnet XmlNode;
        ResponseXmlDoc: dotnet XmlDocument;
        ResponseOutStream: OutStream;
        Found: Boolean;
    begin
        XMLDOMMgt.LoadXMLDocumentFromInStream(ResponseInStream,ResponseXmlDoc);

        Found := XMLDOMMgt.FindNodeWithNamespace(ResponseXmlDoc.DocumentElement,
            BankDataConvServMgt.GetFinstaXPath(ResponseNodeTxt),'amc',BankDataConvServMgt.GetNamespace,FinstaXmlNode);
        if not Found then
          Error(FinstaNotCollectedErr,BankDataConvServMgt.GetSupportURL(FinstaXmlNode));

        TempStatementTempBlob.Blob.CreateOutstream(ResponseOutStream);
        CopyStream(ResponseOutStream,ResponseInStream);
    end;
}

