#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 846 "Cash Flow Date List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cash Flow Date List.rdlc';
    Caption = 'Cash Flow Date List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(CashFlow;"Cash Flow Forecast")
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_2601; 2601)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(CashFlow__No__;"No.")
            {
            }
            column(CashFlow_Description;Description)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CashFlow_Date_ListCaption;CashFlow_Date_ListCaptionLbl)
            {
            }
            column(CashFlow__No__Caption;FieldCaption("No."))
            {
            }
            column(CashFlow_DescriptionCaption;FieldCaption(Description))
            {
            }
            dataitem(EditionPeriod;"Integer")
            {
                DataItemTableView = sorting(Number) order(ascending);
                column(ReportForNavId_2418; 2418)
                {
                }
                column(NewCFSumTotal;NewCFSumTotal)
                {
                }
                column(BeforeSumTotal;BeforeSumTotal)
                {
                }
                column(Liquidity;Values[CFForecastEntry."source type"::"Liquid Funds"])
                {
                }
                column(Receivables;Values[CFForecastEntry."source type"::Receivables])
                {
                }
                column(Sales_Orders_;Values[CFForecastEntry."source type"::"Sales Order"])
                {
                }
                column(Service_Orders_;Values[CFForecastEntry."source type"::"Service Orders"])
                {
                }
                column(ManualRevenues;Values[CFForecastEntry."source type"::"Cash Flow Manual Revenue"])
                {
                }
                column(Payables;Values[CFForecastEntry."source type"::Payables])
                {
                }
                column(Purchase_Orders_;Values[CFForecastEntry."source type"::"Purchase Order"])
                {
                }
                column(ManualExpenses;Values[CFForecastEntry."source type"::"Cash Flow Manual Expense"])
                {
                }
                column(InvFixedAssets;Values[CFForecastEntry."source type"::"Fixed Assets Budget"])
                {
                }
                column(SaleFixedAssets;Values[CFForecastEntry."source type"::"Fixed Assets Disposal"])
                {
                }
                column(GLBudget;Values[CFForecastEntry."source type"::"G/L Budget"])
                {
                }
                column(EditionPeriod_Number;Number)
                {
                }
                column(Period_Number;PeriodNumber)
                {
                }
                column(Receivables_Control2;Values[CFForecastEntry."source type"::Receivables])
                {
                }
                column(Sales_Orders__Control9;Values[CFForecastEntry."source type"::"Sales Order"])
                {
                }
                column(Payables_Control12;Values[CFForecastEntry."source type"::Payables])
                {
                }
                column(Purchase_Orders__Control15;Values[CFForecastEntry."source type"::"Purchase Order"])
                {
                }
                column(ManualRevenues_Control23;Values[CFForecastEntry."source type"::"Cash Flow Manual Revenue"])
                {
                }
                column(ManualExpenses_Control25;Values[CFForecastEntry."source type"::"Cash Flow Manual Expense"])
                {
                }
                column(FORMAT_DateTo_;Format(CurrentDateTo))
                {
                }
                column(FORMAT_DateFrom_;Format(CurrentDateFrom))
                {
                }
                column(InvFixedAssets_Control49;Values[CFForecastEntry."source type"::"Fixed Assets Budget"])
                {
                }
                column(SaleFixedAssets_Control51;Values[CFForecastEntry."source type"::"Fixed Assets Disposal"])
                {
                }
                column(NewCFSumTotal_Control1;NewCFSumTotal)
                {
                }
                column(Service_Orders__Control59;Values[CFForecastEntry."source type"::"Service Orders"])
                {
                }
                column(Service_Orders__Control59Caption;Service_Orders__Control59CaptionLbl)
                {
                }
                column(Jobs;Values[CFForecastEntry."source type"::Job])
                {
                }
                column(JobsLbl;JobsLbl)
                {
                }
                column(Taxes;Values[CFForecastEntry."source type"::Tax])
                {
                }
                column(TaxesLbl;TaxesLbl)
                {
                }
                column(SumTotal_Control18Caption;SumTotal_Control18CaptionLbl)
                {
                }
                column(Purchase_Orders__Control15Caption;Purchase_Orders__Control15CaptionLbl)
                {
                }
                column(Payables_Control12Caption;Payables_Control12CaptionLbl)
                {
                }
                column(Sales_Orders__Control9Caption;Sales_Orders__Control9CaptionLbl)
                {
                }
                column(Receivables_Control2Caption;Receivables_Control2CaptionLbl)
                {
                }
                column(ManualRevenues_Control23Caption;ManualRevenues_Control23CaptionLbl)
                {
                }
                column(ManualExpenses_Control25Caption;ManualExpenses_Control25CaptionLbl)
                {
                }
                column(FORMAT_DateFrom_Caption;FORMAT_DateFrom_CaptionLbl)
                {
                }
                column(FORMAT_DateTo_Caption;FORMAT_DateTo_CaptionLbl)
                {
                }
                column(InvFixedAssets_Control49Caption;InvFixedAssets_Control49CaptionLbl)
                {
                }
                column(SaleFixedAssets_Control51Caption;SaleFixedAssets_Control51CaptionLbl)
                {
                }
                column(before_Caption;before_CaptionLbl)
                {
                }
                column(after_Caption;after_CaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CashFlow.SetCashFlowDateFilter(CurrentDateFrom,CurrentDateTo);
                    case Number of
                      0:
                        begin
                          CurrentDateTo := UserInputDateFrom - 1;
                          CurrentDateFrom := 0D;
                        end;
                      PeriodNumber + 1:
                        begin
                          CurrentDateFrom := CurrentDateTo + 1;
                          CurrentDateTo := 0D;
                        end;
                      else begin
                        CurrentDateFrom := CurrentDateTo + 1;
                        CurrentDateTo := CalcDate(Interval,CurrentDateFrom) - 1;
                      end
                    end;

                    CashFlow.CalculateAllAmounts(CurrentDateFrom,CurrentDateTo,Values,CFSumTotal);
                    NewCFSumTotal := NewCFSumTotal + CFSumTotal;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number,0,PeriodNumber + 1);
                    CashFlow.CalculateAllAmounts(0D,UserInputDateFrom - 1,Values,BeforeSumTotal);
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FromDate;UserInputDateFrom)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'From Date';
                        ToolTip = 'Specifies the first date to be included in the report.';
                    }
                    field(PeriodNumber;PeriodNumber)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Number of Intervals';
                        ToolTip = 'Specifies the number of intervals.';
                    }
                    field(Interval;Interval)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Interval Length';
                        ToolTip = 'Specifies the length of each interval, such as 1M for one month, 1W for one week, or 1D for one day.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            UserInputDateFrom := WorkDate;
        end;
    }

    labels
    {
        GLBudget_Caption = 'G/L Budget';
        Liquidity_Caption = 'Liquidity';
    }

    var
        CFForecastEntry: Record "Cash Flow Forecast Entry";
        UserInputDateFrom: Date;
        CurrentDateFrom: Date;
        CurrentDateTo: Date;
        PeriodNumber: Integer;
        Interval: DateFormula;
        Values: array [15] of Decimal;
        BeforeSumTotal: Decimal;
        NewCFSumTotal: Decimal;
        CFSumTotal: Decimal;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CashFlow_Date_ListCaptionLbl: label 'Cash Flow Date List';
        Service_Orders__Control59CaptionLbl: label 'Service Orders';
        SumTotal_Control18CaptionLbl: label 'Cash Flow Interference';
        Purchase_Orders__Control15CaptionLbl: label 'Purchase Orders';
        Payables_Control12CaptionLbl: label 'Payables';
        Sales_Orders__Control9CaptionLbl: label 'Sales Orders';
        Receivables_Control2CaptionLbl: label 'Receivables';
        ManualRevenues_Control23CaptionLbl: label 'Cash Flow Manual Revenues';
        ManualExpenses_Control25CaptionLbl: label 'Cash Flow Manual Expenses';
        FORMAT_DateFrom_CaptionLbl: label 'From';
        FORMAT_DateTo_CaptionLbl: label 'To';
        InvFixedAssets_Control49CaptionLbl: label 'Fixed Assets Budget';
        SaleFixedAssets_Control51CaptionLbl: label 'Fixed Assets Disposal';
        before_CaptionLbl: label 'Before:';
        after_CaptionLbl: label 'After:';
        JobsLbl: label 'Jobs';
        TaxesLbl: label 'Taxes';


    procedure InitializeRequest(FromDate: Date;NumberOfIntervals: Integer;IntervalLength: DateFormula)
    begin
        UserInputDateFrom := FromDate;
        PeriodNumber := NumberOfIntervals;
        Interval := IntervalLength;
    end;
}

