#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1407 "Bank Account Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Account Statement.rdlc';
    Caption = 'Bank Account Statement';

    dataset
    {
        dataitem("Bank Account Statement";"Bank Account Statement")
        {
            DataItemTableView = sorting("Bank Account No.","Statement No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Bank Account No.","Statement No.";
            column(ReportForNavId_9909; 9909)
            {
            }
            column(ComanyName;COMPANYNAME)
            {
            }
            column(BankAccStmtTableCaptFltr;TableCaption + ': ' + BankAccStmtFilter)
            {
            }
            column(BankAccStmtFilter;BankAccStmtFilter)
            {
            }
            column(StmtNo_BankAccStmt;"Statement No.")
            {
                IncludeCaption = true;
            }
            column(Amt_BankAccStmtLineStmt;"Bank Account Statement Line"."Statement Amount")
            {
            }
            column(AppliedAmt_BankAccStmtLine;"Bank Account Statement Line"."Applied Amount")
            {
            }
            column(BankAccNo_BankAccStmt;"Bank Account No.")
            {
            }
            column(BankAccStmtCapt;BankAccStmtCaptLbl)
            {
            }
            column(CurrReportPAGENOCapt;CurrReportPAGENOCaptLbl)
            {
            }
            column(BnkAccStmtLinTrstnDteCapt;BnkAccStmtLinTrstnDteCaptLbl)
            {
            }
            column(BnkAcStmtLinValDteCapt;BnkAcStmtLinValDteCaptLbl)
            {
            }
            dataitem("Bank Account Statement Line";"Bank Account Statement Line")
            {
                DataItemLink = "Bank Account No."=field("Bank Account No."),"Statement No."=field("Statement No.");
                DataItemTableView = sorting("Bank Account No.","Statement No.","Statement Line No.");
                column(ReportForNavId_3919; 3919)
                {
                }
                column(TrnsctnDte_BnkAcStmtLin;Format("Transaction Date"))
                {
                }
                column(Type_BankAccStmtLine;Type)
                {
                    IncludeCaption = true;
                }
                column(LineDocNo_BankAccStmt;"Document No.")
                {
                    IncludeCaption = true;
                }
                column(AppliedEntr_BankAccStmtLine;"Applied Entries")
                {
                    IncludeCaption = true;
                }
                column(Amt1_BankAccStmtLineStmt;"Statement Amount")
                {
                    IncludeCaption = true;
                }
                column(AppliedAmt1_BankAccStmtLine;"Applied Amount")
                {
                    IncludeCaption = true;
                }
                column(Desc_BankAccStmtLine;Description)
                {
                    IncludeCaption = true;
                }
                column(ValueDate_BankAccStmtLine;Format("Value Date"))
                {
                }

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals("Statement Amount","Applied Amount");
                end;
            }

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(
                  "Bank Account Statement Line"."Statement Amount",
                  "Bank Account Statement Line"."Applied Amount");
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
        TotalCaption = 'Total';
    }

    trigger OnPreReport()
    begin
        BankAccStmtFilter := "Bank Account Statement".GetFilters;
    end;

    var
        BankAccStmtFilter: Text;
        BankAccStmtCaptLbl: label 'Bank Account Statement';
        CurrReportPAGENOCaptLbl: label 'Page';
        BnkAccStmtLinTrstnDteCaptLbl: label 'Transaction Date';
        BnkAcStmtLinValDteCaptLbl: label 'Value Date';
}

