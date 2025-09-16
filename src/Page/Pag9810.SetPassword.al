#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9810 "Set Password"
{
    Caption = 'Set Password';
    DataCaptionExpression = "Full Name";
    PageType = StandardDialog;
    SourceTable = User;

    layout
    {
        area(content)
        {
            field("<SetPassword>";SetPassword)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Password';
                ExtendedDatatype = Masked;

                trigger OnValidate()
                begin
                    if not IdentityManagement.ValidatePasswordStrength(SetPassword) then
                      Error(Text002);
                end;
            }
            field("<ConfirmPassword>";ConfirmPassword)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Confirm Password';
                ExtendedDatatype = Masked;
                ToolTip = 'Specifies the password repeated.';

                trigger OnValidate()
                begin
                    if SetPassword <> ConfirmPassword then
                      Error(Text001);
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::OK then begin
          if SetPassword <> ConfirmPassword then
            Error(Text001);
          if IdentityManagement.ValidatePasswordStrength(SetPassword) then begin
            SetUserPassword("User Security ID",SetPassword);
          end else
            Error(Text002);
        end
    end;

    var
        Text001: label 'The passwords that you entered do not match.';
        Text002: label 'The password that you entered does not meet the minimum requirements. It must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.';
        IdentityManagement: Codeunit "Identity Management";
        [InDataSet]
        SetPassword: Text[250];
        [InDataSet]
        ConfirmPassword: Text[250];
}

