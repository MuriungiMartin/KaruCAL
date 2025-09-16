#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 674 "Job Queue Log Entries"
{
    ApplicationArea = Basic;
    Caption = 'Job Queue Log Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Job Queue Log Entry";
    SourceTableView = sorting("Start Date/Time",ID)
                      order(descending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the status of the running of the job queue entry in a log.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the user who inserted the job in the job queue.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the job queue entry in the log.';
                }
                field("Object Type to Run";"Object Type to Run")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of the object that is to be run for the job.';
                }
                field("Object ID to Run";"Object ID to Run")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the object that is to be run for the job.';
                }
                field("Object Caption to Run";"Object Caption to Run")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name or caption of the object that was run for the job.';
                }
                field("Start Date/Time";"Start Date/Time")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date and time when the job was started.';
                }
                field(Duration;Duration)
                {
                    ApplicationArea = Basic;
                    Caption = 'Duration';
                }
                field("End Date/Time";"End Date/Time")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date and time when the job ended.';
                    Visible = false;
                }
                field(GetErrorMessage;GetErrorMessage)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Error Message';
                    ToolTip = 'Specifies an error that occurred in the job queue.';

                    trigger OnAssistEdit()
                    begin
                        ShowErrorMessage;
                    end;
                }
                field("Processed by User ID";"Processed by User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the user ID of the job queue entry processor. The user ID comes from the job queue entry card.';
                    Visible = false;
                }
                field("Job Queue Category Code";"Job Queue Category Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the category code for the entry in the job queue log.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Delete7days)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Delete Entries Older Than 7 Days';
                Image = ClearLog;
                ToolTip = 'Clear the list of log entries that are older than 7 days.';

                trigger OnAction()
                begin
                    DeleteEntries(7);
                end;
            }
            action(Delete0days)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Delete All Entries';
                Image = Delete;
                ToolTip = 'Clear the list of all log entries.';

                trigger OnAction()
                begin
                    DeleteEntries(0);
                end;
            }
            action("Show Error Message")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show Error Message';
                Image = Error;
                ToolTip = 'Show the error message that has stopped the entry.';

                trigger OnAction()
                begin
                    ShowErrorMessage;
                end;
            }
            action(SetStatusToError)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set Status to Error';
                Image = DefaultFault;
                ToolTip = 'Change the status of the entry.';

                trigger OnAction()
                begin
                    if Confirm(JobQueueEntryRunningQst,false) then
                      MarkAsError;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if FindFirst then;
    end;

    var
        JobQueueEntryRunningQst: label 'This job queue entry may be still running. If you set the status to Error, it may keep running in the background. Are you sure you want to set the status to Error?';
}

