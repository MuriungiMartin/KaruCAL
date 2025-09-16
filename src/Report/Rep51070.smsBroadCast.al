#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51070 "sms_BroadCast"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/sms_BroadCast.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.") where("Phone No."=filter(<>''));
            RequestFilterFields = "No.","BroadCast Filter",Status,"Programme Filter","Stage Filter","Semester Filter";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(Num;Num)
            {
            }
            column(SMS_BROADCASTCaption;SMS_BROADCASTCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption;FieldCaption("No."))
            {
            }
            column(Customer_NameCaption;FieldCaption(Name))
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                  LastID:=LastID+1000;
                  if SendSms=true then begin
                  sms_Master.Init;
                  sms_Master.sms_ID:=LastID;
                  sms_Master.Msg:=msg;
                  sms_Master.Receiver:=Customer."Phone No.";
                  sms_Master.Operator:='BroadCast';
                  sms_Master.sms_Type:=Customer.GetFilter(Customer."BroadCast Filter");
                  sms_Master.Sender:='Maseno';
                  sms_Master.Code:=Customer."No.";
                  sms_Master.sms_Status:='Send';
                  sms_Master.Insert;
                end;
                  Num:=Num+1;
            end;

            trigger OnPreDataItem()
            begin
                   if sms_Broad.Get(Customer.GetFilter(Customer."BroadCast Filter")) then
                   msg:=sms_Broad.Message;

                   if msg='' then
                    Error('Please Note that you can not send a blank message');

                   if sms_Master.FindLast() then
                   LastID:=sms_Master.sms_ID;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        sms_Master: Record UnknownRecord61016;
        sms_Broad: Record UnknownRecord61018;
        msg: Text[200];
        Num: Integer;
        SendSms: Boolean;
        LastID: Integer;
        SMS_BROADCASTCaptionLbl: label 'SMS BROADCAST';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        EmptyStringCaptionLbl: label '#';
}

