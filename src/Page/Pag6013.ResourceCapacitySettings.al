#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6013 "Resource Capacity Settings"
{
    Caption = 'Resource Capacity Settings';
    PageType = Card;
    SourceTable = Resource;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(StartDate;StartDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Starting Date';
                }
                field(EndDate;EndDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ending Date';

                    trigger OnValidate()
                    begin
                        if StartDate > EndDate then
                          Error(Text000);
                    end;
                }
                field(WorkTemplateCode;WorkTemplateCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Work-Hour Template';
                    LookupPageID = "Work-Hour Templates";
                    TableRelation = "Work-Hour Template";

                    trigger OnValidate()
                    begin
                        WorkTemplateCodeOnAfterValidat;
                    end;
                }
                field("WorkTemplateRec.Monday";WorkTemplateRec.Monday)
                {
                    ApplicationArea = Basic;
                    Caption = 'Monday';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        WorkTemplateRecMondayOnAfterVa;
                    end;
                }
                field("WorkTemplateRec.Tuesday";WorkTemplateRec.Tuesday)
                {
                    ApplicationArea = Basic;
                    Caption = 'Tuesday';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        WorkTemplateRecTuesdayOnAfterV;
                    end;
                }
                field("WorkTemplateRec.Wednesday";WorkTemplateRec.Wednesday)
                {
                    ApplicationArea = Basic;
                    Caption = 'Wednesday';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        WorkTemplateRecWednesdayOnAfte;
                    end;
                }
                field("WorkTemplateRec.Thursday";WorkTemplateRec.Thursday)
                {
                    ApplicationArea = Basic;
                    Caption = 'Thursday';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        WorkTemplateRecThursdayOnAfter;
                    end;
                }
                field("WorkTemplateRec.Friday";WorkTemplateRec.Friday)
                {
                    ApplicationArea = Basic;
                    Caption = 'Friday';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        WorkTemplateRecFridayOnAfterVa;
                    end;
                }
                field("WorkTemplateRec.Saturday";WorkTemplateRec.Saturday)
                {
                    ApplicationArea = Basic;
                    Caption = 'Saturday';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        WorkTemplateRecSaturdayOnAfter;
                    end;
                }
                field("WorkTemplateRec.Sunday";WorkTemplateRec.Sunday)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sunday';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        WorkTemplateRecSundayOnAfterVa;
                    end;
                }
                field(WeekTotal;WeekTotal)
                {
                    ApplicationArea = Basic;
                    Caption = 'Week Total';
                    DecimalPlaces = 0:5;
                    Editable = false;
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
            action(UpdateCapacity)
            {
                ApplicationArea = Basic;
                Caption = 'Update &Capacity';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    NewCapacity: Decimal;
                begin
                    if StartDate = 0D then
                      Error(Text002);

                    if EndDate = 0D then
                      Error(Text003);

                    if not Confirm(Text004,false,TableCaption,"No.") then
                      exit;

                    if CompanyInformation.Get then
                      if CompanyInformation."Base Calendar Code" <> '' then
                        CalendarCustomized :=
                          CalendarMgmt.CustomizedChangesExist(CalChange."source type"::Company,'','',CompanyInformation."Base Calendar Code");

                    ResCapacityEntry.Reset;
                    ResCapacityEntry.SetCurrentkey("Resource No.",Date);
                    ResCapacityEntry.SetRange("Resource No.","No.");
                    TempDate := StartDate;
                    ChangedDays := 0;
                    repeat
                      if CalendarCustomized then
                        Holiday :=
                          CalendarMgmt.CheckCustomizedDateStatus(
                            CalChange."source type"::Company,'','',CompanyInformation."Base Calendar Code",TempDate,NewDescription)
                      else
                        Holiday := CalendarMgmt.CheckDateStatus(CompanyInformation."Base Calendar Code",TempDate,NewDescription);

                      ResCapacityEntry.SetRange(Date,TempDate);
                      ResCapacityEntry.CalcSums(Capacity);
                      TempCapacity := ResCapacityEntry.Capacity;

                      if Holiday then
                        if TempCapacity = 0 then
                          NewCapacity := 0
                        else begin
                          // post reverse capacity entry to have zero balance
                          NewCapacity := SelectCapacity;
                          if NewCapacity > TempCapacity then
                            NewCapacity := TempCapacity;
                        end
                      else
                        NewCapacity := TempCapacity - SelectCapacity;

                      if NewCapacity <> 0 then begin
                        ResCapacityEntry2.Reset;
                        if ResCapacityEntry2.FindLast then;
                        LastEntry := ResCapacityEntry2."Entry No." + 1;
                        ResCapacityEntry2.Reset;
                        ResCapacityEntry2."Entry No." := LastEntry;
                        ResCapacityEntry2.Capacity := -NewCapacity;
                        ResCapacityEntry2."Resource No." := "No.";
                        ResCapacityEntry2."Resource Group No." := "Resource Group No.";
                        ResCapacityEntry2.Date := TempDate;
                        if ResCapacityEntry2.Insert(true) then;
                        ChangedDays := ChangedDays + 1;
                      end;
                      TempDate := TempDate + 1;
                    until TempDate > EndDate;
                    Commit;
                    if ChangedDays > 1 then
                      Message(Text006,ChangedDays)
                    else
                      if ChangedDays = 1 then
                        Message(Text007,ChangedDays)
                      else
                        Message(Text008);
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not WorkTemplateRec.Get(WorkTemplateCode) and ("No." <> xRec."No.") then
          Clear(WorkTemplateRec);
        SumWeekTotal;
    end;

    trigger OnOpenPage()
    begin
        StartDate := 0D;
        EndDate := 0D;
        WorkTemplateCode := '';
    end;

    var
        Text000: label 'The starting date is later than the ending date.';
        Text002: label 'You must fill in the Starting Date field.';
        Text003: label 'You must fill in the Ending Date field.';
        Text004: label 'Do you want to change the capacity for %1 %2?', Comment='Do you want to change the capacity for NO No.?';
        Text006: label 'The capacity for %1 days was changed successfully.';
        Text007: label 'The capacity for %1 day was changed successfully.';
        Text008: label 'The capacity change was unsuccessful.';
        CalChange: Record "Customized Calendar Change";
        WorkTemplateRec: Record "Work-Hour Template";
        ResCapacityEntry: Record "Res. Capacity Entry";
        CompanyInformation: Record "Company Information";
        ResCapacityEntry2: Record "Res. Capacity Entry";
        CalendarMgmt: Codeunit "Calendar Management";
        WorkTemplateCode: Code[10];
        StartDate: Date;
        EndDate: Date;
        WeekTotal: Decimal;
        TempDate: Date;
        TempCapacity: Decimal;
        ChangedDays: Integer;
        LastEntry: Decimal;
        CalendarCustomized: Boolean;
        Holiday: Boolean;
        NewDescription: Text[50];

    local procedure SelectCapacity() Hours: Decimal
    begin
        case Date2dwy(TempDate,1) of
          1:
            Hours := WorkTemplateRec.Monday;
          2:
            Hours := WorkTemplateRec.Tuesday;
          3:
            Hours := WorkTemplateRec.Wednesday;
          4:
            Hours := WorkTemplateRec.Thursday;
          5:
            Hours := WorkTemplateRec.Friday;
          6:
            Hours := WorkTemplateRec.Saturday;
          7:
            Hours := WorkTemplateRec.Sunday;
        end;
    end;

    local procedure SumWeekTotal()
    begin
        WeekTotal := WorkTemplateRec.Monday + WorkTemplateRec.Tuesday + WorkTemplateRec.Wednesday +
          WorkTemplateRec.Thursday + WorkTemplateRec.Friday + WorkTemplateRec.Saturday + WorkTemplateRec.Sunday;
    end;

    local procedure WorkTemplateCodeOnAfterValidat()
    begin
        if WorkTemplateRec.Get(WorkTemplateCode) then;
        SumWeekTotal;
    end;

    local procedure WorkTemplateRecMondayOnAfterVa()
    begin
        SumWeekTotal;
    end;

    local procedure WorkTemplateRecTuesdayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure WorkTemplateRecWednesdayOnAfte()
    begin
        SumWeekTotal;
    end;

    local procedure WorkTemplateRecThursdayOnAfter()
    begin
        SumWeekTotal;
    end;

    local procedure WorkTemplateRecFridayOnAfterVa()
    begin
        SumWeekTotal;
    end;

    local procedure WorkTemplateRecSaturdayOnAfter()
    begin
        SumWeekTotal;
    end;

    local procedure WorkTemplateRecSundayOnAfterVa()
    begin
        SumWeekTotal;
    end;
}

