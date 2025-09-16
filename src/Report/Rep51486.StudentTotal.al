#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51486 "Student Total"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Total.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            column(ReportForNavId_6836; 6836)
            {
            }
            column(Customer_Customer__Programme_Filter_;Customer."Programme Filter")
            {
            }
            column(Customer_No_;"No.")
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

