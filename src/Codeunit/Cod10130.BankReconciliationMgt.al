#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10130 "Bank Reconciliation Mgt."
{
    Permissions = TableData UnknownTableData10120=r;

    trigger OnRun()
    begin
    end;


    procedure New(var BankAccReconciliation: Record "Bank Acc. Reconciliation";ShareTable: Boolean)
    var
        BankAccount: Record "Bank Account";
        BankAccReconciliation2: Record "Bank Acc. Reconciliation";
        BankRecHeader: Record UnknownRecord10120;
        BankAccReconciliationCard: Page "Bank Acc. Reconciliation";
        BankRecWorksheet: Page "Bank Rec. Worksheet";
    begin
        if not SelectBankAccountUsingFilter(BankAccount,BankAccReconciliation) then
          if not SelectBankAccount(BankAccount) then
            exit;

        if not BankAccount.CheckLastStatementNo then
          exit;

        if AutoMatchSelected then begin
          BankAccReconciliation2.InsertRec(BankAccReconciliation2."statement type"::"Bank Reconciliation",BankAccount."No.");
          if ShareTable then
            BankAccReconciliationCard.SetSharedTempTable(BankAccReconciliation);
          BankAccReconciliationCard.SetRecord(BankAccReconciliation2);
          BankAccReconciliationCard.Run;
        end else begin
          BankRecHeader.InsertRec(BankAccount."No.");
          if ShareTable then
            BankRecWorksheet.SetSharedTempTable(BankAccReconciliation);
          BankRecWorksheet.SetRecord(BankRecHeader);
          BankRecWorksheet.Run;
        end;
    end;


    procedure Edit(var BankAccReconciliation: Record "Bank Acc. Reconciliation";ShareTable: Boolean)
    var
        BankAccReconciliation2: Record "Bank Acc. Reconciliation";
        BankRecHeader: Record UnknownRecord10120;
        BankAccReconciliationCard: Page "Bank Acc. Reconciliation";
        BankRecWorksheet: Page "Bank Rec. Worksheet";
        BankAccountNo: Code[20];
        StatementNo: Code[20];
        StatementType: Option;
    begin
        StatementType := BankAccReconciliation."Statement Type";
        BankAccountNo := BankAccReconciliation."Bank Account No.";
        StatementNo := BankAccReconciliation."Statement No.";

        if AutoMatchSelected and BankAccReconciliation2.Get(StatementType,BankAccountNo,StatementNo) then begin
          BankAccReconciliationCard.SetSharedTempTable(BankAccReconciliation);
          if ShareTable then
            BankAccReconciliationCard.SetRecord(BankAccReconciliation2);
          BankAccReconciliationCard.Run;
        end;

        if (not AutoMatchSelected) and BankRecHeader.Get(BankAccountNo,StatementNo) then begin
          if ShareTable then
            BankRecWorksheet.SetSharedTempTable(BankAccReconciliation);
          BankRecWorksheet.SetRecord(BankRecHeader);
          BankRecWorksheet.Run;
        end;
    end;


    procedure Delete(BankAccReconciliation: Record "Bank Acc. Reconciliation")
    var
        BankAccReconciliation2: Record "Bank Acc. Reconciliation";
        BankRecHeader: Record UnknownRecord10120;
        BankAccountNo: Code[20];
        StatementNo: Code[20];
        StatementType: Option;
    begin
        StatementType := BankAccReconciliation."Statement Type";
        BankAccountNo := BankAccReconciliation."Bank Account No.";
        StatementNo := BankAccReconciliation."Statement No.";

        if AutoMatchSelected and BankAccReconciliation2.Get(StatementType,BankAccountNo,StatementNo) then
          BankAccReconciliation2.Delete(true);

        if (not AutoMatchSelected) and BankRecHeader.Get(BankAccountNo,StatementNo) then
          BankRecHeader.Delete(true);
    end;


    procedure Refresh(var BankAccReconciliation: Record "Bank Acc. Reconciliation")
    var
        BankAccReconciliation2: Record "Bank Acc. Reconciliation";
    begin
        if AutoMatchSelected then
          BankAccReconciliation2.GetTempCopy(BankAccReconciliation)
        else
          BankAccReconciliation2.GetTempCopyFromBankRecHeader(BankAccReconciliation);
    end;


    procedure Post(BankAccReconciliation: Record "Bank Acc. Reconciliation";AutoMatchCodeunitID: Integer;LocalCodeunitID: Integer)
    var
        BankAccReconciliation2: Record "Bank Acc. Reconciliation";
        BankRecHeader: Record UnknownRecord10120;
        BankAccountNo: Code[20];
        StatementNo: Code[20];
        StatementType: Option;
    begin
        StatementType := BankAccReconciliation."Statement Type";
        BankAccountNo := BankAccReconciliation."Bank Account No.";
        StatementNo := BankAccReconciliation."Statement No.";

        if AutoMatchSelected and BankAccReconciliation2.Get(StatementType,BankAccountNo,StatementNo) then
          Codeunit.Run(AutoMatchCodeunitID,BankAccReconciliation2);

        if (not AutoMatchSelected) and BankRecHeader.Get(BankAccountNo,StatementNo) then
          Codeunit.Run(LocalCodeunitID,BankRecHeader);
    end;

    local procedure SelectBankAccountUsingFilter(var BankAccount: Record "Bank Account";var BankAccReconciliation: Record "Bank Acc. Reconciliation"): Boolean
    begin
        if BankAccReconciliation.GetFilter("Bank Account No.") <> '' then
          exit(BankAccount.Get(BankAccReconciliation.GetRangeMin("Bank Account No.")));
    end;

    local procedure SelectBankAccount(var BankAccount: Record "Bank Account"): Boolean
    var
        BankAccountList: Page "Bank Account List";
    begin
        BankAccountList.LookupMode := true;
        if BankAccountList.RunModal <> Action::LookupOK then
          exit(false);

        BankAccountList.GetRecord(BankAccount);

        exit(true);
    end;

    local procedure AutoMatchSelected(): Boolean
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get;
        exit(GeneralLedgerSetup."Bank Recon. with Auto. Match");
    end;
}

