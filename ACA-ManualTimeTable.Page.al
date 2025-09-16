#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68798 "ACA-Manual Time Table"
{
    PageType = List;
    SourceTable = UnknownTable61540;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Day of Week";"Day of Week")
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field(Unit;Unit)
                {
                    ApplicationArea = Basic;
                }
                field("Programme Option";"Programme Option")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Period;Period)
                {
                    ApplicationArea = Basic;
                }
                field("Room Type";"Room Type")
                {
                    ApplicationArea = Basic;
                }
                field("Lecture Room";"Lecture Room")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        
                        //Check room reservation
                        LecRooms.Reset;
                        LecRooms.SetRange(LecRooms.Code,"Lecture Room");
                        if LecRooms.Find('-') then begin
                        if LecRooms."Reserve For" <> '' then begin
                        Prog.Reset;
                        Prog.SetRange(Prog.Code,Programme);
                        if Prog.Find('-') then begin
                        if Prog.Faculty <> LecRooms."Reserve For" then
                        Error('You can not use this room. Room has been reserved.');
                        end;
                        
                        end;
                        
                        
                        //Check student availability
                        /*
                        TTable2.RESET;
                        TTable2.SETRANGE(TTable2.Released,FALSE);
                        TTable2.SETRANGE(TTable2.Programme,"Programme Code");
                        TTable2.SETRANGE(TTable2.Stage,"Stage Code");
                        TTable2.SETRANGE(TTable2.Semester,GETFILTER("Semester Filter"));
                        TTable2.SETRANGE(TTable2."Day of Week",GETFILTER("Day Filter"));
                        TTable2.SETRANGE(TTable2.Period,CurrForm.Matrix.MatrixRec.Code);
                        TTable2.SETRANGE(TTable2.Class,GETFILTER("Class Filter"));
                        IF TTable2.FIND('-') THEN
                        ERROR('Class already allocated a class at this time.');
                        */
                        
                        
                        TTable2.Reset;
                        TTable2.SetRange(TTable2.Released,false);
                        TTable2.SetRange(TTable2.Semester,Semester);
                        TTable2.SetRange(TTable2.Period,Period);
                        TTable2.SetRange(TTable2."Day of Week","Day of Week");
                        TTable2.SetRange(TTable2."Lecture Room","Lecture Room");
                        if TTable2.Find('-') then begin
                        if Confirm('Lecture room occupied at the specified period/lesson. Do you wish to create a combined lesson?') = false then
                        exit;
                        end;
                        
                        Lessons.Reset;
                        Lessons.SetRange(Lessons.Code,Period);
                        if Lessons.Find('-') = false then
                        Error('Lesson not found.');
                        
                        LecUnits.Reset;
                        LecUnits.SetRange(LecUnits.Programme,Programme);
                        LecUnits.SetRange(LecUnits.Stage,Stage);
                        LecUnits.SetRange(LecUnits.Unit,Unit);
                        LecUnits.SetRange(LecUnits.Semester,Semester);
                        //LecUnits.SETRANGE(LecUnits.Class,Class);
                        //LecUnits.SETRANGE(LecUnits."Unit Class","Unit Class");
                        if LecUnits.Find('-') then begin
                        //Check contract hours
                        LecUnits.CalcFields(LecUnits."Time Table Hours");
                        if LecUnits."No. Of Hours Contracted" < (LecUnits."Time Table Hours"+Lessons."No Of Hours") then begin
                        if Confirm('Lecturers contracted hours will be exceded. Do you wish to continue?') = false then
                        exit;
                        end;
                        
                        //Check availability
                        if (Lessons."Start Time" < LecUnits."Available From") or (Lessons."End Time" > LecUnits."Available To") then begin
                        if Confirm('Lecturer not available at this time as per the contract. Do you wish to continue?') = false then
                        exit;
                        end;
                        
                        //Check lecturer conflict
                        LecUnitsTaken.Reset;
                        LecUnitsTaken.SetRange(LecUnitsTaken.Semester,Semester);
                        LecUnitsTaken.SetRange(LecUnitsTaken.Lecturer,LecUnits.Lecturer);
                        if LecUnitsTaken.Find('-') then begin
                        repeat
                        TTable2.Reset;
                        TTable2.SetRange(TTable2.Released,false);
                        TTable2.SetRange(TTable2.Programme,LecUnitsTaken.Programme);
                        TTable2.SetRange(TTable2.Stage,LecUnitsTaken.Stage);
                        TTable2.SetRange(TTable2.Unit,LecUnitsTaken.Unit);
                        TTable2.SetRange(TTable2.Semester,Semester);
                        TTable2.SetRange(TTable2.Period,Period);
                        TTable2.SetRange(TTable2."Day of Week","Day of Week");
                        TTable2.SetRange(TTable2.Class,Class);
                        TTable2.SetRange(TTable2."Unit Class","Unit Class");
                        if TTable2.Find('-') then begin
                        if Confirm('Lecturer occupied at the specified period/lesson. Do you wish to create a combined lesson?') = false then
                        exit;
                        end;
                        
                        until LecUnitsTaken.Next = 0
                        
                        end;
                        end;
                        
                        //If exam, check date
                        if TTable.Exam <> '' then
                        if GetFilter("Exam Date") = '' then
                        Error('You must specify the exam date.');
                        
                        
                        
                        TTable2.Reset;
                        TTable2.SetRange(TTable2.Released,false);
                        TTable2.SetRange(TTable2.Programme,Programme);
                        TTable2.SetRange(TTable2.Stage,Stage);
                        TTable2.SetRange(TTable2.Unit,Unit);
                        TTable2.SetRange(TTable2.Semester,Semester);
                        TTable2.SetRange(TTable2."Day of Week",Period);
                        TTable2.SetRange(TTable2.Class,Class);
                        TTable2.SetRange(TTable2."Unit Class","Unit Class");
                        TTable2.SetRange(TTable2.Exam,Exam);
                        if TTable2.Count > 3 then
                        Error('You can not have more than 3 lessons in a day');
                        
                        
                        /*
                        IF "Students Registered" < Capacity THEN
                        MESSAGE('Student registered less than the Minimum capacity for this room.');
                        
                        IF "Students Registered" > Capacity2 THEN
                        MESSAGE('Student registered more than the Maximum capacity for this room.');
                        */
                        
                        
                        end;

                    end;
                }
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
}

