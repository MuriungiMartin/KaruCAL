#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 8618 "Config. Excel Exchange"
{

    trigger OnRun()
    begin
    end;

    var
        ConfigPackage: Record "Config. Package";
        ConfigXMLExchange: Codeunit "Config. XML Exchange";
        FileMgt: Codeunit "File Management";
        ConfigProgressBar: Codeunit "Config. Progress Bar";
        ConfigValidateMgt: Codeunit "Config. Validate Management";
        CannotCreateXmlSchemaErr: label 'Could not create XML Schema.';
        CreatingExcelMsg: label 'Creating Excel worksheet';
        WrkbkReader: dotnet WorkbookReader;
        WrkbkWriter: dotnet WorkbookWriter;
        WrkShtWriter: dotnet WorksheetWriter;
        Worksheet: dotnet Worksheet0;
        Workbook: dotnet Workbook;
        WorkBookPart: dotnet WorkbookPart;
        CreateWrkBkFailedErr: label 'Could not create the Excel workbook.';
        WrkShtHelper: dotnet WorksheetHelper;
        DataSet: dotnet DataSet;
        DataTable: dotnet DataTable;
        DataColumn: dotnet DataColumn;
        StringBld: dotnet StringBuilder;
        id: BigInteger;
        HideDialog: Boolean;
        CommentVmlShapeXmlTxt: label '<v:shape id="%1" type="#_x0000_t202" style=''position:absolute;  margin-left:59.25pt;margin-top:1.5pt;width:96pt;height:55.5pt;z-index:1;  visibility:hidden'' fillcolor="#ffffe1" o:insetmode="auto"><v:fill color2="#ffffe1"/><v:shadow color="black" obscured="t"/><v:path o:connecttype="none"/><v:textbox style=''mso-direction-alt:auto''><div style=''text-align:left''/></v:textbox><x:ClientData ObjectType="Note"><x:MoveWithCells/><x:SizeWithCells/><x:Anchor>%2</x:Anchor><x:AutoFill>False</x:AutoFill><x:Row>%3</x:Row><x:Column>%4</x:Column></x:ClientData></v:shape>', Locked=true;
        VmlDrawingXmlTxt: label '<xml xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel"><o:shapelayout v:ext="edit"><o:idmap v:ext="edit" data="1"/></o:shapelayout><v:shapetype id="_x0000_t202" coordsize="21600,21600" o:spt="202"  path="m,l,21600r21600,l21600,xe"><v:stroke joinstyle="miter"/><v:path gradientshapeok="t" o:connecttype="rect"/></v:shapetype>', Locked=true;
        EndXmlTokenTxt: label '</xml>', Locked=true;
        VmlShapeAnchorTxt: label '%1,15,%2,10,%3,31,8,9', Locked=true;
        FileExtensionFilterTok: label 'Excel Files (*.xlsx)|*.xlsx';
        ExcelFileNameTok: label '*%1.xlsx', Comment='%1 = String generated from current datetime to make sure file names are unique ';
        ExcelFileExtensionTok: label '.xlsx';
        InvalidDataInSheetMsg: label 'Data in sheet ''%1'' could not be imported, because the sheet has an unexpected format.', Comment='%1=excel sheet name';
        ImportFromExcelTxt: label 'Import from Excel';


    procedure ExportExcelFromConfig(var ConfigLine: Record "Config. Line"): Text
    var
        ConfigPackageTable: Record "Config. Package Table";
        ConfigMgt: Codeunit "Config. Management";
        FileName: Text;
        "Filter": Text;
    begin
        ConfigLine.FindFirst;
        ConfigPackageTable.SetRange("Package Code",ConfigLine."Package Code");
        Filter := ConfigMgt.MakeTableFilter(ConfigLine,true);
        if Filter <> '' then
          ConfigPackageTable.SetFilter("Table ID",Filter);

        ConfigPackageTable.SetRange("Dimensions as Columns",true);
        if ConfigPackageTable.FindSet then
          repeat
            if not (ConfigPackageTable.DimensionPackageDataExist or (ConfigPackageTable.DimensionFieldsCount > 0)) then
              ConfigPackageTable.InitDimensionFields;
          until ConfigPackageTable.Next = 0;
        ConfigPackageTable.SetRange("Dimensions as Columns");
        ExportExcel(FileName,ConfigPackageTable,true,false);
        exit(FileName);
    end;


    procedure ExportExcelFromPackage(ConfigPackage: Record "Config. Package"): Boolean
    var
        ConfigPackageTable: Record "Config. Package Table";
        FileName: Text;
    begin
        ConfigPackageTable.SetRange("Package Code",ConfigPackage.Code);
        exit(ExportExcel(FileName,ConfigPackageTable,false,false));
    end;


    procedure ExportExcelFromTables(var ConfigPackageTable: Record "Config. Package Table"): Boolean
    var
        FileName: Text;
    begin
        exit(ExportExcel(FileName,ConfigPackageTable,false,false));
    end;


    procedure ExportExcelTemplateFromTables(var ConfigPackageTable: Record "Config. Package Table"): Boolean
    var
        FileName: Text;
    begin
        exit(ExportExcel(FileName,ConfigPackageTable,false,true));
    end;


    procedure ExportExcel(var FileName: Text;var ConfigPackageTable: Record "Config. Package Table";ExportFromWksht: Boolean;SkipData: Boolean): Boolean
    var
        TempBlob: Record TempBlob;
        VmlDrawingPart: dotnet VmlDrawingPart;
        TableDefinitionPart: dotnet TableDefinitionPart;
        TableParts: dotnet TableParts;
        TablePart: dotnet TablePart;
        SingleXMLCells: dotnet SingleXmlCells;
        XmlTextWriter: dotnet XmlTextWriter0;
        FileMode: dotnet FileMode;
        Encoding: dotnet Encoding;
        TempSetupDataFileName: Text;
        TempSchemaFileName: Text;
        DataTableCounter: Integer;
    begin
        TempSchemaFileName := CreateSchemaFile(ConfigPackageTable);
        TempSetupDataFileName := BuildDataSetForPackageTable(ExportFromWksht,ConfigPackageTable);

        CreateBook(TempBlob);
        WrkShtHelper := WrkShtHelper.WorksheetHelper(WrkbkWriter.FirstWorksheet.Worksheet);
        ImportSchema(WrkbkWriter,TempSchemaFileName,1);
        CreateSchemaConnection(WrkbkWriter,TempSetupDataFileName);

        DataTableCounter := 1;

        if not HideDialog then
          ConfigProgressBar.Init(ConfigPackageTable.Count,1,CreatingExcelMsg);

        DataTable := DataSet.Tables.Item(1);

        if ConfigPackageTable.FindSet then
          repeat
            if IsNull(StringBld) then begin
              StringBld := StringBld.StringBuilder;
              StringBld.Append(VmlDrawingXmlTxt);
            end;

            ConfigPackageTable.CalcFields("Table Caption");
            if not HideDialog then
              ConfigProgressBar.Update(ConfigPackageTable."Table Caption");

            // Initialize WorkSheetWriter
            if id < 1 then begin
              WrkShtWriter := WrkbkWriter.FirstWorksheet;
              WrkShtWriter.Name := DelChr(ConfigPackageTable."Table Caption",'=','/');
            end else
              WrkShtWriter := WrkbkWriter.AddWorksheet(ConfigPackageTable."Table Caption");
            Worksheet := WrkShtWriter.Worksheet;

            // Add and initialize SingleCellTable part
            WrkShtWriter.AddSingleCellTablePart;
            SingleXMLCells := SingleXMLCells.SingleXmlCells;
            Worksheet.WorksheetPart.SingleCellTablePart.SingleXmlCells := SingleXMLCells;
            id += 3;

            AddAndInitializeCommentsPart(VmlDrawingPart);
            AddPackageAndTableInformation(ConfigPackageTable,SingleXMLCells);
            AddAndInitializeTableDefinitionPart(ConfigPackageTable,ExportFromWksht,DataTableCounter,TableDefinitionPart,SkipData);
            if not SkipData then
              CopyDataToExcelTable;

            DataTableCounter += 2;
            TableParts := WrkShtWriter.CreateTableParts(1);
            WrkShtHelper.AppendElementToOpenXmlElement(Worksheet,TableParts);
            TablePart := WrkShtWriter.CreateTablePart(Worksheet.WorksheetPart.GetIdOfPart(TableDefinitionPart));
            WrkShtHelper.AppendElementToOpenXmlElement(TableParts,TablePart);

            StringBld.Append(EndXmlTokenTxt);

            XmlTextWriter := XmlTextWriter.XmlTextWriter(VmlDrawingPart.GetStream(FileMode.Create),Encoding.UTF8);
            XmlTextWriter.WriteRaw(StringBld.ToString);
            XmlTextWriter.Flush;
            XmlTextWriter.Close;

            Clear(StringBld);

          until ConfigPackageTable.Next = 0;

        FILE.Erase(TempSchemaFileName);
        FILE.Erase(TempSetupDataFileName);

        CleanMapInfo(WrkbkWriter.Workbook.WorkbookPart.CustomXmlMappingsPart.MapInfo);
        WrkbkWriter.Workbook.Save;
        WrkbkWriter.Close;
        ClearOpenXmlVariables;

        if not HideDialog then
          ConfigProgressBar.Close;

        if FileName = '' then
          FileName :=
            StrSubstNo(ExcelFileNameTok,Format(CurrentDatetime,0,'<Day,2>_<Month,2>_<Year4>_<Hours24>_<Minutes,2>_<Seconds,2>'));

        FileName := FileMgt.BLOBExport(TempBlob,FileName,not HideDialog);
        exit(FileName <> '');
    end;


    procedure ImportExcelFromConfig(ConfigLine: Record "Config. Line")
    var
        TempBlob: Record TempBlob;
    begin
        ConfigLine.TestField("Line Type",ConfigLine."line type"::Table);
        ConfigLine.TestField("Table ID");
        if ConfigPackage.Get(ConfigLine."Package Code") and
           (FileMgt.BLOBImportWithFilter(TempBlob,ImportFromExcelTxt,'',FileExtensionFilterTok,ExcelFileExtensionTok) <> '')
        then
          ImportExcel(TempBlob);
    end;


    procedure ImportExcelFromPackage(): Boolean
    var
        TempBlob: Record TempBlob;
    begin
        if FileMgt.BLOBImportWithFilter(TempBlob,ImportFromExcelTxt,'',FileExtensionFilterTok,ExcelFileExtensionTok) <> '' then
          exit(ImportExcel(TempBlob));
        exit(false)
    end;


    procedure ImportExcel(var TempBlob: Record TempBlob) Imported: Boolean
    var
        TempXMLBuffer: Record "XML Buffer" temporary;
        WrkShtReader: dotnet WorksheetReader;
        DataRow: dotnet DataRow;
        DataRow2: dotnet DataRow;
        Enumerator: dotnet IEnumerator;
        CellData: dotnet CellData;
        WorkBookPart: dotnet WorkbookPart;
        Type: dotnet Type;
        InStream: InStream;
        XMLSchemaDataFile: Text;
        CellValueText: Text;
        ColumnCount: Integer;
        TotalColumnCount: Integer;
        WrkSheetId: Integer;
        DataColumnTableId: Integer;
        SheetCount: Integer;
        RowIn: Integer;
        SheetHeaderRead: Boolean;
        CurrentRowIndex: Integer;
        RowChanged: Boolean;
    begin
        TempBlob.Blob.CreateInstream(InStream);
        WrkbkReader := WrkbkReader.Open(InStream);
        WorkBookPart := WrkbkReader.Workbook.WorkbookPart;
        XMLSchemaDataFile := ExtractXMLSchema(WorkBookPart);

        WrkSheetId := WrkbkReader.FirstSheetId;
        SheetCount := WorkBookPart.Workbook.Sheets.ChildElements.Count + WrkSheetId;
        DataSet := DataSet.DataSet;
        DataSet.ReadXmlSchema(XMLSchemaDataFile);

        WrkSheetId := WrkbkReader.FirstSheetId;
        DataColumnTableId := 0;
        repeat
          WrkShtReader := WrkbkReader.GetWorksheetById(Format(WrkSheetId));

          if InitColumnMapping(WrkShtReader,TempXMLBuffer) then begin
            Enumerator := WrkShtReader.GetEnumerator;
            if GetDataTable(DataColumnTableId) then begin
              DataColumn := DataTable.Columns.Item(1);
              DataColumn.DataType := Type.GetType('System.String');
              DataTable.BeginLoadData;
              DataRow := DataTable.NewRow;
              SheetHeaderRead := false;
              DataColumn := DataTable.Columns.Item(1);
              RowIn := 1;
              ColumnCount := 0;
              TotalColumnCount := 0;
              CurrentRowIndex := 1;
              while Enumerator.MoveNext do begin
                CellData := Enumerator.Current;
                CellValueText := CellData.Value;
                RowChanged := CurrentRowIndex <> CellData.RowNumber;
                if not SheetHeaderRead then begin // Read config and table information
                  if (CellData.RowNumber = 1) and (CellData.ColumnNumber = 1) then
                    DataRow.Item(1,CellValueText);
                  if (CellData.RowNumber = 1) and (CellData.ColumnNumber = 3) then begin
                    DataColumn := DataTable.Columns.Item(0);
                    DataRow.Item(0,CellValueText);
                    DataTable.Rows.Add(DataRow);
                    DataColumn := DataTable.Columns.Item(2);
                    DataColumn.AllowDBNull(true);
                    DataTable := DataSet.Tables.Item(DataColumnTableId + 1);
                    ColumnCount := 0;
                    TotalColumnCount := DataTable.Columns.Count - 1;
                    repeat
                      DataColumn := DataTable.Columns.Item(ColumnCount);
                      DataColumn.DataType := Type.GetType('System.String');
                      ColumnCount += 1;
                    until ColumnCount = TotalColumnCount;
                    ColumnCount := 0;
                    DataRow2 := DataTable.NewRow;
                    DataRow2.SetParentRow(DataRow);
                    SheetHeaderRead := true;
                  end;
                end else begin // Read data rows
                  if (RowIn = 1) and (CellData.RowNumber = 4) and (CellData.ColumnNumber = 1) then begin
                    TotalColumnCount := ColumnCount;
                    ColumnCount := 0;
                    RowIn += 1;
                  end;

                  if RowChanged and (CellData.RowNumber > 4) and (RowIn <> 1) then begin
                    DataTable.Rows.Add(DataRow2);
                    DataTable.EndLoadData;
                    DataRow2 := DataTable.NewRow;
                    DataRow2.SetParentRow(DataRow);
                    RowIn += 1;
                    ColumnCount := 0;
                  end;

                  if RowIn <> 1 then
                    if TempXMLBuffer.Get(CellData.ColumnNumber) then begin
                      DataColumn := DataTable.Columns.Item(TempXMLBuffer."Parent Entry No.");
                      DataColumn.AllowDBNull(true);
                      DataRow2.Item(TempXMLBuffer."Parent Entry No.",CellValueText);
                    end;

                  ColumnCount := CellData.ColumnNumber + 1;
                end;
                CurrentRowIndex := CellData.RowNumber;
              end;
              // Add the last row
              DataTable.Rows.Add(DataRow2);
              DataTable.EndLoadData;
            end else
              Message(InvalidDataInSheetMsg,WrkShtReader.Name);
          end;

          WrkSheetId += 1;
          DataColumnTableId += 2;
        until WrkSheetId >= SheetCount;

        TempBlob.Init;
        TempBlob.Blob.CreateInstream(InStream);
        DataSet.WriteXml(InStream);
        ConfigXMLExchange.SetExcelMode(true);
        if ConfigXMLExchange.ImportPackageXMLFromStream(InStream) then
          Imported := true;

        exit(Imported);
    end;


    procedure ClearOpenXmlVariables()
    begin
        Clear(WrkbkReader);
        Clear(WrkbkWriter);
        Clear(WrkShtWriter);
        Clear(Workbook);
        Clear(WorkBookPart);
        Clear(WrkShtHelper);
    end;

    local procedure CreateBook(var TempBlob: Record TempBlob)
    var
        InStream: InStream;
    begin
        TempBlob.Blob.CreateInstream(InStream);
        WrkbkWriter := WrkbkWriter.Create(InStream);
        if IsNull(WrkbkWriter) then
          Error(CreateWrkBkFailedErr);

        Workbook := WrkbkWriter.Workbook;
        WorkBookPart := Workbook.WorkbookPart;
    end;


    procedure GetXLColumnID(ColumnNo: Integer): Text[10]
    var
        ExcelBuf: Record "Excel Buffer";
    begin
        ExcelBuf.Init;
        ExcelBuf.Validate("Column No.",ColumnNo);
        exit(ExcelBuf.xlColID);
    end;


    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    local procedure AddWorkSheetAuthor(Comments: dotnet Comments;AuthorText: Text)
    var
        Author: dotnet Author;
        Authors: dotnet Authors;
    begin
        Authors := Authors.Authors;
        WrkShtHelper.AppendElementToOpenXmlElement(Comments,Authors);
        Author := Author.Author;
        Author.Text := AuthorText;
        WrkShtHelper.AppendElementToOpenXmlElement(Authors,Author);
    end;

    local procedure ImportSchema(var WrkbkWriter: dotnet WorkbookWriter;SchemaFileName: Text;MapId: BigInteger)
    var
        CustomXMLMappingsPart: dotnet CustomXmlMappingsPart;
        MapInfo: dotnet MapInfo;
        "Schema": dotnet Schema;
        StreamReader: dotnet StreamReader;
        OpenXmlUnknownElement: dotnet OpenXmlUnknownElement;
        Map: dotnet Map;
        DataBinding: dotnet DataBinding;
        UInt32Value: dotnet UInt32Value;
        StringValue: dotnet StringValue;
        BooleanValue: dotnet BooleanValue;
        StreamText: Text;
    begin
        StreamReader := StreamReader.StreamReader(SchemaFileName);
        StreamReader.ReadLine;
        StreamText := StreamReader.ReadToEnd;
        StreamReader.Close;
        OpenXmlUnknownElement := OpenXmlUnknownElement.CreateOpenXmlUnknownElement(StreamText);

        Schema := WrkbkWriter.CreateSchemaFromOpenXmlUnknown(OpenXmlUnknownElement);
        Schema.Id := StringValue.StringValue('Schema1');

        MapInfo := MapInfo.MapInfo;
        MapInfo.SelectionNamespaces := StringValue.StringValue('');
        WrkShtHelper.AppendElementToOpenXmlElement(MapInfo,Schema);
        Map := Map.Map;
        UInt32Value := UInt32Value.UInt32Value;
        UInt32Value.Value := MapId;
        Map.ID := UInt32Value;
        Map.Name := StringValue.StringValue('DataList_Map');
        Map.RootElement := StringValue.StringValue('DataList');
        Map.SchemaId := Schema.Id;
        Map.ShowImportExportErrors := BooleanValue.BooleanValue(false);
        Map.AutoFit := BooleanValue.BooleanValue(true);
        Map.AppendData := BooleanValue.BooleanValue(false);
        Map.PreserveAutoFilterState := BooleanValue.BooleanValue(true);
        Map.PreserveFormat := BooleanValue.BooleanValue(true);

        DataBinding := DataBinding.DataBinding;
        DataBinding.FileBinding := BooleanValue.BooleanValue(true);
        DataBinding.ConnectionId := Map.ID;
        UInt32Value.Value := 1;
        DataBinding.DataBindingLoadMode := UInt32Value;
        WrkShtHelper.AppendElementToOpenXmlElement(MapInfo,Map);
        WrkShtHelper.AppendElementToOpenXmlElement(Map,DataBinding);

        CustomXMLMappingsPart := WrkbkWriter.AddCustomXmlMappingsPart;
        CustomXMLMappingsPart.MapInfo := MapInfo;
    end;

    local procedure CreateSchemaConnection(var WrkbkWriter: dotnet WorkbookWriter;SetupDataFileName: Text)
    var
        ConnectionsPart: dotnet ConnectionsPart;
        Connections: dotnet Connections;
        Connection: dotnet Connection;
        UInt32Value: dotnet UInt32Value;
        StringValue: dotnet StringValue;
        BooleanTrueValue: dotnet BooleanValue;
        WebQueryProperties: dotnet WebQueryProperties;
        ByteValue: dotnet ByteValue;
    begin
        ConnectionsPart := WrkbkWriter.AddConnectionsPart;
        Connections := Connections.Connections;
        Connection := WrkbkWriter.CreateConnection(1);
        UInt32Value := UInt32Value.UInt32Value;
        Connection.Name := StringValue.StringValue(FileMgt.GetFileName(SetupDataFileName));
        UInt32Value.Value := 4;
        Connection.Type := UInt32Value;
        BooleanTrueValue := BooleanTrueValue.BooleanValue(true);
        Connection.Background := BooleanTrueValue;
        ByteValue := ByteValue.ByteValue;
        ByteValue.Value := 0;
        Connection.RefreshedVersion := ByteValue;
        WebQueryProperties := WebQueryProperties.WebQueryProperties;
        WebQueryProperties.XmlSource := BooleanTrueValue;
        WebQueryProperties.SourceData := BooleanTrueValue;
        WebQueryProperties.Url := StringValue.StringValue(SetupDataFileName);
        WebQueryProperties.HtmlTables := BooleanTrueValue;
        WrkShtHelper.AppendElementToOpenXmlElement(Connection,WebQueryProperties);
        WrkShtHelper.AppendElementToOpenXmlElement(Connections,Connection);
        ConnectionsPart.Connections := Connections;
    end;

    local procedure AddSingleXMLCellProperties(var SingleXMLCell: dotnet SingleXmlCell;CellReference: Text;XPath: Text;Mapid: Integer;ConnectionId: Integer)
    var
        XMLCellProperties: dotnet XmlCellProperties;
        XMLProperties: dotnet XmlProperties;
        UInt32Value: dotnet UInt32Value;
        StringValue: dotnet StringValue;
        XmlDataValues: dotnet XmlDataValues;
        WrkShtWriter2: dotnet WorksheetWriter;
    begin
        StringValue := StringValue.StringValue(CellReference);
        SingleXMLCell.CellReference := StringValue;
        UInt32Value := UInt32Value.UInt32Value;
        UInt32Value.Value := ConnectionId;
        SingleXMLCell.ConnectionId := UInt32Value;

        XMLCellProperties := XMLCellProperties.XmlCellProperties;
        WrkShtHelper.AppendElementToOpenXmlElement(SingleXMLCell,XMLCellProperties);
        UInt32Value.Value := 1;
        XMLCellProperties.Id := UInt32Value;
        StringValue := StringValue.StringValue(Format(SingleXMLCell.Id));
        XMLCellProperties.UniqueName := StringValue;

        XMLProperties := XMLProperties.XmlProperties;
        WrkShtHelper.AppendElementToOpenXmlElement(XMLCellProperties,XMLProperties);
        UInt32Value.Value := Mapid;
        XMLProperties.MapId := UInt32Value;
        StringValue := StringValue.StringValue(XPath);
        XMLProperties.XPath := StringValue;
        XmlDataValues := XmlDataValues.String;

        XMLProperties.XmlDataType := WrkShtWriter2.GetEnumXmlDataValues(XmlDataValues);
    end;

    local procedure SetCellComment(WrkShtWriter: dotnet WorksheetWriter;CellReference: Text;CommentValue: Text)
    var
        Comment: dotnet Comment;
        CommentText: dotnet CommentText;
        Run: dotnet Run;
        UInt32Value: dotnet UInt32Value;
        StringValue: dotnet StringValue;
        Int32Value: dotnet Int32Value;
        CommentList: dotnet CommentList;
        Comments: dotnet Comments;
        SpreadsheetText: dotnet Text;
        RunProperties: dotnet RunProperties;
        CommentsPart: dotnet WorksheetCommentsPart;
        Worksheet: dotnet Worksheet0;
        Bold: dotnet Bold;
        FontSize: dotnet FontSize;
        DoubleValue: dotnet DoubleValue;
        Color: dotnet Color;
        RunFont: dotnet RunFont;
        RunPropCharSet: dotnet RunPropertyCharSet;
    begin
        CommentsPart := WrkShtWriter.Worksheet.WorksheetPart.WorksheetCommentsPart;
        Comments := CommentsPart.Comments;

        if IsNull(Comments) then begin
          Comments := Comments.Comments;
          CommentsPart.Comments := Comments;
        end;

        CommentList := Comments.CommentList;

        if IsNull(CommentList) then
          CommentList := WrkShtWriter.CreateCommentList(Comments);

        Comment := Comment.Comment;
        Comment.AuthorId := UInt32Value.FromUInt32(0);
        Comment.Reference := StringValue.StringValue(CellReference);

        CommentText := CommentText.CommentText;

        Run := Run.Run;

        RunProperties := RunProperties.RunProperties;
        Bold := Bold.Bold;

        FontSize := FontSize.FontSize;
        FontSize.Val := DoubleValue.FromDouble(9);

        Color := Color.Color;
        Color.Indexed := UInt32Value.FromUInt32(81);

        RunFont := RunFont.RunFont;
        RunFont.Val := StringValue.FromString('Tahoma');

        RunPropCharSet := RunPropCharSet.RunPropertyCharSet;
        RunPropCharSet.Val := Int32Value.FromInt32(1);

        WrkShtHelper.AppendElementToOpenXmlElement(RunProperties,Bold);
        WrkShtHelper.AppendElementToOpenXmlElement(RunProperties,FontSize);
        WrkShtHelper.AppendElementToOpenXmlElement(RunProperties,Color);
        WrkShtHelper.AppendElementToOpenXmlElement(RunProperties,RunFont);
        WrkShtHelper.AppendElementToOpenXmlElement(RunProperties,RunPropCharSet);

        SpreadsheetText := WrkShtWriter.AddText(CommentValue);
        SpreadsheetText.Text := CommentValue;

        WrkShtHelper.AppendElementToOpenXmlElement(Run,RunProperties);
        WrkShtHelper.AppendElementToOpenXmlElement(Run,SpreadsheetText);

        WrkShtHelper.AppendElementToOpenXmlElement(CommentText,Run);
        Comment.CommentText := CommentText;

        WrkShtWriter.AppendComment(CommentList,Comment);

        CommentsPart.Comments.Save;
        WrkShtWriter.Worksheet.Save;
        Worksheet := WrkShtWriter.Worksheet;
    end;

    local procedure CreateSchemaFile(var ConfigPackageTable: Record "Config. Package Table"): Text
    var
        ConfigDataSchema: XmlPort "Config. Data Schema";
        OStream: OutStream;
        TempSchemaFile: File;
        TempSchemaFileName: Text;
    begin
        TempSchemaFile.CreateTempfile;
        TempSchemaFileName := TempSchemaFile.Name + '.xsd';
        TempSchemaFile.Close;
        TempSchemaFile.Create(TempSchemaFileName);
        TempSchemaFile.CreateOutstream(OStream);
        ConfigDataSchema.SetDestination(OStream);
        ConfigDataSchema.SetTableview(ConfigPackageTable);
        if not ConfigDataSchema.Export then
          Error(CannotCreateXmlSchemaErr);
        TempSchemaFile.Close;
        exit(TempSchemaFileName);
    end;

    local procedure CreateXMLPackage(TempSetupDataFileName: Text;ExportFromWksht: Boolean;var ConfigPackageTable: Record "Config. Package Table"): Text
    begin
        Clear(ConfigXMLExchange);
        ConfigXMLExchange.SetExcelMode(true);
        ConfigXMLExchange.SetCalledFromCode(true);
        ConfigXMLExchange.SetPrefixMode(true);
        ConfigXMLExchange.SetExportFromWksht(ExportFromWksht);
        ConfigXMLExchange.ExportPackageXML(ConfigPackageTable,TempSetupDataFileName);
        ConfigXMLExchange.SetExcelMode(false);
        exit(TempSetupDataFileName);
    end;

    local procedure CreateTableColumnNames(var ConfigPackageField: Record "Config. Package Field";var ConfigPackageTable: Record "Config. Package Table";TableColumns: dotnet TableColumns)
    var
        "Field": Record "Field";
        Dimension: Record Dimension;
        XmlColumnProperties: dotnet XmlColumnProperties;
        TableColumn: dotnet TableColumn;
        WrkShtWriter2: dotnet WorksheetWriter;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        TableColumnName: Text;
        ColumnID: Integer;
    begin
        RecRef.Open(ConfigPackageTable."Table ID");
        ConfigPackageField.SetCurrentkey("Package Code","Table ID","Processing Order");
        if ConfigPackageField.FindSet then begin
          ColumnID := 1;
          repeat
            if Field.Get(ConfigPackageField."Table ID",ConfigPackageField."Field ID") or ConfigPackageField.Dimension then begin
              if ConfigPackageField.Dimension then
                TableColumnName := ConfigPackageField."Field Caption" + ' ' + StrSubstNo('(%1)',Dimension.TableCaption)
              else
                TableColumnName := ConfigPackageField."Field Caption";
              XmlColumnProperties := WrkShtWriter2.CreateXmlColumnProperties(
                  1,
                  '/DataList/' + (ConfigXMLExchange.GetElementName(ConfigPackageTable."Table Caption") + 'List') +
                  '/' + ConfigXMLExchange.GetElementName(ConfigPackageTable."Table Caption") +
                  '/' + ConfigXMLExchange.GetElementName(ConfigPackageField."Field Caption"),
                  WrkShtWriter.XmlDataType2XmlDataValues(
                    ConfigXMLExchange.GetXSDType(ConfigPackageTable."Table ID",ConfigPackageField."Field ID")));
              TableColumn := WrkShtWriter.CreateTableColumn(
                  ColumnID,
                  TableColumnName,
                  ConfigXMLExchange.GetElementName(ConfigPackageField."Field Caption"));
              WrkShtHelper.AppendElementToOpenXmlElement(TableColumn,XmlColumnProperties);
              WrkShtHelper.AppendElementToOpenXmlElement(TableColumns,TableColumn);
              WrkShtWriter.SetCellValueText(3,GetXLColumnID(ColumnID),TableColumnName,WrkShtWriter.DefaultCellDecorator);
              if not ConfigPackageField.Dimension then begin
                FieldRef := RecRef.Field(ConfigPackageField."Field ID");
                SetCellComment(WrkShtWriter,GetXLColumnID(ColumnID) + '3',ConfigValidateMgt.AddComment(FieldRef));
                CreateCommentVmlShapeXml(ColumnID,3);
              end;
            end;
            ColumnID += 1;
          until ConfigPackageField.Next = 0;
        end;
        RecRef.Close;
    end;

    local procedure CleanMapInfo(MapInfo: dotnet MapInfo)
    var
        MapInfoString: Text;
    begin
        MapInfoString :=
          ReplaceSubString(
            Format(MapInfo.OuterXml),
            '<x:MapInfo SelectionNamespaces="" xmlns:x="http://schemas.openxmlformats.org/spreadsheetml/2006/main">',
            '');
        MapInfoString := ReplaceSubString(MapInfoString,'</x:MapInfo>','');
        MapInfoString := ReplaceSubString(MapInfoString,'x:','');
        MapInfo.InnerXml(MapInfoString);
    end;

    local procedure ReplaceSubString(String: Text;Old: Text;New: Text): Text
    var
        Pos: Integer;
    begin
        Pos := StrPos(String,Old);
        while Pos <> 0 do begin
          String := DelStr(String,Pos,StrLen(Old));
          String := InsStr(String,New,Pos);
          Pos := StrPos(String,Old);
        end;
        exit(String);
    end;

    local procedure WriteCellValue(var WrkShtWriter: dotnet WorksheetWriter;DataColumnDataType: Text;var DataRow: dotnet DataRow;RowsCount: Integer;ColumnsCount: Integer)
    begin
        case DataColumnDataType of
          'System.DateTime':
            WrkShtWriter.SetCellValueDate(RowsCount + 4,GetXLColumnID(ColumnsCount + 1),DataRow.Item(ColumnsCount),'',
              WrkShtWriter.DefaultCellDecorator);
          'System.Time':
            WrkShtWriter.SetCellValueTime(RowsCount + 4,GetXLColumnID(ColumnsCount + 1),DataRow.Item(ColumnsCount),'',
              WrkShtWriter.DefaultCellDecorator);
          'System.Boolean':
            WrkShtWriter.SetCellValueBoolean(RowsCount + 4,GetXLColumnID(ColumnsCount + 1),DataRow.Item(ColumnsCount),
              WrkShtWriter.DefaultCellDecorator);
          'System.Integer','System.Int32':
            WrkShtWriter.SetCellValueNumber(RowsCount + 4,GetXLColumnID(ColumnsCount + 1),Format(DataRow.Item(ColumnsCount)),'',
              WrkShtWriter.DefaultCellDecorator);
          else
            WrkShtWriter.SetCellValueText(RowsCount + 4,GetXLColumnID(ColumnsCount + 1),DataRow.Item(ColumnsCount),
              WrkShtWriter.DefaultCellDecorator);
        end;
    end;

    local procedure ExtractXMLSchema(WorkBookPart: dotnet WorkbookPart) XMLSchemaDataFile: Text
    var
        XMLWriter: dotnet XmlWriter;
    begin
        XMLSchemaDataFile := FileMgt.ServerTempFileName('');
        XMLWriter := XMLWriter.Create(XMLSchemaDataFile);
        WorkBookPart.CustomXmlMappingsPart.MapInfo.FirstChild.FirstChild.WriteTo(XMLWriter);
        XMLWriter.Close;
    end;

    local procedure CreateTableStyleInfo(var TableStyleInfo: dotnet TableStyleInfo)
    var
        BooleanValue: dotnet BooleanValue;
        StringValue: dotnet StringValue;
    begin
        TableStyleInfo.Name := StringValue.StringValue('TableStyleMedium2');
        TableStyleInfo.ShowFirstColumn := BooleanValue.BooleanValue(false);
        TableStyleInfo.ShowLastColumn := BooleanValue.BooleanValue(false);
        TableStyleInfo.ShowRowStripes := BooleanValue.BooleanValue(true);
        TableStyleInfo.ShowColumnStripes := BooleanValue.BooleanValue(false);
    end;

    local procedure CreateCommentVmlShapeXml(ColId: Integer;RowId: Integer)
    var
        Guid: Guid;
        Anchor: Text;
        CommentShape: Text;
    begin
        Guid := CreateGuid;

        Anchor := CreateCommentVmlAnchor(ColId,RowId);

        CommentShape := StrSubstNo(CommentVmlShapeXmlTxt,Guid,Anchor,RowId - 1,ColId - 1);

        StringBld.Append(CommentShape);
    end;

    local procedure CreateCommentVmlAnchor(ColId: Integer;RowId: Integer): Text
    begin
        exit(StrSubstNo(VmlShapeAnchorTxt,ColId,RowId - 2,ColId + 2));
    end;

    local procedure AddVmlDrawingPart(var VmlDrawingPart: dotnet VmlDrawingPart)
    var
        StringValue: dotnet StringValue;
        LegacyDrawing: dotnet LegacyDrawing;
        VmlPartId: Text;
    begin
        VmlDrawingPart := WrkShtWriter.CreateVmlDrawingPart;
        VmlPartId := Worksheet.WorksheetPart.GetIdOfPart(VmlDrawingPart);
        LegacyDrawing := LegacyDrawing.LegacyDrawing;
        LegacyDrawing.Id := StringValue.FromString(VmlPartId);
        WrkShtHelper.AppendElementToOpenXmlElement(Worksheet.WorksheetPart.Worksheet,LegacyDrawing);
    end;

    local procedure AddPackageAndTableInformation(var ConfigPackageTable: Record "Config. Package Table";var SingleXMLCells: dotnet SingleXmlCells)
    var
        SingleXMLCell: dotnet SingleXmlCell;
        RecRef: RecordRef;
        TableCaptionString: Text;
    begin
        // Add package name
        SingleXMLCell := WrkShtWriter.AddSingleXmlCell(id);
        WrkShtHelper.AppendElementToOpenXmlElement(SingleXMLCells,SingleXMLCell);
        AddSingleXMLCellProperties(SingleXMLCell,'A1','/DataList/' +
          (ConfigXMLExchange.GetElementName(ConfigPackageTable."Table Caption") + 'List') + '/' +
          ConfigXMLExchange.GetElementName(ConfigPackageTable.FieldName("Package Code")),1,1);
        WrkShtWriter.SetCellValueText(1,'A',ConfigPackageTable."Package Code",WrkShtWriter.DefaultCellDecorator);

        // Add Table name
        RecRef.Open(ConfigPackageTable."Table ID");
        TableCaptionString := RecRef.Caption;
        RecRef.Close;
        WrkShtWriter.SetCellValueText(1,'B',TableCaptionString,WrkShtWriter.DefaultCellDecorator);

        // Add Table id
        id += 1;
        SingleXMLCell := WrkShtWriter.AddSingleXmlCell(id);
        WrkShtHelper.AppendElementToOpenXmlElement(SingleXMLCells,SingleXMLCell);

        AddSingleXMLCellProperties(SingleXMLCell,'C1','/DataList/' +
          (ConfigXMLExchange.GetElementName(ConfigPackageTable."Table Caption") + 'List') + '/' +
          ConfigXMLExchange.GetElementName(ConfigPackageTable.FieldName("Table ID")),1,1);
        WrkShtWriter.SetCellValueText(1,'C',Format(ConfigPackageTable."Table ID"),WrkShtWriter.DefaultCellDecorator);
    end;

    local procedure CopyDataToExcelTable()
    var
        DataRow: dotnet DataRow;
        DataTableRowsCount: Integer;
        RowsCount: Integer;
        ColumnsCount: Integer;
        DataTableColumnsCount: Integer;
    begin
        DataTableRowsCount := DataTable.Rows.Count;
        RowsCount := 0;
        DataTableColumnsCount := DataTable.Columns.Count;
        repeat
          DataRow := DataTable.Rows.Item(RowsCount);
          ColumnsCount := 0;
          repeat
            DataColumn := DataTable.Columns.Item(ColumnsCount);
            WriteCellValue(WrkShtWriter,Format(DataColumn.DataType),DataRow,RowsCount,ColumnsCount);
            ColumnsCount += 1;
          until ColumnsCount = DataTableColumnsCount - 1;
          RowsCount += 1;
        until RowsCount = DataTableRowsCount;
    end;

    local procedure BuildDataSetForPackageTable(ExportFromWksht: Boolean;var ConfigPackageTable: Record "Config. Package Table"): Text
    var
        TempSetupDataFileName: Text;
    begin
        TempSetupDataFileName := CreateXMLPackage(FileMgt.ServerTempFileName(''),ExportFromWksht,ConfigPackageTable);
        DataSet := DataSet.DataSet;
        DataSet.ReadXml(TempSetupDataFileName);
        exit(TempSetupDataFileName);
    end;

    local procedure AddAndInitializeCommentsPart(var VmlDrawingPart: dotnet VmlDrawingPart)
    var
        WorkSheetCommentsPart: dotnet WorksheetCommentsPart;
        Comments: dotnet Comments;
    begin
        WorkSheetCommentsPart := WrkShtWriter.CreateWorksheetCommentsPart;
        AddVmlDrawingPart(VmlDrawingPart);

        if IsNull(WorkSheetCommentsPart.Comments) then
          WorkSheetCommentsPart.Comments := Comments.Comments;

        AddWorkSheetAuthor(WorkSheetCommentsPart.Comments,UserId);

        WrkShtWriter.CreateCommentList(WorkSheetCommentsPart.Comments);
    end;

    local procedure AddAndInitializeTableDefinitionPart(var ConfigPackageTable: Record "Config. Package Table";ExportFromWksht: Boolean;DataTableCounter: Integer;var TableDefinitionPart: dotnet TableDefinitionPart;SkipData: Boolean)
    var
        ConfigPackageField: Record "Config. Package Field";
        TableColumns: dotnet TableColumns;
        "Table": dotnet Table;
        TableStyleInfo: dotnet TableStyleInfo;
        BooleanValue: dotnet BooleanValue;
        AutoFilter: dotnet AutoFilter;
        StringValue: dotnet StringValue;
        RowsCount: Integer;
    begin
        TableDefinitionPart := WrkShtWriter.CreateTableDefinitionPart;
        ConfigPackageField.Reset;
        ConfigPackageField.SetRange("Package Code",ConfigPackageTable."Package Code");
        ConfigPackageField.SetRange("Table ID",ConfigPackageTable."Table ID");
        ConfigPackageField.SetRange("Include Field",true);
        if not ExportFromWksht then
          ConfigPackageField.SetRange(Dimension,false);

        DataTable := DataSet.Tables.Item(DataTableCounter);

        id += 1;
        if SkipData then
          RowsCount := 1
        else
          RowsCount := DataTable.Rows.Count;
        Table := WrkShtWriter.CreateTable(id);
        Table.TotalsRowShown := BooleanValue.BooleanValue(false);
        Table.Reference := StringValue.StringValue('A3:' +
            GetXLColumnID(ConfigPackageField.Count) + Format(RowsCount + 3));
        Table.Name := StringValue.StringValue('Table' + Format(id));
        Table.DisplayName := StringValue.StringValue('Table' + Format(id));
        AutoFilter := AutoFilter.AutoFilter;
        AutoFilter.Reference :=
          StringValue.StringValue('A3:' + GetXLColumnID(ConfigPackageField.Count) + Format(RowsCount + 3));
        WrkShtHelper.AppendElementToOpenXmlElement(Table,AutoFilter);
        TableColumns := WrkShtWriter.CreateTableColumns(ConfigPackageField.Count);

        CreateTableColumnNames(ConfigPackageField,ConfigPackageTable,TableColumns);
        WrkShtHelper.AppendElementToOpenXmlElement(Table,TableColumns);
        TableStyleInfo := TableStyleInfo.TableStyleInfo;
        CreateTableStyleInfo(TableStyleInfo);
        WrkShtHelper.AppendElementToOpenXmlElement(Table,TableStyleInfo);
        TableDefinitionPart.Table := Table;
    end;

    [TryFunction]
    local procedure GetDataTable(TableId: Integer)
    begin
        DataTable := DataSet.Tables.Item(TableId);
    end;

    local procedure InitColumnMapping(WrkShtReader: dotnet WorksheetReader;var TempXMLBuffer: Record "XML Buffer" temporary): Boolean
    var
        "Table": dotnet Table;
        TableColumn: dotnet TableColumn;
        Enumerable: dotnet IEnumerable;
        Enumerator: dotnet IEnumerator;
        XmlColumnProperties: dotnet XmlColumnProperties;
        OpenXmlElement: dotnet OpenXmlElement;
        TableStartColumnIndex: Integer;
        Index: Integer;
    begin
        TempXMLBuffer.DeleteAll;
        if not FindTableDefinition(WrkShtReader,Table) then
          exit(false);

        TableStartColumnIndex := GetTableStartColumnIndex(Table);
        Index := 0;
        Enumerable := Table.TableColumns;
        Enumerator := Enumerable.GetEnumerator;
        while Enumerator.MoveNext do begin
          TableColumn := Enumerator.Current;
          XmlColumnProperties := TableColumn.XmlColumnProperties;
          if not IsNull(XmlColumnProperties) then begin
            OpenXmlElement := XmlColumnProperties.XPath; // identifies column to xsd mapping.
            if not IsNull(OpenXmlElement) then
              InsertXMLBuffer(Index + TableStartColumnIndex,TempXMLBuffer);
          end;
          Index += 1;
        end;

        // RowCount > 2 means sheet has datarow(s)
        exit(WrkShtReader.RowCount > 2);
    end;

    local procedure FindTableDefinition(WrkShtReader: dotnet WorksheetReader;var "Table": dotnet Table): Boolean
    var
        TableDefinitionPart: dotnet TableDefinitionPart;
        Enumerable: dotnet IEnumerable;
        Enumerator: dotnet IEnumerator;
    begin
        Enumerable := WrkShtReader.Worksheet.WorksheetPart.TableDefinitionParts;
        Enumerator := Enumerable.GetEnumerator;
        Enumerator.MoveNext;
        TableDefinitionPart := Enumerator.Current;

        if IsNull(TableDefinitionPart) then
          exit(false);

        Table := TableDefinitionPart.Table;
        exit(true);
    end;

    local procedure GetTableStartColumnIndex("Table": dotnet Table): Integer
    var
        String: dotnet String;
        Index: Integer;
        Length: Integer;
        ColumnIndex: Integer;
    begin
        // <x:table id="5" ... ref="A3:E6" ...>
        // table.Reference = "A3:E6" (A3 - top left table corner, E6 - bottom right corner)
        // we convert "A" - to column index
        String := Table.Reference.Value;
        Length := String.IndexOf(':');
        String := DelChr(String.Substring(0,Length),'=','0123456789');
        Length := String.Length - 1;
        for Index := 0 to Length do
          ColumnIndex += (String.Chars(Index) - 64) + Index * 26;
        exit(ColumnIndex);
    end;

    local procedure InsertXMLBuffer(ColumnIndex: Integer;var TempXMLBuffer: Record "XML Buffer" temporary)
    begin
        TempXMLBuffer.Init;
        TempXMLBuffer."Entry No." := ColumnIndex; // column index in table definition
        TempXMLBuffer."Parent Entry No." := TempXMLBuffer.Count; // column index in dataset
        TempXMLBuffer.Insert;
    end;
}

