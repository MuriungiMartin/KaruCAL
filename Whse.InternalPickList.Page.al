#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7359 "Whse. Internal Pick List"
{
    ApplicationArea = Basic;
    Caption = 'Whse. Internal Pick List';
    CardPageID = "Whse. Internal Pick";
    DataCaptionFields = "No.";
    Editable = false;
    PageType = List;
    SourceTable = "Whse. Internal Pick Header";
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
                    ToolTip = 'Specifies the number of the warehouse internal pick header, created when you started to plan this internal pick.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location where the internal pick is being performed.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Sorting Method";"Sorting Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the method by which the warehouse internal pick lines are sorted.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates whether the internal pick is open or released.';
                }
                field("To Zone Code";"To Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the zone in which you want the items to be placed when they are picked.';
                    Visible = false;
                }
                field("To Bin Code";"To Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the bin in which you want the items to be placed when they are picked.';
                    Visible = false;
                }
                field("Document Status";"Document Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document status of the internal pick.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the due date of the document.';
                    Visible = false;
                }
                field("Assignment Date";"Assignment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the document was assigned to the user.';
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
            group("&Pick")
            {
                Caption = '&Pick';
                Image = CreateInventoryPickup;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Internal Pick"),
                                  Type=const(" "),
                                  "No."=field("No.");
                }
                action("Pick Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pick Lines';
                    Image = PickLines;
                    RunObject = Page "Warehouse Activity Lines";
                    RunPageLink = "Whse. Document Type"=const("Internal Pick"),
                                  "Whse. Document No."=field("No.");
                    RunPageView = sorting("Whse. Document No.","Whse. Document Type","Activity Type")
                                  where("Activity Type"=const(Pick));
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
                        Page.Run(Page::"Whse. Internal Pick",Rec);
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
                        ReleaseWhseInternalPick: Codeunit "Whse. Internal Pick Release";
                    begin
                        CurrPage.Update(true);
                        if Status = Status::Open then
                          ReleaseWhseInternalPick.Release(Rec);
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&open';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseWhseInternalPick: Codeunit "Whse. Internal Pick Release";
                    begin
                        ReleaseWhseInternalPick.Reopen(Rec);
                    end;
                }
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if Find(Which) then begin
          WhseInternalPickHeader := Rec;
          while true do begin
            if WMSMgt.LocationIsAllowed("Location Code") then
              exit(true);
            if Next(1) = 0 then begin
              Rec := WhseInternalPickHeader;
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
        RealSteps: Integer;
        NextSteps: Integer;
    begin
        if Steps = 0 then
          exit;

        WhseInternalPickHeader := Rec;
        repeat
          NextSteps := Next(Steps / Abs(Steps));
          if WMSMgt.LocationIsAllowed("Location Code") then begin
            RealSteps := RealSteps + NextSteps;
            WhseInternalPickHeader := Rec;
          end;
        until (NextSteps = 0) or (RealSteps = Steps);
        Rec := WhseInternalPickHeader;
        Find;
        exit(RealSteps);
    end;

    var
        WhseInternalPickHeader: Record "Whse. Internal Pick Header";
        WMSMgt: Codeunit "WMS Management";
}

