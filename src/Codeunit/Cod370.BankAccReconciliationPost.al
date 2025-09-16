#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 370 "Bank Acc. Reconciliation Post"
{
    Permissions = TableData "Bank Account Ledger Entry"=rm,
                  TableData "Check Ledger Entry"=rm,
                  TableData "Bank Account Statement"=ri,
                  TableData "Bank Account Statement Line"=ri,
                  TableData "Posted Payment Recon. Hdr"=ri;
    TableNo = "Bank Acc. Reconciliation";

    trigger OnRun()
    begin
        Window.Open(
          '#1#################################\\' +
          Text000);
        Window.Update(1,StrSubstNo('%1 %2',"Bank Account No.","Statement No."));

        InitPost(Rec);
        Post(Rec);
        FinalizePost(Rec);

        Window.Close;

        Commit;
    end;

    var
        Text000: label 'Posting lines              #2######';
        Text001: label '%1 is not equal to Total Balance.';
        Text002: label 'There is nothing to post.';
        Text003: label 'The application is not correct. The total amount applied is %1; it should be %2.';
        Text004: label 'The total difference is %1. It must be %2.';
        BankAcc: Record "Bank Account";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Window: Dialog;
        SourceCode: Code[10];
        TotalAmount: Decimal;
        TotalAppliedAmount: Decimal;
        TotalDiff: Decimal;
        Lines: Integer;
        Difference: Decimal;
        ExcessiveAmtErr: label 'You must apply the excessive amount of %1 %2 manually.', Comment='%1 a decimal number, %2 currency code';
        PostPaymentsOnly: Boolean;
        NotFullyAppliedErr: label 'One or more payments are not fully applied.\\The sum of applied amounts is %1. It must be %2.', Comment='%1 - total applied amount, %2 - total transaction amount';
        LineNoTAppliedErr: label 'The line with transaction date %1 and transaction text ''%2'' is not applied. You must apply all lines.', Comment='%1 - transaction date, %2 - arbitrary text';
        TransactionAlreadyReconciledErr: label 'The line with transaction date %1 and transaction text ''%2'' is already reconciled.\\You must remove it from the payment reconciliation journal before posting.', Comment='%1 - transaction date, %2 - arbitrary text';

    local procedure InitPost(BankAccRecon: Record "Bank Acc. Reconciliation")
    begin
        with BankAccRecon do
          case "Statement Type" of
            "statement type"::"Bank Reconciliation":
              begin
                TestField("Statement Date");
                CheckLinesMatchEndingBalance(BankAccRecon,Difference);
              end;
            "statement type"::"Payment Application":
              begin
                SourceCodeSetup.Get;
                SourceCode := SourceCodeSetup."Payment Reconciliation Journal";
                PostPaymentsOnly := "Post Payments Only";
              end;
          end;
    end;

    local procedure Post(BankAccRecon: Record "Bank Acc. Reconciliation")
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        AppliedAmount: Decimal;
        TotalTransAmtNotAppliedErr: Text;
    begin
        with BankAccRecon do begin
          // Run through lines
          BankAccReconLine.FilterBankRecLines(BankAccRecon);
          TotalAmount := 0;
          TotalAppliedAmount := 0;
          TotalDiff := 0;
          Lines := 0;
          if BankAccReconLine.IsEmpty then
            Error(Text002);
          BankAccLedgEntry.LockTable;
          CheckLedgEntry.LockTable;
          BankAccReconLine.SetRange(Reconciled,true);
          if BankAccReconLine.FindSet then
            repeat
              Lines := Lines + 1;
              Window.Update(2,Lines);
              AppliedAmount := 0;
              // Adjust entries
              // Test amount and settled amount
              case "Statement Type" of
                "statement type"::"Bank Reconciliation":
                  case BankAccReconLine.Type of
                    BankAccReconLine.Type::"Bank Account Ledger Entry":
                      CloseBankAccLedgEntry(BankAccReconLine,AppliedAmount);
                    BankAccReconLine.Type::"Check Ledger Entry":
                      CloseCheckLedgEntry(BankAccReconLine,AppliedAmount);
                    BankAccReconLine.Type::Difference:
                      TotalDiff += BankAccReconLine."Statement Amount";
                  end;
                "statement type"::"Payment Application":
                  PostPaymentApplications(BankAccReconLine,AppliedAmount);
              end;
              BankAccReconLine.TestField("Applied Amount",AppliedAmount);
              TotalAmount += BankAccReconLine."Statement Amount";
              TotalAppliedAmount += AppliedAmount;
            until BankAccReconLine.Next = 0;

          // Test amount
          if "Statement Type" = "statement type"::"Payment Application" then
            TotalTransAmtNotAppliedErr := NotFullyAppliedErr
          else
            TotalTransAmtNotAppliedErr := Text003;
          if TotalAmount <> TotalAppliedAmount + TotalDiff then
            Error(
              TotalTransAmtNotAppliedErr,
              TotalAppliedAmount + TotalDiff,TotalAmount);
          if Difference <> TotalDiff then
            Error(Text004,Difference,TotalDiff);

          // Get bank
          UpdateBank(BankAccRecon,TotalAmount);

          case "Statement Type" of

            "statement type"::"Bank Reconciliation":
              TransferToBankStmt(BankAccRecon);
            "statement type"::"Payment Application":
              TransferToPostPmtAppln(BankAccRecon);
          end;
        end;
    end;

    local procedure FinalizePost(BankAccRecon: Record "Bank Acc. Reconciliation")
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        AppliedPmtEntry: Record "Applied Payment Entry";
    begin
        with BankAccRecon do begin
          // Delete statement
          if BankAccReconLine.LinesExist(BankAccRecon) then
            repeat
              AppliedPmtEntry.FilterAppliedPmtEntry(BankAccReconLine);
              AppliedPmtEntry.DeleteAll;

              BankAccReconLine.Delete;
              BankAccReconLine.ClearDataExchEntries;
            until BankAccReconLine.Next = 0;

          Find;
          Delete;
        end;
    end;

    local procedure CheckLinesMatchEndingBalance(BankAccRecon: Record "Bank Acc. Reconciliation";var Difference: Decimal)
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
    begin
        with BankAccReconLine do begin
          LinesExist(BankAccRecon);
          CalcSums("Statement Amount",Difference);

         // IF "Statement Amount" <>
          //   BankAccRecon."Statement Ending Balance" - BankAccRecon."Balance Last Statement"
        //  THEN
        ///    ERROR(Text001,BankAccRecon.FIELDCAPTION("Statement Ending Balance"));
        end;
        Difference := BankAccReconLine.Difference;
    end;

    local procedure CloseBankAccLedgEntry(BankAccReconLine: Record "Bank Acc. Reconciliation Line";var AppliedAmount: Decimal)
    begin
        BankAccLedgEntry.Reset;
        BankAccLedgEntry.SetCurrentkey("Bank Account No.",Open);
        BankAccLedgEntry.SetRange("Bank Account No.",BankAccReconLine."Bank Account No.");
        BankAccLedgEntry.SetRange(Open,true);
        BankAccLedgEntry.SetRange(
          "Statement Status",BankAccLedgEntry."statement status"::"Bank Acc. Entry Applied");
        BankAccLedgEntry.SetRange("Statement No.",BankAccReconLine."Statement No.");
        BankAccLedgEntry.SetRange("Statement Line No.",BankAccReconLine."Statement Line No.");
        if BankAccLedgEntry.Find('-') then
          repeat
            AppliedAmount += BankAccLedgEntry."Remaining Amount";
            BankAccLedgEntry."Remaining Amount" := 0;
            BankAccLedgEntry.Open := false;
            BankAccLedgEntry."Statement Status" := BankAccLedgEntry."statement status"::Closed;
            BankAccLedgEntry.Modify;

            CheckLedgEntry.Reset;
            CheckLedgEntry.SetCurrentkey("Bank Account Ledger Entry No.");
            CheckLedgEntry.SetRange(
              "Bank Account Ledger Entry No.",BankAccLedgEntry."Entry No.");
            CheckLedgEntry.SetRange(Open,true);
            if CheckLedgEntry.Find('-') then
              repeat
                CheckLedgEntry.TestField(Open,true);
                CheckLedgEntry.TestField(
                  "Statement Status",
                  CheckLedgEntry."statement status"::"Bank Acc. Entry Applied");
                CheckLedgEntry.TestField("Statement No.",'');
                CheckLedgEntry.TestField("Statement Line No.",0);
                CheckLedgEntry.Open := false;
                CheckLedgEntry."Statement Status" := CheckLedgEntry."statement status"::Closed;
                CheckLedgEntry.Modify;
              until CheckLedgEntry.Next = 0;
          until BankAccLedgEntry.Next = 0;
    end;

    local procedure CloseCheckLedgEntry(BankAccReconLine: Record "Bank Acc. Reconciliation Line";var AppliedAmount: Decimal)
    var
        CheckLedgEntry2: Record "Check Ledger Entry";
    begin
        CheckLedgEntry.Reset;
        CheckLedgEntry.SetCurrentkey("Bank Account No.",Open);
        CheckLedgEntry.SetRange("Bank Account No.",BankAccReconLine."Bank Account No.");
        CheckLedgEntry.SetRange(Open,true);
        CheckLedgEntry.SetRange(
          "Statement Status",CheckLedgEntry."statement status"::"Check Entry Applied");
        CheckLedgEntry.SetRange("Statement No.",BankAccReconLine."Statement No.");
        CheckLedgEntry.SetRange("Statement Line No.",BankAccReconLine."Statement Line No.");
        if CheckLedgEntry.Find('-') then
          repeat
            AppliedAmount -= CheckLedgEntry.Amount;
            CheckLedgEntry.Open := false;
            CheckLedgEntry."Statement Status" := CheckLedgEntry."statement status"::Closed;
            CheckLedgEntry.Modify;

            BankAccLedgEntry.Get(CheckLedgEntry."Bank Account Ledger Entry No.");
            BankAccLedgEntry.TestField(Open,true);
            BankAccLedgEntry.TestField(
              "Statement Status",BankAccLedgEntry."statement status"::"Check Entry Applied");
            BankAccLedgEntry.TestField("Statement No.",'');
            BankAccLedgEntry.TestField("Statement Line No.",0);
            BankAccLedgEntry."Remaining Amount" :=
              BankAccLedgEntry."Remaining Amount" + CheckLedgEntry.Amount;
            if BankAccLedgEntry."Remaining Amount" = 0 then begin
              BankAccLedgEntry.Open := false;
              BankAccLedgEntry."Statement Status" := BankAccLedgEntry."statement status"::Closed;
              BankAccLedgEntry."Statement No." := BankAccReconLine."Statement No.";
              BankAccLedgEntry."Statement Line No." := CheckLedgEntry."Statement Line No.";
            end else begin
              CheckLedgEntry2.Reset;
              CheckLedgEntry2.SetCurrentkey("Bank Account Ledger Entry No.");
              CheckLedgEntry2.SetRange("Bank Account Ledger Entry No.",BankAccLedgEntry."Entry No.");
              CheckLedgEntry2.SetRange(Open,true);
              CheckLedgEntry2.SetRange("Check Type",CheckLedgEntry2."check type"::"Partial Check");
              CheckLedgEntry2.SetRange(
                "Statement Status",CheckLedgEntry2."statement status"::"Check Entry Applied");
              if not CheckLedgEntry2.FindFirst then
                BankAccLedgEntry."Statement Status" := BankAccLedgEntry."statement status"::Open;
            end;
            BankAccLedgEntry.Modify;
          until CheckLedgEntry.Next = 0;
    end;

    local procedure PostPaymentApplications(BankAccReconLine: Record "Bank Acc. Reconciliation Line";var AppliedAmount: Decimal)
    var
        AppliedPmtEntry: Record "Applied Payment Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        PaymentLineAmount: Decimal;
        RemainingAmount: Decimal;
    begin
        if BankAccReconLine.IsTransactionPostedAndReconciled then
          Error(TransactionAlreadyReconciledErr,BankAccReconLine."Transaction Date",BankAccReconLine."Transaction Text");

        with GenJnlLine do begin
          if BankAccReconLine."Account No." = '' then
            Error(LineNoTAppliedErr,BankAccReconLine."Transaction Date",BankAccReconLine."Transaction Text");
          BankAcc.Get(BankAccReconLine."Bank Account No.");
          Init;
          "Document Type" := "document type"::Payment;

          if IsRefund(BankAccReconLine) then
            "Document Type" := "document type"::Refund;

          "Shortcut Dimension 1 Code" := BankAccReconLine."Shortcut Dimension 1 Code";
          "Shortcut Dimension 2 Code" := BankAccReconLine."Shortcut Dimension 2 Code";
          "Account Type" := BankAccReconLine.GetAppliedToAccountType;
          Validate("Account No.",BankAccReconLine.GetAppliedToAccountNo);
          "Dimension Set ID" := BankAccReconLine."Dimension Set ID";

          "Posting Date" := BankAccReconLine."Transaction Date";
          Description := BankAccReconLine.Description;

          "Document No." := BankAccReconLine."Statement No.";
          "Bal. Account Type" := "bal. account type"::"Bank Account";
          "Bal. Account No." := BankAcc."No.";

          "Source Code" := SourceCode;
          "Allow Zero-Amount Posting" := true;

          "Applies-to ID" := BankAccReconLine."Statement No.";
        end;

        with AppliedPmtEntry do
          if AppliedPmtEntryLinesExist(BankAccReconLine) then
            repeat
              AppliedAmount += "Applied Amount" - "Applied Pmt. Discount";
              PaymentLineAmount += "Applied Amount" - "Applied Pmt. Discount";
              TestField("Account Type",BankAccReconLine."Account Type");
              TestField("Account No.",BankAccReconLine."Account No.");
              if "Applies-to Entry No." <> 0 then
                case "Account Type" of
                  "account type"::Customer:
                    ApplyCustLedgEntry(
                      AppliedPmtEntry,GenJnlLine."Applies-to ID",GenJnlLine."Posting Date",0D,0D,"Applied Pmt. Discount");
                  "account type"::Vendor:
                    ApplyVendLedgEntry(
                      AppliedPmtEntry,GenJnlLine."Applies-to ID",GenJnlLine."Posting Date",0D,0D,"Applied Pmt. Discount");
                  "account type"::"Bank Account":
                    begin
                      BankAccountLedgerEntry.Get("Applies-to Entry No.");
                      RemainingAmount := BankAccountLedgerEntry."Remaining Amount";
                      case true of
                        RemainingAmount = "Applied Amount":
                          begin
                            if not PostPaymentsOnly then
                              CloseBankAccountLedgerEntry("Applies-to Entry No.","Applied Amount");
                            PaymentLineAmount -= "Applied Amount";
                          end;
                        Abs(RemainingAmount) > Abs("Applied Amount"):
                          begin
                            if not PostPaymentsOnly then begin
                              BankAccountLedgerEntry."Remaining Amount" -= "Applied Amount";
                              BankAccountLedgerEntry.Modify;
                            end;
                            PaymentLineAmount -= "Applied Amount";
                          end;
                        Abs(RemainingAmount) < Abs("Applied Amount"):
                          begin
                            if not PostPaymentsOnly then
                              CloseBankAccountLedgerEntry("Applies-to Entry No.",RemainingAmount);
                            PaymentLineAmount -= RemainingAmount;
                          end;
                      end;
                    end;
                end;
            until Next = 0;

        if PaymentLineAmount <> 0 then begin
          if GenJnlLine."Account Type" <> GenJnlLine."account type"::"Bank Account" then begin
            GenJnlLine.Validate("Currency Code",BankAcc."Currency Code");
            GenJnlLine.Amount := -PaymentLineAmount;
            GenJnlLine.Validate("VAT %");
            GenJnlLine.Validate("Bal. VAT %")
          end else begin
            GLSetup.Get;
            Error(ExcessiveAmtErr,PaymentLineAmount,GLSetup.GetCurrencyCode(BankAcc."Currency Code"));
          end;
          GenJnlPostLine.RunWithCheck(GenJnlLine);
          if not PostPaymentsOnly then begin
            BankAccountLedgerEntry.SetRange(Open,true);
            BankAccountLedgerEntry.SetRange("Bank Account No.",BankAcc."No.");
            BankAccountLedgerEntry.SetRange("Document Type",GenJnlLine."document type"::Payment);
            BankAccountLedgerEntry.SetRange("Document No.",BankAccReconLine."Statement No.");
            BankAccountLedgerEntry.SetRange("Posting Date",GenJnlLine."Posting Date");
            if BankAccountLedgerEntry.FindLast then
              CloseBankAccountLedgerEntry(BankAccountLedgerEntry."Entry No.",BankAccountLedgerEntry.Amount);
          end;
        end;
    end;

    local procedure UpdateBank(BankAccRecon: Record "Bank Acc. Reconciliation";Amt: Decimal)
    begin
        with BankAcc do begin
          LockTable;
          Get(BankAccRecon."Bank Account No.");
          TestField(Blocked,false);
          "Last Statement No." := BankAccRecon."Statement No.";
          "Balance Last Statement" := BankAccRecon."Balance Last Statement" + Amt;
          Modify;
        end;
    end;

    local procedure TransferToBankStmt(BankAccRecon: Record "Bank Acc. Reconciliation")
    var
        BankAccStmt: Record "Bank Account Statement";
        BankAccStmtLine: Record "Bank Account Statement Line";
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
    begin
        if BankAccReconLine.LinesExist(BankAccRecon) then
          repeat
            BankAccStmtLine.TransferFields(BankAccReconLine);
            BankAccStmtLine.Insert;
            BankAccReconLine.ClearDataExchEntries;
          until BankAccReconLine.Next = 0;

        BankAccStmt.TransferFields(BankAccRecon);
        BankAccStmt.Insert;
    end;

    local procedure TransferToPostPmtAppln(BankAccRecon: Record "Bank Acc. Reconciliation")
    var
        PostedPmtReconHdr: Record "Posted Payment Recon. Hdr";
        PostedPmtReconLine: Record "Posted Payment Recon. Line";
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        TypeHelper: Codeunit "Type Helper";
        FieldLength: Integer;
    begin
        if BankAccReconLine.LinesExist(BankAccRecon) then
          repeat
            PostedPmtReconLine.TransferFields(BankAccReconLine);

            FieldLength := TypeHelper.GetFieldLength(Database::"Posted Payment Recon. Line",
                PostedPmtReconLine.FieldNo("Applied Document No."));
            PostedPmtReconLine."Applied Document No." := CopyStr(BankAccReconLine.GetAppliedToDocumentNo,1,FieldLength);

            FieldLength := TypeHelper.GetFieldLength(Database::"Posted Payment Recon. Line",
                PostedPmtReconLine.FieldNo("Applied Entry No."));
            PostedPmtReconLine."Applied Entry No." := CopyStr(BankAccReconLine.GetAppliedToEntryNo,1,FieldLength);

            PostedPmtReconLine.Reconciled := not PostPaymentsOnly;

            PostedPmtReconLine.Insert;
            BankAccReconLine.ClearDataExchEntries;
          until BankAccReconLine.Next = 0;

        PostedPmtReconHdr.TransferFields(BankAccRecon);
        PostedPmtReconHdr.Insert;
    end;


    procedure ApplyCustLedgEntry(AppliedPmtEntry: Record "Applied Payment Entry";AppliesToID: Code[50];PostingDate: Date;PmtDiscDueDate: Date;PmtDiscToleranceDate: Date;RemPmtDiscPossible: Decimal)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        with CustLedgEntry do begin
          Get(AppliedPmtEntry."Applies-to Entry No.");
          TestField(Open);
          BankAcc.Get(AppliedPmtEntry."Bank Account No.");
          if AppliesToID = '' then begin
            "Pmt. Discount Date" := PmtDiscDueDate;
            "Pmt. Disc. Tolerance Date" := PmtDiscToleranceDate;

            "Remaining Pmt. Disc. Possible" := RemPmtDiscPossible;
            if BankAcc.IsInLocalCurrency then
              "Remaining Pmt. Disc. Possible" :=
                CurrExchRate.ExchangeAmount("Remaining Pmt. Disc. Possible",'',"Currency Code",PostingDate);
          end else begin
            "Applies-to ID" := AppliesToID;

            "Amount to Apply" := AppliedPmtEntry."Applied Amount";
            if BankAcc.IsInLocalCurrency then
              "Amount to Apply" :=
                CurrExchRate.ExchangeAmount("Amount to Apply",'',"Currency Code",PostingDate);
          end;

          Codeunit.Run(Codeunit::"Cust. Entry-Edit",CustLedgEntry);
        end;
    end;


    procedure ApplyVendLedgEntry(AppliedPmtEntry: Record "Applied Payment Entry";AppliesToID: Code[50];PostingDate: Date;PmtDiscDueDate: Date;PmtDiscToleranceDate: Date;RemPmtDiscPossible: Decimal)
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        with VendLedgEntry do begin
          Get(AppliedPmtEntry."Applies-to Entry No.");
          TestField(Open);
          BankAcc.Get(AppliedPmtEntry."Bank Account No.");
          if AppliesToID = '' then begin
            "Pmt. Discount Date" := PmtDiscDueDate;
            "Pmt. Disc. Tolerance Date" := PmtDiscToleranceDate;

            "Remaining Pmt. Disc. Possible" := RemPmtDiscPossible;
            if BankAcc.IsInLocalCurrency then
              "Remaining Pmt. Disc. Possible" :=
                CurrExchRate.ExchangeAmount("Remaining Pmt. Disc. Possible",'',"Currency Code",PostingDate);
          end else begin
            "Applies-to ID" := AppliesToID;

            "Amount to Apply" := AppliedPmtEntry."Applied Amount";
            if BankAcc.IsInLocalCurrency then
              "Amount to Apply" :=
                CurrExchRate.ExchangeAmount("Amount to Apply",'',"Currency Code",PostingDate);
          end;

          Codeunit.Run(Codeunit::"Vend. Entry-Edit",VendLedgEntry);
        end;
    end;

    local procedure CloseBankAccountLedgerEntry(EntryNo: Integer;AppliedAmount: Decimal)
    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        CheckLedgerEntry: Record "Check Ledger Entry";
    begin
        with BankAccountLedgerEntry do begin
          Get(EntryNo);
          TestField(Open);
          TestField("Remaining Amount",AppliedAmount);
          "Remaining Amount" := 0;
          Open := false;
          "Statement Status" := "statement status"::Closed;
          Modify;

          CheckLedgerEntry.Reset;
          CheckLedgerEntry.SetCurrentkey("Bank Account Ledger Entry No.");
          CheckLedgerEntry.SetRange(
            "Bank Account Ledger Entry No.","Entry No.");
          CheckLedgerEntry.SetRange(Open,true);
          if CheckLedgerEntry.FindSet then
            repeat
              CheckLedgerEntry.Open := false;
              CheckLedgerEntry."Statement Status" := CheckLedgerEntry."statement status"::Closed;
              CheckLedgerEntry.Modify;
            until CheckLedgerEntry.Next = 0;
        end;
    end;

    local procedure IsRefund(BankAccReconLine: Record "Bank Acc. Reconciliation Line"): Boolean
    begin
        with BankAccReconLine do
          if ("Account Type" = "account type"::Customer) and ("Statement Amount" < 0) or
             ("Account Type" = "account type"::Vendor) and ("Statement Amount" > 0)
          then
            exit(true);
        exit(false);
    end;
}

