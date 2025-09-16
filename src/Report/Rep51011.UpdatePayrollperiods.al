#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51011 "Update Payroll periods"
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
                    PRPER.Reset;
                    PRPER.SetRange(PRPER."Period Year","PRL-Salary Card"."Current Year");
                    PRPER.SetRange(PRPER."Period Month","PRL-Salary Card"."Current Month");
                    if PRPER.Find('-') then begin
                      "PRL-Salary Card"."Payroll Period":=PRPER."Date Opened";
                      "PRL-Salary Card"."Period Month":=PRPER."Period Month";
                      "PRL-Salary Card"."Period Year":=PRPER."Period Year";
                      "PRL-Salary Card".Modify;
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
        PRPER: Record UnknownRecord61081;
}

