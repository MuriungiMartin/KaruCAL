#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78019 "Validate Custs"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(StudUnits;UnknownTable61549)
        {
            DataItemTableView = where(Semester=filter("SEM1 20/21"|"SEM2 20/21"));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            dataitem(ExamRes;UnknownTable61548)
            {
                DataItemLink = Unit=field(Unit),Semester=field(Semester),"Student No."=field("Student No.");
                column(ReportForNavId_1000000001; 1000000001)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if ExamRes.Programme<>StudUnits.Programme then begin
                     if (ExamRes.Rename(ExamRes."Student No.",StudUnits.Programme,ExamRes.Stage,ExamRes.Unit,
                     ExamRes.Semester,ExamRes.ExamType,ExamRes."Reg. Transaction ID",ExamRes."Entry No")) then;
                      end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // // Customer.VALIDATE("No.");
                // // Customer.MODIFY;
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
}

