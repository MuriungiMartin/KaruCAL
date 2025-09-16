#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68655 "HMS Patient History"
{
    PageType = ListPart;
    SourceTable = UnknownTable61446;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("History Code";"History Code")
                {
                    ApplicationArea = Basic;
                }
                field("History Name";"History Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

