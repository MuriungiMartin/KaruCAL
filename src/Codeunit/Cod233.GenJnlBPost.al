#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 233 "Gen. Jnl.-B.Post"
{
    TableNo = "Gen. Journal Batch";

    trigger OnRun()
    begin
        GenJnlBatch.Copy(Rec);
        Code;
        Copy(GenJnlBatch);
    end;

    var
        Text000: label 'Do you want to post the journals?';
        Text001: label 'The journals were successfully posted.';
        Text002: label 'It was not possible to post all of the journals. ';
        Text003: label 'The journals that were not successfully posted are now marked.';
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        JnlWithErrors: Boolean;

    local procedure "Code"()
    begin
        with GenJnlBatch do begin
          GenJnlTemplate.Get("Journal Template Name");
          GenJnlTemplate.TestField("Force Posting Report",false);

          if not Confirm(Text000,false) then
            exit;

          Find('-');
          repeat
            GenJnlLine.SetRange("Journal Template Name","Journal Template Name");
            GenJnlLine.SetRange("Journal Batch Name",Name);
            if GenJnlLine.FindFirst then begin
              Clear(GenJnlPostBatch);
              if GenJnlPostBatch.Run(GenJnlLine) then
                Mark(false)
              else begin
                Mark(true);
                JnlWithErrors := true;
              end;
            end;
          until Next = 0;

          if not JnlWithErrors then
            Message(Text001)
          else begin
            MarkedOnly(true);
            Message(
              Text002 +
              Text003);
          end;

          if not Find('=><') then begin
            Reset;
            FilterGroup(2);
            SetRange("Journal Template Name","Journal Template Name");
            FilterGroup(0);
            Name := '';
          end;
        end;
    end;
}

