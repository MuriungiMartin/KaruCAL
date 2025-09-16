#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5323 "Exchange Add-in Setup"
{

    trigger OnRun()
    begin
    end;

    var
        ExchangeWebServicesServer: Codeunit "Exchange Web Services Server";
        Initialized: Boolean;
        InvalidCredentialsErr: label 'The provided email address and password are not valid Office 365 or Exchange credentials.';
        NoMailboxErr: label 'An Office 365 or Exchange mailbox could not be found for this account.';
        AutodiscoverMsg: label 'Searching for your mailbox.';
        WelcomeSubjectTxt: label 'Welcome to %1 - your Business Inbox in Outlook is ready!', Comment='%1 - Application name';
        WelcomeEmailFromNameTxt: label '%1 Admin', Comment='%1 - Application Name';
        SalesEmailAddrTxt: label 'jim.glynn@cronuscorp.net', Locked=true;

    [TryFunction]
    local procedure Initialize(AuthenticationEmail: Text[80])
    var
        ExchangeServiceSetup: Record "Exchange Service Setup";
        AzureADMgt: Codeunit "Azure AD Mgt.";
        AccessToken: Text;
    begin
        AccessToken := AzureADMgt.GetAccessToken(AzureADMgt.GetO365Resource,AzureADMgt.GetO365ResourceName,false);

        if AccessToken <> '' then begin
          ExchangeWebServicesServer.InitializeWithOAuthToken(AccessToken,ExchangeWebServicesServer.GetEndpoint);
          if ValidateCredentials then
            exit;
        end;

        ExchangeServiceSetup.Get;
        with ExchangeServiceSetup do
          ExchangeWebServicesServer.InitializeWithCertificate("Azure AD App. ID","Azure AD App. Cert. Thumbprint",
            "Azure AD Auth. Endpoint","Exchange Service Endpoint","Exchange Resource Uri");

        ExchangeWebServicesServer.SetImpersonatedIdentity(AuthenticationEmail);
        Initialized := true;
    end;

    [TryFunction]

    procedure InitializeServiceWithCredentials(Email: Text[80];Password: Text[50])
    var
        WebCredentials: dotnet WebCredentials;
        ProgressWindow: Dialog;
        PPEError: Text;
        ErrorText: Text;
    begin
        WebCredentials := WebCredentials.WebCredentials(Email,Password);

        ProgressWindow.Open('#1');
        ProgressWindow.Update(1,AutodiscoverMsg);

        // Try both in the case of PPE in case non-PPE credentials are entered
        if IsPPE then begin
          Initialized := ExchangeWebServicesServer.Initialize(Email,ExchangeWebServicesServer.PPEEndpoint,WebCredentials,false) and
            ValidateCredentials;
          PPEError := GetLastErrorText;
        end;

        // Production O365 endpoint
        if not Initialized then begin
          Initialized := ExchangeWebServicesServer.Initialize(Email,ExchangeWebServicesServer.ProdEndpoint,WebCredentials,false) and
            ValidateCredentials;
          ErrorText := GetLastErrorText
        end;

        // Autodiscover endpoint (can be slow)
        if not Initialized then begin
          Initialized := ExchangeWebServicesServer.Initialize(Email,'',WebCredentials,true) and ValidateCredentials;
          ErrorText := GetLastErrorText;
        end;

        ProgressWindow.Close;

        if not Initialized then begin
          if PPEError <> '' then
            Error(PPEError);
          Error(ErrorText);
        end;
    end;


    procedure CredentialsRequired(AuthenticationEmail: Text[80]) Required: Boolean
    begin
        Required := not Initialize(AuthenticationEmail);
    end;


    procedure PromptForCredentials(): Boolean
    var
        User: Record User;
        TempOfficeAdminCredentials: Record "Office Admin. Credentials" temporary;
    begin
        TempOfficeAdminCredentials.Init;
        TempOfficeAdminCredentials.Insert;

        User.SetRange("User Name",UserId);
        if User.FindFirst then begin
          TempOfficeAdminCredentials.Email := User."Authentication Email";
          TempOfficeAdminCredentials.Modify;
        end;

        if CredentialsRequired(TempOfficeAdminCredentials.Email) or (TempOfficeAdminCredentials.Email = '') then begin
          ClearLastError;
          repeat
            if Page.RunModal(Page::"Office 365 Credentials",TempOfficeAdminCredentials) <> Action::LookupOK then
              exit(false);
          until InitializeServiceWithCredentials(TempOfficeAdminCredentials.Email,TempOfficeAdminCredentials.Password);
        end else
          ImpersonateUser(TempOfficeAdminCredentials.Email);

        exit(true);
    end;


    procedure ImpersonateUser(Email: Text[80])
    begin
        if not Initialized then
          Initialize(Email);

        ExchangeWebServicesServer.SetImpersonatedIdentity(Email);
    end;


    procedure SampleEmailsAvailable(): Boolean
    var
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
        PermissionManager: Codeunit "Permission Manager";
    begin
        exit(CompanyInformationMgt.IsDemoCompany and PermissionManager.SoftwareAsAService);
    end;


    procedure DeployAddin(OfficeAddin: Record "Office Add-in")
    var
        UserPreference: Record "User Preference";
        AddinManifestManagement: Codeunit "Add-in Manifest Management";
        InstructionMgt: Codeunit "Instruction Mgt.";
        Stream: InStream;
    begin
        AddinManifestManagement.GenerateManifest(OfficeAddin);
        OfficeAddin.Manifest.CreateInstream(Stream,Textencoding::UTF8);
        ExchangeWebServicesServer.InstallApp(Stream);

        UserPreference.SetRange("Instruction Code",InstructionMgt.OfficeUpdateNotificationCode);
        UserPreference.SetRange("User ID",UserId);
        UserPreference.DeleteAll;
    end;


    procedure DeployAddins()
    var
        OfficeAddin: Record "Office Add-in";
    begin
        if OfficeAddin.FindSet then
          repeat
            DeployAddin(OfficeAddin);
          until OfficeAddin.Next = 0;
    end;


    procedure DeploySampleEmails()
    var
        User: Record User;
        OfficeAddinSampleEmails: Codeunit "Office Add-In Sample Emails";
        RecipientEmail: Text;
        HTMlBody: Text;
    begin
        User.SetRange("User Name",UserId);
        if User.FindFirst then
          RecipientEmail := User."Authentication Email";

        HTMlBody := OfficeAddinSampleEmails.GetHTMLSampleMsg;
        ExchangeWebServicesServer.SaveHTMLEmailToInbox(StrSubstNo(WelcomeSubjectTxt,ProductName.Full),HTMlBody,
          SalesEmailAddrTxt,StrSubstNo(WelcomeEmailFromNameTxt,ProductName.Short),RecipientEmail);
    end;

    local procedure IsPPE(): Boolean
    begin
        exit(ExchangeWebServicesServer.IsPPE)
    end;

    [TryFunction]
    local procedure ValidateCredentials()
    begin
        if not ExchangeWebServicesServer.ValidCredentials then begin
          if StrPos(GetLastErrorText,'401') > 0 then
            Error(InvalidCredentialsErr);
          Error(NoMailboxErr);
        end;
    end;
}

