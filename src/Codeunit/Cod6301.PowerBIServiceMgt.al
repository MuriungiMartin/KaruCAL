#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6301 "Power BI Service Mgt."
{
    // // Manages access to the Power BI service API's (aka powerbi.com)


    trigger OnRun()
    begin
    end;

    var
        AzureAdMgt: Codeunit "Azure AD Mgt.";
        PowerBiApiResourceUrlTxt: label 'https://analysis.windows.net/powerbi/api', Locked=true;
        JObject: dotnet JObject;
        DotNetString: dotnet String;
        PowerBiApiResourceUrlPPETxt: label 'https://analysis.windows-int.net/powerbi/api', Locked=true;
        ReportsUrlTxt: label 'https://api.powerbi.com/beta/myorg/reports', Comment='It should always be English version.';
        ReportsUrlPPETxt: label 'https://biazure-int-edog-redirect.analysis-df.windows.net/beta/myorg/reports', Comment='It should always be English version.';
        UnauthorizedErr: label 'You are not authorized to view Power BI reports. \Make sure you have Power BI account provisioned using https://powerbi.microsoft.com.', Comment='Url should always be English version.';
        GenericErr: label 'Error occurred while trying to get reports from Power BI service. Please try again or contact your system administrator if error persist.';
        PowerBiResourceNameTxt: label 'Power BI Services';


    procedure GetReports(var TempPowerBIReportBuffer: Record "Power BI Report Buffer" temporary;Context: Text[30])
    var
        PowerBIReportConfiguration: Record "Power BI Report Configuration";
        AzureADAppSetup: Record "Azure AD App Setup";
        ActivityLog: Record "Activity Log";
        Company: Record Company;
        DotNetExceptionHandler: Codeunit "DotNet Exception Handler";
        JObj: dotnet JObject;
        ObjectEnumerator: dotnet IEnumerator;
        Current: dotnet KeyValuePair_Of_T_U;
        JArray: dotnet JArray;
        ArrayEnumerator: dotnet IEnumerator;
        JToken: dotnet JToken;
        HttpWebResponse: dotnet HttpWebResponse;
        WebException: dotnet WebException;
        HttpStatusCode: dotnet HttpStatusCode;
        Exception: dotnet Exception;
        Url: Text;
        "Key": Text;
        ResponseText: Text;
    begin
        // Gets a list of reports from the user's Power BI account and loads them into the given buffer.
        // Reports are marked as Enabled if they've previously been selected for the given context (page ID).
        if not TempPowerBIReportBuffer.IsEmpty then
          exit;

        if IsPPE then
          Url := ReportsUrlPPETxt
        else
          Url := ReportsUrlTxt;

        if not GetResponseText(Url,ResponseText) then begin
          Exception := GetLastErrorObject;
          if not AzureADAppSetup.IsEmpty then begin
            AzureADAppSetup.FindFirst;
            ActivityLog.LogActivityForUser(
              AzureADAppSetup.RecordId,ActivityLog.Status::Failed,'Power BI Non-SaaS',Exception.Message,Exception.ToString,UserId);
          end else begin
            Company.Get(COMPANYNAME); // Dummy record to attach to activity log
            ActivityLog.LogActivityForUser(
              Company.RecordId,ActivityLog.Status::Failed,'Power BI SaaS',Exception.Message,Exception.ToString,UserId);
          end;

          DotNetExceptionHandler.Collect;
          if DotNetExceptionHandler.CastToType(WebException,GetDotNetType(WebException)) then begin
            HttpWebResponse := WebException.Response;
            HttpStatusCode := HttpWebResponse.StatusCode;

            if HttpWebResponse.StatusCode = 401 then
              Error(UnauthorizedErr);
          end else
            Error(GenericErr);
        end;

        JObj := JObject.Parse(ResponseText); // TODO: check versions

        ObjectEnumerator := JObj.GetEnumerator;

        while ObjectEnumerator.MoveNext do begin
          Current := ObjectEnumerator.Current;
          Key := Current.Key;

          if Key = 'value' then begin
            JArray := Current.Value;
            ArrayEnumerator := JArray.GetEnumerator;

            while ArrayEnumerator.MoveNext do begin
              JObj := ArrayEnumerator.Current;
              TempPowerBIReportBuffer.Init;

              // report GUID identifier
              JToken := JObj.SelectToken('id');
              Evaluate(TempPowerBIReportBuffer.ReportID,JToken.ToString);

              // report name
              JToken := JObj.SelectToken('name');
              TempPowerBIReportBuffer.ReportName := JToken.ToString;

              // report embedding url
              JToken := JObj.SelectToken('embedUrl');
              TempPowerBIReportBuffer.EmbedUrl := JToken.ToString;

              // report enabled
              TempPowerBIReportBuffer.Enabled := PowerBIReportConfiguration.Get(UserSecurityId,TempPowerBIReportBuffer.ReportID,Context);

              TempPowerBIReportBuffer.Insert;
            end;
          end
        end;
    end;


    procedure IsUserReadyForPowerBI(): Boolean
    begin
        if not AzureAdMgt.IsAzureADAppSetupDone then
          exit(false);

        exit(not DotNetString.IsNullOrWhiteSpace(AzureAdMgt.GetAccessToken(GetPowerBiResourceUrl,GetPowerBiResourceName,false)));
    end;


    procedure GetPowerBiResourceUrl(): Text
    begin
        if IsPPE then
          exit(PowerBiApiResourceUrlPPETxt);

        exit(PowerBiApiResourceUrlTxt);
    end;


    procedure GetPowerBiResourceName(): Text
    begin
        exit(PowerBiResourceNameTxt);
    end;

    [TryFunction]
    local procedure GetResponseText(Url: Text;var ResponseText: Text)
    var
        TempBlob: Record TempBlob;
        HttpWebRequest: dotnet HttpWebRequest;
        HttpWebResponse: dotnet HttpWebResponse;
        ResponseInputStream: InStream;
        ChunkText: Text;
    begin
        HttpWebRequest := HttpWebRequest.Create(Url);
        HttpWebRequest.Method := 'GET';
        HttpWebRequest.ContentLength := 0;
        // add the access token to the authorization bearer header
        HttpWebRequest.Headers.Add('Authorization','Bearer ' + AzureAdMgt.GetAccessToken(
            GetPowerBiResourceUrl,GetPowerBiResourceName,false));
        HttpWebResponse := HttpWebRequest.GetResponse;

        TempBlob.Init;
        TempBlob.Blob.CreateInstream(ResponseInputStream);
        HttpWebResponse.GetResponseStream.CopyTo(ResponseInputStream);

        // the READTEXT() function apparently only reads a single line, so we must loop through the stream to get the contents of every line.
        while not ResponseInputStream.eos do begin
          ResponseInputStream.ReadText(ChunkText);
          ResponseText += ChunkText;
        end;

        HttpWebResponse.Close; // close connection
        HttpWebResponse.Dispose; // cleanup of IDisposable
    end;


    procedure GetGenericError(): Text
    begin
        exit(GenericErr);
    end;

    local procedure IsPPE(): Boolean
    var
        ExchangeWebServicesServer: Codeunit "Exchange Web Services Server";
    begin
        exit(ExchangeWebServicesServer.IsPPE);
    end;

    trigger Jobject::PropertyChanged(sender: Variant;e: dotnet PropertyChangedEventArgs)
    begin
    end;

    trigger Jobject::PropertyChanging(sender: Variant;e: dotnet PropertyChangingEventArgs)
    begin
    end;

    trigger Jobject::ListChanged(sender: Variant;e: dotnet ListChangedEventArgs)
    begin
    end;

    trigger Jobject::AddingNew(sender: Variant;e: dotnet AddingNewEventArgs)
    begin
    end;

    trigger Jobject::CollectionChanged(sender: Variant;e: dotnet NotifyCollectionChangedEventArgs)
    begin
    end;
}

