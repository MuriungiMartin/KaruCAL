#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60104 "Tax Calculation2"
{

    trigger OnRun()
    begin
    end;


    procedure CalculateTax(Rec: Record UnknownRecord61705;CalculationType: Option VAT,"W/Tax",Retention,PAYE) Amount: Decimal
    begin
        case CalculationType of
          Calculationtype::VAT:
            begin
                Amount:=(Rec."VAT Rate"/(100+Rec."VAT Rate"))*Rec.Amount;
            end;
          /*CalculationType::"W/Tax":
            BEGIN
                Amount:=(Rec.Amount-((Rec."VAT Rate"/(100+Rec."VAT Rate"))*Rec.Amount))
                *(Rec."W/Tax Rate"/100);
        
            END;
            */
          Calculationtype::Retention:
            begin
                Amount:=(Rec.Amount-((Rec."VAT Rate"/(100+Rec."VAT Rate"))*Rec.Amount))
                 *(Rec."Retention Rate"/100);
            end;
          Calculationtype::PAYE:
            begin
                Amount:=Rec."PAYE Amount";
                end;
        
          Calculationtype::"W/Tax":
            begin
                Amount:=Rec."Withholding Tax Amount";
        
             end;
        end;

    end;
}

