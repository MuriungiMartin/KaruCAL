#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 238 "G/L Reg.-VAT Entries"
{
    TableNo = "G/L Register";

    trigger OnRun()
    begin
        VATEntry.SetRange("Entry No.","From VAT Entry No.","To VAT Entry No.");
        Page.Run(Page::"VAT Entries",VATEntry);
    end;

    var
        VATEntry: Record "VAT Entry";
}

