#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 840 "CF Forecast Statistics FactBox"
{
    Caption = 'Cash Flow Forecast Statistic';
    Editable = false;
    PageType = CardPart;
    SourceTable = "Cash Flow Forecast";

    layout
    {
        area(content)
        {
            field(LiquidFunds;Amounts[CFForecastEntry."source type"::"Liquid Funds"])
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Liquid Funds';

                trigger OnDrillDown()
                begin
                    DrillDownEntriesFromSource("source type filter"::"Liquid Funds");
                end;
            }
            field(Receivables;Amounts[CFForecastEntry."source type"::Receivables])
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Receivables';

                trigger OnDrillDown()
                begin
                    DrillDownEntriesFromSource("source type filter"::Receivables);
                end;
            }
            field(SalesOrders;Amounts[CFForecastEntry."source type"::"Sales Order"])
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Orders';

                trigger OnDrillDown()
                begin
                    DrillDownEntriesFromSource("source type filter"::"Sales Order");
                end;
            }
            field(ServiceOrders;Amounts[CFForecastEntry."source type"::"Service Orders"])
            {
                ApplicationArea = Basic;
                Caption = 'Service Orders';

                trigger OnDrillDown()
                begin
                    DrillDownEntriesFromSource("source type filter"::"Service Orders");
                end;
            }
            field(SaleofFixedAssets;Amounts[CFForecastEntry."source type"::"Fixed Assets Disposal"])
            {
                ApplicationArea = Basic;
                Caption = 'Fixed Assets Disposal';

                trigger OnDrillDown()
                begin
                    DrillDownEntriesFromSource("source type filter"::"Fixed Assets Disposal");
                end;
            }
            field(ManualRevenues;Amounts[CFForecastEntry."source type"::"Cash Flow Manual Revenue"])
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Cash Flow Manual Revenues';

                trigger OnDrillDown()
                begin
                    DrillDownEntriesFromSource("source type filter"::"Cash Flow Manual Revenue");
                end;
            }
            field(Payables;Amounts[CFForecastEntry."source type"::Payables])
            {
                ApplicationArea = Basic,Suite;
                AutoFormatType = 1;
                Caption = 'Payables';

                trigger OnDrillDown()
                begin
                    DrillDownEntriesFromSource("source type filter"::Payables);
                end;
            }
            field(PurchaseOrders;Amounts[CFForecastEntry."source type"::"Purchase Order"])
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Orders';

                trigger OnDrillDown()
                begin
                    DrillDownEntriesFromSource("source type filter"::"Purchase Order");
                end;
            }
            field(BudgetedFixedAssets;Amounts[CFForecastEntry."source type"::"Fixed Assets Budget"])
            {
                ApplicationArea = Basic;
                Caption = 'Fixed Assets Budget';

                trigger OnDrillDown()
                begin
                    DrillDownEntriesFromSource("source type filter"::"Fixed Assets Budget");
                end;
            }
            field(ManualExpenses;Amounts[CFForecastEntry."source type"::"Cash Flow Manual Expense"])
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Cash Flow Manual Expenses';

                trigger OnDrillDown()
                begin
                    DrillDownEntriesFromSource("source type filter"::"Cash Flow Manual Expense");
                end;
            }
            field(GLBudgets;Amounts[CFForecastEntry."source type"::"G/L Budget"])
            {
                ApplicationArea = Basic,Suite;
                Caption = 'G/L Budgets';

                trigger OnDrillDown()
                begin
                    DrillDownEntriesFromSource("source type filter"::"G/L Budget");
                end;
            }
            field(Jobs;Amounts[CFForecastEntry."source type"::Job])
            {
                ApplicationArea = Jobs;
                Caption = 'Jobs';
                ToolTip = 'Specifies if jobs must be included in cash flow forecasts.';

                trigger OnDrillDown()
                begin
                    DrillDownEntriesFromSource("source type filter"::Job);
                end;
            }
            field(Tax;Amounts[CFForecastEntry."source type"::Tax])
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Tax';
                ToolTip = 'Specifies if tax must be included in cash flow forecasts.';

                trigger OnDrillDown()
                begin
                    DrillDownEntriesFromSource("source type filter"::Tax);
                end;
            }
            field(Total;SumTotal)
            {
                ApplicationArea = Basic,Suite;
                CaptionClass = FORMAT(STRSUBSTNO(Text1000,FORMAT("Manual Payments To")));
                Caption = 'Total';

                trigger OnDrillDown()
                begin
                    DrillDownEntriesFromSource(0);
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if CurrentDate <> WorkDate then
          CurrentDate := WorkDate;

        CalculateAllAmounts(0D,0D,Amounts,SumTotal);
    end;

    var
        Text1000: label 'Liquid Funds at %1';
        CFForecastEntry: Record "Cash Flow Forecast Entry";
        SumTotal: Decimal;
        CurrentDate: Date;
        Amounts: array [15] of Decimal;
}

