#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5330 "CRM Integration Management"
{
    SingleInstance = true;

    trigger OnRun()
    begin
        CheckOrEnableCRMConnection;
    end;

    var
        CRMEntityUrlTemplateTxt: label '%1/main.aspx?pagetype=entityrecord&etn=%2&id=%3', Locked=true;
        UnableToResolveCRMEntityNameFrmTableIDErr: label 'The application is not designed to integrate Table %1 with Dynamics CRM.', Comment='%1 = table ID (numeric)';
        CouplingNotFoundErr: label 'The record is not coupled to Microsoft Dynamics CRM.';
        NoCardPageActionDefinedForTableIdErr: label 'The open page action is not supported for Table %1.', Comment='%1 = Table ID';
        IntegrationTableMappingNotFoundErr: label 'No %1 was found for table %2.', Comment='%1 = Integration Table Mapping caption, %2 = Table caption for the table which is not mapped';
        UpdateNowDirectionQst: label 'Send data update to Dynamics CRM.,Get data update from Dynamics CRM.', Comment='String menu options separated by comma.';
        UpdateOneNowTitleTxt: label 'Synchronize data for %1?', Comment='%1 = Table caption and value for the entity we want to synchronize now.';
        UpdateMultipleNowTitleTxt: label 'Synchronize data for the selected records?';
        UpdateNowFailedIgnoreDestinationChangesQst: label 'The synchronization failed.\\%1. \\Do you want to ignore the destination changes and try the synchronization again?', Comment='%1 the error message';
        UpdateNowFailedErr: label 'The synchronization failed because of the following error:\\%1.', Comment='%1 Error message';
        ManageCouplingQst: label 'The %1 record is not coupled to Microsoft Dynamics CRM. Do you want to create a coupling?', Comment='%1=The record caption (type)';
        SyncNowSuccessMsg: label 'Synchronization completed.';
        SynchronizedMsg: label '%1 of %2 records were successfully synchronized.', Comment='%1 and %2 are numbers';
        UncoupledSkippedMsg: label '%1 of %2 records were not synchronized because they are not coupled.', Comment='%1 and %2 are numbers';
        NewerSkippedMsg: label '%1 of %2 records were not synchronized because their destination contains newer data.', Comment='%1 and %2 are numbers';
        FailedSynchronizationsMsg: label '%1 of %2 records were not synchronized because of errors.\\For more information, see the %3 page.', Comment='%1 and %2 are numbers, %3 is the name of the error log page';
        CreationCompleteMsg: label 'Creation of the selected records in Microsoft Dynamics CRM completed.';
        CreatedMsg: label '%1 of %2 records were successfully created.', Comment='%1 and %2 are numbers';
        CoupledSkippedMsg: label '%1 of %2 records were skipped because they are already coupled.', Comment='%1 and %2 are numbers';
        UpdateOneNowToCRMQst: label 'Send data update to Dynamics CRM for %1?', Comment='%1 = Table caption and value for the entity we want to synchronize now.';
        UpdateOneNowToModifiedCRMQst: label 'The Dynamics CRM record coupled to %1 contains newer data than the %2 record. Do you want to overwrite the data in Dynamics CRM?', Comment='%1 = Table caption and value for the entity we want to synchronize now. %2 - product name';
        UpdateOneNowFromCRMQst: label 'Get data update from Dynamics CRM for %1?', Comment='%1 = Table caption and value for the entity we want to synchronize now.';
        UpdateOneNowFromOldCRMQst: label 'The %2 record %1 contains newer data than the Dynamics CRM record. Get data update from Dynamics CRM, overwriting data in %2?', Comment='%1 = Table caption and value for the entity we want to synchronize now. %2 - product name';
        UpdateMultipleNowToCRMQst: label 'Send data update to Dynamics CRM for the selected records?';
        UpdateMultipleNowFromCRMQst: label 'Get data update from Dynamics CRM for the selected records?';
        TextManagement: Codeunit "Filter Tokens";
        AccountStatisticsUpdatedMsg: label 'The customer statistics have been successfully updated in Microsoft Dynamics CRM.';
        BothRecordsModifiedBiDirectionalMsg: label 'Both the %1 record and the Dynamics CRM %2 record have been changed since the last synchronization, or synchronization has never been performed. If you continue with synchronization, data on one of the records will be lost and replaced with data from the other record.', Comment='%1 and %2 area captions of tables such as Customer and CRM Account';
        BothRecordsModifiedToCRMQst: label 'Both %1 and the Dynamics CRM %2 record have been changed since the last synchronization, or synchronization has never been performed. If you continue with synchronization, data in Microsoft Dynamics CRM will be overwritten with data from %3. Are you sure you want to synchronize?', Comment='%1 is a formatted RecordID, such as ''Customer 1234''. %2 is the caption of a CRM table. %3 - product name';
        BothRecordsModifiedToNAVQst: label 'Both %1 and the Dynamics CRM %2 record have been changed since the last synchronization, or synchronization has never been performed. If you continue with synchronization, data in %3 will be overwritten with data from Microsoft Dynamics CRM. Are you sure you want to synchronize?', Comment='%1 is a formatted RecordID, such as ''Customer 1234''. %2 is the caption of a CRM table. %3 - product name';
        RecordAlreadyCoupledCreateNewQst: label '%1 is already coupled to a record in Microsoft Dynamics CRM. Do you want to create a new copy and couple to it?', Comment='%1 = RecordID (translated table caption and primary key value, such as Customer 1234)';
        CRMRecordAlreadyCoupledCreateNewQst: label 'The Microsoft Dynamics CRM record is already coupled to a record in %1. Do you want to create a new copy and couple to it, replacing the old coupling?', Comment='%1 - product name';
        CRMIntegrationEnabledState: Option " ","Not Enabled",Enabled,"Enabled But Not For Current User";
        DoYouWantToEnableCRMQst: label 'Dynamics CRM Integration is not enabled.\\Do you want to open the %1 window?', Comment='%1 = CRM Connection Setup';
        NotEnabledForCurrentUserMsg: label 'Dynamics CRM Integration is enabled.\However, because the %2 Users Must Map to Dynamics CRM Users field is set, Dynamics CRM integration is not enabled for %1.', Comment='%1 = Current User Id %2 - product name';
        CRMIntegrationEnabledLastError: Text;
        ImportSolutionConnectStringTok: label '%1api%2/XRMServices/2011/Organization.svc', Locked=true;
        UserDoesNotExistCRMTxt: label 'There is no user with email address %1 in Dynamics CRM. Enter a valid email address.', Comment='%1 = User email address';
        RoleIdDoesNotExistCRMTxt: label 'The Integration role does not exist in Dynamics CRM. \\Make sure the relevant customization is imported or check if the name of the role has changed.';
        EmailAndServerAddressEmptyErr: label 'The Integration User Email and Server Address fields must not be empty.';
        CRMSolutionFileNotFoundErr: label 'A file for a CRM solution could not be found.';
        MicrosoftDynamicsNavIntegrationTxt: label 'MicrosoftDynamicsNavIntegration', Locked=true;
        AdminEmailPasswordWrongErr: label 'Enter valid CRM administrator credentials.';
        AdminUserDoesNotHavePriviligesErr: label 'The specified CRM administrator does not have sufficient privileges to import a CRM solution.';
        InvalidUriErr: label 'The value entered is not a valid URL.';
        MustUseHttpsErr: label 'The application is set up to support secure connections (HTTPS) to Dynamics CRM only. You cannot use HTTP.';
        MustUseHttpOrHttpsErr: label '%1 is not a valid URI scheme for Dynamics CRM connections. You can only use HTTPS or HTTP as the scheme in the URL.', Comment='%1 is a URI scheme, such as FTP, HTTP, chrome or file';
        ReplaceServerAddressQst: label 'The URL is not valid. Do you want to replace it with the URL suggested below?\\Entered URL: "%1".\Suggested URL: "%2".', Comment='%1 and %2 are URLs';
        CRMConnectionURLWrongErr: label 'The URL is incorrect. Enter the URL for the Dynamics CRM connection.';
        UserHasNoSecurityRolesErr: label 'The user with email address %1 must have at least one security role in Dynamics CRM.', Comment='%1 = User email address';


    procedure IsCRMIntegrationEnabled(): Boolean
    var
        CRMConnectionSetup: Record "CRM Connection Setup";
    begin
        if CRMIntegrationEnabledState = Crmintegrationenabledstate::" " then begin
          ClearLastError;
          CRMIntegrationEnabledState := Crmintegrationenabledstate::"Not Enabled";
          Clear(CRMIntegrationEnabledLastError);
          if CRMConnectionSetup.Get then
            if CRMConnectionSetup."Is Enabled" then begin
              if not CRMConnectionSetup."Is User Mapping Required" then
                CRMIntegrationEnabledState := Crmintegrationenabledstate::Enabled
              else
                if CRMConnectionSetup.IsCurrentUserMappedToCrmSystemUser then
                  CRMIntegrationEnabledState := Crmintegrationenabledstate::Enabled
                else begin
                  CRMIntegrationEnabledState := Crmintegrationenabledstate::"Enabled But Not For Current User";
                  CRMIntegrationEnabledLastError := GetLastErrorMessage;
                end;

              if not HasTableConnection(Tableconnectiontype::CRM,GetDefaultTableConnection(Tableconnectiontype::CRM)) then
                CRMConnectionSetup.RegisterUserConnection;
            end;
        end;

        exit(CRMIntegrationEnabledState = Crmintegrationenabledstate::Enabled);
    end;


    procedure IsCRMSolutionInstalled(): Boolean
    begin
        if TryTouchCRMSolutionEntities then
          exit(true);

        ClearLastError;
        exit(false);
    end;

    [TryFunction]
    local procedure TryTouchCRMSolutionEntities()
    var
        CRMNAVConnection: Record "CRM NAV Connection";
        CRMAccountStatistics: Record "CRM Account Statistics";
    begin
        if CRMAccountStatistics.FindFirst then;
        if CRMNAVConnection.FindFirst then;
    end;


    procedure SetCRMNAVConnectionUrl(WebClientUrl: Text[250])
    var
        CRMNAVConnection: Record "CRM NAV Connection";
        NewConnection: Boolean;
    begin
        if not CRMNAVConnection.FindFirst then begin
          CRMNAVConnection.Init;
          NewConnection := true;
        end;

        CRMNAVConnection."Dynamics NAV URL" := WebClientUrl;

        if NewConnection then
          CRMNAVConnection.Insert
        else
          CRMNAVConnection.Modify;
    end;


    procedure SetCRMNAVODataUrlCredentials(ODataUrl: Text[250];Username: Text[250];Accesskey: Text[250])
    var
        CRMNAVConnection: Record "CRM NAV Connection";
        NewConnection: Boolean;
    begin
        if not CRMNAVConnection.FindFirst then begin
          CRMNAVConnection.Init;
          NewConnection := true;
        end;

        CRMNAVConnection."Dynamics NAV OData URL" := ODataUrl;
        CRMNAVConnection."Dynamics NAV OData Username" := Username;
        CRMNAVConnection."Dynamics NAV OData Accesskey" := Accesskey;

        if NewConnection then
          CRMNAVConnection.Insert
        else
          CRMNAVConnection.Modify;
    end;


    procedure UpdateMultipleNow(var RecRef: RecordRef)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationRecSynchInvoke: Codeunit "Integration Rec. Synch. Invoke";
        IntegrationSynchErrorList: Page "Integration Synch. Error List";
        CRMRecordRef: RecordRef;
        SelectedDirection: Integer;
        CRMID: Guid;
        NumUnCoupledRecords: Integer;
        NumNewerDataFailedSynchronizations: Integer;
        NumErrorFailedSynchronizations: Integer;
        NumSucceededSynchronizations: Integer;
        SuccessMsg: Text;
        RecordModified: Boolean;
        CRMRecordModified: Boolean;
        Unused: Boolean;
    begin
        if RecRef.IsEmpty then
          exit;

        GetIntegrationTableMapping(IntegrationTableMapping,RecRef.RecordId.TableNo);

        SelectedDirection := GetSelectedSyncDirection(RecRef.RecordId,CRMID,true,Unused);
        if SelectedDirection < 1 then
          exit; // The user cancelled

        repeat
          if not GetCoupledCRMID(RecRef.RecordId,CRMID,true) then
            NumUnCoupledRecords := NumUnCoupledRecords + 1
          else begin
            // Determine which sides were modified since last synch
            IntegrationTableMapping.GetRecordRef(CRMID,CRMRecordRef);
            RecordModified := IntegrationRecSynchInvoke.WasModifiedAfterLastSynch(IntegrationTableMapping,RecRef);
            CRMRecordModified := IntegrationRecSynchInvoke.WasModifiedAfterLastSynch(IntegrationTableMapping,CRMRecordRef);
            if ((SelectedDirection = IntegrationTableMapping.Direction::ToIntegrationTable) and CRMRecordModified) or
               ((SelectedDirection = IntegrationTableMapping.Direction::FromIntegrationTable) and RecordModified)
            then
              NumNewerDataFailedSynchronizations := NumNewerDataFailedSynchronizations + 1
            else
              if UpdateOne(IntegrationTableMapping,RecRef.RecordId,CRMID,SelectedDirection,true,false,false) then
                NumSucceededSynchronizations := NumSucceededSynchronizations + 1
              else
                NumErrorFailedSynchronizations := NumErrorFailedSynchronizations + 1;
          end;
        until RecRef.Next = 0;

        SuccessMsg := SyncNowSuccessMsg;
        SuccessMsg := SuccessMsg + '\'; // At least one of the three below is always the case
        if NumSucceededSynchronizations > 0 then
          SuccessMsg := StrSubstNo('%1\%2',SuccessMsg,StrSubstNo(SynchronizedMsg,NumSucceededSynchronizations,RecRef.Count));
        if NumUnCoupledRecords > 0 then
          SuccessMsg := StrSubstNo('%1\%2',SuccessMsg,StrSubstNo(UncoupledSkippedMsg,NumUnCoupledRecords,RecRef.Count));
        if NumNewerDataFailedSynchronizations > 0 then
          SuccessMsg := StrSubstNo('%1\%2',SuccessMsg,StrSubstNo(NewerSkippedMsg,NumNewerDataFailedSynchronizations,RecRef.Count));
        if NumErrorFailedSynchronizations > 0 then
          SuccessMsg := StrSubstNo('%1\%2',SuccessMsg,
              StrSubstNo(FailedSynchronizationsMsg,NumErrorFailedSynchronizations,RecRef.Count,IntegrationSynchErrorList.Caption));

        Message(SuccessMsg);
    end;


    procedure UpdateOneNow(RecordID: RecordID)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        SelectedDirection: Integer;
        CRMID: Guid;
        RecommendedDirectionIgnored: Boolean;
    begin
        GetIntegrationTableMapping(IntegrationTableMapping,RecordID.TableNo);

        if not GetCoupledCRMID(RecordID,CRMID,true) then begin
          GetCoupledCRMID(RecordID,CRMID,false);
          exit;
        end;

        SelectedDirection := GetSelectedSyncDirection(RecordID,CRMID,false,RecommendedDirectionIgnored);

        if SelectedDirection = 0 then
          exit; // The user cancelled

        if UpdateOne(IntegrationTableMapping,RecordID,CRMID,SelectedDirection,false,not RecommendedDirectionIgnored,false) then
          Message(SyncNowSuccessMsg);
    end;


    procedure CheckOrEnableCRMConnection()
    var
        CRMConnectionSetup: Page "CRM Connection Setup";
    begin
        if IsCRMIntegrationEnabled then
          exit;

        if CRMIntegrationEnabledLastError <> '' then
          Error(CRMIntegrationEnabledLastError);

        if CRMIntegrationEnabledState = Crmintegrationenabledstate::"Enabled But Not For Current User" then
          Message(NotEnabledForCurrentUserMsg,UserId,ProductName.Short)
        else
          if Confirm(DoYouWantToEnableCRMQst,true,CRMConnectionSetup.Caption) then
            Page.Run(Page::"CRM Connection Setup");

        Error('');
    end;


    procedure CreateNewRecordInCRM(RecordID: RecordID;ConfirmBeforeDeletingExistingCoupling: Boolean)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        CRMID: Guid;
    begin
        GetIntegrationTableMapping(IntegrationTableMapping,RecordID.TableNo);
        GetCoupledCRMID(RecordID,CRMID,true);
        if not IsNullGuid(CRMID) then begin
          if ConfirmBeforeDeletingExistingCoupling then
            if not Confirm(RecordAlreadyCoupledCreateNewQst,false,Format(RecordID,0,1)) then
              exit;
          CRMCouplingManagement.RemoveCoupling(RecordID)
        end;
        if UpdateOne(IntegrationTableMapping,RecordID,CRMID,IntegrationTableMapping.Direction::ToIntegrationTable,false,true,true) then
          Message(SyncNowSuccessMsg);
    end;


    procedure CreateNewRecordsInCRM(RecRef: RecordRef)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        CRMID: Guid;
        NumCoupledRecords: Integer;
        NumSuccessfulCreations: Integer;
        NumFailedCreations: Integer;
    begin
        if RecRef.IsEmpty then
          exit;

        GetIntegrationTableMapping(IntegrationTableMapping,RecRef.RecordId.TableNo);

        // Perform the coupling, counting different kinds of success and failure
        repeat
          if GetCoupledCRMID(RecRef.RecordId,CRMID,true) then
            NumCoupledRecords := NumCoupledRecords + 1
          else
            if UpdateOne(IntegrationTableMapping,RecRef.RecordId,CRMID,
                 IntegrationTableMapping.Direction::ToIntegrationTable,true,true,true)
            then
              NumSuccessfulCreations := NumSuccessfulCreations + 1
            else
              NumFailedCreations := NumFailedCreations + 1;
        until RecRef.Next = 0;

        // Report what happened
        ShowCreationFinishedMessage(RecRef.Count,NumSuccessfulCreations,NumCoupledRecords,NumFailedCreations);
    end;


    procedure CreateNewRecordFromCRM(CRMID: Guid;TableID: Integer)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        CRMIntegrationRecord: Record "CRM Integration Record";
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        RecordID: RecordID;
    begin
        GetIntegrationTableMapping(IntegrationTableMapping,TableID);
        if CRMIntegrationRecord.FindRecordIDFromID(CRMID,TableID,RecordID) then
          if not CRMIntegrationRecord.DeleteIfRecordDeleted(CRMID,TableID) then
            if Confirm(StrSubstNo(CRMRecordAlreadyCoupledCreateNewQst,ProductName.Full)) then
              CRMCouplingManagement.RemoveCoupling(RecordID)
            else
              exit;
        if UpdateOne(IntegrationTableMapping,RecordID,CRMID,IntegrationTableMapping.Direction::FromIntegrationTable,false,true,true) then begin
          CRMIntegrationRecord.FindRecordIDFromID(CRMID,TableID,RecordID);
          OpenRecordCardPage(RecordID);
        end;
    end;


    procedure CreateNewRecordsFromCRM(RecRef: RecordRef)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        CRMIntegrationRecord: Record "CRM Integration Record";
        RecordID: RecordID;
        CRMID: Guid;
        NumCoupledRecords: Integer;
        NumSuccessfulCreations: Integer;
        NumFailedCreations: Integer;
    begin
        if RecRef.IsEmpty then
          exit;

        // Make sure this kind of record can be coupled
        IntegrationTableMapping.SetRange("Synch. Codeunit ID",Codeunit::"CRM Integration Table Synch.");
        IntegrationTableMapping.SetRange("Integration Table ID",RecRef.RecordId.TableNo);
        if not IntegrationTableMapping.FindFirst then
          Error(IntegrationTableMappingNotFoundErr,IntegrationTableMapping.TableCaption,RecRef.Caption);

        // Perform the coupling, counting different kinds of success and failure
        repeat
          CRMID := RecRef.Field(IntegrationTableMapping."Integration Table UID Fld. No.").Value;
          if CRMIntegrationRecord.FindRecordIDFromID(CRMID,IntegrationTableMapping."Table ID",RecordID) then begin
            if not CRMIntegrationRecord.DeleteIfRecordDeleted(CRMID,IntegrationTableMapping."Table ID")
            then
              NumCoupledRecords := NumCoupledRecords + 1
          end else
            if UpdateOne(IntegrationTableMapping,RecordID,CRMID,IntegrationTableMapping.Direction::FromIntegrationTable,true,true,true) then
              NumSuccessfulCreations := NumSuccessfulCreations + 1
            else
              NumFailedCreations := NumFailedCreations + 1;
        until RecRef.Next = 0;

        // Report what happened
        ShowCreationFinishedMessage(RecRef.Count,NumSuccessfulCreations,NumCoupledRecords,NumFailedCreations);
    end;

    local procedure ShowCreationFinishedMessage(NumRecords: Integer;NumSuccessfulCreations: Integer;NumCoupledRecords: Integer;NumFailedCreations: Integer)
    var
        IntegrationSynchErrorList: Page "Integration Synch. Error List";
        FinishMsg: Text;
    begin
        FinishMsg := CreationCompleteMsg;
        FinishMsg := FinishMsg + '\';
        if NumSuccessfulCreations > 0 then
          FinishMsg := StrSubstNo('%1\%2',FinishMsg,StrSubstNo(CreatedMsg,NumSuccessfulCreations,NumRecords));
        if NumCoupledRecords > 0 then
          FinishMsg := StrSubstNo('%1\%2',FinishMsg,StrSubstNo(CoupledSkippedMsg,NumCoupledRecords,NumRecords));
        if NumFailedCreations > 0 then
          FinishMsg := StrSubstNo('%1\%2',FinishMsg,
              StrSubstNo(FailedSynchronizationsMsg,NumFailedCreations,NumRecords,IntegrationSynchErrorList.Caption));
        Message(FinishMsg);
    end;

    local procedure PerformInitialSynchronization(RecordID: RecordID;CRMID: Guid;Direction: Option)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
    begin
        GetIntegrationTableMapping(IntegrationTableMapping,RecordID.TableNo);
        if UpdateOne(IntegrationTableMapping,RecordID,CRMID,Direction,false,true,false) then
          Message(SyncNowSuccessMsg);
    end;

    local procedure GetIntegrationTableMapping(var IntegrationTableMapping: Record "Integration Table Mapping";TableID: Integer)
    var
        TableMetadata: Record "Table Metadata";
    begin
        IntegrationTableMapping.SetRange("Synch. Codeunit ID",Codeunit::"CRM Integration Table Synch.");
        IntegrationTableMapping.SetRange("Table ID",TableID);
        if not IntegrationTableMapping.FindFirst then begin
          TableMetadata.Get(TableID);
          Error(IntegrationTableMappingNotFoundErr,IntegrationTableMapping.TableCaption,TableMetadata.Caption);
        end;
    end;

    local procedure UpdateOne(IntegrationTableMapping: Record "Integration Table Mapping";RecordID: RecordID;CRMID: Guid;Direction: Integer;MultipleRecords: Boolean;IgnoreChanges: Boolean;IgnoreSynchOnlyCoupledRecords: Boolean): Boolean
    var
        IntegrationSynchJob: Record "Integration Synch. Job";
        IntegrationSynchJobErrors: Record "Integration Synch. Job Errors";
        CRMIntegrationTableSynch: Codeunit "CRM Integration Table Synch.";
        LogId: Guid;
        ErrorMessage: Text;
    begin
        if Direction = IntegrationTableMapping.Direction::FromIntegrationTable then
          LogId := CRMIntegrationTableSynch.SynchRecord(IntegrationTableMapping,CRMID,IgnoreChanges,IgnoreSynchOnlyCoupledRecords)
        else
          LogId := CRMIntegrationTableSynch.SynchRecord(IntegrationTableMapping,RecordID,IgnoreChanges,IgnoreSynchOnlyCoupledRecords);

        IntegrationSynchJob.Get(LogId);
        if IntegrationSynchJob.Failed > 0 then begin
          ErrorMessage := IntegrationSynchJob.Message;
          IntegrationSynchJobErrors.SetRange("Integration Synch. Job ID",IntegrationSynchJob.ID);
          if IntegrationSynchJobErrors.FindFirst then
            ErrorMessage := ErrorMessage + ' ' + IntegrationSynchJobErrors.Message;

          if MultipleRecords then
            exit(false);

          if IgnoreChanges then
            Error(UpdateNowFailedErr,TextManagement.RemoveMessageTrailingDots(ErrorMessage));

          if not Confirm(UpdateNowFailedIgnoreDestinationChangesQst,false,TextManagement.RemoveMessageTrailingDots(ErrorMessage)) then
            exit(false);

          if Direction = IntegrationTableMapping.Direction::FromIntegrationTable then
            LogId := CRMIntegrationTableSynch.SynchRecord(IntegrationTableMapping,CRMID,true,IgnoreSynchOnlyCoupledRecords)
          else
            LogId := CRMIntegrationTableSynch.SynchRecord(IntegrationTableMapping,RecordID,true,IgnoreSynchOnlyCoupledRecords);
          IntegrationSynchJob.Get(LogId);
        end;

        if IntegrationSynchJob.Failed > 0 then begin
          IntegrationSynchJobErrors.SetRange("Integration Synch. Job ID",IntegrationSynchJob.ID);
          ErrorMessage := IntegrationSynchJob.Message;
          if IntegrationSynchJobErrors.FindFirst then
            ErrorMessage := ErrorMessage + ' ' + IntegrationSynchJobErrors.Message;
          Error(UpdateNowFailedErr,TextManagement.RemoveMessageTrailingDots(ErrorMessage));
        end;

        exit(true);
    end;


    procedure CreateOrUpdateCRMAccountStatistics(Customer: Record Customer)
    var
        CRMAccount: Record "CRM Account";
        CRMStatisticsJob: Codeunit "CRM Statistics Job";
        CRMID: Guid;
    begin
        if not GetCoupledCRMID(Customer.RecordId,CRMID,true) then
          exit;

        CRMAccount.Get(CRMID);
        CRMStatisticsJob.CreateOrUpdateCRMAccountStatistics(Customer,CRMAccount);
        Message(AccountStatisticsUpdatedMsg);
    end;


    procedure ShowCRMEntityFromRecordID(RecordID: RecordID)
    var
        CRMID: Guid;
    begin
        if not GetCoupledCRMID(RecordID,CRMID,false) then
          exit;

        Hyperlink(GetCRMEntityUrlFromRecordID(RecordID));
    end;


    procedure GetCRMEntityUrlFromRecordID(TargetRecordID: RecordID): Text
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        IntegrationRecord: Record "Integration Record";
        CRMId: Guid;
    begin
        if not CRMIntegrationRecord.FindIDFromRecordID(TargetRecordID,CRMId) then
          Error(CouplingNotFoundErr);

        IntegrationRecord.FindByRecordId(TargetRecordID);
        exit(GetCRMEntityUrlFromCRMID(IntegrationRecord."Table ID",CRMId));
    end;


    procedure GetCRMEntityUrlFromCRMID(TableId: Integer;CRMId: Guid): Text
    var
        CRMConnectionSetup: Record "CRM Connection Setup";
    begin
        CRMConnectionSetup.Get;
        exit(StrSubstNo(CRMEntityUrlTemplateTxt,CRMConnectionSetup."Server Address",GetCRMEntityTypeName(TableId),CRMId));
    end;


    procedure OpenCoupledNavRecordPage(CRMID: Guid;CRMEntityTypeName: Text): Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        CRMSetupDefaults: Codeunit "CRM Setup Defaults";
        RecordID: RecordID;
        TableId: Integer;
    begin
        // Find the corresponding NAV record and type
        CRMSetupDefaults.GetTableIDCRMEntityNameMapping(TempNameValueBuffer);
        TempNameValueBuffer.SetRange(Name,Lowercase(CRMEntityTypeName));
        if not TempNameValueBuffer.FindSet then
          exit(false);

        repeat
          Evaluate(TableId,TempNameValueBuffer.Value);
          if CRMIntegrationRecord.FindRecordIDFromID(CRMID,TableId,RecordID) then
            break;
        until TempNameValueBuffer.Next = 0;

        if RecordID.TableNo = 0 then
          exit(false);

        OpenRecordCardPage(RecordID);
        exit(true);
    end;

    local procedure OpenRecordCardPage(RecordID: RecordID)
    var
        Customer: Record Customer;
        Contact: Record Contact;
        Currency: Record Currency;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        UnitOfMeasure: Record "Unit of Measure";
        Item: Record Item;
        Resource: Record Resource;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        CustomerPriceGroup: Record "Customer Price Group";
        RecordRef: RecordRef;
    begin
        // Open the right kind of card page
        RecordRef := RecordID.GetRecord;
        case RecordID.TableNo of
          Database::Contact:
            begin
              RecordRef.SetTable(Contact);
              Page.Run(Page::"Contact Card",Contact);
            end;
          Database::Currency:
            begin
              RecordRef.SetTable(Currency);
              Page.Run(Page::"Currency Card",Currency);
            end;
          Database::Customer:
            begin
              RecordRef.SetTable(Customer);
              Page.Run(Page::"Customer Card",Customer);
            end;
          Database::Item:
            begin
              RecordRef.SetTable(Item);
              Page.Run(Page::"Item Card",Item);
            end;
          Database::"Sales Invoice Header":
            begin
              RecordRef.SetTable(SalesInvoiceHeader);
              Page.Run(Page::"Posted Sales Invoice",SalesInvoiceHeader);
            end;
          Database::Resource:
            begin
              RecordRef.SetTable(Resource);
              Page.Run(Page::"Resource Card",Resource);
            end;
          Database::"Salesperson/Purchaser":
            begin
              RecordRef.SetTable(SalespersonPurchaser);
              Page.Run(Page::"Salesperson/Purchaser Card",SalespersonPurchaser);
            end;
          Database::"Unit of Measure":
            begin
              RecordRef.SetTable(UnitOfMeasure);
              // There is no Unit of Measure card. Open the list, filtered down to this instance.
              Page.Run(Page::"Units of Measure",UnitOfMeasure);
            end;
          Database::"Customer Price Group":
            begin
              RecordRef.SetTable(CustomerPriceGroup);
              // There is no Customer Price Group card. Open the list, filtered down to this instance.
              Page.Run(Page::"Customer Price Groups",CustomerPriceGroup);
            end;
          else
            Error(NoCardPageActionDefinedForTableIdErr,RecordID.TableNo);
        end;
    end;


    procedure GetCRMEntityTypeName(TableId: Integer): Text
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        CRMSetupDefaults: Codeunit "CRM Setup Defaults";
    begin
        CRMSetupDefaults.GetTableIDCRMEntityNameMapping(TempNameValueBuffer);
        TempNameValueBuffer.SetRange(Value,Format(TableId));
        if TempNameValueBuffer.FindFirst then
          exit(TempNameValueBuffer.Name);
        Error(UnableToResolveCRMEntityNameFrmTableIDErr,TableId);
    end;

    local procedure GetCoupledCRMID(RecordID: RecordID;var CRMID: Guid;Silent: Boolean): Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        RecordRef: RecordRef;
    begin
        if CRMIntegrationRecord.FindIDFromRecordID(RecordID,CRMID) then
          exit(true);

        if Silent then
          exit(false);

        RecordRef.Open(RecordID.TableNo);
        if Confirm(StrSubstNo(ManageCouplingQst,RecordRef.Caption),false) then
          if DefineCoupling(RecordID) then
            exit(CRMIntegrationRecord.FindIDFromRecordID(RecordID,CRMID));

        exit(false);
    end;


    procedure DefineCoupling(RecordID: RecordID): Boolean
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        CreateNew: Boolean;
        Synchronize: Boolean;
        Direction: Option;
        CRMID: Guid;
    begin
        if CRMCouplingManagement.DefineCoupling(RecordID,CRMID,CreateNew,Synchronize,Direction) then begin
          if CreateNew then
            CreateNewRecordInCRM(RecordID,false)
          else
            if Synchronize then
              PerformInitialSynchronization(RecordID,CRMID,Direction);
          exit(true);
        end;

        exit(false);
    end;


    procedure ManageCreateNewRecordFromCRM(TableID: Integer)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        CRMContactList: Page "CRM Contact List";
        CRMAccountList: Page "CRM Account List";
    begin
        GetIntegrationTableMapping(IntegrationTableMapping,TableID);

        // Open the right kind of CRM List page, allowing creation
        case TableID of
          Database::Contact:
            begin
              CRMContactList.SetAllowCreateFromCRM(true);
              CRMContactList.RunModal;
            end;
          Database::Customer:
            begin
              CRMAccountList.SetAllowCreateFromCRM(true);
              CRMAccountList.RunModal;
            end;
        end;
    end;


    procedure ShowCustomerCRMOpportunities(Customer: Record Customer)
    var
        CRMOpportunity: Record "CRM Opportunity";
        CRMID: Guid;
    begin
        if not IsCRMIntegrationEnabled then
          exit;

        if not GetCoupledCRMID(Customer.RecordId,CRMID,false) then
          exit;

        CRMOpportunity.FilterGroup := 2;
        CRMOpportunity.SetRange(ParentAccountId,CRMID);
        CRMOpportunity.SetRange(StateCode,CRMOpportunity.Statecode::Open);
        CRMOpportunity.FilterGroup := 0;
        Page.Run(Page::"CRM Opportunity List",CRMOpportunity);
    end;


    procedure ShowCustomerCRMQuotes(Customer: Record Customer)
    var
        CRMQuote: Record "CRM Quote";
        CRMID: Guid;
    begin
        if not IsCRMIntegrationEnabled then
          exit;

        if not GetCoupledCRMID(Customer.RecordId,CRMID,false) then
          exit;

        CRMQuote.FilterGroup := 2;
        CRMQuote.SetRange(CustomerId,CRMID);
        CRMQuote.SetRange(StateCode,CRMQuote.Statecode::Active);
        CRMQuote.FilterGroup := 0;
        Page.Run(Page::"CRM Quote List",CRMQuote);
    end;


    procedure ShowCustomerCRMCases(Customer: Record Customer)
    var
        CRMIncident: Record "CRM Incident";
        CRMID: Guid;
    begin
        if not IsCRMIntegrationEnabled then
          exit;

        if not GetCoupledCRMID(Customer.RecordId,CRMID,false) then
          exit;

        CRMIncident.FilterGroup := 2;
        CRMIncident.SetRange(CustomerId,CRMID);
        CRMIncident.SetRange(StateCode,CRMIncident.Statecode::Active);
        CRMIncident.FilterGroup := 2;
        Page.Run(Page::"CRM Case List",CRMIncident);
    end;


    procedure GetNoOfCRMOpportunities(Customer: Record Customer): Integer
    var
        CRMOpportunity: Record "CRM Opportunity";
        CRMID: Guid;
    begin
        if not IsCRMIntegrationEnabled then
          exit(0);

        if not GetCoupledCRMID(Customer.RecordId,CRMID,true) then
          exit(0);

        CRMOpportunity.SetRange(ParentAccountId,CRMID);
        CRMOpportunity.SetRange(StateCode,CRMOpportunity.Statecode::Open);
        exit(CRMOpportunity.Count);
    end;


    procedure GetNoOfCRMQuotes(Customer: Record Customer): Integer
    var
        CRMQuote: Record "CRM Quote";
        CRMID: Guid;
    begin
        if not IsCRMIntegrationEnabled then
          exit(0);

        if not GetCoupledCRMID(Customer.RecordId,CRMID,true) then
          exit(0);

        CRMQuote.SetRange(CustomerId,CRMID);
        CRMQuote.SetRange(StateCode,CRMQuote.Statecode::Active);
        exit(CRMQuote.Count);
    end;


    procedure GetNoOfCRMCases(Customer: Record Customer): Integer
    var
        CRMIncident: Record "CRM Incident";
        CRMID: Guid;
    begin
        if not IsCRMIntegrationEnabled then
          exit(0);

        if not GetCoupledCRMID(Customer.RecordId,CRMID,true) then
          exit(0);

        CRMIncident.SetRange(StateCode,CRMIncident.Statecode::Active);
        CRMIncident.SetRange(CustomerId,CRMID);
        exit(CRMIncident.Count);
    end;

    local procedure GetSelectedSyncDirection(RecordID: RecordID;CRMID: Guid;MultipleRecords: Boolean;var RecommendedDirectionIgnored: Boolean): Integer
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationRecSynchInvoke: Codeunit "Integration Rec. Synch. Invoke";
        RecordRef: RecordRef;
        CRMRecordRef: RecordRef;
        SynchronizeNowQuestion: Text;
        AllowedDirection: Integer;
        RecommendedDirection: Integer;
        SelectedDirection: Integer;
        RecordModified: Boolean;
        CRMRecordModified: Boolean;
        DefaultAnswer: Boolean;
    begin
        // Interact with the user to a) confirm sync and b) if AllowedDirection = Bidirectional, then get Selected Direction
        // Returns 0 if the user canceled

        // Determine the allowed direction
        // Currently we expect one mapping per entity. In a multi-mapping per entity setup we need additional filtering to choose correct mapping.
        IntegrationTableMapping.SetRange("Table ID",RecordID.TableNo);
        IntegrationTableMapping.FindFirst;
        if IntegrationTableMapping.Count = 1 then
          AllowedDirection := IntegrationTableMapping.Direction
        else
          AllowedDirection := IntegrationTableMapping.GetAllowedSyncDirection(RecordID.TableNo);

        if MultipleRecords then begin
          case AllowedDirection of
            IntegrationTableMapping.Direction::Bidirectional:
              exit(StrMenu(UpdateNowDirectionQst,RecommendedDirection,UpdateMultipleNowTitleTxt));
            IntegrationTableMapping.Direction::FromIntegrationTable:
              SynchronizeNowQuestion := UpdateMultipleNowFromCRMQst;
            else
              SynchronizeNowQuestion := UpdateMultipleNowToCRMQst;
          end;

          if Confirm(SynchronizeNowQuestion,true) then
            exit(AllowedDirection);

          exit(0);
        end;

        // Single record
        // Determine which sides were modified since last synch
        RecordRef.Get(RecordID);
        IntegrationTableMapping.GetRecordRef(CRMID,CRMRecordRef);
        RecordModified := IntegrationRecSynchInvoke.WasModifiedAfterLastSynch(IntegrationTableMapping,RecordRef);
        CRMRecordModified := IntegrationRecSynchInvoke.WasModifiedAfterLastSynch(IntegrationTableMapping,CRMRecordRef);

        if RecordModified and CRMRecordModified then
          // Changes on both sides. Bidirectional: warn user. Unidirectional: confirm and exit.
          case AllowedDirection of
            IntegrationTableMapping.Direction::Bidirectional:
              Message(BothRecordsModifiedBiDirectionalMsg,RecordRef.Caption,CRMRecordRef.Caption);
            IntegrationTableMapping.Direction::ToIntegrationTable:
              begin
                if Confirm(BothRecordsModifiedToCRMQst,false,Format(RecordID,0,1),CRMRecordRef.Caption,ProductName.Full) then
                  exit(AllowedDirection);
                exit(0);
              end;
            IntegrationTableMapping.Direction::FromIntegrationTable:
              begin
                if Confirm(BothRecordsModifiedToNAVQst,false,Format(RecordID,0,1),CRMRecordRef.Caption,ProductName.Full) then
                  exit(AllowedDirection);
                exit(0);
              end;
          end;

        // Zero or one side changed. Synch for zero too because dependent objects could have changed.
        case AllowedDirection of
          IntegrationTableMapping.Direction::Bidirectional:
            begin
              // Default from NAV to CRM
              RecommendedDirection := IntegrationTableMapping.Direction::ToIntegrationTable;
              if CRMRecordModified and not RecordModified then
                RecommendedDirection := IntegrationTableMapping.Direction::FromIntegrationTable;

              SelectedDirection := StrMenu(UpdateNowDirectionQst,RecommendedDirection,
                  StrSubstNo(UpdateOneNowTitleTxt,Format(RecordID,0,1)));
              RecommendedDirectionIgnored := SelectedDirection <> RecommendedDirection;
              exit(SelectedDirection);
            end;
          IntegrationTableMapping.Direction::FromIntegrationTable:
            if RecordModified then
              SynchronizeNowQuestion := StrSubstNo(UpdateOneNowFromOldCRMQst,Format(RecordID,0,1),ProductName.Short)
            else begin
              SynchronizeNowQuestion := StrSubstNo(UpdateOneNowFromCRMQst,Format(RecordID,0,1));
              DefaultAnswer := true;
            end;
          else
            if CRMRecordModified then
              SynchronizeNowQuestion := StrSubstNo(UpdateOneNowToModifiedCRMQst,Format(RecordID,0,1),ProductName.Short)
            else begin
              SynchronizeNowQuestion := StrSubstNo(UpdateOneNowToCRMQst,Format(RecordID,0,1));
              DefaultAnswer := true;
            end;
        end;

        if Confirm(SynchronizeNowQuestion,DefaultAnswer) then
          exit(AllowedDirection);

        exit(0);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Connection", 'OnRegisterServiceConnection', '', false, false)]

    procedure HandleCRMRegisterServiceConnection(var ServiceConnection: Record "Service Connection")
    var
        CRMConnectionSetup: Record "CRM Connection Setup";
        RecRef: RecordRef;
    begin
        if not CRMConnectionSetup.Get then begin
          if not CRMConnectionSetup.WritePermission then
            exit;
          CRMConnectionSetup.Init;
          CRMConnectionSetup.Insert;
        end;

        RecRef.GetTable(CRMConnectionSetup);
        ServiceConnection.Status := ServiceConnection.Status::Enabled;
        with CRMConnectionSetup do begin
          if not "Is Enabled" then
            ServiceConnection.Status := ServiceConnection.Status::Disabled
          else begin
            if TestConnection then
              ServiceConnection.Status := ServiceConnection.Status::Connected
            else
              ServiceConnection.Status := ServiceConnection.Status::Error;
          end;
          ServiceConnection.InsertServiceConnectionExtended(
            ServiceConnection,RecRef.RecordId,TableCaption,"Server Address",Page::"CRM Connection Setup",
            Page::"CRM Connection Setup Wizard");
        end;
    end;


    procedure ClearState()
    begin
        CRMIntegrationEnabledState := Crmintegrationenabledstate::" "
    end;


    procedure GetLastErrorMessage(): Text
    var
        ErrorObject: dotnet Exception;
    begin
        ErrorObject := GetLastErrorObject;
        if IsNull(ErrorObject) then
          exit('');
        if StrPos(ErrorObject.GetType.Name,'NavCrmException') > 0 then
          if not IsNull(ErrorObject.InnerException) then
            exit(ErrorObject.InnerException.Message);
        exit(GetLastErrorText);
    end;

    [TryFunction]

    procedure ImportCRMSolution(ServerAddress: Text;IntegrationUserEmail: Text;AdminUserEmail: Text;AdminUserPassword: Text)
    var
        URI: dotnet Uri;
        HomeRealmURI: dotnet Uri;
        ClientCredentials: dotnet ClientCredentials;
        DevCred: dotnet ClientCredentials;
        OrganizationServiceProxy: dotnet OrganizationServiceProxy;
        CRMHelper: dotnet CrmHelper;
        UserGUID: Guid;
        IntegrationAdminRoleGUID: Guid;
        IntegrationUserRoleGUID: Guid;
    begin
        CheckConnectRequiredFields(ServerAddress,IntegrationUserEmail);
        URI := URI.Uri(ConstructConnectionStringForSolutionImport(ServerAddress));
        ClientCredentials := ClientCredentials.ClientCredentials;
        ClientCredentials.UserName.UserName := AdminUserEmail;
        ClientCredentials.UserName.Password := AdminUserPassword;
        if not InitializeCRMConnection(URI,HomeRealmURI,ClientCredentials,DevCred,CRMHelper,OrganizationServiceProxy) then
          ProcessConnectionFailures;

        if IsNull(OrganizationServiceProxy.ServiceManagement.GetIdentityProvider(AdminUserEmail)) then
          Error(AdminEmailPasswordWrongErr);

        UserGUID := GetUserGUID(OrganizationServiceProxy,IntegrationUserEmail);
        if not CheckAnyRoleAssignedToUser(OrganizationServiceProxy,UserGUID) then
          Error(StrSubstNo(UserHasNoSecurityRolesErr,IntegrationUserEmail));

        if not CheckSolutionPresence(OrganizationServiceProxy) then
          if not ImportDefaultCRMSolution(CRMHelper,OrganizationServiceProxy) then
            ProcessConnectionFailures;

        IntegrationAdminRoleGUID := GetRoleGUID(OrganizationServiceProxy,GetIntegrationAdminRoleID);
        IntegrationUserRoleGUID := GetRoleGUID(OrganizationServiceProxy,GetIntegrationUserRoleID);

        if not CheckRoleAssignedToUser(OrganizationServiceProxy,UserGUID,IntegrationAdminRoleGUID) then
          AssociateUserWithRole(UserGUID,IntegrationAdminRoleGUID,OrganizationServiceProxy);
        if not CheckRoleAssignedToUser(OrganizationServiceProxy,UserGUID,IntegrationUserRoleGUID) then
          AssociateUserWithRole(UserGUID,IntegrationUserRoleGUID,OrganizationServiceProxy);
    end;

    [TryFunction]
    local procedure ImportDefaultCRMSolution(CRMHelper: dotnet CrmHelper;var OrganizationServiceProxy: dotnet OrganizationServiceProxy)
    begin
        CRMHelper.ImportDefaultCrmSolution(OrganizationServiceProxy);
    end;

    local procedure AssociateUserWithRole(UserGUID: Guid;RoleGUID: Guid;var OrganizationServiceProxy: dotnet OrganizationServiceProxy)
    var
        AssociateRequest: dotnet AssociateRequest;
    begin
        CreateAssociateRequest(UserGUID,RoleGUID,AssociateRequest);
        OrganizationServiceProxy.Execute(AssociateRequest);
    end;

    local procedure GetQueryExpression(EntityName: Text;Column: Text;ConditionField: Text;ConditionFieldValue: Text;ErrorMsg: Text;var OrganizationServiceProxy: dotnet OrganizationServiceProxy): Guid
    var
        QueryExpression: dotnet QueryExpression;
        Entity: dotnet Entity;
        EntityCollection: dotnet EntityCollection;
        LinkEntity: dotnet LinkEntity;
    begin
        CreateQueryExpression(EntityName,Column,ConditionField,ConditionFieldValue,LinkEntity,QueryExpression);
        if not ProcessQueryExpression(OrganizationServiceProxy,EntityCollection,QueryExpression) then
          ProcessConnectionFailures;
        if EntityCollection.Entities.Count = 0 then
          Error(StrSubstNo(ErrorMsg,ConditionFieldValue));
        Entity := EntityCollection.Item(0);
        exit(Entity.Id);
    end;

    local procedure GetUserGUID(var OrganizationServiceProxy: dotnet OrganizationServiceProxy;UserEmail: Text): Guid
    begin
        exit(
          GetQueryExpression(
            'systemuser','systemuserid','internalemailaddress',UserEmail,UserDoesNotExistCRMTxt,OrganizationServiceProxy));
    end;

    local procedure GetRoleGUID(var OrganizationServiceProxy: dotnet OrganizationServiceProxy;RoleName: Text): Guid
    begin
        exit(
          GetQueryExpression(
            'role','roleid','roleid',RoleName,RoleIdDoesNotExistCRMTxt,OrganizationServiceProxy));
    end;


    procedure CheckConnectRequiredFields(ServerAddress: Text;IntegrationUserEmail: Text)
    begin
        if (IntegrationUserEmail = '') or (ServerAddress = '') then
          Error(EmailAndServerAddressEmptyErr);
    end;


    procedure CreateAssociateRequest(UserGUID: Guid;RoleGUID: Guid;var AssociateRequest: dotnet AssociateRequest)
    var
        EntityReferenceCollection: dotnet EntityReferenceCollection;
        RelationShip: dotnet Relationship;
        EntityReference: dotnet EntityReference;
    begin
        EntityReferenceCollection := EntityReferenceCollection.EntityReferenceCollection;
        EntityReferenceCollection.Add(EntityReference.EntityReference('role',RoleGUID));
        RelationShip := RelationShip.Relationship('systemuserroles_association');
        AssociateRequest := AssociateRequest.AssociateRequest;
        AssociateRequest.Target(EntityReference.EntityReference('systemuser',UserGUID));
        AssociateRequest.RelatedEntities(EntityReferenceCollection);
        AssociateRequest.Relationship(RelationShip);
    end;


    procedure CreateFilterExpression(AttributeName: Text;Value: Text;var FilterExpression: dotnet FilterExpression)
    var
        ConditionExpression: dotnet ConditionExpression;
        ConditionOperator: dotnet ConditionOperator;
    begin
        ConditionExpression :=
          ConditionExpression.ConditionExpression(AttributeName,ConditionOperator.Equal,Value);
        FilterExpression := FilterExpression.FilterExpression;
        FilterExpression.AddCondition(ConditionExpression);
    end;


    procedure CreateLinkEntity(var LinkEntity: dotnet LinkEntity;LinkFromEntityName: Text;LinkFromAttributeName: Text;LinkToEntityName: Text;LinkToAttributeName: Text)
    var
        JoinOperator: dotnet JoinOperator;
    begin
        LinkEntity :=
          LinkEntity.LinkEntity(
            LinkFromEntityName,LinkToEntityName,LinkFromAttributeName,LinkToAttributeName,
            JoinOperator.Inner);
    end;


    procedure CreateRoleToUserIDQueryExpression(UserIDGUID: Guid;RoleIDGUID: Guid;var QueryExpression: dotnet QueryExpression)
    var
        LinkEntity1: dotnet LinkEntity;
        LinkEntity2: dotnet LinkEntity;
        FilterExpression: dotnet FilterExpression;
    begin
        CreateLinkEntity(LinkEntity1,'systemuserroles','systemuserid','systemuser','systemuserid');

        CreateFilterExpression('systemuserid',UserIDGUID,FilterExpression);
        LinkEntity1.LinkCriteria(FilterExpression);

        CreateLinkEntity(LinkEntity2,'role','roleid','systemuserroles','roleid');
        LinkEntity2.LinkEntities.Add(LinkEntity1);

        CreateQueryExpression('role','roleid','roleid',RoleIDGUID,LinkEntity2,QueryExpression);
    end;


    procedure CreateAnyRoleToUserIDQueryExpression(UserIDGUID: Guid;var QueryExpression: dotnet QueryExpression)
    var
        LinkEntity1: dotnet LinkEntity;
        FilterExpression: dotnet FilterExpression;
        ColumnSet: dotnet ColumnSet;
    begin
        CreateLinkEntity(LinkEntity1,'role','roleid','systemuserroles','roleid');

        CreateFilterExpression('systemuserid',UserIDGUID,FilterExpression);
        LinkEntity1.LinkCriteria(FilterExpression);

        QueryExpression := QueryExpression.QueryExpression('role');
        QueryExpression.ColumnSet(ColumnSet.ColumnSet);
        QueryExpression.LinkEntities.Add(LinkEntity1);
    end;

    local procedure CheckSolutionPresence(var OrganizationServiceProxy: dotnet OrganizationServiceProxy): Boolean
    var
        ColumnSet: dotnet ColumnSet;
        QueryExpression: dotnet QueryExpression;
        ConditionExpression: dotnet ConditionExpression;
        ConditionOperator: dotnet ConditionOperator;
        EntityCollection: dotnet EntityCollection;
    begin
        QueryExpression := QueryExpression.QueryExpression('solution');
        ColumnSet := ColumnSet.ColumnSet;
        QueryExpression.ColumnSet(ColumnSet);
        ConditionExpression :=
          ConditionExpression.ConditionExpression('uniquename',ConditionOperator.Equal,MicrosoftDynamicsNavIntegrationTxt);
        QueryExpression.Criteria.AddCondition(ConditionExpression);
        if not ProcessQueryExpression(OrganizationServiceProxy,EntityCollection,QueryExpression) then
          ProcessConnectionFailures;
        exit(EntityCollection.Entities.Count > 0);
    end;


    procedure CheckModifyCRMConnectionURL(var ServerAddress: Text[250])
    var
        CRMSetupDefaults: Codeunit "CRM Setup Defaults";
        UriHelper: dotnet Uri;
        UriHelper2: dotnet Uri;
        UriKindHelper: dotnet UriKind;
        UriPartialHelper: dotnet UriPartial;
        ProposedUri: Text[250];
    begin
        if (ServerAddress = '') or (ServerAddress = '@@test@@') then
          exit;

        ServerAddress := DelChr(ServerAddress,'<>');

        if not UriHelper.TryCreate(ServerAddress,UriKindHelper.Absolute,UriHelper2) then
          if not UriHelper.TryCreate('https://' + ServerAddress,UriKindHelper.Absolute,UriHelper2) then
            Error(InvalidUriErr);

        if UriHelper2.Scheme <> 'https' then begin
          if not CRMSetupDefaults.GetAllowNonSecureConnections then
            Error(MustUseHttpsErr);
          if UriHelper2.Scheme <> 'http' then
            Error(StrSubstNo(MustUseHttpOrHttpsErr,UriHelper2.Scheme))
        end;

        ProposedUri := UriHelper2.GetLeftPart(UriPartialHelper.Authority);

        if Lowercase(ServerAddress) <> Lowercase(ProposedUri) then begin
          if Confirm(StrSubstNo(ReplaceServerAddressQst,ServerAddress,ProposedUri)) then
            ServerAddress := ProposedUri;
        end;
    end;


    procedure CreateQueryExpression(EntityName: Text;Column: Text;ConditionField: Text;ConditionFieldValue: Text;LinkEntity: dotnet LinkEntity;var QueryExpression: dotnet QueryExpression)
    var
        ColumnSet: dotnet ColumnSet;
        FilterExpression: dotnet FilterExpression;
    begin
        ColumnSet := ColumnSet.ColumnSet;
        if Column <> '' then
          ColumnSet.AddColumn(Column);
        CreateFilterExpression(ConditionField,ConditionFieldValue,FilterExpression);
        QueryExpression := QueryExpression.QueryExpression(EntityName);
        QueryExpression.ColumnSet(ColumnSet);
        if not IsNull(LinkEntity) then
          QueryExpression.LinkEntities.Add(LinkEntity);
        QueryExpression.Criteria(FilterExpression);
    end;

    local procedure CheckRoleAssignedToUser(var OrganizationServiceProxy: dotnet OrganizationServiceProxy;UserIDGUID: Guid;RoleIDGUID: Guid): Boolean
    var
        QueryExpression: dotnet QueryExpression;
        EntityCollection: dotnet EntityCollection;
    begin
        CreateRoleToUserIDQueryExpression(UserIDGUID,RoleIDGUID,QueryExpression);
        if not ProcessQueryExpression(OrganizationServiceProxy,EntityCollection,QueryExpression) then
          ProcessConnectionFailures;
        exit(EntityCollection.Entities.Count > 0);
    end;

    local procedure CheckAnyRoleAssignedToUser(var OrganizationServiceProxy: dotnet OrganizationServiceProxy;UserIDGUID: Guid): Boolean
    var
        QueryExpression: dotnet QueryExpression;
        EntityCollection: dotnet EntityCollection;
    begin
        CreateAnyRoleToUserIDQueryExpression(UserIDGUID,QueryExpression);
        if not ProcessQueryExpression(OrganizationServiceProxy,EntityCollection,QueryExpression) then
          ProcessConnectionFailures;
        exit(EntityCollection.Entities.Count > 0);
    end;


    procedure ConstructConnectionStringForSolutionImport(ServerAddress: Text): Text
    var
        FirstPart: Text;
        SecondPart: Text;
        FirstLevel: Integer;
    begin
        FirstLevel := StrPos(ServerAddress,'.');
        FirstPart := CopyStr(ServerAddress,1,FirstLevel);
        SecondPart := CopyStr(ServerAddress,FirstLevel);
        exit(StrSubstNo(ImportSolutionConnectStringTok,FirstPart,SecondPart));
    end;

    [TryFunction]
    local procedure InitializeCRMConnection(URI: dotnet Uri;HomeRealmURI: dotnet Uri;ClientCredentials: dotnet ClientCredentials;DevCred: dotnet ClientCredentials;var CRMHelper: dotnet CrmHelper;var OrganizationServiceProxy: dotnet OrganizationServiceProxy)
    begin
        OrganizationServiceProxy := CRMHelper.InitializeServiceProxy(URI,HomeRealmURI,ClientCredentials,DevCred);
    end;

    [TryFunction]
    local procedure ProcessQueryExpression(var OrganizationServiceProxy: dotnet OrganizationServiceProxy;var EntityCollection: dotnet EntityCollection;QueryExpression: dotnet QueryExpression)
    begin
        EntityCollection := OrganizationServiceProxy.RetrieveMultiple(QueryExpression);
    end;

    local procedure ProcessConnectionFailures()
    var
        DotNetExceptionHandler: Codeunit "DotNet Exception Handler";
        FaultException: dotnet FaultException;
        FileNotFoundException: dotnet FileNotFoundException;
        CRMHelper: dotnet CrmHelper;
    begin
        DotNetExceptionHandler.Collect;

        if DotNetExceptionHandler.TryCastToType(GetDotNetType(FaultException)) then
          Error(AdminEmailPasswordWrongErr);
        if DotNetExceptionHandler.TryCastToType(GetDotNetType(FileNotFoundException)) then
          Error(CRMSolutionFileNotFoundErr);
        if DotNetExceptionHandler.TryCastToType(CRMHelper.OrganizationServiceFaultExceptionType) then
          Error(AdminUserDoesNotHavePriviligesErr);
        if DotNetExceptionHandler.TryCastToType(CRMHelper.SystemNetWebException) then
          Error(CRMConnectionURLWrongErr);
        DotNetExceptionHandler.Rethrow;
    end;


    procedure SetupItemAvailabilityService()
    var
        TenantWebService: Record "Tenant Web Service";
        WebServiceManagement: Codeunit "Web Service Management";
    begin
        WebServiceManagement.CreateTenantWebService(
          TenantWebService."object type"::Page,Page::"Product Item Availability",'ProductItemAvailability',true);
    end;

    local procedure GetIntegrationAdminRoleID(): Text
    begin
        exit('8c8d4f51-a72b-e511-80d9-3863bb349780');
    end;

    local procedure GetIntegrationUserRoleID(): Text
    begin
        exit('6f960e32-a72b-e511-80d9-3863bb349780');
    end;
}

