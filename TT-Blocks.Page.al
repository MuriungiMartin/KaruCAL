#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 74519 "TT-Blocks"
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
        area(creation)
        {
            action(Rooms)
            {
                ApplicationArea = Basic;
                Caption = 'Rooms';
                Image = Reuse;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "TT-Rooms";
                RunPageLink = "Block Code"=field("Block Code"),
                              "Academic year"=field("Academic Year"),
                              Semester=field(Semester);
            }
        }
    }
}

