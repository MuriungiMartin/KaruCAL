#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50452 "ACA-Enquiry List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Enquiry List.rdlc';

    dataset
    {
        dataitem(UnknownTable61348;UnknownTable61348)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(no;"ACA-Enquiry Header"."Enquiry No.")
            {
            }
            column(enqDate;"ACA-Enquiry Header"."Enquiry Date")
            {
            }
            column(Names;"ACA-Enquiry Header"."Name(Surname First)")
            {
            }
            column(Gender;"ACA-Enquiry Header".Gender)
            {
            }
            column(Prog;"ACA-Enquiry Header".Programme)
            {
            }
            column(Surname;"ACA-Enquiry Header".Surname)
            {
            }
            column(OtherNames;"ACA-Enquiry Header"."Other Names")
            {
            }
            column(MktStrategy;"ACA-Enquiry Header"."How You knew about us")
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

