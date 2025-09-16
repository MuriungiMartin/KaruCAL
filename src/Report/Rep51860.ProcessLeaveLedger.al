#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51860 "Process Leave Ledger"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61659;UnknownTable61659)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "HRM-Leave Ledger"."Transaction Type"="HRM-Leave Ledger"."transaction type"::Allocation then
                "HRM-Leave Ledger"."Entry Type"  :="HRM-Leave Ledger"."entry type"::Allocation;

                if "HRM-Leave Ledger"."Transaction Type"="HRM-Leave Ledger"."transaction type"::Application then
                "HRM-Leave Ledger"."Entry Type"  :="HRM-Leave Ledger"."entry type"::Application;
                "HRM-Leave Ledger".Modify;
            end;
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

