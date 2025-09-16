#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 69300 "salCard rec"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = where("Transaction Code"=filter(BPAY));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "PRL-Period Transactions"."Transaction Code"='BPAY' then begin
                salCard.Reset;
                salCard.SetRange(salCard."Employee Code","PRL-Period Transactions"."Employee Code");
                salCard.SetRange(salCard."Payroll Period","PRL-Period Transactions"."Payroll Period");
                if salCard.Find('-') then begin
                    salCard."Basic Pay":="PRL-Period Transactions".Amount;
                  salCard.Modify;
                  end;
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
        salCard: Record UnknownRecord61105;
}

