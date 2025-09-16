#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51053 "Check Kostel ledger"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("ACA-Students Hostel Rooms";"ACA-Students Hostel Rooms")
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                            if "ACA-Students Hostel Rooms"."Switched to Space No"<>'' then begin
                            "ACA-Students Hostel Rooms".Switched:=true;
                            "ACA-Students Hostel Rooms".Modify;
                            end;
                            if "ACA-Students Hostel Rooms"."Transfer to Space No"<>'' then  begin
                            "ACA-Students Hostel Rooms".Transfered:=true;
                            "ACA-Students Hostel Rooms".Modify;
                            end;
                            if "ACA-Students Hostel Rooms".Allocated then begin
                              "ACA-Students Hostel Rooms".Status:="ACA-Students Hostel Rooms".Status::Allocated;
                              "ACA-Students Hostel Rooms"."Invoice Printed":=true;
                              "ACA-Students Hostel Rooms".Modify;
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
        studRooms: Record "ACA-Hostel Block Rooms";
        roomledgers: Record "ACA-Hostel Ledger";
}

