#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 4 ClientTypeManagement
{

    trigger OnRun()
    begin
    end;


    procedure GetCurrentClientType() CurrClientType: ClientType
    begin
        CurrClientType := CurrentClientType;
        OnAfterGetCurrentClientType(CurrClientType);
    end;


    procedure IsClientType(ExpectedClientType: ClientType): Boolean
    begin
        exit(ExpectedClientType = GetCurrentClientType);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetCurrentClientType(var CurrClientType: ClientType)
    begin
    end;
}

