#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69163 "ACA-Hostel Block Rooms list"
{
    DeleteAllowed = true;
    Editable = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "ACA-Hostel Block Rooms";
    SourceTableView = sorting(Sequence,"Hostel Code","Room Code")
                      order(ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Room Code";"Room Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Control4;"Bed Spaces")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Occupied Spaces";"Occupied Spaces")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Black List reason";"Black List reason")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reason for Reservation';
                    Editable = true;
                }
                field("JAB Fees";"JAB Fees")
                {
                    ApplicationArea = Basic;
                }
                field("SSP Fees";"SSP Fees")
                {
                    ApplicationArea = Basic;
                }
                field("Special Programme";"Special Programme")
                {
                    ApplicationArea = Basic;
                }
                field(Sequence;Sequence)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Bed Spaces")
            {
                ApplicationArea = Basic;
                Caption = 'Bed Spaces';
                Image = List;
                Promoted = true;
                RunObject = Page "ACA-Room Spaces list";
                RunPageLink = "Hostel Code"=field("Hostel Code"),
                              "Room Code"=field("Room Code");
            }
            action("Reserve Room")
            {
                ApplicationArea = Basic;
                Caption = 'Reserve Room';
                Image = AddAction;
                Promoted = true;

                trigger OnAction()
                begin
                          if Status<>Status::Vaccant then Error('The room is not vacant!');
                           if Confirm('Reserve this room?',false)=false then Error('Cancelled by user!');
                           if "Black List reason"='' then Error('please provide a reason for reservation');
                           Status:=Status::"Black-Listed";
                           Modify;
                           roomspaces.Reset;
                           roomspaces.SetRange(roomspaces."Room Code","Room Code");
                           if roomspaces.Find('-') then begin
                            repeat
                              begin
                              if roomspaces.Status<>roomspaces.Status::Vaccant then Error('A Space that is not vaccant exists for this room!');
                                roomspaces.Status:=roomspaces.Status::"Black-Listed";
                                roomspaces."Black List reason":="Black List reason";
                                roomspaces.Modify;
                              end;
                            until roomspaces.Next=0;
                           end;
                           Message('The room has been successfully Reserved.');
                end;
            }
            action("Un-Blacklist")
            {
                ApplicationArea = Basic;
                Caption = 'Un-Blacklist';
                Image = "Action";
                Promoted = true;

                trigger OnAction()
                begin
                           if Confirm('Activate this room?',true)=false then Error('Cancelled by user!');
                                 Status:=Status::Vaccant;
                                 "Black List reason":='';
                                 Modify;
                           roomspaces.Reset;
                           roomspaces.SetRange(roomspaces."Room Code","Room Code");
                           if roomspaces.Find('-') then begin
                            repeat
                              begin
                                roomspaces.Status:=roomspaces.Status::Vaccant;
                                roomspaces."Black List reason":='';
                                roomspaces.Modify;
                              end;
                            until roomspaces.Next=0;
                           end;

                                 Message('Room Activated Successfully');
                end;
            }
            action("Clear Space")
            {
                ApplicationArea = Basic;
                Caption = 'Clear Space';
                Enabled = true;
                Image = ClearLog;
                Promoted = true;

                trigger OnAction()
                begin
                    ACAHostelPermissions.PermissionMan(UserId,2);

                          if Confirm('Clear Space?',false)=true then begin
                              clearFromRoom();
                          end;
                end;
            }
            action("Update Status")
            {
                ApplicationArea = Basic;
                Caption = 'Update Status';
                Image = "Action";
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ACAHostelBlockRooms.Reset;
                    //ACAHostelBlockRooms.COPYFILTERS(Rec);
                    if ACAHostelBlockRooms.Find('-') then begin
                      repeat
                          ACAHostelBlockRooms.Validate(Status);
                        until ACAHostelBlockRooms.Next =0;
                      end;
                end;
            }
        }
    }

    var
        roomspaces: Record UnknownRecord61824;
        clearFromRoom1: Integer;
        ACAHostelBlockRooms: Record "ACA-Hostel Block Rooms";
        ACAHostelPermissions: Record "ACA-Hostel Permissions";


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

