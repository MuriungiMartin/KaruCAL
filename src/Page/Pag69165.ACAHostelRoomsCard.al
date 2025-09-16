#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69165 "ACA-Hostel Rooms Card"
{
    PageType = Card;
    SourceTable = "ACA-Hostel Block Rooms";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Hostel Code";"Hostel Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Room Code";"Room Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Bed Spaces";"Bed Spaces")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Clear Space")
            {
                ApplicationArea = Basic;
                Caption = 'Clear Space';
                Image = ClearLog;
                Promoted = true;

                trigger OnAction()
                begin
                          if Confirm('Clear Space?',false)=true then begin
                              clearFromRoom();
                          end;
                end;
            }
        }
    }


    procedure clearFromRoom()
    var
        Rooms: Record "ACA-Hostel Block Rooms";
        spaces: Record UnknownRecord61824;
        hostLedger: Record "ACA-Hostel Ledger";
        HostRooms: Record "ACA-Students Hostel Rooms";
    begin
         hostLedger.Reset;
         hostLedger.SetRange(hostLedger."Hostel No","Hostel Code");
         hostLedger.SetRange(hostLedger."Room No","Room Code");
        // hostLedger.SETRANGE(hostLedger."Space No","Space Code");

         if hostLedger.Find('-') then begin
         repeat
         begin
        HostRooms.Reset;
        HostRooms.SetRange(HostRooms.Student,hostLedger."Student No");
        HostRooms.SetRange(HostRooms."Academic Year",hostLedger."Academic Year");
        HostRooms.SetRange(HostRooms.Semester,hostLedger.Semester);
        HostRooms.SetRange(HostRooms."Hostel No",hostLedger."Hostel No");
        HostRooms.SetRange(HostRooms."Room No",hostLedger."Room No");
        HostRooms.SetRange(HostRooms."Space No",hostLedger."Space No");
        if HostRooms.Find('-') then begin
          HostRooms.Cleared:=true;
          HostRooms."Clearance Date":=Today;
          HostRooms.Modify;
        end;
        hostLedger.Delete;
          end;
          until hostLedger.Next=0;
         end;


        spaces.Reset;
        spaces.SetRange(spaces."Hostel Code","Hostel Code");
        spaces.SetRange(spaces."Room Code","Room Code");
        //spaces.SETRANGE(spaces."Space Code","Space Code");
        if spaces.Find('-') then begin
        repeat
        begin
        spaces.Status:=spaces.Status::Vaccant;
        spaces."Student No":='';
        spaces."Receipt No":='';
        spaces."Black List reason":='';
        spaces.Modify;
        end;
        until spaces.Next=0;
        end;

          Rooms.Reset;
         Rooms.SetRange(Rooms."Hostel Code","Hostel Code");
         Rooms.SetRange(Rooms."Room Code","Room Code");
         if Rooms.Find('-') then begin
          repeat
           Rooms.Validate(Rooms.Status);
          until Rooms.Next = 0;
         end;
    end;
}

