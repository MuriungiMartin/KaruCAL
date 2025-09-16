#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1328 "Start Activities Mgt."
{

    trigger OnRun()
    begin
        if IsActivitiesVisible then
          DisableActivitiesForCurrentUser
        else
          EnableActivitiesForCurrentUser;
    end;

    local procedure EnableActivitiesForCurrentUser()
    var
        UserPreference: Record "User Preference";
    begin
        UserPreference.EnableInstruction(GetActivitiesCode);
    end;

    local procedure DisableActivitiesForCurrentUser()
    var
        UserPreference: Record "User Preference";
    begin
        UserPreference.DisableInstruction(GetActivitiesCode);
    end;


    procedure IsActivitiesVisible(): Boolean
    var
        UserPreference: Record "User Preference";
    begin
        exit(not UserPreference.Get(UserId,GetActivitiesCode));
    end;

    local procedure GetActivitiesCode(): Code[20]
    begin
        exit('STARTACTIVITIES');
    end;
}

