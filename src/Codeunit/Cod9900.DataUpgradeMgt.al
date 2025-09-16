#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9900 "Data Upgrade Mgt."
{

    trigger OnRun()
    begin
    end;


    procedure SetTableSyncSetup(TableId: Integer;UpgradeTableId: Integer;TableUpgradeMode: Option Check,Copy,Move,Force)
    var
        TableSynchSetup: Record "Table Synch. Setup";
    begin
        if TableSynchSetup.Get(TableId) then begin
          TableSynchSetup."Upgrade Table ID" := UpgradeTableId;
          TableSynchSetup.Mode := TableUpgradeMode;
          TableSynchSetup.Modify;
        end;
    end;
}

