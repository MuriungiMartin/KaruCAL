#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5941 "ContractDiscount-Find"
{
    TableNo = "Contract/Service Discount";

    trigger OnRun()
    begin
        ContractServDiscount.Copy(Rec);

        with ContractServDiscount do begin
          SetRange("Contract Type","contract type"::Contract);
          SetRange("Contract No.","Contract No.");
          SetRange(Type,Type);
          SetFilter("No.",'%1|%2',"No.",'');
          SetRange("Starting Date",0D,"Starting Date");
          if not FindLast then
            "Discount %" := 0;
        end;

        Rec := ContractServDiscount;
    end;

    var
        ContractServDiscount: Record "Contract/Service Discount";
}

