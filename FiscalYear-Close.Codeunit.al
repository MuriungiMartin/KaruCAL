#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6 "Fiscal Year-Close"
{
    TableNo = "Accounting Period";

    trigger OnRun()
    begin
        AccountingPeriod.Copy(Rec);
        Code;
        Rec := AccountingPeriod;
    end;

    var
        Text001: label 'You must create a new fiscal year before you can close the old year.';
        Text002: label 'This function closes the fiscal year from %1 to %2. ';
        Text003: label 'Once the fiscal year is closed it cannot be opened again, and the periods in the fiscal year cannot be changed.\\';
        Text004: label 'Do you want to close the fiscal year?';
        AccountingPeriod: Record "Accounting Period";
        AccountingPeriod2: Record "Accounting Period";
        AccountingPeriod3: Record "Accounting Period";
        FiscalYearStartDate: Date;
        FiscalYearEndDate: Date;

    local procedure "Code"()
    begin
        with AccountingPeriod do begin
          AccountingPeriod2.SetRange(Closed,false);
          AccountingPeriod2.Find('-');

          FiscalYearStartDate := AccountingPeriod2."Starting Date";
          AccountingPeriod := AccountingPeriod2;
          TestField("New Fiscal Year",true);

          AccountingPeriod2.SetRange("New Fiscal Year",true);
          if AccountingPeriod2.Find('>') then begin
            FiscalYearEndDate := CalcDate('<-1D>',AccountingPeriod2."Starting Date");

            AccountingPeriod3 := AccountingPeriod2;
            AccountingPeriod2.SetRange("New Fiscal Year");
            AccountingPeriod2.Find('<');
          end else
            Error(Text001);

          if not
             Confirm(
               Text002 +
               Text003 +
               Text004,false,
               FiscalYearStartDate,FiscalYearEndDate)
          then
            exit;

          Reset;

          SetRange("Starting Date",FiscalYearStartDate,AccountingPeriod2."Starting Date");
          ModifyAll(Closed,true);

          SetRange("Starting Date",FiscalYearStartDate,AccountingPeriod3."Starting Date");
          ModifyAll("Date Locked",true);

          Reset;
        end;
    end;
}

