#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2505 "Extension Installation Dialog"
{
    Caption = 'Extension Installation Dialog';
    PageType = NavigatePage;
    SourceTable = "NAV App";

    layout
    {
        area(content)
        {
            group(Control7)
            {
                Visible = IsVisible;
                fixed(Control3)
                {
                    //The GridLayout property is only supported on controls of type Grid
                    //GridLayout = Columns;
                    part(DetailsPart;"Extension Logo Part")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Installing Extension';
                        ShowFilter = false;
                        SubPageLink = "Package ID"=field("Package ID");
                        SubPageView = sorting("Package ID")
                                      order(ascending);
                    }
                    group(Control4)
                    {
                        label(Control5)
                        {
                            ApplicationArea = Basic,Suite;
                        }
                        usercontrol(WebView;"Microsoft.Dynamics.Nav.Client.WebPageViewer")
                        {
                            ApplicationArea = Basic,Suite;

                            trigger ControlAddInReady(callbackUrl: Text)
                            begin
                                InstallExtension(LanguageId);
                            end;

                            trigger DocumentReady()
                            begin
                            end;

                            trigger Callback(data: Text)
                            begin
                            end;

                            trigger Refresh(callbackUrl: Text)
                            begin
                            end;
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        LanguageId := 1033; // Default to english if unset
        IsVisible := true; // Hack to get the navigation page 'button' to hide properly
    end;

    var
        NavExtensionInstallationMgmt: Codeunit "Extension Installation Impl";
        LanguageId: Integer;
        RestartActivityInstallMsg: label 'The extension %1 was successfully installed. All active users must log out and log in again to see the navigation changes.', Comment='Indicates that users need to restart their activity to pick up new menusuite items. %1=Name of Extension';
        IsVisible: Boolean;

    local procedure InstallExtension(LangId: Integer)
    begin
        NavExtensionInstallationMgmt.InstallNavExtension("Package ID",LangId);

        // If successfully installed, message users to restart activity for menusuites
        if NavExtensionInstallationMgmt.IsInstalled("Package ID") then
          Message(StrSubstNo(RestartActivityInstallMsg,Name));

        CurrPage.Close;
    end;


    procedure SetLanguageId(LangId: Integer)
    begin
        LanguageId := LangId
    end;
}

