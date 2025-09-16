#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50069 "Beneficiary Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Beneficiary Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61324;UnknownTable61324)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(PF;"HRM-Employee Beneficiaries"."Employee Code")
            {
            }
            column(Surname;"HRM-Employee Beneficiaries".SurName)
            {
            }
            column(OtherNmaes;"HRM-Employee Beneficiaries"."Other Names")
            {
            }
            column(Relationship;"HRM-Employee Beneficiaries".Relationship)
            {
            }
            column(IDNO;"HRM-Employee Beneficiaries"."ID No/Passport No")
            {
            }
            column(DOB;"HRM-Employee Beneficiaries"."Date Of Birth")
            {
            }
            column(Occupation;"HRM-Employee Beneficiaries".Occupation)
            {
            }
            column(Address;"HRM-Employee Beneficiaries".Address)
            {
            }
            column(PHoneNO;"HRM-Employee Beneficiaries"."Office Tel No")
            {
            }
            column(TelNo;"HRM-Employee Beneficiaries"."Home Tel No")
            {
            }
            dataitem(UnknownTable61188;UnknownTable61188)
            {
                column(ReportForNavId_1000000012; 1000000012)
                {
                }
                column(Status;"HRM-Employee C".Status)
                {
                }
                column(PFNO;"HRM-Employee C"."No.")
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

