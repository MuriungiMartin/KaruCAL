#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 232 "Gen. Jnl.-Post+Print"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        GenJnlLine.Copy(Rec);
        Code;
        Copy(GenJnlLine);
    end;

    var
        Text000: label 'cannot be filtered when posting recurring journals';
        Text001: label 'Do you want to post the journal lines and print the report(s)?';
        Text002: label 'There is nothing to post.';
        Text003: label 'The journal lines were successfully posted.';
        Text004: label 'The journal lines were successfully posted. You are now in the %1 journal.';
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlLine: Record "Gen. Journal Line";
        GLReg: Record "G/L Register";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        TempJnlBatchName: Code[10];

    local procedure "Code"()
    begin
        with GenJnlLine do begin
          GenJnlTemplate.Get("Journal Template Name");
          if GenJnlTemplate."Force Posting Report" or
             (GenJnlTemplate."Cust. Receipt Report ID" = 0) and (GenJnlTemplate."Vendor Receipt Report ID" = 0)
          then
            GenJnlTemplate.TestField("Posting Report ID");
          if GenJnlTemplate.Recurring and (GetFilter("Posting Date") <> '') then
            FieldError("Posting Date",Text000);

          if not Confirm(Text001,false) then
            exit;

          TempJnlBatchName := "Journal Batch Name";

          Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch",GenJnlLine);

          if GLReg.Get("Line No.") then begin
            if GenJnlTemplate."Cust. Receipt Report ID" <> 0 then begin
              CustLedgEntry.SetRange("Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
              Report.Run(GenJnlTemplate."Cust. Receipt Report ID",false,false,CustLedgEntry);
            end;
            if GenJnlTemplate."Vendor Receipt Report ID" <> 0 then begin
              VendLedgEntry.SetRange("Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
              Report.Run(GenJnlTemplate."Vendor Receipt Report ID",false,false,VendLedgEntry);
            end;
            if GenJnlTemplate."Posting Report ID" <> 0 then begin
              GLReg.SetRecfilter;
              Report.Run(GenJnlTemplate."Posting Report ID",false,false,GLReg);
            end;
          end;

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

