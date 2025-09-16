#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 372 "Bank Acc. Recon. Post+Print"
{
    TableNo = "Bank Acc. Reconciliation";

    trigger OnRun()
    begin
        BankAccRecon.Copy(Rec);

        if not Confirm(Text000,false) then
          exit;

        Codeunit.Run(Codeunit::"Bank Acc. Reconciliation Post",BankAccRecon);
        Rec := BankAccRecon;
        Commit;

        if BankAccStmt.Get("Bank Account No.","Statement No.") then
          DocPrint.PrintBankAccStmt(BankAccStmt);
    end;

    var
        Text000: label 'Do you want to post and print the Reconciliation?';
        BankAccRecon: Record "Bank Acc. Reconciliation";
        BankAccStmt: Record "Bank Account Statement";
        DocPrint: Codeunit "Document-Print";
}

