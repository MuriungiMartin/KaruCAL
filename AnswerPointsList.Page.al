#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5173 "Answer Points List"
{
    Caption = 'Answer Points List';
    DataCaptionFields = "Profile Questionnaire Line No.";
    Editable = false;
    PageType = List;
    SourceTable = Rating;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Rating Profile Quest. Code";"Rating Profile Quest. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the profile questionnaire that contains the answer you use to create your rating.';
                }
                field("ProfileQuestionnaireLine.Question";ProfileQuestionnaireLine.Question)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Question';
                    ToolTip = 'Specifies the question in the profile questionnaire.';
                }
                field("ProfileQuestionnaireLine.Description";ProfileQuestionnaireLine.Description)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Answer';
                    Editable = false;
                    ToolTip = 'Specifies answers to the questions in the profile questionnaire.';
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

    trigger OnAfterGetCurrRecord()
    begin
        if not ProfileQuestionnaireLine.Get("Rating Profile Quest. Code","Rating Profile Quest. Line No.") then
          Clear(ProfileQuestionnaireLine);
    end;

    trigger OnAfterGetRecord()
    begin
        if ProfileQuestionnaireLine.Get("Rating Profile Quest. Code","Rating Profile Quest. Line No.") then ;
    end;

    var
        ProfileQuestionnaireLine: Record "Profile Questionnaire Line";
}

