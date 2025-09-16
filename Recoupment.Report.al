#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51317 Recoupment
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Recoupment.rdlc';

    dataset
    {
        dataitem(UnknownTable61180;UnknownTable61180)
        {
            DataItemTableView = sorting(No) where("Transaction Type"=const(Recoupment),Posted=const(Yes));
            RequestFilterFields = No,"Transaction Type";
            column(ReportForNavId_8573; 8573)
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
            column(Office_Transactions_No;No)
            {
            }
            column(Office_Transactions_Date;Date)
            {
            }
            column(Office_Transactions_Description;Description)
            {
            }
            column(Office_Transactions_Amount;Amount)
            {
            }
            column(Office_Transactions__Office_Transactions___From_Account_No_;"FIN-Office Transactions"."From Account No")
            {
            }
            column(Office_Transactions__Office_Transactions___To_Account_No_;"FIN-Office Transactions"."To Account No")
            {
            }
            column(Office_Transactions__Office_Transactions___Cheque_No_;"FIN-Office Transactions"."Cheque No")
            {
            }
            column(Office_Transactions_Amount_Control1102760000;Amount)
            {
            }
            column(RECOUPMENTCaption;RECOUPMENTCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Office_Transactions_NoCaption;FieldCaption(No))
            {
            }
            column(Office_Transactions_DateCaption;FieldCaption(Date))
            {
            }
            column(Office_Transactions_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Office_Transactions_AmountCaption;FieldCaption(Amount))
            {
            }
            column(From_Acc_No_Caption;From_Acc_No_CaptionLbl)
            {
            }
            column(To_Acc_No_Caption;To_Acc_No_CaptionLbl)
            {
            }
            column(Cheque_No_Caption;Cheque_No_CaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
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
        TotalFor: label 'Total for ';
        RECOUPMENTCaptionLbl: label 'RECOUPMENT';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        From_Acc_No_CaptionLbl: label 'From Acc No.';
        To_Acc_No_CaptionLbl: label 'To Acc No.';
        Cheque_No_CaptionLbl: label 'Cheque No.';
        TotalCaptionLbl: label 'Total';
}

