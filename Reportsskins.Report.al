#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50067 "Reportss kins"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Reportss kins.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(FIRSTNAME;"HRM-Employee C"."First Name")
            {
            }
            column(MNAME;"HRM-Employee C"."Middle Name")
            {
            }
            column(LASTNAME;"HRM-Employee C"."Last Name")
            {
            }
            column(SEARCH;"HRM-Employee C"."Search Name")
            {
            }
            column(ADRRESS;"HRM-Employee C"."Postal Address")
            {
            }
            column(TOWN;"HRM-Employee C".City)
            {
            }
            column(PHONENUMBER;"HRM-Employee C"."Home Phone Number")
            {
            }
            column(CELLPHONE;"HRM-Employee C"."Cellular Phone Number")
            {
            }
            column(WORKPHONE;"HRM-Employee C"."Work Phone Number")
            {
            }
            column(EMAIL;"HRM-Employee C"."E-Mail")
            {
            }
            column(ID;"HRM-Employee C"."ID Number")
            {
            }
            column(STATUS;"HRM-Employee C".Status)
            {
            }
            column(DEPARTMENT;"HRM-Employee C"."Department Code")
            {
            }
            column(DATEOFBIRTH;"HRM-Employee C"."Date Of Birth")
            {
            }
            column(AGE;"HRM-Employee C".Age)
            {
            }
            dataitem(UnknownTable61323;UnknownTable61323)
            {
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column("Code";"HRM-Employee Kin"."Employee Code")
                {
                }
                column(Relationship;"HRM-Employee Kin".Relationship)
                {
                }
                column(Surname;"HRM-Employee Kin".SurName)
                {
                }
                column(OthersName;"HRM-Employee Kin"."Other Names")
                {
                }
                column(IDNO;"HRM-Employee Kin"."ID No/Passport No")
                {
                }
                column(BORNYEAR;"HRM-Employee Kin"."Date Of Birth")
                {
                }
                column(Occupation;"HRM-Employee Kin".Occupation)
                {
                }
                column(Address;"HRM-Employee Kin".Address)
                {
                }
                column(OfficeNo;"HRM-Employee Kin"."Office Tel No")
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
}

