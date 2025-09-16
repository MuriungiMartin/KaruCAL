#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5637 "FA. Jnl.-B.Post"
{
    TableNo = "FA Journal Batch";

    trigger OnRun()
    begin
        FAJnlBatch.Copy(Rec);
        Code;
        Copy(FAJnlBatch);
    end;

    var
        Text000: label 'Do you want to post the journals?';
        Text001: label 'The journals were successfully posted.';
        Text002: label 'It was not possible to post all of the journals. ';
        Text003: label 'The journals that were not successfully posted are now marked.';
        FAJnlTemplate: Record "FA Journal Template";
        FAJnlBatch: Record "FA Journal Batch";
        FAJnlLine: Record "FA Journal Line";
        FAJnlPostBatch: Codeunit "FA Jnl.-Post Batch";
        JournalWithErrors: Boolean;

    local procedure "Code"()
    begin
        with FAJnlBatch do begin
          FAJnlTemplate.Get("Journal Template Name");
          FAJnlTemplate.TestField("Force Posting Report",false);

          if not Confirm(Text000,false) then
            exit;

          Find('-');
          repeat
            FAJnlLine."Journal Template Name" := "Journal Template Name";
            FAJnlLine."Journal Batch Name" := Name;
            FAJnlLine."Line No." := 1;
            Clear(FAJnlPostBatch);
            if FAJnlPostBatch.Run(FAJnlLine) then
              Mark(false)
            else begin
              Mark(true);
              JournalWithErrors := true;
            end;
          until Next = 0;

          if not JournalWithErrors then
            Message(Text001)
          else
            Message(
              Text002 +
              Text003);

          if not Find('=><') then begin
            Reset;
            FilterGroup := 2;
            SetRange("Journal Template Name","Journal Template Name");
            FilterGroup := 0;
            Name := '';
          end;
        end;
    end;
}

