#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 71 "Purch.-Disc. (Yes/No)"
{
    TableNo = "Purchase Line";

    trigger OnRun()
    begin
        if Confirm(Text000,false) then
          Codeunit.Run(Codeunit::"Purch.-Calc.Discount",Rec);
    end;

    var
        Text000: label 'Do you want to calculate the invoice discount?';
}

