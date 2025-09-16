#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 231 "Gen. Jnl.-Post"
{
    EventSubscriberInstance = Manual;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Copy(Rec);
        Code(GenJnlLine);
        Copy(GenJnlLine);
    end;

    var
        Text000: label 'cannot be filtered when posting recurring journals';
        Text001: label 'Do you want to post the journal lines?';
        Text002: label 'There is nothing to post.';
        Text003: label 'The journal lines were successfully posted.';
        Text004: label 'The journal lines were successfully posted. You are now in the %1 journal.';
        Text005: label 'Using %1 for Declining Balance can result in misleading numbers for subsequent years. You should manually check the postings and correct them if necessary. Do you want to continue?';
        Text006: label '%1 in %2 must not be equal to %3 in %4.', Comment='Source Code in Genenral Journal Template must not be equal to Job G/L WIP in Source Code Setup.';
        PreviewMode: Boolean;

    local procedure "Code"(var GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        FALedgEntry: Record "FA Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        TempJnlBatchName: Code[10];
    begin
        with GenJnlLine do begin
          GenJnlTemplate.Get("Journal Template Name");
          if GenJnlTemplate.Type = GenJnlTemplate.Type::Jobs then begin
            SourceCodeSetup.Get;
            if GenJnlTemplate."Source Code" = SourceCodeSetup."Job G/L WIP" then
              Error(Text006,GenJnlTemplate.FieldCaption("Source Code"),GenJnlTemplate.TableCaption,
                SourceCodeSetup.FieldCaption("Job G/L WIP"),SourceCodeSetup.TableCaption);
          end;
          GenJnlTemplate.TestField("Force Posting Report",false);
          if GenJnlTemplate.Recurring and (GetFilter("Posting Date") <> '') then
            FieldError("Posting Date",Text000);

          if not PreviewMode then
            if not Confirm(Text001,false) then
              Error('Posting cancelled');
        //      //EXIT;

          if "Account Type" = "account type"::"Fixed Asset" then begin
            FALedgEntry.SetRange("FA No.","Account No.");
            FALedgEntry.SetRange("FA Posting Type","fa posting type"::"Acquisition Cost");
            if FALedgEntry.FindFirst and "Depr. Acquisition Cost" then
              if not Confirm(Text005,false,FieldCaption("Depr. Acquisition Cost")) then
                exit;
          end;

          TempJnlBatchName := "Journal Batch Name";

          GenJnlPostBatch.SetPreviewMode(PreviewMode);
          GenJnlPostBatch.Run(GenJnlLine);

          if PreviewMode then
            exit;

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


    procedure Preview(var GenJournalLineSource: Record "Gen. Journal Line")
    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
    begin
        BindSubscription(GenJnlPost);
        GenJnlPostPreview.Preview(GenJnlPost,GenJournalLineSource);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnRunPreview', '', false, false)]
    local procedure OnRunPreview(var Result: Boolean;Subscriber: Variant;RecVar: Variant)
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
    begin
        GenJnlPost := Subscriber;
        GenJournalLine.Copy(RecVar);
        PreviewMode := true;
        Result := GenJnlPost.Run(GenJournalLine);
    end;
}

