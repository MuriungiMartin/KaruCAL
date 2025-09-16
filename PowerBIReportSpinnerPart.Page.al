#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6303 "Power BI Report Spinner Part"
{
    Caption = 'Power BI Reports';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    SourceTable = "Power BI Report Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control9)
            {
                Visible = IsGettingStartedVisible;
                field(GettingStarted;'Get started with Power BI')
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                    Style = StrongAccent;
                    StyleExpr = true;

                    trigger OnDrillDown()
                    begin
                        AzureAdMgt.GetAccessToken(PowerBiServiceMgt.GetPowerBiResourceUrl,PowerBiServiceMgt.GetPowerBiResourceName,true);
                        LoadPart;
                        CurrPage.Update;
                    end;
                }
            }
            group(Control7)
            {
                Visible = not IsGettingStartedVisible and not HasReports;
                label(EmptyMessage)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'There are no enabled reports. Choose Select Report to see a list of reports that you can display.';
                    Editable = false;
                    ToolTip = 'Specifies that the user needs to select Power BI reports.';
                }
            }
            group(Control11)
            {
                Visible = not IsGettingStartedVisible and HasReports;
                usercontrol(WebReportViewer;"Microsoft.Dynamics.Nav.Client.WebPageViewer")
                {
                    ApplicationArea = Basic,Suite;

                    trigger ControlAddInReady(callbackUrl: Text)
                    begin
                        AddInReady := true;
                        if not IsEmpty then
                          CurrPage.WebReportViewer.Navigate(GetEmbedUrl);
                    end;

                    trigger DocumentReady()
                    begin
                        if not IsEmpty then
                          CurrPage.WebReportViewer.PostMessage(GetMessage,'*',false);
                    end;

                    trigger Callback(data: Text)
                    begin
                    end;

                    trigger Refresh(callbackUrl: Text)
                    begin
                        if AddInReady and not IsEmpty then
                          CurrPage.WebReportViewer.Navigate(GetEmbedUrl);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Select Report")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Select Report';
                Image = SelectChart;

                trigger OnAction()
                var
                    PowerBiReportSelection: Page "Power BI Report Selection";
                begin
                    PowerBiReportSelection.SetContext(Context);
                    PowerBiReportSelection.SetReportBuffer(Rec);
                    PowerBiReportSelection.LookupMode(true);

                    if PowerBiReportSelection.RunModal = Action::LookupOK then begin
                      RefreshAvailableReports;
                      PowerBiReportSelection.GetRecord(Rec);

                      if AddInReady and Enabled then
                        // Only show report if enabled (selection page only returns a disabled report if none are enabled).
                        CurrPage.WebReportViewer.Navigate(GetEmbedUrl);

                      // at this point, NAV will load the web page viewer since HasReports should be true. WebReportViewer::ControlAddInReady will then fire, calling Navigate()
                    end;
                end;
            }
            action("Expand Report")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Expand Report';
                Enabled = HasReports;
                Image = View;

                trigger OnAction()
                var
                    PowerBiReportDialog: Page "Power BI Report Dialog";
                begin
                    PowerBiReportDialog.SetUrl(GetEmbedUrlWithNavigation,GetMessage);
                    PowerBiReportDialog.Caption(ReportName);
                    PowerBiReportDialog.Run;
                end;
            }
            action("Previous Report")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Previous Report';
                Enabled = HasReports;
                Image = PreviousSet;

                trigger OnAction()
                begin
                    if Next(-1) = 0 then
                      FindLast;

                    CurrPage.WebReportViewer.Navigate(GetEmbedUrl);
                end;
            }
            action("Next Report")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next Report';
                Enabled = HasReports;
                Image = NextSet;

                trigger OnAction()
                begin
                    if Next = 0 then
                      FindFirst;

                    CurrPage.WebReportViewer.Navigate(GetEmbedUrl);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        UpdateContext;
        LoadPart;
        CurrPage.Update;
    end;

    var
        PowerBiServiceMgt: Codeunit "Power BI Service Mgt.";
        AzureAdMgt: Codeunit "Azure AD Mgt.";
        Context: Text[30];
        IsGettingStartedVisible: Boolean;
        HasReports: Boolean;
        NoReportsAvailableErr: label 'There are no reports available from Power BI.';
        AddInReady: Boolean;

    local procedure GetMessage(): Text
    var
        HttpUtility: dotnet HttpUtility;
    begin
        exit(
          '{"action":"loadReport","accessToken":"' +
          HttpUtility.JavaScriptStringEncode(AzureAdMgt.GetAccessToken(
              PowerBiServiceMgt.GetPowerBiResourceUrl,PowerBiServiceMgt.GetPowerBiResourceName,false)) + '"}');
    end;

    local procedure GetEmbedUrl(): Text
    begin
        // Hides both filters and tabs for embedding in small spaces where navigation is unnecessary.
        exit(EmbedUrl + '&filterPaneEnabled=false&navContentPaneEnabled=false');
    end;

    local procedure GetEmbedUrlWithNavigation(): Text
    begin
        // Hides filters and shows tabs for embedding in large spaces where navigation is necessary.
        exit(EmbedUrl + '&filterPaneEnabled=false');
    end;

    local procedure LoadPart()
    begin
        IsGettingStartedVisible := not PowerBiServiceMgt.IsUserReadyForPowerBI;

        DeleteAll;
        if IsGettingStartedVisible then begin
          if AzureAdMgt.IsSaaS then
            Error(PowerBiServiceMgt.GetGenericError);

          Insert // Hack to display Get Started link.
        end else begin
          PowerBiServiceMgt.GetReports(Rec,Context);

          if IsEmpty then
            Error(NoReportsAvailableErr);

          RefreshAvailableReports;
        end;
    end;

    local procedure RefreshAvailableReports()
    begin
        Reset;
        SetRange(Enabled,true);
        HasReports := not IsEmpty;
    end;


    procedure SetContext(ParentContext: Text[30])
    begin
        // Sets an ID that tracks which page to show reports for - called by the parent page hosting the part,
        // if possible (see UpdateContext).
        Context := ParentContext;
    end;

    local procedure UpdateContext()
    var
        ConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
    begin
        // Automatically sets the parent page ID based on the user's selected role center (role centers can't
        // have codebehind, so they have no other way to set the context for their reports).
        if Context = '' then
          SetContext(ConfPersonalizationMgt.GetCurrentProfileID);
    end;
}

