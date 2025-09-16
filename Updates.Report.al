#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 90021 Updates
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Updates.rdlc';

    dataset
    {
        dataitem(hr;UnknownTable61118)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if CopyStr(hr."No.",1,2) = 'PT' then begin
                  hr."PT Category":=hr."pt category"::PT;
                  hr.Modify;
                  end else begin
                  hr."PT Category":=hr."pt category"::" ";
                  hr.Modify;
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
}

