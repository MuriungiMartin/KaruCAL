#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5661 "FA Date Types"
{
    Caption = 'FA Date Types';
    Editable = false;
    PageType = List;
    SourceTable = "FA Date Type";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("FA Date Type Name";"FA Date Type Name")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the name of the fixed asset data type.';
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

