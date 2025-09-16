#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7356 "Whse. Internal Put-away List"
{
    ApplicationArea = Basic;
    Caption = 'Whse. Internal Put-away List';
    CardPageID = "Whse. Internal Put-away";
    DataCaptionFields = "No.";
    Editable = false;
    PageType = List;
    SourceTable = "Whse. Internal Put-away Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the internal put-away header that was created.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location where the internal put-away is being performed.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Sorting Method";"Sorting Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the method by which the warehouse internal put-always are sorted.';
                }
                field("From Zone Code";"From Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the zone from which the items to be put away should be taken.';
                    Visible = false;
                }
                field("From Bin Code";"From Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the bin from which the items to be put away should be taken.';
                    Visible = false;
                }
                field("Document Status";"Document Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the internal put-away.';
                    Visible = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the internal put-away.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the due date of the internal put-away.';
                    Visible = false;
                }
                field("Assignment Date";"Assignment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the document was assigned to the user.';
                    Visible = false;
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Put-away")
            {
                Caption = '&Put-away';
                Image = CreatePutAway;
                action(List)
                {
                    ApplicationArea = Basic;
                    Caption = 'List';
                    Image = OpportunitiesList;
                    ShortCutKey = 'Shift+Ctrl+L';

                    trigger OnAction()
                    begin
                        LookupInternalPutAwayHeader(Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Internal Put-away"),
                                  Type=const(" "),
                                  "No."=field("No.");
                }
                action("Put-away Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Put-away Lines';
                    Image = PutawayLines;
                    RunObject = Page "Warehouse Activity Lines";
                    RunPageLink = "Whse. Document Type"=const("Internal Put-away"),
                                  "Whse. Document No."=field("No.");
                    RunPageView = sorting("Whse. Document No.","Whse. Document Type","Activity Type")
                                  where("Activity Type"=const("Put-away"));
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Whse. Internal Put-away",Rec);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Re&lease")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseWhseInternalPutAway: Codeunit "Whse. Int. Put-away Release";
                    begin
                        if Status = Status::Open then
                          ReleaseWhseInternalPutAway.Release(Rec);
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&open';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseWhseInternalPutaway: Codeunit "Whse. Int. Put-away Release";
                    begin
                        ReleaseWhseInternalPutaway.Reopen(Rec);
                    end;
                }
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if Find(Which) then begin
          WhseInternalPutawayHeader := Rec;
          while true do begin
            if WMSMgt.LocationIsAllowed("Location Code") then
              exit(true);
            if Next(1) = 0 then begin
              Rec := WhseInternalPutawayHeader;
              if Find(Which) then
                while true do begin
                  if WMSMgt.LocationIsAllowed("Location Code") then
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
        Nextsteps: Integer;
        Realsteps: Integer;
    begin
        if Steps = 0 then
          exit;

        WhseInternalPutawayHeader := Rec;
        repeat
          Nextsteps := Next(Steps / Abs(Steps));
          if WMSMgt.LocationIsAllowed("Location Code") then begin
            Realsteps := Realsteps + Nextsteps;
            WhseInternalPutawayHeader := Rec;
          end;
        until (Nextsteps = 0) or (Realsteps = Steps);
        Rec := WhseInternalPutawayHeader;
        Find;
        exit(Realsteps);
    end;

    var
        WhseInternalPutawayHeader: Record "Whse. Internal Put-away Header";
        WMSMgt: Codeunit "WMS Management";
}

