#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7604 "Base Calendar Entries Subform"
{
    Caption = 'Lines';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Date;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(CurrentCalendarCode;CurrentCalendarCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Base Calendar Code';
                    Editable = false;
                    Visible = false;
                }
                field("Period Start";"Period Start")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date';
                    Editable = false;
                }
                field("Period Name";"Period Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Day';
                    Editable = false;
                }
                field(WeekNo;WeekNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Week No.';
                    Editable = false;
                    Visible = false;
                }
                field(Nonworking;Nonworking)
                {
                    ApplicationArea = Basic;
                    Caption = 'Nonworking';
                    Editable = true;
                    ToolTip = 'Specifies the date entry as a nonworking day. You can also remove the check mark to return the status to working day.';

                    trigger OnValidate()
                    begin
                        UpdateBaseCalendarChanges;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';

                    trigger OnValidate()
                    begin
                        UpdateBaseCalendarChanges;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Nonworking := CalendarMgmt.CheckDateStatus(CurrentCalendarCode,"Period Start",Description);
        WeekNo := Date2dwy("Period Start",2);
        CurrentCalendarCodeOnFormat;
        PeriodStartOnFormat;
        PeriodNameOnFormat;
        DescriptionOnFormat;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(PeriodFormMgt.FindDate(Which,Rec,PeriodType));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(PeriodFormMgt.NextDate(Steps,Rec,PeriodType));
    end;

    trigger OnOpenPage()
    begin
        Reset;
        SetFilter("Period Start",'>=%1',00000101D);
    end;

    var
        BaseCalendarChange: Record "Base Calendar Change";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        CalendarMgmt: Codeunit "Calendar Management";
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        Nonworking: Boolean;
        WeekNo: Integer;
        Description: Text[30];
        CurrentCalendarCode: Code[10];


    procedure SetCalendarCode(CalendarCode: Code[10])
    begin
        CurrentCalendarCode := CalendarCode;
        CurrPage.Update;
    end;

    local procedure UpdateBaseCalendarChanges()
    begin
        BaseCalendarChange.Reset;
        BaseCalendarChange.SetRange("Base Calendar Code",CurrentCalendarCode);
        BaseCalendarChange.SetRange(Date,"Period Start");
        if BaseCalendarChange.FindFirst then
          BaseCalendarChange.Delete;
        BaseCalendarChange.Init;
        BaseCalendarChange."Base Calendar Code" := CurrentCalendarCode;
        BaseCalendarChange.Date := "Period Start";
        BaseCalendarChange.Description := Description;
        BaseCalendarChange.Nonworking := Nonworking;
        BaseCalendarChange.Day := "Period No.";
        BaseCalendarChange.Insert;
    end;

    local procedure CurrentCalendarCodeOnFormat()
    begin
        if Nonworking then;
    end;

    local procedure PeriodStartOnFormat()
    begin
        if Nonworking then;
    end;

    local procedure PeriodNameOnFormat()
    begin
        if Nonworking then;
    end;

    local procedure DescriptionOnFormat()
    begin
        if Nonworking then;
    end;
}

