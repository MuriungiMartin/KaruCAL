#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78090 "Proc. Household Qualification"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Proc. Household Qualification.rdlc';
    ProcessingOnly = false;

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = "Academic Year",Semester,Stage,"Student No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            dataitem(Customer;Customer)
            {
                DataItemLink = "No."=field("Student No.");
                DataItemTableView = where("Customer Type"=const(Student));
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
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

    var
        FundBandEntries: Record "Funding Band Entries";
}

