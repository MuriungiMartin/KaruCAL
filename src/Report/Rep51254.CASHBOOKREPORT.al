#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51254 "CASH BOOK REPORT"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CASH BOOK REPORT.rdlc';

    dataset
    {
        dataitem(UnknownTable61157;UnknownTable61157)
        {
            RequestFilterFields = "Doc No","Customer No",Date,"Received By","Paying Bank Account",Department;
            column(ReportForNavId_3303; 3303)
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
            column(Cash_Sale_Header_Date;Date)
            {
            }
            column(Cash_Sale_Header__Customer_Name_;"Customer Name")
            {
            }
            column(Cash_Sale_Header__Customer_No_;"Customer No")
            {
            }
            column(Cash_Sale_Header_Amount;Amount)
            {
            }
            column(Cash_Sale_Header__Paying_Bank_Account_;"Paying Bank Account")
            {
            }
            column(Cash_Sale_Header__Cheque_No_;"Cheque No")
            {
            }
            column(Cash_Sale_Header__Doc_No_;"Doc No")
            {
            }
            column(Cash_Sale_Header_Amount_Control1000000057;Amount)
            {
            }
            column(CASH_RECEIPT_REPORTCaption;CASH_RECEIPT_REPORTCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CASHCaption;CASHCaptionLbl)
            {
            }
            column(DATECaption;DATECaptionLbl)
            {
            }
            column(DETAILSCaption;DETAILSCaptionLbl)
            {
            }
            column(ADM_NOCaption;ADM_NOCaptionLbl)
            {
            }
            column(CHEQUE_NOCaption;CHEQUE_NOCaptionLbl)
            {
            }
            column(RECEIPT_NOCaption;RECEIPT_NOCaptionLbl)
            {
            }
            column(CUSTOMER_BANK_A_CCaption;CUSTOMER_BANK_A_CCaptionLbl)
            {
            }
            column(TOTALCaption;TOTALCaptionLbl)
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
        CASH_RECEIPT_REPORTCaptionLbl: label 'CASH RECEIPT REPORT';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CASHCaptionLbl: label 'CASH';
        DATECaptionLbl: label 'DATE';
        DETAILSCaptionLbl: label 'DETAILS';
        ADM_NOCaptionLbl: label 'ADM/NO';
        CHEQUE_NOCaptionLbl: label 'CHEQUE NO';
        RECEIPT_NOCaptionLbl: label 'RECEIPT NO';
        CUSTOMER_BANK_A_CCaptionLbl: label 'CUSTOMER BANK A/C';
        TOTALCaptionLbl: label 'TOTAL';
}

