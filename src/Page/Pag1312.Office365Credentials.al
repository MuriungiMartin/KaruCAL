#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1312 "Office 365 Credentials"
{
    Caption = 'Office 365 Credentials';
    PageType = StandardDialog;
    Permissions = TableData "Office Admin. Credentials"=rimd;
    SourceTable = "Office Admin. Credentials";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control7)
            {
                InstructionalText = 'Provide your Office 365 email address and password:';
                field(Email;Email)
                {
                    ApplicationArea = Basic,Suite;
                    ExtendedDatatype = EMail;
                    ToolTip = 'Specifies the email address that is associated with the Office 365 account.';
                }
                field(Password;Password)
                {
                    ApplicationArea = Basic,Suite;
                    ExtendedDatatype = Masked;
                    ToolTip = 'Specifies the password that is associated with the Office 365 account.';
                }
                field(StatusText;StatusText)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                    Style = Attention;
                    StyleExpr = true;
                }
                field(WhySignInIsNeededLbl;WhySignInIsNeededLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        Message(WhySignInIsNeededDescriptionMsg);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        StatusText := GetLastErrorText;
    end;

    var
        StatusText: Text;
        WhySignInIsNeededLbl: label 'Why do I have to sign in to Office 365 now?';
        WhySignInIsNeededDescriptionMsg: label 'To set up the Business Inbox in Outlook, we need your permission to install two add-ins in Office 365.';
}

