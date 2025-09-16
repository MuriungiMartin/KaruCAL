#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51671 "VAT Report New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VAT Report New.rdlc';

    dataset
    {
        dataitem(UnknownTable61688;UnknownTable61688)
        {
            DataItemTableView = where("Total VAT Amount"=filter(<>0));
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
            column(Payments_Header__Total_VAT_Amount_;"Total VAT Amount")
            {
            }
            column(Payments_Header__Total_Net_Amount_;"Total Net Amount")
            {
            }
            column(Payments_Header__Payments_Header___Total_Payment_Amount_;"FIN-Payments Header"."Total Payment Amount")
            {
            }
            column(Payments_Header__Cheque_No__;"Cheque No.")
            {
            }
            column(NetAmount;NetAmount)
            {
            }
            column(Payments_Header__Payments_Header___Total_VAT_Amount_;"FIN-Payments Header"."Total VAT Amount")
            {
            }
            column(Payments_Header__Payments_Header___Total_Payment_Amount__Control1102755016;"FIN-Payments Header"."Total Payment Amount")
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
            column(Total_VAT_AmountCaption;Total_VAT_AmountCaptionLbl)
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

            trigger OnAfterGetRecord()
            begin
                NetAmount:="FIN-Payments Header"."Total Payment Amount"-"FIN-Payments Header"."Total VAT Amount";
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
        NetAmount: Decimal;
        Payments_Header2CaptionLbl: label 'Payments Header2';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Total_VAT_AmountCaptionLbl: label 'Total VAT Amount';
        Total_Gross_AmountCaptionLbl: label 'Total Gross Amount';
}

