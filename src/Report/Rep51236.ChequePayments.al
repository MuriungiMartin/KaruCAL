#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51236 "Cheque Payments"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cheque Payments.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting(No) where("Pay Mode"=const(CHEQUE),Posted=const(Yes));
            RequestFilterFields = Date,"IW No",OPN;
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
            column(Payments_No;No)
            {
            }
            column(Payments_Date;Date)
            {
            }
            column(Payments__Cheque_No_;"Cheque No")
            {
            }
            column(Payments__Payment_Date_;"Payment Date")
            {
            }
            column(Payments_Payments__Posted_By_;"FIN-Payments"."Posted By")
            {
            }
            column(Payments__Account_No__;"Account No.")
            {
            }
            column(Payments_Amount;Amount)
            {
            }
            column(Payments__IW_No_;"IW No")
            {
            }
            column(Payments__Bank_Account_No_;"Bank Account No")
            {
            }
            column(Payments_OPN;OPN)
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
            column(Payments_NoCaption;Payments_NoCaptionLbl)
            {
            }
            column(Payments_DateCaption;FieldCaption(Date))
            {
            }
            column(Payments__Cheque_No_Caption;FieldCaption("Cheque No"))
            {
            }
            column(Payments__Payment_Date_Caption;FieldCaption("Payment Date"))
            {
            }
            column(Posted_ByCaption;Posted_ByCaptionLbl)
            {
            }
            column(Payments__Account_No__Caption;FieldCaption("Account No."))
            {
            }
            column(Payments_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Paying_Bank_Ac_NoCaption;Paying_Bank_Ac_NoCaptionLbl)
            {
            }
            column(Warrant_NoCaption;Warrant_NoCaptionLbl)
            {
            }
            column(Total_AmountCaption;Total_AmountCaptionLbl)
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
        Payments_NoCaptionLbl: label 'NO';
        Posted_ByCaptionLbl: label 'Posted By';
        Paying_Bank_Ac_NoCaptionLbl: label 'Paying Bank Ac/No';
        Warrant_NoCaptionLbl: label 'Warrant No';
        Total_AmountCaptionLbl: label 'Total Amount';
}

