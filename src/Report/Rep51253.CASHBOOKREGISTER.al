#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51253 "CASH BOOK REGISTER"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CASH BOOK REGISTER.rdlc';

    dataset
    {
        dataitem(UnknownTable61158;UnknownTable61158)
        {
            DataItemTableView = sorting("Line No",No);
            RequestFilterFields = No,"Code";
            column(ReportForNavId_7967; 7967)
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
            column(Cash_Sale_Line_Code;Code)
            {
            }
            column(Cash_Sale_Line_Description;Description)
            {
            }
            column(Cash_Sale_Line__Total_Amount_;"Total Amount")
            {
            }
            column(Cash_Sale_Line_Date;Date)
            {
            }
            column(Cust_name_;"Cust name")
            {
            }
            column(Cust_No_;"Cust No")
            {
            }
            column(CHQ;CHQ)
            {
            }
            column(Cash_Sale_Line__Total_Amount__Control1000000034;"Total Amount")
            {
            }
            column(CASH_BOOK_REGISTERCaption;CASH_BOOK_REGISTERCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CODECaption;CODECaptionLbl)
            {
            }
            column(DESCRIPTIONCaption;DESCRIPTIONCaptionLbl)
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
            column(TOTALCaption;TOTALCaptionLbl)
            {
            }
            column(Cash_Sale_Line_Line_No;"Line No")
            {
            }
            column(Cash_Sale_Line_No;No)
            {
            }

            trigger OnAfterGetRecord()
            begin
                    "Cash Sale Header".Reset;
                    "Cash Sale Header".SetRange("Cash Sale Header"."Doc No","FIN-Cash Sale Line".No);
                    if "Cash Sale Header".Find('-') then
                    begin
                      Date:="Cash Sale Header".Date;
                      "Cust name":="Cash Sale Header"."Customer Name";
                      "Cust No":="Cash Sale Header"."Customer No";
                      CHQ:="Cash Sale Header"."Cheque No";
                    end;
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
        "Cash Sale Header": Record UnknownRecord61157;
        date: Date;
        "Cust name": Text[30];
        "Cust No": Code[20];
        CHQ: Code[10];
        CASH_BOOK_REGISTERCaptionLbl: label 'CASH BOOK REGISTER';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CODECaptionLbl: label 'CODE';
        DESCRIPTIONCaptionLbl: label 'DESCRIPTION';
        CASHCaptionLbl: label 'CASH';
        DATECaptionLbl: label 'DATE';
        DETAILSCaptionLbl: label 'DETAILS';
        ADM_NOCaptionLbl: label 'ADM/NO';
        CHEQUE_NOCaptionLbl: label 'CHEQUE NO';
        TOTALCaptionLbl: label 'TOTAL';
}

