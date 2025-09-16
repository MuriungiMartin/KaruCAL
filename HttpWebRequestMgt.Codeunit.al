#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1297 "Http Web Request Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        HttpWebRequest: dotnet HttpWebRequest;
        TraceLogEnabled: Boolean;
        InvalidUrlErr: label 'The URL is not valid.';
        NonSecureUrlErr: label 'The URL is not secure.';
        GlobalSkipCheckHttps: Boolean;
        GlobalProgressDialogEnabled: Boolean;
        InternalErr: label 'The remote service has returned the following error message:\\';
        NoCookieForYouErr: label 'The web request has no cookies.';


    procedure GetResponse(var ResponseInStream: InStream;var HttpStatusCode: dotnet HttpStatusCode;var ResponseHeaders: dotnet NameValueCollection): Boolean
    var
        WebRequestHelper: Codeunit "Web Request Helper";
        HttpWebResponse: dotnet HttpWebResponse;
    begin
        exit(WebRequestHelper.GetWebResponse(HttpWebRequest,HttpWebResponse,ResponseInStream,HttpStatusCode,
            ResponseHeaders,GlobalProgressDialogEnabled));
    end;


    procedure GetResponseStream(var ResponseInStream: InStream): Boolean
    var
        WebRequestHelper: Codeunit "Web Request Helper";
        HttpWebResponse: dotnet HttpWebResponse;
        HttpStatusCode: dotnet HttpStatusCode;
        ResponseHeaders: dotnet NameValueCollection;
    begin
        exit(WebRequestHelper.GetWebResponse(HttpWebRequest,HttpWebResponse,ResponseInStream,HttpStatusCode,
            ResponseHeaders,GlobalProgressDialogEnabled));
    end;

    [TryFunction]

    procedure ProcessFaultResponse(SupportInfo: Text)
    begin
        ProcessFaultXMLResponse(SupportInfo,'','','');
    end;

    [TryFunction]

    procedure ProcessFaultXMLResponse(SupportInfo: Text;NodePath: Text;Prefix: Text;NameSpace: Text)
    var
        TempReturnTempBlob: Record TempBlob temporary;
        WebRequestHelper: Codeunit "Web Request Helper";
        XMLDOMMgt: Codeunit "XML DOM Management";
        WebException: dotnet WebException;
        XmlDoc: dotnet XmlDocument;
        ResponseInputStream: InStream;
        ErrorText: Text;
        ServiceURL: Text;
    begin
        ErrorText := WebRequestHelper.GetWebResponseError(WebException,ServiceURL);

        if not IsNull(WebException.Response) then begin
          ResponseInputStream := WebException.Response.GetResponseStream;

          TraceLogStreamToTempFile(ResponseInputStream,'WebExceptionResponse',TempReturnTempBlob);

          if NodePath <> '' then
            if TryLoadXMLResponse(ResponseInputStream,XmlDoc) then
              if Prefix = '' then
                ErrorText := XMLDOMMgt.FindNodeText(XmlDoc.DocumentElement,NodePath)
              else
                ErrorText := XMLDOMMgt.FindNodeTextWithNamespace(XmlDoc.DocumentElement,NodePath,Prefix,NameSpace);
        end;

        if ErrorText = '' then
          ErrorText := WebException.Message;

        ErrorText := InternalErr + ErrorText;

        if SupportInfo <> '' then
          ErrorText += '\\' + SupportInfo;

        Error(ErrorText);
    end;

    [TryFunction]

    procedure CheckUrl(Url: Text)
    var
        Uri: dotnet Uri;
        UriKind: dotnet UriKind;
    begin
        if not Uri.TryCreate(Url,UriKind.Absolute,Uri) then
          Error(InvalidUrlErr);

        if not GlobalSkipCheckHttps and not (Uri.Scheme = 'https') then
          Error(NonSecureUrlErr);
    end;

    local procedure TraceLogStreamToTempFile(var ToLogInStream: InStream;Name: Text;var TraceLogTempBlob: Record TempBlob)
    var
        Trace: Codeunit Trace;
    begin
        if TraceLogEnabled then
          Trace.LogStreamToTempFile(ToLogInStream,Name,TraceLogTempBlob);
    end;

    [TryFunction]

    procedure TryLoadXMLResponse(ResponseInputStream: InStream;var XmlDoc: dotnet XmlDocument)
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
    begin
        XMLDOMManagement.LoadXMLDocumentFromInStream(ResponseInputStream,XmlDoc);
    end;


    procedure SetTraceLogEnabled(Enabled: Boolean)
    begin
        TraceLogEnabled := Enabled;
    end;


    procedure DisableUI()
    begin
        GlobalProgressDialogEnabled := false;
    end;


    procedure Initialize(URL: Text)
    begin
        HttpWebRequest := HttpWebRequest.Create(URL);
        //SetDefaults;
        SetDefaultsPost;
    end;

    local procedure SetDefaults()
    var
        CookieContainer: dotnet CookieContainer;
    begin
        HttpWebRequest.Method := 'GET';
        HttpWebRequest.KeepAlive := true;
        HttpWebRequest.AllowAutoRedirect := true;
        HttpWebRequest.UseDefaultCredentials := true;
        HttpWebRequest.Timeout := 60000;
        HttpWebRequest.Accept('application/xml');
        HttpWebRequest.ContentType('application/xml');
        CookieContainer := CookieContainer.CookieContainer;
        HttpWebRequest.CookieContainer := CookieContainer;

        GlobalSkipCheckHttps := true;
        GlobalProgressDialogEnabled := GuiAllowed;
        TraceLogEnabled := true;
    end;

    local procedure SetDefaultsPost()
    var
        CookieContainer: dotnet CookieContainer;
    begin
        HttpWebRequest.Method := 'POST';
        HttpWebRequest.KeepAlive := true;
        HttpWebRequest.AllowAutoRedirect := true;
        HttpWebRequest.UseDefaultCredentials := true;
        HttpWebRequest.Timeout := 30000;
        HttpWebRequest.Accept('application/json');
        HttpWebRequest.ContentType('application/json');
        CookieContainer := CookieContainer.CookieContainer;
        HttpWebRequest.CookieContainer := CookieContainer;

        GlobalSkipCheckHttps := true;
        GlobalProgressDialogEnabled := GuiAllowed;
        TraceLogEnabled := true;
    end;


    procedure AddBodyAsText(BodyText: Text)
    var
        Encoding: dotnet Encoding;
    begin
        // Assume UTF8
        AddBodyAsTextWithEncoding(BodyText,Encoding.UTF8);
    end;


    procedure AddBodyAsAsciiText(BodyText: Text)
    var
        Encoding: dotnet Encoding;
    begin
        AddBodyAsTextWithEncoding(BodyText,Encoding.Ascii);
    end;

    local procedure AddBodyAsTextWithEncoding(BodyText: Text;Encoding: dotnet Encoding)
    var
        RequestStr: dotnet Stream;
        StreamWriter: dotnet StreamWriter;
    begin
        RequestStr := HttpWebRequest.GetRequestStream;
        StreamWriter := StreamWriter.StreamWriter(RequestStr,Encoding);
        StreamWriter.Write(BodyText);
        StreamWriter.Flush;
        StreamWriter.Close;
        StreamWriter.Dispose;
    end;


    procedure SetTimeout(NewTimeout: Integer)
    begin
        HttpWebRequest.Timeout := NewTimeout;
    end;


    procedure SetMethod(Method: Text)
    begin
        HttpWebRequest.Method := Method;
    end;


    procedure SetDecompresionMethod(DecompressionMethod: dotnet DecompressionMethods)
    begin
        HttpWebRequest.AutomaticDecompression := DecompressionMethod;
    end;


    procedure SetContentType(ContentType: Text)
    begin
        HttpWebRequest.ContentType := ContentType;
    end;


    procedure SetReturnType(ReturnType: Text)
    begin
        HttpWebRequest.Accept := ReturnType;
    end;


    procedure SetProxy(ProxyUrl: Text)
    var
        WebProxy: dotnet WebProxy;
    begin
        if ProxyUrl = '' then
          exit;

        WebProxy := WebProxy.WebProxy(ProxyUrl);

        HttpWebRequest.Proxy := WebProxy;
    end;


    procedure AddHeader("Key": Text;Value: Text)
    begin
        HttpWebRequest.Headers.Add(Key,Value);
    end;


    procedure AddBody(BodyFilePath: Text)
    var
        FileStream: dotnet FileStream;
        FileMode: dotnet FileMode;
    begin
        if BodyFilePath = '' then
          exit;

        FileStream := FileStream.FileStream(BodyFilePath,FileMode.Open);
        FileStream.CopyTo(HttpWebRequest.GetRequestStream);
    end;


    procedure AddBodyBlob(var TempBlob: Record TempBlob)
    var
        RequestStr: dotnet Stream;
        BlobStr: InStream;
    begin
        if not TempBlob.Blob.Hasvalue then
          exit;

        RequestStr := HttpWebRequest.GetRequestStream;
        TempBlob.Blob.CreateInstream(BlobStr);
        CopyStream(RequestStr,BlobStr);
        RequestStr.Flush;
        RequestStr.Close;
        RequestStr.Dispose;
    end;


    procedure SetUserAgent(UserAgent: Text)
    begin
        HttpWebRequest.UserAgent := UserAgent;
    end;


    procedure SetCookie(var Cookie: dotnet Cookie)
    begin
        HttpWebRequest.CookieContainer.Add(Cookie);
    end;


    procedure GetCookie(var Cookie: dotnet Cookie)
    var
        CookieCollection: dotnet CookieCollection;
    begin
        if not HasCookie then
          Error(NoCookieForYouErr);
        CookieCollection := HttpWebRequest.CookieContainer.GetCookies(HttpWebRequest.RequestUri);
        Cookie := CookieCollection.Item(0);
    end;


    procedure HasCookie(): Boolean
    begin
        exit(HttpWebRequest.CookieContainer.Count > 0);
    end;


    procedure CreateInstream(var InStr: InStream)
    var
        TempBlob: Record TempBlob;
    begin
        TempBlob.Init;
        TempBlob.Blob.CreateInstream(InStr);
    end;
}

