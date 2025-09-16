#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1640 "Add-in Deployment Helper"
{

    trigger OnRun()
    begin
    end;

    var
        ExchangePowerShellRunner: Codeunit "Exchange PowerShell Runner";
        AddInManifestManagement: Codeunit "Add-in Manifest Management";
        AppNotInstalledErr: label 'The application %1 did not install as expected. This might be caused by problems with the manifest file, problems connecting to the Exchange PowerShell server, or a version number that is not equal to or higher than the already installed application. You can download the manifest locally and then upload it to the Exchange Administration Center to determine the cause.', Comment='%1: A GUID identifying the office add-in.';


    procedure DeployManifest(var NewOfficeAddin: Record "Office Add-in")
    var
        UserPreference: Record "User Preference";
        InstructionMgt: Codeunit "Instruction Mgt.";
        ManifestStream: InStream;
    begin
        InitializeExchangePSRunner;

        AddInManifestManagement.GenerateManifest(NewOfficeAddin);
        NewOfficeAddin.CalcFields(Manifest);
        NewOfficeAddin.Manifest.CreateInstream(ManifestStream);

        // Clear the credentials if the action fails and reset the PS object.
        if not RunManifestDeployer(ManifestStream,NewOfficeAddin."Application ID") then begin
          ExchangePowerShellRunner.ResetInitialization;
          Error(GetLastErrorText);
        end;

        NewOfficeAddin."Deployment Date" := Today;
        NewOfficeAddin.Modify;

        UserPreference.SetRange("Instruction Code",InstructionMgt.OfficeUpdateNotificationCode);
        UserPreference.DeleteAll;
    end;

    [TryFunction]
    local procedure RunManifestDeployer(ManifestStream: InStream;AppID: Guid)
    var
        PSObj: dotnet PSObjectAdapter;
        MemStream: dotnet MemoryStream;
        StreamBytes: dotnet Array;
        ProvisionMode: Text;
        DefaultUserEnableState: Text;
        EnabledState: Text;
    begin
        InitializeExchangePSRunner;

        ExchangePowerShellRunner.GetApp(AppID,PSObj);

        if IsNull(PSObj) then begin
          DefaultUserEnableState := 'Enabled';
          EnabledState := 'TRUE';
          ProvisionMode := 'Everyone';
        end;

        // Need to copy the manifest into a MemStream for use in PS
        MemStream := MemStream.MemoryStream;
        CopyStream(MemStream,ManifestStream);
        StreamBytes := MemStream.ToArray;

        // Add the add-in
        if not ExchangePowerShellRunner.NewApp(StreamBytes,DefaultUserEnableState,EnabledState,ProvisionMode) then
          Error(AppNotInstalledErr,Format(AppID));
    end;


    procedure SetManifestDeploymentCredentials(Username: Text[80];Password: Text[30])
    begin
        ExchangePowerShellRunner.SetCredentials(Username,Password);
    end;


    procedure SetManifestDeploymentCustomEndpoint(Endpoint: Text[250])
    begin
        ExchangePowerShellRunner.SetEndpoint(Endpoint);
    end;


    procedure RemoveApp(var OfficeAddin: Record "Office Add-in")
    var
        AppID: Guid;
    begin
        InitializeExchangePSRunner;
        AppID := AddInManifestManagement.GetAppID(OfficeAddin);
        ExchangePowerShellRunner.RemoveApp(AppID);
    end;

    local procedure InitializeExchangePSRunner()
    begin
        ExchangePowerShellRunner.PromptForCredentials;
        ExchangePowerShellRunner.InitializePSRunner;
        ExchangePowerShellRunner.ValidateCredentials;
    end;


    procedure InitializeAndValidate()
    begin
        InitializeExchangePSRunner;
    end;


    procedure CheckVersion(HostType: Text;Version: Text) CanContinue: Boolean
    var
        OfficeAddin: Record "Office Add-in";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        GetAddinFromHostType(OfficeAddin,HostType);
        CanContinue := true;
        if OfficeAddin.Version <> Version then
          if OfficeAddin.Breaking then
            Page.RunModal(Page::"Office Update Available Dlg",OfficeAddin)
          else
            if InstructionMgt.IsEnabled(InstructionMgt.OfficeUpdateNotificationCode) then begin
              Page.RunModal(Page::"Office Update Available Dlg",OfficeAddin);
              CanContinue := not OfficeAddin.Breaking;
            end;
    end;


    procedure GetAddinFromHostType(var OfficeAddin: Record "Office Add-in";HostType: Text)
    var
        OfficeHostType: dotnet OfficeHostType;
    begin
        case HostType of
          OfficeHostType.OutlookItemRead,OfficeHostType.OutlookItemEdit,OfficeHostType.OutlookTaskPane,OfficeHostType.OutlookMobileApp:
            OfficeAddin.Get('cfca30bd-9846-4819-a6fc-56c89c5aae96');
          OfficeHostType.OutlookHyperlink:
            OfficeAddin.Get('cf6f2e6a-5f76-4a17-b966-2ed9d0b3e88a');
        end;
    end;
}

