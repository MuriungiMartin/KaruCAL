#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 274 "Res. Jnl.-B.Post+Print"
{
    TableNo = "Res. Journal Batch";

    trigger OnRun()
    begin
        ResJnlBatch.Copy(Rec);
        Code;
        Rec := ResJnlBatch;
    end;

    var
        Text000: label 'Do you want to post the journals and print the posting report?';
        Text001: label 'The journals were successfully posted.';
        Text002: label 'It was not possible to post all of the journals. ';
        Text003: label 'The journals that were not successfully posted are now marked.';
        ResJnlTemplate: Record "Res. Journal Template";
        ResJnlBatch: Record "Res. Journal Batch";
        ResJnlLine: Record "Res. Journal Line";
        ResReg: Record "Resource Register";
        ResJnlPostBatch: Codeunit "Res. Jnl.-Post Batch";
        JnlWithErrors: Boolean;

    local procedure "Code"()
    begin
        with ResJnlBatch do begin
          ResJnlTemplate.Get("Journal Template Name");
          ResJnlTemplate.TestField("Posting Report ID");

          if not Confirm(Text000) then
            exit;

          Find('-');
          repeat
            ResJnlLine."Journal Template Name" := "Journal Template Name";
            ResJnlLine."Journal Batch Name" := Name;
            ResJnlLine."Line No." := 1;
            Clear(ResJnlPostBatch);
            if ResJnlPostBatch.Run(ResJnlLine) then begin
              Mark(false);
              if ResReg.Get(ResJnlLine."Line No.") then begin
                ResReg.SetRecfilter;
                Report.Run(ResJnlTemplate."Posting Report ID",false,false,ResReg);
              end;
            end else begin
              Mark(true);
              JnlWithErrors := true;
            end;
          until Next = 0;

          if not JnlWithErrors then
            Message(Text001)
          else
            Message(
              Text002 +
              Text003);

          if not Find('=><') then begin
            Reset;
            Name := '';
          end;
        end;
    end;
}

