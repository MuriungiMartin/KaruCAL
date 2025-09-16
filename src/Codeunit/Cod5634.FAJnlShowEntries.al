#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5634 "FA Jnl.-Show Entries"
{
    TableNo = "FA Journal Line";

    trigger OnRun()
    begin
        if "FA Posting Type" <> "fa posting type"::Maintenance then begin
          DepreciationCalc.SetFAFilter(FALedgEntry,"FA No.","Depreciation Book Code",false);
          if "Depreciation Book Code" = '' then
            FALedgEntry.SetRange("Depreciation Book Code");
          if FALedgEntry.Find('+') then ;
          Page.Run(Page::"FA Ledger Entries",FALedgEntry);
        end else begin
          MaintenanceLedgEntry.SetCurrentkey("FA No.","Depreciation Book Code","FA Posting Date");
          MaintenanceLedgEntry.SetRange("FA No.","FA No.");
          if "Depreciation Book Code" <> '' then
            MaintenanceLedgEntry.SetRange("Depreciation Book Code","Depreciation Book Code");
          if MaintenanceLedgEntry.FindLast then ;
          Page.Run(Page::"Maintenance Ledger Entries",MaintenanceLedgEntry);
        end;
    end;

    var
        FALedgEntry: Record "FA Ledger Entry";
        MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        DepreciationCalc: Codeunit "Depreciation Calculation";
}

