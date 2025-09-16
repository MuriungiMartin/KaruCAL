#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50060 "Inactive Employees Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Inactive Employees Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(PF;"HRM-Employee C"."No.")
            {
            }
            column(FirstName;"HRM-Employee C"."First Name")
            {
            }
            column(LastName;"HRM-Employee C"."Last Name")
            {
            }
            column(Department;"HRM-Employee C"."Department Name")
            {
            }
            column(DateOfJoining;"HRM-Employee C"."Date Of Join")
            {
            }
            column(DateofLeaving;"HRM-Employee C"."Date Of Leaving")
            {
            }
            column(Status;"HRM-Employee C".Status)
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

