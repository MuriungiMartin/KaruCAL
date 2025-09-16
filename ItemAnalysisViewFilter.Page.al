#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7152 "Item Analysis View Filter"
{
    Caption = 'Item Analysis View Filter';
    DataCaptionFields = "Analysis View Code";
    PageType = List;
    SourceTable = "Item Analysis View Filter";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Dimension Code";"Dimension Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a dimension code that the dimension value filter will be linked to.';
                }
                field("Dimension Value Filter";"Dimension Value Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a dimension value filter for an item analysis view.';
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

