#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9511 "Database Locks"
{
    Caption = 'Database Locks';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Database Locks";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Object Name";"Object Name")
                {
                    ApplicationArea = All;
                    Caption = 'Table name';
                    ToolTip = 'Specifies the name of table on which the lock request was done.';
                }
                field("Resource Type";"Resource Type")
                {
                    ApplicationArea = All;
                    Caption = 'SQL Lock Resource Type';
                    ToolTip = 'Specifies the SQL lock request type. See documentation: https://aka.ms/y7zj2m';
                }
                field("Request Mode";"Request Mode")
                {
                    ApplicationArea = All;
                    Caption = 'SQL Lock Request Mode';
                    ToolTip = 'Specifies the SQL lock request mode. See documentation: https://aka.ms/y7zj2m';
                }
                field("Request Status";"Request Status")
                {
                    ApplicationArea = All;
                    Caption = 'SQL Lock Request Status';
                    ToolTip = 'Specifies the SQL lock request status. See documentation: https://aka.ms/y7zj2m';
                }
                field("User Name";"User Name")
                {
                    ApplicationArea = All;
                    Caption = 'User Name';
                    ToolTip = 'Specifies the user name that have requested the lock.';
                }
                field("AL Object Type";"AL Object Type")
                {
                    ApplicationArea = All;
                    Caption = 'Executing AL Object Type';
                    ToolTip = 'Specifies the AL object type that is executed in the context of the lock.';
                }
                field("AL Object Id";"AL Object Id")
                {
                    ApplicationArea = All;
                    Caption = 'Executing AL Object Id';
                    ToolTip = 'Specifies the AL object id that is executed in the context of the lock.';
                }
                field("AL Method Scope";"AL Method Scope")
                {
                    ApplicationArea = All;
                    Caption = 'Executing AL Method';
                    ToolTip = 'Specifies the AL method that is executed in the context of the given AL object.';
                }
            }
        }
    }

    actions
    {
    }
}

