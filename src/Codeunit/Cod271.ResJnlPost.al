#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 271 "Res. Jnl.-Post"
{
    TableNo = "Res. Journal Line";

    trigger OnRun()
    begin
        ResJnlLine.Copy(Rec);
        Code;
        Copy(ResJnlLine);
    end;

    var
        Text000: label 'cannot be filtered when posting recurring journals';
        Text001: label 'Do you want to post the journal lines?';
        Text002: label 'There is nothing to post.';
        Text003: label 'The journal lines were successfully posted.';
        Text004: label 'The journal lines were successfully posted. ';
        Text005: label 'You are now in the %1 journal.';
        ResJnlTemplate: Record "Res. Journal Template";
        ResJnlLine: Record "Res. Journal Line";
        TempJnlBatchName: Code[10];

    local procedure "Code"()
    begin
        with ResJnlLine do begin
          ResJnlTemplate.Get("Journal Template Name");
          ResJnlTemplate.TestField("Force Posting Report",false);
          if ResJnlTemplate.Recurring and (GetFilter("Posting Date") <> '') then
            FieldError("Posting Date",Text000);

          if not Confirm(Text001) then
            exit;

          TempJnlBatchName := "Journal Batch Name";

          Codeunit.Run(Codeunit::"Res. Jnl.-Post Batch",ResJnlLine);

          if "Line No." = 0 then
            Message(Text002)
          else
            if TempJnlBatchName = "Journal Batch Name" then
              Message(Text003)
            else
              Message(
                Text004 +
                Text005,
                "Journal Batch Name");

          if not Find('=><') or (TempJnlBatchName <> "Journal Batch Name") then begin
            Reset;
            FilterGroup(2);
            SetRange("Journal Template Name","Journal Template Name");
            SetRange("Journal Batch Name","Journal Batch Name");
            FilterGroup(0);
            "Line No." := 1;
          end;
        end;
    end;
}

