#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6700 "O365 Sync. Management"
{
    Permissions = TableData "Service Password"=rimd;

    trigger OnRun()
    begin
        Codeunit.Run(Codeunit::"Exchange Contact Sync.");
        Codeunit.Run(Codeunit::"Booking Customer Sync.");
        Codeunit.Run(Codeunit::"Booking Service Sync.");
    end;

    var
        ProgressWindow: Dialog;
        BookingsConnectionID: Text;
        ConnectionErr: label '%1 is unable to connect to Exchange. This may be due to a service outage or invalid credentials.', Comment='%1 = User who cannot connect';
        LoggingConstTxt: label 'Contact synchronization.';
        O365RecordMissingErr: label 'The Office 365 synchronization setup record is not configured correctly.';
        ExchangeConnectionID: Text;
        RegisterConnectionTxt: label 'Register connection.';
        SetupO365Qst: label 'Would you like to configure your connection to Office 365 now?';
        BookingsConnectionString: Text;
        ExchangeConnectionString: Text;
        GettingContactsTxt: label 'Getting Exchange contacts.';
        GettingBookingCustomersTxt: label 'Getting Booking customers.';
        GettingBookingServicesTxt: label 'Getting Booking services.';
        NoUserAccessErr: label 'Could not connect to %1. Verify that %2 is an administrator in the Bookings mailbox.', Comment='%1 = The Bookings company; %2 = The user';

    [TryFunction]

    procedure GetBookingMailboxes(BookingSync: Record "Booking Sync";var TempBookingMailbox: Record "Booking Mailbox" temporary;MailboxName: Text)
    var
        BookingMailbox: Record "Booking Mailbox";
    begin
        BookingSync."Booking Mailbox Address" := CopyStr(MailboxName,1,80);
        RegisterBookingsConnection(BookingSync);
        TempBookingMailbox.Reset;
        TempBookingMailbox.DeleteAll;
        if BookingMailbox.FindSet then
          repeat
            TempBookingMailbox.Init;
            TempBookingMailbox.TransferFields(BookingMailbox);
            TempBookingMailbox.Insert;
          until BookingMailbox.Next = 0;
    end;


    procedure CreateExchangeConnection(var ExchangeSync: Record "Exchange Sync") Valid: Boolean
    var
        User: Record User;
        AuthenticationEmail: Text[250];
    begin
        IsO365Setup(false);
        if GetUser(User,ExchangeSync."User ID") then begin
          AuthenticationEmail := User."Authentication Email";
          Valid := ValidatePPEExchangeConnection(AuthenticationEmail,ExchangeSync);
          if not Valid then
            Valid := ValidateExchangeConnection(AuthenticationEmail,ExchangeSync);
        end;

        if not Valid then
          Valid := ValidatePPEExchangeConnection(AuthenticationEmail,ExchangeSync);
    end;


    procedure IsO365Setup(AddOnTheFly: Boolean): Boolean
    var
        User: Record User;
        LocalExchangeSync: Record "Exchange Sync";
        AuthenticationEmail: Text[250];
        Password: Text;
        Token: Text;
    begin
        with LocalExchangeSync do begin
          if GetUser(User,UserId) then
            AuthenticationEmail := User."Authentication Email";

          if not Get(UserId) or
             (AuthenticationEmail = '') or ("Folder ID" = '') or not GetPasswordOrToken(LocalExchangeSync,Password,Token)
          then begin
            if AddOnTheFly then begin
              if not OpenSetupWindow then
                Error(O365RecordMissingErr)
            end else
              Error(O365RecordMissingErr);
          end;
        end;

        exit(true);
    end;


    procedure OpenSetupWindow(): Boolean
    var
        ExchangeSyncSetup: Page "Exchange Sync. Setup";
    begin
        if Confirm(SetupO365Qst,true) then
          exit(ExchangeSyncSetup.RunModal = Action::OK);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", 'OnCompanyInitialize', '', false, false)]
    local procedure SetupContactSyncJobQueue()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.Init;
        JobQueueEntry."Object Type to Run" := JobQueueEntry."object type to run"::Codeunit;
        JobQueueEntry."Earliest Start Date/Time" := CreateDatetime(Today,Time);
        JobQueueEntry."Object ID to Run" := Codeunit::"O365 Sync. Management";
        JobQueueEntry."Recurring Job" := true;
        JobQueueEntry."Run on Mondays" := true;
        JobQueueEntry."Run on Tuesdays" := true;
        JobQueueEntry."Run on Wednesdays" := true;
        JobQueueEntry."Run on Thursdays" := true;
        JobQueueEntry."Run on Fridays" := true;
        JobQueueEntry."Run on Saturdays" := true;
        JobQueueEntry."Run on Sundays" := true;
        JobQueueEntry."No. of Minutes between Runs" := 1440;
        JobQueueEntry."Job Queue Category Code" := '';
        JobQueueEntry."Maximum No. of Attempts to Run" := 0;
        Codeunit.Run(Codeunit::"Job Queue - Enqueue",JobQueueEntry);
    end;


    procedure SyncBookingCustomers(var BookingSync: Record "Booking Sync")
    var
        BookingCustomerSync: Codeunit "Booking Customer Sync.";
    begin
        CheckUserAccess(BookingSync);
        ShowProgress(GettingBookingCustomersTxt);
        RegisterBookingsConnection(BookingSync);
        CloseProgress;
        BookingCustomerSync.SyncRecords(BookingSync);
    end;


    procedure SyncBookingServices(var BookingSync: Record "Booking Sync")
    var
        BookingServiceSync: Codeunit "Booking Service Sync.";
    begin
        CheckUserAccess(BookingSync);
        ShowProgress(GettingBookingServicesTxt);
        RegisterBookingsConnection(BookingSync);
        CloseProgress;
        BookingServiceSync.SyncRecords(BookingSync);
    end;


    procedure SyncExchangeContacts(ExchangeSync: Record "Exchange Sync";FullSync: Boolean)
    var
        ExchangeContactSync: Codeunit "Exchange Contact Sync.";
    begin
        ShowProgress(GettingContactsTxt);
        RegisterExchangeConnection(ExchangeSync);
        CloseProgress;
        ExchangeContactSync.SyncRecords(ExchangeSync,FullSync);
    end;


    procedure LogActivityFailed(RecordID: Variant;UserID: Code[50];ActivityDescription: Text;ActivityMessage: Text)
    var
        ActivityLog: Record "Activity Log";
    begin
        ActivityMessage := GetLastErrorText + ' ' + ActivityMessage;
        ClearLastError;

        ActivityLog.LogActivityForUser(RecordID,ActivityLog.Status::Failed,CopyStr(LoggingConstTxt,1,30),
          ActivityDescription,ActivityMessage,UserID);
    end;


    procedure BuildBookingsConnectionString(var BookingSync: Record "Booking Sync") ConnectionString: Text
    var
        User: Record User;
        ExchangeSync: Record "Exchange Sync";
        ExchangeWebServicesServer: Codeunit "Exchange Web Services Server";
        Password: Text;
        Token: Text;
    begin
        // Example connection string
        // {UserName}="user@user.onmicrosoft.com";{Password}="1234";{FolderID}="Dynamics NAV";{Uri}=https://outlook.office365.com/EWS/Exchange.asmx
        ExchangeSync.Get(BookingSync."User ID");
        if (not GetUser(User,BookingSync."User ID")) or
           (User."Authentication Email" = '') or
           (not GetPasswordOrToken(ExchangeSync,Password,Token))
        then
          Error(O365RecordMissingErr);

        ConnectionString :=
          StrSubstNo(
            '{UserName}=%1;{Password}=%2;{Token}=%3;{Mailbox}=%4;',
            User."Authentication Email",
            Password,
            Token,
            BookingSync."Booking Mailbox Address");

        // Attempt use of the PPE endpoint (instead of autodiscover) when in PPE and the credential validates there.
        if ValidatePPEExchangeConnection(User."Authentication Email",ExchangeSync) then
          ConnectionString := StrSubstNo('%1;{Uri}=%2',ConnectionString,ExchangeWebServicesServer.PPEEndpoint)
        else
          if Token <> '' then
            ConnectionString := StrSubstNo('%1;{Uri}=%2',ConnectionString,ExchangeWebServicesServer.GetEndpoint);
    end;


    procedure BuildExchangeConnectionString(var ExchangeSync: Record "Exchange Sync") ConnectionString: Text
    var
        User: Record User;
        ExchangeWebServicesServer: Codeunit "Exchange Web Services Server";
        Token: Text;
        Password: Text;
    begin
        // Example connection string
        // {UserName}="user@user.onmicrosoft.com";{Password}="1234";{FolderID}="Dynamics NAV";{Uri}=https://outlook.office365.com/EWS/Exchange.asmx
        if (not GetUser(User,ExchangeSync."User ID")) or
           (User."Authentication Email" = '') or
           (ExchangeSync."Folder ID" = '') or (not GetPasswordOrToken(ExchangeSync,Password,Token))
        then
          Error(O365RecordMissingErr);

        ConnectionString :=
          StrSubstNo(
            '{UserName}=%1;{Password}=%2;{Token}=%3;{FolderID}=%4;',
            User."Authentication Email",
            Password,
            Token,
            ExchangeSync."Folder ID");

        // Attempt use of the PPE endpoint (instead of autodiscover) when in PPE and the credential validates there.
        if ValidatePPEExchangeConnection(User."Authentication Email",ExchangeSync) then
          ConnectionString := StrSubstNo('%1;{Uri}=%2',ConnectionString,ExchangeWebServicesServer.PPEEndpoint)
        else
          if Token <> '' then
            ConnectionString := StrSubstNo('%1;{Uri}=%2',ConnectionString,ExchangeWebServicesServer.GetEndpoint);
    end;


    procedure RegisterBookingsConnection(BookingSync: Record "Booking Sync")
    var
        ExchangeSync: Record "Exchange Sync";
    begin
        if ExchangeConnectionID <> '' then
          UnregisterConnection(ExchangeConnectionID);

        if BookingsConnectionReady(BookingSync) then
          exit;

        if BookingsConnectionID <> '' then
          UnregisterConnection(BookingsConnectionID);

        ExchangeSync.Get(BookingSync."User ID");
        BookingsConnectionID := CreateGuid;

        if RegisterConnection(ExchangeSync,BookingsConnectionID,BookingsConnectionString) then
          SetConnection(ExchangeSync,BookingsConnectionID);
    end;


    procedure RegisterExchangeConnection(ExchangeSync: Record "Exchange Sync")
    begin
        if BookingsConnectionID <> '' then
          UnregisterConnection(BookingsConnectionID);

        if ExchangeConnectionReady(ExchangeSync) then
          exit;

        if ExchangeConnectionID <> '' then
          UnregisterConnection(ExchangeConnectionID);

        ExchangeConnectionID := CreateGuid;
        if RegisterConnection(ExchangeSync,ExchangeConnectionID,ExchangeConnectionString) then
          SetConnection(ExchangeSync,ExchangeConnectionID);
    end;

    [TryFunction]
    local procedure TryRegisterConnection(ConnectionID: Guid;ConnectionString: Text)
    begin
        // Using a try function, as these may throw an exception under certain circumstances (improper credentials, broken connection)
        RegisterTableConnection(Tableconnectiontype::Exchange,ConnectionID,ConnectionString);
    end;

    local procedure RegisterConnection(ExchangeSync: Record "Exchange Sync";ConnectionID: Guid;ConnectionString: Text) Success: Boolean
    begin
        Success := TryRegisterConnection(ConnectionID,ConnectionString);
        if not Success then
          ConnectionFailure(ExchangeSync);
    end;

    [TryFunction]
    local procedure TrySetConnection(ConnectionID: Guid)
    begin
        // Using a try function, as these may throw an exception under certain circumstances (improper credentials, broken connection)
        SetDefaultTableConnection(Tableconnectiontype::Exchange,ConnectionID);
    end;

    local procedure SetConnection(ExchangeSync: Record "Exchange Sync";ConnectionID: Guid) Success: Boolean
    begin
        Success := TrySetConnection(ConnectionID);
        if not Success then
          ConnectionFailure(ExchangeSync);
    end;

    [TryFunction]
    local procedure UnregisterConnection(var ConnectionID: Text)
    begin
        UnregisterTableConnection(Tableconnectiontype::Exchange,ConnectionID);
        ConnectionID := '';
    end;

    local procedure ConnectionFailure(ExchangeSync: Record "Exchange Sync")
    begin
        with ExchangeSync do begin
          LogActivityFailed(RecordId,RegisterConnectionTxt,StrSubstNo(ConnectionErr,"User ID"),"User ID");
          if GuiAllowed then begin
            CloseProgress;
            Error(StrSubstNo(ConnectionErr,"User ID"));
          end;
        end;
    end;


    procedure ValidatePPEExchangeConnection(AuthenticationEmail: Text[250];var ExchangeSync: Record "Exchange Sync") Valid: Boolean
    var
        ExchangeWebServicesServer: Codeunit "Exchange Web Services Server";
        Credentials: dotnet ExchangeCredentials;
    begin
        if ExchangeWebServicesServer.IsPPE then begin
          CreateExchangeAccountCredentials(ExchangeSync,Credentials);
          Valid := ExchangeWebServicesServer.Initialize(AuthenticationEmail,ExchangeWebServicesServer.PPEEndpoint,Credentials,false);
          Valid := (Valid and ExchangeWebServicesServer.ValidCredentials);
        end;
    end;


    procedure ValidateExchangeConnection(AuthenticationEmail: Text[250];var ExchangeSync: Record "Exchange Sync") Valid: Boolean
    var
        ExchangeWebServicesServer: Codeunit "Exchange Web Services Server";
        Credentials: dotnet ExchangeCredentials;
    begin
        CreateExchangeAccountCredentials(ExchangeSync,Credentials);
        Valid := ExchangeWebServicesServer.Initialize(AuthenticationEmail,ExchangeWebServicesServer.ProdEndpoint,Credentials,false);
        Valid := (Valid and ExchangeWebServicesServer.ValidCredentials);
    end;

    local procedure CreateExchangeAccountCredentials(var ExchangeSync: Record "Exchange Sync";var Credentials: dotnet ExchangeCredentials)
    var
        User: Record User;
        WebCredentials: dotnet WebCredentials;
        OAuthCredentials: dotnet OAuthCredentials;
        AuthenticationEmail: Text[250];
        Token: Text;
        Password: Text;
    begin
        with ExchangeSync do begin
          if GetUser(User,"User ID") then
            AuthenticationEmail := User."Authentication Email";
          if AuthenticationEmail = '' then
            Error(O365RecordMissingErr);
          if not GetPasswordOrToken(ExchangeSync,Password,Token) then
            Error(O365RecordMissingErr);

          if Token <> '' then
            Credentials := OAuthCredentials.OAuthCredentials(Token)
          else
            Credentials := WebCredentials.WebCredentials(AuthenticationEmail,Password);
        end;
    end;

    local procedure GetUser(var User: Record User;UserID: Text[50]): Boolean
    begin
        User.SetRange("User Name",UserID);
        exit(User.FindFirst);
    end;


    procedure ShowProgress(Message: Text)
    begin
        if GuiAllowed then begin
          CloseProgress;
          ProgressWindow.Open(Message);
        end;
    end;


    procedure CloseProgress()
    begin
        if GuiAllowed then
          if TryCloseProgress then;
    end;

    [TryFunction]
    local procedure TryCloseProgress()
    begin
        ProgressWindow.Close;
    end;

    local procedure BookingsConnectionReady(BookingSync: Record "Booking Sync") Ready: Boolean
    var
        NewConnectionString: Text;
    begin
        NewConnectionString := BuildBookingsConnectionString(BookingSync);
        Ready := (BookingsConnectionID <> '') and (NewConnectionString = BookingsConnectionString);
        BookingsConnectionString := NewConnectionString;
    end;

    local procedure ExchangeConnectionReady(ExchangeSync: Record "Exchange Sync") Ready: Boolean
    var
        NewConnectionString: Text;
    begin
        NewConnectionString := BuildExchangeConnectionString(ExchangeSync);
        Ready := (ExchangeConnectionID <> '') and (NewConnectionString = ExchangeConnectionString);
        ExchangeConnectionString := NewConnectionString;
    end;

    local procedure GetPasswordOrToken(ExchangeSync: Record "Exchange Sync";var Password: Text;var Token: Text): Boolean
    var
        ServicePassword: Record "Service Password";
        AzureADMgt: Codeunit "Azure AD Mgt.";
    begin
        if ExchangeSync."User ID" <> '' then
          Token := AzureADMgt.GetAccessTokenForUser(AzureADMgt.GetO365Resource,ExchangeSync."User ID");

        if (Token = '') and not IsNullGuid(ExchangeSync."Exchange Account Password Key") then
          if ServicePassword.Get(ExchangeSync."Exchange Account Password Key") then
            Password := ServicePassword.GetPassword;

        exit((Token <> '') or (Password <> ''));
    end;

    local procedure CheckUserAccess(BookingSync: Record "Booking Sync")
    var
        ExchangeSync: Record "Exchange Sync";
        ExchangeWebServicesServer: Codeunit "Exchange Web Services Server";
        Credentials: dotnet ExchangeCredentials;
        ExchangeServiceFactory: dotnet ServiceWrapperFactory;
        ExchangeService: dotnet ExchangeServiceWrapper;
    begin
        ExchangeSync.Get(BookingSync."User ID");
        ExchangeService := ExchangeServiceFactory.CreateServiceWrapper2013;
        CreateExchangeAccountCredentials(ExchangeSync,Credentials);
        ExchangeService.SetNetworkCredential(Credentials);
        ExchangeService.ExchangeServiceUrl := ExchangeWebServicesServer.GetEndpoint;

        if not ExchangeService.CanAccessBookingMailbox(BookingSync."Booking Mailbox Address") then
          Error(NoUserAccessErr,BookingSync."Booking Mailbox Name",BookingSync."User ID");
    end;
}

