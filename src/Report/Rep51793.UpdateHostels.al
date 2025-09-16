#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51793 "Update Hostels"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Hostels.rdlc';

    dataset
    {
        dataitem("ACA-Hostel Ledger";"ACA-Hostel Ledger")
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                     Room.Reset;
                     Room.SetRange(Room."Hostel Code","ACA-Hostel Ledger"."Hostel No");
                     Room.SetRange(Room."Room Code","ACA-Hostel Ledger"."Room No");
                     if not (Room.Find('-')) then begin
                      // Insert
                        Room.Init;
                        Room."Hostel Code":="ACA-Hostel Ledger"."Hostel No";
                        Room."Room Code":="ACA-Hostel Ledger"."Room No" ;
                        Room.Status:=Room.Status::Vaccant;
                        Room.Insert(true);
                     end;
                     RoomSpaces.Reset;
                     RoomSpaces.SetRange(RoomSpaces."Hostel Code","ACA-Hostel Ledger"."Hostel No");
                     RoomSpaces.SetRange(RoomSpaces."Room Code","ACA-Hostel Ledger"."Room No");
                     RoomSpaces.SetRange(RoomSpaces."Space Code","ACA-Hostel Ledger"."Space No");
                if not (RoomSpaces.Find('-')) then begin
                    //Insert
                    RoomSpaces.Init;
                      RoomSpaces."Hostel Code":= "ACA-Hostel Ledger"."Hostel No";
                      RoomSpaces."Room Code":="ACA-Hostel Ledger"."Room No";
                      RoomSpaces."Space Code":="ACA-Hostel Ledger"."Space No" ;
                      RoomSpaces.Status:=RoomSpaces.Status::Vaccant;
                      RoomSpaces.Insert(true);
                end;

                Delete(true);
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
        Room: Record "ACA-Hostel Block Rooms";
        RoomSpaces: Record UnknownRecord61824;
}

