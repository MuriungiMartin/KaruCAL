#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9807 "User Card"
{
    Caption = 'User Card';
    DataCaptionExpression = "Full Name";
    DelayedInsert = true;
    PageType = Card;
    SourceTable = User;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("User Security ID";"User Security ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'User Security ID';
                    ToolTip = 'Specifies an ID that uniquely identifies the user. This value is generated automatically and should not be changed.';
                    Visible = false;
                }
                field("User Name";"User Name")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the user''s name. If the user is required to present credentials when starting the client, this is the name that the user must present.';

                    trigger OnValidate()
                    begin
                        if xRec."User Name" <> "User Name" then
                          ValidateUserName;
                    end;
                }
                field("Full Name";"Full Name")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = not SoftwareAsAService;
                    ToolTip = 'Specifies the full name of the user.';
                }
                field("License Type";"License Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of license that applies to the user.';
                    Visible = not SoftwareAsAService;
                }
                field(State;State)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies if the user''s login is enabled.';
                }
                field("Expiry Date";"Expiry Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a date past which the user will no longer be authorized to log on to the Windows client.';
                    Visible = not SoftwareAsAService;
                }
                field("Contact Email";"Contact Email")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the user''s email address.';
                }
            }
            group("Windows Authentication")
            {
                Caption = 'Windows Authentication';
                Visible = (not DeployedToAzure) and (not SoftwareAsAService);
                field("Windows Security ID";"Windows Security ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Windows Security ID of the user. This is only relevant for Windows authentication.';
                    Visible = false;
                }
                field("Windows User Name";WindowsUserName)
                {
                    ApplicationArea = Basic,Suite;
                    AssistEdit = false;
                    Caption = 'Windows User Name';
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of a valid Active Directory user, using the format domain\username.';
                    Visible = not IsWindowsClient;

                    trigger OnValidate()
                    begin
                        ValidateWindowsUserName;
                    end;
                }
                field("Windows User Name Desktop";WindowsUserName)
                {
                    ApplicationArea = Basic,Suite;
                    AssistEdit = true;
                    Caption = 'Windows User Name';
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of a valid Active Directory user, using the format domain\username.';
                    Visible = IsWindowsClient;

                    trigger OnAssistEdit()
                    var
                        [RunOnClient]
                        DSOP: dotnet DSObjectPickerWrapper;
                        result: Text;
                    begin
                        DSOP := DSOP.DSObjectPickerWrapper;
                        result := DSOP.InvokeDialogAndReturnSid;
                        if result <> '' then begin
                          "Windows Security ID" := result;
                          ValidateSid;
                          WindowsUserName := IdentityManagement.UserName("Windows Security ID");
                          SetUserName;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        ValidateWindowsUserName;
                    end;
                }
            }
            group("ACS Authentication")
            {
                Caption = 'Access Control Service Authentication';
                Visible = not SoftwareAsAService;
                field(ACSStatus;ACSStatus)
                {
                    ApplicationArea = Basic,Suite;
                    AssistEdit = true;
                    Caption = 'ACS Access Status';
                    DrillDown = false;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the user''s status for ACS authentication. When you start creating a user, the status is Disabled. After you create a user, the status changes to Pending. After the user logs on successfully, the status changes to Enabled.';
                    Visible = not SoftwareAsAService;

                    trigger OnAssistEdit()
                    begin
                        EditACSStatus;
                    end;
                }
            }
            group("NAV Password Authentication")
            {
                Caption = 'Microsoft Dynamics NAV Password Authentication';
                Visible = not SoftwareAsAService;
                field(Password;Password)
                {
                    ApplicationArea = Basic,Suite;
                    AssistEdit = true;
                    Caption = 'Password';
                    Editable = false;
                    ExtendedDatatype = Masked;
                    Importance = Standard;
                    ToolTip = 'Specifies an initial password for the user. To sign in to the client, the user must provide the name that is specified in the User Name field and this password.';

                    trigger OnAssistEdit()
                    begin
                        EditNavPassword;
                    end;
                }
                field("Change Password";"Change Password")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'User must change password at next login';
                    ToolTip = 'Specifies if the user will be prompted to change the password at next login.';
                }
            }
            group("Web Service Access")
            {
                Caption = 'Web Service Access';
                field(WebServiceID;WebServiceID)
                {
                    ApplicationArea = Basic,Suite;
                    AssistEdit = true;
                    Caption = 'Web Service Access Key';
                    Editable = false;
                    ToolTip = 'Specifies a generated key that Dynamics NAV web service applications can use to authenticate to Dynamics NAV services. Choose the AssistEdit button to generate a key.';

                    trigger OnAssistEdit()
                    begin
                        EditWebServiceID;
                    end;
                }
                field(WebServiceExpiryDate;WebServiceExpiryDate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Web Service Expiry Date';
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies an expiration date for the web services access key.';
                }
            }
            group("Office 365 Authentication")
            {
                Caption = 'Office 365 Authentication', Comment='{Locked="Office 365"}';
                field("Authentication Email";"Authentication Email")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = not SoftwareAsAService;
                    ToolTip = 'Specifies the Microsoft account that this user signs into Office 365 or SharePoint Online with.';

                    trigger OnValidate()
                    begin
                        IdentityManagement.SetAuthenticationEmail("User Security ID","Authentication Email");
                        CurrPage.SaveRecord;
                        AuthenticationStatus := IdentityManagement.GetAuthenticationStatus("User Security ID");
                    end;
                }
                field(ApplicationID;ApplicationID)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Application ID';
                    ToolTip = 'Specifies the client ID of the Microsoft Azure Active Directory application when authenticating web-service calls. This field is only relevant when the Dynamics NAV user is used for web services.';

                    trigger OnValidate()
                    begin
                        if ApplicationID = '' then
                          Clear("Application ID")
                        else
                          "Application ID" := ApplicationID
                    end;
                }
                field(MappedToExchangeIdentifier;HasExchangeIdentifier)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Mapped To Exchange Identifier';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies whether the user is mapped to a Microsoft Exchange identifier, which enables the user to access Dynamics NAV from Exchange applications (such as Outlook) without having to sign-in.';
                }
                field(AuthenticationStatus;AuthenticationStatus)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Authentication Status';
                    Editable = false;
                    ToolTip = 'Specifies the user''s status for Office 365 authentication. When you start to create a user, the status is Disabled. After you specify an authentication email address for the user, the status changes to Inactive. After the user logs on successfully, the status changes to Active.';
                }
            }
            part(UserGroups;"User Groups User SubPage")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'User Groups';
                SubPageLink = "User Security ID"=field("User Security ID");
            }
            part(Permissions;"User Subform")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'User Permission Sets';
                SubPageLink = "User Security ID"=field("User Security ID");
            }
        }
        area(factboxes)
        {
            systempart(Control17;Notes)
            {
            }
            systempart(Control18;Links)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Authentication)
            {
                Caption = 'Authentication';
                action(AcsSetup)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&ACS Setup';
                    Image = ServiceSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Set up Access Control Service authentication, such as generating an authentication key that the user can use to connect to Azure.';
                    Visible = not SoftwareAsAService;

                    trigger OnAction()
                    begin
                        EditACSStatus;
                    end;
                }
                action(ChangePassword)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Change &Password';
                    Image = EncryptionKeys;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Change the user''s password if the user connects using password authentication.';
                    Visible = not SoftwareAsAService;

                    trigger OnAction()
                    begin
                        EditNavPassword;
                    end;
                }
                action(ChangeWebServiceAccessKey)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Change &Web Service Key';
                    Enabled = AllowChangeWebServiceAccessKey;
                    Image = ServiceCode;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Set up the key that web services use to access your data, and then specify the key on the user card for the relevant user accounts.';

                    trigger OnAction()
                    begin
                        EditWebServiceID;
                    end;
                }
                action(DeleteExchangeIdentifier)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Delete Exchange Identifier Mapping';
                    Enabled = HasExchangeIdentifier;
                    Image = DeleteXML;
                    ToolTip = 'Delete the document exchange mapping for the current user.';

                    trigger OnAction()
                    begin
                        if not Confirm(ConfirmRemoveExchangeIdentifierQst) then
                          exit;

                        Clear("Exchange Identifier");
                        Modify(true);
                        HasExchangeIdentifier := false;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PermissionManager: Codeunit "Permission Manager";
    begin
        WindowsUserName := IdentityManagement.UserName("Windows Security ID");

        TestField("User Name");

        Password := IdentityManagement.GetMaskedNavPassword("User Security ID");
        ACSStatus := IdentityManagement.GetACSStatus("User Security ID");
        WebServiceExpiryDate := IdentityManagement.GetWebServiceExpiryDate("User Security ID");
        AuthenticationStatus := IdentityManagement.GetAuthenticationStatus("User Security ID");
        HasExchangeIdentifier := "Exchange Identifier" <> '';
        InitialState := State;

        if not IsNullGuid("Application ID") then
          ApplicationID := "Application ID";

        if PermissionManager.SoftwareAsAService and (UserId <> "User Name") then begin
          AllowChangeWebServiceAccessKey := false;
          WebServiceID := '*************************************';
        end else begin
          AllowChangeWebServiceAccessKey := true;
          WebServiceID := IdentityManagement.GetWebServicesKey("User Security ID");
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if SoftwareAsAService then
          Error(CannotDeleteUsersErr)
    end;

    trigger OnInit()
    begin
        DeployedToAzure := IdentityManagement.IsAzure;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "User Security ID" := CreateGuid;
        TestField("User Name");
    end;

    trigger OnModifyRecord(): Boolean
    begin
        TestField("User Name");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PermissionManager: Codeunit "Permission Manager";
    begin
        if PermissionManager.SoftwareAsAService then
          Error(CannotCreateUsersErr);
        WindowsUserName := '';
        Password := '';
        "Change Password" := false;
        WebServiceID := '';
        Clear(WebServiceExpiryDate);
    end;

    trigger OnOpenPage()
    var
        PermissionManager: Codeunit "Permission Manager";
    begin
        SoftwareAsAService := PermissionManager.SoftwareAsAService;

        HideExternalUsers;

        IsWindowsClient := (CurrentClientType = Clienttype::Windows);
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if "User Name" <> '' then
          exit(ValidateAuthentication);
    end;

    var
        UserSecID: Record User;
        IdentityManagement: Codeunit "Identity Management";
        WindowsUserName: Text[208];
        Text001: label 'The account %1 is not a valid Windows account.';
        Text002: label 'The account %1 already exists.';
        Text003: label 'The account %1 is not allowed.';
        Password: Text[80];
        ACSStatus: Option Disabled,Pending,Registered,Unknown;
        WebServiceID: Text[80];
        Confirm001Qst: label 'The current Web Service Access Key will not be valid after editing. All clients that use it have to be updated. Do you want to continue?';
        WebServiceExpiryDate: DateTime;
        Confirm002Qst: label 'You have not completed all necessary fields for the Credential Type that this client is currently using. The user will not be able to log in unless you provide a value in the %1 field. Are you sure that you want to close the window?';
        [InDataSet]
        DeployedToAzure: Boolean;
        Confirm003Qst: label 'The user will not be able to sign in unless you change the state to Enabled. Are you sure that you want to close the page?';
        HasExchangeIdentifier: Boolean;
        AuthenticationStatus: Option Disabled,Inactive,Active;
        Confirm004Qst: label 'The user will not be able to sign in because no authentication data was provided. Are you sure that you want to close the page?';
        ConfirmRemoveExchangeIdentifierQst: label 'If you delete the Exchange Identifier Mapping, the user will no longer automatically be signed in when they use Exchange applications.\Do you want to continue?';
        SoftwareAsAService: Boolean;
        ApplicationID: Text;
        CannotCreateUsersErr: label 'You cannot add users on this page. Administrators can add users in the Office 365 administration portal.';
        AllowChangeWebServiceAccessKey: Boolean;
        IsWindowsClient: Boolean;
        CannotDeleteUsersErr: label 'You cannot delete users on this page. Administrators can delete users in the Office 365 administration portal.';
        InitialState: Option;

    local procedure ValidateSid()
    var
        User: Record User;
    begin
        if "Windows Security ID" = '' then
          Error(Text001,"User Name");

        if ("Windows Security ID" = 'S-1-1-0') or ("Windows Security ID" = 'S-1-5-7') or ("Windows Security ID" = 'S-1-5-32-544') then
          Error(Text003,IdentityManagement.UserName("Windows Security ID"));

        User.SetFilter("Windows Security ID","Windows Security ID");
        User.SetFilter("User Security ID",'<>%1',"User Security ID");
        if not User.IsEmpty then
          Error(Text002,WindowsUserName);
    end;

    local procedure ValidateAuthentication(): Boolean
    var
        ValidationField: Text;
    begin
        UserSecID.Reset;
        if (UserSecID.Count = 1) or (UserSecurityId = "User Security ID") then begin
          if IdentityManagement.IsWindowsAuthentication and ("Windows Security ID" = '') then
            ValidationField := 'Windows User Name';

          if IdentityManagement.IsUserNamePasswordAuthentication and (Password = '') then
            ValidationField := 'Password';

          if IdentityManagement.IsAccessControlServiceAuthentication and (ACSStatus = 0) and (AuthenticationStatus = 0) then
            ValidationField := 'ACSStatus / AuthenticationStatus';

          if ValidationField <> '' then
            exit(Confirm(Confirm002Qst,false,ValidationField));
        end else begin
          if ("Windows Security ID" = '') and (Password = '') and (ACSStatus = 0) and (AuthenticationStatus = 0) then
            exit(Confirm(Confirm004Qst,false));
        end;

        if (InitialState = State::Enabled) and (State = State::Disabled) then
          exit(Confirm(Confirm003Qst,false));

        exit(true);
    end;

    local procedure ValidateUserName()
    var
        UserMgt: Codeunit "User Management";
    begin
        UserMgt.ValidateUserName(Rec,xRec,WindowsUserName);
        CurrPage.Update;
    end;

    local procedure EditWebServiceID()
    var
        PermissionManager: Codeunit "Permission Manager";
        SetWebServiceAccessKey: Page "Set Web Service Access Key";
    begin
        if PermissionManager.SoftwareAsAService and (UserSecurityId <> "User Security ID") then
          exit;

        TestField("User Name");

        if Confirm(Confirm001Qst) then begin
          UserSecID.SetCurrentkey("User Security ID");
          UserSecID.SetRange("User Security ID","User Security ID","User Security ID");
          SetWebServiceAccessKey.SetRecord(UserSecID);
          SetWebServiceAccessKey.SetTableview(UserSecID);
          if SetWebServiceAccessKey.RunModal = Action::OK then
            CurrPage.Update;
        end;
    end;

    local procedure EditNavPassword()
    var
        SetPassword: Page "Password Dialog";
    begin
        TestField("User Name");

        CurrPage.SaveRecord;
        Commit;

        UserSecID.SetCurrentkey("User Security ID");
        UserSecID.SetRange("User Security ID","User Security ID","User Security ID");
        SetPassword.SetRecord(UserSecID);
        SetPassword.SetTableview(UserSecID);
        if SetPassword.RunModal = Action::OK then
          CurrPage.Update(false);
    end;

    local procedure EditACSStatus()
    var
        UserACSSetup: Page "User ACS Setup";
    begin
        TestField("User Name");

        UserSecID.SetCurrentkey("User Security ID");
        UserSecID.SetRange("User Security ID","User Security ID","User Security ID");
        UserACSSetup.SetRecord(UserSecID);
        UserACSSetup.SetTableview(UserSecID);
        if UserACSSetup.RunModal = Action::OK then
          CurrPage.Update;
    end;

    local procedure SetUserName()
    begin
        "User Name" := WindowsUserName;
        ValidateUserName;
    end;

    local procedure HideExternalUsers()
    var
        PermissionManager: Codeunit "Permission Manager";
        OriginalFilterGroup: Integer;
    begin
        if not PermissionManager.SoftwareAsAService then
          exit;

        OriginalFilterGroup := FilterGroup;
        FilterGroup := 2;
        SetFilter("License Type",'<>%1',"license type"::"External User");
        FilterGroup := OriginalFilterGroup;
    end;

    local procedure ValidateWindowsUserName()
    var
        UserSID: Text;
    begin
        if WindowsUserName = '' then
          "Windows Security ID" := ''
        else begin
          UserSID := SID(WindowsUserName);
          WindowsUserName := IdentityManagement.UserName(UserSID);
          if WindowsUserName <> '' then begin
            "Windows Security ID" := UserSID;
            ValidateSid;
            SetUserName;
          end else
            Error(Text001,WindowsUserName);
        end;
    end;
}

