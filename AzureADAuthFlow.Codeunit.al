#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6303 "Azure AD Auth Flow"
{
    // // This codeunit should never be called directly. It should only be called through COD6300.


    trigger OnRun()
    begin
    end;

    var
        AuthFlow: dotnet ALAzureAdCodeGrantFlow;
        ProviderNotInitializedErr: label 'The Azure AD Authentication Flow provider has not been initialized.';


    procedure CanHandle(): Boolean
    var
        AzureADMgtSetup: Record "Azure AD Mgt. Setup";
    begin
        if AzureADMgtSetup.Get then
          exit(AzureADMgtSetup."Auth Flow Codeunit ID" = Codeunit::"Azure AD Auth Flow");

        exit(false);
    end;


    procedure Initialize(SecurityId: Guid;RedirectUri: Text)
    var
        Uri: dotnet Uri;
    begin
        if CanHandle then
          AuthFlow := AuthFlow.ALAzureAdCodeGrantFlow(SecurityId,Uri.Uri(RedirectUri))
        else
          OnInitialize(SecurityId,RedirectUri,AuthFlow);
    end;


    procedure AcquireTokenByAuthorizationCode(AuthorizationCode: Text;ResourceName: Text) AccessToken: Text
    begin
        CheckProvider;
        if CanHandle then
          AccessToken := AuthFlow.ALAcquireTokenByAuthorizationCode(AuthorizationCode,ResourceName)
        else
          OnAcquireTokenByAuthorizationCode(AuthorizationCode,ResourceName,AccessToken);
    end;


    procedure AcquireTokenByAuthorizationCodeWithCredentials(AuthorizationCode: Text;ClientID: Text;ApplicationKey: Text;ResourceName: Text) AccessToken: Text
    begin
        CheckProvider;
        if CanHandle then
          AccessToken := AuthFlow.ALAcquireTokenByAuthorizationCodeWithCredentials(AuthorizationCode,ClientID,ApplicationKey,ResourceName)
        else
          OnAcquireTokenByAuthorizationCodeWithCredentials(AuthorizationCode,ClientID,ApplicationKey,ResourceName,AccessToken);
    end;


    procedure AcquireTokenFromCache(ResourceName: Text) AccessToken: Text
    begin
        CheckProvider;
        if CanHandle then
          AccessToken := AuthFlow.ALAcquireTokenFromCache(ResourceName)
        else
          OnAcquireTokenFromCache(ResourceName,AccessToken);
    end;


    procedure AcquireTokenFromCacheWithCredentials(ClientID: Text;AppKey: Text;ResourceName: Text) AccessToken: Text
    begin
        CheckProvider;
        if CanHandle then
          AccessToken := AuthFlow.ALAcquireTokenFromCacheWithCredentials(ClientID,AppKey,ResourceName)
        else
          OnAcquireTokenFromCacheWithCredentials(ClientID,AppKey,ResourceName,AccessToken);
    end;


    procedure GetSaasClientId() ClientID: Text
    begin
        CheckProvider;
        if CanHandle then
          ClientID := AuthFlow.ALGetSaasClientId
        else
          OnGetSaasClientId(ClientID);
    end;


    procedure CreateExchangeServiceWrapperWithToken(Token: Text;var Service: dotnet ExchangeServiceWrapper)
    var
        ServiceFactory: dotnet ServiceWrapperFactory;
    begin
        if CanHandle then
          Service := ServiceFactory.CreateServiceWrapperWithToken(Token)
        else
          OnCreateExchangeServiceWrapperWithToken(Token,Service);
    end;

    local procedure CheckProvider()
    var
        Initialized: Boolean;
    begin
        if CanHandle then
          Initialized := not IsNull(AuthFlow)
        else
          OnCheckProvider(Initialized);

        if not Initialized then
          Error(ProviderNotInitializedErr);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInitialize(SecurityId: Guid;RedirectUri: Text;var AzureADAuthFlow: dotnet ALAzureAdCodeGrantFlow)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAcquireTokenByAuthorizationCode(AuthorizationCode: Text;ResourceName: Text;var AccessToken: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAcquireTokenByAuthorizationCodeWithCredentials(AuthorizationCode: Text;ClientID: Text;ApplicationKey: Text;ResourceName: Text;var AccessToken: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAcquireTokenFromCache(ResourceName: Text;var AccessToken: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAcquireTokenFromCacheWithCredentials(ClientID: Text;AppKey: Text;ResourceName: Text;var AccessToken: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetSaasClientId(var ClientID: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateExchangeServiceWrapperWithToken(Token: Text;var Service: dotnet ExchangeServiceWrapper)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckProvider(var Result: Boolean)
    begin
    end;
}

