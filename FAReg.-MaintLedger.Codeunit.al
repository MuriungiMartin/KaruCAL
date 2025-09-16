#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5650 "FA Reg.-MaintLedger"
{
    TableNo = "FA Register";

    trigger OnRun()
    begin
        MaintenanceLedgEntry.SetRange("Entry No.","From Maintenance Entry No.","To Maintenance Entry No.");
        Page.Run(Page::"Maintenance Ledger Entries",MaintenanceLedgEntry);
    end;

    var
        MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
}

