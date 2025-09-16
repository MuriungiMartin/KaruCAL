#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51066 "Update LPO2"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Header";"Purchase Header")
        {
            RequestFilterFields = "No. Series";
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   "Purchase Header"."No. Series":='P-ORD';
                   "Purchase Header"."Posting No. Series":='P-INV+';
                   "Purchase Header"."Receiving No. Series":='REC+';
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

