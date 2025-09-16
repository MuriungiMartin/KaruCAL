#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60052 "SMS Web Service"
{

    trigger OnRun()
    begin
    end;

    var
        stringContent: dotnet StringContent;
        httpUtility: dotnet HttpUtility;
        encoding: dotnet Encoding;
        result: dotnet String;
        resultParts: dotnet Array;
        separator: dotnet String;
        HttpResponseMessage: dotnet HttpResponseMessage;
        JsonConvert: dotnet JsonConvert;
        null: dotnet Object;
        Window: Dialog;
        data: Text;
        statusCode: Text;
        statusText: Text;
        JSonString: dotnet String;
        JObject: dotnet JObject;
        ArrayString: Text;
        JSONArray: dotnet JArray;
        ArrayString1: dotnet String;
        JToken: dotnet JToken;
        TempJObject: dotnet JObject;
        counter: Variant;
        JsonTextWriter: dotnet JsonTextWriter;
        StringBuilder: dotnet StringBuilder;
        StringWriter: dotnet StringWriter;
        JsonFormatting: dotnet Formatting;
        GlobalNULL: Variant;


    procedure SendSMS(PhoneNo: Text;MessageText: Text) ReturnValue: Boolean
    var
        BulkSMSSetup: Record UnknownRecord60050;
        RESTWSManagement: Codeunit "REST WS Management";
        EvaluatedTime: Time;
        WebServMan: Codeunit "Http Web Request Mgt.";
        TempBlob: Record TempBlob temporary;
        Instr: InStream;
        ReturnStr: Text[1024];
    begin
        BulkSMSSetup.Get;
        BulkSMSSetup.TestField("User Name");
        BulkSMSSetup.TestField("Password Key");
        if IsNull(StringBuilder) then
          Initialize;
        Window.Open('Sending SMS...');
        
        // //CLEAR(data);
        //       data := 'email=' + httpUtility.UrlEncode(BulkSMSSetup."User Name",encoding.GetEncoding('ISO-8859-1'));
        //       data := '&sender='  + httpUtility.UrlEncode(BulkSMSSetup.Sender_Name,encoding.GetEncoding('ISO-8859-1'));
        //       data := '&schedule=' + httpUtility.UrlEncode(FORMAT(CREATEDATETIME(TODAY,TIME)),encoding.GetEncoding('ISO-8859-1'));
        //       data := '&sms= ' + httpUtility.UrlEncode('[{',encoding.GetEncoding('ISO-8859-1'));
        //       data := '&msisdn='  + httpUtility.UrlEncode(PhoneNo,encoding.GetEncoding('ISO-8859-1'));
        //       data := '&message='  + httpUtility.UrlEncode(MessageText,encoding.GetEncoding('ISO-8859-1'));
        //       data := '&requestid='  + httpUtility.UrlEncode(FORMAT(CREATEDATETIME(TODAY,TIME))+'}]',encoding.GetEncoding('ISO-8859-1'));
        //
        // stringContent := stringContent.StringContent(data,encoding.UTF8,'application/x-www-form-urlencoded');
        
        // // // //
        // // // //       data := '{"email":"' + BulkSMSSetup."User Name"+'",';
        // // // //       data := data+'"sender"="'  + BulkSMSSetup.Sender_Name+'",';
        // // // //       data := '"schedule"="' + FORMAT(CREATEDATETIME(TODAY,TIME))+'",';
        // // // //       data := '"sms"= [{"';
        // // // //       data := '"msisdn"="'  + PhoneNo+'",';
        // // // //       data := '"message"="'  + MessageText+'",';
        // // // //       data := '"requestid"="'  + FORMAT(CREATEDATETIME(TODAY,TIME))+'"}]}';
        /*/*Build ABS JsonConvert OBJECTTYPE here*/*/
        
        /*
        */
        //JsonTextWriter.WriteStartArray;
        
        
         Clear(EvaluatedTime);
         if Evaluate(EvaluatedTime,Format(Time,0,9)) then;
            JsonTextWriter.WriteStartObject;
          //  JsonTextWriter.WritePropertyName('API-Key');
          //  JsonTextWriter.WriteValue(BulkSMSSetup."API Key");
            JsonTextWriter.WritePropertyName('email');
            JsonTextWriter.WriteValue(BulkSMSSetup."User Name");
            JsonTextWriter.WritePropertyName('sender');
            JsonTextWriter.WriteValue(BulkSMSSetup.Sender_Name);
            JsonTextWriter.WritePropertyName('schedule');
            JsonTextWriter.WriteValue(Format(Today,0,9)+' '+Format(EvaluatedTime, 0, '<Hours24,2><Filler Character,0>:<Minutes,2>:<Seconds,2>'));
            //Create Array of SMSes   Start
            JsonTextWriter.WritePropertyName('sms');
            JsonTextWriter.WriteStartArray;
                 JsonTextWriter.WriteStartObject;
                 JsonTextWriter.WritePropertyName('msisdn');
                 JsonTextWriter.WriteValue(PhoneNo);
                 JsonTextWriter.WritePropertyName('message');
                 JsonTextWriter.WriteValue(MessageText);
                 JsonTextWriter.WritePropertyName('requestid');
                 JsonTextWriter.WriteValue(Format(Today,0,9)+' '+Format(Time,0,9));
                 JsonTextWriter.WriteEndObject;
            JsonTextWriter.WriteEndArray;
            JsonTextWriter.WriteEndObject;
        JsonTextWriter.Flush;
        JSonString:=GetJSon;
        stringContent := JSonString;
        
        // Upload Json here
        // // // // // // // // ReturnValue := RESTWSManagement.CallRESTWebService('https://reseller.standardmedia.co.ke/',
        // // // // // // // //                                                   STRSUBSTNO('api/sendmessages?api-key=%1',BulkSMSSetup."API Key"),
        // // // // // // // //                                                  // 'api/sendmessages',
        // // // // // // // //                                                   'POST',
        // // // // // // // //                                                   stringContent,
        // // // // // // // //                                                   HttpResponseMessage);
        
        
        WebServMan.Initialize('https://reseller.standardmedia.co.ke/api/sendmessages?');
        WebServMan.AddHeader('api-key',BulkSMSSetup."API Key");
        WebServMan.DisableUI;
        WebServMan.SetMethod('POST');
        WebServMan.SetReturnType('application/json');
        WebServMan.SetContentType('application/json');
        WebServMan.AddBodyAsText(httpUtility.UrlEncode(stringContent.ToString,encoding.GetEncoding('ISO-8859-1')));
        TempBlob.Init;
        TempBlob.Blob.CreateInstream(Instr);
        if WebServMan.GetResponseStream(Instr) then begin
        Instr.ReadText(ReturnStr);
        Message(ReturnStr);
        end else begin
        end;
        Window.Close;
        
        if not ReturnValue then
          exit;
        
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        
        separator := '|';
        resultParts := result.Split(separator.ToCharArray());
        statusCode := resultParts.GetValue(0);
        statusText :='';// resultParts.GetValue(1);
        
        if not (statusCode in ['0','1']) then
          Error('Sending SMS message failed!\Statuscode: %1\Description: %2',statusCode,statusText);

    end;


    procedure GetCredits(var BulkSMSSetup: Record UnknownRecord60050)
    var
        RESTWSManagement: Codeunit "REST WS Management";
        stringContent: dotnet StringContent;
        httpUtility: dotnet HttpUtility;
        encoding: dotnet Encoding;
        result: dotnet String;
        resultParts: dotnet Array;
        separator: dotnet String;
        HttpResponseMessage: dotnet HttpResponseMessage;
        JsonConvert: dotnet JsonConvert;
        null: dotnet Object;
        Window: Dialog;
        data: Text;
        statusCode: Text;
        statusText: Text;
        APIKeys: Text;
    begin
        BulkSMSSetup.TestField("User Name");
        BulkSMSSetup.TestField("Password Key");
        if IsNull(StringBuilder) then
          Initialize;
        Clear(APIKeys);
        APIKeys := 'E65C1C2799454B4598574EA4521F9560';
        Clear(data);
               data := '"email":' + BulkSMSSetup."User Name"+'"';
            JsonTextWriter.WriteStartObject;
            JsonTextWriter.WritePropertyName('email');
            JsonTextWriter.WriteValue(BulkSMSSetup."User Name");
            JsonTextWriter.WriteEndObject;
        JsonTextWriter.Flush;
        JSonString:=GetJSon;
        stringContent := JSonString;

        //stringContent := stringContent.StringContent(data);
        RESTWSManagement.CallRESTWebService('https://reseller.standardmedia.co.ke/',
                                                           'api/getbalance?api-key='+APIKeys,
                                            'GET',
                                            stringContent,
                                            HttpResponseMessage);

        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;

        separator := '|';
        resultParts := result.Split(separator.ToCharArray());
        statusCode := resultParts.GetValue(0);
        statusText := '';//resultParts.GetValue(1);

        if statusCode <> '0' then
          Error('GetCredits failed!\Statuscode: %1\Description: %2',statusCode,statusText);

        Evaluate(BulkSMSSetup.Credits, statusText,9);
        BulkSMSSetup."Credits Checked At" := CurrentDatetime;
        BulkSMSSetup.Modify;
    end;

    local procedure Initialize()
    begin
        StringBuilder := StringBuilder.StringBuilder;
        StringWriter := StringWriter.StringWriter(StringBuilder);
        JsonTextWriter := JsonTextWriter.JsonTextWriter(StringWriter);
        JsonTextWriter.Formatting := JsonFormatting.Indented;

        Clear(GlobalNULL);
    end;


    procedure GetJSon() JSon: Text
    begin
        JSon := StringBuilder.ToString;
        Initialize;
    end;

    local procedure UploadJSon(WebService_URL: Text[150];var String: dotnet String)
    var
        HttpWebRequest: dotnet HttpWebRequest;
        HttpWebResponse: dotnet WebResponse;
    begin
    end;

    local procedure CreateWebRequest(var HttpWebRequest: dotnet HttpWebRequest;WebServiceURL: Text;Method: Text[20])
    begin
        HttpWebRequest := HttpWebRequest.Create(WebServiceURL);
        HttpWebRequest.Timeout := 300000;
        HttpWebRequest.Method := Method;
        HttpWebRequest.Accept := 'application/json';
        HttpWebRequest.ContentType := 'application/json';
    end;

    local procedure SetRequestStream(HttpWebRequest: dotnet HttpWebRequest)
    begin
    end;

    local procedure GetResponseStream()
    begin
    end;

    local procedure DoWebRequest()
    begin
    end;

    trigger Tempjobject::PropertyChanged(sender: Variant;e: dotnet PropertyChangedEventArgs)
    begin
    end;

    trigger Tempjobject::PropertyChanging(sender: Variant;e: dotnet PropertyChangingEventArgs)
    begin
    end;

    trigger Tempjobject::ListChanged(sender: Variant;e: dotnet ListChangedEventArgs)
    begin
    end;

    trigger Tempjobject::AddingNew(sender: Variant;e: dotnet AddingNewEventArgs)
    begin
    end;

    trigger Tempjobject::CollectionChanged(sender: Variant;e: dotnet NotifyCollectionChangedEventArgs)
    begin
    end;

    trigger Jsonarray::ListChanged(sender: Variant;e: dotnet ListChangedEventArgs)
    begin
    end;

    trigger Jsonarray::AddingNew(sender: Variant;e: dotnet AddingNewEventArgs)
    begin
    end;

    trigger Jsonarray::CollectionChanged(sender: Variant;e: dotnet NotifyCollectionChangedEventArgs)
    begin
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

