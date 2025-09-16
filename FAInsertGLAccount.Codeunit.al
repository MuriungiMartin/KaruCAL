#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5601 "FA Insert G/L Account"
{
    TableNo = "FA Ledger Entry";

    trigger OnRun()
    var
        DisposalEntry: Boolean;
    begin
        Clear(FAGLPostBuf);
        DisposalEntry :=
          ("FA Posting Category" = "fa posting category"::" ") and
          ("FA Posting Type" = "fa posting type"::"Proceeds on Disposal");
        if not BookValueEntry then
          BookValueEntry :=
            ("FA Posting Category" = "fa posting category"::Disposal) and
            ("FA Posting Type" = "fa posting type"::"Book Value on Disposal");

        if not DisposalEntry then
          FAGLPostBuf."Account No." := FAGetGLAcc.GetAccNo(Rec);
        FAGLPostBuf.Amount := Amount;
        FAGLPostBuf.Correction := Correction;
        FAGLPostBuf."Global Dimension 1 Code" := "Global Dimension 1 Code";
        FAGLPostBuf."Global Dimension 2 Code" := "Global Dimension 2 Code";
        FAGLPostBuf."Dimension Set ID" := "Dimension Set ID";
        FAGLPostBuf."FA Entry No." := "Entry No.";
        if "Entry No." > 0 then
          FAGLPostBuf."FA Entry Type" := FAGLPostBuf."fa entry type"::"Fixed Asset";
        FAGLPostBuf."Automatic Entry" := "Automatic Entry";
        GLEntryNo := "G/L Entry No.";
        InsertBufferEntry;
        "G/L Entry No." := TempFAGLPostBuf."Entry No.";
        if DisposalEntry then
          CalcDisposalAmount(Rec);
    end;

    var
        Text000: label 'must not be more than 100';
        Text001: label 'There is not enough space to insert the balance accounts.';
        TempFAGLPostBuf: Record "FA G/L Posting Buffer" temporary;
        FAGLPostBuf: Record "FA G/L Posting Buffer";
        FAAlloc: Record "FA Allocation";
        FAPostingGr: Record "FA Posting Group";
        FAPostingGr2: Record "FA Posting Group";
        FADeprBook: Record "FA Depreciation Book";
        FADimMgt: Codeunit FADimensionManagement;
        FAGetGLAcc: Codeunit "FA Get G/L Account No.";
        DepreciationCalc: Codeunit "Depreciation Calculation";
        NextEntryNo: Integer;
        GLEntryNo: Integer;
        TotalAllocAmount: Decimal;
        NewAmount: Decimal;
        TotalPercent: Decimal;
        NumberOfEntries: Integer;
        NextLineNo: Integer;
        NoOfEmptyLines: Integer;
        NoOfEmptyLines2: Integer;
        OrgGenJnlLine: Boolean;
        DisposalEntryNo: Integer;
        GainLossAmount: Decimal;
        DisposalAmount: Decimal;
        BookValueEntry: Boolean;
        NetDisp: Boolean;


    procedure InsertMaintenanceAccNo(var MaintenanceLedgEntry: Record "Maintenance Ledger Entry")
    begin
        with MaintenanceLedgEntry do begin
          Clear(FAGLPostBuf);
          FAGLPostBuf."Account No." := FAGetGLAcc.GetMaintenanceAccNo(MaintenanceLedgEntry);
          FAGLPostBuf.Amount := Amount;
          FAGLPostBuf.Correction := Correction;
          FAGLPostBuf."Global Dimension 1 Code" := "Global Dimension 1 Code";
          FAGLPostBuf."Global Dimension 2 Code" := "Global Dimension 2 Code";
          FAGLPostBuf."Dimension Set ID" := "Dimension Set ID";
          FAGLPostBuf."FA Entry No." := "Entry No.";
          FAGLPostBuf."FA Entry Type" := FAGLPostBuf."fa entry type"::Maintenance;
          GLEntryNo := "G/L Entry No.";
          InsertBufferEntry;
          "G/L Entry No." := TempFAGLPostBuf."Entry No.";
        end;
    end;

    local procedure InsertBufferBalAcc(FAPostingType: Option Acquisition,Depr,WriteDown,Appr,Custom1,Custom2,Disposal,Maintenance,Gain,Loss,"Book Value Gain","Book Value Loss";AllocAmount: Decimal;DeprBookCode: Code[10];PostingGrCode: Code[10];GlobalDim1Code: Code[20];GlobalDim2Code: Code[20];DimSetID: Integer;AutomaticEntry: Boolean;Correction: Boolean)
    var
        DimMgt: Codeunit DimensionManagement;
        GLAccNo: Code[20];
        DimensionSetIDArr: array [10] of Integer;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        NumberOfEntries := 0;
        TotalAllocAmount := 0;
        NewAmount := 0;
        TotalPercent := 0;
        with FAPostingGr do begin
          Reset;
          Get(PostingGrCode);
          GLAccNo := GetGLAccNoFromFAPostingGroup(FAPostingGr,FAPostingType);
        end;

        DimensionSetIDArr[1] := DimSetID;

        with FAAlloc do begin
          Reset;
          SetRange(Code,PostingGrCode);
          SetRange("Allocation Type",FAPostingType);
          if Find('-') then
            repeat
              if ("Account No." = '') and ("Allocation %" > 0) then
                TestField("Account No.");
              TotalPercent := TotalPercent + "Allocation %";
              NewAmount :=
                DepreciationCalc.CalcRounding(DeprBookCode,AllocAmount * TotalPercent / 100) - TotalAllocAmount;
              TotalAllocAmount := TotalAllocAmount + NewAmount;
              if Abs(TotalAllocAmount) > Abs(AllocAmount) then
                NewAmount := AllocAmount - (TotalAllocAmount - NewAmount);
              Clear(FAGLPostBuf);
              FAGLPostBuf."Account No." := "Account No.";

              DimensionSetIDArr[2] := "Dimension Set ID";
              FAGLPostBuf."Dimension Set ID" :=
                DimMgt.GetCombinedDimensionSetID(
                  DimensionSetIDArr,FAGLPostBuf."Global Dimension 1 Code",FAGLPostBuf."Global Dimension 2 Code");

              FAGLPostBuf.Amount := NewAmount;
              FAGLPostBuf."Automatic Entry" := AutomaticEntry;
              FAGLPostBuf.Correction := Correction;
              FAGLPostBuf."FA Posting Group" := Code;
              FAGLPostBuf."FA Allocation Type" := "Allocation Type";
              FAGLPostBuf."FA Allocation Line No." := "Line No.";
              if NewAmount <> 0 then begin
                FADimMgt.CheckFAAllocDim(FAAlloc,FAGLPostBuf."Dimension Set ID");
                InsertBufferEntry;
              end;
            until Next = 0;
          if Abs(TotalAllocAmount) < Abs(AllocAmount) then begin
            NewAmount := AllocAmount - TotalAllocAmount;
            Clear(FAGLPostBuf);
            FAGLPostBuf."Account No." := GLAccNo;
            FAGLPostBuf.Amount := NewAmount;
            FAGLPostBuf."Global Dimension 1 Code" := GlobalDim1Code;
            FAGLPostBuf."Global Dimension 2 Code" := GlobalDim2Code;
            TableID[1] := Database::"G/L Account";
            No[1] := GLAccNo;
            FAGLPostBuf."Dimension Set ID" :=
              DimMgt.GetDefaultDimID(TableID,No,'',FAGLPostBuf."Global Dimension 1 Code",
                FAGLPostBuf."Global Dimension 2 Code",DimSetID,0);
            FAGLPostBuf."Automatic Entry" := AutomaticEntry;
            FAGLPostBuf.Correction := Correction;
            if NewAmount <> 0 then
              InsertBufferEntry;
          end;
        end;
    end;


    procedure InsertBalAcc(var FALedgEntry: Record "FA Ledger Entry")
    begin
        // Called from codeunit 5632
        with FALedgEntry do
          InsertBufferBalAcc(
            GetPostingType(FALedgEntry),-Amount,"Depreciation Book Code",
            "FA Posting Group","Global Dimension 1 Code","Global Dimension 2 Code","Dimension Set ID","Automatic Entry",Correction);
    end;

    local procedure GetPostingType(var FALedgEntry: Record "FA Ledger Entry"): Integer
    var
        FAPostingType: Option Acquisition,Depr,WriteDown,Appr,Custom1,Custom2,Disposal,Maintenance,Gain,Loss,"Book Value Gain","Book Value Loss";
    begin
        with FALedgEntry do begin
          if "FA Posting Type" >= "fa posting type"::"Gain/Loss" then begin
            if "FA Posting Type" = "fa posting type"::"Gain/Loss" then begin
              if "Result on Disposal" = "result on disposal"::Gain then
                exit(Fapostingtype::Gain);

              exit(Fapostingtype::Loss);
            end;
            if "FA Posting Type" = "fa posting type"::"Book Value on Disposal" then begin
              if "Result on Disposal" = "result on disposal"::Gain then
                exit(Fapostingtype::"Book Value Gain");

              exit(Fapostingtype::"Book Value Loss");
            end;
          end else
            exit(ConvertPostingType);
        end;
    end;


    procedure GetBalAcc(GenJnlLine: Record "Gen. Journal Line"): Integer
    var
        Description2: Text[50];
        FAAddCurrExchRate2: Decimal;
    begin
        TempFAGLPostBuf.DeleteAll;
        with GenJnlLine do begin
          Reset;
          Find;
          TestField("Bal. Account No.",'');
          TestField("Account Type","account type"::"Fixed Asset");
          TestField("Account No.");
          TestField("Depreciation Book Code");
          TestField("Posting Group");
          TestField("FA Posting Type");
          Description2 := Description;
          FAAddCurrExchRate2 := "FA Add.-Currency Factor";
          InsertBufferBalAcc(
            "FA Posting Type" - 1,-Amount,"Depreciation Book Code",
            "Posting Group","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Dimension Set ID",false,false);
          CalculateNoOfEmptyLines(GenJnlLine,NumberOfEntries);
          "Account Type" := "account type"::"G/L Account";
          "Depreciation Book Code" := '';
          "Posting Group" := '';
          Validate("FA Posting Type","fa posting type"::" ");
          if TempFAGLPostBuf.FindFirst then
            repeat
              "Line No." := 0;
              Validate("Account No.",TempFAGLPostBuf."Account No.");
              Validate(Amount,TempFAGLPostBuf.Amount);
              Validate("Depreciation Book Code",'');
              "Shortcut Dimension 1 Code" := TempFAGLPostBuf."Global Dimension 1 Code";
              "Shortcut Dimension 2 Code" := TempFAGLPostBuf."Global Dimension 2 Code";
              "Dimension Set ID" := TempFAGLPostBuf."Dimension Set ID";
              Description := Description2;
              "FA Add.-Currency Factor" := FAAddCurrExchRate2;
              InsertGenJnlLine(GenJnlLine);
            until TempFAGLPostBuf.Next = 0;
        end;
        TempFAGLPostBuf.DeleteAll;
        exit(GenJnlLine."Line No.");
    end;


    procedure GetBalAcc2(var GenJnlLine: Record "Gen. Journal Line";var NextLineNo2: Integer)
    begin
        NoOfEmptyLines2 := 1000;
        GetBalAcc(GenJnlLine);
        NextLineNo2 := NextLineNo;
    end;


    procedure GetBalAccWithBalAccountInfo(GenJnlLine: Record "Gen. Journal Line";BalAccountType: Option;BalAccountNo: Code[20])
    var
        LineNo: Integer;
    begin
        LineNo := GetBalAcc(GenJnlLine);
        GenJnlLine.Get(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name",LineNo);
        GenJnlLine.Validate("Account Type",BalAccountType);
        GenJnlLine.Validate("Account No.",BalAccountNo);
        GenJnlLine.Modify(true);
    end;

    local procedure GetGLAccNoFromFAPostingGroup(FAPostingGr: Record "FA Posting Group";FAPostingType: Option Acquisition,Depr,WriteDown,Appr,Custom1,Custom2,Disposal,Maintenance,Gain,Loss,"Book Value Gain","Book Value Loss") GLAccNo: Code[20]
    var
        FieldErrorText: Text[50];
    begin
        FieldErrorText := Text000;
        with FAPostingGr do
          case FAPostingType of
            Fapostingtype::Acquisition:
              begin
                TestField("Acquisition Cost Bal. Acc.");
                GLAccNo := "Acquisition Cost Bal. Acc.";
                CalcFields("Allocated Acquisition Cost %");
                if "Allocated Acquisition Cost %" > 100 then
                  FieldError("Allocated Acquisition Cost %",FieldErrorText);
              end;
            Fapostingtype::Depr:
              begin
                TestField("Depreciation Expense Acc.");
                GLAccNo := "Depreciation Expense Acc.";
                CalcFields("Allocated Depreciation %");
                if "Allocated Depreciation %" > 100 then
                  FieldError("Allocated Depreciation %",FieldErrorText);
              end;
            Fapostingtype::WriteDown:
              begin
                TestField("Write-Down Expense Acc.");
                GLAccNo := "Write-Down Expense Acc.";
                CalcFields("Allocated Write-Down %");
                if "Allocated Write-Down %" > 100 then
                  FieldError("Allocated Write-Down %",FieldErrorText);
              end;
            Fapostingtype::Appr:
              begin
                TestField("Appreciation Bal. Account");
                GLAccNo := "Appreciation Bal. Account";
                CalcFields("Allocated Appreciation %");
                if "Allocated Appreciation %" > 100 then
                  FieldError("Allocated Appreciation %",FieldErrorText);
              end;
            Fapostingtype::Custom1:
              begin
                TestField("Custom 1 Expense Acc.");
                GLAccNo := "Custom 1 Expense Acc.";
                CalcFields("Allocated Custom 1 %");
                if "Allocated Custom 1 %" > 100 then
                  FieldError("Allocated Custom 1 %",FieldErrorText);
              end;
            Fapostingtype::Custom2:
              begin
                TestField("Custom 2 Expense Acc.");
                GLAccNo := "Custom 2 Expense Acc.";
                CalcFields("Allocated Custom 2 %");
                if "Allocated Custom 2 %" > 100 then
                  FieldError("Allocated Custom 2 %",FieldErrorText);
              end;
            Fapostingtype::Disposal:
              begin
                TestField("Sales Bal. Acc.");
                GLAccNo := "Sales Bal. Acc.";
                CalcFields("Allocated Sales Price %");
                if "Allocated Sales Price %" > 100 then
                  FieldError("Allocated Sales Price %",FieldErrorText);
              end;
            Fapostingtype::Maintenance:
              begin
                TestField("Maintenance Bal. Acc.");
                GLAccNo := "Maintenance Bal. Acc.";
                CalcFields("Allocated Maintenance %");
                if "Allocated Maintenance %" > 100 then
                  FieldError("Allocated Maintenance %",FieldErrorText);
              end;
            Fapostingtype::Gain:
              begin
                TestField("Gains Acc. on Disposal");
                GLAccNo := "Gains Acc. on Disposal";
                CalcFields("Allocated Gain %");
                if "Allocated Gain %" > 100 then
                  FieldError("Allocated Gain %",FieldErrorText);
              end;
            Fapostingtype::Loss:
              begin
                TestField("Losses Acc. on Disposal");
                GLAccNo := "Losses Acc. on Disposal";
                CalcFields("Allocated Loss %");
                if "Allocated Loss %" > 100 then
                  FieldError("Allocated Loss %",FieldErrorText);
              end;
            Fapostingtype::"Book Value Gain":
              begin
                TestField("Book Val. Acc. on Disp. (Gain)");
                GLAccNo := "Book Val. Acc. on Disp. (Gain)";
                CalcFields("Allocated Book Value % (Gain)");
                if "Allocated Book Value % (Gain)" > 100 then
                  FieldError("Allocated Book Value % (Gain)",FieldErrorText);
              end;
            Fapostingtype::"Book Value Loss":
              begin
                TestField("Book Val. Acc. on Disp. (Loss)");
                GLAccNo := "Book Val. Acc. on Disp. (Loss)";
                CalcFields("Allocated Book Value % (Loss)");
                if "Allocated Book Value % (Loss)" > 100 then
                  FieldError("Allocated Book Value % (Loss)",FieldErrorText);
              end;
          end;
        exit(GLAccNo);
    end;

    local procedure CalculateNoOfEmptyLines(var GenJnlLine: Record "Gen. Journal Line";NumberOfEntries: Integer)
    var
        GenJnlLine2: Record "Gen. Journal Line";
    begin
        GenJnlLine2."Journal Template Name" := GenJnlLine."Journal Template Name";
        GenJnlLine2."Journal Batch Name" := GenJnlLine."Journal Batch Name";
        GenJnlLine2."Line No." := GenJnlLine."Line No.";
        GenJnlLine2.SetRange("Journal Template Name",GenJnlLine."Journal Template Name");
        GenJnlLine2.SetRange("Journal Batch Name",GenJnlLine."Journal Batch Name");
        NextLineNo := GenJnlLine."Line No.";
        if NoOfEmptyLines2 > 0 then
          NoOfEmptyLines := NoOfEmptyLines2
        else begin
          if GenJnlLine2.Next = 0 then
            NoOfEmptyLines := 1000
          else
            NoOfEmptyLines := (GenJnlLine2."Line No." - NextLineNo) DIV (NumberOfEntries + 1);
          if NoOfEmptyLines < 1 then
            Error(Text001);
        end;
    end;

    local procedure InsertGenJnlLine(var GenJnlLine: Record "Gen. Journal Line")
    var
        FAJnlSetup: Record "FA Journal Setup";
    begin
        NextLineNo := NextLineNo + NoOfEmptyLines;
        GenJnlLine."Line No." := NextLineNo;
        FAJnlSetup.SetGenJnlTrailCodes(GenJnlLine);
        GenJnlLine.Insert(true);
    end;

    local procedure InsertBufferEntry()
    begin
        if TempFAGLPostBuf.Find('+') then
          NextEntryNo := TempFAGLPostBuf."Entry No." + 1
        else
          NextEntryNo := GLEntryNo;
        TempFAGLPostBuf := FAGLPostBuf;
        TempFAGLPostBuf."Entry No." := NextEntryNo;
        TempFAGLPostBuf."Original General Journal Line" := OrgGenJnlLine;
        TempFAGLPostBuf."Net Disposal" := NetDisp;
        TempFAGLPostBuf.Insert;
        NumberOfEntries := NumberOfEntries + 1;
    end;


    procedure FindFirstGLAcc(var FAGLPostBuf: Record "FA G/L Posting Buffer"): Boolean
    var
        ReturnValue: Boolean;
    begin
        ReturnValue := TempFAGLPostBuf.Find('-');
        FAGLPostBuf := TempFAGLPostBuf;
        exit(ReturnValue);
    end;


    procedure GetNextGLAcc(var FAGLPostBuf: Record "FA G/L Posting Buffer"): Integer
    var
        ReturnValue: Integer;
    begin
        ReturnValue := TempFAGLPostBuf.Next;
        FAGLPostBuf := TempFAGLPostBuf;
        exit(ReturnValue);
    end;


    procedure DeleteAllGLAcc()
    begin
        TempFAGLPostBuf.DeleteAll;
        DisposalEntryNo := 0;
        BookValueEntry := false;
    end;


    procedure SetOrgGenJnlLine(OrgGenJnlLine2: Boolean)
    begin
        OrgGenJnlLine := OrgGenJnlLine2;
    end;

    local procedure CalcDisposalAmount(FALedgEntry: Record "FA Ledger Entry")
    begin
        DisposalEntryNo := TempFAGLPostBuf."Entry No.";
        with FALedgEntry do begin
          FADeprBook.Get("FA No.","Depreciation Book Code");
          FADeprBook.CalcFields("Proceeds on Disposal","Gain/Loss");
          DisposalAmount := FADeprBook."Proceeds on Disposal";
          GainLossAmount := FADeprBook."Gain/Loss";
          FAPostingGr2.Get("FA Posting Group");
        end;
    end;


    procedure CorrectEntries()
    begin
        if DisposalEntryNo = 0 then
          exit;
        CorrectDisposalEntry;
        if not BookValueEntry then
          CorrectBookValueEntry;
    end;

    local procedure CorrectDisposalEntry()
    var
        LastDisposal: Boolean;
        GLAmount: Decimal;
    begin
        TempFAGLPostBuf.Get(DisposalEntryNo);
        FADeprBook.CalcFields("Gain/Loss");
        LastDisposal := CalcLastDisposal(FADeprBook);
        if LastDisposal then
          GLAmount := GainLossAmount
        else
          GLAmount := FADeprBook."Gain/Loss";
        if GLAmount <= 0 then begin
          FAPostingGr2.TestField("Sales Acc. on Disp. (Gain)");
          TempFAGLPostBuf."Account No." := FAPostingGr2."Sales Acc. on Disp. (Gain)";
        end else begin
          FAPostingGr2.TestField("Sales Acc. on Disp. (Loss)");
          TempFAGLPostBuf."Account No." := FAPostingGr2."Sales Acc. on Disp. (Loss)";
        end;
        TempFAGLPostBuf.Modify;
        FAGLPostBuf := TempFAGLPostBuf;
        if LastDisposal then
          exit;
        if IdenticalSign(FADeprBook."Gain/Loss",GainLossAmount,DisposalAmount) then
          exit;
        FAPostingGr2.TestField("Sales Acc. on Disp. (Gain)");
        FAPostingGr2.TestField("Sales Acc. on Disp. (Loss)");
        if FAPostingGr2."Sales Acc. on Disp. (Gain)" = FAPostingGr2."Sales Acc. on Disp. (Loss)" then
          exit;
        FAGLPostBuf."FA Entry No." := 0;
        FAGLPostBuf."FA Entry Type" := FAGLPostBuf."fa entry type"::" ";
        FAGLPostBuf."Automatic Entry" := true;
        OrgGenJnlLine := false;
        if FADeprBook."Gain/Loss" <= 0 then begin
          FAGLPostBuf."Account No." := FAPostingGr2."Sales Acc. on Disp. (Gain)";
          FAGLPostBuf.Amount := DisposalAmount;
          InsertBufferEntry;
          FAGLPostBuf."Account No." := FAPostingGr2."Sales Acc. on Disp. (Loss)";
          FAGLPostBuf.Amount := -DisposalAmount;
          FAGLPostBuf.Correction := not FAGLPostBuf.Correction;
          InsertBufferEntry;
        end else begin
          FAGLPostBuf."Account No." := FAPostingGr2."Sales Acc. on Disp. (Loss)";
          FAGLPostBuf.Amount := DisposalAmount;
          InsertBufferEntry;
          FAGLPostBuf."Account No." := FAPostingGr2."Sales Acc. on Disp. (Gain)";
          FAGLPostBuf.Amount := -DisposalAmount;
          FAGLPostBuf.Correction := not FAGLPostBuf.Correction;
          InsertBufferEntry;
        end;
    end;

    local procedure CorrectBookValueEntry()
    var
        FALedgEntry: Record "FA Ledger Entry";
        FAGLPostBuf: Record "FA G/L Posting Buffer";
        DepreciationCalc: Codeunit "Depreciation Calculation";
        BookValueAmount: Decimal;
    begin
        DepreciationCalc.SetFAFilter(
          FALedgEntry,FADeprBook."FA No.",FADeprBook."Depreciation Book Code",true);
        FALedgEntry.SetRange("FA Posting Category",FALedgEntry."fa posting category"::Disposal);
        FALedgEntry.SetRange("FA Posting Type",FALedgEntry."fa posting type"::"Book Value on Disposal");
        FALedgEntry.CalcSums(Amount);
        BookValueAmount := FALedgEntry.Amount;
        TempFAGLPostBuf.Get(DisposalEntryNo);
        FAGLPostBuf := TempFAGLPostBuf;
        if IdenticalSign(FADeprBook."Gain/Loss",GainLossAmount,BookValueAmount) then
          exit;
        FAPostingGr2.TestField("Book Val. Acc. on Disp. (Gain)");
        FAPostingGr2.TestField("Book Val. Acc. on Disp. (Loss)");
        if FAPostingGr2."Book Val. Acc. on Disp. (Gain)" =
           FAPostingGr2."Book Val. Acc. on Disp. (Loss)"
        then
          exit;
        OrgGenJnlLine := false;
        if FADeprBook."Gain/Loss" <= 0 then begin
          InsertBufferBalAcc(
            10,
            BookValueAmount,
            FADeprBook."Depreciation Book Code",
            FAPostingGr2.Code,
            FAGLPostBuf."Global Dimension 1 Code",
            FAGLPostBuf."Global Dimension 2 Code",
            FAGLPostBuf."Dimension Set ID",
            true,FAGLPostBuf.Correction);

          InsertBufferBalAcc(
            11,
            -BookValueAmount,
            FADeprBook."Depreciation Book Code",
            FAPostingGr2.Code,
            FAGLPostBuf."Global Dimension 1 Code",
            FAGLPostBuf."Global Dimension 2 Code",
            FAGLPostBuf."Dimension Set ID",
            true,not FAGLPostBuf.Correction);
        end else begin
          InsertBufferBalAcc(
            11,
            BookValueAmount,
            FADeprBook."Depreciation Book Code",
            FAPostingGr2.Code,
            FAGLPostBuf."Global Dimension 1 Code",
            FAGLPostBuf."Global Dimension 2 Code",
            FAGLPostBuf."Dimension Set ID",
            true,FAGLPostBuf.Correction);

          InsertBufferBalAcc(
            10,
            -BookValueAmount,
            FADeprBook."Depreciation Book Code",
            FAPostingGr2.Code,
            FAGLPostBuf."Global Dimension 1 Code",
            FAGLPostBuf."Global Dimension 2 Code",
            FAGLPostBuf."Dimension Set ID",
            true,not FAGLPostBuf.Correction);
        end;
    end;

    local procedure IdenticalSign(A: Decimal;B: Decimal;C: Decimal): Boolean
    begin
        exit(((A <= 0) = (B <= 0)) or (C = 0));
    end;


    procedure SetNetDisposal(NetDisp2: Boolean)
    begin
        NetDisp := NetDisp2;
    end;

    local procedure CalcLastDisposal(FADeprBook: Record "FA Depreciation Book"): Boolean
    var
        FALedgEntry: Record "FA Ledger Entry";
        DepreciationCalc: Codeunit "Depreciation Calculation";
    begin
        DepreciationCalc.SetFAFilter(
          FALedgEntry,FADeprBook."FA No.",FADeprBook."Depreciation Book Code",true);
        FALedgEntry.SetRange("FA Posting Type",FALedgEntry."fa posting type"::"Proceeds on Disposal");
        exit(not FALedgEntry.FindFirst);
    end;
}

