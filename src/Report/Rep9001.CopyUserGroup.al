#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 9001 "Copy User Group"
{
    Caption = 'Copy User Group';
    ProcessingOnly = true;

    dataset
    {
        dataitem("User Group";"User Group")
        {
            DataItemTableView = sorting(Code);
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            var
                NewUserGroup: Record "User Group";
                UserGroupPermissionSet: Record "User Group Permission Set";
                NewUserGroupPermissionSet: Record "User Group Permission Set";
            begin
                NewUserGroup.Init;
                NewUserGroup.Code := NewUserGroupCode;
                NewUserGroup.Name := Name;
                NewUserGroup.Insert;
                UserGroupPermissionSet.SetRange("User Group Code",Code);
                if UserGroupPermissionSet.FindSet then
                  repeat
                    NewUserGroupPermissionSet := UserGroupPermissionSet;
                    NewUserGroupPermissionSet."User Group Code" := NewUserGroup.Code;
                    NewUserGroupPermissionSet.Insert;
                  until UserGroupPermissionSet.Next = 0;
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
                    field(NewUserGroupCode;NewUserGroupCode)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New User Group Code';
                        NotBlank = true;
                        ToolTip = 'Specifies the code of the user group that result from the copying.';
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
        NewUserGroupCode: Code[20];
}

