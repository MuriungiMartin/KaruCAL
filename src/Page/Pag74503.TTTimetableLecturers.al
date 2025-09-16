#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 74503 "TT-Timetable Lecturers"
{
    Caption = 'Timetable Lecturers';
    PageType = List;
    SourceTable = UnknownTable74518;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Lecturer Code";"Lecturer Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Lecturer Specific Campuses")
            {
                ApplicationArea = Basic;
                Caption = 'Lecturer Specific Campuses';
                Image = CheckList;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "TT-Lecturer Spec. Campuses";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester),
                              "Lecturer Code"=field("Lecturer Code");
            }
            action("Lecturer Specific Days")
            {
                ApplicationArea = Basic;
                Caption = 'Lecturer Specific Days';
                Image = CalendarWorkcenter;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "TT-Lect. Spec. Days";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester),
                              "Lecturer Code"=field("Lecturer Code");
            }
            action("Lecturer Specific Lessons")
            {
                ApplicationArea = Basic;
                Caption = 'Lecturer Specific Lessons';
                Image = Compress;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "TT-Lect. Spec. Lessons";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester),
                              "Lecturer Code"=field("Lecturer Code");
            }
        }
    }
}

