#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 367 CheckManagement
{
    Permissions = TableData "Cust. Ledger Entry"=rm,
                  TableData "Vendor Ledger Entry"=rm,
                  TableData "Bank Account Ledger Entry"=rm,
                  TableData "Check Ledger Entry"=rim;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Check %1 already exists for this %2.';
        Text001: label 'Voiding check %1.';
        GenJnlLine2: Record "Gen. Journal Line";
        BankAcc: Record "Bank Account";
        BankAccLedgEntry2: Record "Bank Account Ledger Entry";
        CheckLedgEntry2: Record "Check Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        VendorLedgEntry: Record "Vendor Ledger Entry";
        GLEntry: Record "G/L Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        FALedgEntry: Record "FA Ledger Entry";
        BankAccLedgEntry3: Record "Bank Account Ledger Entry";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        NextCheckEntryNo: Integer;
        Text002: label 'You cannot Financially Void checks posted in a non-balancing transaction.';
        AppliesIDCounter: Integer;
        USText000: label '%1 must be either %2 or %3.';
        USText002: label 'Either the %1 or the %2 must refer to a Bank Account.';
        NoAppliedEntryErr: label 'Cannot find an applied entry within the specified filter.';


    procedure InsertCheck(var CheckLedgEntry: Record "Check Ledger Entry";RecordIdToPrint: RecordID)
    begin
        if NextCheckEntryNo = 0 then begin
          CheckLedgEntry2.LockTable;
          CheckLedgEntry2.Reset;
          if CheckLedgEntry2.FindLast then
            NextCheckEntryNo := CheckLedgEntry2."Entry No." + 1
          else
            NextCheckEntryNo := 1;
        end;

        CheckLedgEntry2.Reset;
        CheckLedgEntry2.SetCurrentkey("Bank Account No.","Entry Status","Check No.");
        CheckLedgEntry2.SetRange("Bank Account No.",CheckLedgEntry."Bank Account No.");
        if CheckLedgEntry."Entry Status" = CheckLedgEntry."entry status"::Exported then
          CheckLedgEntry2.SetFilter(
            "Entry Status",'%1|%2|%3',
            CheckLedgEntry2."entry status"::Transmitted,
            CheckLedgEntry2."entry status"::Posted,
            CheckLedgEntry2."entry status"::"Financially Voided")
        else
          CheckLedgEntry2.SetFilter(
            "Entry Status",'%1|%2|%3',
            CheckLedgEntry2."entry status"::Printed,
            CheckLedgEntry2."entry status"::Posted,
            CheckLedgEntry2."entry status"::"Financially Voided");
        CheckLedgEntry2.SetRange("Check No.",CheckLedgEntry."Document No.");
        if CheckLedgEntry2.FindFirst then
          Error(Text000,CheckLedgEntry."Document No.",BankAcc.TableCaption);

        CheckLedgEntry.Open := CheckLedgEntry.Amount <> 0;
        CheckLedgEntry."User ID" := UserId;
        CheckLedgEntry."Entry No." := NextCheckEntryNo;
        CheckLedgEntry."Record ID to Print" := RecordIdToPrint;
        CheckLedgEntry.Insert;
        NextCheckEntryNo := NextCheckEntryNo + 1;
    end;


    procedure VoidCheck(var GenJnlLine: Record "Gen. Journal Line")
    var
        Currency: Record Currency;
        CheckAmountLCY: Decimal;
    begin
        GenJnlLine.TestField("Bank Payment Type",GenJnlLine2."bank payment type"::"Computer Check");
        GenJnlLine.TestField("Check Printed",true);
        GenJnlLine.TestField("Document No.");

        if GenJnlLine."Bal. Account No." = '' then begin
          GenJnlLine."Check Printed" := false;
          GenJnlLine.Delete(true);
        end;

        CheckAmountLCY := GenJnlLine."Amount (LCY)";
        if GenJnlLine."Currency Code" <> '' then
          Currency.Get(GenJnlLine."Currency Code");

        GenJnlLine2.Reset;
        GenJnlLine2.SetCurrentkey("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
        GenJnlLine2.SetRange("Journal Template Name",GenJnlLine."Journal Template Name");
        GenJnlLine2.SetRange("Journal Batch Name",GenJnlLine."Journal Batch Name");
        GenJnlLine2.SetRange("Posting Date",GenJnlLine."Posting Date");
        GenJnlLine2.SetRange("Document No.",GenJnlLine."Document No.");
        if GenJnlLine2.Find('-') then
          repeat
            if (GenJnlLine2."Line No." > GenJnlLine."Line No.") and
               (CheckAmountLCY = -GenJnlLine2."Amount (LCY)") and
               (GenJnlLine2."Currency Code" = '') and (GenJnlLine."Currency Code" <> '') and
               (GenJnlLine2."Account Type" = GenJnlLine2."account type"::"G/L Account") and
               (GenJnlLine2."Account No." in
                [Currency."Conv. LCY Rndg. Debit Acc.",Currency."Conv. LCY Rndg. Credit Acc."]) and
               (GenJnlLine2."Bal. Account No." = '') and not GenJnlLine2."Check Printed"
            then
              GenJnlLine2.Delete // Rounding correction line
            else begin
              if GenJnlLine."Bal. Account No." = '' then begin
                if GenJnlLine2."Account No." = '' then begin
                  GenJnlLine2."Account Type" := GenJnlLine2."account type"::"Bank Account";
                  GenJnlLine2."Account No." := GenJnlLine."Account No.";
                end else begin
                  GenJnlLine2."Bal. Account Type" := GenJnlLine2."account type"::"Bank Account";
                  GenJnlLine2."Bal. Account No." := GenJnlLine."Account No.";
                end;
                GenJnlLine2.Validate(Amount);
                GenJnlLine2."Bank Payment Type" := GenJnlLine."Bank Payment Type";
              end;
              GenJnlLine2."Document No." := '';
              GenJnlLine2."Check Printed" := false;
              GenJnlLine2.UpdateSource;
              GenJnlLine2.Modify;
            end;
          until GenJnlLine2.Next = 0;

        CheckLedgEntry2.Reset;
        CheckLedgEntry2.SetCurrentkey("Bank Account No.","Entry Status","Check No.");
        if GenJnlLine.Amount <= 0 then
          CheckLedgEntry2.SetRange("Bank Account No.",GenJnlLine."Account No.")
        else
          CheckLedgEntry2.SetRange("Bank Account No.",GenJnlLine."Bal. Account No.");
        CheckLedgEntry2.SetRange("Entry Status",CheckLedgEntry2."entry status"::Printed);
        CheckLedgEntry2.SetRange("Check No.",GenJnlLine."Document No.");
        CheckLedgEntry2.FindFirst;
        CheckLedgEntry2."Original Entry Status" := CheckLedgEntry2."Entry Status";
        CheckLedgEntry2."Entry Status" := CheckLedgEntry2."entry status"::Voided;
        CheckLedgEntry2."Positive Pay Exported" := false;
        CheckLedgEntry2.Open := false;
        CheckLedgEntry2.Modify;
    end;


    procedure FinancialVoidCheck(var CheckLedgEntry: Record "Check Ledger Entry")
    var
        VATPostingSetup: Record "VAT Posting Setup";
        Currency: Record Currency;
        ConfirmFinVoid: Page "Confirm Financial Void";
        AmountToVoid: Decimal;
        CheckAmountLCY: Decimal;
        BalanceAmountLCY: Decimal;
        TransactionBalance: Decimal;
    begin
        CheckLedgEntry.TestField("Entry Status",CheckLedgEntry."entry status"::Posted);
        CheckLedgEntry.TestField("Statement Status",CheckLedgEntry."statement status"::Open);
        CheckLedgEntry.TestField("Bal. Account No.");
        BankAcc.Get(CheckLedgEntry."Bank Account No.");
        BankAccLedgEntry2.Get(CheckLedgEntry."Bank Account Ledger Entry No.");
        SourceCodeSetup.Get;
        with GLEntry do begin
          SetCurrentkey("Transaction No.");
          SetRange("Transaction No.",BankAccLedgEntry2."Transaction No.");
          SetRange("Document No.",BankAccLedgEntry2."Document No.");
          CalcSums(Amount);
          TransactionBalance := Amount;
        end;
        if TransactionBalance <> 0 then
          Error(Text002);

        Clear(ConfirmFinVoid);
        ConfirmFinVoid.SetCheckLedgerEntry(CheckLedgEntry);
        if ConfirmFinVoid.RunModal <> Action::Yes then
          exit;

        AmountToVoid := 0;
        with CheckLedgEntry2 do begin
          Reset;
          SetCurrentkey("Bank Account No.","Entry Status","Check No.");
          SetRange("Bank Account No.",CheckLedgEntry."Bank Account No.");
          SetRange("Entry Status",CheckLedgEntry."entry status"::Posted);
          SetRange("Statement Status",CheckLedgEntry."statement status"::Open);
          SetRange("Check No.",CheckLedgEntry."Check No.");
          SetRange("Check Date",CheckLedgEntry."Check Date");
          CalcSums(Amount);
          AmountToVoid := Amount;
        end;

        InitGenJnlLine(
          GenJnlLine2,CheckLedgEntry."Document No.",ConfirmFinVoid.GetVoidDate,
          GenJnlLine2."account type"::"Bank Account",CheckLedgEntry."Bank Account No.",
          StrSubstNo(Text001,CheckLedgEntry."Check No."));
        GenJnlLine2.Validate(Amount,AmountToVoid);
        CheckAmountLCY := GenJnlLine2."Amount (LCY)";
        BalanceAmountLCY := 0;
        GenJnlLine2."Shortcut Dimension 1 Code" := BankAccLedgEntry2."Global Dimension 1 Code";
        GenJnlLine2."Shortcut Dimension 2 Code" := BankAccLedgEntry2."Global Dimension 2 Code";
        GenJnlLine2."Dimension Set ID" := BankAccLedgEntry2."Dimension Set ID";
        GenJnlLine2."Allow Zero-Amount Posting" := true;
        GenJnlPostLine.RunWithCheck(GenJnlLine2);

        // Mark newly posted entry as cleared for bank reconciliation purposes.
        if ConfirmFinVoid.GetVoidDate = CheckLedgEntry."Check Date" then begin
          BankAccLedgEntry3.Reset;
          BankAccLedgEntry3.FindLast;
          BankAccLedgEntry3.Open := false;
          BankAccLedgEntry3."Remaining Amount" := 0;
          BankAccLedgEntry3."Statement Status" := BankAccLedgEntry2."statement status"::Closed;
          BankAccLedgEntry3.Modify;
        end;

        InitGenJnlLine(
          GenJnlLine2,CheckLedgEntry."Document No.",ConfirmFinVoid.GetVoidDate,
          CheckLedgEntry."Bal. Account Type",CheckLedgEntry."Bal. Account No.",
          StrSubstNo(Text001,CheckLedgEntry."Check No."));
        GenJnlLine2.Validate("Currency Code",BankAcc."Currency Code");
        GenJnlLine2."Allow Zero-Amount Posting" := true;
        case CheckLedgEntry."Bal. Account Type" of
          CheckLedgEntry."bal. account type"::"G/L Account":
            with GLEntry do begin
              SetCurrentkey("Transaction No.");
              SetRange("Transaction No.",BankAccLedgEntry2."Transaction No.");
              SetRange("Document No.",BankAccLedgEntry2."Document No.");
              SetRange("Posting Date",BankAccLedgEntry2."Posting Date");
              SetFilter("Entry No.",'<>%1',BankAccLedgEntry2."Entry No.");
              SetRange("G/L Account No.",CheckLedgEntry."Bal. Account No.");
              if FindSet then
                repeat
                  GenJnlLine2.Validate("Account No.","G/L Account No.");
                  GenJnlLine2.Description := StrSubstNo(Text001,CheckLedgEntry."Check No.");
                  GenJnlLine2.Validate(Amount,-Amount - "VAT Amount");
                  BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                  GenJnlLine2."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                  GenJnlLine2."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                  GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                  GenJnlLine2."Gen. Posting Type" := "Gen. Posting Type";
                  GenJnlLine2."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                  GenJnlLine2."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                  GenJnlLine2."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                  GenJnlLine2."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
                  if VATPostingSetup.Get("VAT Bus. Posting Group","VAT Prod. Posting Group") then
                    GenJnlLine2."VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                  GenJnlPostLine.RunWithCheck(GenJnlLine2);
                until Next = 0;
            end;
          CheckLedgEntry."bal. account type"::Customer:
            begin
              if ConfirmFinVoid.GetVoidType = 0 then begin    // Unapply entry
                if UnApplyCustInvoices(CheckLedgEntry,ConfirmFinVoid.GetVoidDate) then
                  GenJnlLine2."Applies-to ID" := CheckLedgEntry."Document No.";
              end;
              with CustLedgEntry do begin
                SetCurrentkey("Transaction No.");
                SetRange("Transaction No.",BankAccLedgEntry2."Transaction No.");
                SetRange("Document No.",BankAccLedgEntry2."Document No.");
                SetRange("Posting Date",BankAccLedgEntry2."Posting Date");
                if FindSet then
                  repeat
                    CalcFields("Original Amount");
                    GenJnlLine2.Validate(Amount,-"Original Amount");
                    GenJnlLine2.Validate("Currency Code","Currency Code");
                    BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                    MakeAppliesID(GenJnlLine2."Applies-to ID",CheckLedgEntry."Document No.");
                    if ConfirmFinVoid.GetVoidType <> 0 then begin
                      GenJnlLine2."Applies-to ID" := CheckLedgEntry."Document No.";
                      "Applies-to ID" := CheckLedgEntry."Document No.";
                      "Amount to Apply" := CheckLedgEntry.Amount;
                      Modify;
                    end;
                    GenJnlLine2."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                    GenJnlLine2."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                    GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                    GenJnlLine2."Source Currency Code" := "Currency Code";
                    GenJnlPostLine.RunWithCheck(GenJnlLine2);
                  until Next = 0;
              end;
            end;
          CheckLedgEntry."bal. account type"::Vendor:
            begin
              if ConfirmFinVoid.GetVoidType = 0 then begin    // Unapply entry
                if UnApplyVendInvoices(CheckLedgEntry,ConfirmFinVoid.GetVoidDate) then
                  GenJnlLine2."Applies-to ID" := CheckLedgEntry."Document No.";
              end;
              with VendorLedgEntry do begin
                SetCurrentkey("Transaction No.");
                SetRange("Transaction No.",BankAccLedgEntry2."Transaction No.");
                SetRange("Document No.",BankAccLedgEntry2."Document No.");
                SetRange("Posting Date",BankAccLedgEntry2."Posting Date");
                if FindSet then
                  repeat
                    CalcFields("Original Amount");
                    GenJnlLine2.Validate(Amount,-"Original Amount");
                    GenJnlLine2.Validate("Currency Code","Currency Code");
                    BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                    MakeAppliesID(GenJnlLine2."Applies-to ID",CheckLedgEntry."Document No.");
                    if ConfirmFinVoid.GetVoidType <> 0 then begin
                      GenJnlLine2."Applies-to ID" := CheckLedgEntry."Document No.";
                      "Applies-to ID" := CheckLedgEntry."Document No.";
                      "Amount to Apply" := CheckLedgEntry.Amount;
                      Modify;
                    end;
                    GenJnlLine2."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                    GenJnlLine2."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                    GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                    GenJnlLine2."Source Currency Code" := "Currency Code";
                    GenJnlPostLine.RunWithCheck(GenJnlLine2);
                  until Next = 0;
              end;
            end;
          CheckLedgEntry."bal. account type"::"Bank Account":
            with BankAccLedgEntry3 do begin
              SetCurrentkey("Transaction No.");
              SetRange("Transaction No.",BankAccLedgEntry2."Transaction No.");
              SetRange("Document No.",BankAccLedgEntry2."Document No.");
              SetRange("Posting Date",BankAccLedgEntry2."Posting Date");
              SetFilter("Entry No.",'<>%1',BankAccLedgEntry2."Entry No.");
              if FindSet then
                repeat
                  GenJnlLine2.Validate(Amount,-Amount);
                  BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                  GenJnlLine2."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                  GenJnlLine2."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                  GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                  GenJnlPostLine.RunWithCheck(GenJnlLine2);
                until Next = 0;
            end;
          CheckLedgEntry."bal. account type"::"Fixed Asset":
            with FALedgEntry do begin
              SetCurrentkey("Transaction No.");
              SetRange("Transaction No.",BankAccLedgEntry2."Transaction No.");
              SetRange("Document No.",BankAccLedgEntry2."Document No.");
              SetRange("Posting Date",BankAccLedgEntry2."Posting Date");
              if FindSet then
                repeat
                  GenJnlLine2.Validate(Amount,-Amount);
                  BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                  GenJnlLine2."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                  GenJnlLine2."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                  GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                  GenJnlPostLine.RunWithCheck(GenJnlLine2);
                until Next = 0;
            end;
          else begin
            GenJnlLine2."Bal. Account Type" := CheckLedgEntry."Bal. Account Type";
            GenJnlLine2.Validate("Bal. Account No.",CheckLedgEntry."Bal. Account No.");
            GenJnlLine2."Shortcut Dimension 1 Code" := '';
            GenJnlLine2."Shortcut Dimension 2 Code" := '';
            GenJnlLine2."Dimension Set ID" := 0;
            GenJnlPostLine.RunWithoutCheck(GenJnlLine2);
          end;
        end;

        if ConfirmFinVoid.GetVoidDate = CheckLedgEntry."Check Date" then begin
          BankAccLedgEntry2.Open := false;
          BankAccLedgEntry2."Remaining Amount" := 0;
          BankAccLedgEntry2."Statement Status" := BankAccLedgEntry2."statement status"::Closed;
          BankAccLedgEntry2.Modify;
        end;

        if CheckAmountLCY + BalanceAmountLCY <> 0 then begin  // rounding error from currency conversion
          Currency.Get(BankAcc."Currency Code");
          Currency.TestField("Conv. LCY Rndg. Debit Acc.");
          Currency.TestField("Conv. LCY Rndg. Credit Acc.");
          GenJnlLine2.Init;
          GenJnlLine2."System-Created Entry" := true;
          GenJnlLine2."Financial Void" := true;
          GenJnlLine2."Document No." := CheckLedgEntry."Document No.";
          GenJnlLine2."Document Type" :=  GetVoidingDocumentType(CheckLedgEntry."Document Type");
          GenJnlLine2."Account Type" := GenJnlLine2."account type"::"G/L Account";
          GenJnlLine2."Posting Date" := ConfirmFinVoid.GetVoidDate;
          if -(CheckAmountLCY + BalanceAmountLCY) > 0 then
            GenJnlLine2.Validate("Account No.",Currency."Conv. LCY Rndg. Debit Acc.")
          else
            GenJnlLine2.Validate("Account No.",Currency."Conv. LCY Rndg. Credit Acc.");
          GenJnlLine2.Validate("Currency Code",BankAcc."Currency Code");
          GenJnlLine2.Description := StrSubstNo(Text001,CheckLedgEntry."Check No.");
          GenJnlLine2."Source Code" := SourceCodeSetup."Financially Voided Check";
          GenJnlLine2."Allow Zero-Amount Posting" := true;
          GenJnlLine2.Validate(Amount,0);
          GenJnlLine2."Amount (LCY)" := -(CheckAmountLCY + BalanceAmountLCY);
          GenJnlLine2."VAT Base Amount (LCY)" := -(CheckAmountLCY + BalanceAmountLCY);
          GenJnlLine2."Shortcut Dimension 1 Code" := BankAccLedgEntry2."Global Dimension 1 Code";
          GenJnlLine2."Shortcut Dimension 2 Code" := BankAccLedgEntry2."Global Dimension 2 Code";
          GenJnlLine2."Dimension Set ID" := BankAccLedgEntry2."Dimension Set ID";
          GenJnlPostLine.RunWithCheck(GenJnlLine2);
        end;

        MarkCheckEntriesVoid(CheckLedgEntry,ConfirmFinVoid.GetVoidDate);
        Commit;
        UpdateAnalysisView.UpdateAll(0,true);
    end;

    local procedure UnApplyVendInvoices(var CheckLedgEntry: Record "Check Ledger Entry";VoidDate: Date): Boolean
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        OrigPaymentVendLedgEntry: Record "Vendor Ledger Entry";
        PaymentDetVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        GenJnlLine3: Record "Gen. Journal Line";
        AppliesID: Code[50];
    begin
        // first, find first original payment line, if any
        BankAccLedgEntry.Get(CheckLedgEntry."Bank Account Ledger Entry No.");
        if CheckLedgEntry."Bal. Account Type" = CheckLedgEntry."bal. account type"::Vendor then begin
          with OrigPaymentVendLedgEntry do begin
            SetCurrentkey("Transaction No.");
            SetRange("Transaction No.",BankAccLedgEntry."Transaction No.");
            SetRange("Document No.",BankAccLedgEntry."Document No.");
            SetRange("Posting Date",BankAccLedgEntry."Posting Date");
            if not FindFirst then
              exit(false);
          end;
        end else
          exit(false);

        AppliesID := CheckLedgEntry."Document No.";

        PaymentDetVendLedgEntry.SetCurrentkey("Vendor Ledger Entry No.","Entry Type","Posting Date");
        PaymentDetVendLedgEntry.SetRange("Vendor Ledger Entry No.",OrigPaymentVendLedgEntry."Entry No.");
        PaymentDetVendLedgEntry.SetRange(Unapplied,false);
        PaymentDetVendLedgEntry.SetFilter("Applied Vend. Ledger Entry No.",'<>%1',0);
        PaymentDetVendLedgEntry.SetRange("Entry Type",PaymentDetVendLedgEntry."entry type"::Application);
        if not PaymentDetVendLedgEntry.FindFirst then
          Error(NoAppliedEntryErr);
        GenJnlLine3."Document No." := OrigPaymentVendLedgEntry."Document No.";
        GenJnlLine3."Posting Date" := VoidDate;
        GenJnlLine3."Account Type" := GenJnlLine3."account type"::Vendor;
        GenJnlLine3."Account No." := OrigPaymentVendLedgEntry."Vendor No.";
        GenJnlLine3.Correction := true;
        GenJnlLine3.Description := StrSubstNo(Text001,CheckLedgEntry."Check No.");
        GenJnlLine3."Shortcut Dimension 1 Code" := OrigPaymentVendLedgEntry."Global Dimension 1 Code";
        GenJnlLine3."Shortcut Dimension 2 Code" := OrigPaymentVendLedgEntry."Global Dimension 2 Code";
        GenJnlLine3."Posting Group" := OrigPaymentVendLedgEntry."Vendor Posting Group";
        GenJnlLine3."Source Type" := GenJnlLine3."source type"::Vendor;
        GenJnlLine3."Source No." := OrigPaymentVendLedgEntry."Vendor No.";
        GenJnlLine3."Source Code" := SourceCodeSetup."Financially Voided Check";
        GenJnlLine3."Source Currency Code" := OrigPaymentVendLedgEntry."Currency Code";
        GenJnlLine3."System-Created Entry" := true;
        GenJnlLine3."Financial Void" := true;
        GenJnlPostLine.UnapplyVendLedgEntry(GenJnlLine3,PaymentDetVendLedgEntry);

        with OrigPaymentVendLedgEntry do begin
          FindSet(true,false);  // re-get the now-modified payment entry.
          repeat                // set up to be applied by upcoming voiding entry.
            MakeAppliesID(AppliesID,CheckLedgEntry."Document No.");
            "Applies-to ID" := AppliesID;
            CalcFields("Remaining Amount");
            "Amount to Apply" := "Remaining Amount";
            "Accepted Pmt. Disc. Tolerance" := false;
            "Accepted Payment Tolerance" := 0;
            Modify;
          until Next = 0;
        end;
        exit(true);
    end;

    local procedure UnApplyCustInvoices(var CheckLedgEntry: Record "Check Ledger Entry";VoidDate: Date): Boolean
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        OrigPaymentCustLedgEntry: Record "Cust. Ledger Entry";
        PaymentDetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        GenJnlLine3: Record "Gen. Journal Line";
        AppliesID: Code[50];
    begin
        // first, find first original payment line, if any
        BankAccLedgEntry.Get(CheckLedgEntry."Bank Account Ledger Entry No.");
        if CheckLedgEntry."Bal. Account Type" = CheckLedgEntry."bal. account type"::Customer then begin
          with OrigPaymentCustLedgEntry do begin
            SetCurrentkey("Transaction No.");
            SetRange("Transaction No.",BankAccLedgEntry."Transaction No.");
            SetRange("Document No.",BankAccLedgEntry."Document No.");
            SetRange("Posting Date",BankAccLedgEntry."Posting Date");
            if not FindFirst then
              exit(false);
          end;
        end else
          exit(false);

        AppliesID := CheckLedgEntry."Document No.";

        PaymentDetCustLedgEntry.SetCurrentkey("Cust. Ledger Entry No.","Entry Type","Posting Date");
        PaymentDetCustLedgEntry.SetRange("Cust. Ledger Entry No.",OrigPaymentCustLedgEntry."Entry No.");
        PaymentDetCustLedgEntry.SetRange(Unapplied,false);
        PaymentDetCustLedgEntry.SetFilter("Applied Cust. Ledger Entry No.",'<>%1',0);
        PaymentDetCustLedgEntry.SetRange("Entry Type",PaymentDetCustLedgEntry."entry type"::Application);
        if not PaymentDetCustLedgEntry.FindFirst then
          Error(NoAppliedEntryErr);
        GenJnlLine3."Document No." := OrigPaymentCustLedgEntry."Document No.";
        GenJnlLine3."Posting Date" := VoidDate;
        GenJnlLine3."Account Type" := GenJnlLine3."account type"::Customer;
        GenJnlLine3."Account No." := OrigPaymentCustLedgEntry."Customer No.";
        GenJnlLine3.Correction := true;
        GenJnlLine3.Description := StrSubstNo(Text001,CheckLedgEntry."Check No.");
        GenJnlLine3."Shortcut Dimension 1 Code" := OrigPaymentCustLedgEntry."Global Dimension 1 Code";
        GenJnlLine3."Shortcut Dimension 2 Code" := OrigPaymentCustLedgEntry."Global Dimension 2 Code";
        GenJnlLine3."Posting Group" := OrigPaymentCustLedgEntry."Customer Posting Group";
        GenJnlLine3."Source Type" := GenJnlLine3."source type"::Customer;
        GenJnlLine3."Source No." := OrigPaymentCustLedgEntry."Customer No.";
        GenJnlLine3."Source Code" := SourceCodeSetup."Financially Voided Check";
        GenJnlLine3."Source Currency Code" := OrigPaymentCustLedgEntry."Currency Code";
        GenJnlLine3."System-Created Entry" := true;
        GenJnlLine3."Financial Void" := true;
        GenJnlPostLine.UnapplyCustLedgEntry(GenJnlLine3,PaymentDetCustLedgEntry);

        with OrigPaymentCustLedgEntry do begin
          FindSet(true,false);  // re-get the now-modified payment entry.
          repeat                // set up to be applied by upcoming voiding entry.
            MakeAppliesID(AppliesID,CheckLedgEntry."Document No.");
            "Applies-to ID" := AppliesID;
            CalcFields("Remaining Amount");
            "Amount to Apply" := "Remaining Amount";
            "Accepted Pmt. Disc. Tolerance" := false;
            "Accepted Payment Tolerance" := 0;
            Modify;
          until Next = 0;
        end;
        exit(true);
    end;

    local procedure MarkCheckEntriesVoid(var OriginalCheckEntry: Record "Check Ledger Entry";VoidDate: Date)
    var
        RelatedCheckEntry: Record "Check Ledger Entry";
        RelatedCheckEntry2: Record "Check Ledger Entry";
    begin
        with RelatedCheckEntry do begin
          Reset;
          SetCurrentkey("Bank Account No.","Entry Status","Check No.");
          SetRange("Bank Account No.",OriginalCheckEntry."Bank Account No.");
          SetRange("Entry Status",OriginalCheckEntry."entry status"::Posted);
          SetRange("Statement Status",OriginalCheckEntry."statement status"::Open);
          SetRange("Check No.",OriginalCheckEntry."Check No.");
          SetRange("Check Date",OriginalCheckEntry."Check Date");
          SetFilter("Entry No.",'<>%1',OriginalCheckEntry."Entry No.");
          if FindSet then
            repeat
              RelatedCheckEntry2 := RelatedCheckEntry;
              RelatedCheckEntry2."Original Entry Status" := "Entry Status";
              RelatedCheckEntry2."Entry Status" := "entry status"::"Financially Voided";
              RelatedCheckEntry2."Positive Pay Exported" := false;
              if VoidDate = OriginalCheckEntry."Check Date" then begin
                RelatedCheckEntry2.Open := false;
                RelatedCheckEntry2."Statement Status" := RelatedCheckEntry2."statement status"::Closed;
              end;
              RelatedCheckEntry2.Modify;
            until Next = 0;
        end;

        with OriginalCheckEntry do begin
          "Original Entry Status" := "Entry Status";
          "Entry Status" := "entry status"::"Financially Voided";
          "Positive Pay Exported" := false;
          if VoidDate = "Check Date" then begin
            Open := false;
            "Statement Status" := "statement status"::Closed;
          end;
          Modify;
        end;
    end;

    local procedure MakeAppliesID(var AppliesID: Code[50];CheckDocNo: Code[20])
    begin
        if AppliesID = '' then
          exit;
        if AppliesID = CheckDocNo then
          AppliesIDCounter := 0;
        AppliesIDCounter := AppliesIDCounter + 1;
        AppliesID :=
          CopyStr(Format(AppliesIDCounter) + CheckDocNo,1,MaxStrLen(AppliesID));
    end;

    local procedure InitGenJnlLine(var GenJnlLine: Record "Gen. Journal Line";DocumentNo: Code[20];PostingDate: Date;AccountType: Option;AccountNo: Code[20];Description: Text[50])
    begin
        GenJnlLine.Init;
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."Financial Void" := true;
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine."Account Type" := AccountType;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine.Validate("Account No.",AccountNo);
        GenJnlLine.Description := Description;
        GenJnlLine."Source Code" := SourceCodeSetup."Financially Voided Check";
    end;

    local procedure GetVoidingDocumentType(OriginalDocumentType: Option): Integer
    begin
        case OriginalDocumentType of
          CheckLedgEntry2."document type"::Payment:
            exit(CheckLedgEntry2."document type"::Refund);
          CheckLedgEntry2."document type"::Refund:
            exit(CheckLedgEntry2."document type"::Payment);
          else
            exit(OriginalDocumentType);
        end;
    end;


    procedure ProcessElectronicPayment(var GenJnlLine: Record "Gen. Journal Line";WhichProcess: Option ,Void,Transmit)
    var
        CheckLedgEntry3: Record "Check Ledger Entry";
        BankAccountNo: Code[20];
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLine3: Record "Gen. Journal Line";
    begin
        if not (GenJnlLine."Bank Payment Type" in
           [GenJnlLine."bank payment type"::"Electronic Payment",
            GenJnlLine."bank payment type"::"Electronic Payment-IAT"])
        then
          GenJnlLine.FieldError("Bank Payment Type");
        GenJnlLine.TestField("Check Exported",true);
        if not (GenJnlLine."Document Type" in [GenJnlLine."document type"::Payment,GenJnlLine."document type"::Refund]) then begin
          GenJnlLine2."Document Type" := GenJnlLine."document type"::Payment;
          GenJnlLine3."Document Type" := GenJnlLine."document type"::Refund;
          Error(USText000,GenJnlLine.FieldCaption("Document Type"),GenJnlLine2."Document Type",
            GenJnlLine3."Document Type");
        end;
        GenJnlLine.TestField("Document No.");
        if GenJnlLine."Account Type" = GenJnlLine."account type"::"Bank Account" then begin
          GenJnlLine.TestField("Account No.");
          BankAccountNo := GenJnlLine."Account No.";
        end else
          if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::"Bank Account" then begin
            GenJnlLine.TestField("Bal. Account No.");
            BankAccountNo := GenJnlLine."Bal. Account No.";
          end else
            Error(USText002,GenJnlLine.FieldCaption("Account Type"),GenJnlLine.FieldCaption("Bal. Account Type"));

        CheckLedgEntry2.Reset;
        CheckLedgEntry2.SetCurrentkey("Bank Account No.","Entry Status","Check No.");
        CheckLedgEntry2.SetRange("Bank Account No.",BankAccountNo);
        CheckLedgEntry2.SetRange("Entry Status",CheckLedgEntry2."entry status"::Exported);
        CheckLedgEntry2.SetRange("Check No.",GenJnlLine."Document No.");
        if CheckLedgEntry2.Find('-') then
          repeat
            CheckLedgEntry3 := CheckLedgEntry2;
            CheckLedgEntry3."Original Entry Status" := CheckLedgEntry3."Entry Status";
            case WhichProcess of
              Whichprocess::Void: begin
                CheckLedgEntry3."Entry Status" := CheckLedgEntry3."entry status"::Voided;
                CheckLedgEntry3."Positive Pay Exported" := false;
              end;
              Whichprocess::Transmit:
                CheckLedgEntry3."Entry Status" := CheckLedgEntry3."entry status"::Transmitted;
            end;
            CheckLedgEntry3.Modify;
          until CheckLedgEntry2.Next = 0;
    end;
}

