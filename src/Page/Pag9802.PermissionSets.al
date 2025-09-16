#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9802 "Permission Sets"
{
    ApplicationArea = Basic;
    Caption = 'Permission Sets';
    PageType = List;
    SourceTable = "Aggregate Permission Set";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Permission Set';
                field(PermissionSet;"Role ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Permission Set';
                    Editable = RoleIDEditable;
                    ToolTip = 'Specifies the permission set.';
                }
                field("<Name>";Name)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of the record.';
                }
                field("App Name";"App Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Extension Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the extension.';
                }
            }
        }
        area(factboxes)
        {
            part(Control17;"Permissions FactBox")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Permissions';
                SubPageLink = "Role ID"=field("Role ID");
            }
            part(Control19;"Tenant Permissions FactBox")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Tenant Permissions';
                Editable = false;
                SubPageLink = "Role ID"=field("Role ID"),
                              "App ID"=field("App ID");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ShowPermissions)
            {
                Caption = 'Permissions';
                Image = Permission;
                action(Permissions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Permissions';
                    Image = Permission;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+Ctrl+p';

                    trigger OnAction()
                    var
                        Permission: Record Permission;
                        Permissions: Page Permissions;
                    begin
                        Permission.SetRange("Role ID","Role ID");
                        Permissions.SetRecord(Permission);
                        Permissions.SetTableview(Permission);
                        Permissions.Editable := PermissionEditable;
                        Permissions.Run;
                    end;
                }
                action("Permission Set by User")
                {
                    ApplicationArea = Basic;
                    Caption = 'Permission Set by User';
                    Image = Permission;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Permission Set by User";
                }
                action("Permission Set by User Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'Permission Set by User Group';
                    Image = Permission;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Permission Set by User Group";
                }
            }
            group("User Groups")
            {
                Caption = 'User Groups';
                action("User by User Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'User by User Group';
                    Image = User;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "User by User Group";
                }
                action(UserGroups)
                {
                    ApplicationArea = Basic;
                    Caption = 'User Groups';
                    Image = Users;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "User Groups";
                }
            }
        }
        area(processing)
        {
            group("<Functions>")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("<CopyPermissionSet>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Permission Set';
                    Ellipsis = true;
                    Enabled = PermissionEditable;
                    Image = Copy;

                    trigger OnAction()
                    var
                        PermissionSet: Record "Permission Set";
                        CopyPermissionSet: Report "Copy Permission Set";
                        NullGUID: Guid;
                    begin
                        PermissionSet.SetRange("Role ID","Role ID");
                        CopyPermissionSet.SetTableview(PermissionSet);
                        CopyPermissionSet.RunModal;

                        if Get(Scope::System,NullGUID,CopyPermissionSet.GetRoleId) then;
                    end;
                }
                action(ImportPermissions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Permissions';
                    Image = Import;

                    trigger OnAction()
                    begin
                        Xmlport.Run(Xmlport::"Import/Export Permissions",false,true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PermissionEditable := IsNullGuid("App ID");
        RoleIDEditable := false;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        PermissionSet: Record "Permission Set";
    begin
        if not IsNullGuid("App ID") then
          Error(AlterAppPermSetErr);

        PermissionSet.Get("Role ID");
        PermissionSet.Delete;
        CurrPage.Update;
        PermissionEditable := IsNullGuid("App ID");
        exit(false); // Causes UI to stop processing the action - we handled it manually
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        PermissionSet: Record "Permission Set";
    begin
        PermissionSet.Init;
        PermissionSet."Role ID" := "Role ID";
        PermissionSet.Name := Name;
        PermissionSet.Insert;
        PermissionEditable := IsNullGuid("App ID");
        RoleIDEditable := false;
        exit(false); // Causes UI to stop processing the action - we handled it manually
    end;

    trigger OnModifyRecord(): Boolean
    var
        PermissionSet: Record "Permission Set";
    begin
        if not IsNullGuid("App ID") then
          Error(AlterAppPermSetErr);

        PermissionSet.Get(xRec."Role ID");
        if xRec."Role ID" <> "Role ID" then begin
          PermissionSet.Rename(xRec."Role ID","Role ID");
          PermissionSet.Get("Role ID");
        end;
        PermissionSet.Name := Name;
        PermissionSet.Modify;
        PermissionEditable := IsNullGuid("App ID");
        exit(false); // Causes UI to stop processing the action - we handled it manually
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Allow edits only on a new record - underlying tables do not allow renames.
        RoleIDEditable := true;
    end;

    var
        AlterAppPermSetErr: label 'You cannot modify application-level permission sets.';
        PermissionEditable: Boolean;
        RoleIDEditable: Boolean;
}

