#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 9802 "Copy Permission Set"
{
    Caption = 'Copy Permission Set';
    ProcessingOnly = true;

    dataset
    {
        dataitem(PermissionSet;"Permission Set")
        {
            DataItemTableView = sorting("Role ID");
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            var
                NewPermissionSet: Record "Permission Set";
                Permission: Record Permission;
                NewPermission: Record Permission;
            begin
                NewPermissionSet.Init;
                NewPermissionSet.Validate("Role ID",NewRoleId);
                NewPermissionSet.TestField("Role ID");
                NewPermissionSet.Validate(Name,Name);
                NewPermissionSet.Insert;

                Permission.SetRange("Role ID","Role ID");
                if Permission.FindSet then
                  repeat
                    NewPermission.Init;
                    NewPermission.Copy(Permission);
                    NewPermission."Role ID" := NewRoleId;
                    NewPermission.Insert;
                  until Permission.Next = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NewRoleId;NewRoleId)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New Permission Set';
                        NotBlank = true;
                        ToolTip = 'Specifies the name of the new permission set after copying.';
                    }
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

    var
        NewRoleId: Code[20];


    procedure GetRoleId(): Code[20]
    begin
        exit(NewRoleId);
    end;
}

