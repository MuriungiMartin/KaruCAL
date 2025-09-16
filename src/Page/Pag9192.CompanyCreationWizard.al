#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9192 "Company Creation Wizard"
{
    Caption = 'Create New Company';
    PageType = NavigatePage;

    layout
    {
        area(content)
        {
            group(Control6)
            {
                Editable = false;
                Visible = TopBannerVisible and not FinalStepVisible;
                field("MediaRepositoryStandard.Image";MediaRepositoryStandard.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Control8)
            {
                Editable = false;
                Visible = TopBannerVisible and FinalStepVisible;
                field("MediaRepositoryDone.Image";MediaRepositoryDone.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Control10)
            {
                Visible = FirstStepVisible;
                group("Welcome to assisted setup for creating a company")
                {
                    Caption = 'Welcome to assisted setup for creating a company';
                    Visible = FirstStepVisible;
                    group(Control12)
                    {
                        InstructionalText = 'This guide will help you create a new company.';
                        Visible = FirstStepVisible;
                    }
                }
                group("Let's go!")
                {
                    Caption = 'Let''s go!';
                    InstructionalText = 'Choose Next to get started.';
                }
            }
            group(Control13)
            {
                Visible = CreationStepVisible;
                group("Specify some basic information")
                {
                    Caption = 'Specify some basic information';
                    Visible = CreationStepVisible;
                    group(Control20)
                    {
                        InstructionalText = 'Enter a name for the company.';
                        field(CompanyName;NewCompanyName)
                        {
                            ApplicationArea = Basic,Suite;
                            ShowCaption = false;
                            ShowMandatory = true;

                            trigger OnValidate()
                            var
                                Company: Record Company;
                            begin
                                if Company.Get(NewCompanyName) then
                                  Error(CompanyAlreadyExistsErr);
                            end;
                        }
                    }
                    group("Select the data and setup to get started.")
                    {
                        Caption = 'Select the data and setup to get started.';
                        field(CompanyData;NewCompanyData)
                        {
                            ApplicationArea = Basic,Suite;
                            OptionCaption = 'Evaluation Data,Standard Data,None';
                            ShowCaption = false;

                            trigger OnValidate()
                            begin
                                UpdateDataDescription;
                            end;
                        }
                        field(NewCompanyDataDescription;NewCompanyDataDescription)
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            MultiLine = true;
                            ShowCaption = false;
                        }
                    }
                }
            }
            group(Control17)
            {
                Visible = FinalStepVisible;
                group("That's it!")
                {
                    Caption = 'That''s it!';
                    group(Control19)
                    {
                        InstructionalText = 'Choose Finish to create the company. This can take a few minutes to complete.';
                    }
                    group(Control22)
                    {
                        InstructionalText = 'The company is created and included in the companies list, but before you use it we need time to set up some data and settings for you.';
                        Visible = ConfigurationPackageExists;
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
                ApplicationArea = Basic,Suite;
                Caption = 'Back';
                Enabled = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;
                //The property 'ToolTip' cannot be empty.
                //ToolTip = '';

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
                //The property 'ToolTip' cannot be empty.
                //ToolTip = '';

                trigger OnAction()
                begin
                    FinishAction;
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
        Step := Step::Start;
        EnableControls;
        UpdateDataDescription;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::OK then
          if not CompanyCreated then
            if not Confirm(SetupNotCompletedQst,false) then
              Error('');
    end;

    var
        MediaRepositoryStandard: Record "Media Repository";
        MediaRepositoryDone: Record "Media Repository";
        Step: Option Start,Creation,Finish;
        TopBannerVisible: Boolean;
        FirstStepVisible: Boolean;
        CreationStepVisible: Boolean;
        FinalStepVisible: Boolean;
        FinishActionEnabled: Boolean;
        BackActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        SetupNotCompletedQst: label 'The company has not yet been created.\\Are you sure that you want to exit?';
        ConfigurationPackageExists: Boolean;
        NewCompanyName: Text[30];
        NewCompanyData: Option "Evaluation Data","Standard Data","None";
        CompanyAlreadyExistsErr: label 'A company with that name already exists. Try a different name.';
        NewCompanyDataDescription: Text;
        CompanyCreated: Boolean;
        SpecifyCompanyNameErr: label 'To continue, you must specify a name for the company.';
        CreatingCompanyMsg: label 'Creating company...';
        CompanySetUpFailedMsg: label 'Set up of the new company failed. Contact your system administrator.';
        NoConfigurationPackageFileDefinedMsg: label 'No configuration package file is defined for this company type. An empty company will be created.';
        NoPermissionsErr: label 'You do not have permissions to create a new company. Contact your system administrator.';
        StandardTxt: label 'Standard', Comment='Must be similar to "Data Type" option in table 101900 Demonstration Data Setup';
        EvaluationTxt: label 'Evaluation', Comment='Must be similar to "Data Type" option in table 101900 Demonstration Data Setup';
        EvaluationDataTxt: label '\Just want to try it out?\\Create a company with everything you need to evaluate the product. For example, sample invoices and ledger entries let you view charts and reports.';
        StandardDataTxt: label '\Thinking about going into production?\\Create a company with data and set ups like number series, a chart of accounts, and payment methods ready for use. Set up your own items and customers, and start posting right-away.';
        NoDataTxt: label '\Want to set things up yourself?\\Create a company that does not contain data, and is not already set up for use. For example, select this option when you want to use your own data, and set things up yourself.';
        TrialPeriodTxt: label '\\You will be able to use this company for a 30-day trial period.';
        EvalPeriodTxt: label '\\You will be able to use the company to try out the product for as long as you want. ';

    local procedure EnableControls()
    begin
        ResetControls;

        case Step of
          Step::Start:
            ShowStartStep;
          Step::Creation:
            ShowCreationStep;
          Step::Finish:
            ShowFinalStep;
        end;
    end;

    local procedure FinishAction()
    begin
        CreateNewCompany;
        SetUpNewCompany;
        CompanyCreated := true;
        CurrPage.Close;
    end;

    local procedure NextStep(Backwards: Boolean)
    begin
        if (Step = Step::Creation) and not Backwards then
          if NewCompanyName = '' then
            Error(SpecifyCompanyNameErr);
        if (Step = Step::Creation) and not Backwards then
          ValidateCompanyType;

        if Backwards then
          Step := Step - 1
        else
          Step := Step + 1;

        EnableControls;
    end;

    local procedure ShowStartStep()
    begin
        FirstStepVisible := true;

        FinishActionEnabled := false;
        BackActionEnabled := false;
    end;

    local procedure ShowCreationStep()
    begin
        CreationStepVisible := true;

        FinishActionEnabled := false;
    end;

    local procedure ShowFinalStep()
    begin
        FinalStepVisible := true;
        NextActionEnabled := false;
    end;

    local procedure ResetControls()
    begin
        FinishActionEnabled := true;
        BackActionEnabled := true;
        NextActionEnabled := true;

        FirstStepVisible := false;
        CreationStepVisible := false;
        FinalStepVisible := false;
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png',Format(CurrentClientType)) and
           MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png',Format(CurrentClientType))
        then
          TopBannerVisible := MediaRepositoryDone.Image.Hasvalue;
    end;

    local procedure CreateNewCompany()
    var
        Company: Record Company;
        GeneralLedgerSetup: Record "General Ledger Setup";
        Window: Dialog;
    begin
        Window.Open(CreatingCompanyMsg);

        Company.Init;
        Company.Name := NewCompanyName;
        Company.Insert;

        if not GeneralLedgerSetup.ChangeCompany(NewCompanyName) then
          Error(NoPermissionsErr);
        if not GeneralLedgerSetup.WritePermission then
          Error(NoPermissionsErr);

        Commit;

        Window.Close;
    end;

    local procedure SetUpNewCompany()
    var
        Company: Record Company;
        ConfigurationPackageFile: Record "Configuration Package File";
        AssistedCompanySetupStatus: Record "Assisted Company Setup Status";
        ImportSessionID: Integer;
    begin
        if NewCompanyData = Newcompanydata::None then
          exit;

        case NewCompanyData of
          Newcompanydata::"Evaluation Data":
            ConfigurationPackageFile.SetFilter(Code,'*' + EvaluationTxt + '*');
          Newcompanydata::"Standard Data":
            ConfigurationPackageFile.SetFilter(Code,'*' + StandardTxt + '*');
        end;
        ConfigurationPackageFile.SetRange("Language ID",GlobalLanguage);
        ConfigurationPackageFile.SetRange("Setup Type",ConfigurationPackageFile."setup type"::Company);
        if ConfigurationPackageFile.IsEmpty then
          exit;

        AssistedCompanySetupStatus.SetEnabled(NewCompanyName,NewCompanyData = Newcompanydata::"Standard Data",false);
        Company.Get(NewCompanyName);
        Company."Evaluation Company" := NewCompanyData = Newcompanydata::"Evaluation Data";
        Company.Modify;
        SetApplicationArea;

        Commit;
        ImportSessionID := 0;
        if StartSession(ImportSessionID,Codeunit::"Import Config. Package Files",NewCompanyName,ConfigurationPackageFile) then begin
          AssistedCompanySetupStatus.Get(NewCompanyName);
          AssistedCompanySetupStatus."Company Setup Session ID" := ImportSessionID;
          AssistedCompanySetupStatus.Modify;
        end else
          Message(CompanySetUpFailedMsg);
    end;

    local procedure SetApplicationArea()
    var
        ApplicationAreaSetup: Record "Application Area Setup";
    begin
        ApplicationAreaSetup.Init;
        ApplicationAreaSetup."Company Name" := NewCompanyName;
        ApplicationAreaSetup.Basic := true;
        ApplicationAreaSetup."Relationship Mgmt" := true;
        ApplicationAreaSetup.Suite := NewCompanyData = Newcompanydata::"Standard Data";
        ApplicationAreaSetup.Insert;
    end;

    local procedure ValidateCompanyType()
    var
        ConfigurationPackageFile: Record "Configuration Package File";
    begin
        Clear(ConfigurationPackageExists);

        if NewCompanyData = Newcompanydata::None then
          exit;

        case NewCompanyData of
          Newcompanydata::"Evaluation Data":
            ConfigurationPackageFile.SetFilter(Code,'*' + EvaluationTxt + '*');
          Newcompanydata::"Standard Data":
            ConfigurationPackageFile.SetFilter(Code,'*' + StandardTxt + '*');
        end;

        ConfigurationPackageExists := not ConfigurationPackageFile.IsEmpty;
        if not ConfigurationPackageExists then
          Message(NoConfigurationPackageFileDefinedMsg)
    end;

    local procedure UpdateDataDescription()
    var
        TenantLicenseState: Record "Tenant License State";
    begin
        case NewCompanyData of
          Newcompanydata::"Evaluation Data":
            NewCompanyDataDescription := EvaluationDataTxt;
          Newcompanydata::"Standard Data":
            NewCompanyDataDescription := StandardDataTxt;
          Newcompanydata::None:
            NewCompanyDataDescription := NoDataTxt;
        end;

        if not TenantLicenseState.FindLast then
          exit;
        if TenantLicenseState.State = TenantLicenseState.State::Paid then
          exit;

        case NewCompanyData of
          Newcompanydata::"Evaluation Data":
            NewCompanyDataDescription += EvalPeriodTxt;
          Newcompanydata::"Standard Data",
          Newcompanydata::None:
            NewCompanyDataDescription += TrialPeriodTxt;
        end;
    end;
}

