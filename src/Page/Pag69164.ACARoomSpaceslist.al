#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69164 "ACA-Room Spaces list"
{
    PageType = List;
    SourceTable = UnknownTable61824;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Room Code";"Room Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Space Code";"Space Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bed Spaces';
                    Editable = true;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Current Student";"Current Student")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student No.';
                    Editable = false;
                }
                field("Black List reason";"Black List reason")
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
            action(BlackList)
            {
                ApplicationArea = Basic;
                Caption = 'Black list';
                Image = AddAction;
                Promoted = true;

                trigger OnAction()
                begin
                        if "Student No"<>'' then Error('The space is not Vaccant');
                              if Confirm('Blacklist this Room-Space?',false)=false then Error('Cancelled by user!');
                           if "Black List reason"='' then Error('please provide a Black list reason');
                           Status:=Status::"Black-Listed";
                           Modify;
                           Message('The Room-Space has been successfully black-listed.');
                end;
            }
            action(UnblackList)
            {
                ApplicationArea = Basic;
                Caption = 'Un-Blacklist';
                Image = "Action";
                Promoted = true;

                trigger OnAction()
                begin
                           if Confirm('Un-blacklist this Room-Space',true)=false then Error('Cancelled by user!');
                           if "Student No"<>'' then
                                 Status:=Status::"Fully Occupied"
                           else
                                 Status:=Status::Vaccant;
                                 "Black List reason":='';
                                 Modify;
                                 Message('Room-Space un-blacklisted Successfully');
                end;
            }
            action(Vacate)
            {
                ApplicationArea = Basic;
                Caption = 'Vacate';
                Image = ClearLog;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ACAHostelPermissions.PermissionMan(UserId,2);

                          if Confirm('Clear Space?',false)=true then begin
                              clearFromRoom();
                          end;
                end;
            }
        }
    }

    var
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
         hostLedger.SetRange(hostLedger."Space No","Space Code");

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
        spaces.SetRange(spaces."Space Code","Space Code");
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

