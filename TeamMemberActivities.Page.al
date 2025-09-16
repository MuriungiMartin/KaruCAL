#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9042 "Team Member Activities"
{
    Caption = 'Self-Service';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Team Member Cue";

    layout
    {
        area(content)
        {
            cuegroup("Time Sheets")
            {
                Caption = 'Time Sheets';
                Visible = ShowOpenTimeSheets;
                field("Open Time Sheets";"Open Time Sheets")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Time Sheet List";
                    ToolTip = 'Specifies the number of time sheets that are currently assigned to you and not submitted for approval.';
                }
            }
            cuegroup("Pending Time Sheets")
            {
                Caption = 'Pending Time Sheets';
                Visible = ShowPendingTimeSheets;
                field("Submitted Time Sheets";"Submitted Time Sheets")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Time Sheet List";
                    ToolTip = 'Specifies the number of time sheets that you have submitted for approval but are not yet approved.';
                }
                field("Rejected Time Sheets";"Rejected Time Sheets")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Time Sheet List";
                    ToolTip = 'Specifies the number of time sheets that you submitted for approval but were rejected.';
                }
                field("Approved Time Sheets";"Approved Time Sheets")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Time Sheet List";
                    ToolTip = 'Specifies the number of time sheets that have been approved.';
                }
            }
            cuegroup(Control4)
            {
                Caption = 'Approvals';
                Visible = ShowRequestToApprove;
                field("Requests to Approve";"Requests to Approve")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Requests to Approve";
                    ToolTip = 'Specifies request for certain documents, cards, or journal lines that you must approve for other users before they can proceed.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Show/Hide Activities")
            {
                Caption = 'Show/Hide Activities';
                Image = Answers;
                action("Time Sheets")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show/Hide Time Sheets';
                    Image = Timesheet;
                    RunObject = Codeunit "Undo Bank Statement (Yes/No)";
                    ToolTip = 'View open time sheets.';
                }
                action("Pending Time Sheets")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show/Hide Pending Time Sheets';
                    Image = Timesheet;
                    RunObject = Codeunit "Time Sheet Activites Mgt.";
                    ToolTip = 'View submitted, rejected, and approved time sheets.';
                }
                action(Approvals)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show/Hide Approvals';
                    Image = Approve;
                    RunObject = Codeunit "Req. To Appr. Activities Mgt.";
                    ToolTip = 'Specifies the number of approval requests that require your approval.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActivityGroupVisibility;
    end;

    trigger OnOpenPage()
    var
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        SetRange("User ID Filter",UserId);

        ShowOpenTimeSheets := true;
        ShowRequestToApprove := true;
        RoleCenterNotificationMgt.ShowNotifications;
    end;

    var
        ShowOpenTimeSheets: Boolean;
        ShowRequestToApprove: Boolean;
        ShowPendingTimeSheets: Boolean;

    local procedure SetActivityGroupVisibility()
    var
        TeamMemberActivitiesMgt: Codeunit "Undo Bank Statement (Yes/No)";
        ReqToApprActivitiesMgt: Codeunit "Req. To Appr. Activities Mgt.";
        TimeSheetActivitesMgt: Codeunit "Time Sheet Activites Mgt.";
    begin
        ShowOpenTimeSheets := TeamMemberActivitiesMgt.IsActivitiesVisible;
        ShowPendingTimeSheets := TimeSheetActivitesMgt.IsActivitiesVisible;
        ShowRequestToApprove := ReqToApprActivitiesMgt.IsActivitiesVisible;
    end;
}

