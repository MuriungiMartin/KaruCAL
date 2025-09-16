#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1113 "CA Jnl.-Post+Print"
{
    TableNo = "Cost Journal Line";

    trigger OnRun()
    begin
        CostJnlLine.Copy(Rec);
        Code;
        Copy(CostJnlLine);
    end;

    var
        CostJnlLine: Record "Cost Journal Line";
        CostReg: Record "Cost Register";
        CostJnlTemplate: Record "Cost Journal Template";
        Text001: label 'Do you want to post the journal lines?';
        Text002: label 'There is nothing to post.';
        Text003: label 'The journal lines were successfully posted.';
        Text004: label 'The journal lines were successfully posted. You are now in the %1 journal.';

    local procedure "Code"()
    var
        TempJnlBatchName: Code[10];
    begin
        with CostJnlLine do begin
          CostJnlTemplate.Get("Journal Template Name");
          CostJnlTemplate.TestField("Posting Report ID");
          if not Confirm(Text001) then
            exit;

          TempJnlBatchName := "Journal Batch Name";
          Codeunit.Run(Codeunit::"CA Jnl.-Post Batch",CostJnlLine);
          CostReg.Get("Line No.");
          CostReg.SetRecfilter;
          Report.Run(CostJnlTemplate."Posting Report ID",false,false,CostReg);

          if "Line No." = 0 then
            Message(Text002)
          else
            if TempJnlBatchName = "Journal Batch Name" then
              Message(Text003)
            else
              Message(Text004,"Journal Batch Name");

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

