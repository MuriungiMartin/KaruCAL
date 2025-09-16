#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5345 "Integration Rec. Synch. Invoke"
{

    trigger OnRun()
    begin
        CheckContext;
        SynchRecord(
          IntegrationTableMappingContext,SourceRecordRefContext,DestinationRecordRefContext,
          IntegrationRecordSynchContext,SynchActionContext,IgnoreSynchOnlyCoupledRecordsContext,
          JobIdContext,IntegrationTableConnectionTypeContext);
    end;

    var
        IntegrationTableMappingContext: Record "Integration Table Mapping";
        IntegrationRecordSynchContext: Codeunit "Integration Record Synch.";
        SourceRecordRefContext: RecordRef;
        DestinationRecordRefContext: RecordRef;
        IntegrationTableConnectionTypeContext: TableConnectionType;
        JobIdContext: Guid;
        SynchActionType: Option "None",Insert,Modify,ForceModify,IgnoreUnchanged,Fail,Skip;
        BothDestinationAndSourceIsNewerErr: label 'Cannot update the %2 record because both the %1 record and the %2 record have been changed.', Comment='%1 = Source record table caption, %2 destination table caption';
        DestinationRecordIsNewerThanSourceErr: label 'Cannot update the %2 record because it has a later modified date than the %1 record.', Comment='%1 = Source Table Caption, %2 = Destination Table Caption';
        InsertFailedErr: label 'Inserting %1 failed because of the following error: %2.', Comment='%1 = Table Caption, %2 = Error from insert process.';
        ModifyFailedErr: label 'Modifying %1 failed because of the following error: %2.', Comment='%1 = Table Caption, %2 = Error from modify process.';
        ConfigurationTemplateNotFoundErr: label 'The %1 %2 was not found.', Comment='%1 = Configuration Template table caption, %2 = Configuration Template Name';
        CoupledRecordIsDeletedErr: label 'The %1 record cannot be updated because it is coupled to a deleted record.', Comment='1% = Source Table Caption';
        CopyDataErr: label 'The data could not be updated because of the following error: %1.', Comment='%1 = Error message from transferdata process.';
        IntegrationRecordNotFoundErr: label 'The integration record for %1 was not found.', Comment='%1 = Internationalized RecordID, such as ''Customer 1234''';
        SynchActionContext: Option;
        IgnoreSynchOnlyCoupledRecordsContext: Boolean;
        IsContextInitialized: Boolean;
        ContextErr: label 'The integration record synchronization context has not been initialized.';


    procedure SetContext(IntegrationTableMapping: Record "Integration Table Mapping";SourceRecordRef: RecordRef;DestinationRecordRef: RecordRef;IntegrationRecordSynch: Codeunit "Integration Record Synch.";SynchAction: Option;IgnoreSynchOnlyCoupledRecords: Boolean;JobId: Guid;IntegrationTableConnectionType: TableConnectionType)
    begin
        IntegrationTableMappingContext := IntegrationTableMapping;
        IntegrationRecordSynchContext := IntegrationRecordSynch;
        SourceRecordRefContext := SourceRecordRef;
        DestinationRecordRefContext := DestinationRecordRef;
        SynchActionContext := SynchAction;
        IgnoreSynchOnlyCoupledRecordsContext := IgnoreSynchOnlyCoupledRecords;
        IntegrationTableConnectionTypeContext := IntegrationTableConnectionType;
        JobIdContext := JobId;
        IsContextInitialized := true;
    end;


    procedure GetContext(var IntegrationTableMapping: Record "Integration Table Mapping";var SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;var IntegrationRecordSynch: Codeunit "Integration Record Synch.";var SynchAction: Option)
    begin
        CheckContext;
        IntegrationTableMapping := IntegrationTableMappingContext;
        IntegrationRecordSynch := IntegrationRecordSynchContext;
        SourceRecordRef := SourceRecordRefContext;
        DestinationRecordRef := DestinationRecordRefContext;
        SynchAction := SynchActionContext;
    end;


    procedure WasModifiedAfterLastSynch(IntegrationTableMapping: Record "Integration Table Mapping";RecordRef: RecordRef): Boolean
    var
        IntegrationRecordManagement: Codeunit "Integration Record Management";
        LastModifiedOn: DateTime;
    begin
        LastModifiedOn := GetRowLastModifiedOn(IntegrationTableMapping,RecordRef);
        if IntegrationTableMapping."Integration Table ID" = RecordRef.Number then
          exit(
            IntegrationRecordManagement.IsModifiedAfterIntegrationTableRecordLastSynch(
              Tableconnectiontype::CRM,RecordRef.Field(IntegrationTableMapping."Integration Table UID Fld. No.").Value,
              IntegrationTableMapping."Table ID",LastModifiedOn));

        exit(IntegrationRecordManagement.IsModifiedAfterRecordLastSynch(Tableconnectiontype::CRM,RecordRef.RecordId,LastModifiedOn));
    end;


    procedure GetRowLastModifiedOn(IntegrationTableMapping: Record "Integration Table Mapping";FromRecordRef: RecordRef): DateTime
    var
        IntegrationRecord: Record "Integration Record";
        ModifiedFieldRef: FieldRef;
    begin
        if FromRecordRef.Number = IntegrationTableMapping."Integration Table ID" then begin
          ModifiedFieldRef := FromRecordRef.Field(IntegrationTableMapping."Int. Tbl. Modified On Fld. No.");
          exit(ModifiedFieldRef.Value);
        end;

        if IntegrationRecord.FindByRecordId(FromRecordRef.RecordId) then
          exit(IntegrationRecord."Modified On");
        Error(IntegrationRecordNotFoundErr,Format(FromRecordRef.RecordId,0,1));
    end;

    local procedure CheckContext()
    begin
        if not IsContextInitialized then
          Error(ContextErr);
    end;

    local procedure SynchRecord(var IntegrationTableMapping: Record "Integration Table Mapping";var SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;var IntegrationRecordSynch: Codeunit "Integration Record Synch.";var SynchAction: Option;IgnoreSynchOnlyCoupledRecords: Boolean;JobId: Guid;IntegrationTableConnectionType: TableConnectionType)
    var
        AdditionalFieldsModified: Boolean;
        SourceWasChanged: Boolean;
        WasModified: Boolean;
        ConflictText: Text;
    begin
        // Find the coupled record or prepare a new one
        if not GetCoupledRecord(
             IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,SynchAction,JobId,IntegrationTableConnectionType)
        then begin
          if SynchAction = Synchactiontype::Fail then
            exit;
          if IntegrationTableMapping."Synch. Only Coupled Records" and not IgnoreSynchOnlyCoupledRecords then begin
            SynchAction := Synchactiontype::Skip;
            exit;
          end;
          PrepareNewDestination(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);
          SynchAction := Synchactiontype::Insert;
        end;

        if SynchAction = Synchactiontype::Insert then
          SourceWasChanged := true
        else begin
          SourceWasChanged := WasModifiedAfterLastSynch(IntegrationTableMapping,SourceRecordRef);
          ConflictText :=
            ChangedDestinationConflictsWithSource(
              IntegrationTableMapping,DestinationRecordRef,SourceWasChanged,SynchAction);
        end;

        if not (SynchAction in [Synchactiontype::Insert,Synchactiontype::Modify,Synchactiontype::ForceModify]) then
          exit;

        if SourceWasChanged or (ConflictText <> '') or (SynchAction = Synchactiontype::ForceModify) then
          TransferFields(
            IntegrationRecordSynch,SourceRecordRef,DestinationRecordRef,SynchAction,AdditionalFieldsModified,JobId,ConflictText <> '');

        WasModified := IntegrationRecordSynch.GetWasModified or AdditionalFieldsModified;
        if WasModified then
          if ConflictText <> '' then begin
            SynchAction := Synchactiontype::Fail;
            LogSynchError(
              SourceRecordRef,DestinationRecordRef,
              StrSubstNo(ConflictText,SourceRecordRef.Caption,DestinationRecordRef.Caption),JobId);
            exit;
          end;
        if (SynchAction = Synchactiontype::Modify) and (not WasModified) then
          SynchAction := Synchactiontype::IgnoreUnchanged;

        case SynchAction of
          Synchactiontype::Insert:
            InsertRecord(
              IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,SynchAction,JobId,IntegrationTableConnectionType);
          Synchactiontype::Modify,
          Synchactiontype::ForceModify:
            ModifyRecord(
              IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,SynchAction,JobId,IntegrationTableConnectionType);
          Synchactiontype::IgnoreUnchanged:
            UpdateIntegrationRecordCoupling(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IntegrationTableConnectionType);
        end;
    end;

    local procedure InsertRecord(var IntegrationTableMapping: Record "Integration Table Mapping";var SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;var SynchAction: Option;JobId: Guid;IntegrationTableConnectionType: TableConnectionType)
    var
        TextManagement: Codeunit "Filter Tokens";
    begin
        OnBeforeInsertRecord(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);
        if DestinationRecordRef.Insert(true) then begin
          ApplyConfigTemplate(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,JobId,SynchAction);
          if SynchAction <> Synchactiontype::Fail then begin
            UpdateIntegrationRecordCoupling(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IntegrationTableConnectionType);
            OnAfterInsertRecord(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);
          end;
        end else begin
          SynchAction := Synchactiontype::Fail;
          LogSynchError(
            SourceRecordRef,DestinationRecordRef,
            StrSubstNo(InsertFailedErr,DestinationRecordRef.Caption,TextManagement.RemoveMessageTrailingDots(GetLastErrorText)),JobId);
        end;
        Commit;
    end;

    local procedure ModifyRecord(var IntegrationTableMapping: Record "Integration Table Mapping";var SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;var SynchAction: Option;JobId: Guid;IntegrationTableConnectionType: TableConnectionType)
    var
        TextManagement: Codeunit "Filter Tokens";
    begin
        OnBeforeModifyRecord(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);

        if DestinationRecordRef.Modify(true) then begin
          UpdateIntegrationRecordCoupling(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IntegrationTableConnectionType);
          OnAfterModifyRecord(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);
        end else begin
          SynchAction := Synchactiontype::Fail;
          LogSynchError(
            SourceRecordRef,DestinationRecordRef,
            StrSubstNo(ModifyFailedErr,DestinationRecordRef.Caption,TextManagement.RemoveMessageTrailingDots(GetLastErrorText)),JobId);
        end;
        Commit;
    end;

    local procedure ApplyConfigTemplate(var IntegrationTableMapping: Record "Integration Table Mapping";var SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;JobId: Guid;var SynchAction: Option)
    var
        ConfigTemplateHeader: Record "Config. Template Header";
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        ConfigTemplateCode: Code[10];
    begin
        if DestinationRecordRef.Number = IntegrationTableMapping."Integration Table ID" then
          ConfigTemplateCode := IntegrationTableMapping."Int. Tbl. Config Template Code"
        else
          ConfigTemplateCode := IntegrationTableMapping."Table Config Template Code";
        if ConfigTemplateCode <> '' then begin
          OnBeforeApplyRecordTemplate(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,ConfigTemplateCode);

          if ConfigTemplateHeader.Get(ConfigTemplateCode) then begin
            ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader,DestinationRecordRef);

            OnAfterApplyRecordTemplate(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);
          end else begin
            SynchAction := Synchactiontype::Fail;
            LogSynchError(
              SourceRecordRef,DestinationRecordRef,
              StrSubstNo(ConfigurationTemplateNotFoundErr,ConfigTemplateHeader.TableCaption,ConfigTemplateCode),JobId);
          end;
        end;
    end;

    local procedure ChangedDestinationConflictsWithSource(IntegrationTableMapping: Record "Integration Table Mapping";DestinationRecordRef: RecordRef;SourceWasChanged: Boolean;SynchAction: Option) ConflictText: Text
    var
        DestinationWasChanged: Boolean;
    begin
        DestinationWasChanged := false;
        if IntegrationTableMapping.Direction = IntegrationTableMapping.Direction::Bidirectional then
          DestinationWasChanged := WasModifiedAfterLastSynch(IntegrationTableMapping,DestinationRecordRef);
        if DestinationWasChanged and (SynchAction <> Synchactiontype::ForceModify) then begin
          if SourceWasChanged then
            ConflictText := BothDestinationAndSourceIsNewerErr;
          ConflictText := DestinationRecordIsNewerThanSourceErr;
        end;
    end;

    local procedure GetCoupledRecord(var IntegrationTableMapping: Record "Integration Table Mapping";var RecordRef: RecordRef;var CoupledRecordRef: RecordRef;var SynchAction: Option;JobId: Guid;IntegrationTableConnectionType: TableConnectionType) RecordFound: Boolean
    var
        IsDestinationMarkedAsDeleted: Boolean;
    begin
        IsDestinationMarkedAsDeleted := false;
        RecordFound :=
          FindRecord(
            IntegrationTableMapping,RecordRef,CoupledRecordRef,IsDestinationMarkedAsDeleted,IntegrationTableConnectionType);

        if RecordFound then begin
          if SynchAction <> Synchactiontype::ForceModify then
            SynchAction := Synchactiontype::Modify;
          if IsDestinationMarkedAsDeleted then begin
            RecordFound := false;
            SynchAction := Synchactiontype::Fail;
            LogSynchError(RecordRef,CoupledRecordRef,StrSubstNo(CoupledRecordIsDeletedErr,RecordRef.Caption),JobId);
          end;
        end;
    end;

    local procedure FindRecord(var IntegrationTableMapping: Record "Integration Table Mapping";var SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;var IsDestinationDeleted: Boolean;IntegrationTableConnectionType: TableConnectionType) RecordFound: Boolean
    var
        IntegrationRecordManagement: Codeunit "Integration Record Management";
        IDFieldRef: FieldRef;
        RecordIDValue: RecordID;
    begin
        if SourceRecordRef.Number = IntegrationTableMapping."Table ID" then // NAV -> Integration Table synch
          RecordFound :=
            FindIntegrationTableRecord(
              IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IsDestinationDeleted,IntegrationTableConnectionType)
        else begin  // Integration Table -> NAV synch
          IDFieldRef := SourceRecordRef.Field(IntegrationTableMapping."Integration Table UID Fld. No.");
          RecordFound :=
            IntegrationRecordManagement.FindRecordIdByIntegrationTableUid(
              IntegrationTableConnectionType,IDFieldRef.Value,IntegrationTableMapping."Table ID",RecordIDValue);
          if RecordFound then
            IsDestinationDeleted := not DestinationRecordRef.Get(RecordIDValue);
        end;
        // If no explicit coupling is found, attempt to find a match based on user data
        if not RecordFound then
          RecordFound :=
            FindAndCoupleDestinationRecord(
              IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IsDestinationDeleted,IntegrationTableConnectionType);
    end;

    local procedure FindAndCoupleDestinationRecord(IntegrationTableMapping: Record "Integration Table Mapping";SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;var DestinationIsDeleted: Boolean;IntegrationTableConnectionType: TableConnectionType) DestinationFound: Boolean
    begin
        OnFindUncoupledDestinationRecord(
          IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,DestinationIsDeleted,DestinationFound);
        if DestinationFound then
          UpdateIntegrationRecordCoupling(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IntegrationTableConnectionType);
    end;

    local procedure FindIntegrationTableRecord(IntegrationTableMapping: Record "Integration Table Mapping";var SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;var IsDestinationDeleted: Boolean;IntegrationTableConnectionType: TableConnectionType) FoundDestination: Boolean
    var
        IntegrationRecordManagement: Codeunit "Integration Record Management";
        IDValue: Variant;
    begin
        FoundDestination :=
          IntegrationRecordManagement.FindIntegrationTableUIdByRecordId(IntegrationTableConnectionType,SourceRecordRef.RecordId,IDValue);

        if FoundDestination then
          IsDestinationDeleted := not IntegrationTableMapping.GetRecordRef(IDValue,DestinationRecordRef);
    end;

    local procedure PrepareNewDestination(var IntegrationTableMapping: Record "Integration Table Mapping";var RecordRef: RecordRef;var CoupledRecordRef: RecordRef)
    begin
        CoupledRecordRef.Close;

        if RecordRef.Number = IntegrationTableMapping."Table ID" then
          CoupledRecordRef.Open(IntegrationTableMapping."Integration Table ID")
        else
          CoupledRecordRef.Open(IntegrationTableMapping."Table ID");

        CoupledRecordRef.Init;
    end;

    local procedure LogSynchError(var SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;ErrorMessage: Text;JobId: Guid)
    var
        IntegrationSynchJobErrors: Record "Integration Synch. Job Errors";
        EmptyRecordID: RecordID;
    begin
        if DestinationRecordRef.Number = 0 then begin
          EmptyRecordID := SourceRecordRef.RecordId;
          Clear(EmptyRecordID);
          IntegrationSynchJobErrors.LogSynchError(JobId,SourceRecordRef.RecordId,EmptyRecordID,ErrorMessage)
        end else begin
          IntegrationSynchJobErrors.LogSynchError(JobId,SourceRecordRef.RecordId,DestinationRecordRef.RecordId,ErrorMessage);

          // Close destination - it is in error state and can no longer be used.
          DestinationRecordRef.Close;
        end;
    end;

    local procedure TransferFields(var IntegrationRecordSynch: Codeunit "Integration Record Synch.";var SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;var SynchAction: Option;var AdditionalFieldsModified: Boolean;JobId: Guid;ConflictFound: Boolean)
    var
        TextManagement: Codeunit "Filter Tokens";
    begin
        OnBeforeTransferRecordFields(SourceRecordRef,DestinationRecordRef);

        IntegrationRecordSynch.SetParameters(SourceRecordRef,DestinationRecordRef,SynchAction <> Synchactiontype::Insert);
        if IntegrationRecordSynch.Run then begin
          if ConflictFound and IntegrationRecordSynch.GetWasModified then
            exit;
          OnAfterTransferRecordFields(SourceRecordRef,DestinationRecordRef,
            AdditionalFieldsModified,SynchAction <> Synchactiontype::Insert);
          AdditionalFieldsModified := AdditionalFieldsModified or IntegrationRecordSynch.GetWasModified;
        end else begin
          SynchAction := Synchactiontype::Fail;
          LogSynchError(
            SourceRecordRef,DestinationRecordRef,
            StrSubstNo(CopyDataErr,TextManagement.RemoveMessageTrailingDots(GetLastErrorText)),JobId);
          Commit;
        end;
    end;

    local procedure UpdateIntegrationRecordCoupling(var IntegrationTableMapping: Record "Integration Table Mapping";var SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;IntegrationTableConnectionType: TableConnectionType)
    var
        IntegrationRecordManagement: Codeunit "Integration Record Management";
        IntegrationManagement: Codeunit "Integration Management";
        RecordId: RecordID;
        IntegrationTableUidFieldRef: FieldRef;
        IntegrationTableUid: Variant;
        IntegrationTableModifiedOn: DateTime;
        ModifiedOn: DateTime;
    begin
        if IntegrationManagement.IsIntegrationRecordChild(IntegrationTableMapping."Table ID") then
          exit;
        if DestinationRecordRef.Number = IntegrationTableMapping."Integration Table ID" then begin
          RecordId := SourceRecordRef.RecordId;
          IntegrationTableUidFieldRef := DestinationRecordRef.Field(IntegrationTableMapping."Integration Table UID Fld. No.");
          IntegrationTableUid := IntegrationTableUidFieldRef.Value;
          IntegrationTableModifiedOn := GetRowLastModifiedOn(IntegrationTableMapping,DestinationRecordRef);
          ModifiedOn := GetRowLastModifiedOn(IntegrationTableMapping,SourceRecordRef);
        end else begin
          RecordId := DestinationRecordRef.RecordId;
          IntegrationTableUidFieldRef := SourceRecordRef.Field(IntegrationTableMapping."Integration Table UID Fld. No.");
          IntegrationTableUid := IntegrationTableUidFieldRef.Value;
          IntegrationTableModifiedOn := GetRowLastModifiedOn(IntegrationTableMapping,SourceRecordRef);
          ModifiedOn := GetRowLastModifiedOn(IntegrationTableMapping,DestinationRecordRef);
        end;

        IntegrationRecordManagement.UpdateIntegrationTableCoupling(
          IntegrationTableConnectionType,
          IntegrationTableUid,
          IntegrationTableModifiedOn,
          RecordId,
          ModifiedOn);
        Commit;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTransferRecordFields(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTransferRecordFields(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;var AdditionalFieldsWereModified: Boolean;DestinationIsInserted: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeModifyRecord(IntegrationTableMapping: Record "Integration Table Mapping";SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterModifyRecord(IntegrationTableMapping: Record "Integration Table Mapping";SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertRecord(IntegrationTableMapping: Record "Integration Table Mapping";SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertRecord(IntegrationTableMapping: Record "Integration Table Mapping";SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeApplyRecordTemplate(IntegrationTableMapping: Record "Integration Table Mapping";SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;var TemplateCode: Code[10])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterApplyRecordTemplate(IntegrationTableMapping: Record "Integration Table Mapping";SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFindUncoupledDestinationRecord(IntegrationTableMapping: Record "Integration Table Mapping";SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;var DestinationIsDeleted: Boolean;var DestinationFound: Boolean)
    begin
    end;
}

