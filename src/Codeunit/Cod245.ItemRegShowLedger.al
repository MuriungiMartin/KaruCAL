#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 245 "Item Reg.-Show Ledger"
{
    TableNo = "Item Register";

    trigger OnRun()
    begin
        ItemLedgEntry.SetRange("Entry No.","From Entry No.","To Entry No.");
        Page.Run(Page::"Item Ledger Entries",ItemLedgEntry);
    end;

    var
        ItemLedgEntry: Record "Item Ledger Entry";
}

