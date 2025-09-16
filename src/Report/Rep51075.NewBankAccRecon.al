#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51075 "New-Bank Acc. Recon."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/New-Bank Acc. Recon..rdlc';

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
            column(BankStatBalance;BankStatBalance)
            {
            }
            column(CashBkBal_ABS_TotalUnpresentedChqs__UncreditedChqs;CashBkBal+Abs(TotalUnpresentedChqs)-UncreditedChqs)
            {
            }
            column(UncreditedChqs;UncreditedChqs)
            {
            }
            column(ABS_TotalUnpresentedChqs_;Abs(TotalUnpresentedChqs))
            {
            }
            column(CashBkBal;CashBkBal)
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
            column(RECONCILIATION_AS_AT_Caption;RECONCILIATION_AS_AT_CaptionLbl)
            {
            }
            column(Bank_Account_No_Caption;Bank_Account_No_CaptionLbl)
            {
            }
            column(Balance_as_per_the_bank_statement_Caption;Balance_as_per_the_bank_statement_CaptionLbl)
            {
            }
            column(Reconciled_Cash_Book_Balance_Caption;Reconciled_Cash_Book_Balance_CaptionLbl)
            {
            }
            column(Uncredited_bankings__as_per_list_Caption;Uncredited_bankings__as_per_list_CaptionLbl)
            {
            }
            column(Unpresented_cheques_as_per_list_Caption;Unpresented_cheques_as_per_list_CaptionLbl)
            {
            }
            column(Bank_Account_balance_as_per_Cash_Book_Caption;Bank_Account_balance_as_per_Cash_Book_CaptionLbl)
            {
            }
            column(Less_Caption;Less_CaptionLbl)
            {
            }
            column(Add_Caption;Add_CaptionLbl)
            {
            }
            column(Bank_Acc__Reconciliation_Line_Statement_No_;"Statement No.")
            {
            }
            column(Bank_Acc__Reconciliation_Line_Statement_Line_No_;"Statement Line No.")
            {
            }
            column(Bank_Acc__Reconciliation_Line_Reconciled;Reconciled)
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
        dataitem(UncreditedCash;"Bank Acc. Reconciliation Line")
        {
            DataItemTableView = sorting("Bank Account No.","Statement No.","Statement Line No.") order(ascending);
            column(ReportForNavId_2008; 2008)
            {
            }
            column(UncreditedCash__Document_No__;"Document No.")
            {
            }
            column(UncreditedCash__Transaction_Date_;"Transaction Date")
            {
            }
            column(UncreditedCash_Description;Description)
            {
            }
            column(UncreditedCash__Check_No__;"Check No.")
            {
            }
            column(UncreditedCash__Applied_Amount_;"Applied Amount")
            {
            }
            column(UncreditedChqs_Control1102756031;UncreditedChqs)
            {
            }
            column(Uncredited_Bankings_list_Caption;Uncredited_Bankings_list_CaptionLbl)
            {
            }
            column(AmountCaption;AmountCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(Cheque_No_Caption;Cheque_No_CaptionLbl)
            {
            }
            column(Document_No_Caption;Document_No_CaptionLbl)
            {
            }
            column(Total_Uncredited_Cheques_Caption;Total_Uncredited_Cheques_CaptionLbl)
            {
            }
            column(UncreditedCash_Bank_Account_No_;"Bank Account No.")
            {
            }
            column(UncreditedCash_Statement_No_;"Statement No.")
            {
            }
            column(UncreditedCash_Statement_Line_No_;"Statement Line No.")
            {
            }

            trigger OnPreDataItem()
            begin

                UncreditedCash.SetFilter(UncreditedCash."Bank Account No.","Bank Acc. Reconciliation Line"."Bank Account No.");
                UncreditedCash.SetFilter(UncreditedCash."Statement No.","Bank Acc. Reconciliation Line"."Statement No.");
                UncreditedCash.SetFilter(UncreditedCash.Reconciled,Format(false));
                UncreditedCash.SetFilter(UncreditedCash."Applied Amount",'>0');
            end;
        }
        dataitem(UnpresentedCheques;"Bank Acc. Reconciliation Line")
        {
            DataItemTableView = sorting("Bank Account No.","Statement No.","Statement Line No.") order(ascending);
            column(ReportForNavId_2851; 2851)
            {
            }
            column(UnpresentedCheques__Document_No__;"Document No.")
            {
            }
            column(UnpresentedCheques__Transaction_Date_;"Transaction Date")
            {
            }
            column(UnpresentedCheques_Description;Description)
            {
            }
            column(UnpresentedCheques__Check_No__;"Check No.")
            {
            }
            column(ABS__Applied_Amount__;Abs("Applied Amount"))
            {
            }
            column(ABS_TotalUnpresentedChqs__Control1102756018;Abs(TotalUnpresentedChqs))
            {
            }
            column(Unpresented_Cheques_list_Caption;Unpresented_Cheques_list_CaptionLbl)
            {
            }
            column(AmountCaption_Control1102756006;AmountCaption_Control1102756006Lbl)
            {
            }
            column(DescriptionCaption_Control1102756008;DescriptionCaption_Control1102756008Lbl)
            {
            }
            column(DateCaption_Control1102756014;DateCaption_Control1102756014Lbl)
            {
            }
            column(Cheque_No_Caption_Control1102756015;Cheque_No_Caption_Control1102756015Lbl)
            {
            }
            column(Document_No_Caption_Control1102756016;Document_No_Caption_Control1102756016Lbl)
            {
            }
            column(Total_Unpresented_Cheques__Caption;Total_Unpresented_Cheques__CaptionLbl)
            {
            }
            column(DataItem1000000005;Approved_by______________________________________________________________Date_______________________________________________CLbl)
            {
            }
            column(FINANCE_MANAGERCaption;FINANCE_MANAGERCaptionLbl)
            {
            }
            column(DataItem1000000007;Reviewed_by______________________________________________________________Date_______________________________________________CLbl)
            {
            }
            column(ACCOUNTANTCaption;ACCOUNTANTCaptionLbl)
            {
            }
            column(DataItem1000000009;Prepared_by______________________________________________________________Date_______________________________________________CLbl)
            {
            }
            column(UnpresentedCheques_Bank_Account_No_;"Bank Account No.")
            {
            }
            column(UnpresentedCheques_Statement_No_;"Statement No.")
            {
            }
            column(UnpresentedCheques_Statement_Line_No_;"Statement Line No.")
            {
            }

            trigger OnPreDataItem()
            begin
                UnpresentedCheques.SetFilter(UnpresentedCheques."Bank Account No.","Bank Acc. Reconciliation Line"."Bank Account No.");
                UnpresentedCheques.SetFilter(UnpresentedCheques."Statement No.","Bank Acc. Reconciliation Line"."Statement No.");
                UnpresentedCheques.SetFilter(UnpresentedCheques.Reconciled,Format(false));
                UnpresentedCheques.SetFilter(UnpresentedCheques."Applied Amount",'<0');
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
        BankName: Text[50];
        BankAcc: Record "Bank Account";
        CashBkBal: Decimal;
        Difference: Decimal;
        Company: Record "Company Information";
        UncreditedChqs: Decimal;
        BankAccNo: Code[20];
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
        RECONCILIATION_AS_AT_CaptionLbl: label 'RECONCILIATION AS AT:';
        Bank_Account_No_CaptionLbl: label 'Bank Account No:';
        Balance_as_per_the_bank_statement_CaptionLbl: label 'Balance as per the bank statement:';
        Reconciled_Cash_Book_Balance_CaptionLbl: label 'Reconciled Cash Book Balance:';
        Uncredited_bankings__as_per_list_CaptionLbl: label 'Uncredited bankings  as per list:';
        Unpresented_cheques_as_per_list_CaptionLbl: label 'Unpresented cheques as per list:';
        Bank_Account_balance_as_per_Cash_Book_CaptionLbl: label 'Bank Account balance as per Cash Book:';
        Less_CaptionLbl: label 'Less:';
        Add_CaptionLbl: label 'Add:';
        Uncredited_Bankings_list_CaptionLbl: label 'Uncredited Bankings list:';
        AmountCaptionLbl: label 'Amount';
        DescriptionCaptionLbl: label 'Description';
        DateCaptionLbl: label 'Date';
        Cheque_No_CaptionLbl: label 'Cheque No.';
        Document_No_CaptionLbl: label 'Document No.';
        Total_Uncredited_Cheques_CaptionLbl: label ' Total Uncredited Cheques:';
        Unpresented_Cheques_list_CaptionLbl: label 'Unpresented Cheques list:';
        AmountCaption_Control1102756006Lbl: label 'Amount';
        DescriptionCaption_Control1102756008Lbl: label 'Description';
        DateCaption_Control1102756014Lbl: label 'Date';
        Cheque_No_Caption_Control1102756015Lbl: label 'Cheque No.';
        Document_No_Caption_Control1102756016Lbl: label 'Document No.';
        Total_Unpresented_Cheques__CaptionLbl: label ' Total Unpresented Cheques :';
        Approved_by______________________________________________________________Date_______________________________________________CLbl: label 'Approved by:........................................                     Date...............................................';
        FINANCE_MANAGERCaptionLbl: label 'FINANCE MANAGER';
        Reviewed_by______________________________________________________________Date_______________________________________________CLbl: label 'Reviewed by:........................................                     Date...............................................';
        ACCOUNTANTCaptionLbl: label 'ACCOUNTANT';
        Prepared_by______________________________________________________________Date_______________________________________________CLbl: label 'Prepared by:........................................                     Date...............................................';


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

