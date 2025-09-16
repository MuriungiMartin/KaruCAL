#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51801 "HRM-Post Empls"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer;Customer)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                 /* if "HR Employee C"."ID Number"<>'' then begin
                    "HR Employee C"."Portal Password":="HR Employee C"."ID Number";
                    "HR Employee C".Password:="HR Employee C"."ID Number";
                    "HR Employee C".MODIFY;
                  end;  */
                
                if Customer."ID No"='' then begin
                  Customer."ID No":=Customer."No.";
                  Customer.Modify;
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
}

