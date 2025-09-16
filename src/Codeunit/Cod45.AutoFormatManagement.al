#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 45 AutoFormatManagement
{

    trigger OnRun()
    begin
    end;

    var
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;
        Text012: label '<Precision,%1><Standard Format,0>';


    procedure AutoFormatTranslate(AutoFormatType: Integer;AutoFormatExpr: Text[80]): Text[80]
    begin
        if AutoFormatType = 0 then
          exit('');

        if not GetGLSetup then
          exit('');

        case AutoFormatType of
          1: // Amount
            begin
              if AutoFormatExpr = '' then
                exit(StrSubstNo(Text012,GLSetup."Amount Decimal Places"));
              if GetCurrency(CopyStr(AutoFormatExpr,1,10)) and
                 (Currency."Amount Decimal Places" <> '')
              then
                exit(StrSubstNo(Text012,Currency."Amount Decimal Places"));
              exit(StrSubstNo(Text012,GLSetup."Amount Decimal Places"));
            end;
          2: // Unit Amount
            begin
              if AutoFormatExpr = '' then
                exit(StrSubstNo(Text012,GLSetup."Unit-Amount Decimal Places"));
              if GetCurrency(CopyStr(AutoFormatExpr,1,10)) and
                 (Currency."Unit-Amount Decimal Places" <> '')
              then
                exit(StrSubstNo(Text012,Currency."Unit-Amount Decimal Places"));
              exit(StrSubstNo(Text012,GLSetup."Unit-Amount Decimal Places"));
            end;
          10:
            exit('<Custom,' + AutoFormatExpr + '>');
        end;
    end;


    procedure ReadRounding(): Decimal
    begin
        GetGLSetup;
        exit(GLSetup."Amount Rounding Precision");
    end;

    local procedure GetGLSetup(): Boolean
    begin
        if not GLSetupRead then
          GLSetupRead := GLSetup.Get;
        exit(GLSetupRead);
    end;

    local procedure GetCurrency(CurrencyCode: Code[10]): Boolean
    begin
        if CurrencyCode = Currency.Code then
          exit(true);
        if CurrencyCode = '' then begin
          Clear(Currency);
          Currency.InitRoundingPrecision;
          exit(true);
        end;
        exit(Currency.Get(CurrencyCode));
    end;
}

