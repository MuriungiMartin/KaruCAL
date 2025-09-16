#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 90003 "Verify Email Address WS"
{
    // http://api.email-validator.net/api/verify?EmailAddress=ajk@cronus.company&APIKey=ev-8915975538904936e89c6e9416666c01


    trigger OnRun()
    begin
    end;

    var
        APIKey: Text[150];

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeValidateEvent', 'E-Mail', false, false)]
    local procedure OnBeforeValidateContactEmailAddress(var Rec: Record Contact;var xRec: Record Contact;CurrFieldNo: Integer)
    begin
        if Rec."E-Mail" = '' then
          exit;

        ValidateEmailAddress(Rec."E-Mail");
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'E-Mail', false, false)]
    local procedure OnBeforeValidateCustomerEmailAddress(var Rec: Record Customer;var xRec: Record Customer;CurrFieldNo: Integer)
    begin
        if Rec."E-Mail" = '' then
          exit;
        ValidateEmailAddress(Rec."E-Mail");
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeValidateEvent', 'E-Mail', false, false)]
    local procedure OnBeforeValidateVendorEmailAddress(var Rec: Record Vendor;var xRec: Record Vendor;CurrFieldNo: Integer)
    begin
        if Rec."E-Mail" = '' then
          exit;

        ValidateEmailAddress(Rec."E-Mail");
    end;


    procedure ValidateEmailAddress(Email: Text)
    var
        result: Text;
        RESTWSManagement: Codeunit "REST WS Management Mail";
        HttpResponseMessage: dotnet HttpResponseMessage;
        JsonConvert: dotnet JsonConvert;
        stringContent: dotnet StringContent;
        null: dotnet Object;
        details: dotnet String;
        detailsArray: dotnet Array;
        detail: Text;
        messageText: Text;
        Environment: dotnet Environment;
        separator: dotnet String;
        Window: Dialog;
        data: Text;
    begin
        Window.Open('Verifying E-mail Address...');
        APIKey:='ev-8915975538904936e89c6e9416666c01';

        RESTWSManagement.CallRESTWebService('http://api.email-validator.net/',
                                            StrSubstNo('api/verify?EmailAddress=%1&APIKey=%2',Email,APIKey),
                                            'GET',
                                            null,
                                            HttpResponseMessage);

        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        //
        // APIResult := JsonConvert.DeserializeObject(result,GETDOTNETTYPE(APIResult));
        //
        // Window.CLOSE();
        //
        // IF NOT (APIResult.status IN [200,207,215]) THEN BEGIN
        //  messageText := 'Verifying E-mail Address...' + Environment.NewLine + Environment.NewLine;
        //  messageText += 'Info: ' + APIResult.info + Environment.NewLine + Environment.NewLine;
        //  messageText += 'Details:' + Environment.NewLine;
        //
        //  separator := '.';
        //  details := APIResult.details;
        //  detailsArray := details.Split(separator.ToCharArray());
        //  FOREACH detail IN detailsArray DO BEGIN
        //    messageText += detail + Environment.NewLine;
        //  END;
        //  MESSAGE(messageText);
        // END;

          Message(result);
    end;

    local procedure GetTimsQRString(InvoiceNumber: Code[20]) TimsUrl: Text[300]
    var
        result: Text;
        RESTWSManagement: Codeunit "REST WS Management Mail";
        HttpResponseMessage: dotnet HttpResponseMessage;
        JsonConvert: dotnet JsonConvert;
        stringContent: dotnet StringContent;
        null: dotnet Object;
        details: dotnet String;
        detailsArray: dotnet Array;
        detail: Text;
        messageText: Text;
        Environment: dotnet Environment;
        separator: dotnet String;
        Window: Dialog;
        data: Text;
    begin
    end;
}

