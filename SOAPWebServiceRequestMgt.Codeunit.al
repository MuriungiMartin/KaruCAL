#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1290 "SOAP Web Service Request Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        BodyPathTxt: label '/soap:Envelope/soap:Body', Locked=true;
        ContentTypeTxt: label 'multipart/form-data; charset=utf-8', Locked=true;
        FaultStringXmlPathTxt: label '/soap:Envelope/soap:Body/soap:Fault/faultstring', Locked=true;
        NoRequestBodyErr: label 'The request body is not set.';
        NoServiceAddressErr: label 'The web service URI is not set.';
        ExpectedResponseNotReceivedErr: label 'The expected data was not received from the web service.';
        SchemaNamespaceTxt: label 'http://www.w3.org/2001/XMLSchema', Locked=true;
        SchemaInstanceNamespaceTxt: label 'http://www.w3.org/2001/XMLSchema-instance', Locked=true;
        SecurityUtilityNamespaceTxt: label 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd', Locked=true;
        SecurityExtensionNamespaceTxt: label 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd', Locked=true;
        SoapNamespaceTxt: label 'http://schemas.xmlsoap.org/soap/envelope/', Locked=true;
        UsernameTokenNamepsaceTxt: label 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText', Locked=true;
        TempDebugLogTempBlob: Record TempBlob temporary;
        ResponseBodyTempBlob: Record TempBlob;
        ResponseInStreamTempBlob: Record TempBlob;
        Trace: Codeunit Trace;
        GlobalRequestBodyInStream: InStream;
        HttpWebResponse: dotnet HttpWebResponse;
        GlobalPassword: Text;
        GlobalURL: Text;
        GlobalUsername: Text;
        TraceLogEnabled: Boolean;
        GlobalTimeout: Integer;
        InternalErr: label 'The remote service has returned the following error message:\\';
        GlobalSkipCheckHttps: Boolean;
        GlobalProgressDialogEnabled: Boolean;

    [TryFunction]

    procedure SendRequestToWebService()
    var
        WebRequestHelper: Codeunit "Web Request Helper";
        HttpWebRequest: dotnet HttpWebRequest;
        HttpStatusCode: dotnet HttpStatusCode;
        ResponseHeaders: dotnet NameValueCollection;
        ResponseInStream: InStream;
    begin
        CheckGlobals;
        BuildWebRequest(GlobalURL,HttpWebRequest);
        ResponseInStreamTempBlob.Init;
        ResponseInStreamTempBlob.Blob.CreateInstream(ResponseInStream);
        CreateSoapRequest(HttpWebRequest.GetRequestStream,GlobalRequestBodyInStream,GlobalUsername,GlobalPassword);
        WebRequestHelper.GetWebResponse(HttpWebRequest,HttpWebResponse,ResponseInStream,
          HttpStatusCode,ResponseHeaders,GlobalProgressDialogEnabled);
        ExtractContentFromResponse(ResponseInStream,ResponseBodyTempBlob);
    end;

    local procedure BuildWebRequest(ServiceUrl: Text;var HttpWebRequest: dotnet HttpWebRequest)
    var
        DecompressionMethods: dotnet DecompressionMethods;
        NetCredential: dotnet NetworkCredential;
    begin
        HttpWebRequest := HttpWebRequest.Create(ServiceUrl);
        HttpWebRequest.Method := 'POST';
        HttpWebRequest.KeepAlive := true;
        HttpWebRequest.AllowAutoRedirect := true;
        // HttpWebRequest.UseDefaultCredentials := TRUE;
        if (GlobalUsername <> '') and (GlobalPassword <> '') then begin
        NetCredential := NetCredential.NetworkCredential(GlobalUsername,GlobalPassword);
        HttpWebRequest.Credentials := NetCredential;
        end else
        HttpWebRequest.UseDefaultCredentials := true;
        // HttpWebRequest.ContentType := ContentTypeTxt;
        HttpWebRequest.ContentType := 'text/xml;charset=utf-8';
        if GlobalTimeout <= 0 then
          GlobalTimeout := 600000;
        HttpWebRequest.Timeout := GlobalTimeout;
        HttpWebRequest.AutomaticDecompression := DecompressionMethods.GZip;

        // IF SoapAction <> '' THEN
        //  HttpWebRequest.Headers.Add('SOAPAction', SoapAction);
    end;

    local procedure CreateSoapRequest(RequestOutStream: OutStream;BodyContentInStream: InStream;Username: Text;Password: Text)
    var
        XmlDoc: dotnet XmlDocument;
        BodyXmlNode: dotnet XmlNode;
    begin
        CreateEnvelope(XmlDoc,BodyXmlNode,Username,Password);
        AddBodyToEnvelope(BodyXmlNode,BodyContentInStream);
        XmlDoc.Save(RequestOutStream);
        TraceLogXmlDocToTempFile(XmlDoc,'FullRequest');
    end;

    local procedure CreateEnvelope(var XmlDoc: dotnet XmlDocument;var BodyXmlNode: dotnet XmlNode;Username: Text;Password: Text)
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        EnvelopeXmlNode: dotnet XmlNode;
        HeaderXmlNode: dotnet XmlNode;
        SecurityXmlNode: dotnet XmlNode;
        UsernameTokenXmlNode: dotnet XmlNode;
        TempXmlNode: dotnet XmlNode;
        PasswordXmlNode: dotnet XmlNode;
    begin
        XmlDoc := XmlDoc.XmlDocument;
        with XMLDOMMgt do begin
          AddRootElementWithPrefix(XmlDoc,'Envelope','s',SoapNamespaceTxt,EnvelopeXmlNode);
          AddAttribute(EnvelopeXmlNode,'xmlns:u',SecurityUtilityNamespaceTxt);

          AddElementWithPrefix(EnvelopeXmlNode,'Header','','s',SoapNamespaceTxt,HeaderXmlNode);

          if (Username <> '') or (Password <> '') then begin
            AddElementWithPrefix(HeaderXmlNode,'Security','','o',SecurityExtensionNamespaceTxt,SecurityXmlNode);
            AddAttributeWithPrefix(SecurityXmlNode,'mustUnderstand','s',SoapNamespaceTxt,'1');

            AddElementWithPrefix(SecurityXmlNode,'UsernameToken','','o',SecurityExtensionNamespaceTxt,UsernameTokenXmlNode);
            AddAttributeWithPrefix(UsernameTokenXmlNode,'Id','u',SecurityUtilityNamespaceTxt,CreateUUID);

            AddElementWithPrefix(UsernameTokenXmlNode,'Username',Username,'o',SecurityExtensionNamespaceTxt,TempXmlNode);
            AddElementWithPrefix(UsernameTokenXmlNode,'Password',Password,'o',SecurityExtensionNamespaceTxt,PasswordXmlNode);
            AddAttribute(PasswordXmlNode,'Type',UsernameTokenNamepsaceTxt);
          end;

          AddElementWithPrefix(EnvelopeXmlNode,'Body','','s',SoapNamespaceTxt,BodyXmlNode);
          AddAttribute(BodyXmlNode,'xmlns:xsi',SchemaInstanceNamespaceTxt);
          AddAttribute(BodyXmlNode,'xmlns:xsd',SchemaNamespaceTxt);
        end;
    end;

    local procedure CreateUUID(): Text
    begin
        exit('uuid-' + DelChr(Lowercase(Format(CreateGuid)),'=','{}'));
    end;

    local procedure AddBodyToEnvelope(var BodyXmlNode: dotnet XmlNode;BodyInStream: InStream)
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        BodyContentXmlDoc: dotnet XmlDocument;
    begin
        XMLDOMManagement.LoadXMLDocumentFromInStream(BodyInStream,BodyContentXmlDoc);
        TraceLogXmlDocToTempFile(BodyContentXmlDoc,'RequestBodyContent');

        BodyXmlNode.AppendChild(BodyXmlNode.OwnerDocument.ImportNode(BodyContentXmlDoc.DocumentElement,true));
    end;

    local procedure ExtractContentFromResponse(ResponseInStream: InStream;var BodyTempBlob: Record TempBlob)
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        ResponseBodyXMLDoc: dotnet XmlDocument;
        ResponseBodyXmlNode: dotnet XmlNode;
        XmlNode: dotnet XmlNode;
        BodyOutStream: OutStream;
        Found: Boolean;
    begin
        TraceLogStreamToTempFile(ResponseInStream,'FullResponse',TempDebugLogTempBlob);
        XMLDOMMgt.LoadXMLNodeFromInStream(ResponseInStream,XmlNode);

        Found := XMLDOMMgt.FindNodeWithNamespace(XmlNode,BodyPathTxt,'soap',SoapNamespaceTxt,ResponseBodyXmlNode);
        if not Found then
          Error(ExpectedResponseNotReceivedErr);

        ResponseBodyXMLDoc := ResponseBodyXMLDoc.XmlDocument;
        ResponseBodyXMLDoc.AppendChild(ResponseBodyXMLDoc.ImportNode(ResponseBodyXmlNode.FirstChild,true));

        BodyTempBlob.Blob.CreateOutstream(BodyOutStream);
        ResponseBodyXMLDoc.Save(BodyOutStream);
        TraceLogXmlDocToTempFile(ResponseBodyXMLDoc,'ResponseBodyContent');
    end;


    procedure GetResponseContent(var ResponseBodyInStream: InStream)
    begin
        ResponseBodyTempBlob.Blob.CreateInstream(ResponseBodyInStream);
    end;


    procedure ProcessFaultResponse(SupportInfo: Text)
    var
        WebRequestHelper: Codeunit "Web Request Helper";
        XMLDOMMgt: Codeunit "XML DOM Management";
        WebException: dotnet WebException;
        XmlNode: dotnet XmlNode;
        ResponseInputStream: InStream;
        ErrorText: Text;
        ServiceURL: Text;
    begin
        ErrorText := WebRequestHelper.GetWebResponseError(WebException,ServiceURL);

        if ErrorText <> '' then
          Error(ErrorText);

        ResponseInputStream := WebException.Response.GetResponseStream;
        if TraceLogEnabled then
          Trace.LogStreamToTempFile(ResponseInputStream,'WebExceptionResponse',TempDebugLogTempBlob);

        XMLDOMMgt.LoadXMLNodeFromInStream(ResponseInputStream,XmlNode);

        ErrorText := XMLDOMMgt.FindNodeTextWithNamespace(XmlNode,FaultStringXmlPathTxt,'soap',SoapNamespaceTxt);
        if ErrorText = '' then
          ErrorText := WebException.Message;
        ErrorText := InternalErr + ErrorText + ServiceURL;

        if SupportInfo <> '' then
          ErrorText += '\\' + SupportInfo;

        Error(ErrorText);
    end;


    procedure SetGlobals(RequestBodyInStream: InStream;URL: Text;Username: Text;Password: Text)
    begin
        GlobalRequestBodyInStream := RequestBodyInStream;

        GlobalSkipCheckHttps := false;

        GlobalURL := URL;
        GlobalUsername := Username;
        GlobalPassword := Password;

        GlobalProgressDialogEnabled := true;

        TraceLogEnabled := false;
    end;


    procedure SetTimeout(NewTimeout: Integer)
    begin
        GlobalTimeout := NewTimeout;
    end;

    local procedure CheckGlobals()
    var
        WebRequestHelper: Codeunit "Web Request Helper";
    begin
        if GlobalRequestBodyInStream.eos then
          Error(NoRequestBodyErr);

        if GlobalURL = '' then
          Error(NoServiceAddressErr);

        if GlobalSkipCheckHttps then
          WebRequestHelper.IsValidUri(GlobalURL)
        else
          WebRequestHelper.IsSecureHttpUrl(GlobalURL);
    end;

    local procedure TraceLogStreamToTempFile(var ToLogInStream: InStream;Name: Text;var TraceLogTempBlob: Record TempBlob)
    begin
        if TraceLogEnabled then
          Trace.LogStreamToTempFile(ToLogInStream,Name,TraceLogTempBlob);
    end;

    local procedure TraceLogXmlDocToTempFile(var XmlDoc: dotnet XmlDocument;Name: Text)
    begin
        if TraceLogEnabled then
          Trace.LogXmlDocToTempFile(XmlDoc,Name);
    end;


    procedure SetTraceMode(NewTraceMode: Boolean)
    begin
        TraceLogEnabled := NewTraceMode;
    end;


    procedure DisableHttpsCheck()
    begin
        GlobalSkipCheckHttps := true;
    end;


    procedure DisableProgressDialog()
    begin
        GlobalProgressDialogEnabled := false;
    end;


    procedure SetCustomGlobals(useXmlMsgTypePar: Boolean;soapActionPar: Text[150];skipNsPar: Boolean;nsPrefixPar: Text[150];nsTxtPar: Text[150])
    begin
    end;
}

