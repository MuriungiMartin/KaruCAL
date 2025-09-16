#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1811 "Setup Email Logging"
{
    Caption = 'Email Logging Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = NavigatePage;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            group(Control96)
            {
                Editable = false;
                Visible = TopBannerVisible and not DoneVisible;
                field("MediaRepositoryStandard.Image";MediaRepositoryStandard.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Control98)
            {
                Editable = false;
                Visible = TopBannerVisible and DoneVisible;
                field("MediaRepositoryDone.Image";MediaRepositoryDone.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Step1)
            {
                Caption = '';
                Visible = IntroVisible;
                group("Welcome to Email Logging Setup")
                {
                    Caption = 'Welcome to Email Logging Setup';
                    group(Control4)
                    {
                        Caption = '';
                        InstructionalText = 'You can set up Exchange public folders and rules, so that incoming and outgoing email can log Interactions. Organization customization will be enabled for Exchange. Choose Next so you can set up public folders and email rules.';
                    }
                }
            }
            group(Step2)
            {
                Caption = '';
                Visible = LoginPassVisible;
                group(ExchangeCredentialsDesc)
                {
                    Caption = 'Provide your Exchange Online administrator credentials.';
                    field(Email;Email)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Email';

                        trigger OnValidate()
                        begin
                            NextEnabled := EmailPasswordNotEmpty;
                        end;
                    }
                    field(Password;Password)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Password';
                        ExtendedDatatype = Masked;

                        trigger OnValidate()
                        begin
                            NextEnabled := EmailPasswordNotEmpty;
                        end;
                    }
                }
            }
            group("Public Folders Creation")
            {
                InstructionalText = 'The following public mailbox and public folders will be created. (You can rename folders later):';
                Visible = PublicFoldersVisible;
                field(DefaultFolderSetup;DefaultFolderSetup)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Default Folder Setup';
                }
                field(PublicMailBoxName;PublicMailBoxName)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Public Mail Box Name';
                    Editable = not DefaultFolderSetup;
                }
                field(RootQueueStorageFolder;RootQueueStorageFolder)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Root Folder';
                    Editable = not DefaultFolderSetup;
                }
                field(QueueFolderName;QueueFolderName)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Queue Folder Name';
                    Editable = not DefaultFolderSetup;
                }
                field(StorageFolderName;StorageFolderName)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Storage Folder Name';
                    Editable = not DefaultFolderSetup;
                }
            }
            group("Email Rules")
            {
                InstructionalText = 'The following Exchange transport rules will be created, so that incoming email from outside organizations and outgoing mail to outside organization will be copied to queue public folder for later NAV processing. You can disable creation or give specific names for the rules:';
                Visible = EmailRulesVisible;
                field(CreateIncomingEmailRule;CreateIncomingEmailRule)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Create Incoming Email Rule';

                    trigger OnValidate()
                    begin
                        if not CreateIncomingEmailRule then
                          Clear(IncomingEmailRuleName);
                    end;
                }
                field(IncomingEmailRuleName;IncomingEmailRuleName)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Incoming Email Rule Name';
                    Editable = CreateIncomingEmailRule;
                }
                field(CreateOutgoingEmailRule;CreateOutgoingEmailRule)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Create Outgoing Email Rule';

                    trigger OnValidate()
                    begin
                        if not CreateOutgoingEmailRule then
                          Clear(OutgoingEmailRuleName);
                    end;
                }
                field(OutgoingEmailRuleName;OutgoingEmailRuleName)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Outgoing Email Rule Name';
                    Editable = CreateOutgoingEmailRule;
                }
            }
            group(Step4)
            {
                Caption = '';
                Visible = DoneVisible;
                group(FinalStepDesc)
                {
                    Caption = 'That''s it!';
                    InstructionalText = 'When you choose Finish, the following will be created:';
                    group(Control33)
                    {
                        field(QueueFolderNameFinal;QueueFolderName)
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'Queue Folder';
                            Editable = false;
                        }
                        field(StorageFolderNameFinal;StorageFolderName)
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'Storage Folder';
                            Editable = false;
                        }
                        field(IncomingEmailRuleNameFinal;IncomingEmailRuleName)
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'Incoming Email Rule';
                            Editable = false;
                        }
                        field(OutgoingEmailRuleNameFinal;OutgoingEmailRuleName)
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'Outgoing Email Rule';
                            Editable = false;
                        }
                        field(CreateEmailLoggingJobQueue;CreateEmailLoggingJobQueue)
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'Create Email Logging Job Queue';
                        }
                    }
                    group(Control34)
                    {
                        InstructionalText = '(Note: The creation of public folders and rules may take some time. When the folders are created, the wizard window will close.)';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ActionBack)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Back';
                Enabled = BackEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Next';
                Enabled = NextEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                var
                    ExchangeAddinSetup: Codeunit "Exchange Add-in Setup";
                begin
                    if (Step = Step::LoginPass) and (not SkipDeployment) then
                      ExchangeAddinSetup.InitializeServiceWithCredentials(Email,Password);
                    NextStep(false);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Finish';
                Enabled = FinishEnabled;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                var
                    AssistedSetup: Record "Assisted Setup";
                    MarketingSetup: Record "Marketing Setup";
                begin
                    Window.Open(SetupEmailLogDialogMsg);
                    if not SkipDeployment then begin
                      if MarketingSetup.Get then
                        SetupEmailLogging.ClearEmailLoggingSetup(MarketingSetup);

                      if not CreateExchangePublicFolders then begin
                        Window.Close;
                        Error(GetLastErrorText);
                      end;
                      UpdateMarketingSetup;

                      CreateMailLoggingRules;
                      if CreateEmailLoggingJobQueue then begin
                        UpdateWindow(CreatingEmailLoggingJobQueueTxt,9000);
                        SetupEmailLogging.CreateEmailLoggingJobQueueSetup;
                      end;
                      SetupEmailLogging.SetupEmailLoggingFolderMarketingSetup(RootQueueStorageFolder,QueueFolderName,StorageFolderName);
                    end;
                    AssistedSetup.SetStatus(Page::"Setup Email Logging",AssistedSetup.Status::Completed);
                    Window.Close;
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        LoadTopBanners;
    end;

    trigger OnOpenPage()
    begin
        PublicMailBoxName := PublicMailBoxTxt;
        RootQueueStorageFolder := EmailLoggingFolderTxt;
        QueueFolderName := QueueFolderTxt;
        StorageFolderName := StorageFolderTxt;
        IncomingEmailRuleName := IncomingEmailRuleTxt;
        OutgoingEmailRuleName := OutgoingEmailRuleTxt;
        DefaultFolderSetup := true;
        CreateIncomingEmailRule := true;
        CreateOutgoingEmailRule := true;
        ShowIntroStep;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        AssistedSetup: Record "Assisted Setup";
    begin
        SetupEmailLogging.ClosePSConnection;
        if CloseAction = Action::OK then
          if AssistedSetup.GetStatus(Page::"Setup Email Logging") = AssistedSetup.Status::"Not Completed" then
            if not Confirm(NAVNotSetUpQst,false) then
              Error('');
    end;

    var
        MediaRepositoryStandard: Record "Media Repository";
        MediaRepositoryDone: Record "Media Repository";
        SetupEmailLogging: Codeunit "Setup Email Logging";
        Window: Dialog;
        Step: Option Intro,LoginPass,PublicFolders,EmailRules,Done;
        Email: Text[80];
        Password: Text[30];
        RootQueueStorageFolder: Text;
        QueueFolderName: Text;
        StorageFolderName: Text;
        PublicMailBoxName: Text;
        IncomingEmailRuleName: Text;
        OutgoingEmailRuleName: Text;
        BackEnabled: Boolean;
        NextEnabled: Boolean;
        FinishEnabled: Boolean;
        TopBannerVisible: Boolean;
        IntroVisible: Boolean;
        LoginPassVisible: Boolean;
        DoneVisible: Boolean;
        PublicFoldersVisible: Boolean;
        PublicMailBoxTxt: label 'Public MailBox';
        EmailLoggingFolderTxt: label 'Email Logging';
        QueueFolderTxt: label 'Queue';
        StorageFolderTxt: label 'Storage';
        EmailRulesVisible: Boolean;
        DefaultFolderSetup: Boolean;
        CreateIncomingEmailRule: Boolean;
        CreateOutgoingEmailRule: Boolean;
        IncomingEmailRuleTxt: label 'Log Email Sent to This Organization';
        OutgoingEmailRuleTxt: label 'Log Email Sent from This Organization';
        NAVNotSetUpQst: label 'Setup of Email Logging was not finished. \\Are you sure that you want to exit?';
        CreateEmailLoggingJobQueue: Boolean;
        SetupEmailLogDialogMsg: label 'Setup Email Logging    #1################## @2@@@@@@@@@@@@@@@@@@', Comment='This is a message for dialog window. Parameters do not require translation.';
        InitializingConnectionTxt: label 'Initializing connection';
        PublicFoldersCreationTxt: label 'Public folders creation';
        EmailRulesCreationTxt: label 'Email rules creation';
        UpdatingMarketingSetupTxt: label 'Updating Marketing Setup';
        CreatingEmailLoggingJobQueueTxt: label 'Creating email Logging Job Queue';
        SkipDeployment: Boolean;

    local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then
          Step := Step - 1
        else
          Step := Step + 1;

        case Step of
          Step::Intro:
            ShowIntroStep;
          Step::LoginPass:
            begin
              if Backwards then
                SetupEmailLogging.ClosePSConnection;
              ShowLoginPassStep;
            end;
          Step::PublicFolders:
            if not SkipDeployment then begin
              Window.Open(SetupEmailLogDialogMsg);
              UpdateWindow(InitializingConnectionTxt,1000);
              if not Backwards then begin
                SetupEmailLogging.SetDeployCredentials(Email,Password);
                InitializePSExchangeConnection;
              end;
              ShowPublicFoldersStep;
              Window.Close;
            end;
          Step::EmailRules:
            ShowEmailRulesStep;
          Step::Done:
            ShowDoneStep;
        end;
        CurrPage.Update(true);
    end;

    local procedure ShowIntroStep()
    begin
        ResetWizardControls;
        IntroVisible := true;
        BackEnabled := false;
    end;

    local procedure ShowLoginPassStep()
    begin
        ResetWizardControls;
        NextEnabled := EmailPasswordNotEmpty;
        LoginPassVisible := true;
    end;

    local procedure ShowPublicFoldersStep()
    begin
        ResetWizardControls;
        NextEnabled := true;
        PublicFoldersVisible := true;
    end;

    local procedure ShowEmailRulesStep()
    begin
        ResetWizardControls;
        NextEnabled := true;
        EmailRulesVisible := true;
    end;

    local procedure ShowDoneStep()
    begin
        ResetWizardControls;
        DoneVisible := true;
        NextEnabled := false;
        FinishEnabled := true;
        CreateEmailLoggingJobQueue := true;
    end;

    local procedure ResetWizardControls()
    begin
        // Buttons
        BackEnabled := true;
        NextEnabled := true;
        FinishEnabled := false;

        // Tabs
        IntroVisible := false;
        LoginPassVisible := false;
        DoneVisible := false;
        PublicFoldersVisible := false;
        EmailRulesVisible := false;
    end;

    local procedure InitializePSExchangeConnection()
    begin
        SetupEmailLogging.InitializeExchangePSConnection;
    end;

    [TryFunction]
    local procedure CreateExchangePublicFolders()
    begin
        UpdateWindow(PublicFoldersCreationTxt,1000);
        SetupEmailLogging.CreatePublicFolders(
          PublicMailBoxName,RootQueueStorageFolder,QueueFolderName,StorageFolderName)
    end;

    local procedure CreateMailLoggingRules()
    var
        QueueEmailAddress: Text;
    begin
        UpdateWindow(EmailRulesCreationTxt,8000);
        QueueEmailAddress := QueueFolderName + '@' + SetupEmailLogging.GetDomainFromEmail(Email);
        SetupEmailLogging.CreateEmailLoggingRules(QueueEmailAddress,IncomingEmailRuleName,OutgoingEmailRuleName);
    end;

    local procedure EmailPasswordNotEmpty(): Boolean
    begin
        exit((Email <> '') and (Password <> ''));
    end;

    local procedure UpdateMarketingSetup()
    var
        MarketingSetup: Record "Marketing Setup";
    begin
        UpdateWindow(UpdatingMarketingSetupTxt,6000);
        if not MarketingSetup.Get then
          exit;

        MarketingSetup.Validate("Exchange Service URL",SetupEmailLogging.GetDomainFromEmail(Email));
        MarketingSetup.Validate("Autodiscovery E-Mail Address",Email);
        MarketingSetup.Validate("Email Batch Size",10);
        MarketingSetup.Validate("Exchange Account User Name",Email);
        MarketingSetup.SetExchangeAccountPassword(Password);
        MarketingSetup.Modify;
    end;

    local procedure UpdateWindow(StepText: Text;Progress: Integer)
    begin
        Window.Update(1,StepText);
        Window.Update(2,Progress);
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png',Format(CurrentClientType)) and
           MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png',Format(CurrentClientType))
        then
          TopBannerVisible := MediaRepositoryDone.Image.Hasvalue;
    end;


    procedure SkipDeploymentToExchange(Skip: Boolean)
    begin
        SkipDeployment := Skip;
    end;
}

