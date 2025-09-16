#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9830 "User Groups"
{
    ApplicationArea = Basic;
    Caption = 'User Groups';
    DataCaptionFields = "Code",Name;
    PageType = List;
    SourceTable = "User Group";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code of the record.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the record.';
                }
                field("Default Profile ID";"Default Profile ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Default Profile';
                    ToolTip = 'Specifies the default profile for members in this user group. The profile determines the layout of the home page.';
                }
                field("Assign to All New Users";"Assign to All New Users")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Assign to All New Users';
                    ToolTip = 'Specifies that new users are automatically added to this user group when you import them from Office 365.';
                    Visible = SoftwareAsAService;
                }
            }
        }
        area(factboxes)
        {
            part(Control12;"User Group Permissions FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "User Group Code"=field(Code);
            }
            part(Control11;"User Group Members FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "User Group Code"=field(Code);
            }
            systempart(Control6;Notes)
            {
            }
            systempart(Control7;MyNotes)
            {
            }
            systempart(Control8;Links)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(UserGroupMembers)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'User Group Members';
                Image = Users;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "User Group Members";
                RunPageLink = "User Group Code"=field(Code);
                Scope = Repeater;
                ToolTip = 'View or edit the members of the user group.';
            }
            action(UserGroupPermissionSets)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'User Group Permission Sets';
                Image = Permission;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "User Group Permission Sets";
                RunPageLink = "User Group Code"=field(Code);
                Scope = Repeater;
                ToolTip = 'View or edit the permission sets that are assigned to the user group.';
            }
            action(PageUserbyUserGroup)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'User by User Group';
                Image = User;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "User by User Group";
                ToolTip = 'View and assign user groups to users.';
            }
            action(PagePermissionSetbyUserGroup)
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
        area(processing)
        {
            action(CopyUserGroup)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Copy User Group';
                Ellipsis = true;
                Image = Copy;
                Promoted = true;
                ToolTip = 'Create a copy of the current user group with a name that you specify.';

                trigger OnAction()
                var
                    UserGroup: Record "User Group";
                begin
                    UserGroup.SetRange(Code,Code);
                    Report.RunModal(Report::"Copy User Group",true,false,UserGroup);
                end;
            }
            action(ExportUserGroups)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Export User Groups';
                Image = ExportFile;
                ToolTip = 'Export the existing user groups to an XML file.';

                trigger OnAction()
                begin
                    ExportUserGroups('');
                end;
            }
            action(ImportUserGroups)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Import User Groups';
                Image = Import;
                ToolTip = 'Import user groups from an XML file.';

                trigger OnAction()
                begin
                    ImportUserGroups('');
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        PermissionManager: Codeunit "Permission Manager";
    begin
        SoftwareAsAService := PermissionManager.SoftwareAsAService;
    end;

    var
        SoftwareAsAService: Boolean;
}

