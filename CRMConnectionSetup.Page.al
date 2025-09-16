#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5330 "CRM Connection Setup"
{
    ApplicationArea = Basic;
    Caption = 'Microsoft Dynamics CRM Connection Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PromotedActionCategories = 'New,Connection,Mapping,Synchronization,Encryption';
    ShowFilter = false;
    SourceTable = "CRM Connection Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(NAVToCRM)
            {
                Caption = 'Connection from Dynamics NAV to Dynamics CRM';
                field("Server Address";"Server Address")
                {
                    ApplicationArea = Suite;
                    Editable = IsEditable;
                    ToolTip = 'Specifies the URL of the Dynamics CRM server that hosts the Dynamics CRM solution that you want to connect to.';
                }
                field("User Name";"User Name")
                {
                    ApplicationArea = Suite;
                    Editable = IsEditable;
                    ToolTip = 'Specifies the user name of a Dynamics CRM account.';
                }
                field(Password;CRMPassword)
                {
                    ApplicationArea = Suite;
                    Enabled = IsEditable;
                    ExtendedDatatype = Masked;
                    ToolTip = 'Specifies the password of a Dynamics CRM user account.';

                    trigger OnValidate()
                    begin
                        if (CRMPassword <> '') and (not EncryptionEnabled) then
                          if Confirm(EncryptionIsNotActivatedQst) then
                            Page.Run(Page::"Data Encryption Management");
                        SetPassword(CRMPassword);
                    end;
                }
                field("Is Enabled";"Is Enabled")
                {
                    ApplicationArea = Suite;
                    Caption = 'Enabled', Comment='Name of tickbox which shows whether the connection is enabled or disabled';
                    ToolTip = 'Specifies if the connection to Dynamics CRM is enabled.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field(ScheduledSynchJobsActive;ScheduledSynchJobsRunning)
                {
                    ApplicationArea = Suite;
                    Caption = 'Active scheduled synchronization jobs';
                    Editable = false;
                    StyleExpr = ScheduledSynchJobsRunningStyleExpr;
                    ToolTip = 'Specifies how many of the default integration synchronization job queue entries ready to automatically synchronize data between Dynamics NAV and Dynamics CRM.';

                    trigger OnDrillDown()
                    var
                        ScheduledSynchJobsRunningMsg: Text;
                    begin
                        if TotalJobs = 0 then
                          ScheduledSynchJobsRunningMsg := JobQueueIsNotRunningMsg
                        else
                          if ActiveJobs = TotalJobs then
                            ScheduledSynchJobsRunningMsg := AllScheduledJobsAreRunningMsg
                          else
                            ScheduledSynchJobsRunningMsg := StrSubstNo(PartialScheduledJobsAreRunningMsg,ActiveJobs,TotalJobs);
                        Message(ScheduledSynchJobsRunningMsg);
                    end;
                }
                label(Control33)
                {
                    ApplicationArea = Suite;
                }
            }
            group(CRMToNAV)
            {
                Caption = 'Connection from Dynamics CRM to Dynamics NAV';
                Visible = "Is Enabled";
                field(NAVURL;"Dynamics NAV URL")
                {
                    ApplicationArea = Suite;
                    Caption = 'Dynamics NAV Web Client URL';
                    Enabled = "Is CRM Solution Installed";
                    ToolTip = 'Specifies the URL of Dynamics NAV Web client. From records in Dynamics CRM, such as an account or product, users can open a corresponding (coupled) record in Dynamics NAV, which opens in the Dynamics NAV Web client. Set this field to the URL of the Dynamics NAV Web client instance to use.';
                }
                label(Control28)
                {
                    ApplicationArea = Suite;
                }
                label(Control34)
                {
                    ApplicationArea = Suite;
                }
                field(NAVODataURL;"Dynamics NAV OData URL")
                {
                    ApplicationArea = Suite;
                    Caption = 'Dynamics NAV OData Webservice URL';
                    Enabled = "Is CRM Solution Installed";
                    ToolTip = 'Specifies the URL of Dynamics NAV OData web services. From sales order records in Dynamics CRM, users can retrieve item availability information for Dynamics NAV items coupled to sales order detail records in Dynamics CRM. Set this field to the URL of the Dynamics NAV OData web services to use.';
                }
                field(NAVODataUsername;"Dynamics NAV OData Username")
                {
                    ApplicationArea = Suite;
                    Caption = 'Dynamics NAV OData Webservice Username';
                    Enabled = "Is CRM Solution Installed";
                    Lookup = true;
                    LookupPageID = Users;
                    ToolTip = 'Specifies the user name to access Dynamics NAV OData web services.';
                }
                field(NAVODataAccesskey;"Dynamics NAV OData Accesskey")
                {
                    ApplicationArea = Suite;
                    Caption = 'Dynamics NAV OData Webservice Accesskey';
                    Editable = false;
                    Enabled = "Is CRM Solution Installed";
                    ToolTip = 'Specifies the access key to access Dynamics NAV OData web services.';
                }
            }
            group(CRMSettings)
            {
                Caption = 'Dynamics CRM Settings';
                Visible = "Is Enabled";
                field("CRM Version";"CRM Version")
                {
                    ApplicationArea = Suite;
                    Caption = 'Version';
                    Editable = false;
                    StyleExpr = CRMVersionStyleExpr;
                    ToolTip = 'Specifies the version of Dynamics CRM.';

                    trigger OnDrillDown()
                    begin
                        if IsVersionValid then
                          Message(FavorableCRMVersionMsg)
                        else
                          Message(UnfavorableCRMVersionMsg,ProductName.Short);
                    end;
                }
                field("Is CRM Solution Installed";"Is CRM Solution Installed")
                {
                    ApplicationArea = Suite;
                    Caption = 'Dynamics NAV Integration Solution Imported';
                    Editable = false;
                    StyleExpr = CRMSolutionInstalledStyleExpr;
                    ToolTip = 'Specifies whether the Dynamics NAV Integration Solution is installed and configured in Dynamics CRM. You cannot change this setting.';

                    trigger OnDrillDown()
                    begin
                        if "Is CRM Solution Installed" then
                          Message(FavorableCRMSolutionInstalledMsg,ProductName.Short)
                        else
                          Message(UnfavorableCRMSolutionInstalledMsg,ProductName.Short);
                    end;
                }
                field("Is S.Order Integration Enabled";"Is S.Order Integration Enabled")
                {
                    ApplicationArea = Suite;
                    Caption = 'Sales Order Integration Enabled';
                    DrillDown = true;
                    Editable = false;
                    StyleExpr = SalesOrderIntegrationStyleExpr;
                    ToolTip = 'Specifies that it is possible for Dynamics CRM users to submit sales orders that can then be viewed and imported in Dynamics NAV.';

                    trigger OnDrillDown()
                    begin
                        if not "Is S.Order Integration Enabled" then
                          if Confirm(StrSubstNo(SetCRMSOPEnableQst,ProductName.Short)) then
                            SetCRMSOPEnabled;

                        RefreshDataFromCRM;
                        SalesOrderIntegrationStyleExpr := GetStyleExpr("Is S.Order Integration Enabled");

                        if "Is S.Order Integration Enabled" then
                          Message(SetCRMSOPEnableConfirmMsg);
                    end;
                }
            }
            group(AdvancedSettings)
            {
                Caption = 'Advanced Settings';
                Visible = "Is Enabled";
                field("Is User Mapping Required";"Is User Mapping Required")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that Dynamics NAV users must have a matching user account in Dynamics CRM to have Dynamics CRM integration capabilities in the user interface.';

                    trigger OnValidate()
                    begin
                        UpdateIsEnabledState
                    end;
                }
                field("Is User Mapped To CRM User";"Is User Mapped To CRM User")
                {
                    ApplicationArea = Suite;
                    Caption = 'Current Dynamics NAV User is Mapped to a Dynamics CRM User';
                    Editable = false;
                    StyleExpr = UserMappedToCRMUserStyleExpr;
                    ToolTip = 'Specifies that the user account that you used to sign in with has a matching user account in Dynamics CRM.';
                    Visible = "Is User Mapping Required";

                    trigger OnDrillDown()
                    begin
                        if "Is User Mapped To CRM User" then
                          Message(CurrentuserIsMappedToCRMUserMsg,UserId,ProductName.Short)
                        else
                          Message(CurrentuserIsNotMappedToCRMUserMsg,UserId,ProductName.Short)
                    end;
                }
                label(Control30)
                {
                    ApplicationArea = Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Assisted Setup")
            {
                ApplicationArea = Suite;
                Caption = 'Assisted Setup';
                Enabled = AssistedSetupAvailable;
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Runs Microsoft Dynamics CRM Connection Setup Wizard.';

                trigger OnAction()
                begin
                    if AssistedSetupAvailable then begin
                      AssistedSetup.Run;
                      CurrPage.Update(false);
                    end;
                end;
            }
            action("Test Connection")
            {
                ApplicationArea = Suite;
                Caption = 'Test Connection', Comment='Test is a verb.';
                Image = ValidateEmailLoggingSetup;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Tests the connection to Microsoft Dynamics CRM using the specified settings.';

                trigger OnAction()
                begin
                    PerformTestConnection;
                end;
            }
            action(ResetConfiguration)
            {
                ApplicationArea = Suite;
                Caption = 'Use Default Synchronization Setup';
                Enabled = "Is Enabled";
                Image = ResetStatus;
                ToolTip = 'Resets the integration table mappings and synchronization jobs to the default values for a connection with Microsoft Dynamics CRM. All current mappings are deleted.';

                trigger OnAction()
                var
                    CRMSetupDefaults: Codeunit "CRM Setup Defaults";
                begin
                    if Confirm(ResetIntegrationTableMappingConfirmQst,false) then begin
                      CRMSetupDefaults.ResetConfiguration(Rec);
                      Message(SetupSuccessfulMsg);
                    end;
                    RefreshDataFromCRM;
                end;
            }
            action(StartInitialSynchAction)
            {
                ApplicationArea = Suite;
                Caption = 'Run Full Synchronization';
                Enabled = "Is Enabled For User";
                Image = RefreshLines;
                ToolTip = 'Start all the default integration jobs for synchronizing Dynamics NAV record types and Dynamics CRM entities, as defined in the Integration Table Mappings page.';

                trigger OnAction()
                begin
                    if Confirm(StrSubstNo(StartInitialSynchQst,ProductName.Short)) then
                      PerformInitialSynch;
                end;
            }
            action("Reset Web Client URL")
            {
                ApplicationArea = Suite;
                Caption = 'Reset Web Client URL';
                Enabled = IsWebCliResetEnabled;
                Image = ResetStatus;
                ToolTip = 'Undo your change and enter the default URL in the Dynamics NAV Web Client URL field.';

                trigger OnAction()
                begin
                    PerformWebClientUrlReset;
                    Message(WebClientUrlResetMsg,ProductName.Short);
                end;
            }
            action(SynchronizeNow)
            {
                ApplicationArea = Suite;
                Caption = 'Synchronize Modified Records';
                Enabled = "Is Enabled For User";
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Synchronize records that have been modified since the last time they were synchronized.';

                trigger OnAction()
                var
                    IntegrationSynchJobList: Page "Integration Synch. Job List";
                begin
                    if not Confirm(SynchronizeModifiedQst) then
                      exit;

                    SynchronizeNow(false);
                    Message(SyncNowSuccessMsg,IntegrationSynchJobList.Caption);
                end;
            }
            action("Generate Integration IDs")
            {
                ApplicationArea = Suite;
                Caption = 'Generate Integration IDs';
                Image = Reconcile;
                ToolTip = 'Create integration IDs for new records that were added while the connection was disabled, for example, after you re-enable a Dynamics CRM connection.';

                trigger OnAction()
                var
                    IntegrationManagement: Codeunit "Integration Management";
                begin
                    if Confirm(ConfirmGenerateIntegrationIdsQst,true) then begin
                      IntegrationManagement.SetupIntegrationTables;
                      Message(GenerateIntegrationIdsSuccessMsg);
                    end;
                end;
            }
        }
        area(navigation)
        {
            action("Integration Table Mappings")
            {
                ApplicationArea = Suite;
                Caption = 'Integration Table Mappings';
                Image = Relationship;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Page "Integration Table Mapping List";
                RunPageMode = Edit;
                ToolTip = 'View entries that map integration tables to business data tables in Dynamics NAV. Integration tables are set up to act as interfaces for synchronizing data between an external database table, such as Dynamics CRM, and a corresponding business data table in Dynamics NAV.';
            }
            action("Synch. Job Queue Entries")
            {
                ApplicationArea = Suite;
                Caption = 'Synch. Job Queue Entries';
                Image = JobListSetup;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'View the job queue entries that manage the scheduled synchronization between Dynamics CRM and Dynamics NAV.';

                trigger OnAction()
                var
                    JobQueueEntry: Record "Job Queue Entry";
                begin
                    JobQueueEntry.FilterGroup := 2;
                    JobQueueEntry.SetRange("Object Type to Run",JobQueueEntry."object type to run"::Codeunit);
                    JobQueueEntry.SetFilter("Object ID to Run",'%1|%2',Codeunit::"Integration Synch. Job Runner",Codeunit::"CRM Statistics Job");
                    JobQueueEntry.FilterGroup := 0;

                    Page.Run(Page::"Job Queue Entries",JobQueueEntry);
                end;
            }
            action(EncryptionManagement)
            {
                ApplicationArea = Suite;
                Caption = 'Encryption Management';
                Image = EncryptionKeys;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Data Encryption Management";
                RunPageMode = View;
                ToolTip = 'Enable or disable data encryption. Data encryption helps make sure that unauthorized users cannot read business data.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if HasPassword then
          CRMPassword := '*';
        RefreshData;
    end;

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"Check App. Area Only Basic");
        AssistedSetupAvailable :=
          AssistedSetup.Get(Page::"CRM Connection Setup Wizard") and
          AssistedSetup.Visible;
    end;

    trigger OnOpenPage()
    begin
        if not Get then begin
          Init;
          Insert;
        end;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if not "Is Enabled" then
          if not Confirm(StrSubstNo(EnableServiceQst,CurrPage.Caption),true) then
            exit(false);
    end;

    var
        AssistedSetup: Record "Assisted Setup";
        CRMPassword: Text;
        ResetIntegrationTableMappingConfirmQst: label 'This will delete all existing integration table mappings and Dynamics CRM synchronization jobs and install the default integration table mappings and jobs for Dynamics CRM synchronization.\\Are you sure that you want to continue?';
        ConfirmGenerateIntegrationIdsQst: label 'You are about to add integration data to tables. This process may take several minutes. Do you want to continue?';
        GenerateIntegrationIdsSuccessMsg: label 'The integration data has been added to the tables.';
        EncryptionIsNotActivatedQst: label 'Data encryption is currently not enabled. We recommend that you encrypt data. \Do you want to open the Data Encryption Management window?';
        WebClientUrlResetMsg: label 'The %1 Web Client URL has been reset to the default value.', Comment='%1 - product name';
        SyncNowSuccessMsg: label 'Synchronize Modified Records completed.\See the %1 window for details.', Comment='%1 = Page 5338 Caption';
        SetCRMSOPEnableQst: label 'Enabling Sales Order Integration will allow you to create %1 Sales Orders from Dynamics CRM.\\To enable this setting, you must provide Dynamics CRM administrator credentials (user name and password).\\Do you want to continue?', Comment='%1 - product name';
        SetCRMSOPEnableConfirmMsg: label 'Dynamics CRM Sales Order Integration is enabled.';
        StartInitialSynchQst: label 'This will synchronize records in all Integration Table Mappings including uncoupled records.\\Before running full synchronization, you should couple all %1 Salespeople to Dynamics CRM Users.\\To prevent data duplication, it is also recommended to couple and synchronize other existing records in advance.\\Do you want to continue?', Comment='%1 - product name';
        UnfavorableCRMVersionMsg: label 'This version of Dynamics CRM might not work correctly with %1. We recommend you upgrade to a supported version.', Comment='%1 - product name';
        FavorableCRMVersionMsg: label 'The version of Dynamics CRM is valid.';
        UnfavorableCRMSolutionInstalledMsg: label 'The %1 Integration Solution was not detected.', Comment='%1 - product name';
        FavorableCRMSolutionInstalledMsg: label 'The %1 Integration Solution is installed in Dynamics CRM.', Comment='%1 - product name';
        SynchronizeModifiedQst: label 'This will synchronize all modified records in all Integration Table Mappings.\\Do you want to continue?';
        ReadyScheduledSynchJobsTok: label '%1 of %2', Comment='%1 = Count of scheduled job queue entries in ready or in process state, %2 count of all scheduled jobs';
        ScheduledSynchJobsRunning: Text;
        CurrentuserIsMappedToCRMUserMsg: label '%2 user (%1) is mapped to a Dynamics CRM user.', Comment='%1 = Current User ID, %2 - product name';
        CurrentuserIsNotMappedToCRMUserMsg: label 'Because the %2 Users Must Map to Dynamics CRM Users field is set, Dynamics CRM integration is not enabled for %1.\\To enable Dynamics CRM integration for %2 user %1, the authentication email must match the primary email of a Dynamics CRM user.', Comment='%1 = Current User ID, %2 - product name';
        EnableServiceQst: label 'The %1 is not enabled. Are you sure you want to exit?', Comment='%1 = This Page Caption (Microsoft Dynamics CRM Connection Setup)';
        PartialScheduledJobsAreRunningMsg: label 'An active job queue is available but only %1 of the %2 scheduled synchronization jobs are ready or in process.', Comment='%1 = Count of scheduled job queue entries in ready or in process state, %2 count of all scheduled jobs';
        JobQueueIsNotRunningMsg: label 'There is no job queue started. Scheduled synchronization jobs require an active job queue to process jobs.\\Contact your administrator to get a job queue configured and started.';
        AllScheduledJobsAreRunningMsg: label 'An job queue is started and all scheduled synchronization jobs are ready or already processing.';
        SetupSuccessfulMsg: label 'The default setup for Microsoft Dynamics CRM synchronization has completed successfully.';
        ScheduledSynchJobsRunningStyleExpr: Text;
        CRMSolutionInstalledStyleExpr: Text;
        CRMVersionStyleExpr: Text;
        SalesOrderIntegrationStyleExpr: Text;
        UserMappedToCRMUserStyleExpr: Text;
        ActiveJobs: Integer;
        TotalJobs: Integer;
        IsEditable: Boolean;
        IsWebCliResetEnabled: Boolean;
        AssistedSetupAvailable: Boolean;

    local procedure RefreshData()
    begin
        UpdateIsEnabledState;
        RefreshDataFromCRM;
        RefreshSynchJobsData;
        UpdateEnableFlags;
        SetStyleExpr;
    end;

    local procedure RefreshSynchJobsData()
    begin
        CountCRMJobQueueEntries(ActiveJobs,TotalJobs);
        ScheduledSynchJobsRunning := StrSubstNo(ReadyScheduledSynchJobsTok,ActiveJobs,TotalJobs);
        ScheduledSynchJobsRunningStyleExpr := GetRunningJobsStyleExpr;
    end;

    local procedure SetStyleExpr()
    begin
        CRMSolutionInstalledStyleExpr := GetStyleExpr("Is CRM Solution Installed");
        CRMVersionStyleExpr := GetStyleExpr(IsVersionValid);
        SalesOrderIntegrationStyleExpr := GetStyleExpr("Is S.Order Integration Enabled");
        UserMappedToCRMUserStyleExpr := GetStyleExpr("Is User Mapped To CRM User");
    end;

    local procedure GetRunningJobsStyleExpr() StyleExpr: Text
    begin
        if ActiveJobs < TotalJobs then
          StyleExpr := 'Ambiguous'
        else
          StyleExpr := GetStyleExpr((ActiveJobs = TotalJobs) and (TotalJobs <> 0))
    end;

    local procedure GetStyleExpr(Favorable: Boolean) StyleExpr: Text
    begin
        if Favorable then
          StyleExpr := 'Favorable'
        else
          StyleExpr := 'Unfavorable'
    end;

    local procedure UpdateEnableFlags()
    begin
        IsEditable := not "Is Enabled";
        IsWebCliResetEnabled := "Is CRM Solution Installed" and "Is Enabled For User";
    end;
}

