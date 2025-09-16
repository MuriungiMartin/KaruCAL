#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1255 "Match Bank Payments"
{
    TableNo = "Bank Acc. Reconciliation Line";

    trigger OnRun()
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccReconciliationLine.Copy(Rec);

        Code(BankAccReconciliationLine);

        Rec := BankAccReconciliationLine;
    end;

    var
        MatchSummaryMsg: label '%1 payment lines out of %2 are applied.\\';
        BankAccount: Record "Bank Account";
        TempBankPmtApplRule: Record "Bank Pmt. Appl. Rule" temporary;
        TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary;
        TextMapperRulesOverridenTxt: label '%1 text mapper rules could be applied. They were overridden because a record with the %2 match confidence was found.';
        MultipleEntriesWithSilarConfidenceFoundTxt: label 'There are %1 ledger entries that this statement line could be applied to with the same confidence.';
        MultipleStatementLinesWithSameConfidenceFoundTxt: label 'There are %1 alternative statement lines that could be applied to the same ledger entry with the same confidence.';
        OneToManyTempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary;
        TempBankStmtMultipleMatchLine: Record "Bank Stmt Multiple Match Line" temporary;
        TempCustomerLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary;
        TempVendorLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary;
        TempBankAccLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary;
        ApplyEntries: Boolean;
        CannotApplyDocumentNoOneToManyApplicationTxt: label 'Document No. %1 was not applied because the transaction amount was insufficient.';
        UsePaymentDiscounts: Boolean;
        MinimumMatchScore: Integer;
        MatchingStmtLinesMsg: label 'The matching of statement lines to open ledger entries is in progress.\\Please wait while the operation is being completed.\\#1####### @2@@@@@@@@@@@@@';
        ProcessedStmtLinesMsg: label 'Processed %1 out of %2 lines.';
        CreatingAppliedEntriesMsg: label 'The application of statement lines to open ledger entries is in progress. Please wait while the operation is being completed.';
        ProgressBarMsg: label 'Please wait while the operation is being completed.';
        MustChooseAccountErr: label 'You must choose an account to transfer the difference to.';
        LineSplitTxt: label 'The value in the Transaction Amount field has been reduced by %1. A new line with %1 in the Transaction Amount field has been created.', Comment='%1 - Difference';


    procedure "Code"(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    begin
        if BankAccReconciliationLine.IsEmpty then
          exit;

        MapLedgerEntriesToStatementLines(BankAccReconciliationLine);

        if ApplyEntries then
          ApplyLedgerEntriesToStatementLines(BankAccReconciliationLine);
    end;

    local procedure ApplyLedgerEntriesToStatementLines(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
        Window: Dialog;
    begin
        Window.Open(CreatingAppliedEntriesMsg);
        BankAccReconciliation.Get(
          BankAccReconciliationLine."Statement Type",BankAccReconciliationLine."Bank Account No.",
          BankAccReconciliationLine."Statement No.");

        DeleteAppliedPaymentEntries(BankAccReconciliation);
        DeletePaymentMatchDetails(BankAccReconciliation);

        CreateAppliedEntries(BankAccReconciliation);
        UpdatePaymentMatchDetails(BankAccReconciliationLine);
        Window.Close;

        ShowMatchSummary(BankAccReconciliation);
    end;

    local procedure MapLedgerEntriesToStatementLines(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        Window: Dialog;
        TotalNoOfLines: Integer;
        ProcessedLines: Integer;
    begin
        TempBankStatementMatchingBuffer.Reset;
        TempBankStatementMatchingBuffer.DeleteAll;
        TempCustomerLedgerEntryMatchingBuffer.DeleteAll;
        TempVendorLedgerEntryMatchingBuffer.DeleteAll;
        TempBankAccLedgerEntryMatchingBuffer.DeleteAll;

        TempBankPmtApplRule.LoadRules;
        MinimumMatchScore := GetLowestMatchScore;

        BankAccReconciliationLine.SetFilter("Statement Amount",'<>0');
        if BankAccReconciliationLine.FindSet then begin
          InitializeCustomerLedgerEntriesMatchingBuffer(BankAccReconciliationLine,TempCustomerLedgerEntryMatchingBuffer);
          InitializeVendorLedgerEntriesMatchingBuffer(BankAccReconciliationLine,TempVendorLedgerEntryMatchingBuffer);
          InitializeBankAccLedgerEntriesMatchingBuffer(BankAccReconciliationLine,TempBankAccLedgerEntryMatchingBuffer);

          TotalNoOfLines := BankAccReconciliationLine.Count;
          ProcessedLines := 0;

          if ApplyEntries then
            Window.Open(MatchingStmtLinesMsg)
          else
            Window.Open(ProgressBarMsg);

          repeat
            FindMatchingEntries(
              BankAccReconciliationLine,TempCustomerLedgerEntryMatchingBuffer,TempBankStatementMatchingBuffer."account type"::Customer);
            FindMatchingEntries(
              BankAccReconciliationLine,TempVendorLedgerEntryMatchingBuffer,TempBankStatementMatchingBuffer."account type"::Vendor);
            FindMatchingEntries(
              BankAccReconciliationLine,
              TempBankAccLedgerEntryMatchingBuffer,TempBankStatementMatchingBuffer."account type"::"Bank Account");
            FindTextMappings(BankAccReconciliationLine);
            ProcessedLines += 1;

            if ApplyEntries then begin
              Window.Update(1,StrSubstNo(ProcessedStmtLinesMsg,ProcessedLines,TotalNoOfLines));
              Window.Update(2,ROUND(ProcessedLines / TotalNoOfLines * 10000,1));
            end;
          until BankAccReconciliationLine.Next = 0;

          UpdateOneToManyMatches(BankAccReconciliationLine);

          Window.Close;
        end;
    end;


    procedure RerunTextMapper(BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        AppliedPaymentEntry: Record "Applied Payment Entry";
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
    begin
        if BankAccReconciliationLine.IsEmpty then
          exit;

        BankAccReconciliationLine.SetRange("Statement Type",BankAccReconciliationLine."statement type"::"Payment Application");
        BankAccReconciliationLine.SetRange("Bank Account No.",BankAccReconciliationLine."Bank Account No.");
        BankAccReconciliationLine.SetRange("Statement No.",BankAccReconciliationLine."Statement No.");
        BankAccReconciliationLine.SetFilter("Match Confidence",'<>%1 & <>%2',
          BankAccReconciliationLine."match confidence"::Accepted,BankAccReconciliationLine."match confidence"::High);

        if BankAccReconciliationLine.FindSet then begin
          BankAccReconciliation.Get(
            BankAccReconciliationLine."Statement Type",BankAccReconciliationLine."Bank Account No.",
            BankAccReconciliationLine."Statement No.");
          repeat
            SetFilterToBankAccReconciliation(AppliedPaymentEntry,BankAccReconciliationLine);
            if FindTextMappings(BankAccReconciliationLine) then begin
              BankAccReconciliationLine.RejectAppliedPayment;
              CreateAppliedEntries(BankAccReconciliation);
            end;
          until BankAccReconciliationLine.Next = 0;

          // Update match details for lines matched by text mapper
          BankAccReconciliationLine.SetRange(
            "Match Confidence",BankAccReconciliationLine."match confidence"::"High - Text-to-Account Mapping");
          UpdatePaymentMatchDetails(BankAccReconciliationLine);
        end;
    end;


    procedure TransferDiffToAccount(BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";var TempGenJournalLine: Record "Gen. Journal Line" temporary)
    var
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
        TempBankPmtApplRule: Record "Bank Pmt. Appl. Rule" temporary;
        Score: Integer;
        Difference: Decimal;
        TransactionDate: Date;
        LineSplitMsg: Text;
        ParentLineNo: Integer;
        TransactionID: Text[50];
    begin
        if BankAccReconciliationLine.IsEmpty or (BankAccReconciliationLine.Difference = 0) then
          exit;

        TempGenJournalLine.Amount := BankAccReconciliationLine.Difference;
        TempGenJournalLine.Description := BankAccReconciliationLine.Description;
        if not TempGenJournalLine.Insert then
          TempGenJournalLine.Modify;

        if Page.RunModal(Page::"Transfer Difference to Account",TempGenJournalLine) = Action::LookupOK then begin
          if TempGenJournalLine."Account No." = '' then
            Error(MustChooseAccountErr);

          if BankAccReconciliationLine."Statement Amount" <> BankAccReconciliationLine.Difference then begin
            ParentLineNo := GetParentLineNo(BankAccReconciliationLine);
            Difference := BankAccReconciliationLine.Difference;
            LineSplitMsg := StrSubstNo(LineSplitTxt,Difference);
            TransactionDate := BankAccReconciliationLine."Transaction Date";
            TransactionID := BankAccReconciliationLine."Transaction ID";
            BankAccReconciliationLine."Statement Amount" := BankAccReconciliationLine."Applied Amount";
            BankAccReconciliationLine.Difference := 0;
            BankAccReconciliationLine.Modify;

            BankAccReconciliationLine.Init;
            BankAccReconciliationLine."Statement Line No." := GetAvailableSplitLineNo(BankAccReconciliationLine,ParentLineNo);
            BankAccReconciliationLine."Parent Line No." := ParentLineNo;
            BankAccReconciliationLine.Description := TempGenJournalLine.Description;
            BankAccReconciliationLine."Transaction Text" := TempGenJournalLine.Description;
            BankAccReconciliationLine."Transaction Date" := TransactionDate;
            BankAccReconciliationLine."Statement Amount" := Difference;
            BankAccReconciliationLine.Type := BankAccReconciliationLine.Type::Difference;
            BankAccReconciliationLine."Transaction ID" := TransactionID;
            BankAccReconciliationLine.Insert;
          end;

          BankAccReconciliation.Get(
            BankAccReconciliationLine."Statement Type",BankAccReconciliationLine."Bank Account No.",
            BankAccReconciliationLine."Statement No.");

          Score := TempBankPmtApplRule.GetTextMapperScore;
          TempBankStatementMatchingBuffer.AddMatchCandidate(
            BankAccReconciliationLine."Statement Line No.",-1,
            Score,TempGenJournalLine."Account Type",TempGenJournalLine."Account No.");
          CreateAppliedEntries(BankAccReconciliation);

          BankAccReconciliationLine.SetManualApplication;
          BankAccReconciliationLine.SetRange("Statement Type",BankAccReconciliationLine."statement type"::"Payment Application");
          BankAccReconciliationLine.SetRange("Bank Account No.",BankAccReconciliationLine."Bank Account No.");
          BankAccReconciliationLine.SetRange("Statement No.",BankAccReconciliationLine."Statement No.");
          BankAccReconciliationLine.SetRange("Statement Line No.",BankAccReconciliationLine."Statement Line No.");
          UpdatePaymentMatchDetails(BankAccReconciliationLine);
          if LineSplitMsg <> '' then
            Message(LineSplitMsg);
        end;
    end;


    procedure MatchSingleLineCustomer(var BankPmtApplRule: Record "Bank Pmt. Appl. Rule";BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";AppliesToEntryNo: Integer;var NoOfLedgerEntriesWithinTolerance: Integer;var NoOfLedgerEntriesOutsideTolerance: Integer)
    var
        MinAmount: Decimal;
        MaxAmount: Decimal;
        AccountNo: Code[20];
    begin
        ApplyEntries := false;
        InitializeCustomerLedgerEntriesMatchingBuffer(BankAccReconciliationLine,TempCustomerLedgerEntryMatchingBuffer);
        if TempCustomerLedgerEntryMatchingBuffer.Get(AppliesToEntryNo,TempCustomerLedgerEntryMatchingBuffer."account type"::Customer) then;

        FindMatchingEntry(
          TempCustomerLedgerEntryMatchingBuffer,BankAccReconciliationLine,TempBankStatementMatchingBuffer."account type"::Customer,
          BankPmtApplRule);

        AccountNo := TempCustomerLedgerEntryMatchingBuffer."Account No.";
        BankAccReconciliationLine.GetAmountRangeForTolerance(MinAmount,MaxAmount);
        TempCustomerLedgerEntryMatchingBuffer.Reset;
        TempCustomerLedgerEntryMatchingBuffer.SetRange("Account No.",AccountNo);
        NoOfLedgerEntriesWithinTolerance :=
          TempCustomerLedgerEntryMatchingBuffer.GetNoOfLedgerEntriesWithinRange(
            MinAmount,MaxAmount,BankAccReconciliationLine."Transaction Date",UsePaymentDiscounts);
        NoOfLedgerEntriesOutsideTolerance :=
          TempCustomerLedgerEntryMatchingBuffer.GetNoOfLedgerEntriesOutsideRange(
            MinAmount,MaxAmount,BankAccReconciliationLine."Transaction Date",UsePaymentDiscounts);
    end;


    procedure MatchSingleLineVendor(var BankPmtApplRule: Record "Bank Pmt. Appl. Rule";BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";AppliesToEntryNo: Integer;var NoOfLedgerEntriesWithinTolerance: Integer;var NoOfLedgerEntriesOutsideTolerance: Integer)
    var
        MinAmount: Decimal;
        MaxAmount: Decimal;
        AccountNo: Code[20];
    begin
        ApplyEntries := false;
        InitializeVendorLedgerEntriesMatchingBuffer(BankAccReconciliationLine,TempVendorLedgerEntryMatchingBuffer);
        if not TempVendorLedgerEntryMatchingBuffer.Get(AppliesToEntryNo,TempVendorLedgerEntryMatchingBuffer."account type"::Vendor) then;

        FindMatchingEntry(
          TempVendorLedgerEntryMatchingBuffer,BankAccReconciliationLine,TempBankStatementMatchingBuffer."account type"::Vendor,
          BankPmtApplRule);

        AccountNo := TempVendorLedgerEntryMatchingBuffer."Account No.";
        BankAccReconciliationLine.GetAmountRangeForTolerance(MinAmount,MaxAmount);
        TempVendorLedgerEntryMatchingBuffer.Reset;
        TempVendorLedgerEntryMatchingBuffer.SetRange("Account No.",AccountNo);

        NoOfLedgerEntriesWithinTolerance :=
          TempVendorLedgerEntryMatchingBuffer.GetNoOfLedgerEntriesWithinRange(
            MinAmount,MaxAmount,BankAccReconciliationLine."Transaction Date",UsePaymentDiscounts);
        NoOfLedgerEntriesOutsideTolerance :=
          TempVendorLedgerEntryMatchingBuffer.GetNoOfLedgerEntriesOutsideRange(
            MinAmount,MaxAmount,BankAccReconciliationLine."Transaction Date",UsePaymentDiscounts);
    end;


    procedure MatchSingleLineBankAccountLedgerEntry(var BankPmtApplRule: Record "Bank Pmt. Appl. Rule";BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";AppliesToEntryNo: Integer;var NoOfLedgerEntriesWithinTolerance: Integer;var NoOfLedgerEntriesOutsideTolerance: Integer)
    var
        MinAmount: Decimal;
        MaxAmount: Decimal;
        AccountNo: Code[20];
    begin
        ApplyEntries := false;
        InitializeBankAccLedgerEntriesMatchingBuffer(BankAccReconciliationLine,TempBankAccLedgerEntryMatchingBuffer);
        with TempBankAccLedgerEntryMatchingBuffer do
          if not Get(AppliesToEntryNo,"account type"::"Bank Account") then;

        FindMatchingEntry(
          TempBankAccLedgerEntryMatchingBuffer,BankAccReconciliationLine,TempBankStatementMatchingBuffer."account type"::"Bank Account",
          BankPmtApplRule);

        AccountNo := TempBankAccLedgerEntryMatchingBuffer."Account No.";
        BankAccReconciliationLine.GetAmountRangeForTolerance(MinAmount,MaxAmount);
        TempBankAccLedgerEntryMatchingBuffer.Reset;
        TempBankAccLedgerEntryMatchingBuffer.SetRange("Account No.",AccountNo);

        NoOfLedgerEntriesWithinTolerance :=
          TempBankAccLedgerEntryMatchingBuffer.GetNoOfLedgerEntriesWithinRange(
            MinAmount,MaxAmount,BankAccReconciliationLine."Transaction Date",false);
        NoOfLedgerEntriesOutsideTolerance :=
          TempBankAccLedgerEntryMatchingBuffer.GetNoOfLedgerEntriesOutsideRange(
            MinAmount,MaxAmount,BankAccReconciliationLine."Transaction Date",false);
    end;

    local procedure FindMatchingEntries(var TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary;var TempLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary;AccountType: Option)
    var
        BankPmtApplRule: Record "Bank Pmt. Appl. Rule";
    begin
        TempLedgerEntryMatchingBuffer.Reset;
        if TempLedgerEntryMatchingBuffer.FindFirst then
          repeat
            FindMatchingEntry(TempLedgerEntryMatchingBuffer,TempBankAccReconciliationLine,AccountType,BankPmtApplRule);
          until TempLedgerEntryMatchingBuffer.Next = 0;
    end;

    local procedure FindMatchingEntry(TempLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary;var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";AccountType: Option;var BankPmtApplRule: Record "Bank Pmt. Appl. Rule")
    var
        Score: Integer;
        RemainingAmount: Decimal;
    begin
        if CanEntriesMatch(
             BankAccReconciliationLine,TempLedgerEntryMatchingBuffer."Remaining Amount",TempLedgerEntryMatchingBuffer."Posting Date")
        then begin
          RelatedPartyMatching(BankPmtApplRule,TempLedgerEntryMatchingBuffer,BankAccReconciliationLine,AccountType);

          if AccountType <> TempBankStatementMatchingBuffer."account type"::"Bank Account" then
            DocumentMatching(BankPmtApplRule,BankAccReconciliationLine,
              TempLedgerEntryMatchingBuffer."Document No.",TempLedgerEntryMatchingBuffer."External Document No.")
          else
            DocumentMatchingForBankLedgerEntry(BankPmtApplRule,BankAccReconciliationLine,TempLedgerEntryMatchingBuffer);

          RemainingAmount := TempLedgerEntryMatchingBuffer.GetApplicableRemainingAmount(BankAccReconciliationLine,UsePaymentDiscounts);
          AmountInclToleranceMatching(
            BankPmtApplRule,BankAccReconciliationLine,AccountType,RemainingAmount);

          Score := TempBankPmtApplRule.GetBestMatchScore(BankPmtApplRule);

          if Score >= MinimumMatchScore then
            TempBankStatementMatchingBuffer.AddMatchCandidate(
              BankAccReconciliationLine."Statement Line No.",TempLedgerEntryMatchingBuffer."Entry No.",
              Score,AccountType,
              TempLedgerEntryMatchingBuffer."Account No.");

          if BankPmtApplRule."Doc. No./Ext. Doc. No. Matched" = BankPmtApplRule."doc. no./ext. doc. no. matched"::Yes then begin
            TempBankStatementMatchingBuffer.InsertOrUpdateOneToManyRule(
              TempLedgerEntryMatchingBuffer,
              BankAccReconciliationLine."Statement Line No.",
              BankPmtApplRule."Related Party Matched",AccountType,
              RemainingAmount);

            TempBankStmtMultipleMatchLine.InsertLine(
              TempLedgerEntryMatchingBuffer,
              BankAccReconciliationLine."Statement Line No.",AccountType);
          end;
        end;
    end;

    local procedure InitializeCustomerLedgerEntriesMatchingBuffer(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";var TempLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        BankAccount.Get(BankAccReconciliationLine."Bank Account No.");
        SalesReceivablesSetup.Get;

        CustLedgerEntry.SetRange(Open,true);
        CustLedgerEntry.SetFilter("Document Type",'%1|%2|%3|%4|%5',
          CustLedgerEntry."document type"::" ",
          CustLedgerEntry."document type"::Invoice,
          CustLedgerEntry."document type"::"Credit Memo",
          CustLedgerEntry."document type"::"Finance Charge Memo",
          CustLedgerEntry."document type"::Reminder);

        if BankAccount.IsInLocalCurrency then begin
          CustLedgerEntry.SetAutocalcFields("Remaining Amt. (LCY)");
          if SalesReceivablesSetup."Appln. between Currencies" = SalesReceivablesSetup."appln. between currencies"::None then begin
            GeneralLedgerSetup.Get;
            CustLedgerEntry.SetFilter("Currency Code",'=%1|=%2','',GeneralLedgerSetup.GetCurrencyCode(''));
          end;
        end else begin
          CustLedgerEntry.SetAutocalcFields("Remaining Amount");
          CustLedgerEntry.SetRange("Currency Code",BankAccount."Currency Code");
        end;

        if CustLedgerEntry.FindSet then
          repeat
            TempLedgerEntryMatchingBuffer.InsertFromCustomerLedgerEntry(
              CustLedgerEntry,BankAccount.IsInLocalCurrency,UsePaymentDiscounts);
          until CustLedgerEntry.Next = 0;
    end;

    local procedure InitializeVendorLedgerEntriesMatchingBuffer(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";var TempLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary)
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        GeneralLedgerSetup: Record "General Ledger Setup";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        BankAccount.Get(BankAccReconciliationLine."Bank Account No.");
        PurchasesPayablesSetup.Get;

        VendorLedgerEntry.SetRange(Open,true);
        VendorLedgerEntry.SetFilter("Document Type",'%1|%2|%3|%4|%5',
          VendorLedgerEntry."document type"::" ",
          VendorLedgerEntry."document type"::Invoice,
          VendorLedgerEntry."document type"::"Credit Memo",
          VendorLedgerEntry."document type"::"Finance Charge Memo",
          VendorLedgerEntry."document type"::Reminder);

        if BankAccount.IsInLocalCurrency then begin
          VendorLedgerEntry.SetAutocalcFields("Remaining Amt. (LCY)");
          if PurchasesPayablesSetup."Appln. between Currencies" = PurchasesPayablesSetup."appln. between currencies"::None then begin
            GeneralLedgerSetup.Get;
            VendorLedgerEntry.SetFilter("Currency Code",'=%1|=%2','',GeneralLedgerSetup.GetCurrencyCode(''));
          end;
        end else begin
          VendorLedgerEntry.SetAutocalcFields("Remaining Amount");
          VendorLedgerEntry.SetRange("Currency Code",BankAccount."Currency Code");
        end;

        if VendorLedgerEntry.FindSet then
          repeat
            TempLedgerEntryMatchingBuffer.InsertFromVendorLedgerEntry(
              VendorLedgerEntry,BankAccount.IsInLocalCurrency,UsePaymentDiscounts);

          until VendorLedgerEntry.Next = 0;
    end;

    local procedure InitializeBankAccLedgerEntriesMatchingBuffer(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";var TempLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary)
    var
        BankAccLedgerEntry: Record "Bank Account Ledger Entry";
        GeneralLedgerSetup: Record "General Ledger Setup";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        BankAccount.Get(BankAccReconciliationLine."Bank Account No.");
        PurchasesPayablesSetup.Get;

        BankAccLedgerEntry.SetRange(Open,true);
        BankAccLedgerEntry.SetRange("Bank Account No.",BankAccReconciliationLine."Bank Account No.");

        if BankAccount.IsInLocalCurrency then
          if PurchasesPayablesSetup."Appln. between Currencies" = PurchasesPayablesSetup."appln. between currencies"::None then begin
            GeneralLedgerSetup.Get;
            BankAccLedgerEntry.SetFilter("Currency Code",'=%1|=%2','',GeneralLedgerSetup.GetCurrencyCode(''));
          end else
            BankAccLedgerEntry.SetRange("Currency Code",BankAccount."Currency Code");

        if BankAccLedgerEntry.FindSet then
          repeat
            TempLedgerEntryMatchingBuffer.InsertFromBankAccLedgerEntry(BankAccLedgerEntry);

          until BankAccLedgerEntry.Next = 0;
    end;

    local procedure FindTextMappings(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"): Boolean
    var
        TextToAccMapping: Record "Text-to-Account Mapping";
        BankAccLedgerEntry: Record "Bank Account Ledger Entry";
        RecordMatchMgt: Codeunit "Record Match Mgt.";
        Nearness: Integer;
        Score: Integer;
        AccountType: Option;
        AccountNo: Code[20];
        EntryNo: Integer;
        TextMapperMatched: Boolean;
    begin
        TextMapperMatched := false;
        if TextToAccMapping.FindSet then
          repeat
            Nearness := RecordMatchMgt.CalculateStringNearness(RecordMatchMgt.Trim(TextToAccMapping."Mapping Text"),
                BankAccReconciliationLine."Transaction Text",StrLen(TextToAccMapping."Mapping Text"),GetNormalizingFactor);

            case TextToAccMapping."Bal. Source Type" of
              TextToAccMapping."bal. source type"::"G/L Account":
                if BankAccReconciliationLine."Statement Amount" >= 0 then
                  AccountNo := TextToAccMapping."Debit Acc. No."
                else
                  AccountNo := TextToAccMapping."Credit Acc. No.";
              else // Customer or Vendor
                AccountNo := TextToAccMapping."Bal. Source No.";
            end;

            if Nearness >= GetExactMatchTreshold then begin
              if FindBankAccLedgerEntry(BankAccLedgerEntry,BankAccReconciliationLine,TextToAccMapping,AccountNo) then begin
                EntryNo := BankAccLedgerEntry."Entry No.";
                AccountType := TempBankStatementMatchingBuffer."account type"::"Bank Account";
                AccountNo := BankAccLedgerEntry."Bank Account No.";
              end else begin
                EntryNo := -TextToAccMapping."Line No."; // mark negative to identify text-mapper
                AccountType := TextToAccMapping."Bal. Source Type";
              end;

              Score := TempBankPmtApplRule.GetTextMapperScore;
              TempBankStatementMatchingBuffer.AddMatchCandidate(
                BankAccReconciliationLine."Statement Line No.",EntryNo,
                Score,AccountType,AccountNo);
              TextMapperMatched := true;
            end;
          until TextToAccMapping.Next = 0;
        exit(TextMapperMatched)
    end;

    local procedure FindBankAccLedgerEntry(var BankAccLedgerEntry: Record "Bank Account Ledger Entry";BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";TextToAccountMapping: Record "Text-to-Account Mapping";BalAccountNo: Code[20]): Boolean
    begin
        with BankAccLedgerEntry do begin
          SetRange("Bank Account No.",BankAccReconciliationLine."Bank Account No.");
          SetRange(Open,true);
          SetRange("Bal. Account Type",TextToAccountMapping."Bal. Source Type");
          SetRange("Bal. Account No.",BalAccountNo);
          SetRange("Remaining Amount",BankAccReconciliationLine."Statement Amount");
          exit(FindFirst);
        end;
    end;

    local procedure CreateAppliedEntries(BankAccReconciliation: Record "Bank Acc. Reconciliation")
    begin
        TempBankStatementMatchingBuffer.Reset;
        TempBankStatementMatchingBuffer.SetCurrentkey(Quality,"No. of Entries");
        TempBankStatementMatchingBuffer.Ascending(false);

        TempBankStmtMultipleMatchLine.SetCurrentkey("Due Date");

        if TempBankStatementMatchingBuffer.FindSet then
          repeat
            ApplyRecords(BankAccReconciliation,TempBankStatementMatchingBuffer);
          until TempBankStatementMatchingBuffer.Next = 0;
    end;

    local procedure ApplyRecords(BankAccReconciliation: Record "Bank Acc. Reconciliation";TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary): Boolean
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        AppliedPaymentEntry: Record "Applied Payment Entry";
    begin
        BankAccReconciliationLine.Get(
          BankAccReconciliation."Statement Type",BankAccReconciliation."Bank Account No.",BankAccReconciliation."Statement No.",
          TempBankStatementMatchingBuffer."Line No.");

        if TempBankStatementMatchingBuffer.Quality = 0 then
          exit(false);

        if StatementLineAlreadyApplied(TempBankStatementMatchingBuffer,BankAccReconciliationLine) then
          exit(false);

        if TempBankStatementMatchingBuffer."One to Many Match" then
          ApplyOneToMany(BankAccReconciliationLine,TempBankStatementMatchingBuffer)
        else begin
          if EntryAlreadyApplied(TempBankStatementMatchingBuffer,BankAccReconciliationLine,TempBankStatementMatchingBuffer."Entry No.")
          then
            if not CanApplyManyToOne(TempBankStatementMatchingBuffer,BankAccReconciliationLine) then
              exit(false);

          AppliedPaymentEntry.ApplyFromBankStmtMatchingBuf(BankAccReconciliationLine,TempBankStatementMatchingBuffer,
            BankAccReconciliationLine."Statement Amount",TempBankStatementMatchingBuffer."Entry No.");
        end;

        exit(true);
    end;

    local procedure ApplyOneToMany(BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary)
    var
        PaymentMatchingDetails: Record "Payment Matching Details";
        AppliedPaymentEntry: Record "Applied Payment Entry";
    begin
        TempBankStmtMultipleMatchLine.SetRange("Line No.",TempBankStatementMatchingBuffer."Line No.");
        TempBankStmtMultipleMatchLine.SetRange("Account Type",TempBankStatementMatchingBuffer."Account Type");
        TempBankStmtMultipleMatchLine.SetRange("Account No.",TempBankStatementMatchingBuffer."Account No.");
        TempBankStmtMultipleMatchLine.FindSet;

        repeat
          AppliedPaymentEntry.TransferFromBankAccReconLine(BankAccReconciliationLine);
          if AppliedPaymentEntry.GetStmtLineRemAmtToApply = 0 then
            PaymentMatchingDetails.CreatePaymentMatchingDetail(BankAccReconciliationLine,
              StrSubstNo(CannotApplyDocumentNoOneToManyApplicationTxt,TempBankStmtMultipleMatchLine."Document No."))
          else begin
            Clear(AppliedPaymentEntry);
            if not EntryAlreadyApplied(
                 TempBankStatementMatchingBuffer,BankAccReconciliationLine,TempBankStmtMultipleMatchLine."Entry No.")
            then
              AppliedPaymentEntry.ApplyFromBankStmtMatchingBuf(BankAccReconciliationLine,TempBankStatementMatchingBuffer,
                BankAccReconciliationLine."Statement Amount",TempBankStmtMultipleMatchLine."Entry No.")
          end;
        until TempBankStmtMultipleMatchLine.Next = 0;
    end;

    local procedure CanEntriesMatch(BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";Amount: Decimal;EntryPostingDate: Date): Boolean
    begin
        if not ApplyEntries then
          exit(true);

        if BankAccReconciliationLine."Statement Amount" * Amount < 0 then
          exit(false);

        if ApplyEntries then begin
          if BankAccReconciliationLine."Transaction Date" < EntryPostingDate then
            exit(false);
        end;

        exit(true);
    end;

    local procedure CanApplyManyToOne(TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary;TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary): Boolean
    var
        AppliedPaymentEntry: Record "Applied Payment Entry";
        HasPositiveApplications: Boolean;
        HasNegativeApplications: Boolean;
    begin
        // Many to one application is possbile if previous applied are for same Account
        SetFilterToRelatedApplications(AppliedPaymentEntry,TempBankStatementMatchingBuffer,
          TempBankAccReconciliationLine);
        if AppliedPaymentEntry.IsEmpty then
          exit(false);

        // Not possible if positive and negative applications already exists
        AppliedPaymentEntry.SetFilter("Applied Amount",'>0');
        HasPositiveApplications := not AppliedPaymentEntry.IsEmpty;
        AppliedPaymentEntry.SetFilter("Applied Amount",'<0');
        HasNegativeApplications := not AppliedPaymentEntry.IsEmpty;
        if HasPositiveApplications and HasNegativeApplications then
          exit(false);

        // Remaining amount should not be 0
        exit(GetRemainingAmount(TempBankStatementMatchingBuffer,TempBankAccReconciliationLine) <> 0);
    end;

    local procedure RelatedPartyMatching(var BankPmtApplRule: Record "Bank Pmt. Appl. Rule";TempLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary;BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";AccountType: Option)
    begin
        case AccountType of
          TempBankStatementMatchingBuffer."account type"::Customer:
            CustomerMatching(BankPmtApplRule,TempLedgerEntryMatchingBuffer."Account No.",BankAccReconciliationLine,AccountType);
          TempBankStatementMatchingBuffer."account type"::Vendor:
            VendorMatching(BankPmtApplRule,TempLedgerEntryMatchingBuffer."Account No.",BankAccReconciliationLine,AccountType);
          TempBankStatementMatchingBuffer."account type"::"Bank Account":
            RelatedPartyMatchingForBankAccLedgEntry(BankPmtApplRule,TempLedgerEntryMatchingBuffer,BankAccReconciliationLine,AccountType);
        end;
    end;

    local procedure CustomerMatching(var BankPmtApplRule: Record "Bank Pmt. Appl. Rule";AccountNo: Code[20];BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";AccountType: Option)
    var
        Customer: Record Customer;
    begin
        if IsCustomerBankAccountMatching(
             BankAccReconciliationLine."Related-Party Bank Acc. No.",AccountNo)
        then begin
          BankPmtApplRule."Related Party Matched" := BankPmtApplRule."related party matched"::Fully;
          exit;
        end;

        Customer.Get(AccountNo);
        RelatedPartyInfoMatching(BankPmtApplRule,BankAccReconciliationLine,Customer.Name,
          Customer.Address + Customer."Address 2",Customer.City,AccountType);
    end;

    local procedure VendorMatching(var BankPmtApplRule: Record "Bank Pmt. Appl. Rule";AccountNo: Code[20];BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";AccountType: Option)
    var
        Vendor: Record Vendor;
    begin
        Vendor.Get(AccountNo);
        if IsVendorBankAccountMatching(BankAccReconciliationLine."Related-Party Bank Acc. No.",Vendor."No.") then begin
          BankPmtApplRule."Related Party Matched" := BankPmtApplRule."related party matched"::Fully;
          exit;
        end;

        RelatedPartyInfoMatching(BankPmtApplRule,BankAccReconciliationLine,Vendor.Name,
          Vendor.Address + Vendor."Address 2",Vendor.City,AccountType);
    end;

    local procedure RelatedPartyMatchingForBankAccLedgEntry(var BankPmtApplRule: Record "Bank Pmt. Appl. Rule";TempLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary;BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";AccountType: Option)
    begin
        case TempLedgerEntryMatchingBuffer."Bal. Account Type" of
          TempLedgerEntryMatchingBuffer."bal. account type"::Customer:
            CustomerMatching(BankPmtApplRule,TempLedgerEntryMatchingBuffer."Bal. Account No.",BankAccReconciliationLine,AccountType);
          TempLedgerEntryMatchingBuffer."bal. account type"::Vendor:
            VendorMatching(BankPmtApplRule,TempLedgerEntryMatchingBuffer."Bal. Account No.",BankAccReconciliationLine,AccountType);
          TempLedgerEntryMatchingBuffer."bal. account type"::"Bank Account",
          TempLedgerEntryMatchingBuffer."bal. account type"::"G/L Account":
            BankPmtApplRule."Related Party Matched" := BankPmtApplRule."related party matched"::No;
        end;
    end;

    local procedure RelatedPartyInfoMatching(var BankPmtApplRule: Record "Bank Pmt. Appl. Rule";BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";Name: Text[50];Address: Text[100];City: Text[30];AccountType: Option)
    var
        USTRNameNearness: Integer;
        STRNameNearness: Integer;
    begin
        BankPmtApplRule."Related Party Matched" := BankPmtApplRule."related party matched"::No;

        // If Strutured text present don't look at unstructured text
        if BankAccReconciliationLine."Related-Party Name" <> '' then begin
          // Use string nearness as names can be reversed, wrongly capitalized, etc
          STRNameNearness := GetStringNearness(BankAccReconciliationLine."Related-Party Name",Name);
          if STRNameNearness >= GetExactMatchTreshold then begin
            BankPmtApplRule."Related Party Matched" := BankPmtApplRule."related party matched"::Partially;

            // City and address should fully match
            if (BankAccReconciliationLine."Related-Party City" = City) and
               (BankAccReconciliationLine."Related-Party Address" = Address)
            then begin
              BankPmtApplRule."Related Party Matched" := BankPmtApplRule."related party matched"::Fully;
              exit;
            end;

            if IsNameUnique(Name,AccountType) then begin
              BankPmtApplRule."Related Party Matched" := BankPmtApplRule."related party matched"::Fully;
              exit;
            end;
          end;

          exit;
        end;

        // Unstructured text is using string nearness since user may shorten the name or mistype
        USTRNameNearness := GetStringNearness(BankAccReconciliationLine."Transaction Text",Name);

        if USTRNameNearness >= GetExactMatchTreshold then begin
          BankPmtApplRule."Related Party Matched" := BankPmtApplRule."related party matched"::Partially;
          if IsNameUnique(Name,AccountType) then begin
            BankPmtApplRule."Related Party Matched" := BankPmtApplRule."related party matched"::Fully;
            exit;
          end;

          exit;
        end;

        if USTRNameNearness >= GetCloseMatchTreshold then
          BankPmtApplRule."Related Party Matched" := BankPmtApplRule."related party matched"::Partially;
    end;

    local procedure DocumentMatching(var BankPmtApplRule: Record "Bank Pmt. Appl. Rule";BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";DocNo: Code[20];ExtDocNo: Code[35])
    var
        SearchText: Text;
    begin
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched" := BankPmtApplRule."doc. no./ext. doc. no. matched"::No;

        SearchText := UpperCase(BankAccReconciliationLine."Transaction Text" + ' ' +
            BankAccReconciliationLine."Additional Transaction Info");

        if DocNoMatching(SearchText,DocNo) then begin
          BankPmtApplRule."Doc. No./Ext. Doc. No. Matched" := BankPmtApplRule."doc. no./ext. doc. no. matched"::Yes;
          exit;
        end;

        if DocNoMatching(SearchText,ExtDocNo) then
          BankPmtApplRule."Doc. No./Ext. Doc. No. Matched" := BankPmtApplRule."doc. no./ext. doc. no. matched"::Yes;
    end;

    local procedure DocumentMatchingForBankLedgerEntry(var BankPmtApplRule: Record "Bank Pmt. Appl. Rule";BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";TempLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustLedgerEntry2: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        VendLedgerEntry2: Record "Vendor Ledger Entry";
        SearchText: Text;
    begin
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched" := BankPmtApplRule."doc. no./ext. doc. no. matched"::No;

        SearchText := UpperCase(BankAccReconciliationLine."Transaction Text" + ' ' +
            BankAccReconciliationLine."Additional Transaction Info");

        if DocNoMatching(SearchText,TempLedgerEntryMatchingBuffer."Document No.") then begin
          BankPmtApplRule."Doc. No./Ext. Doc. No. Matched" := BankPmtApplRule."doc. no./ext. doc. no. matched"::Yes;
          exit;
        end;

        if DocNoMatching(SearchText,TempLedgerEntryMatchingBuffer."External Document No.") then begin
          BankPmtApplRule."Doc. No./Ext. Doc. No. Matched" := BankPmtApplRule."doc. no./ext. doc. no. matched"::Yes;
          exit;
        end;

        CustLedgerEntry.SetRange("Document Type",TempLedgerEntryMatchingBuffer."Document Type");
        CustLedgerEntry.SetRange("Document No.",TempLedgerEntryMatchingBuffer."Document No.");
        CustLedgerEntry.SetRange("Posting Date",TempLedgerEntryMatchingBuffer."Posting Date");
        if CustLedgerEntry.FindSet then
          repeat
            CustLedgerEntry2.SetRange(Open,false);
            CustLedgerEntry2.SetRange("Closed by Entry No.",CustLedgerEntry."Entry No.");
            if CustLedgerEntry2.FindFirst then
              if DocNoMatching(SearchText,CustLedgerEntry2."Document No.") then begin
                BankPmtApplRule."Doc. No./Ext. Doc. No. Matched" := BankPmtApplRule."doc. no./ext. doc. no. matched"::Yes;
                exit;
              end;
          until CustLedgerEntry.Next = 0;

        VendLedgerEntry.SetRange("Document Type",TempLedgerEntryMatchingBuffer."Document Type");
        VendLedgerEntry.SetRange("Document No.",TempLedgerEntryMatchingBuffer."Document No.");
        VendLedgerEntry.SetRange("Posting Date",TempLedgerEntryMatchingBuffer."Posting Date");
        if VendLedgerEntry.FindSet then
          repeat
            VendLedgerEntry2.SetRange(Open,false);
            VendLedgerEntry2.SetRange("Closed by Entry No.",VendLedgerEntry."Entry No.");
            if VendLedgerEntry2.FindFirst then
              if DocNoMatching(SearchText,VendLedgerEntry2."Document No.") then begin
                BankPmtApplRule."Doc. No./Ext. Doc. No. Matched" := BankPmtApplRule."doc. no./ext. doc. no. matched"::Yes;
                exit;
              end;
          until VendLedgerEntry.Next = 0;
    end;

    local procedure DocNoMatching(SearchText: Text;DocNo: Code[35]): Boolean
    var
        Position: Integer;
    begin
        if StrLen(DocNo) < GetMatchLengthTreshold then
          exit(false);

        Position := StrPos(SearchText,DocNo);

        case Position of
          0:
            exit(false);
          1:
            begin
              if StrLen(SearchText) = StrLen(DocNo) then
                exit(true);

              exit(not IsAlphanumeric(SearchText[Position + StrLen(DocNo)]));
            end;
          else begin
            if StrLen(SearchText) < Position + StrLen(DocNo) then
              exit(not IsAlphanumeric(SearchText[Position - 1]));

            exit((not IsAlphanumeric(SearchText[Position - 1])) and
              (not IsAlphanumeric(SearchText[Position + StrLen(DocNo)])));
          end;
        end;

        exit(true);
    end;

    local procedure AmountInclToleranceMatching(var BankPmtApplRule: Record "Bank Pmt. Appl. Rule";BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";AccountType: Option;RemainingAmount: Decimal)
    var
        NoOfEntries: Integer;
        MinAmount: Decimal;
        MaxAmount: Decimal;
    begin
        BankAccReconciliationLine.GetAmountRangeForTolerance(MinAmount,MaxAmount);
        BankPmtApplRule."Amount Incl. Tolerance Matched" := BankPmtApplRule."amount incl. tolerance matched"::"No Matches";

        if (RemainingAmount < MinAmount) or
           (RemainingAmount > MaxAmount)
        then
          exit;

        NoOfEntries := 0;
        BankPmtApplRule."Amount Incl. Tolerance Matched" := BankPmtApplRule."amount incl. tolerance matched"::"Multiple Matches";

        // Check for Multiple Hits for One To Many  matches
        if BankPmtApplRule."Doc. No./Ext. Doc. No. Matched" =
           BankPmtApplRule."doc. no./ext. doc. no. matched"::"Yes - Multiple"
        then begin
          OneToManyTempBankStatementMatchingBuffer.SetFilter("Total Remaining Amount",'>=%1&<=%2',MinAmount,MaxAmount);
          NoOfEntries += OneToManyTempBankStatementMatchingBuffer.Count;

          if NoOfEntries > 1 then
            exit;
        end;

        // Check is a single match for One to One Matches
        case AccountType of
          TempBankStatementMatchingBuffer."account type"::Customer:
            NoOfEntries +=
              TempCustomerLedgerEntryMatchingBuffer.GetNoOfLedgerEntriesWithinRange(
                MinAmount,MaxAmount,BankAccReconciliationLine."Transaction Date",UsePaymentDiscounts);
          TempBankStatementMatchingBuffer."account type"::Vendor:
            NoOfEntries +=
              TempVendorLedgerEntryMatchingBuffer.GetNoOfLedgerEntriesWithinRange(
                MinAmount,MaxAmount,BankAccReconciliationLine."Transaction Date",UsePaymentDiscounts);
          TempBankStatementMatchingBuffer."account type"::"Bank Account":
            NoOfEntries +=
              TempBankAccLedgerEntryMatchingBuffer.GetNoOfLedgerEntriesWithinRange(
                MinAmount,MaxAmount,BankAccReconciliationLine."Transaction Date",false);
        end;

        if NoOfEntries = 1 then
          BankPmtApplRule."Amount Incl. Tolerance Matched" := BankPmtApplRule."amount incl. tolerance matched"::"One Match"
    end;

    local procedure GetStringNearness(Description: Text;CustVendValue: Text): Integer
    var
        RecordMatchMgt: Codeunit "Record Match Mgt.";
    begin
        Description := RecordMatchMgt.Trim(Description);

        exit(RecordMatchMgt.CalculateStringNearness(CustVendValue,Description,GetMatchLengthTreshold,GetNormalizingFactor));
    end;

    local procedure IsCustomerBankAccountMatching(ValueFromBankStatement: Text;CustomerNo: Code[20]): Boolean
    var
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        ValueFromBankStatement := BankAccountNoWithoutSpecialChars(ValueFromBankStatement);
        if ValueFromBankStatement = '' then
          exit(false);

        CustomerBankAccount.SetRange("Customer No.",CustomerNo);
        if CustomerBankAccount.FindSet then
          repeat
            if BankAccountNoWithoutSpecialChars(CustomerBankAccount.GetBankAccountNo) = ValueFromBankStatement then
              exit(true);
          until CustomerBankAccount.Next = 0;

        exit(false);
    end;

    local procedure IsVendorBankAccountMatching(ValueFromBankStatement: Text;VendorNo: Code[20]): Boolean
    var
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        ValueFromBankStatement := BankAccountNoWithoutSpecialChars(ValueFromBankStatement);
        if ValueFromBankStatement = '' then
          exit(false);

        VendorBankAccount.SetRange("Vendor No.",VendorNo);
        if VendorBankAccount.FindSet then
          repeat
            if BankAccountNoWithoutSpecialChars(VendorBankAccount.GetBankAccountNo) = ValueFromBankStatement then
              exit(true);
          until VendorBankAccount.Next = 0;

        exit(false);
    end;

    local procedure BankAccountNoWithoutSpecialChars(Input: Text): Text
    begin
        exit(UpperCase(DelChr(Input,'=',DelChr(UpperCase(Input),'=','ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'))));
    end;

    local procedure StatementLineAlreadyApplied(TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary;TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary): Boolean
    var
        AppliedPaymentEntry: Record "Applied Payment Entry";
    begin
        SetFilterToBankAccReconciliation(AppliedPaymentEntry,TempBankAccReconciliationLine);
        AppliedPaymentEntry.SetRange("Statement Line No.",TempBankStatementMatchingBuffer."Line No.");

        exit(not AppliedPaymentEntry.IsEmpty);
    end;

    local procedure EntryAlreadyApplied(TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary;TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary;EntryNo: Integer): Boolean
    var
        AppliedPaymentEntry: Record "Applied Payment Entry";
    begin
        SetFilterToBankAccReconciliation(AppliedPaymentEntry,TempBankAccReconciliationLine);
        AppliedPaymentEntry.SetRange("Account Type",TempBankStatementMatchingBuffer."Account Type");
        AppliedPaymentEntry.SetRange("Applies-to Entry No.",EntryNo);

        exit(not AppliedPaymentEntry.IsEmpty);
    end;

    local procedure SetFilterToBankAccReconciliation(var AppliedPaymentEntry: Record "Applied Payment Entry";TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary)
    begin
        AppliedPaymentEntry.FilterAppliedPmtEntry(TempBankAccReconciliationLine);
        AppliedPaymentEntry.SetRange("Statement Line No.");
    end;

    local procedure SetFilterToRelatedApplications(var AppliedPaymentEntry: Record "Applied Payment Entry";TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary;TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary)
    begin
        SetFilterToBankAccReconciliation(AppliedPaymentEntry,TempBankAccReconciliationLine);
        AppliedPaymentEntry.SetRange("Account Type",TempBankStatementMatchingBuffer."Account Type");
        AppliedPaymentEntry.SetRange("Account No.",TempBankStatementMatchingBuffer."Account No.");
        AppliedPaymentEntry.SetRange("Applies-to Entry No.",TempBankStatementMatchingBuffer."Entry No.");
    end;

    local procedure GetRemainingAmount(TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary;TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary): Decimal
    var
        TempAppliedPaymentEntry: Record "Applied Payment Entry" temporary;
    begin
        TempAppliedPaymentEntry.TransferFromBankAccReconLine(TempBankAccReconciliationLine);
        TempAppliedPaymentEntry."Account Type" := TempBankStatementMatchingBuffer."Account Type";
        TempAppliedPaymentEntry."Account No." := TempBankStatementMatchingBuffer."Account No.";
        TempAppliedPaymentEntry."Applies-to Entry No." := TempBankStatementMatchingBuffer."Entry No.";

        exit(TempAppliedPaymentEntry.GetRemAmt - TempAppliedPaymentEntry.GetAmtAppliedToOtherStmtLines);
    end;

    local procedure ShowMatchSummary(BankAccReconciliation: Record "Bank Acc. Reconciliation")
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        MatchedCount: Integer;
        TotalCount: Integer;
        FinalText: Text;
    begin
        BankAccReconciliationLine.SetRange("Statement Type",BankAccReconciliation."statement type"::"Payment Application");
        BankAccReconciliationLine.SetRange("Bank Account No.",BankAccReconciliation."Bank Account No.");
        BankAccReconciliationLine.SetRange("Statement No.",BankAccReconciliation."Statement No.");
        TotalCount := BankAccReconciliationLine.Count;

        BankAccReconciliationLine.SetFilter("Applied Entries",'>0');
        MatchedCount := BankAccReconciliationLine.Count;

        FinalText := StrSubstNo(MatchSummaryMsg,MatchedCount,TotalCount);
        Message(FinalText);
    end;

    local procedure UpdateOneToManyMatches(BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    begin
        RemoveInvalidOneToManyMatches;
        GetOneToManyMatches;
        ScoreOneToManyMatches(BankAccReconciliationLine);
    end;

    local procedure ScoreOneToManyMatches(BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        BankPmtApplRule: Record "Bank Pmt. Appl. Rule";
        Score: Integer;
    begin
        if TempBankStatementMatchingBuffer.FindSet then begin
          repeat
            BankPmtApplRule."Doc. No./Ext. Doc. No. Matched" := BankPmtApplRule."doc. no./ext. doc. no. matched"::"Yes - Multiple";
            BankPmtApplRule."Related Party Matched" := TempBankStatementMatchingBuffer."Related Party Matched";
            BankAccReconciliationLine.Get(
              BankAccReconciliationLine."Statement Type",BankAccReconciliationLine."Bank Account No.",
              BankAccReconciliationLine."Statement No.",TempBankStatementMatchingBuffer."Line No.");
            AmountInclToleranceMatching(
              BankPmtApplRule,BankAccReconciliationLine,TempBankStatementMatchingBuffer."Account Type",
              TempBankStatementMatchingBuffer."Total Remaining Amount");

            Score := TempBankPmtApplRule.GetBestMatchScore(BankPmtApplRule);
            TempBankStatementMatchingBuffer.Quality := Score;
            TempBankStatementMatchingBuffer.Modify;
          until TempBankStatementMatchingBuffer.Next = 0;
        end;

        TempBankStatementMatchingBuffer.Reset;
    end;

    local procedure RemoveInvalidOneToManyMatches()
    begin
        TempBankStatementMatchingBuffer.Reset;
        TempBankStatementMatchingBuffer.SetRange("One to Many Match",true);
        TempBankStatementMatchingBuffer.SetFilter("No. of Entries",'=1');
        TempBankStatementMatchingBuffer.DeleteAll(true);
        TempBankStatementMatchingBuffer.Reset;
    end;

    local procedure GetOneToManyMatches()
    begin
        TempBankStatementMatchingBuffer.Reset;
        TempBankStatementMatchingBuffer.SetRange("One to Many Match",true);
        TempBankStatementMatchingBuffer.SetFilter("No. of Entries",'>1');

        if TempBankStatementMatchingBuffer.FindSet then
          repeat
            OneToManyTempBankStatementMatchingBuffer := TempBankStatementMatchingBuffer;
            OneToManyTempBankStatementMatchingBuffer.Insert(true);
          until TempBankStatementMatchingBuffer.Next = 0;
    end;

    local procedure GetExactMatchTreshold(): Decimal
    begin
        exit(0.95 * GetNormalizingFactor);
    end;


    procedure GetCloseMatchTreshold(): Decimal
    begin
        exit(0.65 * GetNormalizingFactor);
    end;

    local procedure GetMatchLengthTreshold(): Decimal
    begin
        exit(4);
    end;


    procedure GetNormalizingFactor(): Decimal
    begin
        exit(100);
    end;

    local procedure GetLowestMatchScore(): Integer
    var
        Score: Integer;
    begin
        if not ApplyEntries then
          exit(0);

        TempBankPmtApplRule.SetFilter("Match Confidence",'<>%1',TempBankPmtApplRule."match confidence"::None);
        TempBankPmtApplRule.SetCurrentkey(Score);
        TempBankPmtApplRule.Ascending(false);
        Score := 0;
        if TempBankPmtApplRule.FindLast then
          Score := TempBankPmtApplRule.Score;

        TempBankPmtApplRule.Reset;
        exit(Score);
    end;

    local procedure IsNameUnique(Name: Text[50];AccountType: Option): Boolean
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        case AccountType of
          TempBankStatementMatchingBuffer."account type"::Customer:
            begin
              Customer.SetFilter(Name,'%1','@*' + Name + '*');
              exit(Customer.Count = 1);
            end;
          TempBankStatementMatchingBuffer."account type"::Vendor:
            begin
              Vendor.SetFilter(Name,'%1','@*' + Name + '*');
              exit(Vendor.Count = 1);
            end;
        end;
    end;

    local procedure IsAlphanumeric(Character: Char): Boolean
    begin
        exit((Character in ['0'..'9']) or (Character in ['A'..'Z']) or (Character in ['a'..'z']));
    end;


    procedure GetBankStatementMatchingBuffer(var TempBankStatementMatchingBuffer2: Record "Bank Statement Matching Buffer" temporary)
    begin
        TempBankStatementMatchingBuffer2.Copy(TempBankStatementMatchingBuffer,true);
        TempBankStatementMatchingBuffer2.Reset;
    end;

    local procedure UpdatePaymentMatchDetails(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        BankAccReconciliationLine2: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccReconciliationLine2.CopyFilters(BankAccReconciliationLine);

        if BankAccReconciliationLine2.FindSet then
          repeat
            BankAccReconciliationLine2.CalcFields("Match Confidence","Match Quality");
            AddWarningsForTextMapperOverriden(BankAccReconciliationLine2);
            AddWarningsForStatementCanBeAppliedToMultipleEntries(BankAccReconciliationLine2);
            AddWarningsForMultipleStatementLinesCouldBeAppliedToEntry(BankAccReconciliationLine2);
            if BankAccReconciliationLine2.Type <> BankAccReconciliationLine2.Type::Difference then
              UpdateType(BankAccReconciliationLine2);
          until BankAccReconciliationLine2.Next = 0;
    end;

    local procedure DeletePaymentMatchDetails(BankAccReconciliation: Record "Bank Acc. Reconciliation")
    var
        PaymentMatchingDetails: Record "Payment Matching Details";
    begin
        PaymentMatchingDetails.SetRange("Statement Type",BankAccReconciliation."Statement Type");
        PaymentMatchingDetails.SetRange("Bank Account No.",BankAccReconciliation."Bank Account No.");
        PaymentMatchingDetails.SetRange("Statement No.",BankAccReconciliation."Statement No.");
        PaymentMatchingDetails.DeleteAll(true);
    end;

    local procedure DeleteAppliedPaymentEntries(BankAccReconciliation: Record "Bank Acc. Reconciliation")
    var
        AppliedPaymentEntry: Record "Applied Payment Entry";
    begin
        AppliedPaymentEntry.SetRange("Statement Type",BankAccReconciliation."Statement Type");
        AppliedPaymentEntry.SetRange("Bank Account No.",BankAccReconciliation."Bank Account No.");
        AppliedPaymentEntry.SetRange("Statement No.",BankAccReconciliation."Statement No.");
        AppliedPaymentEntry.DeleteAll(true);
    end;

    local procedure AddWarningsForTextMapperOverriden(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        PaymentMatchingDetails: Record "Payment Matching Details";
        BankPmtApplRule: Record "Bank Pmt. Appl. Rule";
    begin
        if BankAccReconciliationLine."Match Quality" <= BankPmtApplRule.GetTextMapperScore then
          exit;

        TempBankStatementMatchingBuffer.Reset;
        TempBankStatementMatchingBuffer.SetRange("Line No.",BankAccReconciliationLine."Statement Line No.");
        TempBankStatementMatchingBuffer.SetRange(Quality,BankPmtApplRule.GetTextMapperScore);

        if TempBankStatementMatchingBuffer.Count > 0 then
          PaymentMatchingDetails.CreatePaymentMatchingDetail(BankAccReconciliationLine,
            StrSubstNo(TextMapperRulesOverridenTxt,TempBankStatementMatchingBuffer.Count,
              BankAccReconciliationLine."Match Confidence"));
    end;

    local procedure AddWarningsForStatementCanBeAppliedToMultipleEntries(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        PaymentMatchingDetails: Record "Payment Matching Details";
        BankPmtApplRule: Record "Bank Pmt. Appl. Rule";
        MinRangeValue: Integer;
        MaxRangeValue: Integer;
    begin
        if BankAccReconciliationLine."Match Confidence" = BankAccReconciliationLine."match confidence"::None then
          exit;

        if BankAccReconciliationLine."Match Quality" = BankPmtApplRule.GetTextMapperScore then
          exit;

        TempBankStatementMatchingBuffer.Reset;
        TempBankStatementMatchingBuffer.SetRange("Line No.",BankAccReconciliationLine."Statement Line No.");

        MinRangeValue := BankPmtApplRule.GetLowestScoreInRange(BankAccReconciliationLine."Match Quality");
        MaxRangeValue := BankPmtApplRule.GetHighestScoreInRange(BankAccReconciliationLine."Match Quality");
        TempBankStatementMatchingBuffer.SetRange(Quality,MinRangeValue,MaxRangeValue);

        if TempBankStatementMatchingBuffer.Count > 1 then
          PaymentMatchingDetails.CreatePaymentMatchingDetail(BankAccReconciliationLine,
            StrSubstNo(MultipleEntriesWithSilarConfidenceFoundTxt,TempBankStatementMatchingBuffer.Count));
    end;

    local procedure AddWarningsForMultipleStatementLinesCouldBeAppliedToEntry(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        PaymentMatchingDetails: Record "Payment Matching Details";
        BankPmtApplRule: Record "Bank Pmt. Appl. Rule";
        EntryNo: Integer;
        MinRangeValue: Integer;
        MaxRangeValue: Integer;
    begin
        if BankAccReconciliationLine."Match Confidence" = BankAccReconciliationLine."match confidence"::None then
          exit;

        if BankAccReconciliationLine."Match Quality" = BankPmtApplRule.GetTextMapperScore then
          exit;

        TempBankStatementMatchingBuffer.Reset;

        // Get Entry No.
        TempBankStatementMatchingBuffer.SetRange("Line No.",BankAccReconciliationLine."Statement Line No.");
        TempBankStatementMatchingBuffer.SetRange(Quality,BankAccReconciliationLine."Match Quality");
        TempBankStatementMatchingBuffer.FindFirst;
        EntryNo := TempBankStatementMatchingBuffer."Entry No.";

        MinRangeValue := BankPmtApplRule.GetLowestScoreInRange(BankAccReconciliationLine."Match Quality");
        MaxRangeValue := BankPmtApplRule.GetHighestScoreInRange(BankAccReconciliationLine."Match Quality");

        TempBankStatementMatchingBuffer.Reset;
        TempBankStatementMatchingBuffer.SetRange("Entry No.",EntryNo);
        TempBankStatementMatchingBuffer.SetRange(Quality,MinRangeValue,MaxRangeValue);
        TempBankStatementMatchingBuffer.SetFilter("Line No.",'<>%1',BankAccReconciliationLine."Statement Line No.");
        if TempBankStatementMatchingBuffer.Count > 1 then
          PaymentMatchingDetails.CreatePaymentMatchingDetail(BankAccReconciliationLine,
            StrSubstNo(MultipleStatementLinesWithSameConfidenceFoundTxt,TempBankStatementMatchingBuffer.Count));
    end;


    procedure SetApplyEntries(NewApplyEntries: Boolean)
    begin
        ApplyEntries := NewApplyEntries;
    end;

    local procedure GetAvailableSplitLineNo(BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";ParentLineNo: Integer): Integer
    var
        SplitLineNo: Integer;
    begin
        SplitLineNo := BankAccReconciliationLine."Statement Line No." + 1;
        BankAccReconciliationLine.SetRange("Parent Line No.",ParentLineNo);
        if BankAccReconciliationLine.FindLast then
          SplitLineNo := BankAccReconciliationLine."Statement Line No." + 1;
        exit(SplitLineNo)
    end;

    local procedure GetParentLineNo(BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"): Integer
    begin
        if BankAccReconciliationLine."Parent Line No." <> 0 then
          exit(BankAccReconciliationLine."Parent Line No.");
        exit(BankAccReconciliationLine."Statement Line No.");
    end;


    procedure UpdateType(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        AppliedPaymentEntry: Record "Applied Payment Entry";
        CheckLedgerEntry: Record "Check Ledger Entry";
    begin
        AppliedPaymentEntry.SetRange("Statement Type",BankAccReconciliationLine."Statement Type");
        AppliedPaymentEntry.SetRange("Bank Account No.",BankAccReconciliationLine."Bank Account No.");
        AppliedPaymentEntry.SetRange("Statement No.",BankAccReconciliationLine."Statement No.");
        AppliedPaymentEntry.SetRange("Statement Line No.",BankAccReconciliationLine."Statement Line No.");
        if AppliedPaymentEntry.FindFirst then begin
          if AppliedPaymentEntry."Applies-to Entry No." = 0 then
            exit;

          CheckLedgerEntry.SetRange("Bank Account Ledger Entry No.",AppliedPaymentEntry."Applies-to Entry No.");
          if CheckLedgerEntry.FindFirst then
            BankAccReconciliationLine.Type := BankAccReconciliationLine.Type::"Check Ledger Entry"
          else
            BankAccReconciliationLine.Type := BankAccReconciliationLine.Type::"Bank Account Ledger Entry";

          BankAccReconciliationLine.Modify;
        end;
    end;
}

