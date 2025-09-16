#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10017 "Currency Balances - Rec./Pay."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Currency Balances - Rec.Pay..rdlc';
    Caption = 'Currency Balances - Receivables/Payables';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Currency;Currency)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_4146; 4146)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(Time;Time)
            {
            }
            column(CompanyInfoName;CompanyInformation.Name)
            {
            }
            column(CurFilter;CurFilter)
            {
            }
            column(CurrTblCaptionCurFilter;Currency.TableCaption + ': ' + CurFilter)
            {
            }
            column(Currency_Code;Code)
            {
            }
            column(CurrExchAsOfDateCode;CurrencyExchRate.ExchangeRate(CurrExchAsOfDate,Code))
            {
                DecimalPlaces = 0:5;
            }
            column(CustBalance_Currency;"Customer Balance")
            {
                AutoFormatExpression = Code;
                AutoFormatType = 1;
            }
            column(CustBalanceLCY_Currency;"Customer Balance (LCY)")
            {
                AutoFormatType = 1;
            }
            column(CurValueReceivables;CurValueReceivables)
            {
                AutoFormatType = 1;
            }
            column(VendorBalance_Currency;"Vendor Balance")
            {
                AutoFormatExpression = Code;
                AutoFormatType = 1;
            }
            column(VendorBalanceLCY_Currency;"Vendor Balance (LCY)")
            {
                AutoFormatType = 1;
            }
            column(CurValuePayables;CurValuePayables)
            {
                AutoFormatType = 1;
            }
            column(Description_Currency;Description)
            {
            }
            column(ReceivableAndPayableCaption;ReceivableAndPayableCaptionLbl)
            {
            }
            column(PageNoCaption;PageNoCaptionLbl)
            {
            }
            column(CodeCaption_Currency;FieldCaption(Code))
            {
            }
            column(CurrencyExchRateCaption;CurrencyExchRateCaptionLbl)
            {
            }
            column(CurrencyBalanceCaption;CurrencyBalanceCaptionLbl)
            {
            }
            column(CurrCustBalanceLCYCaption;CaptionClassTranslate('101,1,' + Text000))
            {
            }
            column(CurValueReceivablesCaption;CaptionClassTranslate('101,1,' + Text001))
            {
            }
            column(ReceivablesCustomersCaption;ReceivablesCustomersCaptionLbl)
            {
            }
            column(PayablesVendorsCaption;PayablesVendorsCaptionLbl)
            {
            }
            column(CurrVendBalanceLCYCaption;CaptionClassTranslate('101,1,' + Text000))
            {
            }
            column(CurValuePayablesCaption;CaptionClassTranslate('101,1,' + Text001))
            {
            }
            column(DescriptionCaption_Currency;FieldCaption(Description))
            {
            }
            column(ReportTotalCaption;ReportTotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Customer Balance","Vendor Balance","Customer Balance (LCY)","Vendor Balance (LCY)");

                CurValueReceivables :=
                  ROUND(
                    CurrencyExchRate.ExchangeAmtFCYToFCY(CurrExchAsOfDate,Code,'',"Customer Balance"));
                CurValuePayables :=
                  ROUND(
                    CurrencyExchRate.ExchangeAmtFCYToFCY(CurrExchAsOfDate,Code,'',"Vendor Balance"));
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Customer Balance (LCY)","Vendor Balance (LCY)",CurValueReceivables,CurValuePayables);
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

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        CurFilter := Currency.GetFilters;

        if Currency.GetFilter("Date Filter") = '' then
          CurrExchAsOfDate := WorkDate
        else
          CurrExchAsOfDate := Currency.GetRangemax("Date Filter");
    end;

    var
        CompanyInformation: Record "Company Information";
        CurrencyExchRate: Record "Currency Exchange Rate";
        CurFilter: Text;
        CurrExchAsOfDate: Date;
        CurValueReceivables: Decimal;
        CurValuePayables: Decimal;
        Text000: label 'In %1 (posted)';
        Text001: label 'In %1 (at current rate)';
        ReceivableAndPayableCaptionLbl: label 'Currency Balances in Receivables and Payables';
        PageNoCaptionLbl: label 'Page';
        CurrencyExchRateCaptionLbl: label 'Exchange Rate';
        CurrencyBalanceCaptionLbl: label 'In Currency';
        ReceivablesCustomersCaptionLbl: label 'Receivables (Customers)';
        PayablesVendorsCaptionLbl: label 'Payables (Vendors)';
        ReportTotalCaptionLbl: label 'Report Total';
}

