#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51060 "Generate CREG"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61014;UnknownTable61014)
        {
            RequestFilterFields = Prog,"Code";
            column(ReportForNavId_1; 1)
            {
            }
            column(Code_TempStudProg;"ACA-Temp Stud Prog".Code)
            {
            }
            column(Prog_TempStudProg;"ACA-Temp Stud Prog".Prog)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   if OldProg.Get("ACA-Temp Stud Prog".Prog) then begin
                   OldProg.CalcFields(OldProg."New Code FK");
                   if TempStage.Get("ACA-Temp Stud Prog".Prog) then begin
                   Creg.Init;
                   Creg."Reg. Transacton ID":='A0001';
                   Creg."Student No.":="ACA-Temp Stud Prog".Code;
                   Creg.Programme:=OldProg."New Code";
                   Creg.Semester:='SEM1 15/16';
                   Creg.Stage:=TempStage.Stage;
                   Creg."Settlement Type":='SSP';
                   Creg."Registration Date":=Today;
                   Creg.Remarks:=TempStage.Remarks;
                   Creg."General Remark":=TempStage.Remarks;
                   Creg.Insert;
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
        Creg: Record UnknownRecord61532;
        OldProg: Record UnknownRecord61012;
        TempStage: Record UnknownRecord61013;
}

