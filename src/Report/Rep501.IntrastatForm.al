#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 501 "Intrastat - Form"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Intrastat - Form.rdlc';
    Caption = 'Intrastat - Form';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Intrastat Jnl. Batch";"Intrastat Jnl. Batch")
        {
            DataItemTableView = sorting("Journal Template Name",Name);
            RequestFilterFields = "Journal Template Name",Name;
            column(ReportForNavId_2880; 2880)
            {
            }
            column(JnlTmplName_IntraJnlBatch;"Journal Template Name")
            {
            }
            column(Name_IntraJnlBatch;Name)
            {
            }
            dataitem("Intrastat Jnl. Line";"Intrastat Jnl. Line")
            {
                DataItemLink = "Journal Template Name"=field("Journal Template Name"),"Journal Batch Name"=field(Name);
                DataItemTableView = sorting(Type,"Country/Region Code","Tariff No.","Transaction Type","Transport Method");
                RequestFilterFields = Type;
                column(ReportForNavId_9905; 9905)
                {
                }
                column(IntraJnlBatchStaticPeriod;StrSubstNo(Text002,"Intrastat Jnl. Batch"."Statistics Period"))
                {
                }
                column(CompanyName;COMPANYNAME)
                {
                }
                column(Type_IntraJnlLine;Format(Type))
                {
                }
                column(CompanyInfoVATRegNo;CompanyInfo."VAT Registration No.")
                {
                }
                column(HeaderLine;HeaderLine)
                {
                }
                column(HeaderFilter;HeaderFilter)
                {
                }
                column(TariffNo_IntraJnlLine;"Tariff No.")
                {
                }
                column(ItemDesc_IntraJnlLine;"Item Description")
                {
                }
                column(CountryIntraCode;Country."Intrastat Code")
                {
                }
                column(CountryName;Country.Name)
                {
                }
                column(TransacType_IntraJnlLine;"Transaction Type")
                {
                }
                column(TransportMet_IntraJnlLine;"Transport Method")
                {
                }
                column(SubTotalWeight;SubTotalWeight)
                {
                    DecimalPlaces = 0:0;
                }
                column(Quantity_IntraJnlLine;Quantity)
                {
                }
                column(StatisValue_IntraJnlLine;"Statistical Value")
                {
                }
                column(TotalWeight_IntraJnlLine;TotalWeight)
                {
                    DecimalPlaces = 0:0;
                }
                column(NoOfRecords;NoOfRecords)
                {
                }
                column(JnlTmplName_IntraJnlLine;"Journal Template Name")
                {
                }
                column(IntraFormCaption;IntraFormCaptionLbl)
                {
                }
                column(PageNoCaption;PageNoCaptionLbl)
                {
                }
                column(VATRegNoCaption;VATRegNoCaptionLbl)
                {
                }
                column(TariffNoCaption;TariffNoCaptionLbl)
                {
                }
                column(ItemDescriptionCaption;FieldCaption("Item Description"))
                {
                }
                column(CountryRegionCodeCaption;CountryRegionCodeCaptionLbl)
                {
                }
                column(CountryNameCaption;CountryNameCaptionLbl)
                {
                }
                column(TransactionTypeCaption;TransactionTypeCaptionLbl)
                {
                }
                column(TransportMethodCaption;TransportMethodCaptionLbl)
                {
                }
                column(TotalWeightCaption;TotalWeightCaptionLbl)
                {
                }
                column(QuantityCaption;FieldCaption(Quantity))
                {
                }
                column(StatisticalValueCaption;FieldCaption("Statistical Value"))
                {
                }
                column(TotalCaption;TotalCaptionLbl)
                {
                }
                column(NoOfRecordsCaption;NoOfRecordsCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Country.Get("Country/Region Code");
                    if ("Tariff No." = '') and
                       ("Country/Region Code" = '') and
                       ("Transaction Type" = '') and
                       ("Transport Method" = '') and
                       ("Total Weight" = 0)
                    then
                      CurrReport.Skip;

                    TestField("Tariff No.");
                    TestField("Country/Region Code");
                    TestField("Transaction Type");
                    TestField("Total Weight");
                    if "Supplementary Units" then
                      TestField(Quantity);

                    if (PrevIntrastatJnlLine.Type <> Type) or
                       (PrevIntrastatJnlLine."Tariff No." <> "Tariff No.") or
                       (PrevIntrastatJnlLine."Country/Region Code" <> "Country/Region Code") or
                       (PrevIntrastatJnlLine."Transaction Type" <> "Transaction Type") or
                       (PrevIntrastatJnlLine."Transport Method" <> "Transport Method")
                    then begin
                      SubTotalWeight := 0;
                      PrevIntrastatJnlLine.SetCurrentkey(Type,"Country/Region Code","Tariff No.","Transaction Type","Transport Method");
                      PrevIntrastatJnlLine.SetRange(Type,Type);
                      PrevIntrastatJnlLine.SetRange("Country/Region Code","Country/Region Code");
                      PrevIntrastatJnlLine.SetRange("Tariff No.","Tariff No.");
                      PrevIntrastatJnlLine.SetRange("Transaction Type","Transaction Type");
                      PrevIntrastatJnlLine.SetRange("Transport Method","Transport Method");
                      PrevIntrastatJnlLine.FindFirst;
                    end;

                    SubTotalWeight := SubTotalWeight + ROUND("Total Weight",1);
                    TotalWeight := TotalWeight + ROUND("Total Weight",1);
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals("Statistical Value",Quantity);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.PageNo := 1;
                GLSetup.Get;
                if "Amounts in Add. Currency" then begin
                  GLSetup.TestField("Additional Reporting Currency");
                  HeaderLine := StrSubstNo(Text003,GLSetup."Additional Reporting Currency");
                end else begin
                  GLSetup.TestField("LCY Code");
                  HeaderLine := StrSubstNo(Text003,GLSetup."LCY Code");
                end;
                HeaderFilter := "Intrastat Jnl. Line".TableCaption + ': ' + IntraJnlLineFilter;
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
        IntraJnlLineFilter := "Intrastat Jnl. Line".GetFilters;
        if not ("Intrastat Jnl. Line".GetRangeMin(Type) = "Intrastat Jnl. Line".GetRangemax(Type)) then
          "Intrastat Jnl. Line".FieldError(Type,Text000);

        CompanyInfo.Get;
        CompanyInfo."VAT Registration No." := ConvertStr(CompanyInfo."VAT Registration No.",Text001,'    ');
    end;

    var
        Text000: label 'must be either Receipt or Shipment';
        Text001: label 'WwWw';
        Text002: label 'Statistics Period: %1';
        Text003: label 'All amounts are in %1.';
        CompanyInfo: Record "Company Information";
        Country: Record "Country/Region";
        GLSetup: Record "General Ledger Setup";
        PrevIntrastatJnlLine: Record "Intrastat Jnl. Line";
        IntraJnlLineFilter: Text;
        NoOfRecords: Integer;
        HeaderLine: Text;
        HeaderFilter: Text;
        SubTotalWeight: Decimal;
        TotalWeight: Decimal;
        IntraFormCaptionLbl: label 'Intrastat - Form';
        PageNoCaptionLbl: label 'Page';
        VATRegNoCaptionLbl: label 'Tax Reg. No.';
        TariffNoCaptionLbl: label 'Tariff No.';
        CountryRegionCodeCaptionLbl: label 'Country/Region Code';
        CountryNameCaptionLbl: label 'Name';
        TransactionTypeCaptionLbl: label 'Transaction Type';
        TransportMethodCaptionLbl: label 'Transport Method';
        TotalWeightCaptionLbl: label 'Total Weight';
        TotalCaptionLbl: label 'Total';
        NoOfRecordsCaptionLbl: label 'No. of Entries';
}

