#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 557 "Analysis View Filter"
{
    Caption = 'Analysis View Filter';
    DataCaptionFields = "Analysis View Code";
    PageType = List;
    SourceTable = "Analysis View Filter";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Dimension Code";"Dimension Code")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension Value Filter";"Dimension Value Filter")
                {
                    ApplicationArea = Basic;
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

