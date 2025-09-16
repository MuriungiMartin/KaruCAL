#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5339 "Integration Synch. Job Runner"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
    begin
        IntegrationTableMapping.Get("Record ID to Process");
        RunIntegrationTableSynch(IntegrationTableMapping);
    end;


    procedure RunIntegrationTableSynch(IntegrationTableMapping: Record "Integration Table Mapping")
    begin
        Codeunit.Run(IntegrationTableMapping."Synch. Codeunit ID",IntegrationTableMapping);
    end;
}

