#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5800 "Item Reg.- Show Value Entries"
{
    TableNo = "Item Register";

    trigger OnRun()
    begin
        ValueEntry.SetRange("Entry No.","From Value Entry No.","To Value Entry No.");
        Page.Run(Page::"Value Entries",ValueEntry);
    end;

    var
        ValueEntry: Record "Value Entry";
}

