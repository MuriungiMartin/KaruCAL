#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5719 "Sub. Conditions"
{
    AutoSplitKey = true;
    Caption = 'Sub. Conditions';
    DataCaptionFields = Field20;
    Editable = false;
    PageType = List;
    SourceTable = "Substitution Condition";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Condition;Condition)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the condition for item substitution.';
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

