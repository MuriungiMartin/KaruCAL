#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1254 "Match Bank Pmt. Appl."
{
    TableNo = "Bank Acc. Reconciliation";

    trigger OnRun()
    var
        MatchBankPayments: Codeunit "Match Bank Payments";
    begin
        BankAccReconciliationLine.FilterBankRecLines(Rec);
        MatchBankPayments.SetApplyEntries(true);
        MatchBankPayments.Run(BankAccReconciliationLine);
    end;

    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
}

