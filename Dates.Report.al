#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51750 Dates
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Dates.rdlc';

    dataset
    {
        dataitem(Date;Date)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(Type;Date."Period Type")
            {
            }
            column(Start;Date."Period Start")
            {
            }
            column("End";Date."Period End")
            {
            }
            column(Period_No;Date."Period No.")
            {
            }
            column(PerName;Date."Period Name")
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

