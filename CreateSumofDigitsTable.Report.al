#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5683 "Create Sum of Digits Table"
{
    Caption = 'Create Sum of Digits Table';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfYears;NoOfYears)
                    {
                        ApplicationArea = FixedAssets;
                        BlankZero = true;
                        Caption = 'No. of Years';
                        MinValue = 0;
                        ToolTip = 'Specifies the number of years over which the fixed asset will be depreciated.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if NoOfYears < 1 then
          Error(Text000);
        if NoOfYears >= 200 then
          Error(Text001);

        CreateDeprTableLines(DeprTableCode,NoOfYears);
    end;

    var
        NoOfYears: Integer;
        DeprTableCode: Code[20];
        Text000: label 'You must specify No. of Years.';
        Text001: label 'No. of Years must be less than 200.';


    procedure SetTableCode(DeprTableCode2: Code[20])
    begin
        DeprTableCode := DeprTableCode2;
    end;

    local procedure CreateDeprTableLines(DeprTableCode: Code[10];NoOfYears: Integer)
    var
        DeprTableHeader: Record "Depreciation Table Header";
        DeprTableLine: Record "Depreciation Table Line";
        TotalDigitSum: Integer;
        TotalPercentSum: Decimal;
        CurrentDigit: Integer;
        CurrentDigitSum: Integer;
    begin
        DeprTableHeader.Get(DeprTableCode);
        DeprTableHeader."Period Length" := DeprTableHeader."period length"::Year;
        DeprTableHeader."Total No. of Units" := 0;
        DeprTableLine.SetRange("Depreciation Table Code",DeprTableCode);
        DeprTableLine.DeleteAll;
        DeprTableHeader.Modify;

        Clear(DeprTableLine);
        DeprTableLine."Depreciation Table Code" := DeprTableCode;
        DeprTableLine."Period No." := 0;
        TotalDigitSum := 0;
        CurrentDigitSum := 0;
        TotalPercentSum := 0;
        for CurrentDigit := 1 to NoOfYears do
          TotalDigitSum := TotalDigitSum + CurrentDigit;
        for CurrentDigit := NoOfYears downto 1 do begin
          DeprTableLine."Period Depreciation %" := ROUND((CurrentDigit + CurrentDigitSum) / TotalDigitSum * 100,0.00000001) -
            TotalPercentSum;
          CurrentDigitSum := CurrentDigitSum + CurrentDigit;
          TotalPercentSum := TotalPercentSum + DeprTableLine."Period Depreciation %";
          DeprTableLine."Period No." := DeprTableLine."Period No." + 1;
          DeprTableLine.Insert;
        end;
    end;
}

