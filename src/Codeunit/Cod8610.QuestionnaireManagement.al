#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 8610 "Questionnaire Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'The value of the key field %1 has not been filled in for questionnaire %2.';
        XMLDOMMgt: Codeunit "XML DOM Management";
        ConfigProgressBar: Codeunit "Config. Progress Bar";
        ConfigValidateMgt: Codeunit "Config. Validate Management";
        FileMgt: Codeunit "File Management";
        Text001: label 'Exporting questionnaire';
        Text002: label 'Importing questionnaire';
        Text005: label 'Could not create the XML schema.';
        Text007: label 'Applying answers';
        Text008: label 'Updating questionnaire';
        Text019: label 'Could not create an Excel instance.';
        Text020: label 'Excel does not contain an XML schema.';
        Text022: label 'Creating Excel worksheet';
        [RunOnClient]
        XlApp: dotnet ApplicationClass;
        [RunOnClient]
        XlBook: dotnet WorkbookClass;
        [RunOnClient]
        XlSheet: dotnet WorksheetClass;
        [RunOnClient]
        WrkBkWriter: dotnet WorkbookWriter;
        [RunOnClient]
        XlHelper: dotnet ExcelHelper;
        ExportToExcel: Boolean;
        Text024: label 'Download';
        Text025: label '*.*|*.*';
        Text026: label 'Default';
        CalledFromCode: Boolean;
        Text028: label 'Import File';
        Text029: label 'XML file (*.xml)|*.xml', Comment='Only translate ''XML Files'' {Split=r"[\|\(]\*\.[^ |)]*[|) ]?"}';


    procedure UpdateQuestions(ConfigQuestionArea: Record "Config. Question Area")
    var
        ConfigQuestion: Record "Config. Question";
        "Field": Record "Field";
        ConfigPackageMgt: Codeunit "Config. Package Management";
        NextQuestionNo: Integer;
    begin
        if ConfigQuestionArea."Table ID" = 0 then
          exit;

        ConfigQuestion.SetRange("Questionnaire Code",ConfigQuestionArea."Questionnaire Code");
        ConfigQuestion.SetRange("Question Area Code",ConfigQuestionArea.Code);
        if ConfigQuestion.FindLast then
          NextQuestionNo := ConfigQuestion."No." + 1
        else
          NextQuestionNo := 1;

        ConfigPackageMgt.SetFieldFilter(Field,ConfigQuestionArea."Table ID",0);
        if Field.FindSet then
          repeat
            ConfigQuestion.Init;
            ConfigQuestion."Questionnaire Code" := ConfigQuestionArea."Questionnaire Code";
            ConfigQuestion."Question Area Code" := ConfigQuestionArea.Code;
            ConfigQuestion."No." := NextQuestionNo;
            ConfigQuestion."Table ID" := ConfigQuestionArea."Table ID";
            ConfigQuestion."Field ID" := Field."No.";
            if not QuestionExist(ConfigQuestion) then begin
              UpdateQuestion(ConfigQuestion);
              ConfigQuestion."Answer Option" := BuildAnswerOption(ConfigQuestionArea."Table ID",Field."No.");
              ConfigQuestion.Insert;
              NextQuestionNo := NextQuestionNo + 1;
            end;
          until Field.Next = 0;
    end;

    local procedure UpdateQuestion(var ConfigQuestion: Record "Config. Question")
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        with ConfigQuestion do begin
          if Question <> '' then
            exit;
          if "Table ID" = 0 then
            exit;
          RecRef.Open("Table ID");
          FieldRef := RecRef.Field("Field ID");
          Question := FieldRef.Caption + '?';
        end;
    end;


    procedure UpdateQuestionnaire(ConfigQuestionnaire: Record "Config. Questionnaire"): Boolean
    var
        ConfigQuestionArea: Record "Config. Question Area";
    begin
        if ConfigQuestionnaire.Code = '' then
          exit;

        ConfigQuestionArea.Reset;
        ConfigQuestionArea.SetRange("Questionnaire Code",ConfigQuestionnaire.Code);
        if ConfigQuestionArea.FindSet then begin
          ConfigProgressBar.Init(ConfigQuestionArea.Count,1,Text008);
          repeat
            ConfigProgressBar.Update(ConfigQuestionArea.Code);
            UpdateQuestions(ConfigQuestionArea);
          until ConfigQuestionArea.Next = 0;
          ConfigProgressBar.Close;
          exit(true);
        end;
        exit(false);
    end;

    local procedure QuestionExist(ConfigQuestion: Record "Config. Question"): Boolean
    var
        ConfigQuestion2: Record "Config. Question";
    begin
        ConfigQuestion2.Reset;
        ConfigQuestion2.SetCurrentkey("Questionnaire Code","Question Area Code","Field ID");
        ConfigQuestion2.SetRange("Questionnaire Code",ConfigQuestion."Questionnaire Code");
        ConfigQuestion2.SetRange("Question Area Code",ConfigQuestion."Question Area Code");
        ConfigQuestion2.SetRange("Field ID",ConfigQuestion."Field ID");
        exit(not ConfigQuestion2.IsEmpty);
    end;


    procedure BuildAnswerOption(TableID: Integer;FieldID: Integer): Text[250]
    var
        "Field": Record "Field";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        BooleanText: Text[30];
    begin
        Field.SetRange(TableNo,TableID);
        Field.SetRange("No.",FieldID);

        if not Field.FindFirst then
          exit;

        case Field.Type of
          Field.Type::Option:
            begin
              RecRef.Open(Field.TableNo);
              FieldRef := RecRef.Field(Field."No.");
              exit(FieldRef.OptionCaption);
            end;
          Field.Type::Boolean:
            begin
              BooleanText := Format(true) + ',' + Format(false);
              exit(BooleanText)
            end;
          else
            exit(Format(Field.Type));
        end;
    end;


    procedure ApplyAnswers(ConfigQuestionnaire: Record "Config. Questionnaire"): Boolean
    var
        ConfigQuestionArea: Record "Config. Question Area";
    begin
        ConfigQuestionArea.Reset;
        ConfigQuestionArea.SetRange("Questionnaire Code",ConfigQuestionnaire.Code);
        if ConfigQuestionArea.FindSet then begin
          ConfigProgressBar.Init(ConfigQuestionArea.Count,1,Text007);
          repeat
            ConfigProgressBar.Update(ConfigQuestionArea.Code);
            ApplyAnswer(ConfigQuestionArea);
          until ConfigQuestionArea.Next = 0;
          ConfigProgressBar.Close;
          exit(true);
        end;
        exit(false);
    end;


    procedure ApplyAnswer(ConfigQuestionArea: Record "Config. Question Area")
    var
        RecRef: RecordRef;
    begin
        if ConfigQuestionArea."Table ID" = 0 then
          exit;

        RecRef.Open(ConfigQuestionArea."Table ID");
        RecRef.Init;

        InsertRecordWithKeyFields(RecRef,ConfigQuestionArea);
        ModifyRecordWithOtherFields(RecRef,ConfigQuestionArea);
    end;

    local procedure InsertRecordWithKeyFields(var RecRef: RecordRef;ConfigQuestionArea: Record "Config. Question Area")
    var
        ConfigQuestion: Record "Config. Question";
        RecRef1: RecordRef;
        KeyRef: KeyRef;
        FieldRef: FieldRef;
        KeyFieldCount: Integer;
    begin
        ConfigQuestion.SetRange("Questionnaire Code",ConfigQuestionArea."Questionnaire Code");
        ConfigQuestion.SetRange("Question Area Code",ConfigQuestionArea.Code);

        KeyRef := RecRef.KeyIndex(1);
        for KeyFieldCount := 1 to KeyRef.FieldCount do begin
          FieldRef := KeyRef.FieldIndex(KeyFieldCount);
          ConfigQuestion.SetRange("Field ID",FieldRef.Number);
          if ConfigQuestion.FindFirst then begin
            ConfigValidateMgt.ValidateFieldValue(RecRef,FieldRef,ConfigQuestion.Answer,false,GlobalLanguage);
          end else
            if KeyRef.FieldCount <> 1 then
              Error(StrSubstNo(Text000,FieldRef.Name,ConfigQuestionArea.Code));
        end;

        RecRef1 := RecRef.Duplicate;

        if RecRef1.Find then begin
          RecRef := RecRef1;
          exit
        end;

        RecRef.Insert(true);
    end;

    local procedure ModifyRecordWithOtherFields(var RecRef: RecordRef;ConfigQuestionArea: Record "Config. Question Area")
    var
        ConfigQuestion: Record "Config. Question";
        TempConfigPackageField: Record "Config. Package Field" temporary;
        ConfigPackageManagement: Codeunit "Config. Package Management";
        FieldRef: FieldRef;
        ErrorText: Text[250];
    begin
        ConfigQuestion.SetRange("Questionnaire Code",ConfigQuestionArea."Questionnaire Code");
        ConfigQuestion.SetRange("Question Area Code",ConfigQuestionArea.Code);

        if ConfigQuestion.FindSet then
          repeat
            TempConfigPackageField.DeleteAll;
            if ConfigQuestion.Answer <> '' then begin
              FieldRef := RecRef.Field(ConfigQuestion."Field ID");
              ConfigValidateMgt.ValidateFieldValue(RecRef,FieldRef,ConfigQuestion.Answer,false,GlobalLanguage);
              ConfigPackageManagement.GetFieldsOrder(RecRef,'',TempConfigPackageField);
              ErrorText := ConfigValidateMgt.ValidateFieldRefRelationAgainstCompanyData(FieldRef,TempConfigPackageField);
              if ErrorText <> '' then
                Error(ErrorText);
            end;
          until ConfigQuestion.Next = 0;
        RecRef.Modify(true);
    end;


    procedure ExportQuestionnaireAsXML(XMLDataFile: Text;var ConfigQuestionnaire: Record "Config. Questionnaire"): Boolean
    var
        QuestionnaireXML: dotnet XmlDocument;
        ToFile: Text[1024];
        FileName: Text;
        Exported: Boolean;
    begin
        QuestionnaireXML := QuestionnaireXML.XmlDocument;

        GenerateQuestionnaireXMLDocument(QuestionnaireXML,ConfigQuestionnaire);

        Exported := true;
        if not ExportToExcel then begin
          FileName := XMLDataFile;
          ToFile := Text026 + '.xml';

          if not CalledFromCode then
            FileName := FileMgt.ServerTempFileName('.xml');
          QuestionnaireXML.Save(FileName);
          if not CalledFromCode then
            Exported := FileMgt.DownloadHandler(FileName,Text024,'',Text025,ToFile);
        end else begin
          FileName := XMLDataFile;
          QuestionnaireXML.Save(FileName);
        end;

        exit(Exported);
    end;


    procedure GenerateQuestionnaireXMLDocument(QuestionnaireXML: dotnet XmlDocument;var ConfigQuestionnaire: Record "Config. Questionnaire")
    var
        ConfigQuestionArea: Record "Config. Question Area";
        RecRef: RecordRef;
        DocumentNode: dotnet XmlNode;
    begin
        XMLDOMMgt.LoadXMLDocumentFromText(
          '<?xml version="1.0" encoding="UTF-16" standalone="yes"?><Questionnaire></Questionnaire>',QuestionnaireXML);

        DocumentNode := QuestionnaireXML.DocumentElement;

        RecRef.GetTable(ConfigQuestionnaire);
        CreateFieldSubtree(RecRef,DocumentNode);

        ConfigQuestionArea.SetRange("Questionnaire Code",ConfigQuestionnaire.Code);
        if ConfigQuestionArea.FindSet then begin
          ConfigProgressBar.Init(ConfigQuestionArea.Count,1,Text001);
          repeat
            ConfigProgressBar.Update(ConfigQuestionArea.Code);
            CreateQuestionNodes(QuestionnaireXML,ConfigQuestionArea);
          until ConfigQuestionArea.Next = 0;
          ConfigProgressBar.Close;
        end;
    end;


    procedure ImportQuestionnaireAsXMLFromClient(): Boolean
    var
        ServerFileName: Text;
    begin
        ServerFileName := FileMgt.ServerTempFileName('.xml');
        if Upload(Text028,'',Text029,'',ServerFileName) then
          exit(ImportQuestionnaireAsXML(ServerFileName));

        exit(false);
    end;


    procedure ImportQuestionnaireAsXML(XMLDataFile: Text): Boolean
    var
        QuestionnaireXML: dotnet XmlDocument;
    begin
        XMLDOMMgt.LoadXMLDocumentFromFile(XMLDataFile,QuestionnaireXML);

        exit(ImportQuestionnaireXMLDocument(QuestionnaireXML));
    end;


    procedure ImportQuestionnaireXMLDocument(QuestionnaireXML: dotnet XmlDocument): Boolean
    var
        ConfigQuestionnaire: Record "Config. Questionnaire";
        ConfigQuestionArea: Record "Config. Question Area";
        ConfigQuestion: Record "Config. Question";
        QuestionAreaNodes: dotnet XmlNodeList;
        QuestionAreaNode: dotnet XmlNode;
        QuestionNodes: dotnet XmlNodeList;
        QuestionnaireNode: dotnet XmlNode;
        AreaNodeCount: Integer;
        NodeCount: Integer;
    begin
        QuestionnaireNode := QuestionnaireXML.SelectSingleNode('//Questionnaire');

        UpdateInsertQuestionnaireField(ConfigQuestionnaire,QuestionnaireNode);
        QuestionAreaNodes := QuestionnaireNode.SelectNodes('child::*[position() >= 3]');

        ConfigProgressBar.Init(QuestionAreaNodes.Count,1,Text002);

        for AreaNodeCount := 0 to QuestionAreaNodes.Count - 1 do begin
          QuestionAreaNode := QuestionAreaNodes.Item(AreaNodeCount);
          ConfigProgressBar.Update(GetNodeValue(QuestionAreaNode,'Code'));
          ConfigQuestionArea."Questionnaire Code" := ConfigQuestionnaire.Code;
          UpdateInsertQuestionAreaFields(ConfigQuestionArea,QuestionAreaNode);

          QuestionNodes := QuestionAreaNode.SelectNodes('ConfigQuestion');
          for NodeCount := 0 to QuestionNodes.Count - 1 do begin
            ConfigQuestion.Init;
            ConfigQuestion."Questionnaire Code" := ConfigQuestionArea."Questionnaire Code";
            ConfigQuestion."Question Area Code" := ConfigQuestionArea.Code;
            ConfigQuestion."Table ID" := ConfigQuestionArea."Table ID";
            UpdateInsertQuestionFields(ConfigQuestion,QuestionNodes.Item(NodeCount))
          end;
        end;

        ConfigProgressBar.Close;
        exit(true);
    end;


    procedure ExportQuestionnaireToExcel(ExcelFile: Text;var ConfigQuestionnaire: Record "Config. Questionnaire"): Boolean
    var
        ConfigQuestionnaire1: Record "Config. Questionnaire";
        ConfigQuestionArea: Record "Config. Question Area";
        ConfigQuestion: Record "Config. Question";
        ConfigQuestionnaireSchema: XmlPort "Config. Questionnaire Schema";
        [RunOnClient]
        ListObject: dotnet ListObject;
        [RunOnClient]
        ListColumns: dotnet ListColumns;
        [RunOnClient]
        ListColumn: dotnet ListColumn;
        [RunOnClient]
        Range: dotnet Range;
        [RunOnClient]
        XMLMap: dotnet XmlMap;
        [RunOnClient]
        YesNo: dotnet XlYesNoGuess;
        OStream: OutStream;
        TempSchemaFile: File;
        TempConfigQuestionnaireFileName: Text;
        TempConfigQuestionnaireFNCL: Text;
        TempSchemaFileName: Text;
        TempSchemaFileNameCL: Text;
        TempXLSFile: Text;
        WrkShtNo: Integer;
    begin
        ConfigQuestionnaire1.SetRange(Code,ConfigQuestionnaire.Code);
        TempSchemaFile.CreateTempfile;
        TempSchemaFileName := TempSchemaFile.Name + '.xsd';
        TempSchemaFile.Close;

        TempSchemaFile.Create(TempSchemaFileName);
        TempSchemaFile.CreateOutstream(OStream);
        ConfigQuestionnaireSchema.SetDestination(OStream);
        ConfigQuestionnaireSchema.SetTableview(ConfigQuestionnaire1);
        if not ConfigQuestionnaireSchema.Export then
          Error(Text005);

        TempSchemaFile.Close;

        ExportToExcel := true;
        CalledFromCode := true;
        TempConfigQuestionnaireFileName := FileMgt.ServerTempFileName('');
        ExportQuestionnaireAsXML(TempConfigQuestionnaireFileName,ConfigQuestionnaire);
        ExportToExcel := false;

        TempConfigQuestionnaireFNCL := FileMgt.DownloadTempFile(TempConfigQuestionnaireFileName);
        TempSchemaFileNameCL := FileMgt.DownloadTempFile(TempSchemaFileName);
        WrkShtNo := 1;

        TempXLSFile := FileMgt.ClientTempFileName('xlsx');
        CreateBook(TempXLSFile);

        ConfigQuestionArea.SetRange("Questionnaire Code",ConfigQuestionnaire.Code);
        if ConfigQuestionArea.FindSet then
          repeat
            WrkShtNo += 1;
            WrkBkWriter.AddWorksheet(Format(WrkShtNo));
          until ConfigQuestionArea.Next = 0;
        WrkBkWriter.Close;

        OpenBook(TempXLSFile,false);
        XlApp.DisplayAlerts(false);

        XlBook.XmlMaps.Add(TempSchemaFileNameCL,'Questionnaire');
        XMLMap := XlBook.XmlMaps.Item(1);

        XlSheet := XlBook.Worksheets.Item(ConfigQuestionArea.Count + 1);

        if ConfigQuestionnaire.Description <> '' then
          XlSheet.Name := ConfigQuestionnaire.Description
        else
          XlSheet.Name := ConfigQuestionnaire.Code;

        Range := XlSheet.Range('A1');
        Range.Value := ConfigQuestionnaire.Code;
        Range.XPath.SetValue(XMLMap,'/Questionnaire/' + GetElementName(ConfigQuestionnaire.FieldName(Code)),'',false);

        Range := XlSheet.Range('B1');
        Range.Value := ConfigQuestionnaire.Description;
        Range.XPath.SetValue(XMLMap,'/Questionnaire/' + GetElementName(ConfigQuestionnaire.FieldName(Description)),'',false);

        WrkShtNo := 1;
        ConfigQuestionArea.SetRange("Questionnaire Code",ConfigQuestionnaire.Code);
        ConfigProgressBar.Init(ConfigQuestionArea.Count,1,Text022);
        if ConfigQuestionArea.FindSet then begin
          repeat
            ConfigProgressBar.Update(ConfigQuestionArea.Code);
            ConfigQuestion.SetRange("Questionnaire Code",ConfigQuestionArea."Questionnaire Code");
            ConfigQuestion.SetRange("Question Area Code",ConfigQuestionArea.Code);

            XlSheet := XlBook.Worksheets.Item(WrkShtNo);
            WrkShtNo += 1;

            if ConfigQuestionArea.Description <> '' then
              XlSheet.Name := ConfigQuestionArea.Description
            else
              if ConfigQuestionArea.Code <> ConfigQuestionArea."Questionnaire Code" then
                XlSheet.Name := ConfigQuestionArea.Code
              else
                XlSheet.Name := ConfigQuestionArea."Questionnaire Code" + ' ' + ConfigQuestionArea.Code;

            Range := XlSheet.Range('A1');
            Range.Value := ConfigQuestionArea.Code;
            Range.XPath.SetValue(XMLMap,
              '/Questionnaire/' +
              GetElementName(ConfigQuestionArea.Code) + 'Questions/' + GetElementName(ConfigQuestionArea.FieldName(Code)),
              '',false);

            Range := XlSheet.Range('B1');
            Range.Value := ConfigQuestionArea.Description;
            Range.XPath.SetValue(XMLMap,
              '/Questionnaire/' +
              GetElementName(ConfigQuestionArea.Code) + 'Questions/' + GetElementName(ConfigQuestionArea.FieldName(Description)),
              '',false);

            Range := XlSheet.Range('C1');
            Range.Value := ConfigQuestionArea."Table ID";
            Range.XPath.SetValue(XMLMap,
              '/Questionnaire/' +
              GetElementName(ConfigQuestionArea.Code) + 'Questions/' + GetElementName(ConfigQuestionArea.FieldName("Table ID")),
              '',false);

            if ConfigQuestion.FindFirst then begin
              Range := XlSheet.Range('A2',Format(GetXLColumnID(7)) + '2');

              ListObject := XlSheet.ListObjects.Add(1,Range,true,YesNo.xlNo,'');
              ListColumns := ListObject.ListColumns;

              ListColumn := ListColumns.Item(1);
              ListColumn.Name := ConfigQuestion.FieldCaption("No.");
              ListColumn.XPath.SetValue(XMLMap,
                '/Questionnaire/' +
                (GetElementName(ConfigQuestionArea.Code) + 'Questions/') +
                'ConfigQuestion/' + GetElementName(ConfigQuestion.FieldName("No.")),'',true);

              ListColumn := ListColumns.Item(2);
              ListColumn.Name := ConfigQuestion.FieldCaption(Question);
              ListColumn.XPath.SetValue(XMLMap,
                '/Questionnaire/' +
                (GetElementName(ConfigQuestionArea.Code) + 'Questions/') +
                'ConfigQuestion/' + GetElementName(ConfigQuestion.FieldName(Question)),'',true);

              ListColumn := ListColumns.Item(3);
              ListColumn.Name := ConfigQuestion.FieldCaption("Answer Option");
              ListColumn.XPath.SetValue(XMLMap,
                '/Questionnaire/' +
                (GetElementName(ConfigQuestionArea.Code) + 'Questions/') +
                'ConfigQuestion/' + GetElementName(ConfigQuestion.FieldName("Answer Option")),'',true);

              ListColumn := ListColumns.Item(4);
              ListColumn.Name := ConfigQuestion.FieldCaption(Answer);
              ListColumn.XPath.SetValue(XMLMap,
                '/Questionnaire/' +
                (GetElementName(ConfigQuestionArea.Code) + 'Questions/') +
                'ConfigQuestion/' + GetElementName(ConfigQuestion.FieldName(Answer)),'',true);

              ListColumn := ListColumns.Item(5);
              ListColumn.Name := ConfigQuestion.FieldCaption(Reference);
              ListColumn.XPath.SetValue(XMLMap,
                '/Questionnaire/' +
                (GetElementName(ConfigQuestionArea.Code) + 'Questions/') +
                'ConfigQuestion/' + GetElementName(ConfigQuestion.FieldName(Reference)),'',true);

              ListColumn := ListColumns.Item(6);
              ListColumn.Name := ConfigQuestion.FieldCaption("Field ID");
              ListColumn.XPath.SetValue(XMLMap,
                '/Questionnaire/' +
                (GetElementName(ConfigQuestionArea.Code) + 'Questions/') +
                'ConfigQuestion/' + GetElementName(ConfigQuestion.FieldName("Field ID")),'',true);

              ListColumn := ListColumns.Item(7);
              ListColumn.Name := ConfigQuestion.FieldCaption("Question Origin");
              ListColumn.XPath.SetValue(XMLMap,
                '/Questionnaire/' +
                (GetElementName(ConfigQuestionArea.Code) + 'Questions/') +
                'ConfigQuestion/' + GetElementName(ConfigQuestion.FieldName("Question Origin")),'',true);

              XMLMap.Import(TempConfigQuestionnaireFNCL,true);
            end;

            XlSheet.Columns.Range('F:F').EntireColumn.Hidden := true;
          until ConfigQuestionArea.Next = 0;
        end;

        if FileMgt.GetExtension(ExcelFile) = '' then
          ExcelFile += '.xlsx';
        XlBook.SaveCopyAs(ExcelFile);

        CloseXlApp;

        FILE.Erase(TempSchemaFileName);
        FILE.Erase(TempConfigQuestionnaireFileName);

        ConfigProgressBar.Close;

        exit(true);
    end;


    procedure ImportQuestionnaireFromExcel(XLSDataFile: Text) Imported: Boolean
    var
        [RunOnClient]
        XmlMaps: dotnet XmlMaps;
        [RunOnClient]
        XmlMap: dotnet XmlMap;
        TmpXmlFile: File;
        InStream: InStream;
        XMLDataFileClient: Text;
        XMLDataFileServer: Text;
    begin
        XlApp := XlApp.ApplicationClass;
        if IsNull(XlApp) then
          Error(Text019);

        XlHelper.CallOpen(XlApp,XLSDataFile);
        XlBook := XlApp.ActiveWorkbook;
        XMLDataFileClient := '';
        XmlMaps := XlBook.XmlMaps;
        if XmlMaps.Count <> 0 then begin
          TmpXmlFile.CreateTempfile;
          TmpXmlFile.CreateInstream(InStream);
          DownloadFromStream(InStream,'',FileMgt.Magicpath,'',XMLDataFileClient);
          TmpXmlFile.Close;

          XmlMap := XmlMaps.Item(1);
          XmlMap.Export(XMLDataFileClient,true);

          XMLDataFileServer := FileMgt.ServerTempFileName('.xml');
          Upload('',FileMgt.Magicpath,'',XMLDataFileClient,XMLDataFileServer);

          if ImportQuestionnaireAsXML(XMLDataFileServer) then
            Imported := true;
          CloseXlApp;
        end else begin
          CloseXlApp;
          Error(Text020);
        end;

        exit(Imported);
    end;

    local procedure CreateQuestionNodes(QuestionnaireXML: dotnet XmlDocument;ConfigQuestionArea: Record "Config. Question Area")
    var
        ConfigQuestion: Record "Config. Question";
        DocumentElement: dotnet XmlElement;
        QuestionAreaNode: dotnet XmlNode;
        QuestionNode: dotnet XmlNode;
        RecRef: RecordRef;
        QuestionRecRef: RecordRef;
    begin
        DocumentElement := QuestionnaireXML.DocumentElement;
        QuestionAreaNode := QuestionnaireXML.CreateElement(GetElementName(ConfigQuestionArea.Code + 'Questions'));
        DocumentElement.AppendChild(QuestionAreaNode);

        RecRef.GetTable(ConfigQuestionArea);
        CreateFieldSubtree(RecRef,QuestionAreaNode);

        ConfigQuestion.SetRange("Questionnaire Code",ConfigQuestionArea."Questionnaire Code");
        ConfigQuestion.SetRange("Question Area Code",ConfigQuestionArea.Code);
        if ConfigQuestion.FindSet then
          repeat
            QuestionNode := QuestionnaireXML.CreateElement(GetElementName(ConfigQuestion.TableName));
            QuestionAreaNode.AppendChild(QuestionNode);

            QuestionRecRef.GetTable(ConfigQuestion);
            CreateFieldSubtree(QuestionRecRef,QuestionNode);
          until ConfigQuestion.Next = 0;
    end;


    procedure GetElementName(NameIn: Text[250]): Text[250]
    begin
        NameIn := DelChr(NameIn,'=','?''`');
        NameIn := DelChr(ConvertStr(NameIn,'<>,./\+-&()%:','             '),'=',' ');
        NameIn := DelChr(NameIn,'=',' ');
        exit(NameIn);
    end;

    local procedure CreateFieldSubtree(var RecRef: RecordRef;var Node: dotnet XmlElement)
    var
        "Field": Record "Field";
        FieldRef: FieldRef;
        FieldNode: dotnet XmlNode;
        XmlDom: dotnet XmlDocument;
        i: Integer;
    begin
        XmlDom := Node.OwnerDocument;
        for i := 1 to RecRef.FieldCount do begin
          FieldRef := RecRef.FieldIndex(i);
          if not FieldException(RecRef.Number,FieldRef.Number) then begin
            FieldNode := XmlDom.CreateElement(GetElementName(FieldRef.Name));

            if Field.Get(RecRef.Number,FieldRef.Number) then begin
              if Field.Class = Field.Class::FlowField then
                FieldRef.CalcField;
              FieldNode.InnerText := Format(FieldRef.Value);

              XMLDOMMgt.AddAttribute(FieldNode,'fieldlength',Format(Field.Len));
            end;
            Node.AppendChild(FieldNode);
          end;
        end;
    end;

    local procedure GetNodeValue(var RecordNode: dotnet XmlNode;FieldNodeName: Text[250]): Text[250]
    var
        FieldNode: dotnet XmlNode;
    begin
        FieldNode := RecordNode.SelectSingleNode(FieldNodeName);
        exit(FieldNode.InnerText);
    end;

    local procedure UpdateInsertQuestionnaireField(var ConfigQuestionnaire: Record "Config. Questionnaire";RecordNode: dotnet XmlNode)
    var
        RecRef: RecordRef;
    begin
        RecRef.Open(Database::"Config. Questionnaire");

        ValidateRecordFields(RecRef,RecordNode);

        RecRef.SetTable(ConfigQuestionnaire);
    end;

    local procedure UpdateInsertQuestionAreaFields(var ConfigQuestionArea: Record "Config. Question Area";RecordNode: dotnet XmlNode)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(ConfigQuestionArea);

        ValidateRecordFields(RecRef,RecordNode);

        RecRef.SetTable(ConfigQuestionArea);
    end;

    local procedure UpdateInsertQuestionFields(var ConfigQuestion: Record "Config. Question";RecordNode: dotnet XmlNode)
    var
        "Field": Record "Field";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(ConfigQuestion);

        ValidateRecordFields(RecRef,RecordNode);

        RecRef.SetTable(ConfigQuestion);

        if Field.Get(ConfigQuestion."Table ID",ConfigQuestion."Field ID") then
          ModifyConfigQuestionAnswer(ConfigQuestion,Field);
    end;

    local procedure FieldNodeExists(var RecordNode: dotnet XmlNode;FieldNodeName: Text[250]): Boolean
    var
        FieldNode: dotnet XmlNode;
    begin
        FieldNode := RecordNode.SelectSingleNode(FieldNodeName);

        if not IsNull(FieldNode) then
          exit(true);
    end;

    local procedure CreateBook(XlsFile: Text)
    begin
        WrkBkWriter := WrkBkWriter.Create(XlsFile);
        if IsNull(WrkBkWriter) then
          Error(Text019);
    end;

    local procedure GetXLColumnID(ColumnNo: Integer): Text[10]
    var
        ExcelBuf: Record "Excel Buffer";
    begin
        ExcelBuf.Init;
        ExcelBuf.Validate("Column No.",ColumnNo);
        exit(ExcelBuf.xlColID);
    end;

    local procedure FieldException(TableID: Integer;FieldID: Integer): Boolean
    var
        ConfigQuestionArea: Record "Config. Question Area";
        ConfigQuestion: Record "Config. Question";
    begin
        case TableID of
          Database::"Config. Questionnaire":
            exit(false);
          Database::"Config. Question Area":
            exit(FieldID in [ConfigQuestionArea.FieldNo("Questionnaire Code"),
                             ConfigQuestionArea.FieldNo("Table Name")]);
          Database::"Config. Question":
            exit(FieldID in [ConfigQuestion.FieldNo("Questionnaire Code"),
                             ConfigQuestion.FieldNo("Question Area Code"),
                             ConfigQuestion.FieldNo("Table ID")]);
        end;
    end;


    procedure SetCalledFromCode()
    begin
        CalledFromCode := true;
    end;

    local procedure CloseXlApp()
    begin
        Clear(WrkBkWriter);
        Clear(XlSheet);
        Clear(XlBook);
        XlApp.Quit;
        Clear(XlApp);
    end;

    local procedure ValidateKeyFields(RecRef: RecordRef;RecordNode: dotnet XmlNode)
    var
        KeyRef: KeyRef;
        FieldRef: FieldRef;
        KeyFieldCount: Integer;
    begin
        KeyRef := RecRef.KeyIndex(1);
        for KeyFieldCount := 1 to KeyRef.FieldCount do begin
          FieldRef := KeyRef.FieldIndex(KeyFieldCount);
          if FieldNodeExists(RecordNode,GetElementName(FieldRef.Name)) then
            ConfigValidateMgt.ValidateFieldValue(
              RecRef,FieldRef,GetNodeValue(RecordNode,GetElementName(FieldRef.Name)),false,GlobalLanguage);
        end;
    end;

    local procedure ValidateFields(RecRef: RecordRef;RecordNode: dotnet XmlNode)
    var
        "Field": Record "Field";
        FieldRef: FieldRef;
    begin
        Field.SetRange(TableNo,RecRef.Number);
        if Field.FindSet then
          repeat
            FieldRef := RecRef.Field(Field."No.");
            if FieldNodeExists(RecordNode,GetElementName(FieldRef.Name)) then
              ConfigValidateMgt.ValidateFieldValue(
                RecRef,FieldRef,GetNodeValue(RecordNode,GetElementName(FieldRef.Name)),false,GlobalLanguage)
          until Field.Next = 0;
    end;

    local procedure ValidateRecordFields(RecRef: RecordRef;RecordNode: dotnet XmlNode)
    var
        RecRef1: RecordRef;
    begin
        ValidateKeyFields(RecRef,RecordNode);

        RecRef1 := RecRef.Duplicate;
        if not RecRef1.Find then
          RecRef.Insert(true);

        ValidateFields(RecRef,RecordNode);

        RecRef.Modify(true);
    end;


    procedure ModifyConfigQuestionAnswer(var ConfigQuestion: Record "Config. Question";"Field": Record "Field")
    var
        DateFormula: DateFormula;
        OptionInt: Integer;
    begin
        case Field.Type of
          Field.Type::Option,
          Field.Type::Boolean:
            begin
              if ConfigQuestion.Answer <> '' then begin
                OptionInt := ConfigValidateMgt.GetOptionNo(ConfigQuestion.Answer,ConfigQuestion."Answer Option");
                ConfigQuestion."Answer Option" :=
                  BuildAnswerOption(ConfigQuestion."Table ID",ConfigQuestion."Field ID");
                if OptionInt <> -1 then
                  ConfigQuestion.Answer := SelectStr(OptionInt + 1,ConfigQuestion."Answer Option");
              end else begin
                ConfigQuestion.Answer := '';
                ConfigQuestion."Answer Option" :=
                  BuildAnswerOption(ConfigQuestion."Table ID",ConfigQuestion."Field ID");
              end;
              ConfigQuestion.Modify;
            end;
          Field.Type::DateFormula:
            begin
              Evaluate(DateFormula,ConfigQuestion.Answer);
              ConfigQuestion.Answer := Format(DateFormula);
              ConfigQuestion.Modify;
            end;
        end;
    end;

    local procedure OpenBook(XLSDataFile: Text;Visible: Boolean)
    begin
        XlApp := XlApp.ApplicationClass;
        if IsNull(XlApp) then
          Error(Text019);
        XlHelper.CallOpen(XlApp,XLSDataFile);
        XlBook := XlApp.ActiveWorkbook;
        XlApp.Visible(Visible);
    end;
}

