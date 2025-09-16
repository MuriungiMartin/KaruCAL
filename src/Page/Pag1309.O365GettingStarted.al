#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1309 "O365 Getting Started"
{
    Caption = 'Getting Started';
    PageType = NavigatePage;
    SourceTable = "O365 Getting Started";

    layout
    {
        area(content)
        {
            group(Control2)
            {
                Editable = false;
                Visible = CurrentPage = 1;
                field(Image1;O365GettingStartedPageData1.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Image1';
                    Editable = false;
                    ShowCaption = false;
                }
                group(Page1Group)
                {
                    Caption = 'Welcome to Dynamics 365 for Financials. Try it out!';
                    field(BodyText1;BodyText)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'BodyText1';
                        Editable = false;
                        MultiLine = true;
                        ShowCaption = false;
                    }
                }
            }
            group(Control17)
            {
                Editable = false;
                Visible = CurrentPage = 2;
                field(Image2;O365GettingStartedPageData2.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Image2';
                    Editable = false;
                    ShowCaption = false;
                }
                group(Page2Group)
                {
                    Caption = 'Grow sales, manage your customers, and make billing easy';
                    field(BodyText2;BodyText)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'BodyText2';
                        Editable = false;
                        MultiLine = true;
                        ShowCaption = false;
                    }
                }
            }
            group(Control21)
            {
                Editable = false;
                Visible = CurrentPage = 3;
                field(Image3;O365GettingStartedPageData3.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Image3';
                    Editable = false;
                    ShowCaption = false;
                }
                group(Page3Group)
                {
                    Caption = 'Managing your vendors';
                    field(BodyText3;BodyText)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'BodyText3';
                        Editable = false;
                        MultiLine = true;
                        ShowCaption = false;
                    }
                }
            }
            group(Control24)
            {
                Editable = false;
                Visible = CurrentPage = 4;
                field(Image4;O365GettingStartedPageData4.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Image4';
                    Editable = false;
                    ShowCaption = false;
                }
                group(Page4Group)
                {
                    Caption = 'Do you keep stock and need to track your inventory?';
                    field(BodyText4;BodyText)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'BodyText4';
                        Editable = false;
                        MultiLine = true;
                        ShowCaption = false;
                    }
                }
            }
            group(Control27)
            {
                Editable = false;
                Visible = CurrentPage = 5;
                field(Image5;O365GettingStartedPageData5.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Image5';
                    Editable = false;
                    ShowCaption = false;
                }
                group(Page5Group)
                {
                    Caption = 'Simplify reporting';
                    field(BodyText5;BodyText)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'BodyText5';
                        Editable = false;
                        MultiLine = true;
                        ShowCaption = false;
                    }
                }
            }
            group(Control49)
            {
                Editable = false;
                Visible = CurrentPage = 6;
                field(Image6;O365GettingStartedPageData6.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Image6';
                    Editable = false;
                    ShowCaption = false;
                }
                group(Page6Group)
                {
                    Caption = 'Run your business within Office 365';
                    field(BodyText6;BodyText)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'BodyText6';
                        Editable = false;
                        MultiLine = true;
                        ShowCaption = false;
                    }
                }
            }
            group(Control30)
            {
                Editable = false;
                Visible = CurrentPage = 7;
                field(Image7;O365GettingStartedPageData7.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Image7';
                    Editable = false;
                    ShowCaption = false;
                }
                group(Page7Group)
                {
                    Caption = 'Do business anywhere';
                    field(BodyText7;BodyText)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'BodyText7';
                        Editable = false;
                        MultiLine = true;
                        ShowCaption = false;
                    }
                }
            }
            group(Control33)
            {
                Editable = false;
                Visible = CurrentPage = 8;
                field(Image8;O365GettingStartedPageData8.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Image8';
                    Editable = false;
                    ShowCaption = false;
                }
                group(Page8Group)
                {
                    Caption = 'Easily import data from your current accounting system';
                    field(BodyText8;BodyText)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'BodyText8';
                        Editable = false;
                        MultiLine = true;
                        ShowCaption = false;
                    }
                }
            }
            group(Control44)
            {
                Editable = false;
                Visible = CurrentPage = 9;
                field(Image9;O365GettingStartedPageData9.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Image9';
                    Editable = false;
                    ShowCaption = false;
                }
                group(Page9Group)
                {
                    Caption = 'Try it out';
                    field(BodyText9;BodyText)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'BodyText9';
                        Editable = false;
                        MultiLine = true;
                        ShowCaption = false;
                    }
                }
                field(DocumentationLink;DocumentationLinkCaptionLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'DocumentationLink';
                    Editable = false;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        Hyperlink(DocumentationLinkCaptionLbl);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SkipWizard)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Not now';
                InFooterBar = true;
                Promoted = true;
                Visible = CurrentPage = 1;

                trigger OnAction()
                begin
                    MarkWizardAsDone;
                    DisableConfirmationOnPageClose := false;
                    CurrPage.Close;
                end;
            }
            action(GetStarted)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Get started';
                Image = Start;
                InFooterBar = true;
                Visible = (CurrentPage = 1) and FirstRun;

                trigger OnAction()
                begin
                    InvokeWalkMeButton(O365GettingStartedMgt.GetGettingStartedTourID);
                end;
            }
            action(GetStartedSecondView)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show me welcome tour';
                Image = NextRecord;
                InFooterBar = true;
                Visible = (CurrentPage = 1) and (not FirstRun);

                trigger OnAction()
                begin
                    InvokeWalkMeButton(O365GettingStartedMgt.GetGettingStartedTourID);
                end;
            }
            action(Back)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Go Back';
                Image = PreviousRecord;
                InFooterBar = true;
                Promoted = true;
                Visible = (CurrentPage > 1) and (CurrentPage < LastPageIndex);

                trigger OnAction()
                begin
                    CurrentPage := GetNextPageID(-1,CurrentPage);
                    CurrPage.Update;
                end;
            }
            action(BackLastPage)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Go Back';
                InFooterBar = true;
                Promoted = true;
                Visible = CurrentPage = LastPageIndex;

                trigger OnAction()
                begin
                    CurrentPage := GetNextPageID(-1,CurrentPage);
                    CurrPage.Update;
                end;
            }
            action(ShowMeInvoicing)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show me Invoicing';
                Image = NextRecord;
                InFooterBar = true;
                Promoted = true;
                Visible = CurrentPage = 2;

                trigger OnAction()
                begin
                    InvokeWalkMeButton(O365GettingStartedMgt.GetInvoicingTourID);
                end;
            }
            action(ShowMePurchasing)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show me Purchasing';
                Image = NextRecord;
                InFooterBar = true;
                Promoted = true;
                Visible = CurrentPage = 3;

                trigger OnAction()
                begin
                    InvokeWalkMeButton(-1);
                end;
            }
            action(ShowMeInventory)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show me Inventory';
                Image = NextRecord;
                InFooterBar = true;
                Promoted = true;
                Visible = CurrentPage = 4;

                trigger OnAction()
                begin
                    InvokeWalkMeButton(-1);
                end;
            }
            action(ShowMeReporting)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show me Reporting';
                Image = NextRecord;
                InFooterBar = true;
                Promoted = true;
                Visible = CurrentPage = 5;

                trigger OnAction()
                begin
                    InvokeWalkMeButton(O365GettingStartedMgt.GetReportingTourID);
                end;
            }
            action(SetUpInOutlook)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set up in Outlook';
                Image = NextRecord;
                InFooterBar = true;
                Promoted = true;
                Visible = CurrentPage = 6;

                trigger OnAction()
                begin
                    AddToOutlook;
                end;
            }
            action(SetupDevice)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show me how';
                Image = NextRecord;
                InFooterBar = true;
                Promoted = true;
                Visible = CurrentPage = 7;

                trigger OnAction()
                begin
                    Page.RunModal(Page::"O365 Device Setup");
                end;
            }
            action(ShowMeImport)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show me Import';
                Image = NextRecord;
                InFooterBar = true;
                Promoted = true;
                Visible = CurrentPage = 8;

                trigger OnAction()
                begin
                    InvokeWalkMeButton(-1);
                end;
            }
            action(Next)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next';
                Image = Approve;
                InFooterBar = true;
                Promoted = true;
                Visible = NextPageVisible;

                trigger OnAction()
                begin
                    CurrentPage := GetNextPageID(1,CurrentPage);
                    CurrPage.Update;
                end;
            }
            action(Done)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Done';
                Image = NextRecord;
                InFooterBar = true;
                Promoted = true;
                Visible = CurrentPage = LastPageIndex;

                trigger OnAction()
                begin
                    MarkWizardAsDone;
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if CurrentPage = 0 then
          CurrentPage := "Current Page";

        if CurrentPage = 1 then
          NextPageVisible := not FirstRun
        else
          NextPageVisible := CurrentPage < LastPageIndex;

        UpdatePageControls;
        SetPageCaption;
    end;

    trigger OnInit()
    begin
        SetRange("User ID",UserId);
    end;

    trigger OnOpenPage()
    begin
        if not AlreadyShown then begin
          FirstRun := true;
          MarkAsShown;
        end;

        if UserTours.IsAvailable then begin
          UserTours := UserTours.Create;
          UserTours.StopUserTour;
        end;

        MaxNumberOfSteps := 5;
        LastPageIndex := 9;
        LoadImages;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if DisableConfirmationOnPageClose then
          exit(true);

        "Tour in Progress" := false;
        Modify;

        if UserTours.IsAvailable then
          UserTours.StartUserTour(O365GettingStartedMgt.GetReturnToGettingStartedTourID);

        exit(true);
    end;

    var
        O365GettingStartedPageData1: Record "O365 Getting Started Page Data";
        O365GettingStartedPageData2: Record "O365 Getting Started Page Data";
        O365GettingStartedPageData3: Record "O365 Getting Started Page Data";
        O365GettingStartedPageData4: Record "O365 Getting Started Page Data";
        O365GettingStartedPageData5: Record "O365 Getting Started Page Data";
        O365GettingStartedPageData6: Record "O365 Getting Started Page Data";
        O365GettingStartedPageData7: Record "O365 Getting Started Page Data";
        O365GettingStartedPageData8: Record "O365 Getting Started Page Data";
        O365GettingStartedPageData9: Record "O365 Getting Started Page Data";
        O365GettingStartedMgt: Codeunit "O365 Getting Started Mgt.";
        [RunOnClient]
        [WithEvents]
        UserTours: dotnet UserTours;
        [InDataSet]
        CurrentPage: Integer;
        NextPageVisible: Boolean;
        FirstRun: Boolean;
        BodyText: BigText;
        LastPageIndex: Integer;
        MaxNumberOfSteps: Integer;
        DisableConfirmationOnPageClose: Boolean;
        UserToursAreNotAvailableMsg: label 'Tours are not available for this installation.';
        GettingStartedPageTxt: label 'GETTING STARTED';
        StepCaptionTxt: label '(%1 OF %2)', Comment='%1 Current page number, %2 total number of pages';
        OutlookSetupCompleteMsg: label 'Your Business Inbox is all set up. When you''re ready, you can start using Dynamics 365 for Financials in Outlook.';
        DocumentationLinkCaptionLbl: label 'https://aka.ms/financialsgetstarted', Locked=true;

    local procedure InvokeWalkMeButton(TourID: Integer)
    begin
        if not UserTours.IsAvailable then begin
          Message(UserToursAreNotAvailableMsg);
          CurrPage.Close;
          exit;
        end;

        if (TourID <> O365GettingStartedMgt.GetWizardDoneTourID) and
           (TourID <> O365GettingStartedMgt.GetChangeCompanyTourID)
        then begin
          "Current Page" := CurrentPage;
          "Tour in Progress" := true;
          Modify;
        end;

        UserTours.StartUserTour(TourID);
        DisableConfirmationOnPageClose := true;
        CurrPage.Close;
    end;

    local procedure UpdatePageControls()
    begin
        GetBodyTextForCurrentPage;
    end;

    local procedure MarkWizardAsDone()
    begin
        "Tour in Progress" := false;
        "Tour Completed" := true;
        Modify;

        if UserTours.IsAvailable then
          UserTours.StopNotifyShowTourWizard;
    end;

    local procedure GetBodyTextForCurrentPage()
    var
        BodyTextO365GettingStartedPageData: Record "O365 Getting Started Page Data";
        TextInStream: InStream;
    begin
        BodyTextO365GettingStartedPageData.GetPageBodyText(BodyTextO365GettingStartedPageData,CurrentPage,Page::"O365 Getting Started");
        BodyTextO365GettingStartedPageData."Body Text".CreateInstream(TextInStream,Textencoding::UTF8);
        BodyText.Read(TextInStream);
    end;

    local procedure LoadImages()
    var
        Index: Integer;
    begin
        Index := 1;
        LoadImage(O365GettingStartedPageData1,Index);
        LoadImage(O365GettingStartedPageData2,Index);
        LoadImage(O365GettingStartedPageData3,Index);
        LoadImage(O365GettingStartedPageData4,Index);
        LoadImage(O365GettingStartedPageData5,Index);
        LoadImage(O365GettingStartedPageData6,Index);
        LoadImage(O365GettingStartedPageData7,Index);
        LoadImage(O365GettingStartedPageData8,Index);
        LoadImage(O365GettingStartedPageData9,Index);
    end;

    local procedure LoadImage(var O365GettingStartedPageData: Record "O365 Getting Started Page Data";var CurrentPageID: Integer)
    begin
        O365GettingStartedPageData.GetPageImage(O365GettingStartedPageData,CurrentPageID,Page::"O365 Getting Started");
        CurrentPageID += 1;
    end;


    procedure GetNextPageID(Increment: Integer;CurrentPageID: Integer) NextPageID: Integer
    begin
        NextPageID := CurrentPageID + Increment;

        // Pages 3,4 and 8 are currently skipped in the wizard. They should be removed.
        if NextPageID in [3,4] then
          NextPageID += Increment * 2;

        if NextPageID in [8] then
          NextPageID += Increment;
    end;

    local procedure SetPageCaption()
    var
        StepIndex: Integer;
    begin
        CurrPage.Caption := GettingStartedPageTxt;
        if CurrentPage in [1,LastPageIndex] then
          exit;

        StepIndex := CurrentPage;

        if CurrentPage in [5,6,7] then
          StepIndex := CurrentPage - 2;

        CurrPage.Caption := StrSubstNo('%1 %2',GettingStartedPageTxt,StrSubstNo(StepCaptionTxt,StepIndex,MaxNumberOfSteps));
    end;

    local procedure AddToOutlook()
    var
        AssistedSetup: Record "Assisted Setup";
        ExchangeAddinSetup: Codeunit "Exchange Add-in Setup";
    begin
        if ExchangeAddinSetup.PromptForCredentials then begin
          ExchangeAddinSetup.DeployAddins;
          ExchangeAddinSetup.DeploySampleEmails;
          AssistedSetup.SetStatus(Page::"Exchange Setup Wizard",AssistedSetup.Status::Completed);
          Message(OutlookSetupCompleteMsg);
        end;
    end;

    trigger Usertours::ShowTourWizard(hasTourCompleted: Boolean)
    begin
    end;

    trigger Usertours::IsTourInProgressResultReady(isInProgress: Boolean)
    begin
    end;
}

