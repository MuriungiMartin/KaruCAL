#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1209 "Export Payment File (Yes/No)"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        BankAcc: Record "Bank Account";
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        if not FindSet then
          Error(NothingToExportErr);
        SetRange("Journal Template Name","Journal Template Name");
        SetRange("Journal Batch Name","Journal Batch Name");

        GenJnlBatch.Get("Journal Template Name","Journal Batch Name");
        GenJnlBatch.TestField("Bal. Account Type",GenJnlBatch."bal. account type"::"Bank Account");
        GenJnlBatch.TestField("Bal. Account No.");

        CheckDocNoOnLines;
        if IsExportedToPaymentFile then
          if not Confirm(ExportAgainQst) then
            exit;
        BankAcc.Get(GenJnlBatch."Bal. Account No.");
        Codeunit.Run(BankAcc.GetPaymentExportCodeunitID,Rec);
    end;

    var
        ExportAgainQst: label 'One or more of the selected lines have already been exported. Do you want to export again?';
        NothingToExportErr: label 'There is nothing to export.';
}

