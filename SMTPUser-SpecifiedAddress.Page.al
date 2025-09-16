#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 410 "SMTP User-Specified Address"
{
    Caption = 'Specify an Email Address';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(Control4)
            {
                field(EmailAddressField;EmailAddress)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Email Address';
                    ToolTip = 'Specifies the email address.';

                    trigger OnValidate()
                    var
                        SMTPMail: Codeunit "SMTP Mail";
                    begin
                        SMTPMail.CheckValidEmailAddresses(EmailAddress);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        EmailAddress: Text;


    procedure GetEmailAddress(): Text
    begin
        exit(EmailAddress);
    end;


    procedure SetEmailAddress(Address: Text)
    begin
        EmailAddress := Address;
    end;
}

