#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78025 "Aca-Validate BBM 415"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(ACAStdUnits;UnknownTable61549)
        {
            DataItemTableView = where("Year Of Study"=filter(2),Unit=filter("BBM 415"),Programme=filter(B100),"Academic Year"=filter("2017/2018"));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                /*ACAStdUnits.CALCFIELDS("Total Score");
                IF ACAStdUnits."Total Score" =0 THEN BEGIN ACAStdUnits.DELETE;
                  CurrReport.SKIP;
                  END;
                ACAStudentUnits.RESET;
                ACAStudentUnits.SETRANGE(Unit,'ZOO 110');
                ACAStudentUnits.SETRANGE(Stage,ACAStdUnits.Stage);
                ACAStudentUnits.SETRANGE("Student No.",ACAStdUnits."Student No.");
                IF ACAStudentUnits.FIND('-') THEN BEGIN
                  ACAStudentUnits.DELETE;
                  ACAExamResults.RESET;
                  ACAExamResults.SETRANGE(Unit,'ZOO 110');
                  ACAExamResults.SETRANGE(Stage,ACAStdUnits.Stage);
                  ACAExamResults.SETRANGE("Student No.",ACAStdUnits."Student No.");
                  IF ACAExamResults.FIND('-') THEN ACAExamResults.DELETEALL;
                 //Rename to CHE 111
                 ACAStdUnits.RENAME(ACAStdUnits.Programme,ACAStdUnits.Stage,'ZOO 110',ACAStdUnits.Semester,
                 ACAStdUnits."Reg. Transacton ID",ACAStdUnits."Student No.",ACAStdUnits.ENo,ACAStdUnits."Academic Year");
                 //--- Rename Exam Results
                 ACAExamResults.RESET;
                  ACAExamResults.SETRANGE(Unit,'CHE 113');
                  ACAExamResults.SETRANGE(Stage,ACAStdUnits.Stage);
                  ACAExamResults.SETRANGE("Student No.",ACAStdUnits."Student No.");
                  IF ACAExamResults.FIND('-') THEN BEGIN
                    REPEAT
                      BEGIN
                    ACAExamResults.RENAME(ACAExamResults."Student No.",ACAExamResults.Programme,
                    ACAExamResults.Stage,'ZOO 110',
                    ACAExamResults.Semester,ACAExamResults.ExamType,
                    ACAExamResults."Reg. Transaction ID",ACAExamResults."Entry No");
                    END;
                    UNTIL ACAExamResults.NEXT=0;
                    END;
                  END ELSE BEGIN
                
                  ACAExamResults.RESET;
                  ACAExamResults.SETRANGE(Unit,'ZOO 110');
                  ACAExamResults.SETRANGE(Stage,ACAStdUnits.Stage);
                  ACAExamResults.SETRANGE("Student No.",ACAStdUnits."Student No.");
                  IF ACAExamResults.FIND('-') THEN ACAExamResults.DELETEALL;
                    //Rename to CHE 111
                 ACAStdUnits.RENAME(ACAStdUnits.Programme,ACAStdUnits.Stage,'ZOO 110',ACAStdUnits.Semester,
                 ACAStdUnits."Reg. Transacton ID",ACAStdUnits."Student No.",ACAStdUnits.ENo,ACAStdUnits."Academic Year");
                 //--- Rename Exam Results
                 ACAExamResults.RESET;
                  ACAExamResults.SETRANGE(Unit,'CHE 113');
                  ACAExamResults.SETRANGE(Stage,ACAStdUnits.Stage);
                  ACAExamResults.SETRANGE("Student No.",ACAStdUnits."Student No.");
                  IF ACAExamResults.FIND('-') THEN BEGIN
                    REPEAT
                      BEGIN
                    ACAExamResults.RENAME(ACAExamResults."Student No.",ACAExamResults.Programme,
                    ACAExamResults.Stage,'ZOO 110',
                    ACAExamResults.Semester,ACAExamResults.ExamType,
                    ACAExamResults."Reg. Transaction ID",ACAExamResults."Entry No");
                    END;
                    UNTIL ACAExamResults.NEXT=0;
                    END;
                    END;
                    */
                      ACAExamResults.Reset;
                  ACAExamResults.SetRange(Unit,'BBM 415');
                  ACAExamResults.SetRange(Stage,ACAStdUnits.Stage);
                  ACAExamResults.SetRange("Student No.",ACAStdUnits."Student No.");
                  if ACAExamResults.Find('-') then ACAExamResults.DeleteAll;
                    ACAStdUnits.Delete;

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
        ACAStudentUnits: Record UnknownRecord61549;
        ACAExamResults: Record UnknownRecord61548;
}

