#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 681 "Report Inbox Part"
{
    Caption = 'Report Inbox';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Report Inbox";
    SourceTableView = sorting("User ID","Created Date-Time")
                      order(descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    Style = Strong;
                    StyleExpr = not Read;
                    ToolTip = 'Specifies the Microsoft Dynamics NAV user who scheduled the report to run.';
                    Visible = false;
                }
                field("Created Date-Time";"Created Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    Style = Strong;
                    StyleExpr = not Read;
                    ToolTip = 'Specifies the date and time that the scheduled report was processed from the job queue.';
                }
                field("Report ID";"Report ID")
                {
                    ApplicationArea = Basic,Suite;
                    Style = Strong;
                    StyleExpr = not Read;
                    ToolTip = 'Specifies the ID of the report that was scheduled and processed by job queue.';
                    Visible = false;
                }
                field("Report Name";"Report Name")
                {
                    ApplicationArea = Basic,Suite;
                    Style = Strong;
                    StyleExpr = not Read;
                    ToolTip = 'Specifies the name of the scheduled report that was processed from the job queue.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        ShowReport;
                        CurrPage.Update;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Style = Strong;
                    StyleExpr = not Read;
                    ToolTip = 'Specifies the description of the scheduled report that was processed from the job queue.';

                    trigger OnDrillDown()
                    begin
                        ShowReport;
                        CurrPage.Update;
                    end;
                }
                field("Output Type";"Output Type")
                {
                    ApplicationArea = Basic,Suite;
                    Style = Strong;
                    StyleExpr = not Read;
                    ToolTip = 'Specifies the output type of the scheduled report.';
                }
            }
            group(Control16)
            {
                usercontrol(PingPong;"Microsoft.Dynamics.Nav.Client.PingPong")
                {
                    ApplicationArea = Basic,Suite;

                    trigger AddInReady()
                    begin
                        AddInReady := true;
                        PrevNumberOfRecords := Count;
                        CurrPage.PingPong.Ping(10000);
                    end;

                    trigger Pong()
                    var
                        CurrNumberOfRecords: Integer;
                    begin
                        CurrNumberOfRecords := Count;
                        if PrevNumberOfRecords <> CurrNumberOfRecords then
                          CurrPage.Update(false);
                        PrevNumberOfRecords := CurrNumberOfRecords;
                        CurrPage.PingPong.Ping(10000);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Show)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show';
                Image = "Report";
                ShortCutKey = 'Return';
                ToolTip = 'Open your report inbox.';

                trigger OnAction()
                begin
                    ShowReport;
                    CurrPage.Update;
                end;
            }
            separator(Action11)
            {
            }
            action(Unread)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Unread Reports';
                Enabled = ShowAll;
                Image = FilterLines;
                ToolTip = 'Show only unread reports in your inbox.';

                trigger OnAction()
                begin
                    ShowAll := false;
                    UpdateVisibility;
                end;
            }
            action(All)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'All Reports';
                Enabled = not ShowAll;
                Image = AllLines;
                ToolTip = 'View all reports in your inbox.';

                trigger OnAction()
                begin
                    ShowAll := true;
                    UpdateVisibility;
                end;
            }
            separator(Action14)
            {
            }
            action(Delete)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Delete';
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                var
                    ReportInbox: Record "Report Inbox";
                begin
                    CurrPage.SetSelectionFilter(ReportInbox);
                    ReportInbox.DeleteAll;
                end;
            }
            separator(Action18)
            {
            }
            action(ShowQueue)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show Queue';
                Image = List;
                ToolTip = 'Show scheduled reports.';

                trigger OnAction()
                var
                    JobQueueEntry: Record "Job Queue Entry";
                begin
                    JobQueueEntry.FilterGroup(2);
                    JobQueueEntry.SetRange("User ID",UserId);
                    JobQueueEntry.FilterGroup(0);
                    Page.Run(Page::"Job Queue Entries",JobQueueEntry);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetRange("User ID",UserId);
        SetAutocalcFields;
        ShowAll := true;
        UpdateVisibility;
        AddInReady := false;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if AddInReady then
          CurrPage.PingPong.Stop;
        exit(true);
    end;

    var
        ShowAll: Boolean;
        PrevNumberOfRecords: Integer;
        AddInReady: Boolean;

    local procedure UpdateVisibility()
    begin
        if ShowAll then
          SetRange(Read)
        else
          SetRange(Read,false);
        if FindFirst then;
        CurrPage.Update(false);
    end;
}

