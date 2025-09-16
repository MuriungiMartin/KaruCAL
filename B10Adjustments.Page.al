#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10240 "B10 Adjustments"
{
    Caption = 'B10 Adjustments';
    PageType = List;
    SourceTable = UnknownTable10240;

    layout
    {
        area(content)
        {
            repeater(Control1480000)
            {
                field(Date;Date)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the effective date of the B-10 adjustment rate.';
                }
                field("Adjustment Amount";"Adjustment Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the published B-10 amount for the effective date.';
                }
            }
        }
    }

    actions
    {
    }
}

