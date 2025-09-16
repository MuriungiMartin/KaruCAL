#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70000 "Conf_ Facilities Pend Cleaning"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable70010;
    SourceTableView = where("Not Clean"=filter(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Facility Code";"Facility Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Bed Spaces";"Bed Spaces")
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
                    Editable = false;
                }
                field("Black List reason";"Black List reason")
                {
                    ApplicationArea = Basic;
                    Caption = 'Out of Order Reason';
                    Editable = true;
                }
                field("Facility Category";"Facility Category")
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
            action("Set as Available")
            {
                ApplicationArea = Basic;
                Caption = 'Set as Available';
                Image = "Action";
                Promoted = true;

                trigger OnAction()
                begin
                           if Confirm('Activate this Facility?',true)=false then Error('Cancelled by user!');
                                 Status:=Status::Vaccant;
                                 "Black List reason":='';
                                 "Not Clean":=false;
                                 Modify;
                           Facilityspaces.Reset;
                           Facilityspaces.SetRange(Facilityspaces."Facility Code","Facility Code");
                           if Facilityspaces.Find('-') then begin
                            repeat
                              begin
                                Facilityspaces.Status:=Facilityspaces.Status::"0";
                                Facilityspaces."Black List reason":='';
                                Facilityspaces.Modify;
                              end;
                            until Facilityspaces.Next=0;
                           end;

                                 Message('Facility Activated Successfully');
                end;
            }
        }
    }

    var
        Facilityspaces: Record UnknownRecord70011;
        NameclearFromFacility: Integer;


    procedure clearFromFacility()
    var
        Facilitys: Record UnknownRecord70010;
        spaces: Record UnknownRecord70011;
        hostLedger: Record UnknownRecord70002;
        HostFacilitys: Record UnknownRecord70000;
    begin
         hostLedger.Reset;
         hostLedger.SetRange(hostLedger."Conf_ No","Conf_ Code");
         hostLedger.SetRange(hostLedger."Facility No","Facility Code");
        // hostLedger.SETRANGE(hostLedger."Space No","Space Code");

         if hostLedger.Find('-') then begin
         repeat
         begin
        HostFacilitys.Reset;
        HostFacilitys.SetRange(HostFacilitys.Participant,hostLedger."Participant No");
        HostFacilitys.SetRange(HostFacilitys."Academic Year",hostLedger."Academic Year");
        HostFacilitys.SetRange(HostFacilitys.Semester,hostLedger.Semester);
        HostFacilitys.SetRange(HostFacilitys."Conf_ No",hostLedger."Conf_ No");
        HostFacilitys.SetRange(HostFacilitys."Facility No",hostLedger."Facility No");
        HostFacilitys.SetRange(HostFacilitys."Space No",hostLedger."Space No");
        if HostFacilitys.Find('-') then begin
          HostFacilitys.Cleared:=true;
          HostFacilitys."Clearance Date":=Today;
          HostFacilitys.Modify;
        end;
        hostLedger.Delete;
          end;
          until hostLedger.Next=0;
         end;


        spaces.Reset;
        spaces.SetRange(spaces."Conf_ Code","Conf_ Code");
        spaces.SetRange(spaces."Facility Code","Facility Code");
        //spaces.SETRANGE(spaces."Space Code","Space Code");
        if spaces.Find('-') then begin
        repeat
        begin
        spaces.Status:=spaces.Status::"0";
        spaces."Participant No":='';
        spaces."Receipt No":='';
        spaces."Black List reason":='';
        spaces.Modify;
        end;
        until spaces.Next=0;
        end;

          Facilitys.Reset;
         Facilitys.SetRange(Facilitys."Conf_ Code","Conf_ Code");
         Facilitys.SetRange(Facilitys."Facility Code","Facility Code");
         if Facilitys.Find('-') then begin
          repeat
           Facilitys.Validate(Facilitys.Status);
          until Facilitys.Next = 0;
         end;

        // Set the Facility as waiting cleaning
               "Black List reason":='Pending Cleaning';
               Status:=Status::"Out of Order";
               "Not Clean":=true;
               Modify;
               Facilityspaces.Reset;
               Facilityspaces.SetRange(Facilityspaces."Facility Code","Facility Code");
               if Facilityspaces.Find('-') then begin
                repeat
                  begin
                    Facilityspaces.Status:=Facilityspaces.Status::"3";
                    Facilityspaces."Black List reason":='Pending Cleaning';
                    Facilityspaces.Modify;
                  end;
                until Facilityspaces.Next=0;
               end;
               Message('The Facility has been successfully cleared and Pending Cleaning.');
    end;
}

