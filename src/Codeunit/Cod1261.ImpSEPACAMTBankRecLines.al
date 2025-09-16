#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1261 "Imp. SEPA CAMT Bank Rec. Lines"
{
    TableNo = "Bank Acc. Reconciliation Line";

    trigger OnRun()
    var
        DataExch: Record "Data Exch.";
        ProcessDataExch: Codeunit "Process Data Exch.";
        RecRef: RecordRef;
    begin
        DataExch.Get("Data Exch. Entry No.");
        RecRef.GetTable(Rec);
        PreProcess(Rec);
        ProcessDataExch.ProcessAllLinesColumnMapping(DataExch,RecRef);
        PostProcess(Rec)
    end;

    var
        StatementIDTxt: label '/Document/BkToCstmrStmt/Stmt/Id', Locked=true;
        IBANTxt: label '/Document/BkToCstmrStmt/Stmt/Acct/Id/IBAN', Locked=true;
        CurrencyTxt: label '/Document/BkToCstmrStmt/Stmt/Bal/Amt[@Ccy]', Locked=true;
        BalTypeTxt: label '/Document/BkToCstmrStmt/Stmt/Bal/Tp/CdOrPrtry/Cd', Locked=true;
        ClosingBalTxt: label '/Document/BkToCstmrStmt/Stmt/Bal/Amt', Locked=true;
        StatementDateTxt: label '/Document/BkToCstmrStmt/Stmt/CreDtTm', Locked=true;
        CrdDbtIndTxt: label '/Document/BkToCstmrStmt/Stmt/Bal/CdtDbtInd', Locked=true;

    local procedure PreProcess(BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        DataExch: Record "Data Exch.";
        PrePostProcessXMLImport: Codeunit "Pre & Post Process XML Import";
    begin
        DataExch.Get(BankAccReconciliationLine."Data Exch. Entry No.");
        PrePostProcessXMLImport.PreProcessFile(DataExch,StatementIDTxt);
        PrePostProcessXMLImport.PreProcessBankAccount(DataExch,BankAccReconciliationLine."Bank Account No.",IBANTxt,CurrencyTxt);
    end;

    local procedure PostProcess(BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        DataExch: Record "Data Exch.";
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
        PrePostProcessXMLImport: Codeunit "Pre & Post Process XML Import";
        RecRef: RecordRef;
    begin
        DataExch.Get(BankAccReconciliationLine."Data Exch. Entry No.");
        BankAccReconciliation.Get(
          BankAccReconciliationLine."Statement Type",
          BankAccReconciliationLine."Bank Account No.",
          BankAccReconciliationLine."Statement No.");

        RecRef.GetTable(BankAccReconciliation);
        PrePostProcessXMLImport.PostProcessStatementEndingBalance(DataExch,RecRef,
          BankAccReconciliation.FieldNo("Statement Ending Balance"),'CLBD',BalTypeTxt,ClosingBalTxt,CrdDbtIndTxt,4);
        PrePostProcessXMLImport.PostProcessStatementDate(DataExch,RecRef,BankAccReconciliation.FieldNo("Statement Date"),
          StatementDateTxt);
    end;
}

