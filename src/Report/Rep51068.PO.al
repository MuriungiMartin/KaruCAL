#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51068 PO
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Header";"Purchase Header")
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   "Purchase Header"."Currency Code":='';
                   "Purchase Header"."Currency Factor":=1;
                   "Purchase Header".Modify;
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

