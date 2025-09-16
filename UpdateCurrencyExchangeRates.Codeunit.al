#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1281 "Update Currency Exchange Rates"
{
    Permissions = TableData "Data Exch."=rimd;

    trigger OnRun()
    begin
        SyncCurrencyExchangeRates;
    end;

    var
        ResponseTempBlob: Record TempBlob;
        HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        NoSyncCurrencyExchangeRatesSetupErr: label 'There are no active Currency Exchange Rate Sync. Setup records.';

    local procedure SyncCurrencyExchangeRates()
    var
        CurrExchRateUpdateSetup: Record "Curr. Exch. Rate Update Setup";
        ResponseInStream: InStream;
        SourceName: Text;
    begin
        CurrExchRateUpdateSetup.SetRange(Enabled,true);
        if not CurrExchRateUpdateSetup.FindFirst then
          Error(NoSyncCurrencyExchangeRatesSetupErr);

        GetCurrencyExchangeData(CurrExchRateUpdateSetup,ResponseInStream,SourceName);
        UpdateCurrencyExchangeRates(CurrExchRateUpdateSetup,ResponseInStream,SourceName);
    end;


    procedure UpdateCurrencyExchangeRates(CurrExchRateUpdateSetup: Record "Curr. Exch. Rate Update Setup";CurrencyExchRatesDataInStream: InStream;SourceName: Text)
    var
        DataExch: Record "Data Exch.";
        DataExchDef: Record "Data Exch. Def";
    begin
        DataExchDef.Get(CurrExchRateUpdateSetup."Data Exch. Def Code");
        CreateDataExchange(DataExch,DataExchDef,CurrencyExchRatesDataInStream,CopyStr(SourceName,1,250));
        DataExchDef.ProcessDataExchange(DataExch);
    end;

    local procedure GetCurrencyExchangeData(var CurrExchRateUpdateSetup: Record "Curr. Exch. Rate Update Setup";var ResponseInStream: InStream;var SourceName: Text)
    var
        ServiceUrl: Text;
    begin
        ExecuteWebServiceRequest(CurrExchRateUpdateSetup,ResponseInStream);
        CurrExchRateUpdateSetup.GetWebServiceURL(ServiceUrl);
        SourceName := ServiceUrl;
    end;

    local procedure CreateDataExchange(var DataExch: Record "Data Exch.";DataExchDef: Record "Data Exch. Def";ResponseInStream: InStream;SourceName: Text[250])
    var
        TempBlob: Record TempBlob;
        GetJsonStructure: Codeunit "Get Json Structure";
        OutStream: OutStream;
        BlankInStream: InStream;
    begin
        if DataExchDef."File Type" = DataExchDef."file type"::Json then begin
          TempBlob.Init;
          TempBlob.Blob.CreateInstream(BlankInStream);

          DataExch.InsertRec(SourceName,BlankInStream,DataExchDef.Code);
          DataExch."File Content".CreateOutstream(OutStream);
          if not GetJsonStructure.JsonToXML(ResponseInStream,OutStream) then
            GetJsonStructure.JsonToXMLCreateDefaultRoot(ResponseInStream,OutStream);
          DataExch.Modify(true);
        end else
          DataExch.InsertRec(SourceName,ResponseInStream,DataExchDef.Code);

        Codeunit.Run(DataExchDef."Reading/Writing Codeunit",DataExch);
    end;

    local procedure ExecuteWebServiceRequest(CurrExchRateUpdateSetup: Record "Curr. Exch. Rate Update Setup";var ResponseInStream: InStream)
    var
        HttpStatusCode: dotnet HttpStatusCode;
        ResponseHeaders: dotnet NameValueCollection;
        URL: Text;
    begin
        Clear(ResponseTempBlob);
        ResponseTempBlob.Init;
        ResponseTempBlob.Blob.CreateInstream(ResponseInStream);

        CurrExchRateUpdateSetup.GetWebServiceURL(URL);
        HttpWebRequestMgt.Initialize(URL);

        if not GuiAllowed then
          HttpWebRequestMgt.DisableUI;

        HttpWebRequestMgt.SetTraceLogEnabled(CurrExchRateUpdateSetup."Log Web Requests");

        if not HttpWebRequestMgt.GetResponse(ResponseInStream,HttpStatusCode,ResponseHeaders) then
          HttpWebRequestMgt.ProcessFaultResponse('');
    end;


    procedure GenerateTempDataFromService(var TempCurrencyExchangeRate: Record "Currency Exchange Rate" temporary;CurrExchRateUpdateSetup: Record "Curr. Exch. Rate Update Setup")
    var
        DataExch: Record "Data Exch.";
        DataExchDef: Record "Data Exch. Def";
        MapCurrencyExchangeRate: Codeunit "Map Currency Exchange Rate";
        ResponseInStream: InStream;
        SourceName: Text;
    begin
        GetCurrencyExchangeData(CurrExchRateUpdateSetup,ResponseInStream,SourceName);
        DataExchDef.Get(CurrExchRateUpdateSetup."Data Exch. Def Code");
        CreateDataExchange(DataExch,DataExchDef,ResponseInStream,CopyStr(SourceName,1,250));

        MapCurrencyExchangeRate.MapCurrencyExchangeRates(DataExch,TempCurrencyExchangeRate);
        DataExch.Delete(true);
    end;
}

