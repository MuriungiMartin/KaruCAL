#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51065 "Update Menus Sales Amount"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61170;UnknownTable61170)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                    "CAT-Menu Sale Header".CalcFields("CAT-Menu Sale Header".Amount);
                    "CAT-Menu Sale Header"."Line Amount":="CAT-Menu Sale Header".Amount;
                    "CAT-Menu Sale Header".Modify;
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

