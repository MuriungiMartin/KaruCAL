#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 74522 "TT-Blocks List"
{
    PageType = List;
    SourceTable = UnknownTable74519;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Block Code";"Block Code")
                {
                    ApplicationArea = Basic;
                }
                field("Block Description";"Block Description")
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

