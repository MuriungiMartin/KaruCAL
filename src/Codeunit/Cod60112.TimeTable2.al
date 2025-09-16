#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60112 "Time Table2"
{

    trigger OnRun()
    begin
    end;

    var
        GenSetup: Record UnknownRecord61534;
        TimeTable: Record UnknownRecord61571;


    procedure InsertTimeTable(Unit: Code[20];Lesson: Code[20])
    var
        TT: Record UnknownRecord61540;
    begin
        GenSetup.Get();
        if TimeTable.Get(GenSetup."Current TT Code") then begin
        CheckConflict(Unit,Lesson);
        TT.Init;
        TT.Programme:=TimeTable.Programme;
        TT.Stage:=TimeTable.Stage;
        TT.Unit:=Unit;
        TT.Semester:=TimeTable.Semester;
        TT.Period:=Lesson;
        TT."Day of Week":=TimeTable.Day;
        TT."Lecture Room":=TimeTable."Lecturer Room";
        TT.Lecturer:=TimeTable.Lecturer;
        TT."Campus Code":=TimeTable.Campus;
        TT.Insert;
        end;
    end;


    procedure CheckConflict(Unit: Code[20];Lesson: Code[20])
    var
        TTable2: Record UnknownRecord61540;
    begin
        GenSetup.Get();
        if TimeTable.Get(GenSetup."Current TT Code") then begin

        TTable2.Reset;
        TTable2.SetRange(TTable2.Released,false);
        TTable2.SetRange(TTable2.Programme,TimeTable.Programme);
        TTable2.SetRange(TTable2.Stage,TimeTable.Stage);
        TTable2.SetRange(TTable2.Semester,TimeTable.Semester);
        TTable2.SetRange(TTable2."Day of Week",TimeTable.Day);
        TTable2.SetRange(TTable2.Period,Lesson);
        TTable2.SetRange(TTable2.Unit,Unit);
        //TTable2.SETRANGE(TTable2.Session,GETFILTER("Session Filter"));

        if TTable2.Find('-') then
        Error('Class already allocated a class at this time.');



        TTable2.Reset;
        TTable2.SetRange(TTable2.Released,false);
        TTable2.SetRange(TTable2.Semester,TimeTable.Semester);
        TTable2.SetRange(TTable2.Period,Lesson);
        TTable2.SetRange(TTable2."Day of Week",TimeTable.Day);
        TTable2.SetRange(TTable2."Lecture Room",TimeTable."Lecturer Room");
        if TTable2.Find('-') then begin
        if Confirm('Lecture room occupied at the specified period/lesson. Do you wish to create a combined lesson?') = false then
        exit;
        //ERROR('Lecture room occupied at the specified period/lesson.');
        end;


        TTable2.Reset;
        TTable2.SetRange(TTable2.Released,false);
        TTable2.SetRange(TTable2.Programme,TimeTable.Programme);
        TTable2.SetRange(TTable2.Semester,TimeTable.Semester);
        TTable2.SetRange(TTable2.Period,Lesson);
        TTable2.SetRange(TTable2."Day of Week",TimeTable.Day);
        //TTable2.SETRANGE(TTable2.Class,GETFILTER("Class Filter"));
        TTable2.SetRange(TTable2.Lecturer,TimeTable.Lecturer);
        if TTable2.Find('-') then begin
         Error('Lecturer occupied at the specified period/lesson.') ;
        end;

        end;
    end;


    procedure Randomization(SemCode: Code[20];CampusCode: Code[20])
    var
        DayRec: Record UnknownRecord61514;
        LessonRec: Record UnknownRecord61542;
        ProgStage: Record UnknownRecord61516;
        UnitsRec: Record UnknownRecord61517;
        TT: Record UnknownRecord61540;
        ConflictOk: Boolean;
        RoomCode: Code[20];
        LecturerCode: Code[20];
        RoomOk: Boolean;
        RoomRec: Record UnknownRecord61520;
    begin

          DayRec.Reset;
          if DayRec.Find('-') then begin
          repeat  //DAY
         // ERROR('TEST');
          LessonRec.Reset;
          if LessonRec.Find('-') then begin
          repeat //LESSON
          ProgStage.Reset;
          ProgStage.SetRange(ProgStage."Include in Time Table",true);
          if ProgStage.Find('-') then begin
          repeat //CLASS

          UnitsRec.Reset;
          UnitsRec.SetRange(UnitsRec."Programme Code",ProgStage."Programme Code");
          UnitsRec.SetRange(UnitsRec."Stage Code",ProgStage.Code);
          UnitsRec.SetCurrentkey(UnitsRec.Code,UnitsRec."Time Tabled Count");
          if UnitsRec.Find('-') then begin
          ConflictOk:=true;

          TT.Reset;
          TT.SetFilter(TT."Programme Filter",UnitsRec."Programme Code");
          TT.SetFilter(TT.Stage,UnitsRec."Stage Code");
          TT.SetFilter(TT.Semester,SemCode);
          TT.SetFilter(TT.Period,LessonRec.Code);
          TT.SetFilter(TT."Day of Week",DayRec.Day);
          TT.SetFilter(TT.Unit,UnitsRec.Code);
          if TT.Find('-') then begin
          TT.CalcFields(TT."Unit Count");
          if TT."Unit Count">1 then ConflictOk:=false;
          end;
          RoomRec.Reset;
          RoomRec.Find('-');
          RoomOk:=false;
          repeat
         // RoomCode:=GetRoom;
          TT.Reset;
          TT.SetRange(TT.Semester,SemCode);
          TT.SetRange(TT.Period,LessonRec.Code);
          TT.SetRange(TT."Day of Week",DayRec.Day);
          TT.SetRange(TT."Lecture Room",RoomCode);
          if TT.Find('-') then
          RoomCode:=GetRoom(RoomCode)
          else
          RoomOk:=true;
          until (RoomOk=true) or (RoomRec.Next=0);

          if ConflictOk=true then begin
          LecturerCode:=GetLecturer(CampusCode,SemCode,UnitsRec.Code);
          InsertRandom(UnitsRec.Code,UnitsRec."Programme Code",UnitsRec."Stage Code",SemCode,DayRec.Day,LessonRec.Code,RoomCode,LecturerCode,CampusCode);
          UpdateUnit(UnitsRec."Programme Code",UnitsRec.Code);

          end;
          end;
          until ProgStage.Next=0;
          end;
          until LessonRec.Next=0;
          end;
          until DayRec.Next=0;
          end;
          Message('Done');
    end;


    procedure InsertRandom(UnitCode: Code[20];ProgCode: Code[20];StageCode: Code[20];SemCode: Code[20];DayCode: Code[20];LessonCode: Code[20];RoomCode: Code[20];LecturerCode: Code[20];CampusCode: Code[20])
    var
        TT: Record UnknownRecord61540;
    begin
        TT.Init;
        TT.Programme:=ProgCode;
        TT.Stage:=StageCode;
        TT.Unit:=UnitCode;
        TT.Semester:=SemCode;
        TT.Period:=LessonCode;
        TT."Day of Week":=DayCode;
        TT."Lecture Room":=RoomCode;
        TT.Lecturer:=LecturerCode;
        TT."Campus Code":=CampusCode;
        TT.Auto:=true;
        TT.Insert;
    end;


    procedure UpdateUnit(ProgCode: Code[20];UnitCode: Code[20])
    var
        UnitsRec: Record UnknownRecord61517;
    begin
        UnitsRec.Reset;
        UnitsRec.SetRange(UnitsRec."Programme Code",ProgCode);
        UnitsRec.SetRange(UnitsRec.Code,UnitCode);
        if UnitsRec.Find('-') then begin
        UnitsRec."Time Tabled Count":=UnitsRec."Time Tabled Count"+1;
        UnitsRec.Modify;
        end;
    end;


    procedure GetRoom(badRoom: Code[20]) Room: Code[20]
    var
        LecRoom: Record UnknownRecord61520;
    begin
           UpdateRoom(badRoom);
          LecRoom.Reset;
          LecRoom.SetFilter(LecRoom.Code,'<>%1',badRoom);
         // LecRoom.SETFILTER(LecRoom."Time Table Count",'<%1',100);
          LecRoom.SetCurrentkey("Time Table Count");
          LecRoom.Ascending:=false;
          if LecRoom.Find('+') then
          Room:=LecRoom.Code;
          UpdateRoom(Room);
    end;


    procedure ClearCurrentTimeTable(SemCode: Code[20];CompusCode: Code[20])
    var
        TT: Record UnknownRecord61540;
        RoomRec: Record UnknownRecord61520;
        UnitsRec: Record UnknownRecord61517;
    begin
          TT.Reset;
          TT.SetRange(TT.Semester,SemCode);
          TT.SetRange(TT."Campus Code",CompusCode);
          TT.SetRange(TT.Auto,true);
          if TT.Find('-') then begin
          repeat
          TT.Delete;
          until TT.Next=0;
          end;

          UnitsRec.Reset;
          if UnitsRec.Find('-') then begin
          repeat
          UnitsRec."Time Tabled Count":=0;
          UnitsRec.Modify;
          until UnitsRec.Next=0;
          end;

          RoomRec.Reset;
          if RoomRec.Find('-') then begin
          repeat
          RoomRec."Time Table Count":=0;
          RoomRec.Modify;
          until RoomRec.Next=0;
          end;

          Message('The Time Table has been cleared Successfuly');
    end;


    procedure UpdateRoom(RoomCode: Code[20])
    var
        RoomRec: Record UnknownRecord61520;
    begin
        RoomRec.Reset;
        RoomRec.SetRange(RoomRec.Code,RoomCode);
        if RoomRec.Find('-') then begin
        RoomRec."Time Table Count":=RoomRec."Time Table Count"+1;
        RoomRec.Modify;
        end;
    end;


    procedure GetLecturer(CompusCode: Code[20];SemCode: Code[20];UnitCode: Code[20]) LectCode: Code[20]
    var
        LecUnits: Record UnknownRecord61541;
    begin
          LecUnits.Reset;
          LecUnits.SetRange(LecUnits.Semester,SemCode);
          LecUnits.SetRange(LecUnits."Campus Code",CompusCode);
          LecUnits.SetRange(LecUnits.Unit,UnitCode);
          if LecUnits.Find('-') then
          LectCode:=LecUnits.Lecturer;
    end;
}

