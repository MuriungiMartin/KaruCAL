#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51049 "Pays PAYE"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Pays PAYE.rdlc';

    dataset
    {
        dataitem(UnknownTable61105;UnknownTable61105)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   Salary.Reset;
                   Salary.SetRange(Salary."Employee Code","PRL-Salary Card"."Employee Code");
                   if Salary.Find ('-') then begin
                   Salary."Pays PAYE":=true;
                   Salary.Modify(true);
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
        Salary: Record UnknownRecord61105;
}

