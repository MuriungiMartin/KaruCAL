#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6079 "Contract Amount Distribution"
{
    Caption = 'Contract Amount Distribution';
    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            field(Result;Result)
            {
                ApplicationArea = Basic;
                Caption = 'Do you want the differences to be distributed to the contract lines by';
                OptionCaption = 'Even Distribution?,Distribution Based on Profit?,Distribution Based on Line Amount?';
            }
            group(Details)
            {
                Caption = 'Details';
                InstructionalText = 'The Annual Amount and the Calcd. Annual Amount must be the same.';
                field(AnnualAmount;AnnualAmount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Annual Amount';
                    Editable = false;
                }
                field(CalcdAnnualAmount;CalcdAnnualAmount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calcd. Annual Amount';
                    Editable = false;
                }
                field(Difference;Difference)
                {
                    ApplicationArea = Basic;
                    Caption = 'Difference';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;

    var
        Result: Option "0","1","2";
        AnnualAmount: Decimal;
        CalcdAnnualAmount: Decimal;
        Difference: Decimal;


    procedure GetResult(): Integer
    begin
        exit(Result);
    end;


    procedure SetValues(AnnualAmount2: Decimal;CalcdAnnualAmount2: Decimal)
    begin
        AnnualAmount := AnnualAmount2;
        CalcdAnnualAmount := CalcdAnnualAmount2;
        Difference := AnnualAmount2 - CalcdAnnualAmount2;
    end;


    procedure SetResult(Option: Option)
    begin
        Result := Option;
    end;
}

