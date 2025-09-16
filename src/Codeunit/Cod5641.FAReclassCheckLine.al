#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5641 "FA Reclass. Check Line"
{
    TableNo = "FA Reclass. Journal Line";

    trigger OnRun()
    begin
        if ("FA No." = '') and ("New FA No." = '') then
          exit;
        if ("FA No." = '') and ("New FA No." <> '') then
          TestField("FA No.");
        if ("FA No." <> '') and ("New FA No." = '') then
          TestField("New FA No.");
        TestField("FA Posting Date");
        TestField("FA No.");
        TestField("New FA No.");
        TestField("Depreciation Book Code");
        if DeprBookCode = '' then
          DeprBookCode := "Depreciation Book Code";

        if "Depreciation Book Code" <> DeprBookCode then
          FieldError("Depreciation Book Code",Text000);
    end;

    var
        Text000: label 'must be the same in all journal lines';
        DeprBookCode: Code[10];
}

