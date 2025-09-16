#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68793 "ACA-Time Table - Lecture Room"
{
    DelayedInsert = true;
    Editable = true;
    PageType = List;
    SourceTable = UnknownTable61517;

    layout
    {
    }

    actions
    {
    }

    var
        PeriodCode: Boolean;
        TTable: Record UnknownRecord61540;
        Periods: Record UnknownRecord61514;
        xPeriodCode: Boolean;
        LecUnits: Record UnknownRecord61541;
        LecUnitsTaken: Record UnknownRecord61541;
        TTable2: Record UnknownRecord61540;
        Capacity: Integer;
        Capacity2: Integer;
        LecRooms: Record UnknownRecord61694;
        Lessons: Record UnknownRecord61542;
        LUnits: Record UnknownRecord61541;
        Emp: Record UnknownRecord61188;
        Lec: Code[30];
}

