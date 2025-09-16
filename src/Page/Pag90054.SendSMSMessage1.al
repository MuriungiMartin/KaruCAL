#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90054 "Send SMS Message1"
{
    PageType = NavigatePage;

    layout
    {
        area(content)
        {
            field(MobilePhoneNo;MobilePhoneNo)
            {
                ApplicationArea = Basic;
                Caption = 'Mobile Phone No.';
            }
            field(MessageText;MessageText)
            {
                ApplicationArea = Basic;
                Caption = 'Message';
                MultiLine = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Setup)
            {
                ApplicationArea = Basic;
                Image = XMLSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page BulkSMSSetup;
            }
            action("Send SMS")
            {
                ApplicationArea = Basic;
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if (MobilePhoneNo <> '') and (MessageText <> '') then
                      if not SMSWebService.SendSMS(MobilePhoneNo,MessageText) then;
                end;
            }
        }
    }

    var
        MobilePhoneNo: Text;
        MessageText: Text;
        SMSWebService: Codeunit "SMS Web Service1";


    procedure SetPhoneNo(value: Text)
    begin
        MobilePhoneNo := value;
    end;
}

