#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51197 "Cheques Printed Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cheques Printed Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting(No) where("Cheque Raised"=const(Yes));
            RequestFilterFields = No,"Payment Date","Cheque Raised Date";
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
            column(Payments__Pay_Mode_;"Pay Mode")
            {
            }
            column(Payments__Cheque_No_;"Cheque No")
            {
            }
            column(Payments__Payment_Date_;"Payment Date")
            {
            }
            column(Payments__Account_Name_;"Account Name")
            {
            }
            column(Payments__Cheque_Raised_Date_;"Cheque Raised Date")
            {
            }
            column(Payments__Cheque_Raised_Time_;"Cheque Raised Time")
            {
            }
            column(Payments__Cheque_Raised_By_;"Cheque Raised By")
            {
            }
            column(Payments__Net_Amount_;"Net Amount")
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
            column(Payments__Pay_Mode_Caption;FieldCaption("Pay Mode"))
            {
            }
            column(Payments__Cheque_No_Caption;FieldCaption("Cheque No"))
            {
            }
            column(Payments__Payment_Date_Caption;FieldCaption("Payment Date"))
            {
            }
            column(Payments__Account_Name_Caption;FieldCaption("Account Name"))
            {
            }
            column(Payments__Cheque_Raised_Date_Caption;FieldCaption("Cheque Raised Date"))
            {
            }
            column(Payments__Cheque_Raised_Time_Caption;FieldCaption("Cheque Raised Time"))
            {
            }
            column(Payments__Cheque_Raised_By_Caption;FieldCaption("Cheque Raised By"))
            {
            }
            column(Payments__Net_Amount_Caption;FieldCaption("Net Amount"))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(No);
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        PaymentsCaptionLbl: label 'Payments';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

