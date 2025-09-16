#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1817 "CRM Connection Setup Wizard"
{
    Caption = 'Dynamics CRM Connection Setup';
    PageType = NavigatePage;
    SourceTable = "CRM Connection Setup";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(BannerStandard)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible and not FinalStepVisible;
                field("MediaRepositoryStandard.Image";MediaRepositoryStandard.Image)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(BannerDone)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible and FinalStepVisible;
                field("MediaRepositoryDone.Image";MediaRepositoryDone.Image)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Step1)
            {
                Caption = '';
                InstructionalText = 'Welcome to Dynamics CRM Connection Setup.';
                Visible = FirstStepVisible;
                group(Control23)
                {
                    InstructionalText = 'You can set up a Dynamics CRM connection to enable seamless coupling of data.';
                }
                group(Control24)
                {
                    InstructionalText = 'Once coupled, you can access Dynamics CRM records here and, for some entities, access records from Dynamics CRM. You can also synchronize data between records so that data is the same in both systems.';
                }
                group(Control25)
                {
                    InstructionalText = 'Let''s go!';
                }
                group(Control26)
                {
                    InstructionalText = 'Choose Next to set up a Dynamics CRM connection.';
                }
            }
            group(Step2)
            {
                Caption = '';
                InstructionalText = 'Enter the URL of the Dynamics CRM server that hosts the solution that you want to connect to.';
                Visible = SrvAdrStepVisible;
                field(ServerAddress;"Server Address")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the URL of the Dynamics CRM server that hosts the Dynamics CRM solution that you want to connect to.';

                    trigger OnValidate()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.CheckModifyCRMConnectionURL("Server Address");
                    end;
                }
            }
            group(Step3)
            {
                Caption = '';
                Visible = CredentialsStepVisible;
                group("Step3.1")
                {
                    Caption = '';
                    InstructionalText = 'Enter the credentials for the Dynamics CRM account that will be used for the integration.';
                    field(Email;"User Name")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Email';
                    }
                    field(Password;Password)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Password';
                        ExtendedDatatype = Masked;
                    }
                }
                group("Step3.2")
                {
                    Caption = '';
                    InstructionalText = 'Enter the credentials for the Dynamics CRM administrator account that will be used to import the Dynamics CRM solution.';
                    field(AdminEmail;AdminEmail)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Email';
                    }
                    field(AdminPassword;AdminPassword)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Password';
                        ExtendedDatatype = Masked;
                    }
                }
            }
            group(Step4)
            {
                Caption = '';
                InstructionalText = 'Select the check box if you want to import the Dynamics CRM solution, publish Item Availability webservice and enable the Dynamics CRM connection.';
                Visible = FinalStepVisible;
                field(ImportCRMSolution;ImportSolution)
                {
                    ApplicationArea = Suite;
                    Caption = 'Import Dynamics CRM Solution';
                    Enabled = ImportCRMSolutionEnabled;

                    trigger OnValidate()
                    begin
                        OnImportSolutionChange;
                    end;
                }
                field(PublishItemAvailabilityService;PublishItemAvailabilityService)
                {
                    ApplicationArea = Suite;
                    Caption = 'Publish Item Availability Webservice';
                    Enabled = PublishItemAvailabilityServiceEnabled;
                }
                field(EnableCRMConnection;EnableCRMConnection)
                {
                    ApplicationArea = Suite;
                    Caption = 'Enable Dynamics CRM Connection';
                    Enabled = EnableCRMConnectionEnabled;
                }
            }
            group(Control27)
            {
                Visible = FinalStepVisible;
                group(Control28)
                {
                    InstructionalText = 'That''s it!';
                }
                group(Control29)
                {
                    InstructionalText = 'To enable the Dynamics CRM connection, choose Finish.';
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
                ApplicationArea = Basic,Suite;
                Caption = 'Back';
                Enabled = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next';
                Enabled = NextActionEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Finish';
                Enabled = FinishActionEnabled;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                var
                    AssistedSetup: Record "Assisted Setup";
                begin
                    FinalizeSetup;
                    AssistedSetup.SetStatus(Page::"CRM Connection Setup Wizard",AssistedSetup.Status::Completed);
                    Commit;
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
    var
        CRMConnectionSetup: Record "CRM Connection Setup";
    begin
        Init;
        if CRMConnectionSetup.Get then begin
          "Server Address" := CRMConnectionSetup."Server Address";
          "User Name" := CRMConnectionSetup."User Name";
        end;
        Insert;
        Step := Step::Start;
        EnableControls;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        AssistedSetup: Record "Assisted Setup";
    begin
        if CloseAction = Action::OK then
          if AssistedSetup.GetStatus(Page::"CRM Connection Setup Wizard") = AssistedSetup.Status::"Not Completed" then
            if not Confirm(NAVNotSetUpQst,false) then
              Error('');
    end;

    var
        MediaRepositoryStandard: Record "Media Repository";
        MediaRepositoryDone: Record "Media Repository";
        Step: Option Start,ServerAddress,Credentials,Finish;
        TopBannerVisible: Boolean;
        BackActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        FinishActionEnabled: Boolean;
        FirstStepVisible: Boolean;
        SrvAdrStepVisible: Boolean;
        CredentialsStepVisible: Boolean;
        FinalStepVisible: Boolean;
        EnableCRMConnection: Boolean;
        ImportSolution: Boolean;
        PublishItemAvailabilityService: Boolean;
        EnableCRMConnectionEnabled: Boolean;
        ImportCRMSolutionEnabled: Boolean;
        PublishItemAvailabilityServiceEnabled: Boolean;
        Password: Text;
        NAVNotSetUpQst: label 'The Dynamics CRM connection has not been set up.\\Are you sure you want to exit?';
        AdminEmail: Text;
        AdminPassword: Text;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png',Format(CurrentClientType)) and
           MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png',Format(CurrentClientType))
        then
          TopBannerVisible := MediaRepositoryDone.Image.Hasvalue;
    end;

    local procedure NextStep(Backward: Boolean)
    begin
        if Backward then
          Step := Step - 1
        else
          Step := Step + 1;

        EnableControls;
    end;

    local procedure ResetControls()
    begin
        BackActionEnabled := false;
        NextActionEnabled := false;
        FinishActionEnabled := false;

        FirstStepVisible := false;
        SrvAdrStepVisible := false;
        CredentialsStepVisible := false;
        FinalStepVisible := false;

        ImportCRMSolutionEnabled := true;
        PublishItemAvailabilityServiceEnabled := ImportSolution;
        EnableCRMConnectionEnabled := true;
    end;

    local procedure EnableControls()
    begin
        ResetControls;

        case Step of
          Step::Start:
            ShowStartStep;
          Step::ServerAddress:
            ShowSrvAdrStep;
          Step::Credentials:
            ShowCredentialsStep;
          Step::Finish:
            ShowFinishStep;
        end;
    end;

    local procedure ShowStartStep()
    begin
        BackActionEnabled := false;
        NextActionEnabled := true;
        FinishActionEnabled := false;

        FirstStepVisible := true;
    end;

    local procedure ShowSrvAdrStep()
    begin
        BackActionEnabled := true;
        NextActionEnabled := true;

        SrvAdrStepVisible := true;
    end;

    local procedure ShowCredentialsStep()
    begin
        BackActionEnabled := true;
        NextActionEnabled := true;

        CredentialsStepVisible := true;
    end;

    local procedure ShowFinishStep()
    begin
        BackActionEnabled := true;
        NextActionEnabled := false;
        FinishActionEnabled := ("Server Address" <> '') or ("User Name" <> '');

        ImportCRMSolutionEnabled :=
          ("Server Address" <> '') and ("User Name" <> '') and (AdminEmail <> '') and (AdminPassword <> '');
        EnableCRMConnectionEnabled := ("Server Address" <> '') and ("User Name" <> '') and (Password <> '');
        if ImportCRMSolutionEnabled then
          ImportSolution := true;
        OnImportSolutionChange;
        if EnableCRMConnectionEnabled then
          EnableCRMConnection := true;

        FinalStepVisible := true;
    end;

    local procedure FinalizeSetup()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        if PublishItemAvailabilityService then
          CRMIntegrationManagement.SetupItemAvailabilityService;
        if ImportSolution then
          CRMIntegrationManagement.ImportCRMSolution("Server Address","User Name",AdminEmail,AdminPassword);
        UpdateFromWizard(Rec,Password);
        if EnableCRMConnection then
          EnableCRMConnectionFromWizard;
    end;

    local procedure OnImportSolutionChange()
    begin
        PublishItemAvailabilityServiceEnabled := ImportSolution;
        PublishItemAvailabilityService := ImportSolution;
    end;
}

