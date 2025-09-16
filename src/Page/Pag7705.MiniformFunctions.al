#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7705 "Miniform Functions"
{
    Caption = 'Miniform Functions';
    PageType = List;
    SourceTable = "Miniform Function";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Miniform Code";"Miniform Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Indicates the miniform that has a function assigned to it.';
                    Visible = false;
                }
                field("Function Code";"Function Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the function that is assigned to the miniform.';
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

