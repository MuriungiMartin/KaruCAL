#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 950 "Create Time Sheets"
{
    Caption = 'Create Time Sheets';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number);
            column(ReportForNavId_5444; 5444)
            {
            }
            dataitem(Resource;Resource)
            {
                DataItemTableView = where("Use Time Sheet"=const(true));
                RequestFilterFields = "No.",Type;
                column(ReportForNavId_5508; 5508)
                {
                }

                trigger OnAfterGetRecord()
                var
                    TimeSheetMgt: Codeunit "Time Sheet Management";
                begin
                    if CheckExistingPeriods then begin
                      TimeSheetHeader.Init;
                      TimeSheetHeader."No." := NoSeriesMgt.GetNextNo(ResourcesSetup."Time Sheet Nos.",Today,true);
                      TimeSheetHeader."Starting Date" := StartingDate;
                      TimeSheetHeader."Ending Date" := EndingDate;
                      TimeSheetHeader.Validate("Resource No.","No.");
                      TimeSheetHeader.Insert(true);
                      TimeSheetCounter += 1;

                      if CreateLinesFromJobPlanning then
                        TimeSheetMgt.CreateLinesFromJobPlanning(TimeSheetHeader);
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    StartingDate := CalcDate('<1W>',StartingDate);
                end;

                trigger OnPreDataItem()
                begin
                    if HidResourceFilter <> '' then
                      SetFilter("No.",HidResourceFilter);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                EndingDate := CalcDate('<1W>',StartingDate) - 1;
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number,1,NoOfPeriods);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate;StartingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date';

                        trigger OnValidate()
                        begin
                            ValidateStartingDate;
                        end;
                    }
                    field(NoOfPeriods;NoOfPeriods)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Periods';
                        MinValue = 1;
                    }
                    field(CreateLinesFromJobPlanning;CreateLinesFromJobPlanning)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Create Lines From Job Planning';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            TimeSheetMgt: Codeunit "Time Sheet Management";
        begin
            if NoOfPeriods = 0 then
              NoOfPeriods := 1;

            if TimeSheetHeader.FindLast then
              StartingDate := TimeSheetHeader."Ending Date" + 1
            else
              StartingDate := TimeSheetMgt.FindNearestTimeSheetStartDate(WorkDate);
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        ResourcesSetup.Get;
    end;

    trigger OnPostReport()
    begin
        if not HideDialog then
          Message(Text003,TimeSheetCounter);
    end;

    trigger OnPreReport()
    var
        UserSetup: Record "User Setup";
        i: Integer;
        LastDate: Date;
        FirstAccPeriodStartingDate: Date;
        LastAccPeriodStartingDate: Date;
    begin
        UserSetup.Get(UserId);

        if not UserSetup."Time Sheet Admin." then
          Error(Text002);

        if StartingDate = 0D then
          Error(Text004,Text005);

        if NoOfPeriods = 0 then
          Error(Text004,Text006);

        ResourcesSetup.TestField("Time Sheet Nos.");

        EndingDate := CalcDate('<1W>',StartingDate);

        LastDate := StartingDate;
        for i := 1 to NoOfPeriods do
          LastDate := CalcDate('<1W>',LastDate);

        AccountingPeriod.SetFilter("Starting Date",'..%1',StartingDate);
        AccountingPeriod.FindLast;
        FirstAccPeriodStartingDate := AccountingPeriod."Starting Date";

        AccountingPeriod.SetFilter("Starting Date",'..%1',LastDate);
        AccountingPeriod.FindLast;
        LastAccPeriodStartingDate := AccountingPeriod."Starting Date";

        AccountingPeriod.SetRange("Starting Date",FirstAccPeriodStartingDate,LastAccPeriodStartingDate);
        AccountingPeriod.FindSet;
        repeat
          AccountingPeriod.TestField(Closed,false);
        until AccountingPeriod.Next = 0;
    end;

    var
        AccountingPeriod: Record "Accounting Period";
        ResourcesSetup: Record "Resources Setup";
        TimeSheetHeader: Record "Time Sheet Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HidResourceFilter: Code[250];
        StartingDate: Date;
        EndingDate: Date;
        TimeSheetCounter: Integer;
        NoOfPeriods: Integer;
        CreateLinesFromJobPlanning: Boolean;
        Text002: label 'Time sheet administrator only is allowed to create time sheets.';
        Text003: label '%1 time sheets have been created.';
        Text004: label '%1 must be filled in.';
        Text005: label 'Starting Date';
        Text006: label 'No. of Periods';
        Text010: label 'Starting Date must be %1.';
        HideDialog: Boolean;


    procedure InitParameters(NewStartingDate: Date;NewNoOfPeriods: Integer;NewResourceFilter: Code[250];NewCreateLinesFromJobPlanning: Boolean;NewHideDialog: Boolean)
    begin
        ClearAll;
        ResourcesSetup.Get;
        StartingDate := NewStartingDate;
        NoOfPeriods := NewNoOfPeriods;
        HidResourceFilter := NewResourceFilter;
        CreateLinesFromJobPlanning := NewCreateLinesFromJobPlanning;
        HideDialog := NewHideDialog;
    end;

    local procedure CheckExistingPeriods(): Boolean
    begin
        TimeSheetHeader.SetRange("Resource No.",Resource."No.");
        TimeSheetHeader.SetRange("Starting Date",StartingDate);
        TimeSheetHeader.SetRange("Ending Date",EndingDate);
        if TimeSheetHeader.FindFirst then
          exit(false);

        exit(true);
    end;

    local procedure ValidateStartingDate()
    begin
        if Date2dwy(StartingDate,1) <> ResourcesSetup."Time Sheet First Weekday" + 1 then
          Error(Text010,ResourcesSetup."Time Sheet First Weekday");
    end;
}

