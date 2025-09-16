#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 8 AccSchedManagement
{
    TableNo = "Acc. Schedule Line";

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'DEFAULT';
        Text001: label 'Default Schedule';
        Text002: label 'Default Columns';
        Text012: label 'You have entered an illegal value or a nonexistent row number.';
        Text013: label 'You have entered an illegal value or a nonexistent column number.';
        Text016: label '%1\\ %2 %3 %4', Comment='{Locked} ';
        Text017: label 'The error occurred when the program tried to calculate:\';
        Text018: label 'Acc. Sched. Line: Row No. = %1, Line No. = %2, Totaling = %3\', Comment='%1 = Row No., %2= Line No., %3 = Totaling';
        Text019: label 'Acc. Sched. Column: Column No. = %1, Line No. = %2, Formula  = %3', Comment='%1 = Column No., %2= Line No., %3 = Formula';
        Text020: label 'Because of circular references, the program cannot calculate a formula.';
        AccSchedName: Record "Acc. Schedule Name";
        AccountScheduleLine: Record "Acc. Schedule Line";
        ColumnLayoutName: Record "Column Layout Name";
        AccSchedCellValue: Record "Acc. Sched. Cell Value" temporary;
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        AddRepCurrency: Record Currency;
        AnalysisView: Record "Analysis View";
        MatrixMgt: Codeunit "Matrix Management";
        AnalysisViewRead: Boolean;
        StartDate: Date;
        EndDate: Date;
        FiscalStartDate: Date;
        DivisionError: Boolean;
        PeriodError: Boolean;
        CallLevel: Integer;
        CallingAccSchedLineID: Integer;
        CallingColumnLayoutID: Integer;
        OldAccSchedLineFilters: Text;
        OldColumnLayoutFilters: Text;
        OldAccSchedLineName: Code[10];
        OldColumnLayoutName: Code[10];
        OldCalcAddCurr: Boolean;
        GLSetupRead: Boolean;
        Text021: label 'Conversion of dimension totaling filter %1 results in a filter that becomes too long.';
        BasePercentLine: array [50] of Integer;
        Text022: label 'You cannot have more than %1 lines with %2 of %3.';
        Text023: label 'Formulas ending with a percent sign require %2 %1 on a line before it.';
        Text024: label 'The %1 %3 on the %2 must equal the %4 %6 on the %5 when any Dimension Totaling is used in any Column.';
        NegativeAmounts: Option "Minus Sign",Parentheses,"Square Brackets","Angle Brackets",Braces,"None";
        NegativePercents: Option "Minus Sign",Parentheses,"Square Brackets","Angle Brackets",Braces,"None";
        USText005: label 'For the Period from %3 %4, %1 to %7 %8, %5';
        MonthText01: label 'January';
        MonthText02: label 'February';
        MonthText03: label 'March';
        MonthText04: label 'April';
        MonthText05: label 'May';
        MonthText06: label 'June';
        MonthText07: label 'July';
        MonthText08: label 'August';
        MonthText09: label 'September';
        MonthText10: label 'October';
        MonthText11: label 'November';
        MonthText12: label 'December';
        ColumnFormulaMsg: label 'Column formula: %1.';
        RowFormulaMsg: label 'Row formula: %1.';
        ColumnFormulaErrorMsg: label 'Column formula: %1. \Error: %2.';
        Recalculate: Boolean;
        SystemGeneratedAccSchedMsg: label 'Warning: This account schedule may be automatically updated by the system, so any changes you make may be lost.';


    procedure SetParameters(NewNegativeAmounts: Integer;NewNegativePercents: Integer)
    begin
        NegativeAmounts := NewNegativeAmounts;
        NegativePercents := NewNegativePercents;
    end;


    procedure OpenSchedule(var CurrentSchedName: Code[10];var AccSchedLine: Record "Acc. Schedule Line")
    begin
        CheckTemplateAndSetFilter(CurrentSchedName,AccSchedLine);
    end;


    procedure OpenAndCheckSchedule(var CurrentSchedName: Code[10];var AccSchedLine: Record "Acc. Schedule Line")
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        CheckTemplateAndSetFilter(CurrentSchedName,AccSchedLine);
        if AccSchedLine.IsEmpty then
          exit;
        GeneralLedgerSetup.Get;
        if CurrentSchedName in
           [GeneralLedgerSetup."Acc. Sched. for Balance Sheet",GeneralLedgerSetup."Acc. Sched. for Cash Flow Stmt",
            GeneralLedgerSetup."Acc. Sched. for Income Stmt.",GeneralLedgerSetup."Acc. Sched. for Retained Earn."]
        then
          Message(SystemGeneratedAccSchedMsg);
    end;

    local procedure CheckTemplateAndSetFilter(var CurrentSchedName: Code[10];var AccSchedLine: Record "Acc. Schedule Line")
    begin
        CheckTemplateName(CurrentSchedName);
        AccSchedLine.FilterGroup(2);
        AccSchedLine.SetRange("Schedule Name",CurrentSchedName);
        AccSchedLine.FilterGroup(0);
    end;

    local procedure CheckTemplateName(var CurrentSchedName: Code[10])
    var
        AccSchedName: Record "Acc. Schedule Name";
    begin
        if not AccSchedName.Get(CurrentSchedName) then begin
          if not AccSchedName.FindFirst then begin
            AccSchedName.Init;
            AccSchedName.Name := Text000;
            AccSchedName.Description := Text001;
            AccSchedName.Insert;
            Commit;
          end;
          CurrentSchedName := AccSchedName.Name;
        end;
    end;


    procedure CheckName(CurrentSchedName: Code[10])
    var
        AccSchedName: Record "Acc. Schedule Name";
    begin
        AccSchedName.Get(CurrentSchedName);
    end;


    procedure SetName(CurrentSchedName: Code[10];var AccSchedLine: Record "Acc. Schedule Line")
    begin
        AccSchedLine.FilterGroup(2);
        AccSchedLine.SetRange("Schedule Name",CurrentSchedName);
        AccSchedLine.FilterGroup(0);
        if AccSchedLine.Find('-') then;
    end;


    procedure LookupName(CurrentSchedName: Code[10];var EntrdSchedName: Text[10]): Boolean
    var
        AccSchedName: Record "Acc. Schedule Name";
    begin
        AccSchedName.Name := CurrentSchedName;
        if Page.RunModal(0,AccSchedName) <> Action::LookupOK then
          exit(false);

        EntrdSchedName := AccSchedName.Name;
        exit(true);
    end;


    procedure OpenColumns(var CurrentColumnName: Code[10];var ColumnLayout: Record "Column Layout")
    begin
        CheckColumnTemplateName(CurrentColumnName);
        ColumnLayout.FilterGroup(2);
        ColumnLayout.SetRange("Column Layout Name",CurrentColumnName);
        ColumnLayout.FilterGroup(0);
    end;

    local procedure CheckColumnTemplateName(var CurrentColumnName: Code[10])
    var
        ColumnLayoutName: Record "Column Layout Name";
    begin
        if not ColumnLayoutName.Get(CurrentColumnName) then begin
          if not ColumnLayoutName.FindFirst then begin
            ColumnLayoutName.Init;
            ColumnLayoutName.Name := Text000;
            ColumnLayoutName.Description := Text002;
            ColumnLayoutName.Insert;
            Commit;
          end;
          CurrentColumnName := ColumnLayoutName.Name;
        end;
    end;


    procedure CheckColumnName(CurrentColumnName: Code[10])
    var
        ColumnLayoutName: Record "Column Layout Name";
    begin
        ColumnLayoutName.Get(CurrentColumnName);
    end;


    procedure SetColumnName(CurrentColumnName: Code[10];var ColumnLayout: Record "Column Layout")
    begin
        ColumnLayout.Reset;
        ColumnLayout.FilterGroup(2);
        ColumnLayout.SetRange("Column Layout Name",CurrentColumnName);
        ColumnLayout.FilterGroup(0);
    end;


    procedure CopyColumnsToTemp(NewColumnName: Code[10];var TempColumnLayout: Record "Column Layout")
    var
        ColumnLayout: Record "Column Layout";
    begin
        TempColumnLayout.DeleteAll;
        ColumnLayout.SetRange("Column Layout Name",NewColumnName);
        if ColumnLayout.Find('-') then
          repeat
            TempColumnLayout := ColumnLayout;
            TempColumnLayout.Insert;
          until ColumnLayout.Next = 0;
        if TempColumnLayout.Find('-') then;
    end;


    procedure LookupColumnName(CurrentColumnName: Code[10];var EntrdColumnName: Text[10]): Boolean
    var
        ColumnLayoutName: Record "Column Layout Name";
    begin
        ColumnLayoutName.Name := CurrentColumnName;
        if Page.RunModal(0,ColumnLayoutName) <> Action::LookupOK then
          exit(false);

        EntrdColumnName := ColumnLayoutName.Name;
        exit(true);
    end;


    procedure CheckAnalysisView(CurrentSchedName: Code[10];CurrentColumnName: Code[10];TestColumnName: Boolean)
    var
        ColumnLayout2: Record "Column Layout";
        AnyColumnDimensions: Boolean;
    begin
        if not AnalysisViewRead then begin
          AnalysisViewRead := true;
          if CurrentSchedName <> AccSchedName.Name then begin
            CheckTemplateName(CurrentSchedName);
            AccSchedName.Get(CurrentSchedName);
          end;
          if TestColumnName then
            if CurrentColumnName <> ColumnLayoutName.Name then begin
              CheckColumnTemplateName(CurrentColumnName);
              ColumnLayoutName.Get(CurrentColumnName);
            end;
          if AccSchedName."Analysis View Name" = '' then begin
            if not GLSetupRead then
              GLSetup.Get;
            GLSetupRead := true;
            AnalysisView.Init;
            AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
            AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
          end else
            AnalysisView.Get(AccSchedName."Analysis View Name");
          if AccSchedName."Analysis View Name" <> ColumnLayoutName."Analysis View Name" then begin
            AnyColumnDimensions := false;
            ColumnLayout2.SetRange("Column Layout Name",ColumnLayoutName.Name);
            if ColumnLayout2.Find('-') then
              repeat
                AnyColumnDimensions :=
                  (ColumnLayout2."Dimension 1 Totaling" <> '') or
                  (ColumnLayout2."Dimension 2 Totaling" <> '') or
                  (ColumnLayout2."Dimension 3 Totaling" <> '') or
                  (ColumnLayout2."Dimension 4 Totaling" <> '');
              until AnyColumnDimensions or (ColumnLayout2.Next = 0);
            if AnyColumnDimensions then
              Error(
                Text024,
                AccSchedName.FieldCaption("Analysis View Name"),
                AccSchedName.TableCaption,
                AccSchedName."Analysis View Name",
                ColumnLayoutName.FieldCaption("Analysis View Name"),
                ColumnLayoutName.TableCaption,
                ColumnLayoutName."Analysis View Name");
          end;
        end;
    end;


    procedure FindFiscalYear(BalanceDate: Date): Date
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.SetRange("New Fiscal Year",true);
        AccountingPeriod.SetRange("Starting Date",0D,BalanceDate);
        if AccountingPeriod.FindLast then
          exit(AccountingPeriod."Starting Date");
        AccountingPeriod.Reset;
        AccountingPeriod.FindFirst;
        exit(AccountingPeriod."Starting Date");
    end;

    local procedure FindEndOfFiscalYear(BalanceDate: Date): Date
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.SetRange("New Fiscal Year",true);
        AccountingPeriod.SetFilter("Starting Date",'>%1',FindFiscalYear(BalanceDate));
        if AccountingPeriod.FindFirst then
          exit(CalcDate('<-1D>',AccountingPeriod."Starting Date"));
        exit(Dmy2date(31,12,9999));
    end;

    local procedure AccPeriodStartEnd(Formula: Code[20];Date: Date;var StartDate: Date;var EndDate: Date)
    var
        ColumnLayout: Record "Column Layout";
        AccountingPeriod: Record "Accounting Period";
        AccountingPeriodFY: Record "Accounting Period";
        Steps: Integer;
        Type: Option " ",Period,"Fiscal year","Fiscal Halfyear","Fiscal Quarter";
        CurrentPeriodNo: Integer;
        RangeFromType: Option Int,CP,LP;
        RangeToType: Option Int,CP,LP;
        RangeFromInt: Integer;
        RangeToInt: Integer;
    begin
        if Formula = '' then
          exit;

        ColumnLayout.ParsePeriodFormula(
          Formula,Steps,Type,RangeFromType,RangeToType,RangeFromInt,RangeToInt);

        // Find current period
        AccountingPeriod.SetFilter("Starting Date",'<=%1',Date);
        if not AccountingPeriod.Find('+') then begin
          AccountingPeriod.Reset;
          if Steps < 0 then
            AccountingPeriod.Find('-')
          else
            AccountingPeriod.Find('+')
        end;
        AccountingPeriod.Reset;

        case Type of
          Type::Period:
            begin
              if AccountingPeriod.Next(Steps) <> Steps then
                PeriodError := true;
              StartDate := AccountingPeriod."Starting Date";
              EndDate := AccPeriodEndDate(StartDate);
            end;
          Type::"Fiscal year":
            begin
              AccountingPeriodFY := AccountingPeriod;
              while not AccountingPeriodFY."New Fiscal Year" do
                if AccountingPeriodFY.Find('<') then
                  CurrentPeriodNo += 1
                else
                  AccountingPeriodFY."New Fiscal Year" := true;
              AccountingPeriodFY.SetRange("New Fiscal Year",true);
              AccountingPeriodFY.Next(Steps);

              AccPeriodStartOrEnd(AccountingPeriodFY,CurrentPeriodNo,RangeFromType,RangeFromInt,false,StartDate);
              AccPeriodStartOrEnd(AccountingPeriodFY,CurrentPeriodNo,RangeToType,RangeToInt,true,EndDate);
            end;
        end;
    end;

    local procedure AccPeriodEndDate(StartDate: Date): Date
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod."Starting Date" := StartDate;
        if AccountingPeriod.Find('>') then
          exit(AccountingPeriod."Starting Date" - 1);
        exit(Dmy2date(31,12,9999));
    end;

    local procedure AccPeriodGetPeriod(var AccountingPeriod: Record "Accounting Period";AccPeriodNo: Integer)
    begin
        case true of
          AccPeriodNo > 0:
            begin
              AccountingPeriod.Next(AccPeriodNo);
              exit;
            end;
          AccPeriodNo = 0:
            exit;
          AccPeriodNo < 0:
            begin
              AccountingPeriod.SetRange("New Fiscal Year",true);
              if not AccountingPeriod.Find('>') then begin
                AccountingPeriod.Reset;
                AccountingPeriod.Find('+');
                exit;
              end;
              AccountingPeriod.Reset;
              AccountingPeriod.Find('<');
              exit;
            end;
        end;
    end;

    local procedure AccPeriodStartOrEnd(AccountingPeriod: Record "Accounting Period";CurrentPeriodNo: Integer;RangeType: Option Int,CP,LP;RangeInt: Integer;EndDate: Boolean;var Date: Date)
    begin
        case RangeType of
          Rangetype::CP:
            AccPeriodGetPeriod(AccountingPeriod,CurrentPeriodNo);
          Rangetype::LP:
            AccPeriodGetPeriod(AccountingPeriod,-1);
          Rangetype::Int:
            AccPeriodGetPeriod(AccountingPeriod,RangeInt - 1);
        end;
        if EndDate then
          Date := AccPeriodEndDate(AccountingPeriod."Starting Date")
        else
          Date := AccountingPeriod."Starting Date";
    end;

    local procedure InitBasePercents(AccSchedLine: Record "Acc. Schedule Line";ColumnLayout: Record "Column Layout")
    var
        BaseIdx: Integer;
    begin
        Clear(BasePercentLine);
        BaseIdx := 0;

        with AccSchedLine do begin
          SetRange("Schedule Name","Schedule Name");
          if Find('-') then
            repeat
              if "Totaling Type" = "totaling type"::"Set Base For Percent" then begin
                BaseIdx := BaseIdx + 1;
                if BaseIdx > ArrayLen(BasePercentLine) then
                  ShowError(
                    StrSubstNo(Text022,ArrayLen(BasePercentLine),FieldCaption("Totaling Type"),"Totaling Type"),
                    AccSchedLine,ColumnLayout);
                BasePercentLine[BaseIdx] := "Line No.";
              end;
            until Next = 0;
        end;

        if BaseIdx = 0 then begin
          AccSchedLine."Totaling Type" := AccSchedLine."totaling type"::"Set Base For Percent";
          ShowError(
            StrSubstNo(Text023,AccSchedLine.FieldCaption("Totaling Type"),AccSchedLine."Totaling Type"),
            AccSchedLine,ColumnLayout);
        end;
    end;

    local procedure GetBasePercentLine(AccSchedLine: Record "Acc. Schedule Line";ColumnLayout: Record "Column Layout"): Integer
    var
        BaseIdx: Integer;
    begin
        if BasePercentLine[1] = 0 then
          InitBasePercents(AccSchedLine,ColumnLayout);

        BaseIdx := ArrayLen(BasePercentLine);
        repeat
          if BasePercentLine[BaseIdx] <> 0 then
            if BasePercentLine[BaseIdx] < AccSchedLine."Line No." then
              exit(BasePercentLine[BaseIdx]);
          BaseIdx := BaseIdx - 1;
        until BaseIdx = 0;

        AccSchedLine."Totaling Type" := AccSchedLine."totaling type"::"Set Base For Percent";
        ShowError(
          StrSubstNo(Text023,AccSchedLine.FieldCaption("Totaling Type"),AccSchedLine."Totaling Type"),
          AccSchedLine,ColumnLayout);
    end;


    procedure CalcCell(var AccSchedLine: Record "Acc. Schedule Line";var ColumnLayout: Record "Column Layout";CalcAddCurr: Boolean): Decimal
    var
        Result: Decimal;
    begin
        AccountScheduleLine.CopyFilters(AccSchedLine);
        StartDate := AccountScheduleLine.GetRangeMin("Date Filter");
        if EndDate <> AccountScheduleLine.GetRangemax("Date Filter") then begin
          EndDate := AccountScheduleLine.GetRangemax("Date Filter");
          FiscalStartDate := FindFiscalYear(EndDate);
        end;
        DivisionError := false;
        PeriodError := false;
        CallLevel := 0;
        CallingAccSchedLineID := AccSchedLine."Line No.";
        CallingColumnLayoutID := ColumnLayout."Line No.";

        if (OldAccSchedLineFilters <> AccSchedLine.GetFilters) or
           (OldColumnLayoutFilters <> ColumnLayout.GetFilters) or
           (OldAccSchedLineName <> AccSchedLine."Schedule Name") or
           (OldColumnLayoutName <> ColumnLayout."Column Layout Name") or
           (OldCalcAddCurr <> CalcAddCurr) or
           Recalculate
        then begin
          AccSchedCellValue.Reset;
          AccSchedCellValue.DeleteAll;
          Clear(BasePercentLine);
          OldAccSchedLineFilters := AccSchedLine.GetFilters;
          OldColumnLayoutFilters := ColumnLayout.GetFilters;
          OldAccSchedLineName := AccSchedLine."Schedule Name";
          OldColumnLayoutName := ColumnLayout."Column Layout Name";
          OldCalcAddCurr := CalcAddCurr;
        end;

        Result := CalcCellValue(AccSchedLine,ColumnLayout,CalcAddCurr);
        with ColumnLayout do begin
          case Show of
            Show::"When Positive":
              if Result < 0 then
                Result := 0;
            Show::"When Negative":
              if Result > 0 then
                Result := 0;
          end;
          if "Show Opposite Sign" then
            Result := -Result;
          case "Show Indented Lines" of
            "show indented lines"::"Indented Only":
              if AccSchedLine.Indentation = 0 then
                Result := 0;
            "show indented lines"::"Non-Indented Only":
              if AccSchedLine.Indentation > 0 then
                Result := 0;
          end;
        end;
        if AccSchedLine."Show Opposite Sign" then
          Result := -Result;
        exit(Result);
    end;

    local procedure CalcCellValue(AccSchedLine: Record "Acc. Schedule Line";ColumnLayout: Record "Column Layout";CalcAddCurr: Boolean): Decimal
    var
        GLAcc: Record "G/L Account";
        CostType: Record "Cost Type";
        CFAccount: Record "Cash Flow Account";
        Result: Decimal;
    begin
        Result := 0;
        if AccSchedLine.Totaling <> '' then
          if AccSchedCellValue.Get(AccSchedLine."Line No.",ColumnLayout."Line No.") then begin
            Result := AccSchedCellValue.Value;
            DivisionError := DivisionError or AccSchedCellValue."Has Error";
            PeriodError := PeriodError or AccSchedCellValue."Period Error";
          end else begin
            if ColumnLayout."Column Type" = ColumnLayout."column type"::Formula then
              Result :=
                EvaluateExpression(
                  false,ColumnLayout.Formula,AccSchedLine,ColumnLayout,CalcAddCurr)
            else
              if AccSchedLine."Totaling Type" in
                 [AccSchedLine."totaling type"::Formula,AccSchedLine."totaling type"::"Set Base For Percent"]
              then
                Result :=
                  EvaluateExpression(
                    true,AccSchedLine.Totaling,AccSchedLine,ColumnLayout,CalcAddCurr)
              else
                if (StartDate = 0D) or (EndDate = 0D) or (EndDate = Dmy2date(31,12,9999)) then begin
                  Result := 0;
                  PeriodError := true;
                end else begin
                  if AccSchedLine."Totaling Type" in
                     [AccSchedLine."totaling type"::"Posting Accounts",AccSchedLine."totaling type"::"Total Accounts"]
                  then begin
                    AccSchedLine.CopyFilters(AccountScheduleLine);
                    SetGLAccRowFilters(GLAcc,AccSchedLine);
                    SetGLAccColumnFilters(GLAcc,AccSchedLine,ColumnLayout);
                    if (AccSchedLine."Totaling Type" = AccSchedLine."totaling type"::"Posting Accounts") and
                       (StrLen(AccSchedLine.Totaling) <= MaxStrLen(GLAcc.Totaling)) and (StrPos(AccSchedLine.Totaling,'*') = 0)
                    then begin
                      GLAcc."Account Type" := GLAcc."account type"::Total;
                      GLAcc.Totaling := AccSchedLine.Totaling;
                      Result := Result + CalcGLAcc(GLAcc,AccSchedLine,ColumnLayout,CalcAddCurr);
                    end else
                      if GLAcc.Find('-') then
                        repeat
                          Result := Result + CalcGLAcc(GLAcc,AccSchedLine,ColumnLayout,CalcAddCurr);
                        until GLAcc.Next = 0;
                  end;

                  if AccSchedLine."Totaling Type" in
                     [AccSchedLine."totaling type"::"Cost Type",AccSchedLine."totaling type"::"Cost Type Total"]
                  then begin
                    AccSchedLine.CopyFilters(AccountScheduleLine);
                    SetCostTypeRowFilters(CostType,AccSchedLine,ColumnLayout);
                    SetCostTypeColumnFilters(CostType,AccSchedLine,ColumnLayout);

                    if (AccSchedLine."Totaling Type" = AccSchedLine."totaling type"::"Cost Type") and
                       (StrLen(AccSchedLine.Totaling) <= MaxStrLen(GLAcc.Totaling)) and (StrPos(AccSchedLine.Totaling,'*') = 0)
                    then begin
                      CostType.Type := CostType.Type::Total;
                      CostType.Totaling := AccSchedLine.Totaling;
                      Result := Result + CalcCostType(CostType,AccSchedLine,ColumnLayout,CalcAddCurr);
                    end else begin
                      if CostType.Find('-') then
                        repeat
                          Result := Result + CalcCostType(CostType,AccSchedLine,ColumnLayout,CalcAddCurr);
                        until CostType.Next = 0;
                    end;
                  end;

                  if AccSchedLine."Totaling Type" in
                     [AccSchedLine."totaling type"::"Cash Flow Entry Accounts",AccSchedLine."totaling type"::"Cash Flow Total Accounts"]
                  then begin
                    AccSchedLine.CopyFilters(AccountScheduleLine);
                    SetCFAccRowFilter(CFAccount,AccSchedLine);
                    SetCFAccColumnFilter(CFAccount,AccSchedLine,ColumnLayout);
                    if (AccSchedLine."Totaling Type" = AccSchedLine."totaling type"::"Cash Flow Entry Accounts") and
                       (StrLen(AccSchedLine.Totaling) <= 30)
                    then begin
                      CFAccount."Account Type" := CFAccount."account type"::Total;
                      CFAccount.Totaling := AccSchedLine.Totaling;
                      Result := Result + CalcCFAccount(CFAccount,AccSchedLine,ColumnLayout);
                    end else
                      if CFAccount.Find('-') then
                        repeat
                          Result := Result + CalcCFAccount(CFAccount,AccSchedLine,ColumnLayout);
                        until CFAccount.Next = 0;
                  end;
                end;

            AccSchedCellValue."Row No." := AccSchedLine."Line No.";
            AccSchedCellValue."Column No." := ColumnLayout."Line No.";
            AccSchedCellValue.Value := Result;
            AccSchedCellValue."Has Error" := DivisionError;
            AccSchedCellValue."Period Error" := PeriodError;
            AccSchedCellValue.Insert;
          end;
        exit(Result);
    end;

    local procedure CalcGLAcc(var GLAcc: Record "G/L Account";var AccSchedLine: Record "Acc. Schedule Line";var ColumnLayout: Record "Column Layout";CalcAddCurr: Boolean) ColValue: Decimal
    var
        GLEntry: Record "G/L Entry";
        GLBudgEntry: Record "G/L Budget Entry";
        AnalysisViewEntry: Record "Analysis View Entry";
        AnalysisViewBudgetEntry: Record "Analysis View Budget Entry";
        AmountType: Option "Net Amount","Debit Amount","Credit Amount";
        TestBalance: Boolean;
        Balance: Decimal;
        UseBusUnitFilter: Boolean;
        UseDimFilter: Boolean;
    begin
        ColValue := 0;
        UseDimFilter := false;
        if AccSchedName.Name <> AccSchedLine."Schedule Name" then
          AccSchedName.Get(AccSchedLine."Schedule Name");

        if ConflictAmountType(AccSchedLine,ColumnLayout."Amount Type",AmountType) then
          exit(0);
        TestBalance :=
          AccSchedLine.Show in [AccSchedLine.Show::"When Positive Balance",AccSchedLine.Show::"When Negative Balance"];
        if ColumnLayout."Column Type" <> ColumnLayout."column type"::Formula then begin
          UseBusUnitFilter := (AccSchedLine.GetFilter("Business Unit Filter") <> '') or (ColumnLayout."Business Unit Totaling" <> '');
          UseDimFilter := HasDimFilter(AccSchedLine,ColumnLayout);
          case ColumnLayout."Ledger Entry Type" of
            ColumnLayout."ledger entry type"::Entries:
              begin
                if AccSchedName."Analysis View Name" = '' then
                  with GLEntry do begin
                    if UseBusUnitFilter then
                      if UseDimFilter then
                        SetCurrentkey(
                          "G/L Account No.","Business Unit Code","Global Dimension 1 Code","Global Dimension 2 Code")
                      else
                        SetCurrentkey(
                          "G/L Account No.","Business Unit Code","Posting Date")
                    else
                      if UseDimFilter then
                        SetCurrentkey("G/L Account No.","Global Dimension 1 Code","Global Dimension 2 Code")
                      else
                        SetCurrentkey("G/L Account No.","Posting Date");
                    if GLAcc.Totaling = '' then
                      SetRange("G/L Account No.",GLAcc."No.")
                    else
                      SetFilter("G/L Account No.",GLAcc.Totaling);
                    GLAcc.Copyfilter("Date Filter","Posting Date");
                    AccSchedLine.Copyfilter("Business Unit Filter","Business Unit Code");
                    AccSchedLine.Copyfilter("Dimension 1 Filter","Global Dimension 1 Code");
                    AccSchedLine.Copyfilter("Dimension 2 Filter","Global Dimension 2 Code");
                    FilterGroup(2);
                    SetFilter("Global Dimension 1 Code",GetDimTotalingFilter(1,AccSchedLine."Dimension 1 Totaling"));
                    SetFilter("Global Dimension 2 Code",GetDimTotalingFilter(2,AccSchedLine."Dimension 2 Totaling"));
                    FilterGroup(8);
                    SetFilter("Global Dimension 1 Code",GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"));
                    SetFilter("Global Dimension 2 Code",GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"));
                    SetFilter("Business Unit Code",ColumnLayout."Business Unit Totaling");
                    FilterGroup(0);
                    case AmountType of
                      Amounttype::"Net Amount":
                        begin
                          if CalcAddCurr then begin
                            CalcSums("Additional-Currency Amount");
                            ColValue := "Additional-Currency Amount";
                          end else begin
                            CalcSums(Amount);
                            ColValue := Amount;
                          end;
                          Balance := ColValue;
                        end;
                      Amounttype::"Debit Amount":
                        begin
                          if CalcAddCurr then begin
                            if TestBalance then begin
                              CalcSums("Add.-Currency Debit Amount","Additional-Currency Amount");
                              Balance := "Additional-Currency Amount";
                            end else
                              CalcSums("Add.-Currency Debit Amount");
                            ColValue := "Add.-Currency Debit Amount";
                          end else begin
                            if TestBalance then begin
                              CalcSums("Debit Amount",Amount);
                              Balance := Amount;
                            end else
                              CalcSums("Debit Amount");
                            ColValue := "Debit Amount";
                          end;
                        end;
                      Amounttype::"Credit Amount":
                        begin
                          if CalcAddCurr then begin
                            if TestBalance then begin
                              CalcSums("Add.-Currency Credit Amount","Additional-Currency Amount");
                              Balance := "Additional-Currency Amount";
                            end else
                              CalcSums("Add.-Currency Credit Amount");
                            ColValue := "Add.-Currency Credit Amount";
                          end else begin
                            if TestBalance then begin
                              CalcSums("Credit Amount",Amount);
                              Balance := Amount;
                            end else
                              CalcSums("Credit Amount");
                            ColValue := "Credit Amount";
                          end;
                        end;
                    end;
                  end
                else
                  with AnalysisViewEntry do begin
                    SetRange("Analysis View Code",AccSchedName."Analysis View Name");
                    SetRange("Account Source","account source"::"G/L Account");
                    if GLAcc.Totaling = '' then
                      SetRange("Account No.",GLAcc."No.")
                    else
                      SetFilter("Account No.",GLAcc.Totaling);
                    GLAcc.Copyfilter("Date Filter","Posting Date");
                    AccSchedLine.Copyfilter("Business Unit Filter","Business Unit Code");
                    CopyDimFilters(AccSchedLine);
                    FilterGroup(2);
                    SetDimFilters(
                      GetDimTotalingFilter(1,AccSchedLine."Dimension 1 Totaling"),
                      GetDimTotalingFilter(2,AccSchedLine."Dimension 2 Totaling"),
                      GetDimTotalingFilter(3,AccSchedLine."Dimension 3 Totaling"),
                      GetDimTotalingFilter(4,AccSchedLine."Dimension 4 Totaling"));
                    FilterGroup(8);
                    SetDimFilters(
                      GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"),
                      GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"),
                      GetDimTotalingFilter(3,ColumnLayout."Dimension 3 Totaling"),
                      GetDimTotalingFilter(4,ColumnLayout."Dimension 4 Totaling"));
                    SetFilter("Business Unit Code",ColumnLayout."Business Unit Totaling");
                    FilterGroup(0);

                    case AmountType of
                      Amounttype::"Net Amount":
                        begin
                          if CalcAddCurr then begin
                            CalcSums("Add.-Curr. Amount");
                            ColValue := "Add.-Curr. Amount";
                          end else begin
                            CalcSums(Amount);
                            ColValue := Amount;
                          end;
                          Balance := ColValue;
                        end;
                      Amounttype::"Debit Amount":
                        begin
                          if CalcAddCurr then begin
                            if TestBalance then begin
                              CalcSums("Add.-Curr. Debit Amount","Add.-Curr. Amount");
                              Balance := "Add.-Curr. Amount";
                            end else
                              CalcSums("Add.-Curr. Debit Amount");
                            ColValue := "Add.-Curr. Debit Amount";
                          end else begin
                            if TestBalance then begin
                              CalcSums("Debit Amount",Amount);
                              Balance := Amount;
                            end else
                              CalcSums("Debit Amount");
                            ColValue := "Debit Amount";
                          end;
                        end;
                      Amounttype::"Credit Amount":
                        begin
                          if CalcAddCurr then begin
                            if TestBalance then begin
                              CalcSums("Add.-Curr. Credit Amount","Add.-Curr. Amount");
                              Balance := "Add.-Curr. Amount";
                            end else
                              CalcSums("Add.-Curr. Credit Amount");
                            ColValue := "Add.-Curr. Credit Amount";
                          end else begin
                            if TestBalance then begin
                              CalcSums("Credit Amount",Amount);
                              Balance := Amount;
                            end else
                              CalcSums("Credit Amount");
                            ColValue := "Credit Amount";
                          end;
                        end;
                    end;
                  end;
              end;
            ColumnLayout."ledger entry type"::"Budget Entries":
              begin
                if AccSchedName."Analysis View Name" = '' then
                  with GLBudgEntry do begin
                    if UseBusUnitFilter or UseDimFilter then
                      SetCurrentkey(
                        "Budget Name","G/L Account No.","Business Unit Code",
                        "Global Dimension 1 Code","Global Dimension 2 Code",
                        "Budget Dimension 1 Code","Budget Dimension 2 Code",
                        "Budget Dimension 3 Code","Budget Dimension 4 Code",Date)
                    else
                      SetCurrentkey("Budget Name","G/L Account No.",Date);
                    if GLAcc.Totaling = '' then
                      SetRange("G/L Account No.",GLAcc."No.")
                    else
                      SetFilter("G/L Account No.",GLAcc.Totaling);
                    GLAcc.Copyfilter("Date Filter",Date);
                    AccSchedLine.Copyfilter("G/L Budget Filter","Budget Name");
                    AccSchedLine.Copyfilter("Business Unit Filter","Business Unit Code");
                    AccSchedLine.Copyfilter("Dimension 1 Filter","Global Dimension 1 Code");
                    AccSchedLine.Copyfilter("Dimension 2 Filter","Global Dimension 2 Code");
                    FilterGroup(2);
                    SetFilter("Global Dimension 1 Code",GetDimTotalingFilter(1,AccSchedLine."Dimension 1 Totaling"));
                    SetFilter("Global Dimension 2 Code",GetDimTotalingFilter(2,AccSchedLine."Dimension 2 Totaling"));
                    FilterGroup(8);
                    SetFilter("Global Dimension 1 Code",GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"));
                    SetFilter("Global Dimension 2 Code",GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"));
                    SetFilter("Business Unit Code",ColumnLayout."Business Unit Totaling");
                    FilterGroup(0);

                    case AmountType of
                      Amounttype::"Net Amount":
                        begin
                          CalcSums(Amount);
                          ColValue := Amount;
                        end;
                      Amounttype::"Debit Amount":
                        begin
                          CalcSums(Amount);
                          ColValue := Amount;
                          if ColValue < 0 then
                            ColValue := 0;
                        end;
                      Amounttype::"Credit Amount":
                        begin
                          CalcSums(Amount);
                          ColValue := -Amount;
                          if ColValue < 0 then
                            ColValue := 0;
                        end;
                    end;
                    Balance := Amount;
                  end
                else
                  with AnalysisViewBudgetEntry do begin
                    if GLAcc.Totaling = '' then
                      SetRange("G/L Account No.",GLAcc."No.")
                    else
                      SetFilter("G/L Account No.",GLAcc.Totaling);
                    SetRange("Analysis View Code",AccSchedName."Analysis View Name");
                    GLAcc.Copyfilter("Date Filter","Posting Date");
                    AccSchedLine.Copyfilter("G/L Budget Filter","Budget Name");
                    AccSchedLine.Copyfilter("Business Unit Filter","Business Unit Code");
                    CopyDimFilters(AccSchedLine);
                    FilterGroup(2);
                    SetDimFilters(
                      GetDimTotalingFilter(1,AccSchedLine."Dimension 1 Totaling"),
                      GetDimTotalingFilter(2,AccSchedLine."Dimension 2 Totaling"),
                      GetDimTotalingFilter(3,AccSchedLine."Dimension 3 Totaling"),
                      GetDimTotalingFilter(4,AccSchedLine."Dimension 4 Totaling"));
                    FilterGroup(8);
                    SetDimFilters(
                      GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"),
                      GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"),
                      GetDimTotalingFilter(3,ColumnLayout."Dimension 3 Totaling"),
                      GetDimTotalingFilter(4,ColumnLayout."Dimension 4 Totaling"));
                    SetFilter("Business Unit Code",ColumnLayout."Business Unit Totaling");
                    FilterGroup(0);

                    case AmountType of
                      Amounttype::"Net Amount":
                        begin
                          CalcSums(Amount);
                          ColValue := Amount;
                        end;
                      Amounttype::"Debit Amount":
                        begin
                          CalcSums(Amount);
                          ColValue := Amount;
                          if ColValue < 0 then
                            ColValue := 0;
                        end;
                      Amounttype::"Credit Amount":
                        begin
                          CalcSums(Amount);
                          ColValue := -Amount;
                          if ColValue < 0 then
                            ColValue := 0;
                        end;
                    end;
                    Balance := Amount;
                  end;
                if CalcAddCurr then
                  ColValue := CalcLCYToACY(ColValue);
              end;
          end;
          if TestBalance then begin
            if AccSchedLine.Show = AccSchedLine.Show::"When Positive Balance" then
              if Balance < 0 then
                exit(0);
            if AccSchedLine.Show = AccSchedLine.Show::"When Negative Balance" then
              if Balance > 0 then
                exit(0);
          end;
        end;
        exit(ColValue);
    end;

    local procedure CalcCFAccount(var CFAccount: Record "Cash Flow Account";var AccSchedLine: Record "Acc. Schedule Line";var ColumnLayout: Record "Column Layout") ColValue: Decimal
    var
        CFForecastEntry: Record "Cash Flow Forecast Entry";
        AnalysisViewEntry: Record "Analysis View Entry";
        AmountType: Option "Net Amount","Debit Amount","Credit Amount";
    begin
        ColValue := 0;
        if AccSchedName.Name <> AccSchedLine."Schedule Name" then
          AccSchedName.Get(AccSchedLine."Schedule Name");

        if ConflictAmountType(AccSchedLine,ColumnLayout."Amount Type",AmountType) then
          exit(0);

        if ColumnLayout."Column Type" <> ColumnLayout."column type"::Formula then
          case ColumnLayout."Ledger Entry Type" of
            ColumnLayout."ledger entry type"::Entries:
              begin
                if AccSchedName."Analysis View Name" = '' then
                  with CFForecastEntry do begin
                    SetCurrentkey(
                      "Cash Flow Account No.","Cash Flow Forecast No.","Global Dimension 1 Code",
                      "Global Dimension 2 Code","Cash Flow Date");
                    if CFAccount.Totaling = '' then
                      SetRange("Cash Flow Account No.",CFAccount."No.")
                    else
                      SetFilter("Cash Flow Account No.",CFAccount.Totaling);
                    CFAccount.Copyfilter("Date Filter","Cash Flow Date");
                    AccSchedLine.Copyfilter("Cash Flow Forecast Filter","Cash Flow Forecast No.");
                    AccSchedLine.Copyfilter("Dimension 1 Filter","Global Dimension 1 Code");
                    AccSchedLine.Copyfilter("Dimension 2 Filter","Global Dimension 2 Code");
                    FilterGroup(2);
                    SetFilter("Global Dimension 1 Code",AccSchedLine."Dimension 1 Totaling");
                    SetFilter("Global Dimension 2 Code",AccSchedLine."Dimension 2 Totaling");
                    FilterGroup(8);
                    SetFilter("Global Dimension 1 Code",GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"));
                    SetFilter("Global Dimension 2 Code",GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"));
                    FilterGroup(0);
                    case ColumnLayout."Amount Type" of
                      ColumnLayout."amount type"::"Net Amount":
                        begin
                          CalcSums("Amount (LCY)");
                          ColValue := "Amount (LCY)";
                        end;
                    end;
                  end
                else
                  with AnalysisViewEntry do begin
                    SetRange("Analysis View Code",AccSchedName."Analysis View Name");

                    SetRange("Account Source","account source"::"Cash Flow Account");
                    if CFAccount.Totaling = '' then
                      SetRange("Account No.",CFAccount."No.")
                    else
                      SetFilter("Account No.",CFAccount.Totaling);
                    CFAccount.Copyfilter("Date Filter","Posting Date");
                    AccSchedLine.Copyfilter("Cash Flow Forecast Filter","Cash Flow Forecast No.");
                    CopyDimFilters(AccSchedLine);
                    FilterGroup(2);
                    SetDimFilters(
                      GetDimTotalingFilter(1,AccSchedLine."Dimension 1 Totaling"),
                      GetDimTotalingFilter(2,AccSchedLine."Dimension 2 Totaling"),
                      GetDimTotalingFilter(3,AccSchedLine."Dimension 3 Totaling"),
                      GetDimTotalingFilter(4,AccSchedLine."Dimension 4 Totaling"));
                    FilterGroup(8);
                    SetDimFilters(
                      GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"),
                      GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"),
                      GetDimTotalingFilter(3,ColumnLayout."Dimension 3 Totaling"),
                      GetDimTotalingFilter(4,ColumnLayout."Dimension 4 Totaling"));
                    FilterGroup(0);

                    case ColumnLayout."Amount Type" of
                      ColumnLayout."amount type"::"Net Amount":
                        begin
                          CalcSums(Amount);
                          ColValue := Amount;
                        end;
                    end;
                  end;
              end;
          end;

        exit(ColValue);
    end;


    procedure SetGLAccRowFilters(var GLAcc: Record "G/L Account";var AccSchedLine2: Record "Acc. Schedule Line")
    begin
        with AccSchedLine2 do
          case "Totaling Type" of
            "totaling type"::"Posting Accounts":
              begin
                GLAcc.SetFilter("No.",Totaling);
                GLAcc.SetRange("Account Type",GLAcc."account type"::Posting);
              end;
            "totaling type"::"Total Accounts":
              begin
                GLAcc.SetFilter("No.",Totaling);
                GLAcc.SetFilter("Account Type",'<>%1',GLAcc."account type"::Posting);
              end;
          end;
    end;


    procedure SetCFAccRowFilter(var CFAccount: Record "Cash Flow Account";var AccSchedLine2: Record "Acc. Schedule Line")
    begin
        with AccSchedLine2 do begin
          Copyfilter("Cash Flow Forecast Filter",CFAccount."Cash Flow Forecast Filter");

          case "Totaling Type" of
            "totaling type"::"Cash Flow Entry Accounts":
              begin
                CFAccount.SetFilter("No.",Totaling);
                CFAccount.SetRange("Account Type",CFAccount."account type"::Entry);
              end;
            "totaling type"::"Cash Flow Total Accounts":
              begin
                CFAccount.SetFilter("No.",Totaling);
                CFAccount.SetFilter("Account Type",'<>%1',CFAccount."account type"::Entry);
              end;
          end;
        end;
    end;


    procedure SetGLAccColumnFilters(var GLAcc: Record "G/L Account";AccSchedLine2: Record "Acc. Schedule Line";var ColumnLayout: Record "Column Layout")
    var
        FromDate: Date;
        ToDate: Date;
        FiscalStartDate2: Date;
    begin
        with ColumnLayout do begin
          CalcColumnDates("Comparison Date Formula","Comparison Period Formula",FromDate,ToDate,FiscalStartDate2);
          case "Column Type" of
            "column type"::"Net Change":
              case AccSchedLine2."Row Type" of
                AccSchedLine2."row type"::"Net Change":
                  GLAcc.SetRange("Date Filter",FromDate,ToDate);
                AccSchedLine2."row type"::"Beginning Balance":
                  GLAcc.SetFilter("Date Filter",'..%1',ClosingDate(FromDate - 1)); // always includes closing date
                AccSchedLine2."row type"::"Balance at Date":
                  GLAcc.SetRange("Date Filter",0D,ToDate);
              end;
            "column type"::"Balance at Date":
              if AccSchedLine2."Row Type" = AccSchedLine2."row type"::"Beginning Balance" then
                GLAcc.SetRange("Date Filter",0D) // Force a zero return
              else
                GLAcc.SetRange("Date Filter",0D,ToDate);
            "column type"::"Beginning Balance":
              if AccSchedLine2."Row Type" = AccSchedLine2."row type"::"Balance at Date" then
                GLAcc.SetRange("Date Filter",0D) // Force a zero return
              else
                GLAcc.SetRange(
                  "Date Filter",0D,ClosingDate(FromDate - 1));
            "column type"::"Year to Date":
              case AccSchedLine2."Row Type" of
                AccSchedLine2."row type"::"Net Change":
                  GLAcc.SetRange("Date Filter",FiscalStartDate2,ToDate);
                AccSchedLine2."row type"::"Beginning Balance":
                  GLAcc.SetFilter("Date Filter",'..%1',ClosingDate(FiscalStartDate2 - 1)); // always includes closing date
                AccSchedLine2."row type"::"Balance at Date":
                  GLAcc.SetRange("Date Filter",0D,ToDate);
              end;
            "column type"::"Rest of Fiscal Year":
              case AccSchedLine2."Row Type" of
                AccSchedLine2."row type"::"Net Change":
                  GLAcc.SetRange(
                    "Date Filter",CalcDate('<+1D>',ToDate),FindEndOfFiscalYear(FiscalStartDate2));
                AccSchedLine2."row type"::"Beginning Balance":
                  GLAcc.SetRange("Date Filter",0D,ToDate);
                AccSchedLine2."row type"::"Balance at Date":
                  GLAcc.SetRange("Date Filter",0D,FindEndOfFiscalYear(ToDate));
              end;
            "column type"::"Entire Fiscal Year":
              case AccSchedLine2."Row Type" of
                AccSchedLine2."row type"::"Net Change":
                  GLAcc.SetRange(
                    "Date Filter",
                    FiscalStartDate2,
                    FindEndOfFiscalYear(FiscalStartDate2));
                AccSchedLine2."row type"::"Beginning Balance":
                  GLAcc.SetFilter("Date Filter",'..%1',ClosingDate(FiscalStartDate2 - 1)); // always includes closing date
                AccSchedLine2."row type"::"Balance at Date":
                  GLAcc.SetRange("Date Filter",0D,FindEndOfFiscalYear(ToDate));
              end;
          end;
        end;
    end;


    procedure SetCFAccColumnFilter(var CFAccount: Record "Cash Flow Account";AccSchedLine2: Record "Acc. Schedule Line";var ColumnLayout2: Record "Column Layout")
    var
        FromDate: Date;
        ToDate: Date;
        FiscalStartDate2: Date;
    begin
        with ColumnLayout2 do begin
          CalcColumnDates("Comparison Date Formula","Comparison Period Formula",FromDate,ToDate,FiscalStartDate2);
          case "Column Type" of
            "column type"::"Net Change":
              case AccSchedLine2."Row Type" of
                AccSchedLine2."row type"::"Net Change":
                  CFAccount.SetRange("Date Filter",FromDate,ToDate);
                AccSchedLine2."row type"::"Beginning Balance":
                  CFAccount.SetFilter("Date Filter",'..%1',ClosingDate(FromDate - 1));
                AccSchedLine2."row type"::"Balance at Date":
                  CFAccount.SetRange("Date Filter",0D,ToDate);
              end;
            "column type"::"Balance at Date":
              if AccSchedLine2."Row Type" = AccSchedLine2."row type"::"Beginning Balance" then
                CFAccount.SetRange("Date Filter",0D) // Force a zero return
              else
                CFAccount.SetRange("Date Filter",0D,ToDate);
            "column type"::"Beginning Balance":
              if AccSchedLine2."Row Type" = AccSchedLine2."row type"::"Balance at Date" then
                CFAccount.SetRange("Date Filter",0D) // Force a zero return
              else
                CFAccount.SetRange(
                  "Date Filter",0D,CalcDate('<-1D>',FromDate));
            "column type"::"Year to Date":
              case AccSchedLine2."Row Type" of
                AccSchedLine2."row type"::"Net Change":
                  CFAccount.SetRange("Date Filter",FiscalStartDate2,ToDate);
                AccSchedLine2."row type"::"Beginning Balance":
                  CFAccount.SetFilter("Date Filter",'..%1',FiscalStartDate2 - 1);
                AccSchedLine2."row type"::"Balance at Date":
                  CFAccount.SetRange("Date Filter",0D,ToDate);
              end;
            "column type"::"Rest of Fiscal Year":
              case AccSchedLine2."Row Type" of
                AccSchedLine2."row type"::"Net Change":
                  CFAccount.SetRange(
                    "Date Filter",
                    CalcDate('<+1D>',ToDate),FindEndOfFiscalYear(FiscalStartDate2));
                AccSchedLine2."row type"::"Beginning Balance":
                  CFAccount.SetRange("Date Filter",0D,ToDate);
                AccSchedLine2."row type"::"Balance at Date":
                  CFAccount.SetRange("Date Filter",0D,FindEndOfFiscalYear(ToDate));
              end;
            "column type"::"Entire Fiscal Year":
              case AccSchedLine2."Row Type" of
                AccSchedLine2."row type"::"Net Change":
                  CFAccount.SetRange(
                    "Date Filter",
                    FiscalStartDate2,FindEndOfFiscalYear(FiscalStartDate2));
                AccSchedLine2."row type"::"Beginning Balance":
                  CFAccount.SetFilter("Date Filter",'..%1',ClosingDate(FiscalStartDate2 - 1));
                AccSchedLine2."row type"::"Balance at Date":
                  CFAccount.SetRange("Date Filter",0D,FindEndOfFiscalYear(ToDate));
              end;
          end;
        end;
    end;


    procedure EvaluateExpression(IsAccSchedLineExpression: Boolean;Expression: Text;AccSchedLine: Record "Acc. Schedule Line";ColumnLayout: Record "Column Layout";CalcAddCurr: Boolean): Decimal
    var
        AccSchedLine2: Record "Acc. Schedule Line";
        Result: Decimal;
        Parantheses: Integer;
        Operator: Char;
        LeftOperand: Text;
        RightOperand: Text;
        LeftResult: Decimal;
        RightResult: Decimal;
        i: Integer;
        IsExpression: Boolean;
        IsFilter: Boolean;
        Operators: Text[8];
        OperatorNo: Integer;
        AccSchedLineID: Integer;
    begin
        Result := 0;

        CallLevel := CallLevel + 1;
        if CallLevel > 25 then
          ShowError(Text020,
            AccSchedLine,ColumnLayout);

        Expression := DelChr(Expression,'<>',' ');
        if StrLen(Expression) > 0 then begin
          Parantheses := 0;
          IsExpression := false;
          Operators := '+-*/^%';
          OperatorNo := 1;
          repeat
            i := StrLen(Expression);
            repeat
              if Expression[i] = '(' then
                Parantheses := Parantheses + 1
              else
                if Expression[i] = ')' then
                  Parantheses := Parantheses - 1;
              if (Parantheses = 0) and (Expression[i] = Operators[OperatorNo]) then
                IsExpression := true
              else
                i := i - 1;
            until IsExpression or (i <= 0);
            if not IsExpression then
              OperatorNo := OperatorNo + 1;
          until (OperatorNo > StrLen(Operators)) or IsExpression;
          if IsExpression then begin
            if i > 1 then
              LeftOperand := CopyStr(Expression,1,i - 1)
            else
              LeftOperand := '';
            if i < StrLen(Expression) then
              RightOperand := CopyStr(Expression,i + 1)
            else
              RightOperand := '';
            Operator := Expression[i];
            LeftResult :=
              EvaluateExpression(
                IsAccSchedLineExpression,LeftOperand,AccSchedLine,ColumnLayout,CalcAddCurr);
            if (RightOperand = '') and (Operator = '%') and not IsAccSchedLineExpression and
               (AccSchedLine."Totaling Type" <> AccSchedLine."totaling type"::"Set Base For Percent")
            then begin
              AccSchedLine2.Copy(AccSchedLine);
              AccSchedLine2."Line No." := GetBasePercentLine(AccSchedLine,ColumnLayout);
              AccSchedLine2.Find;
              RightResult :=
                EvaluateExpression(
                  IsAccSchedLineExpression,LeftOperand,AccSchedLine2,ColumnLayout,CalcAddCurr);
            end else
              RightResult :=
                EvaluateExpression(
                  IsAccSchedLineExpression,RightOperand,AccSchedLine,ColumnLayout,CalcAddCurr);
            case Operator of
              '^':
                Result := Power(LeftResult,RightResult);
              '%':
                if RightResult = 0 then begin
                  Result := 0;
                  DivisionError := true;
                end else
                  Result := 100 * LeftResult / RightResult;
              '*':
                Result := LeftResult * RightResult;
              '/':
                if RightResult = 0 then begin
                  Result := 0;
                  DivisionError := true;
                end else
                  Result := LeftResult / RightResult;
              '+':
                Result := LeftResult + RightResult;
              '-':
                Result := LeftResult - RightResult;
            end;
          end else
            if (Expression[1] = '(') and (Expression[StrLen(Expression)] = ')') then
              Result :=
                EvaluateExpression(
                  IsAccSchedLineExpression,CopyStr(Expression,2,StrLen(Expression) - 2),
                  AccSchedLine,ColumnLayout,CalcAddCurr)
            else begin
              IsFilter :=
                (StrPos(Expression,'..') +
                 StrPos(Expression,'|') +
                 StrPos(Expression,'<') +
                 StrPos(Expression,'>') +
                 StrPos(Expression,'&') +
                 StrPos(Expression,'=') > 0);
              if (StrLen(Expression) > 10) and (not IsFilter) then
                Evaluate(Result,Expression)
              else
                if IsAccSchedLineExpression then begin
                  AccSchedLine.SetRange("Schedule Name",AccSchedLine."Schedule Name");
                  AccSchedLine.SetFilter("Row No.",Expression);
                  AccSchedLineID := AccSchedLine."Line No.";
                  if AccSchedLine.Find('-') then
                    repeat
                      if AccSchedLine."Line No." <> AccSchedLineID then
                        Result := Result + CalcCellValue(AccSchedLine,ColumnLayout,CalcAddCurr);
                    until AccSchedLine.Next = 0
                  else
                    if IsFilter or (not Evaluate(Result,Expression)) then
                      ShowError(Text012,AccSchedLine,ColumnLayout);
                end else begin
                  ColumnLayout.SetRange("Column Layout Name",ColumnLayout."Column Layout Name");
                  ColumnLayout.SetFilter("Column No.",Expression);
                  AccSchedLineID := ColumnLayout."Line No.";
                  if ColumnLayout.Find('-') then
                    repeat
                      if ColumnLayout."Line No." <> AccSchedLineID then
                        Result := Result + CalcCellValue(AccSchedLine,ColumnLayout,CalcAddCurr);
                    until ColumnLayout.Next = 0
                  else
                    if IsFilter or (not Evaluate(Result,Expression)) then
                      ShowError(Text013,AccSchedLine,ColumnLayout);
                end;
            end;
        end;
        CallLevel := CallLevel - 1;
        exit(Result);
    end;


    procedure FormatCellAsText(var ColumnLayout2: Record "Column Layout";Value: Decimal;CalcAddCurr: Boolean): Text[30]
    var
        ValueAsText: Text[30];
    begin
        ValueAsText := MatrixMgt.FormatValue(Value,ColumnLayout2."Rounding Factor",CalcAddCurr);
        
        if (ValueAsText <> '') and
          (ColumnLayout2."Column Type" = ColumnLayout2."column type"::Formula) and (StrPos(ColumnLayout2.Formula,'%') > 1)
        then begin
          if Value < 0 then
            case NegativePercents of
              Negativepercents::"Minus Sign":
                /*do nothing*/;
              Negativepercents::Parentheses:
                ValueAsText := '(' + DelStr(ValueAsText,1,1) + ')';
              Negativepercents::"Square Brackets":
                ValueAsText := '[' + DelStr(ValueAsText,1,1) + ']';
              Negativepercents::"Angle Brackets":
                ValueAsText := '<' + DelStr(ValueAsText,1,1) + '>';
              Negativepercents::Braces:
                ValueAsText := '{' + DelStr(ValueAsText,1,1) + '}';
              Negativepercents::None:
                ValueAsText := DelStr(ValueAsText,1,1);
            end
          else
            case NegativePercents of
              Negativepercents::"Minus Sign",
              Negativepercents::None:
                /*do nothing*/;
              Negativepercents::Parentheses,
              Negativepercents::"Square Brackets",
              Negativepercents::Braces:
                ValueAsText := ValueAsText + ' ';
              Negativepercents::"Angle Brackets":
                ValueAsText := ValueAsText + '  ';
            end;
          ValueAsText := ValueAsText + '%';
        end else begin
          if Value < 0 then
            case NegativeAmounts of
              Negativeamounts::"Minus Sign":
                /*do nothing*/;
              Negativeamounts::Parentheses:
                ValueAsText := '(' + DelStr(ValueAsText,1,1) + ')';
              Negativeamounts::"Square Brackets":
                ValueAsText := '[' + DelStr(ValueAsText,1,1) + ']';
              Negativeamounts::"Angle Brackets":
                ValueAsText := '<' + DelStr(ValueAsText,1,1) + '>';
              Negativeamounts::Braces:
                ValueAsText := '{' + DelStr(ValueAsText,1,1) + '}';
              Negativeamounts::None:
                ValueAsText := DelStr(ValueAsText,1,1);
            end
          else
            case NegativeAmounts of
              Negativeamounts::"Minus Sign",
              Negativeamounts::None:
                /*do nothing*/;
              Negativeamounts::Parentheses,
              Negativeamounts::"Square Brackets",
              Negativeamounts::Braces:
                ValueAsText := ValueAsText + ' ';
              Negativeamounts::"Angle Brackets":
                ValueAsText := ValueAsText + '  ';
            end;
        end;
        exit(ValueAsText);

    end;


    procedure GetDivisionError(): Boolean
    begin
        exit(DivisionError);
    end;


    procedure GetPeriodError(): Boolean
    begin
        exit(PeriodError);
    end;

    local procedure ShowError(MessageLine: Text[100];var AccSchedLine: Record "Acc. Schedule Line";var ColumnLayout: Record "Column Layout")
    begin
        AccSchedLine.SetRange("Schedule Name",AccSchedLine."Schedule Name");
        AccSchedLine.SetRange("Line No.",CallingAccSchedLineID);
        if AccSchedLine.FindFirst then;
        ColumnLayout.SetRange("Column Layout Name",ColumnLayout."Column Layout Name");
        ColumnLayout.SetRange("Line No.",CallingColumnLayoutID);
        if ColumnLayout.FindFirst then;
        Error(
          StrSubstNo(
            Text016,
            MessageLine,
            Text017,
            StrSubstNo(Text018,AccSchedLine."Row No.",AccSchedLine."Line No.",AccSchedLine.Totaling),
            StrSubstNo(Text019,ColumnLayout."Column No.",ColumnLayout."Line No.",ColumnLayout.Formula)));
    end;


    procedure InsertGLAccounts(var AccSchedLine: Record "Acc. Schedule Line")
    var
        GLAcc: Record "G/L Account";
        GLAccList: Page "G/L Account List";
        AccCounter: Integer;
        AccSchedLineNo: Integer;
    begin
        GLAccList.LookupMode(true);
        if GLAccList.RunModal = Action::LookupOK then begin
          GLAccList.SetSelection(GLAcc);
          AccCounter := GLAcc.Count;
          if AccCounter > 0 then begin
            AccSchedLineNo := AccSchedLine."Line No.";
            MoveAccSchedLines(AccSchedLine,AccCounter);
            if GLAcc.FindSet then
              repeat
                AccSchedLine.Init;
                AccSchedLineNo := AccSchedLineNo + 10000;
                AccSchedLine."Line No." := AccSchedLineNo;
                AccSchedLine.Description := GLAcc.Name;
                AccSchedLine.Indentation := GLAcc.Indentation;
                AccSchedLine.Bold := GLAcc."Account Type" <> GLAcc."account type"::Posting;
                if GLAcc."Account Type" in
                   [GLAcc."account type"::Posting,GLAcc."account type"::Total,GLAcc."account type"::"End-Total"]
                then begin
                  AccSchedLine.Totaling := GLAcc."No.";
                  AccSchedLine."Row No." := CopyStr(GLAcc."No.",1,MaxStrLen(AccSchedLine."Row No."));
                end;
                if GLAcc."Account Type" in
                   [GLAcc."account type"::Total,GLAcc."account type"::"End-Total"]
                then
                  AccSchedLine."Totaling Type" := AccSchedLine."totaling type"::"Total Accounts"
                else
                  AccSchedLine."Totaling Type" := AccSchedLine."totaling type"::"Posting Accounts";
                AccSchedLine.Insert;
              until GLAcc.Next = 0;
          end;
        end;
    end;


    procedure InsertCFAccounts(var AccSchedLine: Record "Acc. Schedule Line")
    var
        CashFlowAcc: Record "Cash Flow Account";
        CashFlowAccList: Page "Cash Flow Account List";
        AccCounter: Integer;
        AccSchedLineNo: Integer;
    begin
        CashFlowAccList.LookupMode(true);
        if CashFlowAccList.RunModal = Action::LookupOK then begin
          CashFlowAccList.SetSelection(CashFlowAcc);
          AccCounter := CashFlowAcc.Count;
          if AccCounter > 0 then begin
            AccSchedLineNo := AccSchedLine."Line No.";
            MoveAccSchedLines(AccSchedLine,AccCounter);
            if CashFlowAcc.FindSet then
              repeat
                AccSchedLine.Init;
                AccSchedLineNo := AccSchedLineNo + 10000;
                AccSchedLine."Line No." := AccSchedLineNo;
                AccSchedLine.Description := CashFlowAcc.Name;
                if CashFlowAcc."Account Type" in
                   [CashFlowAcc."account type"::Entry,CashFlowAcc."account type"::Total,CashFlowAcc."account type"::"End-Total"]
                then begin
                  AccSchedLine.Totaling := CashFlowAcc."No.";
                  AccSchedLine."Row No." := CopyStr(CashFlowAcc."No.",1,MaxStrLen(AccSchedLine."Row No."));
                end;
                if CashFlowAcc."Account Type" in
                   [CashFlowAcc."account type"::Total,CashFlowAcc."account type"::"End-Total"]
                then
                  AccSchedLine."Totaling Type" := AccSchedLine."totaling type"::"Cash Flow Total Accounts"
                else
                  AccSchedLine."Totaling Type" := AccSchedLine."totaling type"::"Cash Flow Entry Accounts";
                AccSchedLine.Insert;
              until CashFlowAcc.Next = 0;
          end;
        end;
    end;


    procedure InsertCostTypes(var AccSchedLine: Record "Acc. Schedule Line")
    var
        CostType: Record "Cost Type";
        CostTypeList: Page "Cost Type List";
        AccCounter: Integer;
        AccSchedLineNo: Integer;
    begin
        CostTypeList.LookupMode(true);
        if CostTypeList.RunModal = Action::LookupOK then begin
          CostTypeList.SetSelection(CostType);
          AccCounter := CostType.Count;
          if AccCounter > 0 then begin
            AccSchedLineNo := AccSchedLine."Line No.";
            MoveAccSchedLines(AccSchedLine,AccCounter);
            if CostType.FindSet then
              repeat
                AccSchedLine.Init;
                AccSchedLineNo := AccSchedLineNo + 10000;
                AccSchedLine."Line No." := AccSchedLineNo;
                AccSchedLine.Description := CostType.Name;
                if CostType.Type in
                   [CostType.Type::"Cost Type",CostType.Type::Total,CostType.Type::"End-Total"]
                then begin
                  AccSchedLine.Totaling := CostType."No.";
                  AccSchedLine."Row No." := CopyStr(CostType."No.",1,MaxStrLen(AccSchedLine."Row No."));
                end;
                if CostType.Type in
                   [CostType.Type::Total,CostType.Type::"End-Total"]
                then
                  AccSchedLine."Totaling Type" := AccSchedLine."totaling type"::"Cost Type Total"
                else
                  AccSchedLine."Totaling Type" := AccSchedLine."totaling type"::"Cost Type";
                AccSchedLine.Insert;
              until CostType.Next = 0;
          end;
        end;
    end;

    local procedure ExchangeAmtAddCurrToLCY(AmountLCY: Decimal): Decimal
    begin
        if not GLSetupRead then begin
          GLSetup.Get;
          GLSetupRead := true;
        end;

        exit(
          CurrExchRate.ExchangeAmtLCYToFCY(
            WorkDate,GLSetup."Additional Reporting Currency",AmountLCY,
            CurrExchRate.ExchangeRate(WorkDate,GLSetup."Additional Reporting Currency")));
    end;


    procedure SetAccSchedName(var NewAccSchedName: Record "Acc. Schedule Name")
    begin
        AccSchedName := NewAccSchedName;
    end;


    procedure GetDimTotalingFilter(DimNo: Integer;DimTotaling: Text[250]): Text[1024]
    var
        DimTotaling2: Text[250];
        DimTotalPart: Text[250];
        ResultFilter: Text[1024];
        ResultFilter2: Text[1024];
        i: Integer;
    begin
        if DimTotaling = '' then
          exit(DimTotaling);
        DimTotaling2 := DimTotaling;
        repeat
          i := StrPos(DimTotaling2,'|');
          if i > 0 then begin
            DimTotalPart := CopyStr(DimTotaling2,1,i - 1);
            if i < StrLen(DimTotaling2) then
              DimTotaling2 := CopyStr(DimTotaling2,i + 1)
            else
              DimTotaling2 := '';
          end else
            DimTotalPart := DimTotaling2;
          ResultFilter2 := ConvDimTotalingFilter(DimNo,DimTotalPart);
          if ResultFilter2 <> '' then
            if StrLen(ResultFilter) + StrLen(ResultFilter2) + 1 > MaxStrLen(ResultFilter) then
              Error(Text021,DimTotaling);

          if ResultFilter <> '' then
            ResultFilter := ResultFilter + '|';
          ResultFilter := CopyStr(ResultFilter + ResultFilter2,1,MaxStrLen(ResultFilter));
        until i <= 0;
        exit(ResultFilter);
    end;

    local procedure ConvDimTotalingFilter(DimNo: Integer;DimTotaling: Text[250]): Text[1024]
    var
        DimVal: Record "Dimension Value";
        CostAccSetup: Record "Cost Accounting Setup";
        DimCode: Code[20];
        ResultFilter: Text[1024];
        DimValTotaling: Boolean;
    begin
        if CostAccSetup.Get then;
        if DimTotaling = '' then
          exit(DimTotaling);

        CheckAnalysisView(AccSchedName.Name,'',false);

        case DimNo of
          1:
            DimCode := AnalysisView."Dimension 1 Code";
          2:
            DimCode := AnalysisView."Dimension 2 Code";
          3:
            DimCode := AnalysisView."Dimension 3 Code";
          4:
            DimCode := AnalysisView."Dimension 4 Code";
          5:
            DimCode := CostAccSetup."Cost Center Dimension";
          6:
            DimCode := CostAccSetup."Cost Object Dimension";
        end;
        if DimCode = '' then
          exit(DimTotaling);

        DimVal.SetRange("Dimension Code",DimCode);
        DimVal.SetFilter(Code,DimTotaling);
        if DimVal.Find('-') then
          repeat
            DimValTotaling :=
              DimVal."Dimension Value Type" in
              [DimVal."dimension value type"::Total,DimVal."dimension value type"::"End-Total"];
            if DimValTotaling and (DimVal.Totaling <> '') then begin
              if StrLen(ResultFilter) + StrLen(DimVal.Totaling) + 1 > MaxStrLen(ResultFilter) then
                Error(Text021,DimTotaling);
              if ResultFilter <> '' then
                ResultFilter := ResultFilter + '|';
              ResultFilter := ResultFilter + DimVal.Totaling;
            end;
          until (DimVal.Next = 0) or not DimValTotaling;

        if DimValTotaling then
          exit(ResultFilter);

        exit(DimTotaling);
    end;

    local procedure CalcCostType(var CostType: Record "Cost Type";var AccSchedLine: Record "Acc. Schedule Line";var ColumnLayout: Record "Column Layout";CalcAddCurr: Boolean) ColValue: Decimal
    var
        CostEntry: Record "Cost Entry";
        CostBudgEntry: Record "Cost Budget Entry";
        AmountType: Option "Net Amount","Debit Amount","Credit Amount";
        UseDimFilter: Boolean;
        TestBalance: Boolean;
        Balance: Decimal;
    begin
        ColValue := 0;
        if AccSchedName.Name <> AccSchedLine."Schedule Name" then
          AccSchedName.Get(AccSchedLine."Schedule Name");

        if ConflictAmountType(AccSchedLine,ColumnLayout."Amount Type",AmountType) then
          exit(0);

        TestBalance :=
          AccSchedLine.Show in [AccSchedLine.Show::"When Positive Balance",AccSchedLine.Show::"When Negative Balance"];

        if ColumnLayout."Column Type" <> ColumnLayout."column type"::Formula then begin
          UseDimFilter := HasDimFilter(AccSchedLine,ColumnLayout) or HasCostDimFilter(AccSchedLine);
          if ColumnLayout."Ledger Entry Type" = ColumnLayout."ledger entry type"::Entries then begin
            with CostEntry do begin
              if UseDimFilter then
                SetCurrentkey("Cost Type No.","Cost Center Code","Cost Object Code")
              else
                SetCurrentkey("Cost Type No.","Posting Date");
              if CostType.Totaling = '' then
                SetRange("Cost Type No.",CostType."No.")
              else
                SetFilter("Cost Type No.",CostType.Totaling);
              CostType.Copyfilter("Date Filter","Posting Date");
              AccSchedLine.Copyfilter("Cost Center Filter","Cost Center Code");
              AccSchedLine.Copyfilter("Cost Object Filter","Cost Object Code");
              FilterGroup(2);
              SetFilter("Cost Center Code",GetDimTotalingFilter(5,AccSchedLine."Cost Center Totaling"));
              SetFilter("Cost Object Code",GetDimTotalingFilter(6,AccSchedLine."Cost Object Totaling"));
              FilterGroup(8);
              SetFilter("Cost Center Code",GetDimTotalingFilter(5,ColumnLayout."Cost Center Totaling"));
              SetFilter("Cost Object Code",GetDimTotalingFilter(6,ColumnLayout."Cost Object Totaling"));
              FilterGroup(0);
            end;
            case AmountType of
              Amounttype::"Net Amount":
                begin
                  if CalcAddCurr then begin
                    CostEntry.CalcSums("Additional-Currency Amount");
                    ColValue := CostEntry."Additional-Currency Amount";
                  end else begin
                    CostEntry.CalcSums(Amount);
                    ColValue := CostEntry.Amount;
                  end;
                  Balance := ColValue;
                end;
              Amounttype::"Debit Amount":
                begin
                  if CalcAddCurr then begin
                    CostEntry.CalcSums("Add.-Currency Debit Amount","Additional-Currency Amount");
                    if TestBalance then
                      Balance := CostEntry."Additional-Currency Amount";
                    ColValue := CostEntry."Add.-Currency Debit Amount";
                  end else begin
                    if TestBalance then begin
                      CostEntry.CalcSums("Debit Amount",Amount);
                      Balance := CostEntry.Amount;
                    end else
                      CostEntry.CalcSums("Debit Amount");
                    ColValue := CostEntry."Debit Amount";
                  end;
                end;
              Amounttype::"Credit Amount":
                begin
                  if CalcAddCurr then begin
                    CostEntry.CalcSums("Add.-Currency Credit Amount","Additional-Currency Amount");
                    if TestBalance then
                      Balance := CostEntry."Additional-Currency Amount";
                    ColValue := CostEntry."Add.-Currency Credit Amount";
                  end else begin
                    if TestBalance then begin
                      CostEntry.CalcSums("Credit Amount",Amount);
                      Balance := CostEntry.Amount;
                    end else
                      CostEntry.CalcSums("Credit Amount");
                    ColValue := CostEntry."Credit Amount";
                  end;
                end;
            end;
          end;

          if ColumnLayout."Ledger Entry Type" = ColumnLayout."ledger entry type"::"Budget Entries" then begin
            with CostBudgEntry do begin
              SetCurrentkey("Budget Name","Cost Type No.","Cost Center Code","Cost Object Code",Date);

              if CostType.Totaling = '' then
                SetRange("Cost Type No.",CostType."No.")
              else
                SetFilter("Cost Type No.",CostType.Totaling);

              CostType.Copyfilter("Date Filter",Date);
              AccSchedLine.Copyfilter("Cost Budget Filter","Budget Name");
              AccSchedLine.Copyfilter("Cost Center Filter","Cost Center Code");
              AccSchedLine.Copyfilter("Cost Object Filter","Cost Object Code");

              FilterGroup(2);
              SetFilter("Cost Center Code",GetDimTotalingFilter(5,AccSchedLine."Cost Center Totaling"));
              SetFilter("Cost Object Code",GetDimTotalingFilter(6,AccSchedLine."Cost Object Totaling"));
              FilterGroup(8);
              SetFilter("Cost Center Code",GetDimTotalingFilter(5,ColumnLayout."Cost Center Totaling"));
              SetFilter("Cost Object Code",GetDimTotalingFilter(6,ColumnLayout."Cost Object Totaling"));
              FilterGroup(0);
            end;

            CostBudgEntry.CalcSums(Amount);

            case AmountType of
              Amounttype::"Net Amount":
                ColValue := CostBudgEntry.Amount;
              Amounttype::"Debit Amount":
                if CostBudgEntry.Amount > 0 then
                  ColValue := CostBudgEntry.Amount;
              Amounttype::"Credit Amount":
                if CostBudgEntry.Amount < 0 then
                  ColValue := CostBudgEntry.Amount;
            end;
            Balance := CostBudgEntry.Amount;
            if CalcAddCurr then
              ColValue := CalcLCYToACY(ColValue);
          end;

          if TestBalance then begin
            if AccSchedLine.Show = AccSchedLine.Show::"When Positive Balance" then
              if Balance < 0 then
                exit(0);
            if AccSchedLine.Show = AccSchedLine.Show::"When Negative Balance" then
              if Balance > 0 then
                exit(0);
          end;
        end;
        exit(ColValue);
    end;


    procedure SetCostTypeRowFilters(var CostType: Record "Cost Type";var AccSchedLine2: Record "Acc. Schedule Line";var ColumnLayout: Record "Column Layout")
    begin
        with AccSchedLine2 do begin
          case "Totaling Type" of
            "totaling type"::"Cost Type":
              begin
                CostType.SetFilter("No.",Totaling);
                CostType.SetRange(Type,CostType.Type::"Cost Type");
              end;
            "totaling type"::"Cost Type Total":
              begin
                CostType.SetFilter("No.",Totaling);
                CostType.SetFilter(Type,'<>%1',CostType.Type::"Cost Type");
              end;
          end;

          CostType.SetFilter("Cost Center Filter",GetFilter("Cost Center Filter"));
          CostType.SetFilter("Cost Object Filter",GetFilter("Cost Object Filter"));
          if ColumnLayout."Ledger Entry Type" = ColumnLayout."ledger entry type"::"Budget Entries" then
            CostType.SetFilter("Budget Filter",GetFilter("Cost Budget Filter"));
        end;
    end;


    procedure SetCostTypeColumnFilters(var CostType: Record "Cost Type";AccSchedLine2: Record "Acc. Schedule Line";var ColumnLayout: Record "Column Layout")
    var
        FromDate: Date;
        ToDate: Date;
        FiscalStartDate2: Date;
    begin
        with ColumnLayout do begin
          CalcColumnDates("Comparison Date Formula","Comparison Period Formula",FromDate,ToDate,FiscalStartDate2);
          case "Column Type" of
            "column type"::"Net Change":
              case AccSchedLine2."Row Type" of
                AccSchedLine2."row type"::"Net Change":
                  CostType.SetRange("Date Filter",FromDate,ToDate);
                AccSchedLine2."row type"::"Beginning Balance":
                  CostType.SetFilter("Date Filter",'<%1',FromDate);
                AccSchedLine2."row type"::"Balance at Date":
                  CostType.SetRange("Date Filter",0D,ToDate);
              end;
            "column type"::"Balance at Date":
              if AccSchedLine2."Row Type" = AccSchedLine2."row type"::"Beginning Balance" then
                CostType.SetRange("Date Filter",0D) // Force a zero return
              else
                CostType.SetRange("Date Filter",0D,ToDate);
            "column type"::"Beginning Balance":
              if AccSchedLine2."Row Type" = AccSchedLine2."row type"::"Balance at Date" then
                CostType.SetRange("Date Filter",0D) // Force a zero return
              else
                CostType.SetRange(
                  "Date Filter",0D,CalcDate('<-1D>',FromDate));
            "column type"::"Year to Date":
              case AccSchedLine2."Row Type" of
                AccSchedLine2."row type"::"Net Change":
                  CostType.SetRange("Date Filter",FiscalStartDate2,ToDate);
                AccSchedLine2."row type"::"Beginning Balance":
                  CostType.SetFilter("Date Filter",'<%1',FiscalStartDate2);
                AccSchedLine2."row type"::"Balance at Date":
                  CostType.SetRange("Date Filter",0D,ToDate);
              end;
            "column type"::"Rest of Fiscal Year":
              case AccSchedLine2."Row Type" of
                AccSchedLine2."row type"::"Net Change":
                  CostType.SetRange(
                    "Date Filter",CalcDate('<+1D>',ToDate),FindEndOfFiscalYear(FiscalStartDate2));
                AccSchedLine2."row type"::"Beginning Balance":
                  CostType.SetRange("Date Filter",0D,ToDate);
                AccSchedLine2."row type"::"Balance at Date":
                  CostType.SetRange("Date Filter",0D,FindEndOfFiscalYear(ToDate));
              end;
            "column type"::"Entire Fiscal Year":
              case AccSchedLine2."Row Type" of
                AccSchedLine2."row type"::"Net Change":
                  CostType.SetRange(
                    "Date Filter",FiscalStartDate2,FindEndOfFiscalYear(FiscalStartDate2));
                AccSchedLine2."row type"::"Beginning Balance":
                  CostType.SetFilter("Date Filter",'<%1',FiscalStartDate2);
                AccSchedLine2."row type"::"Balance at Date":
                  CostType.SetRange("Date Filter",0D,FindEndOfFiscalYear(ToDate));
              end;
          end;
        end;
    end;

    local procedure HasDimFilter(var AccSchedLine: Record "Acc. Schedule Line";var ColumnLayout: Record "Column Layout"): Boolean
    begin
        exit((AccSchedLine."Dimension 1 Totaling" <> '') or
          (AccSchedLine."Dimension 2 Totaling" <> '') or
          (AccSchedLine."Dimension 3 Totaling" <> '') or
          (AccSchedLine."Dimension 4 Totaling" <> '') or
          (AccSchedLine.GetFilter("Dimension 1 Filter") <> '') or
          (AccSchedLine.GetFilter("Dimension 2 Filter") <> '') or
          (AccSchedLine.GetFilter("Dimension 3 Filter") <> '') or
          (AccSchedLine.GetFilter("Dimension 4 Filter") <> '') or
          (ColumnLayout."Dimension 1 Totaling" <> '') or
          (ColumnLayout."Dimension 2 Totaling" <> '') or
          (ColumnLayout."Dimension 3 Totaling" <> '') or
          (ColumnLayout."Dimension 4 Totaling" <> '') or
          (ColumnLayout."Cost Center Totaling" <> '') or
          (ColumnLayout."Cost Object Totaling" <> ''));
    end;

    local procedure HasCostDimFilter(var AccSchedLine: Record "Acc. Schedule Line"): Boolean
    begin
        exit((AccSchedLine."Cost Center Totaling" <> '') or
          (AccSchedLine."Cost Object Totaling" <> '') or
          (AccSchedLine.GetFilter("Cost Center Filter") <> '') or
          (AccSchedLine.GetFilter("Cost Object Filter") <> ''));
    end;


    procedure CalcColumnDates(ComparisonDateFormula: DateFormula;ComparisonPeriodFormula: Code[20];var FromDate: Date;var ToDate: Date;var FiscalStartDate2: Date)
    begin
        if (Format(ComparisonDateFormula) <> '0') and (Format(ComparisonDateFormula) <> '') then begin
          FromDate := CalcDate(ComparisonDateFormula,StartDate);
          ToDate := CalcDate(ComparisonDateFormula,EndDate);
          if (StartDate = CalcDate('<-CM>',StartDate)) and
             (FromDate = CalcDate('<-CM>',FromDate)) and
             (EndDate = CalcDate('<CM>',EndDate))
          then
            ToDate := CalcDate('<CM>',ToDate);
          FiscalStartDate2 := FindFiscalYear(ToDate);
        end else
          if ComparisonPeriodFormula <> '' then begin
            AccPeriodStartEnd(ComparisonPeriodFormula,StartDate,FromDate,ToDate);
            FiscalStartDate2 := FindFiscalYear(ToDate);
          end else begin
            FromDate := StartDate;
            ToDate := EndDate;
            FiscalStartDate2 := FiscalStartDate;
          end;
    end;

    local procedure MoveAccSchedLines(var AccSchedLine: Record "Acc. Schedule Line";Place: Integer)
    var
        AccSchedLineNo: Integer;
        I: Integer;
    begin
        AccSchedLineNo := AccSchedLine."Line No.";
        AccSchedLine.SetRange("Schedule Name",AccSchedLine."Schedule Name");
        if AccSchedLine.Find('+') then
          repeat
            I := AccSchedLine."Line No.";
            if I > AccSchedLineNo then begin
              AccSchedLine.Delete;
              AccSchedLine."Line No." := I + 10000 * Place;
              AccSchedLine.Insert;
            end;
          until (I <= AccSchedLineNo) or (AccSchedLine.Next(-1) = 0);
    end;


    procedure SetStartDateEndDate(NewStartDate: Date;NewEndDate: Date)
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
    end;


    procedure BuildFinPerDescription(BaseDescription: Text[80];PeriodStartDate: Date;PeriodEndDate: Date) FinPerDescription: Text[250]
    var
        StartDay: Integer;
        StartMonth: Integer;
        StartYear: Integer;
        StartMonthName: Text[30];
        EndDay: Integer;
        EndMonth: Integer;
        EndYear: Integer;
        EndMonthName: Text[30];
    begin
        BreakDownDate(PeriodStartDate,StartYear,StartMonth,StartDay,StartMonthName);
        BreakDownDate(PeriodEndDate,EndYear,EndMonth,EndDay,EndMonthName);
        if BaseDescription = '' then
          BaseDescription := USText005;
        FinPerDescription :=
          StrSubstNo(
            BaseDescription,
            StartYear,StartMonth,StartMonthName,StartDay,
            EndYear,EndMonth,EndMonthName,EndDay);
    end;

    local procedure BreakDownDate(DateToBreak: Date;var Year: Integer;var Month: Integer;var Day: Integer;var MonthName: Text[30])
    begin
        Day := Date2dmy(DateToBreak,1);
        Month := Date2dmy(DateToBreak,2);
        Year := Date2dmy(DateToBreak,3);
        case Month of
          1:
            MonthName := MonthText01;
          2:
            MonthName := MonthText02;
          3:
            MonthName := MonthText03;
          4:
            MonthName := MonthText04;
          5:
            MonthName := MonthText05;
          6:
            MonthName := MonthText06;
          7:
            MonthName := MonthText07;
          8:
            MonthName := MonthText08;
          9:
            MonthName := MonthText09;
          10:
            MonthName := MonthText10;
          11:
            MonthName := MonthText11;
          12:
            MonthName := MonthText12;
        end;
    end;

    local procedure ConflictAmountType(AccSchedLine: Record "Acc. Schedule Line";ColumnLayoutAmtType: Option "Net Amount","Debit Amount","Credit Amount";var AmountType: Option): Boolean
    begin
        if (ColumnLayoutAmtType = AccSchedLine."Amount Type") or
           (AccSchedLine."Amount Type" = AccSchedLine."amount type"::"Net Amount")
        then
          AmountType := ColumnLayoutAmtType
        else
          if ColumnLayoutAmtType = Columnlayoutamttype::"Net Amount" then
            AmountType := AccSchedLine."Amount Type"
          else
            exit(true);
        exit(false);
    end;


    procedure DrillDown(TempColumnLayout: Record "Column Layout" temporary;var AccScheduleLine: Record "Acc. Schedule Line";PeriodLength: Option)
    var
        AccScheduleOverview: Page "Acc. Schedule Overview";
        ErrorType: Option "None","Division by Zero","Period Error",Both;
    begin
        with AccScheduleLine do begin
          if TempColumnLayout."Column Type" = TempColumnLayout."column type"::Formula then begin
            CalcFieldError(ErrorType,"Line No.",TempColumnLayout."Line No.");
            if ErrorType <> Errortype::None then
              Message(StrSubstNo(ColumnFormulaErrorMsg,TempColumnLayout.Formula,Format(ErrorType)))
            else
              Message(ColumnFormulaMsg,TempColumnLayout.Formula);
            exit;
          end;

          if "Totaling Type" in ["totaling type"::Formula,"totaling type"::"Set Base For Percent"] then begin
            AccScheduleOverview.SetAccSchedName("Schedule Name");
            AccScheduleOverview.SetTableview(AccScheduleLine);
            AccScheduleOverview.SetRecord(AccScheduleLine);
            AccScheduleOverview.SetPeriodType(PeriodLength);
            AccScheduleOverview.Run;
            exit;
          end;

          if Totaling = '' then
            exit;

          if "Totaling Type" in ["totaling type"::"Cash Flow Entry Accounts","totaling type"::"Cash Flow Total Accounts"] then
            DrillDownOnCFAccount(TempColumnLayout,AccScheduleLine)
          else
            DrillDownOnGLAccount(TempColumnLayout,AccScheduleLine);
        end;
    end;


    procedure DrillDownFromOverviewPage(TempColumnLayout: Record "Column Layout" temporary;var AccScheduleLine: Record "Acc. Schedule Line";PeriodLength: Option)
    begin
        with AccScheduleLine do begin
          if "Totaling Type" in ["totaling type"::Formula,"totaling type"::"Set Base For Percent"] then
            Message(RowFormulaMsg,Totaling)
          else
            DrillDown(TempColumnLayout,AccScheduleLine,PeriodLength);
        end;
    end;

    local procedure DrillDownOnGLAccount(TempColumnLayout: Record "Column Layout" temporary;var AccScheduleLine: Record "Acc. Schedule Line")
    var
        GLAcc: Record "G/L Account";
        GLAccAnalysisView: Record "G/L Account (Analysis View)";
        CostType: Record "Cost Type";
        ChartOfAccsAnalysisView: Page "Chart of Accs. (Analysis View)";
    begin
        with AccScheduleLine do
          if "Totaling Type" in ["totaling type"::"Cost Type","totaling type"::"Cost Type Total"] then begin
            SetCostTypeRowFilters(CostType,AccScheduleLine,TempColumnLayout);
            SetCostTypeColumnFilters(CostType,AccScheduleLine,TempColumnLayout);
            Copyfilter("Cost Center Filter",CostType."Cost Center Filter");
            Copyfilter("Cost Object Filter",CostType."Cost Object Filter");
            Copyfilter("Cost Budget Filter",CostType."Budget Filter");
            CostType.FilterGroup(2);
            CostType.SetFilter("Cost Center Filter",GetDimTotalingFilter(1,"Cost Center Totaling"));
            CostType.SetFilter("Cost Object Filter",GetDimTotalingFilter(1,"Cost Object Totaling"));
            CostType.FilterGroup(8);
            CostType.SetFilter("Cost Center Filter",GetDimTotalingFilter(1,TempColumnLayout."Cost Center Totaling"));
            CostType.SetFilter("Cost Object Filter",GetDimTotalingFilter(1,TempColumnLayout."Cost Object Totaling"));
            CostType.FilterGroup(0);
            Page.Run(Page::"Chart of Cost Types",CostType);
          end else begin
            Copyfilter("Business Unit Filter",GLAcc."Business Unit Filter");
            Copyfilter("G/L Budget Filter",GLAcc."Budget Filter");
            SetGLAccRowFilters(GLAcc,AccScheduleLine);
            SetGLAccColumnFilters(GLAcc,AccScheduleLine,TempColumnLayout);
            AccSchedName.Get("Schedule Name");
            if AccSchedName."Analysis View Name" = '' then begin
              Copyfilter("Dimension 1 Filter",GLAcc."Global Dimension 1 Filter");
              Copyfilter("Dimension 2 Filter",GLAcc."Global Dimension 2 Filter");
              Copyfilter("Business Unit Filter",GLAcc."Business Unit Filter");
              GLAcc.FilterGroup(2);
              GLAcc.SetFilter("Global Dimension 1 Filter",GetDimTotalingFilter(1,"Dimension 1 Totaling"));
              GLAcc.SetFilter("Global Dimension 2 Filter",GetDimTotalingFilter(2,"Dimension 2 Totaling"));
              GLAcc.FilterGroup(8);
              GLAcc.SetFilter("Business Unit Filter",TempColumnLayout."Business Unit Totaling");
              GLAcc.SetFilter("Global Dimension 1 Filter",GetDimTotalingFilter(1,TempColumnLayout."Dimension 1 Totaling"));
              GLAcc.SetFilter("Global Dimension 2 Filter",GetDimTotalingFilter(2,TempColumnLayout."Dimension 2 Totaling"));
              GLAcc.FilterGroup(0);
              Page.Run(Page::"Chart of Accounts (G/L)",GLAcc)
            end else begin
              GLAcc.Copyfilter("Date Filter",GLAccAnalysisView."Date Filter");
              GLAcc.Copyfilter("Budget Filter",GLAccAnalysisView."Budget Filter");
              GLAcc.Copyfilter("Business Unit Filter",GLAccAnalysisView."Business Unit Filter");
              GLAccAnalysisView.SetRange("Analysis View Filter",AccSchedName."Analysis View Name");
              GLAccAnalysisView.CopyDimFilters(AccScheduleLine);
              GLAccAnalysisView.FilterGroup(2);
              GLAccAnalysisView.SetDimFilters(
                GetDimTotalingFilter(1,"Dimension 1 Totaling"),GetDimTotalingFilter(2,"Dimension 2 Totaling"),
                GetDimTotalingFilter(3,"Dimension 3 Totaling"),GetDimTotalingFilter(4,"Dimension 4 Totaling"));
              GLAccAnalysisView.FilterGroup(8);
              GLAccAnalysisView.SetDimFilters(
                GetDimTotalingFilter(1,TempColumnLayout."Dimension 1 Totaling"),
                GetDimTotalingFilter(2,TempColumnLayout."Dimension 2 Totaling"),
                GetDimTotalingFilter(3,TempColumnLayout."Dimension 3 Totaling"),
                GetDimTotalingFilter(4,TempColumnLayout."Dimension 4 Totaling"));
              GLAccAnalysisView.SetFilter("Business Unit Filter",TempColumnLayout."Business Unit Totaling");
              GLAccAnalysisView.FilterGroup(0);
              Clear(ChartOfAccsAnalysisView);
              ChartOfAccsAnalysisView.InsertTempGLAccAnalysisViews(GLAcc);
              ChartOfAccsAnalysisView.SetTableview(GLAccAnalysisView);
              ChartOfAccsAnalysisView.Run;
            end;
          end;
    end;

    local procedure DrillDownOnCFAccount(TempColumnLayout: Record "Column Layout" temporary;var AccScheduleLine: Record "Acc. Schedule Line")
    var
        CFAccount: Record "Cash Flow Account";
        GLAccAnalysisView: Record "G/L Account (Analysis View)";
        ChartOfAccsAnalysisView: Page "Chart of Accs. (Analysis View)";
    begin
        with AccScheduleLine do begin
          Copyfilter("Cash Flow Forecast Filter",CFAccount."Cash Flow Forecast Filter");

          SetCFAccRowFilter(CFAccount,AccScheduleLine);
          SetCFAccColumnFilter(CFAccount,AccScheduleLine,TempColumnLayout);
          AccSchedName.Get("Schedule Name");
          if AccSchedName."Analysis View Name" = '' then begin
            Copyfilter("Dimension 1 Filter",CFAccount."Global Dimension 1 Filter");
            Copyfilter("Dimension 2 Filter",CFAccount."Global Dimension 2 Filter");
            CFAccount.FilterGroup(2);
            CFAccount.SetFilter("Global Dimension 1 Filter",GetDimTotalingFilter(1,"Dimension 1 Totaling"));
            CFAccount.SetFilter("Global Dimension 2 Filter",GetDimTotalingFilter(2,"Dimension 2 Totaling"));
            CFAccount.FilterGroup(8);
            CFAccount.SetFilter("Global Dimension 1 Filter",GetDimTotalingFilter(1,TempColumnLayout."Dimension 1 Totaling"));
            CFAccount.SetFilter("Global Dimension 2 Filter",GetDimTotalingFilter(2,TempColumnLayout."Dimension 2 Totaling"));
            CFAccount.FilterGroup(0);
            Page.Run(Page::"Chart of Cash Flow Accounts",CFAccount)
          end else begin
            CFAccount.Copyfilter("Date Filter",GLAccAnalysisView."Date Filter");
            CFAccount.Copyfilter("Cash Flow Forecast Filter",GLAccAnalysisView."Cash Flow Forecast Filter");
            GLAccAnalysisView.SetRange("Analysis View Filter",AccSchedName."Analysis View Name");
            GLAccAnalysisView.CopyDimFilters(AccScheduleLine);
            GLAccAnalysisView.FilterGroup(2);
            GLAccAnalysisView.SetDimFilters(
              GetDimTotalingFilter(1,"Dimension 1 Totaling"),
              GetDimTotalingFilter(2,"Dimension 2 Totaling"),
              GetDimTotalingFilter(3,"Dimension 3 Totaling"),
              GetDimTotalingFilter(4,"Dimension 4 Totaling"));
            GLAccAnalysisView.FilterGroup(8);
            GLAccAnalysisView.SetDimFilters(
              GetDimTotalingFilter(1,TempColumnLayout."Dimension 1 Totaling"),
              GetDimTotalingFilter(2,TempColumnLayout."Dimension 2 Totaling"),
              GetDimTotalingFilter(3,TempColumnLayout."Dimension 3 Totaling"),
              GetDimTotalingFilter(4,TempColumnLayout."Dimension 4 Totaling"));
            GLAccAnalysisView.FilterGroup(0);
            Clear(ChartOfAccsAnalysisView);
            ChartOfAccsAnalysisView.InsertTempCFAccountAnalysisVie(CFAccount);
            ChartOfAccsAnalysisView.SetTableview(GLAccAnalysisView);
            ChartOfAccsAnalysisView.Run;
          end;
        end;
    end;


    procedure FindPeriod(var AccScheduleLine: Record "Acc. Schedule Line";SearchText: Text[3];PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period")
    var
        Calendar: Record Date;
        PeriodFormMgt: Codeunit PeriodFormManagement;
    begin
        with AccScheduleLine do begin
          if GetFilter("Date Filter") <> '' then begin
            Calendar.SetFilter("Period Start",GetFilter("Date Filter"));
            if not PeriodFormMgt.FindDate('+',Calendar,PeriodType) then
              PeriodFormMgt.FindDate('+',Calendar,Periodtype::Day);
            Calendar.SetRange("Period Start");
          end;
          PeriodFormMgt.FindDate(SearchText,Calendar,PeriodType);
          SetRange("Date Filter",Calendar."Period Start",Calendar."Period End");
          if GetRangeMin("Date Filter") = GetRangemax("Date Filter") then
            SetRange("Date Filter",GetRangeMin("Date Filter"));
        end;
    end;


    procedure CalcFieldError(var ErrorType: Option "None","Division by Zero","Period Error",Both;RowNo: Integer;ColumnNo: Integer)
    begin
        AccSchedCellValue.SetRange("Row No.",RowNo);
        AccSchedCellValue.SetRange("Column No.",ColumnNo);
        ErrorType := Errortype::None;
        if AccSchedCellValue.FindFirst then
          case true of
            AccSchedCellValue."Has Error":
              ErrorType := Errortype::"Division by Zero";
            AccSchedCellValue."Period Error":
              ErrorType := Errortype::"Period Error";
            AccSchedCellValue."Has Error" and AccSchedCellValue."Period Error":
              ErrorType := Errortype::Both;
          end;

        AccSchedCellValue.SetRange("Row No.");
        AccSchedCellValue.SetRange("Column No.");
    end;


    procedure ForceRecalculate(NewRecalculate: Boolean)
    begin
        Recalculate := NewRecalculate;
    end;

    local procedure CalcLCYToACY(ColValue: Decimal): Decimal
    begin
        if not GLSetupRead then begin
          GLSetup.Get;
          GLSetupRead := true;
          if GLSetup."Additional Reporting Currency" <> '' then
            AddRepCurrency.Get(GLSetup."Additional Reporting Currency");
        end;
        if GLSetup."Additional Reporting Currency" <> '' then
          exit(ROUND(ExchangeAmtAddCurrToLCY(ColValue),AddRepCurrency."Amount Rounding Precision"));
        exit(0);
    end;
}

