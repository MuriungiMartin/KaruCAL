#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5663 "Depreciation Table List"
{
    ApplicationArea = Basic;
    Caption = 'Depreciation Table List';
    CardPageID = "Depreciation Table Card";
    Editable = false;
    PageType = List;
    SourceTable = "Depreciation Table Header";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a code for the depreciation table.';
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a description of the depreciation table.';
                }
                field("Period Length";"Period Length")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the length of period that each of the depreciation table lines will apply to.';
                }
                field("Total No. of Units";"Total No. of Units")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the total number of units the asset is expected to produce in its lifetime.';
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

