#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51151 "Vendor-Outstanding  Balances"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vendor-Outstanding  Balances.rdlc';
    Caption = 'Vendor - Trial Balance';

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            DataItemTableView = sorting("Vendor Posting Group");
            RequestFilterFields = "No.","Date Filter","Vendor Posting Group";
            column(ReportForNavId_3182; 3182)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(STRSUBSTNO_Text003_PeriodFilter_;StrSubstNo(Text003,PeriodFilter))
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(STRSUBSTNO_Text005_Vendor_FIELDCAPTION__Vendor_Posting_Group___;StrSubstNo(Text005,Vendor.FieldCaption("Vendor Posting Group")))
            {
            }
            column(Vendor_TABLECAPTION__________VendFilter;Vendor.TableCaption + ': ' + VendFilter)
            {
            }
            column(PeriodEndDate;PeriodEndDate)
            {
            }
            column(YTDTotal;YTDTotal)
            {
                AutoFormatType = 1;
            }
            column(Vendor_Name;Name)
            {
            }
            column(Vendor__No__;"No.")
            {
            }
            column(YTDTotal_Control32;YTDTotal)
            {
                AutoFormatType = 1;
            }
            column(Text004__________Vendor_Posting_Group_;Text004 + ' ' + "Vendor Posting Group")
            {
            }
            column(YTDTotal_Control41;YTDTotal)
            {
                AutoFormatType = 1;
            }
            column(Vendor_Outstanding__BalancesCaption;Vendor_Outstanding__BalancesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Amounts_in_LCYCaption;Amounts_in_LCYCaptionLbl)
            {
            }
            column(Only_includes_vendors_with_entries_in_the_periodCaption;Only_includes_vendors_with_entries_in_the_periodCaptionLbl)
            {
            }
            column(Vendor__No__Caption;FieldCaption("No."))
            {
            }
            column(Vendor_NameCaption;FieldCaption(Name))
            {
            }
            column(Total_Outstanding_BalanceCaption;Total_Outstanding_BalanceCaptionLbl)
            {
            }
            column(Total_in_LCYCaption;Total_in_LCYCaptionLbl)
            {
            }
            column(Vendor_Vendor_Posting_Group;"Vendor Posting Group")
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
                LastFieldNo := FieldNo("Vendor Posting Group");
                CurrReport.CreateTotals(
                  PeriodBeginBalance,PeriodDebitAmt,PeriodCreditAmt,YTDBeginBalance,
                  YTDDebitAmt,YTDCreditAmt,YTDTotal);
            end;
        }
    }

    requestpage
    {

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

    trigger OnInitReport()
    begin
        HideZeroAmounts := true;
    end;

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
          if AccountingPeriod.Find('+') then
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        HideZeroAmounts: Boolean;
        PeriodFilter: Text[250];
        FiscalYearFilter: Text[250];
        VendFilter: Text[1024];
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        FiscalYearStartDate: Date;
        Text003: label 'Period: %1';
        Text004: label 'Total for';
        Text005: label 'Group Totals: %1';
        Vendor_Outstanding__BalancesCaptionLbl: label 'Vendor-Outstanding  Balances';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Amounts_in_LCYCaptionLbl: label 'Amounts in LCY';
        Only_includes_vendors_with_entries_in_the_periodCaptionLbl: label 'Only includes vendors with entries in the period';
        Total_Outstanding_BalanceCaptionLbl: label 'Total Outstanding Balance';
        Total_in_LCYCaptionLbl: label 'Total in LCY';

    local procedure CalcAmounts(DateFrom: Date;DateTo: Date;var BeginBalance: Decimal;var DebitAmt: Decimal;var CreditAmt: Decimal;var TotalBalance: Decimal)
    var
        DtlVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        Vendor.SetRange("Date Filter",0D,DateFrom - 1);
        Vendor.CalcFields("Net Change (LCY)");
        BeginBalance := -Vendor."Net Change (LCY)";

        with DtlVendLedgEntry do begin
          SetCurrentkey("Vendor No.","Posting Date","Entry Type","Currency Code");
          SetRange("Vendor No.",Vendor."No.");
          SetRange("Posting Date",DateFrom,DateTo);
          SetFilter("Entry Type",'<> %1',"entry type"::Application);
          CalcSums("Debit Amount (LCY)","Credit Amount (LCY)");
          DebitAmt := "Debit Amount (LCY)";
          CreditAmt := "Credit Amount (LCY)";
          TotalBalance := BeginBalance + DebitAmt - CreditAmt;
        end;
    end;
}

