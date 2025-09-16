#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5617 "FA Date Calculation"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'is later than %1';
        Text001: label 'It was not possible to find a %1 in %2.';
        DeprBook: Record "Depreciation Book";


    procedure GetFiscalYear(DeprBookCode: Code[10];EndingDate: Date): Date
    var
        AccountingPeriod: Record "Accounting Period";
        FAJnlLine: Record "FA Journal Line";
    begin
        with DeprBook do begin
          Get(DeprBookCode);
          if "New Fiscal Year Starting Date" > 0D then begin
            if "New Fiscal Year Starting Date" > EndingDate then
              FieldError(
                "New Fiscal Year Starting Date",
                StrSubstNo(Text000,FAJnlLine.FieldCaption("FA Posting Date")));
            exit("New Fiscal Year Starting Date");
          end;
        end;
        with AccountingPeriod do begin
          SetRange("New Fiscal Year",true);
          SetRange("Starting Date",0D,EndingDate);
          if FindLast then
            exit("Starting Date");

          Error(Text001,FieldCaption("Starting Date"),TableCaption);
        end;
    end;


    procedure CalculateDate(StartingDate: Date;NumberOfDays: Integer;Year365Days: Boolean): Date
    var
        Years: Integer;
        Days: Integer;
        Months: Integer;
        LocalDate: Date;
    begin
        if NumberOfDays <= 0 then
          exit(StartingDate);
        if Year365Days then
          exit(CalculateDate365(StartingDate,NumberOfDays));
        Years := Date2dmy(StartingDate,3);
        Months := Date2dmy(StartingDate,2);
        Days := Date2dmy(StartingDate,1);
        if Date2dmy(StartingDate + 1,1) = 1 then
          Days := 30;
        Days := Days + NumberOfDays;
        Months := Months + (Days DIV 30);
        Days := Days MOD 30;
        if Days = 0 then begin
          Days := 30;
          Months := Months - 1;
        end;
        Years := Years + (Months DIV 12);
        Months := Months MOD 12;
        if Months = 0 then begin
          Months := 12;
          Years := Years - 1;
        end;
        if (Months = 2) and (Days > 28) then begin
          Days := 28;
          LocalDate := Dmy2date(28,2,Years) + 1;
          if Date2dmy(LocalDate,1) = 29 then
            Days := 29;
        end;
        case Months of
          1,3,5,7,8,10,12:
            if Days = 30 then
              Days := 31;
        end;
        exit(Dmy2date(Days,Months,Years));
    end;

    local procedure CalculateDate365(StartingDate: Date;NumberOfDays: Integer): Date
    var
        Calendar: Record Date;
        NoOfDays: Integer;
        EndingDate: Date;
        FirstDate: Boolean;
    begin
        with Calendar do begin
          SetRange("Period Type","period type"::Date);
          SetRange("Period Start",StartingDate,Dmy2date(31,12,9999));
          NoOfDays := 1;
          FirstDate := true;
          if Find('-') then
            repeat
              if (not ((Date2dmy("Period Start",1) = 29) and (Date2dmy("Period Start",2) = 2))) or
                 FirstDate
              then
                NoOfDays := NoOfDays + 1;
              FirstDate := false;
            until (Next = 0) or (NumberOfDays < NoOfDays);
          EndingDate := "Period Start";
          if (Date2dmy(EndingDate,1) = 29) and (Date2dmy(EndingDate,2) = 2) then
            EndingDate := EndingDate + 1;
          exit(EndingDate);
        end;
    end;
}

