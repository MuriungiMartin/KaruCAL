#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 424 "Export Analysis View"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'You can only export Actual amounts and Budgeted amounts.\Please change the option in the Show field.';
        Text001: label 'This combination is not valid. You cannot export Debit and Credit amounts for Budgeted amounts.\Please enter Amount in the Show Amount field.';
        Text002: label 'General Info._';
        Text003: label 'None';
        Text004: label 'Day';
        Text005: label 'Week';
        Text006: label 'Month';
        Text007: label 'Quarter';
        Text008: label 'Year';
        Text009: label 'Accounting Period';
        Text011: label 'Analysis by Dimension ';
        Text012: label 'Amount Type';
        Text013: label 'Net Change';
        Text014: label 'Balance at Date';
        Text015: label 'Date Filter';
        Text016: label 'Budget Filter';
        Text116: label 'Cash Flow Forecast Filter';
        Text017: label 'Pivot Table_';
        Text018: label 'G/L Account';
        Text118: label 'Cash Flow Account';
        Text019: label 'Period';
        Text020: label 'Budgeted Amount';
        Text022: label 'Level';
        Text023: label 'Analysis View Name';
        Text024: label 'Closing Entries';
        Text025: label 'Included';
        Text026: label 'Excluded';
        Text027: label 'All amounts shown in ';
        Text028: label 'Show Opposite Sign';
        Text029: label 'Yes';
        Text030: label 'No';
        Text031: label 'Data_';
        Text032: label 'There are more than %1 rows within the filters. Excel only allows up to %1 rows.\You can either narrow the filters or choose a higher %2 value on the %3.';
        TempDimValue2: Record "Dimension Value" temporary;
        TempDimValue3: Record "Dimension Value" temporary;
        TempGLAcc2: Record "G/L Account" temporary;
        TempGLAcc3: Record "G/L Account" temporary;
        TempCFAccount2: Record "Cash Flow Account" temporary;
        TempCFAccount3: Record "Cash Flow Account" temporary;
        BusUnit: Record "Business Unit";
        FileMgt: Codeunit "File Management";
        TextFileStream: OutStream;
        TextFileStreamWriter: dotnet StreamWriter;
        TextFileEncoding: dotnet Encoding;
        [RunOnClient]
        xlApp: dotnet ApplicationClass;
        [RunOnClient]
        xlWorkSheet: dotnet Worksheet;
        [RunOnClient]
        xlWorkSheet2: dotnet Worksheet;
        [RunOnClient]
        xlWorkSheet3: dotnet Worksheet;
        [RunOnClient]
        ExcelHelper: dotnet ExcelHelper;
        NoOfColumns: Integer;
        MaxLevel: Integer;
        MaxLevelDim: array [4] of Integer;
        FileName: Text;
        HasBusinessUnits: Boolean;
        AccNoPrefix: Code[10];
        Text038: label 'The exported data result exceeds a system limit.\Limit the selection by clearing the Show Column Name field.';
        GLAccountSource: Boolean;
        ExcelVersion: Text[30];


    procedure ExportData(var Rec: Record "Analysis View Entry";Line: Text[30];Column: Text[30];Sign: Boolean;ShowInAddCurr: Boolean;AmountField: Option;PeriodType: Option;ShowName: Boolean;DateFilter: Text;AccFilter: Text;BudgetFilter: Text;Dim1Filter: Text;Dim2Filter: Text;Dim3Filter: Text;Dim4Filter: Text;AmountType: Option;ClosingEntryFilter: Option;Show: Option;OtherFilter: Text)
    var
        AnalysisViewFilter: Record "Analysis View Filter";
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        ExcelBuffer: Record "Excel Buffer" temporary;
        AnalysisView: Record "Analysis View";
        [RunOnClient]
        xlPivotTable: dotnet PivotTable;
        [RunOnClient]
        xlPivotCache: dotnet PivotCache;
        [RunOnClient]
        xlRange: dotnet Range;
        [RunOnClient]
        xlPivotField: dotnet PivotField;
        [RunOnClient]
        PivotFieldOrientation: dotnet XlPivotFieldOrientation;
        [RunOnClient]
        PivotFieldFunction: dotnet XlConsolidationFunction;
        [RunOnClient]
        PivotFieldCalculation: dotnet XlPivotFieldCalculation;
        FormatString: Text[30];
        NoOfRows: Integer;
        RowNoCount: Integer;
        xlSheetName: Text[100];
        BusUnitFilter: Code[250];
        CashFlowFilter: Code[250];
    begin
        GLAccountSource := Rec."Account Source" = Rec."account source"::"G/L Account";

        CheckCombination(Show,AmountField);

        BusUnitFilter := '';
        CashFlowFilter := '';

        SetOtherFilterToCorrectFilter(OtherFilter,BusUnitFilter,CashFlowFilter);

        xlApp := xlApp.ApplicationClass;
        HasBusinessUnits := not BusUnit.IsEmpty;
        with Rec do begin
          NoOfRows :=
            CreateFile(
              Rec,Sign,ShowInAddCurr,ShowName,AccFilter,Dim1Filter,Dim2Filter,
              Dim3Filter,Dim4Filter,ClosingEntryFilter,DateFilter,BusUnitFilter,BudgetFilter,AmountType,CashFlowFilter);

          FileName := FileMgt.DownloadTempFile(FileName);

          ExcelHelper.CallOpenText(xlApp,FileName);
          xlWorkSheet := xlApp.ActiveSheet;
          xlSheetName := Format(Text031) + "Analysis View Code";
          xlSheetName := ConvertStr(xlSheetName,' -+','___');
          xlWorkSheet.Name := xlSheetName;

          if AccNoPrefix <> '' then begin
            ExcelBuffer.Validate("Column No.",NoOfColumns);
            xlRange := ExcelHelper.FindRange(xlWorkSheet,'A2:' + ExcelBuffer.xlColID + Format(NoOfRows + 1));
            xlRange.NumberFormat := '@';
            ExcelHelper.ReplaceInRange(xlRange,AccNoPrefix,'''');
          end;

          xlWorkSheet3 := ExcelHelper.AddWorksheet(xlApp.ActiveWorkbook);
          xlWorkSheet3.Name := Format(Text002) + ConvertStr("Analysis View Code",' -+','___');
          ExcelHelper.FindRange(xlWorkSheet3,'A1').Value2 := AnalysisView.TableCaption;
          ExcelHelper.FindRange(xlWorkSheet3,'B2').Value2 := FieldCaption("Analysis View Code");
          ExcelHelper.FindRange(xlWorkSheet3,'C2').Value2 := "Analysis View Code";
          ExcelHelper.FindRange(xlWorkSheet3,'B3').Value2 := Format(Text023);
          AnalysisView.Get("Analysis View Code");
          ExcelHelper.FindRange(xlWorkSheet3,'C3').Value2 := AnalysisView.Name;
          RowNoCount := 3;
          if AnalysisView."Account Filter" <> '' then begin
            RowNoCount := RowNoCount + 1;
            ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := AnalysisView.FieldCaption("Account Filter");
            ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := AnalysisView."Account Filter";
          end;
          RowNoCount := RowNoCount + 1;
          ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := AnalysisView.FieldCaption("Date Compression");
          case AnalysisView."Date Compression" of
            0:
              ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(Text003);
            1:
              ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(Text004);
            2:
              ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(Text005);
            3:
              ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(Text006);
            4:
              ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(Text007);
            5:
              ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(Text008);
            6:
              ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(Text009);
          end;
          if AnalysisView."Starting Date" <> 0D then begin
            RowNoCount := RowNoCount + 1;
            ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := AnalysisView.FieldCaption("Starting Date");
            ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(AnalysisView."Starting Date");
          end;
          RowNoCount := RowNoCount + 1;
          ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := AnalysisView.FieldCaption("Last Date Updated");
          ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(AnalysisView."Last Date Updated");
          AnalysisViewFilter.SetFilter("Analysis View Code","Analysis View Code");
          if AnalysisViewFilter.Find('-') then
            repeat
              RowNoCount := RowNoCount + 1;
              ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := AnalysisViewFilter."Dimension Code";
              ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := AnalysisViewFilter."Dimension Value Filter";
            until AnalysisViewFilter.Next = 0;
          RowNoCount := RowNoCount + 1;
          ExcelHelper.FindRange(xlWorkSheet3,'A' + Format(RowNoCount)).Value2 := Format(Text011);
          RowNoCount := RowNoCount + 1;
          ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := Format(Text012);
          case AmountType of
            0:
              ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(Text013);
            1:
              ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(Text014);
          end;
          if DateFilter <> '' then begin
            RowNoCount := RowNoCount + 1;
            ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := Format(Text015);
            ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := DateFilter;
          end;
          if AccFilter <> '' then begin
            RowNoCount := RowNoCount + 1;
            ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := AnalysisView.FieldCaption("Account Filter");
            ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := AccFilter;
          end;
          if BudgetFilter <> '' then begin
            RowNoCount := RowNoCount + 1;
            ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := Format(Text016);
            ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := BudgetFilter;
          end;
          if CashFlowFilter <> '' then begin
            RowNoCount := RowNoCount + 1;
            ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := Format(Text116);
            ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := CashFlowFilter;
          end;
          if Dim1Filter <> '' then begin
            RowNoCount := RowNoCount + 1;
            ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := AnalysisView."Dimension 1 Code";
            ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Dim1Filter;
          end;
          if Dim2Filter <> '' then begin
            RowNoCount := RowNoCount + 1;
            ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := AnalysisView."Dimension 2 Code";
            ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Dim2Filter;
          end;
          if Dim3Filter <> '' then begin
            RowNoCount := RowNoCount + 1;
            ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := AnalysisView."Dimension 3 Code";
            ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Dim3Filter;
          end;
          if Dim4Filter <> '' then begin
            RowNoCount := RowNoCount + 1;
            ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := AnalysisView."Dimension 4 Code";
            ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Dim4Filter;
          end;
          if GLAccountSource then begin
            RowNoCount := RowNoCount + 1;
            ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := Format(Text024);
            case ClosingEntryFilter of
              0:
                ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(Text025);
              1:
                ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(Text026);
            end;
            RowNoCount := RowNoCount + 1;
            ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := Format(Text027);
            GLSetup.Get;
            if ShowInAddCurr then
              ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := GLSetup."Additional Reporting Currency"
            else
              ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := GLSetup."LCY Code";
          end;

          RowNoCount := RowNoCount + 1;
          ExcelHelper.FindRange(xlWorkSheet3,'B' + Format(RowNoCount)).Value2 := Format(Text028);
          if Sign then
            ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(Text029)
          else
            ExcelHelper.FindRange(xlWorkSheet3,'C' + Format(RowNoCount)).Value2 := Format(Text030);

          ExcelBuffer.Validate("Column No.",10 + NoOfColumns);
          xlPivotCache :=
            xlApp.ActiveWorkbook.PivotCaches.Add(1,StrSubstNo('%1!A1:%2%3',
                xlSheetName,ExcelBuffer.xlColID,NoOfRows + 1));

          ExcelHelper.CreatePivotTable(xlPivotCache,'','PivotTable1');

          xlWorkSheet2 := xlApp.ActiveSheet;
          xlPivotTable := xlWorkSheet2.PivotTables('PivotTable1');
          xlWorkSheet2.Name := Format(Text017) + ConvertStr("Analysis View Code",' -+','___');

          if Line <> '' then
            case Line of
              Text018, Text118:
                xlPivotField := xlPivotTable.PivotFields(GetPivotFieldAccountIndexValue(MaxLevel));
              Text019:
                case PeriodType of
                  0:
                    xlPivotField := xlPivotTable.PivotFields(Format(Text004));
                  1:
                    xlPivotField := xlPivotTable.PivotFields(Format(Text005));
                  2:
                    xlPivotField := xlPivotTable.PivotFields(Format(Text006));
                  3:
                    xlPivotField := xlPivotTable.PivotFields(Format(Text007));
                  4:
                    xlPivotField := xlPivotTable.PivotFields(Format(Text008));
                  5:
                    xlPivotField := xlPivotTable.PivotFields(Format(Text009));
                end;
              BusUnit.TableCaption:
                xlPivotField := xlPivotTable.PivotFields(BusUnit.TableCaption);
              AnalysisView."Dimension 1 Code":
                xlPivotField :=
                  xlPivotTable.PivotFields(AnalysisView."Dimension 1 Code" + ' ' + Format(Text022) + ' ' +
                    Format(MaxLevelDim[1]));
              AnalysisView."Dimension 2 Code":
                xlPivotField :=
                  xlPivotTable.PivotFields(AnalysisView."Dimension 2 Code" + ' ' + Format(Text022) + ' ' +
                    Format(MaxLevelDim[2]));
              AnalysisView."Dimension 3 Code":
                xlPivotField :=
                  xlPivotTable.PivotFields(AnalysisView."Dimension 3 Code" + ' ' + Format(Text022) + ' ' +
                    Format(MaxLevelDim[3]));
              AnalysisView."Dimension 4 Code":
                xlPivotField :=
                  xlPivotTable.PivotFields(AnalysisView."Dimension 4 Code" + ' ' + Format(Text022) + ' ' +
                    Format(MaxLevelDim[4]));
            end;

          xlPivotField.Orientation := PivotFieldOrientation.xlRowField;
          xlPivotField.Position := 1;

          if Column <> '' then
            case Column of
              Text018, Text118:
                xlPivotField := xlPivotTable.PivotFields(GetPivotFieldAccountIndexValue(MaxLevel));
              Text019:
                case PeriodType of
                  0:
                    xlPivotField := xlPivotTable.PivotFields(Format(Text004));
                  1:
                    xlPivotField := xlPivotTable.PivotFields(Format(Text005));
                  2:
                    xlPivotField := xlPivotTable.PivotFields(Format(Text006));
                  3:
                    xlPivotField := xlPivotTable.PivotFields(Format(Text007));
                  4:
                    xlPivotField := xlPivotTable.PivotFields(Format(Text008));
                  5:
                    xlPivotField := xlPivotTable.PivotFields(Format(Text009));
                end;
              BusUnit.TableCaption:
                xlPivotField := xlPivotTable.PivotFields(BusUnit.TableCaption);
              AnalysisView."Dimension 1 Code":
                xlPivotField :=
                  xlPivotTable.PivotFields(AnalysisView."Dimension 1 Code" + ' ' + Format(Text022) + ' ' +
                    Format(MaxLevelDim[1]));
              AnalysisView."Dimension 2 Code":
                xlPivotField :=
                  xlPivotTable.PivotFields(AnalysisView."Dimension 2 Code" + ' ' + Format(Text022) + ' ' +
                    Format(MaxLevelDim[2]));
              AnalysisView."Dimension 3 Code":
                xlPivotField :=
                  xlPivotTable.PivotFields(AnalysisView."Dimension 3 Code" + ' ' + Format(Text022) + ' ' +
                    Format(MaxLevelDim[3]));
              AnalysisView."Dimension 4 Code":
                xlPivotField :=
                  xlPivotTable.PivotFields(AnalysisView."Dimension 4 Code" + ' ' + Format(Text022) + ' ' +
                    Format(MaxLevelDim[4]));
            end;
          xlPivotField.Orientation := PivotFieldOrientation.xlColumnField; // xlColumnField
          xlPivotField.Position := 1;
          if Show = 0 then
            case AmountField of
              0:
                xlPivotField := xlPivotTable.PivotFields(FieldCaption(Amount));
              1:
                xlPivotField := xlPivotTable.PivotFields(FieldCaption("Debit Amount"));
              2:
                xlPivotField := xlPivotTable.PivotFields(FieldCaption("Credit Amount"));
            end
          else
            xlPivotField := xlPivotTable.PivotFields(Format(Text020));

          xlPivotField.Orientation := PivotFieldOrientation.xlDataField;
          xlPivotField.Position := 1;
          xlPivotField.Function := PivotFieldFunction.xlSum;

          if (AmountType = 1) and (Column = Text019) or (AmountType = 1) and (Line = Text019) then begin
            xlPivotField.Calculation := PivotFieldCalculation.xlRunningTotal;
            case PeriodType of
              0:
                xlPivotField.BaseField := Format(Text004);
              1:
                xlPivotField.BaseField := Format(Text005);
              2:
                xlPivotField.BaseField := Format(Text006);
              3:
                xlPivotField.BaseField := Format(Text007);
              4:
                xlPivotField.BaseField := Format(Text008);
              5:
                xlPivotField.BaseField := Format(Text009);
            end;
          end;

          GLSetup.Get;
          if ShowInAddCurr and Currency.Get(GLSetup."Additional Reporting Currency") then
            FormatString := DelChr(Format(ROUND(1000.01,Currency."Amount Rounding Precision"),0),'<',' ')
          else
            FormatString := DelChr(Format(ROUND(1000.01,GLSetup."Amount Rounding Precision"),0),'<',' ');

          FormatString[1] := '#';
          FormatString[3] := '#';
          FormatString[4] := '#';
          if StrLen(FormatString) >= 8 then
            FormatString[8] := '0';
          xlPivotField.NumberFormat := FormatString; // '#.##0,00';

          xlPivotTable.SmallGrid := false;
        end;

        xlApp.Visible := true;
    end;

    local procedure CreateFile(var AnalysisViewEntry: Record "Analysis View Entry";Sign: Boolean;ShowInAddCurr: Boolean;ShowName: Boolean;AccFilter: Text;Dim1Filter: Text;Dim2Filter: Text;Dim3Filter: Text;Dim4Filter: Text;ClosingEntryFilter: Option;DateFilter: Text;BusUnitFilter: Text;BudgetFilter: Text;AmountType: Option;CFFilter: Text): Integer
    var
        AnalysisViewEntry2: Record "Analysis View Entry";
        AnalysisViewEntry3: Record "Analysis View Entry";
        AnalysisView: Record "Analysis View";
        AnalysisViewBudgetEntry: Record "Analysis View Budget Entry";
        AnalysisViewBudgetEntry2: Record "Analysis View Budget Entry";
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        BusUnit: Record "Business Unit";
        TextFile: File;
        Column: Text;
        Line: array [5] of Text;
        Line2: Text;
        Tab: Text[1];
        StartDate: Date;
        EndDate: Date;
        MaxDate: Date;
        CurrExchDate: Date;
        NoOfRows: Integer;
        WeekNo: Integer;
        Year: Integer;
        SignValue: Integer;
        i: Integer;
        AddRepCurrAmount: Decimal;
        NoOfLeadingTabs: Integer;
    begin
        TextFile.CreateTempfile;
        FileName := TextFile.Name + '.txt';
        TextFile.Close;

        TextFile.Create(FileName);
        TextFile.CreateOutstream(TextFileStream);
        TextFileStreamWriter := TextFileStreamWriter.StreamWriter(TextFileStream,TextFileEncoding.Unicode);

        AnalysisViewEntry2.Copy(AnalysisViewEntry);
        AnalysisView.Get(AnalysisViewEntry2."Analysis View Code");
        PopulateTempAccountTable(AccFilter);

        FindDimLevel(AnalysisView."Dimension 1 Code",Dim1Filter,1);
        FindDimLevel(AnalysisView."Dimension 2 Code",Dim2Filter,2);
        FindDimLevel(AnalysisView."Dimension 3 Code",Dim3Filter,3);
        FindDimLevel(AnalysisView."Dimension 4 Code",Dim4Filter,4);

        Tab[1] := 9;
        SignValue := 1;
        if Sign then
          SignValue := -1;

        NoOfRows := 0;
        with AnalysisViewEntry2 do begin
          for i := 0 to MaxLevel do begin
            Line[1] := Line[1] + GetPivotFieldAccountIndexValue(i) + Tab;
            NoOfColumns := NoOfColumns + 1;
          end;
          if HasBusinessUnits then begin
            Line[1] := Line[1] + BusUnit.TableCaption + Tab;
            NoOfColumns := NoOfColumns + 1;
          end;
          if AnalysisView."Dimension 1 Code" <> '' then
            for i := 0 to MaxLevelDim[1] do begin
              Line[1] := Line[1] + AnalysisView."Dimension 1 Code" + ' ' + Format(Text022) + ' ' + Format(i) + Tab;
              NoOfColumns := NoOfColumns + 1;
            end;
          if AnalysisView."Dimension 2 Code" <> '' then
            for i := 0 to MaxLevelDim[2] do begin
              Line[1] := Line[1] + AnalysisView."Dimension 2 Code" + ' ' + Format(Text022) + ' ' + Format(i) + Tab;
              NoOfColumns := NoOfColumns + 1;
            end;
          if AnalysisView."Dimension 3 Code" <> '' then
            for i := 0 to MaxLevelDim[3] do begin
              Line[1] := Line[1] + AnalysisView."Dimension 3 Code" + ' ' + Format(Text022) + ' ' + Format(i) + Tab;
              NoOfColumns := NoOfColumns + 1;
            end;
          if AnalysisView."Dimension 4 Code" <> '' then
            for i := 0 to MaxLevelDim[4] do begin
              Line[1] := Line[1] + AnalysisView."Dimension 4 Code" + ' ' + Format(Text022) + ' ' + Format(i) + Tab;
              NoOfColumns := NoOfColumns + 1;
            end;

          Line[1] := Line[1] + Text004 + Tab + Text005 + Tab + Text006 + Tab + Text007 +
            Tab + Text008 + Tab + Text009 + Tab + FieldCaption(Amount) + Tab +
            FieldCaption("Debit Amount") + Tab + FieldCaption("Credit Amount") + Tab + Text020;

          TextFileStreamWriter.WriteLine(Line[1]);
          StartDate := "Posting Date";
          AnalysisViewEntry3.SetFilter("Posting Date",DateFilter);
          if (DateFilter <> '') and (AmountType = 1) then begin
            MaxDate := AnalysisViewEntry3.GetRangemax("Posting Date");
            SetFilter("Posting Date",'<=%1',MaxDate);
          end;
          if CFFilter <> '' then
            SetFilter("Cash Flow Forecast No.",CFFilter);

          if Find('-') then
            repeat
              if (ClosingEntryFilter = 0) or ("Posting Date" = NormalDate("Posting Date")) then begin
                if "Posting Date" >= EndDate then
                  EndDate := "Posting Date"
                else
                  if "Posting Date" <= StartDate then
                    StartDate := "Posting Date";

                Clear(Line);
                NoOfRows := NoOfRows + 1;
                CheckNoOfRows(NoOfRows,AnalysisView);

                if GLAccountSource then begin
                  if TempGLAcc2.Get("Account No.") then
                    TempGLAcc2.Mark(true);
                  Line[1] := FillOutGLAcc("Account No.",ShowName);
                end else begin
                  if TempCFAccount2.Get("Account No.") then
                    TempCFAccount2.Mark(true);
                  Line[1] := FillOutCFAccount("Account No.",ShowName);
                end;

                if HasBusinessUnits then
                  Line[1] := Line[1] + FillOutBusUnit("Business Unit Code",ShowName);
                if AnalysisView."Dimension 1 Code" <> '' then
                  Line[2] := FillOutDim("Dimension 1 Value Code",AnalysisView."Dimension 1 Code",1,ShowName);

                if AnalysisView."Dimension 2 Code" <> '' then
                  Line[3] := FillOutDim("Dimension 2 Value Code",AnalysisView."Dimension 2 Code",2,ShowName);

                if AnalysisView."Dimension 3 Code" <> '' then
                  Line[4] := FillOutDim("Dimension 3 Value Code",AnalysisView."Dimension 3 Code",3,ShowName);

                if AnalysisView."Dimension 4 Code" <> '' then
                  Line[5] := FillOutDim("Dimension 4 Value Code",AnalysisView."Dimension 4 Code",4,ShowName);

                if not ShowInAddCurr then
                  Line2 :=
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),-1)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),0)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),1)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),2)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),3)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),4)) + Tab +
                    Format(Amount * SignValue,0,'<Standard Format,1>') + Tab +
                    Format("Debit Amount" * SignValue,0,'<Standard Format,1>') + Tab +
                    Format("Credit Amount" * SignValue,0,'<Standard Format,1>')
                else
                  Line2 :=
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),-1)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),0)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),1)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),2)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),3)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),4)) + Tab +
                    Format("Add.-Curr. Amount" * SignValue,0,'<Standard Format,1>') + Tab +
                    Format("Add.-Curr. Debit Amount" * SignValue,0,'<Standard Format,1>') + Tab +
                    Format("Add.-Curr. Credit Amount" * SignValue,0,'<Standard Format,1>');

                TextFileStreamWriter.WriteLine(Line[1] + Line[2] + Line[3] + Line[4] + Line[5] + Line2);
              end;
            until Next = 0;
        end;

        with AnalysisViewBudgetEntry2 do begin
          SetFilter("Analysis View Code",AnalysisView.Code);
          SetFilter("Posting Date",DateFilter);
          if (DateFilter <> '') and (AmountType = 1) then begin
            MaxDate := GetRangemax("Posting Date");
            SetFilter("Posting Date",'<= %1',MaxDate);
          end;
          SetFilter("G/L Account No.",AccFilter);
          SetFilter("Business Unit Code",BusUnitFilter);
          SetFilter("Budget Name",BudgetFilter);
          SetFilter("Dimension 1 Value Code",Dim1Filter);
          SetFilter("Dimension 2 Value Code",Dim2Filter);
          SetFilter("Dimension 3 Value Code",Dim3Filter);
          SetFilter("Dimension 4 Value Code",Dim4Filter);
          if Find('-') then
            repeat
              if (ClosingEntryFilter = 1) or ("Posting Date" = NormalDate("Posting Date")) then begin
                if "Posting Date" >= EndDate then
                  EndDate := "Posting Date";
                if ("Posting Date" <= StartDate) or (StartDate = 0D) then
                  StartDate := "Posting Date";

                Clear(Line);
                NoOfRows := NoOfRows + 1;
                CheckNoOfRows(NoOfRows,AnalysisView);

                if TempGLAcc2.Get("G/L Account No.") then
                  TempGLAcc2.Mark(true);
                Line[1] := FillOutGLAcc("G/L Account No.",ShowName);
                if HasBusinessUnits then
                  Line[1] := Line[1] + FillOutBusUnit("Business Unit Code",ShowName);
                if AnalysisView."Dimension 1 Code" <> '' then
                  Line[2] := FillOutDim("Dimension 1 Value Code",AnalysisView."Dimension 1 Code",1,ShowName);

                if AnalysisView."Dimension 2 Code" <> '' then
                  Line[3] := FillOutDim("Dimension 2 Value Code",AnalysisView."Dimension 2 Code",2,ShowName);

                if AnalysisView."Dimension 3 Code" <> '' then
                  Line[4] := FillOutDim("Dimension 3 Value Code",AnalysisView."Dimension 3 Code",3,ShowName);

                if AnalysisView."Dimension 4 Code" <> '' then
                  Line[5] := FillOutDim("Dimension 4 Value Code",AnalysisView."Dimension 4 Code",4,ShowName);

                if not ShowInAddCurr then begin
                  Line2 :=
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),-1)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),0)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),1)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),2)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),3)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),4)) + Tab +
                    Tab + Tab + Tab + Format(Amount * SignValue);
                end else begin
                  if AnalysisViewBudgetEntry.GetFilter("Posting Date") = '' then
                    CurrExchDate := WorkDate
                  else
                    CurrExchDate := AnalysisViewBudgetEntry.GetRangeMin("Posting Date");
                  GLSetup.Get;
                  if ShowInAddCurr and Currency.Get(GLSetup."Additional Reporting Currency") then
                    AddRepCurrAmount :=
                      ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          CurrExchDate,GLSetup."Additional Reporting Currency",Amount,
                          CurrExchRate.ExchangeRate(
                            CurrExchDate,GLSetup."Additional Reporting Currency")) * SignValue,
                        Currency."Amount Rounding Precision")
                  else
                    AddRepCurrAmount :=
                      ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          CurrExchDate,GLSetup."Additional Reporting Currency",Amount,
                          CurrExchRate.ExchangeRate(
                            CurrExchDate,GLSetup."Additional Reporting Currency")) * SignValue,
                        GLSetup."Amount Rounding Precision");
                  Line2 :=
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),-1)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),0)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),1)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),2)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),3)) + Tab +
                    Format(CalculatePeriodStart(NormalDate("Posting Date"),4)) + Tab +
                    Tab + Tab + Tab + Format(AddRepCurrAmount);
                end;
                TextFileStreamWriter.WriteLine(Line[1] + Line[2] + Line[3] + Line[4] + Line[5] + Line2);
              end;
            until Next = 0;
        end;

        Line2 := '';
        NoOfLeadingTabs := 0;
        if GLAccountSource then begin
          TempGLAcc2.SetRange("Account Type",TempGLAcc2."account type"::Posting);
          if TempGLAcc2.Find('-') then
            repeat
              if not TempGLAcc2.Mark then begin
                NoOfRows := NoOfRows + 1;
                Line2 := FillOutGLAcc(TempGLAcc2."No.",ShowName);
                TextFileStreamWriter.WriteLine(Line2);
              end;
            until TempGLAcc2.Next = 0;
        end else begin
          TempCFAccount2.SetRange("Account Type",TempCFAccount2."account type"::Entry);
          if TempCFAccount2.Find('-') then
            ProcessMarkedTempCFAccountRec(NoOfRows,Line2,ShowName,TextFileStreamWriter);
        end;
        NoOfLeadingTabs := MaxLevel + 1;
        if HasBusinessUnits then begin
          if BusUnit.Find('-') then
            repeat
              if not BusUnit.Mark then begin
                NoOfRows := NoOfRows + 1;
                Line2 := FillOutBusUnit(BusUnit.Code,ShowName);
                TextFileStreamWriter.WriteLine(GetDuplicateChars(NoOfLeadingTabs,Tab) + Line2);
              end;
            until BusUnit.Next = 0;
          NoOfLeadingTabs := NoOfLeadingTabs + 1;
        end;

        if AnalysisView."Dimension 1 Code" <> '' then
          WriteDimLine(Column,Tab,1,Dim1Filter,AnalysisView."Dimension 1 Code",NoOfRows,NoOfLeadingTabs,ShowName);
        NoOfLeadingTabs := NoOfLeadingTabs + MaxLevelDim[1] + 1;

        if AnalysisView."Dimension 2 Code" <> '' then
          WriteDimLine(Column,Tab,2,Dim2Filter,AnalysisView."Dimension 2 Code",NoOfRows,NoOfLeadingTabs,ShowName);
        NoOfLeadingTabs := NoOfLeadingTabs + MaxLevelDim[2] + 1;

        if AnalysisView."Dimension 3 Code" <> '' then
          WriteDimLine(Column,Tab,3,Dim3Filter,AnalysisView."Dimension 3 Code",NoOfRows,NoOfLeadingTabs,ShowName);
        NoOfLeadingTabs := NoOfLeadingTabs + MaxLevelDim[3] + 1;

        if AnalysisView."Dimension 4 Code" <> '' then
          WriteDimLine(Column,Tab,4,Dim4Filter,AnalysisView."Dimension 4 Code",NoOfRows,NoOfLeadingTabs,ShowName);
        NoOfLeadingTabs := NoOfLeadingTabs + MaxLevelDim[4] + 1;

        WeekNo := Date2dwy(StartDate,2);
        Year := Date2dwy(StartDate,3);
        StartDate := Dwy2Date(1,WeekNo,Year);
        Line2 := GetDuplicateChars(NoOfColumns,Tab);

        while StartDate <= EndDate do begin
          NoOfRows := NoOfRows + 1;
          TextFileStreamWriter.WriteLine(
            Line2 + Tab + Format(StartDate) + Tab + Format(CalculatePeriodStart(StartDate,1)) + Tab +
            Format(CalculatePeriodStart(StartDate,2)) + Tab + Format(CalculatePeriodStart(StartDate,3)) + Tab +
            Format(CalculatePeriodStart(StartDate,4)));
          StartDate := CalcDate('<1W>',StartDate);
        end;

        TextFileStreamWriter.Close;
        TextFile.Close;
        exit(NoOfRows);
    end;

    local procedure CalculatePeriodStart(PostingDate: Date;DateCompression: Integer): Date
    var
        AccountingPeriod: Record "Accounting Period";
        PrevPostingDate: Date;
        PrevCalculatedPostingDate: Date;
    begin
        if PostingDate = ClosingDate(PostingDate) then
          exit(PostingDate);
        case DateCompression of
          0:
            // Week :
            PostingDate := CalcDate('<CW+1D-1W>',PostingDate);
          1:
            // Month :
            PostingDate := CalcDate('<CM+1D-1M>',PostingDate);
          2:
            // Quarter :
            PostingDate := CalcDate('<CQ+1D-1Q>',PostingDate);
          3:
            // Year :
            PostingDate := CalcDate('<CY+1D-1Y>',PostingDate);
          4:
            // Period :
            begin
              if PostingDate <> PrevPostingDate then begin
                PrevPostingDate := PostingDate;
                AccountingPeriod.SetRange("Starting Date",0D,PostingDate);
                if AccountingPeriod.FindLast then begin
                  PrevCalculatedPostingDate := AccountingPeriod."Starting Date"
                end else
                  PrevCalculatedPostingDate := PostingDate;
              end;
              PostingDate := PrevCalculatedPostingDate;
            end;
        end;
        exit(PostingDate);
    end;

    local procedure FindGLAccountParent(var Account: Code[20])
    begin
        TempGLAcc3.Get(Account);
        if TempGLAcc3.Indentation <> 0 then begin
          TempGLAcc3.SetRange(Indentation,TempGLAcc3.Indentation - 1);
          TempGLAcc3.Next(-1);
        end;
        Account := TempGLAcc3."No.";
    end;

    local procedure FindCFAccountParent(var Account: Code[20])
    begin
        TempCFAccount3.Get(Account);
        if TempCFAccount3.Indentation <> 0 then begin
          TempCFAccount3.SetRange(Indentation,TempCFAccount3.Indentation - 1);
          TempCFAccount3.Next(-1);
        end;
        Account := TempCFAccount3."No.";
    end;

    local procedure FindDimLevel(DimCode: Code[20];DimFilter: Text;ArrayNo: Integer)
    var
        DimValue: Record "Dimension Value";
    begin
        if DimCode = '' then
          exit;
        DimValue.SetRange("Dimension Code",DimCode);
        if DimValue.Find('-') then
          repeat
            TempDimValue2.Copy(DimValue);
            TempDimValue2.Insert;
            TempDimValue3.Copy(DimValue);
            TempDimValue3.Insert;
          until DimValue.Next = 0;
        TempDimValue2.SetFilter(Code,DimFilter);
        if TempDimValue2.Find('-') then
          repeat
            if MaxLevelDim[ArrayNo] < TempDimValue2.Indentation then
              MaxLevelDim[ArrayNo] := TempDimValue2.Indentation;
          until TempDimValue2.Next = 0;
    end;

    local procedure FindDimParent(var Account: Code[20];DimensionCode: Code[20])
    begin
        TempDimValue3.Reset;
        TempDimValue3.SetRange("Dimension Code",DimensionCode);
        TempDimValue3.Get(DimensionCode,Account);
        if TempDimValue3.Indentation <> 0 then begin
          TempDimValue3.SetRange(Indentation,TempDimValue3.Indentation - 1);
          TempDimValue3.Next(-1);
        end;
        Account := TempDimValue3.Code;
    end;

    local procedure FillOutDim(DimValueCode: Code[20];DimCode: Code[20];DimNo: Integer;ShowName: Boolean) Line: Text
    var
        Indent: Integer;
        i: Integer;
        DimValueCode2: Code[20];
    begin
        if DimValueCode <> '' then begin
          if TempDimValue2.Get(DimCode,DimValueCode) then
            TempDimValue2.Mark(true)
          else
            TempDimValue2.Init;
          DimValueCode2 := DimValueCode;
          Indent := TempDimValue2.Indentation;
          AddAcc(Line,ShowName,true,DimValueCode2,TempDimValue2.Name);
          if Indent <> MaxLevelDim[DimNo] then
            for i := (Indent + 1) to MaxLevelDim[DimNo] do
              AddAcc(Line,ShowName,true,DimValueCode2,TempDimValue2.Name);
          if (Indent <> 0) and (DimValueCode2 <> '') then
            for i := Indent downto 1 do begin
              FindDimParent(DimValueCode2,DimCode);
              TempDimValue2.Get(DimCode,DimValueCode2);
              AddAcc(Line,ShowName,false,DimValueCode2,TempDimValue2.Name);
            end;
        end else
          for i := 0 to MaxLevelDim[DimNo] do
            AddAcc(Line,false,true,'','');
        exit(Line)
    end;

    local procedure FillOutGLAcc(GLAccNo: Code[20];ShowName: Boolean) Line: Text
    var
        i: Integer;
        Indent: Integer;
        Account: Code[20];
    begin
        Account := GLAccNo;
        TempGLAcc3.Get(Account);
        TempGLAcc3.Mark(true);
        AddAcc(Line,ShowName,true,TempGLAcc3."No.",TempGLAcc3.Name);

        Indent := TempGLAcc3.Indentation;
        if Indent <> MaxLevel then
          for i := Indent + 1 to MaxLevel do
            AddAcc(Line,ShowName,true,TempGLAcc3."No.",TempGLAcc3.Name);

        if Indent <> 0 then
          for i := Indent downto 1 do begin
            FindGLAccountParent(Account);
            TempGLAcc3.Get(Account);
            AddAcc(Line,ShowName,false,TempGLAcc3."No.",TempGLAcc3.Name);
          end;
        exit(Line)
    end;

    local procedure FillOutCFAccount(CFAccNo: Code[20];ShowName: Boolean) Line: Text
    var
        i: Integer;
        Indent: Integer;
        Account: Code[20];
    begin
        Account := CFAccNo;
        TempCFAccount3.Get(Account);
        TempCFAccount3.Mark(true);
        AddAcc(Line,ShowName,true,TempCFAccount3."No.",TempCFAccount3.Name);

        Indent := TempCFAccount2.Indentation;
        if Indent <> MaxLevel then
          for i := Indent + 1 to MaxLevel do
            AddAcc(Line,ShowName,true,TempCFAccount3."No.",TempCFAccount3.Name);

        if Indent <> 0 then
          for i := Indent downto 1 do begin
            FindCFAccountParent(Account);
            TempCFAccount3.Get(Account);
            AddAcc(Line,ShowName,false,TempCFAccount3."No.",TempCFAccount3.Name);
          end;
        exit(Line)
    end;

    local procedure FillOutBusUnit(BusUnitCode: Code[10];ShowName: Boolean) Line: Text[1024]
    begin
        if BusUnitCode <> '' then begin
          BusUnit.Get(BusUnitCode);
          BusUnit.Mark(true);
          AddAcc(Line,ShowName,true,BusUnit.Code,BusUnit.Name);
        end else
          AddAcc(Line,false,true,'','');
        exit(Line)
    end;

    local procedure CheckNoOfRows(NoOfRows: Integer;var AnalysisView: Record "Analysis View")
    begin
        if ExcelVersion = '' then
          if not IsNull(xlApp)then
            ExcelVersion := CopyStr(xlApp.Version,1,MaxStrLen(ExcelVersion));

        if (ExcelVersion < '12.0') and (NoOfRows > 65000) then
          Error(Text032,65000,AnalysisView.FieldCaption("Date Compression"),AnalysisView.TableCaption);
    end;

    local procedure GetDuplicateChars(NoOfChars: Integer;c: Text[1]): Text[100]
    var
        t: Text[100];
        i: Integer;
    begin
        for i := 1 to NoOfChars do
          t := t + c;
        exit(t);
    end;

    local procedure AddAcc(var Line: Text;ShowName: Boolean;AppendToLine: Boolean;Account: Code[20];AccName: Text[50])
    var
        Tab: Text[1];
        s: Text[80];
    begin
        Tab[1] := 9;
        if Account = '' then
          s := ''
        else
          if ShowName then
            s := Account + ' ' + AccName
          else
            s := AddAccPrefix(Account);

        if StrLen(Line) + StrLen(s) + 1 > MaxStrLen(Line) then
          Error(Text038);

        if AppendToLine then
          Line := Line + s + Tab
        else
          Line := s + Tab + Line;
    end;

    local procedure AddAccPrefix(Acc: Code[20]): Code[30]
    begin
        if AccNoPrefix = '' then
          AccNoPrefix := '_NAV_'; // Used to ensure that Acc. No. and Dim values are formatted as text.

        if Acc[1] in ['0'..'9'] then
          exit(AccNoPrefix + Acc);
        exit(Acc);
    end;

    local procedure GetPivotFieldAccountIndexValue(Level: Integer): Text[250]
    begin
        if GLAccountSource then
          exit(Format(Text018) + ' ' + Format(Text022) + ' ' + Format(Level));

        exit(Format(Text118) + ' ' + Format(Text022) + ' ' + Format(Level));
    end;

    local procedure CheckCombination(Show: Integer;AmountField: Integer)
    begin
        if not GLAccountSource then
          exit;

        if (Show <> 0) and (Show <> 1) then
          Error(Text000);
        if (Show = 1) and (AmountField <> 0) then
          Error(Text001);
    end;

    local procedure SetOtherFilterToCorrectFilter(DraftFilter: Text;BusUnitFilter: Text;CashFlowFilter: Text)
    begin
        if GLAccountSource then
          BusUnitFilter := DraftFilter
        else
          CashFlowFilter := DraftFilter;
    end;

    local procedure PopulateTempAccountTable(AccFilter: Text)
    var
        GLAcc: Record "G/L Account";
        CFAccount: Record "Cash Flow Account";
    begin
        if GLAccountSource then begin
          if GLAcc.Find('-') then
            repeat
              TempGLAcc3.Copy(GLAcc);
              TempGLAcc3.Insert;
            until GLAcc.Next = 0;

          TempGLAcc3.SetFilter("No.",AccFilter);
          if TempGLAcc3.Find('-') then
            repeat
              TempGLAcc2.Copy(TempGLAcc3);
              TempGLAcc2.Insert;
              if MaxLevel < TempGLAcc2.Indentation then
                MaxLevel := TempGLAcc2.Indentation;
            until TempGLAcc3.Next = 0;
          TempGLAcc3.SetRange("No.");
        end else begin
          if CFAccount.Find('-') then
            repeat
              TempCFAccount3.Copy(CFAccount);
              TempCFAccount3.Insert;
            until CFAccount.Next = 0;

          TempCFAccount3.SetFilter("No.",AccFilter);
          if TempCFAccount3.Find('-') then
            repeat
              TempCFAccount2.Copy(TempCFAccount3);
              TempCFAccount2.Insert;
              if MaxLevel < TempCFAccount2.Indentation then
                MaxLevel := TempCFAccount2.Indentation;
            until TempCFAccount3.Next = 0;
          TempCFAccount3.SetRange("No.");
        end;
    end;

    local procedure ProcessMarkedTempCFAccountRec(var NoOfRows: Integer;var Line2: Text;ShowName: Boolean;var TextFileStreamWriter: dotnet StreamWriter)
    begin
        repeat
          if not TempCFAccount2.Mark then begin
            NoOfRows := NoOfRows + 1;
            Line2 := FillOutCFAccount(TempCFAccount2."No.",ShowName);
            TextFileStreamWriter.WriteLine(Line2);
          end;
        until TempCFAccount2.Next = 0;
    end;

    local procedure WriteDimLine(var Column: Text;Tab: Text[1];DimNo: Integer;DimFilter: Text;DimCode: Code[20];var NoOfRows: Integer;NoOfLeadingTabs: Integer;ShowName: Boolean)
    var
        Line2: Text;
    begin
        Column := Column + Tab;
        TempDimValue2.SetFilter(Code,DimFilter);
        TempDimValue2.SetFilter("Dimension Code",DimCode);
        TempDimValue2.SetRange("Dimension Value Type",TempDimValue2."dimension value type"::Standard);
        if TempDimValue2.Find('-') then
          repeat
            if not TempDimValue2.Mark then begin
              NoOfRows := NoOfRows + 1;
              Line2 := FillOutDim(TempDimValue2.Code,DimCode,DimNo,ShowName);
              TextFileStreamWriter.WriteLine(GetDuplicateChars(NoOfLeadingTabs,Tab) + Line2);
            end;
          until TempDimValue2.Next = 0;
    end;
}

