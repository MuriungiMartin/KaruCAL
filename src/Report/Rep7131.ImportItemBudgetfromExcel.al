#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7131 "Import Item Budget from Excel"
{
    Caption = 'Import Item Budget from Excel';
    ProcessingOnly = true;

    dataset
    {
        dataitem(ItemBudgetBuf;"Item Budget Buffer")
        {
            DataItemTableView = sorting("Item No.","Source Type","Source No.","Location Code","Global Dimension 1 Code","Global Dimension 2 Code","Budget Dimension 1 Code","Budget Dimension 2 Code","Budget Dimension 3 Code",Date);
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                RecNo := RecNo + 1;
                ItemBudgetEntry.Init;
                ItemBudgetEntry.Validate("Entry No.",EntryNo);
                ItemBudgetEntry.Validate("Analysis Area",AnalysisArea);
                ItemBudgetEntry.Validate("Budget Name",ToItemBudgetName);
                ItemBudgetEntry.Validate("Item No.","Item No.");
                ItemBudgetEntry.Validate("Location Code","Location Code");
                ItemBudgetEntry.Validate(Date,Date);
                ItemBudgetEntry.Validate(Description,Description);
                ItemBudgetEntry.Validate("Source Type","Source Type");
                ItemBudgetEntry.Validate("Source No.","Source No.");
                ItemBudgetEntry.Validate("Sales Amount","Sales Amount");
                ItemBudgetEntry.Validate(Quantity,Quantity);
                ItemBudgetEntry.Validate("Cost Amount","Cost Amount");
                ItemBudgetEntry.Validate("Global Dimension 1 Code","Global Dimension 1 Code");
                ItemBudgetEntry.Validate("Global Dimension 2 Code","Global Dimension 2 Code");
                ItemBudgetEntry.Validate("Budget Dimension 1 Code","Budget Dimension 1 Code");
                ItemBudgetEntry.Validate("Budget Dimension 2 Code","Budget Dimension 2 Code");
                ItemBudgetEntry.Validate("Budget Dimension 3 Code","Budget Dimension 3 Code");
                ItemBudgetEntry.Validate("User ID",UserId);
                ItemBudgetEntry.Insert(true);
                EntryNo := EntryNo + 1;
            end;

            trigger OnPostDataItem()
            begin
                if RecNo > 0 then
                  Message(Text004,ItemBudgetEntry.TableCaption,RecNo);
            end;

            trigger OnPreDataItem()
            begin
                RecNo := 0;

                if ImportOption = Importoption::"Replace entries" then begin
                  ItemBudgetEntry.SetRange("Analysis Area",AnalysisArea);
                  ItemBudgetEntry.SetRange("Budget Name",ToItemBudgetName);
                  ItemBudgetEntry.DeleteAll(true);
                end;

                ItemBudgetEntry.Reset;
                if ItemBudgetEntry.FindLast then
                  EntryNo := ItemBudgetEntry."Entry No." + 1
                else
                  EntryNo := 1;
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
                    field(ToItemBudgetName;ToItemBudgetName)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Budget Name';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            ItemBudgetName: Record "Item Budget Name";
                        begin
                            ItemBudgetName.FilterGroup := 2;
                            ItemBudgetName.SetRange("Analysis Area",AnalysisArea);
                            ItemBudgetName.FilterGroup := 0;
                            if Page.RunModal(Page::"Item Budget Names",ItemBudgetName) = Action::LookupOK then begin
                              Text := ItemBudgetName.Name;
                              exit(true);
                            end;
                        end;
                    }
                    field(ImportOption;ImportOption)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Option';
                        OptionCaption = 'Replace entries,Add entries';
                    }
                    field(Description;Description)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Description';
                    }
                    field(PurchValueType;ValueType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Import Value as';
                        OptionCaption = ',Cost Amount,Quantity';
                        Visible = PurchValueTypeVisible;
                    }
                    field(SalesValueType;ValueType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Import Value as';
                        OptionCaption = 'Sales Amount,COGS Amount,Quantity';
                        Visible = SalesValueTypeVisible;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            PurchValueTypeVisible := true;
            SalesValueTypeVisible := true;
        end;

        trigger OnOpenPage()
        var
            ItemBudgetName: Record "Item Budget Name";
        begin
            Description := Text005 + Format(WorkDate);
            if not ItemBudgetName.Get(AnalysisArea,ToItemBudgetName) then
              ToItemBudgetName := '';

            ValueType := ValueTypeHidden;
            SalesValueTypeVisible := AnalysisArea = Analysisarea::Sales;
            PurchValueTypeVisible := AnalysisArea = Analysisarea::Purchase;
        end;

        trigger OnQueryClosePage(CloseAction: action): Boolean
        var
            FileMgt: Codeunit "File Management";
        begin
            if CloseAction = Action::OK then begin
              ServerFileName := FileMgt.UploadFile(Text006,ExcelExtensionTok);
              if ServerFileName = '' then
                exit(false);

              SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
              if SheetName = '' then
                exit(false);
            end;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        ExcelBuf.DeleteAll;
        ItemBudgetBuf.DeleteAll;
    end;

    trigger OnPreReport()
    begin
        if ToItemBudgetName = '' then
          Error(Text000);

        if not ItemBudgetName.Get(AnalysisArea,ToItemBudgetName) then begin
          if not Confirm(Text001,false,ToItemBudgetName) then
            CurrReport.Break;
          ItemBudgetName."Analysis Area" := AnalysisArea;
          ItemBudgetName.Name := ToItemBudgetName;
          ItemBudgetName.Insert;
        end else begin
          if ItemBudgetName.Blocked then
            Error(Text002,ItemBudgetEntry.FieldCaption("Budget Name"),ToItemBudgetName);
          if not Confirm(
               Text003,false,
               Lowercase(Format(SelectStr(ImportOption + 1,Text010))),
               ToItemBudgetName)
          then
            CurrReport.Break;
        end;

        ExcelBuf.LockTable;
        ItemBudgetBuf.LockTable;

        ExcelBuf.OpenBook(ServerFileName,SheetName);
        ExcelBuf.ReadSheet;

        AnalyseData;
    end;

    var
        Text000: label 'You must specify a budget name to import to.';
        Text001: label 'Do you want to create Item Budget Name %1?';
        Text002: label '%1 %2 is blocked. You cannot import entries.';
        Text003: label 'Are you sure you want to %1 for Budget Name %2?';
        Text004: label '%1 table has been successfully updated with %2 entries.';
        Text005: label 'Imported from Excel ';
        Text006: label 'Import Excel File';
        Text007: label 'Table Data';
        Text008: label 'Show as Lines';
        Text009: label 'Show as Columns';
        Text010: label 'Replace Entries,Add Entries';
        Text011: label 'The text %1 can only be specified once in the Excel worksheet.';
        Text012: label 'The filters specified by worksheet must be placed in the lines before the table.';
        Text013: label 'Date Filter';
        ExcelBuf: Record "Excel Buffer";
        GLSetup: Record "General Ledger Setup";
        ItemBudgetName: Record "Item Budget Name";
        ItemBudgetEntry: Record "Item Budget Entry";
        ItemBudgetManagement: Codeunit "Item Budget Management";
        Window: Dialog;
        ServerFileName: Text;
        SheetName: Text[250];
        Description: Text[50];
        ToItemBudgetName: Code[10];
        RecNo: Integer;
        EntryNo: Integer;
        ImportOption: Option "Replace entries","Add entries";
        AnalysisArea: Option Sales,Purchase,Inventory;
        ValueType: Option "Sales Amount","COGS / Cost Amount",Quantity;
        ValueTypeHidden: Option "Sales Amount","COGS / Cost Amount",Quantity;
        GlSetupRead: Boolean;
        Text014: label 'Customer Filter';
        Text015: label 'Vendor Filter';
        Text016: label 'Analyzing Data...\\';
        Text017: label 'Item Filter';
        Text018: label '%1 is not a valid dimension value.';
        Text019: label '%1 is not a valid line definition.';
        Text020: label '%1 is not a valid column definition.';
        Text021: label 'You must specify a dimension value in row %1, column %2.';
        [InDataSet]
        SalesValueTypeVisible: Boolean;
        [InDataSet]
        PurchValueTypeVisible: Boolean;
        ExcelExtensionTok: label '.xlsx', Locked=true;

    local procedure AnalyseData()
    var
        DateFilter: Text[30];
        LineDimCode: Text[30];
        ColumnDimCode: Text[30];
        ItemFilter: Code[20];
        LocationFilter: Code[10];
        GlobalDim1Filter: Code[20];
        GlobalDim2Filter: Code[20];
        BudgetDim1Filter: Code[20];
        BudgetDim2Filter: Code[20];
        BudgetDim3Filter: Code[20];
        SourceNoFilter: Code[20];
        CurrLineDimValue: Code[20];
        CurrColumnDimValue: Code[20];
        TotalRecNo: Integer;
        HeaderRowNo: Integer;
        SourceTypeFilter: Option " ",Customer,Vendor,Item;
        LineDimOption: Option Item,Customer,Vendor,Period,Location,"Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3";
        ColumnDimOption: Option Item,Customer,Vendor,Period,Location,"Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3";
    begin
        Window.Open(Text016 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        TotalRecNo := ExcelBuf.Count;

        ItemBudgetBuf.DeleteAll;

        if ExcelBuf.Find('-') then
          repeat
            RecNo := RecNo + 1;
            Window.Update(1,ROUND(RecNo / TotalRecNo * 10000,1));
            case true of
              StrPos(ExcelBuf."Cell Value as Text",Text007) <> 0:
                begin
                  if HeaderRowNo = 0 then
                    HeaderRowNo := ExcelBuf."Row No."
                  else
                    Error(StrSubstNo(Text011,Text007));

                  ConvertFiltersToValue(
                    DateFilter,
                    ItemFilter,
                    GlobalDim1Filter,
                    GlobalDim2Filter,
                    BudgetDim1Filter,
                    BudgetDim2Filter,
                    BudgetDim3Filter,
                    SourceNoFilter,
                    SourceTypeFilter);

                  if ItemBudgetManagement.DimCodeNotAllowed(LineDimCode,ItemBudgetName) then
                    Error(Text019,LineDimCode);

                  if ItemBudgetManagement.DimCodeNotAllowed(ColumnDimCode,ItemBudgetName) then
                    Error(Text020,ColumnDimCode);

                  ItemBudgetManagement.SetLineAndColDim(
                    ItemBudgetName,
                    LineDimCode,
                    LineDimOption,
                    ColumnDimCode,
                    ColumnDimOption);
                end;
              StrPos(ExcelBuf."Cell Value as Text",IsGlobalDimFilter(1)) <> 0:
                begin
                  CheckFilterRowNo(HeaderRowNo);
                  ExcelBuf.SetRange("Row No.",ExcelBuf."Row No.");
                  if ExcelBuf.Next <> 0 then
                    GlobalDim1Filter := CopyStr(ExcelBuf."Cell Value as Text",1,MaxStrLen(GlobalDim1Filter));
                  ExcelBuf.SetRange("Row No.");
                end;
              StrPos(ExcelBuf."Cell Value as Text",IsGlobalDimFilter(2)) <> 0:
                begin
                  CheckFilterRowNo(HeaderRowNo);
                  ExcelBuf.SetRange("Row No.",ExcelBuf."Row No.");
                  if ExcelBuf.Next <> 0 then
                    GlobalDim2Filter := CopyStr(ExcelBuf."Cell Value as Text",1,MaxStrLen(GlobalDim2Filter));
                  ExcelBuf.SetRange("Row No.");
                end;
              StrPos(ExcelBuf."Cell Value as Text",IsBudgetDimFilter(1)) <> 0:
                begin
                  CheckFilterRowNo(HeaderRowNo);
                  ExcelBuf.SetRange("Row No.",ExcelBuf."Row No.");
                  if ExcelBuf.Next <> 0 then
                    BudgetDim1Filter := CopyStr(ExcelBuf."Cell Value as Text",1,MaxStrLen(BudgetDim1Filter));
                  ExcelBuf.SetRange("Row No.");
                end;
              StrPos(ExcelBuf."Cell Value as Text",IsBudgetDimFilter(2)) <> 0:
                begin
                  CheckFilterRowNo(HeaderRowNo);
                  ExcelBuf.SetRange("Row No.",ExcelBuf."Row No.");
                  if ExcelBuf.Next <> 0 then
                    BudgetDim2Filter := CopyStr(ExcelBuf."Cell Value as Text",1,MaxStrLen(BudgetDim2Filter));
                  ExcelBuf.SetRange("Row No.");
                end;
              StrPos(ExcelBuf."Cell Value as Text",IsBudgetDimFilter(3)) <> 0:
                begin
                  CheckFilterRowNo(HeaderRowNo);
                  ExcelBuf.SetRange("Row No.",ExcelBuf."Row No.");
                  if ExcelBuf.Next <> 0 then
                    BudgetDim3Filter := CopyStr(ExcelBuf."Cell Value as Text",1,MaxStrLen(BudgetDim3Filter));
                  ExcelBuf.SetRange("Row No.");
                end;
              StrPos(ExcelBuf."Cell Value as Text",Text017) <> 0:
                begin
                  CheckFilterRowNo(HeaderRowNo);
                  ExcelBuf.SetRange("Row No.",ExcelBuf."Row No.");
                  if ExcelBuf.Next <> 0 then
                    ItemFilter := CopyStr(ExcelBuf."Cell Value as Text",1,MaxStrLen(ItemFilter));
                  ExcelBuf.SetRange("Row No.");
                end;
              StrPos(ExcelBuf."Cell Value as Text",Text013) <> 0:
                begin
                  CheckFilterRowNo(HeaderRowNo);
                  ExcelBuf.SetRange("Row No.",ExcelBuf."Row No.");
                  if ExcelBuf.Next <> 0 then
                    DateFilter := CopyStr(ExcelBuf."Cell Value as Text",1,MaxStrLen(DateFilter));
                  ExcelBuf.SetRange("Row No.");
                end;
              StrPos(ExcelBuf."Cell Value as Text",Text014) <> 0:
                begin
                  CheckFilterRowNo(HeaderRowNo);
                  ExcelBuf.SetRange("Row No.",ExcelBuf."Row No.");
                  if ExcelBuf.Next <> 0 then begin
                    SourceTypeFilter := Sourcetypefilter::Customer;
                    SourceNoFilter := CopyStr(ExcelBuf."Cell Value as Text",1,MaxStrLen(SourceNoFilter));
                  end;
                  ExcelBuf.SetRange("Row No.");
                end;
              StrPos(ExcelBuf."Cell Value as Text",Text015) <> 0:
                begin
                  CheckFilterRowNo(HeaderRowNo);
                  ExcelBuf.SetRange("Row No.",ExcelBuf."Row No.");
                  if ExcelBuf.Next <> 0 then begin
                    SourceTypeFilter := Sourcetypefilter::Vendor;
                    SourceNoFilter := CopyStr(ExcelBuf."Cell Value as Text",1,MaxStrLen(SourceNoFilter));
                  end;
                  ExcelBuf.SetRange("Row No.");
                end;
              StrPos(ExcelBuf."Cell Value as Text",Text008) <> 0:
                begin
                  CheckFilterRowNo(HeaderRowNo);
                  ExcelBuf.SetRange("Row No.",ExcelBuf."Row No.");
                  if ExcelBuf.Next <> 0 then
                    LineDimCode := CopyStr(ExcelBuf."Cell Value as Text",1,MaxStrLen(LineDimCode));
                  ExcelBuf.SetRange("Row No.");
                end;
              StrPos(ExcelBuf."Cell Value as Text",Text009) <> 0:
                begin
                  CheckFilterRowNo(HeaderRowNo);
                  ExcelBuf.SetRange("Row No.",ExcelBuf."Row No.");
                  if ExcelBuf.Next <> 0 then
                    ColumnDimCode := CopyStr(ExcelBuf."Cell Value as Text",1,MaxStrLen(ColumnDimCode));
                  ExcelBuf.SetRange("Row No.");
                end;
              (ExcelBuf."Row No." > HeaderRowNo) and (HeaderRowNo <> 0):
                begin
                  CurrLineDimValue := CopyStr(ExcelBuf."Cell Value as Text",1,MaxStrLen(CurrLineDimValue));
                  ExcelBuf.SetRange("Row No.",ExcelBuf."Row No.");
                  while ExcelBuf.Next <> 0 do begin
                    CurrColumnDimValue := GetCurrColumnDimValue(ExcelBuf."Column No.",HeaderRowNo);
                    ExchangeFiltersWithDimValue(
                      CurrLineDimValue,
                      CurrColumnDimValue,
                      LineDimOption,
                      ColumnDimOption,
                      DateFilter,
                      ItemFilter,
                      LocationFilter,
                      GlobalDim1Filter,
                      GlobalDim2Filter,
                      BudgetDim1Filter,
                      BudgetDim2Filter,
                      BudgetDim3Filter,
                      SourceNoFilter,
                      SourceTypeFilter);

                    ItemBudgetBuf.Init;
                    ItemBudgetBuf."Item No." := ItemFilter;
                    if SourceTypeFilter <> 0 then
                      ItemBudgetBuf."Source Type" := SourceTypeFilter
                    else
                      ItemBudgetBuf."Source Type" := LineDimOption;
                    ItemBudgetBuf."Source No." := SourceNoFilter;
                    ItemBudgetBuf."Location Code" := LocationFilter;
                    ItemBudgetBuf."Global Dimension 1 Code" := GlobalDim1Filter;
                    ItemBudgetBuf."Global Dimension 2 Code" := GlobalDim2Filter;
                    ItemBudgetBuf."Budget Dimension 1 Code" := BudgetDim1Filter;
                    ItemBudgetBuf."Budget Dimension 2 Code" := BudgetDim2Filter;
                    ItemBudgetBuf."Budget Dimension 3 Code" := BudgetDim3Filter;
                    Evaluate(ItemBudgetBuf.Date,DateFilter);
                    case ValueType of
                      Valuetype::"Sales Amount":
                        Evaluate(ItemBudgetBuf."Sales Amount",ExcelBuf."Cell Value as Text");
                      Valuetype::"COGS / Cost Amount":
                        Evaluate(ItemBudgetBuf."Cost Amount",ExcelBuf."Cell Value as Text");
                      Valuetype::Quantity:
                        Evaluate(ItemBudgetBuf.Quantity,ExcelBuf."Cell Value as Text");
                    end;
                    ItemBudgetBuf.Insert;
                  end;
                  ExcelBuf.SetRange("Row No.");
                end;
            end;
          until ExcelBuf.Next = 0;

        Window.Close;
    end;

    local procedure ExchangeFiltersWithDimValue(CurrLineDimValue: Code[20];CurrColumnDimValue: Code[20];LineDimOption: Option Item,Customer,Vendor,Period,Location,"Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3";ColumnDimOption: Option Item,Customer,Vendor,Period,Location,"Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3";var DateFilter: Text[30];var ItemFilter: Code[20];var LocationFilter: Code[10];var GlobalDim1Filter: Code[20];var GlobalDim2Filter: Code[20];var BudgetDim1Filter: Code[20];var BudgetDim2Filter: Code[20];var BudgetDim3Filter: Code[20];var SourceNoFilter: Code[20];var SourceTypeFilter: Option " ",Customer,Vendor,Item)
    begin
        case LineDimOption of
          Linedimoption::Item:
            ItemFilter := CurrLineDimValue;
          Linedimoption::Customer:
            begin
              SourceNoFilter := CurrLineDimValue;
              if SourceTypeFilter = Sourcetypefilter::" " then
                SourceTypeFilter := Sourcetypefilter::Customer;
            end;
          Linedimoption::Vendor:
            begin
              SourceNoFilter := CurrLineDimValue;
              if SourceTypeFilter = Sourcetypefilter::" " then
                SourceTypeFilter := Sourcetypefilter::Vendor;
            end;
          Linedimoption::Period:
            DateFilter := CurrLineDimValue;
          Linedimoption::Location:
            LocationFilter := CopyStr(CurrLineDimValue,1,MaxStrLen(LocationFilter));
          Linedimoption::"Global Dimension 1":
            GlobalDim1Filter := CurrLineDimValue;
          Linedimoption::"Global Dimension 2":
            GlobalDim2Filter := CurrLineDimValue;
          Linedimoption::"Budget Dimension 1":
            BudgetDim1Filter := CurrLineDimValue;
          Linedimoption::"Budget Dimension 2":
            BudgetDim2Filter := CurrLineDimValue;
          Linedimoption::"Budget Dimension 3":
            BudgetDim3Filter := CurrLineDimValue;
          else
            Error(Text018,CurrLineDimValue);
        end;

        case ColumnDimOption of
          Columndimoption::Item:
            ItemFilter := CurrColumnDimValue;
          Columndimoption::Customer:
            begin
              SourceNoFilter := CurrColumnDimValue;
              if SourceTypeFilter = Sourcetypefilter::" " then
                SourceTypeFilter := Sourcetypefilter::Customer;
            end;
          Columndimoption::Vendor:
            begin
              SourceNoFilter := CurrColumnDimValue;
              if SourceTypeFilter = Sourcetypefilter::" " then
                SourceTypeFilter := Sourcetypefilter::Vendor;
            end;
          Columndimoption::Period:
            DateFilter := CurrColumnDimValue;
          Columndimoption::Location:
            LocationFilter := CopyStr(CurrColumnDimValue,1,MaxStrLen(LocationFilter));
          Columndimoption::"Global Dimension 1":
            GlobalDim1Filter := CurrColumnDimValue;
          Columndimoption::"Global Dimension 2":
            GlobalDim2Filter := CurrColumnDimValue;
          Columndimoption::"Budget Dimension 1":
            BudgetDim1Filter := CurrColumnDimValue;
          Columndimoption::"Budget Dimension 2":
            BudgetDim2Filter := CurrColumnDimValue;
          Columndimoption::"Budget Dimension 3":
            BudgetDim3Filter := CurrColumnDimValue;
          else
            Error(Text018,CurrColumnDimValue);
        end;
    end;

    local procedure GetCurrColumnDimValue(ColNo: Integer;HeaderRowNo: Integer): Code[20]
    var
        ExcelBuf2: Record "Excel Buffer";
    begin
        if not ExcelBuf2.Get(HeaderRowNo,ColNo) then
          Error(Text021,HeaderRowNo,ColNo);
        exit(ExcelBuf2."Cell Value as Text");
    end;

    local procedure ConvertFiltersToValue(var DateFilter: Text[30];var ItemFilter: Code[20];var GlobalDim1Filter: Code[20];var GlobalDim2Filter: Code[20];var BudgetDim1Filter: Code[20];var BudgetDim2Filter: Code[20];var BudgetDim3Filter: Code[20];var SourceNoFilter: Code[20];SourceTypeFilter: Option " ",Customer,Vendor,Item)
    var
        Item: Record Item;
        Calendar: Record Date;
        Cust: Record Customer;
        Vend: Record Vendor;
        DimValue: Record "Dimension Value";
        CurrDate: Date;
    begin
        if ItemFilter <> '' then begin
          Item.SetFilter("No.",ItemFilter);
          ItemFilter := Item.GetRangeMin("No.");
          Item.Get(ItemFilter);
        end;

        if DateFilter <> '' then begin
          Calendar.SetFilter("Period Start",DateFilter);
          DateFilter := Format(Calendar.GetRangeMin("Period Start"));
          Evaluate(CurrDate,DateFilter);
          Calendar.Get(Calendar."period type"::Date,CurrDate);
        end;

        if SourceNoFilter <> '' then
          case SourceTypeFilter of
            Sourcetypefilter::Customer:
              begin
                Cust.SetFilter("No.",SourceNoFilter);
                SourceNoFilter := Cust.GetRangeMin("No.");
                Cust.Get(SourceNoFilter);
              end;
            Sourcetypefilter::Vendor:
              begin
                Vend.SetFilter("No.",SourceNoFilter);
                SourceNoFilter := Vend.GetRangeMin("No.");
                Vend.Get(SourceNoFilter);
              end;
          end;

        GetGLSetup;
        if GlobalDim1Filter <> '' then begin
          DimValue.SetFilter(Code,GlobalDim1Filter);
          GlobalDim1Filter := DimValue.GetRangeMin(Code);
          DimValue.Get(GLSetup."Global Dimension 1 Code",GlobalDim1Filter);
        end;

        if GlobalDim2Filter <> '' then begin
          DimValue.SetFilter(Code,GlobalDim2Filter);
          GlobalDim2Filter := DimValue.GetRangeMin(Code);
          DimValue.Get(GLSetup."Global Dimension 2 Code",GlobalDim2Filter);
        end;

        if BudgetDim1Filter <> '' then begin
          DimValue.SetFilter(Code,BudgetDim1Filter);
          BudgetDim1Filter := DimValue.GetRangeMin(Code);
          DimValue.Get(ItemBudgetName."Budget Dimension 1 Code",BudgetDim1Filter);
        end;

        if BudgetDim2Filter <> '' then begin
          DimValue.SetFilter(Code,BudgetDim2Filter);
          BudgetDim2Filter := DimValue.GetRangeMin(Code);
          DimValue.Get(ItemBudgetName."Budget Dimension 2 Code",BudgetDim2Filter);
        end;

        if BudgetDim3Filter <> '' then begin
          DimValue.SetFilter(Code,BudgetDim3Filter);
          BudgetDim3Filter := DimValue.GetRangeMin(Code);
          DimValue.Get(ItemBudgetName."Budget Dimension 3 Code",BudgetDim3Filter);
        end;
    end;

    local procedure CheckFilterRowNo(HeaderRowNo: Integer)
    begin
        if (HeaderRowNo <> 0) and (ExcelBuf."Row No." > HeaderRowNo) then
          Error(Text012);
    end;

    local procedure IsGlobalDimFilter(DimNo: Integer): Text[30]
    var
        Dim: Record Dimension;
    begin
        GetGLSetup;
        case DimNo of
          1:
            if Dim.Get(GLSetup."Global Dimension 1 Code") then;
          2:
            if Dim.Get(GLSetup."Global Dimension 2 Code") then;
        end;
        exit(Dim."Filter Caption");
    end;

    local procedure IsBudgetDimFilter(DimNo: Integer): Text[30]
    var
        Dim: Record Dimension;
    begin
        case DimNo of
          1:
            if Dim.Get(ItemBudgetName."Budget Dimension 1 Code") then;
          2:
            if Dim.Get(ItemBudgetName."Budget Dimension 2 Code") then;
          3:
            if Dim.Get(ItemBudgetName."Budget Dimension 3 Code") then;
        end;
        exit(Dim."Filter Caption");
    end;

    local procedure GetGLSetup()
    begin
        if not GlSetupRead then
          GLSetup.Get;
        GlSetupRead := true;
    end;


    procedure SetParameters(NewToItemBudgetName: Code[10];NewAnalysisArea: Integer;NewValueType: Integer)
    begin
        ToItemBudgetName := NewToItemBudgetName;
        AnalysisArea := NewAnalysisArea;
        ValueTypeHidden := NewValueType;
    end;


    procedure SetFileNameSilent(NewFileName: Text)
    begin
        ServerFileName := NewFileName;
    end;
}

