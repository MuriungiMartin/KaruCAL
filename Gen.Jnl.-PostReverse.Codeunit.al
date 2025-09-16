#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 17 "Gen. Jnl.-Post Reverse"
{
    Permissions = TableData "G/L Entry"=m,
                  TableData "Cust. Ledger Entry"=imd,
                  TableData "Vendor Ledger Entry"=imd,
                  TableData "G/L Register"=rm,
                  TableData "G/L Entry - VAT Entry Link"=rimd,
                  TableData "VAT Entry"=imd,
                  TableData "Bank Account Ledger Entry"=imd,
                  TableData "Check Ledger Entry"=imd,
                  TableData "Detailed Cust. Ledg. Entry"=imd,
                  TableData "Detailed Vendor Ledg. Entry"=imd;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
    end;

    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        ReversalMismatchErr: label 'Reversal found a %1 without a matching general ledger entry.';
        CannotReverseErr: label 'You cannot reverse the transaction, because it has already been reversed.';
        DimCombBlockedErr: label 'The combination of dimensions used in general ledger entry %1 is blocked. %2.';


    procedure Reverse(var ReversalEntry: Record "Reversal Entry";var ReversalEntry2: Record "Reversal Entry")
    var
        SourceCodeSetup: Record "Source Code Setup";
        GLEntry: Record "G/L Entry";
        GLEntry2: Record "G/L Entry";
        ReversedGLEntry: Record "G/L Entry";
        GLReg: Record "G/L Register";
        GLReg2: Record "G/L Register";
        GenJnlLine: Record "Gen. Journal Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        VendLedgEntry: Record "Vendor Ledger Entry";
        TempVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        TempBankAccLedgEntry: Record "Bank Account Ledger Entry" temporary;
        VATEntry: Record "VAT Entry";
        FALedgEntry: Record "FA Ledger Entry";
        MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        TempRevertTransactionNo: Record "Integer" temporary;
        TempReversedGLEntry: Record "G/L Entry" temporary;
        FAInsertLedgEntry: Codeunit "FA Insert Ledger Entry";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        NextDtldCustLedgEntryEntryNo: Integer;
        NextDtldVendLedgEntryEntryNo: Integer;
    begin
        SourceCodeSetup.Get;
        if ReversalEntry2."Reversal Type" = ReversalEntry2."reversal type"::Register then
          GLReg2."No." := ReversalEntry2."G/L Register No.";

        ReversalEntry.CopyReverseFilters(
          GLEntry2,CustLedgEntry,VendLedgEntry,BankAccLedgEntry,VATEntry,FALedgEntry,MaintenanceLedgEntry);

        if ReversalEntry2."Reversal Type" = ReversalEntry2."reversal type"::Transaction then begin
          if ReversalEntry2.FindSet(false,false) then
            repeat
              TempRevertTransactionNo.Number := ReversalEntry2."Transaction No.";
              if TempRevertTransactionNo.Insert then;
            until ReversalEntry2.Next = 0;
        end;

        GenJnlLine.Init;
        GenJnlLine."Source Code" := SourceCodeSetup.Reversal;

        if GenJnlPostLine.GetNextEntryNo = 0 then
          GenJnlPostLine.StartPosting(GenJnlLine)
        else
          GenJnlPostLine.ContinuePosting(GenJnlLine);

        GenJnlPostLine.SetGLRegReverse(GLReg);

        CopyCustLedgEntry(CustLedgEntry,TempCustLedgEntry);
        CopyVendLedgEntry(VendLedgEntry,TempVendLedgEntry);
        CopyBankAccLedgEntry(BankAccLedgEntry,TempBankAccLedgEntry);

        if TempRevertTransactionNo.FindSet then;
        repeat
          if ReversalEntry2."Reversal Type" = ReversalEntry2."reversal type"::Transaction then
            GLEntry2.SetRange("Transaction No.",TempRevertTransactionNo.Number);
          with GLEntry2 do
            if Find('+') then
              repeat
                if "Reversed by Entry No." <> 0 then
                  Error(CannotReverseErr);
                CheckDimComb("Entry No.","Dimension Set ID",Database::"G/L Account","G/L Account No.",0,'');
                GLEntry := GLEntry2;
                if "FA Entry No." <> 0 then
                  FAInsertLedgEntry.InsertReverseEntry(
                    GenJnlPostLine.GetNextEntryNo,"FA Entry Type","FA Entry No.",GLEntry."FA Entry No.",
                    GenJnlPostLine.GetNextTransactionNo,ReversalEntry2);
                GLEntry.Amount := -Amount;
                GLEntry.Quantity := -Quantity;
                GLEntry."VAT Amount" := -"VAT Amount";
                GLEntry."Debit Amount" := -"Debit Amount";
                GLEntry."Credit Amount" := -"Credit Amount";
                GLEntry."Additional-Currency Amount" := -"Additional-Currency Amount";
                GLEntry."Add.-Currency Debit Amount" := -"Add.-Currency Debit Amount";
                GLEntry."Add.-Currency Credit Amount" := -"Add.-Currency Credit Amount";
                GLEntry."Entry No." := GenJnlPostLine.GetNextEntryNo;
                GLEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
                GLEntry."User ID" := UserId;
                GenJnlLine.Correction :=
                  (GLEntry."Debit Amount" < 0) or (GLEntry."Credit Amount" < 0) or
                  (GLEntry."Add.-Currency Debit Amount" < 0) or (GLEntry."Add.-Currency Credit Amount" < 0);
                GLEntry."Journal Batch Name" := '';
                GLEntry."Source Code" := GenJnlLine."Source Code";
                SetReversalDescription(
                  ReversalEntry."entry type"::"G/L Account","Entry No.",ReversalEntry2,GLEntry.Description);
                GLEntry."Reversed Entry No." := "Entry No.";
                GLEntry.Reversed := true;
                // Reversal of Reversal
                if "Reversed Entry No." <> 0 then begin
                  ReversedGLEntry.Get("Reversed Entry No.");
                  ReversedGLEntry."Reversed by Entry No." := 0;
                  ReversedGLEntry.Reversed := false;
                  ReversedGLEntry.Modify;
                  "Reversed Entry No." := GLEntry."Entry No.";
                  GLEntry."Reversed by Entry No." := "Entry No.";
                end;
                "Reversed by Entry No." := GLEntry."Entry No.";
                Reversed := true;
                Modify;
                GenJnlPostLine.InsertGLEntry(GenJnlLine,GLEntry,false);
                TempReversedGLEntry := GLEntry;
                TempReversedGLEntry.Insert;

                case true of
                  TempCustLedgEntry.Get("Entry No."):
                    begin
                      CheckDimComb("Entry No.","Dimension Set ID",
                        Database::Customer,TempCustLedgEntry."Customer No.",
                        Database::"Salesperson/Purchaser",TempCustLedgEntry."Salesperson Code");
                      ReverseCustLedgEntry(
                        TempCustLedgEntry,GLEntry."Entry No.",GenJnlLine.Correction,GenJnlLine."Source Code",
                        NextDtldCustLedgEntryEntryNo,ReversalEntry2);
                      TempCustLedgEntry.Delete;
                    end;
                  TempVendLedgEntry.Get("Entry No."):
                    begin
                      CheckDimComb("Entry No.","Dimension Set ID",
                        Database::Vendor,TempVendLedgEntry."Vendor No.",
                        Database::"Salesperson/Purchaser",TempVendLedgEntry."Purchaser Code");
                      ReverseVendLedgEntry(
                        TempVendLedgEntry,GLEntry."Entry No.",GenJnlLine.Correction,GenJnlLine."Source Code",
                        NextDtldVendLedgEntryEntryNo,ReversalEntry2);
                      TempVendLedgEntry.Delete;
                    end;
                  TempBankAccLedgEntry.Get("Entry No."):
                    begin
                      CheckDimComb("Entry No.","Dimension Set ID",
                        Database::"Bank Account",TempBankAccLedgEntry."Bank Account No.",0,'');
                      ReverseBankAccLedgEntry(TempBankAccLedgEntry,GLEntry."Entry No.",GenJnlLine."Source Code",ReversalEntry2);
                      TempBankAccLedgEntry.Delete;
                    end;
                end;
              until Next(-1) = 0;
        until TempRevertTransactionNo.Next = 0;

        if FALedgEntry.FindSet then
          repeat
            FAInsertLedgEntry.CheckFAReverseEntry(FALedgEntry)
          until FALedgEntry.Next = 0;

        if MaintenanceLedgEntry.FindFirst then
          repeat
            FAInsertLedgEntry.CheckMaintReverseEntry(MaintenanceLedgEntry)
          until FALedgEntry.Next = 0;

        FAInsertLedgEntry.FinishFAReverseEntry(GLReg);

        if not TempCustLedgEntry.IsEmpty then
          Error(ReversalMismatchErr,CustLedgEntry.TableCaption);
        if not TempVendLedgEntry.IsEmpty then
          Error(ReversalMismatchErr,VendLedgEntry.TableCaption);
        if not TempBankAccLedgEntry.IsEmpty then
          Error(ReversalMismatchErr,BankAccLedgEntry.TableCaption);

        if ReversalEntry2."Reversal Type" = ReversalEntry2."reversal type"::Transaction then begin
          TempRevertTransactionNo.FindSet;
          repeat
            VATEntry.SetRange("Transaction No.",TempRevertTransactionNo.Number);
            ReverseVAT(VATEntry,TempReversedGLEntry,GenJnlLine."Source Code");
          until TempRevertTransactionNo.Next = 0;
        end else
          ReverseVAT(VATEntry,TempReversedGLEntry,GenJnlLine."Source Code");

        GenJnlPostLine.FinishPosting;

        if GLReg2."No." <> 0 then
          if GLReg2.Get(GLReg2."No.") then begin
            GLReg2.Reversed := true;
            GLReg2.Modify;
          end;

        UpdateAnalysisView.UpdateAll(0,true);
    end;

    local procedure ReverseCustLedgEntry(CustLedgEntry: Record "Cust. Ledger Entry";NewEntryNo: Integer;Correction: Boolean;SourceCode: Code[10];var NextDtldCustLedgEntryEntryNo: Integer;var ReversalEntry: Record "Reversal Entry")
    var
        NewCustLedgEntry: Record "Cust. Ledger Entry";
        ReversedCustLedgEntry: Record "Cust. Ledger Entry";
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        NewDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        with NewCustLedgEntry do begin
          NewCustLedgEntry := CustLedgEntry;
          "Sales (LCY)" := -"Sales (LCY)";
          "Profit (LCY)" := -"Profit (LCY)";
          "Inv. Discount (LCY)" := -"Inv. Discount (LCY)";
          "Original Pmt. Disc. Possible" := -"Original Pmt. Disc. Possible";
          "Pmt. Disc. Given (LCY)" := -"Pmt. Disc. Given (LCY)";
          Positive := not Positive;
          "Adjusted Currency Factor" := "Adjusted Currency Factor";
          "Original Currency Factor" := "Original Currency Factor";
          "Remaining Pmt. Disc. Possible" := -"Remaining Pmt. Disc. Possible";
          "Max. Payment Tolerance" := -"Max. Payment Tolerance";
          "Accepted Payment Tolerance" := -"Accepted Payment Tolerance";
          "Pmt. Tolerance (LCY)" := -"Pmt. Tolerance (LCY)";
          "User ID" := UserId;
          "Entry No." := NewEntryNo;
          "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
          "Journal Batch Name" := '';
          "Source Code" := SourceCode;
          SetReversalDescription(
            ReversalEntry."entry type"::Customer,CustLedgEntry."Entry No.",ReversalEntry,Description);
          "Reversed Entry No." := CustLedgEntry."Entry No.";
          Reversed := true;
          "Applies-to ID" := '';
          // Reversal of Reversal
          if CustLedgEntry."Reversed Entry No." <> 0 then begin
            ReversedCustLedgEntry.Get(CustLedgEntry."Reversed Entry No.");
            ReversedCustLedgEntry."Reversed by Entry No." := 0;
            ReversedCustLedgEntry.Reversed := false;
            ReversedCustLedgEntry.Modify;
            CustLedgEntry."Reversed Entry No." := "Entry No.";
            "Reversed by Entry No." := CustLedgEntry."Entry No.";
          end;
          CustLedgEntry."Applies-to ID" := '';
          CustLedgEntry."Reversed by Entry No." := "Entry No.";
          CustLedgEntry.Reversed := true;
          CustLedgEntry.Modify;
          Insert;

          if NextDtldCustLedgEntryEntryNo = 0 then begin
            DtldCustLedgEntry.FindLast;
            NextDtldCustLedgEntryEntryNo := DtldCustLedgEntry."Entry No." + 1;
          end;
          DtldCustLedgEntry.SetCurrentkey("Cust. Ledger Entry No.");
          DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.",CustLedgEntry."Entry No.");
          DtldCustLedgEntry.SetRange(Unapplied,false);
          DtldCustLedgEntry.FindSet;
          repeat
            DtldCustLedgEntry.TestField("Entry Type",DtldCustLedgEntry."entry type"::"Initial Entry");
            NewDtldCustLedgEntry := DtldCustLedgEntry;
            NewDtldCustLedgEntry.Amount := -NewDtldCustLedgEntry.Amount;
            NewDtldCustLedgEntry."Amount (LCY)" := -NewDtldCustLedgEntry."Amount (LCY)";
            NewDtldCustLedgEntry.UpdateDebitCredit(Correction);
            NewDtldCustLedgEntry."Cust. Ledger Entry No." := NewEntryNo;
            NewDtldCustLedgEntry."User ID" := UserId;
            NewDtldCustLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
            NewDtldCustLedgEntry."Entry No." := NextDtldCustLedgEntryEntryNo;
            NextDtldCustLedgEntryEntryNo := NextDtldCustLedgEntryEntryNo + 1;
            NewDtldCustLedgEntry.Insert(true);
          until DtldCustLedgEntry.Next = 0;

          ApplyCustLedgEntryByReversal(
            CustLedgEntry,NewCustLedgEntry,NewDtldCustLedgEntry,"Entry No.",NextDtldCustLedgEntryEntryNo);
          ApplyCustLedgEntryByReversal(
            NewCustLedgEntry,CustLedgEntry,DtldCustLedgEntry,"Entry No.",NextDtldCustLedgEntryEntryNo);
        end;
    end;

    local procedure ReverseVendLedgEntry(VendLedgEntry: Record "Vendor Ledger Entry";NewEntryNo: Integer;Correction: Boolean;SourceCode: Code[10];var NextDtldVendLedgEntryEntryNo: Integer;var ReversalEntry: Record "Reversal Entry")
    var
        NewVendLedgEntry: Record "Vendor Ledger Entry";
        ReversedVendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        NewDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        with NewVendLedgEntry do begin
          NewVendLedgEntry := VendLedgEntry;
          "Purchase (LCY)" := -"Purchase (LCY)";
          "Inv. Discount (LCY)" := -"Inv. Discount (LCY)";
          "Original Pmt. Disc. Possible" := -"Original Pmt. Disc. Possible";
          "Pmt. Disc. Rcd.(LCY)" := -"Pmt. Disc. Rcd.(LCY)";
          Positive := not Positive;
          "Adjusted Currency Factor" := "Adjusted Currency Factor";
          "Original Currency Factor" := "Original Currency Factor";
          "Remaining Pmt. Disc. Possible" := -"Remaining Pmt. Disc. Possible";
          "Max. Payment Tolerance" := -"Max. Payment Tolerance";
          "Accepted Payment Tolerance" := -"Accepted Payment Tolerance";
          "Pmt. Tolerance (LCY)" := -"Pmt. Tolerance (LCY)";
          "User ID" := UserId;
          "Entry No." := NewEntryNo;
          "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
          "Journal Batch Name" := '';
          "Source Code" := SourceCode;
          SetReversalDescription(
            ReversalEntry."entry type"::Vendor,VendLedgEntry."Entry No.",ReversalEntry,Description);
          "Reversed Entry No." := VendLedgEntry."Entry No.";
          Reversed := true;
          "Applies-to ID" := '';
          // Reversal of Reversal
          if VendLedgEntry."Reversed Entry No." <> 0 then begin
            ReversedVendLedgEntry.Get(VendLedgEntry."Reversed Entry No.");
            ReversedVendLedgEntry."Reversed by Entry No." := 0;
            ReversedVendLedgEntry.Reversed := false;
            ReversedVendLedgEntry.Modify;
            VendLedgEntry."Reversed Entry No." := "Entry No.";
            "Reversed by Entry No." := VendLedgEntry."Entry No.";
          end;
          VendLedgEntry."Applies-to ID" := '';
          VendLedgEntry."Reversed by Entry No." := "Entry No.";
          VendLedgEntry.Reversed := true;
          VendLedgEntry.Modify;
          Insert;

          if NextDtldVendLedgEntryEntryNo = 0 then begin
            DtldVendLedgEntry.FindLast;
            NextDtldVendLedgEntryEntryNo := DtldVendLedgEntry."Entry No." + 1;
          end;
          DtldVendLedgEntry.SetCurrentkey("Vendor Ledger Entry No.");
          DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.",VendLedgEntry."Entry No.");
          DtldVendLedgEntry.SetRange(Unapplied,false);
          DtldVendLedgEntry.FindSet;
          repeat
            DtldVendLedgEntry.TestField("Entry Type",DtldVendLedgEntry."entry type"::"Initial Entry");
            NewDtldVendLedgEntry := DtldVendLedgEntry;
            NewDtldVendLedgEntry.Amount := -NewDtldVendLedgEntry.Amount;
            NewDtldVendLedgEntry."Amount (LCY)" := -NewDtldVendLedgEntry."Amount (LCY)";
            NewDtldVendLedgEntry.UpdateDebitCredit(Correction);
            NewDtldVendLedgEntry."Vendor Ledger Entry No." := NewEntryNo;
            NewDtldVendLedgEntry."User ID" := UserId;
            NewDtldVendLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
            NewDtldVendLedgEntry."Entry No." := NextDtldVendLedgEntryEntryNo;
            NextDtldVendLedgEntryEntryNo := NextDtldVendLedgEntryEntryNo + 1;
            NewDtldVendLedgEntry.Insert(true);
          until DtldVendLedgEntry.Next = 0;

          ApplyVendLedgEntryByReversal(
            VendLedgEntry,NewVendLedgEntry,NewDtldVendLedgEntry,"Entry No.",NextDtldVendLedgEntryEntryNo);
          ApplyVendLedgEntryByReversal(
            NewVendLedgEntry,VendLedgEntry,DtldVendLedgEntry,"Entry No.",NextDtldVendLedgEntryEntryNo);
        end;
    end;

    local procedure ReverseBankAccLedgEntry(BankAccLedgEntry: Record "Bank Account Ledger Entry";NewEntryNo: Integer;SourceCode: Code[10];var ReversalEntry: Record "Reversal Entry")
    var
        NewBankAccLedgEntry: Record "Bank Account Ledger Entry";
        ReversedBankAccLedgEntry: Record "Bank Account Ledger Entry";
    begin
        with NewBankAccLedgEntry do begin
          NewBankAccLedgEntry := BankAccLedgEntry;
          Amount := -Amount;
          "Remaining Amount" := -"Remaining Amount";
          "Amount (LCY)" := -"Amount (LCY)";
          "Debit Amount" := -"Debit Amount";
          "Credit Amount" := -"Credit Amount";
          "Debit Amount (LCY)" := -"Debit Amount (LCY)";
          "Credit Amount (LCY)" := -"Credit Amount (LCY)";
          Positive := not Positive;
          "User ID" := UserId;
          "Entry No." := NewEntryNo;
          "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
          "Journal Batch Name" := '';
          "Source Code" := SourceCode;
          SetReversalDescription(
            ReversalEntry."entry type"::"Bank Account",BankAccLedgEntry."Entry No.",ReversalEntry,Description);
          "Reversed Entry No." := BankAccLedgEntry."Entry No.";
          Reversed := true;
          // Reversal of Reversal
          if BankAccLedgEntry."Reversed Entry No." <> 0 then begin
            ReversedBankAccLedgEntry.Get(BankAccLedgEntry."Reversed Entry No.");
            ReversedBankAccLedgEntry."Reversed by Entry No." := 0;
            ReversedBankAccLedgEntry.Reversed := false;
            ReversedBankAccLedgEntry.Modify;
            BankAccLedgEntry."Reversed Entry No." := "Entry No.";
            "Reversed by Entry No." := BankAccLedgEntry."Entry No.";
          end;
          BankAccLedgEntry."Reversed by Entry No." := "Entry No.";
          BankAccLedgEntry.Reversed := true;
          BankAccLedgEntry.Modify;
          Insert;
        end;
    end;

    local procedure ReverseVAT(var VATEntry: Record "VAT Entry";var TempReversedGLEntry: Record "G/L Entry" temporary;SourceCode: Code[10])
    var
        NewVATEntry: Record "VAT Entry";
        ReversedVATEntry: Record "VAT Entry";
        GLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link";
    begin
        if VATEntry.FindSet then
          repeat
            if VATEntry."Reversed by Entry No." <> 0 then
              Error(CannotReverseErr);
            with NewVATEntry do begin
              NewVATEntry := VATEntry;
              Base := -Base;
              Amount := -Amount;
              "Unrealized Amount" := -"Unrealized Amount";
              "Unrealized Base" := -"Unrealized Base";
              "Remaining Unrealized Amount" := -"Remaining Unrealized Amount";
              "Remaining Unrealized Base" := -"Remaining Unrealized Base";
              "Additional-Currency Amount" := -"Additional-Currency Amount";
              "Additional-Currency Base" := -"Additional-Currency Base";
              "Add.-Currency Unrealized Amt." := -"Add.-Currency Unrealized Amt.";
              "Add.-Curr. Rem. Unreal. Amount" := -"Add.-Curr. Rem. Unreal. Amount";
              "Add.-Curr. Rem. Unreal. Base" := -"Add.-Curr. Rem. Unreal. Base";
              "VAT Difference" := -"VAT Difference";
              "Add.-Curr. VAT Difference" := -"Add.-Curr. VAT Difference";
              "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
              "Source Code" := SourceCode;
              "User ID" := UserId;
              "Entry No." := GenJnlPostLine.GetNextVATEntryNo;
              "Reversed Entry No." := VATEntry."Entry No.";
              Reversed := true;
              // Reversal of Reversal
              if VATEntry."Reversed Entry No." <> 0 then begin
                ReversedVATEntry.Get(VATEntry."Reversed Entry No.");
                ReversedVATEntry."Reversed by Entry No." := 0;
                ReversedVATEntry.Reversed := false;
                ReversedVATEntry.Modify;
                VATEntry."Reversed Entry No." := "Entry No.";
                "Reversed by Entry No." := VATEntry."Entry No.";
              end;
              VATEntry."Reversed by Entry No." := "Entry No.";
              VATEntry.Reversed := true;
              VATEntry.Modify;
              Insert;
              GLEntryVATEntryLink.SetRange("VAT Entry No.",VATEntry."Entry No.");
              if GLEntryVATEntryLink.FindSet then
                repeat
                  TempReversedGLEntry.SetRange("Reversed Entry No.",GLEntryVATEntryLink."G/L Entry No.");
                  if TempReversedGLEntry.FindFirst then
                    GLEntryVATEntryLink.InsertLink(TempReversedGLEntry."Entry No.","Entry No.");
                until GLEntryVATEntryLink.Next = 0;
              GenJnlPostLine.IncrNextVATEntryNo;
            end;
          until VATEntry.Next = 0;
    end;

    local procedure SetReversalDescription(EntryType: Option " ","G/L Account",Customer,Vendor,"Bank Account","Fixed Asset",Maintenance,VAT;EntryNo: Integer;var ReversalEntry: Record "Reversal Entry";var Description: Text[50])
    begin
        ReversalEntry.Reset;
        ReversalEntry.SetRange("Entry Type",EntryType);
        ReversalEntry.SetRange("Entry No.",EntryNo);
        if ReversalEntry.FindFirst then
          Description := ReversalEntry.Description;
    end;

    local procedure ApplyCustLedgEntryByReversal(CustLedgEntry: Record "Cust. Ledger Entry";CustLedgEntry2: Record "Cust. Ledger Entry";DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";AppliedEntryNo: Integer;var NextDtldCustLedgEntryEntryNo: Integer)
    var
        NewDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        CustLedgEntry2.CalcFields("Remaining Amount","Remaining Amt. (LCY)");
        CustLedgEntry."Closed by Entry No." := CustLedgEntry2."Entry No.";
        CustLedgEntry."Closed at Date" := CustLedgEntry2."Posting Date";
        CustLedgEntry."Closed by Amount" := -CustLedgEntry2."Remaining Amount";
        CustLedgEntry."Closed by Amount (LCY)" := -CustLedgEntry2."Remaining Amt. (LCY)";
        CustLedgEntry."Closed by Currency Code" := CustLedgEntry2."Currency Code";
        CustLedgEntry."Closed by Currency Amount" := -CustLedgEntry2."Remaining Amount";
        CustLedgEntry.Open := false;
        CustLedgEntry.Modify;

        NewDtldCustLedgEntry := DtldCustLedgEntry2;
        NewDtldCustLedgEntry."Cust. Ledger Entry No." := CustLedgEntry."Entry No.";
        NewDtldCustLedgEntry."Entry Type" := NewDtldCustLedgEntry."entry type"::Application;
        NewDtldCustLedgEntry."Applied Cust. Ledger Entry No." := AppliedEntryNo;
        NewDtldCustLedgEntry."User ID" := UserId;
        NewDtldCustLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        NewDtldCustLedgEntry."Entry No." := NextDtldCustLedgEntryEntryNo;
        NextDtldCustLedgEntryEntryNo := NextDtldCustLedgEntryEntryNo + 1;
        NewDtldCustLedgEntry.Insert(true);
    end;

    local procedure ApplyVendLedgEntryByReversal(VendLedgEntry: Record "Vendor Ledger Entry";VendLedgEntry2: Record "Vendor Ledger Entry";DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";AppliedEntryNo: Integer;var NextDtldVendLedgEntryEntryNo: Integer)
    var
        NewDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        VendLedgEntry2.CalcFields("Remaining Amount","Remaining Amt. (LCY)");
        VendLedgEntry."Closed by Entry No." := VendLedgEntry2."Entry No.";
        VendLedgEntry."Closed at Date" := VendLedgEntry2."Posting Date";
        VendLedgEntry."Closed by Amount" := -VendLedgEntry2."Remaining Amount";
        VendLedgEntry."Closed by Amount (LCY)" := -VendLedgEntry2."Remaining Amt. (LCY)";
        VendLedgEntry."Closed by Currency Code" := VendLedgEntry2."Currency Code";
        VendLedgEntry."Closed by Currency Amount" := -VendLedgEntry2."Remaining Amount";
        VendLedgEntry.Open := false;
        VendLedgEntry.Modify;

        NewDtldVendLedgEntry := DtldVendLedgEntry2;
        NewDtldVendLedgEntry."Vendor Ledger Entry No." := VendLedgEntry."Entry No.";
        NewDtldVendLedgEntry."Entry Type" := NewDtldVendLedgEntry."entry type"::Application;
        NewDtldVendLedgEntry."Applied Vend. Ledger Entry No." := AppliedEntryNo;
        NewDtldVendLedgEntry."User ID" := UserId;
        NewDtldVendLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        NewDtldVendLedgEntry."Entry No." := NextDtldVendLedgEntryEntryNo;
        NextDtldVendLedgEntryEntryNo := NextDtldVendLedgEntryEntryNo + 1;
        NewDtldVendLedgEntry.Insert(true);
    end;

    local procedure CheckDimComb(EntryNo: Integer;DimSetID: Integer;TableID1: Integer;AccNo1: Code[20];TableID2: Integer;AccNo2: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
        TableID: array [10] of Integer;
        AccNo: array [10] of Code[20];
    begin
        if not DimMgt.CheckDimIDComb(DimSetID) then
          Error(DimCombBlockedErr,EntryNo,DimMgt.GetDimCombErr);
        Clear(TableID);
        Clear(AccNo);
        TableID[1] := TableID1;
        AccNo[1] := AccNo1;
        TableID[2] := TableID2;
        AccNo[2] := AccNo2;
        if not DimMgt.CheckDimValuePosting(TableID,AccNo,DimSetID) then
          Error(DimMgt.GetDimValuePostingErr);
    end;

    local procedure CopyCustLedgEntry(var CustLedgEntry: Record "Cust. Ledger Entry";var TempCustLedgEntry: Record "Cust. Ledger Entry" temporary)
    begin
        if CustLedgEntry.FindSet then
          repeat
            if CustLedgEntry."Reversed by Entry No." <> 0 then
              Error(CannotReverseErr);
            TempCustLedgEntry := CustLedgEntry;
            TempCustLedgEntry.Insert;
          until CustLedgEntry.Next = 0;
    end;

    local procedure CopyVendLedgEntry(var VendLedgEntry: Record "Vendor Ledger Entry";var TempVendLedgEntry: Record "Vendor Ledger Entry" temporary)
    begin
        if VendLedgEntry.FindSet then
          repeat
            if VendLedgEntry."Reversed by Entry No." <> 0 then
              Error(CannotReverseErr);
            TempVendLedgEntry := VendLedgEntry;
            TempVendLedgEntry.Insert;
          until VendLedgEntry.Next = 0;
    end;

    local procedure CopyBankAccLedgEntry(var BankAccLedgEntry: Record "Bank Account Ledger Entry";var TempBankAccLedgEntry: Record "Bank Account Ledger Entry" temporary)
    begin
        if BankAccLedgEntry.FindSet then
          repeat
            if BankAccLedgEntry."Reversed by Entry No." <> 0 then
              Error(CannotReverseErr);
            TempBankAccLedgEntry := BankAccLedgEntry;
            TempBankAccLedgEntry.Insert;
          until BankAccLedgEntry.Next = 0;
    end;
}

