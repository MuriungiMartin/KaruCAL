#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51062 "Temp Hoste"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("ACA-Hostel Block Rooms";"ACA-Hostel Block Rooms")
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   "ACA-Hostel Block Rooms".Validate("ACA-Hostel Block Rooms"."Room Code");
                    "ACA-Hostel Block Rooms".Modify;
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

