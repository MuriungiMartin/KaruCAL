#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68649 "HMS Beds"
{
    PageType = Card;
    SourceTable = UnknownTable61441;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Ward No";"Ward No")
                {
                    ApplicationArea = Basic;
                }
                field("Bed No";"Bed No")
                {
                    ApplicationArea = Basic;
                }
                field("Bed Name";"Bed Name")
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

