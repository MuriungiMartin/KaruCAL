#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80050 "Validate Period Trans"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                transcode.Reset;
                if transcode.Get("PRL-Period Transactions"."Transaction Code") then begin
                "PRL-Period Transactions"."Recovery Priority"  :=transcode."Recovery Priority";
                "PRL-Period Transactions".Modify;
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
        transcode: Record UnknownRecord61082;
}

