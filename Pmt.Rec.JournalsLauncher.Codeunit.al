#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9022 "Pmt. Rec. Journals Launcher"
{

    trigger OnRun()
    var
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
    begin
        BankAccReconciliation.SetRange("Statement Type",BankAccReconciliation."statement type"::"Payment Application");
        if BankAccReconciliation.Count = 1 then
          OpenJournal(BankAccReconciliation)
        else
          OpenList;
    end;

    local procedure OpenList()
    begin
        if CurrentClientType = Clienttype::Phone then
          Page.Run(Page::"Pmt. Rec. Journals Overview")
        else
          Page.Run(Page::"Pmt. Reconciliation Journals");
    end;

    local procedure OpenJournal(var BankAccReconciliation: Record "Bank Acc. Reconciliation")
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccReconciliation.FindFirst;
        BankAccReconciliationLine.SetRange("Bank Account No.",BankAccReconciliation."Bank Account No.");
        BankAccReconciliationLine.SetRange("Statement Type",BankAccReconciliation."Statement Type");
        BankAccReconciliationLine.SetRange("Statement No.",BankAccReconciliation."Statement No.");

        if CurrentClientType = Clienttype::Phone then
          Page.Run(Page::"Pmt. Recon. Journal Overview",BankAccReconciliationLine)
        else
          Page.Run(Page::"Payment Reconciliation Journal",BankAccReconciliationLine);
    end;
}

