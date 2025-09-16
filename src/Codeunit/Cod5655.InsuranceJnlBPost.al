#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5655 "Insurance Jnl.-B.Post"
{
    TableNo = "Insurance Journal Batch";

    trigger OnRun()
    begin
        InsuranceJnlBatch.Copy(Rec);
        Code;
        Copy(InsuranceJnlBatch);
    end;

    var
        Text000: label 'Do you want to post the journals?';
        Text001: label 'The journals were successfully posted.';
        Text002: label 'It was not possible to post all of the journals. ';
        Text003: label 'The journals that were not successfully posted are now marked.';
        InsuranceJnlTempl: Record "Insurance Journal Template";
        InsuranceJnlBatch: Record "Insurance Journal Batch";
        InsuranceJnlLine: Record "Insurance Journal Line";
        InsuranceJnlPostBatch: Codeunit "Insurance Jnl.-Post Batch";
        JournalWithErrors: Boolean;

    local procedure "Code"()
    begin
        with InsuranceJnlBatch do begin
          InsuranceJnlTempl.Get("Journal Template Name");
          InsuranceJnlTempl.TestField("Force Posting Report",false);

          if not Confirm(Text000,false) then
            exit;

          Find('-');
          repeat
            InsuranceJnlLine."Journal Template Name" := "Journal Template Name";
            InsuranceJnlLine."Journal Batch Name" := Name;
            InsuranceJnlLine."Line No." := 1;

            Clear(InsuranceJnlPostBatch);
            if InsuranceJnlPostBatch.Run(InsuranceJnlLine) then
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

