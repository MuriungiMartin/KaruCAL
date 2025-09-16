#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5335 "Integration Table Synch."
{

    trigger OnRun()
    begin
    end;

    var
        IntegrationTableMappingHasNoMappedFieldsErr: label 'There are no field mapping rows for the %2 %3 in the %1 table.', Comment='%1="Integration Field Mapping" table caption, %2="Integration Field Mapping.Integration Table Mapping Name" field caption, %3 Integration Table Mapping value';
        IntegrationNotActivatedErr: label 'Integration Management must be activated before you can start the synchronization processes.';
        RecordMustBeIntegrationRecordErr: label 'Table %1 must be registered for integration.', Comment='%1 = Table caption';
        IntegrationRecordNotFoundErr: label 'The integration record for %1 was not found.', Comment='%1 = Internationalized RecordID, such as ''Customer 1234''';
        CurrentIntegrationSynchJob: Record "Integration Synch. Job";
        CurrentIntegrationTableMapping: Record "Integration Table Mapping";
        TempIntegrationFieldMapping: Record "Temp Integration Field Mapping" temporary;
        IntegrationTableConnectionType: TableConnectionType;
        SynchActionType: Option "None",Insert,Modify,ForceModify,IgnoreUnchanged,Fail,Skip;
        JobState: Option Ready,Created,"In Progress";
        UnableToDetectSynchDirectionErr: label 'The synchronization direction cannot be determined.';
        MappingDoesNotAllowDirectionErr: label 'The %1 %2 is not configured for %3 synchronization.', Comment='%1 = Integration Table Mapping caption, %2 Integration Table Mapping Name, %3 = the calculated synch. direction (FromIntegrationTable|ToIntegrationTable)';
        InvalidStateErr: label 'The synchronization process is in a state that is not valid.';
        DirectionChangeIsNotSupportedErr: label 'You cannot change the synchronization direction after a job has started.';


    procedure BeginIntegrationSynchJob(ConnectionType: TableConnectionType;IntegrationTableMapping: Record "Integration Table Mapping"): Boolean
    begin
        EnsureState(Jobstate::Ready);

        Clear(CurrentIntegrationSynchJob);
        Clear(CurrentIntegrationTableMapping);

        IntegrationTableConnectionType := ConnectionType;
        CurrentIntegrationTableMapping := IntegrationTableMapping;

        if StartIntegrationSynchJob(IntegrationTableMapping) then begin
          JobState := Jobstate::Created;
          exit(true);
        end;
    end;


    procedure Synchronize(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;IgnoreChanges: Boolean;IgnoreSynchOnlyCoupledRecords: Boolean): Boolean
    var
        IntegrationRecordSynch: Codeunit "Integration Record Synch.";
        IntegrationRecSynchInvoke: Codeunit "Integration Rec. Synch. Invoke";
        SynchDirection: Option;
        SynchAction: Option;
        ErrorMessage: Text;
    begin
        EnsureState(Jobstate::Created);

        if not DetermineSynchDirection(SourceRecordRef,CurrentIntegrationTableMapping,SynchDirection,ErrorMessage) then begin
          FinishIntegrationSynchJob(ErrorMessage);
          exit(false);
        end;

        // Ready to synch.
        Commit;

        // First synch. fixes direction
        if JobState = Jobstate::Created then begin
          CurrentIntegrationSynchJob."Synch. Direction" := SynchDirection;
          JobState := Jobstate::"In Progress";
          CurrentIntegrationSynchJob.Modify(true);

          BuildTempIntegrationFieldMapping(CurrentIntegrationTableMapping,SynchDirection,TempIntegrationFieldMapping);
          Commit;
        end else
          if SynchDirection <> CurrentIntegrationSynchJob."Synch. Direction" then
            Error(DirectionChangeIsNotSupportedErr);

        if IgnoreChanges then
          SynchAction := Synchactiontype::ForceModify
        else
          SynchAction := Synchactiontype::Skip;

        if not SourceRecordRef.IsEmpty then begin
          IntegrationRecordSynch.SetFieldMapping(TempIntegrationFieldMapping);
          IntegrationRecSynchInvoke.SetContext(
            CurrentIntegrationTableMapping,SourceRecordRef,DestinationRecordRef,
            IntegrationRecordSynch,SynchAction,IgnoreSynchOnlyCoupledRecords,CurrentIntegrationSynchJob.ID,
            IntegrationTableConnectionType);
          if not IntegrationRecSynchInvoke.Run then begin
            SynchAction := Synchactiontype::Fail;
            LogSynchError(SourceRecordRef,DestinationRecordRef,GetLastErrorText);
            IncrementSynchJobCounters(SynchAction);
            exit(false);
          end;
          IntegrationRecSynchInvoke.GetContext(
            CurrentIntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IntegrationRecordSynch,SynchAction);

          IncrementSynchJobCounters(SynchAction);
        end;

        exit(true);
    end;


    procedure EndIntegrationSynchJob(): Guid
    begin
        if CurrentIntegrationSynchJob."Finish Date/Time" = 0DT then
          FinishIntegrationSynchJob('');

        JobState := Jobstate::Ready;
        exit(CurrentIntegrationSynchJob.ID);
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

    local procedure EnsureState(RequiredState: Option)
    begin
        if (JobState = Jobstate::"In Progress") and (RequiredState = Jobstate::Created) then
          exit;

        if RequiredState <> JobState then
          Error(InvalidStateErr);
    end;

    local procedure DetermineSynchDirection(SourceRecordRef: RecordRef;IntegrationTableMapping: Record "Integration Table Mapping";var SynchDirection: Option;var ErrorMessage: Text): Boolean
    var
        DummyIntegrationTableMapping: Record "Integration Table Mapping";
        TempSynchDirection: Option;
    begin
        ErrorMessage := '';
        case SourceRecordRef.Number of
          IntegrationTableMapping."Table ID":
            TempSynchDirection := IntegrationTableMapping.Direction::ToIntegrationTable;
          IntegrationTableMapping."Integration Table ID":
            TempSynchDirection := IntegrationTableMapping.Direction::FromIntegrationTable;
          else begin
            ErrorMessage := UnableToDetectSynchDirectionErr;
            exit(false);
          end;
        end;

        if not (IntegrationTableMapping.Direction in [TempSynchDirection,IntegrationTableMapping.Direction::Bidirectional]) then begin
          DummyIntegrationTableMapping.Direction := TempSynchDirection;
          ErrorMessage :=
            StrSubstNo(
              MappingDoesNotAllowDirectionErr,IntegrationTableMapping.TableCaption,IntegrationTableMapping.Name,
              DummyIntegrationTableMapping.Direction);
          exit(false);
        end;

        SynchDirection := TempSynchDirection;
        exit(true);
    end;

    local procedure StartIntegrationSynchJob(IntegrationTableMapping: Record "Integration Table Mapping"): Boolean
    begin
        CreateIntegrationSynchJobEntry(IntegrationTableMapping.Name,IntegrationTableMapping.Direction);

        if EnsureIntegrationServicesState(IntegrationTableMapping) then begin // Prepare for processing
          Commit;
          exit(true);
        end;
    end;

    local procedure FinishIntegrationSynchJob(FinalMessage: Text)
    begin
        with CurrentIntegrationSynchJob do begin
          if FinalMessage <> '' then
            Message := CopyStr(FinalMessage,1,MaxStrLen(Message));
          "Finish Date/Time" := CurrentDatetime;
          Modify(true);
        end;
        Commit;
    end;

    local procedure CreateIntegrationSynchJobEntry(MappingName: Code[20];MappingDirection: Option)
    begin
        with CurrentIntegrationSynchJob do
          if IsEmpty or IsNullGuid(ID) then begin
            Reset;
            Init;
            ID := CreateGuid;
            "Start Date/Time" := CurrentDatetime;
            "Integration Table Mapping Name" := MappingName;
            "Synch. Direction" := MappingDirection;
            Insert(true);
            Commit;
          end;
    end;

    local procedure EnsureIntegrationServicesState(var IntegrationTableMapping: Record "Integration Table Mapping"): Boolean
    var
        IntegrationManagement: Codeunit "Integration Management";
    begin
        if not IntegrationManagement.IsIntegrationActivated then begin
          FinishIntegrationSynchJob(IntegrationNotActivatedErr);
          exit(false);
        end;

        if IntegrationManagement.IsIntegrationRecord(IntegrationTableMapping."Table ID") then
          exit(true);

        if IntegrationManagement.IsIntegrationRecordChild(IntegrationTableMapping."Table ID") then
          exit(true);

        FinishIntegrationSynchJob(StrSubstNo(RecordMustBeIntegrationRecordErr,IntegrationTableMapping."Table ID"));
        exit(false);
    end;

    local procedure BuildTempIntegrationFieldMapping(var IntegrationTableMapping: Record "Integration Table Mapping";SynchDirection: Option;var TempIntegrationFieldMapping: Record "Temp Integration Field Mapping")
    var
        IntegrationFieldMapping: Record "Integration Field Mapping";
    begin
        with IntegrationFieldMapping do begin
          SetRange("Integration Table Mapping Name",IntegrationTableMapping.Name);
          SetFilter(Direction,'%1|%2',SynchDirection,Direction::Bidirectional);
          if IsEmpty then
            Error(
              IntegrationTableMappingHasNoMappedFieldsErr,TableCaption,
              FieldCaption("Integration Table Mapping Name"),IntegrationTableMapping.Name);

          TempIntegrationFieldMapping.DeleteAll;
          FindSet;
          repeat
            TempIntegrationFieldMapping.Init;
            TempIntegrationFieldMapping."No." := "No.";
            TempIntegrationFieldMapping."Integration Table Mapping Name" := "Integration Table Mapping Name";
            TempIntegrationFieldMapping."Constant Value" := "Constant Value";
            if SynchDirection = IntegrationTableMapping.Direction::ToIntegrationTable then begin
              TempIntegrationFieldMapping."Source Field No." := "Field No.";
              TempIntegrationFieldMapping."Destination Field No." := "Integration Table Field No.";
              TempIntegrationFieldMapping."Validate Destination Field" := "Validate Integration Table Fld";
            end else begin
              TempIntegrationFieldMapping."Source Field No." := "Integration Table Field No.";
              TempIntegrationFieldMapping."Destination Field No." := "Field No.";
              TempIntegrationFieldMapping."Validate Destination Field" := "Validate Field";
            end;
            TempIntegrationFieldMapping.Insert;
          until Next = 0;
        end;
    end;

    local procedure LogSynchError(var SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;ErrorMessage: Text)
    var
        IntegrationSynchJobErrors: Record "Integration Synch. Job Errors";
        DummyEmptyRecordID: RecordID;
    begin
        if DestinationRecordRef.Number = 0 then
          IntegrationSynchJobErrors.LogSynchError(
            CurrentIntegrationSynchJob.ID,SourceRecordRef.RecordId,DummyEmptyRecordID,ErrorMessage)
        else begin
          IntegrationSynchJobErrors.LogSynchError(
            CurrentIntegrationSynchJob.ID,SourceRecordRef.RecordId,DestinationRecordRef.RecordId,ErrorMessage);

          // Close destination - it is in error state and can no longer be used.
          DestinationRecordRef.Close;
        end;
    end;

    local procedure CountSynchActionIn(ExpectedSynchActionValue: Option;ActualSynchActionValue: Option): Integer
    begin
        if ActualSynchActionValue = ExpectedSynchActionValue then
          exit(1);
        exit(0);
    end;

    local procedure IncrementSynchJobCounters(SynchAction: Option)
    begin
        with CurrentIntegrationSynchJob do begin
          Inserted += CountSynchActionIn(Synchactiontype::Insert,SynchAction);
          Modified +=
            (CountSynchActionIn(Synchactiontype::Modify,SynchAction) + CountSynchActionIn(Synchactiontype::ForceModify,SynchAction));
          Unchanged += CountSynchActionIn(Synchactiontype::IgnoreUnchanged,SynchAction);
          Skipped += CountSynchActionIn(Synchactiontype::Skip,SynchAction);
          Failed += CountSynchActionIn(Synchactiontype::Fail,SynchAction);
          Modify;
          Commit;
        end;
    end;
}

