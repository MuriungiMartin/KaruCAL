#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 31 "VAT Exceptions"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VAT Exceptions.rdlc';
    Caption = 'Tax Exceptions';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("VAT Entry";"VAT Entry")
        {
            RequestFilterFields = "Posting Date";
            column(ReportForNavId_7612; 7612)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(Filter1_VatEntry;TableCaption + ': ' + VATEntryFilter)
            {
            }
            column(MinVatDifference;MinVATDifference)
            {
                AutoFormatExpression = GetCurrency;
                AutoFormatType = 1;
            }
            column(MinVatDiffText;MinVATDiffText)
            {
            }
            column(AddCurrAmt_VatEntry;AddCurrAmtTxt)
            {
            }
            column(PostingDate_VatEntry;Format("Posting Date"))
            {
            }
            column(DocumentType_VatEntry;"Document Type")
            {
            }
            column(DocumentNo_VatEntry;"Document No.")
            {
                IncludeCaption = true;
            }
            column(Type_VatEntry;Type)
            {
                IncludeCaption = true;
            }
            column(GenBusPostGrp_VatEntry;"Gen. Bus. Posting Group")
            {
            }
            column(GenProdPostGrp_VatEntry;"Gen. Prod. Posting Group")
            {
            }
            column(Base_VatEntry;Base)
            {
                AutoFormatExpression = GetCurrency;
                AutoFormatType = 1;
                IncludeCaption = true;
            }
            column(Amount_VatEntry;Amount)
            {
                AutoFormatExpression = GetCurrency;
                AutoFormatType = 1;
                IncludeCaption = true;
            }
            column(VatCalType_VatEntry;"VAT Calculation Type")
            {
            }
            column(BillToPay_VatEntry;"Bill-to/Pay-to No.")
            {
                IncludeCaption = true;
            }
            column(Eu3PartyTrade_VatEntry;Format("EU 3-Party Trade"))
            {
            }
            column(FormatClosed;Format(Closed))
            {
            }
            column(EntrtyNo_VatEntry;"Entry No.")
            {
                IncludeCaption = true;
            }
            column(VatDiff_VatEntry;"VAT Difference")
            {
                IncludeCaption = true;
            }
            column(VATExceptionsCaption;VATExceptionsCaptionLbl)
            {
            }
            column(CurrReportPageNoOCaption;CurrReportPageNoOCaptionLbl)
            {
            }
            column(FORMATEU3PartyTradeCap;FORMATEU3PartyTradeCapLbl)
            {
            }
            column(FORMATClosedCaption;FORMATClosedCaptionLbl)
            {
            }
            column(VATEntryVATCalcTypeCap;VATEntryVATCalcTypeCapLbl)
            {
            }
            column(GenProdPostingGrpCaption;GenProdPostingGrpCaptionLbl)
            {
            }
            column(GenBusPostingGrpCaption;GenBusPostingGrpCaptionLbl)
            {
            }
            column(DocumentTypeCaption;DocumentTypeCaptionLbl)
            {
            }
            column(PostingDateCaption;PostingDateCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not PrintReversedEntries then
                  if Reversed then
                    CurrReport.Skip;
                if UseAmtsInAddCurr then begin
                  Base := "Additional-Currency Base";
                  Amount := "Additional-Currency Amount";
                  "VAT Difference" := "Add.-Curr. VAT Difference";
                end;
            end;

            trigger OnPreDataItem()
            begin
                if UseAmtsInAddCurr then
                  SetFilter("Add.-Curr. VAT Difference",'<=%1|>=%2',-Abs(MinVATDifference),Abs(MinVATDifference))
                else
                  SetFilter("VAT Difference",'<=%1|>=%2',-Abs(MinVATDifference),Abs(MinVATDifference));
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
                    field(AmountsInAddReportingCurrency;UseAmtsInAddCurr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Amounts in Add. Reporting Currency';
                        MultiLine = true;
                    }
                    field(IncludeReversedEntries;PrintReversedEntries)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Reversed Entries';
                    }
                    field(MinVATDifference;MinVATDifference)
                    {
                        ApplicationArea = Basic;
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                        Caption = 'Min. Tax Difference';

                        trigger OnValidate()
                        begin
                            MinVATDifference := Abs(ROUND(MinVATDifference));
                        end;
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
    }

    trigger OnPreReport()
    begin
        GLSetup.Get;
        VATEntryFilter := "VAT Entry".GetFilters;
        if UseAmtsInAddCurr then
          AddCurrAmtTxt := StrSubstNo(Text000,GLSetup."Additional Reporting Currency");
        MinVATDiffText := StrSubstNo(Text001,"VAT Entry".FieldCaption("VAT Difference"));
    end;

    var
        Text000: label 'Amounts are shown in %1.';
        Text001: label 'Show %1 equal to or greater than';
        GLSetup: Record "General Ledger Setup";
        VATEntryFilter: Text;
        UseAmtsInAddCurr: Boolean;
        AddCurrAmtTxt: Text[50];
        MinVATDifference: Decimal;
        MinVATDiffText: Text[250];
        PrintReversedEntries: Boolean;
        VATExceptionsCaptionLbl: label 'Tax Exceptions';
        CurrReportPageNoOCaptionLbl: label 'Page';
        FORMATEU3PartyTradeCapLbl: label 'EU 3-Party Trade';
        FORMATClosedCaptionLbl: label 'Closed';
        VATEntryVATCalcTypeCapLbl: label 'VAT Calculation Type';
        GenProdPostingGrpCaptionLbl: label 'Gen. Prod. Posting Group';
        GenBusPostingGrpCaptionLbl: label 'Gen. Bus. Posting Group';
        DocumentTypeCaptionLbl: label 'Document Type';
        PostingDateCaptionLbl: label 'Posting Date';

    local procedure GetCurrency(): Code[10]
    begin
        if UseAmtsInAddCurr then
          exit(GLSetup."Additional Reporting Currency");

        exit('');
    end;


    procedure InitializeRequest(NewUseAmtsInAddCurr: Boolean;NewPrintReversedEntries: Boolean;NewMinVATDifference: Decimal)
    begin
        UseAmtsInAddCurr := NewUseAmtsInAddCurr;
        PrintReversedEntries := NewPrintReversedEntries;
        MinVATDifference := Abs(ROUND(NewMinVATDifference));
    end;
}

