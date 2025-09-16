#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51228 "Imprest Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Imprest Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = where("Payment Type"=const(Imprest),Surrendered=const(No),Amount=filter(<>0));
            RequestFilterFields = No,Date,"Account No.",Department,"IW No";
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
            column(Payments__Account_No__;"Account No.")
            {
            }
            column(Payments_Amount;Amount)
            {
            }
            column(Dept;Dept)
            {
            }
            column(Payments_Date;Date)
            {
            }
            column(Actual_Spent_;"Actual Spent")
            {
            }
            column(Exp_Remarks_;"Exp Remarks")
            {
            }
            column(Bal;Bal)
            {
            }
            column(Payments__IW_No_;"IW No")
            {
            }
            column(TotalAmt;TotalAmt)
            {
            }
            column(TotalBal;TotalBal)
            {
            }
            column(TotalSpent;TotalSpent)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Imprest_SummaryCaption;Imprest_SummaryCaptionLbl)
            {
            }
            column(Warrant_NoCaption;Warrant_NoCaptionLbl)
            {
            }
            column(Imprest_HolderCaption;Imprest_HolderCaptionLbl)
            {
            }
            column(Payments_AmountCaption;FieldCaption(Amount))
            {
            }
            column(DepartmentCaption;DepartmentCaptionLbl)
            {
            }
            column(Payments_DateCaption;FieldCaption(Date))
            {
            }
            column(Actual_SpentCaption;Actual_SpentCaptionLbl)
            {
            }
            column(RemarksCaption;RemarksCaptionLbl)
            {
            }
            column(BalanceCaption;BalanceCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(BalanceCaption_Control1000000040;BalanceCaption_Control1000000040Lbl)
            {
            }
            column(Total_SpentCaption;Total_SpentCaptionLbl)
            {
            }
            column(Payments_No;No)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   SetRange("FIN-Payments".Type,'imprest');
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
        "Actual Spent": Decimal;
        "Exp Remarks": Text[30];
        Dept: Text[100];
        Dimm: Record "Dimension Value";
        ImpDetails: Record UnknownRecord61126;
        Bal: Decimal;
        TotalAmt: Decimal;
        TotalBal: Decimal;
        TotalSpent: Decimal;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Imprest_SummaryCaptionLbl: label 'Imprest Summary';
        Warrant_NoCaptionLbl: label 'Warrant No';
        Imprest_HolderCaptionLbl: label 'Imprest Holder';
        DepartmentCaptionLbl: label 'Department';
        Actual_SpentCaptionLbl: label 'Actual Spent';
        RemarksCaptionLbl: label 'Remarks';
        BalanceCaptionLbl: label 'Balance';
        TotalCaptionLbl: label 'Total';
        BalanceCaption_Control1000000040Lbl: label 'Balance';
        Total_SpentCaptionLbl: label 'Total Spent';
}

