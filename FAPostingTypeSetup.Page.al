#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5608 "FA Posting Type Setup"
{
    Caption = 'FA Posting Type Setup';
    DataCaptionFields = "Depreciation Book Code";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "FA Posting Type Setup";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the depreciation book for which you set up posting types.';
                    Visible = false;
                }
                field("FA Posting Type";"FA Posting Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the FA posting type for which the settings on the line are valid.';
                }
                field("Part of Book Value";"Part of Book Value")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies that entries posted with the FA Posting Type field will be part of the book value.';
                }
                field("Part of Depreciable Basis";"Part of Depreciable Basis")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies that entries posted with the FA Posting Type field will be part of the depreciable basis.';
                }
                field("Include in Depr. Calculation";"Include in Depr. Calculation")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies that entries posted with the FA Posting Type field must be included in periodic depreciation calculations.';
                }
                field("Include in Gain/Loss Calc.";"Include in Gain/Loss Calc.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies that entries posted with the FA Posting Type field must be included in the calculation of gain or loss for a sold asset.';
                }
                field("Reverse before Disposal";"Reverse before Disposal")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies that entries posted with the FA Posting Type field must be reversed (that is, set to zero) before disposal.';
                }
                field("Acquisition Type";"Acquisition Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies that entries posted with the FA Posting Type must be part of the total acquisition for the fixed asset in the Fixed Asset - Book Value 01 report.';
                }
                field("Depreciation Type";"Depreciation Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies that entries posted with the FA Posting Type field will be regarded as part of the total depreciation for the fixed asset.';
                }
                field(Sign;Sign)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies whether the type in the FA Posting Type field should be a debit or a credit.';
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

