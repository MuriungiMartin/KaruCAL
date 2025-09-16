#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51824 "PRL-Update Basic Pay"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61105;UnknownTable61105)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                  /*proc.OPEN('#1#############################');
                   "Employe Buff".RESET;
                  "Employe Buff".SETRANGE("Employe Buff"."Employee No.","prSalary Card"."Employee Code");
                  "Employe Buff".SETRANGE("Employe Buff"."Transaction Name",'BASIC SALARY');
                  IF NOT ("Employe Buff".FIND('-')) THEN BEGIN
                  // Nobasic Salary
                  IF HrEmployee.GET("prSalary Card"."Employee Code") THEN BEGIN
                   proc.UPDATE(1,HrEmployee."First Name"+' '+HrEmployee."Middle Name"+' '+HrEmployee."Last Name");
                   SLEEP(200);
                 // HrEmployee.Status:=HrEmployee.Status::Resigned;
                 // HrEmployee.MODIFY;
                   END;
                  END;
                   proc.CLOSE;   */
                   "PRL-Salary Card"."Basic Pay":=0;
                   "PRL-Salary Card".Modify;

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
        "Employe Buff": Record UnknownRecord61751;
        HrEmployee: Record UnknownRecord61118;
        proc: Dialog;
}

