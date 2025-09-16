#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5916 "Service Hours"
{
    Caption = 'Service Hours';
    DataCaptionFields = "Service Contract No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Service Hour";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Service Contract No.";"Service Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service contract to which the service hours apply.';
                    Visible = false;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service hours become valid.';
                }
                field(Day;Day)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the day when the service hours are valid.';
                }
                field("Starting Time";"Starting Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting time of the service hours.';
                }
                field("Ending Time";"Ending Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ending time of the service hours.';
                }
                field("Valid on Holidays";"Valid on Holidays")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that service hours are valid on holidays.';
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Copy Default Service Hours")
                {
                    ApplicationArea = Basic;
                    Caption = '&Copy Default Service Hours';
                    Image = CopyServiceHours;

                    trigger OnAction()
                    begin
                        CopyDefaultServiceHours;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := false;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        Clear(Weekdays);
        EntryMissing := false;

        ServHour.Reset;
        case "Service Contract Type" of
          "service contract type"::Quote:
            ServHour.SetRange("Service Contract Type","service contract type"::Quote);
          "service contract type"::Contract:
            ServHour.SetRange("Service Contract Type","service contract type"::Contract);
        end;
        ServHour.SetRange("Service Contract No.","Service Contract No.");
        if ServHour.Find('-') then begin
          repeat
            Weekdays[ServHour.Day + 1] := true;
          until ServHour.Next = 0;

          for i := 1 to 5 do begin
            if not Weekdays[i] then
              EntryMissing := true;
          end;

          if EntryMissing then
            if not Confirm(Text000)
            then
              exit(false);
        end;
    end;

    var
        Text000: label 'You have not specified service hours for all working days.\\Do you want to close the window?';
        ServHour: Record "Service Hour";
        Weekdays: array [7] of Boolean;
        EntryMissing: Boolean;
        i: Integer;
}

