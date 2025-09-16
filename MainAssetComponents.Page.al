#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5658 "Main Asset Components"
{
    AutoSplitKey = false;
    Caption = 'Main Asset Components';
    DataCaptionFields = "Main Asset No.";
    PageType = List;
    SourceTable = "Main Asset Component";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Main Asset No.";"Main Asset No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the main asset. This is the asset for which components can be set up.';
                    Visible = false;
                }
                field("FA No.";"FA No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the fixed asset that is a component of the main asset.';
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the description linked to the fixed asset for the fixed asset number you entered in FA No. field.';
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

