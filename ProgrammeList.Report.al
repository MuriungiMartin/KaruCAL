#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51016 "Programme List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Programme List.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Schl;"ACA-Programme"."School Code")
            {
            }
            column("code";"ACA-Programme".Code)
            {
            }
            column(Description;"ACA-Programme".Description)
            {
            }
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

