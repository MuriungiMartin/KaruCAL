#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 2500 NavExtensionInstallationMgmt
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        InstalledExtensionTable: Record "NAV App Installed App";
        Installer: dotnet NavAppALInstaller;
        InstallerHasBeenCreated: Boolean;
        InstalledTxt: label 'Installed';
        NotInstalledTxt: label 'Not Installed';
        FullVersionStringTxt: label '%1.%2.%3.%4', Comment='%1=Version Major, %2=Version Minor, %3=Version build, %4=Version revision';
        NoRevisionVersionStringTxt: label '%1.%2.%3', Comment='%1=Version Major, %2=Version Minor, %3=Version build';
        NoBuildVersionStringTxt: label '%1.%2', Comment='%1=Version Major, %2=Version Minor';
        NullGuidTok: label '00000000-0000-0000-0000-000000000000', Locked=true;


    procedure IsInstalled(PackageID: Guid): Boolean
    begin
        InstalledExtensionTable.SetFilter("Package ID",'%1',PackageID);
        exit(InstalledExtensionTable.FindFirst);
    end;


    procedure InstallNavExtension(PackageID: Guid;Lcid: Integer)
    begin
        AssertIsInitialized;
        Installer.ALInstallNavApp(PackageID,Lcid);
    end;


    procedure GetExtensionInstalledDisplayString(PackageId: Guid): Text[15]
    begin
        if IsInstalled(PackageId) then
          exit(InstalledTxt);

        exit(NotInstalledTxt);
    end;


    procedure GetDependenciesForExtensionToInstall(PackageID: Guid): Text
    begin
        AssertIsInitialized;
        exit(Installer.ALGetAppDependenciesToInstallString(PackageID));
    end;


    procedure GetDependentForExtensionToUninstall(PackageID: Guid): Text
    begin
        AssertIsInitialized;
        exit(Installer.ALGetDependentAppsToUninstallString(PackageID));
    end;

    local procedure AssertIsInitialized()
    begin
        if not InstallerHasBeenCreated then begin
          Installer := Installer.NavAppALInstaller;
          InstallerHasBeenCreated := true;
        end;
    end;


    procedure UninstallNavExtension(PackageID: Guid)
    begin
        AssertIsInitialized;
        Installer.ALUninstallNavApp(PackageID);
    end;


    procedure GetVersionDisplayString(Major: Integer;Minor: Integer;Build: Integer;Revision: Integer): Text
    begin
        if Build <= -1 then
          exit(StrSubstNo(NoBuildVersionStringTxt,Major,Minor));

        if Revision <= -1 then
          exit(StrSubstNo(NoRevisionVersionStringTxt,Major,Minor,Build));

        exit(StrSubstNo(FullVersionStringTxt,Major,Minor,Build,Revision));
    end;


    procedure GetLatestVersionPackageId(AppId: Guid): Guid
    var
        NavAppTable: Record "NAV App";
        Result: Guid;
    begin
        NavAppTable.SetFilter(ID,'%1',AppId);
        NavAppTable.SetCurrentkey(Name,"Version Major","Version Minor","Version Build","Version Revision");
        NavAppTable.Ascending(false);
        Result := NullGuidTok;
        if NavAppTable.FindFirst then
          Result := NavAppTable."Package ID";

        exit(Result);
    end;
}

