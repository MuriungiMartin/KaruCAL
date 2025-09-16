#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5797 "Registered Whse. Activity List"
{
    Caption = 'Registered Whse. Activity List';
    Editable = false;
    PageType = List;
    SourceTable = "Registered Whse. Activity Hdr.";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of activity that the warehouse performed on the lines attached to the header, such as put-away, pick or movement.';
                    Visible = false;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the registered warehouse activity number.';
                }
                field("Whse. Activity No.";"Whse. Activity No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the warehouse activity number from which the activity was registered.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location in which the registered warehouse activity occurred.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the employee who is responsible for the document and assigned to perform the warehouse activity.';
                }
                field("Sorting Method";"Sorting Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the method by which the lines were sorted on the warehouse header, such as by item, or bin code.';
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code used if a number was assigned to the registered warehouse activity header.';
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
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        case Type of
                          Type::"Put-away":
                            Page.Run(Page::"Registered Put-away",Rec);
                          Type::Pick:
                            Page.Run(Page::"Registered Pick",Rec);
                          Type::Movement:
                            Page.Run(Page::"Registered Movement",Rec);
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Caption := FormCaption;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if Find(Which) then begin
          RegisteredWhseActivHeader := Rec;
          while true do begin
            if WMSManagement.LocationIsAllowed("Location Code") then
              exit(true);
            if Next(1) = 0 then begin
              Rec := RegisteredWhseActivHeader;
              if Find(Which) then
                while true do begin
                  if WMSManagement.LocationIsAllowed("Location Code") then
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

        RegisteredWhseActivHeader := Rec;
        repeat
          NextSteps := Next(Steps / Abs(Steps));
          if WMSManagement.LocationIsAllowed("Location Code") then begin
            RealSteps := RealSteps + NextSteps;
            RegisteredWhseActivHeader := Rec;
          end;
        until (NextSteps = 0) or (RealSteps = Steps);
        Rec := RegisteredWhseActivHeader;
        Find;
        exit(RealSteps);
    end;

    var
        RegisteredWhseActivHeader: Record "Registered Whse. Activity Hdr.";
        WMSManagement: Codeunit "WMS Management";
        Text000: label 'Registered Whse. Put-away List';
        Text001: label 'Registered Whse. Pick List';
        Text002: label 'Registered Whse. Movement List';
        Text003: label 'Registered Whse. Activity List';

    local procedure FormCaption(): Text[250]
    begin
        case Type of
          Type::"Put-away":
            exit(Text000);
          Type::Pick:
            exit(Text001);
          Type::Movement:
            exit(Text002);
          else
            exit(Text003);
        end;
    end;
}

