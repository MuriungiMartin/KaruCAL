#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1026 "Job WIP Warnings"
{
    Caption = 'Job WIP Warnings';
    PageType = List;
    SourceTable = "Job WIP Warning";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the job that is associated with the WIP warning message.';
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the job task associated with the WIP warning message.';
                }
                field("Job WIP Total Entry No.";"Job WIP Total Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the entry number from the associated job WIP total.';
                }
                field("Warning Message";"Warning Message")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a warning message that is related to a job WIP calculation.';
                }
            }
        }
    }

    actions
    {
    }
}

