#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68774 "ACA-Time Table"
{
    PageType = ListPlus;
    SourceTable = UnknownTable61517;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(CampusFilter;CampusFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Campus Filter';
                }
                field(ProgFilter;ProgFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Programme Filter';
                    Lookup = true;
                    LookupPageID = "ACA-Programmes List";
                    TableRelation = "ACA-Programme".Code;

                    trigger OnValidate()
                    begin
                         SetFilter("Programme Code",ProgFilter);
                    end;
                }
                field(StageFilter;StageFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stage Filter';
                    Lookup = true;
                    TableRelation = "ACA-Programme Stages".Code;
                }
                field(SemFilter;SemFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester Filter';
                    Lookup = true;
                    TableRelation = "ACA-Semester".Code;
                }
                field(DayFilter;DayFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Day Filter';
                    Lookup = true;
                    TableRelation = "ACA-Day Of Week".Day;
                }
                field(RoomFilter;RoomFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Room Filter';
                    TableRelation = "ACA-Lecture Rooms".Code;
                }
                field(LecFilter;LecFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lecturer Filter';
                    TableRelation = "HRM-Employee C"."No." where (Lecturer=const(true));
                }
            }
            part(MatrixForm;"ACA-Time Table Header")
            {
            }
        }
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
        LecE: Record UnknownRecord61188;
        Prog: Record UnknownRecord61511;
        Prog2: Record UnknownRecord61511;
        Period: Record UnknownRecord61542;
        Department: Code[20];
        RegFT: Integer;
        RegPT: Integer;
        Stages: Record UnknownRecord61516;
        ProgStages: Record UnknownRecord61516;
        PSemester: Record UnknownRecord61525;
        ProgFilter: Code[20];
        StageFilter: Code[20];
        SemFilter: Code[20];
        DayFilter: Code[20];
        RoomFilter: Code[20];
        LecFilter: Code[20];
        CampusFilter: Code[20];
}

