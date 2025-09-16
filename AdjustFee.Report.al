#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51018 "Adjust Fee"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Adjust Fee.rdlc';

    dataset
    {
        dataitem(UnknownTable61523;UnknownTable61523)
        {
            DataItemTableView = where("Stage Code"=filter(Y1S1),"Settlemet Type"=filter(JAB));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(prog;"ACA-Fee By Stage"."Programme Code")
            {
            }
            column(stage;"ACA-Fee By Stage"."Stage Code")
            {
            }
            column(type;"ACA-Fee By Stage"."Settlemet Type")
            {
            }
            column(Amount;"ACA-Fee By Stage"."Break Down")
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

