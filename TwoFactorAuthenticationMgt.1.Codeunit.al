#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 90053 "Two Factor AuthenticationMgt.1"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnBeforeCompanyOpen', '', false, false)]
    local procedure TwoFactorAuthenticationBeforeCompanyOpen()
    var
        UserSetup: Record UnknownRecord90050;
        SMSCode: Text;
        MessageText: Text;
        UserResponse: Text;
        EnterSMSCode: Page "Enter SMS Code1";
        Counter: Integer;
        CodeIsValid: Boolean;
        TryAgain: Boolean;
        SMSWebService: Codeunit "SMS Web Service1";
    begin
        if not UserSetup.Get(UserId) then
          exit;

        if not UserSetup."Use Two Factor Authentication" then
          exit;

        SMSCode := Format(Random(100000000));
        MessageText := StrSubstNo('Use this code to login in %1: %2',COMPANYNAME,SMSCode);
        SMSWebService.SendSMS(UserSetup."Phone No.",MessageText);
        TryAgain := true;

        while TryAgain do begin
          Clear(EnterSMSCode);
          if EnterSMSCode.RunModal <> Action::OK then
            Error('You canceled the login procedure');

          UserResponse := EnterSMSCode.GetSMSCode;

          CodeIsValid := UserResponse = SMSCode;
          Counter += 1;
          TryAgain := (not CodeIsValid) and (Counter < 3);
        end;

        if not CodeIsValid then
          Error('You entered an invalid code for 3 times');
    end;
}

