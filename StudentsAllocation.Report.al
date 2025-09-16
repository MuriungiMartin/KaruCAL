#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51009 "Students Allocation"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("ACA-Hostel Block Rooms";"ACA-Hostel Block Rooms")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                    Validate("ACA-Hostel Block Rooms".Status);
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
        MKey: Text;
        mSign: Text;
        mMart: Text;
}

