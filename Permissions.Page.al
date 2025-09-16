#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9803 Permissions
{
    Caption = 'Permissions';
    DataCaptionFields = "Object Type","Object Name";
    DelayedInsert = true;
    PageType = Worksheet;
    PopulateAllFields = true;
    PromotedActionCategories = 'New,Process,Report,Read,Insert,Modify,Delete,Execute';
    ShowFilter = true;
    SourceTable = Permission;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group(Control42)
                {
                    field(CurrentRoleID;CurrentRoleID)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Role ID';
                        Importance = Promoted;
                        TableRelation = "Permission Set"."Role ID";
                        ToolTip = 'Specifies the ID of the role that the permissions apply to.';

                        trigger OnValidate()
                        begin
                            FillTempPermissions;
                        end;
                    }
                    field(Show;Show)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Show';
                        OptionCaption = 'Only In Permission Set,All';
                        ToolTip = 'Specifies if the selected value is shown in the window.';

                        trigger OnValidate()
                        begin
                            FillTempPermissions;
                        end;
                    }
                }
                field(AddRelatedTables;AddRelatedTables)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Add Read Permission to Related Tables';
                    ToolTip = 'Specifies that all tables that are related to the selected table will be added to the window with Read permission.';
                }
            }
            repeater(Group)
            {
                Caption = 'AllPermission';
                field(PermissionSet;"Role ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'Permission Set';
                    Enabled = false;
                    ToolTip = 'Specifies the ID of the permission sets that exist in the current database. This field is used internally.';
                    Visible = false;
                }
                field("Object Type";"Object Type")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = AllowChangePrimaryKey;
                    Style = Strong;
                    StyleExpr = ZeroObjStyleExpr;
                    ToolTip = 'Specifies the type of object that the permissions apply to in the current database.';

                    trigger OnValidate()
                    begin
                        ActivateControls;
                    end;
                }
                field("Object ID";"Object ID")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = AllowChangePrimaryKey;
                    LookupPageID = "All Objects with Caption";
                    Style = Strong;
                    StyleExpr = ZeroObjStyleExpr;
                    ToolTip = 'Specifies the ID of the object to which the permissions apply.';

                    trigger OnValidate()
                    begin
                        IsValidatedObjectID := false;
                        ActivateControls;
                    end;
                }
                field("Object Name";"Object Name")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = ZeroObjStyleExpr;
                    ToolTip = 'Specifies the name of the object to which the permissions apply.';
                }
                field(Control8;"Read Permission")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = IsTableData;
                    Style = Strong;
                    StyleExpr = ZeroObjStyleExpr;
                    ToolTip = 'Specifies information about whether the permission set has read permission to this object. The values for the field are blank, Yes, and Indirect. Indirect means permission only through another object. If the field is empty, the permission set does not have read permission.';
                }
                field(Control7;"Insert Permission")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = IsTableData;
                    Style = Strong;
                    StyleExpr = ZeroObjStyleExpr;
                    ToolTip = 'Specifies information about whether the permission set has insert permission to this object. The values for the field are blank, Yes, and Indirect. Indirect means permission only through another object. If the field is empty, the permission set does not have insert permission.';
                }
                field(Control6;"Modify Permission")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = IsTableData;
                    Style = Strong;
                    StyleExpr = ZeroObjStyleExpr;
                    ToolTip = 'Specifies information about whether the permission set has modify permission to this object. The values for the field are blank, Yes, and Indirect. Indirect means permission only through another object. If the field is empty, the permission set does not have modify permission.';
                }
                field(Control5;"Delete Permission")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = IsTableData;
                    Style = Strong;
                    StyleExpr = ZeroObjStyleExpr;
                    ToolTip = 'Specifies information about whether the permission set has delete permission to this object. The values for the field are blank, Yes, and Indirect. Indirect means permission only through another object. If the field is empty, the permission set does not have delete permission.';
                }
                field(Control4;"Execute Permission")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = not IsTableData;
                    Style = Strong;
                    StyleExpr = ZeroObjStyleExpr;
                    ToolTip = 'Specifies information about whether the permission set has execute permission to this object. The values for the field are blank, Yes, and Indirect. Indirect means permission only through another object. If the field is empty, the permission set does not have execute permission.';
                }
                field("Security Filter";"Security Filter")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = IsTableData;
                    Style = Strong;
                    StyleExpr = ZeroObjStyleExpr;
                    ToolTip = 'Specifies the security filter that is being applied to this permission set to limit the access that this permission set has to the data contained in this table.';

                    trigger OnAssistEdit()
                    var
                        TableFilter: Record "Table Filter";
                        TableFilterPage: Page "Table Filter";
                    begin
                        TableFilter.FilterGroup(2);
                        TableFilter.SetRange("Table Number","Object ID");
                        TableFilter.FilterGroup(0);
                        TableFilterPage.SetTableview(TableFilter);
                        TableFilterPage.SetSourceTable(Format("Security Filter"),"Object ID","Object Name");
                        if Action::OK = TableFilterPage.RunModal then
                          Evaluate("Security Filter",TableFilterPage.CreateTextTableFilter(false));
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Read Permission")
            {
                Caption = 'Read Permission';
                Image = Ledger;
                group("Allow Read")
                {
                    Caption = 'Allow Read';
                    Image = Confirm;
                    action(AllowReadYes)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Yes';
                        Image = Approve;
                        ToolTip = 'Allow read access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('R',"read permission"::Yes);
                        end;
                    }
                    action(AllowReadNo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'No';
                        Image = Reject;
                        ToolTip = 'Do not allow read access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('R',"read permission"::" ");
                        end;
                    }
                    action(AllowReadIndirect)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Indirect';
                        Image = Indent;
                        ToolTip = 'Allow indirect read access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('R',"read permission"::Indirect);
                        end;
                    }
                }
            }
            group("Insert Permission")
            {
                Caption = 'Insert Permission';
                Image = FiledPosted;
                group("Allow Insertion")
                {
                    Caption = 'Allow Insertion';
                    Image = Confirm;
                    action(AllowInsertYes)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Yes';
                        Image = Approve;
                        ToolTip = 'Allow insertion access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('I',"insert permission"::Yes);
                        end;
                    }
                    action(AllowInsertNo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'No';
                        Image = Reject;
                        ToolTip = 'Do not allow insertion access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('I',"insert permission"::" ");
                        end;
                    }
                    action(AllowInsertIndirect)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Indirect';
                        Image = Indent;
                        ToolTip = 'Allow indirect insertion access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('I',"insert permission"::Indirect);
                        end;
                    }
                }
            }
            group("Modify Permission")
            {
                Caption = 'Modify Permission';
                Image = Statistics;
                group("Allow Modification")
                {
                    Caption = 'Allow Modification';
                    Image = Confirm;
                    action(AllowModifyYes)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Yes';
                        Image = Approve;
                        ToolTip = 'Allow modification access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('M',"modify permission"::Yes);
                        end;
                    }
                    action(AllowModifyNo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'No';
                        Image = Reject;
                        ToolTip = 'Do not allow modification access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('M',"modify permission"::" ");
                        end;
                    }
                    action(AllowModifyIndirect)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Indirect';
                        Image = Indent;
                        ToolTip = 'Allow indirect modification access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('M',"modify permission"::Indirect);
                        end;
                    }
                }
            }
            group("Delete Permission")
            {
                Caption = 'Delete Permission';
                Image = Transactions;
                group("Allow Deletion")
                {
                    Caption = 'Allow Deletion';
                    Image = Confirm;
                    action(AllowDeleteYes)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Yes';
                        Image = Approve;
                        ToolTip = 'Allow delete access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('D',"delete permission"::Yes);
                        end;
                    }
                    action(AllowDeleteNo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'No';
                        Image = Reject;
                        ToolTip = 'Do not allow delete access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('D',"delete permission"::" ");
                        end;
                    }
                    action(AllowDeleteIndirect)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Indirect';
                        Image = Indent;
                        ToolTip = 'Allow indirect delete access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('D',"delete permission"::Indirect);
                        end;
                    }
                }
            }
            group("Execute Permission")
            {
                Caption = 'Execute Permission';
                Image = Transactions;
                group("Allow Execution")
                {
                    Caption = 'Allow Execution';
                    Image = Confirm;
                    action(AllowExecuteYes)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Yes';
                        Image = Approve;
                        ToolTip = 'Allow execution access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('X',"execute permission"::Yes);
                        end;
                    }
                    action(AllowExecuteNo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'No';
                        Image = Reject;
                        ToolTip = 'Do not allow execution access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('X',"execute permission"::" ");
                        end;
                    }
                    action(AllowExecuteIndirect)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Indirect';
                        Image = Indent;
                        ToolTip = 'Allow indirect execution access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('X',"execute permission"::Indirect);
                        end;
                    }
                }
            }
            group("All Permissions")
            {
                Caption = 'All Permissions';
                Image = Transactions;
                group("Allow All")
                {
                    Caption = 'Allow All';
                    Image = Confirm;
                    action(AllowAllYes)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Yes';
                        Image = Approve;
                        ToolTip = 'Allow full access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('*',"read permission"::Yes);
                        end;
                    }
                    action(AllowAllNo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'No';
                        Image = Reject;
                        ToolTip = 'Do not allow full access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('*',"read permission"::" ");
                        end;
                    }
                    action(AllowAllIndirect)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Indirect';
                        Image = Indent;
                        ToolTip = 'Allow indirect full access.';

                        trigger OnAction()
                        begin
                            UpdateSelected('*',"read permission"::Indirect);
                        end;
                    }
                }
            }
            group("Manage Permission Sets")
            {
                Caption = 'Manage Permission Sets';
                action(AddRelatedTablesAction)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Add Read Permission to Related Tables';
                    Image = Relationship;
                    ToolTip = 'Define read access to related tables.';

                    trigger OnAction()
                    begin
                        AddRelatedTablesToSelected;
                    end;
                }
                action(IncludeExclude)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Include/Exclude Permission Set';
                    Image = Edit;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Add or exclude a specific permission set.';

                    trigger OnAction()
                    var
                        AddSubtractPermissionSet: Report "Add/Subtract Permission Set";
                    begin
                        AddSubtractPermissionSet.SetDestination(CurrentRoleID);
                        AddSubtractPermissionSet.RunModal;
                        FillTempPermissions;
                    end;
                }
                action(ImportPermissions)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Import Permissions';
                    Image = Import;
                    ToolTip = 'Import a file with permissions.';

                    trigger OnAction()
                    begin
                        SetRange("Role ID","Role ID");
                        Xmlport.Run(Xmlport::"Import/Export Permissions",false,true,Rec);
                        Reset;
                        FillTempPermissions;
                    end;
                }
            }
            group("Code Coverage Actions")
            {
                Caption = 'Record Permissions';
                action(Start)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Start';
                    Enabled = not PermissionLoggingRunning;
                    Image = Start;
                    ToolTip = 'Start recording.';

                    trigger OnAction()
                    begin
                        if not Confirm(StartRecordingQst) then
                          exit;
                        LogTablePermissions.Start;
                        PermissionLoggingRunning := true;
                    end;
                }
                action(Stop)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Stop';
                    Enabled = PermissionLoggingRunning;
                    Image = Stop;
                    ToolTip = 'Stop recording.';

                    trigger OnAction()
                    var
                        TempTablePermissionBuffer: Record "Table Permission Buffer" temporary;
                    begin
                        LogTablePermissions.Stop(TempTablePermissionBuffer);
                        PermissionLoggingRunning := false;
                        if not Confirm(AddPermissionsQst) then
                          exit;
                        AddLoggedPermissions(TempTablePermissionBuffer);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        Permission: Record Permission;
    begin
        ActivateControls;
        SetObjectZeroName(Rec);
        if not IsNewRecord then begin
          Permission := Rec;
          PermissionRecExists := Permission.Find;
        end else
          PermissionRecExists := false;
        AllowChangePrimaryKey := not PermissionRecExists and (Show = Show::"Only In Permission Set");
        ZeroObjStyleExpr := PermissionRecExists and ("Object ID" = 0);
    end;

    trigger OnAfterGetRecord()
    begin
        SetObjectZeroName(Rec);
        ZeroObjStyleExpr := "Object ID" = 0;
        IsValidatedObjectID := false;
        IsNewRecord := false;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        Permission: Record Permission;
    begin
        if (Show = Show::All) and ("Object ID" <> 0) then
          exit(false);
        Permission := Rec;
        Permission.Find;
        exit(Permission.Delete);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Permission: Record Permission;
    begin
        if ("Object ID" = 0) and ((Show = Show::All) or IsValidatedObjectID) then
          exit(false);
        if ("Execute Permission" = "execute permission"::" ") and
           ("Read Permission" = "read permission"::" ") and
           ("Insert Permission" = "insert permission"::" ") and
           ("Modify Permission" = "modify permission"::" ") and
           ("Delete Permission" = "delete permission"::" ")
        then
          exit(false);

        if "Object Type" = "object type"::"Table Data" then
          "Execute Permission" := "execute permission"::" "
        else begin
          "Read Permission" := "read permission"::" ";
          "Insert Permission" := "insert permission"::" ";
          "Modify Permission" := "modify permission"::" ";
          "Delete Permission" := "delete permission"::" ";
        end;
        Permission := Rec;
        Permission.Insert;
        if AddRelatedTables then
          DoAddRelatedTables(Rec);
        Rec := Permission;
        SetObjectZeroName(Rec);
        PermissionRecExists := true;
        IsNewRecord := false;
        ZeroObjStyleExpr := "Object ID" = 0;
        exit(true);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ModifyRecord(Rec);
        PermissionRecExists := true;
        IsNewRecord := false;
        exit(Modify);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ActivateControls;
        PermissionRecExists := false;
        IsNewRecord := true;
        IsValidatedObjectID := false;
    end;

    trigger OnOpenPage()
    var
        PermissionSet: Record "Permission Set";
    begin
        if CurrentRoleID = '' then
          if GetFilter("Role ID") <> '' then
            CurrentRoleID := GetRangeMin("Role ID")
          else
            if PermissionSet.FindFirst then
              CurrentRoleID := PermissionSet."Role ID";
        Reset;
        FillTempPermissions;
    end;

    var
        LogTablePermissions: Codeunit "Log Table Permissions";
        CurrentRoleID: Code[20];
        Show: Option "Only In Permission Set",All;
        AddRelatedTables: Boolean;
        [InDataSet]
        IsTableData: Boolean;
        IsNewRecord: Boolean;
        IsValidatedObjectID: Boolean;
        PermissionRecExists: Boolean;
        AllowChangePrimaryKey: Boolean;
        AddPermissionsQst: label 'Do you want to add the recorded permissions?';
        StartRecordingQst: label 'Do you want to start the recording now?';
        AllObjTxt: label 'All objects of type %1', Comment='%1= type name, e.g. Table Data or Report or Page';
        ZeroObjStyleExpr: Boolean;
        PermissionLoggingRunning: Boolean;

    local procedure FillTempPermissions()
    var
        TempPermission: Record Permission temporary;
        Permission: Record Permission;
    begin
        TempPermission.Copy(Rec,true);
        TempPermission.Reset;
        TempPermission.DeleteAll;
        FilterGroup(2);
        SetRange("Role ID",CurrentRoleID);
        Permission.SetRange("Role ID",CurrentRoleID);
        FilterGroup(0);

        if Permission.Find('-') then
          repeat
            TempPermission := Permission;
            TempPermission.Insert;
          until Permission.Next = 0;

        if Show = Show::All then
          FillTempPermissionsForAllObjects(TempPermission);
        IsNewRecord := false;
        if Find('=<>') then;
        CurrPage.Update(false);
    end;

    local procedure FillTempPermissionsForAllObjects(var Permission: Record Permission)
    var
        TempPermission: Record Permission temporary;
        AllObj: Record AllObj;
    begin
        AllObj.SetRange("Object Type");
        TempPermission.Copy(Permission,true);
        TempPermission.Init;
        if AllObj.FindSet then
          repeat
            TempPermission."Object Type" := AllObj."Object Type";
            TempPermission."Object ID" := AllObj."Object ID";
            TempPermission."Read Permission" := "read permission"::" ";
            TempPermission."Insert Permission" := "insert permission"::" ";
            TempPermission."Modify Permission" := "modify permission"::" ";
            TempPermission."Delete Permission" := "delete permission"::" ";
            TempPermission."Execute Permission" := "execute permission"::" ";
            SetObjectZeroName(TempPermission);
            if TempPermission.Insert then;
          until AllObj.Next = 0;
    end;

    local procedure ActivateControls()
    begin
        IsTableData := "Object Type" = "object type"::"Table Data"
    end;

    local procedure ModifyRecord(var ModifiedPermission: Record Permission)
    var
        Permission: Record Permission;
        IsNewPermission: Boolean;
    begin
        Permission.LockTable;
        IsNewPermission :=
          not Permission.Get(ModifiedPermission."Role ID",ModifiedPermission."Object Type",ModifiedPermission."Object ID");
        if IsNewPermission then begin
          Permission.TransferFields(ModifiedPermission,true);
          Permission.Insert;
        end else begin
          Permission.TransferFields(ModifiedPermission,false);
          Permission.Modify;
        end;

        if (Permission."Read Permission" = 0) and
           (Permission."Insert Permission" = 0) and
           (Permission."Modify Permission" = 0) and
           (Permission."Delete Permission" = 0) and
           (Permission."Execute Permission" = 0)
        then begin
          Permission.Delete;
          if Show = Show::"Only In Permission Set" then
            ModifiedPermission.Delete;
          IsNewPermission := false;
        end;
        if IsNewPermission and AddRelatedTables then
          DoAddRelatedTables(ModifiedPermission);
    end;

    local procedure UpdateSelected(RIMDX: Text[1];PermissionOption: Option)
    var
        TempPermission: Record Permission temporary;
        OrgPermission: Record Permission;
    begin
        OrgPermission := Rec;
        TempPermission.Copy(Rec,true);
        CurrPage.SetSelectionFilter(TempPermission);

        if TempPermission.FindSet then
          repeat
            case RIMDX of
              'R':
                if TempPermission."Object Type" = "object type"::"Table Data" then
                  TempPermission."Read Permission" := PermissionOption;
              'I':
                if TempPermission."Object Type" = "object type"::"Table Data" then
                  TempPermission."Insert Permission" := PermissionOption;
              'M':
                if TempPermission."Object Type" = "object type"::"Table Data" then
                  TempPermission."Modify Permission" := PermissionOption;
              'D':
                if TempPermission."Object Type" = "object type"::"Table Data" then
                  TempPermission."Delete Permission" := PermissionOption;
              'X':
                if TempPermission."Object Type" <> "object type"::"Table Data" then
                  TempPermission."Execute Permission" := PermissionOption;
              '*':
                begin
                  if TempPermission."Object Type" = "object type"::"Table Data" then begin
                    TempPermission."Read Permission" := PermissionOption;
                    TempPermission."Insert Permission" := PermissionOption;
                    TempPermission."Modify Permission" := PermissionOption;
                    TempPermission."Delete Permission" := PermissionOption;
                  end else
                    TempPermission."Execute Permission" := PermissionOption;
                end;
            end;
            ModifyRecord(TempPermission);
            if Get(TempPermission."Role ID",TempPermission."Object Type",TempPermission."Object ID") then begin
              Rec := TempPermission;
              Modify;
            end;
          until TempPermission.Next = 0;

        Rec := OrgPermission;
        if Find then;
    end;

    local procedure AddRelatedTablesToSelected()
    var
        TempPermission: Record Permission temporary;
    begin
        TempPermission.Copy(Rec,true);
        CurrPage.SetSelectionFilter(TempPermission);
        if TempPermission.FindSet then
          repeat
            DoAddRelatedTables(TempPermission);
          until TempPermission.Next = 0;
        if Find then;
    end;

    local procedure AddLoggedPermissions(var TablePermissionBuffer: Record "Table Permission Buffer")
    begin
        TablePermissionBuffer.SetRange("Session ID",SessionId);
        if TablePermissionBuffer.FindSet then
          repeat
            AddPermission(CurrentRoleID,
              TablePermissionBuffer."Object Type",
              TablePermissionBuffer."Object ID",
              TablePermissionBuffer."Read Permission",
              TablePermissionBuffer."Insert Permission",
              TablePermissionBuffer."Modify Permission",
              TablePermissionBuffer."Delete Permission",
              TablePermissionBuffer."Execute Permission");
          until TablePermissionBuffer.Next = 0;
        TablePermissionBuffer.DeleteAll;
    end;

    local procedure DoAddRelatedTables(var Permission: Record Permission)
    var
        TableRelationsMetadata: Record "Table Relations Metadata";
    begin
        if Permission."Object Type" <> Permission."object type"::"Table Data" then
          exit;
        if Permission."Object ID" = 0 then
          exit;

        TableRelationsMetadata.SetRange("Table ID",Permission."Object ID");
        TableRelationsMetadata.SetFilter("Related Table ID",'>0&<>%1',Permission."Object ID");
        if TableRelationsMetadata.FindSet then
          repeat
            AddPermission(
              CurrentRoleID,"object type"::"Table Data",TableRelationsMetadata."Related Table ID","read permission"::Yes,
              "insert permission"::" ","modify permission"::" ","delete permission"::" ","execute permission"::" ");
          until TableRelationsMetadata.Next = 0;
    end;

    local procedure AddPermission(RoleID: Code[20];ObjectType: Option;ObjectID: Integer;AddRead: Option;AddInsert: Option;AddModify: Option;AddDelete: Option;AddExecute: Option): Boolean
    var
        Permission: Record Permission;
        LogTablePermissions: Codeunit "Log Table Permissions";
    begin
        if not Get(RoleID,ObjectType,ObjectID) then begin
          Init;
          "Role ID" := RoleID;
          "Object Type" := ObjectType;
          "Object ID" := ObjectID;
          "Read Permission" := "read permission"::" ";
          "Insert Permission" := "insert permission"::" ";
          "Modify Permission" := "modify permission"::" ";
          "Delete Permission" := "delete permission"::" ";
          "Execute Permission" := "execute permission"::" ";
          Insert;
          Permission.TransferFields(Rec,true);
          Permission.Insert;
        end;

        "Read Permission" := LogTablePermissions.GetMaxPermission("Read Permission",AddRead);
        "Insert Permission" := LogTablePermissions.GetMaxPermission("Insert Permission",AddInsert);
        "Modify Permission" := LogTablePermissions.GetMaxPermission("Modify Permission",AddModify);
        "Delete Permission" := LogTablePermissions.GetMaxPermission("Delete Permission",AddDelete);
        "Execute Permission" := LogTablePermissions.GetMaxPermission("Execute Permission",AddExecute);

        SetObjectZeroName(Rec);
        Modify;
        Permission.LockTable;
        if not Permission.Get(RoleID,ObjectType,ObjectID) then begin
          Permission.TransferFields(Rec,true);
          Permission.Insert;
        end else begin
          Permission.TransferFields(Rec,false);
          Permission.Modify;
        end;
        exit(true);
    end;

    local procedure SetObjectZeroName(var Permission: Record Permission)
    begin
        if Permission."Object ID" <> 0 then
          exit;
        Permission."Object Name" := CopyStr(StrSubstNo(AllObjTxt,Permission."Object Type"),1,MaxStrLen(Permission."Object Name"));
    end;
}

