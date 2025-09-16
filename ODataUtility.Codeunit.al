#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6710 ODataUtility
{

    trigger OnRun()
    begin
    end;

    var
        ODataWizardTxt: label 'Set Up Reporting Data';
        LoadingXMLErr: label 'There was an error loading the object.';

    [TryFunction]

    procedure GenerateSelectText(ServiceNameParam: Text;ObjectTypeParam: Option ,,,,,"Codeunit",,,"Page","Query";var SelectTextParam: Text)
    var
        TenantWebServiceColumns: Record "Tenant Web Service Columns";
        TenantWebService: Record "Tenant Web Service";
        FirstColumn: Boolean;
    begin
        if TenantWebService.Get(ObjectTypeParam,ServiceNameParam) then begin
          FirstColumn := true;
          TenantWebServiceColumns.SetRange(TenantWebServiceID,TenantWebService.RecordId);

          if TenantWebServiceColumns.Find('-') then begin
            SelectTextParam := '$select=';
            repeat
              if not FirstColumn then
                SelectTextParam += ','
              else
                FirstColumn := false;

              SelectTextParam += TenantWebServiceColumns."Field Name";
            until TenantWebServiceColumns.Next = 0;
          end;
        end;
    end;

    [TryFunction]

    procedure GenerateFilterText(ServiceNameParam: Text;ObjectTypeParam: Option ,,,,,"Codeunit",,,"Page","Query";var FilterTextParam: Text)
    var
        TenantWebService: Record "Tenant Web Service";
        TableItemFilterTextDictionary: dotnet Dictionary_Of_T_U;
        ODataFilterList: dotnet List_Of_T;
        ColumnList: dotnet List_Of_T;
        SelectText: Text;
    begin
        if TenantWebService.Get(ObjectTypeParam,ServiceNameParam) then begin
          TableItemFilterTextDictionary := TableItemFilterTextDictionary.Dictionary;
          ODataFilterList := ODataFilterList.List;
          ColumnList := ColumnList.List;

          if GenerateSelectText(ServiceNameParam,ObjectTypeParam,SelectText) then
            if GetNAVFilters(TenantWebService,TableItemFilterTextDictionary) then
              if ParseNAVFilters(TenantWebService,TableItemFilterTextDictionary,ODataFilterList,ColumnList,1) then
                FilterTextParam := CreateODataFilterText(ODataFilterList);
        end;
    end;


    procedure GenerateUrl(ServiceRootUrlParam: Text;ServiceNameParam: Text;ObjectTypeParam: Option ,,,,,,,,"Page","Query"): Text
    var
        TenantWebService: Record "Tenant Web Service";
        TenantWebServiceOData: Record "Tenant Web Service OData";
        ODataUrl: Text;
        SelectText: Text;
        FilterText: Text;
    begin
        if TenantWebService.Get(ObjectTypeParam,ServiceNameParam) then begin
          TenantWebServiceOData.SetRange(TenantWebServiceID,TenantWebService.RecordId);

          if TenantWebServiceOData.FindFirst then begin
            SelectText := TenantWebServiceOData.GetOdataSelectClause;
            FilterText := TenantWebServiceOData.GetOdataFilterClause;
          end;
        end;

        ODataUrl := BuildUrl(ServiceRootUrlParam,SelectText,FilterText);
        exit(ODataUrl);
    end;

    local procedure BuildUrl(ServiceRootUrlParam: Text;SelectTextParam: Text;FilterTextParam: Text): Text
    var
        ODataUrl: Text;
        preSelectTextConjunction: Text;
    begin
        if StrPos(ServiceRootUrlParam,'?tenant=') > 0 then
          preSelectTextConjunction := '&'
        else
          preSelectTextConjunction := '?';

        if (StrLen(SelectTextParam) > 0) and (StrLen(FilterTextParam) > 0) then
          ODataUrl := ServiceRootUrlParam + preSelectTextConjunction + SelectTextParam + '&' + FilterTextParam
        else
          if StrLen(SelectTextParam) > 0 then
            ODataUrl := ServiceRootUrlParam + preSelectTextConjunction + SelectTextParam
          else
            // FilterText is based on SelectText, so it doesn't make sense to have only the FilterText.
            ODataUrl := ServiceRootUrlParam;

        exit(ODataUrl);
    end;

    local procedure CreateODataFilterText(ODataFilterListParam: dotnet List_Of_T): Text
    var
        ODataFilterText: Text;
        I: Integer;
    begin
        ODataFilterText := '';

        if ODataFilterListParam.Count > 0 then begin
          ODataFilterText := '$filter=';

          for I := 0 to ODataFilterListParam.Count - 1 do begin
            if I > 0 then begin
              ODataFilterText += ' and '
            end;

            ODataFilterText += Format(ODataFilterListParam.Item(I));
          end;
        end;

        exit(ODataFilterText);
    end;

    [TryFunction]
    local procedure ParseNAVFilters(var TenantWebService: Record "Tenant Web Service";TableItemFilterTextDictionaryParam: dotnet Dictionary_Of_T_U;var ODataFilterListParam: dotnet List_Of_T;var ColumnListParam: dotnet List_Of_T;"Action": Integer)
    var
        TenantWebServiceColumns: Record "Tenant Web Service Columns";
        FieldTable: Record "Field";
        Regex: dotnet Regex;
        localFilterSegments: dotnet Array;
        tempString1: dotnet String;
        tempString2: dotnet String;
        keyValuePair: dotnet KeyValuePair_Of_T_U;
        localFilterText: Text;
        I: Integer;
        column: Text;
        value: Text;
        indexOfKeyStart: Integer;
        indexOfValueEnd: Integer;
    begin
        // SORTING(No.) WHERE(No=FILTER(01121212..01454545|31669966),Balance Due=FILTER(>0))

        // Action:  1 = parse and create OData filters
        // Action:  2 = parse, don't create OData filters, just create list of columns

        foreach keyValuePair in TableItemFilterTextDictionaryParam do begin
          localFilterText := DelStr(keyValuePair.Value,1,StrPos(keyValuePair.Value,'WHERE') + 5);  // becomes No=FILTER(01121212..01454545|31669966),Balance Due=FILTER(>0))
          localFilterText := DelStr(localFilterText,StrLen(localFilterText),1); // remove ), becomes No=FILTER(01121212..01454545|31669966),Balance Due=FILTER(>0)
          localFilterSegments := Regex.Split(localFilterText,'=FILTER'); // No   (01121212..01454545|31669966),Balance Due   (>0)

          // Break all the filters into key value pairs.
          for I := 0 to localFilterSegments.Length - 2 do begin
            tempString1 := localFilterSegments.GetValue(I);
            tempString2 := localFilterSegments.GetValue(I + 1);
            indexOfKeyStart := tempString1.LastIndexOf(',');
            indexOfValueEnd := tempString2.LastIndexOf(',');

            // Start index of the key is either at the beginning or right after the comma.
            if indexOfKeyStart > 0 then
              indexOfKeyStart := indexOfKeyStart + 1
            else
              indexOfKeyStart := 0;

            // End index of the value is either right before the comma or at the end.  Make sure we don't confuse commas in last filter value.
            if (indexOfValueEnd < 0) or (I = localFilterSegments.Length - 2) then
              indexOfValueEnd := tempString2.Length;

            column := tempString1.Substring(indexOfKeyStart,tempString1.Length - indexOfKeyStart);
            value := tempString2.Substring(1,indexOfValueEnd - 2);

            // Convert to OData format if the field is in the dataset.
            FieldTable.SetRange(TableNo,keyValuePair.Key);
            FieldTable.SetRange("Field Caption",column);
            if FieldTable.FindFirst then begin
              TenantWebServiceColumns.SetRange(TenantWebServiceID,TenantWebService.RecordId);
              TenantWebServiceColumns.SetRange("Data Item",keyValuePair.Key);
              TenantWebServiceColumns.SetRange("Field Number",FieldTable."No.");
              if TenantWebServiceColumns.FindFirst then begin
                if Action = 1 then
                  ParseIndividualNAVFilter(TenantWebService,keyValuePair.Key,column,value,ODataFilterListParam)
                else
                  if Action = 2 then
                    ColumnListParam.Add(column);
              end;
            end;
          end;
        end;
    end;

    local procedure ParseIndividualNAVFilter(var TenantWebService: Record "Tenant Web Service";TableItemParam: Integer;ColumnNameParam: Text;FilterValueParam: Text;var ODataFilterListParam: dotnet List_Of_T)
    var
        partialFilterValue: Text;
        I: Integer;
        filterCharacters: Text;
        individualFilterValue: Text;
        conjunctionValue: Text;
    begin
        filterCharacters := '';
        individualFilterValue := '';

        for I := 1 to StrLen(FilterValueParam) do begin
          if (CopyStr(FilterValueParam,I,1) = '|') or (CopyStr(FilterValueParam,I,1) = '&') then begin
            partialFilterValue := CreateIndividualODataFilter(TenantWebService,TableItemParam,ColumnNameParam,filterCharacters);
            conjunctionValue := ConvertNavSymbolToODataConjunction(CopyStr(FilterValueParam,I,1));
            individualFilterValue := '(' + individualFilterValue + partialFilterValue + ')' + conjunctionValue;
            filterCharacters := '';
          end else
            filterCharacters += CopyStr(FilterValueParam,I,1);
        end;

        partialFilterValue := CreateIndividualODataFilter(TenantWebService,TableItemParam,ColumnNameParam,filterCharacters);

        if StrPos(individualFilterValue,'(') = 1 then
          individualFilterValue := '(' + individualFilterValue + partialFilterValue + ')'
        else
          individualFilterValue := partialFilterValue;

        ODataFilterListParam.Add(individualFilterValue); // Add last individual filter
    end;

    local procedure CreateIndividualODataFilter(var TenantWebService: Record "Tenant Web Service";TableItemParam: Integer;ColumnNameParam: Text;FilterValueParam: Text): Text
    var
        FilterValue: Text;
        FilterValueLeft: Text;
        FilterValueRight: Text;
        Position: Integer;
        ColumnNameLeft: Text;
        ColumnNameRight: Text;
    begin
        if StrPos(FilterValueParam,'<>') > 0 then begin
          FilterValue := DelStr(FilterValueParam,StrPos(FilterValueParam,'<>'),StrLen('<>'));
          FilterValue := DelChr(FilterValue,'<>',' ');
          ConvertToODataSyntax(TenantWebService,TableItemParam,ColumnNameParam,FilterValue);
          FilterValue := ColumnNameParam + ' ne ' + FilterValue;
        end else
          if StrPos(FilterValueParam,'>=') > 0 then begin
            FilterValue := DelStr(FilterValueParam,StrPos(FilterValueParam,'>='),StrLen('>='));
            FilterValue := DelChr(FilterValue,'<>',' ');
            ConvertToODataSyntax(TenantWebService,TableItemParam,ColumnNameParam,FilterValue);
            FilterValue := ColumnNameParam + ' ge ' + FilterValue;
          end else
            if StrPos(FilterValueParam,'<=') > 0 then begin
              FilterValue := DelStr(FilterValueParam,StrPos(FilterValueParam,'<='),StrLen('<='));
              FilterValue := DelChr(FilterValue,'<>',' ');
              ConvertToODataSyntax(TenantWebService,TableItemParam,ColumnNameParam,FilterValue);
              FilterValue := ColumnNameParam + ' le ' + FilterValue;
            end else
              if StrPos(FilterValueParam,'>') > 0 then begin
                FilterValue := DelStr(FilterValueParam,StrPos(FilterValueParam,'>'),StrLen('>'));
                FilterValue := DelChr(FilterValue,'<>',' ');
                ConvertToODataSyntax(TenantWebService,TableItemParam,ColumnNameParam,FilterValue);
                FilterValue := ColumnNameParam + ' gt ' + FilterValue;
              end else
                if StrPos(FilterValueParam,'<') > 0 then begin
                  FilterValue := DelStr(FilterValueParam,StrPos(FilterValueParam,'<'),StrLen('<'));
                  FilterValue := DelChr(FilterValue,'<>',' ');
                  ConvertToODataSyntax(TenantWebService,TableItemParam,ColumnNameParam,FilterValue);
                  FilterValue := ColumnNameParam + ' lt ' + FilterValue;
                end else
                  if StrPos(FilterValueParam,'..') > 0 then begin
                    // Replace .. with appropriate ge and le statement
                    FilterValue := DelChr(FilterValueParam,'<>');
                    Position := StrPos(FilterValue,'..');

                    if Position = 1 then begin
                      // Pattern like ..1000
                      FilterValue := DelStr(FilterValue,Position,2);
                      ConvertToODataSyntax(TenantWebService,TableItemParam,ColumnNameParam,FilterValue);
                      FilterValue := ColumnNameParam + ' le ' + FilterValue
                    end else
                      if Position = StrLen(FilterValue) - 1 then begin
                        // Pattern like 1000..
                        FilterValue := DelStr(FilterValue,Position,2);
                        ConvertToODataSyntax(TenantWebService,TableItemParam,ColumnNameParam,FilterValue);
                        FilterValue := ColumnNameParam + ' ge ' + FilterValue
                      end else begin
                        // Pattern like 1000..2000
                        FilterValueLeft := CopyStr(FilterValue,1,Position - 1);
                        FilterValueRight := CopyStr(FilterValue,Position + 2,StrLen(FilterValue) - Position - 1);
                        ColumnNameLeft := ColumnNameParam;
                        ColumnNameRight := ColumnNameParam;
                        ConvertToODataSyntax(TenantWebService,TableItemParam,ColumnNameLeft,FilterValueLeft);
                        ConvertToODataSyntax(TenantWebService,TableItemParam,ColumnNameRight,FilterValueRight);
                        FilterValueLeft := ColumnNameLeft + ' ge ' + FilterValueLeft;
                        FilterValueRight := ColumnNameRight + ' le ' + FilterValueRight;
                        FilterValue := FilterValueLeft + ' and ' + FilterValueRight;
                      end;
                  end else begin
                    FilterValue := DelChr(FilterValueParam,'<>',' ');
                    ConvertToODataSyntax(TenantWebService,TableItemParam,ColumnNameParam,FilterValue);
                    FilterValue := ColumnNameParam + ' eq ' + FilterValue;
                  end;

        exit(FilterValue);
    end;

    local procedure ConvertToODataSyntax(var TenantWebService: Record "Tenant Web Service";TableItemParam: Integer;var ColumnNameParam: Text;var FilterValueParam: Text)
    var
        FieldTable: Record "Field";
        TenantWebServiceColumns: Record "Tenant Web Service Columns";
        DotNetDateTime: dotnet DateTime;
        DecimalVariable: Decimal;
        BigIntegerVariable: BigInteger;
        DateVariable: Date;
        BoolVar: Boolean;
    begin
        // Look up the datatype and put in appropriate format.
        FieldTable.SetRange(TableNo,TableItemParam);
        FieldTable.SetRange("Field Caption",ColumnNameParam);

        if FieldTable.FindFirst then
          case FieldTable.Type of
            FieldTable.Type::Text,FieldTable.Type::Code,FieldTable.Type::OemCode,FieldTable.Type::OemText,FieldTable.Type::Option:
              begin
                FilterValueParam := ReplaceSpecialURICharacters(FilterValueParam);

                if (StrLen(FilterValueParam) > 0) and (StrPos(FilterValueParam,'''') = 1) then
                  FilterValueParam := FilterValueParam
                else
                  FilterValueParam := '''' + FilterValueParam + '''';
              end;
            FieldTable.Type::BigInteger,FieldTable.Type::Integer:
              begin
                Evaluate(BigIntegerVariable,FilterValueParam);
                FilterValueParam := Format(BigIntegerVariable,0,9);
              end;
            FieldTable.Type::Decimal:
              begin
                Evaluate(DecimalVariable,FilterValueParam);
                FilterValueParam := Format(DecimalVariable,0,9) + 'M';
              end;
            FieldTable.Type::Date,FieldTable.Type::DateTime:
              begin
                Evaluate(DateVariable,FilterValueParam);
                DotNetDateTime := DotNetDateTime.DateTime(Date2dmy(DateVariable,3),Date2dmy(DateVariable,2),Date2dmy(DateVariable,1));
                FilterValueParam := 'DateTime''' + DotNetDateTime.ToString('yyyy-MM-dd') + ''''
              end;
            FieldTable.Type::Time:
              FilterValueParam := FilterValueParam;
            FieldTable.Type::Boolean:
              begin
                Evaluate(BoolVar,FilterValueParam);

                if BoolVar then
                  FilterValueParam := 'true'
                else
                  FilterValueParam := 'false';
              end;
          end;

        // Look up the column name.  Column must be in appropriate format or filter will fail.
        TenantWebServiceColumns.SetRange(TenantWebServiceID,TenantWebService.RecordId);
        TenantWebServiceColumns.SetRange("Data Item",TableItemParam);
        TenantWebServiceColumns.SetRange("Field Number",FieldTable."No.");
        if TenantWebServiceColumns.FindFirst then
          ColumnNameParam := TenantWebServiceColumns."Field Name";
    end;

    local procedure ReplaceSpecialURICharacters(FilterValueParam: Text): Text
    var
        FilterValueDotNetString: dotnet String;
        ReturnText: Text;
    begin
        FilterValueDotNetString := FilterValueParam;
        FilterValueDotNetString := FilterValueDotNetString.Replace('%','%25');
        FilterValueDotNetString := FilterValueDotNetString.Replace('+','%2B');
        FilterValueDotNetString := FilterValueDotNetString.Replace('/','%2F');
        FilterValueDotNetString := FilterValueDotNetString.Replace('?','%3F');
        FilterValueDotNetString := FilterValueDotNetString.Replace('#','%23');
        FilterValueDotNetString := FilterValueDotNetString.Replace('&','%26');
        ReturnText := FilterValueDotNetString;
        exit(ReturnText);
    end;

    local procedure ConvertNavSymbolToODataConjunction(ConjunctionParam: Text): Text
    var
        localODataConjunction: Text;
    begin
        case ConjunctionParam of
          '|':
            localODataConjunction := ' or ';
          '&':
            localODataConjunction := ' and ';
        end;

        exit(localODataConjunction);
    end;

    [TryFunction]
    local procedure GetNAVFilters(var TenantWebService: Record "Tenant Web Service";var TableItemFilterTextDictionaryParam: dotnet Dictionary_Of_T_U)
    var
        TenantWebServiceFilter: Record "Tenant Web Service Filter";
        FilterText: Text;
    begin
        TenantWebServiceFilter.SetRange(TenantWebServiceID,TenantWebService.RecordId);
        if TenantWebServiceFilter.Find('-') then begin
          repeat
            FilterText := TenantWebServiceFilter.GetFilter;

            if StrLen(FilterText) > 0 then
              TableItemFilterTextDictionaryParam.Add(TenantWebServiceFilter."Data Item",FilterText);
          until TenantWebServiceFilter.Next = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Tenant Web Service", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteODataOnDeleteTenantWebService(var Rec: Record "Tenant Web Service";RunTrigger: Boolean)
    var
        TenantWebServiceColumns: Record "Tenant Web Service Columns";
        TenantWebServiceFilter: Record "Tenant Web Service Filter";
        TenantWebServiceOData: Record "Tenant Web Service OData";
    begin
        // Delete the data from the OData concrete tables when a Tenant Web Service record is deleted.
        TenantWebServiceFilter.SetRange(TenantWebServiceID,Rec.RecordId);
        TenantWebServiceColumns.SetRange(TenantWebServiceID,Rec.RecordId);
        TenantWebServiceOData.SetRange(TenantWebServiceID,Rec.RecordId);
        TenantWebServiceFilter.DeleteAll;
        TenantWebServiceColumns.DeleteAll;
        TenantWebServiceOData.DeleteAll;
    end;


    procedure ConvertNavFieldNameToOdataName(NavFieldName: Text): Text
    var
        i: Integer;
    begin
        i := StrPos(NavFieldName,'%');
        if i > 0 then
          NavFieldName := InsStr(NavFieldName,'Percent',i);
        NavFieldName := DelChr(NavFieldName,'=','(.)<>%');
        NavFieldName := ConvertStr(NavFieldName,' ,:;?&"/-','_________');
        exit(NavFieldName);
    end;


    procedure GetColumnsFromFilter(var TenantWebService: Record "Tenant Web Service";FilterText: Text;var ColumnList: dotnet List_Of_T)
    var
        TableItemFilterTextDictionary: dotnet Dictionary_Of_T_U;
        ODataFilterList: dotnet List_Of_T;
    begin
        TableItemFilterTextDictionary := TableItemFilterTextDictionary.Dictionary;
        ODataFilterList := ODataFilterList.List;
        TableItemFilterTextDictionary.Add(1,FilterText);
        ParseNAVFilters(TenantWebService,TableItemFilterTextDictionary,ODataFilterList,ColumnList,2);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", 'OnCompanyInitialize', '', false, false)]

    procedure CreateAssistedSetup()
    var
        AssistedSetup: Record "Assisted Setup";
        NewOrderNumber: Integer;
    begin
        if AssistedSetup.Get(Page::"OData Setup Wizard") then
          exit;

        AssistedSetup.LockTable;
        AssistedSetup.SetCurrentkey(Order,Visible);
        if AssistedSetup.FindLast then
          NewOrderNumber := AssistedSetup.Order + 1
        else
          NewOrderNumber := 1;

        Clear(AssistedSetup);
        AssistedSetup.Init;
        AssistedSetup.Validate("Page ID",Page::"OData Setup Wizard");
        AssistedSetup.Validate(Name,ODataWizardTxt);
        AssistedSetup.Validate(Order,NewOrderNumber);
        AssistedSetup.Validate(Status,AssistedSetup.Status::"Not Completed");
        AssistedSetup.Validate(Visible,true);
        AssistedSetup.Insert(true);
    end;


    procedure GenerateExcelWorkBook(ObjectTypeParm: Option ,,,,,"Codeunit",,,"Page","Query";ServiceNameParm: Text;ShowDialogParm: Boolean)
    var
        TenantWebService: Record "Tenant Web Service";
        TempBlob: Record TempBlob temporary;
        FileManagement: Codeunit "File Management";
        DataEntityExportInfo: dotnet DataEntityExportInfo;
        DataEntityExportGenerator: dotnet DataEntityExportGenerator;
        NvOutStream: OutStream;
        FileName: Text;
    begin
        if not TenantWebService.Get(ObjectTypeParm,ServiceNameParm) then
          exit;

        DataEntityExportInfo := DataEntityExportInfo.DataEntityExportInfo;
        CreateDataEntityExportInfo(TenantWebService,DataEntityExportInfo);

        DataEntityExportGenerator := DataEntityExportGenerator.DataEntityExportGenerator;
        TempBlob.Blob.CreateOutstream(NvOutStream);
        DataEntityExportGenerator.GenerateWorkbook(DataEntityExportInfo,NvOutStream);
        FileName := TenantWebService."Service Name" + '.xlsx';
        FileManagement.BLOBExport(TempBlob,FileName,ShowDialogParm);
    end;

    [TryFunction]
    local procedure GetConjunctionString(var localFilterSegments: dotnet Array;var ConjunctionStringParam: Text;var IndexParam: Integer)
    begin
        ConjunctionStringParam := localFilterSegments.GetValue(IndexParam);
        IndexParam += 1;
    end;

    [TryFunction]
    local procedure GetNextFieldString(var localFilterSegments: dotnet Array;var NextFieldStringParam: Text;var IndexParam: Integer)
    begin
        NextFieldStringParam := localFilterSegments.GetValue(IndexParam);
        IndexParam += 1;
    end;

    local procedure TrimFilterClause(var FilterClauseParam: Text)
    begin
        FilterClauseParam := DelStr(FilterClauseParam,1,StrPos(FilterClauseParam,'filter=') + 6);
        // becomes  ((No ge '01121212' and No le '01445544') or No eq '10000') and ((Name eq 'bob') and Name eq 'frank')
        FilterClauseParam := DelChr(FilterClauseParam,'<','(');
        FilterClauseParam := DelChr(FilterClauseParam,'>',')');
        // becomes  (No ge '01121212' and No le '01445544') or No eq '10000') and ((Name eq 'bob') and Name eq 'frank'
    end;


    procedure GetEndPointAndCreateWorkbook(ObjectTypeParam: Option ,,,,,"Codeunit",,,"Page","Query";ObjectIDParam: Integer;ShowDialogParam: Boolean)
    var
        TenantWebService: Record "Tenant Web Service";
        TenantWebServiceOData: Record "Tenant Web Service OData";
        AllObjWithCaption: Record AllObjWithCaption;
        ColumnDictionary: dotnet Dictionary_Of_T_U;
        SourceTableText: Text;
        SavedSelectText: Text;
        DefaultSelectText: Text;
    begin
        ColumnDictionary := ColumnDictionary.Dictionary;

        AllObjWithCaption.SetRange("Object ID",ObjectIDParam);
        AllObjWithCaption.SetRange("Object Type",ObjectTypeParam);
        AllObjWithCaption.FindFirst;

        TenantWebService.Init;
        TenantWebService.SetRange("Object Type",ObjectTypeParam);
        TenantWebService.SetRange("Object ID",ObjectIDParam);
        if TenantWebService.Find('-') then begin
          repeat
            TenantWebServiceOData.SetRange(TenantWebServiceID,TenantWebService.RecordId);
            if TenantWebServiceOData.Find('-') then begin
              repeat
                // the $filter string must be null
                if not TenantWebServiceOData.ODataFilterClause.Hasvalue then begin
                  // The saved $select must match the default $select for the page.
                  SavedSelectText := TenantWebServiceOData.GetOdataSelectClause;
                  InitSelectedColumns(ObjectTypeParam,ObjectIDParam,ColumnDictionary,SourceTableText);
                  GetDefaultSelectText(ColumnDictionary,DefaultSelectText);
                end;
              until (TenantWebServiceOData.Next = 0) or (SavedSelectText = DefaultSelectText);
            end;
          until (TenantWebService.Next = 0) or (SavedSelectText = DefaultSelectText);

          if (SavedSelectText = '') or (SavedSelectText <> DefaultSelectText) then
            // We have a Tenant Web Service record but no $select or $select does not match the pages default columns
            CreateEndPoint(ObjectTypeParam,ObjectIDParam,TenantWebService,AllObjWithCaption."Object Caption",ColumnDictionary);
        end else
          // Create an endpoint that can be used by the Reporting Setup wizard
          CreateEndPoint(ObjectTypeParam,ObjectIDParam,TenantWebService,AllObjWithCaption."Object Caption",ColumnDictionary);

        GenerateExcelWorkBook(Objecttypeparam::Page,TenantWebService."Service Name",ShowDialogParam)
    end;


    procedure CreateDataEntityExportInfo(var TenantWebService: Record "Tenant Web Service";var DataEntityExportInfoParam: dotnet DataEntityExportInfo)
    var
        TenantWebServiceColumns: Record "Tenant Web Service Columns";
        TenantWebServiceOData: Record "Tenant Web Service OData";
        TypeHelper: Codeunit "Type Helper";
        ConnectionInfo: dotnet ConnectionInfo;
        OfficeAppInfo: dotnet OfficeAppInfo;
        DataEntityInfo: dotnet DataEntityInfo;
        BindingInfo: dotnet BindingInfo;
        FieldInfo: dotnet FieldInfo;
        FilterBinaryNode: dotnet FilterBinaryNode;
        FieldFilterCollectionNode: dotnet FilterCollectionNode;
        FieldFilterCollectionNode2: dotnet FilterCollectionNode;
        EntityFilterCollectionNode: dotnet FilterCollectionNode;
        FilterLeftOperand: dotnet FilterLeftOperand;
        ValueString: dotnet String;
        Regex: dotnet Regex;
        FilterSegments: dotnet Array;
        ConjunctionString: Text;
        OldConjunctionString: Text;
        NextFieldString: Text;
        Index: Integer;
        FilterClause: Text;
        HostName: Text;
        ServiceName: Text;
        NumberOfCharsTrimmed: Integer;
        TrimPos: Integer;
        FieldFilterCounter: Integer;
    begin
        OfficeAppInfo := OfficeAppInfo.OfficeAppInfo;
        OfficeAppInfo.Id := 'WA104379629';
        OfficeAppInfo.Store := 'en-US'; // todo US store only?
        OfficeAppInfo.StoreType := 'OMEX';
        OfficeAppInfo.Version := '1.3.0.0';

        DataEntityExportInfoParam := DataEntityExportInfoParam.DataEntityExportInfo;
        DataEntityExportInfoParam.AppReference := OfficeAppInfo;

        ConnectionInfo := ConnectionInfo.ConnectionInfo;
        HostName := GetUrl(Clienttype::Web);
        if StrPos(HostName,'?') <> 0 then
          HostName := CopyStr(HostName,1,StrPos(HostName,'?') - 1);
        ConnectionInfo.HostName := HostName;

        DataEntityExportInfoParam.Connection := ConnectionInfo;
        DataEntityExportInfoParam.Language := TypeHelper.LanguageIDToCultureName(WindowsLanguage); // todo get language
        DataEntityExportInfoParam.EnableDesign := true;
        DataEntityExportInfoParam.RefreshOnOpen := true;
        DataEntityExportInfoParam.Headers.Add('Company',TenantWebService.CurrentCompany);
        DataEntityInfo := DataEntityInfo.DataEntityInfo;
        ServiceName := ExternalizeName(TenantWebService."Service Name");
        DataEntityInfo.Name := ServiceName;
        DataEntityInfo.PublicName := ServiceName;
        DataEntityExportInfoParam.Entities.Add(DataEntityInfo);

        BindingInfo := BindingInfo.BindingInfo;
        BindingInfo.EntityName := DataEntityInfo.Name;

        DataEntityExportInfoParam.Bindings.Add(BindingInfo);

        TenantWebServiceOData.Init;
        TenantWebServiceOData.SetRange(TenantWebServiceID,TenantWebService.RecordId);
        TenantWebServiceOData.FindFirst;

        TenantWebServiceColumns.Init;
        TenantWebServiceColumns.SetRange(TenantWebServiceID,TenantWebService.RecordId);
        if TenantWebServiceColumns.FindSet then begin
          EntityFilterCollectionNode := EntityFilterCollectionNode.FilterCollectionNode;  // One filter collection node for entire entity

          repeat
            FieldInfo := FieldInfo.FieldInfo;
            FieldInfo.Name := TenantWebServiceColumns."Field Name";
            FieldInfo.Label := TenantWebServiceColumns."Field Name";
            BindingInfo.Fields.Add(FieldInfo);

            // New column, if the previous row had data, add it entity filter collection
            AddFieldNodeToEntityNode(FieldFilterCollectionNode,FieldFilterCollectionNode2,EntityFilterCollectionNode);

            TrimPos := 0;
            Index := 1;
            OldConjunctionString := '';
            FieldFilterCounter += 1;

            FilterClause := TenantWebServiceOData.GetOdataFilterClause;
            // $filter=((No ge '01121212' and No le '01445544') or No eq '10000') and ((Name eq 'bo b') and Name eq 'fra nk')
            if FilterClause <> '' then begin
              TrimFilterClause(FilterClause);

              if StrPos(FilterClause,TenantWebServiceColumns."Field Name" + ' ') > 0 then begin
                FilterClause := CopyStr(FilterClause,StrPos(FilterClause,TenantWebServiceColumns."Field Name" + ' '));

                while FilterClause <> '' do begin
                  FilterBinaryNode := FilterBinaryNode.FilterBinaryNode;
                  FilterLeftOperand := FilterLeftOperand.FilterLeftOperand;

                  FilterLeftOperand.Field(TenantWebServiceColumns."Field Name");
                  FilterLeftOperand.Type(GetFieldType(TenantWebServiceColumns));

                  FilterBinaryNode.Left := FilterLeftOperand;
                  FilterSegments := Regex.Split(FilterClause,' ');

                  FilterBinaryNode.Operator(FilterSegments.GetValue(1));
                  ValueString := FilterSegments.GetValue(2);
                  Index := 3;

                  NumberOfCharsTrimmed := ConcatValueStringPortions(ValueString,FilterSegments,Index);

                  FilterBinaryNode.Right(ValueString);

                  TrimPos := StrPos(FilterClause,ValueString) + StrLen(ValueString) + NumberOfCharsTrimmed;

                  if not GetConjunctionString(FilterSegments,ConjunctionString,Index) then
                    ConjunctionString := '';

                  if not GetNextFieldString(FilterSegments,NextFieldString,Index) then
                    NextFieldString := '';

                  TrimPos := TrimPos + StrLen(ConjunctionString) + StrLen(NextFieldString);

                  if (NextFieldString = '') or (NextFieldString = TenantWebServiceColumns."Field Name") then begin
                    if (OldConjunctionString <> '') and (OldConjunctionString <> ConjunctionString) then begin
                      if IsNull(FieldFilterCollectionNode2) then begin
                        FieldFilterCollectionNode2 := FieldFilterCollectionNode2.FilterCollectionNode;
                        FieldFilterCollectionNode2.Operator(ConjunctionString);
                      end;

                      FieldFilterCollectionNode.Collection.Add(FilterBinaryNode);
                      if OldConjunctionString <> '' then
                        FieldFilterCollectionNode.Operator(OldConjunctionString);

                      FieldFilterCollectionNode2.Collection.Add(FieldFilterCollectionNode);

                      Clear(FieldFilterCollectionNode);
                    end else begin
                      if IsNull(FieldFilterCollectionNode) then
                        FieldFilterCollectionNode := FieldFilterCollectionNode.FilterCollectionNode;

                      FieldFilterCollectionNode.Collection.Add(FilterBinaryNode);
                      FieldFilterCollectionNode.Operator(OldConjunctionString)
                    end
                  end else begin
                    if IsNull(FieldFilterCollectionNode2) then
                      FieldFilterCollectionNode2 := FieldFilterCollectionNode2.FilterCollectionNode;

                    if IsNull(FieldFilterCollectionNode) then
                      FieldFilterCollectionNode := FieldFilterCollectionNode.FilterCollectionNode;

                    FieldFilterCollectionNode.Collection.Add(FilterBinaryNode);
                    FieldFilterCollectionNode.Operator(OldConjunctionString);

                    FieldFilterCollectionNode2.Collection.Add(FieldFilterCollectionNode);

                    Clear(FieldFilterCollectionNode);

                    FilterClause := ''; // the FilterClause is exhausted for this field
                  end;

                  OldConjunctionString := ConjunctionString;

                  FilterClause := CopyStr(FilterClause,TrimPos); // remove that portion that has been processed.
                end;
              end;
            end;
          until TenantWebServiceColumns.Next = 0;

          AddFieldNodeToEntityNode(FieldFilterCollectionNode,FieldFilterCollectionNode2,EntityFilterCollectionNode);
        end;

        if FieldFilterCounter > 1 then
          EntityFilterCollectionNode.Operator('and');  // All fields are anded together

        DataEntityInfo.Filter(EntityFilterCollectionNode);
    end;

    local procedure ConcatValueStringPortions(var ValueStringParam: dotnet String;var FilterSegmentsParam: dotnet Array;var IndexParm: Integer): Integer
    var
        ValueStringPortion: dotnet String;
        LastPosition: Integer;
        FirstPosition: Integer;
        SingleTick: Char;
        StrLenAfterTrim: Integer;
        StrLenBeforeTrim: Integer;
    begin
        SingleTick := 39;

        FirstPosition := ValueStringParam.IndexOf(SingleTick);
        LastPosition := ValueStringParam.LastIndexOf(SingleTick);

        // The valueString might have been spit earlier if it had an embedded ' ', stick it back together
        if (FirstPosition = 0) and (FirstPosition = LastPosition) then begin
          repeat
            ValueStringPortion := FilterSegmentsParam.GetValue(IndexParm);
            ValueStringParam := ValueStringParam.Concat(ValueStringParam,' ');
            ValueStringParam := ValueStringParam.Concat(ValueStringParam,ValueStringPortion);
            ValueStringPortion := FilterSegmentsParam.GetValue(IndexParm);
            IndexParm += 1 ;
          until ValueStringPortion.LastIndexOf(SingleTick) > 0;
        end;

        // Now that the string has been put back together if needed, remove leading and trailing SingleTick
        // as the excel addin will apply them.
        FirstPosition := ValueStringParam.IndexOf(SingleTick);

        StrLenBeforeTrim := StrLen(ValueStringParam);
        if FirstPosition = 0 then begin
          ValueStringParam := DelStr(ValueStringParam,1,1);
          LastPosition := ValueStringParam.LastIndexOf(SingleTick);
          if LastPosition > 0 then begin
            ValueStringParam := DelChr(ValueStringParam,'>',')'); // Remove any trailing ')'
            ValueStringParam := DelStr(ValueStringParam,ValueStringParam.Length,1);
          end;
        end;

        StrLenAfterTrim := StrLen(ValueStringParam);
        exit(StrLenBeforeTrim - StrLenAfterTrim);
    end;

    local procedure GetFieldType(var TenantWebServiceColumnsParam: Record "Tenant Web Service Columns"): Text
    var
        FieldTable: Record "Field";
    begin
        FieldTable.SetRange(TableNo,TenantWebServiceColumnsParam."Data Item");
        FieldTable.SetRange("No.",TenantWebServiceColumnsParam."Field Number");
        if FieldTable.FindFirst then
          case FieldTable.Type of
            FieldTable.Type::Text,FieldTable.Type::Code,FieldTable.Type::OemCode,FieldTable.Type::OemText,FieldTable.Type::Option:
              exit('Edm.String');
            FieldTable.Type::BigInteger,FieldTable.Type::Integer:
              exit('Edm.Int32');
            FieldTable.Type::Decimal:
              exit('Edm.Decimal');
            FieldTable.Type::Date,FieldTable.Type::DateTime,FieldTable.Type::Time:
              exit('Edm.DateTimeOffset');
            FieldTable.Type::Boolean:
              exit('Edm.Boolean');
          end;
    end;

    local procedure AddFieldNodeToEntityNode(var FieldFilterCollectionNodeParam: dotnet FilterCollectionNode;var FieldFilterCollectionNode2Param: dotnet FilterCollectionNode;var EntityFilterCollectionNodeParam: dotnet FilterCollectionNode)
    begin
        if not IsNull(FieldFilterCollectionNode2Param) then begin
          EntityFilterCollectionNodeParam.Collection.Add(FieldFilterCollectionNode2Param);
          Clear(FieldFilterCollectionNode2Param);
        end;

        if not IsNull(FieldFilterCollectionNodeParam) then begin
          EntityFilterCollectionNodeParam.Collection.Add(FieldFilterCollectionNodeParam);
          Clear(FieldFilterCollectionNodeParam);
        end;
    end;

    local procedure InitSelectedColumns(ObjectType: Option ,,,,,,,,"Page","Query";ObjectID: Integer;ColumnDictionary: dotnet Dictionary_Of_T_U;var SourceTableText: Text)
    var
        ObjectMetadata: Record "Object Metadata";
        inStream: InStream;
    begin
        if not ObjectMetadata.Get(ObjectType,ObjectID) then
          exit;
        if not ObjectMetadata.Metadata.Hasvalue then
          exit;

        ObjectMetadata.CalcFields(Metadata);
        ObjectMetadata.Metadata.CreateInstream(inStream);
        InitColumnsForPage(inStream,ColumnDictionary,SourceTableText);
    end;

    local procedure InitColumnsForPage(pageStream: InStream;ColumnDictionary: dotnet Dictionary_Of_T_U;var SourceTableTextParam: Text)
    var
        FieldsTable: Record "Field";
        XMLDOMManagement: Codeunit "XML DOM Management";
        ODataUtility: Codeunit ODataUtility;
        XmlDocument: dotnet XmlDocument;
        XmlNodeList: dotnet XmlNodeList;
        XmlNode: dotnet XmlNode;
        XmlAttribute: dotnet XmlAttribute;
        AttributesCollection: dotnet XmlAttributeCollection;
        NodeListEnum: dotnet IEnumerator;
        CollectionAttributeEnum: dotnet IEnumerator;
        PageStreamText: Text;
        XmlText: Text;
        FieldIDText: Text;
        FieldNameText: Text;
        ValidTag: Boolean;
    begin
        while not pageStream.eos do begin
          Clear(PageStreamText);
          pageStream.ReadText(PageStreamText);
          XmlText := XmlText + PageStreamText;
        end;

        XmlDocument := XmlDocument.XmlDocument;
        if not XMLDOMManagement.LoadXMLDocumentFromText(XmlText,XmlDocument)then
          Error(LoadingXMLErr);

        XmlNodeList := XmlDocument.GetElementsByTagName('SourceObject');
        if XmlNodeList.Count <> 1 then
          Error(LoadingXMLErr);

        NodeListEnum := XmlNodeList.GetEnumerator;
        NodeListEnum.MoveNext;
        XmlNode := NodeListEnum.Current;
        AttributesCollection := XmlNode.Attributes;
        CollectionAttributeEnum := AttributesCollection.GetEnumerator;
        while CollectionAttributeEnum.MoveNext do begin
          XmlAttribute := CollectionAttributeEnum.Current;
          if XmlAttribute.Name = 'SourceTable' then
            SourceTableTextParam := XmlAttribute.Value;
        end;

        XmlNodeList := XmlDocument.GetElementsByTagName('Controls');
        NodeListEnum := XmlNodeList.GetEnumerator;
        while NodeListEnum.MoveNext do begin
          ValidTag := false;
          FieldIDText := '';
          FieldNameText := '';

          XmlNode := NodeListEnum.Current;
          AttributesCollection := XmlNode.Attributes;
          CollectionAttributeEnum := AttributesCollection.GetEnumerator;
          while CollectionAttributeEnum.MoveNext do begin
            XmlAttribute := CollectionAttributeEnum.Current;

            if (XmlAttribute.Name = 'xsi:type') and (XmlAttribute.Value = 'ControlDefinition') then
              ValidTag := true;

            if XmlAttribute.Name = 'Name' then
              FieldNameText := XmlAttribute.Value;

            if XmlAttribute.Name = 'DataColumnName' then
              FieldIDText := XmlAttribute.Value;

            if (XmlAttribute.Name = 'Visible') and (XmlAttribute.Value = 'FALSE') then
              ValidTag := false;

            if StrPos(FieldIDText,'Control') > 0 then
              ValidTag := false;
          end;

          if ValidTag then begin
            Evaluate(FieldsTable.TableNo,SourceTableTextParam);
            Evaluate(FieldsTable."No.",FieldIDText);
            if FieldsTable.Get(FieldsTable.TableNo,FieldsTable."No.") then begin
              if ColumnDictionary.ContainsKey(FieldsTable."No.") then
                exit;

              if FieldNameText = '' then
                FieldNameText := FieldsTable.FieldName;

              // Convert to OData compatible name.
              FieldNameText := ODataUtility.ConvertNavFieldNameToOdataName(FieldNameText);
              ColumnDictionary.Add(FieldsTable."No.",FieldNameText);
            end;
          end;
        end;
    end;

    local procedure InsertSelectedColumns(var TenantWebService: Record "Tenant Web Service";var ColumnDictionary: dotnet Dictionary_Of_T_U;TableNo: Integer)
    var
        TenantWebServiceColumns: Record "Tenant Web Service Columns";
        keyValuePair: dotnet KeyValuePair_Of_T_U;
    begin
        foreach keyValuePair in ColumnDictionary do begin
          Clear(TenantWebServiceColumns);
          TenantWebServiceColumns.Init;
          TenantWebServiceColumns.Validate(TenantWebServiceID,TenantWebService.RecordId);
          TenantWebServiceColumns.Validate("Data Item",TableNo);
          TenantWebServiceColumns.Validate(Include,true);
          TenantWebServiceColumns.Validate("Field Number",keyValuePair.Key);
          TenantWebServiceColumns.Validate("Field Name",CopyStr(keyValuePair.Value,1));
          TenantWebServiceColumns.Insert(true);
        end;
    end;

    local procedure InsertODataRecord(var TenantWebService: Record "Tenant Web Service")
    var
        TenantWebServiceOData: Record "Tenant Web Service OData";
        SelectTextParam: Text;
    begin
        GenerateSelectText(TenantWebService."Service Name",TenantWebService."Object Type",SelectTextParam);

        TenantWebServiceOData.Init;
        TenantWebServiceOData.Validate(TenantWebServiceID,TenantWebService.RecordId);
        TenantWebServiceOData.SetOdataSelectClause(SelectTextParam);
        TenantWebServiceOData.Insert(true);
    end;

    local procedure InsertTenantWebService(ObjectTypeParam: Option ,,,,,"Codeunit",,,"Page","Query";ObjectIDParam: Integer;var TenantWebService: Record "Tenant Web Service";ServiceNameParam: Text[240])
    var
        Counter: Integer;
        ServiceName: Text[240];
    begin
        TenantWebService.Init;
        TenantWebService.Validate("Object Type",Objecttypeparam::Page);
        TenantWebService.Validate("Object ID",ObjectIDParam);
        TenantWebService.Validate(Published,true);
        repeat
          TenantWebService.Validate("Service Name",ServiceNameParam);
          if Counter > 0 then begin
            ServiceName := ServiceNameParam;
            ServiceName += Format(Counter);
            TenantWebService.Validate("Service Name",ServiceName);
          end;
          Counter += 1;
        until TenantWebService.Insert(true) or (Counter = 1000);
    end;

    local procedure GetDefaultSelectText(var ColumnDictionary: dotnet Dictionary_Of_T_U;var SelectTextParam: Text)
    var
        keyValuePair: dotnet KeyValuePair_Of_T_U;
        FirstColumn: Boolean;
    begin
        FirstColumn := true;
        SelectTextParam := '$select=';
        foreach keyValuePair in ColumnDictionary do begin
          if not FirstColumn then
            SelectTextParam += ','
          else
            FirstColumn := false;

          SelectTextParam += CopyStr(keyValuePair.Value,1);
        end;
    end;

    local procedure CreateEndPoint(ObjectTypeParam: Option ,,,,,"Codeunit",,,"Page","Query";ObjectIDParam: Integer;var TenantWebService: Record "Tenant Web Service";ServiceNameParam: Text[240];var ColumnDictionary: dotnet Dictionary_Of_T_U)
    var
        SourceTableText: Text;
        TableNo: Integer;
    begin
        InsertTenantWebService(ObjectTypeParam,ObjectIDParam,TenantWebService,ServiceNameParam);
        InitSelectedColumns(ObjectTypeParam,ObjectIDParam,ColumnDictionary,SourceTableText);
        Evaluate(TableNo,SourceTableText);
        InsertSelectedColumns(TenantWebService,ColumnDictionary,TableNo);
        InsertODataRecord(TenantWebService);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ODataUtility, 'OnEditInExcel', '', false, false)]
    local procedure EditInExcel(ObjectId: Integer)
    var
        Type: Option ,,,,,"Codeunit",,,"Page","Query";
    begin
        GetEndPointAndCreateWorkbook(Type::Page,ObjectId,true);
    end;

    local procedure ExternalizeName(Name: Text): Text
    begin
        // Service names are externalized by replacing some special characters with '_'
        // We should do the same here
        Name := ConvertStr(Name,' ','_');
        Name := ConvertStr(Name,'\','_');
        Name := ConvertStr(Name,'/','_');
        Name := ConvertStr(Name,'''','_');
        Name := ConvertStr(Name,'"','_');
        Name := ConvertStr(Name,'.','_');
        Name := ConvertStr(Name,'(','_');
        Name := ConvertStr(Name,')','_');
        Name := ConvertStr(Name,'-','_');
        Name := ConvertStr(Name,':','_');

        exit(Name);
    end;
}

