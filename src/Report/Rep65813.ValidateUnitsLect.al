#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65813 "Validate Units Lect"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable65201;UnknownTable65201)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Lect Load Batch Lines".Validate("Lect Load Batch Lines"."Lecturer Code");
                "Lect Load Batch Lines".Modify;
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

