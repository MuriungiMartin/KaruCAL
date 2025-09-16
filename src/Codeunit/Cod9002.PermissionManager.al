#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9002 "Permission Manager"
{
    Permissions = TableData "User Group Plan"=rimd,
                  TableData "User Login"=rimd;
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        OfficePortalUserAdministrationUrlTxt: label 'https://portal.office.com/admin/default.aspx#ActiveUsersPage', Locked=true;
        TestabilitySoftwareAsAService: Boolean;
        SUPERPermissionSetTxt: label 'SUPER', Locked=true;


    procedure AddUserToUserGroup(UserSecurityID: Guid;UserGroupCode: Code[20];Company: Text[30])
    var
        UserGroupMember: Record "User Group Member";
    begin
        if not UserGroupMember.Get(UserGroupCode,UserSecurityID,Company) then begin
          UserGroupMember.Init;
          UserGroupMember."Company Name" := Company;
          UserGroupMember."User Security ID" := UserSecurityID;
          UserGroupMember."User Group Code" := UserGroupCode;
          UserGroupMember.Insert(true);
        end;
    end;


    procedure AddUserToDefaultUserGroups(UserSecurityID: Guid) UserGroupsAdded: Boolean
    var
        UserPlan: Record "User Plan";
    begin
        // Add the new user to all user groups of the plan

        // No plan is assigned to this user
        UserPlan.SetRange("User Security ID",UserSecurityID);
        if not UserPlan.FindSet then begin
          UserGroupsAdded := false;
          exit;
        end;

        // There is at least a plan assigned (and probably only one)
        repeat
          if AddUserToAllUserGroupsOfThePlan(UserSecurityID,UserPlan."Plan ID") then
            UserGroupsAdded := true;
        until UserPlan.Next = 0;
    end;

    local procedure AddUserToAllUserGroupsOfThePlan(UserSecurityID: Guid;PlanID: Guid): Boolean
    var
        UserGroupPlan: Record "User Group Plan";
    begin
        // Get all User Groups in plan
        UserGroupPlan.SetRange("Plan ID",PlanID);
        if not UserGroupPlan.FindSet then
          exit(false); // nothing to add

        // Assign groups to the current user (if not assigned already)
        repeat
          AddUserToUserGroup(UserSecurityID,UserGroupPlan."User Group Code",COMPANYNAME);
        until UserGroupPlan.Next = 0;
        exit(true);
    end;

    local procedure RemoveUserFromAllPermissionSets(UserSecurityID: Guid)
    var
        AccessControl: Record "Access Control";
    begin
        AccessControl.SetRange("User Security ID",UserSecurityID);
        AccessControl.DeleteAll(true);
    end;

    local procedure RemoveUserFromAllUserGroups(UserSecurityID: Guid)
    var
        UserGroupMember: Record "User Group Member";
    begin
        UserGroupMember.SetRange("User Security ID",UserSecurityID);
        UserGroupMember.DeleteAll(true);
    end;


    procedure ResetUserToDefaultUserGroups(UserSecurityID: Guid)
    begin
        // Remove the user from all assigned user groups and their related permission sets
        RemoveUserFromAllUserGroups(UserSecurityID);

        // Remove the user from any additional, manually assigned permission sets
        RemoveUserFromAllPermissionSets(UserSecurityID);

        // Add the user to all the user groups (and their permission sets) which are
        // defined in the user's assigned subscription plan
        AddUserToDefaultUserGroups(UserSecurityID);
    end;


    procedure GetOfficePortalUserAdminUrl(): Text
    begin
        exit(OfficePortalUserAdministrationUrlTxt);
    end;


    procedure SetTestabilitySoftwareAsAService(EnableSoftwareAsAServiceForTest: Boolean)
    begin
        TestabilitySoftwareAsAService := EnableSoftwareAsAServiceForTest;
    end;


    procedure SoftwareAsAService(): Boolean
    var
        MembershipEntitlement: Record "Membership Entitlement";
    begin
        if TestabilitySoftwareAsAService then
          exit(true);

        exit(not MembershipEntitlement.IsEmpty);
    end;


    procedure UpdateUserAccessForSaaS(UserSID: Guid)
    begin
        if not AllowUpdateUserAccessForSaaS(UserSID) then
          exit;

        // Only remove SUPER if other permissions are granted (to avoid user lockout)
        if AddUserToDefaultUserGroups(UserSID) then begin
          AssignDefaultRoleCenterToUser(UserSID);
          RemoveSUPERPermissionSetFromUserIfMoreSupersExist(UserSID);
          StoreUserFirstLogin(UserSID);
        end;
    end;

    local procedure AllowUpdateUserAccessForSaaS(UserSID: Guid): Boolean
    var
        User: Record User;
        UserPlan: Record "User Plan";
        UserLogin: Record "User Login";
    begin
        if not SoftwareAsAService then
          exit(false);

        if IsNullGuid(UserSID) then
          exit(false);

        // Only update first-time login users
        if not UserLogin.Get(UserSID) then
          exit(true); // This user had never logged in before
        if UserLogin."First Login Date" = 0D then
          exit(true); // This user had never logged in before

        // Some users come from an upgrade (when table UserLogin didn't exist),
        // but they have personalization which proves they have been logged on before
        if UserHasPersonalization(UserSID) then
          exit(false);

        // Don't demote external users (like the sync daemon)
        User.Get(UserSID);
        if User."License Type" = User."license type"::"External User" then
          exit(false);

        // Don't demote users which don't come from Office365 (have no plans assigned)
        // Note: all users who come from O365, if they don't have a plan, they don't get a license (hence, no SUPER role)
        UserPlan.SetRange("User Security ID",User."User Security ID");
        if UserPlan.IsEmpty then
          exit(false);

        exit(true);
    end;

    local procedure UserHasNoUserGroups(UserID: Guid): Boolean
    var
        UserGroupMember: Record "User Group Member";
    begin
        UserGroupMember.SetRange("User Security ID",UserID);
        UserGroupMember.SetRange("Company Name",COMPANYNAME);
        exit(not UserGroupMember.FindFirst);
    end;

    [EventSubscriber(ObjectType::Table, Database::"User Plan", 'OnAfterDeleteEvent', '', false, false)]
    local procedure RemoveUserFromUserGroupsOfThePlan(var Rec: Record "User Plan";RunTrigger: Boolean)
    var
        UserGroupPlan: Record "User Group Plan";
        UserGroupMember: Record "User Group Member";
    begin
        if Rec.IsTemporary then
          exit;

        if UserHasNoUserGroups(Rec."User Security ID") then
          exit; // nothing to remove

        // Get list of all user groups of removed plan
        UserGroupPlan.SetRange("Plan ID",Rec."Plan ID");
        if not UserGroupPlan.Find('-') then
          exit; // nothing to remove

        repeat
          if UserGroupMember.Get(UserGroupPlan."User Group Code",Rec."User Security ID",COMPANYNAME) then
            UserGroupMember.Delete(true);
        until UserGroupPlan.Next = 0;
    end;


    procedure AddUserGroupFromExtension(UserGroupCode: Code[20];RoleID: Code[20];AppGuid: Guid)
    var
        UserGroupPermissionSet: Record "User Group Permission Set";
        UserGroup: Record "User Group";
    begin
        if not SoftwareAsAService then
          if not UserGroup.Get(UserGroupCode) then
            exit;

        UserGroupPermissionSet.Init;
        UserGroupPermissionSet."User Group Code" := UserGroupCode;
        UserGroupPermissionSet."Role ID" := RoleID;
        UserGroupPermissionSet."App ID" := AppGuid;
        UserGroupPermissionSet.Scope := UserGroupPermissionSet.Scope::Tenant;
        if not UserGroupPermissionSet.Find then
          UserGroupPermissionSet.Insert(true);
    end;

    local procedure DeleteSuperFromUser(UserSID: Guid)
    var
        AccessControl: Record "Access Control";
    begin
        AccessControl.SetRange("Role ID",SUPERPermissionSetTxt);
        AccessControl.SetRange("Company Name",'');
        AccessControl.SetRange("User Security ID",UserSID);
        AccessControl.DeleteAll(true);
    end;

    local procedure IsExternalUser(UserSID: Guid): Boolean
    var
        User: Record User;
    begin
        if User.Get(UserSID) then
          exit(User."License Type" = User."license type"::"External User");

        exit(false);
    end;

    local procedure IsSomeoneElseSuper(UserSID: Guid): Boolean
    var
        AccessControl: Record "Access Control";
    begin
        AccessControl.LockTable;
        AccessControl.SetRange("Role ID",SUPERPermissionSetTxt);
        AccessControl.SetRange("Company Name",'');
        AccessControl.SetFilter("User Security ID",'<>%1',UserSID);

        if not AccessControl.FindSet then
          exit;

        repeat
          // Sync Deamon should not count as a super user and he has a external license
          if not IsExternalUser(AccessControl."User Security ID") then
            exit(true);
        until AccessControl.Next = 0;

        exit(false);
    end;

    local procedure RemoveSUPERPermissionSetFromUserIfMoreSupersExist(UserSID: Guid)
    begin
        if IsSomeoneElseSuper(UserSID) then
          DeleteSuperFromUser(UserSID);
    end;

    local procedure StoreUserFirstLogin(UserSecurityID: Guid)
    var
        UserLogin: Record "User Login";
    begin
        if UserLogin.Get(UserSecurityID) then
          exit; // the user has already been logged in before
        UserLogin.Init;
        UserLogin.Validate("User SID",UserSecurityID);
        UserLogin.Validate("First Login Date",Today);
        UserLogin.Insert;
    end;

    local procedure UserHasPersonalization(UserSecurityID: Guid): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin
        if UserPersonalization.Get(UserSecurityID) then begin
          StoreUserFirstLogin(UserSecurityID); // This user probably comes from an upgrade
          exit(true);
        end;
        exit(false);
    end;

    local procedure AssignDefaultRoleCenterToUser(UserSercurityID: Guid)
    var
        UserPlan: Record "User Plan";
        UserPersonalization: Record "User Personalization";
        Plan: Record Plan;
        "Profile": Record "Profile";
    begin
        UserPlan.SetRange("User Security ID",UserSercurityID);

        if not UserPlan.FindFirst then
          exit; // this user has no plans assigned, so they'll get the app-wide default role center

        Plan.Get(UserPlan."Plan ID");
        Profile.SetRange("Role Center ID",Plan."Role Center ID");
        Profile.FindFirst;

        // Create the user personalization record
        if not UserPersonalization.Get(UserSercurityID) then begin
          UserPersonalization.Init;
          UserPersonalization.Validate("User SID",UserSercurityID);
          UserPersonalization.Validate("Profile ID",Profile."Profile ID");
          UserPersonalization.Insert;
          exit;
        end;

        // This user already has personalization, update it
        UserPersonalization.Validate("User SID",UserSercurityID);
        UserPersonalization.Validate("Profile ID",Profile."Profile ID");
        UserPersonalization.Modify(true);
    end;
}

