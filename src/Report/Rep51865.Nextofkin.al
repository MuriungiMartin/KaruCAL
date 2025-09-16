#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51865 Nextofkin
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Nextofkin.rdlc';

    dataset
    {
        dataitem(UnknownTable61323;UnknownTable61323)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Names;"HRM-Employee Kin"."Other Names")
            {
            }
            column(Surname;"HRM-Employee Kin".SurName)
            {
            }
            column(Employeekin;"HRM-Employee Kin"."Employee Code")
            {
            }
            column(Relationship;"HRM-Employee Kin".Relationship)
            {
            }
            column(DOB;"HRM-Employee Kin"."Date Of Birth")
            {
            }
            column(No;"HRM-Employee Kin"."No.")
            {
            }
            column(HomeTel;"HRM-Employee Kin"."Home Tel No")
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

