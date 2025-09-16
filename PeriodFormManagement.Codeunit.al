#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 359 PeriodFormManagement
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label '<Week>.<Year4>';
        Text001: label '<Month Text,3> <Year4>';
        Text002: label '<Quarter>/<Year4>';
        Text003: label '<Year4>';
        AccountingPeriod: Record "Accounting Period";


    procedure FindDate(SearchString: Text[3];var Calendar: Record Date;PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period"): Boolean
    var
        Found: Boolean;
    begin
        Calendar.SetRange("Period Type",PeriodType);
        Calendar."Period Type" := PeriodType;
        if Calendar."Period Start" = 0D then
          Calendar."Period Start" := WorkDate;
        if SearchString in ['','=><'] then
          SearchString := '=<>';
        if PeriodType = Periodtype::"Accounting Period" then begin
          SetAccountingPeriodFilter(Calendar);
          Found := AccountingPeriod.Find(SearchString);
          if Found then
            CopyAccountingPeriod(Calendar);
        end else begin
          Found := Calendar.Find(SearchString);
          if Found then
            Calendar."Period End" := NormalDate(Calendar."Period End");
        end;
        exit(Found);
    end;


    procedure NextDate(NextStep: Integer;var Calendar: Record Date;PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period"): Integer
    begin
        Calendar.SetRange("Period Type",PeriodType);
        Calendar."Period Type" := PeriodType;
        if PeriodType = Periodtype::"Accounting Period" then begin
          SetAccountingPeriodFilter(Calendar);
          NextStep := AccountingPeriod.Next(NextStep);
          if NextStep <> 0 then
            CopyAccountingPeriod(Calendar);
        end else begin
          NextStep := Calendar.Next(NextStep);
          if NextStep <> 0 then
            Calendar."Period End" := NormalDate(Calendar."Period End");
        end;
        exit(NextStep);
    end;


    procedure CreatePeriodFormat(PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";Date: Date): Text[10]
    begin
        case PeriodType of
          Periodtype::Day:
            exit(Format(Date));
          Periodtype::Week:
            begin
              if Date2dwy(Date,2) = 1 then
                Date := Date + 7 - Date2dwy(Date,1);
              exit(Format(Date,0,Text000));
            end;
          Periodtype::Month:
            exit(Format(Date,0,Text001));
          Periodtype::Quarter:
            exit(Format(Date,0,Text002));
          Periodtype::Year:
            exit(Format(Date,0,Text003));
          Periodtype::"Accounting Period":
            exit(Format(Date));
        end;
    end;


    procedure MoveDateByPeriod(Date: Date;PeriodType: Option;MoveByNoOfPeriods: Integer): Date
    var
        DateExpression: DateFormula;
    begin
        Evaluate(DateExpression,'<' + Format(MoveByNoOfPeriods) + GetPeriodTypeSymbol(PeriodType) + '>');
        exit(CalcDate(DateExpression,Date));
    end;


    procedure MoveDateByPeriodToEndOfPeriod(Date: Date;PeriodType: Option;MoveByNoOfPeriods: Integer): Date
    var
        DateExpression: DateFormula;
    begin
        Evaluate(DateExpression,'<' + Format(MoveByNoOfPeriods + 1) + GetPeriodTypeSymbol(PeriodType) + '-1D>');
        exit(CalcDate(DateExpression,Date));
    end;


    procedure GetPeriodTypeSymbol(PeriodType: Option): Text[1]
    var
        Date: Record Date;
    begin
        case PeriodType of
          Date."period type"::Date:
            exit('D');
          Date."period type"::Week:
            exit('W');
          Date."period type"::Month:
            exit('M');
          Date."period type"::Quarter:
            exit('Q');
          Date."period type"::Year:
            exit('Y');
        end;
    end;

    local procedure SetAccountingPeriodFilter(var Calendar: Record Date)
    begin
        AccountingPeriod.SetFilter("Starting Date",Calendar.GetFilter("Period Start"));
        AccountingPeriod.SetFilter(Name,Calendar.GetFilter("Period Name"));
        AccountingPeriod."Starting Date" := Calendar."Period Start";
    end;

    local procedure CopyAccountingPeriod(var Calendar: Record Date)
    begin
        Calendar.Init;
        Calendar."Period Start" := AccountingPeriod."Starting Date";
        Calendar."Period Name" := AccountingPeriod.Name;
        if AccountingPeriod.Next = 0 then
          Calendar."Period End" := Dmy2date(31,12,9999)
        else
          Calendar."Period End" := AccountingPeriod."Starting Date" - 1;
    end;


    procedure GetFullPeriodDateFilter(PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";DateFilter: Text): Text
    var
        AccountingPeriod: Record "Accounting Period";
        Period: Record Date;
        StartDate: Date;
        EndDate: Date;
    begin
        if DateFilter = '' then
          exit(DateFilter);

        Period.SetFilter("Period Start",DateFilter);
        StartDate := Period.GetRangeMin("Period Start");
        EndDate := Period.GetRangemax("Period Start");
        case PeriodType of
          Periodtype::Week,
          Periodtype::Month,
          Periodtype::Quarter,
          Periodtype::Year:
            begin
              Period.SetRange("Period Type",PeriodType);
              Period.SetFilter("Period Start",'<=%1',StartDate);
              Period.FindLast;
              StartDate := Period."Period Start";
              Period.SetRange("Period Start");
              Period.SetFilter("Period End",'>%1',EndDate);
              Period.FindFirst;
              EndDate := NormalDate(Period."Period End");
            end;
          Periodtype::"Accounting Period":
            begin
              AccountingPeriod.SetFilter("Starting Date",'<=%1',StartDate);
              AccountingPeriod.FindLast;
              StartDate := AccountingPeriod."Starting Date";
              AccountingPeriod.SetFilter("Starting Date",'>%1',EndDate);
              AccountingPeriod.FindFirst;
              EndDate := AccountingPeriod."Starting Date" - 1;
            end;
        end;
        Period.SetRange("Period Start",StartDate,EndDate);
        exit(Period.GetFilter("Period Start"));
    end;


    procedure FindPeriodOnMatrixPage(var DateFilter: Text;var InternalDateFilter: Text;SearchText: Text[3];PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";UpdateDateFilter: Boolean)
    var
        Item: Record Item;
        Calendar: Record Date;
    begin
        if DateFilter <> '' then begin
          Calendar.SetFilter("Period Start",DateFilter);
          if not FindDate('+',Calendar,PeriodType) then
            FindDate('+',Calendar,Periodtype::Day);
          Calendar.SetRange("Period Start");
        end;
        FindDate(SearchText,Calendar,PeriodType);
        Item.SetRange("Date Filter",Calendar."Period Start",Calendar."Period End");
        if Item.GetRangeMin("Date Filter") = Item.GetRangemax("Date Filter") then
          Item.SetRange("Date Filter",Item.GetRangeMin("Date Filter"));
        InternalDateFilter := Item.GetFilter("Date Filter");
        if UpdateDateFilter then
          DateFilter := InternalDateFilter;
    end;
}

