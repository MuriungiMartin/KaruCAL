#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5613 "Calculate Acq. Cost Depr."
{
    Permissions = TableData "FA Ledger Entry"=rimd;

    trigger OnRun()
    begin
    end;

    var
        Text000: label '%1 field must not have a check mark because %2 is zero or negative for %3.';


    procedure DeprCalc(var DeprAmount: Decimal;var Custom1Amount: Decimal;FANo: Code[20];DeprBookCode: Code[10];LocalDeprBasis: Decimal;Custom1LocalDeprBasis: Decimal)
    var
        DeprBook: Record "Depreciation Book";
        FADeprBook: Record "FA Depreciation Book";
        DepreciationCalc: Codeunit "Depreciation Calculation";
        DeprBasis: Decimal;
    begin
        DeprAmount := 0;
        Custom1Amount := 0;
        DeprBook.Get(DeprBookCode);
        with FADeprBook do begin
          if not Get(FANo,DeprBookCode) then
            exit;
          CalcFields(Depreciation,"Acquisition Cost","Depreciable Basis");
          DeprBasis := "Depreciable Basis" - LocalDeprBasis;
          if DeprBasis <= 0 then
            CreateError(FANo,DeprBookCode);
          if DeprBasis > 0 then
            DeprAmount :=
              DepreciationCalc.CalcRounding(
                DeprBookCode,(Depreciation * LocalDeprBasis) / DeprBasis);
          if DeprBook."Use Custom 1 Depreciation" and
             ("Depr. Ending Date (Custom 1)" > 0D)
          then begin
            DeprBasis := "Acquisition Cost" - Custom1LocalDeprBasis;
            CalcFields("Custom 1");
            if DeprBasis <= 0 then
              CreateError(FANo,DeprBookCode);
            if DeprBasis > 0 then
              Custom1Amount :=
                DepreciationCalc.CalcRounding(
                  DeprBookCode,("Custom 1" * Custom1LocalDeprBasis) / DeprBasis);
          end;
        end;
    end;

    local procedure CreateError(FANo: Code[20];DeprBookCode: Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line";
        FA: Record "Fixed Asset";
        FADeprBook: Record "FA Depreciation Book";
        DepreciationCalc: Codeunit "Depreciation Calculation";
    begin
        FA."No." := FANo;
        Error(
          Text000,
          GenJnlLine.FieldCaption("Depr. Acquisition Cost"),
          FADeprBook.FieldCaption("Depreciable Basis"),DepreciationCalc.FAName(FA,DeprBookCode));
    end;
}

