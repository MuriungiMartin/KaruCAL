#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9175 "Connect Online"
{
    Caption = 'Connect Online';
    PageType = CardPart;

    layout
    {
        area(content)
        {
            usercontrol(Parameters;"Microsoft.Dynamics.Nav.Client.DynamicsOnlineConnect")
            {
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
    }

    var
        CurrentRole: Code[30];
        CurrentRoleID: Integer;
        CurrentLanguageID: Integer;
        Text000: label 'version=', Comment='version=';
        Text001: label 'locale=', Comment='locale=';
        Text002: label 'role=', Comment='role=';
        Text003: label 'roleid=', Comment='roleid=';
        Text004: label 'Serial=', Comment='Serial=';

    local procedure Parameters(): Text[350]
    begin
        InitCurrentRoleValues;

        exit(Add(Version) + Add(Locale) + Add(Role) + Add(RoleID) + Add(Serial));
    end;

    local procedure Add(Parameter: Text[200]): Text[200]
    begin
        exit(Parameter + Separator);
    end;

    local procedure Version(): Text[170]
    var
        ApplicationManagement: Codeunit ApplicationManagement;
    begin
        exit(Text000 + Format(ApplicationManagement.ApplicationVersion + ':' + ApplicationManagement.ApplicationBuild,0,XMLFormat));
    end;

    local procedure Locale(): Text[30]
    begin
        // Windows Language ID
        exit(Text001 + Format(CurrentLanguageID,0,XMLFormat));
    end;

    local procedure Role(): Text[40]
    begin
        // Profile ID (Any text entered in Profile ID)
        exit(Text002 + Format(DelChr(CurrentRole,'=',Separator),0,XMLFormat));
    end;

    local procedure RoleID(): Text[30]
    begin
        // Role Center ID (Page ID)
        exit(Text003 + Format(CurrentRoleID,0,XMLFormat));
    end;

    local procedure Serial(): Text[80]
    begin
        // License ID
        exit(Text004 + Format(SerialNumber,0,XMLFormat));
    end;

    local procedure Separator(): Text[1]
    begin
        exit(';');
    end;

    local procedure XMLFormat(): Integer
    begin
        exit(9);
    end;

    local procedure InitCurrentRoleValues()
    var
        UserPersonalization: Record "User Personalization";
        "Profile": Record "Profile";
        ApplicationManagement: Codeunit ApplicationManagement;
    begin
        CurrentLanguageID := GlobalLanguage;
        CurrentRoleID := ApplicationManagement.DefaultRoleCenter;
        CurrentRole := Format(CurrentRoleID);

        Profile.SetRange("Default Role Center",true);
        if Profile.FindFirst then begin
          CurrentRoleID := Profile."Role Center ID";
          CurrentRole := Profile."Profile ID";
        end;

        UserPersonalization.SetFilter("User ID",'%1',UserFilter);
        if UserPersonalization.FindFirst then begin
          if (UserPersonalization."Language ID" <> 0) and (UserPersonalization."Language ID" <> CurrentLanguageID) then
            CurrentLanguageID := UserPersonalization."Language ID";
          if UserPersonalization."Profile ID" <> '' then begin
            CurrentRole := UserPersonalization."Profile ID";
            if Profile.Get(UserPersonalization."Profile ID") then
              CurrentRoleID := Profile."Role Center ID";
          end;
        end;
    end;

    local procedure UserFilter(): Text[80]
    begin
        exit('*\' + UserId);
    end;
}

