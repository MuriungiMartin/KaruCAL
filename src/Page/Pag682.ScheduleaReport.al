#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 682 "Schedule a Report"
{
    Caption = 'Schedule a Report';
    DataCaptionExpression = Description;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = StandardDialog;
    SourceTable = "Job Queue Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            field("Object ID to Run";"Object ID to Run")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Report ID';
                Editable = ReportEditable;
                ToolTip = 'Specifies the ID of the object that is to be run for this job. You can select an ID that is of the object type that you have specified in the Object Type to Run field.';

                trigger OnLookup(var Text: Text): Boolean
                var
                    NewObjectID: Integer;
                begin
                    if LookupObjectID(NewObjectID) then begin
                      Text := Format(NewObjectID);
                      exit(true);
                    end;
                    exit(false);
                end;

                trigger OnValidate()
                begin
                    if "Object ID to Run" <> 0 then
                      RunReportRequestPage;
                    OutPutEditable := Report.DefaultLayout("Object ID to Run") <> Defaultlayout::None; // Processing Only
                end;
            }
            field("Object Caption to Run";"Object Caption to Run")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Report Name';
                Enabled = false;
                ToolTip = 'Specifies the name of the object that is selected in the Object ID to Run field.';
            }
            field(Description;Description)
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies a description of the job queue entry. You can edit and update the description on the job queue entry card. The description is also displayed in the Job Queue Entries window, but it cannot be updated there. You can enter a maximum of 50 characters, both numbers and letters.';
            }
            field("Report Request Page Options";"Report Request Page Options")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether options on the report request page have been set for scheduled report job. If the check box is selected, then options have been set for the scheduled report.';
                Visible = ReportEditable;
            }
            field("Report Output Type";"Report Output Type")
            {
                ApplicationArea = Basic,Suite;
                Enabled = OutPutEditable;
                ToolTip = 'Specifies the output of the scheduled report.';
            }
            field("Printer Name";"Printer Name")
            {
                ApplicationArea = Basic;
                Enabled = "Report Output Type" = "Report Output Type"::Print;
                Importance = Additional;
                ToolTip = 'Specifies the printer to use to print the scheduled report.';
            }
            field("Earliest Start Date/Time";"Earliest Start Date/Time")
            {
                ApplicationArea = Basic,Suite;
                Importance = Additional;
                ToolTip = 'Specifies the earliest date and time when the job queue entry should be run.';
            }
            field("Expiration Date/Time";"Expiration Date/Time")
            {
                ApplicationArea = Basic,Suite;
                Importance = Additional;
                ToolTip = 'Specifies the date and time when the job queue entry is to expire, after which the job queue entry will not be run.';
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if not FindFirst then begin
          Init;
          ReportEditable := true;
          OutPutEditable := true;
          Status := Status::"On Hold";
          Validate("Object Type to Run","object type to run"::Report);
          Insert(true);
        end else
          OutPutEditable := Report.DefaultLayout("Object ID to Run") <> Defaultlayout::None; // Processing Only
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        if CloseAction <> Action::OK then
          exit(true);

        if "Object ID to Run" = 0 then begin
          Message(NoIdMsg);
          exit(false);
        end;

        CalcFields(Xml);
        JobQueueEntry := Rec;
        JobQueueEntry."Run in User Session" := true;
        if JobQueueEntry.Description = '' then
          JobQueueEntry.Description := CopyStr("Object Caption to Run",1,MaxStrLen(JobQueueEntry.Description));
        Codeunit.Run(Codeunit::"Job Queue - Enqueue",JobQueueEntry);
        if JobQueueEntry.IsToReportInbox then
          Message(ReportScheduledMsg);
        exit(true);
    end;

    var
        NoIdMsg: label 'You must specify a report number.';
        ReportEditable: Boolean;
        OutPutEditable: Boolean;
        ReportScheduledMsg: label 'The report has been scheduled. It will appear in the Report Inbox part when it is completed.';


    procedure ScheduleAReport(ReportId: Integer;RequestPageXml: Text): Boolean
    var
        ScheduleAReport: Page "Schedule a Report";
    begin
        ScheduleAReport.SetParameters(ReportId,RequestPageXml);
        exit(ScheduleAReport.RunModal = Action::OK);
    end;


    procedure SetParameters(ReportId: Integer;RequestPageXml: Text)
    begin
        Init;
        Status := Status::"On Hold";
        Validate("Object Type to Run","object type to run"::Report);
        Validate("Object ID to Run",ReportId);
        Insert(true);
        SetReportParameters(RequestPageXml);
    end;
}

