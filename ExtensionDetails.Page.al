#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2501 "Extension Details"
{
    Caption = 'Extension Details';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = NavigatePage;
    SourceTable = "NAV App";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group("Install NAV Extension")
            {
                Caption = 'Install Extension';
                Editable = false;
                Visible = Step1Enabled;
                group(InstallGroup)
                {
                    Caption = 'Install Extension';
                    Editable = false;
                    InstructionalText = 'Extensions add new capabilities that extend and enhance functionality.';
                    field(In_Name;Name)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the name of the extension.';
                    }
                    field(In_Des;AppDescription)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Description';
                        Editable = false;
                        MultiLine = true;
                        ToolTip = 'Specifies the full description of the extension.';
                    }
                    field(In_Ver;VersionDisplay)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Version';
                        ToolTip = 'Specifies the version of the extension.';
                    }
                    field(In_Pub;Publisher)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the person or company that created the extension';
                    }
                    field(In_Url;UrlLbl)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ShowCaption = false;
                        ToolTip = 'Specifies the support site for the extension.';

                        trigger OnDrillDown()
                        begin
                            Hyperlink(Url);
                        end;
                    }
                    field(In_Help;HelpLbl)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ShowCaption = false;
                        ToolTip = 'Specifies the Help site for the extension.';

                        trigger OnDrillDown()
                        begin
                            Hyperlink(Help);
                        end;
                    }
                }
            }
            group("Uninstall NAV Extension")
            {
                Caption = 'Uninstall Extension';
                Visible = IsInstalled;
                group(UninstallGroup)
                {
                    Caption = 'Uninstall Extension';
                    Editable = false;
                    InstructionalText = 'Uninstall extension to remove added features.';
                    field(Un_Name;Name)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the name of the extension.';
                    }
                    field(Un_Des;AppDescription)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Description';
                        Editable = false;
                        MultiLine = true;
                        ToolTip = 'Specifies the full description of the extension.';
                    }
                    field(Un_Ver;VersionDisplay)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Version';
                        ToolTip = 'Specifies the version of the extension.';
                    }
                    field(Un_Pub;Publisher)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the person or company that created the extension';
                    }
                    field(Un_Terms;TermsLbl)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ShowCaption = false;
                        ToolTip = 'Specifies the terms of use for the extension.';
                        Visible = Legal;

                        trigger OnDrillDown()
                        begin
                            Hyperlink(EULA);
                        end;
                    }
                    field(Un_Privacy;PrivacyLbl)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ShowCaption = false;
                        ToolTip = 'Specifies the privacy information for the extension.';
                        Visible = Legal;

                        trigger OnDrillDown()
                        begin
                            Hyperlink("Privacy Statement");
                        end;
                    }
                    field(Un_Url;UrlLbl)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ShowCaption = false;
                        ToolTip = 'Specifies the support site for the extension.';

                        trigger OnDrillDown()
                        begin
                            Hyperlink(Url);
                        end;
                    }
                    field(Un_Help;HelpLbl)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ShowCaption = false;
                        ToolTip = 'Specifies the Help site for the extension.';

                        trigger OnDrillDown()
                        begin
                            Hyperlink(Help);
                        end;
                    }
                }
            }
            group(Installation)
            {
                Caption = 'Installation';
                Visible = BackEnabled;
                group("Review Extension Information before installation")
                {
                    Caption = 'Review Extension Information before installation';
                    field(Name;Name)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ToolTip = 'Specifies the name of the extension.';
                    }
                    field(Publisher;Publisher)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ToolTip = 'Specifies the person or company that created the extension';
                    }
                    field(Language;LanguageName)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Language';
                        ToolTip = 'Specifies the language to install the extension against.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            WinLanguagesTable: Record "Windows Language";
                        begin
                            WinLanguagesTable.SetFilter("Globally Enabled",'Yes');
                            WinLanguagesTable.SetFilter("Localization Exist",'Yes');
                            if Page.RunModal(Page::"Windows Languages",WinLanguagesTable) = Action::LookupOK then begin
                              LanguageID := WinLanguagesTable."Language ID";
                              LanguageName := WinLanguagesTable.Name;
                            end;
                        end;

                        trigger OnValidate()
                        var
                            WinLanguagesTable: Record "Windows Language";
                        begin
                            WinLanguagesTable.SetRange(Name,LanguageName);
                            WinLanguagesTable.SetFilter("Globally Enabled",'Yes');
                            WinLanguagesTable.SetFilter("Localization Exist",'Yes');
                            if WinLanguagesTable.FindFirst then
                              LanguageID := WinLanguagesTable."Language ID"
                            else
                              Error(LanguageNotFoundErr,LanguageName);
                        end;
                    }
                    group(Control30)
                    {
                        Visible = Legal;
                        field(Terms;TermsLbl)
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies the terms of use for the extension.';

                            trigger OnDrillDown()
                            begin
                                Hyperlink(EULA);
                            end;
                        }
                        field(Privacy;PrivacyLbl)
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies the privacy information for the extension.';

                            trigger OnDrillDown()
                            begin
                                Hyperlink("Privacy Statement");
                            end;
                        }
                        field(Accepted;Accepted)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'I accept the terms and conditions';
                            ToolTip = 'Specifies if you accept the terms and conditions.';
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Back)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Back';
                Image = PreviousRecord;
                InFooterBar = true;
                Visible = BackEnabled;

                trigger OnAction()
                begin
                    BackEnabled := false;
                    NextEnabled := true;
                    Step1Enabled := true;
                    InstallEnabled := false;
                end;
            }
            action(Next)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next';
                Image = NextRecord;
                InFooterBar = true;
                Visible = NextEnabled;

                trigger OnAction()
                begin
                    BackEnabled := true;
                    NextEnabled := false;
                    Step1Enabled := false;
                    InstallEnabled := true;
                end;
            }
            action(Install)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Install';
                Enabled = Accepted;
                Image = Approve;
                InFooterBar = true;
                ToolTip = 'Install the extension for the current tenant.';
                Visible = InstallEnabled;

                trigger OnAction()
                var
                    Dependencies: Text;
                    CanChange: Boolean;
                begin
                    CanChange := NavExtensionInstallationMgmt.IsInstalled("Package ID");

                    if CanChange then begin
                      Message(StrSubstNo(AlreadyInstalledMsg,Name));
                      exit;
                    end;

                    Dependencies := NavExtensionInstallationMgmt.GetDependenciesForExtensionToInstall("Package ID");
                    CanChange := (StrLen(Dependencies) = 0);

                    if not CanChange then
                      CanChange := Confirm(StrSubstNo(DependenciesFoundQst,Name,Dependencies),false);

                    if CanChange then
                      NavExtensionInstallationMgmt.InstallNavExtension("Package ID",LanguageID);

                    // If successfully installed, message users to restart activity for menusuites
                    if NavExtensionInstallationMgmt.IsInstalled("Package ID") then
                      Message(StrSubstNo(RestartActivityInstallMsg,Name));

                    CurrPage.Close;
                end;
            }
            action(Uninstall)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Uninstall';
                Image = Approve;
                InFooterBar = true;
                ToolTip = 'Remove the extension from the current tenant.';
                Visible = IsInstalled;

                trigger OnAction()
                var
                    Dependents: Text;
                    CanChange: Boolean;
                begin
                    CanChange := NavExtensionInstallationMgmt.IsInstalled("Package ID");
                    if not CanChange then
                      Message(StrSubstNo(AlreadyUninstalledMsg,Name));

                    Dependents := NavExtensionInstallationMgmt.GetDependentForExtensionToUninstall("Package ID");
                    CanChange := (StrLen(Dependents) = 0);
                    if not CanChange then
                      CanChange := Confirm(StrSubstNo(DependentsFoundQst,Name,Dependents),false);

                    if CanChange then
                      NavExtensionInstallationMgmt.UninstallNavExtension("Package ID");

                    // If successfully uninstalled, message users to restart activity for menusuites
                    if not NavExtensionInstallationMgmt.IsInstalled("Package ID") then
                      Message(StrSubstNo(RestartActivityUninstallMsg,Name));

                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        WinLanguagesTable: Record "Windows Language";
    begin
        NavAppTable.SetFilter("Package ID",'%1',"Package ID");
        if not NavAppTable.FindFirst then
          CurrPage.Close;

        SetNavAppRecord;

        IsInstalled := NavExtensionInstallationMgmt.IsInstalled("Package ID");
        if IsInstalled then
          CurrPage.Caption(UninstallationPageCaptionMsg)
        else
          CurrPage.Caption(InstallationPageCaptionMsg);

        // Any legal info to display
        Legal := ((StrLen("Privacy Statement") <> 0) or (StrLen(EULA) <> 0));

        // Next only enabled if legal info is found
        NextEnabled := not IsInstalled;

        // Step1 enabled if installing
        Step1Enabled := not IsInstalled;

        // Auto accept if no legal info
        Accepted := not Legal;

        LanguageID := GlobalLanguage;
        WinLanguagesTable.SetRange("Language ID",LanguageID);
        if WinLanguagesTable.FindFirst then
          LanguageName := WinLanguagesTable.Name;
    end;

    var
        NavAppTable: Record "NAV App";
        NavExtensionInstallationMgmt: Codeunit "Extension Installation Impl";
        AppDescription: BigText;
        VersionDisplay: Text;
        LanguageName: Text;
        BackEnabled: Boolean;
        NextEnabled: Boolean;
        InstallEnabled: Boolean;
        Accepted: Boolean;
        IsInstalled: Boolean;
        Legal: Boolean;
        Step1Enabled: Boolean;
        DependenciesFoundQst: label 'The extension %1 has a dependency on one or more extensions: %2. \ \Do you wish to install %1 and all of its dependencies?', Comment='%1=name of app, %2=semicolon separated list of uninstalled dependencies';
        DependentsFoundQst: label 'The extension %1 is a dependency for on or more extensions: %2. \ \Do you wish to uninstall %1 and all of its dependents?', Comment='%1=name of app, %2=semicolon separated list of installed dependents';
        AlreadyInstalledMsg: label 'The extension %1 is already installed.', Comment='%1=name of app';
        AlreadyUninstalledMsg: label 'The extension %1 is not installed.', Comment='%1=name of app';
        InstallationPageCaptionMsg: label 'Extension Installation', Comment='Caption for when extension needs to be installed';
        RestartActivityInstallMsg: label 'The %1 extension was successfully installed. All active users must log out and log in again to see the navigation changes.', Comment='Indicates that users need to restart their activity to pick up new menusuite items. %1=Name of Extension';
        RestartActivityUninstallMsg: label 'The %1 extension was successfully uninstalled. All active users must log out and log in again to see the navigation changes.', Comment='Indicates that users need to restart their activity to pick up new menusuite items. %1=Name of Extension';
        UninstallationPageCaptionMsg: label 'Extension Uninstallation', Comment='Caption for when extension needs to be uninstalled';
        LanguageNotFoundErr: label 'Language %1 does not exist, or is not enabled globally and contains a localization. Use the lookup to select a language.', Comment='Error message to notify user that the entered language was not found. This could mean that the language doesn''t exist or that the language is not valid within the filter set for the lookup. %1=Entered value.';
        TermsLbl: label 'Terms and Conditions';
        PrivacyLbl: label 'Privacy Statement', Comment='Label for privacy statement link';
        UrlLbl: label 'Website';
        HelpLbl: label 'Help';
        LanguageID: Integer;

    local procedure SetNavAppRecord()
    var
        DescriptionStream: InStream;
    begin
        "Package ID" := NavAppTable."Package ID";
        ID := NavAppTable.ID;
        Name := NavAppTable.Name;
        Publisher := NavAppTable.Publisher;
        VersionDisplay :=
          NavExtensionInstallationMgmt.GetVersionDisplayString(
            NavAppTable."Version Major",NavAppTable."Version Minor",
            NavAppTable."Version Build",NavAppTable."Version Revision");
        NavAppTable.CalcFields(Description);
        NavAppTable.Description.CreateInstream(DescriptionStream,Textencoding::UTF8);
        AppDescription.Read(DescriptionStream);
        Url := NavAppTable.Url;
        Help := NavAppTable.Help;
        "Privacy Statement" := NavAppTable."Privacy Statement";
        EULA := NavAppTable.EULA;
        Insert;
    end;
}

