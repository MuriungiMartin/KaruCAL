#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1805 "Import Config. Package Files"
{
    // // This code unit is executed in a separate session. Messages and errors will be output to the event log.

    TableNo = "Configuration Package File";

    trigger OnRun()
    var
        LogInManagement: Codeunit LogInManagement;
    begin
        LogInManagement.InitializeCompany;
        ImportConfigurationPackageFiles(Rec);
    end;

    var
        NoPackDefinedMsg: label 'Critical Error: No configuration package file is defined within the specified filter %1. Please contact your system administrator.', Comment='%1 = Filter String';
        ImportStartedMsg: label 'The import of the %1 configuration package to the %2 company has started.', Comment='%1 = Configuration Package Code, %2 = Company Name';
        ImportSuccessfulMsg: label 'The configuration package %1 was successfully imported to the %2 company.', Comment='%1 = Configuration Package Code, %2 = Company Name';
        ApplicationStartedMsg: label 'Application of the %1 configuration package to the %2 company has started.', Comment='%1 = Configuration Package Code, %2 = Company Name';
        ApplicationSuccessfulMsg: label 'The configuration package %1 was successfully applied to the %2 company.', Comment='%1 = Configuration Package Code, %2 = Company Name';
        ApplicationFailedMsg: label 'Critical Error: %1 errors occurred during the application of the %2 package to the %3 company. Please contact your system administrator.', Comment='%1 = No. of errors, %2 = Package Code, %3 = Company Name';

    local procedure ImportConfigurationPackageFiles(var ConfigurationPackageFile: Record "Configuration Package File")
    var
        AssistedCompanySetupStatus: Record "Assisted Company Setup Status";
        TempConfigSetupSystemRapidStart: Record "Config. Setup" temporary;
        ConfigPackageImport: Codeunit "Config. Package - Import";
        AssistedCompanySetup: Codeunit "Assisted Company Setup";
        ServerTempFileName: Text;
        ErrorCount: Integer;
        TotalNoOfErrors: Integer;
    begin
        AssistedCompanySetupStatus.Get(COMPANYNAME);
        AssistedCompanySetupStatus."Company Setup Session ID" := SessionId;
        AssistedCompanySetupStatus.Modify;
        Commit;

        ConfigurationPackageFile.SetCurrentkey("Processing Order");
        if ConfigurationPackageFile.FindSet then begin
          repeat
            Message(ImportStartedMsg,ConfigurationPackageFile.Code,COMPANYNAME);
            ServerTempFileName := AssistedCompanySetup.GetConfigurationPackageFile(ConfigurationPackageFile);
            ConfigPackageImport.ImportRapidStartPackage(ServerTempFileName,TempConfigSetupSystemRapidStart);
            Message(ImportSuccessfulMsg,ConfigurationPackageFile.Code,COMPANYNAME);

            Message(ApplicationStartedMsg,ConfigurationPackageFile.Code,COMPANYNAME);
            ErrorCount := TempConfigSetupSystemRapidStart.ApplyPackages;
            TotalNoOfErrors += ErrorCount;
            TempConfigSetupSystemRapidStart.Delete;
            Erase(ServerTempFileName);
            if ErrorCount > 0 then
              Message(ApplicationFailedMsg,ErrorCount,ConfigurationPackageFile.Code,COMPANYNAME)
            else
              Message(ApplicationSuccessfulMsg,ConfigurationPackageFile.Code,COMPANYNAME);
          until ConfigurationPackageFile.Next = 0;
          if TotalNoOfErrors > 0 then
            AssistedCompanySetupStatus.Validate("Import Failed",true)
          else
            AssistedCompanySetupStatus.Validate("Package Imported",true);
        end else begin
          AssistedCompanySetupStatus.Validate("Import Failed",true);
          Message(NoPackDefinedMsg,ConfigurationPackageFile.GetFilters);
        end;
        AssistedCompanySetupStatus."Company Setup Session ID" := 0;
        AssistedCompanySetupStatus.Modify;
        Commit;
    end;
}

