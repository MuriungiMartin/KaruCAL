#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51823 "HRM-Flash Emp. Salary Card"
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
                        "PRL-Salary Card"."Pays NSSF":=false;
                        "PRL-Salary Card"."Pays NHIF":=false;
                        "PRL-Salary Card"."Pays PAYE":=false;
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
}

