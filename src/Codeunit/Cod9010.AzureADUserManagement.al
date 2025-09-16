#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9010 "Azure AD User Management"
{
    Permissions = TableData Plan=rimd,
                  TableData "User Plan"=rimd,
                  TableData "Access Control"=rimd,
                  TableData User=rimd,
                  TableData "User Property"=rimd,
                  TableData "Membership Entitlement"=rimd;

    trigger OnRun()
    var
        UserProperty: Record "User Property";
        PermissionManager: Codeunit "Permission Manager";
    begin
        if not PermissionManager.SoftwareAsAService then
          exit;

        if not UserProperty.Get(UserSecurityId) then
          exit;

        if GetUserAuthenticationObjectId(UserSecurityId) = '' then
          exit;

        RefreshUserPlanAssignments(UserSecurityId);
        Commit;
    end;

    var
        PermissionManager: Codeunit "Permission Manager";
        Graph: dotnet GraphQuery;
        IsInitialized: Boolean;
        UserDoesNotObjectIdSetErr: label 'The user with the security ID %1 does not have a valid object ID in Azure Active Directory.', Comment='%1 =  The specified User Security ID';
        CouldNotFindGraphUserErr: label 'An Azure Active Directory user with the object ID %1 was not found.', Comment='%1 = The specified object id';

    local procedure RefreshUserPlanAssignments(ForUserSecurityId: Guid)
    var
        User: Record User;
        GraphUser: dotnet User;
        UserObjectId: Text;
    begin
        if not User.Get(ForUserSecurityId) then
          exit;

        if not Initialize then
          exit;

        UserObjectId := GetUserAuthenticationObjectId(ForUserSecurityId);
        if UserObjectId = '' then
          exit;

        GetGraphUserFromObjectId(UserObjectId,GraphUser);
        UpdateUserFromAzureGraph(User,GraphUser);
        UpdateUserPlansFromAzureGraph(User."User Security ID",GraphUser);
    end;


    procedure GetPlans(var TempPlan: Record Plan temporary;IncludePlansWithoutEntitlement: Boolean)
    var
        SubscribedSku: dotnet ISubscribedSku;
        ServicePlan: dotnet ServicePlanInfo;
        ServicePlanId: dotnet Guid;
        ServicePlanIdValue: Variant;
    begin
        if not Initialize then
          exit;

        TempPlan.Reset;
        TempPlan.DeleteAll;

        foreach SubscribedSku in Graph.GetDirectorySubscribedSkus do
          foreach ServicePlan in SubscribedSku.ServicePlans do begin
            ServicePlanId := ServicePlan.ServicePlanId;
            ServicePlanIdValue := ServicePlanId;
            if IncludePlansWithoutEntitlement then
              AddToTempPlan(ServicePlanIdValue,ServicePlan.ServicePlanName,TempPlan)
            else
              if IsServicePlanMembershipEntitled(ServicePlanId) then
                AddToTempPlan(ServicePlanIdValue,ServicePlan.ServicePlanName,TempPlan);
          end;
    end;


    procedure GetUserPlans(var TempPlan: Record Plan temporary;ForUserSecurityId: Guid;IncludePlansWithoutEntitlement: Boolean)
    var
        GraphUser: dotnet User;
        UserObjectId: Text;
    begin
        if not Initialize then
          exit;

        UserObjectId := GetUserAuthenticationObjectId(ForUserSecurityId);
        GetGraphUserFromObjectId(UserObjectId,GraphUser);
        GetGraphUserPlans(TempPlan,GraphUser,IncludePlansWithoutEntitlement);
    end;


    procedure GetUserRoles(var TempNameValueBuffer: Record "Name/Value Buffer" temporary;ForUserSecurityId: Guid;IncludeRolesWithoutEntitlement: Boolean)
    var
        GraphUser: dotnet User;
        UserObjectId: Text;
    begin
        if not Initialize then
          exit;

        UserObjectId := GetUserAuthenticationObjectId(ForUserSecurityId);
        GetGraphUserFromObjectId(UserObjectId,GraphUser);
        GetGraphUserRoles(TempNameValueBuffer,UserObjectId,IncludeRolesWithoutEntitlement);
    end;


    procedure CreateNewUsersFromAzureAD()
    var
        User: Record User;
        PagedUsers: dotnet PagedUserCollection;
        GraphUser: dotnet IUser;
        UserAccountHelper: dotnet NavUserAccountHelper;
        NewUserSecurityId: Guid;
        IsFirstPage: Boolean;
    begin
        if not Initialize then
          exit;

        PagedUsers := Graph.GetUsersPage(50);
        IsFirstPage := true;
        repeat
          if not IsFirstPage then
            PagedUsers.GetNextPage
          else
            IsFirstPage := false;

          foreach GraphUser in PagedUsers.CurrentPage do
            if GetUserFromAuthenticationObjectId(GraphUser.ObjectId,User) then begin
              UpdateUserFromAzureGraph(User,GraphUser);
              UpdateUserPlansFromAzureGraph(User."User Security ID",GraphUser);
            end else
              if IsGraphUserEntitledFromServicePlan(GraphUser) then begin
                EnsureAuthenticationEmailIsNotInUse(GraphUser.UserPrincipalName);

                NewUserSecurityId := UserAccountHelper.CreateUserFromAzureADObjectId(GraphUser.ObjectId);
                if not IsNullGuid(NewUserSecurityId) then
                  InitializeAsNewUser(NewUserSecurityId,GraphUser);
              end;
        until (not PagedUsers.MorePagesAvailable);
    end;


    procedure RemoveUnassignedUserPlans(var TempO365Plan: Record Plan temporary;ForUserSecurityId: Guid)
    var
        NavUserPlan: Record "User Plan";
        TempNavUserPlan: Record "User Plan" temporary;
    begin
        // Have any plans been removed from this user in O365, since last time he logged-in to NAV?
        // Get all plans assigned to the user, in NAV
        NavUserPlan.SetRange("User Security ID",ForUserSecurityId);
        if NavUserPlan.FindSet then
          repeat
            TempNavUserPlan.Copy(NavUserPlan,false);
            TempNavUserPlan.Insert;
          until NavUserPlan.Next = 0;

        // Get all plans assigned to the user in Office
        if TempO365Plan.FindSet then
          // And remove them from the list of plans assigned to the user
          repeat
            TempNavUserPlan.SetRange("Plan ID",TempO365Plan."Plan ID");
            if not TempNavUserPlan.IsEmpty then
              TempNavUserPlan.DeleteAll;
          until TempO365Plan.Next = 0;

        // If any plans belong to the user in NAV, but not in Office, de-assign them
        if TempNavUserPlan.FindSet then
          repeat
            NavUserPlan.SetRange("Plan ID",TempNavUserPlan."Plan ID");
            NavUserPlan.DeleteAll(true);
          until TempNavUserPlan.Next = 0;
    end;


    procedure AddNewlyAssignedUserPlans(var TempO365Plan: Record Plan temporary;ForUserSecurityId: Guid)
    var
        NavUserPlan: Record "User Plan";
        PermissionManager: Codeunit "Permission Manager";
    begin
        // Have any plans been added to this user in O365, since last time he logged-in to NAV?
        // For each plan assigned to the user in Office
        if TempO365Plan.FindSet then
          repeat
            // Does this assignment exist in NAV? If not, add it.
            NavUserPlan.SetRange("Plan ID",TempO365Plan."Plan ID");
            NavUserPlan.SetRange("User Security ID",ForUserSecurityId);
            if NavUserPlan.IsEmpty then begin
              InsertFromTempPlan(TempO365Plan);

              NavUserPlan.Init;
              NavUserPlan."Plan ID" := TempO365Plan."Plan ID";
              NavUserPlan."User Security ID" := ForUserSecurityId;
              NavUserPlan.Insert(true);
              // The SUPER role is replaced with O365 FULL ACCESS for new users.
              // This happens only for users who are created from O365 (i.e. are added to plans)
              PermissionManager.UpdateUserAccessForSaaS(NavUserPlan."User Security ID");
            end;
          until TempO365Plan.Next = 0;
    end;

    local procedure GetGraphUserPlans(var TempPlan: Record Plan temporary;var GraphUser: dotnet User;IncludePlansWithoutEntitlement: Boolean)
    var
        AssignedPlan: dotnet AssignedPlan;
        ServicePlanIdValue: Variant;
    begin
        TempPlan.Reset;
        TempPlan.DeleteAll;

        foreach AssignedPlan in GraphUser.AssignedPlans do
          if IncludePlansWithoutEntitlement then begin
            ServicePlanIdValue := AssignedPlan.ServicePlanId;
            AddToTempPlan(ServicePlanIdValue,AssignedPlan.Service,TempPlan);
          end else
            if IsServicePlanMembershipEntitled(AssignedPlan.ServicePlanId) then begin
              ServicePlanIdValue := AssignedPlan.ServicePlanId;
              AddToTempPlan(ServicePlanIdValue,AssignedPlan.Service,TempPlan);
            end;
    end;

    local procedure GetGraphUserRoles(var TempNameValueBuffer: Record "Name/Value Buffer" temporary;UserObjectId: Guid;IncludeRolesWithoutEntitlement: Boolean)
    var
        MembershipEntitlement: Record "Membership Entitlement";
        GraphUser: dotnet User;
        DirectoryRole: dotnet IDirectoryRole;
        IsSystemRole: Boolean;
    begin
        TempNameValueBuffer.Reset;
        TempNameValueBuffer.DeleteAll;

        GraphUser := Graph.GetUserByObjectId(UserObjectId);
        if IsNull(GraphUser) then
          Error(CouldNotFindGraphUserErr,UserObjectId);

        MembershipEntitlement.SetRange(Type,MembershipEntitlement.Type::"Azure AD Role");
        foreach DirectoryRole in Graph.GetUserRoles(GraphUser) do begin
          Evaluate(IsSystemRole,Format(DirectoryRole.IsSystem));
          if IncludeRolesWithoutEntitlement then
            AddRoleToTempNameValueBuffer(DirectoryRole.DisplayName,DirectoryRole.Description,TempNameValueBuffer)
          else
            if IsSystemRole then begin
              MembershipEntitlement.SetRange(ID,DirectoryRole.DisplayName);
              if MembershipEntitlement.Count > 0 then
                AddRoleToTempNameValueBuffer(DirectoryRole.DisplayName,DirectoryRole.Description,TempNameValueBuffer)
            end;
        end;
    end;

    [TryFunction]
    local procedure GetGraphUserFromObjectId(ObjectId: Text;var GraphUser: dotnet User)
    begin
        GraphUser := Graph.GetUserByObjectId(ObjectId);
        if IsNull(GraphUser) then
          Error(CouldNotFindGraphUserErr,ObjectId);
    end;

    local procedure InsertFromTempPlan(var TempPlan: Record Plan temporary)
    var
        Plan: Record Plan;
    begin
        if not Plan.Get(TempPlan."Plan ID") then begin
          Plan.Init;
          Plan.Copy(TempPlan);
          Plan.Insert;
        end;
    end;

    local procedure IsGraphUserEntitledFromServicePlan(var GraphUser: dotnet IUser): Boolean
    var
        AssignedPlan: dotnet AssignedPlan;
    begin
        foreach AssignedPlan in GraphUser.AssignedPlans do begin
          if IsServicePlanMembershipEntitled(AssignedPlan.ServicePlanId) then
            exit(true);
        end;

        exit(false);
    end;

    local procedure IsServicePlanMembershipEntitled(ServicePlanId: dotnet Guid): Boolean
    var
        MembershipEntitlement: Record "Membership Entitlement";
        MembershipEntitlementId: Text;
    begin
        MembershipEntitlement.SetRange(Type,MembershipEntitlement.Type::"Azure AD Plan");
        MembershipEntitlementId := ServicePlanId.ToString('D');
        MembershipEntitlement.SetFilter(ID,'@' + MembershipEntitlementId);
        exit(MembershipEntitlement.Count > 0);
    end;

    local procedure GetUserAuthenticationObjectId(ForUserSecurityId: Guid): Text
    var
        UserProperty: Record "User Property";
    begin
        if not UserProperty.Get(ForUserSecurityId) then
          Error(UserDoesNotObjectIdSetErr,ForUserSecurityId);

        exit(UserProperty."Authentication Object ID");
    end;

    local procedure GetUserFromAuthenticationObjectId(AuthenticationObjectId: Text;var FoundUser: Record User): Boolean
    var
        UserProperty: Record "User Property";
    begin
        UserProperty.SetRange("Authentication Object ID",AuthenticationObjectId);
        if UserProperty.FindFirst then
          exit(FoundUser.Get(UserProperty."User Security ID"));
        exit(false)
    end;

    local procedure UpdateUserFromAzureGraph(var User: Record User;var GraphUser: dotnet User)
    var
        ModifyUser: Boolean;
        TempString: Text;
    begin
        TempString := GraphUser.GivenName;
        if GraphUser.Surname <> '' then
          TempString := TempString + ' ';
        TempString := TempString + GraphUser.Surname;
        TempString := CopyStr(TempString,1,MaxStrLen(User."Full Name"));
        if Lowercase(User."Full Name") <> Lowercase(TempString) then begin
          User."Full Name" := TempString;
          ModifyUser := true;
        end;

        TempString := Format(GraphUser.Mail);
        TempString := CopyStr(TempString,1,MaxStrLen(User."Contact Email"));
        if Lowercase(User."Contact Email") <> Lowercase(TempString) then begin
          User."Contact Email" := TempString;
          ModifyUser := true;
        end;

        TempString := CopyStr(GraphUser.UserPrincipalName,1,MaxStrLen(User."Authentication Email"));
        if Lowercase(User."Authentication Email") <> Lowercase(TempString) then begin
          // Clear current authentication mail
          User."Authentication Email" := '';
          User.Modify(true);
          ModifyUser := false;

          EnsureAuthenticationEmailIsNotInUse(TempString);
          UpdateAuthenticationEmail(User,GraphUser);
        end;

        if ModifyUser then
          User.Modify(true);
    end;

    local procedure UpdateUserPlansFromAzureGraph(ForUserSecurityId: Guid;var GraphUser: dotnet User)
    var
        TempO365Plan: Record Plan temporary;
    begin
        GetGraphUserPlans(TempO365Plan,GraphUser,false);

        // Have any plans been removed from this user in O365, since last time he logged-in to NAV?
        RemoveUnassignedUserPlans(TempO365Plan,ForUserSecurityId);

        // Have any plans been added to this user in O365, since last time he logged-in to NAV?
        AddNewlyAssignedUserPlans(TempO365Plan,ForUserSecurityId);
    end;


    procedure UpdateUserPlansFromAzureGraphAllUsers()
    var
        User: Record User;
        GraphUser: dotnet User;
        UserObjectId: Text;
    begin
        User.SetFilter("License Type",'<>%1',User."license type"::"External User");
        if not User.FindSet then
          exit;
        repeat
          UserObjectId := GetUserAuthenticationObjectId(User."User Security ID");
          GetGraphUserFromObjectId(UserObjectId,GraphUser);
          UpdateUserPlansFromAzureGraph(User."User Security ID",GraphUser);
        until User.Next = 0;
    end;

    local procedure AddToTempPlan(ServicePlanId: Guid;ServicePlanName: Text;var TempPlan: Record Plan temporary)
    begin
        with TempPlan do begin
          if Get(ServicePlanId) then
            exit;

          Init;
          "Plan ID" := ServicePlanId;
          Name := CopyStr(ServicePlanName,1,MaxStrLen(Name));
          Insert;
        end;
    end;

    local procedure AddRoleToTempNameValueBuffer(RoleName: Text;RoleDescription: Text;var TempNameValueBuffer: Record "Name/Value Buffer" temporary)
    begin
        with TempNameValueBuffer do begin
          if not Get(RoleName) then
            exit;

          Init;
          Name := CopyStr(RoleName,1,MaxStrLen(Name));
          Value := CopyStr(RoleDescription,1,MaxStrLen(Value));
          Insert
        end;
    end;

    local procedure EnsureAuthenticationEmailIsNotInUse(AuthenticationEmail: Text)
    var
        User: Record User;
        ModifiedUser: Record User;
        GraphUser: dotnet User;
        AuthenticationObjectId: Text;
        UserSecurityId: Guid;
    begin
        // Clear all duplicate authentication email.
        User.SetRange("Authentication Email",CopyStr(AuthenticationEmail,1,MaxStrLen(User."Authentication Email")));
        if not User.FindFirst then
          exit;
        repeat
          AuthenticationObjectId := GetUserAuthenticationObjectId(User."User Security ID");
          UserSecurityId := User."User Security ID";
          // Modifying the user authentication email breaks the connection to AD by clearing the Authentication Object Id
          User."Authentication Email" := '';
          User.Modify(true);

          // Cascade changes to authentication email, terminates at the first time an authentication email is not found.
          if GetGraphUserFromObjectId(AuthenticationObjectId,GraphUser) then begin
            EnsureAuthenticationEmailIsNotInUse(GraphUser.UserPrincipalName);
            ModifiedUser.Get(UserSecurityId);
            UpdateAuthenticationEmail(ModifiedUser,GraphUser);
          end;
        until not User.FindFirst;
    end;

    local procedure UpdateAuthenticationEmail(var User: Record User;var GraphUser: dotnet User)
    var
        NavUserAuthenticationHelper: dotnet NavUserAccountHelper;
    begin
        User."Authentication Email" := CopyStr(GraphUser.UserPrincipalName,1,MaxStrLen(User."Authentication Email"));
        User.Modify(true);
        NavUserAuthenticationHelper.SetAuthenticationObjectId(User."User Security ID",GraphUser.ObjectId);
    end;

    local procedure InitializeAsNewUser(NewUserSecurityId: Guid;var GraphUser: dotnet IUser)
    var
        User: Record User;
    begin
        User.Get(NewUserSecurityId);

        UpdateUserFromAzureGraph(User,GraphUser);
        UpdateUserPlansFromAzureGraph(User."User Security ID",GraphUser);
    end;

    local procedure Initialize(): Boolean
    begin
        if not PermissionManager.SoftwareAsAService then
          exit(false);

        if IsInitialized then
          exit(true);

        IsInitialized := true;

        if CanHandle then
          Graph := Graph.GraphQuery
        else
          OnInitialize(Graph);

        exit(true);
    end;

    local procedure CanHandle(): Boolean
    var
        AzureADMgtSetup: Record "Azure AD Mgt. Setup";
    begin
        if AzureADMgtSetup.Get then
          exit(AzureADMgtSetup."Azure AD User Mgt. Codeunit ID" = Codeunit::"Azure AD User Management");

        exit(true);
    end;

    [IntegrationEvent(false, true)]
    local procedure OnInitialize(var GraphQuery: dotnet GraphQuery)
    begin
    end;
}

