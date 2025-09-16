#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9170 "Conf./Personalization Mgt."
{

    trigger OnRun()
    begin
        InitializeProfiles;
    end;

    var
        DeleteConfigurationChangesQst: label 'This will delete all configuration changes made for this profile.  Do you want to continue?';
        DeletePersonalizationChangesQst: label 'This will delete all personalization changes made by this user.  Do you want to continue?';
        NoDeleteProfileErr: label 'You cannot delete a profile with default Role Center.';
        AccountingManagerProfileTxt: label 'Accounting Manager';
        AccountingManagerDescriptionTxt: label 'Accounting Manager';
        APCoordinatorProfileTxt: label 'AP Coordinator';
        APCoordinatorDescriptionTxt: label 'Accounts Payable Coordinator';
        ARAdministratorProfileTxt: label 'AR Administrator';
        ARAdministratorDescriptionTxt: label 'Accounts Receivable Administrator';
        BookkeeperProfileTxt: label 'Bookkeeper';
        BookkeeperDescriptionTxt: label 'Bookkeeper';
        SalesManagerProfileTxt: label 'Sales Manager';
        SalesManagerDescriptionTxt: label 'Sales Manager';
        OrderProcessorProfileTxt: label 'Order Processor';
        SalesOrderProcessorDescriptionTxt: label 'Sales Order Processor';
        PurchasingAgentProfileTxt: label 'Purchasing Agent';
        PurchasingAgentDescriptionTxt: label 'Purchasing Agent';
        ShippingandReceivingWMSProfileTxt: label 'Shipping and Receiving - WMS';
        ShippingandReceivingWMSDescriptionTxt: label 'Shipping and Receiving - Warehouse Management System';
        ShippingandReceivingProfileTxt: label 'Shipping and Receiving';
        ShippingandReceivingDescriptionTxt: label 'Shipping and Receiving - Order-by-Order';
        WarehouseWorkerWMSProfileTxt: label 'Warehouse Worker - WMS';
        WarehouseWorkerWMSDescriptionTxt: label 'Warehouse Worker - Warehouse Management System';
        ProductionPlannerProfileTxt: label 'Production Planner';
        ProductionPlannerDescriptionTxt: label 'Production Planner';
        ShopSupervisorProfileTxt: label 'Shop Supervisor';
        ShopSupervisorDescriptionTxt: label 'Shop Supervisor - Manufacturing Comprehensive';
        ShopSupervisorFoundationProfileTxt: label 'Shop Supervisor - Foundation';
        ShopSupervisorFoundationDescriptionTxt: label 'Shop Supervisor - Manufacturing Foundation';
        MachineOperatorProfileTxt: label 'Machine Operator';
        MachineOperatorDescriptionTxt: label 'Machine Operator - Manufacturing Comprehensive';
        ResourceManagerProfileTxt: label 'Resource Manager';
        ResourceManagerDescriptionTxt: label 'Resource Manager';
        ProjectManagerProfileTxt: label 'Project Manager';
        ProjectManagerDescriptionTxt: label 'Project Manager';
        DispatcherProfileTxt: label 'Dispatcher';
        DispatcherDescriptionTxt: label 'Dispatcher - Customer Service';
        OutboundTechnicianProfileTxt: label 'Outbound Technician';
        OutboundTechnicianDescriptionTxt: label 'Outbound Technician - Customer Service';
        ITManagerProfileTxt: label 'IT Manager';
        ITManagerDescriptionTxt: label 'IT Manager';
        PresidentProfileTxt: label 'President';
        PresidentDescriptionTxt: label 'President';
        PresidentSBProfileTxt: label 'President - Small Business';
        PresidentSBDescriptionTxt: label 'President - Small Business';
        Text1480000: label ' HR Manager';
        Text1480001: label ' Human Resources Manager';
        Text1480002: label ' Payroll Administrator';
        Text1480003: label ' Payroll Administrator';
        Text1480004: label ' Credit Manager';
        Text1480005: label ' Credit and Collections Manager';
        RapidStartServicesProfileTxt: label 'RapidStart Services';
        RapidStartServicesDescriptionTxt: label 'RapidStart Services Implementer';
        AccountingServicesTxt: label 'Accounting Services';
        AccountingServicesDescriptionTxt: label 'Profile for users that have outsourced their Accounting';
        SecurityAdministratorTxt: label 'Security Administrator';
        SecurityAdministratorDescriptionTxt: label 'Administration of users, user groups, and permissions';
        AccountantTxt: label 'Accountant';
        AccountantDescriptionTxt: label 'Accountant';
        BusinessManagerIDTxt: label 'Business Manager';
        BusinessManagerDescriptionTxt: label 'Business Manager';
        CannotDeleteDefaultUserProfileErr: label 'You cannot delete this profile because it is set up as a default profile for one or more users or user groups.';
        XMLDOMManagement: Codeunit "XML DOM Management";
        RegEx: dotnet Regex;
        CultureInfo: dotnet CultureInfo;
        Convert: dotnet Convert;
        InstalledLanguages: dotnet StringCollection;
        DetectedLanguages: dotnet StringCollection;
        InfoForCompletionMessage: dotnet StringCollection;
        CurrentProfileID: Code[30];
        CurrentProfileDescription: Text[250];
        CurrentPageID: Integer;
        CurrentPersonalizationID: Code[40];
        ProfileResxFileNotFoundTxt: label '%1  for Profile %2.', Comment='Tells the user that translated UI strings for a profile could not be found in a specific language.';
        ProfileResxFileNotFoundMsg: label 'Could not find translated resources for the following language(s)\%1\This can happen if Profile ID is translated between languages.', Comment='Tells the user that translated UI strings for a given profile could not be found for one or more languages.';
        AttributesNodeNameTxt: label 'Attributes', Locked=true;
        NodeNodeNameTxt: label 'Node', Locked=true;
        NodesNodeNameTxt: label 'Nodes', Locked=true;
        CaptionMLAttributeNameTxt: label 'CaptionML', Locked=true;
        idLowerAttributeNameTxt: label 'id', Locked=true;
        NameAttributeNameLowerTxt: label 'name', Locked=true;
        ValueAttributeNameTxt: label 'value', Locked=true;
        RegexAppendCaptionMLTxt: label '%1=%2', Locked=true;
        ReplaceCaptionMLPatternTxt: label '%1=.+?(?=;[A-Z]{3}=|$)', Locked=true;
        RemoveCaptionMLPatternTxt: label '%1=.+?(?<=;)(?=[A-Z]{3}=)|;%1=.+?(?=;[A-Z]{3}=|$)', Locked=true;
        ExtractCaptionMLPatternTxt: label '[A-Z]{3}(?==)|(?<=[A-Z]{3}=).+?(?=;[A-Z]{3}=|$)', Locked=true;
        LanguagePatternTxt: label '%1=', Locked=true;
        SelectImportFolderMsg: label 'Select a folder to import translations from.';
        SelectExportFolderMsg: label 'Select a folder to export translations to.';
        SelectRemoveLanguageMsg: label 'Select the language to remove profile translations for.';
        SelectRemoveLanguageTxt: label '%1 - %2,', Locked=true;
        ProfileIDTxt: label 'Profile ID', Locked=true;
        ProfileIDCommentTxt: label 'Profile ID field from table 2000000074', Locked=true;
        ProfileDescriptionTxt: label 'Profile Description', Locked=true;
        ProfileDescriptionCommentTxt: label 'Description field from table 2000000074', Locked=true;
        ExportResxFormatTxt: label '%1;%2;%3', Locked=true;
        ExportResxCommentFormatTxt: label 'Page: %1 - PersonalizationId: %2 - ControlGuid: %3', Locked=true;
        ZipFileEntryTxt: label '%1\%2.resx', Locked=true;
        ZipFileFormatNameTxt: label '%1.zip', Locked=true;
        ZipFileNameTxt: label 'ProfileResources';
        Mode: Option "None",Import,Export,Remove;
        SelectTranslatedResxFileTxt: label 'Select a zip file with translated resources.';
        ImportCompleteMsg: label 'Import completed. Restart the client to apply changes.', Comment='User must restart the client to see the imported translations.';
        ExportCompleteMsg: label 'Export completed.';
        ExportNoEntriesFoundMsg: label 'No entries found to export.';
        RemoveCompleteMsg: label 'Remove completed.';
        CompletionMessageMsg: label '%1\%2', Locked=true;
        NoImportResourcesFoundMsg: label 'No resources found to import.', Comment='%1 = User selected folder. ';
        NoImportResourcesFoundForProfileMsg: label 'No resources found to import for Profile %1.', Comment='%1 = Profile ID';
        NoDefaultProfileErr: label 'No default profile set.';
        ZipArchiveFileNameTxt: label 'Profiles.zip';
        ZipArchiveFilterTxt: label 'Zip File (*.zip)|*.zip', Locked=true;
        ZipArchiveSaveDialogTxt: label 'Export Profiles';
        ZipArchiveProgressMsg: label 'Exporting profile: #1######', Comment='Exporting profile: ORDER PROCESSOR';
        O365SalesTxt: label 'O365 Sales';
        O365SalesDescriptionTxt: label 'O365 Sales Activities';
        TeamMemberTxt: label 'Team Member';
        TeamMemberDescriptionTxt: label 'Team Member';


    procedure InitializeProfiles()
    var
        "Profile": Record "Profile";
    begin
        Profile.LockTable;
        if not Profile.IsEmpty then
          exit;
        InsertProfile(AccountingManagerProfileTxt,AccountingManagerDescriptionTxt,9001);
        InsertProfile(APCoordinatorProfileTxt,APCoordinatorDescriptionTxt,9002);
        InsertProfile(ARAdministratorProfileTxt,ARAdministratorDescriptionTxt,9003);
        InsertProfile(BookkeeperProfileTxt,BookkeeperDescriptionTxt,9004);
        InsertProfile(SalesManagerProfileTxt,SalesManagerDescriptionTxt,9005);
        InsertProfile(OrderProcessorProfileTxt,SalesOrderProcessorDescriptionTxt,9006);
        InsertProfile(PurchasingAgentProfileTxt,PurchasingAgentDescriptionTxt,9007);
        InsertProfile(ShippingandReceivingWMSProfileTxt,ShippingandReceivingWMSDescriptionTxt,9000);
        InsertProfile(ShippingandReceivingProfileTxt,ShippingandReceivingDescriptionTxt,9008);
        InsertProfile(WarehouseWorkerWMSProfileTxt,WarehouseWorkerWMSDescriptionTxt,9009);
        InsertProfile(ProductionPlannerProfileTxt,ProductionPlannerDescriptionTxt,9010);
        InsertProfile(ShopSupervisorProfileTxt,ShopSupervisorDescriptionTxt,9012);
        InsertProfile(ShopSupervisorFoundationProfileTxt,ShopSupervisorFoundationDescriptionTxt,9011);
        InsertProfile(MachineOperatorProfileTxt,MachineOperatorDescriptionTxt,9013);
        InsertProfile(ResourceManagerProfileTxt,ResourceManagerDescriptionTxt,9014);
        InsertProfile(ProjectManagerProfileTxt,ProjectManagerDescriptionTxt,9015);
        InsertProfile(DispatcherProfileTxt,DispatcherDescriptionTxt,9016);
        InsertProfile(OutboundTechnicianProfileTxt,OutboundTechnicianDescriptionTxt,9017);
        InsertProfile(ITManagerProfileTxt,ITManagerDescriptionTxt,9018);
        InsertProfile(PresidentProfileTxt,PresidentDescriptionTxt,9019);
        InsertProfile(PresidentSBProfileTxt,PresidentSBDescriptionTxt,9020);
        InsertProfile(RapidStartServicesProfileTxt,RapidStartServicesDescriptionTxt,9021);
        InsertProfile(BusinessManagerIDTxt,BusinessManagerDescriptionTxt,9022);
        InsertProfile(AccountingServicesTxt,AccountingServicesDescriptionTxt,9023);
        InsertProfile(SecurityAdministratorTxt,SecurityAdministratorDescriptionTxt,9024);
        InsertProfile(AccountantTxt,AccountantDescriptionTxt,9027);
        InsertProfile(O365SalesTxt,O365SalesDescriptionTxt,9029);
        InsertProfile(TeamMemberTxt,TeamMemberDescriptionTxt,9028);
        InsertProfile(Text1480000,Text1480001,36600);
        InsertProfile(Text1480002,Text1480003,36601);
        InsertProfile(Text1480004,Text1480005,36603);
        Commit;
    end;


    procedure InsertProfile(ProfileID: Code[30];Description: Text[250];RoleCenterID: Integer)
    var
        "Profile": Record "Profile";
        "Object": Record "Object";
    begin
        Object.SetRange(Type,Object.Type::Page);
        Object.SetRange(ID,RoleCenterID);
        if Object.IsEmpty then
          exit;

        Profile.Init;
        Profile."Profile ID" := ProfileID;
        Profile.Description := Description;
        Profile."Role Center ID" := RoleCenterID;
        Profile."Default Role Center" := (RoleCenterID = DefaultRoleCenterID);
        Profile.Insert;
    end;


    procedure DefaultRoleCenterID(): Integer
    begin
        exit(9022); // BUSINESS MANAGER
    end;


    procedure GetProfileHavingDefaultRoleCenter(): Code[30]
    var
        "Profile": Record "Profile";
    begin
        Profile.SetRange("Role Center ID",DefaultRoleCenterID);
        if Profile.FindFirst then;
        exit(Profile."Profile ID");
    end;


    procedure GetCurrentProfileID(): Code[30]
    var
        CurrentProfileID: Code[30];
    begin
        CurrentProfileID := GetCurrentProfileIDNoError;
        if CurrentProfileID = '' then
          Error(NoDefaultProfileErr);

        exit(CurrentProfileID);
    end;


    procedure GetCurrentProfileIDNoError(): Code[30]
    var
        UserPersonalization: Record "User Personalization";
        "Profile": Record "Profile";
    begin
        if UserPersonalization.Get(UserSecurityId) then
          if UserPersonalization."Profile ID" <> '' then
            exit(UserPersonalization."Profile ID");

        Profile.SetRange("Default Role Center",true);
        if Profile.FindFirst then
          exit(Profile."Profile ID");

        exit('');
    end;


    procedure SetCurrentProfileID(ProfileID: Code[30])
    var
        UserPersonalization: Record "User Personalization";
    begin
        if UserPersonalization.Get(UserSecurityId) then begin
          UserPersonalization."Profile ID" := ProfileID;
          UserPersonalization.Modify(true);
        end;
    end;


    procedure CopyProfile("Profile": Record "Profile";NewProfileID: Code[30])
    var
        NewProfile: Record "Profile";
        ProfileMetadata: Record "Profile Metadata";
        NewProfileMetadata: Record "Profile Metadata";
    begin
        NewProfile.Init;
        NewProfile.Validate("Profile ID",NewProfileID);
        NewProfile.TestField("Profile ID");
        NewProfile.Validate(Description,Profile.Description);
        NewProfile.Validate("Role Center ID",Profile."Role Center ID");
        NewProfile.Insert;

        ProfileMetadata.SetRange("Profile ID",Profile."Profile ID");
        if ProfileMetadata.FindSet then
          repeat
            ProfileMetadata.CalcFields("Page Metadata Delta");

            NewProfileMetadata.Init;
            NewProfileMetadata.Copy(ProfileMetadata);
            NewProfileMetadata."Profile ID" := NewProfileID;
            NewProfileMetadata.Insert;
          until ProfileMetadata.Next = 0;
    end;


    procedure ClearProfileConfiguration("Profile": Record "Profile")
    var
        ProfileMetadata: Record "Profile Metadata";
    begin
        if not Confirm(DeleteConfigurationChangesQst) then
          exit;

        ProfileMetadata.SetRange("Profile ID",Profile."Profile ID");
        ProfileMetadata.DeleteAll(true);
    end;


    procedure ClearUserPersonalization(User: Record "User Personalization")
    var
        UserMetadata: Record "User Metadata";
    begin
        if not Confirm(DeletePersonalizationChangesQst) then
          exit;

        UserMetadata.SetRange("User SID",User."User SID");
        UserMetadata.DeleteAll(true);
    end;


    procedure ExportProfilesInZipFile(var "Profile": Record "Profile")
    var
        ProfileToExport: Record "Profile";
        FileMgt: Codeunit "File Management";
        Window: Dialog;
        FileName: Text;
        ZipArchive: Text;
    begin
        if Profile.FindSet then begin
          ZipArchive := FileMgt.CreateZipArchiveObject;
          Window.Open(ZipArchiveProgressMsg);

          repeat
            Window.Update(1,Profile."Profile ID");
            FileName := FileMgt.ServerTempFileName('xml');

            ProfileToExport.Get(Profile."Profile ID");
            ProfileToExport.SetRecfilter;
            ExportProfiles(FileName,ProfileToExport);

            FileMgt.AddFileToZipArchive(FileName,Profile."Profile ID" + '.xml');
            FileMgt.DeleteServerFile(FileName);
          until Profile.Next = 0;

          Window.Close;
          FileMgt.CloseZipArchive;

          FileMgt.DownloadHandler(ZipArchive,ZipArchiveSaveDialogTxt,'',ZipArchiveFilterTxt,ZipArchiveFileNameTxt);
          FileMgt.DeleteServerFile(ZipArchive);
        end;
    end;


    procedure ExportProfiles(FileName: Text;var "Profile": Record "Profile")
    var
        FileOutStream: OutStream;
        ProfileFile: File;
    begin
        ProfileFile.Create(FileName);
        ProfileFile.CreateOutstream(FileOutStream);
        Xmlport.Export(Xmlport::"Profile Import/Export",FileOutStream,Profile);
        ProfileFile.Close;
    end;


    procedure ImportProfiles(FileName: Text)
    var
        FileInStream: InStream;
        ProfileFile: File;
    begin
        ProfileFile.Open(FileName);
        ProfileFile.CreateInstream(FileInStream);
        Xmlport.Import(Xmlport::"Profile Import/Export",FileInStream);
        ProfileFile.Close;
    end;


    procedure ChangeDefaultRoleCenter(ProfileID: Code[30])
    var
        "Profile": Record "Profile";
    begin
        Profile.SetRange("Default Role Center",true);
        Profile.SetFilter("Profile ID",'<> %1',ProfileID);
        if Profile.FindFirst then begin
          Profile."Default Role Center" := false;
          Profile.Modify;
        end;
    end;


    procedure DeleteProfile("Profile": Record "Profile")
    var
        UserPersonalization: Record "User Personalization";
        UserGroup: Record "User Group";
    begin
        if Profile."Default Role Center" then
          Error(NoDeleteProfileErr);

        UserPersonalization.SetRange("Profile ID",Profile."Profile ID");
        if not UserPersonalization.IsEmpty then
          Error(CannotDeleteDefaultUserProfileErr);

        UserGroup.SetRange("Default Profile ID",Profile."Profile ID");
        if not UserGroup.IsEmpty then
          Error(CannotDeleteDefaultUserProfileErr);
    end;


    procedure ImportTranslatedResources(var "Profile": Record "Profile";ResourcesZipFileOrFolder: Text;ShowCompletionMessage: Boolean)
    var
        FileManagement: Codeunit "File Management";
        ServerFolder: Text;
    begin
        if Profile.FindSet then begin
          InitializeDotnetVariables;
          ServerFolder := CopyResourcesToServer(ResourcesZipFileOrFolder);
          repeat
            if ReadResourceFiles(Profile."Profile ID",ServerFolder) then begin
              Mode := Mode::Import;
              ProcessConfigurationMetadata(Profile);
            end;
          until Profile.Next = 0;

          FileManagement.ServerRemoveDirectory(ServerFolder,true);

          if ShowCompletionMessage then
            GetCompletionMessage(true);
        end;
    end;


    procedure ImportTranslatedResourcesWithFolderSelection(var "Profile": Record "Profile")
    var
        FileManagement: Codeunit "File Management";
        ResourceFolder: Text;
    begin
        if FileManagement.CanRunDotNetOnClient then
          ResourceFolder := SelectResourceImportFolder;
        if (ResourceFolder <> '') or FileManagement.IsWebClient then
          ImportTranslatedResources(Profile,ResourceFolder,true);
    end;


    procedure ExportTranslatedResources(var "Profile": Record "Profile";ResourceFolder: Text)
    var
        FileManagement: Codeunit "File Management";
        FolderExists: Boolean;
    begin
        if Profile.FindSet then begin
          InitializeDotnetVariables;
          if FileManagement.CanRunDotNetOnClient then
            FolderExists := FileManagement.ClientDirectoryExists(ResourceFolder);
          if FileManagement.IsWebClient or FolderExists then begin
            Mode := Mode::Export;
            repeat
              ClearResourcesForProfile(Profile."Profile ID");
              ProcessConfigurationMetadata(Profile);
              ExportResourceFiles(ResourceFolder,Profile."Profile ID")
            until Profile.Next = 0
          end;
        end;
    end;


    procedure ExportTranslatedResourcesWithFolderSelection(var "Profile": Record "Profile")
    var
        FileManagement: Codeunit "File Management";
        ResourceFolder: Text;
    begin
        if FileManagement.CanRunDotNetOnClient then
          ResourceFolder := SelectResourceExportFolder;
        if (ResourceFolder <> '') or FileManagement.IsWebClient then begin
          ExportTranslatedResources(Profile,ResourceFolder);
          GetCompletionMessage(true);
        end;
    end;


    procedure RemoveTranslatedResources(var "Profile": Record "Profile";Language: Text[3])
    begin
        if Profile.FindSet then
          if Language <> '' then begin
            InitializeDotnetVariables;
            AppendDetectedLanguage(Language);
            Mode := Mode::Remove;

            repeat
              ProcessConfigurationMetadata(Profile);
            until Profile.Next = 0
          end;
    end;


    procedure RemoveTranslatedResourcesWithLanguageSelection(var "Profile": Record "Profile")
    var
        LanguageToRemove: Text[3];
    begin
        LanguageToRemove := SelectLanguageToRemove;
        if LanguageToRemove <> '' then begin
          RemoveTranslatedResources(Profile,LanguageToRemove);
          GetCompletionMessage(true);
        end;
    end;

    local procedure ProcessConfigurationMetadata(var "Profile": Record "Profile")
    var
        ProfileMetadata: Record "Profile Metadata";
        ProfileConfigurationDOM: dotnet XmlDocument;
    begin
        ProfileMetadata.SetRange("Profile ID",Profile."Profile ID");
        if ProfileMetadata.FindSet(true) then begin
          repeat
            LoadProfileMetadata(ProfileMetadata,ProfileConfigurationDOM);
            CurrentProfileID := ProfileMetadata."Profile ID";
            CurrentProfileDescription := Profile.Description;
            CurrentPageID := ProfileMetadata."Page ID";
            CurrentPersonalizationID := ProfileMetadata."Personalization ID";
            ParseConfiguration(ProfileConfigurationDOM);
            UpdateProfileConfigurationRecord(ProfileMetadata,ProfileConfigurationDOM);
          until ProfileMetadata.Next = 0
        end;
    end;


    procedure SelectResourceImportFolder() Folder: Text
    var
        FileManagement: Codeunit "File Management";
    begin
        if FileManagement.CanRunDotNetOnClient then
          FileManagement.SelectFolderDialog(SelectImportFolderMsg,Folder);
    end;


    procedure SelectResourceExportFolder() Folder: Text
    var
        FileManagement: Codeunit "File Management";
    begin
        if FileManagement.CanRunDotNetOnClient then
          FileManagement.SelectFolderDialog(SelectExportFolderMsg,Folder);
    end;


    procedure SelectLanguageToRemove(): Text[3]
    var
        WindowsLanguage: Record "Windows Language";
        Options: Text;
        Selected: Integer;
    begin
        FilterToInstalledLanguages(WindowsLanguage);
        if WindowsLanguage.FindSet then begin
          repeat
            Options += StrSubstNo(SelectRemoveLanguageTxt,WindowsLanguage."Abbreviated Name",WindowsLanguage.Name);
          until WindowsLanguage.Next = 0;

          Selected := StrMenu(Options,0,SelectRemoveLanguageMsg);
          if Selected > 0 then
            exit(CopyStr(SelectStr(Selected,Options),1,3));
        end;

        exit('');
    end;


    procedure FilterToInstalledLanguages(var WindowsLanguage: Record "Windows Language")
    begin
        // Filter is the same used by the Select Language dialog in the Windows client
        WindowsLanguage.SetRange("Globally Enabled",true);
        WindowsLanguage.SetRange("Localization Exist",true);
        WindowsLanguage.SetFilter("Language ID",'<> %1',1034);
        WindowsLanguage.FindSet;
    end;

    local procedure IsLanguageInstalled(LanguageName: Text): Boolean
    var
        WindowsLanguage: Record "Windows Language";
    begin
        if InstalledLanguages.Count = 0 then begin
          FilterToInstalledLanguages(WindowsLanguage);
          if WindowsLanguage.FindSet then begin
            repeat
              InstalledLanguages.Add(CultureInfo.GetCultureInfo(WindowsLanguage."Language ID").Name);
            until WindowsLanguage.Next = 0
          end;
        end;

        exit(InstalledLanguages.Contains(LanguageName));
    end;

    local procedure ReadResourceFiles(ProfileID: Code[30];ServerFolder: Text): Boolean
    var
        ProfileResourceImportExport: Record "Profile Resource Import/Export";
        WindowsLanguage: Record "Windows Language";
        FileManagement: Codeunit "File Management";
        ResxReader: dotnet ResXResourceReader;
        Enumerator: dotnet IDictionaryEnumerator;
        KeySplits: dotnet Array;
        Directory: dotnet Directory;
        DirectoryInfo: dotnet DirectoryInfo;
        Directories: dotnet Array;
        Dir: Text;
        DirName: Text;
        FileName: Text;
        Language: Text[3];
        BaseProfileID: Code[30];
        i: Integer;
        ResourceCount: Integer;
    begin
        ClearResourcesForProfile(ProfileID);

        if (ServerFolder = '') or (not FileManagement.ServerDirectoryExists(ServerFolder)) then
          exit(false);

        Directories := Directory.GetDirectories(ServerFolder);
        for i := 0 to Directories.Length - 1 do begin
          Dir := Directories.GetValue(i);
          DirName := DirectoryInfo.DirectoryInfo(Dir).Name;
          if IsLanguageInstalled(DirName) then begin
            Language := CultureInfo.GetCultureInfo(DirName).ThreeLetterWindowsLanguageName;
            AppendDetectedLanguage(Language);
            FilterToInstalledLanguages(WindowsLanguage);
            BaseProfileID := TranslateProfileID(ProfileID,WindowsLanguage,1033);
            FileName := FileManagement.CombinePath(Dir,BaseProfileID + '.Resx');
            if FileManagement.ServerFileExists(FileName) then begin
              ResxReader := ResxReader.ResXResourceReader(FileName);
              Enumerator := ResxReader.GetEnumerator;
              while Enumerator.MoveNext do begin
                KeySplits := RegEx.Split(Convert.ToString(Enumerator.Key),';');
                if KeySplits.Length = 3 then
                  ProfileResourceImportExport.InsertRec(
                    ProfileID,Convert.ToInt32(KeySplits.GetValue(0)),Convert.ToString(KeySplits.GetValue(1)),
                    Convert.ToString(KeySplits.GetValue(2)),Language,Convert.ToString(Enumerator.Value));
              end;
            end else
              InfoForCompletionMessage.Add(StrSubstNo(ProfileResxFileNotFoundTxt,Language,ProfileID));
          end;
        end;

        ResourceCount := CountResourcesForProfile(ProfileID);
        if ResourceCount = 0 then
          InfoForCompletionMessage.Add(StrSubstNo(NoImportResourcesFoundForProfileMsg,ProfileID));

        exit(ResourceCount > 0);
    end;

    local procedure SetTranslationParameters(var WindowsLanguage: Record "Windows Language";ProfileIDTxt: Text;TempLanguage: Integer;TranslateToLanguageID: Integer) TranslatedProfileID: Code[30]
    begin
        CheckSetLanguage(TranslateToLanguageID);
        TranslatedProfileID := CopyStr(ProfileIDTxt,1,MaxStrLen(TranslatedProfileID));
        WindowsLanguage.Get(TempLanguage); // Other profiles will match same language
    end;


    procedure TranslateProfileID(ProfileID: Code[30];var WindowsLanguage: Record "Windows Language";TranslateToLanguageID: Integer) TranslatedProfileID: Code[30]
    var
        CurrentLanguage: Integer;
        TempLanguage: Integer;
        ProfileIDTxt: Text;
    begin
        CurrentLanguage := GlobalLanguage;

        repeat
          TempLanguage := WindowsLanguage."Language ID";
          if GlobalLanguage <> TempLanguage then
            GlobalLanguage := TempLanguage;
          case ProfileID of
            UpperCase(AccountingManagerProfileTxt):
              ProfileIDTxt := AccountingManagerProfileTxt;
            UpperCase(APCoordinatorProfileTxt):
              ProfileIDTxt := APCoordinatorProfileTxt;
            UpperCase(ARAdministratorProfileTxt):
              ProfileIDTxt := ARAdministratorProfileTxt;
            UpperCase(BookkeeperProfileTxt):
              ProfileIDTxt := BookkeeperProfileTxt;
            UpperCase(SalesManagerProfileTxt):
              ProfileIDTxt := SalesManagerProfileTxt;
            UpperCase(OrderProcessorProfileTxt):
              ProfileIDTxt := OrderProcessorProfileTxt;
            UpperCase(PurchasingAgentProfileTxt):
              ProfileIDTxt := PurchasingAgentProfileTxt;
            UpperCase(ShippingandReceivingWMSProfileTxt):
              ProfileIDTxt := ShippingandReceivingWMSProfileTxt;
            UpperCase(ShippingandReceivingProfileTxt):
              ProfileIDTxt := ShippingandReceivingProfileTxt;
            UpperCase(WarehouseWorkerWMSProfileTxt):
              ProfileIDTxt := WarehouseWorkerWMSProfileTxt;
            UpperCase(ProductionPlannerProfileTxt):
              ProfileIDTxt := ProductionPlannerProfileTxt;
            UpperCase(ShopSupervisorProfileTxt):
              ProfileIDTxt := ShopSupervisorProfileTxt;
            UpperCase(ShopSupervisorFoundationProfileTxt):
              ProfileIDTxt := ShopSupervisorFoundationProfileTxt;
            UpperCase(MachineOperatorProfileTxt):
              ProfileIDTxt := MachineOperatorProfileTxt;
            UpperCase(ResourceManagerProfileTxt):
              ProfileIDTxt := ResourceManagerProfileTxt;
            UpperCase(ProjectManagerProfileTxt):
              ProfileIDTxt := ProjectManagerProfileTxt;
            UpperCase(DispatcherProfileTxt):
              ProfileIDTxt := DispatcherProfileTxt;
            UpperCase(OutboundTechnicianProfileTxt):
              ProfileIDTxt := OutboundTechnicianProfileTxt;
            UpperCase(ITManagerProfileTxt):
              ProfileIDTxt := ITManagerProfileTxt;
            UpperCase(PresidentProfileTxt):
              ProfileIDTxt := PresidentProfileTxt;
            UpperCase(PresidentSBProfileTxt):
              ProfileIDTxt := PresidentSBProfileTxt;
            UpperCase(RapidStartServicesProfileTxt):
              ProfileIDTxt := RapidStartServicesProfileTxt;
            UpperCase(BusinessManagerIDTxt):
              ProfileIDTxt := BusinessManagerIDTxt;
            UpperCase(AccountingServicesTxt):
              ProfileIDTxt := AccountingServicesTxt;
            UpperCase(SecurityAdministratorTxt):
              ProfileIDTxt := SecurityAdministratorTxt;
            UpperCase(TeamMemberTxt):
              ProfileIDTxt := TeamMemberTxt;
            UpperCase(Text1480000):
              ProfileIDTxt := Text1480000;
            UpperCase(Text1480002):
              ProfileIDTxt := Text1480002;
            UpperCase(Text1480004):
              ProfileIDTxt := Text1480004;
          end;
          TranslatedProfileID := SetTranslationParameters(
              WindowsLanguage,ProfileIDTxt,TempLanguage,TranslateToLanguageID);
        until (WindowsLanguage.Next = 0) or (TranslatedProfileID <> '');

        if GlobalLanguage <> CurrentLanguage then
          GlobalLanguage := CurrentLanguage;
        if TranslatedProfileID = '' then
          TranslatedProfileID := ProfileID;
    end;

    local procedure CheckSetLanguage(LanguageID: Integer)
    begin
        if GlobalLanguage <> LanguageID then
          GlobalLanguage := LanguageID;
    end;

    local procedure CopyResourcesToServer(ResourcesZipFileOrFolder: Text) ServerFolder: Text
    var
        FileManagement: Codeunit "File Management";
        ServerFile: Text;
    begin
        if FileManagement.IsWebClient then
          ServerFile := FileManagement.UploadFile(SelectTranslatedResxFileTxt,'*.zip');

        if FileManagement.CanRunDotNetOnClient then begin
          if FileManagement.ClientDirectoryExists(ResourcesZipFileOrFolder) then begin
            ServerFolder := FileManagement.UploadClientDirectorySilent(ResourcesZipFileOrFolder,'*.resx',true);
            if ServerFolder = '' then
              InfoForCompletionMessage.Add(NoImportResourcesFoundMsg);
            exit;
          end;
          if ResourcesZipFileOrFolder = '' then
            ServerFile := FileManagement.UploadFile(SelectTranslatedResxFileTxt,'*.zip');
          if FileManagement.GetExtension(ResourcesZipFileOrFolder) = 'zip' then
            ServerFile := FileManagement.UploadFileSilent(ResourcesZipFileOrFolder);
        end;

        if ServerFile <> '' then begin
          ServerFolder := FileManagement.ServerCreateTempSubDirectory;
          FileManagement.ExtractZipFile(ServerFile,ServerFolder);
          FileManagement.DeleteServerFile(ServerFile);
        end;
    end;

    local procedure ExportResourceFiles(ResourceFolder: Text;ProfileID: Code[30])
    var
        ProfileResourceImportExport: Record "Profile Resource Import/Export";
        WindowsLanguage: Record "Windows Language";
        FileManagement: Codeunit "File Management";
        CurrentDir: Text;
        ZipArchiveName: Text;
        ZipFileEntry: Text;
        ServerFileName: Text;
        i: Integer;
        CurrentLanguage: Text;
        CultureName: Text;
        CanRunDotNetOnClient: Boolean;
    begin
        CanRunDotNetOnClient := FileManagement.CanRunDotNetOnClient;

        if not CanRunDotNetOnClient then
          ZipArchiveName := FileManagement.CreateZipArchiveObject;

        for i := 0 to DetectedLanguages.Count - 1 do begin
          CurrentLanguage := DetectedLanguages.Item(i);
          ProfileResourceImportExport.SetRange("Profile ID",ProfileID);
          ProfileResourceImportExport.SetRange("Abbreviated Language Name",CurrentLanguage);

          if ProfileResourceImportExport.FindFirst then begin
            WindowsLanguage.SetRange("Abbreviated Name",CurrentLanguage);
            WindowsLanguage.FindFirst;
            CultureName := CultureInfo.GetCultureInfo(WindowsLanguage."Language ID").Name;
            CurrentDir := FileManagement.CombinePath(ResourceFolder,CultureName);

            ServerFileName := FileManagement.ServerTempFileName('.Resx');
            AppendToResxFile(ProfileResourceImportExport,ProfileID,ServerFileName);

            if not CanRunDotNetOnClient then begin
              ZipFileEntry := StrSubstNo(ZipFileEntryTxt,CultureName,ProfileID);
              FileManagement.AddFileToZipArchive(ServerFileName,ZipFileEntry);
            end else begin
              FileManagement.CreateClientDirectory(CurrentDir);
              FileManagement.DownloadToFile(ServerFileName,FileManagement.CombinePath(CurrentDir,ProfileID + '.Resx'));
            end;
            FileManagement.DeleteServerFile(ServerFileName);
          end else
            InfoForCompletionMessage.Add(ExportNoEntriesFoundMsg);
        end;

        if not CanRunDotNetOnClient then begin
          FileManagement.CloseZipArchive;
          FileManagement.DownloadHandler(ZipArchiveName,'','','',StrSubstNo(ZipFileFormatNameTxt,ZipFileNameTxt));
        end;
    end;

    local procedure AppendToResxFile(var ProfileResourceImportExport: Record "Profile Resource Import/Export";ProfileID: Code[30];ServerFileName: Text)
    var
        ResxWriter: dotnet ResXResourceWriter;
        ResxDataNode: dotnet ResXDataNode;
        "Key": Text;
        Comment: Text;
    begin
        ResxWriter := ResxWriter.ResXResourceWriter(ServerFileName);
        ResxDataNode := ResxDataNode.ResXDataNode(ProfileIDTxt,ProfileID);
        ResxDataNode.Comment := ProfileIDCommentTxt;
        ResxWriter.AddResource(ResxDataNode);
        ResxDataNode := ResxDataNode.ResXDataNode(ProfileDescriptionTxt,CurrentProfileDescription);
        ResxDataNode.Comment := ProfileDescriptionCommentTxt;
        ResxWriter.AddResource(ResxDataNode);

        repeat
          Key := StrSubstNo(ExportResxFormatTxt,
              ProfileResourceImportExport."Page ID",
              ProfileResourceImportExport."Personalization ID",
              ProfileResourceImportExport."Control GUID");

          Comment := StrSubstNo(ExportResxCommentFormatTxt,
              ProfileResourceImportExport."Page ID",
              ProfileResourceImportExport."Personalization ID",
              ProfileResourceImportExport."Control GUID");

          ResxDataNode := ResxDataNode.ResXDataNode(Key,ProfileResourceImportExport.Value);
          ResxDataNode.Comment := Comment;
          ResxWriter.AddResource(ResxDataNode);
        until ProfileResourceImportExport.Next = 0;

        ResxWriter.Close;
    end;

    local procedure LoadProfileMetadata(ProfileMetadata: Record "Profile Metadata";var ObjectDOM: dotnet XmlDocument)
    var
        InStr: InStream;
    begin
        ProfileMetadata.CalcFields("Page Metadata Delta");
        ProfileMetadata."Page Metadata Delta".CreateInstream(InStr);
        XMLDOMManagement.LoadXMLDocumentFromInStream(InStr,ObjectDOM);
    end;

    local procedure ParseConfiguration(var ProfileConfigurationDOM: dotnet XmlDocument)
    var
        ChangeNodeList: dotnet XmlNodeList;
        ChangeNode: dotnet XmlNode;
        DeltaNode: dotnet XmlNode;
        ChangeType: Text;
        i: Integer;
    begin
        DeltaNode := ProfileConfigurationDOM.DocumentElement;
        ChangeNodeList := DeltaNode.FirstChild.ChildNodes;

        for i := 0 to ChangeNodeList.Count - 1 do begin
          ChangeNode := ChangeNodeList.ItemOf(i);
          ChangeType := ChangeNode.Name;
          case Lowercase(ChangeType) of
            'add':
              ParseAdd(ProfileConfigurationDOM,ChangeNode);
            'update':
              ParseUpdate(ChangeNode);
          end;
        end;
    end;

    local procedure UpdateProfileConfigurationRecord(var ProfileMetadata: Record "Profile Metadata";ProfileConfigurationDOM: dotnet XmlDocument)
    var
        OutStr: OutStream;
    begin
        if not (Mode in [Mode::Import,Mode::Remove]) then
          exit;
        ProfileMetadata."Page Metadata Delta".CreateOutstream(OutStr);
        ProfileConfigurationDOM.Save(OutStr);
        ProfileMetadata.Modify;
    end;

    local procedure ParseAdd(XmlDocument: dotnet XmlDocument;var XmlNode: dotnet XmlNode)
    var
        NodeNode: dotnet XmlNode;
    begin
        XMLDOMManagement.FindNode(XmlNode,NodeNodeNameTxt,NodeNode);
        ParseAddNode(XmlDocument,NodeNode);
    end;

    local procedure ParseAddNode(XmlDocument: dotnet XmlDocument;var XmlNode: dotnet XmlNode)
    var
        NodeNode: dotnet XmlNode;
        NodesNode: dotnet XmlNode;
        ControlGuid: Text;
        i: Integer;
    begin
        ControlGuid := XMLDOMManagement.GetAttributeValue(XmlNode,idLowerAttributeNameTxt);
        ProcessAddNodes(XmlNode,CopyStr(ControlGuid,1,40));

        NodesNode := XmlNode.SelectSingleNode(NodesNodeNameTxt);
        for i := 0 to NodesNode.ChildNodes.Count - 1 do begin
          NodeNode := NodesNode.ChildNodes.ItemOf(i);
          ParseAddNode(XmlDocument,NodeNode);
        end;
    end;

    local procedure ParseUpdate(var XmlNode: dotnet XmlNode)
    var
        CaptionMLAttribute: dotnet XmlAttribute;
        ControlGuid: Text;
        CaptionMLValue: Text;
    begin
        if XMLDOMManagement.GetAttributeValue(XmlNode,NameAttributeNameLowerTxt) <> CaptionMLAttributeNameTxt then
          exit;

        if not XMLDOMManagement.FindAttribute(XmlNode,CaptionMLAttribute,ValueAttributeNameTxt) then
          exit;

        ControlGuid := XMLDOMManagement.GetAttributeValue(XmlNode,idLowerAttributeNameTxt);

        CaptionMLValue := CaptionMLAttribute.Value;
        case Mode of
          Mode::Export:
            begin
              ExtractCaptions(CopyStr(ControlGuid,1,40),CaptionMLValue);
              exit;
            end;
          Mode::Import:
            CaptionMLValue := AppendCaptions(CopyStr(ControlGuid,1,40),CaptionMLValue);
          Mode::Remove:
            CaptionMLValue := RemoveCaptions(CaptionMLValue);
        end;

        CaptionMLAttribute.Value(CaptionMLValue);
    end;

    local procedure ProcessAddNodes(NodeNode: dotnet XmlNode;ControlGuid: Code[40])
    var
        AttributesNode: dotnet XmlNode;
        AttributeNode: dotnet XmlNode;
        CaptionMLAttribute: dotnet XmlAttribute;
        Attribute: Text;
        CaptionMLValue: Text;
        i: Integer;
    begin
        if XMLDOMManagement.FindNode(NodeNode,AttributesNodeNameTxt,AttributesNode) then
          for i := 0 to AttributesNode.ChildNodes.Count - 1 do begin
            AttributeNode := AttributesNode.ChildNodes.ItemOf(i);
            Attribute := XMLDOMManagement.GetAttributeValue(AttributeNode,NameAttributeNameLowerTxt);
            if Attribute = CaptionMLAttributeNameTxt then begin
              if not XMLDOMManagement.FindAttribute(AttributeNode,CaptionMLAttribute,ValueAttributeNameTxt) then
                exit;
              CaptionMLValue := CaptionMLAttribute.Value;
              if CaptionMLValue <> '' then begin
                case Mode of
                  Mode::Export:
                    begin
                      ExtractCaptions(ControlGuid,CaptionMLValue);
                      exit;
                    end;
                  Mode::Import:
                    CaptionMLValue := AppendCaptions(ControlGuid,CaptionMLValue);
                  Mode::Remove:
                    CaptionMLValue := RemoveCaptions(CaptionMLValue);
                end;
                CaptionMLAttribute.Value(CaptionMLValue);
                exit;
              end;
            end;
          end;
    end;

    local procedure AppendCaptions(ControlGuid: Code[40];OriginalCaptionML: Text): Text
    var
        ProfileResourceImportExport: Record "Profile Resource Import/Export";
        Pattern: Text;
        Translation: Text;
        Language: Text;
        Position: Integer;
        i: Integer;
    begin
        for i := 0 to DetectedLanguages.Count - 1 do begin
          Language := DetectedLanguages.Item(i);
          if FindProfileLanguageResourcesImp(ProfileResourceImportExport,ControlGuid,Language) then begin
            Translation := ProfileResourceImportExport.Value;
            Position := StrPos(OriginalCaptionML,StrSubstNo(LanguagePatternTxt,Language));

            if Position > 0 then begin
              Pattern := StrSubstNo(ReplaceCaptionMLPatternTxt,Language);
              OriginalCaptionML := RegEx.Replace(OriginalCaptionML,Pattern,StrSubstNo(RegexAppendCaptionMLTxt,Language,Translation));
            end else
              OriginalCaptionML += StrSubstNo(';%1=%2',Language,Translation);
          end;
        end;

        exit(OriginalCaptionML);
    end;

    local procedure RemoveCaptions(OriginalCaptionML: Text): Text
    var
        Pattern: Text;
        Language: Text;
        Position: Integer;
    begin
        Language := DetectedLanguages.Item(0);

        Position := StrPos(OriginalCaptionML,StrSubstNo(LanguagePatternTxt,Language));
        if Position > 0 then begin
          Pattern := StrSubstNo(RemoveCaptionMLPatternTxt,Language);
          OriginalCaptionML := RegEx.Replace(OriginalCaptionML,Pattern,'');
        end;

        exit(OriginalCaptionML);
    end;

    local procedure ExtractCaptions(ControlGuid: Code[40];OriginalCaptionML: Text)
    var
        ProfileResourceImportExport: Record "Profile Resource Import/Export";
        Matches: dotnet MatchCollection;
        AbbreviatedLanguageName: Text[3];
        Caption: Text[250];
        i: Integer;
    begin
        Matches := RegEx.Matches(OriginalCaptionML,ExtractCaptionMLPatternTxt);

        for i := 0 to Matches.Count - 1 do begin
          AbbreviatedLanguageName := Matches.Item(i).Value;
          AppendDetectedLanguage(AbbreviatedLanguageName);
          i += 1;
          Caption := Matches.Item(i).Value;

          ProfileResourceImportExport.InsertRec(
            CurrentProfileID,CurrentPageID,CurrentPersonalizationID,ControlGuid,AbbreviatedLanguageName,Caption);
        end;
    end;

    local procedure FindProfileLanguageResourcesImp(var ProfileResourceImportExport: Record "Profile Resource Import/Export";ControlGuid: Code[40];language: Text): Boolean
    begin
        ProfileResourceImportExport.SetRange("Abbreviated Language Name",language);
        ProfileResourceImportExport.SetRange("Profile ID",CurrentProfileID);
        ProfileResourceImportExport.SetRange("Page ID",CurrentPageID);
        ProfileResourceImportExport.SetRange("Personalization ID",CurrentPersonalizationID);
        ProfileResourceImportExport.SetRange("Control GUID",ControlGuid);
        exit(ProfileResourceImportExport.FindFirst);
    end;

    local procedure ClearResourcesForProfile(ProfileID: Code[30])
    var
        ProfileResourceImportExport: Record "Profile Resource Import/Export";
    begin
        ProfileResourceImportExport.SetRange("Profile ID",ProfileID);
        ProfileResourceImportExport.DeleteAll;
    end;

    local procedure CountResourcesForProfile(ProfileID: Code[30]): Integer
    var
        ProfileResourceImportExport: Record "Profile Resource Import/Export";
    begin
        ProfileResourceImportExport.SetRange("Profile ID",ProfileID);
        exit(ProfileResourceImportExport.Count);
    end;

    local procedure InitializeDotnetVariables()
    begin
        DetectedLanguages := DetectedLanguages.StringCollection;
        InfoForCompletionMessage := InfoForCompletionMessage.StringCollection;
        InstalledLanguages := InstalledLanguages.StringCollection;
    end;

    local procedure AppendDetectedLanguage(AbbreviatedLanguageName: Text[3])
    begin
        if not DetectedLanguages.Contains(AbbreviatedLanguageName) then
          DetectedLanguages.Add(AbbreviatedLanguageName);
    end;


    procedure GetCompletionMessage(ShowAsMessage: Boolean) CompleteMessage: Text
    var
        AdditionalInfo: Text;
    begin
        AdditionalInfo := GetAdditionalInfo;

        case Mode of
          Mode::Export:
            begin
              if AdditionalInfo <> '' then
                CompleteMessage := AdditionalInfo
              else
                CompleteMessage := ExportCompleteMsg;
            end;
          Mode::Import:
            begin
              if AdditionalInfo <> '' then begin
                AdditionalInfo := StrSubstNo(ProfileResxFileNotFoundMsg,AdditionalInfo);
                CompleteMessage := StrSubstNo(CompletionMessageMsg,ImportCompleteMsg,AdditionalInfo);
              end else
                CompleteMessage := ImportCompleteMsg;
            end;
          Mode::Remove:
            begin
              if AdditionalInfo <> '' then
                CompleteMessage := AdditionalInfo
              else
                CompleteMessage := RemoveCompleteMsg;
            end;
          else
            CompleteMessage := AdditionalInfo;
        end;

        if ShowAsMessage and (CompleteMessage <> '') then
          Message(CompleteMessage);
    end;

    local procedure GetAdditionalInfo() ErrorMessage: Text
    var
        i: Integer;
    begin
        if InfoForCompletionMessage.Count > 0 then begin
          for i := 0 to InfoForCompletionMessage.Count - 1 do
            ErrorMessage += InfoForCompletionMessage.Item(i) + '\';
          ErrorMessage := DelChr(ErrorMessage,'>','\');
        end;
    end;


    procedure ValidateTimeZone(var TimeZoneText: Text)
    var
        TimeZone: Record "Time Zone";
    begin
        TimeZone.Get(FindTimeZoneNo(TimeZoneText));
        TimeZoneText := TimeZone.ID;
    end;


    procedure LookupTimeZone(var TimeZoneText: Text): Boolean
    var
        TimeZone: Record "Time Zone";
    begin
        TimeZone."No." := FindTimeZoneNo(TimeZoneText);
        if Page.RunModal(Page::"Time Zones",TimeZone) = Action::LookupOK then begin
          TimeZoneText := TimeZone.ID;
          exit(true);
        end;
    end;

    local procedure FindTimeZoneNo(TimeZoneText: Text): Integer
    var
        TimeZone: Record "Time Zone";
    begin
        TimeZone.SetRange(ID,TimeZoneText);
        if not TimeZone.FindFirst then begin
          TimeZone.SetFilter(ID,'''@*' + TimeZoneText + '*''');
          TimeZone.Find('=<>');
        end;
        exit(TimeZone."No.");
    end;
}

