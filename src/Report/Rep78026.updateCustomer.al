#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78026 "update Customer"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer;Customer)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                 if (Customer."Customer Posting Group" = 'STUDENT') then begin
                   Customer.Password := Customer."ID No";
                   Customer."Changed Password" := true;
                   Customer.Modify;
                   end;
            end;

            trigger OnPostDataItem()
            begin
                Message('There is nothing to display.This is a process only report');
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

