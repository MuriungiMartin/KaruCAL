#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6018 "Skill Codes"
{
    ApplicationArea = Basic;
    Caption = 'Skill Codes';
    PageType = List;
    SourceTable = "Skill Code";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the skill.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the skill code.';
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
        area(navigation)
        {
            group("&Skill Code")
            {
                Caption = '&Skill Code';
                Image = Skills;
                action("&Resource Skills")
                {
                    ApplicationArea = Basic;
                    Caption = '&Resource Skills';
                    Image = ResourceSkills;
                    RunObject = Page "Resource Skills";
                    RunPageLink = "Skill Code"=field(Code);
                    RunPageView = sorting("Skill Code")
                                  where(Type=const(Resource));
                }
            }
        }
    }
}

