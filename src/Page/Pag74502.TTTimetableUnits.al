#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 74502 "TT-Timetable Units"
{
    Caption = 'Timetable Units';
    PageType = List;
    SourceTable = UnknownTable74517;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("Programme Code";"Programme Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unit Name";"Unit Name")
                {
                    ApplicationArea = Basic;
                }
                field("Weighting Category";"Weighting Category")
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
            action("Unit Specific Campuses")
            {
                ApplicationArea = Basic;
                Caption = 'Unit Specific Campuses';
                Image = Dimensions;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "TT-Unit Spec. Campuses";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester),
                              "Programme Code"=field("Programme Code"),
                              "Unit Code"=field("Unit Code");
            }
            action("Unit Specific Rooms")
            {
                ApplicationArea = Basic;
                Caption = 'Unit Specific Rooms';
                Image = GiroPlus;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "TT-Unit Spec. Rooms";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester),
                              "Programme Code"=field("Programme Code"),
                              "Unit Code"=field("Unit Code");
            }
            action("Unit Specific Weighting")
            {
                ApplicationArea = Basic;
                Caption = 'Unit Specific Weighting';
                Image = Warehouse;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "TT-Unit Spec. Weighting";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester),
                              "Programme Code"=field("Programme Code"),
                              "Unit Code"=field("Unit Code");
                Visible = false;
            }
        }
    }
}

