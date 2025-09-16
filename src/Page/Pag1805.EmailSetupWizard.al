#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1805 "Email Setup Wizard"
{
    Caption = 'Email Setup';
    PageType = NavigatePage;
    SourceTable = "SMTP Mail Setup";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control96)
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
            group(Control98)
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
            group(Control20)
            {
                Visible = FirstStepVisible;
                group("Welcome to Email Setup")
                {
                    Caption = 'Welcome to Email Setup';
                    Visible = FirstStepVisible;
                    group(Control18)
                    {
                        InstructionalText = 'To send email messages using actions on documents, such as the Sales Invoice window, you must log on to the relevant email account.';
                    }
                    group(Control19)
                    {
                        InstructionalText = 'Email messages can then be sent directly to customers and between approval workflow users.';
                    }
                }
                group("Let's go!")
                {
                    Caption = 'Let''s go!';
                    group(Control22)
                    {
                        InstructionalText = 'Choose Next so you can set up email sending from documents.';
                    }
                }
            }
            group(Control2)
            {
                InstructionalText = 'Choose your email provider.';
                Visible = ProviderStepVisible;
                field("Email Provider";EmailProvider)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Email Provider';

                    trigger OnValidate()
                    begin
                        if EmailProvider = Emailprovider::"Office 365" then
                          SMTPMail.ApplyOffice365Smtp(Rec)
                        else
                          "SMTP Server" := '';
                        EnableControls;
                    end;
                }
            }
            group(Control12)
            {
                Visible = SettingsStepVisible;
                group(Control27)
                {
                    InstructionalText = 'Enter the SMTP Server Details.';
                    Visible = AdvancedSettingsVisible;
                    field(Authentication;Authentication)
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnValidate()
                        begin
                            EnableControls;
                        end;
                    }
                    field("SMTP Server";"SMTP Server")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the name of the SMTP server.';

                        trigger OnValidate()
                        begin
                            EnableControls;
                        end;
                    }
                    field("SMTP Server Port";"SMTP Server Port")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the port of the SMTP server. The default setting is 25.';
                    }
                    field("Secure Connection";"Secure Connection")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies if your SMTP mail server setup requires a secure connection that uses a cryptography or security protocol, such as secure socket layers (SSL). Clear the check box if you do not want to enable this security setting.';
                    }
                }
                group(Control26)
                {
                    InstructionalText = 'Enter the credentials for the account, which will be used for sending emails.';
                    Visible = MailSettingsVisible;
                    field(Email;"User ID")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnValidate()
                        begin
                            EnableControls;
                        end;
                    }
                    field(Password;Password)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Password';
                        ExtendedDatatype = Masked;

                        trigger OnValidate()
                        begin
                            EnableControls;
                        end;
                    }
                }
            }
            group(Control17)
            {
                Visible = FinalStepVisible;
                group(Control23)
                {
                    InstructionalText = 'To verify that the specified email setup works, choose Send Test Email.';
                }
                group("That's it!")
                {
                    Caption = 'That''s it!';
                    group(Control25)
                    {
                        InstructionalText = 'To enable email sending directly from documents, choose Finish.';
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
                    case Step of
                      Step::Settings:
                        if (Authentication = Authentication::Basic) and (("User ID" = '') or (Password = '')) then
                          Error(EmailPasswordMissingErr);
                    end;

                    NextStep(false);
                end;
            }
            action(ActionSendTestEmail)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Send Test Email';
                Enabled = FinishActionEnabled;
                Image = Email;
                InFooterBar = true;

                trigger OnAction()
                begin
                    SendTestEmailAction;
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
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        CompanyInformation: Record "Company Information";
    begin
        Init;
        if SMTPMailSetup.Get then begin
          TransferFields(SMTPMailSetup);
          EmailProvider := Emailprovider::Other;
        end else begin
          SMTPMail.ApplyOffice365Smtp(Rec);
          EmailProvider := Emailprovider::"Office 365";
          if CompanyInformation.Get then
            "User ID" := CompanyInformation."E-Mail";
        end;
        Insert;
        if SMTPMailSetup.HasPassword then
          Password := DummyPasswordTxt;

        Step := Step::Start;
        EnableControls;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::OK then
          if AssistedSetup.GetStatus(Page::"Email Setup Wizard") = AssistedSetup.Status::"Not Completed" then
            if not Confirm(NAVNotSetUpQst,false) then
              Error('');
    end;

    var
        AssistedSetup: Record "Assisted Setup";
        MediaRepositoryStandard: Record "Media Repository";
        MediaRepositoryDone: Record "Media Repository";
        SMTPMail: Codeunit "SMTP Mail";
        Step: Option Start,Provider,Settings,Finish;
        TopBannerVisible: Boolean;
        FirstStepVisible: Boolean;
        ProviderStepVisible: Boolean;
        SettingsStepVisible: Boolean;
        AdvancedSettingsVisible: Boolean;
        MailSettingsVisible: Boolean;
        FinalStepVisible: Boolean;
        EmailProvider: Option "Office 365",Other;
        FinishActionEnabled: Boolean;
        BackActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        NAVNotSetUpQst: label 'Email has not been set up.\\Are you sure you want to exit?';
        EmailPasswordMissingErr: label 'Please enter a valid email address and password.';
        Password: Text[250];
        DummyPasswordTxt: label '***', Locked=true;

    local procedure EnableControls()
    begin
        ResetControls;

        case Step of
          Step::Start:
            ShowStartStep;
          Step::Provider:
            ShowProviderStep;
          Step::Settings:
            ShowSettingsStep;
          Step::Finish:
            ShowFinishStep;
        end;
    end;

    local procedure StoreSMTPSetup()
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
    begin
        if not SMTPMailSetup.Get then begin
          SMTPMailSetup.Init;
          SMTPMailSetup.Insert;
        end;

        SMTPMailSetup.TransferFields(Rec,false);
        if Password <> DummyPasswordTxt then
          SMTPMailSetup.SetPassword(Password);
        SMTPMailSetup.Modify(true);
        Commit;
    end;

    local procedure SendTestEmailAction()
    begin
        StoreSMTPSetup;
        Codeunit.Run(Codeunit::"SMTP Test Mail");
    end;

    local procedure FinishAction()
    begin
        StoreSMTPSetup;
        AssistedSetup.SetStatus(Page::"Email Setup Wizard",AssistedSetup.Status::Completed);
        CurrPage.Close;
    end;

    local procedure NextStep(Backwards: Boolean)
    begin
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

    local procedure ShowProviderStep()
    begin
        ProviderStepVisible := true;
    end;

    local procedure ShowSettingsStep()
    begin
        SettingsStepVisible := true;
        AdvancedSettingsVisible := EmailProvider = Emailprovider::Other;
        MailSettingsVisible := Authentication = Authentication::Basic;
    end;

    local procedure ShowFinishStep()
    begin
        FinalStepVisible := true;
        NextActionEnabled := false;
    end;

    local procedure ResetControls()
    begin
        FinishActionEnabled := "SMTP Server" <> '';
        if (Authentication = Authentication::Basic) and (("User ID" = '') or (Password = '')) then
          FinishActionEnabled := false;
        BackActionEnabled := true;
        NextActionEnabled := true;

        FirstStepVisible := false;
        ProviderStepVisible := false;
        SettingsStepVisible := false;
        FinalStepVisible := false;
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png',Format(CurrentClientType)) and
           MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png',Format(CurrentClientType))
        then
          TopBannerVisible := MediaRepositoryDone.Image.Hasvalue;
    end;
}

