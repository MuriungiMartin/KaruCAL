#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1800 "Assisted Company Setup"
{

    trigger OnRun()
    begin
    end;

    var
        EnableWizardErr: label 'You cannot enable the assisted company setup for an already active company.';
        NoConfigPackageFileMsg: label 'There are no configuration package files defined in your system. Assisted company setup will not be fully functional. Please contact your system administrator.';
        CompanyIsBeingSetUpMsg: label 'The Company is being set up. Please wait...';
        CompanySetUpInProgressErr: label 'The company was just created, and we are still setting up data and settings for it. Wait a few minutes, and then try again.';


    procedure EnableAssistedCompanySetup(SetupCompanyName: Text[30];AssistedSetupEnabled: Boolean)
    var
        GLEntry: Record "G/L Entry";
        ConfigurationPackageFile: Record "Configuration Package File";
    begin
        if AssistedSetupEnabled then begin
          GLEntry.ChangeCompany(SetupCompanyName);
          if not GLEntry.IsEmpty then
            Error(EnableWizardErr);
          if ConfigurationPackageFile.IsEmpty then
            Message(NoConfigPackageFileMsg);
        end;
        SetAssistedCompanySetupVisibility(SetupCompanyName,AssistedSetupEnabled);
    end;

    local procedure RunAssistedCompanySetup()
    var
        AssistedSetup: Record "Assisted Setup";
    begin
        if not GuiAllowed then
          exit;

        if not AssistedSetup.ReadPermission then
          exit;

        if CompanyActive then
          exit;

        if not AssistedSetupEnabled then
          exit;

        if AssistedSetup.GetStatus(Page::"Assisted Company Setup Wizard") = AssistedSetup.Status::Completed then
          exit;

        if CurrentClientType <> Clienttype::Phone then
          Page.RunModal(Page::"Assisted Company Setup Wizard");
    end;


    procedure ApplyUserInput(var TempConfigSetup: Record "Config. Setup" temporary;var BankAccount: Record "Bank Account";AccountingPeriodStartDate: Date;SkipSetupCompanyInfo: Boolean)
    begin
        if not SkipSetupCompanyInfo then
          TempConfigSetup.CopyCompInfo;
        CreateAccountingPeriod(AccountingPeriodStartDate);
        SetupCompanyBankAccount(BankAccount);
    end;


    procedure GetConfigurationPackageFile(ConfigurationPackageFile: Record "Configuration Package File") ServerTempFileName: Text
    var
        FileManagement: Codeunit "File Management";
        TempFile: File;
        OutStream: OutStream;
        InStream: InStream;
    begin
        ServerTempFileName := FileManagement.ServerTempFileName('rapidstart');
        TempFile.Create(ServerTempFileName);
        TempFile.CreateOutstream(OutStream);
        ConfigurationPackageFile.CalcFields(Package);
        ConfigurationPackageFile.Package.CreateInstream(InStream);
        CopyStream(OutStream,InStream);
        TempFile.Close;
    end;

    local procedure CreateAccountingPeriod(StartDate: Date)
    var
        AccountingPeriod: Record "Accounting Period";
        CreateFiscalYear: Report "Create Fiscal Year";
        DateFormulaVariable: DateFormula;
    begin
        // The wizard should only setup accounting periods, if non exist.
        if not AccountingPeriod.IsEmpty then
          exit;

        Evaluate(DateFormulaVariable,'<1M>');
        CreateFiscalYear.InitializeRequest(12,DateFormulaVariable,StartDate);
        CreateFiscalYear.UseRequestPage(false);
        CreateFiscalYear.HideConfirmationDialog(true);
        CreateFiscalYear.RunModal;
    end;

    local procedure SetupCompanyBankAccount(var BankAccount: Record "Bank Account")
    var
        CompanyInformation: Record "Company Information";
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
    begin
        CompanyInformation.Get;
        CompanyInformationMgt.UpdateCompanyBankAccount(CompanyInformation,'',BankAccount);
    end;

    local procedure AssistedSetupEnabled(): Boolean
    var
        AssistedCompanySetupStatus: Record "Assisted Company Setup Status";
    begin
        exit(AssistedCompanySetupStatus.Get(COMPANYNAME) and AssistedCompanySetupStatus.Enabled);
    end;

    local procedure CompanyActive(): Boolean
    var
        GLEntry: Record "G/L Entry";
    begin
        exit(not GLEntry.IsEmpty);
    end;


    procedure SetAssistedCompanySetupVisibility(SetupCompanyName: Text[30];IsVisible: Boolean)
    var
        AssistedSetup: Record "Assisted Setup";
    begin
        AssistedSetup.ChangeCompany(SetupCompanyName);
        if AssistedSetup.Get(Page::"Assisted Company Setup Wizard") then begin
          AssistedSetup.Visible := IsVisible;
          AssistedSetup.Modify;
        end;
    end;


    procedure CompanySetupCompleted(NewCompanyName: Text): Boolean
    var
        ActiveSession: Record "Active Session";
        AssistedCompanySetupStatus: Record "Assisted Company Setup Status";
    begin
        if not AssistedCompanySetupStatus.Get(NewCompanyName) then
          exit(true);

        if not ActiveSession.Get(ServiceInstanceId,AssistedCompanySetupStatus."Company Setup Session ID") then
          exit(true);

        exit(false);
    end;


    procedure WaitForPackageImportToComplete(CompanySetupSessionID: Integer)
    var
        ActiveSession: Record "Active Session";
        Window: Dialog;
    begin
        if CompanySetupCompleted(COMPANYNAME) then
          exit;

        Window.Open(CompanyIsBeingSetUpMsg);
        while ActiveSession.Get(ServiceInstanceId,CompanySetupSessionID) do
          Sleep(1000);
        Window.Close;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", 'OnCompanyInitialize', '', false, false)]
    local procedure OnCompanyInitialize()
    var
        AssistedSetup: Record "Assisted Setup";
    begin
        AssistedSetup.Initialize;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Assisted Company Setup Status", 'OnEnabled', '', false, false)]
    local procedure OnEnableAssistedCompanySetup(SetupCompanyName: Text[30];AssistedSetupEnabled: Boolean)
    begin
        EnableAssistedCompanySetup(SetupCompanyName,AssistedSetupEnabled);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnAfterCompanyOpen', '', false, false)]
    local procedure OnAfterCompanyOpen()
    var
        AssistedCompanySetupStatus: Record "Assisted Company Setup Status";
    begin
        // Any running imports need to complete before we launch the assisted company setup wizard, else the wizard will suggest import of packages.
        if AssistedCompanySetupStatus.Get(COMPANYNAME) then
          WaitForPackageImportToComplete(AssistedCompanySetupStatus."Company Setup Session ID");
        RunAssistedCompanySetup;
    end;

    [EventSubscriber(Objecttype::Page, 9177, 'OnBeforeActionEvent', 'Create New Company', false, false)]
    local procedure OnBeforeCreateNewCompany(var Rec: Record Company)
    begin
        Page.RunModal(Page::"Company Creation Wizard");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Assisted Company Setup Status", 'OnAfterValidateEvent', 'Package Imported', false, false)]
    local procedure OnAfterPackageImportedValidate(var Rec: Record "Assisted Company Setup Status";var xRec: Record "Assisted Company Setup Status";CurrFieldNo: Integer)
    begin
        // Send global notification that the new company is ready for use
    end;

    [EventSubscriber(ObjectType::Table, Database::"Assisted Company Setup Status", 'OnAfterValidateEvent', 'Import Failed', false, false)]
    local procedure OnAfterImportFailedValidate(var Rec: Record "Assisted Company Setup Status";var xRec: Record "Assisted Company Setup Status";CurrFieldNo: Integer)
    begin
        // Send global notification that the company set up failed
    end;

    [EventSubscriber(Objecttype::Page, 9176, 'OnCompanyChange', '', false, false)]
    local procedure OnCompanyChange(NewCompanyName: Text)
    begin
        if not CompanySetupCompleted(NewCompanyName) then
          Error(CompanySetUpInProgressErr);
    end;
}

