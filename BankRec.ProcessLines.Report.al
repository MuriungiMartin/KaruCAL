#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10406 "Bank Rec. Process Lines"
{
    Caption = 'Bank Rec. Process Lines';
    Permissions = TableData "Bank Account Ledger Entry"=rm,
                  TableData "Check Ledger Entry"=rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable10120;UnknownTable10120)
        {
            DataItemTableView = sorting("Bank Account No.","Statement No.");
            MaxIteration = 1;
            column(ReportForNavId_8875; 8875)
            {
            }
            dataitem(UnknownTable10121;UnknownTable10121)
            {
                DataItemLink = "Bank Account No."=field("Bank Account No."),"Statement No."=field("Statement No.");
                DataItemTableView = sorting("Bank Account No.","Statement No.","Record Type","Line No.");
                MaxIteration = 0;
                RequestFilterFields = "Posting Date","Document Type","Document No.";
                column(ReportForNavId_1224; 1224)
                {
                }
            }
            dataitem(RunProcesses;"Integer")
            {
                DataItemTableView = sorting(Number);
                MaxIteration = 1;
                column(ReportForNavId_5692; 5692)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if DoSuggestLines then
                      SuggestLines;

                    if DoMarkLines then
                      MarkLines;

                    if DoAdjLines then
                      RecordAdjustmentLines;

                    if DoClearLines then
                      ClearLines;
                end;
            }

            trigger OnPreDataItem()
            begin
                SetRange("Bank Account No.",DoBankAcct);
                SetRange("Statement No.",DoStatementNo);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(RecordTypeToProcess;RecordTypeToProcess)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Record type to process';
                        OptionCaption = 'Checks,Deposits,Both';
                        ToolTip = 'Specifies the type of bank reconciliation records to process: Checks, Deposits, or Both.';
                    }
                    field(MarkAsCleared;MarkCleared)
                    {
                        ApplicationArea = All;
                        Caption = 'Mark lines as cleared';
                        ToolTip = 'Specifies is cleared bank reconciliation lines are marked as cleared. In that case, you must select Process in the Record type to process field.';
                        Visible = MarkAsClearedVisible;
                    }
                    field(ReplaceLines;ReplaceExisting)
                    {
                        ApplicationArea = All;
                        Caption = 'Replace existing lines';
                        ToolTip = 'Specifies if identical existing bank account reconciliation lines are replaced. ';
                        Visible = ReplaceLinesVisible;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            MarkAsClearedVisible := true;
            ReplaceLinesVisible := true;
        end;

        trigger OnOpenPage()
        begin
            ReplaceLinesVisible := DoSuggestLines;
            MarkAsClearedVisible := DoMarkLines;
        end;
    }

    labels
    {
    }

    var
        DoSuggestLines: Boolean;
        DoMarkLines: Boolean;
        DoAdjLines: Boolean;
        DoClearLines: Boolean;
        ReplaceExisting: Boolean;
        MarkCleared: Boolean;
        RecordTypeToProcess: Option Checks,Deposits,Both;
        LastLineNo: Integer;
        AdjAmount: Decimal;
        DoBankAcct: Code[20];
        DoStatementNo: Code[20];
        GLSetup: Record "General Ledger Setup";
        BankRecLine: Record UnknownRecord10121;
        Window: Dialog;
        Text001: label 'Processing bank account           #1####################\\';
        Text002: label 'Reading bank ledger entries       #2##########\';
        Text003: label 'Reading check ledger entries      #3##########\';
        Text004: label '                      Statement   #2####################\';
        Text005: label '                  Marking lines   #3####################';
        Text006: label '              Processing lines    #3####################';
        Text007: label '                  Clearing lines  #3####################';
        Text008: label 'Collapsing Deposit Lines...';
        [InDataSet]
        ReplaceLinesVisible: Boolean;
        [InDataSet]
        MarkAsClearedVisible: Boolean;


    procedure SetDoSuggestLines(UseDo: Boolean;UseBankAcct: Code[20];UseStatementNo: Code[20])
    begin
        DoSuggestLines := UseDo;
        DoBankAcct := UseBankAcct;
        DoStatementNo := UseStatementNo;
    end;


    procedure SetDoMarkLines(UseDo: Boolean;UseBankAcct: Code[20];UseStatementNo: Code[20])
    begin
        DoMarkLines := UseDo;
        DoBankAcct := UseBankAcct;
        DoStatementNo := UseStatementNo;
    end;


    procedure SetDoAdjLines(UseDo: Boolean;UseBankAcct: Code[20];UseStatementNo: Code[20])
    begin
        DoAdjLines := UseDo;
        DoBankAcct := UseBankAcct;
        DoStatementNo := UseStatementNo;
    end;


    procedure SetDoClearLines(UseDo: Boolean;UseBankAcct: Code[20];UseStatementNo: Code[20])
    begin
        DoClearLines := UseDo;
        DoBankAcct := UseBankAcct;
        DoStatementNo := UseStatementNo;
    end;


    procedure SuggestLines()
    var
        RecordType: Option Check,Deposit,Adjustment;
        BankLedger: Record "Bank Account Ledger Entry";
        CheckLedger: Record "Check Ledger Entry";
        BankRecLine2: Record UnknownRecord10121;
    begin
        Window.Open(Text001 + Text002 + Text003);
        Window.Update(1,"Bank Rec. Header"."Bank Account No.");

        if ReplaceExisting then begin
          BankRecLine.SetCurrentkey("Bank Account No.","Statement No.");
          BankRecLine.SetRange("Bank Account No.","Bank Rec. Header"."Bank Account No.");
          BankRecLine.SetRange("Statement No.","Bank Rec. Header"."Statement No.");
          if RecordTypeToProcess <> Recordtypetoprocess::Both then
            BankRecLine.SetRange("Record Type",RecordTypeToProcess);
          BankRecLine.DeleteAll(true);
          BankRecLine.Reset;
        end;

        with BankLedger do begin
          SetCurrentkey("Bank Account No.","Posting Date","Statement Status");
          SetRange("Bank Account No.","Bank Rec. Header"."Bank Account No.");
          SetRange("Statement Status","statement status"::Open);
          if "Bank Rec. Line".GetFilter("Posting Date") = '' then
            SetRange("Posting Date",0D,"Bank Rec. Header"."Statement Date")
          else
            "Bank Rec. Line".Copyfilter("Posting Date","Posting Date");
          "Bank Rec. Line".Copyfilter("Document Type","Document Type");
          "Bank Rec. Line".Copyfilter("Document No.","Document No.");
          "Bank Rec. Line".Copyfilter("External Document No.","External Document No.");
          if Find('-') then
            repeat
              Window.Update(2,"Entry No.");
              CheckLedger.SetCurrentkey("Bank Account Ledger Entry No.");
              CheckLedger.SetRange("Bank Account Ledger Entry No.","Entry No.");
              CheckLedger.SetRange("Statement Status","statement status"::Open);
              if CheckLedger.Find('-') then begin
                repeat
                  Window.Update(3,CheckLedger."Entry No.");
                  if RecordTypeToProcess in [Recordtypetoprocess::Both,Recordtypetoprocess::Checks] then
                    WriteLine("Bank Rec. Header",
                      BankRecLine,
                      ReplaceExisting,
                      Recordtype::Check,
                      CheckLedger."Document Type",
                      CheckLedger."Check No.",
                      CheckLedger.Description,
                      CheckLedger.Amount,
                      CheckLedger."External Document No.",
                      "Entry No.",
                      CheckLedger."Entry No.",
                      CheckLedger."Posting Date",
                      "Global Dimension 1 Code",
                      "Global Dimension 2 Code",
                      "Dimension Set ID");

                until CheckLedger.Next = 0;
              end else begin
                if RecordTypeToProcess in [Recordtypetoprocess::Both,Recordtypetoprocess::Deposits] then
                  WriteLine("Bank Rec. Header",
                    BankRecLine,
                    ReplaceExisting,
                    Recordtype::Deposit,
                    "Document Type",
                    "Document No.",
                    Description,
                    Amount,
                    "External Document No.",
                    "Entry No.",
                    0,
                    "Posting Date",
                    "Global Dimension 1 Code",
                    "Global Dimension 2 Code",
                    "Dimension Set ID");
              end;
            until Next = 0;
        end;
        Window.Close;
        if RecordTypeToProcess in [Recordtypetoprocess::Both,Recordtypetoprocess::Deposits] then begin
          Window.Open(Text008);
          with BankRecLine do begin
            Reset;
            SetCurrentkey("Bank Account No.","Statement No.","Record Type");
            SetRange("Bank Account No.","Bank Rec. Header"."Bank Account No.");
            SetRange("Statement No.","Bank Rec. Header"."Statement No.");
            SetRange("Record Type","record type"::Deposit);
            SetRange("Collapse Status","collapse status"::"Expanded Deposit Line");
            if Find('-') then
              repeat
                BankRecLine2 := BankRecLine;
                CollapseLines(BankRecLine2);
              until Next = 0;
            Reset;
          end;
          Window.Close;
        end;
    end;


    procedure MarkLines()
    begin
        Window.Open(Text001 + Text004 + Text005);
        Window.Update(1,"Bank Rec. Header"."Bank Account No.");
        Window.Update(2,"Bank Rec. Header"."Statement No.");

        BankRecLine.CopyFilters("Bank Rec. Line");
        if RecordTypeToProcess = Recordtypetoprocess::Both then
          BankRecLine.SetRange("Record Type",BankRecLine."record type"::Check,
            BankRecLine."record type"::Deposit)
        else
          if RecordTypeToProcess = Recordtypetoprocess::Checks then
            BankRecLine.SetRange("Record Type",BankRecLine."record type"::Check)
          else
            BankRecLine.SetRange("Record Type",BankRecLine."record type"::Deposit);

        if BankRecLine.Find('-') then
          repeat
            BankRecLine.Validate(Cleared,MarkCleared);
            BankRecLine.Modify;
            Window.Update(3,BankRecLine."Line No.");
          until BankRecLine.Next = 0;

        Window.Close;
    end;


    procedure RecordAdjustmentLines()
    var
        UseRecordType: Option Check,Deposit,Adjustment;
        NewBankRecLine: Record UnknownRecord10121;
    begin
        Window.Open(Text001 + Text004 + Text006);
        Window.Update(1,"Bank Rec. Header"."Bank Account No.");
        Window.Update(2,"Bank Rec. Header"."Statement No.");

        GLSetup.Get;

        with BankRecLine do begin
          Reset;
          SetCurrentkey("Bank Account No.",
            "Statement No.",
            "Record Type",
            Cleared);
          SetRange("Bank Account No.","Bank Rec. Header"."Bank Account No.");
          SetRange("Statement No.","Bank Rec. Header"."Statement No.");
          if RecordTypeToProcess <> Recordtypetoprocess::Both then
            SetRange("Record Type",RecordTypeToProcess);
          SetRange(Cleared,true);

          if Find('-') then
            repeat
              Window.Update(3,"Line No.");
              if "Record Type" = "record type"::Check then
                AdjAmount := -("Cleared Amount" - Amount)
              else
                AdjAmount := "Cleared Amount" - Amount;
              if AdjAmount <> 0 then begin
                WriteAdjLine("Bank Rec. Header",
                  NewBankRecLine,
                  Userecordtype::Adjustment,
                  "Document Type",
                  "Document No.",
                  Description,
                  AdjAmount,
                  "External Document No.",
                  "Record Type",
                  "Dimension Set ID");
                Modify;
              end;
            until Next = 0;
        end;
        Window.Close;
    end;


    procedure ClearLines()
    begin
        Window.Open(Text001 + Text004 + Text007);
        Window.Update(1,"Bank Rec. Header"."Bank Account No.");
        Window.Update(2,"Bank Rec. Header"."Statement No.");

        BankRecLine.CopyFilters("Bank Rec. Line");
        if RecordTypeToProcess = Recordtypetoprocess::Both then
          BankRecLine.SetRange("Record Type",BankRecLine."record type"::Check,
            BankRecLine."record type"::Deposit)
        else
          if RecordTypeToProcess = Recordtypetoprocess::Checks then
            BankRecLine.SetRange("Record Type",BankRecLine."record type"::Check)
          else
            BankRecLine.SetRange("Record Type",BankRecLine."record type"::Deposit);

        if BankRecLine.Find('-') then
          repeat
            BankRecLine.Delete(true);
            Window.Update(3,BankRecLine."Line No.");
          until BankRecLine.Next = 0;

        Window.Close;
    end;

    local procedure WriteLine(BankRecHdr2: Record UnknownRecord10120;var BankRecLine2: Record UnknownRecord10121;UseReplaceExisting: Boolean;UseRecordType: Option Check,Deposit,Adjustment;UseDocumentType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;UseDocumentNo: Code[20];UseDescription: Text[50];UseAmount: Decimal;UseExtDocNo: Code[35];UseBankLedgerEntryNo: Integer;UseCheckLedgerEntryNo: Integer;UsePostingDate: Date;UseDimCode1: Code[20];UseDimCode2: Code[20];UseDimSetID: Integer)
    var
        Ok: Boolean;
    begin
        if (RecordTypeToProcess = Recordtypetoprocess::Both) or
           (UseRecordType = RecordTypeToProcess)
        then
          with BankRecHdr2 do begin
            BankRecLine2.SetCurrentkey("Bank Account No.","Statement No.");
            BankRecLine2.SetRange("Bank Account No.","Bank Account No.");
            BankRecLine2.SetRange("Statement No.","Statement No.");
            if BankRecLine2.Find('+') then
              LastLineNo := BankRecLine2."Line No."
            else
              LastLineNo := 0;
            BankRecLine2.Reset;

            BankRecLine2.Init;
            BankRecLine2."Bank Account No." := "Bank Account No.";
            BankRecLine2."Statement No." := "Statement No.";
            BankRecLine2."Record Type" := UseRecordType;
            BankRecLine2."Posting Date" := UsePostingDate;
            BankRecLine2."Document Type" := UseDocumentType;
            BankRecLine2."Document No." := UseDocumentNo;
            BankRecLine2.Description := UseDescription;
            BankRecLine2.Amount := UseAmount;
            BankRecLine2.Validate("Currency Code","Currency Code");
            BankRecLine2."External Document No." := UseExtDocNo;
            BankRecLine2."Bank Ledger Entry No." := UseBankLedgerEntryNo;
            BankRecLine2."Check Ledger Entry No." := UseCheckLedgerEntryNo;
            BankRecLine2."Shortcut Dimension 1 Code" := UseDimCode1;
            BankRecLine2."Shortcut Dimension 2 Code" := UseDimCode2;
            BankRecLine2."Dimension Set ID" := UseDimSetID;
            if (UseRecordType = Userecordtype::Deposit) and (UseExtDocNo <> '') then
              BankRecLine2."Collapse Status" := BankRecLine2."collapse status"::"Expanded Deposit Line";

            if UseReplaceExisting then
              InsertLine(BankRecLine2)
            else begin
              BankRecLine2.SetCurrentkey("Bank Account No.",
                "Statement No.",
                "Posting Date",
                "Document Type",
                "Document No.",
                "External Document No.");
              BankRecLine2.SetRange("Bank Account No.","Bank Account No.");
              BankRecLine2.SetRange("Statement No.","Statement No.");
              BankRecLine2.SetRange("Bank Ledger Entry No.",UseBankLedgerEntryNo);
              BankRecLine2.SetRange("Check Ledger Entry No.",UseCheckLedgerEntryNo);
              Ok := BankRecLine2.Find('-');
              if Ok then begin
                BankRecLine2.Description := UseDescription;
                BankRecLine2.Amount := UseAmount;
                BankRecLine2.Validate("Currency Code","Currency Code");
                BankRecLine2.Modify;
              end else
                InsertLine(BankRecLine2);
            end;
          end;
    end;

    local procedure InsertLine(var BankRecLine3: Record UnknownRecord10121)
    var
        Ok: Boolean;
    begin
        repeat
          LastLineNo := LastLineNo + 10000;
          BankRecLine3."Line No." := LastLineNo;
          Ok := BankRecLine3.Insert(true);
        until Ok
    end;

    local procedure WriteAdjLine(BankRecHdr2: Record UnknownRecord10120;var BankRecLine2: Record UnknownRecord10121;UseRecordType: Option Check,Deposit,Adjustment;UseDocumentType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;UseDocumentNo: Code[20];UseDescription: Text[50];UseAmount: Decimal;UseExtDocNo: Code[35];UseSourceType: Option Check,Deposit,Adjustment;DimSetID: Integer)
    var
        Ok: Boolean;
        WorkDocumentNo: Code[20];
        NoSeriesMgmnt: Codeunit NoSeriesManagement;
    begin
        with BankRecHdr2 do begin
          if BankRecLine2.Find('+') then
            LastLineNo := BankRecLine2."Line No."
          else
            LastLineNo := 0;

          NoSeriesMgmnt.InitSeries(GLSetup."Bank Rec. Adj. Doc. Nos.",'',"Statement Date",WorkDocumentNo,
            BankRecLine2."Adj. No. Series");

          BankRecLine2.Init;
          BankRecLine2."Bank Account No." := "Bank Account No.";
          BankRecLine2."Statement No." := "Statement No.";
          BankRecLine2."Record Type" := UseRecordType;
          BankRecLine2."Posting Date" := "Statement Date";
          BankRecLine2."Document Type" := UseDocumentType;
          BankRecLine2."Document No." := WorkDocumentNo;
          BankRecLine2."Dimension Set ID" := DimSetID;
          BankRecLine2.Description := CopyStr(StrSubstNo('Adjustment to %1',UseDescription),1,50);
          BankRecLine2.Cleared := true;
          BankRecLine2.Amount := UseAmount;
          BankRecLine2."Cleared Amount" := BankRecLine2.Amount;
          BankRecLine2.Validate("Currency Code","Currency Code");
          BankRecLine2."External Document No." := UseExtDocNo;
          BankRecLine2."Account Type" := BankRecLine2."account type"::"Bank Account";
          BankRecLine2."Account No." := "Bank Account No.";
          BankRecLine2."Adj. Source Record ID" := UseSourceType;
          BankRecLine2."Adj. Source Document No." := UseDocumentNo;

          repeat
            LastLineNo := LastLineNo + 10000;
            BankRecLine2."Line No." := LastLineNo;
            Ok := BankRecLine2.Insert;
          until Ok
        end;
    end;
}

