#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9178 "Check App. Area Only Basic"
{

    trigger OnRun()
    var
        ApplicationAreaSetup: Record "Application Area Setup";
    begin
        if ApplicationAreaSetup.IsBasicOnlyEnabled then begin
          Message(OnlyBasicAppAreaMsg);
          Error('');
        end;
    end;

    var
        OnlyBasicAppAreaMsg: label 'You do not have access to this page, because your Experience option is set to Basic.';
}

