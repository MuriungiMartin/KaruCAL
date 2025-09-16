#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51827 "FIN-Cheque no updates"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FIN-Cheque no updates.rdlc';

    dataset
    {
        dataitem(UnknownTable61536;UnknownTable61536)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(StundNo;"ACA-Std Payments"."Student No.")
            {
            }
            column(Cheque;"ACA-Std Payments"."Cheque No")
            {
            }
            column(bank;"ACA-Std Payments"."Drawer Bank")
            {
            }
            column(Amount;"ACA-Std Payments"."Amount to pay")
            {
            }
            column(Paymode;"ACA-Std Payments"."Payment Mode")
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

