#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1321 "Getting Started Mgt."
{

    trigger OnRun()
    begin
        if IsGettingStartedVisible then
          DisableGettingStartedForCurrentUser
        else
          EnableGettingStartedForCurrentUser;

        Message(GettingStartedRefreshThePageMsg);
    end;

    var
        GettingStartedRefreshThePageMsg: label 'Refresh the page to see the change.';
        WelcomePageTxt: label 'Welcome!';
        SettingUpYourSystemPageTxt: label 'Setting up Your System';
        ForwardLinkMgt: Codeunit "Forward Link Mgt.";

    local procedure EnableGettingStartedForCurrentUser()
    var
        UserPreference: Record "User Preference";
    begin
        UserPreference.EnableInstruction(GetGettingStartedCode);
    end;

    local procedure DisableGettingStartedForCurrentUser()
    var
        UserPreference: Record "User Preference";
    begin
        UserPreference.DisableInstruction(GetGettingStartedCode);
    end;


    procedure IsGettingStartedVisible(): Boolean
    var
        UserPreference: Record "User Preference";
    begin
        exit(not UserPreference.Get(UserId,GetGettingStartedCode) and NotDevice);
    end;


    procedure PlayWelcomeVideoOnFirstLogin()
    begin
        if ShouldWelcomeVideoBePlayed then begin
          SetWelcomeVideoPlayed;
          PlayWelcomeVideoForWebClient;
        end;
    end;


    procedure PlayWelcomeVideoForWebClient()
    begin
        PlayVideo(WelcomePageTxt,
          ForwardLinkMgt.GetLanguageSpecificUrl('https://go.microsoft.com/fwlink/?LinkID=506729'));
    end;


    procedure PlaySettingUpYourSystemVideoForWebClient()
    begin
        PlayVideo(SettingUpYourSystemPageTxt,
          ForwardLinkMgt.GetLanguageSpecificUrl('https://go.microsoft.com/fwlink/?LinkID=506736'));
    end;


    procedure PlaySettingUpYourSystemVideoForTablet()
    begin
        PlayVideoTablet(
          SettingUpYourSystemPageTxt,
          ForwardLinkMgt.GetLanguageSpecificUrl('https://go.microsoft.com/fwlink/?LinkID=506791'),
          ForwardLinkMgt.GetLanguageSpecificUrl('https://go.microsoft.com/fwlink/?LinkID=507484'));
    end;

    local procedure PlayVideo(PageCaption: Text;Src: Text)
    var
        VideoPlayerPage: Page "Loading View Part";
        Height: Integer;
        Width: Integer;
    begin
        Height := 415;
        Width := 740;

        VideoPlayerPage.SetParameters(Height,Width,Src,PageCaption);
        VideoPlayerPage.Run;
    end;

    local procedure PlayVideoTablet(PageCaption: Text;Src: Text;SrcLink: Text)
    var
        VideoPlayerPageTablet: Page "Video Player Page Tablet";
        Height: Integer;
        Width: Integer;
    begin
        Height := 415;
        Width := 740;

        VideoPlayerPageTablet.SetParameters(Height,Width,Src,SrcLink,PageCaption);
        VideoPlayerPageTablet.Run;
    end;


    procedure ShouldWelcomeVideoBePlayed(): Boolean
    var
        UserPreference: Record "User Preference";
    begin
        exit(not UserPreference.Get(UserId,GetWelcomeVideoCode));
    end;

    local procedure SetWelcomeVideoPlayed()
    var
        UserPreference: Record "User Preference";
    begin
        UserPreference.DisableInstruction(GetWelcomeVideoCode);
    end;

    local procedure GetGettingStartedCode(): Code[20]
    begin
        exit('GETTINGSTARTED');
    end;

    local procedure GetWelcomeVideoCode(): Code[20]
    begin
        exit('WELCOMEVIDEOPLAYED');
    end;

    local procedure NotDevice(): Boolean
    begin
        exit(not (CurrentClientType in [Clienttype::Tablet,Clienttype::Phone]));
    end;
}

