#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51664 "Academic Progress"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Academic Progress.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = Programme,Stage,Semester,"Student No.";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(Names;Names)
            {
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(FacultyDesc;FacultyDesc)
            {
            }
            column(DepartmentDesc;DepartmentDesc)
            {
            }
            column(LevelDesc;LevelDesc)
            {
            }
            column(Course_Registration__Course_Registration___Student_Type_;"ACA-Course Registration"."Student Type")
            {
            }
            column(ProgDesc;ProgDesc)
            {
            }
            column(Course_Registration__Course_Registration___KSPS_No__;"ACA-Course Registration"."OLD No.")
            {
            }
            column(PROGRESS_REPORTCaption;PROGRESS_REPORTCaptionLbl)
            {
            }
            column(Name_of_Student__Caption;Name_of_Student__CaptionLbl)
            {
            }
            column(Admission_Number_Caption;Admission_Number_CaptionLbl)
            {
            }
            column(School_Caption;School_CaptionLbl)
            {
            }
            column(Department_Caption;Department_CaptionLbl)
            {
            }
            column(Unit_DescriptionCaption;Unit_DescriptionCaptionLbl)
            {
            }
            column(Unit_CodeCaption;Unit_CodeCaptionLbl)
            {
            }
            column(Academic_YearCaption;Academic_YearCaptionLbl)
            {
            }
            column(Mode_of_Study_Caption;Mode_of_Study_CaptionLbl)
            {
            }
            column(Course_Caption;Course_CaptionLbl)
            {
            }
            column(CATS__30Caption;CATS__30CaptionLbl)
            {
            }
            column(GradeCaption;GradeCaptionLbl)
            {
            }
            column(Registration_Caption;Registration_CaptionLbl)
            {
            }
            column(Exam__70Caption;Exam__70CaptionLbl)
            {
            }
            column(Total__100Caption;Total__100CaptionLbl)
            {
            }
            column(This_is_not_a_transcript_Caption;This_is_not_a_transcript_CaptionLbl)
            {
            }
            column(Date_Caption;Date_CaptionLbl)
            {
            }
            column(Class_Teacher_Caption;Class_Teacher_CaptionLbl)
            {
            }
            column(FailCaption;FailCaptionLbl)
            {
            }
            column(DistinctionCaption;DistinctionCaptionLbl)
            {
            }
            column(CreditCaption;CreditCaptionLbl)
            {
            }
            column(PassCaption;PassCaptionLbl)
            {
            }
            column(ClassCaption;ClassCaptionLbl)
            {
            }
            column(Key_to_Grading_System_Caption;Key_to_Grading_System_CaptionLbl)
            {
            }
            column(MarksCaption;MarksCaptionLbl)
            {
            }
            column(V75____100_Caption;V75____100_CaptionLbl)
            {
            }
            column(V65____74_Caption;V65____74_CaptionLbl)
            {
            }
            column(V50____64_Caption;V50____64_CaptionLbl)
            {
            }
            column(V49__and_BelowCaption;V49__and_BelowCaptionLbl)
            {
            }
            column(Signed_Caption;Signed_CaptionLbl)
            {
            }
            column(HOD_Caption;HOD_CaptionLbl)
            {
            }
            column(Date_Caption_Control1000000051;Date_Caption_Control1000000051Lbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(Pass_after_sitting_supplementaryCaption;Pass_after_sitting_supplementaryCaptionLbl)
            {
            }
            column(Class_Teacher_Comments_Caption;Class_Teacher_Comments_CaptionLbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Student No."=field("Student No."),Programme=field(Programme),Stage=field(Stage);
                column(ReportForNavId_2992; 2992)
                {
                }
                column(Student_Units_Unit;Unit)
                {
                }
                column(UnitDesc;UnitDesc)
                {
                }
                column(Student_Units__Student_Units___Total_Score_;"ACA-Student Units"."Total Score")
                {
                }
                column(ScoreGrade;ScoreGrade)
                {
                }
                column(Unit_Count_;"Unit Count")
                {
                }
                column(Student_Units__Student_Units___CAT_Total_Marks_;"ACA-Student Units"."CAT Total Marks")
                {
                    DecimalPlaces = 0:0;
                }
                column(Student_Units__Student_Units___Exam_Marks_;"ACA-Student Units"."Exam Marks")
                {
                    DecimalPlaces = 0:0;
                }
                column(Student_Units_Programme;Programme)
                {
                }
                column(Student_Units_Stage;Stage)
                {
                }
                column(Student_Units_Semester;Semester)
                {
                }
                column(Student_Units_Reg__Transacton_ID;"Reg. Transacton ID")
                {
                }
                column(Student_Units_Student_No_;"Student No.")
                {
                }
                column(Student_Units_ENo;ENo)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    "ACA-Student Units".CalcFields("ACA-Student Units"."Total Score");
                    "Unit Count" := "Unit Count" + 1;
                    TotalMarks :=TotalMarks +"ACA-Student Units"."Total Score";

                    RecUnits.Reset;
                    RecUnits.SetFilter(RecUnits.Code,"ACA-Student Units".Unit);
                    if RecUnits.Find('-')  then
                         UnitDesc := RecUnits.Desription;
                    //CalculateFinalScore("Student Units"."Student No.","Student Units".Unit);

                    //ScoreGrade:=GetGradeStatus("Student Units"."Total Score","Student Units".Programme);
                end;

                trigger OnPreDataItem()
                begin
                    "Unit Count" := 0;
                    TOTAL := 0;
                    ThisAverage := 0.0;
                    "%FINAL" := 0.0;
                    CATotals := 0;
                    TotalMarks := 0;
                    FinalFinal := 0;
                    thisFinalScore := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                //////////////GET THE STUDENT NAMES
                Customers.Reset;
                Customers.SetFilter(Customers."No.","ACA-Course Registration"."Student No.");
                if Customers.Find('-') then
                Names := Customers.Name;
                /////////////GET THE STUDENT FACULTY
                ProgrammeRec.Reset;
                ProgrammeRec.SetFilter(ProgrammeRec.Code,"ACA-Course Registration".Programme);
                if ProgrammeRec.Find('-') then
                begin
                ProgDesc := ProgrammeRec.Description;

                DimensionTables.Reset;
                DimensionTables.SetFilter(DimensionTables.Code,ProgrammeRec."Department Code");
                if DimensionTables.Find('-') then
                begin
                DepartmentDesc := DimensionTables.Name;
                end;
                DimensionTables.Reset;
                DimensionTables.SetFilter(DimensionTables.Code,ProgrammeRec."School Code");
                if DimensionTables.Find('-') then
                begin
                FacultyDesc := DimensionTables.Name;
                end;

                end;
                Stages.Reset;
                Stages.SetFilter(Stages."Programme Code","ACA-Course Registration".Programme);
                if Stages.Find('-') then
                begin
                LevelDesc := Stages.Description;
                Semesters.Reset;
                Semesters.SetFilter(Semesters.Code,"ACA-Course Registration".Semester);
                if Semesters.Find('-') then
                LevelDesc := LevelDesc + ' ' + Semesters.Description;
                end;
                //////////////////GENERATE THE STUDENT UNITS/////////////
                thisCount := 1;
                RecUnits.Reset;
                RecUnits.SetFilter(RecUnits."Programme Code","ACA-Course Registration".Programme);
                RecUnits.SetFilter(RecUnits."Stage Code","ACA-Course Registration".Stage);
                if RecUnits.Find('-') then
                begin
                repeat
                thisUnit := RecUnits.Code;
                thisUnitDesc := RecUnits.Desription;
                thisCount := thisCount + 1;
                until RecUnits.Next = 0
                end;
                ////////////////////////////////////////////////////////
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        thisFinalScore: Integer;
        RecExams: Record UnknownRecord61526;
        FinalFinal: Integer;
        TotalMarks: Decimal;
        CATotals: Decimal;
        "Student Exam Registration/Unit": Record UnknownRecord61576;
        "Unit Count": Integer;
        Stages: Record UnknownRecord61516;
        Semesters: Record UnknownRecord61692;
        UnitDesc: Text[120];
        Marks: Integer;
        Grade: Text[50];
        RecUnits: Record UnknownRecord61517;
        RecExamsRes: Record UnknownRecord61572;
        "%FIRST": Decimal;
        "%SECND": Decimal;
        "%FINAL": Integer;
        RecExamGrades: Record UnknownRecord61575;
        ThisGrade: Text[30];
        "Average": Integer;
        TOTAL: Integer;
        ThisAverage: Integer;
        ExamRemark: Text[50];
        Classification: Text[50];
        ThisAverageGrade: Text[30];
        StageGrade: Text[30];
        FailCount: Integer;
        RecStudUnits: Record UnknownRecord61549;
        UnitCount: Integer;
        Programmes: Text[50];
        Stage: Text[50];
        Semester: Text[50];
        Names: Text[150];
        Customers: Record Customer;
        ProgrammeRec: Record UnknownRecord61511;
        "Exam Faculty": Record UnknownRecord61577;
        FacultyDesc: Text[150];
        DepartmentDesc: Text[150];
        DimensionTables: Record "Dimension Value";
        ProgDesc: Text[150];
        LevelDesc: Text[150];
        thisCount: Integer;
        thisUnit: Code[50];
        thisUnitDesc: Text[150];
        ScoreGrade: Code[20];
        PROGRESS_REPORTCaptionLbl: label 'PROGRESS REPORT';
        Name_of_Student__CaptionLbl: label 'Name of Student: ';
        Admission_Number_CaptionLbl: label 'Admission Number:';
        School_CaptionLbl: label 'School:';
        Department_CaptionLbl: label 'Department:';
        Unit_DescriptionCaptionLbl: label 'Unit Description';
        Unit_CodeCaptionLbl: label 'Unit Code';
        Academic_YearCaptionLbl: label 'Academic Year';
        Mode_of_Study_CaptionLbl: label 'Mode of Study:';
        Course_CaptionLbl: label 'Course:';
        CATS__30CaptionLbl: label 'CATS /30';
        GradeCaptionLbl: label 'Grade';
        Registration_CaptionLbl: label 'Registration:';
        Exam__70CaptionLbl: label 'Exam /70';
        Total__100CaptionLbl: label 'Total /100';
        This_is_not_a_transcript_CaptionLbl: label 'This is not a transcript.';
        Date_CaptionLbl: label 'Date:';
        Class_Teacher_CaptionLbl: label 'Class Teacher:';
        FailCaptionLbl: label 'Fail';
        DistinctionCaptionLbl: label 'Distinction';
        CreditCaptionLbl: label 'Credit';
        PassCaptionLbl: label 'Pass';
        ClassCaptionLbl: label 'Class';
        Key_to_Grading_System_CaptionLbl: label 'Key to Grading System:';
        MarksCaptionLbl: label 'Marks';
        V75____100_CaptionLbl: label '75% - 100%';
        V65____74_CaptionLbl: label '65% - 74%';
        V50____64_CaptionLbl: label '50% - 64%';
        V49__and_BelowCaptionLbl: label '49% and Below';
        Signed_CaptionLbl: label 'Signed:';
        HOD_CaptionLbl: label 'HOD:';
        Date_Caption_Control1000000051Lbl: label 'Date:';
        EmptyStringCaptionLbl: label '*';
        Pass_after_sitting_supplementaryCaptionLbl: label 'Pass after sitting supplementary';
        Class_Teacher_Comments_CaptionLbl: label 'Class Teacher Comments:';


    procedure GetUnitDesc(var Unit: Code[100])
    begin
    end;


    procedure GetGrade(var FinalScore: Integer;var Exam: Code[130]) Grade: Text[100]
    begin
                  RecStudUnits.Reset;
                  RecStudUnits.SetFilter(RecStudUnits."Student No.","ACA-Course Registration"."Student No.");
                  RecStudUnits.SetFilter(RecStudUnits.Programme,"ACA-Course Registration".Programme);
                  RecStudUnits.SetFilter(RecStudUnits.Stage,"ACA-Course Registration".Stage);
                  RecStudUnits.SetFilter(RecStudUnits.Semester,"ACA-Course Registration".Semester);
                  RecStudUnits.CalcFields(RecStudUnits.UnitCount);
                  RecExamGrades.Reset;
                  RecExamGrades.SetCurrentkey(RecExamGrades.Upto);
                  RecExamGrades.Ascending := false;
                  RecExamGrades.SetFilter(RecExamGrades.ExamCode,'DEFAULT');
                  if RecExamGrades.Find('-') then
                  begin
                       repeat
                       if FinalScore < RecExamGrades.Upto then
                       begin
                            ThisGrade := RecExamGrades.Grade;
                             if ThisGrade = 'FAIL' then
                              FailCount := FailCount + 1;
                             if(FailCount = 0) then
                              ExamRemark := 'PROCEED';
                             if (FailCount > 0) and (FailCount <= (RecStudUnits.UnitCount)/2) then
                              ExamRemark := 'DEFERRED';
                             if (FailCount > 0) and  (FailCount >= (RecStudUnits.UnitCount)/2) then
                              ExamRemark := 'REPEAT';
                       end;
                       until RecExamGrades.Next = 0;
                 end
    end;


    procedure GetAverage(var Score: Integer) "Average": Decimal
    begin
        if TOTAL <> 0 then
        begin
        "Student Exam Registration/Unit".Reset;
        "Student Exam Registration/Unit".SetFilter("Student Exam Registration/Unit"."Student No.","ACA-Course Registration"."Student No.");
        "Student Exam Registration/Unit".SetFilter("Student Exam Registration/Unit".Programme,"ACA-Course Registration".Programme);
        "Student Exam Registration/Unit".SetFilter("Student Exam Registration/Unit".Stage,"ACA-Course Registration".Stage);
        "Student Exam Registration/Unit".SetFilter("Student Exam Registration/Unit".Semester,"ACA-Course Registration".Semester);
        if "Student Exam Registration/Unit".Find('-') then
        "Student Exam Registration/Unit".CalcFields("Student Exam Registration/Unit".UnitCount);
        if "Student Exam Registration/Unit".UnitCount <> 0 then
        ThisAverage := ROUND(TOTAL/"Student Exam Registration/Unit".UnitCount,1,'=');
        GetAverageGrade(ThisAverage);
        end;
    end;


    procedure GetAverageGrade(var "Average": Integer) Grade: Text[100]
    begin
             begin
                  RecExamGrades.Reset;
                  RecExamGrades.SetCurrentkey(RecExamGrades.Upto);
                  //RecExamGrades.ASCENDING := FALSE;
                  RecExamGrades.SetFilter(RecExamGrades.ExamCode,'DEFAULT');
                  if RecExamGrades.Find('-') then
                  begin
                       repeat
                       if ThisAverage < RecExamGrades.Upto then
                       begin
                            ThisAverageGrade := RecExamGrades.Remark;
                            exit;
                       end;
                       until RecExamGrades.Next = 0;
                  end
             end
    end;


    procedure GoToStudentUnits(var "StudentNo.": Code[120]) TotalFailed: Integer
    begin
    end;


    procedure GoToStudentExams(var StudentNo: Code[150];var Unit: Code[150]) UnitGrade: Text[50]
    begin
    end;


    procedure GetGradeStatus(var AvMarks: Decimal;var ProgCode: Code[20]) G: Code[20]
    var
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[20];
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        ProgrammeRec: Record UnknownRecord61511;
    begin
        G:='';

        GradeCategory:='';
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(ProgCode) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then Error('Please note that you must specify Exam Category in Programme Setup');

        if AvMarks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        repeat
        LastScore:=Gradings."Up to";
        if AvMarks < LastScore then begin
        if ExitDo = false then begin

        G:=Gradings.Grade;
        ExitDo:=true;
        end;
        end;

        until Gradings.Next = 0;


        end;

        end else begin


        end;
    end;
}

