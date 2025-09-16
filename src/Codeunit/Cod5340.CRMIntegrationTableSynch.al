#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5340 "CRM Integration Table Synch."
{
    TableNo = "Integration Table Mapping";

    trigger OnRun()
    var
        CRMConnectionSetup: Record "CRM Connection Setup";
        "Field": Record "Field";
        ConnectionName: Text;
    begin
        ConnectionName := InitConnection;

        if "Int. Table UID Field Type" = Field.Type::Option then
          SynchOption(Rec)
        else begin
          if Direction in [Direction::ToIntegrationTable,Direction::Bidirectional] then
            PerformScheduledSynchToIntegrationTable(Rec);
          if Direction in [Direction::FromIntegrationTable,Direction::Bidirectional] then
            PerformScheduledSynchFromIntegrationTable(Rec,CRMConnectionSetup.GetIntegrationUserID);
        end;

        CloseConnection(ConnectionName);
    end;

    var
        ConnectionNotEnabledErr: label 'The Microsoft Dynamics CRM connection is not enabled.';
        RecordNotFoundErr: label 'Cannot find %1 record %2.', Comment='%1 = Source table caption, %2 = The lookup value when searching for the source record';
        SourceRecordIsNotInMappingErr: label 'Cannot find the mapping %2 in table %1.', Comment='%1 Integration Table Mapping caption, %2 Integration Table Mapping Name';
        CannotDetermineSourceOriginErr: label 'Cannot determine the source origin: %1.', Comment='%1 the value of the source id';
        SynchronizeEmptySetErr: label 'Attempted to synchronize an empty set of records.';
        CRMIntTableSubscriber: Codeunit "CRM Int. Table. Subscriber";
        SupportedSourceType: Option ,RecordID,Guid;
        NoMappingErr: label 'No mapping is set for %1.', Comment='%1=Table Caption';

    local procedure InitConnection() ConnectionName: Text
    var
        CRMConnectionSetup: Record "CRM Connection Setup";
    begin
        CRMConnectionSetup.Get;
        if not CRMConnectionSetup."Is Enabled" then
          Error(ConnectionNotEnabledErr);

        ConnectionName := RegisterTempConnectionIfNeeded(CRMConnectionSetup);
        if ConnectionName <> '' then
          SetDefaultTableConnection(Tableconnectiontype::CRM,ConnectionName,true);
        ClearCache;
    end;

    local procedure CloseConnection(ConnectionName: Text)
    var
        CRMConnectionSetup: Record "CRM Connection Setup";
    begin
        ClearCache;
        if ConnectionName <> '' then
          CRMConnectionSetup.UnregisterConnectionWithName(ConnectionName);
    end;

    local procedure ClearCache()
    begin
        CRMIntTableSubscriber.ClearCache;
        Clear(CRMIntTableSubscriber);
    end;

    local procedure CacheTable(var RecordRef: RecordRef;var TempRecordRef: RecordRef)
    var
        OutlookSynchNAVMgt: Codeunit "Outlook Synch. NAV Mgt";
    begin
        TempRecordRef.Open(RecordRef.Number,true);
        if RecordRef.FindSet then
          repeat
            OutlookSynchNAVMgt.CopyRecordReference(RecordRef,TempRecordRef,false);
          until RecordRef.Next = 0;
        RecordRef.Close;
    end;

    local procedure CacheFilteredCRMTable(TempSourceRecordRef: RecordRef;IntegrationTableMapping: Record "Integration Table Mapping";IntegrationUserId: Guid)
    var
        CRMRecordRef: RecordRef;
        ModifyByFieldRef: FieldRef;
    begin
        CRMRecordRef.Open(IntegrationTableMapping."Integration Table ID");
        IntegrationTableMapping.SetIntRecordRefFilter(CRMRecordRef);
        // Exclude modifications by background job
        ModifyByFieldRef := CRMRecordRef.Field(GetModifyByFieldNo(IntegrationTableMapping."Integration Table ID"));
        ModifyByFieldRef.SetFilter('<>%1',IntegrationUserId);
        CacheTable(CRMRecordRef,TempSourceRecordRef);
        CRMRecordRef.Close;
    end;

    local procedure CacheFilteredNAVTable(TempSourceRecordRef: RecordRef;IntegrationTableMapping: Record "Integration Table Mapping")
    var
        SourceRecordRef: RecordRef;
    begin
        SourceRecordRef.Open(IntegrationTableMapping."Table ID");
        IntegrationTableMapping.SetRecordRefFilter(SourceRecordRef);
        CacheTable(SourceRecordRef,TempSourceRecordRef);
        SourceRecordRef.Close;
    end;

    local procedure GetSourceRecordRef(IntegrationTableMapping: Record "Integration Table Mapping";SourceID: Variant;var RecordRef: RecordRef)
    var
        RecordID: RecordID;
        CRMID: Guid;
    begin
        case GetSourceType(SourceID) of
          Supportedsourcetype::RecordID:
            begin
              RecordID := SourceID;
              if RecordID.TableNo = 0 then
                Error(CannotDetermineSourceOriginErr,SourceID);
              if not (RecordID.TableNo = IntegrationTableMapping."Table ID") then
                Error(SourceRecordIsNotInMappingErr,IntegrationTableMapping.TableCaption,IntegrationTableMapping.Name);
              if not RecordRef.Get(RecordID) then
                Error(RecordNotFoundErr,RecordRef.Caption,Format(RecordID,0,1));
            end;
          Supportedsourcetype::Guid:
            begin
              CRMID := SourceID;
              if IsNullGuid(CRMID) then
                Error(CannotDetermineSourceOriginErr,SourceID);
              if not IntegrationTableMapping.GetRecordRef(CRMID,RecordRef) then
                Error(RecordNotFoundErr,IntegrationTableMapping.GetExtendedIntegrationTableCaption,CRMID);
            end;
          else
            Error(CannotDetermineSourceOriginErr,SourceID);
        end;
    end;

    local procedure GetSourceType(Source: Variant): Integer
    begin
        if Source.IsRecordId then
          exit(Supportedsourcetype::RecordID);
        if Source.IsGuid then
          exit(Supportedsourcetype::Guid);
        exit(0);
    end;

    local procedure FillCodeBufferFromOption(FieldRef: FieldRef;var TempNameValueBuffer: Record "Name/Value Buffer" temporary): Boolean
    var
        TempNameValueBufferWithValue: Record "Name/Value Buffer" temporary;
    begin
        CollectOptionValues(FieldRef.OptionString,TempNameValueBuffer);
        CollectOptionValues(FieldRef.OptionCaption,TempNameValueBufferWithValue);
        MergeBuffers(TempNameValueBuffer,TempNameValueBufferWithValue);
        exit(TempNameValueBuffer.FindSet);
    end;

    local procedure FindModifiedIntegrationRecords(var IntegrationRecord: Record "Integration Record";IntegrationTableMapping: Record "Integration Table Mapping"): Boolean
    begin
        IntegrationRecord.SetRange("Table ID",IntegrationTableMapping."Table ID");
        if IntegrationTableMapping."Synch. Modified On Filter" <> 0DT then
          IntegrationRecord.SetFilter("Modified On",'>%1',IntegrationTableMapping."Synch. Modified On Filter");
        exit(IntegrationRecord.FindSet);
    end;

    local procedure CollectOptionValues(OptionString: Text;var TempNameValueBuffer: Record "Name/Value Buffer" temporary)
    var
        CommaPos: Integer;
        OptionValue: Text;
        OptionValueInt: Integer;
    begin
        OptionValueInt := 0;
        TempNameValueBuffer.DeleteAll;
        while StrLen(OptionString) > 0 do begin
          CommaPos := StrPos(OptionString,',');
          if CommaPos = 0 then begin
            OptionValue := OptionString;
            OptionString := '';
          end else begin
            OptionValue := CopyStr(OptionString,1,CommaPos - 1);
            OptionString := CopyStr(OptionString,CommaPos + 1);
          end;
          if DelChr(OptionValue,'=',' ') <> '' then begin
            TempNameValueBuffer.Init;
            TempNameValueBuffer.ID := OptionValueInt;
            TempNameValueBuffer.Name := CopyStr(OptionValue,1,MaxStrLen(TempNameValueBuffer.Name));
            TempNameValueBuffer.Insert
          end;
          OptionValueInt += 1;
        end;
    end;

    local procedure MergeBuffers(var TempNameValueBuffer: Record "Name/Value Buffer" temporary;var TempNameValueBufferWithValue: Record "Name/Value Buffer" temporary)
    begin
        with TempNameValueBuffer do begin
          if FindSet then
            repeat
              if TempNameValueBufferWithValue.Get(ID) then begin
                Value := TempNameValueBufferWithValue.Name;
                Modify
              end;
            until Next = 0;
          TempNameValueBufferWithValue.DeleteAll;
        end;
    end;


    procedure SynchOption(IntegrationTableMapping: Record "Integration Table Mapping")
    var
        CRMOptionMapping: Record "CRM Option Mapping";
        "Field": Record "Field";
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        FieldRef: FieldRef;
        KeyRef: KeyRef;
        RecordRef: RecordRef;
        NewPK: Text;
    begin
        if Field.Get(IntegrationTableMapping."Integration Table ID",IntegrationTableMapping."Integration Table UID Fld. No.") then
          if Field.Type = Field.Type::Option then begin
            RecordRef.Open(Field.TableNo);
            FieldRef := RecordRef.Field(Field."No.");
            RecordRef.Close;
            if FillCodeBufferFromOption(FieldRef,TempNameValueBuffer) then begin
              CRMOptionMapping.SetRange("Table ID",IntegrationTableMapping."Table ID");
              CRMOptionMapping.DeleteAll;

              RecordRef.Open(IntegrationTableMapping."Table ID");
              KeyRef := RecordRef.KeyIndex(1);
              FieldRef := KeyRef.FieldIndex(1);
              repeat
                NewPK := CopyStr(TempNameValueBuffer.Name,1,FieldRef.Length);
                FieldRef.SetRange(NewPK);
                if not RecordRef.FindFirst then begin
                  RecordRef.Init;
                  FieldRef.Value := NewPK;
                  RecordRef.Insert(true);
                end;

                CRMOptionMapping.Init;
                CRMOptionMapping."Record ID" := RecordRef.RecordId;
                CRMOptionMapping."Option Value" := TempNameValueBuffer.ID;
                CRMOptionMapping."Option Value Caption" := TempNameValueBuffer.Value;
                CRMOptionMapping."Table ID" := IntegrationTableMapping."Table ID";
                CRMOptionMapping."Integration Table ID" := IntegrationTableMapping."Integration Table ID";
                CRMOptionMapping."Integration Field ID" := IntegrationTableMapping."Integration Table UID Fld. No.";
                CRMOptionMapping.Insert;
              until TempNameValueBuffer.Next = 0;
              RecordRef.Close;
            end;
          end;
    end;


    procedure SynchRecord(IntegrationTableMapping: Record "Integration Table Mapping";SourceID: Variant;IgnoreChanges: Boolean;IgnoreSynchOnlyCoupledRecords: Boolean) JobID: Guid
    var
        IntegrationTableSynch: Codeunit "Integration Table Synch.";
        FromRecordRef: RecordRef;
        ToRecordRef: RecordRef;
        ConnectionName: Text;
    begin
        ConnectionName := InitConnection;

        IntegrationTableSynch.BeginIntegrationSynchJob(Tableconnectiontype::CRM,IntegrationTableMapping);
        GetSourceRecordRef(IntegrationTableMapping,SourceID,FromRecordRef);
        IntegrationTableSynch.Synchronize(FromRecordRef,ToRecordRef,IgnoreChanges,IgnoreSynchOnlyCoupledRecords);
        JobID := IntegrationTableSynch.EndIntegrationSynchJob;

        CloseConnection(ConnectionName);
    end;


    procedure SynchRecordsToIntegrationTable(RecordsToSynchRecordRef: RecordRef;IgnoreChanges: Boolean;IgnoreSynchOnlyCoupledRecords: Boolean) JobID: Guid
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        CRMSynchHelper: Codeunit "CRM Synch. Helper";
        IntegrationTableSynch: Codeunit "Integration Table Synch.";
        IntegrationRecordRef: RecordRef;
        ConnectionName: Text;
    begin
        if RecordsToSynchRecordRef.IsEmpty then
          Error(SynchronizeEmptySetErr);

        if not CRMSynchHelper.GetMappingForTable(RecordsToSynchRecordRef.Number,IntegrationTableMapping) then
          Error(StrSubstNo(NoMappingErr,RecordsToSynchRecordRef.Name));

        ConnectionName := InitConnection;

        IntegrationTableSynch.BeginIntegrationSynchJob(Tableconnectiontype::CRM,IntegrationTableMapping);
        repeat
          IntegrationTableSynch.Synchronize(RecordsToSynchRecordRef,IntegrationRecordRef,IgnoreChanges,IgnoreSynchOnlyCoupledRecords)
        until RecordsToSynchRecordRef.Next = 0;
        JobID := IntegrationTableSynch.EndIntegrationSynchJob;

        CloseConnection(ConnectionName);
    end;

    local procedure SynchNAVTableToCRM(IntegrationTableMapping: Record "Integration Table Mapping";var IntegrationTableSynch: Codeunit "Integration Table Synch.") LatestModifiedOn: DateTime
    var
        IntegrationRecord: Record "Integration Record";
        TempCRMIntegrationRecord: Record "CRM Integration Record" temporary;
        SourceRecordRef: RecordRef;
        DestinationRecordRef: RecordRef;
        IgnoreRecord: Boolean;
        ModifiedOn: DateTime;
    begin
        LatestModifiedOn := 0DT;
        if FindModifiedIntegrationRecords(IntegrationRecord,IntegrationTableMapping) then begin
          CreateCRMIntegrationRecordClone(IntegrationTableMapping."Table ID",TempCRMIntegrationRecord);
          CacheFilteredNAVTable(SourceRecordRef,IntegrationTableMapping);
          repeat
            IgnoreRecord := false;
            if SourceRecordRef.Get(IntegrationRecord."Record ID") then begin
              OnQueryPostFilterIgnoreRecord(SourceRecordRef,IgnoreRecord);
              if not IgnoreRecord then begin
                if not TempCRMIntegrationRecord.IsIntegrationIdCoupled(IntegrationRecord."Integration ID") then
                  IgnoreRecord := IntegrationTableMapping."Synch. Only Coupled Records";
                if not IgnoreRecord then
                  if IntegrationTableSynch.Synchronize(SourceRecordRef,DestinationRecordRef,false,false) then begin
                    ModifiedOn := IntegrationTableSynch.GetRowLastModifiedOn(IntegrationTableMapping,SourceRecordRef);
                    if ModifiedOn > LatestModifiedOn then
                      LatestModifiedOn := ModifiedOn;
                  end;
              end;
            end;
          until IntegrationRecord.Next = 0;
        end;
    end;

    local procedure SynchCRMTableToNAV(IntegrationTableMapping: Record "Integration Table Mapping";IntegrationUserId: Guid;var IntegrationTableSynch: Codeunit "Integration Table Synch.") LatestModifiedOn: DateTime
    var
        TempCRMIntegrationRecord: Record "CRM Integration Record" temporary;
        SourceRecordRef: RecordRef;
        DestinationRecordRef: RecordRef;
        ModifiedOn: DateTime;
        IgnoreRecord: Boolean;
    begin
        LatestModifiedOn := 0DT;
        CacheFilteredCRMTable(SourceRecordRef,IntegrationTableMapping,IntegrationUserId);
        CreateCRMIntegrationRecordClone(IntegrationTableMapping."Table ID",TempCRMIntegrationRecord);
        if SourceRecordRef.FindSet then
          repeat
            IgnoreRecord := false;
            OnQueryPostFilterIgnoreRecord(SourceRecordRef,IgnoreRecord);
            if not IgnoreRecord then begin
              if TempCRMIntegrationRecord.IsCRMRecordRefCoupled(SourceRecordRef) then
                TempCRMIntegrationRecord.Delete
              else
                IgnoreRecord := IntegrationTableMapping."Synch. Only Coupled Records";
              if not IgnoreRecord then
                if IntegrationTableSynch.Synchronize(SourceRecordRef,DestinationRecordRef,false,false) then begin
                  ModifiedOn := IntegrationTableSynch.GetRowLastModifiedOn(IntegrationTableMapping,SourceRecordRef);
                  if ModifiedOn > LatestModifiedOn then
                    LatestModifiedOn := ModifiedOn;
                end;
            end;
          until SourceRecordRef.Next = 0;
    end;

    local procedure GetModifyByFieldNo(CRMTableID: Integer): Integer
    var
        "Field": Record "Field";
    begin
        Field.SetRange(TableNo,CRMTableID);
        Field.SetRange(FieldName,'ModifiedBy'); // All CRM tables should have "ModifiedBy" field
        Field.FindFirst;
        exit(Field."No.");
    end;

    local procedure PerformScheduledSynchToIntegrationTable(var IntegrationTableMapping: Record "Integration Table Mapping")
    var
        IntegrationTableSynch: Codeunit "Integration Table Synch.";
        LatestModifiedOn: DateTime;
    begin
        IntegrationTableSynch.BeginIntegrationSynchJob(Tableconnectiontype::CRM,IntegrationTableMapping);

        LatestModifiedOn := SynchNAVTableToCRM(IntegrationTableMapping,IntegrationTableSynch);

        IntegrationTableSynch.EndIntegrationSynchJob;

        IntegrationTableMapping.SetTableModifiedOn(LatestModifiedOn);
    end;

    local procedure PerformScheduledSynchFromIntegrationTable(var IntegrationTableMapping: Record "Integration Table Mapping";IntegrationUserId: Guid)
    var
        IntegrationTableSynch: Codeunit "Integration Table Synch.";
        LatestModifiedOn: DateTime;
    begin
        IntegrationTableSynch.BeginIntegrationSynchJob(Tableconnectiontype::CRM,IntegrationTableMapping);

        LatestModifiedOn := SynchCRMTableToNAV(IntegrationTableMapping,IntegrationUserId,IntegrationTableSynch);

        IntegrationTableSynch.EndIntegrationSynchJob;

        IntegrationTableMapping.SetIntTableModifiedOn(LatestModifiedOn);
    end;

    local procedure CreateCRMIntegrationRecordClone(ForTable: Integer;var TempCRMIntegrationRecord: Record "CRM Integration Record" temporary)
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
    begin
        TempCRMIntegrationRecord.Reset;
        TempCRMIntegrationRecord.DeleteAll;

        CRMIntegrationRecord.SetRange("Table ID",ForTable);
        if not CRMIntegrationRecord.FindSet then
          exit;

        repeat
          TempCRMIntegrationRecord.Copy(CRMIntegrationRecord,false);
          TempCRMIntegrationRecord.Insert;
        until CRMIntegrationRecord.Next = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnQueryPostFilterIgnoreRecord(SourceRecordRef: RecordRef;var IgnoreRecord: Boolean)
    begin
    end;

    local procedure RegisterTempConnectionIfNeeded(CRMConnectionSetup: Record "CRM Connection Setup") ConnectionName: Text
    var
        TempNoUserMapCRMConnectionSetup: Record "CRM Connection Setup" temporary;
    begin
        if CRMConnectionSetup."Is User Mapping Required" then begin
          ConnectionName := Format(CreateGuid);
          TempNoUserMapCRMConnectionSetup.TransferFields(CRMConnectionSetup);
          TempNoUserMapCRMConnectionSetup."Is User Mapping Required" := false;
          TempNoUserMapCRMConnectionSetup.RegisterConnectionWithName(ConnectionName);
        end;
    end;
}

