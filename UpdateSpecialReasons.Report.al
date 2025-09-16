#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77125 "Update Special Reasons"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Special Reasons.rdlc';
    UsageCategory = Lists;

    dataset
    {
        dataitem(Spec;UnknownTable78002)
        {
            DataItemTableView = where("Special Exam Reason"=filter(""));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ACAStudentUnits);
                ACAStudentUnits.Reset;
                ACAStudentUnits.SetRange("Student No.",Spec."Student No.");
                ACAStudentUnits.SetRange("Reg. Reversed",false);
                ACAStudentUnits.SetRange(Unit,Spec."Unit Code");
                if ACAStudentUnits.Find('-') then begin
                  if ACAStudentUnits."Reason for Special Exam/Susp." <> '' then begin
                Spec."Special Exam Reason" := ACAStudentUnits."Reason for Special Exam/Susp.";
                Spec.Modify;
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
}

