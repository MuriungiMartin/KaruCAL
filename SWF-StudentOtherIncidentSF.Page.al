#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68659 "SWF-Student Other Incident SF"
{
    PageType = List;
    SourceTable = UnknownTable61596;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Incident Date";"Incident Date")
                {
                    ApplicationArea = Basic;
                }
                field("Incident Case";"Incident Case")
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

