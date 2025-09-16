#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51718 "Random Four Digit Code"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Random Four Digit Code.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(Customer__No__;"No.")
            {
            }
            column(Customer__No__Caption;FieldCaption("No."))
            {
            }

            trigger OnAfterGetRecord()
            begin
                smsCode:=Format(Random(9999));

                if StrLen(smsCode)=1 then
                  smsCode:='000'+smsCode
                else if StrLen(smsCode)=2 then
                  smsCode:='00'+smsCode
                else if StrLen(smsCode)=3 then
                  smsCode:='0'+smsCode;

                Customer.sms_Password:=smsCode;
                Customer.Modify;
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
        smsCode: Code[4];
}

