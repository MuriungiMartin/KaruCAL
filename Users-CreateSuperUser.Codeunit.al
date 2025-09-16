#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9000 "Users - Create Super User"
{

    trigger OnRun()
    var
        User: Record User;
        PermissionSet: Record "Permission Set";
    begin
        if not User.IsEmpty then
          exit;

        GetSuperRole(PermissionSet);
        CreateUser(User,UserId,SID);
        AssignPermissionSetToUser(User,PermissionSet);
    end;

    var
        SuperPermissonSetDescTxt: label 'This user has all permissions.';

    local procedure GetSuperRole(var PermissionSet: Record "Permission Set")
    var
        Permission: Record Permission;
    begin
        if PermissionSet.Get('SUPER') then
          exit;
        PermissionSet."Role ID" := 'SUPER';
        PermissionSet.Name := CopyStr(SuperPermissonSetDescTxt,1,MaxStrLen(PermissionSet.Name));
        PermissionSet.Insert(true);
        AddPermissionToPermissionSet(PermissionSet,Permission."object type"::"Table Data",0);
        AddPermissionToPermissionSet(PermissionSet,Permission."object type"::Table,0);
        AddPermissionToPermissionSet(PermissionSet,Permission."object type"::Report,0);
        AddPermissionToPermissionSet(PermissionSet,Permission."object type"::Codeunit,0);
        AddPermissionToPermissionSet(PermissionSet,Permission."object type"::XMLport,0);
        AddPermissionToPermissionSet(PermissionSet,Permission."object type"::MenuSuite,0);
        AddPermissionToPermissionSet(PermissionSet,Permission."object type"::Page,0);
        AddPermissionToPermissionSet(PermissionSet,Permission."object type"::Query,0);
        AddPermissionToPermissionSet(PermissionSet,Permission."object type"::System,0);
    end;

    local procedure CreateUser(var User: Record User;UserName: Code[50];WindowsSecurityID: Text[119])
    begin
        User.Init;
        User."User Security ID" := CreateGuid;
        User."User Name" := UserName;
        User."Windows Security ID" := WindowsSecurityID;
        User.Insert(true);
    end;

    local procedure AddPermissionToPermissionSet(var PermissionSet: Record "Permission Set";ObjectType: Option;ObjectID: Integer)
    var
        Permission: Record Permission;
    begin
        with Permission do begin
          Init;
          "Role ID" := PermissionSet."Role ID";
          "Object Type" := ObjectType;
          "Object ID" := ObjectID;
          if "Object Type" = "object type"::"Table Data" then
            "Execute Permission" := "execute permission"::" "
          else begin
            "Read Permission" := "read permission"::" ";
            "Insert Permission" := "insert permission"::" ";
            "Modify Permission" := "modify permission"::" ";
            "Delete Permission" := "delete permission"::" ";
          end;
          Insert(true);
        end;
    end;

    local procedure AssignPermissionSetToUser(var User: Record User;var PermissionSet: Record "Permission Set")
    var
        AccessControl: Record "Access Control";
    begin
        AccessControl.SetRange("User Security ID",User."User Security ID");
        AccessControl.SetRange("Role ID",PermissionSet."Role ID");
        if not AccessControl.IsEmpty then
          exit;
        AccessControl."User Security ID" := User."User Security ID";
        AccessControl."Role ID" := PermissionSet."Role ID";
        AccessControl.Insert(true);
    end;


    procedure AddUserAsSuper(var User: Record User)
    var
        PermissionSet: Record "Permission Set";
    begin
        GetSuperRole(PermissionSet);
        AssignPermissionSetToUser(User,PermissionSet);
    end;
}

