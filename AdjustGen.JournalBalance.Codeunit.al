#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 407 "Adjust Gen. Journal Balance"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        GenJnlLine: Record "Gen. Journal Line";
        PrevGenJnlLine: Record "Gen. Journal Line";
        CorrectionEntry: Boolean;
        TotalAmountLCY: Decimal;
    begin
        TempCurrTotalBuffer.DeleteAll;
        GenJnlLine.SetRange("Journal Template Name","Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name","Journal Batch Name");

        with GenJnlLine do begin
          if not Find('-') then
            exit;
          PrevGenJnlLine := GenJnlLine;
          CorrectionEntry := true;
          repeat
            if ("Posting Date" <> PrevGenJnlLine."Posting Date") or
               ("Document No." <> PrevGenJnlLine."Document No.")
            then begin
              if CheckCurrBalance and (TotalAmountLCY <> 0) then begin
                PrevGenJnlLine.Correction := CorrectionEntry;
                InsertCorrectionLines(GenJnlLine,PrevGenJnlLine);
              end;
              TotalAmountLCY := 0;
              TempCurrTotalBuffer.DeleteAll;
              CorrectionEntry := true;
              PrevGenJnlLine := GenJnlLine;
            end;
            TotalAmountLCY := TotalAmountLCY + "Amount (LCY)";
            if "Bal. Account No." = '' then begin
              if TempCurrTotalBuffer.Get("Currency Code") then begin
                TempCurrTotalBuffer."Total Amount" :=
                  TempCurrTotalBuffer."Total Amount" + Amount;
                TempCurrTotalBuffer."Total Amount (LCY)" :=
                  TempCurrTotalBuffer."Total Amount (LCY)" + "Amount (LCY)";
                TempCurrTotalBuffer.Modify;
              end else begin
                TempCurrTotalBuffer."Currency Code" := "Currency Code";
                TempCurrTotalBuffer."Total Amount" := Amount;
                TempCurrTotalBuffer."Total Amount (LCY)" := "Amount (LCY)";
                TempCurrTotalBuffer.Insert;
              end;
              CorrectionEntry := CorrectionEntry and Correction;
            end;

            if "Document Type" <> PrevGenJnlLine."Document Type" then
              "Document Type" := 0;
            if "Business Unit Code" <> PrevGenJnlLine."Business Unit Code" then
              "Business Unit Code" := '';
            if "Reason Code" <> PrevGenJnlLine."Reason Code" then
              "Reason Code" := '';
            if "Recurring Method" <> PrevGenJnlLine."Recurring Method" then
              "Recurring Method" := 0;
            if "Recurring Frequency" <> PrevGenJnlLine."Recurring Frequency" then
              Evaluate("Recurring Frequency",'<>');

            PrevGenJnlLine := GenJnlLine;
          until Next = 0;

          Clear(PrevGenJnlLine);

          if CheckCurrBalance and (TotalAmountLCY <> 0) then begin
            Correction := CorrectionEntry;
            InsertCorrectionLines(PrevGenJnlLine,GenJnlLine);
          end;
        end;
    end;

    var
        Text000: label 'The program cannot find a key between line number %1 and line number %2.';
        Text002: label 'Rounding correction for %1';
        TempCurrTotalBuffer: Record "Currency Total Buffer" temporary;

    local procedure CheckCurrBalance(): Boolean
    var
        InBalance: Boolean;
    begin
        InBalance := true;
        if TempCurrTotalBuffer.Find('-') then
          repeat
            InBalance := InBalance and (TempCurrTotalBuffer."Total Amount" = 0)
          until (not InBalance) or (TempCurrTotalBuffer.Next = 0);
        exit(InBalance);
    end;

    local procedure InsertCorrectionLines(var GenJnlLine2: Record "Gen. Journal Line";var PrevGenJnlLine2: Record "Gen. Journal Line")
    var
        Currency: Record Currency;
        NewGenJnlLine: Record "Gen. Journal Line";
    begin
        NewGenJnlLine := PrevGenJnlLine2;

        TempCurrTotalBuffer.SetFilter("Currency Code",'<>%1','');
        TempCurrTotalBuffer.SetRange("Total Amount",0);

        if TempCurrTotalBuffer.Find('-') then
          repeat
            Currency.Get(TempCurrTotalBuffer."Currency Code");
            Currency.TestField("Conv. LCY Rndg. Debit Acc.");
            Currency.TestField("Conv. LCY Rndg. Credit Acc.");
            with NewGenJnlLine do begin
              Init;
              if GenJnlLine2."Line No." = 0 then
                "Line No." := "Line No." + 10000
              else
                if GenJnlLine2."Line No." >= "Line No." + 2 then
                  "Line No." := ("Line No." + GenJnlLine2."Line No.") DIV 2
                else
                  Error(
                    StrSubstNo(
                      Text000,
                      PrevGenJnlLine2."Line No.",
                      GenJnlLine2."Line No."));
              "Document Type" := PrevGenJnlLine2."Document Type";
              "Account Type" := "account type"::"G/L Account";
              Correction := PrevGenJnlLine2.Correction;
              if Correction xor (TempCurrTotalBuffer."Total Amount (LCY)" <= 0) then
                Validate("Account No.",Currency."Conv. LCY Rndg. Debit Acc.")
              else
                Validate("Account No.",Currency."Conv. LCY Rndg. Credit Acc.");
              "Posting Date" := PrevGenJnlLine2."Posting Date";
              "Document No." := PrevGenJnlLine2."Document No.";
              Description := StrSubstNo(Text002,TempCurrTotalBuffer."Currency Code");
              Validate(Amount,-TempCurrTotalBuffer."Total Amount (LCY)");
              "Source Code" := PrevGenJnlLine2."Source Code";
              "Business Unit Code" := PrevGenJnlLine2."Business Unit Code";
              "Reason Code" := PrevGenJnlLine2."Reason Code";
              "Recurring Method" := PrevGenJnlLine2."Recurring Method";
              "Recurring Frequency" := PrevGenJnlLine2."Recurring Frequency";
              "Posting No. Series" := PrevGenJnlLine2."Posting No. Series";
              if TempCurrTotalBuffer."Total Amount (LCY)" <> 0 then
                Insert;
            end;
          until TempCurrTotalBuffer.Next = 0;
    end;
}

