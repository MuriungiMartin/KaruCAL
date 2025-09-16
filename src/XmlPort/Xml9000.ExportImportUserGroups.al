#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 9000 "Export/Import User Groups"
{
    Caption = 'Export/Import User Groups';
    UseRequestPage = false;

    schema
    {
        textelement(UserGroups)
        {
            tableelement("User Group";"User Group")
            {
                XmlName = 'UserGroup';
                fieldelement(Code;"User Group".Code)
                {
                }
                fieldelement(Name;"User Group".Name)
                {
                }
                tableelement("User Group Permission Set";"User Group Permission Set")
                {
                    LinkFields = "User Group Code"=field(Code);
                    LinkTable = "User Group";
                    XmlName = 'UserGroupPermissionSet';
                    SourceTableView = sorting("User Group Code","Role ID","App ID") order(ascending);
                    fieldelement(UserGroupCode;"User Group Permission Set"."User Group Code")
                    {
                    }
                    fieldelement(RoleId;"User Group Permission Set"."Role ID")
                    {
                        FieldValidate = no;
                    }
                    fieldelement(Scope;"User Group Permission Set".Scope)
                    {
                    }
                    fieldelement(AppID;"User Group Permission Set"."App ID")
                    {
                        FieldValidate = no;
                    }

                    trigger OnAfterInsertRecord()
                    begin
                        NoOfUserGroupPermissionSetsInserted += 1;
                    end;

                    trigger OnBeforeInsertRecord()
                    var
                        UserGroupPermissionSet: Record "User Group Permission Set";
                        PermissionSet: Record "Permission Set";
                    begin
                        if UserGroupPermissionSet.Get(
                             "User Group Permission Set"."User Group Code",
                             "User Group Permission Set"."Role ID","User Group Permission Set".Scope,"User Group Permission Set"."App ID")
                        then
                          currXMLport.Skip;
                        if not PermissionSet.Get("User Group Permission Set"."Role ID") then
                          currXMLport.Skip;
                    end;
                }

                trigger OnAfterInsertRecord()
                begin
                    NoOfUserGroupsInserted += 1;
                end;

                trigger OnBeforeInsertRecord()
                var
                    UserGroup: Record "User Group";
                begin
                    IsImport := true;
                    if UserGroup.Get("User Group".Code) then
                      currXMLport.Skip;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        if IsImport then
          Message(InsertedMsg,NoOfUserGroupsInserted,NoOfUserGroupPermissionSetsInserted);
    end;

    var
        IsImport: Boolean;
        NoOfUserGroupsInserted: Integer;
        NoOfUserGroupPermissionSetsInserted: Integer;
        InsertedMsg: label '%1 user groups with a total of %2 user group permission sets were inserted.', Comment='%1 and %2 are numbers/quantities.';
}

