#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 390 "Item Reg.-Show Inventory Ledg."
{
    TableNo = "Item Register";

    trigger OnRun()
    begin
        PhysInvtLedgEntry.SetRange("Entry No.","From Phys. Inventory Entry No.","To Phys. Inventory Entry No.");
        Page.Run(Page::"Phys. Inventory Ledger Entries",PhysInvtLedgEntry);
    end;

    var
        PhysInvtLedgEntry: Record "Phys. Inventory Ledger Entry";
}

