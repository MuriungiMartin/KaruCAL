#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5660 "Depreciation Table Lines"
{
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Depreciation Table Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Period No.";"Period No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the depreciation period that this line applies to.';
                }
                field("Period Depreciation %";"Period Depreciation %")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the depreciation percentage to apply to the period for this line.';
                }
                field("No. of Units in Period";"No. of Units in Period")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the units produced by the asset this depreciation table applies to, during the period when this line applies.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        NewRecord;
    end;
}

