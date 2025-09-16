#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1248 "Process Bank Acc. Rec Lines"
{
    Permissions = TableData "Data Exch."=rimd;
    TableNo = "Bank Acc. Reconciliation Line";

    trigger OnRun()
    var
        DataExch: Record "Data Exch.";
        ProcessDataExch: Codeunit "Process Data Exch.";
        RecRef: RecordRef;
    begin
        DataExch.Get("Data Exch. Entry No.");
        RecRef.GetTable(Rec);
        ProcessDataExch.ProcessAllLinesColumnMapping(DataExch,RecRef);
    end;

    var
        ProgressWindowMsg: label 'Please wait while the operation is being completed.';


    procedure ImportBankStatement(BankAccRecon: Record "Bank Acc. Reconciliation";DataExch: Record "Data Exch."): Boolean
    var
        BankAcc: Record "Bank Account";
        DataExchDef: Record "Data Exch. Def";
        DataExchMapping: Record "Data Exch. Mapping";
        DataExchLineDef: Record "Data Exch. Line Def";
        TempBankAccReconLine: Record "Bank Acc. Reconciliation Line" temporary;
        ProgressWindow: Dialog;
    begin
        BankAcc.Get(BankAccRecon."Bank Account No.");
        BankAcc.GetDataExchDef(DataExchDef);

        DataExch."Related Record" := BankAcc.RecordId;
        DataExch."Data Exch. Def Code" := DataExchDef.Code;

        if not DataExch.ImportToDataExch(DataExchDef)then
          exit(false);

        ProgressWindow.Open(ProgressWindowMsg);

        CreateBankAccRecLineTemplate(TempBankAccReconLine,BankAccRecon,DataExch);
        DataExchLineDef.SetRange("Data Exch. Def Code",DataExchDef.Code);
        DataExchLineDef.FindFirst;

        DataExchMapping.Get(DataExchDef.Code,DataExchLineDef.Code,Database::"Bank Acc. Reconciliation Line");

        if DataExchMapping."Pre-Mapping Codeunit" <> 0 then
          Codeunit.Run(DataExchMapping."Pre-Mapping Codeunit",TempBankAccReconLine);

        DataExchMapping.TestField("Mapping Codeunit");
        Codeunit.Run(DataExchMapping."Mapping Codeunit",TempBankAccReconLine);

        if DataExchMapping."Post-Mapping Codeunit" <> 0 then
          Codeunit.Run(DataExchMapping."Post-Mapping Codeunit",TempBankAccReconLine);

        InsertNonReconciledNonImportedLines(TempBankAccReconLine,GetStatementLineNoOffset(BankAccRecon));

        ProgressWindow.Close;
        exit(true);
    end;

    local procedure CreateBankAccRecLineTemplate(var BankAccReconLine: Record "Bank Acc. Reconciliation Line";BankAccRecon: Record "Bank Acc. Reconciliation";DataExch: Record "Data Exch.")
    begin
        BankAccReconLine.Init;
        BankAccReconLine."Statement Type" := BankAccRecon."Statement Type";
        BankAccReconLine."Statement No." := BankAccRecon."Statement No.";
        BankAccReconLine."Bank Account No." := BankAccRecon."Bank Account No.";
        BankAccReconLine."Data Exch. Entry No." := DataExch."Entry No.";
    end;

    local procedure InsertNonReconciledNonImportedLines(var TempBankAccReconLine: Record "Bank Acc. Reconciliation Line" temporary;StatementLineNoOffset: Integer)
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
    begin
        if TempBankAccReconLine.FindSet then
          repeat
            if TempBankAccReconLine.CanImport then begin
              BankAccReconciliationLine := TempBankAccReconLine;
              BankAccReconciliationLine."Statement Line No." += StatementLineNoOffset;
              BankAccReconciliationLine.Insert;
            end;
          until TempBankAccReconLine.Next = 0;
    end;

    local procedure GetStatementLineNoOffset(BankAccRecon: Record "Bank Acc. Reconciliation"): Integer
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccReconLine.SetRange("Statement Type",BankAccRecon."Statement Type");
        BankAccReconLine.SetRange("Statement No.",BankAccRecon."Statement No.");
        BankAccReconLine.SetRange("Bank Account No.",BankAccRecon."Bank Account No.");
        if BankAccReconLine.FindLast then
          exit(BankAccReconLine."Statement Line No.");
        exit(0)
    end;
}

