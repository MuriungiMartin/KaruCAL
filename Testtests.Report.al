#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 344 "Test tests"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Test tests.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Name_Customer;Customer.Name)
            {
            }
            column(No_Customer;Customer."No.")
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

