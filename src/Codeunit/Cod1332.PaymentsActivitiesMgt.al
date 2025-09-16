#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1332 "Payments Activities Mgt."
{

    trigger OnRun()
    begin
        if IsActivitiesVisible then
          DisableActivitiesForCurrentUser
        else
          EnableActivitiesForCurrentUser;
    end;

    var
        ApplicationAreaSetup: Record "Application Area Setup";

    local procedure EnableActivitiesForCurrentUser()
    var
        UserPreference: Record "User Preference";
    begin
        if ApplicationAreaSetup.IsBasicOnlyEnabled then
          UserPreference.DisableInstruction(GetActivitiesCode)
        else
          UserPreference.EnableInstruction(GetActivitiesCode);
    end;

    local procedure DisableActivitiesForCurrentUser()
    var
        UserPreference: Record "User Preference";
    begin
        if ApplicationAreaSetup.IsBasicOnlyEnabled then
          UserPreference.EnableInstruction(GetActivitiesCode)
        else
          UserPreference.DisableInstruction(GetActivitiesCode);
    end;


    procedure IsActivitiesVisible(): Boolean
    var
        UserPreference: Record "User Preference";
    begin
        // Default Visibility = Hide
        if ApplicationAreaSetup.IsBasicOnlyEnabled then
          exit(UserPreference.Get(UserId,GetActivitiesCode));

        exit(not UserPreference.Get(UserId,GetActivitiesCode));
    end;

    local procedure GetActivitiesCode(): Code[20]
    begin
        exit('PAYMENTSACTIVITIES');
    end;
}

