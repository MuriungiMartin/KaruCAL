#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9176 "My Settings"
{
    // Contains various system-wide settings which are personal to an individual user.
    // Styled as a StandardDialog which is ideal for presenting a single field. Once more fields are added,
    // this page should be converted to a Card page.

    ApplicationArea = Basic;
    Caption = 'My Settings';
    PageType = StandardDialog;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(Control14)
            {
                field(RoleCenter;GetProfileName)
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    Caption = 'Role Center';
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Role Center that is associated with the current user.';

                    trigger OnAssistEdit()
                    var
                        "Profile": Record "Profile";
                    begin
                        if Page.RunModal(Page::"Available Role Centers",Profile) = Action::LookupOK then
                          ProfileID := Profile."Profile ID";
                    end;
                }
                field(Company;VarCompany)
                {
                    ApplicationArea = All;
                    Caption = 'Company';
                    Editable = false;
                    ToolTip = 'Specifies the database company that you work in. You must sign out and then sign in again for the change to take effect.';

                    trigger OnAssistEdit()
                    var
                        SelectedCompany: Record Company;
                        AllowedCompanies: Page "Allowed Companies";
                    begin
                        AllowedCompanies.Initialize;

                        if SelectedCompany.Get(COMPANYNAME) then
                          AllowedCompanies.SetRecord(SelectedCompany);

                        AllowedCompanies.LookupMode(true);

                        if AllowedCompanies.RunModal = Action::LookupOK then begin
                          AllowedCompanies.GetRecord(SelectedCompany);
                          OnCompanyChange(SelectedCompany.Name);
                          VarCompany := SelectedCompany.Name;
                        end;
                    end;
                }
                field(NewWorkdate;NewWorkdate)
                {
                    ApplicationArea = All;
                    Caption = 'Work Date';
                    ToolTip = 'Specifies the date that will be entered on transactions, typically today''s date. This change only affects the date on new transactions.';

                    trigger OnValidate()
                    begin
                        WorkDate := NewWorkdate;
                    end;
                }
                group("Region & Language")
                {
                    Caption = 'Region & Language';
                    Visible = NotRunningOnSaaS;
                    field(Locale;GetLocale)
                    {
                        ApplicationArea = All;
                        Caption = 'Region';
                        ToolTip = 'Specifies the regional settings, such as date and numeric format, on all devices. You must sign out and then sign in again for the change to take effect.';
                        Visible = NotRunningOnSaaS;

                        trigger OnAssistEdit()
                        var
                            LanguageManagement: Codeunit Language;
                        begin
                            if not PermissionManager.SoftwareAsAService then
                              LanguageManagement.LookupWindowsLocale(LocaleID);
                        end;
                    }
                    field(Language;GetLanguage)
                    {
                        ApplicationArea = All;
                        Caption = 'Language';
                        Editable = false;
                        Importance = Promoted;
                        ToolTip = 'Specifies the display language, on all devices. You must sign out and then sign in again for the change to take effect.';
                        Visible = NotRunningOnSaaS;

                        trigger OnAssistEdit()
                        var
                            LanguageManagement: Codeunit Language;
                        begin
                            if not PermissionManager.SoftwareAsAService then
                              LanguageManagement.LookupApplicationLanguage(LanguageID);
                        end;
                    }
                    field(TimeZone;GetTimeZone)
                    {
                        ApplicationArea = All;
                        Caption = 'Time Zone';
                        ToolTip = 'Specifies the time zone that you work in. You must sign out and then sign in again for the change to take effect.';
                        Visible = NotRunningOnSaaS;

                        trigger OnAssistEdit()
                        var
                            ConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
                        begin
                            if not PermissionManager.SoftwareAsAService then
                              ConfPersonalizationMgt.LookupTimeZone(TimeZoneID);
                        end;
                    }
                }
                field(MyNotificationsLbl;MyNotificationsLbl)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = IsNotOnMobile;

                    trigger OnDrillDown()
                    begin
                        Page.RunModal(Page::"My Notifications");
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        NotRunningOnSaaS := not PermissionManager.SoftwareAsAService;
        IsNotOnMobile := CurrentClientType <> Clienttype::Phone;
    end;

    trigger OnOpenPage()
    var
        UserPersonalization: Record "User Personalization";
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
    begin
        with UserPersonalization do begin
          Get(UserSecurityId);
          ProfileID := "Profile ID";
          LanguageID := "Language ID";
          LocaleID := "Locale ID";
          TimeZoneID := "Time Zone";
          VarCompany := Company;
          NewWorkdate := WorkDate;
        end;
        if RoleCenterNotificationMgt.IsEvaluationNotificationClicked then begin
          // set notification state to normal to avoid resending
          RoleCenterNotificationMgt.EnableEvaluationNotification;
          Commit;
        end;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        UserPersonalization: Record "User Personalization";
        ShowMessage: Boolean;
    begin
        if CloseAction = Action::OK then begin
          with UserPersonalization do begin
            Get(UserSecurityId);

            if ("Language ID" <> LanguageID) or
               ("Locale ID" <> LocaleID) or
               ("Time Zone" <> TimeZoneID) or
               (Company <> VarCompany) or
               ("Profile ID" <> ProfileID)
            then begin
              Validate("Profile ID",ProfileID);
              Validate("Language ID",LanguageID);
              Validate("Locale ID",LocaleID);
              Validate("Time Zone",TimeZoneID);
              Validate(Company,VarCompany);
              Modify(true);
              ShowMessage := true;
            end;
          end;

          if ShowMessage then
            Message(ReSignInMsg);
        end;
    end;

    var
        PermissionManager: Codeunit "Permission Manager";
        LanguageID: Integer;
        ReSignInMsg: label 'You must sign out and then sign in again for the change to take effect.', Comment='"sign out" and "sign in" are the same terms as shown in the Dynamics NAV client.';
        LocaleID: Integer;
        TimeZoneID: Text[180];
        VarCompany: Text;
        NewWorkdate: Date;
        ProfileID: Code[30];
        NotRunningOnSaaS: Boolean;
        MyNotificationsLbl: label 'Change when I receive notifications.';
        IsNotOnMobile: Boolean;

    local procedure GetLanguage(): Text
    begin
        exit(GetWindowsLanguageNameFromID(LanguageID));
    end;

    local procedure GetWindowsLanguageNameFromID(ID: Integer): Text
    var
        WindowsLanguage: Record "Windows Language";
    begin
        if WindowsLanguage.Get(ID) then
          exit(WindowsLanguage.Name);
    end;

    local procedure GetLocale(): Text
    begin
        exit(GetWindowsLanguageNameFromID(LocaleID));
    end;

    local procedure GetTimeZone(): Text
    var
        TimeZone: Record "Time Zone";
    begin
        TimeZone.SetRange(ID,TimeZoneID);
        if TimeZone.FindFirst then
          exit(TimeZone."Display Name");
    end;

    local procedure GetProfileName(): Text
    var
        "Profile": Record "Profile";
    begin
        if not Profile.Get(ProfileID) then begin
          Profile.SetRange("Default Role Center",true);
          if not Profile.FindFirst then
            exit('');
        end;
        exit(Profile.Description);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCompanyChange(NewCompanyName: Text)
    begin
    end;
}

