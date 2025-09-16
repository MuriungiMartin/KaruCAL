#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5638 "FA Reclass. Jnl. Template List"
{
    Caption = 'FA Reclass. Jnl. Template List';
    Editable = false;
    PageType = List;
    SourceTable = "FA Reclass. Journal Template";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the name of the journal template you are creating.';
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the journal template that you are creating.';
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the ID of the window used for batches under this journal template.';
                    Visible = false;
                }
                field("Page Caption";"Page Caption")
                {
                    ApplicationArea = FixedAssets;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the window that is specified in the Page ID field.';
                    Visible = false;
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

