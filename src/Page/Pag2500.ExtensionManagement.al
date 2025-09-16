#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2500 "Extension Management"
{
    ApplicationArea = Basic;
    Caption = 'Extension Management';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Details,Manage';
    RefreshOnActivate = true;
    SourceTable = "NAV App";
    SourceTableView = sorting(Name)
                      order(ascending)
                      where(Name=filter(<>'_Exclude_*'));
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field(Logo;Logo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Logo';
                    ToolTip = 'Specifies the logo of the extension, such as the logo of the service provider.';
                }
                field(AdditionalInfo;PublisherOrStatus)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AdditionalInfo';
                    Style = Favorable;
                    StyleExpr = Style;
                    ToolTip = 'Specifies the person or company that created the extension.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the extension.';
                }
                label(Control18)
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = IsSaaS;
                    HideValue = true;
                    Style = Favorable;
                    StyleExpr = true;
                    ToolTip = 'Specifies a spacer for ''Brick'' view mode.';
                    Visible = IsSaaS;
                }
                field(Version;VersionDisplay)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Version';
                    ToolTip = 'Specifies the version of the extension.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup13)
            {
                Enabled = false;
                Visible = false;
                action(Install)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Install';
                    Enabled = ActionsEnabled and not IsSaaS;
                    Image = NewRow;
                    Promoted = true;
                    PromotedCategory = Category5;
                    Scope = Repeater;
                    ToolTip = 'Install the extension for the current tenant.';
                    Visible = not IsSaaS;

                    trigger OnAction()
                    begin
                        if NavExtensionInstallationMgmt.IsInstalled("Package ID") then begin
                          Message(AlreadyInstalledMsg,Name);
                          exit;
                        end;

                        RunOldExtensionInstallation;
                    end;
                }
                action(Uninstall)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Uninstall';
                    Enabled = ActionsEnabled;
                    Image = RemoveLine;
                    Promoted = true;
                    PromotedCategory = Category5;
                    Scope = Repeater;
                    ToolTip = 'Remove the extension from the current tenant.';

                    trigger OnAction()
                    begin
                        if not NavExtensionInstallationMgmt.IsInstalled("Package ID") then begin
                          Message(AlreadyUninstalledMsg,Name);
                          exit;
                        end;

                        RunOldExtensionInstallation;
                    end;
                }
                action(LearnMore)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Learn More';
                    Enabled = ActionsEnabled;
                    Image = Info;
                    Promoted = true;
                    PromotedCategory = Category5;
                    Scope = Repeater;
                    ToolTip = 'View information from the extension provider.';

                    trigger OnAction()
                    begin
                        Hyperlink(Help);
                    end;
                }
                action(Refresh)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Refresh';
                    Image = RefreshLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Refresh the list of extensions.';

                    trigger OnAction()
                    begin
                        ActionsEnabled := false;
                        CurrPage.Update(false);
                    end;
                }
                action("Extension Marketplace")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Extension Marketplace';
                    Enabled = IsSaaS;
                    Image = NewItem;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Browse the extension marketplace for new extensions to install.';
                    Visible = IsSaaS;

                    trigger OnAction()
                    var
                        ExtensionMarketplace: Page "Extension Marketplace";
                    begin
                        ExtensionMarketplace.Run;
                        if ExtensionMarketplace.Editable = false then
                          CurrPage.Update;
                    end;
                }
            }
            group(Manage)
            {
                Caption = 'Manage';
                action(View)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View';
                    Enabled = ActionsEnabled;
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunPageMode = View;
                    ShortCutKey = 'Return';
                    ToolTip = 'View extension details.';
                    Visible = not IsSaaS;

                    trigger OnAction()
                    begin
                        RunOldExtensionInstallation;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ActionsEnabled := true;
        VersionDisplay :=
          StrSubstNo(
            VersionFormatTxt,
            NavExtensionInstallationMgmt.GetVersionDisplayString("Version Major","Version Minor","Version Build","Version Revision"));

        Style := false;
        PublisherOrStatus := Publisher;
        if not IsSaaS then begin
          PublisherOrStatus := NavExtensionInstallationMgmt.GetExtensionInstalledDisplayString("Package ID");
          Style := NavExtensionInstallationMgmt.IsInstalled("Package ID");
        end;
    end;

    trigger OnInit()
    var
        PermissionManager: Codeunit "Permission Manager";
    begin
        IsSaaS := PermissionManager.SoftwareAsAService;
    end;

    trigger OnOpenPage()
    begin
        ActionsEnabled := false;
        if IsSaaS then begin
          CurrPage.Caption(SaaSCaptionTxt);
          SetFilter(Installed,'%1',true);
        end
    end;

    var
        VersionFormatTxt: label 'v. %1', Comment='v=version abbr, %1=Version string';
        NavExtensionInstallationMgmt: Codeunit "Extension Installation Impl";
        PublisherOrStatus: Text;
        VersionDisplay: Text;
        ActionsEnabled: Boolean;
        IsSaaS: Boolean;
        SaaSCaptionTxt: label 'Installed Extensions', Comment='The caption to display when on SaaS';
        Style: Boolean;
        AlreadyInstalledMsg: label 'The extension %1 is already installed.', Comment='%1 = name of extension';
        AlreadyUninstalledMsg: label 'The extension %1 is not installed.', Comment='%1 = name of extension.';

    local procedure RunOldExtensionInstallation()
    var
        ExtensionDetails: Page "Extension Details";
    begin
        ExtensionDetails.SetRecord(Rec);
        ExtensionDetails.Run;
        if ExtensionDetails.Editable = false then
          CurrPage.Update;
    end;
}

