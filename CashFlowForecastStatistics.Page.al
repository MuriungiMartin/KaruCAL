#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 868 "Cash Flow Forecast Statistics"
{
    Caption = 'Cash Flow Forecast Statistics';
    Editable = false;
    PageType = Card;
    SourceTable = "Cash Flow Forecast";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(LiquidFunds;Amounts[CFForecastEntry."source type"::"Liquid Funds"])
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Liquid Funds';
                    ToolTip = 'Specifies amounts related to liquid funds.';

                    trigger OnDrillDown()
                    begin
                        DrillDownEntriesFromSource("source type filter"::"Liquid Funds");
                    end;
                }
                field(Receivables;Amounts[CFForecastEntry."source type"::Receivables])
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Receivables';
                    ToolTip = 'Specifies amounts related to receivables.';

                    trigger OnDrillDown()
                    begin
                        DrillDownEntriesFromSource("source type filter"::Receivables);
                    end;
                }
                field(SalesOrders;Amounts[CFForecastEntry."source type"::"Sales Order"])
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Orders';
                    ToolTip = 'Specifies amounts related to sales orders.';

                    trigger OnDrillDown()
                    begin
                        DrillDownEntriesFromSource("source type filter"::"Sales Order");
                    end;
                }
                field(ServiceOrders;Amounts[CFForecastEntry."source type"::"Service Orders"])
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Orders';
                    ToolTip = 'Specifies amounts related to service orders.';

                    trigger OnDrillDown()
                    begin
                        DrillDownEntriesFromSource("source type filter"::"Service Orders");
                    end;
                }
                field(SalesofFixedAssets;Amounts[CFForecastEntry."source type"::"Fixed Assets Disposal"])
                {
                    ApplicationArea = Basic;
                    Caption = 'Fixed Assets Disposal';
                    ToolTip = 'Specifies amounts related to fixed assets disposal.';

                    trigger OnDrillDown()
                    begin
                        DrillDownEntriesFromSource("source type filter"::"Fixed Assets Disposal");
                    end;
                }
                field(ManualRevenues;Amounts[CFForecastEntry."source type"::"Cash Flow Manual Revenue"])
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cash Flow Manual Revenues';
                    ToolTip = 'Specifies amounts related to cash flow manual revenues.';

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
                    ToolTip = 'Specifies amounts related to payables.';

                    trigger OnDrillDown()
                    begin
                        DrillDownEntriesFromSource("source type filter"::Payables);
                    end;
                }
                field(PurchaseOrders;Amounts[CFForecastEntry."source type"::"Purchase Order"])
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Orders';
                    ToolTip = 'Specifies amounts related to purchase orders.';

                    trigger OnDrillDown()
                    begin
                        DrillDownEntriesFromSource("source type filter"::"Purchase Order");
                    end;
                }
                field(BudgetedFixedAssets;Amounts[CFForecastEntry."source type"::"Fixed Assets Budget"])
                {
                    ApplicationArea = Basic;
                    Caption = 'Fixed Assets Budget';
                    ToolTip = 'Specifies amounts related to fixed asset budgets.';

                    trigger OnDrillDown()
                    begin
                        DrillDownEntriesFromSource("source type filter"::"Fixed Assets Budget");
                    end;
                }
                field(ManualExpenses;Amounts[CFForecastEntry."source type"::"Cash Flow Manual Expense"])
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cash Flow Manual Expenses';
                    ToolTip = 'Specifies amounts related to cash flow manual expenses.';

                    trigger OnDrillDown()
                    begin
                        DrillDownEntriesFromSource("source type filter"::"Cash Flow Manual Expense");
                    end;
                }
                field(GLBudgets;Amounts[CFForecastEntry."source type"::"G/L Budget"])
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'G/L Budgets';
                    ToolTip = 'Specifies amounts related to general ledger budgets.';

                    trigger OnDrillDown()
                    begin
                        DrillDownEntriesFromSource("source type filter"::"G/L Budget");
                    end;
                }
                field(Job;Amounts[CFForecastEntry."source type"::Job])
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job';
                    ToolTip = 'Specifies amounts related to jobs.';

                    trigger OnDrillDown()
                    begin
                        DrillDownEntriesFromSource("source type filter"::Job);
                    end;
                }
                field(Tax;Amounts[CFForecastEntry."source type"::Tax])
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tax';
                    ToolTip = 'Specifies amounts related to taxes.';

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
                    ToolTip = 'Specifies total amounts.';

                    trigger OnDrillDown()
                    begin
                        DrillDownEntriesFromSource(0);
                    end;
                }
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

