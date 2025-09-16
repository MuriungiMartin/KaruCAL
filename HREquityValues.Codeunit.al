#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50135 "HR Equity Values"
{

    trigger OnRun()
    begin
    end;

    var
        Equity: Record UnknownRecord61196;
        OK: Boolean;
        Find: Boolean;
        Employee: Record UnknownRecord61188;


    procedure CalculateValues(Gender: Text[30];Race: Text[30];OccuCat: Text[30];StartDate: Date;EndDate: Date) Total: Integer
    begin
        /*Equity.RESET;
        Find := Equity.FIND('-');
        IF Find THEN BEGIN
          OK := Employee.GET(Equity."Employee No.");
          IF OK THEN BEGIN
             Equity.SETFILTER(Equity.Date,'>%1',StartDate);
             Equity.SETFILTER(Equity.Date,'<%1',EndDate);
             Equity.SETFILTER(Equity.Gender,'=%1',Gender);
             Equity.SETFILTER(Equity."Ethnic Origin",'=%1',Format(Race));
             Equity.SETFILTER(Equity."Occupational Category",'=%1',Format(OccuCat));
             Total := Equity.COUNT;
          END;
        END;
         */

    end;
}

