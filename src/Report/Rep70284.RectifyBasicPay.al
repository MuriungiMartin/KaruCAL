#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70284 "Rectify Basic Pay"
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
                PRLSalaryCard.Reset;
                PRLSalaryCard.SetRange(PRLSalaryCard."Employee Code","PRL-Period Transactions"."Employee Code");
                PRLSalaryCard.SetRange(PRLSalaryCard."Payroll Period","PRL-Period Transactions"."Payroll Period");
                if PRLSalaryCard.Find('-') = false then begin
                  // Create Slary Card Entries Here
                PRLSalaryCard.Reset;
                PRLSalaryCard."Employee Code":="PRL-Period Transactions"."Employee Code";
                PRLSalaryCard."Payroll Period":="PRL-Period Transactions"."Payroll Period";
                PRLSalaryCard."Basic Pay":="PRL-Period Transactions".Amount;
                PRLSalaryCard."Posting Group":="PRL-Period Transactions"."Payroll Code";
                PRLSalaryCard."Period Month":="PRL-Period Transactions"."Period Month";
                PRLSalaryCard."Period Year":="PRL-Period Transactions"."Period Year";
                PRLSalaryCard.Closed:=true;
                PRLSalaryCard.Insert;
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
        PRLSalaryCard: Record UnknownRecord61105;
}

