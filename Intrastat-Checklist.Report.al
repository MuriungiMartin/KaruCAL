#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 502 "Intrastat - Checklist"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Intrastat - Checklist.rdlc';
    Caption = 'Intrastat - Checklist';
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
            column(IntrastatJnlBatJnlTemName;"Journal Template Name")
            {
            }
            column(IntrastatJnlBatchName;Name)
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
                column(TodayFormatted;Format(Today,0,4))
                {
                }
                column(IntrastatJnlBatStatPeriod;StrSubstNo(Text001,"Intrastat Jnl. Batch"."Statistics Period"))
                {
                }
                column(CompanyName;COMPANYNAME)
                {
                }
                column(CompanyInfoVATRegNo;CompanyInfo."VAT Registration No.")
                {
                }
                column(HeaderText;HeaderText)
                {
                }
                column(HeaderLine;HeaderLine)
                {
                }
                column(PrintJnlLines;PrintJnlLines)
                {
                }
                column(NoOfRecordsRTC;NoOfRecordsRTC)
                {
                }
                column(IntrastatJnlLineType;Type)
                {
                    IncludeCaption = true;
                }
                column(IntrastatJnlLineTariffNo;"Tariff No.")
                {
                    IncludeCaption = true;
                }
                column(CountryIntrastatCode;Country."Intrastat Code")
                {
                }
                column(CountryName;Country.Name)
                {
                }
                column(IntrastatJnlLineTranType;"Transaction Type")
                {
                    IncludeCaption = true;
                }
                column(IntrastatJnlLinTranMethod;"Transport Method")
                {
                    IncludeCaption = true;
                }
                column(IntrastatJnlLineItemDesc;"Item Description")
                {
                    IncludeCaption = true;
                }
                column(IntrastatJnlLineTotalWt;"Total Weight")
                {
                    IncludeCaption = true;
                }
                column(IntrastatJnlLineTotalWt2;TotalWeight)
                {
                }
                column(IntrastatJnlLineQty;Quantity)
                {
                    IncludeCaption = true;
                }
                column(IntrastatJnlLineStatVal;"Statistical Value")
                {
                    IncludeCaption = true;
                }
                column(IntrastatJnlLinInterRefNo;"Internal Ref. No.")
                {
                    IncludeCaption = true;
                }
                column(IntrastatJnlLinSubTotalWt;SubTotalWeight)
                {
                    DecimalPlaces = 0:0;
                }
                column(NoOfRecords;NoOfRecords)
                {
                }
                column(IntrastatJnlLinJnlTemName;"Journal Template Name")
                {
                }
                column(IntrastatJnlLinJnlBatName;"Journal Batch Name")
                {
                }
                column(IntrastatJnlLineLineNo;"Line No.")
                {
                }
                column(IntrastatChecklistCaption;IntrastatChecklistCaptionLbl)
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
                column(CountryRegionCodeCaption;CountryRegionCodeCaptionLbl)
                {
                }
                column(TransactionTypeCaption;TransactionTypeCaptionLbl)
                {
                }
                column(TransactionMethodCaption;TransactionMethodCaptionLbl)
                {
                }
                column(NoOfEntriesCaption;NoOfEntriesCaptionLbl)
                {
                }
                column(TotalCaption;TotalCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
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
                    TestField("Transport Method");
                    TestField("Total Weight");
                    if "Supplementary Units" then
                      TestField(Quantity);
                    Country.Get("Country/Region Code");
                    IntrastatJnlLineTemp.Reset;
                    IntrastatJnlLineTemp.SetRange(Type,Type);
                    IntrastatJnlLineTemp.SetRange("Tariff No.","Tariff No.");
                    IntrastatJnlLineTemp.SetRange("Country/Region Code","Country/Region Code");
                    IntrastatJnlLineTemp.SetRange("Transaction Type","Transaction Type");
                    IntrastatJnlLineTemp.SetRange("Transport Method","Transport Method");
                    if not IntrastatJnlLineTemp.FindFirst then begin
                      IntrastatJnlLineTemp := "Intrastat Jnl. Line";
                      IntrastatJnlLineTemp.Insert;
                      NoOfRecordsRTC += 1;
                    end;
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
                    IntrastatJnlLineTemp.DeleteAll;
                    NoOfRecordsRTC := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.PageNo := 1;
                GLSetup.Get;
                if "Amounts in Add. Currency" then begin
                  GLSetup.TestField("Additional Reporting Currency");
                  HeaderLine := StrSubstNo(Text002,GLSetup."Additional Reporting Currency");
                end else begin
                  GLSetup.TestField("LCY Code");
                  HeaderLine := StrSubstNo(Text002,GLSetup."LCY Code");
                end;
            end;

            trigger OnPreDataItem()
            begin
                if "Intrastat Jnl. Line".GetFilter("Journal Template Name") <> '' then
                  SetFilter("Journal Template Name","Intrastat Jnl. Line".GetFilter("Journal Template Name"));
                if "Intrastat Jnl. Line".GetFilter("Journal Batch Name") <> '' then
                  SetFilter(Name,"Intrastat Jnl. Line".GetFilter("Journal Batch Name"));
            end;
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
                    field(ShowIntrastatJournalLines;PrintJnlLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Intrastat Journal Lines';
                        MultiLine = true;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        TotalWeightCaption = 'Total Weight';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo."VAT Registration No." := ConvertStr(CompanyInfo."VAT Registration No.",Text000,'    ');
    end;

    var
        Text000: label 'WwWw';
        Text001: label 'Statistics Period: %1';
        Text002: label 'All amounts are in %1.';
        CompanyInfo: Record "Company Information";
        Country: Record "Country/Region";
        GLSetup: Record "General Ledger Setup";
        IntrastatJnlLineTemp: Record "Intrastat Jnl. Line" temporary;
        PrevIntrastatJnlLine: Record "Intrastat Jnl. Line";
        NoOfRecords: Integer;
        NoOfRecordsRTC: Integer;
        PrintJnlLines: Boolean;
        HeaderText: Text;
        HeaderLine: Text;
        SubTotalWeight: Decimal;
        TotalWeight: Decimal;
        IntrastatChecklistCaptionLbl: label 'Intrastat - Checklist';
        PageNoCaptionLbl: label 'Page';
        VATRegNoCaptionLbl: label 'Tax Registration No.';
        TariffNoCaptionLbl: label 'Tariff No.';
        CountryRegionCodeCaptionLbl: label 'Country/Region Code';
        TransactionTypeCaptionLbl: label 'Transaction Type';
        TransactionMethodCaptionLbl: label 'Transport Method';
        NoOfEntriesCaptionLbl: label 'No. of Entries';
        TotalCaptionLbl: label 'Total';
}

