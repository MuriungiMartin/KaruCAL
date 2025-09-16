#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6304 "Setup Azure AD Mgt. Provider"
{

    trigger OnRun()
    begin
        InitSetup;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", 'OnCompanyInitialize', '', false, false)]
    local procedure InitSetup()
    var
        AzureADMgtSetup: Record "Azure AD Mgt. Setup";
    begin
        with AzureADMgtSetup do
          if IsEmpty then begin
            Init;
            ResetToDefault;
            Insert;
          end;
    end;
}

