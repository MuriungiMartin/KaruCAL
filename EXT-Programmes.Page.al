#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 74551 "EXT-Programmes"
{
    Caption = 'Timetable Programs';
    PageType = List;
    SourceTable = UnknownTable74553;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Programme Code";"Programme Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Timetable Color";"Timetable Color")
                {
                    ApplicationArea = Basic;
                }
                field("Prog. Name";"Prog. Name")
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
            action("Timetable Units")
            {
                ApplicationArea = Basic;
                Caption = 'Timetable Units';
                Image = Default;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "TT-Timetable Units";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester),
                              "Programme Code"=field("Programme Code");
            }
            action("Prog. Campuses")
            {
                ApplicationArea = Basic;
                Caption = 'Prog. Campuses';
                Image = Delivery;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "TT-Prog. Specific Campuses";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester),
                              "Programme Code"=field("Programme Code");
            }
            action("Prog. Specific Days")
            {
                ApplicationArea = Basic;
                Caption = 'Prog. Specific Days';
                Image = CreateBins;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "TT-Prog. Specific Days";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester),
                              "Programme Code"=field("Programme Code");
            }
            action("Prog. Specific Rooms")
            {
                ApplicationArea = Basic;
                Caption = 'Prog. Specific Rooms';
                Image = CreatePutAway;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "TT-Prog. Spec. Rooms";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester),
                              "Programme Code"=field("Programme Code");
            }
        }
    }
}

