#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69025 "ACA-Marksheet Lines"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = UnknownTable61549;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                }
                field("Total Score";"Total Score")
                {
                    ApplicationArea = Basic;
                }
                field("Cancelled Score";"Cancelled Score")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Unit;Unit)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(EXAM;Sc[1])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[1];
                    Caption = 'Exam';
                    Visible = FieldVisible1;

                    trigger OnValidate()
                    begin
                         UpdateMarks(Sc[1],MATRIX_CaptionSet[1]);
                    end;
                }
                field(CAT1;Sc[2])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[2];
                    Caption = 'CAT1';
                    Visible = FieldVisible2;

                    trigger OnValidate()
                    begin
                         UpdateMarks(Sc[2],MATRIX_CaptionSet[2]);
                    end;
                }
                field(CAT2;Sc[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[3];
                    Caption = 'CAT2';
                    Visible = FieldVisible3;

                    trigger OnValidate()
                    begin
                        UpdateMarks(Sc[3],MATRIX_CaptionSet[3]);
                    end;
                }
                field(CAT3;Sc[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[4];
                    Caption = 'CAT3';
                    Visible = FieldVisible4;

                    trigger OnValidate()
                    begin
                          UpdateMarks(Sc[4],MATRIX_CaptionSet[4]);
                    end;
                }
                field(CAT4;Sc[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[5];
                    Caption = 'CAT4';
                    Visible = FieldVisible5;

                    trigger OnValidate()
                    begin
                          UpdateMarks(Sc[5],MATRIX_CaptionSet[5]);
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
          SetFilter(Programme,ProgrammeFilter);
          SetFilter(Stage,StageFilter);
          SetFilter(Semester,SemesterFilter);
          SetFilter(Unit,UnitFilter);
          SetFilter("Student No.","Student No Filter");
          CalcFields("Exam Marks");
          CalcFields("CAT Total Marks");

          for i:=1 to 5 do begin
          if MATRIX_CaptionSet[i]='EXAM' then
          Sc[i]:="Exam Marks";
          if MATRIX_CaptionSet[i]='CAT' then
          Sc[i]:="CAT Total Marks";
          end;
          i:=0;
    end;

    var
        Sc: array [5] of Decimal;
        ProgrammeFilter: Code[20];
        StageFilter: Code[20];
        SemesterFilter: Code[20];
        UnitFilter: Code[20];
        ExamCategory: Code[20];
        "Student No Filter": Code[20];
        UnitsR: Record UnknownRecord61517;
        ExamResults: Record UnknownRecord61548;
        ProgRec: Record UnknownRecord61511;
        ExamsSetup: Record UnknownRecord61567;
        ExamType: Option Assignment,CAT,"Final Exam",Supplementary,Special;
        GenSetup: Record UnknownRecord61534;
        XxScore: Decimal;
        OriginalUser: Code[20];
        EntryDate: Date;
        ExamContrib: Decimal;
        MaxScore: Decimal;
        xxContrib: Decimal;
        Captions: Integer;
        MATRIX_CaptionSet: array [5] of Code[20];
        i: Integer;
        FieldVisible1: Boolean;
        FieldVisible2: Boolean;
        FieldVisible3: Boolean;
        FieldVisible4: Boolean;
        FieldVisible5: Boolean;
        SemRec: Record UnknownRecord61692;
        LastEntry: Integer;
        RegisterFor: Option Stage,"Unit/Subject",Supplementary;


    procedure Load(_ProgrammeFilter: Code[20];_StageFilter: Code[20];_SemesterFilter: Code[20];_UnitFilter: Code[20];_ExamCategory: Code[20];_RegisterFor: Option Stage,"Unit/Subject",Supplementary;"_Student No": Code[20])
    begin
         ProgrammeFilter:=_ProgrammeFilter;
         StageFilter:=_StageFilter;
         SemesterFilter:=_SemesterFilter;
         UnitFilter:= _UnitFilter;
         ExamCategory:=_ExamCategory;
         RegisterFor:=_RegisterFor;
         "Student No Filter":="_Student No";
    end;


    procedure GetExamCaption(_ExamCategory: Code[20])
    begin
         ExamsSetup.Reset;
         ExamsSetup.SetRange(ExamsSetup.Category,_ExamCategory);
         if ExamsSetup.Find('-') then begin
         repeat
         i:=i+1;
         if i<6 then
         MATRIX_CaptionSet[i]:=ExamsSetup.Code;
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

         until ExamsSetup.Next=0;
         end;
    end;


    procedure UpdateMarks(Score: Decimal;MarksType: Code[20])
    begin
        if ProgrammeFilter = '' then
        Error('You must specify the Programme filter.');
        
        if StageFilter = '' then
        Error('You must specify the Stage filter');
        
        if UnitFilter = '' then
        Error('You must specify the Unit filter.');
        
        
        if SemesterFilter = '' then
        Error('You must specify the semester filter.');
        
        SemRec.Get(SemesterFilter);
        if MarksType='EXAM' then
        if SemRec."Lock CAT Editting"=true then Error('Please note that editting of Exam Marks for the selected period has been locked')
        else
        if SemRec."Lock CAT Editting"=true then Error('Please note that editting of CAT Marks for the selected period has been locked');
        if SemRec."Lock Lecturer Editing"=true then Error('Please note editing of marks can be done by HOD or the Dean');
        
        //IF PeriodCode='' THEN
        //ERROR('You must specify the Exam Period.');
        
        UnitsR.Reset;
        UnitsR.SetRange(UnitsR."Programme Code",ProgrammeFilter);
        UnitsR.SetRange(UnitsR.Code,UnitFilter);
        if UnitsR.Find('-') then begin
        if UnitsR.Submited =true then
        Error('The marks have already been submited.');
        end;
        
        //MESSAGE(FORMAT(score));
        if Score<0 then Error('Marks Can Not be Less than Zero');
        ExamsSetup.Reset;
        ExamsSetup.SetFilter(ExamsSetup.Category,GetFilter(Category));
        ExamsSetup.SetRange(ExamsSetup.Code,MarksType);
        if ExamsSetup.Find('-') then begin
        if Score > ExamsSetup."Max. Score" then
        Error('You Cant Enter Score Above The Maximum Score. The Maximum Score is '+Format(ExamsSetup."Max. Score"));
        if ExamsSetup.Type = ExamsSetup.Type::Supplementary then begin
        if "Allow Supplementary" = false then
        Error('Student not allowed to sit supplementary.');
        end;
        end;
        
        
        
        
        
        
        /*/////////////Comment checks
        
        ExamsSetup.RESET;
        ExamsSetup.SETRANGE(ExamsSetup.Category,GETFILTER(Category));
        ExamsSetup.SETRANGE(ExamsSetup.Code,CurrForm.Matrix.MatrixRec.Code);
        IF ExamsSetup.FIND('-') THEN BEGIN
        IF ExamsSetup.Type = ExamsSetup.Type::"Final Exam" THEN BEGIN
        //Check Fee Bal
        IF Cust.GET("Student No.") THEN BEGIN
        Cust.CALCFIELDS(Cust."Balance (LCY)");
        IF Cust."Balance (LCY)" > 0 THEN
        ERROR('Student has a fee balance.');
        
        //Check if CAT done
        Exams.RESET;
        Exams.SETRANGE(Exams.Category,ExamCategory);
        Exams.SETRANGE(Exams.Type,Exams.Type::CAT);
        IF Exams.FIND('-') THEN BEGIN
        REPEAT
        EResults.RESET;
        EResults.SETRANGE(EResults."Student No.","Student No.");
        EResults.SETRANGE(EResults.Programme,Programme);
        EResults.SETRANGE(EResults.Unit,Unit);
        EResults.SETRANGE(EResults.Semester,GETFILTER("Semester Filter"));
        EResults.SETRANGE(EResults.Exam,Exams.Code);
        EResults.SETFILTER(EResults.Score,'>0');
        IF EResults.FIND('-') = FALSE THEN
        ERROR('%1 not done.',Exams.Desription);
        
        
        UNTIL Exams.NEXT = 0;
        END;
        
        
        END;
        
        UnitsR.RESET;
        UnitsR.SETRANGE(UnitsR."Programme Code",Programme);
        UnitsR.SETRANGE(UnitsR.Code,Unit);
        IF UnitsR.FIND('-') THEN BEGIN
        IF UnitsR."Credit Hours" > 0 THEN BEGIN
        IF Attendance < (0.75*UnitsR."Credit Hours") THEN
        ERROR('Student attendance less than the minimum required (75 Percent).');
        END;
        END;
        END;
        
        IF Score > ExamsSetup."Max. Score" THEN
        ERROR('You cant enter score above the maximum score.');
        IF ExamsSetup.Type = ExamsSetup.Type::Supplementary THEN BEGIN
        IF "Allow Supplementary" = FALSE THEN
        ERROR('Student not allowed to sit supplementary.');
        END;
        END;
        
        
        
        IF (GETFILTER("Exam Type") ='SPECIAL') OR (GETFILTER("Exam Type") ='SUPPLEMENTARY') THEN
        IF CurrForm.Matrix.MatrixRec.Code<> 'EXAM' THEN
        ERROR('Please note that CAT is not allowed for SPECIAL and SUPPLEMENTARY Exams ');
        */
        ProgRec.Get(Programme);
        ProgRec.TestField(ProgRec."Exam Category");
        ExamsSetup.Reset;
        ExamsSetup.SetFilter(ExamsSetup.Category,ProgRec."Exam Category");
        ExamsSetup.SetRange(ExamsSetup.Code,MarksType);
        if ExamsSetup.Find('-') then begin
        ExamType:=ExamsSetup.Type;
        MaxScore:=ExamsSetup."Max. Score";
        ExamContrib:=ExamsSetup."% Contrib. Final Score";
        end;
        
        
        OriginalUser:=UserId;
        ExamResults.Reset;
        //ExamResults.SETRANGE(ExamResults."Reg. Transaction ID","Reg. Transacton ID");
        ExamResults.SetRange(ExamResults."Student No.","Student No.");
        ExamResults.SetRange(ExamResults.Programme,Programme);
        ExamResults.SetRange(ExamResults.Stage,Stage);
        ExamResults.SetRange(ExamResults.Unit,Unit);
        ExamResults.SetRange(ExamResults.Semester,SemesterFilter);
        ExamResults.SetRange(ExamResults.ExamType,MarksType);
        if ExamResults.Find('-') then begin
        repeat
        XxScore:=ExamResults.Score;
        xxContrib:=(XxScore*ExamContrib)/MaxScore;
        OriginalUser:=ExamResults.User_ID;
        ExamResults.Cancelled:=true;
        ExamResults."Cancelled By":=UserId;
        ExamResults."Cancelled Date":=Today;
        ExamResults.Modify;
        until ExamResults.Next=0;
        end;
        
        ExamResults.Reset;
        if ExamResults.Find('-') then
        LastEntry:=ExamResults.Count;
        
        ExamResults.Init;
        ExamResults."Reg. Transaction ID":="Reg. Transacton ID";
        ExamResults."Student No.":="Student No.";
        ExamResults.Programme:=Programme;
        ExamResults.Stage:=Stage;
        ExamResults.Unit:=Unit;
        ExamResults.Semester:=SemesterFilter;
        ExamResults.Score:=Score;
        ExamResults.Exam:=Format(MarksType);
        ExamResults.ExamType:=MarksType;
        ExamResults.Category:=ExamCategory;
        //ExamResults.VALIDATE(ExamResults.Score);
        ExamResults.Contribution:=(Score*ExamContrib)/MaxScore;
        ExamResults.User_ID:=OriginalUser;
        ExamResults."Last Edited By":=UserId;
        ExamResults."Last Edited On":=Today;
        ExamResults."Original Score":=XxScore;
        ExamResults."Original Contribution":=xxContrib;
        ExamResults."Entry No":=LastEntry+1;
        ExamResults.Insert;

    end;
}

