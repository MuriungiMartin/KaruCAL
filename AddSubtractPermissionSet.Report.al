#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 9000 "Add/Subtract Permission Set"
{
    Caption = 'Add/Subtract Permission Set';
    ProcessingOnly = true;

    dataset
    {
        dataitem(SourcePermission;Permission)
        {
            DataItemTableView = sorting("Role ID","Object Type","Object ID") order(ascending);
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            var
                DestinationPermission: Record Permission;
            begin
                case SetOperation of
                  Setoperation::Include:
                    if DestinationPermission.Get(DestinationPermissionSet,"Object Type","Object ID") then begin
                      if PermissionValueIsGreaterOrEqual("Read Permission",DestinationPermission."Read Permission") then
                        DestinationPermission."Read Permission" := "Read Permission";
                      if PermissionValueIsGreaterOrEqual("Insert Permission",DestinationPermission."Insert Permission") then
                        DestinationPermission."Insert Permission" := "Insert Permission";
                      if PermissionValueIsGreaterOrEqual("Modify Permission",DestinationPermission."Modify Permission") then
                        DestinationPermission."Modify Permission" := "Modify Permission";
                      if PermissionValueIsGreaterOrEqual("Delete Permission",DestinationPermission."Delete Permission") then
                        DestinationPermission."Delete Permission" := "Delete Permission";
                      if PermissionValueIsGreaterOrEqual("Execute Permission",DestinationPermission."Execute Permission") then
                        DestinationPermission."Execute Permission" := "Execute Permission";
                      DestinationPermission.Modify;
                    end else begin
                      DestinationPermission := SourcePermission;
                      DestinationPermission."Role ID" := DestinationPermissionSet;
                      DestinationPermission.Insert;
                    end;
                  Setoperation::Exclude:
                    begin
                      DestinationPermission.SetRange("Role ID",DestinationPermissionSet);
                      DestinationPermission.SetRange("Object Type","Object Type");
                      if "Object ID" <> 0 then
                        DestinationPermission.SetRange("Object ID","Object ID");
                      if DestinationPermission.FindSet then
                        repeat
                          if PermissionValueIsGreaterOrEqual("Read Permission",DestinationPermission."Read Permission") then
                            DestinationPermission."Read Permission" := "read permission"::" ";
                          if PermissionValueIsGreaterOrEqual("Insert Permission",DestinationPermission."Insert Permission") then
                            DestinationPermission."Insert Permission" := "insert permission"::" ";
                          if PermissionValueIsGreaterOrEqual("Modify Permission",DestinationPermission."Modify Permission") then
                            DestinationPermission."Modify Permission" := "modify permission"::" ";
                          if PermissionValueIsGreaterOrEqual("Delete Permission",DestinationPermission."Delete Permission") then
                            DestinationPermission."Delete Permission" := "delete permission"::" ";
                          if PermissionValueIsGreaterOrEqual("Execute Permission",DestinationPermission."Execute Permission") then
                            DestinationPermission."Execute Permission" := "execute permission"::" ";
                          DestinationPermission.Modify;
                          if (DestinationPermission."Read Permission" = "read permission"::" ") and
                             (DestinationPermission."Insert Permission" = "read permission"::" ") and
                             (DestinationPermission."Modify Permission" = "read permission"::" ") and
                             (DestinationPermission."Delete Permission" = "read permission"::" ") and
                             (DestinationPermission."Execute Permission" = "read permission"::" ")
                          then
                            DestinationPermission.Delete;
                        until DestinationPermission.Next = 0;
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Role ID",SourcePermissionSet);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(DestinationPermissionSet;DestinationPermissionSet)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Destination';
                    Editable = false;
                    TableRelation = "Permission Set"."Role ID";
                    ToolTip = 'Specifies the permission set for which permission sets are included or excluded.';
                }
                field(SetOperation;SetOperation)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Operation';
                    OptionCaption = 'Include,Exclude';
                    ToolTip = 'Specifies if the batch job includes or excludes a permission set for the destination permission set.';
                }
                field(SourcePermissionSet;SourcePermissionSet)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Source';
                    TableRelation = "Permission Set"."Role ID";
                    ToolTip = 'Specifies which permission set is included or excluded for the destination permission set.';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if DestinationPermissionSet = '' then
          Error(NoDestinationErr);
        if SourcePermissionSet = '' then
          Error(NoSourceErr);
    end;

    var
        DestinationPermissionSet: Code[20];
        SourcePermissionSet: Code[20];
        SetOperation: Option Include,Exclude;
        NoDestinationErr: label 'No destination permission set has been set.';
        NoSourceErr: label 'You must select a source permission set.';


    procedure SetDestination(NewDestination: Code[20])
    begin
        DestinationPermissionSet := NewDestination;
    end;

    local procedure PermissionValueIsGreaterOrEqual(Left: Option " ",Yes,Indirect;Right: Option " ",Yes,Indirect): Boolean
    begin
        // Returns (Left >= Right)
        case Left of
          Left::" ":
            exit(Right = Right::" ");
          Left::Yes:
            exit(true);
          Left::Indirect:
            exit(Right <> Right::Yes);
        end;
    end;
}

