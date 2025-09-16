#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51007 Tender
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Tender.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(UnknownTable61143;UnknownTable61143)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(No;"PROC-Tender"."Vendor No.")
            {
            }
            column(Name;"PROC-Tender"."Vendor Name")
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

