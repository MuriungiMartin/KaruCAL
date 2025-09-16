#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5609 "FA Journal Setup"
{
    Caption = 'FA Journal Setup';
    DataCaptionFields = "Depreciation Book Code";
    PageType = List;
    SourceTable = "FA Journal Setup";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the depreciation book, for which you set up journal types.';
                    Visible = false;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the ID of a user.';
                }
                field("FA Jnl. Template Name";"FA Jnl. Template Name")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies an FA journal template.';
                }
                field("FA Jnl. Batch Name";"FA Jnl. Batch Name")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the relevant FA journal batch name.';
                }
                field("Gen. Jnl. Template Name";"Gen. Jnl. Template Name")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a general journal template.';
                }
                field("Gen. Jnl. Batch Name";"Gen. Jnl. Batch Name")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the relevant general journal batch name.';
                }
                field("Insurance Jnl. Template Name";"Insurance Jnl. Template Name")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies an insurance journal template.';
                }
                field("Insurance Jnl. Batch Name";"Insurance Jnl. Batch Name")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the relevant insurance journal batch name.';
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

