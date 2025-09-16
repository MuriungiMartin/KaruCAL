#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 130440 "Library - Random"
{
    // Pseudo random number generator.

    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        Seed: Integer;


    procedure RandDec(Range: Integer;Decimals: Integer): Decimal
    begin
        exit(RandInt(Range * Power(10,Decimals)) / Power(10,Decimals));
    end;


    procedure RandDecInRange("Min": Integer;"Max": Integer;Decimals: Integer): Decimal
    begin
        // Returns a pseudo random decimal in the interval (Min,Max]
        exit(Min + RandDec(Max - Min,Decimals));
    end;


    procedure RandDecInDecimalRange("Min": Decimal;"Max": Decimal;Precision: Integer): Decimal
    var
        Min2: Integer;
        Max2: Integer;
        Pow: Integer;
    begin
        Pow := Power(10,Precision);
        Min2 := ROUND(Min * Pow,1,'>');
        Max2 := ROUND(Max * Pow,1,'<');
        exit(RandIntInRange(Min2,Max2) / Pow);
    end;


    procedure RandInt(Range: Integer): Integer
    begin
        // Returns a pseudo random integer in the interval [1,Range]
        if Range < 1 then
          exit(1);
        exit(1 + ROUND(Uniform * (Range - 1),1));
    end;


    procedure RandIntInRange("Min": Integer;"Max": Integer): Integer
    begin
        exit(Min - 1 + RandInt(Max - Min + 1));
    end;


    procedure RandDate(Delta: Integer): Date
    begin
        if Delta = 0 then
          exit(WorkDate);
        exit(CalcDate(StrSubstNo('<%1D>',Delta / Abs(Delta) * RandInt(Abs(Delta))),WorkDate));
    end;


    procedure RandDateFrom(FromDate: Date;Range: Integer): Date
    begin
        if Range = 0 then
          exit(FromDate);
        exit(CalcDate(StrSubstNo('<%1D>',Range / Abs(Range) * RandInt(Range)),FromDate));
    end;


    procedure RandDateFromInRange(FromDate: Date;FromRange: Integer;ToRange: Integer): Date
    begin
        if FromRange >= ToRange then
          exit(FromDate);
        exit(CalcDate(StrSubstNo('<+%1D>',RandIntInRange(FromRange,ToRange)),FromDate));
    end;


    procedure RandPrecision(): Decimal
    begin
        exit(1 / Power(10,RandInt(5)));
    end;


    procedure Init(): Integer
    begin
        // Updates the seed from the current time
        exit(SetSeed(Time - 000000T));
    end;


    procedure SetSeed(Val: Integer): Integer
    begin
        // Set the random seed to reproduce pseudo random sequence
        Seed := Val;
        Seed := Seed MOD 10000;  // Overflow protection
        exit(Seed);
    end;

    local procedure UpdateSeed()
    begin
        // Generates a new seed value and
        Seed := Seed + 3;
        Seed := Seed * 3;
        Seed := Seed * Seed;
        Seed := Seed MOD 10000;  // Overflow protection
    end;

    local procedure Uniform(): Decimal
    begin
        // Generates a pseudo random uniform number
        UpdateSeed;

        exit((Seed MOD 137) / 137);
    end;
}

