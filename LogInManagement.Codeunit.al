#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 40 LogInManagement
{
    Permissions = TableData "G/L Entry"=r,
                  TableData Customer=r,
                  TableData Vendor=r,
                  TableData Item=r,
                  TableData "User Time Register"=rimd,
                  TableData "My Customer"=rimd,
                  TableData "My Vendor"=rimd,
                  TableData "My Item"=rimd;

    trigger OnRun()
    begin
    end;

    var
        PartnerAgreementNotAcceptedErr: label 'Partner Agreement has not been accepted.';
        Text022: label 'You must change password before you can continue.';
        GLSetup: Record "General Ledger Setup";
        [SecurityFiltering(Securityfilter::Filtered)]User: Record User;
        LogInWorkDate: Date;
        LogInDate: Date;
        LogInTime: Time;
        GLSetupRead: Boolean;
        ActiveSession: Record "Active Session";
        locUser: Record "User Setup";
        locActiveSession: Record "Active Session";


    procedure CompanyOpen()
    var
        CRMConnectionSetup: Record "CRM Connection Setup";
    begin
        // locUser.GET(UPPERCASE(USERID));
        //
        // IF NOT locUser.Multilogin THEN BEGIN
        //
        // locActiveSession.RESET;
        //
        // locActiveSession.SETRANGE("User ID",UPPERCASE(USERID));
        //
        // locActiveSession.SETRANGE("Client Type", locActiveSession."Client Type"::"Windows Client"); //For   KUCSERVER\Windows Clients
        //
        // IF locActiveSession.COUNT > 1 THEN
        //
        // ERROR('You are currently logged in NAV, you can’t have more sessions!');
        //
        // END
        // ELSE BEGIN
        //
        // locActiveSession.RESET;
        //
        // locActiveSession.SETRANGE("User ID",UPPERCASE(USERID));
        //
        // locActiveSession.SETRANGE("Client Type", locActiveSession."Client Type"::"Windows Client"); //For   KUCSERVER\Windows Clients
        //
        // IF locActiveSession.COUNT > locUser."Sessions Allowed" THEN
        //
        // ERROR('You are currently logged in NAV, you can’t have more than ' + FORMAT(locActiveSession.COUNT-1) + ' sessions!');
        //
        // END;

        if GuiAllowed then
          LogInStart;

        // Register all Microsoft Dynamics CRM connection strings
        if CRMConnectionSetup.Get then
          CRMConnectionSetup.UpdateAllConnectionRegistrations;
    end;


    procedure CompanyClose()
    begin
        if GuiAllowed then
          LogInEnd;
    end;

    local procedure LogInStart()
    var
        Language: Record "Windows Language";
        LicenseAgreement: Record "License Agreement";
        ApplicationAreaSetup: Record "Application Area Setup";
        ApplicationManagement: Codeunit ApplicationManagement;
        IdentityManagement: Codeunit "Identity Management";
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
        SuccessfullLogin: label 'Your program license does not permit more users to work simultaneously. Wait until another user has stopped using the program';
        CountedSuccess: Integer;
    begin
        Clear(CountedSuccess);
        CountedSuccess:=2;
        if LicenseAgreement.Get then
          if not CompanyInformationMgt.IsDemoCompany then
            if LicenseAgreement.GetActive and not LicenseAgreement.Accepted then begin
              Page.RunModal(Page::"Additional Customer Terms");
              LicenseAgreement.Get;
              if not LicenseAgreement.Accepted then
                Error(PartnerAgreementNotAcceptedErr)
            end;

        Language.SetRange("Localization Exist",true);
        Language.SetRange("Globally Enabled",true);
        Language."Language ID" := GlobalLanguage;
        if not Language.Find then begin
          Language."Language ID" := WindowsLanguage;
          if not Language.Find then
            Language."Language ID" := ApplicationManagement.ApplicationLanguage;
        end;
        GlobalLanguage := Language."Language ID";

        // Check if the logged in user must change login before allowing access.
        if 0 <> User.Count then begin
          if IdentityManagement.IsUserNamePasswordAuthentication then begin
            User.SetRange("User Security ID",UserSecurityId);
            User.FindFirst;
            if User."Change Password" then
              Page.RunModal(Page::"Change Password");

            SelectLatestVersion;
            User.FindFirst;
            if User."Change Password" then
              Error(Text022);
          end;
          User.SetRange("User Security ID");
        end;

        InitializeCompany;
        CreateProfiles;

        LogInDate := Today;
        LogInTime := Time;
        LogInWorkDate := 0D;

        WorkDate := GetDefaultWorkDate;

        SetupMyCustomer;
        SetupMyItem;
        SetupMyVendor;
        SetupMyAccount;

        //ActiveSession.RESET;
        //IF ActiveSession.COUNT >CountedSuccess THEN ERROR(SuccessfullLogin);

        ApplicationAreaSetup.SetupApplicationArea;

        OnAfterLogInStart;

        //CheckLicenses;
    end;

    local procedure LogInEnd()
    var
        UserSetup: Record "User Setup";
        UserTimeRegister: Record "User Time Register";
        LogOutDate: Date;
        LogOutTime: Time;
        Minutes: Integer;
        UserSetupFound: Boolean;
        RegisterTime: Boolean;
    begin
        if LogInWorkDate <> 0D then
          if LogInWorkDate = LogInDate then
            WorkDate := Today
          else
            WorkDate := LogInWorkDate;

        if UserId <> '' then begin
          if UserSetup.Get(UserId) then begin
            UserSetupFound := true;
            RegisterTime := UserSetup."Register Time";
          end;
          if not UserSetupFound then
            if GetGLSetup then
              RegisterTime := GLSetup."Register Time";
          if RegisterTime then begin
            LogOutDate := Today;
            LogOutTime := Time;
            if (LogOutDate > LogInDate) or (LogOutDate = LogInDate) and (LogOutTime > LogInTime) then
              Minutes := ROUND((1440 * (LogOutDate - LogInDate)) + ((LogOutTime - LogInTime) / 60000),1);
            if Minutes = 0 then
              Minutes := 1;
            UserTimeRegister.Init;
            UserTimeRegister."User ID" := UserId;
            UserTimeRegister.Date := LogInDate;
            if UserTimeRegister.Find then begin
              UserTimeRegister.Minutes := UserTimeRegister.Minutes + Minutes;
              UserTimeRegister.Modify;
            end else begin
              UserTimeRegister.Minutes := Minutes;
              UserTimeRegister.Insert;
            end;
          end;
        end;
    end;


    procedure InitializeCompany()
    begin
        if not GLSetup.Get then
          Codeunit.Run(Codeunit::"Company-Initialize");
    end;


    procedure CreateProfiles()
    var
        "Profile": Record "Profile";
    begin
        if Profile.IsEmpty then begin
          Codeunit.Run(Codeunit::"Conf./Personalization Mgt.");
          Commit;
        end;
    end;

    local procedure GetGLSetup(): Boolean
    begin
        if not GLSetupRead then
          GLSetupRead := GLSetup.Get;
        exit(GLSetupRead);
    end;


    procedure GetDefaultWorkDate(): Date
    var
        GLEntry: Record "G/L Entry";
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
        OK: Boolean;
    begin
        if CompanyInformationMgt.IsDemoCompany then
          if GLEntry.ReadPermission then begin
            GLEntry.SetCurrentkey("G/L Account No.","Posting Date");
            OK := true;
            repeat
              GLEntry.SetFilter("G/L Account No.",'>%1',GLEntry."G/L Account No.");
              GLEntry.SetFilter("Posting Date",'>%1',GLEntry."Posting Date");
              if GLEntry.FindFirst then begin
                GLEntry.SetRange("G/L Account No.",GLEntry."G/L Account No.");
                GLEntry.SetRange("Posting Date");
                GLEntry.FindLast;
              end else
                OK := false
            until not OK;
            if not (GLEntry."Posting Date" in [0D,WorkDate]) then begin
              LogInWorkDate := WorkDate;
              exit(NormalDate(GLEntry."Posting Date"));
            end;
          end;
        exit(WorkDate);
    end;

    local procedure SetupMyCustomer()
    var
        Customer: Record Customer;
        MyCustomer: Record "My Customer";
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
        MaxCustomersToAdd: Integer;
        I: Integer;
    begin
        if not CompanyInformationMgt.IsDemoCompany then
          exit;
        if not Customer.ReadPermission then
          exit;
        MyCustomer.SetRange("User ID",UserId);
        if not MyCustomer.IsEmpty then
          exit;
        I := 0;
        MaxCustomersToAdd := 5;
        Customer.SetFilter(Balance,'<>0');
        if Customer.FindSet then
          repeat
            I += 1;
            MyCustomer."User ID" := UserId;
            MyCustomer.Validate("Customer No.",Customer."No.");
            if MyCustomer.Insert then;
          until (Customer.Next = 0) or (I >= MaxCustomersToAdd);
    end;

    local procedure SetupMyItem()
    var
        Item: Record Item;
        MyItem: Record "My Item";
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
        MaxItemsToAdd: Integer;
        I: Integer;
    begin
        if not CompanyInformationMgt.IsDemoCompany then
          exit;
        if not Item.ReadPermission then
          exit;
        MyItem.SetRange("User ID",UserId);
        if not MyItem.IsEmpty then
          exit;
        I := 0;
        MaxItemsToAdd := 5;

        Item.SetFilter("Unit Price",'<>0');
        if Item.FindSet then
          repeat
            I += 1;
            MyItem."User ID" := UserId;
            MyItem.Validate("Item No.",Item."No.");
            if MyItem.Insert then;
          until (Item.Next = 0) or (I >= MaxItemsToAdd);
    end;

    local procedure SetupMyVendor()
    var
        Vendor: Record Vendor;
        MyVendor: Record "My Vendor";
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
        MaxVendorsToAdd: Integer;
        I: Integer;
    begin
        if not CompanyInformationMgt.IsDemoCompany then
          exit;
        if not Vendor.ReadPermission then
          exit;
        MyVendor.SetRange("User ID",UserId);
        if not MyVendor.IsEmpty then
          exit;
        I := 0;
        MaxVendorsToAdd := 5;
        Vendor.SetFilter(Balance,'<>0');
        if Vendor.FindSet then
          repeat
            I += 1;
            MyVendor."User ID" := UserId;
            MyVendor.Validate("Vendor No.",Vendor."No.");
            if MyVendor.Insert then;
          until (Vendor.Next = 0) or (I >= MaxVendorsToAdd);
    end;

    local procedure SetupMyAccount()
    var
        GLAccount: Record "G/L Account";
        MyAccount: Record "My Account";
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
        MaxAccountsToAdd: Integer;
        I: Integer;
    begin
        if not CompanyInformationMgt.IsDemoCompany then
          exit;
        if not GLAccount.ReadPermission then
          exit;
        MyAccount.SetRange("User ID",UserId);
        if not MyAccount.IsEmpty then
          exit;
        I := 0;
        MaxAccountsToAdd := 5;
        GLAccount.SetRange("Reconciliation Account",true);
        if GLAccount.FindSet then
          repeat
            I += 1;
            MyAccount."User ID" := UserId;
            MyAccount.Validate("Account No.",GLAccount."No.");
            if MyAccount.Insert then;
          until (GLAccount.Next = 0) or (I >= MaxAccountsToAdd);
    end;


    procedure UserLogonExistsWithinPeriod(PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";NoOfPeriods: Integer): Boolean
    var
        SessionEvent: Record "Session Event";
        PeriodFormManagement: Codeunit PeriodFormManagement;
        FromEventDateTime: DateTime;
    begin
        FromEventDateTime := CreateDatetime(PeriodFormManagement.MoveDateByPeriod(Today,PeriodType,-NoOfPeriods),Time);
        SessionEvent.SetRange("Event Datetime",FromEventDateTime,CurrentDatetime);
        SessionEvent.SetRange("Event Type",SessionEvent."event type"::Logon);
        // Filter out sessions of type Web Service, Client Service, NAS, Background and Management Client
        SessionEvent.SetFilter("Client Type",'<%1|>%2',
          SessionEvent."client type"::"Web Service",SessionEvent."client type"::"Management Client");
        SessionEvent.SetRange("Database Name",GetDatabase);
        exit(not SessionEvent.IsEmpty);
    end;

    local procedure GetDatabase(): Text[250]
    var
        ActiveSession: Record "Active Session";
    begin
        ActiveSession.Get(ServiceInstanceId,SessionId);
        exit(ActiveSession."Database Name");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLogInStart()
    begin
    end;

    local procedure CheckLicenses()
    var
        CompanyInformation: Record "Company Information";
        RecDate: Record Date;
        TotalDays: Integer;
    begin
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then;
        if CompanyInformation."License end Date"<>0D then begin
          if CompanyInformation."License end Date">Today then begin
        RecDate.Reset;
        RecDate.SetRange("Period Type",RecDate."period type"::Date);
        RecDate.SetRange("Period Start",Today,CompanyInformation."License end Date");
        if RecDate.Find('-') then;
        TotalDays := RecDate.Count;
        if TotalDays<11 then
        Message('Your Developer licenses: \6658091-AppKings.DEV/2019\Expires in '+Format(TotalDays)+' Day(s)');
        end else Error('Your developer licenses expired on '+Format(CompanyInformation."License end Date"));
        end;
    end;
}

