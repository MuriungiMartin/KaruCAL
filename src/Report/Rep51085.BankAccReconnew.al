#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51085 "Bank Acc. Recon. -new"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Acc. Recon. -new.rdlc';

    dataset
    {
        dataitem("Bank Acc. Reconciliation Line";"Bank Acc. Reconciliation Line")
        {
            DataItemTableView = sorting(Reconciled,"Transaction Date") order(descending);
            RequestFilterFields = "Bank Account No.";
            column(ReportForNavId_1210; 1210)
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
            column(Bank_Acc__Reconciliation_Line__Bank_Account_No__;"Bank Account No.")
            {
            }
            column(CashBkBal;CashBkBal)
            {
            }
            column(CashBkBal_BankStatBalance;CashBkBal-BankStatBalance)
            {
            }
            column(BankStatBalance;BankStatBalance)
            {
            }
            column(BankName;BankName)
            {
            }
            column(VarBankRec__Statement_Date_;VarBankRec."Statement Date")
            {
            }
            column(BankAccNo;BankAccNo)
            {
            }
            column(ReconciliationStatement;ReconciliationStatement)
            {
            }
            column(CashBkBal_BankStatBalance_Control58;CashBkBal-BankStatBalance)
            {
            }
            column(TotalUnPresented_TotalDifference;TotalUnPresented+TotalDifference)
            {
            }
            column(Bank_Acc__Reconciliation_Line__Document_No__;"Document No.")
            {
            }
            column(Bank_Acc__Reconciliation_Line__Transaction_Date_;"Transaction Date")
            {
            }
            column(Bank_Acc__Reconciliation_Line_Description;Description)
            {
            }
            column(Bank_Acc__Reconciliation_Line__Applied_Amount_;"Applied Amount")
            {
            }
            column(Bank_Acc__Reconciliation_Line_Reconciled;Reconciled)
            {
            }
            column(Bank_Acc__Reconciliation_Line__Check_No__;"Check No.")
            {
            }
            column(Bank_Acc__Reconciliation_Line_Difference;Difference)
            {
            }
            column(TotalUnPresented_TotalDifference_Control13;TotalUnPresented+TotalDifference)
            {
            }
            column(UncreditedChqs;UncreditedChqs)
            {
            }
            column(TotalUnpresentedChqs;TotalUnpresentedChqs)
            {
            }
            column(TotalDifference;TotalDifference)
            {
            }
            column(BANK_ACCOUNT_RECONCILIATION_REPORTCaption;BANK_ACCOUNT_RECONCILIATION_REPORTCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Bank_Code_Caption;Bank_Code_CaptionLbl)
            {
            }
            column(Bank_Name_Caption;Bank_Name_CaptionLbl)
            {
            }
            column(Reconciliation_as_at_Caption;Reconciliation_as_at_CaptionLbl)
            {
            }
            column(Bank_Account_balance_as_per_Cash_Book_Caption;Bank_Account_balance_as_per_Cash_Book_CaptionLbl)
            {
            }
            column(Balance_on_Bank_Statement_Caption;Balance_on_Bank_Statement_CaptionLbl)
            {
            }
            column(Difference_to_be_Explained_Caption;Difference_to_be_Explained_CaptionLbl)
            {
            }
            column(Bank_Account_No_Caption;Bank_Account_No_CaptionLbl)
            {
            }
            column(Difference_between_Cash_book_and_Bank_Statement_BalanceCaption;Difference_between_Cash_book_and_Bank_Statement_BalanceCaptionLbl)
            {
            }
            column(Total_Unreconciling_itemsCaption;Total_Unreconciling_itemsCaptionLbl)
            {
            }
            column(Bank_Acc__Reconciliation_Line__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(Bank_Acc__Reconciliation_Line_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(AmountCaption;AmountCaptionLbl)
            {
            }
            column(ReconciledCaption;ReconciledCaptionLbl)
            {
            }
            column(Cheque_No_Caption;Cheque_No_CaptionLbl)
            {
            }
            column(Bank_Acc__Reconciliation_Line_DifferenceCaption;FieldCaption(Difference))
            {
            }
            column(Differences_Expalined_by_Uncredited_and_Unpresented_Cheques_Caption;Differences_Expalined_by_Uncredited_and_Unpresented_Cheques_CaptionLbl)
            {
            }
            column(Difference_ExplainedCaption;Difference_ExplainedCaptionLbl)
            {
            }
            column(Uncredited_ChequesCaption;Uncredited_ChequesCaptionLbl)
            {
            }
            column(Unpresented_ChequesCaption;Unpresented_ChequesCaptionLbl)
            {
            }
            column(Items_in_bank_statement_not_in_cash_bookCaption;Items_in_bank_statement_not_in_cash_bookCaptionLbl)
            {
            }
            column(DataItem50;Prepared_by______________________________________________________________Date_______________________________________________CLbl)
            {
            }
            column(DataItem51;Reviewed_by______________________________________________________________Date_______________________________________________CLbl)
            {
            }
            column(DataItem52;Approved_by______________________________________________________________Date_______________________________________________CLbl)
            {
            }
            column(ACCOUNTANTCaption;ACCOUNTANTCaptionLbl)
            {
            }
            column(FINANCE_MANAGERCaption;FINANCE_MANAGERCaptionLbl)
            {
            }
            column(Bank_Acc__Reconciliation_Line_Statement_No_;"Statement No.")
            {
            }
            column(Bank_Acc__Reconciliation_Line_Statement_Line_No_;"Statement Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Bank Acc. Reconciliation Line".Reconciled=false then
                begin
                if "Bank Acc. Reconciliation Line"."Applied Amount">0 then
                UncreditedChqs:=UncreditedChqs+"Bank Acc. Reconciliation Line"."Applied Amount"
                else
                TotalUnpresentedChqs:=TotalUnpresentedChqs+"Bank Acc. Reconciliation Line"."Applied Amount";
                end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Bank Account No.");
                TotalPresentedFunc;
                TotalUnpresentedFunc;
                TotalDiffFunc;
                GetBank;
                "Bank Acc. Reconciliation Line".SetRange("Bank Acc. Reconciliation Line"."Bank Account No.",VarBankRec."Bank Account No.");
                "Bank Acc. Reconciliation Line".SetRange("Bank Acc. Reconciliation Line"."Statement No.",VarBankRec."Statement No.");
                if (TotalUnPresented+TotalDifference) =(CashBkBal-BankStatBalance) then
                Finished:=true;
                //MESSAGE('%1',TotalUnPresented+TotalDifference);
                //MESSAGE('%1',CashBkBal-BankStatBalance);

                if TotalUnPresented<>0 then
                IsDifferent:=true;
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

    trigger OnPreReport()
    begin
         Company.Get;
          ReconciliationStatement:='Reconciliation is incomplete please go through it again';
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: label 'Total for ';
        VarBankRec: Record "Bank Acc. Reconciliation";
        BankRecPresented: Record "Bank Acc. Reconciliation Line";
        BankRecUnPresented: Record "Bank Acc. Reconciliation Line";
        TotalPresented: Decimal;
        TotalUnPresented: Decimal;
        BankStatBalance: Decimal;
        BankLastBalance: Decimal;
        BankName: Text[30];
        BankAcc: Record "Bank Account";
        CashBkBal: Decimal;
        Difference: Decimal;
        Company: Record "Company Information";
        UncreditedChqs: Decimal;
        BankAccNo: Code[30];
        ReconciliationStatement: Text[250];
        Finished: Boolean;
        PrintWithRecon: Boolean;
        IsDifferent: Boolean;
        TotalUnpresentedChqs: Decimal;
        TotalDifference: Decimal;
        BANK_ACCOUNT_RECONCILIATION_REPORTCaptionLbl: label 'BANK ACCOUNT RECONCILIATION REPORT';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Bank_Code_CaptionLbl: label 'Bank Code:';
        Bank_Name_CaptionLbl: label 'Bank Name:';
        Reconciliation_as_at_CaptionLbl: label 'Reconciliation as at:';
        Bank_Account_balance_as_per_Cash_Book_CaptionLbl: label 'Bank Account balance as per Cash Book:';
        Balance_on_Bank_Statement_CaptionLbl: label 'Balance on Bank Statement:';
        Difference_to_be_Explained_CaptionLbl: label 'Difference to be Explained:';
        Bank_Account_No_CaptionLbl: label 'Bank Account No:';
        Difference_between_Cash_book_and_Bank_Statement_BalanceCaptionLbl: label 'Difference between Cash book and Bank Statement Balance';
        Total_Unreconciling_itemsCaptionLbl: label 'Total Unreconciling items';
        DateCaptionLbl: label 'Date';
        AmountCaptionLbl: label 'Amount';
        ReconciledCaptionLbl: label 'Reconciled';
        Cheque_No_CaptionLbl: label 'Cheque No.';
        Differences_Expalined_by_Uncredited_and_Unpresented_Cheques_CaptionLbl: label 'Differences Expalined by Uncredited and Unpresented Cheques ';
        Difference_ExplainedCaptionLbl: label 'Difference Explained';
        Uncredited_ChequesCaptionLbl: label 'Uncredited Cheques';
        Unpresented_ChequesCaptionLbl: label 'Unpresented Cheques';
        Items_in_bank_statement_not_in_cash_bookCaptionLbl: label 'Items in bank statement not in cash book';
        Prepared_by______________________________________________________________Date_______________________________________________CLbl: label 'Prepared by:........................................                     Date...............................................';
        Reviewed_by______________________________________________________________Date_______________________________________________CLbl: label 'Reviewed by:........................................                     Date...............................................';
        Approved_by______________________________________________________________Date_______________________________________________CLbl: label 'Approved by:........................................                     Date...............................................';
        ACCOUNTANTCaptionLbl: label 'ACCOUNTANT';
        FINANCE_MANAGERCaptionLbl: label 'FINANCE MANAGER';


    procedure getbankRec(var BankRec: Record "Bank Acc. Reconciliation";var StatementBalance: Decimal)
    begin
        VarBankRec:=BankRec;
        BankStatBalance:=StatementBalance;
        //BankStatBalance:=BankRec."Statement Ending Balance"-BankRec."Balance Last Statement";
        //ADDED BY ERIC
        BankStatBalance:=BankRec."Statement Ending Balance";
        BankLastBalance:=BankRec."Balance Last Statement";
    end;


    procedure TotalPresentedFunc()
    begin
        BankRecPresented.SetRange(BankRecPresented."Bank Account No.",VarBankRec."Bank Account No.");
        BankRecPresented.SetRange(BankRecPresented."Statement No.",VarBankRec."Statement No.");
        BankRecPresented.SetRange(BankRecPresented.Reconciled,true);
        if BankRecPresented.Find('-') then begin
        repeat
        TotalPresented:=TotalPresented+BankRecPresented."Applied Amount";
        until BankRecPresented.Next=0;
        end;
    end;


    procedure TotalUnpresentedFunc()
    begin
        BankRecUnPresented.SetRange(BankRecUnPresented."Bank Account No.",VarBankRec."Bank Account No.");
        BankRecUnPresented.SetRange(BankRecUnPresented."Statement No.",VarBankRec."Statement No.");
        BankRecUnPresented.SetRange(BankRecUnPresented.Reconciled,false);
        if BankRecPresented.Find('-') then begin
        repeat
        TotalUnPresented:=TotalUnPresented+BankRecUnPresented."Applied Amount";
        until BankRecUnPresented.Next=0;
        end;
    end;


    procedure GetBank()
    begin
        if BankAcc.Get(VarBankRec."Bank Account No.") then
        begin
        BankAcc.SetRange(BankAcc."Date Filter",0D,VarBankRec."Statement Date");
        BankAcc.CalcFields(BankAcc."Balance at Date");
        CashBkBal:=BankAcc."Balance at Date";
        BankName:=BankAcc.Name;
        BankAccNo:=BankAcc."Bank Account No.";
        end;
    end;


    procedure TotalDiffFunc()
    begin
        BankRecPresented.Reset;
        BankRecPresented.SetRange(BankRecPresented."Bank Account No.",VarBankRec."Bank Account No.");
        BankRecPresented.SetRange(BankRecPresented."Statement No.",VarBankRec."Statement No.");
        //BankRecPresented.SETRANGE(BankRecPresented.Reconciled,TRUE);
        if BankRecPresented.Find('-') then begin
        repeat
        TotalDifference:=TotalDifference+BankRecPresented.Difference;
        //MESSAGE('%1',TotalDifference);
        until BankRecPresented.Next=0;
        end;
    end;
}

