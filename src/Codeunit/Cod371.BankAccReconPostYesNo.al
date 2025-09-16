#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 371 "Bank Acc. Recon. Post (Yes/No)"
{
    TableNo = "Bank Acc. Reconciliation";

    trigger OnRun()
    begin
        if BankAccReconPostYesNo(Rec) then;
    end;

    var
        PostReconciliationQst: label 'Do you want to post the Reconciliation?';
        PostPaymentsOnlyQst: label 'Do you want to post the payments?';
        PostPaymentsAndReconcileQst: label 'Do you want to post the payments and reconcile the bank account?';


    procedure BankAccReconPostYesNo(var BankAccReconciliation: Record "Bank Acc. Reconciliation"): Boolean
    var
        BankAccRecon: Record "Bank Acc. Reconciliation";
        Question: Text;
    begin
        BankAccRecon.Copy(BankAccReconciliation);

        if BankAccRecon."Statement Type" = BankAccRecon."statement type"::"Payment Application" then
          if BankAccRecon."Post Payments Only" then
            Question := PostPaymentsOnlyQst
          else
            Question := PostPaymentsAndReconcileQst
        else
          Question := PostReconciliationQst;

        if not Confirm(Question,false) then
          exit(false);

        Codeunit.Run(Codeunit::"Bank Acc. Reconciliation Post",BankAccRecon);
        BankAccReconciliation := BankAccRecon;
        exit(true);
    end;
}

