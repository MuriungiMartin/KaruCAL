#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 338 "VAT Entry - Edit"
{
    Permissions = TableData "VAT Entry"=imd;
    TableNo = "VAT Entry";

    trigger OnRun()
    begin
        VATEntry := Rec;
        VATEntry.LockTable;
        VATEntry.Find;
        VATEntry.Validate(Type);
        VATEntry."Bill-to/Pay-to No." := "Bill-to/Pay-to No.";
        VATEntry."Ship-to/Order Address Code" := "Ship-to/Order Address Code";
        VATEntry."EU 3-Party Trade" := "EU 3-Party Trade";
        VATEntry."Country/Region Code" := "Country/Region Code";
        VATEntry."VAT Registration No." := "VAT Registration No.";
        VATEntry.Modify;
        Rec := VATEntry;
    end;

    var
        VATEntry: Record "VAT Entry";
}

