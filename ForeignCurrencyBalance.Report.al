#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 503 "Foreign Currency Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Foreign Currency Balance.rdlc';
    Caption = 'Foreign Currency Balance';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Currency;Currency)
        {
            DataItemTableView = sorting(Code);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code";
            column(ReportForNavId_4146; 4146)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(CurrTableCaptCurrFilter;TableCaption + ': ' + CurrencyFilter)
            {
            }
            column(CurrencyFilter;CurrencyFilter)
            {
            }
            column(CurrencyCode;Code)
            {
                IncludeCaption = true;
            }
            column(CurrencyCustomerBalance;"Customer Balance")
            {
            }
            column(CustBalanceLCY_Currency;"Customer Balance (LCY)")
            {
            }
            column(CustCurrentBalanceLCY;CustCurrentBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(CustrBalLcyCustCurrBalLcy;"Customer Balance (LCY)" - CustCurrentBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(VendorBalance;-"Vendor Balance")
            {
            }
            column(VendorBalanceLCY;-"Vendor Balance (LCY)")
            {
            }
            column(VendCurrentBalanceLCY;-VendCurrentBalanceLCY)
            {
            }
            column(VendBalLcyVendCurrBalLcy;-"Vendor Balance (LCY)" + VendCurrentBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(TotalBalanceLCY;TotalBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(TotalCurrentBalanceLCY;TotalCurrentBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(TotalBalLcyTotalCurrBalLcy;TotalBalanceLCY - TotalCurrentBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(ForeignCurrencyBalanceCaption;ForeignCurrencyBalanceCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(CurrencyCustomerBalanceCaption;CurrencyCustomerBalanceCaptionLbl)
            {
            }
            column(CurrencyCustomerBalanceLCYCaption;CurrencyCustomerBalanceLCYCaptionLbl)
            {
            }
            column(CustCurrentBalanceLCYCaption;CustCurrentBalanceLCYCaptionLbl)
            {
            }
            column(CustomerBalanceLCYCustCurrentBalanceLCYCaption;CustomerBalanceLCYCustCurrentBalanceLCYCaptionLbl)
            {
            }
            column(ReceivablesCaption;ReceivablesCaptionLbl)
            {
            }
            column(PayablesCaption;PayablesCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            dataitem("Bank Account";"Bank Account")
            {
                DataItemLink = "Currency Code"=field(Code);
                DataItemTableView = sorting("No.");
                column(ReportForNavId_4558; 4558)
                {
                }
                column(BankAccCurrentBalanceLCY;BankAccCurrentBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(BankAccountBalanceLCY;"Balance (LCY)")
                {
                }
                column(BankAccountBalance;Balance)
                {
                }
                column(BalLcyBankAccCurrBalLcy;"Balance (LCY)" - BankAccCurrentBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(BankAccountNo;"No.")
                {
                }
                column(BankAccountsCaption;BankAccountsCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields(Balance,"Balance (LCY)");
                    if (Balance = 0) and ("Balance (LCY)" = 0) then
                      CurrReport.Skip;
                    BankAccCurrentBalanceLCY :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          WorkDate,Currency.Code,Balance,
                          CurrExchRate.ExchangeRate(
                            WorkDate,Currency.Code)));

                    CalcTotalBalance += Balance;
                    CalcTotalBalanceLCY += "Balance (LCY)";
                    CalcTotalCurrentBalanceLCY += BankAccCurrentBalanceLCY;
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals(Balance,"Balance (LCY)",BankAccCurrentBalanceLCY);
                end;
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(TotalBalance;TotalBalance)
                {
                    AutoFormatExpression = Currency.Code;
                    AutoFormatType = 1;
                }
                column(TotalBalLCYControl22;TotalBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(TotalCurrBalLcyControl23;TotalCurrentBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(TotalBalaLcyCurrBalCtrl24;TotalBalanceLCY - TotalCurrentBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(StrsubNototalCurrCode;StrSubstNo(Text000,Currency.Code))
                {
                }
                column(CalcTotalBalance;CalcTotalBalance)
                {
                }
                column(CalcTotalBalanceLCY;CalcTotalBalanceLCY)
                {
                }
                column(CalcTotalCurrBalanceLCY;CalcTotalCurrentBalanceLCY)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TotalBalance :=
                      Currency."Customer Balance" - Currency."Vendor Balance" +
                      "Bank Account".Balance;
                    TotalBalanceLCY :=
                      Currency."Customer Balance (LCY)" - Currency."Vendor Balance (LCY)" +
                      "Bank Account"."Balance (LCY)";

                    TotalCurrentBalanceLCY := CustCurrentBalanceLCY - VendCurrentBalanceLCY + BankAccCurrentBalanceLCY;

                    CalcTotalBalance := CalcTotalBalance + Currency."Customer Balance" - Currency."Vendor Balance";
                    CalcTotalBalanceLCY := CalcTotalBalanceLCY + Currency."Customer Balance (LCY)" - Currency."Vendor Balance (LCY)";
                    CalcTotalCurrentBalanceLCY := CalcTotalCurrentBalanceLCY + CustCurrentBalanceLCY - VendCurrentBalanceLCY;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                SetFilter("Customer Filter",'<>%1','');
                SetFilter("Vendor Filter",'<>%1','');
                CalcFields(
                  "Customer Balance","Customer Balance (LCY)",
                  "Vendor Balance","Vendor Balance (LCY)");

                CustCurrentBalanceLCY :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      WorkDate,Code,"Customer Balance",
                      CurrExchRate.ExchangeRate(
                        WorkDate,Code)));
                VendCurrentBalanceLCY :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      WorkDate,Code,"Vendor Balance",
                      CurrExchRate.ExchangeRate(
                        WorkDate,Code)));

                CalcTotalBalance := 0;
                CalcTotalBalanceLCY := 0;
                CalcTotalCurrentBalanceLCY := 0;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(
                  "Customer Balance","Customer Balance (LCY)",CustCurrentBalanceLCY,
                  "Vendor Balance","Vendor Balance (LCY)",VendCurrentBalanceLCY,
                  "Bank Account".Balance,"Bank Account"."Balance (LCY)",BankAccCurrentBalanceLCY);
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
        CurrencyFilter := Currency.GetFilters;
    end;

    var
        Text000: label 'Total %1';
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyFilter: Text;
        CustCurrentBalanceLCY: Decimal;
        VendCurrentBalanceLCY: Decimal;
        BankAccCurrentBalanceLCY: Decimal;
        TotalBalance: Decimal;
        CalcTotalBalance: Decimal;
        TotalBalanceLCY: Decimal;
        CalcTotalBalanceLCY: Decimal;
        TotalCurrentBalanceLCY: Decimal;
        CalcTotalCurrentBalanceLCY: Decimal;
        ForeignCurrencyBalanceCaptionLbl: label 'Foreign Currency Balance';
        CurrReportPageNoCaptionLbl: label 'Page';
        CurrencyCustomerBalanceCaptionLbl: label 'Balance';
        CurrencyCustomerBalanceLCYCaptionLbl: label 'Posted Value ($)';
        CustCurrentBalanceLCYCaptionLbl: label 'Current Value ($)';
        CustomerBalanceLCYCustCurrentBalanceLCYCaptionLbl: label 'Difference ($)';
        ReceivablesCaptionLbl: label 'Receivables';
        PayablesCaptionLbl: label 'Payables';
        TotalCaptionLbl: label 'Total';
        BankAccountsCaptionLbl: label 'Bank Accounts';
}

