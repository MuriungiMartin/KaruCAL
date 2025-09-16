#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5170 "Answer Where-Used"
{
    Caption = 'Answer Where-Used';
    DataCaptionFields = "Rating Profile Quest. Line No.";
    Editable = false;
    PageType = List;
    SourceTable = Rating;
    SourceTableView = sorting("Rating Profile Quest. Code","Rating Profile Quest. Line No.");

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Profile Questionnaire Code";"Profile Questionnaire Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the profile questionnaire that contains the question you use to create your rating.';
                }
                field("Profile Question Description";"Profile Question Description")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies the description you have entered for this rating question in the Description field in the Profile Questionnaire Setup window.';
                }
                field(Points;Points)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of points you have assigned to this answer.';
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

