#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80051 "PRl Validate Emp. Transactions"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61091;UnknownTable61091)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PRLTransactionCodes.Reset;
                PRLTransactionCodes.SetRange("Transaction Code","PRL-Employee Transactions"."Transaction Code");
                if PRLTransactionCodes.Find('-') then begin
                "PRL-Employee Transactions".Validate("PRL-Employee Transactions"."Transaction Code");
                "PRL-Employee Transactions".Modify;
                end;
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

    var
        PRLTransactionCodes: Record UnknownRecord61082;
}

