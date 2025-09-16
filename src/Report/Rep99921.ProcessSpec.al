#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99921 "Process Spec"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(spec;UnknownTable78003)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(AcaSpecialExamsDetails);
                AcaSpecialExamsDetails.Reset;
                AcaSpecialExamsDetails.SetRange("Student No.",spec."Student No.");
                AcaSpecialExamsDetails.SetRange("Unit Code",spec.Unit);
                AcaSpecialExamsDetails.SetRange("Academic Year",spec."Academic Year");
                AcaSpecialExamsDetails.SetRange(Programme,spec.Programme);
                if AcaSpecialExamsDetails.Find('-') then begin
                  end else begin
                    AcaSpecialExamsDetails.Init;
                    AcaSpecialExamsDetails."Student No.":=spec."Student No.";
                    AcaSpecialExamsDetails.Stage:=spec.Stage;
                    AcaSpecialExamsDetails."Unit Code":=spec.Unit;
                    AcaSpecialExamsDetails."Academic Year":=spec."Academic Year";
                    AcaSpecialExamsDetails.Semester:=spec.Semester;
                    AcaSpecialExamsDetails.Programme:=spec.Programme;
                    AcaSpecialExamsDetails."Exam Marks":=spec.Score;
                    AcaSpecialExamsDetails.Category:=spec.Catogory;
                    AcaSpecialExamsDetails.Insert;
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
        AcaSpecialExamsDetails: Record UnknownRecord78002;
}

