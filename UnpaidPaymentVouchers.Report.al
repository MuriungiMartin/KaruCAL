#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51654 "Unpaid Payment Vouchers"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Unpaid Payment Vouchers.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting(No) where(Posted=const(No),"Payment Type"=const(Normal));
            RequestFilterFields = No,Amount;
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
            column(Payments__Account_No__;"Account No.")
            {
            }
            column(Payments__Account_Name_;"Account Name")
            {
            }
            column(Payments_Amount;Amount)
            {
            }
            column(Payments_OPN;OPN)
            {
            }
            column(Payments_Date;Date)
            {
            }
            column(Payments_Amount_Control1102760000;Amount)
            {
            }
            column(PaymentsCaption;PaymentsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Payments_NoCaption;FieldCaption(No))
            {
            }
            column(Payments_DateCaption;FieldCaption(Date))
            {
            }
            column(Payments__Account_No__Caption;FieldCaption("Account No."))
            {
            }
            column(Payments__Account_Name_Caption;FieldCaption("Account Name"))
            {
            }
            column(Payments_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Payments_OPNCaption;FieldCaption(OPN))
            {
            }
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
        PaymentsCaptionLbl: label 'Payments';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

