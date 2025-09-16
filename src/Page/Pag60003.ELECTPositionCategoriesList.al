#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60003 "ELECT-Position Categories List"
{
    PageType = List;
    SourceTable = UnknownTable60003;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic;
                }
                field("Category Description";"Category Description")
                {
                    ApplicationArea = Basic;
                }
                field("Order";Order)
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
            action("Elective Positions")
            {
                ApplicationArea = Basic;
                Caption = 'Elective Positions';
                Image = Aging;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ELECT-Positions List";
                RunPageLink = "Election Code"=field("Election Code"),
                              "Position Category"=field("Category Code");
            }
        }
    }

    var
        ELECTCandidates: Record UnknownRecord60006;
        ELECTPositionCategories: Record UnknownRecord60003;
        ELECTPositions: Record UnknownRecord60001;
}

