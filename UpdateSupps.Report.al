#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78063 "Update Supps"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Supps.rdlc';

    dataset
    {
        dataitem(Results;UnknownTable78003)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ACAStudentUnits);
                ACAStudentUnits.Reset;
                ACAStudentUnits.SetRange("Student No.",Results."Student No.");
                ACAStudentUnits.SetRange(Unit,Results.Unit);
                ACAStudentUnits.SetRange("Reg. Reversed",false);
                if ACAStudentUnits.Find('-') then;



                Clear(AcaSpecialExamsDetails);
                AcaSpecialExamsDetails.Reset;
                AcaSpecialExamsDetails.SetRange("Student No.",Results."Student No.");
                AcaSpecialExamsDetails.SetRange("Unit Code",Results.Unit);
                if AcaSpecialExamsDetails.Find('-') then begin
                    AcaSpecialExamsDetails."Exam Marks":=Results.Score;
                    AcaSpecialExamsDetails."Total Marks":=Results.Score;
                    AcaSpecialExamsDetails.Modify(true);
                  end else begin
                    AcaSpecialExamsDetails.Init;
                    AcaSpecialExamsDetails."Academic Year":=ACAStudentUnits."Academic Year";
                    AcaSpecialExamsDetails."Student No.":=Results."Student No.";
                    AcaSpecialExamsDetails."Unit Code":=Results.Unit;
                    AcaSpecialExamsDetails."Academic Year":=ACAStudentUnits."Academic Year";
                    AcaSpecialExamsDetails."Current Academic Year":=ACAStudentUnits."Academic Year";
                    AcaSpecialExamsDetails.Programme:=ACAStudentUnits.Programme;
                    AcaSpecialExamsDetails."Exam Marks":=Results.Score;
                    AcaSpecialExamsDetails."Total Marks":=Results.Score;
                    AcaSpecialExamsDetails.Semester:=ACAStudentUnits.Semester;
                    AcaSpecialExamsDetails.Insert(true);
                    end;
            end;
        }
        dataitem(secondSuppRes;UnknownTable78032)
        {
            column(ReportForNavId_1000000001; 1000000001)
            {
            }

            trigger OnAfterGetRecord()
            begin

                Clear(ACAStudentUnits);
                ACAStudentUnits.Reset;
                ACAStudentUnits.SetRange("Student No.",secondSuppRes."Student No.");
                ACAStudentUnits.SetRange(Unit,secondSuppRes.Unit);
                ACAStudentUnits.SetRange("Reg. Reversed",false);
                if ACAStudentUnits.Find('-') then;



                Clear(Aca2ndSuppExamsDetails);
                Aca2ndSuppExamsDetails.Reset;
                Aca2ndSuppExamsDetails.SetRange("Student No.",secondSuppRes."Student No.");
                Aca2ndSuppExamsDetails.SetRange("Unit Code",secondSuppRes.Unit);
                if Aca2ndSuppExamsDetails.Find('-') then begin
                    Aca2ndSuppExamsDetails."Exam Marks":=secondSuppRes.Score;
                    Aca2ndSuppExamsDetails."Total Marks":=secondSuppRes.Score;
                    Aca2ndSuppExamsDetails.Modify(true);
                  end else begin
                    Aca2ndSuppExamsDetails.Init;
                    Aca2ndSuppExamsDetails."Academic Year":=ACAStudentUnits."Academic Year";
                    Aca2ndSuppExamsDetails."Student No.":=secondSuppRes."Student No.";
                    Aca2ndSuppExamsDetails."Unit Code":=secondSuppRes.Unit;
                    Aca2ndSuppExamsDetails."Academic Year":=ACAStudentUnits."Academic Year";
                    Aca2ndSuppExamsDetails."Current Academic Year":=ACAStudentUnits."Academic Year";
                    Aca2ndSuppExamsDetails.Programme:=ACAStudentUnits.Programme;
                    Aca2ndSuppExamsDetails."Exam Marks":=secondSuppRes.Score;
                    Aca2ndSuppExamsDetails."Total Marks":=secondSuppRes.Score;
                    Aca2ndSuppExamsDetails.Semester:=ACAStudentUnits.Semester;
                    Aca2ndSuppExamsDetails.Insert(true);
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
        Aca2ndSuppExamsDetails: Record UnknownRecord78031;
        ACAStudentUnits: Record UnknownRecord61549;
}

