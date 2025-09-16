#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 130 "EC Sales List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/EC Sales List.rdlc';
    Caption = 'EC Sales List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Country/Region";"Country/Region")
        {
            DataItemTableView = sorting("EU Country/Region Code") where("EU Country/Region Code"=filter(<>''));
            column(ReportForNavId_4153; 4153)
            {
            }
            column(CompanyAddr1;CompanyAddr[1])
            {
            }
            column(CompanyAddr2;CompanyAddr[2])
            {
            }
            column(CompanyAddr3;CompanyAddr[3])
            {
            }
            column(CompanyAddr4;CompanyAddr[4])
            {
            }
            column(CompanyAddr5;CompanyAddr[5])
            {
            }
            column(CompanyAddr6;CompanyAddr[6])
            {
            }
            column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoHomePage;CompanyInfo."Home Page")
            {
            }
            column(CompanyInfoEMail;CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoVATRegistrationNo;CompanyInfo."VAT Registration No.")
            {
            }
            column(PageCaption;StrSubstNo(Text001,''))
            {
            }
            column(GLSetupLCYCode;StrSubstNo(Text000,GLSetup."LCY Code"))
            {
            }
            column(VATEntryTableCaptionFilter;"VAT Entry".TableCaption + ': ' + VATEntryFilter)
            {
            }
            column(VATEntryFilter;VATEntryFilter)
            {
            }
            column(ThirdPartyTrade;ThirdPartyTrade)
            {
            }
            column(NotEUTrdPartyAmtTotal;FormatNotEUTrdPartyAmt)
            {
            }
            column(NotEUTrdPartyAmtServiceTotal;FormatNotEUTrdPartyAmtService)
            {
            }
            column(FORMATTRUE;Format(true))
            {
            }
            column(EUTrdPartyAmtTotal;FormatEUTrdPartyAmt)
            {
            }
            column(EUTrdPartyAmtServiceTotal;FormatEUTrdPartyAmtService)
            {
            }
            column(ECSalesListCaption;ECSalesListCaptionLbl)
            {
            }
            column(CompanyInfoPhoneNoCaption;CompanyInfoPhoneNoCaptionLbl)
            {
            }
            column(CompanyInfoHomePageCaption;CompanyInfoHomePageCaptionLbl)
            {
            }
            column(CompanyInfoVATRegistrationNoCaption;CompanyInfoVATRegistrationNoCaptionLbl)
            {
            }
            column(TotalValueofItemSuppliesCaption;TotalValueofItemSuppliesCaptionLbl)
            {
            }
            column(EU3PartyTradeCaption;EU3PartyTradeCaptionLbl)
            {
            }
            column(TotalValueofServiceSuppliesCaption;TotalValueofServiceSuppliesCaptionLbl)
            {
            }
            column(EU3PartyItemTradeAmtCaption;EU3PartyItemTradeAmtCaptionLbl)
            {
            }
            column(EUPartySrvcTradeAmtCaption;EUPartySrvcTradeAmtCaptionLbl)
            {
            }
            column(NumberoflinesThispageCaption;NumberoflinesThispageCaptionLbl)
            {
            }
            column(NumberoflinesAllpagesCaption;NumberoflinesAllpagesCaptionLbl)
            {
            }
            column(CompanyInfoEMailCaption;CompanyInfoEMailCaptionLbl)
            {
            }
            dataitem("VAT Entry";"VAT Entry")
            {
                DataItemLink = "Country/Region Code"=field(Code);
                DataItemTableView = sorting(Type,"Country/Region Code","VAT Registration No.","VAT Bus. Posting Group","VAT Prod. Posting Group","Posting Date") where(Type=const(Sale),"Country/Region Code"=filter(<>''));
                RequestFilterFields = "VAT Bus. Posting Group","VAT Prod. Posting Group","Posting Date";
                column(ReportForNavId_7612; 7612)
                {
                }
                column(VATRegNo_VATEntry;"VAT Registration No.")
                {
                }
                column(VATRegNo_VATEntryCaption;FieldCaption("VAT Registration No."))
                {
                }
                column(CountryRegionEUCountryRegionCode;"Country/Region"."EU Country/Region Code")
                {
                }
                column(CountryRegionEUCountryRegionCodeCaption;"Country/Region".FieldCaption("EU Country/Region Code"))
                {
                }
                column(NotEUTrdPartyAmt;NotEUTrdPartyAmt)
                {
                }
                column(Grouping;Grouping)
                {
                    OptionCaption = 'NotEUTrdPartyAmt,NotEUTrdPartyAmtService,EUTrdPartyAmt,EUTrdPartyAmtService';
                }
                column(NotEUTrdPartyAmtService;NotEUTrdPartyAmtService)
                {
                }
                column(EUTrdPartyAmt;EUTrdPartyAmt)
                {
                }
                column(EUTrdPartyAmtService;EUTrdPartyAmtService)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if ResetVATEntry then begin
                      ResetVATEntry := false;
                      EUTrdPartyAmtService := 0;
                      NotEUTrdPartyAmtService := 0;
                      EUTrdPartyAmt := 0;
                      NotEUTrdPartyAmt := 0
                    end;

                    if "EU Service" then
                      if "EU 3-Party Trade" then
                        EUTrdPartyAmtService += Base
                      else
                        NotEUTrdPartyAmtService += Base
                    else
                      if "EU 3-Party Trade" then
                        EUTrdPartyAmt += Base
                      else
                        NotEUTrdPartyAmt += Base;

                    if ReportLayout = Reportlayout::"Separate &Lines" then begin
                      if NotEUTrdPartyAmt <> 0 then
                        Grouping := Grouping::NotEUTrdPartyAmt;
                      if NotEUTrdPartyAmtService <> 0 then
                        Grouping := Grouping::NotEUTrdPartyAmtService;
                      if EUTrdPartyAmt <> 0 then
                        Grouping := Grouping::EUTrdPartyAmt;
                      if EUTrdPartyAmtService <> 0 then
                        Grouping := Grouping::EUTrdPartyAmtService
                    end;

                    if not (VATEntry.Next = 0) then begin
                      if VATEntry."VAT Registration No." = "VAT Registration No." then
                        if ReportLayout = Reportlayout::"Separate &Lines" then begin
                          if (VATEntry."EU Service" = "EU Service") and (VATEntry."EU 3-Party Trade" = "EU 3-Party Trade") then
                            CurrReport.Skip
                        end else
                          CurrReport.Skip;
                      ResetVATEntry := true
                    end;

                    TotalEUTrdPartyAmtService += ROUND(EUTrdPartyAmtService,1);
                    TotalNotEUTrdPartyAmtService += ROUND(NotEUTrdPartyAmtService,1);
                    TotalEUTrdPartyAmt += ROUND(EUTrdPartyAmt,1);
                    TotalNotEUTrdPartyAmt += ROUND(NotEUTrdPartyAmt,1);
                    FormatEUTrdPartyAmtService := FormatAmt(TotalEUTrdPartyAmtService);
                    FormatNotEUTrdPartyAmtService := FormatAmt(TotalNotEUTrdPartyAmtService);
                    FormatEUTrdPartyAmt := FormatAmt(TotalEUTrdPartyAmt);
                    FormatNotEUTrdPartyAmt := FormatAmt(TotalNotEUTrdPartyAmt);
                end;

                trigger OnPreDataItem()
                begin
                    ResetVATEntry := true;
                    VATEntry.SetCurrentkey(
                      Type,"Country/Region Code","VAT Registration No.","VAT Bus. Posting Group","VAT Prod. Posting Group","Posting Date");
                    VATEntry.CopyFilters("VAT Entry");
                    if VATEntry.FindSet then;
                end;
            }

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                FormatAddr.Company(CompanyAddr,CompanyInfo);
                ThirdPartyTrade := (ReportLayout = Reportlayout::"Separate &Lines");
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
                    field(ReportLayout;ReportLayout)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Third Party Trade as';
                        OptionCaption = 'Separate Lines,Column with Amount';
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
        CompanyInfo.Get;
        FormatAddr.Company(CompanyAddr,CompanyInfo);

        VATEntryFilter := "VAT Entry".GetFilters;

        GLSetup.Get;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        VATEntry: Record "VAT Entry";
        FormatAddr: Codeunit "Format Address";
        VATEntryFilter: Text;
        CompanyAddr: array [8] of Text[50];
        EUTrdPartyAmt: Decimal;
        NotEUTrdPartyAmt: Decimal;
        EUTrdPartyAmtService: Decimal;
        Text000: label 'All amounts are in whole %1.';
        NotEUTrdPartyAmtService: Decimal;
        ReportLayout: Option "Separate &Lines","Column with &Amount";
        LineCountCurrentPage: Integer;
        LineCountAllPages: Integer;
        CurrentPageNo: Integer;
        Text001: label 'Page %1';
        ThirdPartyTrade: Boolean;
        ResetVATEntry: Boolean;
        Grouping: Option NotEUTrdPartyAmt,NotEUTrdPartyAmtService,EUTrdPartyAmt,EUTrdPartyAmtService;
        TotalNotEUTrdPartyAmt: Decimal;
        TotalEUTrdPartyAmt: Decimal;
        TotalNotEUTrdPartyAmtService: Decimal;
        TotalEUTrdPartyAmtService: Decimal;
        FormatNotEUTrdPartyAmt: Text[30];
        FormatEUTrdPartyAmt: Text[30];
        FormatNotEUTrdPartyAmtService: Text[30];
        FormatEUTrdPartyAmtService: Text[30];
        ECSalesListCaptionLbl: label 'EC Sales List';
        CompanyInfoPhoneNoCaptionLbl: label 'Phone No.';
        CompanyInfoHomePageCaptionLbl: label 'Home Page';
        CompanyInfoVATRegistrationNoCaptionLbl: label 'Tax Registration No.';
        TotalValueofItemSuppliesCaptionLbl: label 'Total Value of Item Supplies';
        EU3PartyTradeCaptionLbl: label 'EU 3-Party Trade';
        TotalValueofServiceSuppliesCaptionLbl: label 'Total Value of Service Supplies';
        EU3PartyItemTradeAmtCaptionLbl: label 'EU 3-Party Item Trade Amount';
        EUPartySrvcTradeAmtCaptionLbl: label 'EU 3-Party Service Trade Amount';
        NumberoflinesThispageCaptionLbl: label 'Number of lines (this page)';
        NumberoflinesAllpagesCaptionLbl: label 'Number of lines (all pages)';
        CompanyInfoEMailCaptionLbl: label 'Email';

    local procedure FormatAmt(AmountToPrint: Decimal): Text[30]
    var
        TextAmt: Text[30];
    begin
        TextAmt := Format(ROUND(-AmountToPrint,1),0,'<Integer Thousand><Decimals>');
        if AmountToPrint > 0 then
          TextAmt := '(' + TextAmt + ')';
        exit(TextAmt);
    end;


    procedure IncrLineCount()
    begin
        if CurrReport.PageNo > CurrentPageNo then begin
          LineCountCurrentPage := 0;
          CurrentPageNo := CurrReport.PageNo;
        end;
        LineCountCurrentPage := LineCountCurrentPage + 1;
        LineCountAllPages := LineCountAllPages + 1;
    end;


    procedure InitializeRequest(NewReportLayout: Option)
    begin
        ReportLayout := NewReportLayout;
    end;
}

