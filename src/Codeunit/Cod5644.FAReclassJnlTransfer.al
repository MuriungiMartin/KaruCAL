#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5644 "FA Reclass. Jnl.-Transfer"
{
    TableNo = "FA Reclass. Journal Line";

    trigger OnRun()
    begin
        FAReclassJnlLine.Copy(Rec);
        Code;
        Copy(FAReclassJnlLine);
    end;

    var
        Text000: label 'Do you want to reclassify the journal lines?';
        Text001: label 'There is nothing to reclassify.';
        Text002: label 'The journal lines were successfully reclassified.';
        Text003: label 'The journal lines were successfully reclassified. You are now in the %1 journal.';
        FAReclassJnlTempl: Record "FA Reclass. Journal Template";
        FAReclassJnlLine: Record "FA Reclass. Journal Line";
        JnlBatchName2: Code[10];

    local procedure "Code"()
    begin
        with FAReclassJnlLine do begin
          FAReclassJnlTempl.Get("Journal Template Name");

          if not Confirm(Text000,false) then
            exit;

          JnlBatchName2 := "Journal Batch Name";

          Codeunit.Run(Codeunit::"FA Reclass. Transfer Batch",FAReclassJnlLine);

          if "Line No." = 0 then
            Message(Text001)
          else
            if JnlBatchName2 = "Journal Batch Name" then
              Message(Text002)
            else
              Message(
                Text003,
                "Journal Batch Name");

          if not Find('=><') or (JnlBatchName2 <> "Journal Batch Name") then begin
            Reset;
            FilterGroup := 2;
            SetRange("Journal Template Name","Journal Template Name");
            SetRange("Journal Batch Name","Journal Batch Name");
            FilterGroup := 0;
            "Line No." := 1;
          end;
        end;
    end;
}

