#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70072 "Sync. Student Units"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable70073;UnknownTable70073)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ACAStudentUnits.Reset;
                ACAStudentUnits.SetRange(ACAStudentUnits.Programme,"Std Units Buffer".Prog);
                ACAStudentUnits.SetRange(ACAStudentUnits.Stage,"Std Units Buffer".Stage);
                ACAStudentUnits.SetRange(ACAStudentUnits.Unit,"Std Units Buffer".Unit);
                ACAStudentUnits.SetRange(ACAStudentUnits.Semester,"Std Units Buffer".Semester);
                ACAStudentUnits.SetRange(ACAStudentUnits."Reg. Transacton ID","Std Units Buffer"."Reg. Trans. Id");
                ACAStudentUnits.SetRange(ACAStudentUnits."Student No.","Std Units Buffer"."Stud. No");
                ACAStudentUnits.SetRange(ACAStudentUnits.ENo,"Std Units Buffer".ENO);
                ACAStudentUnits.SetRange(ACAStudentUnits."Academic Year","Std Units Buffer"."Academic Year");
                if ACAStudentUnits.Find('-') then begin
                ACAStudentUnits.Remarks:="Std Units Buffer".Remarks;
                ACAStudentUnits.Status:="Std Units Buffer".Status;
                ACAStudentUnits.Description:="Std Units Buffer".Description;
                ACAStudentUnits.Modify;
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

