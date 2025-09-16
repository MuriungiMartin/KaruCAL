#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9154 "My Jobs"
{
    Caption = 'My Jobs';
    PageType = ListPart;
    SourceTable = "My Job";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the job numbers that are displayed in the My Job Cue on the Role Center.';

                    trigger OnValidate()
                    begin
                        GetJob;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    Enabled = false;
                    ToolTip = 'Specifies a description of the job.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the job''s status.';
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the job''s Name.';
                }
                field("Percent Completed";"Percent Completed")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the completion rate of the job.';
                }
                field("Percent Invoiced";"Percent Invoiced")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies how much of the job has been invoiced.';
                }
                field("Exclude from Business Chart";"Exclude from Business Chart")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies if this job should appear in the business charts for this role center.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Open';
                Image = ViewDetails;
                RunObject = Page "Job Card";
                RunPageLink = "No."=field("Job No.");
                RunPageMode = View;
                ShortCutKey = 'Return';
                ToolTip = 'Open the card for the selected record.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetJob;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(Job);
    end;

    trigger OnOpenPage()
    begin
        SetRange("User ID",UserId);
    end;

    var
        Job: Record Job;

    local procedure GetJob()
    begin
        Clear(Job);

        if Job.Get("Job No.") then begin
          Description := Job.Description;
          Status := Job.Status;
          "Bill-to Name" := Job."Bill-to Name";
          "Percent Completed" := Job.PercentCompleted;
          "Percent Invoiced" := Job.PercentInvoiced;
        end;
    end;
}

