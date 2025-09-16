#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5107 "Salesperson Teams"
{
    Caption = 'Salesperson Teams';
    DataCaptionFields = "Salesperson Code";
    PageType = List;
    SourceTable = "Team Salesperson";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Team Code";"Team Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the team to which the salesperson belongs.';
                }
                field("Team Name";"Team Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the team.';
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

