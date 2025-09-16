#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 867 "CF Availability by Periods"
{
    Caption = 'CF Availability by Periods';
    InsertAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    SourceTable = "Cash Flow Forecast";

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Manual Payments From";"Manual Payments From")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies a starting date from which manual payments should be included in cash flow forecast.';
                }
                field("Manual Payments To";"Manual Payments To")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'To';
                    Editable = false;
                }
                field(LiquidFunds;LiquidFunds)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = MatrixMgt.GetFormatString(RoundingFactor,false);
                    AutoFormatType = 10;
                    Caption = 'Liquid Funds';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDownEntriesFromSource("source type filter"::"Liquid Funds");
                    end;
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date that the forecast was created.';
                }
                field(RoundingFactor;RoundingFactor)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Rounding Factor';
                    OptionCaption = 'None,1,1000,1000000';

                    trigger OnValidate()
                    begin
                        UpdateSubForm;
                    end;
                }
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Period';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        UpdateSubForm;
                    end;
                }
                field(AmountType;AmountType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View as';
                    OptionCaption = 'Net Change,Balance at Date';
                    ToolTip = 'Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.';

                    trigger OnValidate()
                    begin
                        UpdateSubForm;
                    end;
                }
            }
            part(CFAvailabLines;"Cash Flow Availability Lines")
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        UpdateSubForm;
    end;

    var
        MatrixMgt: Codeunit "Matrix Management";
        PeriodType: Option Day,Week,Month,Quarter,Year,Period;
        AmountType: Option "Net Change","Balance at Date";
        RoundingFactor: Option "None","1","1000","1000000";
        LiquidFunds: Decimal;

    local procedure UpdateSubForm()
    begin
        CurrPage.CFAvailabLines.Page.Set(Rec,PeriodType,AmountType,RoundingFactor);
        LiquidFunds := MatrixMgt.RoundValue(CalcAmountFromSource("source type filter"::"Liquid Funds"),RoundingFactor);
    end;
}

