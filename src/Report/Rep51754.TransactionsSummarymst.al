#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51754 "Transactions Summary mst"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Transactions Summary mst.rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = sorting("Group Order","Sub Group Order");
            RequestFilterFields = "Period Filter";
            column(ReportForNavId_6955; 6955)
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
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(GETFILTERS;GetFilters)
            {
            }
            column(prTransaction_Codes__Transaction_Name_;"Transaction Name")
            {
            }
            column(prTransaction_Codes__Transaction_Code_;"Transaction Code")
            {
            }
            column(prTransaction_Codes__Curr__Amount_;"PRL-Period Transactions".Amount)
            {
            }
            column(prTransaction_Codes__Curr__Amount__Control1102755010;"PRL-Period Transactions".Amount)
            {
            }
            column(Transactions_SummaryCaption;Transactions_SummaryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CodeCaption;CodeCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(AmountCaption;AmountCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin

                //IF "prPeriod Transactions"."Non-Transactional" = TRUE THEN BEGIN
                if ("PRL-Period Transactions"."Transaction Code" <> 'BPAY') and
                   ("PRL-Period Transactions"."Transaction Code" <> 'PAYE') and
                   ("PRL-Period Transactions"."Transaction Code" <> 'NHF') then
                CurrReport.Skip;

                //END;
            end;

            trigger OnPreDataItem()
            begin
                if GetFilter("Period Filter") = '' then
                Error('You must specify Current Period Filter.');

                Evaluate(SelectedPeriod,GetFilter("Period Filter"));

                //SETFILTER("Previous Month Filter",FORMAT(CALCDATE('-1M',SelectedPeriod)));
                //CurrReport.CREATETOTALS(DebitAmount,CreditAmount);
                if CompanyInfo.Get() then
                CompanyInfo.CalcFields(CompanyInfo.Picture);
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
        TotalFor: label 'Total for ';
        SelectedPeriod: Date;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        RDebitAmount: Decimal;
        RCreditAmount: Decimal;
        CompanyInfo: Record "Company Information";
        Transactions_SummaryCaptionLbl: label 'Transactions Summary';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CodeCaptionLbl: label 'Code';
        DescriptionCaptionLbl: label 'Description';
        AmountCaptionLbl: label 'Amount';
}

