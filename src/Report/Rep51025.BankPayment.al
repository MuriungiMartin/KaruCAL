#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51025 "Bank Payment"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer;Customer)
        {
            column(ReportForNavId_7; 7)
            {
            }

            trigger OnAfterGetRecord()
            begin
                    if ((Customer."Global Dimension 2 Code"='1001') or (Customer."Global Dimension 2 Code"='1002')) then begin
                    Customer."Global Dimension 2 Code":='541';
                    Modify;
                    end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }
}

