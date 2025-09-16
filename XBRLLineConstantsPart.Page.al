#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 581 "XBRL Line Constants Part"
{
    Caption = 'XBRL Line Constants Part';
    PageType = ListPart;
    SourceTable = "XBRL Line Constant";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the constant amount on this line comes into effect. The constant amount on this line applies from this date until the date in the Starting Date field on the next line.';
                }
                field("Constant Amount";"Constant Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount that is exported for this line, from the date in the Starting Date field until a new constant amount comes into effect, if the source type of the XBRL taxonomy line is Constant.';
                }
            }
        }
    }

    actions
    {
    }
}

