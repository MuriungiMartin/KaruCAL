#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 387 "Extended Text Lines"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Extended Text Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Text;Text)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the text. You can use both numbers and letters. There are no restrictions as to the number of lines you can use.';
                }
            }
        }
    }

    actions
    {
    }
}

