#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1803 "Assisted Company Setup Wizard"
{
    Caption = 'Company Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = NavigatePage;
    PromotedActionCategories = 'New,Process,Report,Step 4,Step 5';
    ShowFilter = false;
    SourceTable = "Config. Setup";
    SourceTableTemporary = true;

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
            group(Control8)
            {
                Visible = IntroVisible;
                group("Welcome to Company Setup.")
                {
                    Caption = 'Welcome to Company Setup.';
                    InstructionalText = 'To prepare Dynamics 365 for Financials for first use, you must specify some basic information about your company. This information is used on your external documents, such as sales invoices, and includes your company logo and bank information. You must also set up the fiscal year.';
                }
                group("Let's go!")
                {
                    Caption = 'Let''s go!';
                    InstructionalText = 'Choose Next so you can specify basic company information.';
                }
            }
            group(Control18)
            {
                Visible = SelectTypeVisible and TypeSelectionEnabled;
                group("Standard Setup")
                {
                    Caption = 'Standard Setup';
                    InstructionalText = 'The company will be ready to use when Setup has completed.';
                    Visible = StandardVisible;
                    field(Standard;TypeStandard)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Set up as Standard';

                        trigger OnValidate()
                        begin
                            if TypeStandard then
                              TypeEvaluation := false;
                        end;
                    }
                }
                group("Evaluation Setup")
                {
                    Caption = 'Evaluation Setup';
                    InstructionalText = 'The company will be set up in demonstration mode for exploring and testing.';
                    Visible = EvaluationVisible;
                    field(Evaluation;TypeEvaluation)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Set up as Evaluation';

                        trigger OnValidate()
                        begin
                            if TypeEvaluation then
                              TypeStandard := false;
                        end;
                    }
                }
                group(Important)
                {
                    Caption = 'Important';
                    InstructionalText = 'You cannot change your choice of setup after you choose Next.';
                    Visible = TypeStandard or TypeEvaluation;
                }
            }
            group(Control56)
            {
                Visible = CompanyDetailsVisible;
                group("Specify your company's address information and logo.")
                {
                    Caption = 'Specify your company''s address information and logo.';
                    field(Name;Name)
                    {
                        ApplicationArea = Basic,Suite;
                        NotBlank = true;
                        ShowMandatory = true;
                    }
                    field(Address;Address)
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Address 2";"Address 2")
                    {
                        ApplicationArea = Basic;
                        Visible = false;
                    }
                    field(City;City)
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field(County;County)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'State';
                        ToolTip = 'Specifies the state as a part of the address.';
                    }
                    field("Post Code";"Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Country/Region Code";"Country/Region Code")
                    {
                        ApplicationArea = Basic,Suite;
                        TableRelation = "Country/Region".Code;

                        trigger OnValidate()
                        begin
                            SetTaxAreaCodeVisible;
                        end;
                    }
                    field("VAT Registration No.";"VAT Registration No.")
                    {
                        ApplicationArea = Basic;
                        Visible = false;
                    }
                    field("Industrial Classification";"Industrial Classification")
                    {
                        ApplicationArea = Basic;
                        NotBlank = true;
                        ShowMandatory = true;
                        Visible = false;
                    }
                    field(Picture;Picture)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Company Logo';

                        trigger OnValidate()
                        begin
                            LogoPositionOnDocumentsShown := Picture.Hasvalue;
                            if LogoPositionOnDocumentsShown then begin
                              if "Logo Position on Documents" = "logo position on documents"::"No Logo" then
                                "Logo Position on Documents" := "logo position on documents"::Right;
                            end else
                              "Logo Position on Documents" := "logo position on documents"::"No Logo";
                            CurrPage.Update(true);
                        end;
                    }
                }
                group(Control1020001)
                {
                    Visible = TaxAreaCodeVisible;
                    field("Tax Area Code";"Tax Area Code")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Logo Position on Documents";"Logo Position on Documents")
                    {
                        ApplicationArea = Basic;
                        Editable = LogoPositionOnDocumentsShown;
                    }
                }
            }
            group(Control45)
            {
                Visible = CommunicationDetailsVisible;
                group("Specify the contact details for your company.")
                {
                    Caption = 'Specify the contact details for your company.';
                    InstructionalText = 'This is used in invoices and other documents where general information about your company is printed.';
                    field("Phone No.";"Phone No.")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("E-Mail";"E-Mail")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Home Page";"Home Page")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                }
            }
            group(Control29)
            {
                Visible = BankStatementConfirmationVisible;
                group("Bank Feed Service")
                {
                    Caption = 'Bank Feed Service';
                    InstructionalText = 'You can use a bank feeds service to import electronic bank statements from your bank to quickly process payments.';
                    field(UseBankStatementFeed;UseBankStatementFeed)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Use a bank feed service';
                    }
                }
                group("NOTE:")
                {
                    Caption = 'NOTE:';
                    InstructionalText = 'When you choose Next, you accept the terms of use for the bank feed service.';
                    Visible = UseBankStatementFeed;
                    field(TermsOfUseLbl;TermsOfUseLbl)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ShowCaption = false;
                        ToolTip = 'Specifies a link to the terms of use for the Envestnet Yodlee bank feed service.';

                        trigger OnDrillDown()
                        begin
                            Hyperlink(TermsOfUseUrlTxt);
                        end;
                    }
                }
            }
            group("Select bank account.")
            {
                Caption = 'Select bank account.';
                Visible = SelectBankAccountVisible;
                part(OnlineBanckAccountLinkPagePart;"Online Bank Accounts")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
            group(Control37)
            {
                Visible = PaymentDetailsVisible;
                group("Specify your company's bank information.")
                {
                    Caption = 'Specify your company''s bank information.';
                    InstructionalText = 'This information is included on documents that you send to customer and vendors to inform about payments to your bank account.';
                    field("Bank Name";"Bank Name")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Bank Branch No.";"Bank Branch No.")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Bank Account No.";"Bank Account No.")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnValidate()
                        begin
                            ShowBankAccountCreationWarning := not ValidateBankAccountNotEmpty;
                        end;
                    }
                }
                group(Control33)
                {
                    Caption = ' ';
                    InstructionalText = 'To create a bank account that is linked to the related online bank account, you must specify the bank account information above.';
                    Visible = ShowBankAccountCreationWarning;
                }
            }
            group(Control6)
            {
                Visible = AccountingPeriodVisible;
                group("Specify information about your company's fiscal year for accounting purposes.")
                {
                    Caption = 'Specify information about your company''s fiscal year for accounting purposes.';
                    field(AccountingPeriodStartDate;AccountingPeriodStartDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Accounting Period Start';
                        NotBlank = true;
                        ShowMandatory = true;
                    }
                }
            }
            group(Control9)
            {
                Visible = DoneVisible;
                group("That's it!")
                {
                    Caption = 'That''s it!';
                    InstructionalText = 'Choose Finish to prepare the application for first use. This will take a few moments.';
                    field(HelpLbl;HelpLbl)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ExtendedDatatype = URL;

                        trigger OnDrillDown()
                        begin
                            Hyperlink(HelpLinkTxt);
                        end;
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
                ApplicationArea = Basic,Suite;
                Caption = 'Next';
                Enabled = NextEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    if (Step = Step::"Select Type") and not (TypeStandard or TypeEvaluation) then
                      if not Confirm(NoSetupTypeSelectedQst,false) then
                        Error('');
                    NextStep(false);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Finish';
                Enabled = FinishEnabled;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                var
                    AssistedSetup: Record "Assisted Setup";
                    AssistedCompanySetup: Codeunit "Assisted Company Setup";
                begin
                    AssistedCompanySetup.WaitForPackageImportToComplete(ImportSessionID);
                    BankAccount.TransferFields(TempBankAccount,true);
                    AssistedCompanySetup.ApplyUserInput(Rec,BankAccount,AccountingPeriodStartDate,TypeEvaluation);
                    AssistedSetup.SetStatus(Page::"Assisted Company Setup Wizard",AssistedSetup.Status::Completed);
                    if (BankAccount."No." <> '') and (TempOnlineBankAccLink.Count > 0) then
                      BankAccount.OnMarkAccountLinkedEvent(TempOnlineBankAccLink,BankAccount);
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetTaxAreaCodeVisible;
    end;

    trigger OnAfterGetRecord()
    begin
        LogoPositionOnDocumentsShown := Picture.Hasvalue;
    end;

    trigger OnInit()
    begin
        InitializeRecord;
        LoadTopBanners;
    end;

    trigger OnOpenPage()
    begin
        ResetWizardControls;
        ShowIntroStep;
        TypeSelectionEnabled := LoadConfigTypes and not PackageImported;
        ImportSessionID := 0;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        AssistedSetup: Record "Assisted Setup";
    begin
        if CloseAction = Action::OK then
          if AssistedSetup.GetStatus(Page::"Assisted Company Setup Wizard") = AssistedSetup.Status::"Not Completed" then
            if not Confirm(NotSetUpQst,false) then
              Error('');
    end;

    var
        MediaRepositoryStandard: Record "Media Repository";
        TempBankAccount: Record "Bank Account" temporary;
        BankAccount: Record "Bank Account";
        TempOnlineBankAccLink: Record "Online Bank Acc. Link" temporary;
        MediaRepositoryDone: Record "Media Repository";
        AccountingPeriodStartDate: Date;
        ImportSessionID: Integer;
        TypeStandard: Boolean;
        TypeEvaluation: Boolean;
        Step: Option Intro,"Select Type","Company Details","Communication Details",BankStatementFeed,SelectBankAccont,"Payment Details","Accounting Period",Done;
        BackEnabled: Boolean;
        NextEnabled: Boolean;
        FinishEnabled: Boolean;
        TopBannerVisible: Boolean;
        IntroVisible: Boolean;
        SelectTypeVisible: Boolean;
        CompanyDetailsVisible: Boolean;
        CommunicationDetailsVisible: Boolean;
        PaymentDetailsVisible: Boolean;
        AccountingPeriodVisible: Boolean;
        DoneVisible: Boolean;
        TypeSelectionEnabled: Boolean;
        StandardVisible: Boolean;
        EvaluationVisible: Boolean;
        SkipAccountingPeriod: Boolean;
        NotSetUpQst: label 'The application has not been set up. Setup will continue the next time you start the program.\\Are you sure that you want to exit?';
        HideBankStatementProvider: Boolean;
        ImportStarted: Boolean;
        StandardTxt: label 'Standard', Comment='Must be similar to "Data Type" option in table 101900 Demonstration Data Setup';
        EvaluationTxt: label 'Evaluation', Comment='Must be similar to "Data Type" option in table 101900 Demonstration Data Setup';
        NoSetupTypeSelectedQst: label 'You have not selected any setup type. If you proceed, the application will not be fully functional, until you set it up manually.\\Do you want to continue?';
        HelpLbl: label 'To learn more about setting up your company, follow this link';
        HelpLinkTxt: label 'http://go.microsoft.com/fwlink/?LinkId=746160', Locked=true;
        BankStatementConfirmationVisible: Boolean;
        UseBankStatementFeed: Boolean;
        SelectBankAccountVisible: Boolean;
        TaxAreaCodeVisible: Boolean;
        TermsOfUseLbl: label 'Envestnet Yodlee Terms of Use';
        TermsOfUseUrlTxt: label 'https://go.microsoft.com/fwlink/?LinkId=746179', Locked=true;
        LogoPositionOnDocumentsShown: Boolean;
        ShowBankAccountCreationWarning: Boolean;

    local procedure NextStep(Backwards: Boolean)
    begin
        ResetWizardControls;

        if Backwards then
          Step := Step - 1
        else
          Step := Step + 1;

        case Step of
          Step::Intro:
            ShowIntroStep;
          Step::"Select Type":
            if not TypeSelectionEnabled then
              NextStep(Backwards)
            else
              ShowSelectTypeStep;
          Step::"Company Details":
            if TypeEvaluation then begin
              Step := Step::Done;
              ShowDoneStep;
            end else
              ShowCompanyDetailsStep;
          Step::"Communication Details":
            ShowCommunicationDetailsStep;
          Step::BankStatementFeed:
            if not ShowBankStatementFeedStep then
              NextStep(Backwards)
            else
              ShowBankStatementFeedConfirmation;
          Step::SelectBankAccont:
            begin
              if not Backwards then
                ShowOnlineBankStatement;
              if not ShowSelectBankAccountStep then
                NextStep(Backwards)
              else
                ShowSelectBankAccount;
            end;
          Step::"Payment Details":
            begin
              if not Backwards then
                PopulateBankAccountInformation;
              ShowPaymentDetailsStep;
              ShowBankAccountCreationWarning := not ValidateBankAccountNotEmpty;
            end;
          Step::"Accounting Period":
            if SkipAccountingPeriod then
              NextStep(Backwards)
            else
              ShowAccountingPeriodStep;
          Step::Done:
            ShowDoneStep;
        end;
        CurrPage.Update(true);
    end;

    local procedure ShowIntroStep()
    begin
        IntroVisible := true;
        BackEnabled := false;
    end;

    local procedure ShowSelectTypeStep()
    begin
        SelectTypeVisible := true;
    end;

    local procedure ShowCompanyDetailsStep()
    begin
        CompanyDetailsVisible := true;
        if TypeSelectionEnabled then begin
          StartConfigPackageImport;
          BackEnabled := false;
        end;
    end;

    local procedure ShowCommunicationDetailsStep()
    begin
        CommunicationDetailsVisible := true;
    end;

    local procedure ShowPaymentDetailsStep()
    begin
        PaymentDetailsVisible := true;
    end;

    local procedure ShowOnlineBankStatement()
    var
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
    begin
        if CompanyInformationMgt.IsDemoCompany then
          exit;

        if HideBankStatementProvider then
          exit;

        if not TempBankAccount.StatementProvidersExist then
          exit;

        if UseBankStatementFeed then begin
          TempOnlineBankAccLink.Reset;
          TempOnlineBankAccLink.DeleteAll;
          TempBankAccount.SimpleLinkStatementProvider(TempOnlineBankAccLink);
          if TempOnlineBankAccLink.FindFirst then
            if TempOnlineBankAccLink.Count > 0 then begin
              CurrPage.OnlineBanckAccountLinkPagePart.Page.SetRecs(TempOnlineBankAccLink);
              HideBankStatementProvider := true;
            end;
        end;
    end;

    local procedure ShowAccountingPeriodStep()
    begin
        AccountingPeriodVisible := true;
    end;

    local procedure ShowDoneStep()
    begin
        DoneVisible := true;
        NextEnabled := false;
        FinishEnabled := true;
        if TypeEvaluation then begin
          StartConfigPackageImport;
          BackEnabled := false;
        end;
    end;

    local procedure ResetWizardControls()
    begin
        // Buttons
        BackEnabled := true;
        NextEnabled := true;
        FinishEnabled := false;

        // Tabs
        IntroVisible := false;
        SelectTypeVisible := false;
        CompanyDetailsVisible := false;
        CommunicationDetailsVisible := false;
        BankStatementConfirmationVisible := false;
        SelectBankAccountVisible := false;
        PaymentDetailsVisible := false;
        AccountingPeriodVisible := false;
        DoneVisible := false;
    end;

    local procedure InitializeRecord()
    var
        CompanyInformation: Record "Company Information";
        AccountingPeriod: Record "Accounting Period";
    begin
        Init;

        if CompanyInformation.Get then begin
          TransferFields(CompanyInformation);
          if Name = '' then
            Name := COMPANYNAME;
        end else
          Name := COMPANYNAME;

        SkipAccountingPeriod := not AccountingPeriod.IsEmpty;
        if not SkipAccountingPeriod then
          AccountingPeriodStartDate := CalcDate('<-CY>',Today);

        Insert;
    end;

    local procedure StartConfigPackageImport()
    var
        Company: Record Company;
        ConfigurationPackageFile: Record "Configuration Package File";
        AssistedCompanySetupStatus: Record "Assisted Company Setup Status";
        CodeFilter: Text;
    begin
        if ImportStarted or not TypeSelectionEnabled then
          exit;

        if not (TypeStandard or TypeEvaluation) then
          exit;

        Company.Get(COMPANYNAME);
        Company."Evaluation Company" := TypeEvaluation;
        Company.Modify;

        case true of
          TypeStandard:
            CodeFilter := '*' + StandardTxt + '*';
          TypeEvaluation:
            CodeFilter := '*' + EvaluationTxt + '*';
        end;
        ConfigurationPackageFile.SetFilter(Code,CodeFilter);
        ConfigurationPackageFile.SetRange("Language ID",GlobalLanguage);
        ConfigurationPackageFile.SetRange("Setup Type",ConfigurationPackageFile."setup type"::Company);
        ImportStarted := StartSession(ImportSessionID,Codeunit::"Import Config. Package Files",COMPANYNAME,ConfigurationPackageFile);
        if ImportStarted then begin
          AssistedCompanySetupStatus.Get(COMPANYNAME);
          AssistedCompanySetupStatus."Company Setup Session ID" := ImportSessionID;
          AssistedCompanySetupStatus.Modify;
        end;
    end;

    local procedure LoadConfigTypes(): Boolean
    var
        ConfigurationPackageFile: Record "Configuration Package File";
    begin
        ConfigurationPackageFile.SetRange("Language ID",GlobalLanguage);
        ConfigurationPackageFile.SetRange("Setup Type",ConfigurationPackageFile."setup type"::Company);

        ConfigurationPackageFile.SetFilter(Code,'*' + StandardTxt + '*');
        if not ConfigurationPackageFile.IsEmpty then
          StandardVisible := true;

        ConfigurationPackageFile.SetFilter(Code,'*' + EvaluationTxt + '*');
        if not ConfigurationPackageFile.IsEmpty then
          EvaluationVisible := true;

        exit(StandardVisible or EvaluationVisible);
    end;

    local procedure PackageImported(): Boolean
    var
        AssistedCompanySetupStatus: Record "Assisted Company Setup Status";
    begin
        AssistedCompanySetupStatus.Get(COMPANYNAME);
        exit(AssistedCompanySetupStatus."Package Imported" or AssistedCompanySetupStatus."Import Failed");
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png',Format(CurrentClientType)) and
           MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png',Format(CurrentClientType))
        then
          TopBannerVisible := MediaRepositoryDone.Image.Hasvalue;
    end;

    local procedure PopulateBankAccountInformation()
    begin
        if TempOnlineBankAccLink.Count = 0 then
          exit;
        if TempOnlineBankAccLink.Count = 1 then
          TempOnlineBankAccLink.FindFirst
        else
          CurrPage.OnlineBanckAccountLinkPagePart.Page.GetRecord(TempOnlineBankAccLink);

        if (TempBankAccount."Bank Account No." = TempBankAccount."Bank Account No.") and
           (TempBankAccount.Name = TempOnlineBankAccLink.Name)
        then
          exit;

        if not IsBankAccountFormatValid(TempOnlineBankAccLink."Bank Account No.") then
          Clear(TempOnlineBankAccLink."Bank Account No.");

        TempBankAccount.Init;
        TempBankAccount.CreateNewAccount(TempOnlineBankAccLink);
        "Bank Account No." := TempBankAccount."Bank Account No.";
        "Bank Name" := TempBankAccount.Name;
        "Bank Branch No." := TempBankAccount."Bank Branch No.";
        "SWIFT Code" := TempBankAccount."SWIFT Code";
        Iban := TempBankAccount.Iban;
    end;

    local procedure ShowBankStatementFeedConfirmation()
    begin
        BankStatementConfirmationVisible := true;
    end;

    local procedure ShowBankStatementFeedStep(): Boolean
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if not GeneralLedgerSetup.Get then
          exit(false);
        if GeneralLedgerSetup."LCY Code" = '' then
          exit(false);

        UseBankStatementFeed := BankAccount.StatementProvidersExist;
        exit(UseBankStatementFeed);
    end;

    local procedure ShowSelectBankAccountStep(): Boolean
    begin
        exit(TempOnlineBankAccLink.Count > 1);
    end;

    local procedure ShowSelectBankAccount()
    begin
        SelectBankAccountVisible := true;
    end;

    local procedure SetTaxAreaCodeVisible()
    var
        TaxArea: Record "Tax Area";
    begin
        TaxAreaCodeVisible := false;

        if TaxArea.IsEmpty then
          exit;

        if "Country/Region Code" <> 'CA' then
          exit;

        TaxAreaCodeVisible := true;
    end;

    local procedure IsBankAccountFormatValid(BankAccount: Text): Boolean
    var
        VarInt: Integer;
        Which: Text;
    begin
        Which := ' -';
        exit(Evaluate(VarInt,DelChr(BankAccount,'=',Which)));
    end;

    local procedure ValidateBankAccountNotEmpty(): Boolean
    begin
        if ("Bank Account No." = '') and (TempOnlineBankAccLink.Count > 0) then
          exit(false);

        exit(true);
    end;
}

