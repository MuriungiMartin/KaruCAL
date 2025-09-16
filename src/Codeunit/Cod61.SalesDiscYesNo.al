#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 61 "Sales-Disc. (Yes/No)"
{
    TableNo = "Sales Line";

    trigger OnRun()
    begin
        SalesLine.Copy(Rec);
        with SalesLine do begin
          if Confirm(Text000,false) then
            Codeunit.Run(Codeunit::"Sales-Calc. Discount",SalesLine);
        end;
        Rec := SalesLine;
    end;

    var
        Text000: label 'Do you want to calculate the invoice discount?';
        SalesLine: Record "Sales Line";
}

