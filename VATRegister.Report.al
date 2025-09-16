#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 13 "VAT Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VAT Register.rdlc';
    Caption = 'Tax Register';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("G/L Register";"G/L Register")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(ReportForNavId_9922; 9922)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(GLSetupLCYCode;GLSetup."LCY Code")
            {
            }
            column(GLSetupAddReportCurr;GLSetup."Additional Reporting Currency")
            {
            }
            column(AllamountsareIn;AllamountsareInLbl)
            {
            }
            column(GLRegFilter_GLRegister;TableCaption + ': ' + GLRegFilter)
            {
            }
            column(GLRegFilter;GLRegFilter)
            {
            }
            column(No_GLRegister;"No.")
            {
            }
            column(VATRegisterCaption;VATRegisterCaptionLbl)
            {
            }
            column(PageNoCaption;PageNoCaptionLbl)
            {
            }
            column(PostingDateCaption;PostingDateCaptionLbl)
            {
            }
            column(DocumentTypeCaption;DocumentTypeCaptionLbl)
            {
            }
            column(GenBusPostingGroupCaption;GenBusPostingGroupCaptionLbl)
            {
            }
            column(GenProdPostingGroupCaption;GenProdPostingGroupCaptionLbl)
            {
            }
            column(VATCalculationTypeCaption;VATCalculationTypeCaptionLbl)
            {
            }
            column(EU3PartyTradeCaption;EU3PartyTradeCaptionLbl)
            {
            }
            column(VATEntryClosedCaption;CaptionClassTranslate("VAT Entry".FieldCaption(Closed)))
            {
            }
            column(GLRegisterNoCaption;GLRegisterNoCaptionLbl)
            {
            }
            dataitem("VAT Entry";"VAT Entry")
            {
                DataItemTableView = sorting("Entry No.");
                column(ReportForNavId_7612; 7612)
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
                column(GenBusPostGroup_VatEntry;"Gen. Bus. Posting Group")
                {
                }
                column(GenPostGroup_VatEntry;"Gen. Prod. Posting Group")
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
                column(Closed_VatEntry;Format(Closed))
                {
                }
                column(ClosedEntryNo_VatEntry;"Closed by Entry No.")
                {
                    IncludeCaption = true;
                }
                column(EntryNo_VatEntry;"Entry No.")
                {
                    IncludeCaption = true;
                }
                column(AdditionalCurr_VatEntry;UseAmtsInAddCurr)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if UseAmtsInAddCurr then begin
                      Base := "Additional-Currency Base";
                      Amount := "Additional-Currency Amount";
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Entry No.","G/L Register"."From VAT Entry No.","G/L Register"."To VAT Entry No.");
                end;
            }

            trigger OnPreDataItem()
            begin
                GLSetup.Get;
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
                    field(UseAmtsInAddCurr;UseAmtsInAddCurr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Amounts in Add. Reporting Currency';
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
    }

    trigger OnPreReport()
    begin
        GLRegFilter := "G/L Register".GetFilters;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GLRegFilter: Text;
        UseAmtsInAddCurr: Boolean;
        AllamountsareInLbl: label 'All amounts are in';
        VATRegisterCaptionLbl: label 'Tax Register';
        PageNoCaptionLbl: label 'Page';
        PostingDateCaptionLbl: label 'Posting Date';
        DocumentTypeCaptionLbl: label 'Document Type';
        GenBusPostingGroupCaptionLbl: label 'Gen. Bus. Posting Group';
        GenProdPostingGroupCaptionLbl: label 'Gen. Prod. Posting Group';
        VATCalculationTypeCaptionLbl: label 'VAT Calculation Type';
        EU3PartyTradeCaptionLbl: label 'EU 3-Party Trade';
        GLRegisterNoCaptionLbl: label 'Register No.';

    local procedure GetCurrency(): Code[10]
    begin
        if UseAmtsInAddCurr then
          exit(GLSetup."Additional Reporting Currency");

        exit('');
    end;


    procedure InitializeRequest(NewUseAmtsInAddCurr: Boolean)
    begin
        UseAmtsInAddCurr := NewUseAmtsInAddCurr;
    end;
}

