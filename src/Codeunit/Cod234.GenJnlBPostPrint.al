#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 234 "Gen. Jnl.-B.Post+Print"
{
    TableNo = "Gen. Journal Batch";

    trigger OnRun()
    begin
        GenJnlBatch.Copy(Rec);
        Code;
        Rec := GenJnlBatch;
    end;

    var
        Text000: label 'Do you want to post the journals and print the report(s)?';
        Text001: label 'The journals were successfully posted.';
        Text002: label 'It was not possible to post all of the journals. ';
        Text003: label 'The journals that were not successfully posted are now marked.';
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GLReg: Record "G/L Register";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        JnlWithErrors: Boolean;

    local procedure "Code"()
    begin
        with GenJnlBatch do begin
          GenJnlTemplate.Get("Journal Template Name");
          if GenJnlTemplate."Force Posting Report" or
             (GenJnlTemplate."Cust. Receipt Report ID" = 0) and (GenJnlTemplate."Vendor Receipt Report ID" = 0)
          then
            GenJnlTemplate.TestField("Posting Report ID");

          if not Confirm(Text000,false) then
            exit;

          Find('-');
          repeat
            GenJnlLine."Journal Template Name" := "Journal Template Name";
            GenJnlLine."Journal Batch Name" := Name;
            GenJnlLine."Line No." := 1;
            Clear(GenJnlPostBatch);
            if GenJnlPostBatch.Run(GenJnlLine) then begin
              Mark(false);
              if GLReg.Get(GenJnlLine."Line No.") then begin
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

