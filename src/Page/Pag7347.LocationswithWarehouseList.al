#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7347 "Locations with Warehouse List"
{
    Caption = 'Locations with Warehouse List';
    CardPageID = "Location Card";
    Editable = false;
    PageType = List;
    SourceTable = Location;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a location code for the warehouse or distribution center where your items are handled and stored before being sold.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name or address of the location.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                separator(Action7301)
                {
                }
                action("&Zones")
                {
                    ApplicationArea = Basic;
                    Caption = '&Zones';
                    Image = Zones;
                    RunObject = Page Zones;
                    RunPageLink = "Location Code"=field(Code);
                }
                action("&Bins")
                {
                    ApplicationArea = Basic;
                    Caption = '&Bins';
                    Image = Bins;
                    RunObject = Page Bins;
                    RunPageLink = "Location Code"=field(Code);
                }
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if Find(Which) then begin
          Location := Rec;
          while true do begin
            if WMSMgt.LocationIsAllowed(Code) then
              exit(true);
            if Next(1) = 0 then begin
              Rec := Location;
              if Find(Which) then
                while true do begin
                  if WMSMgt.LocationIsAllowed(Code) then
                    exit(true);
                  if Next(-1) = 0 then
                    exit(false);
                end;
            end;
          end;
        end;
        exit(false);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        RealSteps: Integer;
        NextSteps: Integer;
    begin
        if Steps = 0 then
          exit;

        Location := Rec;
        repeat
          NextSteps := Next(Steps / Abs(Steps));
          if WMSMgt.LocationIsAllowed(Code) then begin
            RealSteps := RealSteps + NextSteps;
            Location := Rec;
          end;
        until (NextSteps = 0) or (RealSteps = Steps);
        Rec := Location;
        Find;
        exit(RealSteps);
    end;

    var
        Location: Record Location;
        WMSMgt: Codeunit "WMS Management";
}

