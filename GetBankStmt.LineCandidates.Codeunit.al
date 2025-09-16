#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1295 "Get Bank Stmt. Line Candidates"
{
    TableNo = "Payment Application Proposal";

    trigger OnRun()
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccReconLine.Get("Statement Type","Bank Account No.","Statement No.","Statement Line No.");

        TransferExistingAppliedPmtEntries(Rec,BankAccReconLine);

        TransferCandidatestoAppliedPmtEntries(Rec,BankAccReconLine);
    end;

    local procedure CreatePaymentApplicationProposalFromAppliedPmtEntry(var AppliedPmtEntry: Record "Applied Payment Entry";var PaymentApplicationProposal: Record "Payment Application Proposal")
    begin
        if AppliedPmtEntry.FindSet then
          repeat
            PaymentApplicationProposal.CreateFromAppliedPaymentEntry(AppliedPmtEntry);
          until AppliedPmtEntry.Next = 0;
    end;

    local procedure GetCandidateRanking(BankAccReconLine: Record "Bank Acc. Reconciliation Line";var TempBankStmtMatchingBuffer: Record "Bank Statement Matching Buffer" temporary)
    var
        MatchBankPayments: Codeunit "Match Bank Payments";
    begin
        BankAccReconLine.SetRecfilter;
        MatchBankPayments.SetApplyEntries(false);
        MatchBankPayments.Run(BankAccReconLine);
        MatchBankPayments.GetBankStatementMatchingBuffer(TempBankStmtMatchingBuffer);
    end;

    local procedure TransferExistingAppliedPmtEntries(var PaymentApplicationProposal: Record "Payment Application Proposal";BankAccReconLine: Record "Bank Acc. Reconciliation Line")
    var
        ExistingAppliedPmtEntry: Record "Applied Payment Entry";
    begin
        ExistingAppliedPmtEntry.FilterAppliedPmtEntry(BankAccReconLine);
        CreatePaymentApplicationProposalFromAppliedPmtEntry(ExistingAppliedPmtEntry,PaymentApplicationProposal);
    end;

    local procedure TransferCandidatestoAppliedPmtEntries(var PaymentApplicationProposal: Record "Payment Application Proposal";BankAccReconLine: Record "Bank Acc. Reconciliation Line")
    var
        BankPmtApplRule: Record "Bank Pmt. Appl. Rule";
        TempBankStmtMatchingBuffer: Record "Bank Statement Matching Buffer" temporary;
        BankAccount: Record "Bank Account";
    begin
        GetCandidateRanking(BankAccReconLine,TempBankStmtMatchingBuffer);
        BankAccount.Get(BankAccReconLine."Bank Account No.");

        PaymentApplicationProposal.Reset;
        TempBankStmtMatchingBuffer.Reset;
        TempBankStmtMatchingBuffer.SetRange("One to Many Match",false);
        if TempBankStmtMatchingBuffer.FindSet then
          repeat
            PaymentApplicationProposal.CreateFromBankStmtMacthingBuffer(TempBankStmtMatchingBuffer,BankAccReconLine,BankAccount);
            if not PaymentApplicationProposal.Insert(true) then begin
              PaymentApplicationProposal.Find;
              PaymentApplicationProposal."Match Confidence" := BankPmtApplRule.GetMatchConfidence(PaymentApplicationProposal.Quality);
              PaymentApplicationProposal.Modify(true);
            end;
          until TempBankStmtMatchingBuffer.Next = 0;
    end;
}

