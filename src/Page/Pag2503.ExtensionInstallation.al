#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2503 "Extension Installation"
{
    Caption = 'Extension Installation';
    PageType = NavigatePage;
    SourceTable = "NAV App";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control7)
            {
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                Visible = ReviewVisible;
                part(ReviewPart;"Extension Details Part")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Review Extension Installation Details';
                    ShowFilter = false;
                    SubPageLink = "Package ID"=field("Package ID");
                    SubPageView = sorting("Package ID")
                                  order(ascending);
                }
                group(Control3)
                {
                    field(Language;LanguageName)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Language';
                        ToolTip = 'Specifies the language that the Extension is installed for';

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
                }
            }
            group(Control2)
            {
                Visible = ExtensionNotFound;
                field(NotFoundMsg;NotFoundMsg)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Extension not found';
                    Editable = false;
                    MultiLine = true;
                    ShowCaption = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Ok)
            {
                ApplicationArea = Basic,Suite;
                Image = NextRecord;
                InFooterBar = true;
                Visible = ExtensionNotFound;

                trigger OnAction()
                begin
                    CurrPage.Close;
                end;
            }
            action(Install)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Install';
                Image = Approve;
                InFooterBar = true;
                ToolTip = 'Install the extension for the current tenant.';
                Visible = ReviewVisible;

                trigger OnAction()
                var
                    NavExtensionInstallationMgmt: Codeunit "Extension Installation Impl";
                    ExtensionInstallationDialog: Page "Extn. Installation Progress";
                    Dependencies: Text;
                    CanChange: Boolean;
                    Result: Option;
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

                    Result := Operationresult::Successful;
                    if CanChange then begin
                      ExtensionInstallationDialog.SetRecord(Rec);
                      ExtensionInstallationDialog.SetLanguageId(LanguageID);
                      if not (ExtensionInstallationDialog.RunModal = Action::OK) then
                        Result := Operationresult::DeploymentFailedDueToPackage;
                    end;

                    MakeTelemetryCallback(Result);
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        WinLanguagesTable: Record "Windows Language";
        NavAppTable: Record "NAV App";
        NavExtensionInstallationMgmt: Codeunit "Extension Installation Impl";
    begin
        GetDetailsFromFilters;
        ExtensionPkgId := "Package ID";
        ExtensionAppId := ID;
        TelemetryUrl := responseUrl;
        ReviewVisible := false;

        Reset;

        NavAppTable.SetFilter("Package ID",'%1',ExtensionPkgId);
        ExtensionNotFound := not NavAppTable.FindFirst;

        NotFoundMsg := StrSubstNo(ExtensionNotFoundLbl,'Package',ExtensionPkgId);

        // If extension not found by package id, search for app id
        if ExtensionNotFound and (not IsNullGuid(ExtensionAppId)) then begin
          NavAppTable.SetFilter("Package ID",'%1',NavExtensionInstallationMgmt.GetLatestVersionPackageId(ExtensionAppId));
          ExtensionNotFound := not NavAppTable.FindFirst;
          NotFoundMsg := StrSubstNo(ExtensionNotFoundLbl,'App',ExtensionAppId);
        end;

        if not ExtensionNotFound then begin
          ReviewVisible := true;

          if Name = '' then
            "Package ID" := NavAppTable."Package ID";

          LanguageID := GlobalLanguage;
          WinLanguagesTable.SetRange("Language ID",LanguageID);
          if WinLanguagesTable.FindFirst then
            LanguageName := WinLanguagesTable.Name;
        end;

        CurrPage.Update;
    end;

    var
        LanguageNotFoundErr: label 'Cannot find the specified language, %1. Choose the lookup button to select a language.', Comment='Error message to notify user that the entered language was not found. This could mean that the language doesn''t exist or that the language is not valid within the filter set for the lookup. %1=Entered value.';
        LanguageID: Integer;
        LanguageName: Text;
        AlreadyInstalledMsg: label 'The extension %1 is already installed.', Comment='%1=name of app';
        ExtensionPkgId: Text;
        ExtensionAppId: Text;
        NotFoundMsg: Text;
        ExtensionNotFound: Boolean;
        ReviewVisible: Boolean;
        ExtensionNotFoundLbl: label 'Could not find an extension for the specified target, %1 with the ID %2.\\Extension is not published.', Comment='%1=id type (package vs app), %2=target extension id';
        DependenciesFoundQst: label 'The extension %1 has a dependency on one or more extensions: %2.\\Do you wish to install %1 and all of its dependencies?', Comment='%1=name of app, %2=semicolon separated list of uninstalled dependencies';
        TelemetryUrl: Text;
        OperationResult: Option UserNotAuthorized,DeploymentFailedDueToPackage,DeploymentFailed,Successful,UserCancel,UserTimeOut;

    local procedure GetDetailsFromFilters()
    var
        RecRef: RecordRef;
        i: Integer;
    begin
        RecRef.GetTable(Rec);
        for i := 1 to RecRef.FieldCount do
          ParseFilter(RecRef.FieldIndex(i));
        RecRef.SetTable(Rec);
    end;

    local procedure ParseFilter(FieldRef: FieldRef)
    var
        FilterPrefixRegEx: dotnet Regex;
        SingleQuoteRegEx: dotnet Regex;
        EscapedEqualityRegEx: dotnet Regex;
        "Filter": Text;
    begin
        FilterPrefixRegEx := FilterPrefixRegEx.Regex('^@\*([^\\]+)\*$');
        SingleQuoteRegEx := SingleQuoteRegEx.Regex('^''([^\\]+)''$');
        EscapedEqualityRegEx := EscapedEqualityRegEx.Regex('~');
        Filter := FieldRef.GetFilter;
        Filter := FilterPrefixRegEx.Replace(Filter,'$1');
        Filter := SingleQuoteRegEx.Replace(Filter,'$1');
        Filter := EscapedEqualityRegEx.Replace(Filter,'=');

        if Filter <> '' then
          FieldRef.Value(Filter);
    end;

    local procedure MakeTelemetryCallback(Result: Option UserNotAuthorized,DeploymentFailedDueToPackage,DeploymentFailed,Successful,UserCancel,UserTimeOut)
    var
        ExtensionMarketplaceMgmt: Codeunit "Extension Marketplace";
    begin
        if TelemetryUrl <> '' then
          ExtensionMarketplaceMgmt.MakeMarketplaceTelemetryCallback(TelemetryUrl,Result,"Package ID");
    end;
}

