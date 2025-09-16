#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51033 "Adjust Transactions"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = where("Transaction Code"=filter(2049));
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   if ((Balance-(Amount*2))>0) then begin
                  if Balance>0 then begin
                      Balance:=Balance--(Amount*2);
                      Modify;
                  emptra.Reset;
                  emptra.SetRange(emptra."Employee Code","PRL-Period Transactions"."Employee Code");
                  emptra.SetRange(emptra."Transaction Code","PRL-Period Transactions"."Transaction Code");
                  emptra.SetRange(emptra."Payroll Period","PRL-Period Transactions"."Payroll Period");
                  if emptra.Find('-') then begin
                  emptra.Balance:=emptra.Balance-(emptra.Amount*2);
                  emptra.Modify;
                  end;
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
        emptra: Record UnknownRecord61091;
}

