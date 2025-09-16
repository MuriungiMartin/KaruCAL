#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10100 "Post Sales Tax Jnl"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        GenJnlLine.Copy(Rec);
        Code;
        Copy(GenJnlLine);
    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        ManageSalesTaxJournal: Codeunit "Manage Sales Tax Journal";
        TempJnlBatchName: Code[10];
        Text000: label 'cannot be filtered when posting recurring journals.', Comment='Posting Date cannot be filtered when posting recurring journals.';
        Text001: label 'Do you want to post the journal lines?';
        Text002: label 'There is nothing to post.';
        Text003: label 'The journal lines were successfully posted.';
        Text004: label 'The journal lines were successfully posted. You are now in the %1 journal.';


    procedure "Code"()
    begin
        with GenJnlLine do begin
          GenJnlTemplate.Get("Journal Template Name");
          GenJnlTemplate.TestField("Force Posting Report",false);
          if GenJnlTemplate.Recurring and (GetFilter("Posting Date") <> '') then
            FieldError("Posting Date",Text000);

          if not Confirm(Text001,false) then
            exit;

          TempJnlBatchName := "Journal Batch Name";

          ManageSalesTaxJournal.PostToVAT(GenJnlLine);
          ManageSalesTaxJournal.CreateGenJnlLines(GenJnlLine);
          GenJnlPostBatch.Run(GenJnlLine);

          if "Line No." = 0 then
            Message(Text002)
          else
            if TempJnlBatchName = "Journal Batch Name" then
              Message(Text003)
            else
              Message(
                Text004,
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

