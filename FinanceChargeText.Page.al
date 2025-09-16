#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 445 "Finance Charge Text"
{
    AutoSplitKey = true;
    Caption = 'Finance Charge Text';
    DataCaptionFields = "Fin. Charge Terms Code",Position;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "Finance Charge Text";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Fin. Charge Terms Code";"Fin. Charge Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the finance charge terms code this text applies to.';
                    Visible = false;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the text will appear at the beginning or the end of the finance charge memo.';
                    Visible = false;
                }
                field(Text;Text)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the text that you want to insert in the finance charge memo.';
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

