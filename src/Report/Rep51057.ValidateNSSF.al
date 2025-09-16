#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51057 "Validate NSSF"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Validate NSSF.rdlc';

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
                      Salary.SetRange(Salary."No.","PRL-Salary Card"."Employee Code");
                      if Salary.Find ('-') then begin
                      if Salary."NSSF No."<>'' then begin
                      "PRL-Salary Card"."Pays NSSF":=true;
                      "PRL-Salary Card".Modify(true);
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
        Salary: Record UnknownRecord61118;
}

