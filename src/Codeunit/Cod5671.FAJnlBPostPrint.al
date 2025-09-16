#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5671 "FA. Jnl.-B.Post+Print"
{
    TableNo = "FA Journal Batch";

    trigger OnRun()
    begin
        FAJnlBatch.Copy(Rec);
        Code;
        Copy(FAJnlBatch);
    end;

    var
        Text000: label 'Do you want to post the journals and print the posting report?';
        Text001: label 'The journals were successfully posted.';
        Text002: label 'It was not possible to post all of the journals. ';
        Text003: label 'The journals that were not successfully posted are now marked.';
        FAJnlTemplate: Record "FA Journal Template";
        FAJnlBatch: Record "FA Journal Batch";
        FAJnlLine: Record "FA Journal Line";
        FAReg: Record "FA Register";
        JournalWithErrors: Boolean;

    local procedure "Code"()
    begin
        with FAJnlBatch do begin
          FAJnlTemplate.Get("Journal Template Name");
          FAJnlTemplate.TestField("Posting Report ID");
          FAJnlTemplate.TestField("Maint. Posting Report ID");

          if not Confirm(Text000,false) then
            exit;

          Find('-');
          repeat
            FAJnlLine."Journal Template Name" := "Journal Template Name";
            FAJnlLine."Journal Batch Name" := Name;
            FAJnlLine."Line No." := 1;
            if Codeunit.Run(Codeunit::"FA Jnl.-Post Batch",FAJnlLine) then begin
              if FAReg.Get(FAJnlLine."Line No.") then begin
                FAReg.SetRecfilter;
                if FAReg."From Entry No." > 0 then
                  Report.Run(FAJnlTemplate."Posting Report ID",false,false,FAReg);
                if FAReg."From Maintenance Entry No." > 0 then
                  Report.Run(FAJnlTemplate."Maint. Posting Report ID",false,false,FAReg);
              end;
              Mark(false);
            end
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

