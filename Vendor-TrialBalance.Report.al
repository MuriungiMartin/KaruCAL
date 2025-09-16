#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 329 "Vendor - Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vendor - Trial Balance.rdlc';
    Caption = 'Vendor - Trial Balance';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            DataItemTableView = sorting("Vendor Posting Group");
            RequestFilterFields = "No.","Date Filter","Vendor Posting Group";
            column(ReportForNavId_3182; 3182)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(PeriodPeriodFilter;StrSubstNo(Text003,PeriodFilter))
            {
            }
            column(VendPostGrpGroupTotal;StrSubstNo(Text005,FieldCaption("Vendor Posting Group")))
            {
            }
            column(VendTblCapVendFilter;TableCaption + ': ' + VendFilter)
            {
            }
            column(VendFilter;VendFilter)
            {
            }
            column(PeriodStartDate;Format(PeriodStartDate))
            {
            }
            column(PeriodFilter;PeriodFilter)
            {
            }
            column(FiscalYearStartDate;Format(FiscalYearStartDate))
            {
            }
            column(FiscalYearFilter;FiscalYearFilter)
            {
            }
            column(PeriodEndDate;Format(PeriodEndDate))
            {
            }
            column(VendorPostingGroup_Vendor;"Vendor Posting Group")
            {
            }
            column(YTDTotal;YTDTotal)
            {
                AutoFormatType = 1;
            }
            column(YTDCreditAmt;YTDCreditAmt)
            {
                AutoFormatType = 1;
            }
            column(YTDDebitAmt;YTDDebitAmt)
            {
                AutoFormatType = 1;
            }
            column(YTDBeginBalance;YTDBeginBalance)
            {
            }
            column(PeriodCreditAmt;PeriodCreditAmt)
            {
            }
            column(PeriodDebitAmt;PeriodDebitAmt)
            {
            }
            column(PeriodBeginBalance;PeriodBeginBalance)
            {
            }
            column(Name_Vendor;Name)
            {
                IncludeCaption = true;
            }
            column(No_Vendor;"No.")
            {
                IncludeCaption = true;
            }
            column(TotForFrmtVendPostGrp;Text004 + Format(' ') + "Vendor Posting Group")
            {
            }
            column(VendTrialBalanceCap;VendTrialBalanceCapLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(AmountsinLCYCaption;AmountsinLCYCaptionLbl)
            {
            }
            column(VendWithEntryPeriodCapt;VendWithEntryPeriodCaptLbl)
            {
            }
            column(PeriodBeginBalCap;PeriodBeginBalCapLbl)
            {
            }
            column(PeriodDebitAmtCaption;PeriodDebitAmtCaptionLbl)
            {
            }
            column(PeriodCreditAmtCaption;PeriodCreditAmtCaptionLbl)
            {
            }
            column(YTDTotalCaption;YTDTotalCaptionLbl)
            {
            }
            column(PeriodCaption;PeriodCaptionLbl)
            {
            }
            column(FiscalYearToDateCaption;FiscalYearToDateCaptionLbl)
            {
            }
            column(NetChangeCaption;NetChangeCaptionLbl)
            {
            }
            column(TotalinLCYCaption;TotalinLCYCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcAmounts(
                  PeriodStartDate,PeriodEndDate,
                  PeriodBeginBalance,PeriodDebitAmt,PeriodCreditAmt,YTDTotal);
                CalcAmounts(
                  FiscalYearStartDate,PeriodEndDate,
                  YTDBeginBalance,YTDDebitAmt,YTDCreditAmt,YTDTotal);
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(
                  PeriodBeginBalance,PeriodDebitAmt,PeriodCreditAmt,YTDBeginBalance,
                  YTDDebitAmt,YTDCreditAmt,YTDTotal);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
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
        with Vendor do begin
          PeriodFilter := GetFilter("Date Filter");
          PeriodStartDate := GetRangeMin("Date Filter");
          PeriodEndDate := GetRangemax("Date Filter");
          SetRange("Date Filter");
          VendFilter := GetFilters;
          SetRange("Date Filter",PeriodStartDate,PeriodEndDate);
          AccountingPeriod.SetRange("Starting Date",0D,PeriodEndDate);
          AccountingPeriod.SetRange("New Fiscal Year",true);
          if AccountingPeriod.FindLast then
            FiscalYearStartDate := AccountingPeriod."Starting Date"
          else
            Error(Text000,AccountingPeriod.FieldCaption("Starting Date"),AccountingPeriod.TableCaption);
          FiscalYearFilter := Format(FiscalYearStartDate) + '..' + Format(PeriodEndDate);
        end;
    end;

    var
        Text000: label 'It was not possible to find a %1 in %2.';
        AccountingPeriod: Record "Accounting Period";
        PeriodBeginBalance: Decimal;
        PeriodDebitAmt: Decimal;
        PeriodCreditAmt: Decimal;
        YTDBeginBalance: Decimal;
        YTDDebitAmt: Decimal;
        YTDCreditAmt: Decimal;
        YTDTotal: Decimal;
        PeriodFilter: Text;
        FiscalYearFilter: Text;
        VendFilter: Text;
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        FiscalYearStartDate: Date;
        Text003: label 'Period: %1';
        Text004: label 'Total for';
        Text005: label 'Group Totals: %1';
        VendTrialBalanceCapLbl: label 'Vendor - Trial Balance';
        CurrReportPageNoCaptionLbl: label 'Page';
        AmountsinLCYCaptionLbl: label 'Amounts in $';
        VendWithEntryPeriodCaptLbl: label 'Only includes vendors with entries in the period';
        PeriodBeginBalCapLbl: label 'Beginning Balance';
        PeriodDebitAmtCaptionLbl: label 'Debit';
        PeriodCreditAmtCaptionLbl: label 'Credit';
        YTDTotalCaptionLbl: label 'Ending Balance';
        PeriodCaptionLbl: label 'Period';
        FiscalYearToDateCaptionLbl: label 'Fiscal Year-To-Date';
        NetChangeCaptionLbl: label 'Net Change';
        TotalinLCYCaptionLbl: label 'Total in $';

    local procedure CalcAmounts(DateFrom: Date;DateTo: Date;var BeginBalance: Decimal;var DebitAmt: Decimal;var CreditAmt: Decimal;var TotalBalance: Decimal)
    var
        VendorCopy: Record Vendor;
    begin
        VendorCopy.Copy(Vendor);
        VendorCopy.SetRange("Date Filter",0D,DateFrom - 1);
        VendorCopy.CalcFields("Net Change (LCY)");
        BeginBalance := -VendorCopy."Net Change (LCY)";

        VendorCopy.SetRange("Date Filter",DateFrom,DateTo);
        VendorCopy.CalcFields("Debit Amount (LCY)","Credit Amount (LCY)");
        DebitAmt := VendorCopy."Debit Amount (LCY)";
        CreditAmt := VendorCopy."Credit Amount (LCY)";

        TotalBalance := BeginBalance + DebitAmt - CreditAmt;
    end;
}

