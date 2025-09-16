#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5911 "Serv Reg.-Show Ledger Entries"
{
    TableNo = "Service Register";

    trigger OnRun()
    begin
        ServLedgEntry.Reset;
        ServLedgEntry.SetRange("Entry No.","From Entry No.","To Entry No.");
        Page.Run(Page::"Service Ledger Entries",ServLedgEntry);
    end;

    var
        ServLedgEntry: Record "Service Ledger Entry";
}

