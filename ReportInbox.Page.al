#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 680 "Report Inbox"
{
    ApplicationArea = Basic;
    Caption = 'Report Inbox';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Report Inbox";
    SourceTableView = sorting("User ID","Created Date-Time")
                      order(descending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Microsoft Dynamics NAV user who scheduled the report to run.';
                }
                field("Created Date-Time";"Created Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date and time that the scheduled report was processed from the job queue.';
                }
                field("Report ID";"Report ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the report that was scheduled and processed by job queue.';
                }
                field("Report Name";"Report Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the scheduled report that was processed from the job queue.';
                }
            }
        }
    }

    actions
    {
    }
}

