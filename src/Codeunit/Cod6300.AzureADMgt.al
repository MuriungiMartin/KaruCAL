#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6300 "Azure AD Mgt."
{
    // // Provides functions to authorize NAV app to use Azure Active Directory resources on behalf of a user.


    trigger OnRun()
    begin
    end;

    var
        AzureADAppSetup: Record "Azure AD App Setup";
        TypeHelper: Codeunit "Type Helper";
        AzureADNotSetupErr: label '%1 is not registered in your Azure Active Directory tenant.', Comment='%1 - product name';
        AzureAdSetupTxt: label 'Set Up Azure Active Directory Application';
        AzureADAuthEndpointTxt: label 'https://login.windows.net/common/oauth2/authorize', Locked=true;
        AzureADAuthEndpointPPETxt: label 'https://login.windows-ppe.net/common/oauth2/authorize', Locked=true;
        O365ResourceTxt: label 'https://outlook.office365.com', Locked=true;
        O365ResourcePPETxt: label 'https://edgesdf.outlook.com', Locked=true;
        O365ResourceNameTxt: label 'Office 365 Services', Locked=true;
        OAuthLandingPageTxt: label 'OAuthLanding.htm', Locked=true;


    procedure GetAuthCodeUrl(ResourceName: Text) AuthCodeUrl: Text
    begin
        // Pass ResourceName as empty string if you want to authorize all azure resources.
        AuthCodeUrl := GetAzureADAuthEndpoint;
        AuthCodeUrl += '?response_type=code';
        AuthCodeUrl += '&client_id=' + UrlEncode(GetClientId);
        if ResourceName <> '' then
          AuthCodeUrl += '&resource=' + UrlEncode(ResourceName);
        AuthCodeUrl += '&redirect_uri=' + UrlEncode(GetRedirectUrl);
    end;

    local procedure AcquireTokenByAuthorizationCode(AuthorizationCode: Text;ResourceUrl: Text) AccessToken: Text
    var
        AzureADAuthFlow: Codeunit "Azure AD Auth Flow";
    begin
        // This will return access token and also cache it for future use.
        AzureADAuthFlow.Initialize(UserSecurityId,GetRedirectUrl);

        if IsSaaS then
          AccessToken := AzureADAuthFlow.AcquireTokenByAuthorizationCode(AuthorizationCode,ResourceUrl)
        else begin
          AzureADAppSetup.FindFirst;
          AccessToken := AzureADAuthFlow.AcquireTokenByAuthorizationCodeWithCredentials(
              AuthorizationCode,
              GetClientId,
              AzureADAppSetup.GetSecretKey,
              ResourceUrl);
        end;
    end;


    procedure GetAccessToken(ResourceUrl: Text;ResourceName: Text;ShowDialog: Boolean) AccessToken: Text
    var
        AzureADAccessDialog: Page "Azure AD Access Dialog";
        AuthorizationCode: Text;
    begin
        // Does everything required to retrieve an access token for the given service, including
        // showing the Azure AD wizard and auth code retrieval form if necessary.
        if (not IsAzureADAppSetupDone ) and ShowDialog then begin
          Page.RunModal(Page::"Azure AD App Setup Wizard");
          if not IsAzureADAppSetupDone then
            // Don't continue if user cancelled or errored out of the setup wizard.
            exit('');
        end;

        if AcquireToken(ResourceUrl,AccessToken) then begin
          if AccessToken <> '' then
            exit(AccessToken);
        end;

        if ShowDialog then
          AuthorizationCode := AzureADAccessDialog.GetAuthorizationCode(ResourceUrl,ResourceName);
        if AuthorizationCode <> '' then
          AccessToken := AcquireTokenByAuthorizationCode(AuthorizationCode,ResourceUrl);
    end;


    procedure GetAccessTokenForUser(ResourceUrl: Text;UserName: Code[50]) AccessToken: Text
    var
        User: Record User;
    begin
        User.SetRange("User Name",UserName);
        User.FindFirst;
        if not AcquireTokenForUser(ResourceUrl,User."User Security ID",AccessToken) then;
    end;

    local procedure UrlEncode(UrlComponent: Text): Text
    var
        HttpUtility: dotnet HttpUtility;
    begin
        exit(HttpUtility.UrlEncode(UrlComponent));
    end;


    procedure GetAzureADAuthEndpoint(): Text
    begin
        if IsPPE then
          exit(AzureADAuthEndpointPPETxt);

        exit(AzureADAuthEndpointTxt);
    end;


    procedure GetRedirectUrl(): Text[150]
    var
        UriBuilder: dotnet UriBuilder;
        PathString: dotnet String;
    begin
        if not IsSaaS and not AzureADAppSetup.IsEmpty then begin
          // Use existing redirect URL if already in table - necessary for Windows client which would otherwise
          // generate a different URL for each computer and thus not match the company's Azure application.
          AzureADAppSetup.FindFirst;
          exit(AzureADAppSetup."Redirect URL");
        end;

        // Due to a bug in ADAL 2.9, it will not consider URI's to be equal if one URI specified the default port number (ex: 443 for HTTPS)
        // and the other did not. UriBuilder(...).Uri.ToString() is a way to remove any protocol-default port numbers, such as 80 for HTTP
        // and 443 for HTTPS. This bug appears to be fixed in ADAL 3.1+.
        UriBuilder := UriBuilder.UriBuilder(GetUrl(Clienttype::Web));

        // Append a '/' character to the end of the path if one does not exist already.
        PathString := UriBuilder.Path;
        if PathString.LastIndexOf('/') < (PathString.Length - 1) then
          UriBuilder.Path := UriBuilder.Path + '/';

        // Append the desired redirect page to the path.
        UriBuilder.Path := UriBuilder.Path + OAuthLandingPageTxt;
        UriBuilder.Query := '';

        // Pull out the full URL by the URI and convert it to a string.
        exit(UriBuilder.Uri.ToString);
    end;


    procedure GetO365Resource() Resource: Text
    begin
        if IsPPE then
          Resource := O365ResourcePPETxt
        else
          Resource := O365ResourceTxt;
    end;


    procedure GetO365ResourceName(): Text
    begin
        exit(O365ResourceNameTxt);
    end;


    procedure IsSaaS(): Boolean
    var
        PermissionManager: Codeunit "Permission Manager";
    begin
        exit(PermissionManager.SoftwareAsAService);
    end;

    local procedure GetClientId() ClientID: Text
    var
        AzureADAuthFlow: Codeunit "Azure AD Auth Flow";
    begin
        if IsSaaS then begin
          AzureADAuthFlow.Initialize(UserSecurityId,GetRedirectUrl);
          ClientID := AzureADAuthFlow.GetSaasClientId;
        end else begin
          if AzureADAppSetup.IsEmpty then
            Error(AzureADNotSetupErr,ProductName.Short);

          AzureADAppSetup.FindFirst;
          ClientID := TypeHelper.GetGuidAsString(AzureADAppSetup."App ID");
        end;
    end;


    procedure IsAzureADAppSetupDone(): Boolean
    begin
        if (not IsSaaS) and AzureADAppSetup.IsEmpty then
          exit(false);

        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", 'OnCompanyInitialize', '', false, false)]

    procedure CreateAssistedSetup()
    var
        AssistedSetup: Record "Assisted Setup";
        NewOrderNumber: Integer;
    begin
        if AssistedSetup.Get(Page::"Azure AD App Setup Wizard") then
          exit;

        AssistedSetup.LockTable;
        AssistedSetup.SetCurrentkey(Order,Visible);
        if AssistedSetup.FindLast then
          NewOrderNumber := AssistedSetup.Order + 1
        else
          NewOrderNumber := 1;

        Clear(AssistedSetup);
        AssistedSetup.Init;
        AssistedSetup.Validate("Page ID",Page::"Azure AD App Setup Wizard");
        AssistedSetup.Validate(Name,AzureAdSetupTxt);
        AssistedSetup.Validate(Order,NewOrderNumber);
        if IsAzureADAppSetupDone then
          AssistedSetup.Validate(Status,AssistedSetup.Status::Completed)
        else
          AssistedSetup.Validate(Status,AssistedSetup.Status::"Not Completed");
        AssistedSetup.Validate(Visible,not IsSaaS);
        AssistedSetup.Insert(true);
    end;


    procedure CreateExchangeServiceWrapperWithToken(Token: Text;var Service: dotnet ExchangeServiceWrapper)
    var
        AzureADAuthFlow: Codeunit "Azure AD Auth Flow";
    begin
        AzureADAuthFlow.CreateExchangeServiceWrapperWithToken(Token,Service);
    end;

    [TryFunction]
    local procedure AcquireToken(ResourceName: Text;var AccessToken: Text)
    begin
        AcquireTokenForUser(ResourceName,UserSecurityId,AccessToken);
    end;

    [TryFunction]
    local procedure AcquireTokenForUser(ResourceName: Text;SecurityID: Guid;var AccessToken: Text)
    var
        AzureADAuthFlow: Codeunit "Azure AD Auth Flow";
    begin
        // This function will return access token for a resource
        // Need to run the Azure AD Setup wizard before calling into this.
        // Returns empty string if access token not available

        AzureADAuthFlow.Initialize(SecurityID,GetRedirectUrl);

        if IsSaaS then
          AccessToken := AzureADAuthFlow.AcquireTokenFromCache(ResourceName)
        else begin
          AzureADAppSetup.FindFirst;
          AccessToken := AzureADAuthFlow.AcquireTokenFromCacheWithCredentials(
              GetClientId,
              AzureADAppSetup.GetSecretKey,
              ResourceName);
        end;
    end;

    local procedure IsPPE(): Boolean
    var
        ExchangeWebServicesServer: Codeunit "Exchange Web Services Server";
    begin
        exit(ExchangeWebServicesServer.IsPPE);
    end;
}

