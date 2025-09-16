#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9552 "Document Service Acc. Pwd."
{
    Caption = 'Document Service Acc. Pwd.';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                InstructionalText = 'Enter the password for your online document storage account.';
                field(PasswordField;PasswordField)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Set Password';
                    ExtendedDatatype = Masked;
                    ShowCaption = true;
                    ToolTip = 'Specifies the password for your online storage account.';
                }
                field(ConfirmPasswordField;ConfirmPasswordField)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Confirm Password';
                    ExtendedDatatype = Masked;
                    ShowCaption = true;
                    ToolTip = 'Specifies the password repeated.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::OK then
          if PasswordField <> ConfirmPasswordField then
            Error(PasswordValidationErr);
    end;

    var
        PasswordField: Text[80];
        ConfirmPasswordField: Text[80];
        PasswordValidationErr: label 'The passwords that you entered do not match.';


    procedure GetData(): Text[80]
    begin
        exit(PasswordField);
    end;
}

