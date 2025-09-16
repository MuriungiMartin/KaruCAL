#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51005 "Jab Billing Correction"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Jab Billing Correction.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = Stage,"Settlement Type";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(No;"ACA-Course Registration"."Student No.")
            {
            }
            column(Prog;"ACA-Course Registration".Programme)
            {
            }
            column(Stage;"ACA-Course Registration".Stage)
            {
            }
            column(SettlementType;"ACA-Course Registration"."Settlement Type")
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

