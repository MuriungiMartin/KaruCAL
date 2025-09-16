#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1260 "Imp. SEPA CAMT Gen. Jnl."
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        DataExch: Record "Data Exch.";
        ProcessDataExch: Codeunit "Process Data Exch.";
        RecRef: RecordRef;
    begin
        DataExch.Get("Data Exch. Entry No.");
        PreProcess(Rec);
        RecRef.GetTable(Rec);
        ProcessDataExch.ProcessAllLinesColumnMapping(DataExch,RecRef);
    end;

    var
        StatementIDTxt: label '/Document/BkToCstmrStmt/Stmt/Id', Locked=true;
        IBANTxt: label '/Document/BkToCstmrStmt/Stmt/Acct/Id/IBAN', Locked=true;
        CurrencyTxt: label '/Document/BkToCstmrStmt/Stmt/Bal/Amt[@Ccy]', Locked=true;

    local procedure PreProcess(var GenJnlLine: Record "Gen. Journal Line")
    var
        DataExch: Record "Data Exch.";
        GenJnlBatch: Record "Gen. Journal Batch";
        PrePostProcessXMLImport: Codeunit "Pre & Post Process XML Import";
    begin
        GenJnlBatch.Get(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name");
        DataExch.Get(GenJnlLine."Data Exch. Entry No.");
        PrePostProcessXMLImport.PreProcessFile(DataExch,StatementIDTxt);
        case GenJnlLine."Bal. Account Type" of
          GenJnlLine."bal. account type"::"Bank Account":
            PrePostProcessXMLImport.PreProcessBankAccount(DataExch,GenJnlLine."Bal. Account No.",IBANTxt,CurrencyTxt);
          GenJnlLine."bal. account type"::"G/L Account":
            PrePostProcessXMLImport.PreProcessGLAccount(DataExch,GenJnlLine,CurrencyTxt);
        end;
    end;
}

