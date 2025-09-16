#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5083 "Job Responsibility Contacts"
{
    Caption = 'Job Responsibility Contacts';
    DataCaptionFields = "Job Responsibility Code";
    PageType = List;
    SourceTable = "Contact Job Responsibility";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the contact you assign the job responsibility.';
                }
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the contact person to whom you are assigning job responsibilities.';
                }
                field("Contact Company Name";"Contact Company Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the company for which the contact person works.';
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

