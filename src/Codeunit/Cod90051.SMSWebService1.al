#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 90051 "SMS Web Service1"
{

    trigger OnRun()
    begin
    end;


    procedure SendSMS(PhoneNo: Text;MessageText: Text) ReturnValue: Boolean
    var
        BulkSMSSetup: Record UnknownRecord90051;
        RESTWSManagement: Codeunit "REST WS Management sm";
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
    begin
        BulkSMSSetup.Get;
        BulkSMSSetup.TestField("User Name");
        BulkSMSSetup.TestField("Password Key");

        Window.Open('Sending SMS...');

        // data := 'username='  + httpUtility.UrlEncode(BulkSMSSetup."User Name",encoding.GetEncoding('ISO-8859-1'));
        // data += '&password=' + httpUtility.UrlEncode(BulkSMSSetup.GetPassword(),encoding.GetEncoding('ISO-8859-1'));
        // data += '&message='  + httpUtility.UrlEncode(MessageText,encoding.GetEncoding('ISO-8859-1'));
        // data += '&msisdn='   + PhoneNo;
        // data += '&want_report=0';
        data := 'email='  + 'twanjala@appkings.co.ke';//httpUtility.UrlEncode('twanjala@appkings.co.ke',encoding.GetEncoding('ISO-8859-1'));
        data += '&sender=' +'Kyu_Uni_Sms'; //httpUtility.UrlEncode('Kyu_Uni_Sms',encoding.GetEncoding('ISO-8859-1'));
        data += '&api-key='  +'46DC43733BFD410ABA41DD8462BDE01D'; //httpUtility.UrlEncode('46DC43733BFD410ABA41DD8462BDE01D',encoding.GetEncoding('ISO-8859-1'));
        //data += '&msisdn='   + PhoneNo;
        data += '&sms=[{"msisdn":'   + PhoneNo+',"message": "This is my message","requestid": "885730"}]';

        //data += '&want_report=0';

        stringContent := stringContent.StringContent(data,encoding.UTF8,'application/x-www-form-urlencoded');

        ReturnValue := RESTWSManagement.CallRESTWebService('https://reseller.standardmedia.co.ke/',
                                                           'api/sendmessages',
                                                           'POST',
                                                           stringContent,
                                                           HttpResponseMessage);
        Window.Close;

        if not ReturnValue then
          exit;

        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;

        separator := '|';
        resultParts := result.Split(separator.ToCharArray());
        statusCode := resultParts.GetValue(0);
        statusText := resultParts.GetValue(1);

        if not (statusCode in ['0','1']) then
          Error('Sending SMS message failed!\Statuscode: %1\Description: %2',statusCode,statusText);
    end;


    procedure GetCredits(var BulkSMSSetup: Record UnknownRecord90051)
    var
        RESTWSManagement: Codeunit "REST WS Management sm";
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
    begin
        BulkSMSSetup.TestField("User Name");
        BulkSMSSetup.TestField("Password Key");

        RESTWSManagement.CallRESTWebService('https://bulksms.vsms.net/',
                                            StrSubstNo('eapi/user/get_credits/1/1.1?username=%1&password=%2',BulkSMSSetup."User Name",BulkSMSSetup.GetPassword()),
                                            'GET',
                                            null,
                                            HttpResponseMessage);

        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;

        separator := '|';
        resultParts := result.Split(separator.ToCharArray());
        statusCode := resultParts.GetValue(0);
        statusText := resultParts.GetValue(1);

        if statusCode <> '0' then
          Error('GetCredits failed!\Statuscode: %1\Description: %2',statusCode,statusText);

        Evaluate(BulkSMSSetup.Credits, statusText,9);
        BulkSMSSetup."Credits Checked At" := CurrentDatetime;
        BulkSMSSetup.Modify;
    end;
}

