#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1299 "Web Request Helper"
{

    trigger OnRun()
    begin
    end;

    var
        ConnectionErr: label 'Connection to the remote service could not be established.\\';
        InvalidUriErr: label 'The URI is not valid.';
        NonSecureUriErr: label 'The URI is not secure.';
        ProcessingWindowMsg: label 'Please wait while the server is processing your request.\This may take several minutes.';
        ServiceURLTxt: label '\\Service URL: %1.', Comment='Example: ServiceURL: http://www.contoso.com/';
        GlobalHttpWebResponseError: dotnet HttpWebResponse;

    [TryFunction]

    procedure IsValidUri(Url: Text)
    var
        ResultUri: dotnet Uri;
        Uri: dotnet Uri;
        UriKind: dotnet UriKind;
    begin
        if not Uri.IsWellFormedUriString(Url,UriKind.Absolute) then
          if not Uri.TryCreate(Url,UriKind.Absolute,ResultUri) then
            Error(InvalidUriErr);
    end;

    [TryFunction]

    procedure IsSecureHttpUrl(Url: Text)
    var
        Uri: dotnet Uri;
    begin
        IsValidUri(Url);
        Uri := Uri.Uri(Url);
        if Uri.Scheme <> 'https' then
          Error(NonSecureUriErr);
    end;

    [TryFunction]

    procedure IsHttpUrl(Url: Text)
    var
        Uri: dotnet Uri;
    begin
        IsValidUri(Url);
        Uri := Uri.Uri(Url);
        if (Uri.Scheme <> 'http') and (Uri.Scheme <> 'https') then
          Error(InvalidUriErr);
    end;

    [TryFunction]

    procedure GetWebResponse(var HttpWebRequest: dotnet HttpWebRequest;var HttpWebResponse: dotnet HttpWebResponse;var ResponseInStream: InStream;var HttpStatusCode: dotnet HttpStatusCode;var ResponseHeaders: dotnet NameValueCollection;ProgressDialogEnabled: Boolean)
    var
        ProcessingWindow: Dialog;
        ServicePointManager: dotnet ServicePointManager;
        SecurityProtocolType: dotnet SecurityProtocolType;
    begin
        if ProgressDialogEnabled then
          ProcessingWindow.Open(ProcessingWindowMsg);
        ServicePointManager.SecurityProtocol(SecurityProtocolType.Ssl3);

        ClearLastError;
        HttpWebResponse := HttpWebRequest.GetResponse;
        HttpWebResponse.GetResponseStream.CopyTo(ResponseInStream);
        HttpStatusCode := HttpWebResponse.StatusCode;
        ResponseHeaders := HttpWebResponse.Headers;

        if ProgressDialogEnabled then
          ProcessingWindow.Close;
    end;


    procedure GetWebResponseError(var WebException: dotnet WebException;var ServiceURL: Text): Text
    var
        DotNetExceptionHandler: Codeunit "DotNet Exception Handler";
        WebExceptionStatus: dotnet WebExceptionStatus;
        HttpStatusCode: dotnet HttpStatusCode;
        ErrorText: Text;
    begin
        DotNetExceptionHandler.Collect;

        if not DotNetExceptionHandler.CastToType(WebException,GetDotNetType(WebException)) then
          DotNetExceptionHandler.Rethrow;

        if not IsNull(WebException.Response) then
          if not IsNull(WebException.Response.ResponseUri) then
            ServiceURL := StrSubstNo(ServiceURLTxt,WebException.Response.ResponseUri.AbsoluteUri);

        ErrorText := ConnectionErr + WebException.Message + ServiceURL;
        if not WebException.Status.Equals(WebExceptionStatus.ProtocolError) then
          exit(ErrorText);

        if IsNull(WebException.Response) then
          DotNetExceptionHandler.Rethrow;

        GlobalHttpWebResponseError := WebException.Response;
        if not (GlobalHttpWebResponseError.StatusCode.Equals(HttpStatusCode.Found) or
                GlobalHttpWebResponseError.StatusCode.Equals(HttpStatusCode.InternalServerError))
        then
          exit(ErrorText);

        exit('');
    end;
}

