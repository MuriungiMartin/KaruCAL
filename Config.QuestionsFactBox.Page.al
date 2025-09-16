#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 8633 "Config. Questions FactBox"
{
    Caption = 'Config. Questions FactBox';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Config. Question";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Questionnaire Code";"Questionnaire Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the questionnaire.';
                    Visible = false;
                }
                field("Question Area Code";"Question Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the question area.';
                    Visible = false;
                }
                field(Question;Question)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a question that is to be answered on the setup questionnaire. On the Actions tab, in the Question group, choose Update Questions to autopopulate the question list based on the fields in the table on which the question area is based. You can modify the text to be more meaningful to the person responsible for filling out the questionnaire. For example, you could rewrite the Name? question as What is the name of your company?';
                }
                field(Answer;Answer)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the answer to the question. The answer to the question should match the format of the answer option and must be a value that the database supports. If it does not, then there will be an error when you apply the answer.';
                }
            }
        }
    }

    actions
    {
    }
}

