#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68241 "ACA-Hostel Card"
{
    DeleteAllowed = false;
    PageType = Document;
    SourceTable = "ACA-Hostel Card";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Asset No";"Asset No")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                           FA.SetRange(FA."No.","Asset No");
                           if FA.Find('-') then
                            begin
                             Description:=FA.Description;
                           end
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Hostel Type";"Hostel Type")
                {
                    ApplicationArea = Basic;
                }
                field("Provider Code";"Provider Code")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                }
                field("Room Prefix";"Room Prefix")
                {
                    ApplicationArea = Basic;
                }
                field("Total Rooms";"Total Rooms")
                {
                    ApplicationArea = Basic;
                }
                field("Space Per Room";"Space Per Room")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Per Occupant";"Cost Per Occupant")
                {
                    ApplicationArea = Basic;
                }
                field("Starting No";"Starting No")
                {
                    ApplicationArea = Basic;
                }
                field("Room Spaces";"Room Spaces")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                field("View Online";"View Online")
                {
                    ApplicationArea = Basic;
                }
                field("Asignment Sequence";"Asignment Sequence")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RoomsGen)
            {
                ApplicationArea = Basic;
                Caption = 'Generate Rooms';
                Image = AddAction;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                     "Rooms Maker"();
                end;
            }
            action(Rooms)
            {
                ApplicationArea = Basic;
                Caption = 'Rooms';
                Image = DistributionGroup;
                Promoted = true;
                RunObject = Page "ACA-Hostel Block Rooms list";
                RunPageLink = "Hostel Code"=field("Asset No");
            }
            action(ClearRooms)
            {
                ApplicationArea = Basic;
                Caption = 'Clear All Rooms';
                Enabled = true;
                Image = ClearLog;
                Promoted = true;

                trigger OnAction()
                begin
                    ACAHostelPermissions.PermissionMan(UserId,2);
                       if Confirm('Clear All Rooms in this Block?',false)=false then exit;
                       clearFromRoom();
                end;
            }
            action(Rec_Incidents)
            {
                ApplicationArea = Basic;
                Caption = 'Incidents Recording';
                Image = Capacity;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ACA-Hostel Incidents";
                RunPageLink = "Hostel Block No."=field("Asset No");
            }
        }
    }

    var
        FA: Record "Fixed Asset";
        Rooms: Record "ACA-Hostel Block Rooms";
        Existing: Integer;
        Counter: Integer;
        "Last Room": Code[10];
        "Space Name": Code[20];
        Counter2: Integer;
        TotalCount: Integer;
        RoomSpaces: Record UnknownRecord61824;
        ACAHostelPermissions: Record "ACA-Hostel Permissions";


    procedure "Rooms Maker"()
    begin
        // Creates Rooms For The Hostel
        Clear(Counter2);
          TestField("Room Prefix");
          Rooms.Reset;
          Rooms.SetRange(Rooms."Hostel Code","Asset No");
          Existing:=Rooms.Count;
          Rooms.Reset;
          if Existing=0 then
            Existing:=1;
            /*
          IF "Space Per Room">1 THEN
          BEGIN
            "Total Rooms":="Total Rooms"*"Space Per Room"
          END;
        
          IF "Space Per Room"<1 THEN
          BEGIN
            "Space Per Room":=1
          END;
          */
          TotalCount:=0;
          Rooms.Reset;
          Rooms.SetRange(Rooms."Hostel Code","Asset No");
          if Rooms.Find('-') then Rooms.DeleteAll;
          for Counter:="Starting No" to "Total Rooms" do
          begin
         // Create Rooms Here
              Rooms.Init();
        if Counter<10 then
              Rooms."Room Code":="Room Prefix" +' 000'+ Format(Counter)
        else if Counter<100 then
              Rooms."Room Code":="Room Prefix" +' 00'+ Format(Counter)
        else if Counter>99 then
              Rooms."Room Code":="Room Prefix" +' 0'+ Format(Counter);
              Rooms."Hostel Code":="Asset No";
              Rooms.Status:=Rooms.Status::Vaccant;
              Rooms."Room Cost":="Cost Per Occupant";
              Rooms.Validate(Rooms."Room Code");
              //Rooms."Space No":=Rooms."Room No"+'-'+FORMAT(Counter2);
              Rooms.Insert(true);
            RoomSpaces.Reset;
            RoomSpaces.SetRange(RoomSpaces."Hostel Code","Asset No");
            if Counter<10 then
            RoomSpaces.SetRange(RoomSpaces."Room Code","Room Prefix" +' 000'+ Format(Counter))
            else if Counter<100 then
            RoomSpaces.SetRange(RoomSpaces."Room Code","Room Prefix" +' 00'+ Format(Counter))
            else if Counter>99 then
            RoomSpaces.SetRange(RoomSpaces."Room Code","Room Prefix" +' 0'+ Format(Counter));
            if RoomSpaces.Find('-') then RoomSpaces.DeleteAll;
            for Counter2:=1 to "Space Per Room" do
            begin
         //   Create Bed Spaces Here
         RoomSpaces.Reset;
         RoomSpaces."Hostel Code":="Asset No";
         if Counter<10 then begin
         RoomSpaces."Room Code":="Room Prefix" +' 000'+ Format(Counter);
         RoomSpaces."Space Code":="Room Prefix" +' 000'+ Format(Counter)+' ('+Format(Counter2)+')';
         end else if Counter<100 then begin
         RoomSpaces."Room Code":="Room Prefix" +' 00'+ Format(Counter);
         RoomSpaces."Space Code":="Room Prefix" +' 00'+ Format(Counter)+' ('+Format(Counter2)+')';
        end else if Counter>99 then begin
        RoomSpaces."Room Code":="Room Prefix" +' 0'+ Format(Counter);
         RoomSpaces."Space Code":="Room Prefix" +' 0'+ Format(Counter)+' ('+Format(Counter2)+')';
        end;
         RoomSpaces.Status:=RoomSpaces.Status::Vaccant;
         RoomSpaces.Booked:=false;
         RoomSpaces.Insert;
              TotalCount:=TotalCount+1;
             end;
            //end;
            //Rooms.INSERT(TRUE);
          end;
        Message(Format(TotalCount)+' Rooms Created successfully');

    end;


    procedure clearFromRoom()
    var
        Rooms: Record "ACA-Hostel Block Rooms";
        spaces: Record UnknownRecord61824;
        hostLedger: Record "ACA-Hostel Ledger";
        HostRooms: Record "ACA-Students Hostel Rooms";
    begin
         hostLedger.Reset;
         hostLedger.SetRange(hostLedger."Hostel No","Asset No");
         //hostLedger.SETRANGE(hostLedger."Room No","Room No");
         //hostLedger.SETRANGE(hostLedger."Space No","Space No");
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
        spaces.SetRange(spaces."Hostel Code","Asset No");
        //spaces.setrange(spaces."Room Code","Room No");
        //spaces.setrange(spaces."Space Code","Space No");
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
         Rooms.SetRange(Rooms."Hostel Code","Asset No");
         //Rooms.SETRANGE(Rooms."Room Code","Room No");
         if Rooms.Find('-') then begin
          repeat
           Rooms.Validate(Rooms.Status);
          until Rooms.Next = 0;
         end;
    end;
}

