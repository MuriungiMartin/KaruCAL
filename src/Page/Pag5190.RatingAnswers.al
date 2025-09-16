#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5190 "Rating Answers"
{
    AutoSplitKey = true;
    Caption = 'Rating Answers';
    PageType = List;
    SourceTable = "Profile Questionnaire Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the profile question or answer.';
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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Type := Type::Answer;
    end;
}

