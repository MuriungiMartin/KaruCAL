#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5837 "Additional-Currency Management"
{

    trigger OnRun()
    begin
    end;

    var
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        GLSetupRead: Boolean;
        CurrencyRead: Boolean;

    local procedure InitCodeunit(): Boolean
    begin
        if not GLSetupRead then begin
          GLSetup.Get;
          GLSetupRead := true;
        end;
        if GLSetup."Additional Reporting Currency" = '' then
          exit;
        if not CurrencyRead then begin
          Currency.Get(GLSetup."Additional Reporting Currency");
          Currency.TestField("Unit-Amount Rounding Precision");
          Currency.TestField("Amount Rounding Precision");
          CurrencyRead := true;
        end;
        exit(true);
    end;


    procedure CalcACYAmt(Amount: Decimal;PostingDate: Date;IsUnitAmount: Boolean): Decimal
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if not InitCodeunit then
          exit;
        exit(
          RoundACYAmt(
            CurrExchRate.ExchangeAmtLCYToFCY(
              PostingDate,GLSetup."Additional Reporting Currency",Amount,
              CurrExchRate.ExchangeRate(PostingDate,GLSetup."Additional Reporting Currency")),
            IsUnitAmount));
    end;

    local procedure RoundACYAmt(UnroundedACYAmt: Decimal;IsUnitAmount: Boolean): Decimal
    var
        RndgPrec: Decimal;
    begin
        if not InitCodeunit then
          exit;
        if IsUnitAmount then
          RndgPrec := Currency."Unit-Amount Rounding Precision"
        else
          RndgPrec := Currency."Amount Rounding Precision";
        exit(ROUND(UnroundedACYAmt,RndgPrec));
    end;
}

