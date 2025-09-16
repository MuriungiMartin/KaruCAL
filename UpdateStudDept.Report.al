#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51059 "UpdateStud Dept"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer;Customer)
        {
            RequestFilterFields = "Global Dimension 2 Code";
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   if Prog.Get(Customer."Current Programme") then
                   Customer."Global Dimension 2 Code":=Prog."Department Code";
                   Customer.Modify;
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
        Prog: Record UnknownRecord61511;
}

