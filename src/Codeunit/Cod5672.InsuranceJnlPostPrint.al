#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5672 "Insurance Jnl.-Post+Print"
{
    TableNo = "Insurance Journal Line";

    trigger OnRun()
    begin
        InsuranceJnlLine.Copy(Rec);
        Code;
        Copy(InsuranceJnlLine);
    end;

    var
        Text000: label 'Do you want to post the journal lines and print the posting report?';
        Text001: label 'There is nothing to post.';
        Text002: label 'The journal lines were successfully posted.';
        Text003: label 'The journal lines were successfully posted. You are now in the %1 journal.';
        InsuranceJnlTempl: Record "Insurance Journal Template";
        InsuranceJnlLine: Record "Insurance Journal Line";
        InsuranceReg: Record "Insurance Register";
        TempJnlBatchName: Code[10];

    local procedure "Code"()
    begin
        with InsuranceJnlLine do begin
          InsuranceJnlTempl.Get("Journal Template Name");
          InsuranceJnlTempl.TestField("Posting Report ID");

          if not Confirm(Text000,false) then
            exit;

          TempJnlBatchName := "Journal Batch Name";

          Codeunit.Run(Codeunit::"Insurance Jnl.-Post Batch",InsuranceJnlLine);

          if InsuranceReg.Get("Line No.") then begin
            InsuranceReg.SetRecfilter;
            Report.Run(InsuranceJnlTempl."Posting Report ID",false,false,InsuranceReg);
          end;

          if "Line No." = 0 then
            Message(Text001)
          else
            if TempJnlBatchName = "Journal Batch Name" then
              Message(Text002)
            else
              Message(
                Text003,
                "Journal Batch Name");

          if not Find('=><') or (TempJnlBatchName <> "Journal Batch Name") then begin
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

