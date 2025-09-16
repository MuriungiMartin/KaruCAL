#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 551 "VAT Prod. Posting Group Conv."
{
    ApplicationArea = Basic;
    Caption = 'Tax Prod. Posting Group Conv.';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "VAT Rate Change Conversion";
    SourceTableView = where(Type=const("VAT Prod. Posting Group"));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("From Code";"From Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the current posting group for Tax rate change conversion.';
                }
                field("To Code";"To Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the new posting group for Tax rate change conversion.';
                }
                field("Converted Date";"Converted Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date on which the Tax rate change conversion was performed.';
                }
            }
        }
    }

    actions
    {
    }
}

