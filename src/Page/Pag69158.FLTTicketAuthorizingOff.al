#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69158 "FLT-Ticket Authorizing Off."
{
    PageType = ListPart;
    SourceTable = UnknownTable61813;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Officer Line no.";"Officer Line no.")
                {
                    ApplicationArea = Basic;
                }
                field("Ticket No.";"Ticket No.")
                {
                    ApplicationArea = Basic;
                }
                field("Officer No.";"Officer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Officer Name";"Officer Name")
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

