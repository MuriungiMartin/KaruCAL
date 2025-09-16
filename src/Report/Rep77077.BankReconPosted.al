#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77077 "Bank Recon. - Posted"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Recon. - Posted.rdlc';
    Caption = 'Bank Acc. Recon. - Test';

    dataset
    {
        dataitem("Bank Account Statement";"Bank Account Statement")
        {
            RequestFilterFields = "Bank Account No.","Statement No.","Statement Date";
            column(ReportForNavId_1000000032; 1000000032)
            {
            }
            column(BankCode;BankCode)
            {
            }
            column(BankAccountNo_BankAccReconciliation;"Bank Account Statement"."Bank Account No.")
            {
            }
            column(StatementNo_BankAccReconciliation;"Bank Account Statement"."Statement No.")
            {
            }
            column(StatementDate_BankAccReconciliation;"Bank Account Statement"."Statement Date")
            {
            }
            column(BankAccountNo;BankAccountNo)
            {
            }
            column(StatementEndingBalance_BankAccReconciliation;"Bank Account Statement"."Statement Ending Balance")
            {
            }
            column(BankName;BankName)
            {
            }
            column(BankAccountBalanceasperCashBook;BankAccountBalanceasperCashBook)
            {
            }
            column(UnpresentedChequesTotal;UnpresentedChequesTotal)
            {
            }
            column(UncreditedBanking;UncreditedBanking)
            {
            }
            column(ReconciliationStatement;ReconciliationStatement)
            {
            }
            column(CompanyName;CompanyInfo.Name)
            {
            }
            column(CompanyAddress;CompanyInfo.Address)
            {
            }
            dataitem("Bank Account Statement Line";"Bank Account Statement Line")
            {
                DataItemLink = "Bank Account No."=field("Bank Account No."),"Statement No."=field("Statement No.");
                DataItemTableView = where(Reconciled=const(false),"Statement Amount"=filter(<0));
                column(ReportForNavId_1000000015; 1000000015)
                {
                }
                column(CheckNo_BankAccReconciliationLine;"Bank Account Statement Line"."Check No.")
                {
                }
                column(DocumentNo_BankAccReconciliationLine;"Bank Account Statement Line"."Document No.")
                {
                }
                column(TransactionDate_BankAccReconciliationLine;"Bank Account Statement Line"."Transaction Date")
                {
                }
                column(StatementLineNo_BankAccReconciliationLine;"Bank Account Statement Line"."Statement Line No.")
                {
                }
                column(Description_BankAccReconciliationLine;"Bank Account Statement Line".Description)
                {
                }
                column(StatementAmount_BankAccReconciliationLine;"Bank Account Statement Line"."Statement Amount")
                {
                }
                column(OpenType_BankAccReconciliationLine;"Bank Account Statement Line"."Open Type")
                {
                }
            }
            dataitem(BankAccStatementLines2;"Bank Account Statement Line")
            {
                DataItemLink = "Bank Account No."=field("Bank Account No."),"Statement No."=field("Statement No.");
                DataItemTableView = where(Reconciled=const(false),"Statement Amount"=filter(>0));
                column(ReportForNavId_1000000007; 1000000007)
                {
                }
                column(CheckNo_BankAccReconciliationLine1;BankAccStatementLines2."Check No.")
                {
                }
                column(StatementLineNo_BankAccReconciliationLn1;BankAccStatementLines2."Statement Line No.")
                {
                }
                column(DocumentNo_BankAccReconciliationLine1;BankAccStatementLines2."Document No.")
                {
                }
                column(TransactionDate_BankAccReconciliationLine1;BankAccStatementLines2."Transaction Date")
                {
                }
                column(Description_BankAccReconciliationLine1;BankAccStatementLines2.Description)
                {
                }
                column(StatementAmount_BankAccReconciliationLine1;BankAccStatementLines2."Statement Amount")
                {
                }
                column(OpenType_BankAccReconciliationLine1;BankAccStatementLines2."Open Type")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                BankCode:='';
                BankAccountNo:='';
                BankName:='';
                BankAccountBalanceasperCashBook:=0;
                UnpresentedChequesTotal:=0;
                UncreditedBanking:=0;
                
                TotalDiffFunc();
                
                Bank.Reset;
                Bank.SetRange(Bank."No.","Bank Account No.");
                if Bank.Find('-') then begin
                  BankCode:=Bank."No.";
                  BankAccountNo:=Bank."Bank Account No.";
                  BankName:=Bank.Name;
                  Bank.SetRange(Bank."Date Filter",0D,"Statement Date");
                  Bank.CalcFields(Bank."Net Change");
                  BankAccountBalanceasperCashBook:=Bank."Net Change";
                
                  BankStatementLine.Reset;
                  BankStatementLine.SetRange(BankStatementLine."Bank Account No.",Bank."No.");
                  BankStatementLine.SetRange(BankStatementLine."Statement No.","Statement No.");
                  BankStatementLine.SetRange(BankStatementLine.Reconciled,false);
                  if BankStatementLine.Find('-') then repeat
                    if BankStatementLine."Statement Amount"<0 then
                     UnpresentedChequesTotal:=UnpresentedChequesTotal+BankStatementLine."Statement Amount"
                    else if BankStatementLine."Statement Amount">0 then
                     UncreditedBanking:=UncreditedBanking+BankStatementLine."Statement Amount";
                  until BankStatementLine.Next=0;
                
                   UnpresentedChequesTotal:=UnpresentedChequesTotal*-1;
                
                 BankStatBalance:="Bank Account Statement"."Statement Ending Balance";
                 end;
                 /*
                IF (UnpresentedChequesTotal+TotalDifference) =(BankAccountBalanceasperCashBook-BankStatBalance) THEN
                 ReconciliationStatement:=''
                ELSE
                 ReconciliationStatement:='Reconciliation is incomplete please go through it again';
                
                */

            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);

                ReconciliationStatement:='Reconciliation is incomplete please go through it again';
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
        Text000: label '%1 must be specified.';
        Text001: label '%1 is not equal to Total Balance.';
        Text002: label '%1 must be %2 for %3 %4.';
        Text003: label '%1 %2 does not exist.';
        Text004: label '%1 must be %2.';
        Text005: label 'Application is wrong.';
        Text006: label 'The total difference is %1. It must be %2.';
        Bank_Account_Statement___TestCaptionLbl: label 'Bank Account Statement - Test';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Bank_Acc__Reconciliation___Balance_Last_Statement_CaptionLbl: label 'Balance Last Statement';
        Bank_Acc__Reconciliation___Statement_Date_CaptionLbl: label 'Statement Date';
        Bank_Acc__Reconciliation___Statement_Ending_Balance_CaptionLbl: label 'Statement Ending Balance';
        ErrorText_Number_CaptionLbl: label 'Warning!';
        Bank_Acc__Reconciliation_Line__Transaction_Date_CaptionLbl: label 'Transaction Date';
        Bank_Acc__Reconciliation_Line__Value_Date_CaptionLbl: label 'Value Date';
        TotalsCaptionLbl: label 'Totals';
        ErrorText_Number__Control97CaptionLbl: label 'Warning!';
        ErrorText_Number__Control31CaptionLbl: label 'Warning!';
        Bank: Record "Bank Account";
        BankCode: Code[20];
        BankAccountNo: Code[20];
        BankName: Text;
        BankAccountBalanceasperCashBook: Decimal;
        UnpresentedChequesTotal: Decimal;
        UncreditedBanking: Decimal;
        BankStatementLine: Record "Bank Account Statement Line";
        CompanyInfo: Record "Company Information";
        ReconciliationStatement: Text;
        TotalDifference: Decimal;
        BankRecPresented: Record "Bank Account Statement Line";
        BankRecUnPresented: Record "Bank Account Statement Line";
        BankStatBalance: Decimal;


    procedure TotalDiffFunc()
    begin
        BankRecPresented.Reset;
        BankRecPresented.SetRange(BankRecPresented."Bank Account No.","Bank Account Statement"."Bank Account No.");
        BankRecPresented.SetRange(BankRecPresented."Statement No.","Bank Account Statement"."Statement No.");
        //BankRecPresented.SETRANGE(BankRecPresented.Reconciled,TRUE);
        if BankRecPresented.Find('-') then begin
        repeat
        TotalDifference:=TotalDifference+BankRecPresented.Difference;
        //MESSAGE('%1',TotalDifference);
        until BankRecPresented.Next=0;
        end;
    end;
}

