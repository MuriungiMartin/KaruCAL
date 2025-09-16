#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5149 "Profile Questn. Line List"
{
    AutoSplitKey = true;
    Caption = 'Profile Questn. Line List';
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SaveValues = true;
    SourceTable = "Profile Questionnaire Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Line No.";"Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the profile questionnaire line. This field is used internally by the program.';
                }
                field(Question;Question)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Question';
                    ToolTip = 'Specifies the question in the profile questionnaire.';
                }
                field(Description;Description)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Answer';
                    ToolTip = 'Specifies the profile question or answer.';
                }
                field("From Value";"From Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value from which the automatic classification of your contacts starts.';
                    Visible = false;
                }
                field("To Value";"To Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value that the automatic classification of your contacts stops at.';
                    Visible = false;
                }
                field("No. of Contacts";"No. of Contacts")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of contacts that have given this answer.';
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

