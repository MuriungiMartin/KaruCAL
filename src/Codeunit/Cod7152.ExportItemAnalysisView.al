#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7152 "Export Item Analysis View"
{

    trigger OnRun()
    begin
    end;

    var
        Item: Record Item;
        TempDimValue2: Record "Dimension Value" temporary;
        TempDimValue3: Record "Dimension Value" temporary;
        FileMgt: Codeunit "File Management";
        xlApp: Automation ;
        xlWorkSheet: Automation ;
        xlWorkSheet2: Automation ;
        xlPivotTable: Automation ;
        xlPivotCache: Automation ;
        xlRange: Automation ;
        xlPivotField: Automation ;
        xlWorkSheet3: Automation ;
        NoOfColumns: Integer;
        MaxLevelDim: array [3] of Integer;
        CharsNavision: Text[250];
        CharsWindows: Text[250];
        FileName: Text;
        Text000: label 'You can only export Actual amounts and Budgeted amounts.\Please change the option in the Show field.';
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
        Text015: label 'Date Filter';
        Text016: label 'Budget Filter';
        Text017: label 'Pivot Table_';
        Text018: label 'Item';
        Text019: label 'Period';
        Text020: label 'Budg. Sales Amount';
        Text022: label 'Level';
        Text023: label 'Analysis View Name';
        Text028: label 'Show Opposite Sign';
        Text029: label 'Yes';
        Text030: label 'No';
        Text031: label 'Data_';
        Text032: label 'Sales Amount';
        Text033: label 'Cost Amount';
        Text035: label 'Budg Cost Amount';
        Text036: label 'Budg. Quantity';
        Text037: label 'There are more than %1 rows within the filters. Excel only allows up to %1 rows.\You can either narrow the filters or choose a higher %2 value on the %3.';
        Text038: label 'The exported data result exceeds a system limit.\Limit the selection by clearing the Show Column Name field.';
        Text039: label 'Location';
        ExcelVersion: Text[30];
        AccNoPrefix: Code[10];


    procedure ExportData(var ItemAnalysisViewEntry: Record "Item Analysis View Entry";Line: Text[30];Column: Text[30];AmountField: Option;PeriodType: Option;ShowName: Boolean;DateFilter: Code[250];ItemFilter: Code[250];BudgetFilter: Code[250];Dim1Filter: Code[250];Dim2Filter: Code[250];Dim3Filter: Code[250];ShowActualBudg: Option "Actual Amounts","Budgeted Amounts",Variance,"Variance%","Index%";LocationFilter: Code[250];Sign: Boolean)
    var
        ItemAnalysisViewFilter: Record "Item Analysis View Filter";
        GLSetup: Record "General Ledger Setup";
        ExcelBuffer: Record "Excel Buffer" temporary;
        ItemAnalysisView: Record "Item Analysis View";
        FormatString: Text[30];
        NoOfRows: Integer;
        RowNoCount: Integer;
        xlSheetName: Text[100];
    begin
        if (ShowActualBudg <> 0) and (ShowActualBudg <> 1) then
          Error(Text000);
        Create(xlApp,true,true);
        InitCharTables;
        with ItemAnalysisViewEntry do begin
          NoOfRows := CreateFile(
              ItemAnalysisViewEntry,ShowName,ItemFilter,Dim1Filter,Dim2Filter,
              Dim3Filter,DateFilter,LocationFilter,BudgetFilter,Sign);
          FileName := FileMgt.DownloadTempFile(FileName);
          xlApp.Workbooks._OpenText(FileName);
          xlWorkSheet := xlApp.ActiveSheet;
          xlSheetName := Format(Text031) + "Analysis View Code";
          xlSheetName := ConvertStr(xlSheetName,' -+','___');
          xlWorkSheet.Name := xlSheetName;

          if AccNoPrefix <> '' then begin
            ExcelBuffer.Validate("Column No.",NoOfColumns);
            xlRange := xlWorkSheet.Range('A2:' + ExcelBuffer.xlColID + Format(NoOfRows + 1));
            xlRange.NumberFormat('@');
            xlRange._Replace(AccNoPrefix,'''');
          end;

          xlApp.ActiveWorkbook.Sheets.Add;
          xlWorkSheet3 := xlApp.ActiveSheet;
          xlWorkSheet3.Name := Format(Text002) + ConvertStr("Analysis View Code",' -+','___');
          xlWorkSheet3.Range('A1').Value := ItemAnalysisView.TableCaption;
          xlWorkSheet3.Range('B2').Value := FieldCaption("Analysis View Code");
          xlWorkSheet3.Range('C2').Value := "Analysis View Code";
          xlWorkSheet3.Range('B3').Value := Format(Text023);
          ItemAnalysisView.Get("Analysis Area","Analysis View Code");
          xlWorkSheet3.Range('C3').Value := ItemAnalysisView.Name;
          RowNoCount := 3;
          if ItemAnalysisView."Item Filter" <> '' then begin
            RowNoCount := RowNoCount + 1;
            xlWorkSheet3.Range('B' + Format(RowNoCount)).Value := ItemAnalysisView.FieldCaption("Item Filter");
            xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := ItemAnalysisView."Item Filter";
          end;
          RowNoCount := RowNoCount + 1;

          xlWorkSheet3.Range('B' + Format(RowNoCount)).Value := ItemAnalysisView.FieldCaption("Date Compression");

          case ItemAnalysisView."Date Compression" of
            0:
              xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := Format(Text003);
            1:
              xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := Format(Text004);
            2:
              xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := Format(Text005);
            3:
              xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := Format(Text006);
            4:
              xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := Format(Text007);
            5:
              xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := Format(Text008);
            6:
              xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := Format(Text009);
          end;
          if ItemAnalysisView."Starting Date" <> 0D then begin
            RowNoCount := RowNoCount + 1;
            xlWorkSheet3.Range('B' + Format(RowNoCount)).Value := ItemAnalysisView.FieldCaption("Starting Date");
            xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := Format(ItemAnalysisView."Starting Date");
          end;
          RowNoCount := RowNoCount + 1;
          xlWorkSheet3.Range('B' + Format(RowNoCount)).Value := ItemAnalysisView.FieldCaption("Last Date Updated");
          xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := ItemAnalysisView."Last Date Updated";
          ItemAnalysisViewFilter.SetRange("Analysis Area","Analysis Area");
          ItemAnalysisViewFilter.SetFilter("Analysis View Code","Analysis View Code");
          if ItemAnalysisViewFilter.Find('-') then
            repeat
              RowNoCount := RowNoCount + 1;
              xlWorkSheet3.Range('B' + Format(RowNoCount)).Value := ItemAnalysisViewFilter."Dimension Code";
              xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := ItemAnalysisViewFilter."Dimension Value Filter";
            until ItemAnalysisViewFilter.Next = 0;
          RowNoCount := RowNoCount + 1;
          xlWorkSheet3.Range('A' + Format(RowNoCount)).Value := Format(Text011);
          RowNoCount := RowNoCount + 1;
          xlWorkSheet3.Range('B' + Format(RowNoCount)).Value := Format(Text012);

          if DateFilter <> '' then begin
            RowNoCount := RowNoCount + 1;
            xlWorkSheet3.Range('B' + Format(RowNoCount)).Value := Format(Text015);
            xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := DateFilter;
          end;
          if ItemFilter <> '' then begin
            RowNoCount := RowNoCount + 1;
            xlWorkSheet3.Range('B' + Format(RowNoCount)).Value := ItemAnalysisView.FieldCaption("Item Filter");
            xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := ItemFilter;
          end;
          if LocationFilter <> '' then begin
            RowNoCount := RowNoCount + 1;
            xlWorkSheet3.Range('B' + Format(RowNoCount)).Value := Format(Text039);
            xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := LocationFilter;
          end;

          if BudgetFilter <> '' then begin
            RowNoCount := RowNoCount + 1;
            xlWorkSheet3.Range('B' + Format(RowNoCount)).Value := Format(Text016);
            xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := BudgetFilter;
          end;
          if Dim1Filter <> '' then begin
            RowNoCount := RowNoCount + 1;
            xlWorkSheet3.Range('B' + Format(RowNoCount)).Value := ItemAnalysisView."Dimension 1 Code";
            xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := Dim1Filter;
          end;
          if Dim2Filter <> '' then begin
            RowNoCount := RowNoCount + 1;
            xlWorkSheet3.Range('B' + Format(RowNoCount)).Value := ItemAnalysisView."Dimension 2 Code";
            xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := Dim2Filter;
          end;
          if Dim3Filter <> '' then begin
            RowNoCount := RowNoCount + 1;
            xlWorkSheet3.Range('B' + Format(RowNoCount)).Value := ItemAnalysisView."Dimension 3 Code";
            xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := Dim3Filter;
          end;
          RowNoCount := RowNoCount + 1;
          xlWorkSheet3.Range('B' + Format(RowNoCount)).Value := Format(Text028);
          if Sign then
            xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := Format(Text029)
          else
            xlWorkSheet3.Range('C' + Format(RowNoCount)).Value := Format(Text030);

          ExcelBuffer.Validate("Column No.",13 + NoOfColumns);
          xlPivotCache :=
            xlApp.ActiveWorkbook.PivotCaches.Add(1,StrSubstNo('%1!A1:%2%3',
                xlSheetName,ExcelBuffer.xlColID,NoOfRows + 1));
          xlPivotCache.CreatePivotTable('','PivotTable1');

          xlWorkSheet2 := xlApp.ActiveSheet;
          xlPivotTable := xlWorkSheet2.PivotTables('PivotTable1');
          xlWorkSheet2.Name := Format(Text017) + ConvertStr("Analysis View Code",' -+','___');

          if Line <> '' then
            case Line of
              Text018:
                xlPivotField := xlPivotTable.PivotFields(Format(Text018) + ' ' + Format(Text022) + ' ' + Format(0));
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
              Text039:
                xlPivotField := xlPivotTable.PivotFields(Format(Text039));
              ItemAnalysisView."Dimension 1 Code":
                xlPivotField :=
                  xlPivotTable.PivotFields(ItemAnalysisView."Dimension 1 Code" + ' ' + Format(Text022) + ' ' +
                    Format(MaxLevelDim[1]));
              ItemAnalysisView."Dimension 2 Code":
                xlPivotField :=
                  xlPivotTable.PivotFields(ItemAnalysisView."Dimension 2 Code" + ' ' + Format(Text022) + ' ' +
                    Format(MaxLevelDim[2]));
              ItemAnalysisView."Dimension 3 Code":
                xlPivotField :=
                  xlPivotTable.PivotFields(ItemAnalysisView."Dimension 3 Code" + ' ' + Format(Text022) + ' ' +
                    Format(MaxLevelDim[3]));
            end;

          xlPivotField.Orientation := 1; // xlRowField
          xlPivotField.Position := 1;

          if Column <> '' then
            case Column of
              Text018:
                xlPivotField := xlPivotTable.PivotFields(Format(Text018) + ' ' + Format(Text022) + ' ' + Format(0));
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
              Text039:
                xlPivotField := xlPivotTable.PivotFields(Format(Text039));
              ItemAnalysisView."Dimension 1 Code":
                xlPivotField :=
                  xlPivotTable.PivotFields(ItemAnalysisView."Dimension 1 Code" + ' ' + Format(Text022) + ' ' +
                    Format(MaxLevelDim[1]));
              ItemAnalysisView."Dimension 2 Code":
                xlPivotField :=
                  xlPivotTable.PivotFields(ItemAnalysisView."Dimension 2 Code" + ' ' + Format(Text022) + ' ' +
                    Format(MaxLevelDim[2]));
              ItemAnalysisView."Dimension 3 Code":
                xlPivotField :=
                  xlPivotTable.PivotFields(ItemAnalysisView."Dimension 3 Code" + ' ' + Format(Text022) + ' ' +
                    Format(MaxLevelDim[3]));
            end;
          xlPivotField.Orientation := 2; // xlColumnField
          xlPivotField.Position := 1;

          if ShowActualBudg = 0 then
            case AmountField of
              0:
                xlPivotField := xlPivotTable.PivotFields(Format(Text032));
              1:
                xlPivotField := xlPivotTable.PivotFields(Format(Text033));
              2:
                xlPivotField := xlPivotTable.PivotFields(FieldCaption(Quantity));
            end
          else
            xlPivotField := xlPivotTable.PivotFields(Format(Text020));

          xlPivotField.Orientation := 4; // xlDataField
          xlPivotField.Position := 1;
          xlPivotField."Function" := 0;// sum

          GLSetup.Get;
          FormatString := DelChr(Format(ROUND(1000.01,GLSetup."Amount Rounding Precision"),0),'<',' ');
          FormatString[1] := '#';
          FormatString[3] := '#';
          FormatString[4] := '#';
          if StrLen(FormatString) >= 8 then
            FormatString[8] := '0';
          xlPivotField.NumberFormat := FormatString; // '#.##0,00';

          xlPivotTable.SmallGrid := false;
        end;
        xlApp.Visible := true
    end;

    local procedure CreateFile(var ItemAnalysisViewEntry: Record "Item Analysis View Entry";ShowName: Boolean;ItemFilter: Code[250];Dim1Filter: Code[250];Dim2Filter: Code[250];Dim3Filter: Code[250];DateFilter: Code[250];LocationFilter: Text[250];BudgetFilter: Code[250];Sign: Boolean): Integer
    var
        ItemAnalysisViewEntry2: Record "Item Analysis View Entry";
        ItemAnalysisView: Record "Item Analysis View";
        ItemAnalysisViewBudgetEntry2: Record "Item Analysis View Budg. Entry";
        TextFile: File;
        Column: Text[100];
        Line: array [5] of Text[1024];
        Line2: Text[1024];
        Tab: Text[1];
        StartDate: Date;
        EndDate: Date;
        NoOfRows: Integer;
        WeekNo: Integer;
        Year: Integer;
        SignValue: Integer;
        i: Integer;
        j: Integer;
    begin
        TextFile.CreateTempfile;
        FileName := TextFile.Name + '.txt';
        TextFile.Close;

        TextFile.TextMode(true);
        TextFile.Create(FileName);
        ItemAnalysisViewEntry2.Copy(ItemAnalysisViewEntry);
        ItemAnalysisView.Get(ItemAnalysisViewEntry."Analysis Area",ItemAnalysisViewEntry."Analysis View Code");
        ItemAnalysisViewEntry2.SetRange("Analysis Area",ItemAnalysisView."Analysis Area");
        ItemAnalysisViewEntry2.SetRange("Analysis View Code",ItemAnalysisView.Code);
        FindDimLevel(ItemAnalysisView."Dimension 1 Code",Dim1Filter,1);
        FindDimLevel(ItemAnalysisView."Dimension 2 Code",Dim2Filter,2);
        FindDimLevel(ItemAnalysisView."Dimension 3 Code",Dim3Filter,3);

        Tab[1] := 9;
        SignValue := 1;
        if Sign then
          SignValue := -1;

        NoOfRows := 0;

        with ItemAnalysisViewEntry2 do begin
          Line[1] := Line[1] + Format(Text018) + ' ' + Format(Text022) + ' ' + Format(0) + Tab;
          NoOfColumns := NoOfColumns + 1;
          if ItemAnalysisView."Dimension 1 Code" <> '' then
            for i := 0 to MaxLevelDim[1] do begin
              Line[1] := Line[1] + ItemAnalysisView."Dimension 1 Code" + ' ' + Format(Text022) + ' ' + Format(i) + Tab;
              NoOfColumns := NoOfColumns + 1;
            end;
          if ItemAnalysisView."Dimension 2 Code" <> '' then
            for i := 0 to MaxLevelDim[2] do begin
              Line[1] := Line[1] + ItemAnalysisView."Dimension 2 Code" + ' ' + Format(Text022) + ' ' + Format(i) + Tab;
              NoOfColumns := NoOfColumns + 1;
            end;
          if ItemAnalysisView."Dimension 3 Code" <> '' then
            for i := 0 to MaxLevelDim[3] do begin
              Line[1] := Line[1] + ItemAnalysisView."Dimension 3 Code" + ' ' + Format(Text022) + ' ' + Format(i) + Tab;
              NoOfColumns := NoOfColumns + 1;
            end;

          Line[1] := Line[1] + Text004 + Tab + Text005 + Tab + Text006 + Tab + Text007 +
            Tab + Text008 + Tab + Text009 + Tab + Text032 + Tab +
            Text033 + Tab + FieldCaption(Quantity) + Tab + Text039 + Tab +
            Text020 + Tab + Text035 + Tab + Text036 + Tab;

          Line[1] := ConvertStr(Line[1],CharsNavision,CharsWindows);
          TextFile.Write(Line[1]);
          StartDate := "Posting Date";

          if Find('-') then
            repeat
              if "Item No." <> Item."No." then
                if Item.Get("Item No.") then
                  Item.Mark(true);
              if "Posting Date" = NormalDate("Posting Date") then begin
                if "Posting Date" >= EndDate then
                  EndDate := "Posting Date"
                else
                  if "Posting Date" <= StartDate then
                    StartDate := "Posting Date";
                Line[1] := '';
                Line[2] := '';
                Line[3] := '';
                Line[4] := '';
                Line[5] := '';
                NoOfRows := NoOfRows + 1;
                CheckNoOfRows(NoOfRows,ItemAnalysisView);
                Line[1] := ConvertStr(FillOutItem("Item No.",ShowName),CharsNavision,CharsWindows);
                if ItemAnalysisView."Dimension 1 Code" <> '' then
                  Line[2] :=
                    ConvertStr(
                      FillOutDim("Dimension 1 Value Code",ItemAnalysisView."Dimension 1 Code",1,ShowName),
                      CharsNavision,CharsWindows);

                if ItemAnalysisView."Dimension 2 Code" <> '' then
                  Line[3] :=
                    ConvertStr(
                      FillOutDim("Dimension 2 Value Code",ItemAnalysisView."Dimension 2 Code",2,ShowName),
                      CharsNavision,CharsWindows);

                if ItemAnalysisView."Dimension 3 Code" <> '' then
                  Line[4] :=
                    ConvertStr(
                      FillOutDim("Dimension 3 Value Code",ItemAnalysisView."Dimension 3 Code",3,ShowName),
                      CharsNavision,CharsWindows);

                Line2 :=
                  Format(CalculatePeriodStart(NormalDate("Posting Date"),-1)) + Tab +
                  Format(CalculatePeriodStart(NormalDate("Posting Date"),0)) + Tab +
                  Format(CalculatePeriodStart(NormalDate("Posting Date"),1)) + Tab +
                  Format(CalculatePeriodStart(NormalDate("Posting Date"),2)) + Tab +
                  Format(CalculatePeriodStart(NormalDate("Posting Date"),3)) + Tab +
                  Format(CalculatePeriodStart(NormalDate("Posting Date"),4)) + Tab +
                  Format(("Sales Amount (Actual)" + "Sales Amount (Expected)") * SignValue) + Tab +
                  Format(("Cost Amount (Actual)" + "Cost Amount (Expected)" + "Cost Amount (Non-Invtbl.)") * SignValue) + Tab +
                  Format(Quantity * SignValue) + Tab + Format("Location Code") + Tab;
                Line2 := ConvertStr(Line2,CharsNavision,CharsWindows);

                TextFile.Write(Line[1] + Line[2] + Line[3] + Line[4] + Line2);
              end;
            until Next = 0;
        end;

        Line2 := '';
        with ItemAnalysisViewBudgetEntry2 do begin
          SetRange("Analysis Area",ItemAnalysisView."Analysis Area");
          SetRange("Analysis View Code",ItemAnalysisView.Code);
          SetFilter("Posting Date",DateFilter);
          SetFilter("Item No.",ItemFilter);
          SetFilter("Location Code",LocationFilter);
          SetFilter("Budget Name",BudgetFilter);
          SetFilter("Dimension 1 Value Code",Dim1Filter);
          SetFilter("Dimension 2 Value Code",Dim2Filter);
          SetFilter("Dimension 3 Value Code",Dim3Filter);
          if Find('-') then
            repeat
              if "Item No." <> Item."No." then
                if Item.Get("Item No.") then
                  Item.Mark(true);
              if "Posting Date" = NormalDate("Posting Date") then begin
                if "Posting Date" >= EndDate then
                  EndDate := "Posting Date"
                else
                  if "Posting Date" <= StartDate then
                    StartDate := "Posting Date";
                Line[1] := '';
                Line[2] := '';
                Line[3] := '';
                Line[4] := '';
                Line[5] := '';
                NoOfRows := NoOfRows + 1;
                CheckNoOfRows(NoOfRows,ItemAnalysisView);
                Line[1] := ConvertStr(FillOutItem("Item No.",ShowName),
                    CharsNavision,CharsWindows);

                if ItemAnalysisView."Dimension 1 Code" <> '' then
                  Line[2] :=
                    ConvertStr(
                      FillOutDim("Dimension 1 Value Code",ItemAnalysisView."Dimension 1 Code",1,ShowName),
                      CharsNavision,CharsWindows);

                if ItemAnalysisView."Dimension 2 Code" <> '' then
                  Line[3] :=
                    ConvertStr(
                      FillOutDim("Dimension 2 Value Code",ItemAnalysisView."Dimension 2 Code",2,ShowName),
                      CharsNavision,CharsWindows);

                if ItemAnalysisView."Dimension 3 Code" <> '' then
                  Line[4] :=
                    ConvertStr(
                      FillOutDim("Dimension 3 Value Code",ItemAnalysisView."Dimension 3 Code",3,ShowName),
                      CharsNavision,CharsWindows);

                Line2 :=
                  Format(CalculatePeriodStart(NormalDate("Posting Date"),-1)) + Tab +
                  Format(CalculatePeriodStart(NormalDate("Posting Date"),0)) + Tab +
                  Format(CalculatePeriodStart(NormalDate("Posting Date"),1)) + Tab +
                  Format(CalculatePeriodStart(NormalDate("Posting Date"),2)) + Tab +
                  Format(CalculatePeriodStart(NormalDate("Posting Date"),3)) + Tab +
                  Format(CalculatePeriodStart(NormalDate("Posting Date"),4)) + Tab +
                  Tab + Tab + Tab + Format("Location Code") + Tab + Format("Sales Amount" * SignValue) + Tab +
                  Format("Cost Amount" * SignValue) + Tab + Format(Quantity * SignValue) + Tab ;
                Line2 := ConvertStr(Line2,CharsNavision,CharsWindows);

                TextFile.Write(Line[1] + Line[2] + Line[3] + Line[4] + Line[5] + Line2);
              end;
            until Next = 0;
        end;

        Line2 := '';
        if ItemFilter <> '' then
          Item.SetFilter("No.",ItemFilter);
        if Item.Find('-') then
          repeat
            if not Item.Mark then begin
              NoOfRows := NoOfRows + 1;
              CheckNoOfRows(NoOfRows,ItemAnalysisView);
              Line2 :=
                ConvertStr(
                  FillOutItem(Item."No.",ShowName),
                  CharsNavision,CharsWindows);
              TextFile.Write(Line2);
            end;
          until Item.Next = 0;

        if ItemAnalysisView."Dimension 1 Code" <> '' then begin
          Column := Column + Tab;
          TempDimValue2.SetFilter(Code,Dim1Filter);
          TempDimValue2.SetFilter("Dimension Code",ItemAnalysisView."Dimension 1 Code");
          Line[1] := '';
          Line2 := '';
          TempDimValue2.SetRange("Dimension Value Type",TempDimValue2."dimension value type"::Standard);
          if TempDimValue2.Find('-') then
            repeat
              if not TempDimValue2.Mark then begin
                NoOfRows := NoOfRows + 1;
                CheckNoOfRows(NoOfRows,ItemAnalysisView);
                Line2 :=
                  ConvertStr(
                    FillOutDim(TempDimValue2.Code,ItemAnalysisView."Dimension 1 Code",1,ShowName),
                    CharsNavision,CharsWindows);
                TextFile.Write(Tab + Line[1] + Line2);
              end;
            until TempDimValue2.Next = 0;
        end;

        if ItemAnalysisView."Dimension 2 Code" <> '' then begin
          Column := Column + Tab;
          TempDimValue2.SetFilter(Code,Dim2Filter);
          TempDimValue2.SetFilter("Dimension Code",ItemAnalysisView."Dimension 2 Code");
          Line[1] := '';
          for j := 1 to MaxLevelDim[1] do
            Line[1] := Line[1] + Tab;
          Line2 := '';
          TempDimValue2.SetRange("Dimension Value Type",TempDimValue2."dimension value type"::Standard);
          if TempDimValue2.Find('-') then
            repeat
              if not TempDimValue2.Mark then begin
                NoOfRows := NoOfRows + 1;
                CheckNoOfRows(NoOfRows,ItemAnalysisView);
                Line2 :=
                  ConvertStr(
                    FillOutDim(TempDimValue2.Code,ItemAnalysisView."Dimension 2 Code",2,ShowName),
                    CharsNavision,CharsWindows);
                TextFile.Write(Tab + Tab + Line[1] + Line2);
              end;
            until TempDimValue2.Next = 0;
        end;

        if ItemAnalysisView."Dimension 3 Code" <> '' then begin
          Column := Column + Tab;
          TempDimValue2.SetFilter(Code,Dim3Filter);
          TempDimValue2.SetFilter("Dimension Code",ItemAnalysisView."Dimension 3 Code");
          Line[1] := '';
          for j := 1 to MaxLevelDim[1] + MaxLevelDim[2] do
            Line[1] := Line[1] + Tab;
          Line2 := '';
          TempDimValue2.SetRange("Dimension Value Type",TempDimValue2."dimension value type"::Standard);
          if TempDimValue2.Find('-') then
            repeat
              if not TempDimValue2.Mark then begin
                NoOfRows := NoOfRows + 1;
                CheckNoOfRows(NoOfRows,ItemAnalysisView);
                Line2 :=
                  ConvertStr(
                    FillOutDim(TempDimValue2.Code,ItemAnalysisView."Dimension 3 Code",3,ShowName),
                    CharsNavision,CharsWindows);
                TextFile.Write(Tab + Tab + Tab + Line[1] + Line2);
              end;
            until TempDimValue2.Next = 0;
        end;

        WeekNo := Date2dwy(StartDate,2);
        Year := Date2dwy(StartDate,3);
        StartDate := Dwy2Date(1,WeekNo,Year);
        Line2 := '';
        for i := 1 to NoOfColumns do
          Line2 := Line2 + Tab;

        while StartDate <= EndDate do begin
          NoOfRows := NoOfRows + 1;
          CheckNoOfRows(NoOfRows,ItemAnalysisView);
          TextFile.Write(
            Line2 + Tab + Format(StartDate) + Tab + Format(CalculatePeriodStart(StartDate,1)) + Tab +
            Format(CalculatePeriodStart(StartDate,2)) + Tab + Format(CalculatePeriodStart(StartDate,3)) + Tab +
            Format(CalculatePeriodStart(StartDate,4)));
          StartDate := CalcDate('<1W>',StartDate);
        end;

        TextFile.Close;
        exit(NoOfRows);
    end;

    local procedure CalculatePeriodStart(PostingDate: Date;DateCompression: Integer): Date
    var
        AccountingPeriod: Record "Accounting Period";
        PrevPostingDate: Date;
        PrevCalculatedPostingDate: Date;
    begin
        case DateCompression of
          0:// Week :
            PostingDate := CalcDate('<CW+1D-1W>',PostingDate);
          1:// Month :
            PostingDate := CalcDate('<CM+1D-1M>',PostingDate);
          2:// Quarter :
            PostingDate := CalcDate('<CQ+1D-1Q>',PostingDate);
          3:// Year :
            PostingDate := CalcDate('<CY+1D-1Y>',PostingDate);
          4:// Period :
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


    procedure InitCharTables()
    var
        CharFile: File;
        i: Integer;
        c: Char;
        TempFileName: Text;
    begin
        for i := 65 to 255 do begin
          c := i;
          CharsWindows[i - 64] := c;
        end;
        CharFile.CreateTempfile;
        TempFileName := CharFile.Name + '.txt';
        CharFile.Close;
        CharFile.Create(TempFileName);
        CharFile.TextMode := true;
        CharFile.Write(CharsWindows);
        CharFile.Close;
        TempFileName := FileMgt.DownloadTempFile(TempFileName);
        xlApp.Workbooks.OpenText(TempFileName);
        xlWorkSheet := xlApp.ActiveSheet;
        CharsNavision := xlWorkSheet.Range('A1').Value;
        xlApp.ActiveWorkbook.Close(false);
        if StrLen(CharsWindows) <> StrLen(CharsNavision) then
          if (StrLen(CharsWindows) = StrLen(CharsNavision) - 2) and
             (CharsNavision[1] = '"') and (CharsNavision[StrLen(CharsNavision)] = '"')
          then
            CharsNavision := CopyStr(CharsNavision,2,StrLen(CharsNavision) - 2)
          else
            CharsNavision := CharsWindows; // Not possible to translate.
    end;

    local procedure FindDimLevel(DimCode: Code[20];DimFilter: Code[250];ArrayNo: Integer)
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

    local procedure FillOutDim(DimValueCode: Code[20];DimCode: Code[20];DimNo: Integer;ShowName: Boolean) Line: Text[1024]
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
          if Indent <> 0 then
            for i := Indent downto 1 do begin
              FindDimParent(DimValueCode2,DimCode);
              TempDimValue2.Get(DimCode,DimValueCode2);
              TempDimValue2.Mark(true);
              AddAcc(Line,ShowName,false,DimValueCode2,TempDimValue2.Name);
            end;
        end else
          for i := 0 to MaxLevelDim[DimNo] do
            AddAcc(Line,false,true,'','');
        exit(Line)
    end;

    local procedure FillOutItem(ItemNo: Code[20];ShowName: Boolean) Line: Text[1024]
    begin
        AddAcc(Line,ShowName and (ItemNo <> ''),true,ItemNo,Item.Description);
    end;


    procedure SetCommonFilters(CurrentAnalysisArea: Option;CurrentAnalysisViewCode: Code[10];var ItemAnalysisViewEntry: Record "Item Analysis View Entry";DateFilter: Text[30];ItemFilter: Code[250];Dim1Filter: Code[250];Dim2Filter: Code[250];Dim3Filter: Code[250];LocationFilter: Code[250])
    begin
        ItemAnalysisViewEntry.SetRange("Analysis Area",CurrentAnalysisArea);
        ItemAnalysisViewEntry.SetRange("Analysis View Code",CurrentAnalysisViewCode);
        if DateFilter <> '' then
          ItemAnalysisViewEntry.SetFilter("Posting Date",DateFilter);
        if ItemFilter <> '' then
          ItemAnalysisViewEntry.SetFilter("Item No.",ItemFilter);
        if Dim1Filter <> '' then
          ItemAnalysisViewEntry.SetFilter("Dimension 1 Value Code",Dim1Filter);
        if Dim2Filter <> '' then
          ItemAnalysisViewEntry.SetFilter("Dimension 2 Value Code",Dim2Filter);
        if Dim3Filter <> '' then
          ItemAnalysisViewEntry.SetFilter("Dimension 3 Value Code",Dim3Filter);
        if LocationFilter <> '' then
          ItemAnalysisViewEntry.SetFilter("Location Code",LocationFilter);
    end;

    local procedure CheckNoOfRows(NoOfRows: Integer;ItemAnalysisView: Record "Item Analysis View")
    begin
        if ExcelVersion = '' then
          if not ISCLEAR(xlApp) then
            ExcelVersion := CopyStr(xlApp.Version,1,MaxStrLen(ExcelVersion));

        if (ExcelVersion < '12.0') and (NoOfRows > 65000) then
          Error(Text037,65000,ItemAnalysisView.FieldCaption("Date Compression"),ItemAnalysisView.TableCaption);
    end;

    local procedure AddAcc(var Line: Text[1024];ShowName: Boolean;AppendToLine: Boolean;Account: Code[20];AccName: Text[50])
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
}

