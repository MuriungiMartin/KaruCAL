#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51052 "Validate Rooms"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("ACA-Hostel Block Rooms";"ACA-Hostel Block Rooms")
        {
            DataItemTableView = where(Status=filter(<>"Black-Listed"));
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                           CalcFields("ACA-Hostel Block Rooms"."Occupied Spaces","ACA-Hostel Block Rooms"."Bed Spaces");
                           if (("ACA-Hostel Block Rooms"."Occupied Spaces">0) and ("ACA-Hostel Block Rooms"."Occupied Spaces"<"ACA-Hostel Block Rooms"."Bed Spaces")) then begin
                            "ACA-Hostel Block Rooms".Status:="ACA-Hostel Block Rooms".Status::"Partially Occupied";
                            "ACA-Hostel Block Rooms".Modify;
                           end else if ("ACA-Hostel Block Rooms"."Occupied Spaces"="ACA-Hostel Block Rooms"."Bed Spaces") then begin
                            "ACA-Hostel Block Rooms".Status:="ACA-Hostel Block Rooms".Status::"Fully Occupied";
                            "ACA-Hostel Block Rooms".Modify;
                           end else if ("ACA-Hostel Block Rooms"."Occupied Spaces"=0) then begin
                            "ACA-Hostel Block Rooms".Status:="ACA-Hostel Block Rooms".Status::Vaccant;
                            "ACA-Hostel Block Rooms".Modify;
                           end;
                          /* CALCFIELDS("Room Spaces"."Current Student");
                           IF  "Room Spaces"."Current Student"='' THEN BEGIN
                            "Room Spaces".Status:="Room Spaces".Status::Vaccant;
                            "Room Spaces".MODIFY;
                           END;*/

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
        hostLed: Record "ACA-Hostel Ledger";
}

