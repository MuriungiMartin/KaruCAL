#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 8611 "Config. Package Management"
{
    TableNo = "Config. Package Record";

    trigger OnRun()
    begin
        Clear(RecordsInsertedCount);
        Clear(RecordsModifiedCount);
        InsertPackageRecord(Rec);
    end;

    var
        KeyFieldValueMissingErr: label 'The value of the key field %1 has not been filled in for record %2 : %3.', Comment='Parameter 1 - field name, 2 - table name, 3 - code value. Example: The value of the key field Customer Posting Group has not been filled in for record Customer : XXXXX.';
        ValidatingTableRelationsMsg: label 'Validating table relations';
        RecordsXofYMsg: label 'Records: %1 of %2', Comment='Sample: 5 of 1025. 1025 is total number of records, 5 is a number of the current record ';
        ApplyingPackageMsg: label 'Applying package %1', Comment='%1 = The name of the package being applied.';
        ApplyingTableMsg: label 'Applying table %1', Comment='%1 = The name of the table being applied.';
        NoTablesAndErrorsMsg: label '%1 tables are processed.\%2 errors found.\%3 records inserted.\%4 records modified.', Comment='%1 = number of tables processed, %2 = number of errors, %3 = number of records inserted, %4 = number of records modified';
        NoTablesMsg: label '%1 tables are processed.', Comment='%1 = The number of tables that were processed.';
        UpdatingDimSetsMsg: label 'Updating dimension sets';
        TempConfigRecordForProcessing: Record "Config. Record For Processing" temporary;
        TempAppliedConfigPackageRecord: Record "Config. Package Record" temporary;
        InventorySetup: Record "Inventory Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        ConfigProgressBar: Codeunit "Config. Progress Bar";
        ConfigValidateMgt: Codeunit "Config. Validate Management";
        ConfigMgt: Codeunit "Config. Management";
        ValidationFieldID: Integer;
        RecordsInsertedCount: Integer;
        RecordsModifiedCount: Integer;
        ApplyMode: Option ,PrimaryKey,NonKeyFields;
        ProcessingOrderErr: label 'Cannot set up processing order numbers. A cycle reference exists in the primary keys for table %1.', Comment='%1 = The name of the table.';
        ErrorTypeEnum: Option General,TableRelation;
        HideDialog: Boolean;
        ReferenceSameTableErr: label 'Some lines refer to the same table. You cannot assign a table to a package more than one time.';
        BlankTxt: label '[Blank]';
        DimValueDoesNotExistsErr: label 'Dimension Value %1 %2 does not exist.', Comment='%1 = Dimension Code, %2 = Dimension Value Code';
        MSGPPackageCodeTxt: label 'GB.ENU.CSV';
        QBPackageCodeTxt: label 'DM.IIF';


    procedure InsertPackage(var ConfigPackage: Record "Config. Package";PackageCode: Code[20];PackageName: Text[50];ExcludeConfigTables: Boolean)
    begin
        ConfigPackage.Code := PackageCode;
        ConfigPackage."Package Name" := PackageName;
        ConfigPackage."Exclude Config. Tables" := ExcludeConfigTables;
        ConfigPackage.Insert;
    end;


    procedure InsertPackageTable(var ConfigPackageTable: Record "Config. Package Table";PackageCode: Code[20];TableID: Integer)
    begin
        if not ConfigPackageTable.Get(PackageCode,TableID) then begin
          ConfigPackageTable.Init;
          ConfigPackageTable.Validate("Package Code",PackageCode);
          ConfigPackageTable.Validate("Table ID",TableID);
          ConfigPackageTable.Insert(true);
        end;
    end;


    procedure InsertPackageTableWithoutValidation(var ConfigPackageTable: Record "Config. Package Table";PackageCode: Code[20];TableID: Integer)
    begin
        if not ConfigPackageTable.Get(PackageCode,TableID) then begin
          ConfigPackageTable.Init;
          ConfigPackageTable."Package Code" := PackageCode;
          ConfigPackageTable."Table ID" := TableID;
          ConfigPackageTable.Insert;
        end;
    end;


    procedure InsertPackageField(var ConfigPackageField: Record "Config. Package Field";PackageCode: Code[20];TableID: Integer;FieldID: Integer;FieldName: Text[30];FieldCaption: Text[250];SetInclude: Boolean;SetValidate: Boolean;SetLocalize: Boolean;SetDimension: Boolean)
    begin
        if not ConfigPackageField.Get(PackageCode,TableID,FieldID) then begin
          ConfigPackageField.Init;
          ConfigPackageField.Validate("Package Code",PackageCode);
          ConfigPackageField.Validate("Table ID",TableID);
          ConfigPackageField.Validate(Dimension,SetDimension);
          ConfigPackageField.Validate("Field ID",FieldID);
          ConfigPackageField."Field Name" := FieldName;
          ConfigPackageField."Field Caption" := FieldCaption;
          ConfigPackageField."Primary Key" := ConfigValidateMgt.IsKeyField(TableID,FieldID);
          ConfigPackageField."Include Field" := SetInclude or ConfigPackageField."Primary Key";
          if not SetDimension then begin
            ConfigPackageField."Relation Table ID" := ConfigValidateMgt.GetRelationTableID(TableID,FieldID);
            ConfigPackageField."Validate Field" :=
              ConfigPackageField."Include Field" and SetValidate and not ValidateException(TableID,FieldID);
          end;
          ConfigPackageField."Localize Field" := SetLocalize;
          ConfigPackageField.Dimension := SetDimension;
          if SetDimension then
            ConfigPackageField."Processing Order" := ConfigPackageField."Field ID";
          ConfigPackageField.Insert;
        end;
    end;


    procedure InsertPackageFilter(var ConfigPackageFilter: Record "Config. Package Filter";PackageCode: Code[20];TableID: Integer;ProcessingRuleNo: Integer;FieldID: Integer;FieldFilter: Text[250])
    begin
        if not ConfigPackageFilter.Get(PackageCode,TableID,0,FieldID) then begin
          ConfigPackageFilter.Init;
          ConfigPackageFilter.Validate("Package Code",PackageCode);
          ConfigPackageFilter.Validate("Table ID",TableID);
          ConfigPackageFilter.Validate("Processing Rule No.",ProcessingRuleNo);
          ConfigPackageFilter.Validate("Field ID",FieldID);
          ConfigPackageFilter.Validate("Field Filter",FieldFilter);
          ConfigPackageFilter.Insert;
        end else
          if ConfigPackageFilter."Field Filter" <> FieldFilter then begin
            ConfigPackageFilter."Field Filter" := FieldFilter;
            ConfigPackageFilter.Modify;
          end;
    end;


    procedure InsertPackageRecord(ConfigPackageRecord: Record "Config. Package Record")
    var
        RecRef: RecordRef;
    begin
        if (ConfigPackageRecord."Package Code" = '') or (ConfigPackageRecord."Table ID" = 0) then
          exit;

        if ConfigMgt.IsSystemTable(ConfigPackageRecord."Table ID") then
          exit;

        RecRef.Open(ConfigPackageRecord."Table ID");
        if ApplyMode <> Applymode::NonKeyFields then
          RecRef.Init;

        InsertPrimaryKeyFields(RecRef,ConfigPackageRecord,true);

        if ApplyMode = Applymode::PrimaryKey then
          UpdateKeyInfoForConfigPackageRecord(RecRef,ConfigPackageRecord);

        if ApplyMode = Applymode::NonKeyFields then
          ModifyRecordDataFields(RecRef,ConfigPackageRecord,true);
    end;


    procedure InsertPackageData(var ConfigPackageData: Record "Config. Package Data";PackageCode: Code[20];TableID: Integer;No: Integer;FieldID: Integer;Value: Text[250];Invalid: Boolean)
    begin
        if not ConfigPackageData.Get(PackageCode,TableID,No,FieldID) then begin
          ConfigPackageData.Init;
          ConfigPackageData."Package Code" := PackageCode;
          ConfigPackageData."Table ID" := TableID;
          ConfigPackageData."No." := No;
          ConfigPackageData."Field ID" := FieldID;
          ConfigPackageData.Value := Value;
          ConfigPackageData.Invalid := Invalid;
          ConfigPackageData.Insert;
        end else
          if ConfigPackageData.Value <> Value then begin
            ConfigPackageData.Value := Value;
            ConfigPackageData.Modify;
          end;
    end;


    procedure InsertProcessingRule(var ConfigTableProcessingRule: Record "Config. Table Processing Rule";ConfigPackageTable: Record "Config. Package Table";RuleNo: Integer;NewAction: Option)
    begin
        with ConfigTableProcessingRule do begin
          Validate("Package Code",ConfigPackageTable."Package Code");
          Validate("Table ID",ConfigPackageTable."Table ID");
          Validate("Rule No.",RuleNo);
          Validate(Action,NewAction);
          Insert(true);
        end;
    end;


    procedure InsertProcessingRuleCustom(var ConfigTableProcessingRule: Record "Config. Table Processing Rule";ConfigPackageTable: Record "Config. Package Table";RuleNo: Integer;CodeunitID: Integer)
    begin
        with ConfigTableProcessingRule do begin
          Validate("Package Code",ConfigPackageTable."Package Code");
          Validate("Table ID",ConfigPackageTable."Table ID");
          Validate("Rule No.",RuleNo);
          Validate(Action,Action::Custom);
          Validate("Custom Processing Codeunit ID",CodeunitID);
          Insert(true);
        end;
    end;


    procedure SetSkipTableTriggers(var ConfigPackageTable: Record "Config. Package Table";PackageCode: Code[20];TableID: Integer;Skip: Boolean)
    begin
        if ConfigPackageTable.Get(PackageCode,TableID) then begin
          ConfigPackageTable.Validate("Skip Table Triggers",Skip);
          ConfigPackageTable.Modify(true);
        end;
    end;


    procedure GetNumberOfRecordsInserted(): Integer
    begin
        exit(RecordsInsertedCount);
    end;


    procedure GetNumberOfRecordsModified(): Integer
    begin
        exit(RecordsModifiedCount);
    end;

    local procedure InsertPrimaryKeyFields(var RecRef: RecordRef;ConfigPackageRecord: Record "Config. Package Record";DoInsert: Boolean)
    var
        ConfigPackageData: Record "Config. Package Data";
        ConfigPackageField: Record "Config. Package Field";
        ConfigPackageTable: Record "Config. Package Table";
        TempConfigPackageField: Record "Config. Package Field" temporary;
        ConfigPackageError: Record "Config. Package Error";
        RecRef1: RecordRef;
        FieldRef: FieldRef;
    begin
        ConfigPackageData.SetRange("Package Code",ConfigPackageRecord."Package Code");
        ConfigPackageData.SetRange("Table ID",ConfigPackageRecord."Table ID");
        ConfigPackageData.SetRange("No.",ConfigPackageRecord."No.");

        GetKeyFieldsOrder(RecRef,ConfigPackageRecord."Package Code",TempConfigPackageField);

        TempConfigPackageField.Reset;
        TempConfigPackageField.SetCurrentkey("Package Code","Table ID","Processing Order");

        TempConfigPackageField.FindSet;
        repeat
          FieldRef := RecRef.Field(TempConfigPackageField."Field ID");
          ConfigPackageData.SetRange("Field ID",TempConfigPackageField."Field ID");
          if ConfigPackageData.FindFirst then begin
            ConfigPackageField.Get(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."Field ID");
            UpdateValueUsingMapping(ConfigPackageData,ConfigPackageField,ConfigPackageRecord."Package Code");
            ValidationFieldID := FieldRef.Number;
            ConfigValidateMgt.EvaluateTextToFieldRef(
              ConfigPackageData.Value,FieldRef,ConfigPackageField."Validate Field" and (ApplyMode = Applymode::PrimaryKey));
          end else
            Error(KeyFieldValueMissingErr,FieldRef.Name,RecRef.Name,ConfigPackageData."No.");
        until TempConfigPackageField.Next = 0;

        RecRef1 := RecRef.Duplicate;

        if RecRef1.Find then begin
          RecRef := RecRef1;
          exit
        end;
        if ((ConfigPackageRecord."Package Code" = QBPackageCodeTxt) or (ConfigPackageRecord."Package Code" = MSGPPackageCodeTxt)) and
           (ConfigPackageRecord."Table ID" = 15)
        then
          if ConfigPackageError.Get(
               ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID",ConfigPackageRecord."No.",1)
          then
            exit;

        if DoInsert then begin
          ConfigPackageTable.Get(ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID");
          RecRef.Insert(not ConfigPackageTable."Skip Table Triggers");
          RecordsInsertedCount += 1;
        end;
    end;

    local procedure UpdateKeyInfoForConfigPackageRecord(RecRef: RecordRef;ConfigPackageRecord: Record "Config. Package Record")
    var
        ConfigPackageData: Record "Config. Package Data";
        KeyRef: KeyRef;
        FieldRef: FieldRef;
        KeyFieldCount: Integer;
    begin
        KeyRef := RecRef.KeyIndex(1);
        for KeyFieldCount := 1 to KeyRef.FieldCount do begin
          FieldRef := KeyRef.FieldIndex(KeyFieldCount);

          ConfigPackageData.Get(
            ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID",ConfigPackageRecord."No.",FieldRef.Number);
          ConfigPackageData.Value := FieldRef.Value;
          ConfigPackageData.Modify;
        end;
    end;


    procedure InitPackageRecord(var ConfigPackageRecord: Record "Config. Package Record";PackageCode: Code[20];TableID: Integer)
    var
        NextNo: Integer;
    begin
        ConfigPackageRecord.Reset;
        ConfigPackageRecord.SetRange("Package Code",PackageCode);
        ConfigPackageRecord.SetRange("Table ID",TableID);
        if ConfigPackageRecord.FindLast then
          NextNo := ConfigPackageRecord."No." + 1
        else
          NextNo := 1;

        ConfigPackageRecord.Init;
        ConfigPackageRecord."Package Code" := PackageCode;
        ConfigPackageRecord."Table ID" := TableID;
        ConfigPackageRecord."No." := NextNo;
        ConfigPackageRecord.Insert;
    end;

    local procedure ModifyRecordDataFields(var RecRef: RecordRef;ConfigPackageRecord: Record "Config. Package Record";DoModify: Boolean)
    var
        ConfigPackageData: Record "Config. Package Data";
        ConfigPackageField: Record "Config. Package Field";
        ConfigQuestion: Record "Config. Question";
        "Field": Record "Field";
        ConfigPackageTable: Record "Config. Package Table";
        ConfigPackageError: Record "Config. Package Error";
        ConfigQuestionnaireMgt: Codeunit "Questionnaire Management";
        FieldRef: FieldRef;
    begin
        ConfigPackageField.Reset;
        ConfigPackageField.SetCurrentkey("Package Code","Table ID","Processing Order");
        ConfigPackageField.SetRange("Package Code",ConfigPackageRecord."Package Code");
        ConfigPackageField.SetRange("Table ID",ConfigPackageRecord."Table ID");
        ConfigPackageField.SetRange("Include Field",true);
        ConfigPackageField.SetRange(Dimension,false);

        if DoModify then begin
          ConfigPackageTable.Get(ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID");
          ApplyTemplate(ConfigPackageTable,RecRef);
        end;

        if ConfigPackageField.FindSet then
          repeat
            ValidationFieldID := ConfigPackageField."Field ID";
            if ((ConfigPackageRecord."Package Code" = QBPackageCodeTxt) or (ConfigPackageRecord."Package Code" = MSGPPackageCodeTxt)) and
               ((ConfigPackageRecord."Table ID" = 15) or (ConfigPackageRecord."Table ID" = 18) or
                (ConfigPackageRecord."Table ID" = 23) or (ConfigPackageRecord."Table ID" = 27))
            then
              if ConfigPackageError.Get(
                   ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID",ConfigPackageRecord."No.",1)
              then
                exit;

            if ConfigPackageData.Get(
                 ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID",ConfigPackageRecord."No.",
                 ConfigPackageField."Field ID")
            then
              if not ConfigPackageField."Primary Key" then begin
                FieldRef := RecRef.Field(ConfigPackageField."Field ID");
                UpdateValueUsingMapping(ConfigPackageData,ConfigPackageField,ConfigPackageRecord."Package Code");

                case true of
                  IsBLOBField(ConfigPackageData."Table ID",ConfigPackageData."Field ID"):
                    EvaluateBLOBToFieldRef(ConfigPackageData,FieldRef);
                  IsMediaSetField(ConfigPackageData."Table ID",ConfigPackageData."Field ID"):
                    ImportMediaSetFiles(ConfigPackageData,FieldRef,DoModify);
                  IsMediaField(ConfigPackageData."Table ID",ConfigPackageData."Field ID"):
                    ImportMediaFiles(ConfigPackageData,FieldRef,DoModify);
                  else
                    if (ConfigPackageData.Value <> '') or TextFieldIsBlank(FieldRef) then
                      ConfigValidateMgt.EvaluateTextToFieldRef(
                        ConfigPackageData.Value,FieldRef,
                        ConfigPackageField."Validate Field" and (ApplyMode = Applymode::NonKeyFields));
                end;
              end;
          until ConfigPackageField.Next = 0;

        if DoModify then begin
          RecRef.Modify(not ConfigPackageTable."Skip Table Triggers");
          RecordsModifiedCount += 1;

          if RecRef.Number <> Database::"Config. Question" then
            exit;

          RecRef.SetTable(ConfigQuestion);

          SetFieldFilter(Field,ConfigQuestion."Table ID",ConfigQuestion."Field ID");
          if Field.FindFirst then
            ConfigQuestionnaireMgt.ModifyConfigQuestionAnswer(ConfigQuestion,Field);
        end;
    end;

    local procedure ApplyTemplate(ConfigPackageTable: Record "Config. Package Table";var RecRef: RecordRef)
    var
        ConfigTemplateHeader: Record "Config. Template Header";
        ConfigTemplateMgt: Codeunit "Config. Template Management";
    begin
        if ConfigTemplateHeader.Get(ConfigPackageTable."Data Template") then
          ConfigTemplateMgt.UpdateRecord(ConfigTemplateHeader,RecRef);
    end;

    local procedure TextFieldIsBlank(var FieldRef: FieldRef): Boolean
    begin
        exit(Format(FieldRef.Value) = '')
    end;


    procedure ValidatePackageRelations(var ConfigPackageTable: Record "Config. Package Table";var TempConfigPackageTable: Record "Config. Package Table" temporary;SetupProcessingOrderForTables: Boolean)
    var
        TableCount: Integer;
    begin
        if SetupProcessingOrderForTables then
          SetupProcessingOrder(ConfigPackageTable);

        with ConfigPackageTable do begin
          TableCount := Count;
          if not HideDialog then
            ConfigProgressBar.Init(TableCount,1,ValidatingTableRelationsMsg);

          ModifyAll(Validated,false);

          SetCurrentkey("Package Processing Order","Processing Order");
          if FindSet then
            repeat
              CalcFields("Table Name");
              if not HideDialog then
                ConfigProgressBar.Update("Table Name");
              ValidateTableRelation("Package Code","Table ID",TempConfigPackageTable);

              TempConfigPackageTable.Init;
              TempConfigPackageTable."Package Code" := "Package Code";
              TempConfigPackageTable."Table ID" := "Table ID";
              TempConfigPackageTable.Insert;
              Validated := true;
              Modify;
            until Next = 0;
          if not HideDialog then
            ConfigProgressBar.Close;
        end;

        if not HideDialog then
          Message(NoTablesMsg,TableCount);
    end;

    local procedure ValidateTableRelation(PackageCode: Code[20];TableId: Integer;var ValidatedConfigPackageTable: Record "Config. Package Table")
    var
        ConfigPackageField: Record "Config. Package Field";
    begin
        ConfigPackageField.SetCurrentkey("Package Code","Table ID","Processing Order");
        ConfigPackageField.SetRange("Package Code",PackageCode);
        ConfigPackageField.SetRange("Table ID",TableId);
        ConfigPackageField.SetRange("Validate Field",true);
        if ConfigPackageField.FindSet then
          repeat
            ValidateFieldRelation(ConfigPackageField,ValidatedConfigPackageTable);
          until ConfigPackageField.Next = 0;
    end;


    procedure ValidateFieldRelation(ConfigPackageField: Record "Config. Package Field";var ValidatedConfigPackageTable: Record "Config. Package Table") NoValidateErrors: Boolean
    var
        ConfigPackageData: Record "Config. Package Data";
    begin
        NoValidateErrors := true;

        ConfigPackageData.SetRange("Package Code",ConfigPackageField."Package Code");
        ConfigPackageData.SetRange("Table ID",ConfigPackageField."Table ID");
        ConfigPackageData.SetRange("Field ID",ConfigPackageField."Field ID");
        if ConfigPackageData.FindSet then
          repeat
            NoValidateErrors :=
              NoValidateErrors and
              ValidatePackageDataRelation(ConfigPackageData,ValidatedConfigPackageTable,ConfigPackageField,true);
          until ConfigPackageData.Next = 0;
    end;


    procedure ValidateSinglePackageDataRelation(var ConfigPackageData: Record "Config. Package Data"): Boolean
    var
        TempConfigPackageTable: Record "Config. Package Table" temporary;
        ConfigPackageField: Record "Config. Package Field";
    begin
        ConfigPackageField.Get(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."Field ID");
        exit(ValidatePackageDataRelation(ConfigPackageData,TempConfigPackageTable,ConfigPackageField,false));
    end;

    local procedure ValidatePackageDataRelation(var ConfigPackageData: Record "Config. Package Data";var ValidatedConfigPackageTable: Record "Config. Package Table";var ConfigPackageField: Record "Config. Package Field";GenerateFieldError: Boolean): Boolean
    var
        ErrorText: Text[250];
        RelationTableNo: Integer;
        RelationFieldNo: Integer;
        DataInPackageData: Boolean;
    begin
        if Format(ConfigPackageData.Value) <> '' then begin
          DataInPackageData := false;
          if GetRelationInfo(ConfigPackageField,RelationTableNo,RelationFieldNo) then
            DataInPackageData :=
              ValidateFieldRelationAgainstPackageData(
                ConfigPackageData,ValidatedConfigPackageTable,RelationTableNo,RelationFieldNo);

          if not DataInPackageData then begin
            ErrorText := ValidateFieldRelationAgainstCompanyData(ConfigPackageData);
            if ErrorText <> '' then begin
              if GenerateFieldError then
                FieldError(ConfigPackageData,ErrorText,Errortypeenum::TableRelation);
              exit(false);
            end;
          end;
        end;

        if PackageErrorsExists(ConfigPackageData,Errortypeenum::TableRelation) then
          CleanFieldError(ConfigPackageData);
        exit(true);
    end;


    procedure ValidateException(TableID: Integer;FieldID: Integer): Boolean
    begin
        case TableID of
          // Dimension Value ID: ERROR message
          Database::"Dimension Value":
            exit(FieldID = 12);
          // Default Dimension: multi-relations
          Database::"Default Dimension":
            exit(FieldID = 2);
          // VAT %: CheckVATIdentifier
          Database::"VAT Posting Setup":
            exit(FieldID = 4);
          // Table ID - OnValidate
          Database::"Config. Template Header":
            exit(FieldID = 3);
          // Field ID relation
          Database::"Config. Template Line":
            exit(FieldID in [4,8,12]);
          // Dimensions as Columns
          Database::"Config. Line":
            exit(FieldID = 12);
          // Customer : Contact OnValidate
          Database::Customer:
            exit(FieldID = 8);
          // Vendor : Contact OnValidate
          Database::Vendor:
            exit(FieldID = 8);
          // Item : Base Unit of Measure OnValidate
          Database::Item:
            exit(FieldID = 8);
          // "No." to pass not manual No. Series
          Database::"Sales Header",Database::"Purchase Header":
            exit(FieldID = 3);
          // "Document No." conditional relation
          Database::"Sales Line",Database::"Purchase Line":
            exit(FieldID = 3);
        end;
        exit(false);
    end;


    procedure IsDimSetIDField(TableId: Integer;FieldId: Integer): Boolean
    var
        DimensionValue: Record "Dimension Value";
    begin
        exit((TableId = Database::"Dimension Value") and (DimensionValue.FieldNo("Dimension Value ID") = FieldId));
    end;

    local procedure GetRelationInfo(ConfigPackageField: Record "Config. Package Field";var RelationTableNo: Integer;var RelationFieldNo: Integer): Boolean
    begin
        exit(
          ConfigValidateMgt.GetRelationInfoByIDs(
            ConfigPackageField."Table ID",ConfigPackageField."Field ID",RelationTableNo,RelationFieldNo));
    end;

    local procedure ValidateFieldRelationAgainstCompanyData(ConfigPackageData: Record "Config. Package Data"): Text[250]
    var
        TempConfigPackageField: Record "Config. Package Field" temporary;
        ConfigPackageRecord: Record "Config. Package Record";
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef.Open(ConfigPackageData."Table ID");
        ConfigPackageRecord.Get(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."No.");
        InsertPrimaryKeyFields(RecRef,ConfigPackageRecord,false);
        ModifyRecordDataFields(RecRef,ConfigPackageRecord,false);

        FieldRef := RecRef.Field(ConfigPackageData."Field ID");
        ConfigValidateMgt.EvaluateValue(FieldRef,ConfigPackageData.Value,false);

        GetFieldsOrder(RecRef,ConfigPackageRecord."Package Code",TempConfigPackageField);
        exit(ConfigValidateMgt.ValidateFieldRefRelationAgainstCompanyData(FieldRef,TempConfigPackageField));
    end;

    local procedure ValidateFieldRelationAgainstPackageData(ConfigPackageData: Record "Config. Package Data";var ValidatedConfigPackageTable: Record "Config. Package Table";RelationTableNo: Integer;RelationFieldNo: Integer): Boolean
    var
        RelatedConfigPackageData: Record "Config. Package Data";
        ConfigPackageTable: Record "Config. Package Table";
        TablePriority: Integer;
    begin
        if not ConfigPackageTable.Get(ConfigPackageData."Package Code",RelationTableNo) then
          exit(false);

        TablePriority := ConfigPackageTable."Processing Order";
        if ConfigValidateMgt.IsRelationInKeyFields(ConfigPackageData."Table ID",ConfigPackageData."Field ID") then begin
          ConfigPackageTable.Get(ConfigPackageData."Package Code",ConfigPackageData."Table ID");

          if ConfigPackageTable."Processing Order" < TablePriority then
            exit(false);

          // That current order will be for apply data
          ValidatedConfigPackageTable.Reset;
          ValidatedConfigPackageTable.SetRange("Table ID",RelationTableNo);
          if ValidatedConfigPackageTable.IsEmpty then
            exit(false);
        end;

        RelatedConfigPackageData.SetRange("Package Code",ConfigPackageData."Package Code");
        RelatedConfigPackageData.SetRange("Table ID",RelationTableNo);
        RelatedConfigPackageData.SetRange("Field ID",RelationFieldNo);
        RelatedConfigPackageData.SetRange(Value,ConfigPackageData.Value);
        exit(not RelatedConfigPackageData.IsEmpty);
    end;


    procedure RecordError(var ConfigPackageRecord: Record "Config. Package Record";ValidationFieldID: Integer;ErrorText: Text[250])
    var
        ConfigPackageError: Record "Config. Package Error";
        ConfigPackageData: Record "Config. Package Data";
        RecordID: RecordID;
    begin
        if ErrorText = '' then
          exit;

        ConfigPackageError.Init;
        ConfigPackageError."Package Code" := ConfigPackageRecord."Package Code";
        ConfigPackageError."Table ID" := ConfigPackageRecord."Table ID";
        ConfigPackageError."Record No." := ConfigPackageRecord."No.";
        ConfigPackageError."Field ID" := ValidationFieldID;
        ConfigPackageError."Error Text" := ErrorText;

        ConfigPackageData.SetRange("Package Code",ConfigPackageRecord."Package Code");
        ConfigPackageData.SetRange("Table ID",ConfigPackageRecord."Table ID");
        ConfigPackageData.SetRange("No.",ConfigPackageRecord."No.");
        if Evaluate(RecordID,GetRecordIDOfRecordError(ConfigPackageData)) then
          ConfigPackageError."Record ID" := RecordID;
        if not ConfigPackageError.Insert then
          ConfigPackageError.Modify;
        ConfigPackageRecord.Invalid := true;
        ConfigPackageRecord.Modify;
    end;


    procedure FieldError(var ConfigPackageData: Record "Config. Package Data";ErrorText: Text[250];ErrorType: Option ,TableRelation)
    var
        ConfigPackageRecord: Record "Config. Package Record";
        ConfigPackageError: Record "Config. Package Error";
        ConfigPackageData2: Record "Config. Package Data";
        RecordID: RecordID;
    begin
        if ErrorText = '' then
          exit;

        ConfigPackageError.Init;
        ConfigPackageError."Package Code" := ConfigPackageData."Package Code";
        ConfigPackageError."Table ID" := ConfigPackageData."Table ID";
        ConfigPackageError."Record No." := ConfigPackageData."No.";
        ConfigPackageError."Field ID" := ConfigPackageData."Field ID";
        ConfigPackageError."Error Text" := ErrorText;
        ConfigPackageError."Error Type" := ErrorType;

        ConfigPackageData2.SetRange("Package Code",ConfigPackageData."Package Code");
        ConfigPackageData2.SetRange("Table ID",ConfigPackageData."Table ID");
        ConfigPackageData2.SetRange("No.",ConfigPackageData."No.");
        if Evaluate(RecordID,GetRecordIDOfRecordError(ConfigPackageData2)) then
          ConfigPackageError."Record ID" := RecordID;
        if not ConfigPackageError.Insert then
          ConfigPackageError.Modify;

        ConfigPackageData.Invalid := true;
        ConfigPackageData.Modify;

        ConfigPackageRecord.Get(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."No.");
        ConfigPackageRecord.Invalid := true;
        ConfigPackageRecord.Modify;
    end;


    procedure CleanRecordError(var ConfigPackageRecord: Record "Config. Package Record")
    var
        ConfigPackageError: Record "Config. Package Error";
    begin
        ConfigPackageError.SetRange("Package Code",ConfigPackageRecord."Package Code");
        ConfigPackageError.SetRange("Table ID",ConfigPackageRecord."Table ID");
        ConfigPackageError.SetRange("Record No.",ConfigPackageRecord."No.");
        ConfigPackageError.DeleteAll;
    end;


    procedure CleanFieldError(var ConfigPackageData: Record "Config. Package Data")
    var
        ConfigPackageError: Record "Config. Package Error";
        ConfigPackageRecord: Record "Config. Package Record";
    begin
        ConfigPackageError.SetRange("Package Code",ConfigPackageData."Package Code");
        ConfigPackageError.SetRange("Table ID",ConfigPackageData."Table ID");
        ConfigPackageError.SetRange("Record No.",ConfigPackageData."No.");
        ConfigPackageError.SetRange("Field ID",ConfigPackageData."Field ID");
        ConfigPackageError.DeleteAll;

        ConfigPackageData.Invalid := false;
        ConfigPackageData.Modify;

        ConfigPackageRecord.Get(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."No.");

        ConfigPackageError.Reset;
        ConfigPackageError.SetRange("Package Code",ConfigPackageData."Package Code");
        ConfigPackageError.SetRange("Table ID",ConfigPackageData."Table ID");
        ConfigPackageError.SetRange("Record No.",ConfigPackageData."No.");
        if ConfigPackageError.FindFirst then
          ConfigPackageRecord.Invalid := true
        else
          ConfigPackageRecord.Invalid := false;

        ConfigPackageRecord.Modify;
    end;

    local procedure CleanPackageErrors(PackageCode: Code[20];TableFilter: Text)
    var
        ConfigPackageError: Record "Config. Package Error";
    begin
        ConfigPackageError.SetRange("Package Code",PackageCode);
        if TableFilter <> '' then
          ConfigPackageError.SetFilter("Table ID",TableFilter);

        ConfigPackageError.DeleteAll;
    end;

    local procedure PackageErrorsExists(ConfigPackageData: Record "Config. Package Data";ErrorType: Option General,TableRelation): Boolean
    var
        ConfigPackageError: Record "Config. Package Error";
    begin
        if not ConfigPackageError.Get(
             ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."No.",ConfigPackageData."Field ID")
        then
          exit(false);

        if ConfigPackageError."Error Type" = ErrorType then
          exit(true);

        exit(false)
    end;


    procedure GetValidationFieldID(): Integer
    begin
        exit(ValidationFieldID);
    end;


    procedure ApplyConfigLines(var ConfigLine: Record "Config. Line")
    var
        ConfigPackage: Record "Config. Package";
        ConfigPackageTable: Record "Config. Package Table";
        ConfigMgt: Codeunit "Config. Management";
        "Filter": Text;
    begin
        ConfigLine.FindFirst;
        ConfigPackage.Get(ConfigLine."Package Code");
        ConfigPackageTable.SetRange("Package Code",ConfigLine."Package Code");
        Filter := ConfigMgt.MakeTableFilter(ConfigLine,false);

        if Filter = '' then
          exit;

        ConfigPackageTable.SetFilter("Table ID",Filter);
        ApplyPackage(ConfigPackage,ConfigPackageTable,true);
    end;


    procedure ApplyPackage(ConfigPackage: Record "Config. Package";var ConfigPackageTable: Record "Config. Package Table";SetupProcessingOrderForTables: Boolean) ErrorCount: Integer
    var
        DimSetEntry: Record "Dimension Set Entry";
        TableCount: Integer;
        DimSetIDUsed: Boolean;
        ResetPostingSetup: Boolean;
    begin
        InventorySetup.Reset;
        InventorySetup.FindFirst;
        ResetPostingSetup := false;
        if InventorySetup."Automatic Cost Posting" then begin
          InventorySetup."Automatic Cost Posting" := false;
          InventorySetup.Modify;
          ResetPostingSetup := true;
        end;
        ConfigPackage.CalcFields("No. of Records","No. of Errors");
        TableCount := ConfigPackageTable.Count;
        if (ConfigPackage.Code <> MSGPPackageCodeTxt) and (ConfigPackage.Code <> QBPackageCodeTxt) then
          // Hold the error count for duplicate records.
          ErrorCount := ConfigPackage."No. of Errors";
        if (TableCount = 0) or (ConfigPackage."No. of Records" = 0) then
          exit;
        if (ConfigPackage.Code <> MSGPPackageCodeTxt) and (ConfigPackage.Code <> QBPackageCodeTxt) then
          // Skip this code to hold the error count for duplicate records.
          CleanPackageErrors(ConfigPackage.Code,ConfigPackageTable.GetFilter("Table ID"));

        if SetupProcessingOrderForTables then begin
          SetupProcessingOrder(ConfigPackageTable);
          Commit;
        end;

        DimSetIDUsed := false;
        if ConfigPackageTable.FindSet then
          repeat
            DimSetIDUsed := ConfigMgt.IsDimSetIDTable(ConfigPackageTable."Table ID");
          until (ConfigPackageTable.Next = 0) or DimSetIDUsed;

        if DimSetIDUsed and not DimSetEntry.IsEmpty then
          UpdateDimSetIDValues(ConfigPackage);
        if (ConfigPackage.Code <> MSGPPackageCodeTxt) and (ConfigPackage.Code <> QBPackageCodeTxt) then
          DeleteAppliedPackageRecords(TempAppliedConfigPackageRecord); // Do not delete PackageRecords till transactions are created

        Commit;

        TempAppliedConfigPackageRecord.DeleteAll;
        TempConfigRecordForProcessing.DeleteAll;
        Clear(RecordsInsertedCount);
        Clear(RecordsModifiedCount);

        // Handle independent tables
        ConfigPackageTable.SetRange("Parent Table ID",0);
        ApplyPackageTables(ConfigPackage,ConfigPackageTable,Applymode::PrimaryKey);
        ApplyPackageTables(ConfigPackage,ConfigPackageTable,Applymode::NonKeyFields);

        // Handle children tables
        ConfigPackageTable.SetFilter("Parent Table ID",'>0');
        ApplyPackageTables(ConfigPackage,ConfigPackageTable,Applymode::PrimaryKey);
        ApplyPackageTables(ConfigPackage,ConfigPackageTable,Applymode::NonKeyFields);

        ProcessAppliedPackageRecords(TempConfigRecordForProcessing,TempAppliedConfigPackageRecord);
        if (ConfigPackage.Code <> MSGPPackageCodeTxt) and (ConfigPackage.Code <> QBPackageCodeTxt) then
          DeleteAppliedPackageRecords(TempAppliedConfigPackageRecord); // Do not delete PackageRecords till transactions are created

        ConfigPackage.CalcFields("No. of Errors");
        ErrorCount := ConfigPackage."No. of Errors" - ErrorCount;
        if ErrorCount < 0 then
          ErrorCount := 0;

        RecordsModifiedCount := MaxInt(RecordsModifiedCount - RecordsInsertedCount,0);

        if not HideDialog then
          Message(NoTablesAndErrorsMsg,TableCount,ErrorCount,RecordsInsertedCount,RecordsModifiedCount);

        if ResetPostingSetup then begin
          GeneralLedgerSetup.Reset;
          GeneralLedgerSetup.FindFirst;
          if not GeneralLedgerSetup."Use Legacy G/L Entry Locking" then begin
            GeneralLedgerSetup."Use Legacy G/L Entry Locking" := true;
            GeneralLedgerSetup.Modify;
          end;
          InventorySetup.Reset;
          InventorySetup.FindFirst;
          InventorySetup."Automatic Cost Posting" := true;
          InventorySetup.Modify;
          ResetPostingSetup := false;
        end;
    end;

    local procedure ApplyPackageTables(ConfigPackage: Record "Config. Package";var ConfigPackageTable: Record "Config. Package Table";ApplyMode: Option ,PrimaryKey,NonKeyFields)
    var
        ConfigPackageRecord: Record "Config. Package Record";
    begin
        ConfigPackageTable.SetCurrentkey("Package Processing Order","Processing Order");

        if not HideDialog then
          ConfigProgressBar.Init(ConfigPackageTable.Count,1,
            StrSubstNo(ApplyingPackageMsg,ConfigPackage.Code));
        if ConfigPackageTable.FindSet then
          repeat
            ConfigPackageTable.CalcFields("Table Name");
            ConfigPackageRecord.SetRange("Package Code",ConfigPackageTable."Package Code");
            ConfigPackageRecord.SetRange("Table ID",ConfigPackageTable."Table ID");
            if not HideDialog then
              ConfigProgressBar.Update(ConfigPackageTable."Table Name");
            if not IsTableErrorsExists(ConfigPackageTable) then// Added to show item duplicate errors
              ApplyPackageRecords(
                ConfigPackageRecord,ConfigPackageTable."Package Code",ConfigPackageTable."Table ID",ApplyMode);
          until ConfigPackageTable.Next = 0;

        if not HideDialog then
          ConfigProgressBar.Close;
    end;


    procedure ApplySelectedPackageRecords(var ConfigPackageRecord: Record "Config. Package Record";PackageCode: Code[20];TableNo: Integer)
    begin
        TempAppliedConfigPackageRecord.DeleteAll;
        TempConfigRecordForProcessing.DeleteAll;

        ApplyPackageRecords(ConfigPackageRecord,PackageCode,TableNo,Applymode::PrimaryKey);
        ApplyPackageRecords(ConfigPackageRecord,PackageCode,TableNo,Applymode::NonKeyFields);

        ProcessAppliedPackageRecords(TempConfigRecordForProcessing,TempAppliedConfigPackageRecord);
        DeleteAppliedPackageRecords(TempAppliedConfigPackageRecord);
    end;

    local procedure ApplyPackageRecords(var ConfigPackageRecord: Record "Config. Package Record";PackageCode: Code[20];TableNo: Integer;ApplyMode: Option ,PrimaryKey,NonKeyFields)
    var
        ConfigPackageTable: Record "Config. Package Table";
        ConfigTableProcessingRule: Record "Config. Table Processing Rule";
        ConfigPackageMgt: Codeunit "Config. Package Management";
        ConfigProgressBarRecord: Codeunit "Config. Progress Bar";
        RecRef: RecordRef;
        RecordCount: Integer;
        StepCount: Integer;
        Counter: Integer;
        ProcessingRuleIsSet: Boolean;
    begin
        ConfigPackageTable.Get(PackageCode,TableNo);
        ProcessingRuleIsSet := ConfigTableProcessingRule.FindTableRules(ConfigPackageTable);

        ConfigPackageMgt.SetApplyMode(ApplyMode);
        RecordCount := ConfigPackageRecord.Count;
        if not HideDialog and (RecordCount > 1000) then begin
          StepCount := ROUND(RecordCount / 100,1);
          ConfigPackageTable.CalcFields("Table Name");
          ConfigProgressBarRecord.Init(
            RecordCount,StepCount,StrSubstNo(ApplyingTableMsg,ConfigPackageTable."Table Name"));
        end;

        Counter := 0;
        if ConfigPackageRecord.FindSet then begin
          RecRef.Open(ConfigPackageRecord."Table ID");
          if ConfigPackageTable."Delete Recs Before Processing" then begin
            RecRef.DeleteAll;
            Commit;
          end;
          repeat
            Counter := Counter + 1;
            if (ApplyMode = Applymode::PrimaryKey) or not IsRecordErrorsExistsInPrimaryKeyFields(ConfigPackageRecord) then begin
              if ConfigPackageMgt.Run(ConfigPackageRecord) then begin
                if not ((ApplyMode = Applymode::PrimaryKey) or IsRecordErrorsExists(ConfigPackageRecord)) then begin
                  CollectAppliedPackageRecord(ConfigPackageRecord,TempAppliedConfigPackageRecord);
                  if ProcessingRuleIsSet then
                    CollectRecordForProcessingAction(ConfigPackageRecord,ConfigTableProcessingRule);
                end
              end else
                if GetLastErrorText <> '' then begin
                  ConfigPackageMgt.RecordError(
                    ConfigPackageRecord,ConfigPackageMgt.GetValidationFieldID,CopyStr(GetLastErrorText,1,250));
                  ClearLastError;
                  Commit;
                end;
              RecordsInsertedCount += ConfigPackageMgt.GetNumberOfRecordsInserted;
              RecordsModifiedCount += ConfigPackageMgt.GetNumberOfRecordsModified;
            end;
            if not HideDialog and (RecordCount > 1000) then
              ConfigProgressBarRecord.Update(StrSubstNo(RecordsXofYMsg,Counter,RecordCount));
          until ConfigPackageRecord.Next = 0;
        end;

        if not HideDialog and (RecordCount > 1000) then
          ConfigProgressBarRecord.Close;
    end;

    local procedure CollectRecordForProcessingAction(ConfigPackageRecord: Record "Config. Package Record";var ConfigTableProcessingRule: Record "Config. Table Processing Rule")
    begin
        ConfigTableProcessingRule.FindSet;
        repeat
          if ConfigPackageRecord.FitsProcessingFilter(ConfigTableProcessingRule."Rule No.") then
            TempConfigRecordForProcessing.AddRecord(ConfigPackageRecord,ConfigTableProcessingRule."Rule No.");
        until ConfigTableProcessingRule.Next = 0;
    end;

    local procedure CollectAppliedPackageRecord(ConfigPackageRecord: Record "Config. Package Record";var TempConfigPackageRecord: Record "Config. Package Record" temporary)
    begin
        TempConfigPackageRecord.Init;
        TempConfigPackageRecord := ConfigPackageRecord;
        TempConfigPackageRecord.Insert;
    end;

    local procedure DeleteAppliedPackageRecords(var TempConfigPackageRecord: Record "Config. Package Record" temporary)
    var
        ConfigPackageRecord: Record "Config. Package Record";
    begin
        if TempConfigPackageRecord.FindSet then
          repeat
            ConfigPackageRecord.TransferFields(TempConfigPackageRecord);
            ConfigPackageRecord.Delete(true);
          until TempConfigPackageRecord.Next = 0;
        TempConfigPackageRecord.DeleteAll;
        Commit;
    end;


    procedure ApplyConfigTables(ConfigPackage: Record "Config. Package")
    var
        ConfigPackageTable: Record "Config. Package Table";
    begin
        ConfigPackageTable.Reset;
        ConfigPackageTable.SetRange("Package Code",ConfigPackage.Code);
        ConfigPackageTable.SetFilter("Table ID",'%1|%2|%3|%4|%5|%6|%7|%8',
          Database::"Config. Template Header",Database::"Config. Template Line",
          Database::"Config. Questionnaire",Database::"Config. Question Area",Database::"Config. Question",
          Database::"Config. Line",Database::"Config. Package Filter",Database::"Config. Table Processing Rule");
        if not ConfigPackageTable.IsEmpty then begin
          Commit;
          SetHideDialog(true);
          ApplyPackageTables(ConfigPackage,ConfigPackageTable,Applymode::PrimaryKey);
          ApplyPackageTables(ConfigPackage,ConfigPackageTable,Applymode::NonKeyFields);
          DeleteAppliedPackageRecords(TempAppliedConfigPackageRecord);
        end;
    end;

    local procedure ProcessAppliedPackageRecords(var TempConfigRecordForProcessing: Record "Config. Record For Processing" temporary;var TempConfigPackageRecord: Record "Config. Package Record" temporary)
    var
        ConfigTableProcessingRule: Record "Config. Table Processing Rule";
    begin
        if TempConfigRecordForProcessing.FindSet then
          repeat
            if not ConfigTableProcessingRule.Process(TempConfigRecordForProcessing) then begin
              TempConfigRecordForProcessing.FindConfigRecord(TempConfigPackageRecord);
              RecordError(TempConfigPackageRecord,0,CopyStr(GetLastErrorText,1,250));
              TempConfigPackageRecord.Delete; // Remove it from the buffer to avoid deletion in the package
              Commit;
            end;
          until TempConfigRecordForProcessing.Next = 0;
        TempConfigRecordForProcessing.DeleteAll;
    end;


    procedure SetApplyMode(NewApplyMode: Option ,PrimaryKey,NonKeyFields)
    begin
        ApplyMode := NewApplyMode;
    end;


    procedure SetFieldFilter(var "Field": Record "Field";TableID: Integer;FieldID: Integer)
    begin
        Field.Reset;
        if TableID > 0 then
          Field.SetRange(TableNo,TableID);
        if FieldID > 0 then
          Field.SetRange("No.",FieldID);
        Field.SetRange(Class,Field.Class::Normal);
        Field.SetRange(Enabled,true);
    end;


    procedure SelectAllPackageFields(var ConfigPackageField: Record "Config. Package Field";SetInclude: Boolean)
    var
        ConfigPackageField2: Record "Config. Package Field";
    begin
        ConfigPackageField.SetRange("Primary Key",false);
        ConfigPackageField.SetRange("Include Field",not SetInclude);
        if ConfigPackageField.FindSet then
          repeat
            ConfigPackageField2.Get(ConfigPackageField."Package Code",ConfigPackageField."Table ID",ConfigPackageField."Field ID");
            ConfigPackageField2."Include Field" := SetInclude;
            ConfigPackageField2."Validate Field" :=
              SetInclude and not ValidateException(ConfigPackageField."Table ID",ConfigPackageField."Field ID");
            ConfigPackageField2.Modify;
          until ConfigPackageField.Next = 0;
        ConfigPackageField.SetRange("Include Field");
        ConfigPackageField.SetRange("Primary Key");
    end;


    procedure SetupProcessingOrder(var ConfigPackageTable: Record "Config. Package Table")
    var
        ConfigPackageTableLoop: Record "Config. Package Table";
        TempConfigPackageTable: Record "Config. Package Table" temporary;
        Flag: Integer;
    begin
        ConfigPackageTableLoop.CopyFilters(ConfigPackageTable);
        if not ConfigPackageTableLoop.FindSet(true) then
          exit;

        Flag := -1; // flag for all selected records: record processing order no was not initialized

        repeat
          ConfigPackageTableLoop."Processing Order" := Flag;
          ConfigPackageTableLoop.Modify;
        until ConfigPackageTableLoop.Next = 0;

        ConfigPackageTable.FindSet(true);
        repeat
          if ConfigPackageTable."Processing Order" = Flag then begin
            SetupTableProcessingOrder(ConfigPackageTable."Package Code",ConfigPackageTable."Table ID",TempConfigPackageTable,1);
            TempConfigPackageTable.Reset;
            TempConfigPackageTable.DeleteAll;
          end;
        until ConfigPackageTable.Next = 0;
    end;

    local procedure SetupTableProcessingOrder(PackageCode: Code[20];TableId: Integer;var CheckedConfigPackageTable: Record "Config. Package Table";StackLevel: Integer): Integer
    var
        ConfigPackageTable: Record "Config. Package Table";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        KeyRef: KeyRef;
        I: Integer;
        ProcessingOrder: Integer;
    begin
        if CheckedConfigPackageTable.Get(PackageCode,TableId) then
          Error(ProcessingOrderErr,TableId);

        CheckedConfigPackageTable.Init;
        CheckedConfigPackageTable."Package Code" := PackageCode;
        CheckedConfigPackageTable."Table ID" := TableId;
        // level to cleanup temptable from field branch checking history for case with multiple field branches
        CheckedConfigPackageTable."Processing Order" := StackLevel;
        CheckedConfigPackageTable.Insert;

        RecRef.Open(TableId);
        KeyRef := RecRef.KeyIndex(1);

        ProcessingOrder := 1;

        for I := 1 to KeyRef.FieldCount do begin
          FieldRef := KeyRef.FieldIndex(I);
          if (FieldRef.Relation <> 0) and (FieldRef.Relation <> TableId) then
            if ConfigPackageTable.Get(PackageCode,FieldRef.Relation) then begin
              ProcessingOrder :=
                MaxInt(
                  SetupTableProcessingOrder(PackageCode,FieldRef.Relation,CheckedConfigPackageTable,StackLevel + 1) + 1,ProcessingOrder);
              ClearFieldBranchCheckingHistory(PackageCode,CheckedConfigPackageTable,StackLevel);
            end;
        end;

        if ConfigPackageTable.Get(PackageCode,TableId) then begin
          ConfigPackageTable."Processing Order" := ProcessingOrder;
          AdjustProcessingOrder(ConfigPackageTable);
          ConfigPackageTable.Modify;
        end;

        exit(ProcessingOrder);
    end;

    local procedure AdjustProcessingOrder(var ConfigPackageTable: Record "Config. Package Table")
    var
        RelatedConfigPackageTable: Record "Config. Package Table";
    begin
        with ConfigPackageTable do
          case "Table ID" of
            Database::"G/L Account Category": // Pushing G/L Account Category before G/L Account
              if RelatedConfigPackageTable.Get("Package Code",Database::"G/L Account") then
                "Processing Order" := RelatedConfigPackageTable."Processing Order" - 1;
            Database::"Sales Header"..Database::"Purchase Line": // Moving Sales/Purchase Documents down
              "Processing Order" += 4;
            Database::"Company Information":
              "Processing Order" += 1;
            Database::"Custom Report Layout": // Moving Layouts to be on the top
              "Processing Order" := 0;
          end;
    end;

    local procedure ClearFieldBranchCheckingHistory(PackageCode: Code[20];var CheckedConfigPackageTable: Record "Config. Package Table";StackLevel: Integer)
    begin
        CheckedConfigPackageTable.SetRange("Package Code",PackageCode);
        CheckedConfigPackageTable.SetFilter("Processing Order",'>%1',StackLevel);
        CheckedConfigPackageTable.DeleteAll;
    end;

    local procedure MaxInt(Int1: Integer;Int2: Integer): Integer
    begin
        if Int1 > Int2 then
          exit(Int1);

        exit(Int2);
    end;

    local procedure GetDimSetID(PackageCode: Code[20];DimSetValue: Text[250]): Integer
    var
        ConfigPackageData: Record "Config. Package Data";
        ConfigPackageData2: Record "Config. Package Data";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
    begin
        ConfigPackageData.SetRange("Package Code",PackageCode);
        ConfigPackageData.SetRange("Table ID",Database::"Dimension Set Entry");
        ConfigPackageData.SetRange("Field ID",TempDimSetEntry.FieldNo("Dimension Set ID"));
        if ConfigPackageData.FindSet then
          repeat
            if ConfigPackageData.Value = DimSetValue then begin
              TempDimSetEntry.Init;
              ConfigPackageData2.Get(
                ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."No.",
                TempDimSetEntry.FieldNo("Dimension Code"));
              TempDimSetEntry.Validate("Dimension Code",Format(ConfigPackageData2.Value));
              ConfigPackageData2.Get(
                ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."No.",
                TempDimSetEntry.FieldNo("Dimension Value Code"));
              TempDimSetEntry.Validate(
                "Dimension Value Code",CopyStr(Format(ConfigPackageData2.Value),1,MaxStrLen(TempDimSetEntry."Dimension Value Code")));
              TempDimSetEntry.Insert;
            end;
          until ConfigPackageData.Next = 0;

        exit(DimMgt.GetDimensionSetID(TempDimSetEntry));
    end;


    procedure GetDimSetIDForRecord(ConfigPackageRecord: Record "Config. Package Record"): Integer
    var
        ConfigPackageData: Record "Config. Package Data";
        ConfigPackageField: Record "Config. Package Field";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimValue: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
        ConfigPackageMgt: Codeunit "Config. Package Management";
        DimCode: Code[20];
        DimValueCode: Code[20];
        DimValueNotFound: Boolean;
    begin
        ConfigPackageData.SetRange("Package Code",ConfigPackageRecord."Package Code");
        ConfigPackageData.SetRange("Table ID",ConfigPackageRecord."Table ID");
        ConfigPackageData.SetRange("No.",ConfigPackageRecord."No.");
        ConfigPackageData.SetRange("Field ID",ConfigMgt.DimensionFieldID,ConfigMgt.DimensionFieldID + 999);
        ConfigPackageData.SetFilter(Value,'<>%1','');
        if ConfigPackageData.FindSet then
          repeat
            if ConfigPackageField.Get(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."Field ID") then begin
              ConfigPackageField.TestField(Dimension);
              DimCode := CopyStr(Format(ConfigPackageField."Field Name"),1,20);
              DimValueCode := CopyStr(Format(ConfigPackageData.Value),1,MaxStrLen(TempDimSetEntry."Dimension Value Code"));
              TempDimSetEntry.Init;
              TempDimSetEntry.Validate("Dimension Code",DimCode);
              if DimValue.Get(DimCode,DimValueCode) then begin
                TempDimSetEntry.Validate("Dimension Value Code",DimValueCode);
                TempDimSetEntry.Insert;
              end else begin
                ConfigPackageMgt.FieldError(
                  ConfigPackageData,StrSubstNo(DimValueDoesNotExistsErr,DimCode,DimValueCode),Errortypeenum::General);
                DimValueNotFound := true;
              end;
            end;
          until ConfigPackageData.Next = 0;
        if DimValueNotFound then
          exit(0);
        exit(DimMgt.GetDimensionSetID(TempDimSetEntry));
    end;

    local procedure UpdateDimSetIDValues(ConfigPackage: Record "Config. Package")
    var
        ConfigPackageData: Record "Config. Package Data";
        ConfigPackageTable: Record "Config. Package Table";
        ConfigPackageTableDim: Record "Config. Package Table";
        ConfigPackageDataDimSet: Record "Config. Package Data";
        DimSetEntry: Record "Dimension Set Entry";
    begin
        ConfigPackageTableDim.SetRange("Package Code",ConfigPackage.Code);
        ConfigPackageTableDim.SetRange("Table ID",Database::Dimension,Database::"Default Dimension Priority");
        if not ConfigPackageTableDim.IsEmpty then begin
          ApplyPackageTables(ConfigPackage,ConfigPackageTableDim,Applymode::PrimaryKey);
          ApplyPackageTables(ConfigPackage,ConfigPackageTableDim,Applymode::NonKeyFields);
        end;

        ConfigPackageDataDimSet.SetRange("Package Code",ConfigPackage.Code);
        ConfigPackageDataDimSet.SetRange("Table ID",Database::"Dimension Set Entry");
        ConfigPackageDataDimSet.SetRange("Field ID",DimSetEntry.FieldNo("Dimension Set ID"));
        if ConfigPackageDataDimSet.IsEmpty then
          exit;

        ConfigPackageData.Reset;
        ConfigPackageData.SetRange("Package Code",ConfigPackage.Code);
        ConfigPackageData.SetFilter("Table ID",'<>%1',Database::"Dimension Set Entry");
        ConfigPackageData.SetRange("Field ID",Database::"Dimension Set Entry");
        if ConfigPackageData.FindSet(true) then begin
          if not HideDialog then
            ConfigProgressBar.Init(ConfigPackageData.Count,1,UpdatingDimSetsMsg);
          repeat
            ConfigPackageTable.Get(ConfigPackage.Code,ConfigPackageData."Table ID");
            ConfigPackageTable.CalcFields("Table Name");
            if not HideDialog then
              ConfigProgressBar.Update(ConfigPackageTable."Table Name");
            if ConfigPackageData.Value <> '' then begin
              ConfigPackageData.Value := Format(GetDimSetID(ConfigPackage.Code,ConfigPackageData.Value));
              ConfigPackageData.Modify;
            end;
          until ConfigPackageData.Next = 0;
          if not HideDialog then
            ConfigProgressBar.Close;
        end;
    end;


    procedure UpdateDefaultDimValues(ConfigPackageRecord: Record "Config. Package Record";MasterNo: Code[20])
    var
        ConfigPackageTableDim: Record "Config. Package Table";
        ConfigPackageRecordDim: Record "Config. Package Record";
        ConfigPackageDataDim: array [4] of Record "Config. Package Data";
        ConfigPackageField: Record "Config. Package Field";
        ConfigPackageData: Record "Config. Package Data";
        DefaultDim: Record "Default Dimension";
        DimValue: Record "Dimension Value";
        RecordFound: Boolean;
    begin
        ConfigPackageRecord.TestField("Package Code");
        ConfigPackageRecord.TestField("Table ID");

        ConfigPackageData.Reset;
        ConfigPackageData.SetRange("Package Code",ConfigPackageRecord."Package Code");
        ConfigPackageData.SetRange("Table ID",ConfigPackageRecord."Table ID");
        ConfigPackageData.SetRange("No.",ConfigPackageRecord."No.");
        ConfigPackageData.SetRange("Field ID",ConfigMgt.DimensionFieldID,ConfigMgt.DimensionFieldID + 999);
        ConfigPackageData.SetFilter(Value,'<>%1','');
        if ConfigPackageData.FindSet then
          repeat
            if ConfigPackageField.Get(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."Field ID") then begin
              // find if Dimension Code already exist
              RecordFound := false;
              ConfigPackageDataDim[1].SetRange("Package Code",ConfigPackageRecord."Package Code");
              ConfigPackageDataDim[1].SetRange("Table ID",Database::"Default Dimension");
              ConfigPackageDataDim[1].SetRange("Field ID",DefaultDim.FieldNo("Table ID"));
              ConfigPackageDataDim[1].SetRange(Value,Format(ConfigPackageRecord."Table ID"));
              if ConfigPackageDataDim[1].FindSet then
                repeat
                  ConfigPackageDataDim[2].SetRange("Package Code",ConfigPackageRecord."Package Code");
                  ConfigPackageDataDim[2].SetRange("Table ID",Database::"Default Dimension");
                  ConfigPackageDataDim[2].SetRange("No.",ConfigPackageDataDim[1]."No.");
                  ConfigPackageDataDim[2].SetRange("Field ID",DefaultDim.FieldNo("No."));
                  ConfigPackageDataDim[2].SetRange(Value,MasterNo);
                  if ConfigPackageDataDim[2].FindSet then
                    repeat
                      ConfigPackageDataDim[3].SetRange("Package Code",ConfigPackageRecord."Package Code");
                      ConfigPackageDataDim[3].SetRange("Table ID",Database::"Default Dimension");
                      ConfigPackageDataDim[3].SetRange("No.",ConfigPackageDataDim[2]."No.");
                      ConfigPackageDataDim[3].SetRange("Field ID",DefaultDim.FieldNo("Dimension Code"));
                      ConfigPackageDataDim[3].SetRange(Value,ConfigPackageField."Field Name");
                      RecordFound := ConfigPackageDataDim[3].FindFirst;
                    until (ConfigPackageDataDim[2].Next = 0) or RecordFound;
                until (ConfigPackageDataDim[1].Next = 0) or RecordFound;
              if not RecordFound then begin
                if not ConfigPackageTableDim.Get(ConfigPackageRecord."Package Code",Database::"Default Dimension") then
                  InsertPackageTable(ConfigPackageTableDim,ConfigPackageRecord."Package Code",Database::"Default Dimension");
                InitPackageRecord(ConfigPackageRecordDim,ConfigPackageTableDim."Package Code",ConfigPackageTableDim."Table ID");
                // Insert Default Dimension record
                InsertPackageData(ConfigPackageDataDim[4],
                  ConfigPackageRecordDim."Package Code",ConfigPackageRecordDim."Table ID",ConfigPackageRecordDim."No.",
                  DefaultDim.FieldNo("Table ID"),Format(ConfigPackageRecord."Table ID"),false);
                InsertPackageData(ConfigPackageDataDim[4],
                  ConfigPackageRecordDim."Package Code",ConfigPackageRecordDim."Table ID",ConfigPackageRecordDim."No.",
                  DefaultDim.FieldNo("No."),Format(MasterNo),false);
                InsertPackageData(ConfigPackageDataDim[4],
                  ConfigPackageRecordDim."Package Code",ConfigPackageRecordDim."Table ID",ConfigPackageRecordDim."No.",
                  DefaultDim.FieldNo("Dimension Code"),ConfigPackageField."Field Name",false);
                if IsBlankDim(ConfigPackageData.Value) then
                  InsertPackageData(ConfigPackageDataDim[4],
                    ConfigPackageRecordDim."Package Code",ConfigPackageRecordDim."Table ID",ConfigPackageRecordDim."No.",
                    DefaultDim.FieldNo("Dimension Value Code"),'',false)
                else
                  InsertPackageData(ConfigPackageDataDim[4],
                    ConfigPackageRecordDim."Package Code",ConfigPackageRecordDim."Table ID",ConfigPackageRecordDim."No.",
                    DefaultDim.FieldNo("Dimension Value Code"),ConfigPackageData.Value,false);
              end else begin
                ConfigPackageDataDim[3].SetRange("Field ID",DefaultDim.FieldNo("Dimension Value Code"));
                ConfigPackageDataDim[3].SetRange(Value);
                ConfigPackageDataDim[3].FindFirst;
                ConfigPackageDataDim[3].Value := ConfigPackageData.Value;
                ConfigPackageDataDim[3].Modify;
              end;
              // Insert Dimension value if needed
              if not IsBlankDim(ConfigPackageData.Value) then
                if not DimValue.Get(ConfigPackageField."Field Name",ConfigPackageData.Value) then begin
                  ConfigPackageRecord.TestField("Package Code");
                  if not ConfigPackageTableDim.Get(ConfigPackageRecord."Package Code",Database::"Dimension Value") then
                    InsertPackageTable(ConfigPackageTableDim,ConfigPackageRecord."Package Code",Database::"Dimension Value");
                  InitPackageRecord(ConfigPackageRecordDim,ConfigPackageTableDim."Package Code",ConfigPackageTableDim."Table ID");
                  InsertPackageData(ConfigPackageDataDim[4],
                    ConfigPackageRecordDim."Package Code",ConfigPackageRecordDim."Table ID",ConfigPackageRecordDim."No.",
                    DimValue.FieldNo("Dimension Code"),ConfigPackageField."Field Name",false);
                  InsertPackageData(ConfigPackageDataDim[4],
                    ConfigPackageRecordDim."Package Code",ConfigPackageRecordDim."Table ID",ConfigPackageRecordDim."No.",
                    DimValue.FieldNo(Code),ConfigPackageData.Value,false);
                end;
            end;
          until ConfigPackageData.Next = 0;
    end;

    local procedure IsBlankDim(Value: Text[250]): Boolean
    begin
        exit(UpperCase(Value) = UpperCase(BlankTxt));
    end;


    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;


    procedure AddConfigTables(PackageCode: Code[20])
    var
        ConfigPackageTable: Record "Config. Package Table";
        ConfigPackageFilter: Record "Config. Package Filter";
        ConfigLine: Record "Config. Line";
    begin
        ConfigPackageTable.Init;
        InsertPackageTable(ConfigPackageTable,PackageCode,Database::"Config. Questionnaire");
        InsertPackageTable(ConfigPackageTable,PackageCode,Database::"Config. Question Area");
        InsertPackageTable(ConfigPackageTable,PackageCode,Database::"Config. Question");
        InsertPackageTable(ConfigPackageTable,PackageCode,Database::"Config. Template Header");
        InsertPackageTable(ConfigPackageTable,PackageCode,Database::"Config. Template Line");
        InsertPackageTable(ConfigPackageTable,PackageCode,Database::"Config. Line");
        InsertPackageFilter(ConfigPackageFilter,PackageCode,Database::"Config. Line",0,ConfigLine.FieldNo("Package Code"),PackageCode);
        InsertPackageTable(ConfigPackageTable,PackageCode,Database::"Config. Package Filter");
        InsertPackageFilter(
          ConfigPackageFilter,PackageCode,Database::"Config. Package Filter",0,ConfigPackageFilter.FieldNo("Package Code"),PackageCode);
        InsertPackageTable(ConfigPackageTable,PackageCode,Database::"Config. Field Mapping");
        InsertPackageTable(ConfigPackageTable,PackageCode,Database::"Config. Table Processing Rule");
        SetSkipTableTriggers(ConfigPackageTable,PackageCode,Database::"Config. Table Processing Rule",true);
        InsertPackageFilter(
          ConfigPackageFilter,PackageCode,Database::"Config. Table Processing Rule",0,
          ConfigPackageFilter.FieldNo("Package Code"),PackageCode);
    end;


    procedure AssignPackage(var ConfigLine: Record "Config. Line";PackageCode: Code[20])
    var
        ConfigLine2: Record "Config. Line";
        TempConfigLine: Record "Config. Line" temporary;
        ConfigPackageTable: Record "Config. Package Table";
        ConfigPackageTable2: Record "Config. Package Table";
        LineTypeFilter: Text;
    begin
        CreateConfigLineBuffer(ConfigLine,TempConfigLine,PackageCode);
        CheckConfigLinesToAssign(TempConfigLine);

        LineTypeFilter := ConfigLine.GetFilter("Line Type");
        ConfigLine.SetFilter("Package Code",'<>%1',PackageCode);
        ConfigLine.SetRange("Line Type");
        if ConfigLine.FindSet(true) then
          repeat
            ConfigLine.CheckBlocked;
            if ConfigLine.Status <= ConfigLine.Status::"In Progress" then begin
              if ConfigLine."Line Type" = ConfigLine."line type"::Table then begin
                ConfigLine.TestField("Table ID");
                if ConfigPackageTable.Get(ConfigLine."Package Code",ConfigLine."Table ID") then begin
                  ConfigLine2.SetRange("Package Code",PackageCode);
                  ConfigLine2.SetRange("Table ID",ConfigLine."Table ID");
                  CheckConfigLinesToAssign(ConfigLine2);
                  InsertPackageTable(ConfigPackageTable2,PackageCode,ConfigLine."Table ID");
                  ChangePackageCode(ConfigLine."Package Code",PackageCode,ConfigLine."Table ID");
                  ConfigPackageTable.Delete(true);
                end else
                  if not ConfigPackageTable.Get(PackageCode,ConfigLine."Table ID") then
                    InsertPackageTable(ConfigPackageTable,PackageCode,ConfigLine."Table ID");
              end;
              ConfigLine."Package Code" := PackageCode;
              ConfigLine.Modify;
            end;
          until ConfigLine.Next = 0;

        ConfigLine.SetRange("Package Code");
        if LineTypeFilter <> '' then
          ConfigLine.SetFilter("Line Type",LineTypeFilter);
    end;

    local procedure ChangePackageCode(OldPackageCode: Code[20];NewPackageCode: Code[20];TableID: Integer)
    var
        ConfigPackageRecord: Record "Config. Package Record";
        TempConfigPackageRecord: Record "Config. Package Record" temporary;
        ConfigPackageData: Record "Config. Package Data";
        TempConfigPackageData: Record "Config. Package Data" temporary;
        ConfigPackageFilter: Record "Config. Package Filter";
        TempConfigPackageFilter: Record "Config. Package Filter" temporary;
        ConfigPackageError: Record "Config. Package Error";
        TempConfigPackageError: Record "Config. Package Error" temporary;
    begin
        TempConfigPackageRecord.DeleteAll;
        ConfigPackageRecord.SetRange("Package Code",OldPackageCode);
        ConfigPackageRecord.SetRange("Table ID",TableID);
        if ConfigPackageRecord.FindSet(true,true) then
          repeat
            TempConfigPackageRecord := ConfigPackageRecord;
            TempConfigPackageRecord."Package Code" := NewPackageCode;
            TempConfigPackageRecord.Insert;
          until ConfigPackageRecord.Next = 0;
        if TempConfigPackageRecord.FindSet then
          repeat
            ConfigPackageRecord := TempConfigPackageRecord;
            ConfigPackageRecord.Insert;
          until TempConfigPackageRecord.Next = 0;

        TempConfigPackageData.DeleteAll;
        ConfigPackageData.SetRange("Package Code",OldPackageCode);
        ConfigPackageData.SetRange("Table ID",TableID);
        if ConfigPackageData.FindSet(true,true) then
          repeat
            TempConfigPackageData := ConfigPackageData;
            TempConfigPackageData."Package Code" := NewPackageCode;
            TempConfigPackageData.Insert;
          until ConfigPackageData.Next = 0;
        if TempConfigPackageData.FindSet then
          repeat
            ConfigPackageData := TempConfigPackageData;
            ConfigPackageData.Insert;
          until TempConfigPackageData.Next = 0;

        TempConfigPackageError.DeleteAll;
        ConfigPackageError.SetRange("Package Code",OldPackageCode);
        ConfigPackageError.SetRange("Table ID",TableID);
        if ConfigPackageError.FindSet(true,true) then
          repeat
            TempConfigPackageError := ConfigPackageError;
            TempConfigPackageError."Package Code" := NewPackageCode;
            TempConfigPackageError.Insert;
          until ConfigPackageError.Next = 0;
        if TempConfigPackageError.FindSet then
          repeat
            ConfigPackageError := TempConfigPackageError;
            ConfigPackageError.Insert;
          until TempConfigPackageError.Next = 0;

        TempConfigPackageFilter.DeleteAll;
        ConfigPackageFilter.SetRange("Package Code",OldPackageCode);
        ConfigPackageFilter.SetRange("Table ID",TableID);
        if ConfigPackageFilter.FindSet(true,true) then
          repeat
            TempConfigPackageFilter := ConfigPackageFilter;
            TempConfigPackageFilter."Package Code" := NewPackageCode;
            TempConfigPackageFilter.Insert;
          until ConfigPackageFilter.Next = 0;
        if TempConfigPackageFilter.FindSet then
          repeat
            ConfigPackageFilter := TempConfigPackageFilter;
            ConfigPackageFilter.Insert;
          until TempConfigPackageFilter.Next = 0;
    end;


    procedure CheckConfigLinesToAssign(var ConfigLine: Record "Config. Line")
    var
        TempObject: Record "Object" temporary;
    begin
        ConfigLine.SetRange("Line Type",ConfigLine."line type"::Table);
        if ConfigLine.FindSet then
          repeat
            if TempObject.Get(TempObject.Type::Table,'',ConfigLine."Table ID") then
              Error(ReferenceSameTableErr);
            TempObject.Type := TempObject.Type::Table;
            TempObject.ID := ConfigLine."Table ID";
            TempObject.Insert;
          until ConfigLine.Next = 0;
    end;

    local procedure CreateConfigLineBuffer(var ConfigLineNew: Record "Config. Line";var ConfigLineBuffer: Record "Config. Line";PackageCode: Code[20])
    var
        ConfigLine: Record "Config. Line";
    begin
        ConfigLine.SetRange("Package Code",PackageCode);
        AddConfigLineToBuffer(ConfigLine,ConfigLineBuffer);
        AddConfigLineToBuffer(ConfigLineNew,ConfigLineBuffer);
    end;

    local procedure AddConfigLineToBuffer(var ConfigLine: Record "Config. Line";var ConfigLineBuffer: Record "Config. Line")
    begin
        if ConfigLine.FindSet then
          repeat
            if not ConfigLineBuffer.Get(ConfigLine."Line No.") then begin
              ConfigLineBuffer.Init;
              ConfigLineBuffer.TransferFields(ConfigLine);
              ConfigLineBuffer.Insert;
            end;
          until ConfigLine.Next = 0;
    end;


    procedure GetRelatedTables(var ConfigPackageTable: Record "Config. Package Table")
    var
        TempConfigPackageTable: Record "Config. Package Table" temporary;
        "Field": Record "Field";
    begin
        TempConfigPackageTable.DeleteAll;
        if ConfigPackageTable.FindSet then
          repeat
            SetFieldFilter(Field,ConfigPackageTable."Table ID",0);
            Field.SetFilter(RelationTableNo,'<>%1&<>%2&..%3',0,ConfigPackageTable."Table ID",99000999);
            if Field.FindSet then
              repeat
                TempConfigPackageTable."Package Code" := ConfigPackageTable."Package Code";
                TempConfigPackageTable."Table ID" := Field.RelationTableNo;
                if TempConfigPackageTable.Insert then;
              until Field.Next = 0;
          until ConfigPackageTable.Next = 0;

        ConfigPackageTable.Reset;
        if TempConfigPackageTable.FindSet then
          repeat
            if not ConfigPackageTable.Get(TempConfigPackageTable."Package Code",TempConfigPackageTable."Table ID") then
              InsertPackageTable(ConfigPackageTable,TempConfigPackageTable."Package Code",TempConfigPackageTable."Table ID");
          until TempConfigPackageTable.Next = 0;
    end;

    local procedure GetKeyFieldsOrder(RecRef: RecordRef;PackageCode: Code[20];var TempConfigPackageField: Record "Config. Package Field" temporary)
    var
        ConfigPackageField: Record "Config. Package Field";
        KeyRef: KeyRef;
        FieldRef: FieldRef;
        KeyFieldCount: Integer;
    begin
        KeyRef := RecRef.KeyIndex(1);
        for KeyFieldCount := 1 to KeyRef.FieldCount do begin
          FieldRef := KeyRef.FieldIndex(KeyFieldCount);
          ValidationFieldID := FieldRef.Number;

          if ConfigPackageField.Get(PackageCode,RecRef.Number,FieldRef.Number) then;

          TempConfigPackageField.Init;
          TempConfigPackageField."Package Code" := PackageCode;
          TempConfigPackageField."Table ID" := RecRef.Number;
          TempConfigPackageField."Field ID" := FieldRef.Number;
          TempConfigPackageField."Processing Order" := ConfigPackageField."Processing Order";
          TempConfigPackageField.Insert;
        end;
    end;


    procedure GetFieldsOrder(RecRef: RecordRef;PackageCode: Code[20];var TempConfigPackageField: Record "Config. Package Field" temporary)
    var
        ConfigPackageField: Record "Config. Package Field";
        FieldRef: FieldRef;
        FieldCount: Integer;
    begin
        for FieldCount := 1 to RecRef.FieldCount do begin
          FieldRef := RecRef.FieldIndex(FieldCount);

          if ConfigPackageField.Get(PackageCode,RecRef.Number,FieldRef.Number) then;

          TempConfigPackageField.Init;
          TempConfigPackageField."Package Code" := PackageCode;
          TempConfigPackageField."Table ID" := RecRef.Number;
          TempConfigPackageField."Field ID" := FieldRef.Number;
          TempConfigPackageField."Processing Order" := ConfigPackageField."Processing Order";
          TempConfigPackageField.Insert;
        end;
    end;

    local procedure IsRecordErrorsExists(ConfigPackageRecord: Record "Config. Package Record"): Boolean
    var
        ConfigPackageError: Record "Config. Package Error";
    begin
        ConfigPackageError.SetRange("Package Code",ConfigPackageRecord."Package Code");
        ConfigPackageError.SetRange("Table ID",ConfigPackageRecord."Table ID");
        ConfigPackageError.SetRange("Record No.",ConfigPackageRecord."No.");
        exit(not ConfigPackageError.IsEmpty);
    end;

    local procedure IsRecordErrorsExistsInPrimaryKeyFields(ConfigPackageRecord: Record "Config. Package Record"): Boolean
    var
        ConfigPackageError: Record "Config. Package Error";
    begin
        with ConfigPackageError do begin
          SetRange("Package Code",ConfigPackageRecord."Package Code");
          SetRange("Table ID",ConfigPackageRecord."Table ID");
          SetRange("Record No.",ConfigPackageRecord."No.");

          if FindSet then
            repeat
              if ConfigValidateMgt.IsKeyField("Table ID","Field ID") then
                exit(true);
            until Next = 0;
        end;

        exit(false);
    end;


    procedure UpdateConfigLinePackageData(ConfigPackageCode: Code[20])
    var
        ConfigLine: Record "Config. Line";
        ConfigPackageData: Record "Config. Package Data";
        ShiftLineNo: BigInteger;
        ShiftVertNo: Integer;
        TempValue: BigInteger;
    begin
        ConfigLine.Reset;
        if not ConfigLine.FindLast then
          exit;

        ShiftLineNo := ConfigLine."Line No." + 10000L;
        ShiftVertNo := ConfigLine."Vertical Sorting" + 1;

        with ConfigPackageData do begin
          SetRange("Package Code",ConfigPackageCode);
          SetRange("Table ID",Database::"Config. Line");
          SetRange("Field ID",ConfigLine.FieldNo("Line No."));
          if FindSet then
            repeat
              if Evaluate(TempValue,Value) then begin
                Value := Format(TempValue + ShiftLineNo);
                Modify;
              end;
            until Next = 0;
          SetRange("Field ID",ConfigLine.FieldNo("Vertical Sorting"));
          if FindSet then
            repeat
              if Evaluate(TempValue,Value) then begin
                Value := Format(TempValue + ShiftVertNo);
                Modify;
              end;
            until Next = 0;
        end;
    end;


    procedure HandlePackageDataDimSetIDForRecord(ConfigPackageRecord: Record "Config. Package Record")
    var
        ConfigPackageData: Record "Config. Package Data";
        ConfigPackageMgt: Codeunit "Config. Package Management";
        DimPackageDataExists: Boolean;
        DimSetID: Integer;
    begin
        DimSetID := ConfigPackageMgt.GetDimSetIDForRecord(ConfigPackageRecord);
        DimPackageDataExists :=
          GetDimPackageDataFromRecord(ConfigPackageData,ConfigPackageRecord);
        if DimSetID = 0 then begin
          if DimPackageDataExists then
            ConfigPackageData.Delete(true);
        end else
          if not DimPackageDataExists then
            CreateDimPackageDataFromRecord(ConfigPackageData,ConfigPackageRecord,DimSetID)
          else
            if ConfigPackageData.Value <> Format(DimSetID) then begin
              ConfigPackageData.Value := Format(DimSetID);
              ConfigPackageData.Modify;
            end;
    end;

    local procedure GetDimPackageDataFromRecord(var ConfigPackageData: Record "Config. Package Data";ConfigPackageRecord: Record "Config. Package Record"): Boolean
    begin
        exit(
          ConfigPackageData.Get(
            ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID",ConfigPackageRecord."No.",
            Database::"Dimension Set Entry"));
    end;

    local procedure CreateDimPackageDataFromRecord(var ConfigPackageData: Record "Config. Package Data";ConfigPackageRecord: Record "Config. Package Record";DimSetID: Integer)
    var
        ConfigPackageField: Record "Config. Package Field";
    begin
        if ConfigPackageField.Get(ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID",Database::"Dimension Set Entry") then begin
          ConfigPackageField.Validate("Include Field",true);
          ConfigPackageField.Modify(true);
        end;

        with ConfigPackageData do begin
          Init;
          "Package Code" := ConfigPackageRecord."Package Code";
          "Table ID" := ConfigPackageRecord."Table ID";
          "Field ID" := Database::"Dimension Set Entry";
          "No." := ConfigPackageRecord."No.";
          Value := Format(DimSetID);
          Insert;
        end;
    end;

    local procedure UpdateValueUsingMapping(var ConfigPackageData: Record "Config. Package Data";ConfigPackageField: Record "Config. Package Field";PackageCode: Code[20])
    var
        ConfigFieldMapping: Record "Config. Field Mapping";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        NewValue: Text[250];
    begin
        if ConfigFieldMapping.Get(
             ConfigPackageData."Package Code",
             ConfigPackageField."Table ID",
             ConfigPackageField."Field ID",
             ConfigPackageData.Value)
        then
          NewValue := ConfigFieldMapping."New Value";

        if (NewValue = '') and (ConfigPackageField."Relation Table ID" <> 0) then
          NewValue := GetMappingFromPKOfRelatedTable(ConfigPackageField,ConfigPackageData.Value);

        if NewValue <> '' then begin
          ConfigPackageData.Validate(Value,NewValue);
          ConfigPackageData.Modify;
        end;

        if ConfigPackageField."Create Missing Codes" then begin
          RecRef.Open(ConfigPackageField."Relation Table ID");
          FieldRef := RecRef.Field(1);
          FieldRef.Value(ConfigPackageData.Value);
          // even "Create Missing Codes" is marked we should not create for blank account numbers and blank/zero account categories should not be created
          if ConfigPackageData."Table ID" <> 15 then begin
            if RecRef.Insert then;
          end else
            if (ConfigPackageData.Value <> '') and ((ConfigPackageData.Value <> '0') and (ConfigPackageData."Field ID" = 80)) or
               ((PackageCode <> QBPackageCodeTxt) and (PackageCode <> MSGPPackageCodeTxt))
            then
              if RecRef.Insert then;
        end;
    end;

    local procedure GetMappingFromPKOfRelatedTable(ConfigPackageField: Record "Config. Package Field";MappingOldValue: Text[250]): Text[250]
    var
        ConfigPackageField2: Record "Config. Package Field";
        ConfigFieldMapping: Record "Config. Field Mapping";
    begin
        ConfigPackageField2.SetRange("Package Code",ConfigPackageField."Package Code");
        ConfigPackageField2.SetRange("Table ID",ConfigPackageField."Relation Table ID");
        ConfigPackageField2.SetRange("Primary Key",true);
        if ConfigPackageField2.FindFirst then
          if ConfigFieldMapping.Get(
               ConfigPackageField2."Package Code",
               ConfigPackageField2."Table ID",
               ConfigPackageField2."Field ID",
               MappingOldValue)
          then
            exit(ConfigFieldMapping."New Value");
    end;


    procedure ShowFieldMapping(ConfigPackageField: Record "Config. Package Field")
    var
        ConfigFieldMapping: Record "Config. Field Mapping";
        ConfigFieldMappingPage: Page "Config. Field Mapping";
    begin
        Clear(ConfigFieldMappingPage);
        ConfigFieldMapping.FilterGroup(2);
        ConfigFieldMapping.SetRange("Package Code",ConfigPackageField."Package Code");
        ConfigFieldMapping.SetRange("Table ID",ConfigPackageField."Table ID");
        ConfigFieldMapping.SetRange("Field ID",ConfigPackageField."Field ID");
        ConfigFieldMapping.FilterGroup(0);
        ConfigFieldMappingPage.SetTableview(ConfigFieldMapping);
        ConfigFieldMappingPage.RunModal;
    end;


    procedure IsBLOBField(TableId: Integer;FieldId: Integer): Boolean
    var
        "Field": Record "Field";
    begin
        Field.SetRange(TableNo,TableId);
        Field.SetRange("No.",FieldId);
        if Field.FindFirst then
          exit(Field.Type = Field.Type::Blob);
        exit(false);
    end;

    local procedure EvaluateBLOBToFieldRef(var ConfigPackageData: Record "Config. Package Data";var FieldRef: FieldRef)
    begin
        ConfigPackageData.CalcFields("BLOB Value");
        FieldRef.Value := ConfigPackageData."BLOB Value";
    end;


    procedure IsMediaSetField(TableId: Integer;FieldId: Integer): Boolean
    var
        "Field": Record "Field";
    begin
        Field.SetRange(TableNo,TableId);
        Field.SetRange("No.",FieldId);
        if Field.FindFirst then
          exit(Field.Type = Field.Type::MediaSet);

        exit(false);
    end;

    local procedure ImportMediaSetFiles(var ConfigPackageData: Record "Config. Package Data";var FieldRef: FieldRef;DoModify: Boolean)
    var
        TempConfigMediaBuffer: Record "Config. Media Buffer" temporary;
        MediaSetIDConfigPackageData: Record "Config. Package Data";
        BlobMediaSetConfigPackageData: Record "Config. Package Data";
        BlobInStream: InStream;
        MediaSetID: Text;
    begin
        if not CanImportMediaField(ConfigPackageData,FieldRef,DoModify,MediaSetID) then
          exit;

        MediaSetIDConfigPackageData.SetRange("Package Code",ConfigPackageData."Package Code");
        MediaSetIDConfigPackageData.SetRange("Table ID",Database::"Config. Media Buffer");
        MediaSetIDConfigPackageData.SetRange("Field ID",TempConfigMediaBuffer.FieldNo("Media Set ID"));
        MediaSetIDConfigPackageData.SetRange(Value,MediaSetID);

        if not MediaSetIDConfigPackageData.FindSet then
          exit;

        TempConfigMediaBuffer.Init;
        TempConfigMediaBuffer.Insert;
        BlobMediaSetConfigPackageData.SetAutocalcFields("BLOB Value");

        repeat
          BlobMediaSetConfigPackageData.Get(
            MediaSetIDConfigPackageData."Package Code",MediaSetIDConfigPackageData."Table ID",MediaSetIDConfigPackageData."No.",
            TempConfigMediaBuffer.FieldNo("Media Blob"));
          BlobMediaSetConfigPackageData."BLOB Value".CreateInstream(BlobInStream);
          TempConfigMediaBuffer."Media Set".ImportStream(BlobInStream,'');
          TempConfigMediaBuffer.Modify;
        until MediaSetIDConfigPackageData.Next = 0;

        FieldRef.Value := Format(TempConfigMediaBuffer."Media Set");
    end;


    procedure IsMediaField(TableId: Integer;FieldId: Integer): Boolean
    var
        "Field": Record "Field";
    begin
        Field.SetRange(TableNo,TableId);
        Field.SetRange("No.",FieldId);
        if Field.FindFirst then
          exit(Field.Type = Field.Type::Media);

        exit(false);
    end;

    local procedure ImportMediaFiles(var ConfigPackageData: Record "Config. Package Data";var FieldRef: FieldRef;DoModify: Boolean)
    var
        TempConfigMediaBuffer: Record "Config. Media Buffer" temporary;
        MediaIDConfigPackageData: Record "Config. Package Data";
        BlobMediaConfigPackageData: Record "Config. Package Data";
        BlobInStream: InStream;
        MediaID: Text;
    begin
        if not CanImportMediaField(ConfigPackageData,FieldRef,DoModify,MediaID) then
          exit;

        MediaIDConfigPackageData.SetRange("Package Code",ConfigPackageData."Package Code");
        MediaIDConfigPackageData.SetRange("Table ID",Database::"Config. Media Buffer");
        MediaIDConfigPackageData.SetRange("Field ID",TempConfigMediaBuffer.FieldNo("Media ID"));
        MediaIDConfigPackageData.SetRange(Value,MediaID);

        if not MediaIDConfigPackageData.FindFirst then
          exit;

        BlobMediaConfigPackageData.SetAutocalcFields("BLOB Value");

        BlobMediaConfigPackageData.Get(
          MediaIDConfigPackageData."Package Code",MediaIDConfigPackageData."Table ID",MediaIDConfigPackageData."No.",
          TempConfigMediaBuffer.FieldNo("Media Blob"));
        BlobMediaConfigPackageData."BLOB Value".CreateInstream(BlobInStream);

        TempConfigMediaBuffer.Init;
        TempConfigMediaBuffer.Media.ImportStream(BlobInStream,'');
        TempConfigMediaBuffer.Insert;

        FieldRef.Value := Format(TempConfigMediaBuffer.Media);
    end;

    local procedure CanImportMediaField(var ConfigPackageData: Record "Config. Package Data";var FieldRef: FieldRef;DoModify: Boolean;var MediaID: Text): Boolean
    var
        RecRef: RecordRef;
        DummyNotInitializedGuid: Guid;
    begin
        if not DoModify then
          exit(false);

        RecRef := FieldRef.Record;
        if RecRef.Number = Database::"Config. Media Buffer" then
          exit(false);

        MediaID := Format(ConfigPackageData.Value);
        if (MediaID = Format(DummyNotInitializedGuid)) or (MediaID = '') then
          exit(false);

        exit(true);
    end;

    local procedure GetRecordIDOfRecordError(var ConfigPackageData: Record "Config. Package Data"): Text[250]
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        KeyRef: KeyRef;
        RecordID: Text;
        KeyFieldCount: Integer;
        KeyFieldValNotEmpty: Boolean;
    begin
        if not ConfigPackageData.FindSet then
          exit;

        RecRef.Open(ConfigPackageData."Table ID");
        KeyRef := RecRef.KeyIndex(1);
        for KeyFieldCount := 1 to KeyRef.FieldCount do begin
          FieldRef := KeyRef.FieldIndex(KeyFieldCount);

          if not ConfigPackageData.Get(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."No.",
               FieldRef.Number)
          then
            exit;

          if ConfigPackageData.Value <> '' then
            KeyFieldValNotEmpty := true;

          if KeyFieldCount = 1 then
            RecordID := RecRef.Name + ': ' + ConfigPackageData.Value
          else
            RecordID += ', ' + ConfigPackageData.Value;
        end;

        if not KeyFieldValNotEmpty then
          exit;

        exit(CopyStr(RecordID,1,250));
    end;

    local procedure IsTableErrorsExists(ConfigPackageTable: Record "Config. Package Table"): Boolean
    var
        ConfigPackageError: Record "Config. Package Error";
    begin
        if ConfigPackageTable."Table ID" = 27 then begin
          ConfigPackageError.SetRange("Package Code",ConfigPackageTable."Package Code");
          ConfigPackageError.SetRange("Table ID",ConfigPackageTable."Table ID");
          if ConfigPackageError.Find('-') then
            repeat
              if StrPos(ConfigPackageError."Error Text",'is a duplicate item number') > 0 then
                exit(not ConfigPackageError.IsEmpty);
            until ConfigPackageError.Next = 0;
        end
    end;
}

