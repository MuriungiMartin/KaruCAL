#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51733 Payments
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payments.rdlc';

    dataset
    {
        dataitem(UnknownTable61688;UnknownTable61688)
        {
            RequestFilterFields = "No.",Date;
            column(ReportForNavId_6437; 6437)
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
            column(Payments_Header__No__;"No.")
            {
            }
            column(Payments_Header_Date;Date)
            {
            }
            column(Payments_Header_Payee;Payee)
            {
            }
            column(Payments_Header__Total_PAYE_Amount_;"Total PAYE Amount")
            {
            }
            column(Payments_Header__Total_Net_Amount_;"Total Net Amount")
            {
            }
            column(GrossAmount;GrossAmount)
            {
            }
            column(Payments_Header__Cheque_No__;"Cheque No.")
            {
            }
            column(Payments_Header__Total_Net_Amount__Control1102755010;"Total Net Amount")
            {
            }
            column(Payments_Header__Total_PAYE_Amount__Control1102755013;"Total PAYE Amount")
            {
            }
            column(GrossAmount_Control1102755016;GrossAmount)
            {
            }
            column(Payments_Header2Caption;Payments_Header2CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Payments_Header__No__Caption;FieldCaption("No."))
            {
            }
            column(Payments_Header_DateCaption;FieldCaption(Date))
            {
            }
            column(Payments_Header_PayeeCaption;FieldCaption(Payee))
            {
            }
            column(Payments_Header__Total_PAYE_Amount_Caption;FieldCaption("Total PAYE Amount"))
            {
            }
            column(Payments_Header__Total_Net_Amount_Caption;FieldCaption("Total Net Amount"))
            {
            }
            column(Total_Gross_AmountCaption;Total_Gross_AmountCaptionLbl)
            {
            }
            column(Payments_Header__Cheque_No__Caption;FieldCaption("Cheque No."))
            {
            }
            column(status;"FIN-Payments Header".Status)
            {
            }

            trigger OnAfterGetRecord()
            begin
                GrossAmount:="FIN-Payments Header"."Total Net Amount"+"FIN-Payments Header"."Total PAYE Amount";
                CurrReport.CreateTotals(GrossAmount);
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
        Vend: Record Vendor;
        GrossAmount: Decimal;
        Payments_Header2CaptionLbl: label 'Payments Header2';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Total_Gross_AmountCaptionLbl: label 'Total Gross Amount';
}

