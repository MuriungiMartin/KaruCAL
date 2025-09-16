#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1263 "Imp. Bank Conv.-Pre-Mapping"
{
    TableNo = "Bank Acc. Reconciliation Line";

    trigger OnRun()
    var
        DataExch: Record "Data Exch.";
        PrePostProcessXMLImport: Codeunit "Pre & Post Process XML Import";
    begin
        DataExch.Get("Data Exch. Entry No.");
        PrePostProcessXMLImport.PreProcessFile(DataExch,StmtNoPathFilterTxt);
        PrePostProcessXMLImport.PreProcessBankAccount(DataExch,"Bank Account No.",StmtBankAccNoPathFilterTxt,CurrCodePathFilterTxt);
    end;

    var
        StmtBankAccNoPathFilterTxt: label '/reportExportResponse/return/finsta/ownbankaccountidentification/bankaccount', Locked=true;
        CurrCodePathFilterTxt: label '=''/reportExportResponse/return/finsta/statementdetails/amountdetails/currency''|=''/reportExportResponse/return/finsta/transactions/posting/currency''', Locked=true;
        StmtNoPathFilterTxt: label '/reportExportResponse/return/finsta/statementdetails/statementno', Locked=true;
}

