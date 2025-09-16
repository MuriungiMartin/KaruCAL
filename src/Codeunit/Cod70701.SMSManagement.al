#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 70701 "SMS Management"
{

    trigger OnRun()
    begin
    end;


    procedure UpdateMessageStatus(SmsCode: Code[20];RecepientNo: Code[20];PhoneNo: Code[20];MessageDelivered: Text[10];DeliveryStatusMessage: Text[100]) UpdateStatus: Text[20]
    var
        BulkSMSRecipient: Record UnknownRecord70702;
    begin
        BulkSMSRecipient.Reset;
        BulkSMSRecipient.SetRange("SMS Code",SmsCode);
        BulkSMSRecipient.SetRange("Recipient No.",RecepientNo);
        BulkSMSRecipient.SetRange(Phone,PhoneNo);
        if BulkSMSRecipient.Find('-') then begin
          if MessageDelivered = 'TRUE' then
            BulkSMSRecipient.Delivered:=true
          else  BulkSMSRecipient.Delivered:=false;
          BulkSMSRecipient."Delivery Status Message":=DeliveryStatusMessage;
          BulkSMSRecipient.Modify;
          UpdateStatus:='SUCCESS';
          end else UpdateStatus:='FAIL';
    end;


    procedure UpdateBatchStatus(SmsCode: Code[20];CreditBalance: Decimal) ReturnMessage: Text[100]
    var
        SMSHeader: Record UnknownRecord70701;
    begin
        ReturnMessage:='FAIL';
        SMSHeader.Reset;
        SMSHeader.SetRange("SMS Code",SmsCode);
        if SMSHeader.Find('-') then begin
            SMSHeader.Status:=SMSHeader.Status::Active;
          SMSHeader."Credit Balance":=CreditBalance;
          SMSHeader.Modify;
          ReturnMessage:='SUCCESS';
          end;
    end;
}

