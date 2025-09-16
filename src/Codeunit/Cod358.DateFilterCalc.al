#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 358 "DateFilter-Calc"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Fiscal Year %1';
        AccountingPeriod: Record "Accounting Period";
        StartDate: Date;


    procedure CreateFiscalYearFilter(var "Filter": Text[30];var Name: Text[30];Date: Date;NextStep: Integer)
    begin
        CreateAccountingDateFilter(Filter,Name,true,Date,NextStep);
    end;


    procedure CreateAccountingPeriodFilter(var "Filter": Text[30];var Name: Text[30];Date: Date;NextStep: Integer)
    begin
        CreateAccountingDateFilter(Filter,Name,false,Date,NextStep);
    end;


    procedure ConvertToUtcDateTime(LocalDateTime: DateTime): DateTime
    var
        DotNetDateTimeOffset: dotnet DateTimeOffset;
        DotNetDateTimeOffsetNow: dotnet DateTimeOffset;
    begin
        if LocalDateTime = CreateDatetime(0D,0T) then
          exit(CreateDatetime(0D,0T));

        DotNetDateTimeOffset := DotNetDateTimeOffset.DateTimeOffset(LocalDateTime);
        DotNetDateTimeOffsetNow := DotNetDateTimeOffset.Now;
        exit(DotNetDateTimeOffset.LocalDateTime - DotNetDateTimeOffsetNow.Offset);
    end;

    local procedure CreateAccountingDateFilter(var "Filter": Text[30];var Name: Text[30];FiscalYear: Boolean;Date: Date;NextStep: Integer)
    begin
        AccountingPeriod.Reset;
        if FiscalYear then
          AccountingPeriod.SetRange("New Fiscal Year",true);
        AccountingPeriod."Starting Date" := Date;
        AccountingPeriod.Find('=<>');
        if AccountingPeriod."Starting Date" > Date then
          NextStep := NextStep - 1;
        if NextStep <> 0 then
          if AccountingPeriod.Next(NextStep) <> NextStep then begin
            if NextStep < 0 then
              Filter := '..' + Format(AccountingPeriod."Starting Date" - 1)
            else
              Filter := Format(AccountingPeriod."Starting Date") + '..' + Format(Dmy2date(31,12,9999));
            Name := '...';
            exit;
          end;
        StartDate := AccountingPeriod."Starting Date";
        if FiscalYear then
          Name := StrSubstNo(Text000,Format(Date2dmy(StartDate,3)))
        else
          Name := AccountingPeriod.Name;
        if AccountingPeriod.Next <> 0 then
          Filter := Format(StartDate) + '..' + Format(AccountingPeriod."Starting Date" - 1)
        else begin
          Filter := Format(StartDate) + '..' + Format(Dmy2date(31,12,9999));
          Name := Name + '...';
        end;
    end;
}

