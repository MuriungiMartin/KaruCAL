#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6302 "Azure AD Access Dialog"
{
    Caption = 'AZURE ACTIVE DIRECTORY SERVICE PERMISSIONS';
    PageType = NavigatePage;

    layout
    {
        area(content)
        {
            label(Para0)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'The functionality you have selected to use requires services from Azure Active Directory to access your system.';
            }
            label(Para1)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Before you can begin using this functionality, you must first grant access to these services.  To grant access, choose the ''Authorize Azure Services''  link.';
            }
            usercontrol(OAuthIntegration;"Microsoft.Dynamics.Nav.Client.OAuthIntegration")
            {
                ApplicationArea = Basic,Suite;

                trigger ControlAddInReady()
                begin
                    CurrPage.OAuthIntegration.Authorize(AzureAdMgt.GetAuthCodeUrl(ResourceUrl),LinkNameTxt,LinkTooltipTxt);
                end;

                trigger AuthorizationCodeRetrieved(authorizationCode: Text)
                begin
                    AuthCode := authorizationCode;
                    CurrPage.Close;
                    if FileManagement.IsWindowsClient then
                      Message(CloseWindowMsg);
                end;

                trigger AuthorizationErrorOccurred(error: Text;description: Text)
                var
                    ActivityLog: Record "Activity Log";
                    AzureAdAppSetup: Record "Azure AD App Setup";
                begin
                    if error <> 'access_denied' then begin
                      if not AzureAdAppSetup.IsEmpty then begin
                        AzureAdAppSetup.FindFirst;
                        ActivityLog.LogActivityForUser(
                          AzureAdAppSetup.RecordId,ActivityLog.Status::Failed,'Azure Authorization',description,error,UserId);
                      end;
                      ThrowError;
                    end;
                end;
            }
            label(Para2)
            {
                ApplicationArea = Basic,Suite;
                Caption = '';
                ShowCaption = false;
            }
            label(Para3)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Azure Active Directory Services:';
                Style = Strong;
                StyleExpr = true;
            }
            field(Para4;ResourceFriendlyName)
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                ShowCaption = false;
                Visible = ResourceFriendlyName <> '';
            }
        }
    }

    actions
    {
    }

    var
        AzureAdMgt: Codeunit "Azure AD Mgt.";
        FileManagement: Codeunit "File Management";
        AuthCode: Text;
        ResourceUrl: Text;
        AuthorizationTxt: label 'Error occurred while trying to authorize with Azure Active Directory. Please try again or contact your system administrator if error persist.';
        ResourceFriendlyName: Text;
        CloseWindowMsg: label 'Authorization sucessful. Close the window to proceed.';
        LinkNameTxt: label 'Authorize Azure Services';
        LinkTooltipTxt: label 'You will be redirected to the authorization provider in a different browser instance.';


    procedure GetAuthorizationCode(Resource: Text;ResourceName: Text): Text
    begin
        ResourceUrl := Resource;
        ResourceFriendlyName := ResourceName;
        CurrPage.Update;
        if not AzureAdMgt.IsAzureADAppSetupDone then begin
          Page.RunModal(Page::"Azure AD App Setup Wizard");
          if not AzureAdMgt.IsAzureADAppSetupDone then
            exit('');
        end;

        CurrPage.RunModal;
        exit(AuthCode);
    end;

    local procedure ThrowError()
    begin
        if FileManagement.IsWindowsClient then
          Message(AuthorizationTxt)
        else
          Error(AuthorizationTxt)
    end;
}

