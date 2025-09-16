#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50137 "SUPPS&REPS"
{

    trigger OnRun()
    begin
    end;

    var
        RecStudUnits: Record UnknownRecord61576;
        RecExams: Record UnknownRecord61526;
        TotCount: Integer;
        "%FIRST": Integer;
        "%SECND": Integer;
        "%FINAL": Integer;
        RecExamGrades: Record UnknownRecord61575;
        ThisGrade: Text[50];
        FailCount: Integer;
        StageGrade: Text[50];
        "Student Names": Text[150];
        UnitCount: Integer;
        "RecSupps&Reps": Record UnknownRecord61581;
        RecStudExams: Integer;
        RecStudExams2: Record UnknownRecord61572;


    procedure GoToStudentUnits(var "StudentNo.": Code[120]) TotalFailed: Integer
    begin
        StageGrade := '';
        FailCount := 0.0;
        "%FINAL" := 0.0;
        RecStudUnits.Reset;
        RecStudUnits.SetRange(RecStudUnits."Student No.","StudentNo.");
        if RecStudUnits.Find('-') then
        RecStudUnits.CalcFields(RecStudUnits.UnitCount);
        UnitCount := RecStudUnits.UnitCount;
        begin
             repeat
                   if GoToStudentExams("StudentNo.",RecStudUnits.Unit) = 'FAIL' then
                   begin
                        FailCount := FailCount + 1;
                   end;
             until (RecStudUnits.Next = 0);
        end;
        if FailCount <= (RecStudUnits.UnitCount)/2 then
        begin
             StageGrade := 'SUPPLEMENTARY';
        end;
        if FailCount >= (RecStudUnits.UnitCount)/2 then
        begin
             StageGrade := 'REPEAT';
        end;
        UpdateRecord(RecStudUnits."Student No.",RecStudUnits."Student Name",RecStudUnits.Programme,RecStudUnits.Stage,
        RecStudUnits.Semester,RecStudUnits.UnitCount,FailCount,StageGrade);
    end;


    procedure GoToStudentExams(var StudentNo: Code[150];var Unit: Code[150]) UnitGrade: Text[50]
    begin
        RecStudExams2.Reset;
        RecStudExams2.SetFilter(RecStudExams2."Student No.",StudentNo);
        RecStudExams2.SetFilter(RecStudExams2.Unit,Unit);
        if RecStudExams2.Find('-') then
        begin
             repeat
                  RecExams.Reset;
                  RecExams.SetFilter(RecExams.Code,RecStudExams2."Exam Code");
                  if RecExams.Find('-') then
                  begin
                       "%FIRST" := 0;
                       "%SECND" := 0;
                       "%FIRST" := ROUND(((RecStudExams2.Result)/(RecExams."Max.Score"))*100,1,'=');
                       "%SECND" := ROUND((((RecExams."Contribution %")/100)*("%FIRST")),1,'=');
                       "%FINAL" := "%FINAL" + "%SECND";

                 end
                 until (RecStudExams2.Next = 0);


        end
        else
        begin
             "%FINAL" := 0.0;
        end;
                 begin
                      RecExamGrades.Reset;
                      RecExamGrades.SetCurrentkey(RecExamGrades.Upto);
                      RecExamGrades.SetFilter(RecExamGrades.ExamCode,'DEFAULT');
                      if RecExamGrades.Find('-') then
                       begin
                            repeat
                                 if "%FINAL" < RecExamGrades.Upto then
                                 begin
                                  ThisGrade := RecExamGrades.Grade;
                                  UnitGrade := ThisGrade;
                                  exit;
                                 end;
                            until RecExamGrades.Next = 0;
                       end
                end
    end;


    procedure GetStageGrade(var TotalDone: Integer;var TotalFailed: Integer) StageGrade: Text[50]
    begin
    end;


    procedure UpdateRecord(var StudentNo: Code[120];var StudentName: Text[150];var Programme: Code[80];var Stage: Code[80];var Semester: Code[80];var UnitsDone: Integer;var UnitsFailed: Integer;var Grade: Text[50])
    begin
        "RecSupps&Reps".Reset;
        "RecSupps&Reps".SetFilter("RecSupps&Reps".StudentNo,StudentNo);
        "RecSupps&Reps".SetFilter("RecSupps&Reps".Stage,Stage);
        if "RecSupps&Reps".Find('-') then
        begin
             "RecSupps&Reps".StudentNo := StudentNo;
             "RecSupps&Reps".StudentName := StudentName;
             "RecSupps&Reps".Programme := Programme;
             "RecSupps&Reps".Stage := Stage;
             "RecSupps&Reps".Semester := Semester;
             "RecSupps&Reps".UnitsDone := UnitsDone;
             "RecSupps&Reps".UnitsFailed := UnitsFailed;
             "RecSupps&Reps".FinalGrade := Grade;
             "RecSupps&Reps".Modify;
        end
        else
        begin
             "RecSupps&Reps".StudentNo := StudentNo;
             "RecSupps&Reps".StudentName := StudentName;
             "RecSupps&Reps".Programme := Programme;
             "RecSupps&Reps".Stage := Stage;
             "RecSupps&Reps".Semester := Semester;
             "RecSupps&Reps".UnitsDone := UnitsDone;
             "RecSupps&Reps".UnitsFailed := UnitsFailed;
             "RecSupps&Reps".FinalGrade := Grade;
             "RecSupps&Reps".Insert;

        end;
    end;


    procedure GoToStudentExamsII(var StudentNo: Code[150];var Unit: Code[150]) Result: Decimal
    begin
        Result := 0.0;
        "%FINAL" := 0.0;
        RecStudExams2.Reset;
        RecStudExams2.SetFilter(RecStudExams2."Student No.",StudentNo);
        RecStudExams2.SetFilter(RecStudExams2.Unit,Unit);
        if RecStudExams2.Find('-') then
        begin
             repeat
                  RecExams.Reset;
                  RecExams.SetFilter(RecExams.Code,RecStudExams2."Exam Code");
                  if RecExams.Find('-') then
                  begin
                       "%FIRST" := 0;
                       "%SECND" := 0;
                       "%FIRST" := ROUND(((RecStudExams2.Result)/(RecExams."Max.Score"))*100,1,'=');
                       "%SECND" := ROUND((((RecExams."Contribution %")/100)*("%FIRST")),1,'=');
                       "%FINAL" := "%FINAL" + "%SECND";
                        Result := "%FINAL";
                 end
                 until (RecStudExams2.Next = 0);


        end
        else
        begin
             "%FINAL" := 0.0;
             Result := "%FINAL";
        end;
    end;


    procedure GetStudentGrade(var "Average": Integer) Grade: Text[120]
    begin
                 begin
                      RecExamGrades.Reset;
                      RecExamGrades.SetCurrentkey(RecExamGrades.Upto);
                      RecExamGrades.SetFilter(RecExamGrades.ExamCode,'DEFAULT');
                      if RecExamGrades.Find('-') then
                       begin
                            repeat
                                 if Average < RecExamGrades.Upto then
                                 begin
                                  Grade := RecExamGrades.Grade;
                                 exit;
                                 end;
                            until RecExamGrades.Next = 0;
                       end
                end
    end;
}

