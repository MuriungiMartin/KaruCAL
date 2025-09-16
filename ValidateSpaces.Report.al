#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51035 "Validate Spaces"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61824;UnknownTable61824)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                       blockRooms.Reset;
                       blockRooms.SetRange(blockRooms."Hostel Code","ACA-Room Spaces"."Hostel Code");
                       blockRooms.SetRange(blockRooms."Room Code","ACA-Room Spaces"."Room Code");
                       if not blockRooms.Find('-') then begin
                 "ACA-Room Spaces".Delete;
                       end;
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
        blockRooms: Record "ACA-Hostel Block Rooms";
}

