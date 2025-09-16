#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5620 "FA Reg.-FALedger"
{
    TableNo = "FA Register";

    trigger OnRun()
    begin
        FALedgEntry.SetRange("Entry No.","From Entry No.","To Entry No.");
        Page.Run(Page::"FA Ledger Entries",FALedgEntry);
    end;

    var
        FALedgEntry: Record "FA Ledger Entry";
}

