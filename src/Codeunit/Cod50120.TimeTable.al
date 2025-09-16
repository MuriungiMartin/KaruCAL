#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50120 "Time Table"
{

    trigger OnRun()
    begin
    end;

    var
        GenSetup: Record UnknownRecord61534;
        TimeTable: Record UnknownRecord61571;
        ClassRec: Record UnknownRecord61613;
        CV: Integer;
        TRec: Record UnknownRecord61540;
        TRec2: Record UnknownRecord61540;
        TRec3: Record UnknownRecord61540;
        TRec4: Record UnknownRecord61540;
        TRec5: Record UnknownRecord61540;


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
        RoomRec: Record UnknownRecord61694;
        ProgStage1: Record UnknownRecord61516;
        "StageUnits TT Count": Integer;
        "StageUnits Count": Integer;
        LessonCode: Code[20];
        DayCode: Code[20];
    begin

          ProgStage.Reset;
          ProgStage.SetRange(ProgStage."Include in Time Table",true);
         ProgStage.Ascending:=false;
          if ProgStage.Find('-') then begin
          repeat //CLASS

          UnitsRec.Reset;
          UnitsRec.SetRange(UnitsRec."Programme Code",ProgStage."Programme Code");
          UnitsRec.SetRange(UnitsRec."Stage Code",ProgStage.Code);
         // UnitsRec.SETCURRENTKEY(UnitsRec.Code,UnitsRec."Time Tabled Count");
          if UnitsRec.Find('-') then begin
          ConflictOk:=true;
           repeat
           LessonCode:=GetLesson;
           DayCode:=GetDay;
          TT.Reset;
          TT.SetRange(TT.Programme,ProgStage."Programme Code");
          TT.SetFilter(TT."Stage Filter",ProgStage.Code);
          TT.SetFilter(TT."Semester Filter",SemCode);
          TT.SetFilter(TT."Lesson Filter",LessonRec.Code);
          TT.SetFilter(TT."Day Filter",DayRec.Day);
          TT.SetFilter(TT.Unit,UnitsRec.Code);
          if TT.Find('-') then begin
          TT.CalcFields(TT."Unit Count");
          TT.CalcFields(TT."Unit Week Count");
          if TT."Unit Count">0 then ConflictOk:=false;
          end;
          RoomRec.Reset;
          RoomRec.Find('-');
          RoomOk:=false;
          repeat
         // RoomCode:=GetRoom;
          TT.Reset;
          TT.SetRange(TT.Semester,SemCode);
          TT.SetRange(TT.Period,LessonCode);
          TT.SetRange(TT."Day of Week",DayCode);
          TT.SetRange(TT."Lecture Room",RoomCode);
          if TT.Find('-') then
          RoomCode:=GetRoom(RoomCode)
          else
          RoomOk:=true;
          until (RoomOk=true) or (RoomRec.Next=0);

          if ConflictOk=true then begin
          LecturerCode:=GetLecturer(CampusCode,SemCode,UnitsRec.Code);
          if TT."Unit Count"=0 then
         // InsertRandom(UnitsRec.Code,UnitsRec."Programme Code",UnitsRec."Stage Code",SemCode,DayCode,LessonCode,RoomCode,LecturerCode,
        //CampusCode);
          UpdateUnit(UnitsRec."Programme Code",UnitsRec.Code);
          UpdateLesson(LessonCode);
          UpdateDay(DayCode);

          end;
          until UnitsRec.Next=0;
          end;

          until ProgStage.Next=0;
          end;

          Message('Done');
    end;


    procedure InsertRandom(UnitCode: Code[20];SemCode: Code[20];DayCode: Code[20];LessonCode: Code[20];RoomCode: Code[20];LecturerCode: Code[20];ClassName: Code[50];ProgCode: Code[20];StageCode: Code[20];UnitClass: Code[20])
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
        TT.Class:=ClassName;
        TT."Unit Class":=UnitClass;
        //TT."Campus Code":=CampusCode;
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
        LessonRec: Record UnknownRecord61542;
        DayRec: Record UnknownRecord61514;
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

          LessonRec.Reset;
          if LessonRec.Find('-') then begin
          repeat
          LessonRec."Used Count":=0;
          LessonRec.Modify;
          until LessonRec.Next=0;
          end;

          DayRec.Reset;
          if DayRec.Find('-') then begin
          repeat
         // DayRec."Used Count":=0;
          DayRec.Modify;
          until DayRec.Next=0;
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


    procedure UpdateLesson(LessonCode: Code[20])
    var
        LessonRec: Record UnknownRecord61542;
    begin
        LessonRec.Reset;
        LessonRec.SetRange(LessonRec.Code,LessonCode);
        if LessonRec.Find('-') then begin
        LessonRec."Used Count":=LessonRec."Used Count"+1;
        LessonRec.Modify;
        end;
    end;


    procedure UpdateDay(DayCode: Code[20])
    var
        DayRec: Record UnknownRecord61514;
    begin
        DayRec.Reset;
        DayRec.SetRange(DayRec.Day,DayCode);
        if DayRec.Find('-') then begin
        //DayRec."Used Count":=DayRec."Used Count"+1;
        DayRec.Modify;
        end;
    end;


    procedure GetDay() DayCode: Code[20]
    var
        DayRec: Record UnknownRecord61514;
    begin
        DayRec.Reset;
        //DayRec.SETCURRENTKEY(DayRec."Used Count");
        DayRec.Ascending:=false;
        if DayRec.Find('+') then begin
        DayCode:=DayRec.Day;
        end;
    end;


    procedure GetLesson() LessonCode: Code[20]
    var
        LessonRec: Record UnknownRecord61542;
    begin
        LessonRec.Reset;
        LessonRec.SetCurrentkey(LessonRec."Used Count");
        LessonRec.Ascending:=false;
        if LessonRec.Find('+') then begin
        LessonCode:=LessonRec.Code;
        end;
    end;


    procedure GenerateClass(CapSem: Code[20];ClassMax: Integer)
    var
        ProgStages: Record UnknownRecord61516;
        UnitsRec: Record UnknownRecord61517;
        Classes: Integer;
        i: Integer;
        HrEmp: Record UnknownRecord61188;
    begin
          ClassRec.DeleteAll;

          ProgStages.Reset;
          ProgStages.SetRange(ProgStages."Include in Time Table",true);
          if ProgStages.Find('-') then begin
          repeat
          UnitsRec.Reset;
          UnitsRec.SetRange(UnitsRec."Programme Code",ProgStages."Programme Code");
          UnitsRec.SetRange(UnitsRec."Stage Code",ProgStages.Code);
          UnitsRec.SetFilter(UnitsRec."Semester Filter",CapSem);
          if UnitsRec.Find('-') then begin
          repeat
          UnitsRec.CalcFields(UnitsRec."Unit Class Size");
          UnitsRec.CalcFields(UnitsRec."Lecturer Lkup");
          if UnitsRec."Unit Class Size" > ClassMax then
          Classes:=Abs(UnitsRec."Unit Class Size"/ClassMax);
          if Classes<1 then Classes:=1;
          for i:=1 to Classes do begin
           if not ClassRec.Get(UnitsRec.Code+'$'+Format(i)) then begin
            ClassRec.Init;
            ClassRec."Class Code":=UnitsRec.Code+'$'+Format(i);
            ClassRec."Unit Code":=UnitsRec.Code;
            if HrEmp.Get(UnitsRec."Lecturer Lkup") then
            ClassRec.Lecturer:=HrEmp."First Name";
            if UnitsRec."Unit Class Size"> ClassMax then
             ClassRec."Class Size":=ClassMax
            else
             ClassRec."Class Size":=UnitsRec."Unit Class Size";
            ClassRec.Insert;
           end;
          end;
          until UnitsRec.Next=0;
          end;
          until ProgStages.Next=0;
          end;
    end;


    procedure GenerateTT(MaxClassWk: Integer;SemCode: Code[20])
    var
        DayRec: Record UnknownRecord61514;
        LessonRec: Record UnknownRecord61542;
        LecRooms: Record UnknownRecord61520;
    begin

        DayRec.Reset;
        if DayRec.Find('-') then begin
        repeat
        LessonRec.Reset;
        if LessonRec.Find('-') then begin
        repeat
        LecRooms.Reset;
        LecRooms.SetFilter(LecRooms."Day Filter",DayRec.Day);
        LecRooms.SetFilter(LecRooms."Lesson Filter",LessonRec.Code);
        if LecRooms.Find('-') then begin
        repeat

        LecRooms.CalcFields(LecRooms."Used Count");
        if LecRooms."Used Count"<2 then begin

        ClassRec.Reset;
        ClassRec.SetFilter(ClassRec."Day Filter",DayRec.Day);
        ClassRec.SetFilter(ClassRec."Lesson Filter",LessonRec.Code);
        if ClassRec.Find('-') then begin
        repeat
        ClassRec.CalcFields(ClassRec."Day Count");
        ClassRec.CalcFields(ClassRec."Lesson Count");
        ClassRec.CalcFields(ClassRec."Used Count");
        ClassRec.CalcFields(ClassRec."Unit Programme");
        ClassRec.CalcFields(ClassRec."Unit Stage");
        if ClassRec."Class Size"<LecRooms."Maximum Capacity" then begin
        TRec.Reset;
        TRec.SetRange(TRec.Unit,ClassRec."Unit Code");
        TRec.SetRange(TRec."Day of Week",DayRec.Day);
        if TRec.Count<1 then begin    // Check Unit per day
        TRec2.Reset;
        TRec2.SetRange(TRec2."Day of Week",DayRec.Day);
        TRec2.SetRange(TRec2."Lecture Room",LecRooms.Code);
        TRec2.SetRange(TRec2.Period,LessonRec.Code);
        if TRec2.Count<1 then begin   // Check room confict
        TRec3.Reset;
        TRec3.SetRange(TRec3."Unit Class",ClassRec."Class Code");
        if TRec3.Count<MaxClassWk then begin  // Check max class weekly
        TRec4.Reset;
        TRec4.SetRange(TRec4.Lecturer,ClassRec.Lecturer);
        TRec4.SetRange(TRec4.Period,LessonRec.Code);
        TRec4.SetRange(TRec4."Day of Week",DayRec.Day);
        if TRec4.Count<1 then begin  // Check the lecturer conflict
        TRec5.Reset;
        TRec5.SetRange(TRec5.Programme,ClassRec."Unit Programme");
        TRec5.SetRange(TRec5.Stage,ClassRec."Unit Stage");
        TRec5.SetRange(TRec5.Period,LessonRec.Code);
        TRec5.SetRange(TRec5."Day of Week",DayRec.Day);
        if TRec5.Count<1 then begin  // Check the class conflict
        InsertRandom(ClassRec."Unit Code",SemCode,DayRec.Day,LessonRec.Code,LecRooms.Code,ClassRec.Lecturer,ClassRec."Unit Code"
        +'['+Format(ClassRec."Class Size")+'] '+ClassRec.Lecturer+' '+LecRooms.Code,ClassRec."Unit Programme",ClassRec."Unit Stage",
        ClassRec."Class Code");
        end;
        end;
        end;
        end;
        end;
        end;
        until ClassRec.Next=0;
        end;
        end;
        until LecRooms.Next=0;
        end;
        until LessonRec.Next=0;
        end;

        until DayRec.Next=0;
        end;
    end;
}

