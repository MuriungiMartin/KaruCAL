#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65810 "Rectify tt"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = where(Number=filter(1));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ACAStudentUnits.Reset;
                ACAStudentUnits.SetFilter(Programme,'<>%1','');
                if ACAStudentUnits.Find('-') then begin
                  repeat
                ACACourseRegistration.Reset;
                ACACourseRegistration.SetRange(Semester,ACAStudentUnits.Semester);
                ACACourseRegistration.SetRange("Student No.",ACAStudentUnits."Student No.");
                if ACACourseRegistration.Find('-') then begin
                //ACAStudentUnits."Academic Year":=ACACourseRegistration."Academic Year";
                  with ACAStudentUnits do
                    begin
                ACAStudentUnits.Rename(Programme,Stage,Unit,Semester,"Reg. Transacton ID","Student No.",ENo,ACACourseRegistration."Academic Year");
                      end;
                end;
                    until ACAStudentUnits.Next=0;
                  end;

                ACAExamResults.Reset;
                if ACAExamResults.Find('-') then  begin
                  repeat
                    ACACourseRegistration.Reset;
                ACACourseRegistration.SetRange(Semester,ACAExamResults.Semester);
                ACACourseRegistration.SetRange("Student No.",ACAExamResults."Student No.");
                if ACACourseRegistration.Find('-') then begin
                ACAExamResults."Academic Year":=ACACourseRegistration."Academic Year";
                ACAExamResults.Modify;
                end;
                    until ACAExamResults.Next=0;
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
        ACAStudentUnits22: Record UnknownRecord65810;
        ACACourseRegistration: Record UnknownRecord61532;
        ACAExamResults: Record UnknownRecord61548;
}

