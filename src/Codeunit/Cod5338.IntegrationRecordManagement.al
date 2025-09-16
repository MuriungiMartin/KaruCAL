#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5338 "Integration Record Management"
{

    trigger OnRun()
    begin
    end;

    var
        UnsupportedTableConnectionTypeErr: label '%1 is not a supported table connection type.';


    procedure FindRecordIdByIntegrationTableUid(IntegrationTableConnectionType: TableConnectionType;IntegrationTableUid: Variant;DestinationTableId: Integer;var DestinationRecordId: RecordID): Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
    begin
        if IntegrationTableConnectionType = Tableconnectiontype::CRM then
          exit(CRMIntegrationRecord.FindRecordIDFromID(IntegrationTableUid,DestinationTableId,DestinationRecordId));

        Error(UnsupportedTableConnectionTypeErr,Format(IntegrationTableConnectionType));
    end;


    procedure FindIntegrationTableUIdByRecordId(IntegrationTableConnectionType: TableConnectionType;SourceRecordId: RecordID;var IntegrationTableUid: Variant): Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
    begin
        if IntegrationTableConnectionType = Tableconnectiontype::CRM then
          exit(CRMIntegrationRecord.FindIDFromRecordID(SourceRecordId,IntegrationTableUid));

        Error(UnsupportedTableConnectionTypeErr,Format(IntegrationTableConnectionType));
    end;


    procedure UpdateIntegrationTableCoupling(IntegrationTableConnectionType: TableConnectionType;IntegrationTableUid: Variant;IntegrationTableModfiedOn: DateTime;RecordId: RecordID;ModifiedOn: DateTime)
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
    begin
        if IntegrationTableConnectionType = Tableconnectiontype::CRM then begin
          CRMIntegrationRecord.CoupleCRMIDToRecordID(IntegrationTableUid,RecordId);
          CRMIntegrationRecord.SetLastSynchModifiedOns(IntegrationTableUid,RecordId.TableNo,IntegrationTableModfiedOn,ModifiedOn);
        end else
          Error(UnsupportedTableConnectionTypeErr,Format(IntegrationTableConnectionType));
    end;


    procedure IsModifiedAfterIntegrationTableRecordLastSynch(IntegrationTableConnectionType: TableConnectionType;IntegrationTableUid: Variant;DestinationTableId: Integer;LastModifiedOn: DateTime): Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
    begin
        if IntegrationTableConnectionType = Tableconnectiontype::CRM then
          exit(CRMIntegrationRecord.IsModifiedAfterLastSynchonizedCRMRecord(IntegrationTableUid,DestinationTableId,LastModifiedOn));
        Error(UnsupportedTableConnectionTypeErr,Format(IntegrationTableConnectionType));
    end;


    procedure IsModifiedAfterRecordLastSynch(IntegrationTableConnectionType: TableConnectionType;SourceRecordID: RecordID;LastModifiedOn: DateTime): Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
    begin
        if IntegrationTableConnectionType = Tableconnectiontype::CRM then
          exit(CRMIntegrationRecord.IsModifiedAfterLastSynchronizedRecord(SourceRecordID,LastModifiedOn));
        Error(UnsupportedTableConnectionTypeErr,Format(IntegrationTableConnectionType));
    end;
}

