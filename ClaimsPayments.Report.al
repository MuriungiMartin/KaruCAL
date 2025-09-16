#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51249 "Claims Payments"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Claims Payments.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting(No);
            PrintOnlyIfDetail = false;
            RequestFilterFields = No,Date,"Pay Mode","Account No.";
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
            column(Payments__Pay_Mode_;"Pay Mode")
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
            column(Payments__Posted_By_;"Posted By")
            {
            }
            column(Payments_Amount_Control1000000018;Amount)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Claims_Payments_RegisterCaption;Claims_Payments_RegisterCaptionLbl)
            {
            }
            column(Payments_NoCaption;FieldCaption(No))
            {
            }
            column(Payments_DateCaption;FieldCaption(Date))
            {
            }
            column(Payments__Pay_Mode_Caption;FieldCaption("Pay Mode"))
            {
            }
            column(PF_NOCaption;PF_NOCaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Payments_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Payments__Posted_By_Caption;FieldCaption("Posted By"))
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }

            trigger OnPreDataItem()
            begin
                   "FIN-Payments".SetRange("FIN-Payments"."Payment Type","FIN-Payments"."payment type"::Claims);
                   "FIN-Payments".SetRange("FIN-Payments".Posted,true);
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
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Claims_Payments_RegisterCaptionLbl: label 'Claims Payments Register';
        PF_NOCaptionLbl: label 'PF NO';
        NameCaptionLbl: label 'Name';
        TotalCaptionLbl: label 'Total';
}

