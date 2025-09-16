#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51734 "PAYE Payments"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PAYE Payments.rdlc';

    dataset
    {
        dataitem(UnknownTable61688;UnknownTable61688)
        {
            DataItemTableView = where("Total PAYE Amount"=filter(<>0),Status=const(Posted));
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
            column(Payments_Header__Cheque_No__;"Cheque No.")
            {
            }
            column(GrossAmount;GrossAmount)
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
            column(Payments_Header__Cheque_No__Caption;FieldCaption("Cheque No."))
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
}

