#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7132 "Export Item Budget to Excel"
{
    Caption = 'Export Item Budget to Excel';
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
            begin
                if DoUpdateExistingWorksheet then begin
                  if ServerFileName = '' then
                    ServerFileName := FileMgt.UploadFile(Text002,ExcelFileExtensionTok);
                  if ServerFileName = '' then
                    exit;
                  SheetName := TempExcelBuffer.SelectSheetsName(ServerFileName);
                  if SheetName = '' then
                    exit;
                end;

                Window.Open(
                  Text000 +
                  '@1@@@@@@@@@@@@@@@@@@@@@\');

                TempExcelBuffer.DeleteAll;
                Clear(TempExcelBuffer);

                ItemBudgetName.Get(AnalysisArea,BudgetName);
                GLSetup.Get;

                if DateFilter = '' then
                  Error(StrSubstNo(Text010,Text003));

                if FindLine('-') then
                  repeat
                    TotalRecNo := TotalRecNo + 1;
                  until NextLine(1) = 0;

                RowNo := 1;
                EnterCell(RowNo,1,Text001,false,false,true,'',TempExcelBuffer."cell type"::Text);
                EnterCell(RowNo,2,'',false,false,true,'',TempExcelBuffer."cell type"::Text);

                RowNo := RowNo + 1;
                EnterFilterInCell(RowNo,BudgetName,ItemBudgetName.TableCaption);

                if GlobalDim1Filter <> '' then begin
                  RowNo := RowNo + 1;
                  Dim.Get(GLSetup."Global Dimension 1 Code");
                  EnterFilterInCell(RowNo,GlobalDim1Filter,Dim."Filter Caption");
                end;

                if GlobalDim2Filter <> '' then begin
                  RowNo := RowNo + 1;
                  Dim.Get(GLSetup."Global Dimension 2 Code");
                  EnterFilterInCell(RowNo,GlobalDim2Filter,Dim."Filter Caption");
                end;

                if BudgetDim1Filter <> '' then begin
                  RowNo := RowNo + 1;
                  Dim.Get(ItemBudgetName."Budget Dimension 1 Code");
                  EnterFilterInCell(RowNo,BudgetDim1Filter,Dim."Filter Caption");
                end;

                if BudgetDim2Filter <> '' then begin
                  RowNo := RowNo + 1;
                  Dim.Get(ItemBudgetName."Budget Dimension 2 Code");
                  EnterFilterInCell(RowNo,BudgetDim2Filter,Dim."Filter Caption");
                end;

                if BudgetDim3Filter <> '' then begin
                  RowNo := RowNo + 1;
                  Dim.Get(ItemBudgetName."Budget Dimension 3 Code");
                  EnterFilterInCell(RowNo,BudgetDim3Filter,Dim."Filter Caption");
                end;

                if ItemFilter <> '' then begin
                  RowNo := RowNo + 1;
                  EnterFilterInCell(RowNo,ItemFilter,Text004);
                end;

                if DateFilter <> '' then begin
                  RowNo := RowNo + 1;
                  EnterFilterInCell(RowNo,DateFilter,Text003);
                end;

                if SourceNoFilter <> '' then begin
                  RowNo := RowNo + 1;
                  if SourceTypeFilter = Sourcetypefilter::Customer then
                    EnterFilterInCell(RowNo,SourceNoFilter,Text005)
                  else
                    EnterFilterInCell(RowNo,SourceNoFilter,Text006);
                end;

                RowNo := RowNo + 2;
                EnterFilterInCell(RowNo,LineDimCode,Text008);

                RowNo := RowNo + 1;
                EnterFilterInCell(RowNo,ColumnDimCode,Text009);

                RowNo := RowNo + 1;
                case ValueType of
                  Valuetype::"Sales Amount":
                    ShowValueAsText := Text012;
                  Valuetype::"Cost Amount":
                    if AnalysisArea = Analysisarea::Sales then
                      ShowValueAsText := Text014
                    else
                      ShowValueAsText := Text013;
                  Valuetype::Quantity:
                    ShowValueAsText := Text015;
                end;
                EnterFilterInCell(RowNo,ShowValueAsText,Text011);

                RowNo := RowNo + 2;
                if FindLine('-') then begin
                  if FindColumn('-') then begin
                    ColumnNo := 1;
                    EnterCell(RowNo,ColumnNo,Text007,false,true,false,'',TempExcelBuffer."cell type"::Text);
                    repeat
                      ColumnNo := ColumnNo + 1;
                      EnterCell(RowNo,ColumnNo,ColumnDimCodeBuffer.Code,false,false,false,'',TempExcelBuffer."cell type"::Text);
                    until NextColumn(1) = 0;
                  end;
                  repeat
                    RecNo := RecNo + 1;
                    Window.Update(1,ROUND(RecNo / TotalRecNo * 10000,1));
                    RowNo := RowNo + 1;
                    ColumnNo := 1;
                    EnterCell(
                      RowNo,ColumnNo,LineDimCodeBuffer.Code,LineDimCodeBuffer."Show in Bold",false,false,'',TempExcelBuffer."cell type"::Text);
                    if FindColumn('-') then
                      repeat
                        ColumnNo := ColumnNo + 1;
                        ColumnValue :=
                          ItemBudgetManagement.CalcAmount(
                            ValueType,true,
                            ItemStatisticsBuffer,ItemBudgetName,
                            ItemFilter,SourceTypeFilter,SourceNoFilter,DateFilter,
                            GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter,
                            LineDimOption,LineDimCodeBuffer,
                            ColumnDimOption,ColumnDimCodeBuffer);
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          MatrixMgt.FormatValue(ColumnValue,RoundingFactor,false),
                          LineDimCodeBuffer."Show in Bold",
                          false,
                          false,
                          '',
                          TempExcelBuffer."cell type"::Number)
                      until NextColumn(1) = 0;
                  until NextLine(1) = 0;
                end;
                Window.Close;

                if DoUpdateExistingWorksheet then begin
                  TempExcelBuffer.UpdateBook(ServerFileName,SheetName);
                  TempExcelBuffer.WriteSheet('',COMPANYNAME,UserId);
                  TempExcelBuffer.CloseBook;
                  if not TestMode then
                    TempExcelBuffer.DownloadAndOpenExcel;
                end else begin
                  TempExcelBuffer.CreateBook(ServerFileName,TempExcelBuffer.GetExcelReference(10));
                  TempExcelBuffer.WriteSheet(
                    PadStr(StrSubstNo('%1 %2',ItemBudgetName.Name,ItemBudgetName.Description),30),
                    COMPANYNAME,UserId);
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
        ItemBudgetName: Record "Item Budget Name";
        Dim: Record Dimension;
        LineDimCodeBuffer: Record "Dimension Code Buffer";
        ColumnDimCodeBuffer: Record "Dimension Code Buffer";
        ItemStatisticsBuffer: Record "Item Statistics Buffer";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        GLSetup: Record "General Ledger Setup";
        ItemBudgetManagement: Codeunit "Item Budget Management";
        MatrixMgt: Codeunit "Matrix Management";
        FileMgt: Codeunit "File Management";
        LineDimCode: Text[30];
        ColumnDimCode: Text[30];
        DateFilter: Text;
        InternalDateFilter: Text;
        ShowValueAsText: Text[30];
        ServerFileName: Text;
        SheetName: Text[250];
        BudgetName: Code[10];
        GlobalDim1Filter: Text;
        GlobalDim2Filter: Text;
        BudgetDim1Filter: Text;
        BudgetDim2Filter: Text;
        BudgetDim3Filter: Text;
        SourceNoFilter: Text;
        ItemFilter: Text;
        ColumnValue: Decimal;
        AnalysisArea: Option Sales,Purchase,Inventory;
        ValueType: Option "Sales Amount","Cost Amount",Quantity;
        Text003: label 'Date Filter';
        Text004: label 'Item Filter';
        Text005: label 'Customer Filter';
        Text006: label 'Vendor Filter';
        SourceTypeFilter: Option " ",Customer,Vendor,Item;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        LineDimOption: Option Item,Customer,Vendor,Period,Location,"Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4";
        ColumnDimOption: Option Item,Customer,Vendor,Period,Location,"Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4";
        RoundingFactor: Option "None","1","1000","1000000";
        PeriodInitialized: Boolean;
        Text007: label 'Table Data';
        Text008: label 'Show as Lines';
        Text009: label 'Show as Columns';
        Text010: label '%1 must not be blank.';
        Text011: label 'Show Value as';
        Text012: label 'Sales Amount';
        Text013: label 'Cost Amount';
        Text014: label 'COGS Amount';
        Text015: label 'Quantity';
        DoUpdateExistingWorksheet: Boolean;
        ExcelFileExtensionTok: label '.xlsx', Locked=true;
        TestMode: Boolean;


    procedure SetOptions(NewAnalysisArea: Integer;NewBudgName: Code[10];NewValueType: Integer;NewGlobalDim1Filter: Text;NewGlobalDim2Filter: Text;NewBudgDim1Filter: Text;NewBudgDim2Filter: Text;NewBudgDim3Filter: Text;NewDateFilter: Text;NewSourceTypeFilter: Integer;NewSourceNoFilter: Text;NewItemFilter: Text;NewInternalDateFilter: Text;NewPeriodInitialized: Boolean;NewPeriodType: Integer;NewLineDimOption: Integer;NewColumnDimOption: Integer;NewLineDimCode: Text[30];NewColumnDimCode: Text[30];NewRoundingFactor: Option "None","1","1000","1000000")
    begin
        AnalysisArea := NewAnalysisArea;
        BudgetName := NewBudgName;
        ValueType := NewValueType;
        GlobalDim1Filter := NewGlobalDim1Filter;
        GlobalDim2Filter := NewGlobalDim2Filter;
        BudgetDim1Filter := NewBudgDim1Filter;
        BudgetDim2Filter := NewBudgDim2Filter;
        BudgetDim3Filter := NewBudgDim3Filter;
        DateFilter := NewDateFilter;
        ItemFilter := NewItemFilter;
        SourceTypeFilter := NewSourceTypeFilter;
        SourceNoFilter := NewSourceNoFilter;
        InternalDateFilter := NewInternalDateFilter;
        PeriodInitialized := NewPeriodInitialized;
        PeriodType := NewPeriodType;
        LineDimOption := NewLineDimOption;
        ColumnDimOption := NewColumnDimOption;
        LineDimCode := NewLineDimCode;
        ColumnDimCode := NewColumnDimCode;
        RoundingFactor := NewRoundingFactor;
    end;

    local procedure EnterFilterInCell(RowNo: Integer;"Filter": Text;FieldName: Text[100])
    begin
        EnterCell(RowNo,1,FieldName,false,false,false,'',TempExcelBuffer."cell type"::Text);
        EnterCell(RowNo,2,CopyStr(Filter,1,250),false,false,false,'',TempExcelBuffer."cell type"::Text);
    end;

    local procedure EnterCell(RowNo: Integer;ColumnNo: Integer;CellValue: Text[250];Bold: Boolean;Italic: Boolean;UnderLine: Boolean;NumberFormat: Text[30];CellType: Option)
    begin
        TempExcelBuffer.Init;
        TempExcelBuffer.Validate("Row No.",RowNo);
        TempExcelBuffer.Validate("Column No.",ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := '';
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        TempExcelBuffer.Underline := UnderLine;
        TempExcelBuffer.NumberFormat := NumberFormat;
        TempExcelBuffer."Cell Type" := CellType;
        TempExcelBuffer.Insert;
    end;

    local procedure FindLine(Which: Text[1024]): Boolean
    begin
        exit(
          ItemBudgetManagement.FindRec(
            ItemBudgetName,LineDimOption,LineDimCodeBuffer,Which,
            ItemFilter,SourceNoFilter,PeriodType,DateFilter,PeriodInitialized,InternalDateFilter,
            GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter));
    end;

    local procedure NextLine(Steps: Integer): Integer
    begin
        exit(
          ItemBudgetManagement.NextRec(
            ItemBudgetName,LineDimOption,LineDimCodeBuffer,Steps,
            ItemFilter,SourceNoFilter,PeriodType,DateFilter,
            GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter));
    end;

    local procedure FindColumn(Which: Text[1024]): Boolean
    begin
        exit(
          ItemBudgetManagement.FindRec(
            ItemBudgetName,ColumnDimOption,ColumnDimCodeBuffer,Which,
            ItemFilter,SourceNoFilter,PeriodType,DateFilter,PeriodInitialized,InternalDateFilter,
            GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter));
    end;

    local procedure NextColumn(Steps: Integer): Integer
    begin
        exit(
          ItemBudgetManagement.NextRec(
            ItemBudgetName,ColumnDimOption,ColumnDimCodeBuffer,Steps,
            ItemFilter,SourceNoFilter,PeriodType,DateFilter,
            GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter));
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
}

