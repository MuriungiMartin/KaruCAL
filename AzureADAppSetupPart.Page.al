#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6301 "Azure AD App Setup Part"
{
    Caption = '<Azure AD Application Setup Part>';
    PageType = CardPart;
    SourceTable = "Azure AD App Setup";

    layout
    {
        area(content)
        {
            field(HomePageUrl;HomePageUrl)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Home page URL';
                Editable = false;
                ToolTip = 'Specifies the home page URL to enter when registering an Azure application.';
            }
            field(RedirectUrl;RedirectUrl)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Reply URL';
                Editable = false;
                ToolTip = 'Specifies the reply URL to enter when registering an Azure application.';
            }
            field(AppId;AppId)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Application ID';
                ShowMandatory = true;
            }
            field(SecretKey;SecretKey)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Key';
                NotBlank = true;
                ShowMandatory = true;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        AzureADMgt: Codeunit "Azure AD Mgt.";
    begin
        if not FindFirst then
          Init;

        HomePageUrl := GetUrl(Clienttype::Web);
        RedirectUrl := AzureADMgt.GetRedirectUrl;
        AppId := "App ID";
        SecretKey := GetSecretKey;
    end;

    var
        HomePageUrl: Text;
        RedirectUrl: Text[150];
        SecretKey: Text;
        AppId: Guid;
        InvalidAppIdErr: label 'Enter valid GUID for Application ID.';
        InvalidClientSecretErr: label 'Key is required.';


    procedure Save()
    begin
        "Redirect URL" := RedirectUrl;
        "App ID" := AppId;
        SetSecretKey(SecretKey);

        if not Modify(true) then
          Insert(true);
    end;


    procedure ValidateFields()
    begin
        if IsNullGuid(AppId) then
          Error(InvalidAppIdErr);

        if SecretKey = '' then
          Error(InvalidClientSecretErr);
    end;
}

