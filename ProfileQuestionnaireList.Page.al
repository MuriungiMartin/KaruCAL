#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5111 "Profile Questionnaire List"
{
    Caption = 'Profile Questionnaire List';
    Editable = false;
    PageType = List;
    SourceTable = "Profile Questionnaire Header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the profile questionnaire.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the profile questionnaire.';
                }
                field("Contact Type";"Contact Type")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the type of contact you want to use this profile questionnaire for.';
                }
                field("Business Relation Code";"Business Relation Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the code of the business relation to which the profile questionnaire applies.';
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

