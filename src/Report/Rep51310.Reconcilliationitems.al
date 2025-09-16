#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51310 "Reconcilliation items"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Reconcilliation items.rdlc';

    dataset
    {
        dataitem(UnknownTable61000;UnknownTable61000)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(BankAccountNo_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Bank Account No.")
            {
            }
            column(StatementNo_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Statement No.")
            {
            }
            column(StatementLineNo_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Statement Line No.")
            {
            }
            column(DocumentNo_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Document No.")
            {
            }
            column(TransactionDate_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Transaction Date")
            {
            }
            column(Description_BankAccStatementLine;"FIN-Bank A/C Stmt Lines".Description)
            {
            }
            column(StatementAmount_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Statement Amount")
            {
            }
            column(Difference_BankAccStatementLine;"FIN-Bank A/C Stmt Lines".Difference)
            {
            }
            column(AppliedAmount_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Applied Amount")
            {
            }
            column(Type_BankAccStatementLine;"FIN-Bank A/C Stmt Lines".Type)
            {
            }
            column(AppliedEntries_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Applied Entries")
            {
            }
            column(ValueDate_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Value Date")
            {
            }
            column(ReadyforApplication_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Ready for Application")
            {
            }
            column(CheckNo_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Check No.")
            {
            }
            column(RelatedPartyName_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Related-Party Name")
            {
            }
            column(AdditionalTransactionInfo_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Additional Transaction Info")
            {
            }
            column(PostingExchEntryNo_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Posting Exch. Entry No.")
            {
            }
            column(PostingExchLineNo_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Posting Exch. Line No.")
            {
            }
            column(StatementType_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Statement Type")
            {
            }
            column(AccountType_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Account Type")
            {
            }
            column(AccountNo_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Account No.")
            {
            }
            column(TransactionText_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Transaction Text")
            {
            }
            column(RelatedPartyBankAccNo_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Related-Party Bank Acc. No.")
            {
            }
            column(RelatedPartyAddress_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Related-Party Address")
            {
            }
            column(RelatedPartyCity_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Related-Party City")
            {
            }
            column(ShortcutDimension1Code_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Shortcut Dimension 2 Code")
            {
            }
            column(MatchConfidence_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Match Confidence")
            {
            }
            column(MatchQuality_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Match Quality")
            {
            }
            column(SortingOrder_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Sorting Order")
            {
            }
            column(DimensionSetID_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Dimension Set ID")
            {
            }
            column(Reconciled_BankAccStatementLine;"FIN-Bank A/C Stmt Lines".Reconciled)
            {
            }
            column(OpenType_BankAccStatementLine;"FIN-Bank A/C Stmt Lines"."Open Type")
            {
            }
            column(Imported_BankAccStatementLine;"FIN-Bank A/C Stmt Lines".Imported)
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
}

