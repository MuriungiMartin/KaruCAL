#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51665 "Academic Transcript"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Academic Transcript.rdlc';

    dataset
    {
        dataitem(UnknownTable61576;UnknownTable61576)
        {
            RequestFilterFields = Programme,Stage,Semester;
            column(ReportForNavId_7076; 7076)
            {
            }
            column(Student_Exam_Registration_Unit_Faculty;Faculty)
            {
            }
            column(Student_Exam_Registration_Unit__Student_No__;"Student No.")
            {
            }
            column(Student_Exam_Registration_Unit__Student_Name_;"Student Name")
            {
            }
            column(Student_Exam_Registration_Unit_Semester;Semester)
            {
            }
            column(Student_Exam_Registration_Unit_Stage;Stage)
            {
            }
            column(Student_Exam_Registration_Unit_Programme;Programme)
            {
            }
            column(Department;Department)
            {
            }
            column(Student_Exam_Registration_Unit_Unit;Unit)
            {
            }
            column(UnitDesc;UnitDesc)
            {
            }
            column(FINAL_;"%FINAL")
            {
            }
            column(ThisGrade;ThisGrade)
            {
            }
            column(ThisAverage;ThisAverage)
            {
            }
            column(ThisAverageGrade;ThisAverageGrade)
            {
            }
            column(ExamRemark;ExamRemark)
            {
            }
            column(Department_Caption;Department_CaptionLbl)
            {
            }
            column(Faculty_Caption;Faculty_CaptionLbl)
            {
            }
            column(Admission_Number_Caption;Admission_Number_CaptionLbl)
            {
            }
            column(Name_of_Student__Caption;Name_of_Student__CaptionLbl)
            {
            }
            column(ACADEMIC_TRANSCRIPTCaption;ACADEMIC_TRANSCRIPTCaptionLbl)
            {
            }
            column(Course_Caption;Course_CaptionLbl)
            {
            }
            column(Mode_of_Study_Caption;Mode_of_Study_CaptionLbl)
            {
            }
            column(Academic_YearCaption;Academic_YearCaptionLbl)
            {
            }
            column(Unit_CodeCaption;Unit_CodeCaptionLbl)
            {
            }
            column(Unit_CodeCaption_Control1000000021;Unit_CodeCaption_Control1000000021Lbl)
            {
            }
            column(Marks__Caption;Marks__CaptionLbl)
            {
            }
            column(GradeCaption;GradeCaptionLbl)
            {
            }
            column(Average_Mark_Caption;Average_Mark_CaptionLbl)
            {
            }
            column(Classification_of_Diploma_CertificateCaption;Classification_of_Diploma_CertificateCaptionLbl)
            {
            }
            column(Remark_on_Status_Caption;Remark_on_Status_CaptionLbl)
            {
            }
            column(Key_to_Grading_System_Caption;Key_to_Grading_System_CaptionLbl)
            {
            }
            column(MarksCaption;MarksCaptionLbl)
            {
            }
            column(ClassCaption;ClassCaptionLbl)
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
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(Pass_after_sitting_supplementaryCaption;Pass_after_sitting_supplementaryCaptionLbl)
            {
            }
            column(Signed_Caption;Signed_CaptionLbl)
            {
            }
            column(Dean_Caption;Dean_CaptionLbl)
            {
            }
            column(Date_Caption;Date_CaptionLbl)
            {
            }
            column(Date_Caption_Control1000000056;Date_Caption_Control1000000056Lbl)
            {
            }
            column(Principal_Caption;Principal_CaptionLbl)
            {
            }
            column(This_transcript_has_been_issued_without_any_alterationsCaption;This_transcript_has_been_issued_without_any_alterationsCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                GetUnitDesc("ACA-Std Exam Registration/Unit".Unit);
                CalculateFinalScore("ACA-Std Exam Registration/Unit"."Student No.","ACA-Std Exam Registration/Unit".Unit);
                GoToStudentUnits("ACA-Std Exam Registration/Unit"."Student No.");
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
        Department: Text[120];
        UnitDesc: Text[120];
        Marks: Decimal;
        Grade: Text[50];
        RecUnits: Record UnknownRecord61517;
        RecExamsRes: Record UnknownRecord61572;
        RecExams: Record UnknownRecord61526;
        "%FIRST": Decimal;
        "%SECND": Decimal;
        "%FINAL": Decimal;
        RecExamGrades: Record UnknownRecord61575;
        ThisGrade: Text[30];
        "Average": Decimal;
        TOTAL: Decimal;
        ThisAverage: Decimal;
        ExamRemark: Text[50];
        Classification: Text[50];
        ThisAverageGrade: Text[30];
        StageGrade: Text[30];
        FailCount: Decimal;
        RecStudUnits: Record UnknownRecord61549;
        UnitCount: Integer;
        Programme: Text[50];
        Stage: Text[50];
        Semester: Text[50];
        Department_CaptionLbl: label 'Department:';
        Faculty_CaptionLbl: label 'Faculty:';
        Admission_Number_CaptionLbl: label 'Admission Number:';
        Name_of_Student__CaptionLbl: label 'Name of Student: ';
        ACADEMIC_TRANSCRIPTCaptionLbl: label 'ACADEMIC TRANSCRIPT';
        Course_CaptionLbl: label 'Course:';
        Mode_of_Study_CaptionLbl: label 'Mode of Study:';
        Academic_YearCaptionLbl: label 'Academic Year';
        Unit_CodeCaptionLbl: label 'Unit Code';
        Unit_CodeCaption_Control1000000021Lbl: label 'Unit Code';
        Marks__CaptionLbl: label 'Marks %';
        GradeCaptionLbl: label 'Grade';
        Average_Mark_CaptionLbl: label 'Average Mark:';
        Classification_of_Diploma_CertificateCaptionLbl: label 'Classification of Diploma/Certificate';
        Remark_on_Status_CaptionLbl: label 'Remark on Status:';
        Key_to_Grading_System_CaptionLbl: label 'Key to Grading System:';
        MarksCaptionLbl: label 'Marks';
        ClassCaptionLbl: label 'Class';
        V75____100_CaptionLbl: label '75% - 100%';
        V65____74_CaptionLbl: label '65% - 74%';
        V50____64_CaptionLbl: label '50% - 64%';
        V49__and_BelowCaptionLbl: label '49% and Below';
        FailCaptionLbl: label 'Fail';
        DistinctionCaptionLbl: label 'Distinction';
        CreditCaptionLbl: label 'Credit';
        PassCaptionLbl: label 'Pass';
        EmptyStringCaptionLbl: label '*';
        Pass_after_sitting_supplementaryCaptionLbl: label 'Pass after sitting supplementary';
        Signed_CaptionLbl: label 'Signed:';
        Dean_CaptionLbl: label 'Dean:';
        Date_CaptionLbl: label 'Date:';
        Date_Caption_Control1000000056Lbl: label 'Date:';
        Principal_CaptionLbl: label 'Principal:';
        This_transcript_has_been_issued_without_any_alterationsCaptionLbl: label 'This transcript has been issued without any alterations';


    procedure GetUnitDesc(var Unit: Code[100])
    begin
        RecUnits.Reset;
        RecUnits.SetFilter(RecUnits.Code,Unit);
        if RecUnits.Find('-')  then
        begin
             UnitDesc := RecUnits.Desription;
        end
    end;


    procedure CalculateFinalScore(var StudentNo: Code[150];var Unit: Code[150]) FinalScore: Decimal
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
                       if RecExamsRes."New Score" <> 0.0 then
                       begin
                       "%FIRST" := ((RecExamsRes."New Score")/(RecExams."Max.Score"))*100;
                       end
                       else
                       begin
                        "%FIRST" := ((RecExamsRes.Result)/(RecExams."Max.Score"))*100;
                       end;
                       "%SECND" := (((RecExams."Contribution %")/100)*("%FIRST"));
                       "%FINAL" := "%FINAL" + "%SECND";
                  end;
             until (RecExamsRes.Next = 0);

        end;
        GetGrade("%FINAL",RecExamsRes."Exam Code");
        TOTAL := TOTAL + "%FINAL";
        GetAverage(TOTAL);
    end;


    procedure GetGrade(var FinalScore: Decimal;var Exam: Code[130]) Grade: Text[100]
    begin
        /*
        RecExams.RESET;
        RecExams.SETFILTER(RecExams.Code,Exam);
        IF RecExams.FIND('-') THEN
        BEGIN
             IF RecExams."Grading System" = 1 THEN
        */
                 begin
                  RecExamGrades.Reset;
                  RecExamGrades.SetCurrentkey(RecExamGrades.Upto);
                  //RecExamGrades.ASCENDING(FALSE);
                  RecExamGrades.SetFilter(RecExamGrades.ExamCode,'DEFAULT');
                  if RecExamGrades.Find('-') then
                  begin
                       repeat
                       if FinalScore < RecExamGrades.Upto then
                       begin
                            ThisGrade := RecExamGrades.Grade;
                            exit;
                       end;
                       until RecExamGrades.Next = 0;
                  end
             end
        /*
             ELSE
             BEGIN
                  RecExamGrades.RESET;
                  RecExamGrades.SETFILTER(RecExamGrades.ExamCode,Exam);
                  IF RecExamGrades.FIND('-') THEN
                  BEGIN
                       REPEAT
                       IF FinalScore < RecExamGrades.Upto THEN
                       ThisGrade := RecExamGrades.Grade
                       UNTIL RecExamGrades.NEXT = 0;
                  END
        
             END;
        
        END
        */

    end;


    procedure GetAverage(var Score: Decimal) "Average": Decimal
    begin
        if TOTAL <> 0 then
        begin
        "ACA-Std Exam Registration/Unit".CalcFields("ACA-Std Exam Registration/Unit".UnitCount);
        ThisAverage := (TOTAL/"ACA-Std Exam Registration/Unit".UnitCount);
        GetAverageGrade(ThisAverage);
        end;
    end;


    procedure GetAverageGrade(var "Average": Decimal) Grade: Text[100]
    begin
             begin
                  RecExamGrades.Reset;
                  RecExamGrades.SetCurrentkey(RecExamGrades.Upto);
                  //RecExamGrades.ASCENDING(FALSE);
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

        StageGrade := '';
        FailCount := 0.0;
        //"%FINAL" := 0.00;
        RecStudUnits.Reset;
        RecStudUnits.SetRange(RecStudUnits."Student No.","StudentNo.");
        if RecStudUnits.Find('-') then
        RecStudUnits.CalcFields(RecStudUnits.UnitCount);
        UnitCount := RecStudUnits.UnitCount;
        Programme := RecStudUnits.Programme;
        Stage := RecStudUnits.Stage;
        Semester := RecStudUnits.Semester;

        begin
             repeat
                   if GoToStudentExams("StudentNo.",RecStudUnits.Unit) = 'FAIL' then
                   begin
                        FailCount := FailCount + 1;
                   end;
             until (RecStudUnits.Next = 0);
        end;
        if(FailCount = 0) then
        begin
             ExamRemark := 'PROCEED';
        end;
        if (FailCount > 0) and (FailCount <= (RecStudUnits.UnitCount)/2) then
        begin
             ExamRemark := 'DEFERRED';
        end;
        if (FailCount > 0) and  (FailCount >= (RecStudUnits.UnitCount)/2) then
        begin
             ExamRemark := 'REPEAT';
        end;
    end;


    procedure GoToStudentExams(var StudentNo: Code[150];var Unit: Code[150]) UnitGrade: Text[50]
    begin
        /*
        RecExamsRes.RESET;
        RecExamsRes.SETFILTER(RecExamsRes."Student No.",StudentNo);
        RecExamsRes.SETFILTER(RecExamsRes.Unit,Unit);
        IF RecExamsRes.FIND('-') THEN
        BEGIN
             REPEAT
                  RecExams.RESET;
                  RecExams.SETFILTER(RecExams.Code,RecExamsRes."Exam Code");
                  IF RecExams.FIND('-') THEN
                  BEGIN
                       "%FIRST" := 0;
                       "%SECND" := 0;
                       "%FIRST" := ((RecExamsRes.Result)/(RecExams."Max.Score"))*100;
                       "%SECND" := (((RecExams."Contribution %")/100)*("%FIRST"));
                       "%FINAL" := "%FINAL" + "%SECND";
        
                 END
                 UNTIL (RecExamsRes.NEXT = 0);
        
        
        END
        ELSE
        BEGIN
             "%FINAL" := 0.00;
        END;
        */
                 begin
                      RecExamGrades.Reset;
                      RecExamGrades.SetCurrentkey(RecExamGrades.Upto);
                      //RecExamGrades.ASCENDING(FALSE);
                      RecExamGrades.SetFilter(RecExamGrades.ExamCode,'DEFAULT');
                      if RecExamGrades.Find('-') then
                       begin
                            repeat
                                 if "%FINAL" < RecExamGrades.Upto then
                                 begin
                                  ThisGrade := RecExamGrades.Remark;
                                  UnitGrade := ThisGrade;
                                  exit;
                                 end;
                            until RecExamGrades.Next = 0;
                       end
                end;

    end;
}

