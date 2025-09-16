#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1634 "Setup Office Host Provider"
{

    trigger OnRun()
    begin
        InitSetup;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", 'OnCompanyInitialize', '', false, false)]
    local procedure InitSetup()
    var
        OfficeAddinSetup: Record "Office Add-in Setup";
    begin
        if not OfficeAddinSetup.IsEmpty then
          exit;

        OfficeAddinSetup.Init;
        OfficeAddinSetup.Insert;
    end;
}

