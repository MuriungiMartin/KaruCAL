#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50138 "Exam Grading"
{

    trigger OnRun()
    begin
    end;

    var
        Department: Text[120];
        UnitDesc: Text[120];
        Marks: Integer;
        Grade: Text[50];
        RecUnits: Record UnknownRecord61517;
        RecExamsRes: Record UnknownRecord61572;
        RecExams: Record UnknownRecord61526;
        "%FIRST": Integer;
        "%SECND": Integer;
        "%FINAL": Integer;
        "%FINALB": Integer;
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
        Programme: Text[50];
        Stage: Text[50];
        Semester: Text[50];


    procedure CalculateFinalScore(var StudentNo: Code[150];var Unit: Code[150];var NewScore: Integer;var ThisExam: Code[50]) Hadfailed: Boolean
    begin
        RecExamsRes.Reset;
        "%FINAL" := 0;
        RecExamsRes.SetFilter(RecExamsRes."Student No.",StudentNo);
        RecExamsRes.SetFilter(RecExamsRes.Unit,Unit);
        if RecExamsRes.Find('-') then
        begin
             repeat
                  RecExams.Reset;
                  RecExams.SetFilter(RecExams.Code,RecExamsRes."Exam Code");
                  if RecExams.Find('-') then
                  begin
                       "%FIRST" := 0;
                       "%SECND" := 0;
                        "%FIRST" := ROUND(((RecExamsRes.Result)/(RecExams."Max.Score"))*100,1,'=');
                       "%SECND" := ROUND((((RecExams."Contribution %")/100)*("%FIRST")),1,'=');
                       "%FINAL" := "%FINAL" + "%SECND";
                  end;
             until (RecExamsRes.Next = 0);

        end;
        "%FINALB" := 0;
        begin
             repeat
                  RecExams.Reset;
                  RecExams.SetFilter(RecExams.Code,RecExamsRes."Exam Code");
                  if RecExams.Find('-') then
                  begin
                       "%FIRST" := 0;
                       "%SECND" := 0;
                       if RecExams.Code = ThisExam then
                        "%FIRST" := ROUND(((NewScore)/(RecExams."Max.Score"))*100,1,'=')
                       else
                        "%FIRST" := ROUND(((RecExamsRes.Result)/(RecExams."Max.Score"))*100,1,'=');
                        "%SECND" := ROUND((((RecExams."Contribution %")/100)*("%FIRST")),1,'=');
                        "%FINALB" := "%FINAL" + "%SECND";
                  end;
             until (RecExamsRes.Next = 0);

        end;
        begin
             RecExamGrades.Reset;
             RecExamGrades.SetCurrentkey(RecExamGrades.Upto);
             RecExamGrades.SetFilter(RecExamGrades.ExamCode,'DEFAULT');
             RecExamGrades.SetFilter(RecExamGrades.Grade,'PASS');
             if RecExamGrades.Find('-') then
             begin
                  if ("%FINAL" < RecExamGrades.Upto) and ("%FINALB" >= RecExamGrades.Upto)  then
                   exit(true)
                  else
                   exit(false);
             end
        end;
    end;
}

