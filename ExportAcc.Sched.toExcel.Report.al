#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 29 "Export Acc. Sched. to Excel"
{
    Caption = 'Export Acc. Sched. to Excel';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=const(1));
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            var
                Window: Dialog;
                RecNo: Integer;
                TotalRecNo: Integer;
                RowNo: Integer;
                ColumnNo: Integer;
                ClientFileName: Text;
            begin
                if DoUpdateExistingWorksheet then
                  if not UploadClientFile(ClientFileName,ServerFileName) then
                    exit;

                Window.Open(
                  Text000 +
                  '@1@@@@@@@@@@@@@@@@@@@@@\');
                Window.Update(1,0);
                AccSchedLine.SetFilter(Show,'<>%1',AccSchedLine.Show::No);
                TotalRecNo := AccSchedLine.Count;
                RecNo := 0;

                TempExcelBuffer.DeleteAll;
                Clear(TempExcelBuffer);

                AccSchedName.Get(AccSchedLine.GetRangeMin("Schedule Name"));
                AccSchedManagement.CheckAnalysisView(AccSchedName.Name,ColumnLayout.GetRangeMin("Column Layout Name"),true);
                if AccSchedName."Analysis View Name" <> '' then
                  AnalysisView.Get(AccSchedName."Analysis View Name");
                GLSetup.Get;

                RowNo := 1;
                EnterCell(RowNo,1,Text001,false,false,true,false,'',TempExcelBuffer."cell type"::Text);
                EnterFilterInCell(
                  RowNo,AccSchedLine.GetFilter("Date Filter"),AccSchedLine.FieldCaption("Date Filter"),
                  '',TempExcelBuffer."cell type"::Text);
                EnterFilterInCell(
                  RowNo,AccSchedLine.GetFilter("G/L Budget Filter"),AccSchedLine.FieldCaption("G/L Budget Filter"),
                  '',TempExcelBuffer."cell type"::Text);
                EnterFilterInCell(
                  RowNo,AccSchedLine.GetFilter("Cost Budget Filter"),AccSchedLine.FieldCaption("Cost Budget Filter"),
                  '',TempExcelBuffer."cell type"::Text);
                EnterFilterInCell(
                  RowNo,AccSchedLine.GetFilter("Dimension 1 Filter"),GetDimFilterCaption(1),'',TempExcelBuffer."cell type"::Text);
                EnterFilterInCell(
                  RowNo,AccSchedLine.GetFilter("Dimension 2 Filter"),GetDimFilterCaption(2),'',TempExcelBuffer."cell type"::Text);
                EnterFilterInCell(
                  RowNo,AccSchedLine.GetFilter("Dimension 3 Filter"),GetDimFilterCaption(3),'',TempExcelBuffer."cell type"::Text);
                EnterFilterInCell(
                  RowNo,AccSchedLine.GetFilter("Dimension 4 Filter"),GetDimFilterCaption(4),'',TempExcelBuffer."cell type"::Text);

                RowNo := RowNo + 1;
                if UseAmtsInAddCurr then
                  EnterFilterInCell(
                    RowNo,GLSetup."Additional Reporting Currency",Currency.TableCaption,'',TempExcelBuffer."cell type"::Text)
                else
                  EnterFilterInCell(
                    RowNo,GLSetup."LCY Code",Currency.TableCaption,'',TempExcelBuffer."cell type"::Text);

                RowNo := RowNo + 1;
                if AccSchedLine.Find('-') then begin
                  if ColumnLayout.Find('-') then begin
                    RowNo := RowNo + 1;
                    ColumnNo := 2; // Skip the "Row No." column.
                    repeat
                      ColumnNo := ColumnNo + 1;
                      EnterCell(
                        RowNo,ColumnNo,ColumnLayout."Column Header",false,false,false,false,'',TempExcelBuffer."cell type"::Text);
                    until ColumnLayout.Next = 0;
                  end;
                  repeat
                    RecNo := RecNo + 1;
                    Window.Update(1,ROUND(RecNo / TotalRecNo * 10000,1));
                    RowNo := RowNo + 1;
                    ColumnNo := 1;
                    EnterCell(
                      RowNo,ColumnNo,AccSchedLine."Row No.",
                      AccSchedLine.Bold,AccSchedLine.Italic,AccSchedLine.Underline,AccSchedLine."Double Underline",
                      '0',TempExcelBuffer."cell type"::Text);
                    ColumnNo := 2;
                    if IncludeRow(AccSchedLine) then
                      EnterCell(
                        RowNo,ColumnNo,AccSchedLine.Description,
                        AccSchedLine.Bold,AccSchedLine.Italic,AccSchedLine.Underline,AccSchedLine."Double Underline",
                        '',TempExcelBuffer."cell type"::Text);
                    if ColumnLayout.Find('-') then begin
                      repeat
                        if (AccSchedLine.Totaling = '' ) or
                           (AccSchedLine."Totaling Type" in
                             [AccSchedLine."totaling type"::Underline,AccSchedLine."totaling type"::"Double Underline"])
                        then
                          ColumnValue := 0
                        else begin
                          ColumnValue := AccSchedManagement.CalcCell(AccSchedLine,ColumnLayout,UseAmtsInAddCurr);
                          if AccSchedManagement.GetDivisionError then
                            ColumnValue := 0
                        end;
                        ColumnNo := ColumnNo + 1;
                        if IncludeRow(AccSchedLine) then begin
                          EnterCell(
                            RowNo,ColumnNo,MatrixMgt.FormatValue(ColumnValue,ColumnLayout."Rounding Factor",UseAmtsInAddCurr),
                            AccSchedLine.Bold,AccSchedLine.Italic,AccSchedLine.Underline,AccSchedLine."Double Underline",
                            '',TempExcelBuffer."cell type"::Number)
                        end;
                      until ColumnLayout.Next = 0;
                    end;
                  until AccSchedLine.Next = 0;
                end;

                Window.Close;

                if DoUpdateExistingWorksheet then begin
                  TempExcelBuffer.UpdateBook(ServerFileName,SheetName);
                  TempExcelBuffer.WriteSheet('',COMPANYNAME,UserId);
                  TempExcelBuffer.CloseBook;
                  if not TestMode then
                    if FileMgt.IsWebClient then
                      TempExcelBuffer.DownloadAndOpenExcel
                    else
                      TempExcelBuffer.OverwriteAndOpenExistingExcel(ClientFileName);
                end else begin
                  TempExcelBuffer.CreateBook(ServerFileName,AccSchedName.Name);
                  TempExcelBuffer.WriteSheet(AccSchedName.Description,COMPANYNAME,UserId);
                  TempExcelBuffer.CloseBook;
                  if not TestMode then
                    TempExcelBuffer.OpenExcel;
                end;
                if not TestMode then
                  TempExcelBuffer.GiveUserControl;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: label 'Analyzing Data...\\';
        Text001: label 'Filters';
        Text002: label 'Update Workbook';
        AccSchedName: Record "Acc. Schedule Name";
        AccSchedLine: Record "Acc. Schedule Line";
        ColumnLayout: Record "Column Layout";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        GLSetup: Record "General Ledger Setup";
        AnalysisView: Record "Analysis View";
        Currency: Record Currency;
        AccSchedManagement: Codeunit AccSchedManagement;
        MatrixMgt: Codeunit "Matrix Management";
        FileMgt: Codeunit "File Management";
        UseAmtsInAddCurr: Boolean;
        ColumnValue: Decimal;
        ServerFileName: Text;
        SheetName: Text[250];
        DoUpdateExistingWorksheet: Boolean;
        ExcelFileExtensionTok: label '.xlsx', Locked=true;
        TestMode: Boolean;


    procedure SetOptions(var AccSchedLine2: Record "Acc. Schedule Line";ColumnLayoutName2: Code[10];UseAmtsInAddCurr2: Boolean)
    begin
        AccSchedLine.CopyFilters(AccSchedLine2);
        ColumnLayout.SetRange("Column Layout Name",ColumnLayoutName2);
        UseAmtsInAddCurr := UseAmtsInAddCurr2;
    end;

    local procedure EnterFilterInCell(RowNo: Integer;"Filter": Text[250];FieldName: Text[100];Format: Text[30];CellType: Option)
    begin
        RowNo := RowNo + 1;
        if Filter <> '' then begin
          EnterCell(RowNo,1,FieldName,false,false,false,false,'',TempExcelBuffer."cell type"::Text);
          EnterCell(RowNo,2,Filter,false,false,false,false,Format,CellType);
        end;
    end;

    local procedure EnterCell(RowNo: Integer;ColumnNo: Integer;CellValue: Text[250];Bold: Boolean;Italic: Boolean;UnderLine: Boolean;DoubleUnderLine: Boolean;Format: Text[30];CellType: Option)
    begin
        TempExcelBuffer.Init;
        TempExcelBuffer.Validate("Row No.",RowNo);
        TempExcelBuffer.Validate("Column No.",ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := '';
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        if DoubleUnderLine = true then begin
          TempExcelBuffer."Double Underline" := true;
          TempExcelBuffer.Underline := false;
        end else begin
          TempExcelBuffer."Double Underline" := false;
          TempExcelBuffer.Underline := UnderLine;
        end;
        TempExcelBuffer.NumberFormat := Format;
        TempExcelBuffer."Cell Type" := CellType;
        TempExcelBuffer.Insert;
    end;

    local procedure IncludeRow(AccSchedLine: Record "Acc. Schedule Line"): Boolean
    begin
        exit(
          not
            (AccSchedLine."Totaling Type" in
              [AccSchedLine."totaling type"::Underline,
               AccSchedLine."totaling type"::"Double Underline",
               AccSchedLine."totaling type"::"Set Base For Percent"]));
    end;

    local procedure GetDimFilterCaption(DimFilterNo: Integer): Text[80]
    var
        Dimension: Record Dimension;
    begin
        if AccSchedName."Analysis View Name" = '' then
          case DimFilterNo of
            1:
              Dimension.Get(GLSetup."Global Dimension 1 Code");
            2:
              Dimension.Get(GLSetup."Global Dimension 2 Code");
          end
        else
          case DimFilterNo of
            1:
              Dimension.Get(AnalysisView."Dimension 1 Code");
            2:
              Dimension.Get(AnalysisView."Dimension 2 Code");
            3:
              Dimension.Get(AnalysisView."Dimension 3 Code");
            4:
              Dimension.Get(AnalysisView."Dimension 4 Code");
          end;
        exit(CopyStr(Dimension.GetMLFilterCaption(GlobalLanguage),1,80));
    end;


    procedure SetUpdateExistingWorksheet(UpdateExistingWorksheet: Boolean)
    begin
        DoUpdateExistingWorksheet := UpdateExistingWorksheet;
    end;


    procedure SetFileNameSilent(NewFileName: Text)
    begin
        ServerFileName := NewFileName;
    end;


    procedure SetTestMode(NewTestMode: Boolean)
    begin
        TestMode := NewTestMode;
    end;

    local procedure UploadClientFile(var ClientFileName: Text;var ServerFileName: Text): Boolean
    begin
        if FileMgt.IsWebClient then
          ServerFileName := FileMgt.UploadFile(Text002,ExcelFileExtensionTok)
        else begin
          ClientFileName := FileMgt.OpenFileDialog(Text002,ExcelFileExtensionTok,'');
          if ClientFileName = '' then
            exit(false);
          ServerFileName := FileMgt.UploadFileSilent(ClientFileName);
        end;

        if ServerFileName = '' then
          exit(false);

        SheetName := TempExcelBuffer.SelectSheetsName(ServerFileName);
        if SheetName = '' then
          exit(false);

        exit(true);
    end;
}

