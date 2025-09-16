#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9808 "User Permission Sets"
{
    Caption = 'User Permission Sets';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Access Control";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'User Permissions';
                field(UserSecurityID;"User Security ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'User Security ID';
                    Editable = false;
                    ToolTip = 'Specifies the Windows security identification (SID) of each Windows login that has been created in the current database.';
                    Visible = false;
                }
                field(PermissionSet;"Role ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Permission Set';
                    ToolTip = 'Specifies the ID of a security role that has been assigned to this Windows login in the current database.';
                }
                field(Description;"Role Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Description';
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies the name of the security role that has been given to this Windows login in the current database.';
                }
                field(Company;"Company Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Company';
                    ToolTip = 'Specifies the name of the company that this role is limited to for this Windows login.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ShowPermissions)
            {
                Caption = 'Show Permissions';
                action(Permissions)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Permissions';
                    Image = Permission;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page Permissions;
                    RunPageLink = "Role ID"=field("Role ID");
                    ShortCutKey = 'Shift+Ctrl+p';
                    ToolTip = 'View or edit which feature objects that users need to access and set up the related permissions in permission sets that you can assign to the users of the database.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if User."User Name" <> '' then
          CurrPage.Caption := User."User Name";
    end;

    var
        User: Record User;
}

