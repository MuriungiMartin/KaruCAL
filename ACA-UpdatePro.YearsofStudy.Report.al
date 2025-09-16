#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78079 "ACA-Update Pro. Years of Study"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Update Pro. Years of Study.rdlc';

    dataset
    {
        dataitem(Progs;UnknownTable61516)
        {
            DataItemTableView = where(Code=filter(Y1S1));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Progs.Validate(Code);
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

