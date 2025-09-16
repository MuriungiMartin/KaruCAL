#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5623 "FA MoveEntries"
{
    Permissions = TableData "FA Ledger Entry"=rm,
                  TableData "Maintenance Ledger Entry"=rm,
                  TableData "Ins. Coverage Ledger Entry"=rm;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Only disposed fixed assets can be deleted.';
        Text001: label 'You cannot delete a fixed asset that has ledger entries in a fiscal year that has not been closed yet.';
        Text002: label 'The field %1 cannot be changed for a fixed asset with ledger entries.';
        Text003: label 'The field %1 cannot be changed for a fixed asset with insurance coverage ledger entries.';
        FA: Record "Fixed Asset";
        FALedgEntry: Record "FA Ledger Entry";
        MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        InsCoverageLedgEntry: Record "Ins. Coverage Ledger Entry";
        AccountingPeriod: Record "Accounting Period";
        FiscalYearStartDate: Date;


    procedure MoveFAEntries(FADeprBook: Record "FA Depreciation Book")
    begin
        ClearAll;
        FA.LockTable;
        FALedgEntry.LockTable;
        MaintenanceLedgEntry.LockTable;
        InsCoverageLedgEntry.LockTable;
        FA.Get(FADeprBook."FA No.");

        AccountingPeriod.SetCurrentkey(Closed);
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          FiscalYearStartDate := AccountingPeriod."Starting Date"
        else
          FiscalYearStartDate := 0D;

        FALedgEntry.SetCurrentkey("FA No.","Depreciation Book Code","FA Posting Date");
        MaintenanceLedgEntry.SetCurrentkey("FA No.","Depreciation Book Code","FA Posting Date");

        FALedgEntry.SetRange("FA No.",FADeprBook."FA No.");
        MaintenanceLedgEntry.SetRange("FA No.",FADeprBook."FA No.");

        FALedgEntry.SetRange("Depreciation Book Code",FADeprBook."Depreciation Book Code");
        MaintenanceLedgEntry.SetRange("Depreciation Book Code",FADeprBook."Depreciation Book Code");

        if FA."Budgeted Asset" then
          DeleteNo(FADeprBook)
        else begin
          if FALedgEntry.FindFirst then
            if FADeprBook."Disposal Date" = 0D then
              Error(Text000);

          FALedgEntry.SetFilter("FA Posting Date",'>=%1',FiscalYearStartDate);
          if FALedgEntry.FindFirst then
            CreateError(0);

          MaintenanceLedgEntry.SetFilter("FA Posting Date",'>=%1',FiscalYearStartDate);
          if MaintenanceLedgEntry.FindFirst then
            CreateError(0);

          FALedgEntry.SetRange("FA Posting Date");
          MaintenanceLedgEntry.SetRange("FA Posting Date");

          FALedgEntry.SetCurrentkey(
            "FA No.","Depreciation Book Code","FA Posting Category","FA Posting Type","Posting Date");
          MaintenanceLedgEntry.SetCurrentkey("FA No.","Depreciation Book Code","Posting Date");

          FALedgEntry.SetFilter("Posting Date",'>=%1',FiscalYearStartDate);
          if FALedgEntry.FindFirst then
            CreateError(0);
          MaintenanceLedgEntry.SetFilter("Posting Date",'>=%1',FiscalYearStartDate);
          if MaintenanceLedgEntry.FindFirst then
            CreateError(0);

          FALedgEntry.SetRange("Posting Date");
          MaintenanceLedgEntry.SetRange("Posting Date");
          DeleteNo(FADeprBook);
        end;
    end;

    local procedure DeleteNo(var FADeprBook: Record "FA Depreciation Book")
    begin
        FALedgEntry.ModifyAll("FA No.",'');
        FALedgEntry.SetRange("FA No.");
        FALedgEntry.SetCurrentkey("Canceled from FA No.");
        FALedgEntry.SetRange("Canceled from FA No.",FADeprBook."FA No.");
        FALedgEntry.ModifyAll("Canceled from FA No.",'');

        MaintenanceLedgEntry.ModifyAll("FA No.",'');
        MoveFAInsuranceEntries(FADeprBook."FA No.");
    end;


    procedure MoveInsuranceEntries(Insurance: Record Insurance)
    begin
        with InsCoverageLedgEntry do begin
          Reset;
          LockTable;
          SetCurrentkey("Insurance No.");
          SetRange("Insurance No.",Insurance."No.");
          if Find('-') then
            repeat
              "FA No." := '';
              "Insurance No." := '';
              Modify;
            until Next = 0;
        end;
    end;


    procedure MoveFAInsuranceEntries(FANo: Code[20])
    begin
        with InsCoverageLedgEntry do begin
          SetCurrentkey("FA No.");
          SetRange("FA No.",FANo);
          if Find('-') then
            repeat
              "Insurance No." := '';
              "FA No." := '';
              Modify;
            until Next = 0;
        end;
    end;


    procedure ChangeBudget(FA: Record "Fixed Asset")
    begin
        FALedgEntry.Reset;
        MaintenanceLedgEntry.Reset;
        InsCoverageLedgEntry.Reset;

        FALedgEntry.LockTable;
        MaintenanceLedgEntry.LockTable;
        InsCoverageLedgEntry.LockTable;

        FALedgEntry.SetCurrentkey("FA No.","Depreciation Book Code","FA Posting Date");
        MaintenanceLedgEntry.SetCurrentkey("FA No.","Depreciation Book Code","FA Posting Date");
        InsCoverageLedgEntry.SetCurrentkey("FA No.");

        FALedgEntry.SetRange("FA No.",FA."No.");
        MaintenanceLedgEntry.SetRange("FA No.",FA."No.");
        InsCoverageLedgEntry.SetRange("FA No.",FA."No.");

        if FALedgEntry.FindFirst then
          CreateError(1);
        if MaintenanceLedgEntry.FindFirst then
          CreateError(1);
        if InsCoverageLedgEntry.Find('-') then
          CreateError(2);
    end;

    local procedure CreateError(CheckType: Option Delete,Budget,Insurance)
    var
        FA: Record "Fixed Asset";
    begin
        case CheckType of
          Checktype::Delete:
            Error(
              Text001);
          Checktype::Budget:
            Error(
              Text002,
              FA.FieldCaption("Budgeted Asset"));
          Checktype::Insurance:
            Error(
              Text003,
              FA.FieldCaption("Budgeted Asset"));
        end;
    end;
}

