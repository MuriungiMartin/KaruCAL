#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1612 "Office Admin. Credentials"
{
    Caption = 'Office Admin. Credentials';
    DeleteAllowed = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    MultipleNewLines = false;
    PageType = NavigatePage;
    Permissions = TableData "Office Admin. Credentials"=rimd;
    SaveValues = true;
    SourceTable = "Office Admin. Credentials";

    layout
    {
        area(content)
        {
            group(Question)
            {
                Caption = '';
                Visible = QuestionVisible;
                field(UseO365;EmailHostedInO365)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Are you using an Office 365 mailbox?';
                    DrillDown = true;
                    ToolTip = 'Specifies whether you use Office 365 for your email.';
                }
            }
            group(O365Credential)
            {
                Caption = '';
                Visible = O365CredentialVisible;
                field(O365Email;Email)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Office 365 admin email address';
                    ExtendedDatatype = EMail;
                    NotBlank = true;
                    ToolTip = 'Specifies the email address of a user account that has permission to manage Office add-ins. For example, with Office 365, this account has the administrator role.';
                }
                field(O365Password;Password)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Office 365 admin password';
                    NotBlank = true;
                    ToolTip = 'Specifies the password of a user account that has permission to manage Office add-ins.';
                }
            }
            group(OnPremCredential)
            {
                Caption = '';
                Visible = OnPremCredentialVisible;
                field(OnPremUsername;Email)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Exchange admin username';
                    ExtendedDatatype = EMail;
                    NotBlank = true;
                    ToolTip = 'Specifies the domain username of a user account that has permission to deploy Exchange. For example, with Exchange, this account could have the administrator role.';
                }
                field(OnPremPassword;Password)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Exchange admin password';
                    NotBlank = true;
                    ToolTip = 'Specifies the password of a user account that has permission to manage Exchange add-ins.';
                }
                field(Endpoint;Endpoint)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Exchange PowerShell Endpoint';
                    ToolTip = 'Specifies the Exchange remote PowerShell endpoint for your Exchange server.';
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
                begin
                    if (Email = '') or (Password = '') or (EmailHostedInO365 and (Endpoint = '')) then
                      Error(MissingCredentialErr);

                    if not Insert(true) then
                      Modify(true);

                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ShowQuestion;
        EmailHostedInO365 := true;
    end;

    var
        Step: Option Question,O365Credential,OnPremCredential;
        EmailHostedInO365: Boolean;
        QuestionVisible: Boolean;
        O365CredentialVisible: Boolean;
        OnPremCredentialVisible: Boolean;
        BackEnabled: Boolean;
        NextEnabled: Boolean;
        FinishEnabled: Boolean;
        MissingCredentialErr: label 'You must specify both an email address and a password.';

    local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then
          Step := Step - 1
        else
          Step := Step + 1;

        case Step of
          Step::Question:
            ShowQuestion;
          Step::O365Credential:
            ShowO365Credential(Backwards);
          Step::OnPremCredential:
            ShowOnPremCredential;
        end;

        CurrPage.Update(true);
    end;

    local procedure ShowQuestion()
    begin
        ResetControls;

        BackEnabled := false;
        QuestionVisible := true;
    end;

    local procedure ShowO365Credential(Backwards: Boolean)
    begin
        ResetControls;

        // Skip to the next window if we're not using O365.
        if not EmailHostedInO365 then begin
          NextStep(Backwards);
          exit;
        end;

        FinishEnabled := true;
        NextEnabled := false;
        O365CredentialVisible := true;
    end;

    local procedure ShowOnPremCredential()
    begin
        ResetControls;

        FinishEnabled := true;
        NextEnabled := false;
        OnPremCredentialVisible := true;
    end;

    local procedure ResetControls()
    begin
        NextEnabled := true;
        BackEnabled := true;
        FinishEnabled := false;

        QuestionVisible := false;
        O365CredentialVisible := false;
        OnPremCredentialVisible := false;
    end;
}

