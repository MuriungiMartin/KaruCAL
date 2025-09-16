#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1025 "Job Reg.-Show Ledger"
{
    TableNo = "Job Register";

    trigger OnRun()
    begin
        JobLedgEntry.SetRange("Entry No.","From Entry No.","To Entry No.");
        Page.Run(Page::"Job Ledger Entries",JobLedgEntry);
    end;

    var
        JobLedgEntry: Record "Job Ledger Entry";
}

