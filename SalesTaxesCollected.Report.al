#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 24 "Sales Taxes Collected"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales Taxes Collected.rdlc';
    Caption = 'Sales Taxes Collected';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(ReportToJurisdiction;"Tax Jurisdiction")
        {
            DataItemTableView = sorting("Report-to Jurisdiction");
            column(ReportForNavId_7051; 7051)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Report-to Jurisdiction" = '' then
                  CurrReport.Skip;
                if "Report-to Jurisdiction" <> TempTaxJurisdiction.Code then begin
                  TempTaxJurisdiction.Code := "Report-to Jurisdiction";
                  if LookupTaxJurisdiction.Get("Report-to Jurisdiction") then
                    TempTaxJurisdiction.Description := LookupTaxJurisdiction.Description
                  else
                    TempTaxJurisdiction.Description := Text003;
                  TempTaxJurisdiction.Insert;
                end;
            end;

            trigger OnPostDataItem()
            begin
                NumReportTo := TempTaxJurisdiction.Count;
            end;

            trigger OnPreDataItem()
            begin
                TempTaxJurisdiction.DeleteAll;
                TempTaxJurisdiction.Init;
                SetFilter("Report-to Jurisdiction",ReportToFilter);
            end;
        }
        dataitem(CurReportTo;"Integer")
        {
            DataItemTableView = sorting(Number);
            column(ReportForNavId_2952; 2952)
            {
            }
            dataitem("Tax Jurisdiction";"Tax Jurisdiction")
            {
                DataItemTableView = sorting(Code);
                RequestFilterFields = "Code","Report-to Jurisdiction","Tax Group Filter","Date Filter";
                column(ReportForNavId_7666; 7666)
                {
                }
                column(Title;Title)
                {
                }
                column(Time;Time)
                {
                }
                column(CompanyInfoName;CompanyInfo.Name)
                {
                }
                column(SubTitle;SubTitle)
                {
                }
                column(TaxInclusions;TaxInclusions)
                {
                }
                column(JurisFltr_TaxJurisdiction;"Tax Jurisdiction".TableCaption + ': ' + JurisFilters)
                {
                }
                column(JurisFltr;JurisFilters)
                {
                }
                column(ReportType;ReportType)
                {
                }
                column(ReportTypeIsSummary;(ReportType = Reporttype::Summary))
                {
                }
                column(ReportTypeIsDetail;(ReportType = Reporttype::Detail))
                {
                }
                column(ReportTypeIsNormal;(ReportType = Reporttype::Normal))
                {
                }
                column("Code";TableCaption + ' ' + FieldCaption(Code) + ': ' + Code)
                {
                }
                column(Desc_TaxJurisdiction;Description)
                {
                }
                column(ReporttoJurisd_TaxJurisdiction;"Tax Jurisdiction"."Report-to Jurisdiction")
                {
                }
                column(TotalSalesTaxCollected;StrSubstNo(Text004,FieldCaption("Report-to Jurisdiction"),"Report-to Jurisdiction"))
                {
                }
                column(SalesTaxAmt;SalesTaxAmount)
                {
                    AutoFormatType = 1;
                }
                column(Code_TaxJurisdiction;Code)
                {
                }
                column(DateFltr_TaxJurisdiction;"Date Filter")
                {
                }
                column(PageCaption;PageCaptionLbl)
                {
                }
                column(SalesTaxAmountCaption;SalesTaxAmountCaptionLbl)
                {
                }
                column(TaxableSalesAmountCaption;TaxableSalesAmountCaptionLbl)
                {
                }
                column(NontaxableSalesAmountCaption;NontaxableSalesAmountCaptionLbl)
                {
                }
                column(ExemptSalesAmountCaption;ExemptSalesAmountCaptionLbl)
                {
                }
                column(DescriptionCaption;DescriptionCaptionLbl)
                {
                }
                column(TaxGroupCodeCaption;TaxGroupCodeCaptionLbl)
                {
                }
                column(RecoverablePurchaseCaption;RecoverablePurchaseCaptionLbl)
                {
                }
                column(DocNo_VATEntryCaption;"VAT Entry".FieldCaption("Document No."))
                {
                }
                column(DocType_VATEntryCaption;"VAT Entry".FieldCaption("Document Type"))
                {
                }
                column(PostingDate_VATEntryCaption;"VAT Entry".FieldCaption("Posting Date"))
                {
                }
                column(UseTax_VATEntryCaption;"VAT Entry".FieldCaption("Use Tax"))
                {
                }
                column(Type_VATEntryCaption;"VAT Entry".FieldCaption(Type))
                {
                }
                column(BilltoPaytoNo_VATEntryCaption;"VAT Entry".FieldCaption("Bill-to/Pay-to No."))
                {
                }
                column(TaxJurisdictionCode_VATEntryCaption;"VAT Entry".FieldCaption("Tax Jurisdiction Code"))
                {
                }
                dataitem("VAT Entry";"VAT Entry")
                {
                    DataItemLink = "Tax Jurisdiction Code"=field(Code),"Tax Group Used"=field("Tax Group Filter"),"Posting Date"=field("Date Filter");
                    DataItemTableView = sorting("Tax Jurisdiction Code","Tax Group Used","Tax Type","Use Tax","Posting Date") where("Tax Type"=filter("Sales and Use Tax"|"Sales Tax Only"|"Use Tax Only"));
                    column(ReportForNavId_7612; 7612)
                    {
                    }
                    column(TaxGroupCodeUsed;FieldCaption("Tax Group Code") + ': ' + "Tax Group Used")
                    {
                    }
                    column(TaxGroupDesc;TaxGroup.Description)
                    {
                    }
                    column(SalesTaxAmt1;SalesTaxAmount)
                    {
                        AutoFormatType = 1;
                    }
                    column(BilltoPaytoNo_VATEntry;"Bill-to/Pay-to No.")
                    {
                    }
                    column(TaxableSalesAmt;TaxableSalesAmount)
                    {
                        AutoFormatType = 1;
                    }
                    column(NonTaxableSalesAmt;NonTaxableSalesAmount)
                    {
                        AutoFormatType = 1;
                    }
                    column(ExemptSalesAmt;ExemptSalesAmount)
                    {
                        AutoFormatType = 1;
                    }
                    column(DocNo_VATEntry;"Document No.")
                    {
                    }
                    column(DocType_VATEntry;"Document Type")
                    {
                    }
                    column(PostingDate_VATEntry;"Posting Date")
                    {
                    }
                    column(UseTax_VATEntry;"Use Tax")
                    {
                    }
                    column(UseTaxtxt;UseTaxtxt)
                    {
                    }
                    column(Type_VATEntry;Type)
                    {
                    }
                    column(UseTax1_VATEntry;Format((Type = Type::Purchase) and not "Use Tax"))
                    {
                    }
                    column(TaxGroupUsed_VATEntry;"Tax Group Used")
                    {
                    }
                    column(TotalTaxGroupCodeTaxGroupUsed;StrSubstNo(Text005,FieldCaption("Tax Group Code"),"Tax Group Used"))
                    {
                    }
                    column(TaxJurisdictionCode_VATEntry;"Tax Jurisdiction Code")
                    {
                    }
                    column(TotalTaxJurisdictionCode;StrSubstNo(Text005,FieldCaption("Tax Jurisdiction Code"),"Tax Jurisdiction Code"))
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if ((Type = Type::Purchase) and (IncludePurchases or IncludeUseTax)) or
                           ((Type = Type::Sale) and IncludeSales)
                        then begin
                          if Type = Type::Purchase then
                            if ("Use Tax" and not IncludeUseTax) or
                               (not "Use Tax" and not IncludePurchases)
                            then
                              CurrReport.Skip;

                          Amount := -Amount;
                          Base := -Base;

                          SalesTaxAmount := Amount;
                          if Amount = 0 then
                            if "Tax Liable" then
                              NonTaxableSalesAmount := Base
                            else
                              ExemptSalesAmount := Base
                          else
                            TaxableSalesAmount := Base;
                        end else
                          CurrReport.Skip;

                        if ReportType <> Reporttype::Summary then
                          if "Tax Group Used" <> '' then
                            TaxGroup.Get("Tax Group Used")
                          else
                            TaxGroup.Init;
                        UseTaxtxt := Format("VAT Entry"."Use Tax");
                    end;

                    trigger OnPreDataItem()
                    begin
                        CurrReport.CreateTotals(NonTaxableSalesAmount,TaxableSalesAmount,ExemptSalesAmount,SalesTaxAmount);
                    end;
                }

                trigger OnPreDataItem()
                begin
                    SetRange("Report-to Jurisdiction",TempTaxJurisdiction.Code);
                    CurrReport.CreateTotals(NonTaxableSalesAmount,TaxableSalesAmount,ExemptSalesAmount,SalesTaxAmount);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                  TempTaxJurisdiction.Find('-')
                else
                  TempTaxJurisdiction.Next;
                CurrReport.PageNo := 1;
                SubTitle := TempTaxJurisdiction.FieldCaption("Report-to Jurisdiction") +
                  ': ' +
                  TempTaxJurisdiction.Code +
                  '  (' +
                  TempTaxJurisdiction.Description +
                  ')';
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number,1,NumReportTo);
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
                    field(ReportType;ReportType)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Report Type';
                        OptionCaption = 'Summary,Normal,Detail';
                        ToolTip = 'Specifies one of the available report types to determine how detailed you want the report to be.';
                    }
                    field(IncludeSales;IncludeSales)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Include Sales';
                        ToolTip = 'Specifies if sales tax related to sales is included in the report.';
                    }
                    field(IncludePurchases;IncludePurchases)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Include Purchases';
                        ToolTip = 'Specifies if sales tax related to purchases is included in the report.';
                    }
                    field(IncludeUseTax;IncludeUseTax)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Include Use Tax';
                        ToolTip = 'Specifies if you want the report to include tax entries on which the tax amounts are marked as use tax.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if not IncludeSales and not IncludePurchases and not IncludeUseTax then
              IncludeSales := true;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if IncludeSales then
          if IncludePurchases then
            if IncludeUseTax then
              TaxInclusions := USText013
            else
              TaxInclusions := USText010
          else
            if IncludeUseTax then
              TaxInclusions := USText011
            else
              TaxInclusions := USText007
        else
          if IncludePurchases then
            if IncludeUseTax then
              TaxInclusions := USText012
            else
              TaxInclusions := USText008
          else
            if IncludeUseTax then
              TaxInclusions := USText009
            else
              Error(USText006);

        CompanyInfo.Get;
        ReportToFilter := "Tax Jurisdiction".GetFilter("Report-to Jurisdiction");
        "Tax Jurisdiction".SetRange("Report-to Jurisdiction");
        JurisFilters := "Tax Jurisdiction".GetFilters;

        case ReportType of
          Reporttype::Summary:
            Title := Text000;
          Reporttype::Normal:
            Title := Text001;
          Reporttype::Detail:
            Title := Text002;
        end;
    end;

    var
        Text000: label 'Sales Taxes Collected, Summary';
        Text001: label 'Sales Taxes Collected';
        Text002: label 'Sales Taxes Collected, Detail';
        Text003: label 'Unknown Jurisdiction';
        Text004: label 'Total Sales Taxes Collected for %1: %2';
        Text005: label 'Total for %1: %2';
        CompanyInfo: Record "Company Information";
        TempTaxJurisdiction: Record "Tax Jurisdiction" temporary;
        LookupTaxJurisdiction: Record "Tax Jurisdiction";
        TaxGroup: Record "Tax Group";
        ReportType: Option Summary,Normal,Detail;
        JurisFilters: Text;
        ReportToFilter: Text[250];
        Title: Text[132];
        SubTitle: Text[132];
        TaxInclusions: Text[132];
        NumReportTo: Integer;
        NonTaxableSalesAmount: Decimal;
        TaxableSalesAmount: Decimal;
        ExemptSalesAmount: Decimal;
        SalesTaxAmount: Decimal;
        IncludeUseTax: Boolean;
        UseTaxtxt: Text[30];
        IncludeSales: Boolean;
        IncludePurchases: Boolean;
        USText006: label 'You must check at least one of the check boxes labeled Include...';
        USText007: label 'Includes Taxes Collected From Sales Only';
        USText008: label 'Includes Recoverable Taxes Paid On Purchases Only';
        USText009: label 'Includes Use Taxes Only';
        USText010: label 'Includes Taxes Collected and Recoverable Taxes Paid';
        USText011: label 'Includes Taxes Collected From Sales and Use Taxes';
        USText012: label 'Includes Recoverable Taxes Paid On Purchases and Use Taxes';
        USText013: label 'Includes Taxes Collected, Recoverable Taxes Paid, and Use Taxes';
        PageCaptionLbl: label 'Page';
        SalesTaxAmountCaptionLbl: label 'Sales Tax Amount';
        TaxableSalesAmountCaptionLbl: label 'Taxable Sales Amount';
        NontaxableSalesAmountCaptionLbl: label 'Nontaxable Sales Amount';
        ExemptSalesAmountCaptionLbl: label 'Exempt Sales Amount';
        DescriptionCaptionLbl: label 'Description';
        TaxGroupCodeCaptionLbl: label 'Tax Group Code';
        RecoverablePurchaseCaptionLbl: label 'Recoverable Purchase';
}

