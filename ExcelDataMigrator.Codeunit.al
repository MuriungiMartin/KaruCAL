#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1806 "Excel Data Migrator"
{

    trigger OnRun()
    begin
    end;

    var
        PackageCodeTxt: label 'GB.ENU.EXCEL';
        PackageNameTxt: label 'Excel Data Migration';
        ConfigPackageManagement: Codeunit "Config. Package Management";
        ConfigExcelExchange: Codeunit "Config. Excel Exchange";
        DataMigratorDescriptionTxt: label 'Import from Excel';
        Instruction1Txt: label '1) Download the Excel template.';
        Instruction2Txt: label '2) Fill in the template with your data.';
        ImportingMsg: label 'Importing Data...';
        ApplyingMsg: label 'Applying Data...';
        ImportFromExcelTxt: label 'Import from Excel';
        ExcelFileExtensionTok: label '*.xlsx';
        ExcelValidationErr: label 'The file that you imported is corrupted. It contains columns that cannot be mapped to Dynamics 365 for Financials.';
        OpenAdvancedQst: label 'The advanced setup experience requires you to specify how database tables are configured. We recommend that you only access the advanced setup if you are familiar with RapidStart Services.\\Do you want to continue?';
        ExcelFileNameTok: label 'DataImport_Dynamics365%1.xlsx', Comment='%1 = String generated from current datetime to make sure file names are unique ';
        SettingsMissingQst: label 'You have not specified import settings for this data source.\\Are you sure you want to continue?';
        TransactionExistsMsg: label 'Transactions have already been entered. In order to use the wizard, you will need to create a new company to migrate your data.';
        TransactionforGLExistsMsg: label 'Transactions have already been entered for "G/L Account". In order to use the wizard, unmark "G/L Account".';
        TransactionforCustExistsMsg: label 'Transactions have already been entered for "Customer". In order to use the wizard, unmark "Customer".';
        TransactionforVendExistsMsg: label 'Transactions have already been entered for "Vendor". In order to use the wizard, unmark "Vendor".';
        TransactionforItemExistsMsg: label 'Transactions have already been entered for "Item". In order to use the wizard, unmark "Item".';
        SavedJrnlLinesFoundMsg: label 'Saved journal lines are found. In order to use the wizard, you will need to delete the journal lines before you migrate your data.';


    procedure ImportExcelData(): Boolean
    var
        FileManagement: Codeunit "File Management";
        ServerFile: Text[250];
    begin
        OnUploadFile(ServerFile);
        if ServerFile = '' then
          ServerFile := CopyStr(FileManagement.UploadFile(ImportFromExcelTxt,ExcelFileExtensionTok),
              1,MaxStrLen(ServerFile));

        if ServerFile <> '' then begin
          ImportExcelDataByFileName(ServerFile);
          exit(true);
        end;

        exit(false);
    end;


    procedure ImportExcelDataByFileName(FileName: Text[250])
    var
        FileManagement: Codeunit "File Management";
        Window: Dialog;
    begin
        Window.Open(ImportingMsg);

        FileManagement.ValidateFileExtension(FileName,ExcelFileExtensionTok);
        CreatePackageMetadata(false);
        ValidateTemplateAndImportData(FileName);

        Window.Close;
    end;


    procedure ExportExcelTemplate(): Boolean
    var
        FileName: Text;
        HideDialog: Boolean;
    begin
        OnDownloadTemplate(HideDialog);
        exit(ExportExcelTemplateByFileName(FileName,HideDialog));
    end;


    procedure ExportExcelTemplateByFileName(var FileName: Text;HideDialog: Boolean): Boolean
    var
        ConfigPackageTable: Record "Config. Package Table";
    begin
        if FileName = '' then
          FileName :=
            StrSubstNo(ExcelFileNameTok,Format(CurrentDatetime,0,'<Day,2>_<Month,2>_<Year4>_<Hours24>_<Minutes,2>_<Seconds,2>'));

        CreatePackageMetadata(true);
        ConfigPackageTable.SetRange("Package Code",PackageCodeTxt);
        ConfigExcelExchange.SetHideDialog(HideDialog);
        exit(ConfigExcelExchange.ExportExcel(FileName,ConfigPackageTable,false,true));
    end;


    procedure GetPackageCode(): Code[20]
    begin
        exit(PackageCodeTxt);
    end;


    procedure CreatePackageMetadata(InsertConfigPackageFields: Boolean)
    var
        ConfigPackage: Record "Config. Package";
        ConfigPackageManagement: Codeunit "Config. Package Management";
        ApplicationManagement: Codeunit ApplicationManagement;
    begin
        ConfigPackage.SetRange(Code,PackageCodeTxt);
        ConfigPackage.DeleteAll(true);

        ConfigPackageManagement.InsertPackage(ConfigPackage,PackageCodeTxt,PackageNameTxt,false);
        ConfigPackage."Language ID" := ApplicationManagement.ApplicationLanguage;
        ConfigPackage."Product Version" := ApplicationManagement.ApplicationVersion;
        ConfigPackage.Modify;

        InsertPackageTables;

        if InsertConfigPackageFields then
          InsertPackageFields
    end;

    local procedure InsertPackageTables()
    var
        ConfigPackageField: Record "Config. Package Field";
        DataMigrationSetup: Record "Data Migration Setup";
    begin
        if not DataMigrationSetup.Get then begin
          DataMigrationSetup.Init;
          DataMigrationSetup.Insert;
        end;

        InsertPackageTableCustomer(DataMigrationSetup);
        InsertPackageTableVendor(DataMigrationSetup);
        InsertPackageTableItem(DataMigrationSetup);
        InsertPackageTableAccount(DataMigrationSetup);

        ConfigPackageField.SetRange("Package Code",PackageCodeTxt);
        ConfigPackageField.ModifyAll("Include Field",false);
    end;

    local procedure InsertPackageFields()
    begin
        InsertPackageFieldsCustomer;
        InsertPackageFieldsVendor;
        InsertPackageFieldsItem;
        InsertPackageFieldsAccount;
    end;

    local procedure InsertPackageTableCustomer(var DataMigrationSetup: Record "Data Migration Setup")
    var
        ConfigPackageTable: Record "Config. Package Table";
        ConfigTableProcessingRule: Record "Config. Table Processing Rule";
    begin
        ConfigPackageManagement.InsertPackageTable(ConfigPackageTable,PackageCodeTxt,Database::Customer);
        ConfigPackageTable."Data Template" := DataMigrationSetup."Default Customer Template";
        ConfigPackageTable.Modify;
        ConfigPackageManagement.InsertProcessingRuleCustom(
          ConfigTableProcessingRule,ConfigPackageTable,100000,Codeunit::"Excel Post Processor");
    end;

    local procedure InsertPackageFieldsCustomer()
    var
        ConfigPackageField: Record "Config. Package Field";
    begin
        ConfigPackageField.SetRange("Package Code",PackageCodeTxt);
        ConfigPackageField.SetRange("Table ID",Database::Customer);
        ConfigPackageField.DeleteAll(true);

        InsertPackageField(Database::Customer,1,1);     // No.
        InsertPackageField(Database::Customer,2,2);     // Name
        InsertPackageField(Database::Customer,3,3);     // Search Name
        InsertPackageField(Database::Customer,5,4);     // Address
        InsertPackageField(Database::Customer,7,5);     // City
        InsertPackageField(Database::Customer,92,6);    // County
        InsertPackageField(Database::Customer,91,7);    // Post Code
        InsertPackageField(Database::Customer,35,8);    // Country/Region Code
        InsertPackageField(Database::Customer,8,9);     // Contact
        InsertPackageField(Database::Customer,9,10);    // Phone No.
        InsertPackageField(Database::Customer,102,11);  // E-Mail
        InsertPackageField(Database::Customer,20,12);   // Credit Limit (LCY)
        InsertPackageField(Database::Customer,21,13);   // Customer Posting Group
        InsertPackageField(Database::Customer,27,14);   // Payment Terms Code
        InsertPackageField(Database::Customer,88,15);   // Gen. Bus. Posting Group
    end;

    local procedure InsertPackageTableVendor(var DataMigrationSetup: Record "Data Migration Setup")
    var
        ConfigPackageTable: Record "Config. Package Table";
        ConfigTableProcessingRule: Record "Config. Table Processing Rule";
    begin
        ConfigPackageManagement.InsertPackageTable(ConfigPackageTable,PackageCodeTxt,Database::Vendor);
        ConfigPackageTable."Data Template" := DataMigrationSetup."Default Vendor Template";
        ConfigPackageTable.Modify;
        ConfigPackageManagement.InsertProcessingRuleCustom(
          ConfigTableProcessingRule,ConfigPackageTable,100000,Codeunit::"Excel Post Processor");
    end;

    local procedure InsertPackageFieldsVendor()
    var
        ConfigPackageField: Record "Config. Package Field";
    begin
        ConfigPackageField.SetRange("Package Code",PackageCodeTxt);
        ConfigPackageField.SetRange("Table ID",Database::Vendor);
        ConfigPackageField.DeleteAll(true);

        InsertPackageField(Database::Vendor,1,1);     // No.
        InsertPackageField(Database::Vendor,2,2);     // Name
        InsertPackageField(Database::Vendor,3,3);     // Search Name
        InsertPackageField(Database::Vendor,5,4);     // Address
        InsertPackageField(Database::Vendor,7,5);     // City
        InsertPackageField(Database::Vendor,92,6);    // County
        InsertPackageField(Database::Vendor,91,7);    // Post Code
        InsertPackageField(Database::Vendor,35,8);    // Country/Region Code
        InsertPackageField(Database::Vendor,8,9);     // Contact
        InsertPackageField(Database::Vendor,9,10);    // Phone No.
        InsertPackageField(Database::Vendor,102,11);  // E-Mail
        InsertPackageField(Database::Vendor,21,12);   // Vendor Posting Group
        InsertPackageField(Database::Vendor,27,13);   // Payment Terms Code
        InsertPackageField(Database::Vendor,88,14);   // Gen. Bus. Posting Group
    end;

    local procedure InsertPackageTableItem(var DataMigrationSetup: Record "Data Migration Setup")
    var
        ConfigPackageTable: Record "Config. Package Table";
        ConfigPackageField: Record "Config. Package Field";
        ConfigTableProcessingRule: Record "Config. Table Processing Rule";
        Item: Record Item;
    begin
        ConfigPackageManagement.InsertPackageTable(ConfigPackageTable,PackageCodeTxt,Database::Item);
        ConfigPackageManagement.InsertPackageField(ConfigPackageField,PackageCodeTxt,Database::Item,
          Item.FieldNo(Inventory),Item.FieldName(Inventory),Item.FieldCaption(Inventory),
          true,true,false,false);
        ConfigPackageTable."Data Template" := DataMigrationSetup."Default Item Template";
        ConfigPackageTable.Modify;
        ConfigPackageManagement.InsertProcessingRuleCustom(
          ConfigTableProcessingRule,ConfigPackageTable,100000,Codeunit::"Excel Post Processor")
    end;

    local procedure InsertPackageFieldsItem()
    var
        ConfigPackageField: Record "Config. Package Field";
    begin
        ConfigPackageField.SetRange("Package Code",PackageCodeTxt);
        ConfigPackageField.SetRange("Table ID",Database::Item);
        ConfigPackageField.DeleteAll(true);

        InsertPackageField(Database::Item,1,1);     // No.
        InsertPackageField(Database::Item,3,2);     // Description
        InsertPackageField(Database::Item,4,3);     // Search Description
        InsertPackageField(Database::Item,8,4);     // Base Unit of Measure
        InsertPackageField(Database::Item,18,5);    // Unit Price
        InsertPackageField(Database::Item,20,6);    // Profit %
        InsertPackageField(Database::Item,22,7);    // Unit Cost
        InsertPackageField(Database::Item,24,8);    // Standard Cost
        InsertPackageField(Database::Item,68,9);    // Inventory
        InsertPackageField(Database::Item,35,10);   // Maximum Inventory
        InsertPackageField(Database::Item,121,11);  // Prevent Negative Inventory
        InsertPackageField(Database::Item,34,12);   // Reorder Point
        InsertPackageField(Database::Item,36,13);   // Reorder Quantity
        InsertPackageField(Database::Item,38,14);   // Unit List Price
        InsertPackageField(Database::Item,41,15);   // Gross Weight
        InsertPackageField(Database::Item,42,16);   // Net Weight
        InsertPackageField(Database::Item,5411,17); // Minimum Order Quantity
        InsertPackageField(Database::Item,5412,18); // Maximum Order Quantity
        InsertPackageField(Database::Item,5413,19); // Safety Stock Quantity
    end;

    local procedure InsertPackageField(TableNo: Integer;FieldNo: Integer;ProcessingOrderNo: Integer)
    var
        ConfigPackageField: Record "Config. Package Field";
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecordRef.Open(TableNo);
        FieldRef := RecordRef.Field(FieldNo);

        ConfigPackageManagement.InsertPackageField(ConfigPackageField,PackageCodeTxt,TableNo,
          FieldRef.Number,FieldRef.Name,FieldRef.Caption,true,true,false,false);
        ConfigPackageField.Validate("Processing Order",ProcessingOrderNo);
        ConfigPackageField.Modify(true);
    end;

    local procedure GetCodeunitNumber(): Integer
    begin
        exit(Codeunit::"Excel Data Migrator");
    end;

    local procedure ValidateTemplateAndImportData(FileName: Text)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ConfigPackage: Record "Config. Package";
        ConfigPackageTable: Record "Config. Package Table";
        ConfigPackageRecord: Record "Config. Package Record";
        ConfigPackageField: Record "Config. Package Field";
        ColumnHeaderRow: Integer;
        ColumnCount: Integer;
        RecordNo: Integer;
        FieldID: array [250] of Integer;
        I: Integer;
    begin
        ConfigPackage.Get(PackageCodeTxt);
        ConfigPackageTable.SetRange("Package Code",ConfigPackage.Code);

        ColumnHeaderRow := 3; // Data is stored in the Excel sheets starting from row 3

        if ConfigPackageTable.FindSet then
          repeat
            ConfigPackageField.Reset;
            ConfigPackageTable.CalcFields("Table Name");

            // Check if Excel file contains data sheets with the supported master tables (Customer, Vendor, Item)
            if IsTableInExcel(TempExcelBuffer,FileName,ConfigPackageTable."Table Name") then begin
              TempExcelBuffer.ReadSheet;
              // Jump to the Columns' header row
              TempExcelBuffer.SetFilter("Row No.",'%1..',ColumnHeaderRow);

              ConfigPackageField.SetRange("Package Code",PackageCodeTxt);
              ConfigPackageField.SetRange("Table ID",ConfigPackageTable."Table ID");

              ColumnCount := 0;

              if TempExcelBuffer.FindSet then
                repeat
                  if TempExcelBuffer."Row No." = ColumnHeaderRow then begin // Columns' header row
                    ConfigPackageField.SetRange("Field Caption",TempExcelBuffer."Cell Value as Text");

                    // Column can be mapped to a field, data will be imported to NAV
                    if ConfigPackageField.FindFirst then begin
                      FieldID[TempExcelBuffer."Column No."] := ConfigPackageField."Field ID";
                      ConfigPackageField."Include Field" := true;
                      ConfigPackageField.Modify;
                      ColumnCount += 1;
                    end else // Error is thrown when the template is corrupted (i.e., there are columns in Excel file that cannot be mapped to NAV)
                      Error(ExcelValidationErr);
                  end else begin // Read data row by row
                    // A record is created with every new row
                    ConfigPackageManagement.InitPackageRecord(ConfigPackageRecord,PackageCodeTxt,
                      ConfigPackageTable."Table ID");
                    RecordNo := ConfigPackageRecord."No.";
                    if ConfigPackageTable."Table ID" = 15 then begin
                      for I := 1 to ColumnCount do
                        if TempExcelBuffer.Get(TempExcelBuffer."Row No.",I) then // Mapping for Account fields
                          InsertAccountsFieldData(ConfigPackageTable."Table ID",RecordNo,FieldID[I],TempExcelBuffer."Cell Value as Text")
                    end else begin
                      for I := 1 to ColumnCount do
                        if TempExcelBuffer.Get(TempExcelBuffer."Row No.",I) then
                          // Fields are populated in the record created
                          InsertFieldData(
                            ConfigPackageTable."Table ID",RecordNo,FieldID[I],TempExcelBuffer."Cell Value as Text")
                        else
                          InsertFieldData(
                            ConfigPackageTable."Table ID",RecordNo,FieldID[I],'');
                    end;

                    // Go to next line
                    TempExcelBuffer.SetFilter("Row No.",'%1..',TempExcelBuffer."Row No." + 1);
                  end;
                until TempExcelBuffer.Next = 0;

              TempExcelBuffer.Reset;
              TempExcelBuffer.DeleteAll;
              TempExcelBuffer.CloseBook;
            end else begin
              // Table is removed from the configuration package because it doen't exist in the Excel file
              TempExcelBuffer.QuitExcel;
              ConfigPackageTable.Delete(true);
            end;
          until ConfigPackageTable.Next = 0;
    end;

    [TryFunction]
    local procedure IsTableInExcel(var TempExcelBuffer: Record "Excel Buffer" temporary;FileName: Text;TableName: Text[250])
    begin
        TempExcelBuffer.OpenBook(FileName,TableName);
    end;

    local procedure InsertFieldData(TableNo: Integer;RecordNo: Integer;FieldNo: Integer;Value: Text[250])
    var
        ConfigPackageData: Record "Config. Package Data";
    begin
        ConfigPackageManagement.InsertPackageData(ConfigPackageData,PackageCodeTxt,
          TableNo,RecordNo,FieldNo,Value,false);
    end;

    local procedure CreateDataMigrationEntites(var DataMigrationEntity: Record "Data Migration Entity")
    var
        ConfigPackage: Record "Config. Package";
        ConfigPackageTable: Record "Config. Package Table";
    begin
        ConfigPackage.Get(PackageCodeTxt);
        ConfigPackageTable.SetRange("Package Code",ConfigPackage.Code);
        DataMigrationEntity.DeleteAll;

        with ConfigPackageTable do
          if FindSet then
            repeat
              CalcFields("No. of Package Records");
              DataMigrationEntity.InsertRecord("Table ID","No. of Package Records");
            until Next = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Data Migrator Registration", 'OnRegisterDataMigrator', '', false, false)]
    local procedure RegisterExcelDataMigrator(var Sender: Record "Data Migrator Registration")
    begin
        Sender.RegisterDataMigrator(GetCodeunitNumber,DataMigratorDescriptionTxt);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Data Migrator Registration", 'OnHasSettings', '', false, false)]
    local procedure HasSettings(var Sender: Record "Data Migrator Registration";var HasSettings: Boolean)
    begin
        if Sender."No." <> GetCodeunitNumber then
          exit;

        HasSettings := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Data Migrator Registration", 'OnOpenSettings', '', false, false)]
    local procedure OpenSettings(var Sender: Record "Data Migrator Registration";var Handled: Boolean)
    begin
        if Sender."No." <> GetCodeunitNumber then
          exit;

        Page.RunModal(Page::"Data Migration Settings");
        Handled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Data Migrator Registration", 'OnValidateSettings', '', false, false)]
    local procedure ValidateSettings(var Sender: Record "Data Migrator Registration")
    var
        DataMigrationSetup: Record "Data Migration Setup";
    begin
        if Sender."No." <> GetCodeunitNumber then
          exit;

        DataMigrationSetup.Get;
        if (DataMigrationSetup."Default Customer Template" = '') and
           (DataMigrationSetup."Default Vendor Template" = '') and
           (DataMigrationSetup."Default Item Template" = '')
        then
          if not Confirm(SettingsMissingQst,true) then
            Error('');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Data Migrator Registration", 'OnHasTemplate', '', false, false)]
    local procedure HasTemplate(var Sender: Record "Data Migrator Registration";var HasTemplate: Boolean)
    begin
        if Sender."No." <> GetCodeunitNumber then
          exit;

        HasTemplate := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Data Migrator Registration", 'OnGetInstructions', '', false, false)]
    local procedure GetInstructions(var Sender: Record "Data Migrator Registration";var Instructions: Text;var Handled: Boolean)
    var
        CRLF: Text[2];
    begin
        if Sender."No." <> GetCodeunitNumber then
          exit;

        CRLF := '';
        CRLF[1] := 13;
        CRLF[2] := 10;

        Instructions := Instruction1Txt + CRLF + Instruction2Txt;

        Handled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Data Migrator Registration", 'OnDownloadTemplate', '', false, false)]
    local procedure DownloadTemplate(var Sender: Record "Data Migrator Registration";var Handled: Boolean)
    begin
        if Sender."No." <> GetCodeunitNumber then
          exit;

        if ExportExcelTemplate then begin
          Handled := true;
          exit;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Data Migrator Registration", 'OnDataImport', '', false, false)]
    local procedure ImportData(var Sender: Record "Data Migrator Registration";var Handled: Boolean)
    begin
        if Sender."No." <> GetCodeunitNumber then
          exit;

        if ImportExcelData then begin
          Handled := true;
          exit;
        end;

        Handled := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Data Migrator Registration", 'OnSelectDataToApply', '', false, false)]
    local procedure SelectDataToApply(var Sender: Record "Data Migrator Registration";var DataMigrationEntity: Record "Data Migration Entity";var Handled: Boolean)
    begin
        if Sender."No." <> GetCodeunitNumber then
          exit;

        CreateDataMigrationEntites(DataMigrationEntity);

        Handled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Data Migrator Registration", 'OnHasAdvancedApply', '', false, false)]
    local procedure HasAdvancedApply(var Sender: Record "Data Migrator Registration";var HasAdvancedApply: Boolean)
    begin
        if Sender."No." <> GetCodeunitNumber then
          exit;

        HasAdvancedApply := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Data Migrator Registration", 'OnOpenAdvancedApply', '', false, false)]
    local procedure OpenAdvancedApply(var Sender: Record "Data Migrator Registration";var DataMigrationEntity: Record "Data Migration Entity";var Handled: Boolean)
    var
        ConfigPackage: Record "Config. Package";
    begin
        if Sender."No." <> GetCodeunitNumber then
          exit;

        if not Confirm(OpenAdvancedQst,true) then
          exit;

        ConfigPackage.Get(PackageCodeTxt);
        Page.RunModal(Page::"Config. Package Card",ConfigPackage);

        CreateDataMigrationEntites(DataMigrationEntity);
        Handled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Data Migrator Registration", 'OnApplySelectedData', '', false, false)]
    local procedure ApplySelectedData(var Sender: Record "Data Migrator Registration";var DataMigrationEntity: Record "Data Migration Entity";var Handled: Boolean)
    var
        ConfigPackage: Record "Config. Package";
        ConfigPackageTable: Record "Config. Package Table";
        ConfigPackageManagement: Codeunit "Config. Package Management";
        Window: Dialog;
        ErrorNo: Integer;
    begin
        if Sender."No." <> GetCodeunitNumber then
          exit;

        if DataMigrationEntity.FindSet then
          repeat
            if not DataMigrationEntity.Selected then begin
              ConfigPackageTable.Get(PackageCodeTxt,DataMigrationEntity."Table ID");
              ConfigPackageTable.Delete(true);
            end else begin
              ErrorNo := 0;
              CheckBegBalTransactions(DataMigrationEntity."Table ID",ErrorNo);
              if ErrorNo > 0 then begin
                DisplayErrorMessage(ErrorNo);
                exit;
              end;
            end;
          until DataMigrationEntity.Next = 0;

        ConfigPackage.Get(PackageCodeTxt);
        ConfigPackageTable.SetRange("Package Code",ConfigPackage.Code);
        Window.Open(ApplyingMsg);
        RemoveDemoData(ConfigPackageTable);// Remove the demo data before importing Accounts(if any)
        ConfigPackageManagement.ApplyPackage(ConfigPackage,ConfigPackageTable,true);
        Window.Close;
        Handled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Data Migrator Registration", 'OnHasErrors', '', false, false)]
    local procedure HasErrors(var Sender: Record "Data Migrator Registration";var HasErrors: Boolean)
    var
        ConfigPackage: Record "Config. Package";
    begin
        if Sender."No." <> GetCodeunitNumber then
          exit;

        ConfigPackage.Get(PackageCodeTxt);
        ConfigPackage.CalcFields("No. of Errors");
        HasErrors := ConfigPackage."No. of Errors" <> 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Data Migrator Registration", 'OnShowErrors', '', false, false)]
    local procedure ShowErrors(var Sender: Record "Data Migrator Registration";var Handled: Boolean)
    var
        ConfigPackageError: Record "Config. Package Error";
    begin
        if Sender."No." <> GetCodeunitNumber then
          exit;

        ConfigPackageError.SetRange("Package Code",PackageCodeTxt);
        Page.RunModal(Page::"Config. Package Errors",ConfigPackageError);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUploadFile(var ServerFileName: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnDownloadTemplate(var HideDialog: Boolean)
    begin
    end;

    local procedure CheckBegBalTransactions(TableID: Integer;var ErrorNo: Integer)
    var
        GLEntry: Record "G/L Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        GenJournalLine: Record "Gen. Journal Line";
        ItemJournalLine: Record "Item Journal Line";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        if ErrorNo = 0 then
          if TableID = 15 then begin
            GLEntry.Reset;
            GenJournalLine.Reset;
            if GLEntry.FindFirst then
              ErrorNo := 2// Already Beginning balance exists and G/L Accounts is selected
            else
              if GenJournalLine.FindFirst then
                ErrorNo := 6;// Saved General Journal line exists.
          end else begin
            if TableID = 18 then begin // Customer
              CustLedgerEntry.Reset;
              GenJournalLine.Reset;
              if CustLedgerEntry.FindFirst then
                ErrorNo := 3// Already Customer is imported or transactions exists.
              else
                if GenJournalLine.FindFirst then
                  ErrorNo := 6;// Saved General Journal line exists.
            end else
              if TableID = 23 then begin // Vendor
                VendLedgerEntry.Reset;
                GenJournalLine.Reset;
                if VendLedgerEntry.FindFirst then
                  ErrorNo := 4// Already Vendor is imported or transactions exists.
                else
                  if GenJournalLine.FindFirst then
                    ErrorNo := 6;// Saved General Journal line exists.
              end else
                if TableID = 27 then begin // Item
                  ItemLedgerEntry.Reset;
                  ItemJournalLine.Reset;
                  if ItemLedgerEntry.FindFirst then
                    ErrorNo := 5// Already Item is imported or transactions exists.
                  else
                    if ItemJournalLine.FindFirst then
                      ErrorNo := 6;// Saved Item Journal line exists.
                end
          end;
    end;

    local procedure DisplayErrorMessage(ErrorNo: Integer)
    begin
        case ErrorNo of
          1:
            Message(TransactionExistsMsg);
          2:
            Message(TransactionforGLExistsMsg);
          3:
            Message(TransactionforCustExistsMsg);
          4:
            Message(TransactionforVendExistsMsg);
          5:
            Message(TransactionforItemExistsMsg);
          6:
            Message(SavedJrnlLinesFoundMsg);
        end;
    end;

    local procedure InsertPackageTableAccount(var DataMigrationSetup: Record "Data Migration Setup")
    var
        ConfigPackageTable: Record "Config. Package Table";
        ConfigTableProcessingRule: Record "Config. Table Processing Rule";
    begin
        ConfigPackageManagement.InsertPackageTable(ConfigPackageTable,PackageCodeTxt,Database::"G/L Account");
        ConfigPackageTable."Data Template" := DataMigrationSetup."Default Account Template";
        ConfigPackageTable.Modify;
        ConfigPackageManagement.InsertProcessingRuleCustom(
          ConfigTableProcessingRule,ConfigPackageTable,100000,Codeunit::"Excel Post Processor");
    end;

    local procedure InsertPackageFieldsAccount()
    var
        ConfigPackageField: Record "Config. Package Field";
    begin
        ConfigPackageField.SetRange("Package Code",PackageCodeTxt);
        ConfigPackageField.SetRange("Table ID",Database::"G/L Account");
        ConfigPackageField.DeleteAll(true);

        InsertPackageField(Database::"G/L Account",1,1);     // No.
        InsertPackageField(Database::"G/L Account",2,2);     // Name
        InsertPackageField(Database::"G/L Account",3,3);     // Search Name
        InsertPackageField(Database::"G/L Account",4,4);     // Account Type
        InsertPackageField(Database::"G/L Account",8,5);     // Account Category
        InsertPackageField(Database::"G/L Account",9,6);     // Income/Balance
        InsertPackageField(Database::"G/L Account",10,7);    // Debit/Credit
        InsertPackageField(Database::"G/L Account",13,8);    // Blocked
        InsertPackageField(Database::"G/L Account",43,9);   // Gen. Posting Type
        InsertPackageField(Database::"G/L Account",44,10);   // Gen. Bus. Posting Group
        InsertPackageField(Database::"G/L Account",45,11);   // Gen. Prod. Posting Group
        InsertPackageField(Database::"G/L Account",80,12);   // Account Subcategory Entry No.
    end;

    local procedure RemoveDemoData(var ConfigPackageTable: Record "Config. Package Table")
    var
        ConfigPackageData: Record "Config. Package Data";
        ConfigPackageRecord: Record "Config. Package Record";
    begin
        if ConfigPackageTable.Get(PackageCodeTxt,Database::"G/L Account") then begin
          ConfigPackageRecord.SetRange("Package Code",ConfigPackageTable."Package Code");
          ConfigPackageRecord.SetRange("Table ID",ConfigPackageTable."Table ID");
          if ConfigPackageRecord.FindFirst then begin
            ConfigPackageData.SetRange("Package Code",ConfigPackageRecord."Package Code");
            ConfigPackageData.SetRange("Table ID",ConfigPackageRecord."Table ID");
            if ConfigPackageData.FindFirst then
              Codeunit.Run(Codeunit::"Data Migration Del G/L Account");
          end;
        end;
    end;

    local procedure InsertAccountsFieldData(TableNo: Integer;RecordNo: Integer;FieldNo: Integer;Value: Text[250])
    var
        GLAccount: Record "G/L Account";
    begin
        if FieldNo = 4 then begin
          if Value = '0' then
            InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."account type"::Posting))
          else
            if Value = '1' then
              InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."account type"::Heading))
            else
              if Value = '2' then
                InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."account type"::Total))
              else
                if Value = '3' then
                  InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."account type"::"Begin-Total"))
                else
                  if Value = '4' then
                    InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."account type"::"End-Total"))
        end else
          if FieldNo = 8 then begin
            if Value = '0' then
              InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."account category"::" "))
            else
              if Value = '1' then
                InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."account category"::Assets))
              else
                if Value = '2' then
                  InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."account category"::Liabilities))
                else
                  if Value = '3' then
                    InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."account category"::Equity))
                  else
                    if Value = '4' then
                      InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."account category"::Income))
                    else
                      if Value = '5' then
                        InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."account category"::"Cost of Goods Sold"))
                      else
                        if Value = '6' then
                          InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."account category"::Expense))
          end else
            if FieldNo = 9 then begin
              if Value = '0' then
                InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."income/balance"::"Income Statement"))
              else
                if Value = '1' then
                  InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."income/balance"::"Balance Sheet"))
            end else
              if FieldNo = 10 then begin
                if Value = '0' then
                  InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."debit/credit"::Both))
                else
                  if Value = '1' then
                    InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."debit/credit"::Debit))
                  else
                    if Value = '2' then
                      InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."debit/credit"::Credit))
              end else
                if FieldNo = 43 then begin
                  if Value = '0' then
                    InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."gen. posting type"::" "))
                  else
                    if Value = '1' then
                      InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."gen. posting type"::Purchase))
                    else
                      if Value = '2' then
                        InsertFieldData(TableNo,RecordNo,FieldNo,Format(GLAccount."gen. posting type"::Sale))
                end else
                  InsertFieldData(TableNo,RecordNo,FieldNo,Value)
    end;
}

