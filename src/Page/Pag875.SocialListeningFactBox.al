#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 875 "Social Listening FactBox"
{
    Caption = 'Social Media Insights FactBox';
    PageType = CardPart;
    SourceTable = "Social Listening Search Topic";

    layout
    {
        area(content)
        {
            usercontrol(SocialListening;"Microsoft.Dynamics.Nav.Client.SocialListening")
            {
                ApplicationArea = Basic;

                trigger AddInReady()
                begin
                    IsAddInReady := true;
                    UpdateAddIn;
                end;

                trigger DetermineUserAuthenticationResult(result: Integer)
                begin
                    case result of
                      -1: // Error
                        CurrPage.SocialListening.ShowMessage(SocialListeningMgt.GetAuthenticationConectionErrorMsg);
                      0: // User is not authenticated
                        CurrPage.SocialListening.ShowMessage(SocialListeningMgt.GetAuthenticationUserErrorMsg);
                      1: // User is authenticated
                        CurrPage.SocialListening.ShowWidget(SocialListeningMgt.GetAuthenticationWidget("Search Topic"));
                    end;
                end;

                trigger MessageLinkClick(identifier: Integer)
                begin
                    case identifier of
                      1: // Refresh
                        UpdateAddIn;
                    end;
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        IsDataReady := true;
        UpdateAddIn;
    end;

    var
        SocialListeningMgt: Codeunit "Social Listening Management";
        IsDataReady: Boolean;
        IsAddInReady: Boolean;

    local procedure UpdateAddIn()
    var
        SocialListeningSetup: Record "Social Listening Setup";
    begin
        if "Search Topic" = '' then
          exit;
        if not IsAddInReady then
          exit;

        if not IsDataReady then
          exit;

        if not SocialListeningSetup.Get or
           (SocialListeningSetup."Solution ID" = '')
        then
          exit;

        CurrPage.SocialListening.DetermineUserAuthentication(SocialListeningMgt.MSLAuthenticationStatusURL);
    end;
}

