#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 74558 "EXT-Daily Periods"
{
    Caption = 'Timetable Daily Lessons';
    PageType = List;
    SourceTable = UnknownTable74552;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Period Code";"Period Code")
                {
                    ApplicationArea = Basic;
                }
                field("Start Time";"Start Time")
                {
                    ApplicationArea = Basic;
                }
                field("End Time";"End Time")
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

