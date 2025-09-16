#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10140 "Deposit-Post"
{
    Permissions = TableData "Cust. Ledger Entry"=r,
                  TableData "Vendor Ledger Entry"=r,
                  TableData "Bank Account Ledger Entry"=r,
                  TableData UnknownTableData10143=rim,
                  TableData UnknownTableData10144=rim;
    TableNo = UnknownTable10140;

    trigger OnRun()
    var
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        // Perform all testing

        TestField("Posting Date");
        TestField("Total Deposit Amount");
        TestField("Document Date");
        TestField("Bank Account No.");
        BankAccount.Get("Bank Account No.");
        BankAccount.TestField(Blocked,false);

        if "Currency Code" = '' then
          Currency.InitRoundingPrecision
        else begin
          Currency.Get("Currency Code");
          Currency.TestField("Amount Rounding Precision");
        end;

        SourceCodeSetup.Get;
        GenJnlTemplate.Get("Journal Template Name");

        CalcFields("Total Deposit Lines");
        if "Total Deposit Lines" <> "Total Deposit Amount" then
          Error(Text000,FieldCaption("Total Deposit Amount"),FieldCaption("Total Deposit Lines"));

        TotalLines := 0;
        TotalDepositLinesLCY := 0;
        CurLine := 0;
        Window.Open(
          StrSubstNo(Text001,"No.") +
          Text004 +
          Text002 +
          Text003);

        // Copy to History Tables

        Window.Update(4,Text005);
        PostedDepositHeader.LockTable;
        PostedDepositLine.LockTable;

        LockTable;
        GenJnlLine.LockTable;

        PostedDepositHeader.TransferFields(Rec,true);
        PostedDepositHeader."No. Printed" := 0;
        PostedDepositHeader.Insert;

        RecordLinkManagement.CopyLinks(Rec,PostedDepositHeader);

        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name","Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name","Journal Batch Name");
        if GenJnlLine.Find('-') then
          repeat
            TotalLines := TotalLines + 1;
            Window.Update(2,TotalLines);
            PostedDepositLine."Deposit No." := "No.";
            PostedDepositLine."Line No." := TotalLines;
            PostedDepositLine."Account Type" := GenJnlLine."Account Type";
            PostedDepositLine."Account No." := GenJnlLine."Account No.";
            PostedDepositLine."Document Date" := GenJnlLine."Document Date";
            PostedDepositLine."Document Type" := GenJnlLine."Document Type";
            PostedDepositLine."Document No." := GenJnlLine."Document No.";
            PostedDepositLine.Description := GenJnlLine.Description;
            PostedDepositLine."Currency Code" := GenJnlLine."Currency Code";
            PostedDepositLine.Amount := -GenJnlLine.Amount;
            PostedDepositLine."Posting Group" := GenJnlLine."Posting Group";
            PostedDepositLine."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
            PostedDepositLine."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
            PostedDepositLine."Dimension Set ID" := GenJnlLine."Dimension Set ID";
            PostedDepositLine."Posting Date" := "Posting Date";
            PostedDepositLine.Insert;
            if GenJnlTemplate."Force Doc. Balance" then
              AddBalancingAccount(GenJnlLine,Rec)
            else
              GenJnlLine."Bal. Account No." := '';
            GenJnlCheckLine.RunCheck(GenJnlLine);
          until GenJnlLine.Next = 0;

        BankCommentLine.Reset;
        BankCommentLine.SetRange("Table Name",BankCommentLine."table name"::Deposit);
        BankCommentLine.SetRange("Bank Account No.","Bank Account No.");
        BankCommentLine.SetRange("No.","No.");
        if BankCommentLine.Find('-') then
          repeat
            BankCommentLine2 := BankCommentLine;
            BankCommentLine2."Table Name" := BankCommentLine2."table name"::"Posted Deposit";
            BankCommentLine2.Insert;
          until BankCommentLine.Next = 0;

        // Post to General, and other, Ledgers

        Window.Update(4,Text006);
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name","Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name","Journal Batch Name");
        if GenJnlLine.Find('-') then
          repeat
            CurLine := CurLine + 1;
            Window.Update(2,CurLine);
            Window.Update(3,ROUND(CurLine / TotalLines * 10000,1));
            if GenJnlTemplate."Force Doc. Balance" then
              AddBalancingAccount(GenJnlLine,Rec)
            else begin
              TotalDepositLinesLCY := TotalDepositLinesLCY + GenJnlLine."Amount (LCY)";
              GenJnlLine."Bal. Account No." := '';
            end;
            GenJnlLine."Source Code" := SourceCodeSetup.Deposits;
            GenJnlLine."Source Type" := GenJnlLine."source type"::"Bank Account";
            GenJnlLine."Source No." := "Bank Account No.";
            GenJnlLine."Source Currency Code" := "Currency Code";
            GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
            GenJnlPostLine.RunWithoutCheck(GenJnlLine);

            PostedDepositLine.Get("No.",CurLine);
            case GenJnlLine."Account Type" of
              GenJnlLine."account type"::"G/L Account",
              GenJnlLine."account type"::"Bank Account":
                begin
                  GLEntry.FindLast;
                  PostedDepositLine."Entry No." := GLEntry."Entry No.";
                  if GenJnlTemplate."Force Doc. Balance" and
                     (GenJnlLine.Amount * GLEntry.Amount < 0)
                  then
                    PostedDepositLine."Entry No." := PostedDepositLine."Entry No." - 1;
                end;
              GenJnlLine."account type"::Customer:
                begin
                  CustLedgEntry.FindLast;
                  PostedDepositLine."Entry No." := CustLedgEntry."Entry No.";
                end;
              GenJnlLine."account type"::Vendor:
                begin
                  VendLedgEntry.FindLast;
                  PostedDepositLine."Entry No." := VendLedgEntry."Entry No.";
                end;
            end;
            if GenJnlTemplate."Force Doc. Balance" then begin
              BankAccountLedgerEntry.FindLast;
              PostedDepositLine."Bank Account Ledger Entry No." := BankAccountLedgerEntry."Entry No.";
              if (GenJnlLine."Account Type" = GenJnlLine."account type"::"Bank Account") and
                 (GenJnlLine.Amount * BankAccountLedgerEntry.Amount > 0)
              then
                PostedDepositLine."Entry No." := PostedDepositLine."Entry No." - 1;
            end;
            PostedDepositLine.Modify;
          until GenJnlLine.Next = 0;

        Window.Update(4,Text007);
        if not GenJnlTemplate."Force Doc. Balance" then begin
          GenJnlLine.Init;
          GenJnlLine."Account Type" := GenJnlLine."account type"::"Bank Account";
          GenJnlLine."Account No." := "Bank Account No.";
          GenJnlLine."Posting Date" := "Posting Date";
          GenJnlLine."Document No." := "No.";
          GenJnlLine."Currency Code" := "Currency Code";
          GenJnlLine."Currency Factor" := "Currency Factor";
          GenJnlLine."Posting Group" := "Bank Acc. Posting Group";
          GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
          GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
          GenJnlLine."Dimension Set ID" := "Dimension Set ID";
          GenJnlLine."Source Code" := SourceCodeSetup.Deposits;
          GenJnlLine."Reason Code" := "Reason Code";
          GenJnlLine."Document Date" := "Document Date";
          GenJnlLine."External Document No." := "No.";
          GenJnlLine."Source Type" := GenJnlLine."source type"::"Bank Account";
          GenJnlLine."Source No." := "Bank Account No.";
          GenJnlLine."Source Currency Code" := "Currency Code";
          GenJnlLine.Description := "Posting Description";
          GenJnlLine.Amount := "Total Deposit Amount";
          GenJnlLine."Source Currency Amount" := "Total Deposit Amount";
          GenJnlLine.Validate(Amount);
          GenJnlLine."Amount (LCY)" := -TotalDepositLinesLCY;
          GenJnlPostLine.RunWithCheck(GenJnlLine);

          BankAccountLedgerEntry.FindLast;    // The last entry is the one we just posted.
          PostedDepositLine.Reset;
          PostedDepositLine.SetRange("Deposit No.","No.");
          if PostedDepositLine.Find('-') then
            repeat
              PostedDepositLine."Bank Account Ledger Entry No." := BankAccountLedgerEntry."Entry No.";
              PostedDepositLine.Modify;
            until PostedDepositLine.Next = 0;
        end;

        // Erase Original Document
        Window.Update(4,Text008);

        BankCommentLine.Reset;
        BankCommentLine.SetRange("Table Name",BankCommentLine."table name"::Deposit);
        BankCommentLine.SetRange("Bank Account No.","Bank Account No.");
        BankCommentLine.SetRange("No.","No.");
        BankCommentLine.DeleteAll;

        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name","Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name","Journal Batch Name");
        GenJnlLine.DeleteAll;
        GenJnlBatch.Get("Journal Template Name","Journal Batch Name");
        if IncStr("Journal Batch Name") <> '' then begin
          GenJnlBatch.Get("Journal Template Name","Journal Batch Name");
          GenJnlBatch.Delete;
          GenJnlBatch.Name := IncStr("Journal Batch Name");
          if GenJnlBatch.Insert then;
        end;

        Delete;

        Commit;

        UpdateAnalysisView.UpdateAll(0,true);
    end;

    var
        PostedDepositHeader: Record UnknownRecord10143;
        PostedDepositLine: Record UnknownRecord10144;
        BankCommentLine: Record UnknownRecord10122;
        BankCommentLine2: Record UnknownRecord10122;
        BankAccount: Record "Bank Account";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        SourceCodeSetup: Record "Source Code Setup";
        GLEntry: Record "G/L Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        Currency: Record Currency;
        Window: Dialog;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        Text000: label 'The %1 must match the %2.';
        Text001: label 'Posting Deposit No. %1...\\';
        Text002: label 'Deposit Line  #2########\';
        UpdateAnalysisView: Codeunit "Update Analysis View";
        TotalLines: Integer;
        CurLine: Integer;
        Text003: label '@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        Text004: label 'Status        #4###################\';
        Text005: label 'Moving Deposit to History';
        Text006: label 'Posting Lines to Ledgers';
        Text007: label 'Posting Bank Entry';
        Text008: label 'Removing Deposit Entry';
        TotalDepositLinesLCY: Decimal;

    local procedure AddBalancingAccount(var GenJnlLine: Record "Gen. Journal Line";DepositHeader: Record UnknownRecord10140)
    begin
        with GenJnlLine do begin
          "Bal. Account Type" := "bal. account type"::"Bank Account";
          "Bal. Account No." := DepositHeader."Bank Account No.";
          "Balance (LCY)" := 0;
        end;
    end;
}

