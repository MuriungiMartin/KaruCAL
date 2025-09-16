#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 69275 "Val Units"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61549;UnknownTable61549)
        {
            RequestFilterFields = Semester;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "ACA-Student Units".Taken:=true;
                "ACA-Student Units".Modify;
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

