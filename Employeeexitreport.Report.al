#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51864 "Employee exit report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee exit report.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(EmployeeNo;o."No.")
            {
            }
            column(FirstName;o."First Name")
            {
            }
            column(LastName;o."Last Name")
            {
            }
            column(JobTitle;o."Job Title")
            {
            }
            column(EmployementDate;o."Employment Date")
            {
            }
            column(Date;o."Date Filter")
            {
            }
            column(Status;o.Status)
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

