#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5607 "FA Automatic Entry"
{

    trigger OnRun()
    begin
    end;

    var
        FA: Record "Fixed Asset";


    procedure AdjustFALedgEntry(var FALedgEntry: Record "FA Ledger Entry")
    begin
        with FALedgEntry do begin
          FA.Get("FA No.");
          if not FA."Budgeted Asset" then
            Quantity := 0;
          "Bal. Account Type" := "bal. account type"::"G/L Account";
          "Bal. Account No." := '';
          "VAT Amount" := 0;
          "Gen. Posting Type" := "gen. posting type"::" ";
          "Gen. Bus. Posting Group" := '';
          "Gen. Prod. Posting Group" := '';
          "VAT Bus. Posting Group" := '';
          "VAT Prod. Posting Group" := '';
          "Reclassification Entry" := false;
          "Index Entry" := false;
        end;
    end;


    procedure AdjustMaintenanceLedgEntry(var MaintenanceLedgEntry: Record "Maintenance Ledger Entry")
    begin
        with MaintenanceLedgEntry do begin
          FA.Get("FA No.");
          if not FA."Budgeted Asset" then
            Quantity := 0;
          "Bal. Account Type" := "bal. account type"::"G/L Account";
          "Bal. Account No." := '';
          "VAT Amount" := 0;
          "Gen. Posting Type" := "gen. posting type"::" ";
          "Gen. Bus. Posting Group" := '';
          "Gen. Prod. Posting Group" := '';
          "VAT Bus. Posting Group" := '';
          "VAT Prod. Posting Group" := '';
          "Index Entry" := false;
        end;
    end;


    procedure AdjustGLEntry(var GLEntry: Record "G/L Entry")
    begin
        with GLEntry do begin
          Quantity := 0;
          "Bal. Account Type" := "bal. account type"::"G/L Account";
          "Bal. Account No." := '';
          "VAT Amount" := 0;
          "Gen. Posting Type" := "gen. posting type"::" ";
          "Gen. Bus. Posting Group" := '';
          "Gen. Prod. Posting Group" := '';
          "VAT Bus. Posting Group" := '';
          "VAT Prod. Posting Group" := '';
        end;
    end;
}

