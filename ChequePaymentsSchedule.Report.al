#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51233 "Cheque Payments Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cheque Payments Schedule.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting(No) where("Pay Mode"=const(CHEQUE),Posted=const(Yes));
            RequestFilterFields = Date,"IW No";
            column(ReportForNavId_3752; 3752)
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
            column(Payments_Date;Date)
            {
            }
            column(Payments__Cheque_No_;"Cheque No")
            {
            }
            column(Payments_Payments__Account_Name_;"FIN-Payments"."Account Name")
            {
            }
            column(Payments_Amount;Amount)
            {
            }
            column(Payments__Paying_Bank_Account_;"Paying Bank Account")
            {
            }
            column(Payments_Amount_Control1102760004;Amount)
            {
            }
            column(Cheque_PaymentsCaption;Cheque_PaymentsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Payments_DateCaption;FieldCaption(Date))
            {
            }
            column(Payments__Cheque_No_Caption;FieldCaption("Cheque No"))
            {
            }
            column(Payments_Payments__Account_Name_Caption;FieldCaption("Account Name"))
            {
            }
            column(Payments_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Payments__Paying_Bank_Account_Caption;FieldCaption("Paying Bank Account"))
            {
            }
            column(Total_AmountCaption;Total_AmountCaptionLbl)
            {
            }
            column(Payments_No;No)
            {
            }

            trigger OnPreDataItem()
            begin
                      "FIN-Payments".SetRange("FIN-Payments"."Pay Mode",'cheque');
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
        Cheque_PaymentsCaptionLbl: label 'Cheque Payments';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Total_AmountCaptionLbl: label 'Total Amount';
}

