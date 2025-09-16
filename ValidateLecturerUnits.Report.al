#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65818 "Validate Lecturer Units"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable65202;UnknownTable65202)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //"ACA-Lecturers Units".VALIDATE("ACA-Lecturers Units".Programme);
                "ACA-Lecturers Units".Validate("ACA-Lecturers Units".Unit);
                "ACA-Lecturers Units".Modify;
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

