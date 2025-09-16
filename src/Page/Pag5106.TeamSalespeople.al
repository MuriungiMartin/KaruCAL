#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5106 "Team Salespeople"
{
    Caption = 'Team Salespeople';
    DataCaptionFields = "Team Code";
    PageType = List;
    SourceTable = "Team Salesperson";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the salesperson you want to register as part of the team.';
                }
                field("Salesperson Name";"Salesperson Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the salesperson you want to register as part of the team.';
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

