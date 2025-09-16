#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 43 LanguageManagement
{

    trigger OnRun()
    begin
    end;


    procedure SetGlobalLanguage()
    var
        TempLanguage: Record "Windows Language" temporary;
    begin
        GetApplicationLanguages(TempLanguage);

        with TempLanguage do begin
          SetCurrentkey(Name);
          if Get(GlobalLanguage) then;
          Page.Run(Page::"Application Languages",TempLanguage);
        end;
    end;

    local procedure GetApplicationLanguages(var TempLanguage: Record "Windows Language" temporary)
    var
        Language: Record "Windows Language";
        ApplicationManagement: Codeunit ApplicationManagement;
    begin
        with Language do begin
          SetRange("Localization Exist",true);
          SetRange("Globally Enabled",true);
          if FindSet then
            repeat
              TempLanguage := Language;
              TempLanguage.Insert;
            until Next = 0;
          if Get(ApplicationManagement.ApplicationLanguage) then begin
            TempLanguage := Language;
            if TempLanguage.Insert then;
          end;
        end;
    end;


    procedure ValidateApplicationLanguage(LanguageID: Integer)
    var
        TempLanguage: Record "Windows Language" temporary;
    begin
        GetApplicationLanguages(TempLanguage);

        with TempLanguage do begin
          SetRange("Language ID",LanguageID);
          FindFirst;
        end;
    end;


    procedure LookupApplicationLanguage(var LanguageID: Integer)
    var
        TempLanguage: Record "Windows Language" temporary;
    begin
        GetApplicationLanguages(TempLanguage);

        with TempLanguage do begin
          if Get(LanguageID) then;
          if Page.RunModal(Page::"Windows Languages",TempLanguage) = Action::LookupOK then
            LanguageID := "Language ID";
        end;
    end;


    procedure LookupWindowsLocale(var LocaleID: Integer)
    var
        WindowsLanguage: Record "Windows Language";
    begin
        with WindowsLanguage do begin
          SetCurrentkey(Name);
          if Page.RunModal(Page::"Windows Languages",WindowsLanguage) = Action::LookupOK then
            LocaleID := "Language ID";
        end;
    end;
}

