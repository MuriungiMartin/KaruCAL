#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1264 "Imp. Bank Conv.-Post-Mapping"
{
    TableNo = "Bank Acc. Reconciliation Line";

    trigger OnRun()
    var
        DataExch: Record "Data Exch.";
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
        PrePostProcessXMLImport: Codeunit "Pre & Post Process XML Import";
        RecRef: RecordRef;
    begin
        DataExch.Get("Data Exch. Entry No.");
        BankAccReconciliation.Get("Statement Type","Bank Account No.","Statement No.");

        RecRef.GetTable(BankAccReconciliation);
        PrePostProcessXMLImport.PostProcessStatementEndingBalance(DataExch,RecRef,
          BankAccReconciliation.FieldNo("Statement Ending Balance"),'EndBalance',StmtBalTypePathFilterTxt,StmtAmtPathFilterTxt,'',2);
        PrePostProcessXMLImport.PostProcessStatementDate(DataExch,RecRef,BankAccReconciliation.FieldNo("Statement Date"),
          StmtDatePathFilterTxt);
    end;

    var
        StmtDatePathFilterTxt: label '/reportExportResponse/return/finsta/statementdetails/todate', Locked=true;
        StmtBalTypePathFilterTxt: label '/reportExportResponse/return/finsta/statementdetails/amountdetails/type', Locked=true;
        StmtAmtPathFilterTxt: label '/reportExportResponse/return/finsta/statementdetails/amountdetails/value', Locked=true;
}

