#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10308 "Currency List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Currency List.rdlc';
    Caption = 'Currency List';
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
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(TIME;Time)
            {
            }
            column(CompanyInformation_Name;CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Currency_TABLECAPTION__________CurrencyFilter;Currency.TableCaption + ': ' + CurrencyFilter)
            {
            }
            column(CurrencyFilter;CurrencyFilter)
            {
            }
            column(Currency_Code;Code)
            {
            }
            column(Currency__Last_Date_Modified_;"Last Date Modified")
            {
            }
            column(Currency__Last_Date_Adjusted_;"Last Date Adjusted")
            {
            }
            column(CurrExchRate__Exchange_Rate_Amount_;CurrExchRate."Exchange Rate Amount")
            {
                DecimalPlaces = 2:2;
            }
            column(Currency__Unrealized_Gains_Acc__;"Unrealized Gains Acc.")
            {
            }
            column(Currency__Realized_Gains_Acc__;"Realized Gains Acc.")
            {
            }
            column(Currency__Unrealized_Losses_Acc__;"Unrealized Losses Acc.")
            {
            }
            column(Currency__Realized_Losses_Acc__;"Realized Losses Acc.")
            {
            }
            column(Currency_ListCaption;Currency_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Currency_CodeCaption;FieldCaption(Code))
            {
            }
            column(Currency__Last_Date_Modified_Caption;FieldCaption("Last Date Modified"))
            {
            }
            column(Currency__Last_Date_Adjusted_Caption;FieldCaption("Last Date Adjusted"))
            {
            }
            column(CurrExchRate__Exchange_Rate_Amount_Caption;CurrExchRate__Exchange_Rate_Amount_CaptionLbl)
            {
            }
            column(Currency__Unrealized_Gains_Acc__Caption;FieldCaption("Unrealized Gains Acc."))
            {
            }
            column(Currency__Realized_Gains_Acc__Caption;FieldCaption("Realized Gains Acc."))
            {
            }
            column(Currency__Unrealized_Losses_Acc__Caption;FieldCaption("Unrealized Losses Acc."))
            {
            }
            column(Currency__Realized_Losses_Acc__Caption;FieldCaption("Realized Losses Acc."))
            {
            }

            trigger OnAfterGetRecord()
            begin
                CurrExchRate.SetRange("Currency Code",Code);
                CurrExchRate.SetRange("Starting Date",0D,WorkDate);
                CurrExchRate.FindLast;
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
        CompanyInformation.Get;
        CurrencyFilter := Currency.GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyFilter: Text;
        Currency_ListCaptionLbl: label 'Currency List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CurrExchRate__Exchange_Rate_Amount_CaptionLbl: label 'Current Exchange Rate';
}

