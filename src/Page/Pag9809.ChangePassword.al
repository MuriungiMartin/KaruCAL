#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9809 "Change Password"
{
    ApplicationArea = Basic;
    Caption = 'Change Password';
    DataCaptionExpression = "Full Name";
    PageType = StandardDialog;
    SourceTable = User;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field("<OldPassword>";OldPassword)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Old Password';
                ExtendedDatatype = Masked;
                ToolTip = 'Specifies the current password, before the user defines a new one.';
            }
            field("<SetPassword>";SetPassword)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Password';
                ExtendedDatatype = Masked;
                ToolTip = 'Specifies the password.';
            }
            field("<ConfirmPassword>";ConfirmPassword)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Confirm Password';
                ExtendedDatatype = Masked;
                ToolTip = 'Specifies the password repeated.';
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        FilterGroup(99);
        SetFilter("User Security ID",UserSecurityId);
        FindFirst;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::OK then begin
          if SetPassword <> ConfirmPassword then
            Error(Text001);
          if IdentityManagement.ValidatePasswordStrength(SetPassword) then begin
            ChangeUserPassword(OldPassword,SetPassword);
          end else
            Error(Text002);
        end;
    end;

    var
        Text001: label 'The passwords that you entered do not match.';
        Text002: label 'The password that you entered does not meet the minimum requirements. It must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.';
        IdentityManagement: Codeunit "Identity Management";
        SetPassword: Text[250];
        ConfirmPassword: Text[250];
        OldPassword: Text[250];
}

