#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78072 "Clear Prog. Options"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Clear Prog. Options.rdlc';

    dataset
    {
        dataitem(AcaCoregcs;UnknownTable61532)
        {
            RequestFilterFields = Programme,"Academic Year",Stage,Semester;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if AcaCoregcs.Options <> '' then begin
                  AcaCoregcs.Options := '';
                  AcaCoregcs.Modify;
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

    trigger OnPreReport()
    begin
        if AcaCoregcs.GetFilter(Programme) = '' then Error('Specify Program(s)');
        if AcaCoregcs.GetFilter(Stage) = '' then Error('Specify Stage(s)');
    end;
}

