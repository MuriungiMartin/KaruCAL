#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9800 Users
{
    ApplicationArea = Basic;
    Caption = 'Users';
    CardPageID = "User Card";
    DelayedInsert = true;
    PageType = List;
    SourceTable = User;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Security ID";"User Security ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an ID that uniquely identifies the user. This value is generated automatically and should not be changed.';
                    Visible = false;
                }
                field("User Name";"User Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'User Name';
                    ToolTip = 'Specifies the user''s name. If the user is required to present credentials when starting the client, this is the name that the user must present.';

                    trigger OnValidate()
                    begin
                        ValidateUserName;
                    end;
                }
                field("Full Name";"Full Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Full Name';
                    Editable = not SoftwareAsAService;
                    ToolTip = 'Specifies the full name of the user.';
                }
                field("Windows Security ID";"Windows Security ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Windows Security ID of the user. This is only relevant for Windows authentication.';
                    Visible = false;
                }
                field("Windows User Name";WindowsUserName)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Windows User Name';
                    ToolTip = 'Specifies the user''s name on Windows.';
                    Visible = not SoftwareAsAService;

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
                    var
                        UserSID: Text;
                    begin
                        if WindowsUserName = '' then begin
                          "Windows Security ID" := '';
                        end else begin
                          UserSID := SID(WindowsUserName);
                          WindowsUserName := IdentityManagement.UserName(UserSID);
                          if WindowsUserName <> '' then begin
                            "Windows Security ID" := UserSID;
                            ValidateSid;
                            SetUserName;
                          end else begin
                            Error(Text001,WindowsUserName);
                          end
                        end;
                    end;
                }
                field("License Type";"License Type")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'License Type';
                    ToolTip = 'Specifies the type of license that applies to the user. For more information, see License Types.';
                    Visible = not SoftwareAsAService;
                }
                field(State;State)
                {
                    ApplicationArea = Basic;
                    Caption = 'State';
                }
                field("Authentication Email";"Authentication Email")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the Microsoft account that this user signs into Office 365 or SharePoint Online with.';
                    Visible = SoftwareAsAService;
                }
            }
        }
        area(factboxes)
        {
            part(Control18;"Permission Sets FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "User Security ID"=field("User Security ID");
            }
            part(Control17;"User Group Memberships FactBox")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'User Group Memberships';
                SubPageLink = "User Security ID"=field("User Security ID");
            }
            part(Control20;"User Setup FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "User ID"=field("User Name");
            }
            part(Control33;"Inherited Permission Sets Part")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "User SID"=field("User Security ID");
            }
            part(Control32;"Printer Selections FactBox")
            {
                ShowFilter = false;
                SubPageLink = "User ID"=field("User Name");
            }
            part(Control28;"My Customers")
            {
                Editable = false;
                ShowFilter = false;
                SubPageLink = "User ID"=field("User Name");
                Visible = false;
            }
            part(Control29;"My Vendors")
            {
                Editable = false;
                ShowFilter = false;
                SubPageLink = "User ID"=field("User Name");
                Visible = false;
            }
            part(Control30;"My Items")
            {
                Editable = false;
                ShowFilter = false;
                SubPageLink = "User ID"=field("User Name");
                Visible = false;
            }
            systempart(Control11;Notes)
            {
                Visible = false;
            }
            systempart(Control12;Links)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("User Groups")
            {
                Caption = 'User Groups';
                action(Action15)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'User Groups';
                    Image = Users;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "User Groups";
                    ToolTip = 'Set up or modify user groups as a fast way of giving users access to the functionality that is relevant to their work.';
                }
            }
            group(Permissions)
            {
                Caption = 'Permissions';
                action("Permission Sets")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Permission Sets';
                    Image = Permission;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Permission Sets";
                    ToolTip = 'View or edit which feature objects that users need to access and set up the related permissions in permission sets that you can assign to the users of the database.';
                }
                action("Permission Set by User")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Permission Set by User';
                    Image = Permission;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Permission Set by User";
                    ToolTip = 'View or edit the available permission sets and apply permission sets to existing users.';
                }
                action("Permission Set by User Group")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Permission Set by User Group';
                    Image = Permission;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Permission Set by User Group";
                    ToolTip = 'View or edit the available permission sets and apply permission sets to existing user groups.';
                }
            }
            action("User Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'User Setup';
                Image = UserSetup;
                RunObject = Page "User Setup";
                ToolTip = 'Set up users to restrict access to post to the general ledger.';
            }
            action("Printer Selections")
            {
                ApplicationArea = Basic;
                Caption = 'Printer Selections';
                Image = Print;
                RunObject = Page "Printer Selections";
                ToolTip = 'Assign printers to users and/or reports so that a user always uses a specific printer, or a specific report only prints on a specific printer.';
            }
            action("Warehouse Employees")
            {
                ApplicationArea = Basic;
                Caption = 'Warehouse Employees';
                Image = WarehouseSetup;
                RunObject = Page "Warehouse Employees";
            }
            action("FA Journal Setup")
            {
                ApplicationArea = FixedAssets;
                Caption = 'FA Journal Setup';
                Image = FixedAssets;
                RunObject = Page "FA Journal Setup";
                ToolTip = 'Set up journals, journal templates, and journal batches for fixed assets.';
            }
        }
        area(creation)
        {
            action(AddMeAsSuper)
            {
                ApplicationArea = All;
                Caption = 'Add me as Administrator';
                Image = User;
                Promoted = true;
                ToolTip = 'Assign the Administrator status to your user account.';
                Visible = NoUserExists and (not SoftwareAsAService);

                trigger OnAction()
                begin
                    if Confirm(StrSubstNo(CreateQst,UserId),false) then
                      Codeunit.Run(Codeunit::"Users - Create Super User");
                end;
            }
            action("Get Users from Office 365")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Get Users from Office 365';
                Image = Users;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Gets updated information about users from the Office portal.';
                Visible = SoftwareAsAService;

                trigger OnAction()
                var
                    AzureADUserManagement: Codeunit "Azure AD User Management";
                begin
                    AzureADUserManagement.CreateNewUsersFromAzureAD;
                    CurrPage.Update;
                end;
            }
            action("Restore User Default User Groups")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Restore User''s Default User Groups';
                Image = UserInterface;
                ToolTip = 'Restore the default user groups for the user’s subscription plan.';
                Visible = SoftwareAsAService;

                trigger OnAction()
                var
                    PermissionManager: Codeunit "Permission Manager";
                    AzureADUserManagement: Codeunit "Azure AD User Management";
                begin
                    AzureADUserManagement.UpdateUserPlansFromAzureGraphAllUsers;
                    PermissionManager.ResetUserToDefaultUserGroups("User Security ID");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        WindowsUserName := IdentityManagement.UserName("Windows Security ID");
        NoUserExists := false;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if SoftwareAsAService then
          Error(CannotDeleteUsersErr)
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if SoftwareAsAService then
          Error(CannotCreateUsersErr);
        if "User Name" = '' then
          Error(Text004,FieldCaption("User Name"));
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "User Security ID" := CreateGuid;
        WindowsUserName := '';
    end;

    trigger OnOpenPage()
    var
        PermissionManager: Codeunit "Permission Manager";
    begin
        NoUserExists := IsEmpty;
        SoftwareAsAService := PermissionManager.SoftwareAsAService;

        HideExternalUsers;
    end;

    var
        IdentityManagement: Codeunit "Identity Management";
        WindowsUserName: Text[208];
        Text001: label 'The account %1 is not a valid Windows account.';
        Text002: label 'The account %1 already exists.';
        Text003: label 'The account %1 is not allowed.';
        Text004: label '%1 cannot be empty.';
        NoUserExists: Boolean;
        CreateQst: label 'Do you want to create %1 as super user?', Comment='%1=user name, e.g. europe\myaccountname';
        SoftwareAsAService: Boolean;
        CannotCreateUsersErr: label 'You cannot add users on this page. Administrators can add users in the Office 365 administration portal.';
        CannotDeleteUsersErr: label 'You cannot delete users on this page. Administrators can delete users in the Office 365 administration portal.';

    local procedure ValidateSid()
    var
        User: Record User;
    begin
        if "Windows Security ID" = '' then
          Error(Text001,"User Name");

        if ("Windows Security ID" = 'S-1-1-0') or ("Windows Security ID" = 'S-1-5-7') then
          Error(Text003,"User Name");

        User.SetFilter("Windows Security ID","Windows Security ID");
        User.SetFilter("User Security ID",'<>%1',"User Security ID");
        if not User.IsEmpty then
          Error(Text002,WindowsUserName);
    end;

    local procedure ValidateUserName()
    var
        UserMgt: Codeunit "User Management";
    begin
        UserMgt.ValidateUserName(Rec,xRec,WindowsUserName);
        CurrPage.Update;
    end;

    local procedure SetUserName()
    begin
        "User Name" := WindowsUserName;
        ValidateUserName;
    end;


    procedure GetSelectionFilter(var User: Record User)
    begin
        CurrPage.SetSelectionFilter(User);
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
}

