#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9815 "Std. Password Dialog"
{
    Caption = 'Set Password';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(SetPassword;SetPassword)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Password';
                ExtendedDatatype = Masked;
                ToolTip = 'Specifies the password for this task. The password must consist of 8 or more characters, at least one uppercase letter, one lowercase letter, and one number.';

                trigger OnValidate()
                begin
                    if ValidatePassword and not IdentityManagement.ValidatePasswordStrength(SetPassword) then
                      Error(PasswordTooSimpleErr);
                end;
            }
            field(ConfirmPassword;ConfirmPassword)
            {
                ApplicationArea = All;
                Caption = 'Confirm Password';
                ExtendedDatatype = Masked;
                ToolTip = 'Specifies the password repeated.';
                Visible = RequiresPasswordConfirmation;

                trigger OnValidate()
                begin
                    if RequiresPasswordConfirmation and (SetPassword <> ConfirmPassword) then
                      Error(PasswordMismatchErr);
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        ValidatePassword := true;
        RequiresPasswordConfirmation := true;
    end;

    trigger OnOpenPage()
    begin
        ValidPassword := false;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        ValidPassword := false;
        if CloseAction = Action::OK then begin
          if RequiresPasswordConfirmation and (SetPassword <> ConfirmPassword) then
            Error(PasswordMismatchErr);
          if EnableBlankPasswordState and (SetPassword = '') then begin
            if not Confirm(ConfirmBlankPasswordQst) then
              Error(PasswordTooSimpleErr);
          end else begin
            if ValidatePassword and not IdentityManagement.ValidatePasswordStrength(SetPassword) then
              Error(PasswordTooSimpleErr);
          end;
          ValidPassword := true;
        end
    end;

    var
        PasswordMismatchErr: label 'The specified passwords are not the same.';
        PasswordTooSimpleErr: label 'The specified password does not meet the requirements. It must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.';
        PasswordNotValidatedErr: label 'The password did not validate correctly, or it was not accepted.';
        ConfirmBlankPasswordQst: label 'Do you want to close the dialog box with an empty password?';
        IdentityManagement: Codeunit "Identity Management";
        [InDataSet]
        SetPassword: Text[250];
        [InDataSet]
        ConfirmPassword: Text[250];
        ValidPassword: Boolean;
        EnableBlankPasswordState: Boolean;
        ValidatePassword: Boolean;
        GetPasswordCaptionTxt: label 'Enter Password';
        RequiresPasswordConfirmation: Boolean;


    procedure GetPasswordValue(): Text
    begin
        if ValidPassword = true then
          exit(SetPassword);

        Error(PasswordNotValidatedErr);
    end;


    procedure EnableBlankPassword(enable: Boolean)
    begin
        EnableBlankPasswordState := enable;
    end;


    procedure EnableGetPasswordMode(NewValidatePassword: Boolean)
    begin
        ValidatePassword := NewValidatePassword;
        CurrPage.Caption := GetPasswordCaptionTxt;
    end;


    procedure DisablePasswordConfirmation()
    begin
        RequiresPasswordConfirmation := false;
    end;
}

