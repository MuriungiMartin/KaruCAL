#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 673 "Job Queue Entry Card"
{
    Caption = 'Job Queue Entry Card';
    DataCaptionFields = "Object Type to Run","Object Caption to Run";
    PageType = Card;
    SourceTable = "Job Queue Entry";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Object Type to Run";"Object Type to Run")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the type of the object, report or codeunit, that is to be run for the job queue entry. After you specify a type, you then select an object ID of that type in the Object ID to Run field.';
                }
                field("Object ID to Run";"Object ID to Run")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the ID of the object that is to be run for this job. You can select an ID that is of the object type that you have specified in the Object Type to Run field.';
                }
                field("Object Caption to Run";"Object Caption to Run")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the object that is selected in the Object ID to Run field.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies a description of the job queue entry. You can edit and update the description on the job queue entry card. The description is also displayed in the Job Queue Entries window, but it cannot be updated there. You can enter a maximum of 50 characters, both numbers and letters.';
                }
                field("Parameter String";"Parameter String")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies a text string that is used as a parameter by the job queue when it is run.';
                }
                field("Job Queue Category Code";"Job Queue Category Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code of the job queue category to which the job queue entry belongs. Choose the field to select a code from the list.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the user ID of the user who has inserted the job queue entry in the queue.';
                }
                field("Maximum No. of Attempts to Run";"Maximum No. of Attempts to Run")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies how many times a job queue task should be rerun after a job queue fails to run. This is useful for situations in which a task might be unresponsive. For example, a task might be unresponsive because it depends on an external resource that is not always available.';
                }
                field("Last Ready State";"Last Ready State")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the date and time when the job queue entry was last set to Ready and sent to the job queue.';
                }
                field("Earliest Start Date/Time";"Earliest Start Date/Time")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the earliest date and time when the job queue entry should be run.';
                }
                field("Expiration Date/Time";"Expiration Date/Time")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the date and time when the job queue entry is to expire, after which the job queue entry will not be run.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the status of the job queue entry. When you create a job queue entry, its status is set to On Hold. You can set the status to Ready and back to On Hold. Otherwise, status information in this field is updated automatically.';
                }
            }
            group("Report Parameters")
            {
                Caption = 'Report Parameters';
                Visible = "Object Type to Run" = "Object Type to Run"::Report;
                field("Report Request Page Options";"Report Request Page Options")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether options on the report request page have been set for scheduled report job. If the check box is selected, then options have been set for the scheduled report.';
                }
                field("Report Output Type";"Report Output Type")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the output of the scheduled report.';
                }
                field("Printer Name";"Printer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the printer to use to print the scheduled report.';
                }
            }
            group(Recurrence)
            {
                Caption = 'Recurrence';
                field("Recurring Job";"Recurring Job")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies if the job queue entry is recurring. If the Recurring Job check box is selected, then the job queue entry is recurring. If the check box is cleared, the job queue entry is not recurring. After you specify that a job queue entry is a recurring one, you must specify on which days of the week the job queue entry is to run. Optionally, you can also specify a time of day for the job to run and how many minutes should elapse between runs.';
                }
                field("Run on Mondays";"Run on Mondays")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the job queue entry runs on Mondays.';
                }
                field("Run on Tuesdays";"Run on Tuesdays")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the job queue entry runs on Tuesdays.';
                }
                field("Run on Wednesdays";"Run on Wednesdays")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the job queue entry runs on Wednesdays.';
                }
                field("Run on Thursdays";"Run on Thursdays")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the job queue entry runs on Thursdays.';
                }
                field("Run on Fridays";"Run on Fridays")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the job queue entry runs on Fridays.';
                }
                field("Run on Saturdays";"Run on Saturdays")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the job queue entry runs on Saturdays.';
                }
                field("Run on Sundays";"Run on Sundays")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the job queue entry runs on Sundays.';
                }
                field("Starting Time";"Starting Time")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = "Recurring Job" = true;
                    Importance = Promoted;
                    ToolTip = 'Specifies the earliest time of the day that the recurring job queue entry is to be run.';
                }
                field("Ending Time";"Ending Time")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = "Recurring Job" = true;
                    Importance = Promoted;
                    ToolTip = 'Specifies the latest time of the day that the recurring job queue entry is to be run.';
                }
                field("No. of Minutes between Runs";"No. of Minutes between Runs")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = "Recurring Job" = true;
                    Importance = Promoted;
                    ToolTip = 'Specifies the minimum number of minutes that are to elapse between runs of a job queue entry. This field only has meaning if the job queue entry is set to be a recurring job.';
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
            group("Job &Queue")
            {
                Caption = 'Job &Queue';
                Image = CheckList;
                action("Set Status to Ready")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Set Status to Ready';
                    Image = ResetStatus;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Change the status of the entry.';

                    trigger OnAction()
                    begin
                        SetStatus(Status::Ready);
                    end;
                }
                action("Set On Hold")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Set On Hold';
                    Image = Pause;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Change the status of the entry.';

                    trigger OnAction()
                    begin
                        SetStatus(Status::"On Hold");
                    end;
                }
                action("Show Error")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Error';
                    Image = Error;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Show the error message that has stopped the entry.';

                    trigger OnAction()
                    begin
                        ShowErrorMessage;
                    end;
                }
                action(Restart)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Restart';
                    Image = Start;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Stop and start the entry.';

                    trigger OnAction()
                    begin
                        Restart;
                    end;
                }
            }
        }
        area(navigation)
        {
            group(ActionGroup12)
            {
                Caption = 'Job &Queue';
                Image = CheckList;
                action(LogEntries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Log Entries';
                    Image = Log;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job Queue Log Entries";
                    RunPageLink = ID=field(ID);
                    ToolTip = 'View the job queue log entries.';
                }
                action(ShowRecord)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Record';
                    Image = ViewDetails;
                    ToolTip = 'Show the record for the entry.';

                    trigger OnAction()
                    begin
                        LookupRecordToProcess;
                    end;
                }
                action(ReportRequestPage)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Report Request Page';
                    Enabled = "Object Type to Run" = "Object Type to Run"::Report;
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    ToolTip = 'Show the request page for the entry. If the entry is set up to run a processing-only report, the request page is blank.';

                    trigger OnAction()
                    begin
                        RunReportRequestPage;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if not ((Status = Status::Error) or (Status = Status::"On Hold")) then begin
          if "Earliest Start Date/Time" - CurrentDatetime < 2 * 60 * 1000 then
            Message(ChooseSetOnHoldMsg);
        end
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ID := CreateGuid;
        Status := Status::"On Hold";
    end;

    var
        ChooseSetOnHoldMsg: label 'To edit the job queue entry, you must first choose the Set On Hold action.';


    procedure GetChooseSetOnHoldMsg(): Text
    begin
        exit(ChooseSetOnHoldMsg);
    end;
}

