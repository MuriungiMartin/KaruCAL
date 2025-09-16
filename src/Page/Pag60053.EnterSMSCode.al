#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60053 "Enter SMS Code"
{
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(SMSCode;SMSCode)
            {
                ApplicationArea = Basic;
                Caption = 'Enter the code you received by SMS';
            }
        }
    }

    actions
    {
    }

    var
        SMSCode: Text;


    procedure GetSMSCode(): Text
    begin
        exit(SMSCode);
    end;
}

