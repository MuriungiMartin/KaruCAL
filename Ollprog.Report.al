#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51063 "Oll prog"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Oll prog.rdlc';

    dataset
    {
        dataitem(UnknownTable61012;UnknownTable61012)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   "ACA-Old Programmes".CalcFields("New Code FK" );
                   "ACA-Old Programmes"."New Code":="ACA-Old Programmes"."New Code FK";
                    "ACA-Old Programmes".Modify;
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

