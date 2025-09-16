#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69027 "ACA-Timetable Lines"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = UnknownTable61517;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Desription;Desription)
                {
                    ApplicationArea = Basic;
                }
                field(T1;Sc[1])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[1];
                    Visible = FieldVisible1;

                    trigger OnValidate()
                    begin
                        // UpdateMarks(Sc[1],MATRIX_CaptionSet[1]);
                    end;
                }
                field(T2;Sc[2])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[2];
                    Visible = FieldVisible2;

                    trigger OnValidate()
                    begin
                        // UpdateMarks(Sc[2],MATRIX_CaptionSet[2]);
                    end;
                }
                field(T3;Sc[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[3];
                    Visible = FieldVisible3;

                    trigger OnValidate()
                    begin
                        //UpdateMarks(Sc[3],MATRIX_CaptionSet[3]);
                    end;
                }
                field(T4;Sc[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[4];
                    Visible = FieldVisible4;

                    trigger OnValidate()
                    begin
                         // UpdateMarks(Sc[4],MATRIX_CaptionSet[4]);
                    end;
                }
                field(T5;Sc[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[5];
                    Visible = FieldVisible5;

                    trigger OnValidate()
                    begin
                        //  UpdateMarks(Sc[5],MATRIX_CaptionSet[5]);
                    end;
                }
                field(T6;Sc[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[1];
                    Visible = FieldVisible1;

                    trigger OnValidate()
                    begin
                        // UpdateMarks(Sc[1],MATRIX_CaptionSet[1]);
                    end;
                }
                field(T7;Sc[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[2];
                    Visible = FieldVisible2;

                    trigger OnValidate()
                    begin
                        // UpdateMarks(Sc[2],MATRIX_CaptionSet[2]);
                    end;
                }
                field(T8;Sc[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[3];
                    Visible = FieldVisible3;

                    trigger OnValidate()
                    begin
                        //UpdateMarks(Sc[3],MATRIX_CaptionSet[3]);
                    end;
                }
                field(T9;Sc[9])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[4];
                    Visible = FieldVisible4;

                    trigger OnValidate()
                    begin
                         // UpdateMarks(Sc[4],MATRIX_CaptionSet[4]);
                    end;
                }
                field(T10;Sc[10])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[5];
                    Visible = FieldVisible5;

                    trigger OnValidate()
                    begin
                        //  UpdateMarks(Sc[5],MATRIX_CaptionSet[5]);
                    end;
                }
                field(T11;Sc[11])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[1];
                    Visible = FieldVisible1;

                    trigger OnValidate()
                    begin
                        // UpdateMarks(Sc[1],MATRIX_CaptionSet[1]);
                    end;
                }
                field(T12;Sc[12])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[2];
                    Visible = FieldVisible2;

                    trigger OnValidate()
                    begin
                        // UpdateMarks(Sc[2],MATRIX_CaptionSet[2]);
                    end;
                }
                field(T13;Sc[13])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[3];
                    Visible = FieldVisible3;

                    trigger OnValidate()
                    begin
                        //UpdateMarks(Sc[3],MATRIX_CaptionSet[3]);
                    end;
                }
                field(T14;Sc[14])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[4];
                    Visible = FieldVisible4;

                    trigger OnValidate()
                    begin
                         // UpdateMarks(Sc[4],MATRIX_CaptionSet[4]);
                    end;
                }
                field(T15;Sc[15])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[5];
                    Visible = FieldVisible5;

                    trigger OnValidate()
                    begin
                         // UpdateMarks(Sc[5],MATRIX_CaptionSet[5]);
                    end;
                }
                field(T16;Sc[16])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[1];
                    Visible = FieldVisible1;

                    trigger OnValidate()
                    begin
                        // UpdateMarks(Sc[1],MATRIX_CaptionSet[1]);
                    end;
                }
                field(T17;Sc[17])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[2];
                    Visible = FieldVisible2;

                    trigger OnValidate()
                    begin
                        // UpdateMarks(Sc[2],MATRIX_CaptionSet[2]);
                    end;
                }
                field(T18;Sc[18])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[3];
                    Visible = FieldVisible3;

                    trigger OnValidate()
                    begin
                        //UpdateMarks(Sc[3],MATRIX_CaptionSet[3]);
                    end;
                }
                field(T19;Sc[19])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[4];
                    Visible = FieldVisible4;

                    trigger OnValidate()
                    begin
                         // UpdateMarks(Sc[4],MATRIX_CaptionSet[4]);
                    end;
                }
                field(T20;Sc[20])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[5];
                    Visible = FieldVisible5;

                    trigger OnValidate()
                    begin
                         //s UpdateMarks(Sc[5],MATRIX_CaptionSet[5]);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
         // GetExamCaption;
          Reset;
          SetFilter("Programme Code",ProgrammeFilter);
          SetFilter("Stage Code",StageFilter);
          SetFilter(Code,UnitFilter);

          GetTT(Code);
          i:=0;
    end;

    var
        Sc: array [20] of Boolean;
        ProgrammeFilter: Code[20];
        StageFilter: Code[20];
        SemesterFilter: Code[20];
        UnitFilter: Code[20];
        DayFilter: Code[20];
        Type: Option Teaching,Exam;
        UnitsR: Record UnknownRecord61517;
        ExamResults: Record UnknownRecord61548;
        ProgRec: Record UnknownRecord61511;
        LessonSetup: Record UnknownRecord61542;
        ExamType: Option Assignment,CAT,"Final Exam",Supplementary,Special;
        GenSetup: Record UnknownRecord61534;
        XxScore: Decimal;
        OriginalUser: Code[20];
        EntryDate: Date;
        ExamContrib: Decimal;
        MaxScore: Decimal;
        xxContrib: Decimal;
        Captions: Integer;
        MATRIX_CaptionSet: array [20] of Code[20];
        i: Integer;
        FieldVisible1: Boolean;
        FieldVisible2: Boolean;
        FieldVisible3: Boolean;
        FieldVisible4: Boolean;
        FieldVisible5: Boolean;
        FieldVisible6: Boolean;
        FieldVisible7: Boolean;
        FieldVisible8: Boolean;
        FieldVisible9: Boolean;
        FieldVisible10: Boolean;
        SemRec: Record UnknownRecord61692;
        LastEntry: Integer;
        TT: Record UnknownRecord61540;


    procedure Load(_ProgrammeFilter: Code[20];_StageFilter: Code[20];_SemesterFilter: Code[20];_UnitFilter: Code[20];_DayFilter: Code[20];_Type: Option Teaching,Exam)
    begin
         ProgrammeFilter:=_ProgrammeFilter;
         StageFilter:=_StageFilter;
         SemesterFilter:=_SemesterFilter;
         UnitFilter:= _UnitFilter;
         DayFilter:=_DayFilter;
         Type:=_Type;
    end;


    procedure GetExamCaption(_Type: Option Teaching,Exam)
    begin
         LessonSetup.Reset;
         LessonSetup.SetRange(LessonSetup.Type,_Type);
         if LessonSetup.Find('-') then begin
         repeat
         i:=i+1;
         if i<6 then
         MATRIX_CaptionSet[i]:=LessonSetup.Code;
         if i=1 then
         FieldVisible1:=true;
         if i=2 then
         FieldVisible2:=true;
         if i=3 then
         FieldVisible3:=true;
         if i=4 then
         FieldVisible4:=true;
         if i=5 then
         FieldVisible5:=true;
         if i=6 then
         FieldVisible6:=true;
         if i=7 then
         FieldVisible7:=true;
         if i=8 then
         FieldVisible8:=true;
         if i=9 then
         FieldVisible9:=true;
         if i=10 then
         FieldVisible10:=true;


         until LessonSetup.Next=0;
         end;
    end;


    procedure UpdateMarks(Allocate: Boolean;UnitCode: Code[20];LessonCode: Code[20];ProgCode: Code[20];StagCode: Code[20];SemCode: Code[20];CampusCode: Code[20];TypeCode: Option Teaching,Exam)
    begin
        if ProgrammeFilter = '' then
        Error('You must specify the Programme filter.');

        if StageFilter = '' then
        Error('You must specify the Stage filter');

        if UnitFilter = '' then
        Error('You must specify the Unit filter.');

        if SemesterFilter = '' then
        Error('You must specify the semester filter.');
    end;


    procedure GetTT(UnitCode: Code[20])
    begin

         for i:=1 to 20 do begin
        // Sc[i]:=FALSE;
         TT.Reset;
         TT.SetRange(TT.Programme,ProgrammeFilter);
         TT.SetRange(TT.Stage,StageFilter);
         TT.SetRange(TT.Semester,SemesterFilter);
         TT.SetRange(TT.Unit,UnitCode);
         TT.SetRange(TT."Day of Week",DayFilter);
         TT.SetRange(TT.Period,MATRIX_CaptionSet[i]);
         if TT.Find('-') then
        // error(UnitCode+','+MATRIX_CaptionSet[i])
         Sc[i]:=true
         else
         Sc[i]:=false;

         end;
    end;
}

