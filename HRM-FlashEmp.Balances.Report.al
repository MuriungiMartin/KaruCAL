#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51822 "HRM-Flash Emp. Balances"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61753;UnknownTable61753)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                    "HRM-Emp. Trans Bal.  Buffer".Posted:=false;
                    "HRM-Emp. Trans Bal.  Buffer"."Fail Reason":='';
                    "HRM-Emp. Trans Bal.  Buffer"."Transaction Type":="HRM-Emp. Trans Bal.  Buffer"."transaction type"::" ";
                    "HRM-Emp. Trans Bal.  Buffer".Modify;
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

