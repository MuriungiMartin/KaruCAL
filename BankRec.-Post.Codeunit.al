#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10120 "Bank Rec.-Post"
{
    Permissions = TableData "Bank Account"=rm,
                  TableData "Bank Account Ledger Entry"=rm,
                  TableData "Check Ledger Entry"=rm,
                  TableData "Dim. Value per Account"=rimd,
                  TableData UnknownTableData10120=rmd,
                  TableData UnknownTableData10121=rmd,
                  TableData UnknownTableData10122=rimd,
                  TableData UnknownTableData10123=rimd,
                  TableData UnknownTableData10124=rimd,
                  TableData UnknownTableData10125=rimd;
    TableNo = UnknownTable10120;

    trigger OnRun()
    begin
        ClearAll;

        BankRecHeader := Rec;
        with BankRecHeader do begin
          TestField("Statement Date");
          TestField("Statement No.");
          TestField("Bank Account No.");

          CalculateBalance;
          if ("G/L Balance" +
              ("Positive Adjustments" - "Negative Bal. Adjustments") +
              ("Negative Adjustments" - "Positive Bal. Adjustments")) -
             (("Statement Balance" + "Outstanding Deposits") - "Outstanding Checks") <> 0
          then
            Error(Text007);

          CalcFields("Total Adjustments","Total Balanced Adjustments");
          if ("Total Adjustments" - "Total Balanced Adjustments") <> 0 then
            Error(Text008);

          Window.Open(Text001 +
            Text002 +
            Text003 +
            Text004 +
            Text005 +
            Text006);

          Window.Update(1,"Bank Account No.");
          Window.Update(2,"Statement No.");

          GLSetup.Get;

          BankRecLine.LockTable;
          PostedBankRecLine.LockTable;

          SourceCodeSetup.Get;

          SetRange("Date Filter","Statement Date");
          CalcFields("G/L Balance (LCY)");
          CalculateBalance;

          PostedBankRecHeader.Init;
          PostedBankRecHeader.TransferFields(BankRecHeader,true);
          PostedBankRecHeader."G/L Balance (LCY)" := "G/L Balance (LCY)";
          PostedBankRecHeader.Insert;

          BankRecCommentLine.SetCurrentkey("Table Name",
            "Bank Account No.",
            "No.");
          BankRecCommentLine.SetRange("Table Name",BankRecCommentLine."table name"::"Bank Rec.");
          BankRecCommentLine.SetRange("Bank Account No.","Bank Account No.");
          BankRecCommentLine.SetRange("No.","Statement No.");
          if BankRecCommentLine.Find('-') then
            repeat
              Window.Update(3,BankRecCommentLine."Line No.");

              PostedBankRecCommentLine.Init;
              PostedBankRecCommentLine.TransferFields(BankRecCommentLine,true);
              PostedBankRecCommentLine."Table Name" := PostedBankRecCommentLine."table name"::"Posted Bank Rec.";
              PostedBankRecCommentLine.Insert;
            until BankRecCommentLine.Next = 0;
          BankRecCommentLine.DeleteAll;

          BankRecLine.Reset;
          BankRecLine.SetCurrentkey("Bank Account No.",
            "Statement No.");
          BankRecLine.SetRange("Bank Account No.","Bank Account No.");
          BankRecLine.SetRange("Statement No.","Statement No.");
          if BankRecLine.Find('-') then
            repeat
              Window.Update(BankRecLine."Record Type" + 4,BankRecLine."Line No.");
              if BankRecLine."Record Type" = BankRecLine."record type"::Adjustment then
                if (GLSetup."Bank Rec. Adj. Doc. Nos." <> '') and
                   (BankRecLine."Document No." <> NoSeriesMgt.GetNextNo(GLSetup."Bank Rec. Adj. Doc. Nos.",
                      "Posting Date",false))
                then
                  NoSeriesMgt.TestManual(GLSetup."Bank Rec. Adj. Doc. Nos.");

              if BankRecLine."Record Type" = BankRecLine."record type"::Adjustment then
                PostAdjustmentToGL(BankRecLine)
              else
                if BankRecLine.Cleared then
                  UpdateLedgers(BankRecLine,Setstatus::Posted)
                else
                  UpdateLedgers(BankRecLine,Setstatus::Open);

              PostedBankRecLine.Init;
              PostedBankRecLine.TransferFields(BankRecLine,true);
              PostedBankRecLine.Insert;
            until BankRecLine.Next = 0;
          BankRecLine.DeleteAll;
          BankRecSubLine.Reset;
          BankRecSubLine.SetRange("Bank Account No.","Bank Account No.");
          BankRecSubLine.SetRange("Statement No.","Statement No.");
          BankRecSubLine.DeleteAll;

          BankAccount.Get("Bank Account No.");
          BankAccount."Last Statement No." := "Statement No.";
          BankAccount."Balance Last Statement" := "Statement Balance";
          BankAccount.Modify;

          Delete;

          Commit;
          Window.Close;
        end;
        if GLSetup."Bank Rec. Adj. Doc. Nos." <> '' then
          NoSeriesMgt.SaveNoSeries;
        Rec := BankRecHeader;
        UpdateAnalysisView.UpdateAll(0,true);
    end;

    var
        SetStatus: Option Open,Cleared,Posted;
        BankRecHeader: Record UnknownRecord10120;
        BankRecLine: Record UnknownRecord10121;
        BankRecCommentLine: Record UnknownRecord10122;
        BankRecSubLine: Record UnknownRecord10126;
        PostedBankRecHeader: Record UnknownRecord10123;
        PostedBankRecLine: Record UnknownRecord10124;
        PostedBankRecCommentLine: Record UnknownRecord10122;
        GLSetup: Record "General Ledger Setup";
        SourceCodeSetup: Record "Source Code Setup";
        BankAccount: Record "Bank Account";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        Window: Dialog;
        Text001: label 'Posting Bank Account  #1#################### \\';
        Text002: label 'Statement             #2#################### \';
        Text003: label 'Comment               #3########## \';
        Text004: label 'Check                 #4########## \';
        Text005: label 'Deposit               #5########## \';
        Text006: label 'Adjustment            #6########## \';
        Text007: label 'Difference must be zero before the statement can be posted.';
        Text008: label 'Balance of adjustments must be zero before posting.';
        NoSeriesMgt: Codeunit NoSeriesManagement;


    procedure UpdateLedgers(BankRecLine3: Record UnknownRecord10121;UseStatus: Option Open,Cleared,Posted)
    var
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        CheckLedgerEntry: Record "Check Ledger Entry";
        BankRecSubLine: Record UnknownRecord10126;
        CheckLedgerEntry2: Record "Check Ledger Entry";
    begin
        if (BankRecLine3."Bank Ledger Entry No." <> 0) and (BankRecLine3."Check Ledger Entry No." = 0) then
          UpdateBankLedger(
            BankRecLine3."Bank Ledger Entry No.",UseStatus,
            BankRecLine3."Statement No.",BankRecLine3."Line No.");
        if BankRecLine3."Check Ledger Entry No." <> 0 then
          if CheckLedgerEntry.Get(BankRecLine3."Check Ledger Entry No.") then begin
            if UseStatus = Usestatus::Posted then
              CheckLedgerEntry.Open := false;
            case UseStatus of
              Usestatus::Open:
                CheckLedgerEntry."Statement Status" := CheckLedgerEntry."statement status"::Open;
              Usestatus::Cleared:
                CheckLedgerEntry."Statement Status" := CheckLedgerEntry."statement status"::"Check Entry Applied";
              Usestatus::Posted:
                CheckLedgerEntry."Statement Status" := CheckLedgerEntry."statement status"::Closed;
            end;
            if CheckLedgerEntry."Statement Status" = CheckLedgerEntry."statement status"::Open then begin
              CheckLedgerEntry."Statement No." := '';
              CheckLedgerEntry."Statement Line No." := 0;
            end else begin
              CheckLedgerEntry."Statement No." := BankRecLine3."Statement No.";
              CheckLedgerEntry."Statement Line No." := BankRecLine3."Line No.";
            end;
            CheckLedgerEntry.Modify;
            if (CheckLedgerEntry."Check Type" = CheckLedgerEntry."check type"::"Total Check") or
               (UseStatus <> Usestatus::Posted)
            then
              UpdateBankLedger(
                BankRecLine3."Bank Ledger Entry No.",UseStatus,
                BankRecLine3."Statement No.",BankRecLine3."Line No.")
            else begin
              CheckLedgerEntry2.Reset;
              CheckLedgerEntry2.SetCurrentkey("Bank Account Ledger Entry No.");
              CheckLedgerEntry2.SetRange("Bank Account Ledger Entry No.",CheckLedgerEntry."Bank Account Ledger Entry No.");
              CheckLedgerEntry2.SetFilter("Statement Status",'<>%1',CheckLedgerEntry."statement status"::Closed);
              if CheckLedgerEntry2.Find('-') then begin
                if BankLedgerEntry.Get(CheckLedgerEntry2."Bank Account Ledger Entry No.") then begin
                  BankLedgerEntry."Remaining Amount" := 0;
                  repeat
                    BankLedgerEntry."Remaining Amount" :=
                      BankLedgerEntry."Remaining Amount" - CheckLedgerEntry2.Amount;
                  until CheckLedgerEntry2.Next = 0;
                  BankLedgerEntry.Modify;
                end;
              end else
                UpdateBankLedger(
                  BankRecLine3."Bank Ledger Entry No.",UseStatus,
                  BankRecLine3."Statement No.",BankRecLine3."Line No.");
            end;
          end;
        if BankRecLine3."Collapse Status" = BankRecLine3."collapse status"::"Collapsed Deposit" then begin
          BankRecSubLine.SetRange("Bank Account No.",BankRecLine3."Bank Account No.");
          BankRecSubLine.SetRange("Statement No.",BankRecLine3."Statement No.");
          BankRecSubLine.SetRange("Bank Rec. Line No.",BankRecLine3."Line No.");
          if BankRecSubLine.Find('-') then
            repeat
              UpdateBankLedger(
                BankRecSubLine."Bank Ledger Entry No.",UseStatus,
                BankRecLine3."Statement No.",BankRecLine3."Line No.");
            until BankRecSubLine.Next = 0;
        end;
    end;

    local procedure UpdateBankLedger(BankLedgerEntryNo: Integer;UseStatus: Option Open,Cleared,Posted;StatementNo: Code[20];StatementLineNo: Integer)
    var
        BankLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        if BankLedgerEntry.Get(BankLedgerEntryNo) then begin
          if UseStatus = Usestatus::Posted then begin
            BankLedgerEntry.Open := false;
            BankLedgerEntry."Remaining Amount" := 0;
          end;
          case UseStatus of
            Usestatus::Open:
              BankLedgerEntry."Statement Status" := BankLedgerEntry."statement status"::Open;
            Usestatus::Cleared:
              BankLedgerEntry."Statement Status" := BankLedgerEntry."statement status"::"Bank Acc. Entry Applied";
            Usestatus::Posted:
              BankLedgerEntry."Statement Status" := BankLedgerEntry."statement status"::Closed;
          end;
          if BankLedgerEntry."Statement Status" = BankLedgerEntry."statement status"::Open then begin
            BankLedgerEntry."Statement No." := '';
            BankLedgerEntry."Statement Line No." := 0;
          end else begin
            BankLedgerEntry."Statement No." := StatementNo;
            BankLedgerEntry."Statement Line No." := StatementLineNo;
          end;
          BankLedgerEntry.Modify;
        end;
    end;

    local procedure PostAdjustmentToGL(BankRecLine2: Record UnknownRecord10121)
    var
        GenJnlLine: Record "Gen. Journal Line";
        GLEntry: Record "G/L Entry";
    begin
        with BankRecLine2 do
          if Amount <> 0 then begin
            GenJnlLine.Init;
            GenJnlLine."Posting Date" := "Posting Date";
            GenJnlLine."Document Date" := "Posting Date";
            GenJnlLine.Description := Description;
            GenJnlLine."Account Type" := "Account Type";
            GenJnlLine."Account No." := "Account No.";
            GenJnlLine."Bal. Account Type" := "Bal. Account Type";
            GenJnlLine."Bal. Account No." := "Bal. Account No.";
            GenJnlLine."Document Type" := "Document Type";
            GenJnlLine."Document No." := "Document No.";
            GenJnlLine."External Document No." := "External Document No.";
            GenJnlLine."Currency Code" := "Currency Code";
            GenJnlLine."Currency Factor" := "Currency Factor";
            GenJnlLine."Source Currency Code" := "Currency Code";
            GenJnlLine."Source Currency Amount" := Amount;
            if "Currency Code" = '' then
              GenJnlLine."Currency Factor" := 1
            else
              GenJnlLine."Currency Factor" := "Currency Factor";
            GenJnlLine.Validate(Amount,Amount);
            GenJnlLine."Source Type" := "Account Type";
            GenJnlLine."Source No." := "Account No.";
            GenJnlLine."Source Code" := SourceCodeSetup."Bank Rec. Adjustment";
            GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := "Dimension Set ID";

            GenJnlPostLine.RunWithCheck(GenJnlLine);

            GLEntry.FindLast;
            if GLEntry."Bal. Account Type" = GLEntry."bal. account type"::"Bank Account" then
              "Bank Ledger Entry No." := GLEntry."Entry No." - 1
            else
              "Bank Ledger Entry No." := GLEntry."Entry No.";
            "Check Ledger Entry No." := 0;
            Modify;
            UpdateLedgers(BankRecLine2,Setstatus::Posted);
          end;
    end;
}

