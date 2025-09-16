#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5081 "Contact Job Responsibilities"
{
    Caption = 'Contact Job Responsibilities';
    DataCaptionFields = "Contact No.";
    PageType = List;
    SourceTable = "Contact Job Responsibility";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Job Responsibility Code";"Job Responsibility Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the job responsibility code.';
                }
                field("Job Responsibility Description";"Job Responsibility Description")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the description for the job responsibility you have assigned to the contact.';
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
    }
}

