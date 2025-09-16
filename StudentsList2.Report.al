#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51147 "Students List2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Students List2.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            RequestFilterFields = "Settlement Type Filter";
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(No;Customer."No.")
            {
            }
            column(Name;Customer.Name)
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

