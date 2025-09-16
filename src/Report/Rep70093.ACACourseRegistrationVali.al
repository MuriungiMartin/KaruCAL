#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70093 "ACA-Course Registration Vali"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "ACA-Course Registration".Validate("ACA-Course Registration".Stage);
                "ACA-Course Registration".Modify;
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

