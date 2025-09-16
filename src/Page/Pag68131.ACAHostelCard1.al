#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68131 "ACA-Hostel Card1"
{
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
                    LookupPageID = "PROC-Procure. Plan Period";

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
                field("Total Rooms Created";"Total Rooms Created")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Rooms")
            {
                ApplicationArea = Basic;
                Caption = 'Create Rooms';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                      "Rooms Maker"();
                end;
            }
        }
    }

    var
        FA: Record "Fixed Asset";
        Rooms: Record "ACA-Hostel Ledger";
        Existing: Integer;
        Counter: Integer;
        "Last Room": Code[10];
        "Space Name": Code[20];
        Counter2: Integer;
        TotalCount: Integer;


    procedure "Rooms Maker"()
    begin
        // Creates Rooms For The Hostel
          TestField("Room Prefix");
          Rooms.Reset;
          Rooms.SetRange(Rooms."Hostel No","Asset No");
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
          for Counter:="Starting No" to "Total Rooms" do
          begin
            for Counter2:=1 to "Space Per Room" do
            begin
              Rooms.Init();
              Rooms."Room No":="Room Prefix" +' '+ Format(Counter);
              Rooms."Hostel No":="Asset No";
              Rooms.Status:=Rooms.Status::Vaccant;
              Rooms."Room Cost":="Cost Per Occupant";
              Rooms."Space No":=Rooms."Room No"+'-'+Format(Counter2);
              Rooms.Insert(true);
              TotalCount:=TotalCount+1;
             end;
            //end;
            //Rooms.INSERT(TRUE);
          end;
        Message(Format(TotalCount)+' Rooms Created successfully');

    end;
}

