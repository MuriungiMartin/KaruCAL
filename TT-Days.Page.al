#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 74523 "TT-Days"
{
    Caption = 'Timetable Days';
    PageType = List;
    SourceTable = UnknownTable74502;

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
                field("Day Code";"Day Code")
                {
                    ApplicationArea = Basic;
                }
                field("Day Order";"Day Order")
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
            action("`")
            {
                ApplicationArea = Basic;
                Caption = 'Daily Lessons';
                Image = AdjustExchangeRates;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "TT-Daily Lessons";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester),
                              "Day Code"=field("Day Code");
            }
        }
    }
}

