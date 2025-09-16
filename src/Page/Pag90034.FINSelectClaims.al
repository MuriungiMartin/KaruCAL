#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90034 "FIN-Select Claims"
{
    PageType = List;
    SourceTable = UnknownTable90025;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Claim No.";"Claim No.")
                {
                    ApplicationArea = Basic;
                }
                field("Staff No.";"Staff No.")
                {
                    ApplicationArea = Basic;
                }
                field(Selected;Selected)
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

