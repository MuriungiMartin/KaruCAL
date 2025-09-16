#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1530 "Request Page Parameters Helper"
{

    trigger OnRun()
    begin
    end;

    var
        DataItemPathTxt: label '/ReportParameters/DataItems/DataItem', Locked=true;
        OptionPathTxt: label '/ReportParameters/Options/Field', Locked=true;
        XmlNodesNotFoundErr: label 'The XML Nodes at %1 cannot be found in the XML Document %2.';
        RepParamsWrongNumberFoundErr: label 'XML contains incorrect number of <ReportParameters> nodes.';


    procedure ConvertParametersToFilters(RecRef: RecordRef;TempBlob: Record TempBlob): Boolean
    var
        TableMetadata: Record "Table Metadata";
        FoundXmlNodeList: dotnet XmlNodeList;
    begin
        if not TableMetadata.Get(RecRef.Number) then
          exit(false);

        if not FindNodes(FoundXmlNodeList,ReadParameters(TempBlob),DataItemPathTxt) then
          exit(false);

        exit(GetFiltersForTable(RecRef,FoundXmlNodeList));
    end;

    local procedure ReadParameters(TempBlob: Record TempBlob) Parameters: Text
    var
        ParametersInStream: InStream;
    begin
        if TempBlob.Blob.Hasvalue then begin
          TempBlob.Blob.CreateInstream(ParametersInStream);
          ParametersInStream.ReadText(Parameters);
        end;
    end;

    local procedure FindNodes(var FoundXmlNodeList: dotnet XmlNodeList;Parameters: Text;NodePath: Text): Boolean
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        ParametersXmlDoc: dotnet XmlDocument;
    begin
        if not XMLDOMMgt.LoadXMLDocumentFromText(Parameters,ParametersXmlDoc) then
          exit(false);

        if not XMLDOMMgt.FindNodes(ParametersXmlDoc.DocumentElement,NodePath,FoundXmlNodeList) then
          Error(XmlNodesNotFoundErr,NodePath,ParametersXmlDoc.DocumentElement.InnerXml);

        exit(true);
    end;

    local procedure GetFiltersForTable(RecRef: RecordRef;FoundXmlNodeList: dotnet XmlNodeList): Boolean
    var
        FoundXmlNode: dotnet XmlNode;
    begin
        foreach FoundXmlNode in FoundXmlNodeList do
          if (FoundXmlNode.Attributes.ItemOf('name').Value = GetTableCaption(RecRef.Number)) or
             (FoundXmlNode.Attributes.ItemOf('name').Value = GetTableName(RecRef.Number))
          then begin
            RecRef.SetView(FoundXmlNode.InnerText);
            exit(true);
          end;

        exit(false);
    end;

    local procedure GetTableCaption(TableID: Integer): Text
    var
        TableMetadata: Record "Table Metadata";
    begin
        TableMetadata.Get(TableID);
        exit(TableMetadata.Caption);
    end;

    local procedure GetTableName(TableID: Integer): Text
    var
        TableMetadata: Record "Table Metadata";
    begin
        TableMetadata.Get(TableID);
        exit(TableMetadata.Name);
    end;


    procedure BuildDynamicRequestPage(var FilterPageBuilder: FilterPageBuilder;EntityName: Code[20];TableID: Integer): Boolean
    var
        TableList: dotnet ArrayList;
        Name: Text;
        "Table": Integer;
    begin
        if not GetDataItems(TableList,EntityName,TableID) then
          exit(false);

        foreach Table in TableList do begin
          Name := FilterPageBuilder.AddTable(GetTableCaption(Table),Table);
          AddFields(FilterPageBuilder,Name,Table);
        end;

        exit(true);
    end;

    local procedure GetDataItems(var TableList: dotnet ArrayList;EntityName: Code[20];TableID: Integer): Boolean
    var
        TableMetadata: Record "Table Metadata";
        DynamicRequestPageEntity: Record "Dynamic Request Page Entity";
    begin
        if not TableMetadata.Get(TableID) then
          exit(false);

        TableList := TableList.ArrayList;
        TableList.Add(TableID);

        DynamicRequestPageEntity.SetRange(Name,EntityName);
        DynamicRequestPageEntity.SetRange("Table ID",TableID);
        if DynamicRequestPageEntity.FindSet then
          repeat
            if not TableList.Contains(DynamicRequestPageEntity."Related Table ID") then
              TableList.Add(DynamicRequestPageEntity."Related Table ID");
          until DynamicRequestPageEntity.Next = 0;

        exit(true);
    end;

    local procedure AddFields(var FilterPageBuilder: FilterPageBuilder;Name: Text;TableID: Integer)
    var
        DynamicRequestPageField: Record "Dynamic Request Page Field";
    begin
        DynamicRequestPageField.SetRange("Table ID",TableID);
        if DynamicRequestPageField.FindSet then
          repeat
            FilterPageBuilder.AddFieldNo(Name,DynamicRequestPageField."Field ID");
          until DynamicRequestPageField.Next = 0;
    end;


    procedure SetViewOnDynamicRequestPage(var FilterPageBuilder: FilterPageBuilder;Filters: Text;EntityName: Code[20];TableID: Integer): Boolean
    var
        RecRef: RecordRef;
        FoundXmlNodeList: dotnet XmlNodeList;
        TableList: dotnet ArrayList;
        "Table": Integer;
    begin
        if not FindNodes(FoundXmlNodeList,Filters,DataItemPathTxt) then
          exit(false);

        if not GetDataItems(TableList,EntityName,TableID) then
          exit(false);

        foreach Table in TableList do begin
          RecRef.Open(Table);
          GetFiltersForTable(RecRef,FoundXmlNodeList);
          FilterPageBuilder.SetView(GetTableCaption(Table),RecRef.GetView(false));
          RecRef.Close;
          Clear(RecRef);
        end;

        exit(true);
    end;


    procedure GetViewFromDynamicRequestPage(var FilterPageBuilder: FilterPageBuilder;EntityName: Code[20];TableID: Integer): Text
    var
        TableList: dotnet ArrayList;
        TableFilterDictionary: dotnet Dictionary_Of_T_U;
        "Table": Integer;
    begin
        if not GetDataItems(TableList,EntityName,TableID) then
          exit('');

        TableFilterDictionary := TableFilterDictionary.Dictionary(TableList.Count);

        foreach Table in TableList do begin
          if not TableFilterDictionary.ContainsKey(Table) then
            TableFilterDictionary.Add(Table,FilterPageBuilder.GetView(GetTableCaption(Table),false));
        end;

        exit(ConvertFiltersToParameters(TableFilterDictionary));
    end;

    local procedure ConvertFiltersToParameters(TableFilterDictionary: dotnet Dictionary_Of_T_U): Text
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        DataItemXmlNode: dotnet XmlNode;
        DataItemsXmlNode: dotnet XmlNode;
        XmlDoc: dotnet XmlDocument;
        ReportParametersXmlNode: dotnet XmlNode;
        TableFilter: dotnet KeyValuePair_Of_T_U;
    begin
        XmlDoc := XmlDoc.XmlDocument;

        XMLDOMMgt.AddRootElement(XmlDoc,'ReportParameters',ReportParametersXmlNode);
        XMLDOMMgt.AddDeclaration(XmlDoc,'1.0','utf-8','yes');

        XMLDOMMgt.AddElement(ReportParametersXmlNode,'DataItems','','',DataItemsXmlNode);
        foreach TableFilter in TableFilterDictionary do begin
          XMLDOMMgt.AddElement(DataItemsXmlNode,'DataItem',TableFilter.Value,'',DataItemXmlNode);
          XMLDOMMgt.AddAttribute(DataItemXmlNode,'name',GetTableCaption(TableFilter.Key));
        end;

        exit(XmlDoc.InnerXml);
    end;


    procedure GetRequestPageOptionValue(OptionName: Text;Parameters: Text): Text
    var
        FoundXmlNodeList: dotnet XmlNodeList;
        FoundXmlNode: dotnet XmlNode;
        TempValue: Text;
    begin
        if not FindNodes(FoundXmlNodeList,Parameters,OptionPathTxt) then
          exit('');

        foreach FoundXmlNode in FoundXmlNodeList do begin
          TempValue := FoundXmlNode.Attributes.ItemOf('name').Value;
          if Format(TempValue) = Format(OptionName) then
            exit(FoundXmlNode.InnerText);
        end;
    end;


    procedure GetReportID(RequestPageParameters: Text): Text
    var
        FoundXmlNodeList: dotnet XmlNodeList;
    begin
        if not FindNodes(FoundXmlNodeList,RequestPageParameters,'/ReportParameters') then
          Error(RepParamsWrongNumberFoundErr);

        if FoundXmlNodeList.Count <> 1 then
          Error(RepParamsWrongNumberFoundErr);

        exit(FoundXmlNodeList.Item(0).Attributes.ItemOf('id').Value)
    end;
}

