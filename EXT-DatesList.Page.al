#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 74557 "EXT-Dates List"
{
    Caption = 'Timetable Days';
    PageType = List;
    SourceTable = UnknownTable74551;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Date Code";"Date Code")
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

