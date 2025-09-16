#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1294 "OCR Service Mgt."
{
    Permissions = TableData "Bank Data Conv. Service Setup"=r;

    trigger OnRun()
    begin
    end;

    var
        MissingCredentialsQst: label '%1\ Do you want to open %2 to specify the missing values?', Comment='%1=error message. %2=OCR Service Setup';
        MissingCredentialsErr: label 'You must fill the User Name, Password, and Authorization Key fields.', Comment='%1 = OCR Service Setup';
        OCRServiceSetup: Record "OCR Service Setup";
        AuthCookie: dotnet Cookie;
        ConnectionSuccessMsg: label 'Connection succeeded.';
        ConnectionFailedErr: label 'The connection failed. Check that the User Name, Password, and Authorization Key fields are filled correctly.';
        NoFileContentErr: label 'The file is empty.';
        InitiateUploadMsg: label 'Initiate document upload.';
        GetDocumentConfirmMsg: label 'Acknowledge document receipt.';
        DocumentDownloadedTxt: label 'Downloaded %1', Comment='%1 = Document Identifier (usually a guid)';
        UploadFileMsg: label 'Send to OCR service.';
        AuthenticateMsg: label 'Log in to OCR service.';
        GetNewDocumentsMsg: label 'Get received OCR documents.';
        GetDocumentMsg: label 'Receive OCR document.';
        UploadFileFailedMsg: label 'The document failed to upload. Service Error: %1', Comment='%1 = Response from OCR service, this will probably be an XML string';
        UploadTotalSuccessMsg: label 'Notify OCR service that %1 documents are ready for upload.', Comment='%1 = Number of documents to be uploaded';
        NewDocumentsTotalMsg: label 'Downloaded %1 documents', Comment='%1 = Number of documents downloaded (e.g. 5)';
        ImportSuccessMsg: label 'The document was successfully received.';
        DocumentNotReadyMsg: label 'The document cannot be received yet. Try again in a few moments.';
        NotUploadedErr: label 'You must upload the image first.';
        NotValidDocIDErr: label 'Received document ID %1 contains invalid characters.', Comment='%1 is the value.';
        LoggingConstTxt: label 'OCR Service';
        UploadSuccessMsg: label 'The document was successfully sent to the OCR service.';
        NoOCRDataCorrectionMsg: label 'You have made no OCR data corrections.';
        VerifyMsg: label 'The document is awaiting your manual verification on’ the OCR service site.\\Choose the Awaiting Verification link in the OCR Status field.';
        FailedMsg: label 'The document failed to be processed.';


    procedure SetURLsToDefaultRSO(var OCRServiceSetup: Record "OCR Service Setup")
    begin
        OCRServiceSetup."Sign-up URL" := 'https://store.readsoftonline.com/nav';
        OCRServiceSetup."Service URL" := 'https://services.readsoftonline.com';
        OCRServiceSetup."Sign-in URL" := 'https://nav.readsoftonline.com';
    end;


    procedure CheckCredentials()
    var
        OCRServiceSetup: Record "OCR Service Setup";
    begin
        with OCRServiceSetup do begin
          if not HasCredentials(OCRServiceSetup) then
            if Confirm(StrSubstNo(GetCredentialsQstText),true) then begin
              Commit;
              Page.RunModal(Page::"OCR Service Setup",OCRServiceSetup);
            end;

          if not HasCredentials(OCRServiceSetup) then
            Error(GetCredentialsErrText);
        end;
    end;

    local procedure HasCredentials(OCRServiceSetup: Record "OCR Service Setup"): Boolean
    begin
        with OCRServiceSetup do
          exit(
            Get and
            HasPassword("Password Key") and
            HasPassword("Authorization Key") and
            ("User Name" <> ''));
    end;


    procedure GetCredentialsErrText(): Text
    begin
        exit(MissingCredentialsErr);
    end;


    procedure GetCredentialsQstText(): Text
    var
        OCRServiceSetup: Record "OCR Service Setup";
    begin
        exit(StrSubstNo(MissingCredentialsQst,GetCredentialsErrText,OCRServiceSetup.TableCaption));
    end;


    procedure Authenticate(): Boolean
    var
        ResponseString: Text;
    begin
        if not TryAuthenticate(ResponseString) then
          exit(false);

        if StrPos(ResponseString,'<Status>Success</Status>') < 1 then
          LogActivityFailed(OCRServiceSetup.RecordId,AuthenticateMsg,ConnectionFailedErr)
        else
          LogActivitySucceeded(OCRServiceSetup.RecordId,AuthenticateMsg,'');

        exit(true);
    end;

    [TryFunction]
    local procedure TryAuthenticate(var ResponseString: Text)
    var
        TempBlob: Record TempBlob;
        HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        HttpStatusCode: dotnet HttpStatusCode;
        ResponseHeaders: dotnet NameValueCollection;
        InStr: InStream;
    begin
        GetOcrServiceSetup(false);
        HttpWebRequestMgt.Initialize(StrSubstNo('%1/authentication/rest/authenticate',OCRServiceSetup."Service URL"));
        HttpWebRequestMgt.DisableUI;
        RsoAddHeaders(HttpWebRequestMgt);
        HttpWebRequestMgt.SetMethod('POST');
        HttpWebRequestMgt.AddBodyAsText(
          StrSubstNo(
            '<AuthenticationCredentials><UserName>%1</UserName><Password>%2</Password>' +
            '<AuthenticationType>SetCookie</AuthenticationType></AuthenticationCredentials>',
            OCRServiceSetup."User Name",OCRServiceSetup.GetPassword(OCRServiceSetup."Password Key")));
        TempBlob.Init;
        TempBlob.Blob.CreateInstream(InStr);
        HttpWebRequestMgt.GetResponse(InStr,HttpStatusCode,ResponseHeaders);
        InStr.ReadText(ResponseString);
        HttpWebRequestMgt.GetCookie(AuthCookie);
    end;


    procedure UpdateOrganizationInfo(var OCRServiceSetup: Record "OCR Service Setup")
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLRootNode: dotnet XmlNode;
        XMLNode: dotnet XmlNode;
        ResponseStr: InStream;
    begin
        if not RsoGetRequest('accounts/rest/currentcustomer',ResponseStr) then
          Error(GetLastErrorText);
        XMLDOMManagement.LoadXMLNodeFromInStream(ResponseStr,XMLRootNode);
        if XMLDOMManagement.FindNode(XMLRootNode,'Id',XMLNode) then
          OCRServiceSetup."Customer ID" := CopyStr(XMLNode.InnerText,1,MaxStrLen(OCRServiceSetup."Customer ID"));
        if XMLDOMManagement.FindNode(XMLRootNode,'Name',XMLNode) then
          OCRServiceSetup."Customer Name" := CopyStr(XMLNode.InnerText,1,MaxStrLen(OCRServiceSetup."Customer Name"));
        if XMLDOMManagement.FindNode(XMLRootNode,'ActivationStatus',XMLNode) then
          OCRServiceSetup."Customer Status" := CopyStr(XMLNode.InnerText,1,MaxStrLen(OCRServiceSetup."Customer Status"));
        RsoGetRequest('users/rest/currentuser',ResponseStr);
        XMLDOMManagement.LoadXMLNodeFromInStream(ResponseStr,XMLRootNode);

        if XMLDOMManagement.FindNode(XMLRootNode,'OrganizationId',XMLNode) then
          OCRServiceSetup."Organization ID" := CopyStr(XMLNode.InnerText,1,MaxStrLen(OCRServiceSetup."Organization ID"));
        OCRServiceSetup.Modify;
    end;


    procedure UpdateOcrDocumentTemplates()
    var
        OCRServiceDocumentTemplate: Record "OCR Service Document Template";
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLRootNode: dotnet XmlNode;
        XMLNode: dotnet XmlNode;
        XMLNode2: dotnet XmlNode;
        ResponseStr: InStream;
    begin
        GetOcrServiceSetup(false);
        OCRServiceSetup.TestField("Customer ID");

        RsoGetRequest(StrSubstNo('accounts/rest/customers/%1/userconfiguration',OCRServiceSetup."Organization ID"),ResponseStr);
        XMLDOMManagement.LoadXMLNodeFromInStream(ResponseStr,XMLRootNode);

        OCRServiceDocumentTemplate.LockTable;
        OCRServiceDocumentTemplate.DeleteAll;
        foreach XMLNode in XMLRootNode.SelectNodes('AvailableDocumentTypes/UserConfigurationDocumentType') do begin
          OCRServiceDocumentTemplate.Init;
          XMLNode2 := XMLNode.SelectSingleNode('SystemName');
          OCRServiceDocumentTemplate.Code := CopyStr(XMLNode2.InnerText,1,MaxStrLen(OCRServiceDocumentTemplate.Code));
          XMLNode2 := XMLNode.SelectSingleNode('Name');
          OCRServiceDocumentTemplate.Name := CopyStr(XMLNode2.InnerText,1,MaxStrLen(OCRServiceDocumentTemplate.Name));
          OCRServiceDocumentTemplate.Insert;
        end;
    end;


    procedure RsoGetRequest(PathQuery: Text;var ResponseStr: InStream): Boolean
    begin
        exit(RsoRequest(PathQuery,'GET','',ResponseStr));
    end;

    [TryFunction]

    procedure RsoGetRequestBinary(PathQuery: Text;var ResponseStr: InStream)
    var
        HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        HttpStatusCode: dotnet HttpStatusCode;
        ResponseHeaders: dotnet NameValueCollection;
    begin
        GetOcrServiceSetup(true);

        HttpWebRequestMgt.Initialize(StrSubstNo('%1/%2',OCRServiceSetup."Service URL",PathQuery));
        HttpWebRequestMgt.DisableUI;
        RsoAddCookie(HttpWebRequestMgt);
        RsoAddHeaders(HttpWebRequestMgt);
        HttpWebRequestMgt.SetMethod('GET');
        HttpWebRequestMgt.CreateInstream(ResponseStr);
        HttpWebRequestMgt.GetResponse(ResponseStr,HttpStatusCode,ResponseHeaders);
    end;


    procedure RsoPutRequest(PathQuery: Text;var ResponseStr: InStream): Boolean
    begin
        exit(RsoRequest(PathQuery,'PUT','<UploadDataCollection xmlns:i="http://www.w3.org/2001/XMLSchema-instance" />',ResponseStr));
    end;


    procedure RsoPostRequest(PathQuery: Text;Data: Text;var ResponseStr: InStream): Boolean
    begin
        exit(RsoRequest(PathQuery,'POST',Data,ResponseStr));
    end;

    local procedure RsoRequest(PathQuery: Text;RequestAction: Code[4];BodyText: Text;var ResponseStr: InStream): Boolean
    var
        HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        HttpStatusCode: dotnet HttpStatusCode;
        ResponseHeaders: dotnet NameValueCollection;
    begin
        GetOcrServiceSetup(true);

        HttpWebRequestMgt.Initialize(StrSubstNo('%1/%2',OCRServiceSetup."Service URL",PathQuery));
        HttpWebRequestMgt.DisableUI;
        RsoAddCookie(HttpWebRequestMgt);
        RsoAddHeaders(HttpWebRequestMgt);
        HttpWebRequestMgt.SetMethod(RequestAction);
        if BodyText <> '' then
          HttpWebRequestMgt.AddBodyAsText(BodyText);
        HttpWebRequestMgt.CreateInstream(ResponseStr);
        exit(HttpWebRequestMgt.GetResponse(ResponseStr,HttpStatusCode,ResponseHeaders));
    end;

    local procedure RsoAddHeaders(var HttpWebRequestMgt: Codeunit "Http Web Request Mgt.")
    begin
        HttpWebRequestMgt.AddHeader('x-rs-version','2011-10-14');
        HttpWebRequestMgt.AddHeader('x-rs-key',OCRServiceSetup.GetPassword(OCRServiceSetup."Authorization Key"));
        HttpWebRequestMgt.AddHeader('x-rs-culture','en-US');
        HttpWebRequestMgt.AddHeader('x-rs-uiculture','en-US');
    end;

    local procedure RsoAddCookie(var HttpWebRequestMgt: Codeunit "Http Web Request Mgt.")
    begin
        if IsNull(AuthCookie) then
          if not Authenticate then
            Error(GetLastErrorText);
        if AuthCookie.Expired then
          if not Authenticate then
            Error(GetLastErrorText);

        HttpWebRequestMgt.SetCookie(AuthCookie);
    end;

    local procedure URLEncode(InText: Text): Text
    var
        SystemWebHttpUtility: dotnet HttpUtility;
    begin
        SystemWebHttpUtility := SystemWebHttpUtility.HttpUtility;
        exit(SystemWebHttpUtility.UrlEncode(InText));
    end;


    procedure DateConvertYYYYMMDD2XML(YYYYMMDD: Text): Text
    begin
        if StrLen(YYYYMMDD) <> 8 then
          exit(YYYYMMDD);
        exit(StrSubstNo('%1-%2-%3',CopyStr(YYYYMMDD,1,4),CopyStr(YYYYMMDD,5,2),CopyStr(YYYYMMDD,7,2)));
    end;


    procedure DateConvertXML2YYYYMMDD(XMLDate: Text): Text
    begin
        exit(DelChr(XMLDate,'=','-'))
    end;

    local procedure GetOcrServiceSetup(VerifyEnable: Boolean)
    begin
        OCRServiceSetup.Get;
        if OCRServiceSetup."Service URL" <> '' then
          exit;
        if VerifyEnable then
          OCRServiceSetup.CheckEnabled;
        OCRServiceSetup.TestField("User Name");
        OCRServiceSetup.TestField("Service URL");
    end;


    procedure StartUpload(NumberOfUploads: Integer): Boolean
    var
        ResponseStr: InStream;
        ResponseText: Text;
    begin
        if NumberOfUploads < 1 then
          exit(false);

        // Initialize upload
        RsoGetRequest(StrSubstNo('files/rest/requestupload?targetCount=%1',NumberOfUploads),ResponseStr);
        ResponseStr.ReadText(ResponseText);
        if ResponseText = '' then begin
          LogActivityFailed(OCRServiceSetup.RecordId,InitiateUploadMsg,'');
          exit(false);
        end;

        LogActivitySucceeded(OCRServiceSetup.RecordId,InitiateUploadMsg,StrSubstNo(UploadTotalSuccessMsg,NumberOfUploads));
        exit(true);
    end;


    procedure UploadImage(var TempBlob: Record TempBlob;FileName: Text;ExternalReference: Text[50];Template: Code[20];LoggingRecordId: RecordID): Boolean
    var
        HttpRequestURL: Text;
        APIPart: Text;
    begin
        GetOcrServiceSetup(true);
        APIPart := StrSubstNo(
            'files/rest/image2?filename=%1&customerid=&batchexternalid=%2&buyerid=&documenttype=%3&sortingmethod=OneDocumentPerFile',
            URLEncode(FileName),ExternalReference,Template);
        HttpRequestURL := StrSubstNo('%1/%2',OCRServiceSetup."Service URL",APIPart);
        exit(UploadFile(TempBlob,HttpRequestURL,'*/*','application/octet-stream',LoggingRecordId));
    end;


    procedure UploadLearningDocument(var TempBlob: Record TempBlob;DocumentId: Text;LoggingRecordId: RecordID): Boolean
    var
        HttpRequestURL: Text;
        APIPart: Text;
    begin
        GetOcrServiceSetup(true);
        APIPart := StrSubstNo('documents/rest/%1/learningdocument',DocumentId);
        HttpRequestURL := StrSubstNo('%1/%2',OCRServiceSetup."Service URL",APIPart);
        exit(UploadFile(TempBlob,HttpRequestURL,'','',LoggingRecordId));
    end;

    local procedure UploadFile(var TempBlob: Record TempBlob;HttpRequestURL: Text;HttpRequestReturnType: Text;HttpRequestContentType: Text;LoggingRecordId: RecordID): Boolean
    var
        HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        OfficeMgt: Codeunit "Office Management";
        HttpStatusCode: dotnet HttpStatusCode;
        ResponseHeaders: dotnet NameValueCollection;
        ResponseStr: InStream;
        ResponseText: Text;
    begin
        if not TempBlob.Blob.Hasvalue then
          LogActivityFailed(LoggingRecordId,UploadFileMsg,NoFileContentErr); // throws error

        GetOcrServiceSetup(true);

        HttpWebRequestMgt.Initialize(HttpRequestURL);
        HttpWebRequestMgt.SetTraceLogEnabled(false); // Activity Log will log for us
        HttpWebRequestMgt.DisableUI;
        RsoAddCookie(HttpWebRequestMgt);
        RsoAddHeaders(HttpWebRequestMgt);
        if HttpRequestReturnType <> '' then
          HttpWebRequestMgt.SetReturnType(HttpRequestReturnType);
        if HttpRequestContentType <> '' then
          HttpWebRequestMgt.SetContentType(HttpRequestContentType);
        HttpWebRequestMgt.SetMethod('POST');
        HttpWebRequestMgt.AddBodyBlob(TempBlob);
        HttpWebRequestMgt.CreateInstream(ResponseStr);

        if not HttpWebRequestMgt.GetResponse(ResponseStr,HttpStatusCode,ResponseHeaders) then begin
          if HttpWebRequestMgt.ProcessFaultXMLResponse('','/ServiceError/Message','','') then;
          LogActivityFailed(LoggingRecordId,UploadFileMsg,'');
          exit(false); // in case error text is empty
        end;

        ResponseStr.ReadText(ResponseText);

        if ResponseText = '<BoolValue xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><Value>true</Value></BoolValue>' then begin
          LogActivitySucceeded(LoggingRecordId,UploadFileMsg,'');
          if GuiAllowed and (not OfficeMgt.IsAvailable) then
            Message(UploadSuccessMsg);
          exit(true);
        end;

        LogActivityFailed(LoggingRecordId,UploadFileMsg,StrSubstNo(UploadFileFailedMsg,ResponseText));
    end;


    procedure UploadAttachment(var TempBlob: Record TempBlob;FileName: Text;ExternalReference: Text[50];Template: Code[20];RelatedRecordId: RecordID): Boolean
    begin
        if not TempBlob.Blob.Hasvalue then
          Error(NoFileContentErr);

        if not StartUpload(1) then
          exit(false);

        exit(UploadImage(TempBlob,FileName,ExternalReference,Template,RelatedRecordId));
    end;


    procedure UploadCorrectedOCRFile(IncomingDocument: Record "Incoming Document"): Boolean
    var
        TempBlob: Record TempBlob;
        DocumentId: Text;
    begin
        if not IncomingDocument."OCR Data Corrected" then begin
          Message(NoOCRDataCorrectionMsg);
          exit;
        end;

        DocumentId := GetOCRServiceDocumentReference(IncomingDocument);
        CorrectOCRFile(IncomingDocument,TempBlob);
        if not TempBlob.Blob.Hasvalue then
          Error(NoFileContentErr);

        if not StartUpload(1) then
          exit(false);

        exit(UploadLearningDocument(TempBlob,DocumentId,IncomingDocument.RecordId));
    end;


    procedure CorrectOCRFile(IncomingDocument: Record "Incoming Document";var TempBlob: Record TempBlob)
    var
        OCRFileXMLRootNode: dotnet XmlNode;
        OutStream: OutStream;
    begin
        ValidateUpdatedOCRFields(IncomingDocument);

        GetOriginalOCRXMLRootNode(IncomingDocument,OCRFileXMLRootNode);

        with IncomingDocument do begin
          CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FieldNo("Vendor Name"));
          CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FieldNo("Vendor Invoice No."));
          CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FieldNo("Order No."));
          CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FieldNo("Document Date"));
          CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FieldNo("Due Date"));
          CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FieldNo("Amount Excl. VAT"));
          CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FieldNo("Amount Incl. VAT"));
          CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FieldNo("VAT Amount"));
          CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FieldNo("Currency Code"));
          CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FieldNo("Vendor VAT Registration No."));
          CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FieldNo("Vendor IBAN"));
          CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FieldNo("Vendor Bank Branch No."));
          CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FieldNo("Vendor Bank Account No."));
          CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FieldNo("Vendor Phone No."));
        end;
        TempBlob.Init;
        TempBlob.Blob.CreateOutstream(OutStream);
        OCRFileXMLRootNode.OwnerDocument.Save(OutStream);
    end;


    procedure CorrectOCRFileNode(var OCRFileXMLRootNode: dotnet XmlNode;IncomingDocument: Record "Incoming Document";FieldNo: Integer)
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        CorrectionXMLNode: dotnet XmlNode;
        EmptyCorrectionXMLNode: dotnet XmlNode;
        CorrectionXMLNodeParent: dotnet XmlNode;
        PositionXMLNode: dotnet XmlNode;
        IncomingDocumentRecRef: RecordRef;
        IncomingDocumentFieldRef: FieldRef;
        XPath: Text;
        CorrectionValue: Text;
        CorrectionNeeded: Boolean;
        CorrectionValueAsDecimal: Decimal;
        OriginalValueAsDecimal: Decimal;
    begin
        IncomingDocumentRecRef.GetTable(IncomingDocument);
        XPath := IncomingDocument.GetDataExchangePath(FieldNo);
        if XPath = '' then
          exit;
        if XMLDOMManagement.FindNode(OCRFileXMLRootNode,XPath,CorrectionXMLNode) then begin
          IncomingDocumentFieldRef := IncomingDocumentRecRef.Field(FieldNo);

          case Format(IncomingDocumentFieldRef.Type) of
            'Date':
              begin
                CorrectionValue := DateConvertXML2YYYYMMDD(Format(IncomingDocumentFieldRef.Value,0,9));
                CorrectionNeeded := CorrectionXMLNode.InnerText <> CorrectionValue;
              end;
            'Decimal':
              begin
                CorrectionValueAsDecimal := IncomingDocumentFieldRef.Value;
                CorrectionValue := Format(IncomingDocumentFieldRef.Value,0,9);
                if Evaluate(OriginalValueAsDecimal,CorrectionXMLNode.InnerText,9) then;
                CorrectionNeeded := OriginalValueAsDecimal <> CorrectionValueAsDecimal;
              end;
            else begin
              CorrectionValue := Format(IncomingDocumentFieldRef.Value,0,9);
              CorrectionNeeded := CorrectionXMLNode.InnerText <> CorrectionValue;
            end;
          end;

          if CorrectionNeeded then begin
            if XMLDOMManagement.FindNode(CorrectionXMLNode,'../Position',PositionXMLNode) then
              PositionXMLNode.InnerText := '0, 0, 0, 0';
            if CorrectionValue = '' then begin
              CorrectionXMLNodeParent := CorrectionXMLNode.ParentNode;
              EmptyCorrectionXMLNode := CorrectionXMLNodeParent.OwnerDocument.CreateElement(CorrectionXMLNode.Name);
              CorrectionXMLNodeParent.ReplaceChild(EmptyCorrectionXMLNode,CorrectionXMLNode);
            end else
              CorrectionXMLNode.InnerText := CorrectionValue
          end;
        end;
    end;


    procedure ValidateUpdatedOCRFields(IncomingDocument: Record "Incoming Document")
    begin
        IncomingDocument.TestField("Vendor Name");
    end;


    procedure GetOriginalOCRXMLRootNode(IncomingDocument: Record "Incoming Document";var OriginalXMLRootNode: dotnet XmlNode)
    var
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        TempBlob: Record TempBlob;
        XMLDOMManagement: Codeunit "XML DOM Management";
        InStream: InStream;
        IncDocAttachmentRecRef: RecordRef;
        OriginalXMLContentFieldRef: FieldRef;
    begin
        IncomingDocument.TestField(Posted,false);
        IncomingDocumentAttachment.SetRange("Incoming Document Entry No.",IncomingDocument."Entry No.");
        IncomingDocumentAttachment.SetRange("Generated from OCR",true);
        IncomingDocumentAttachment.SetRange(Default,true);
        if not IncomingDocumentAttachment.FindFirst then
          exit;
        IncDocAttachmentRecRef.GetTable(IncomingDocumentAttachment);
        OriginalXMLContentFieldRef := IncDocAttachmentRecRef.Field(IncomingDocumentAttachment.FieldNo(Content));
        OriginalXMLContentFieldRef.CalcField;

        TempBlob.Init;
        TempBlob.Blob := OriginalXMLContentFieldRef.Value;
        TempBlob.Blob.CreateInstream(InStream);
        XMLDOMManagement.LoadXMLNodeFromInStream(InStream,OriginalXMLRootNode);
    end;


    procedure GetOCRServiceDocumentReference(IncomingDocument: Record "Incoming Document"): Text[50]
    var
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
    begin
        IncomingDocumentAttachment.SetRange("Incoming Document Entry No.",IncomingDocument."Entry No.");
        IncomingDocumentAttachment.SetRange("Generated from OCR",true);
        if not IncomingDocumentAttachment.FindFirst then
          exit('');
        exit(IncomingDocumentAttachment."OCR Service Document Reference");
    end;


    procedure GetDocumentList(var ResponseStr: InStream): Boolean
    begin
        exit(RsoGetRequest('currentuser/documents?pageIndex=0&pageSize=1000',ResponseStr));
    end;


    procedure GetDocuments(ExternalBatchFilter: Text): Integer
    var
        TypeHelper: Codeunit "Type Helper";
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLRootNode: dotnet XmlNode;
        XMLNode: dotnet XmlNode;
        ChildNode: dotnet XmlNode;
        ResponseStr: InStream;
        ExternalBatchId: Text[50];
        DocId: Text[50];
        DocCount: Integer;
    begin
        GetOcrServiceSetup(true);

        RsoGetRequest(StrSubstNo('documents/rest/customers/%1/outputdocuments',OCRServiceSetup."Customer ID"),ResponseStr);

        XMLDOMManagement.LoadXMLNodeFromInStream(ResponseStr,XMLRootNode);

        foreach XMLNode in XMLRootNode.ChildNodes do begin
          ChildNode := XMLNode.SelectSingleNode('BatchExternalId');
          ExternalBatchId := ChildNode.InnerText;
          if (ExternalBatchFilter = '') or (ExternalBatchFilter = ExternalBatchId) then
            foreach ChildNode in XMLNode.SelectNodes('DocumentId') do begin
              DocId := ChildNode.InnerText;

              if not TypeHelper.IsMatch(DocId,'^[a-zA-Z0-9\-\{\}]*$') then
                Error(NotValidDocIDErr,DocId);

              DocCount += DownloadDocument(ExternalBatchId,DocId);

              if DocCount > GetMaxDocDownloadCount then begin
                LogActivitySucceeded(OCRServiceSetup.RecordId,GetNewDocumentsMsg,StrSubstNo(NewDocumentsTotalMsg,DocCount));
                exit(DocCount);
              end;
            end;
        end;

        LogActivitySucceeded(OCRServiceSetup.RecordId,GetNewDocumentsMsg,StrSubstNo(NewDocumentsTotalMsg,DocCount));

        if (ExternalBatchFilter <> '') and (DocCount > 0) then
          exit(DocCount);

        if ExternalBatchFilter <> '' then
          GetDocumentStatus(ExternalBatchFilter)
        else
          GetDocumentsExcludeProcessed;

        exit(DocCount);
    end;


    procedure GetDocumentsExcludeProcessed()
    var
        IncomingDocument: Record "Incoming Document";
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        TempIncomingDocumentAttachment: Record "Incoming Document Attachment" temporary;
    begin
        GetOcrServiceSetup(true);

        IncomingDocument.SetRange("OCR Status",IncomingDocument."ocr status"::Sent);
        if not IncomingDocument.FindSet then
          exit;

        repeat
          IncomingDocumentAttachment.SetRange("Incoming Document Entry No.",IncomingDocument."Entry No.");
          IncomingDocumentAttachment.SetRange(Default,true);
          IncomingDocumentAttachment.FindFirst;
          TempIncomingDocumentAttachment := IncomingDocumentAttachment;
          TempIncomingDocumentAttachment.Insert;
        until IncomingDocument.Next = 0;

        GetBatches(TempIncomingDocumentAttachment,'');
    end;


    procedure GetDocumentStatus(ExternalBatchFilter: Text)
    var
        IncomingDocument: Record "Incoming Document";
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        TempIncomingDocumentAttachment: Record "Incoming Document Attachment" temporary;
    begin
        GetOcrServiceSetup(true);

        IncomingDocumentAttachment.SetRange("External Document Reference",ExternalBatchFilter);
        IncomingDocumentAttachment.SetRange(Default,true);
        IncomingDocumentAttachment.FindFirst;

        IncomingDocument.Get(IncomingDocumentAttachment."Incoming Document Entry No.");
        if IncomingDocument."OCR Status" <> IncomingDocument."ocr status"::Sent then
          exit;

        TempIncomingDocumentAttachment := IncomingDocumentAttachment;
        TempIncomingDocumentAttachment.Insert;

        GetBatches(TempIncomingDocumentAttachment,ExternalBatchFilter);
    end;


    procedure GetDocumentForAttachment(var IncomingDocumentAttachment: Record "Incoming Document Attachment"): Integer
    var
        IncomingDocument: Record "Incoming Document";
        Status: Integer;
    begin
        if IncomingDocumentAttachment."External Document Reference" = '' then
          Error(NotUploadedErr);

        if GetDocuments(IncomingDocumentAttachment."External Document Reference") > 0 then
          Status := IncomingDocument."ocr status"::Success
        else begin
          IncomingDocument.Get(IncomingDocumentAttachment."Incoming Document Entry No.");
          Status := IncomingDocument."OCR Status";
        end;

        case Status of
          IncomingDocument."ocr status"::Success:
            Message(ImportSuccessMsg);
          IncomingDocument."ocr status"::"Awaiting Verification":
            Message(VerifyMsg);
          IncomingDocument."ocr status"::Error:
            Message(FailedMsg);
          IncomingDocument."ocr status"::Sent: // Pending Result
            Message(DocumentNotReadyMsg);
          else
            Message(DocumentNotReadyMsg);
        end;

        exit(Status);
    end;

    local procedure GetBatchDocuments(var XMLRootNode: dotnet XmlNode;BatchFilter: Text)
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        ResponseStr: InStream;
        Path: Text;
        PageSize: Integer;
        CurrentPage: Integer;
    begin
        PageSize := 200;
        CurrentPage := 0;
        Path := StrSubstNo(
            'documents/rest/customers/%1/batches/%2/documents?pageIndex=%3&pageSize=%4',OCRServiceSetup."Customer ID",
            BatchFilter,CurrentPage,PageSize);
        RsoGetRequest(Path,ResponseStr);
        XMLDOMManagement.LoadXMLNodeFromInStream(ResponseStr,XMLRootNode);
    end;

    local procedure GetBatchesApi(var XMLRootNode: dotnet XmlNode;ExternalBatchFilter: Text)
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        ResponseStr: InStream;
        Path: Text;
        PageSize: Integer;
        CurrentPage: Integer;
    begin
        PageSize := 200;
        CurrentPage := 0;
        if ExternalBatchFilter <> '' then
          Path := StrSubstNo(
              'documents/rest/customers/%1/batches?pageIndex=%2&pageSize=%3&externalId=%4',OCRServiceSetup."Customer ID",
              CurrentPage,PageSize,ExternalBatchFilter)
        else
          Path := StrSubstNo(
              'documents/rest/customers/%1/batches?pageIndex=%2&pageSize=%3&excludeProcessed=1',OCRServiceSetup."Customer ID",
              CurrentPage,PageSize);

        RsoGetRequest(Path,ResponseStr);
        XMLDOMManagement.LoadXMLNodeFromInStream(ResponseStr,XMLRootNode);
    end;

    local procedure GetBatches(var TempIncomingDocumentAttachment: Record "Incoming Document Attachment" temporary;ExternalBatchFilter: Text)
    var
        IncomingDocument: Record "Incoming Document";
        XMLDOMManagement: Codeunit "XML DOM Management";
        SendIncomingDocumentToOCR: Codeunit "Send Incoming Document to OCR";
        XMLRootNode: dotnet XmlNode;
        CurrentPage: Integer;
        TotalPages: Integer;
    begin
        repeat
          GetBatchesApi(XMLRootNode,ExternalBatchFilter);
          Evaluate(TotalPages,XMLDOMManagement.FindNodeText(XMLRootNode,'//PageCount'));

          XMLDOMManagement.FindNode(XMLRootNode,'//Batches',XMLRootNode);
          FindDocumentFromList(XMLRootNode,TempIncomingDocumentAttachment);

          CurrentPage += 1;
        until (TempIncomingDocumentAttachment.Count = 0) or (CurrentPage > TotalPages);

        if TempIncomingDocumentAttachment.FindSet then
          repeat
            IncomingDocument.Get(TempIncomingDocumentAttachment."Incoming Document Entry No.");
            SendIncomingDocumentToOCR.SetStatusToFailed(IncomingDocument);
          until TempIncomingDocumentAttachment.Next = 0;
    end;


    procedure GetDocumentId(ExternalBatchFilter: Text): Text
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLRootNode: dotnet XmlNode;
        BatchID: Text;
        DocumentID: Text;
    begin
        GetOcrServiceSetup(true);

        GetBatchesApi(XMLRootNode,ExternalBatchFilter);
        BatchID := XMLDOMManagement.FindNodeText(XMLRootNode,'/PagedBatches/Batches/Batch/Id');

        GetBatchDocuments(XMLRootNode,BatchID);
        DocumentID := XMLDOMManagement.FindNodeText(XMLRootNode,'/PagedDocuments/Documents/Document/Id');

        exit(DocumentID);
    end;

    local procedure DownloadDocument(ExternalBatchId: Text[50];DocId: Text[50]): Integer
    var
        IncomingDocument: Record "Incoming Document";
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        XMLDOMManagement: Codeunit "XML DOM Management";
        FileManagement: Codeunit "File Management";
        SendIncomingDocumentToOCR: Codeunit "Send Incoming Document to OCR";
        ImageInStr: InStream;
        ResponseStr: InStream;
        XMLRootNode: dotnet XmlNode;
        AttachmentName: Text[50];
    begin
        RsoGetRequest(StrSubstNo('documents/rest/%1',DocId),ResponseStr);
        if not XMLDOMManagement.LoadXMLNodeFromInStream(ResponseStr,XMLRootNode) then begin
          LogActivityFailed(OCRServiceSetup.RecordId,GetDocumentMsg,'');
          exit(0);
        end;

        if ExternalBatchId <> '' then
          IncomingDocumentAttachment.SetRange("External Document Reference",ExternalBatchId);
        if (ExternalBatchId <> '') and IncomingDocumentAttachment.FindFirst then begin
          IncomingDocument.Get(IncomingDocumentAttachment."Incoming Document Entry No.");
          AttachmentName := IncomingDocumentAttachment.Name;
        end else begin  // New Incoming Document
          AttachmentName := CopyStr(XMLDOMManagement.FindNodeText(XMLRootNode,'OriginalFilename'),1,MaxStrLen(AttachmentName));
          IncomingDocument.Init;
          IncomingDocument.CreateIncomingDocument(AttachmentName,'');
          IncomingDocumentAttachment.SetRange("External Document Reference");
          if RsoGetRequestBinary(StrSubstNo('documents/rest/file/%1/image',DocId),ImageInStr) then
            IncomingDocument.AddAttachmentFromStream(
              IncomingDocumentAttachment,AttachmentName,FileManagement.GetExtension(AttachmentName),ImageInStr);
        end;
        IncomingDocument.CheckNotCreated;
        IncomingDocumentAttachment.SetRange("External Document Reference");
        IncomingDocument.AddAttachmentFromStream(IncomingDocumentAttachment,AttachmentName,'xml',ResponseStr);
        IncomingDocumentAttachment."Generated from OCR" := true;
        IncomingDocumentAttachment."OCR Service Document Reference" := DocId;
        IncomingDocumentAttachment.Validate(Default,true);
        IncomingDocumentAttachment.Modify;

        IncomingDocument.Get(IncomingDocument."Entry No.");
        SendIncomingDocumentToOCR.SetStatusToReceived(IncomingDocument);

        UpdateIncomingDocWithOCRData(IncomingDocument,XMLRootNode);
        LogActivitySucceeded(IncomingDocument.RecordId,GetDocumentMsg,StrSubstNo(DocumentDownloadedTxt,DocId));

        RsoPutRequest(StrSubstNo('documents/rest/%1/downloaded',DocId),ResponseStr);
        LogActivitySucceeded(IncomingDocument.RecordId,GetDocumentConfirmMsg,StrSubstNo(DocumentDownloadedTxt,DocId));
        exit(1);
    end;


    procedure UpdateIncomingDocWithOCRData(var IncomingDocument: Record "Incoming Document";var XMLRootNode: dotnet XmlNode)
    var
        Vendor: Record Vendor;
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        XMLDOMManagement: Codeunit "XML DOM Management";
    begin
        with IncomingDocument do begin
          if "Data Exchange Type" = '' then
            exit;

          IncomingDocumentAttachment.SetRange("Incoming Document Entry No.","Entry No.");
          IncomingDocumentAttachment.SetRange("Generated from OCR",true);
          IncomingDocumentAttachment.SetRange(Default,true);
          if not IncomingDocumentAttachment.FindFirst then
            exit;
          IncomingDocumentAttachment.ExtractHeaderFields(XMLRootNode,IncomingDocument);
          Get("Entry No.");

          if XMLDOMManagement.FindNodeText(XMLRootNode,'HeaderFields/HeaderField/Text[../Type/text() = "creditinvoice"]') =
             'true'
          then
            "Document Type" := "document type"::"Purchase Credit Memo";

          if "Vendor VAT Registration No." <> '' then begin
            Vendor.SetRange("VAT Registration No.","Vendor VAT Registration No.");
            if Vendor.FindFirst then
              Validate("Vendor No.",Vendor."No.");
          end;
          Modify;
        end;
    end;

    local procedure LogActivitySucceeded(RelatedRecordID: RecordID;ActivityDescription: Text;ActivityMessage: Text)
    var
        ActivityLog: Record "Activity Log";
    begin
        ActivityLog.LogActivity(RelatedRecordID,ActivityLog.Status::Success,LoggingConstTxt,
          ActivityDescription,ActivityMessage);
    end;

    local procedure LogActivityFailed(RelatedRecordID: RecordID;ActivityDescription: Text;ActivityMessage: Text)
    var
        ActivityLog: Record "Activity Log";
    begin
        ActivityMessage := GetLastErrorText + ' ' + ActivityMessage;
        ClearLastError;

        ActivityLog.LogActivity(RelatedRecordID,ActivityLog.Status::Failed,LoggingConstTxt,
          ActivityDescription,ActivityMessage);

        Commit;

        if DelChr(ActivityMessage,'<>',' ') <> '' then
          Error(ActivityMessage);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Connection", 'OnRegisterServiceConnection', '', false, false)]

    procedure HandleOCRRegisterServiceConnection(var ServiceConnection: Record "Service Connection")
    var
        OCRServiceSetup: Record "OCR Service Setup";
        RecRef: RecordRef;
    begin
        if not OCRServiceSetup.Get then begin
          OCRServiceSetup.Init;
          OCRServiceSetup.Insert(true);
        end;
        RecRef.GetTable(OCRServiceSetup);

        if OCRServiceSetup.Enabled then
          ServiceConnection.Status := ServiceConnection.Status::Enabled
        else
          ServiceConnection.Status := ServiceConnection.Status::Disabled;
        with OCRServiceSetup do
          ServiceConnection.InsertServiceConnection(
            ServiceConnection,RecRef.RecordId,TableName,"Service URL",Page::"OCR Service Setup");
    end;

    local procedure GetMaxDocDownloadCount(): Integer
    begin
        exit(1000);
    end;

    local procedure GetDocumentSimplifiedStatus(ObjectStatus: Integer): Integer
    var
        IncomingDocument: Record "Incoming Document";
    begin
        // Status definitions can be found at http://docs.readsoftonline.com/help/eng/partner/#reference/batch-statuses.htm%3FTocPath%3DReference%7C_____6
        // Status codes can be found at https://services.readsoftonline.com/documentation/rest?s=-940536891&m=173766930
        case ObjectStatus of
          0: // 'BATCHCREATED'
            exit(IncomingDocument."ocr status"::Sent);
          1: // 'BATCHINPUTVALIDATIONFAILED'
            exit(IncomingDocument."ocr status"::Error);
          3: // 'BATCHPENDINGPROCESSSTART'
            exit(IncomingDocument."ocr status"::Sent);
          7: // 'BATCHCLASSIFICATIONINPROGRESS'
            exit(IncomingDocument."ocr status"::Sent);
          10: // 'BATCHPENDINGCORRECTION'
            exit(IncomingDocument."ocr status"::"Awaiting Verification");
          15: // 'BATCHEXTRACTIONINPROGRESS'
            exit(IncomingDocument."ocr status"::Sent);
          20: // 'BATCHMANUALVERIFICATION'
            exit(IncomingDocument."ocr status"::"Awaiting Verification");
          23: // 'BATCHREQUESTINFORMATION'
            exit(IncomingDocument."ocr status"::"Awaiting Verification");
          25: // 'BATCHAPPROVALINPROGRESS'
            exit(IncomingDocument."ocr status"::Sent);
          26: // 'BATCHPENDINGREGISTRATION'
            exit(IncomingDocument."ocr status"::Sent);
          27: // 'BATCHREGISTRATIONINPROGRESS'
            exit(IncomingDocument."ocr status"::Sent);
          28: // 'BATCHPENDINGPOST'
            exit(IncomingDocument."ocr status"::Sent);
          29: // 'BATCHPOSTINPROGRESS'
            exit(IncomingDocument."ocr status"::Sent);
          30: // 'BATCHPENDINGEXPORT'
            exit(IncomingDocument."ocr status"::Sent);
          33: // 'BATCHEXPORTINPROGRESS'
            exit(IncomingDocument."ocr status"::Success);
          35: // 'BATCHEXPORTFAILED'
            exit(IncomingDocument."ocr status"::Error);
          40: // 'BATCHSUCCESSFULLYPROCESSED'
            exit(IncomingDocument."ocr status"::Sent);
          50: // 'BATCHREJECTED'
            exit(IncomingDocument."ocr status"::Error);
          100: // 'BATCHDELETED'
            exit(IncomingDocument."ocr status"::Error);
          200: // 'BATCHPREPROCESSINGINPROGRESS'
            exit(IncomingDocument."ocr status"::Sent);
          13: // 'BATCHMANUALSEPERATION'
            exit(IncomingDocument."ocr status"::"Awaiting Verification");
          14: // 'BATCHSEPERATIONINPROGRESS'
            exit(IncomingDocument."ocr status"::Sent);
          95: // 'BATCHDELETEINPROGRESS'
            exit(IncomingDocument."ocr status"::Error);
          else
            exit(IncomingDocument."ocr status"::" ");
        end;
    end;

    local procedure FindDocumentFromList(var XMLRootNode: dotnet XmlNode;var TempIncomingDocumentAttachment: Record "Incoming Document Attachment" temporary)
    var
        IncomingDocument: Record "Incoming Document";
        XMLDOMManagement: Codeunit "XML DOM Management";
        SendIncomingDocumentToOCR: Codeunit "Send Incoming Document to OCR";
        XMLNode: dotnet XmlNode;
        DocId: Text;
        DocStatus: Integer;
        StatusAsInt: Integer;
    begin
        foreach XMLNode in XMLRootNode.ChildNodes do begin
          if TempIncomingDocumentAttachment.IsEmpty then
            exit;

          DocId := XMLDOMManagement.FindNodeText(XMLNode,'./ExternalId');
          TempIncomingDocumentAttachment.SetRange("External Document Reference",DocId);
          if TempIncomingDocumentAttachment.FindSet then
            repeat
              Evaluate(StatusAsInt,XMLDOMManagement.FindNodeText(XMLNode,'./StatusAsInt'));
              DocStatus := GetDocumentSimplifiedStatus(StatusAsInt);
              IncomingDocument.Get(TempIncomingDocumentAttachment."Incoming Document Entry No.");
              case DocStatus of
                IncomingDocument."ocr status"::Error:
                  SendIncomingDocumentToOCR.SetStatusToFailed(IncomingDocument);
                IncomingDocument."ocr status"::"Awaiting Verification":
                  SendIncomingDocumentToOCR.SetStatusToVerify(IncomingDocument);
              end;

              TempIncomingDocumentAttachment.Delete;
            until TempIncomingDocumentAttachment.Next = 0;

          // Remove filter
          TempIncomingDocumentAttachment.SetRange("External Document Reference");
          if TempIncomingDocumentAttachment.FindSet then;
        end;
    end;


    procedure TestConnection(var OCRServiceSetup: Record "OCR Service Setup")
    begin
        if SetupConnection(OCRServiceSetup) then
          Message(ConnectionSuccessMsg);
    end;


    procedure SetupConnection(var OCRServiceSetup: Record "OCR Service Setup"): Boolean
    begin
        if not HasCredentials(OCRServiceSetup) then
          Error(GetCredentialsErrText);
        if not Authenticate then
          Error(ConnectionFailedErr);
        UpdateOrganizationInfo(OCRServiceSetup);
        UpdateOcrDocumentTemplates;
        exit(true);
    end;

    [EventSubscriber(Objecttype::Page, 189, 'OnCloseIncomingDocumentFromAction', '', false, false)]
    local procedure OnCloseIncomingDocumentHandler(var IncomingDocument: Record "Incoming Document")
    begin
        Page.Run(Page::"Incoming Document",IncomingDocument);
    end;

    [EventSubscriber(Objecttype::Page, 190, 'OnCloseIncomingDocumentsFromActions', '', false, false)]
    local procedure OnCloseIncomingDocumentsHandler(var IncomingDocument: Record "Incoming Document")
    begin
        Page.Run(Page::"Incoming Documents",IncomingDocument);
    end;


    procedure OcrServiceIsEnable(): Boolean
    begin
        if not OCRServiceSetup.Get then
          exit(false);

        if
           (OCRServiceSetup."Service URL" = '') or
           (OCRServiceSetup.Enabled = false)
        then
          exit(false);

        exit(true);
    end;


    procedure GetStatusHyperLink(IncomingDocument: Record "Incoming Document"): Text
    var
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        DocumentID: Text;
    begin
        if IncomingDocument."OCR Status" = IncomingDocument."ocr status"::"Awaiting Verification" then begin
          IncomingDocument.GetMainAttachment(IncomingDocumentAttachment);
          if IncomingDocumentAttachment."External Document Reference" = '' then
            exit('');

          DocumentID := GetDocumentId(IncomingDocumentAttachment."External Document Reference");
          exit(StrSubstNo('%1/documents/%2',OCRServiceSetup."Sign-in URL",DocumentID));
        end;

        if OCRServiceSetup.Enabled and (OCRServiceSetup."Sign-in URL" <> '') then
          exit(OCRServiceSetup."Sign-in URL");
    end;
}

