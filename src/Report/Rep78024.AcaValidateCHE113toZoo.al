#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78024 "Aca-Validate CHE 113 to Zoo"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(ACAStdUnits;UnknownTable61549)
        {
            DataItemTableView = where(Stage=filter(Y1S1),Unit=filter("CHE 113"),Programme=filter(P106),"Academic Year"=filter("2017/2018"));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ACAStdUnits.CalcFields("Total Score");
                if ACAStdUnits."Total Score" =0 then begin ACAStdUnits.Delete;
                  CurrReport.Skip;
                  end;
                ACAStudentUnits.Reset;
                ACAStudentUnits.SetRange(Unit,'ZOO 110');
                ACAStudentUnits.SetRange(Stage,ACAStdUnits.Stage);
                ACAStudentUnits.SetRange("Student No.",ACAStdUnits."Student No.");
                if ACAStudentUnits.Find('-') then begin
                  ACAStudentUnits.Delete;
                  ACAExamResults.Reset;
                  ACAExamResults.SetRange(Unit,'ZOO 110');
                  ACAExamResults.SetRange(Stage,ACAStdUnits.Stage);
                  ACAExamResults.SetRange("Student No.",ACAStdUnits."Student No.");
                  if ACAExamResults.Find('-') then ACAExamResults.DeleteAll;
                 //Rename to CHE 111
                 ACAStdUnits.Rename(ACAStdUnits.Programme,ACAStdUnits.Stage,'ZOO 110',ACAStdUnits.Semester,
                 ACAStdUnits."Reg. Transacton ID",ACAStdUnits."Student No.",ACAStdUnits.ENo,ACAStdUnits."Academic Year");
                 //--- Rename Exam Results
                 ACAExamResults.Reset;
                  ACAExamResults.SetRange(Unit,'CHE 113');
                  ACAExamResults.SetRange(Stage,ACAStdUnits.Stage);
                  ACAExamResults.SetRange("Student No.",ACAStdUnits."Student No.");
                  if ACAExamResults.Find('-') then begin
                    repeat
                      begin
                    ACAExamResults.Rename(ACAExamResults."Student No.",ACAExamResults.Programme,
                    ACAExamResults.Stage,'ZOO 110',
                    ACAExamResults.Semester,ACAExamResults.ExamType,
                    ACAExamResults."Reg. Transaction ID",ACAExamResults."Entry No");
                    end;
                    until ACAExamResults.Next=0;
                    end;
                  end else begin

                  ACAExamResults.Reset;
                  ACAExamResults.SetRange(Unit,'ZOO 110');
                  ACAExamResults.SetRange(Stage,ACAStdUnits.Stage);
                  ACAExamResults.SetRange("Student No.",ACAStdUnits."Student No.");
                  if ACAExamResults.Find('-') then ACAExamResults.DeleteAll;
                    //Rename to CHE 111
                 ACAStdUnits.Rename(ACAStdUnits.Programme,ACAStdUnits.Stage,'ZOO 110',ACAStdUnits.Semester,
                 ACAStdUnits."Reg. Transacton ID",ACAStdUnits."Student No.",ACAStdUnits.ENo,ACAStdUnits."Academic Year");
                 //--- Rename Exam Results
                 ACAExamResults.Reset;
                  ACAExamResults.SetRange(Unit,'CHE 113');
                  ACAExamResults.SetRange(Stage,ACAStdUnits.Stage);
                  ACAExamResults.SetRange("Student No.",ACAStdUnits."Student No.");
                  if ACAExamResults.Find('-') then begin
                    repeat
                      begin
                    ACAExamResults.Rename(ACAExamResults."Student No.",ACAExamResults.Programme,
                    ACAExamResults.Stage,'ZOO 110',
                    ACAExamResults.Semester,ACAExamResults.ExamType,
                    ACAExamResults."Reg. Transaction ID",ACAExamResults."Entry No");
                    end;
                    until ACAExamResults.Next=0;
                    end;
                    end;
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

