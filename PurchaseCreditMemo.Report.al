#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10120 "Purchase Credit Memo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase Credit Memo.rdlc';
    Caption = 'Purchase Credit Memo';

    dataset
    {
        dataitem("Purch. Cr. Memo Hdr.";"Purch. Cr. Memo Hdr.")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Buy-from Vendor No.","Pay-to Vendor No.","No. Printed";
            column(ReportForNavId_9869; 9869)
            {
            }
            column(No_PurchCrMemoHdr;"No.")
            {
            }
            dataitem(CopyLoop;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_5701; 5701)
                {
                }
                dataitem(PageLoop;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=const(1));
                    column(ReportForNavId_6455; 6455)
                    {
                    }
                    column(CompanyAddress1;CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress2;CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress3;CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress4;CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress5;CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress6;CompanyAddress[6])
                    {
                    }
                    column(CopyTxt;CopyTxt)
                    {
                    }
                    column(BuyFromAddress1;BuyFromAddress[1])
                    {
                    }
                    column(BuyFromAddress2;BuyFromAddress[2])
                    {
                    }
                    column(BuyFromAddress3;BuyFromAddress[3])
                    {
                    }
                    column(BuyFromAddress4;BuyFromAddress[4])
                    {
                    }
                    column(BuyFromAddress5;BuyFromAddress[5])
                    {
                    }
                    column(BuyFromAddress6;BuyFromAddress[6])
                    {
                    }
                    column(BuyFromAddress7;BuyFromAddress[7])
                    {
                    }
                    column(AppDocType_PurchCrMemoHdr;"Purch. Cr. Memo Hdr."."Applies-to Doc. Type")
                    {
                    }
                    column(ShipToAddress1;ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress2;ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress3;ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress4;ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress5;ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress6;ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress7;ShipToAddress[7])
                    {
                    }
                    column(PaytoVendNo_PurchCrMemoHdr;"Purch. Cr. Memo Hdr."."Pay-to Vendor No.")
                    {
                    }
                    column(YourRef_PurchCrMemoHdr;"Purch. Cr. Memo Hdr."."Your Reference")
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(VendCrMemoNo_PurchCrMemoHdr;"Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.")
                    {
                    }
                    column(DocDate_PurchCrMemoHdr;"Purch. Cr. Memo Hdr."."Document Date")
                    {
                    }
                    column(CompanyAddress7;CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8;CompanyAddress[8])
                    {
                    }
                    column(BuyFromAddress8;BuyFromAddress[8])
                    {
                    }
                    column(ShipToAddress8;ShipToAddress[8])
                    {
                    }
                    column(AppDocNo_PurchCrMemoHdr;"Purch. Cr. Memo Hdr."."Applies-to Doc. No.")
                    {
                    }
                    column(CopyNo;CopyNo)
                    {
                    }
                    column(VendTaxIdentificationType;Format(Vend."Tax Identification Type"))
                    {
                    }
                    column(ToCaption;ToCaptionLbl)
                    {
                    }
                    column(ApplytoTypeCaption;ApplytoTypeCaptionLbl)
                    {
                    }
                    column(VendorIDCaption;VendorIDCaptionLbl)
                    {
                    }
                    column(ConfirmToCaption;ConfirmToCaptionLbl)
                    {
                    }
                    column(BuyerCaption;BuyerCaptionLbl)
                    {
                    }
                    column(ShipCaption;ShipCaptionLbl)
                    {
                    }
                    column(PurchCreditMemoCaption;PurchCreditMemoCaptionLbl)
                    {
                    }
                    column(PurchaseCreditMemoNumberCaption;PurchaseCreditMemoNumberCaptionLbl)
                    {
                    }
                    column(PurchaseCreditMemoDateCaption;PurchaseCreditMemoDateCaptionLbl)
                    {
                    }
                    column(PageCaption;PageCaptionLbl)
                    {
                    }
                    column(ApplytoNumberCaption;ApplytoNumberCaptionLbl)
                    {
                    }
                    column(PayCaption;PayCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption;TaxIdentTypeCaptionLbl)
                    {
                    }
                    dataitem("Purch. Cr. Memo Line";"Purch. Cr. Memo Line")
                    {
                        DataItemLink = "Document No."=field("No.");
                        DataItemLinkReference = "Purch. Cr. Memo Hdr.";
                        DataItemTableView = sorting("Document No.","Line No.");
                        column(ReportForNavId_7507; 7507)
                        {
                        }
                        column(AmountExclInvDisc;AmountExclInvDisc)
                        {
                        }
                        column(ItemNumberToPrint;ItemNumberToPrint)
                        {
                        }
                        column(UOM_PurchCrMemoLine;"Unit of Measure")
                        {
                        }
                        column(Quantity_PurchCrMemoLine;Quantity)
                        {
                        }
                        column(UnitPriceToPrint;UnitPriceToPrint)
                        {
                            DecimalPlaces = 2:5;
                        }
                        column(Desc_PurchCrMemoLine;Description)
                        {
                        }
                        column(AmountExclInvDisc1;Amount - AmountExclInvDisc)
                        {
                        }
                        column(AmountIncludingVATAmount;"Amount Including VAT" - Amount)
                        {
                        }
                        column(AmtIncluVAT_PurchCrMemoLine;"Amount Including VAT")
                        {
                        }
                        column(BreakdownLabel1;BreakdownLabel[1])
                        {
                        }
                        column(BreakdownTitle;BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel2;BreakdownLabel[2])
                        {
                        }
                        column(BreakdownLabel3;BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt1;BreakdownAmt[1])
                        {
                        }
                        column(BreakdownAmt2;BreakdownAmt[2])
                        {
                        }
                        column(BreakdownAmt3;BreakdownAmt[3])
                        {
                        }
                        column(BreakdownAmt4;BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel4;BreakdownLabel[4])
                        {
                        }
                        column(TotalTaxLabel;TotalTaxLabel)
                        {
                        }
                        column(PrintFooter;PrintFooter)
                        {
                        }
                        column(LineNo_PurchCrMemoLine;"Line No.")
                        {
                        }
                        column(ItemNoCaption;ItemNoCaptionLbl)
                        {
                        }
                        column(UnitCaption;UnitCaptionLbl)
                        {
                        }
                        column(DescriptionCaption;DescriptionCaptionLbl)
                        {
                        }
                        column(QuantityCaption;QuantityCaptionLbl)
                        {
                        }
                        column(UnitPriceCaption;UnitPriceCaptionLbl)
                        {
                        }
                        column(TotalPriceCaption;TotalPriceCaptionLbl)
                        {
                        }
                        column(SubtotalCaption;SubtotalCaptionLbl)
                        {
                        }
                        column(InvoiceDiscountCaption;InvoiceDiscountCaptionLbl)
                        {
                        }
                        column(TotalCaption;TotalCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            if Type = 0 then begin
                              ItemNumberToPrint := '';
                              "Unit of Measure" := '';
                              Amount := 0;
                              "Amount Including VAT" := 0;
                              "Inv. Discount Amount" := 0;
                              Quantity := 0;
                            end else
                              if Type = Type::"G/L Account" then
                                ItemNumberToPrint := "Vendor Item No."
                              else
                                ItemNumberToPrint := "No.";

                            if Amount <> "Amount Including VAT" then
                              TaxLiable := Amount
                            else
                              TaxLiable := 0;

                            AmountExclInvDisc := Amount + "Inv. Discount Amount";

                            if Quantity = 0 then
                              UnitPriceToPrint := 0 // so it won't print
                            else
                              UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity,0.00001);
                            if OnLineNumber = NumberOfLines then
                              PrintFooter := true;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(TaxLiable,AmountExclInvDisc,Amount,"Amount Including VAT");
                            NumberOfLines := Count;
                            OnLineNumber := 0;
                            PrintFooter := false;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    CurrReport.PageNo := 1;

                    if CopyNo = NoLoops then begin
                      if not CurrReport.Preview then
                        PurchaseCrMemoPrinted.Run("Purch. Cr. Memo Hdr.");
                      CurrReport.Break;
                    end;
                    CopyNo := CopyNo + 1;
                    if CopyNo = 1 then // Original
                      Clear(CopyTxt)
                    else
                      CopyTxt := Text000;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + Abs(NoCopies);
                    if NoLoops <= 0 then
                      NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if PrintCompany then
                  if RespCenter.Get("Responsibility Center") then begin
                    FormatAddress.RespCenter(CompanyAddress,RespCenter);
                    CompanyInformation."Phone No." := RespCenter."Phone No.";
                    CompanyInformation."Fax No." := RespCenter."Fax No.";
                  end;
                CurrReport.Language := Language.GetLanguageID("Language Code");

                if "Purchaser Code" = '' then
                  Clear(SalesPurchPerson)
                else
                  SalesPurchPerson.Get("Purchaser Code");

                if "Pay-to Vendor No." = '' then begin
                  "Buy-from Vendor Name" := Text009;
                  "Ship-to Name" := Text009;
                end;

                FormatAddress.PurchCrMemoPayTo(BuyFromAddress,"Purch. Cr. Memo Hdr.");
                FormatAddress.PurchCrMemoShipTo(ShipToAddress,"Purch. Cr. Memo Hdr.");

                if LogInteraction then
                  if not CurrReport.Preview then
                    SegManagement.LogDocument(
                      16,"No.",0,0,Database::Vendor,"Buy-from Vendor No.","Purchaser Code",'',"Posting Description",'');

                Clear(BreakdownTitle);
                Clear(BreakdownLabel);
                Clear(BreakdownAmt);
                TotalTaxLabel := Text008;
                if "Tax Area Code" <> '' then begin
                  TaxArea.Get("Tax Area Code");
                  case TaxArea."Country/Region" of
                    TaxArea."country/region"::US:
                      TotalTaxLabel := Text005;
                    TaxArea."country/region"::CA:
                      TotalTaxLabel := Text007;
                  end;
                  SalesTaxCalc.StartSalesTaxCalculation;
                  if TaxArea."Use External Tax Engine" then
                    SalesTaxCalc.CallExternalTaxEngineForDoc(Database::"Purch. Cr. Memo Hdr.",0,"No.")
                  else begin
                    SalesTaxCalc.AddPurchCrMemoLines("No.");
                    SalesTaxCalc.EndSalesTaxCalculation("Posting Date");
                  end;
                  SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                  BrkIdx := 0;
                  PrevPrintOrder := 0;
                  PrevTaxPercent := 0;
                  with TempSalesTaxAmtLine do begin
                    Reset;
                    SetCurrentkey("Print Order","Tax Area Code for Key","Tax Jurisdiction Code");
                    if Find('-') then
                      repeat
                        if ("Print Order" = 0) or
                           ("Print Order" <> PrevPrintOrder) or
                           ("Tax %" <> PrevTaxPercent)
                        then begin
                          BrkIdx := BrkIdx + 1;
                          if BrkIdx > 1 then begin
                            if TaxArea."Country/Region" = TaxArea."country/region"::CA then
                              BreakdownTitle := Text006
                            else
                              BreakdownTitle := Text003;
                          end;
                          if BrkIdx > ArrayLen(BreakdownAmt) then begin
                            BrkIdx := BrkIdx - 1;
                            BreakdownLabel[BrkIdx] := Text004;
                          end else
                            BreakdownLabel[BrkIdx] := StrSubstNo("Print Description","Tax %");
                        end;
                        BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Amount";
                      until Next = 0;
                  end;
                  if BrkIdx = 1 then begin
                    Clear(BreakdownLabel);
                    Clear(BreakdownAmt);
                  end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if PrintCompany then
                  FormatAddress.Company(CompanyAddress,CompanyInformation)
                else
                  Clear(CompanyAddress);
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
                    field(NumberOfCopies;NoCopies)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Number of Copies';
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                    field(PrintCompanyAddress;PrintCompany)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.';
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            LogInteraction := SegManagement.FindInteractTmplCode(16) <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get('');
    end;

    var
        TaxLiable: Decimal;
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;
        TaxArea: Record "Tax Area";
        Vend: Record Vendor;
        CompanyAddress: array [8] of Text[50];
        BuyFromAddress: array [8] of Text[50];
        ShipToAddress: array [8] of Text[50];
        CopyTxt: Text[10];
        ItemNumberToPrint: Text[20];
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        PurchaseCrMemoPrinted: Codeunit "PurchCrMemo-Printed";
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        SegManagement: Codeunit SegManagement;
        LogInteraction: Boolean;
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        BreakdownLabel: array [4] of Text[30];
        BreakdownAmt: array [4] of Decimal;
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        Text000: label 'COPY';
        Text003: label 'Sales Tax Breakdown:';
        Text004: label 'Other Taxes';
        Text005: label 'Total Sales Tax:';
        Text006: label 'Tax Breakdown:';
        Text007: label 'Total Tax:';
        Text008: label 'Tax:';
        Text009: label 'VOID CREDIT MEMO';
        [InDataSet]
        LogInteractionEnable: Boolean;
        ToCaptionLbl: label 'To:';
        ApplytoTypeCaptionLbl: label 'Apply to Type';
        VendorIDCaptionLbl: label 'Vendor ID';
        ConfirmToCaptionLbl: label 'Confirm To';
        BuyerCaptionLbl: label 'Buyer';
        ShipCaptionLbl: label 'Ship';
        PurchCreditMemoCaptionLbl: label 'Purchase Credit Memo';
        PurchaseCreditMemoNumberCaptionLbl: label 'Purchase Credit Memo Number:';
        PurchaseCreditMemoDateCaptionLbl: label 'Purchase Credit Memo Date:';
        PageCaptionLbl: label 'Page';
        ApplytoNumberCaptionLbl: label 'Apply to Number';
        PayCaptionLbl: label 'Pay';
        TaxIdentTypeCaptionLbl: label 'Tax Ident. Type';
        ItemNoCaptionLbl: label 'Item No.';
        UnitCaptionLbl: label 'Unit';
        DescriptionCaptionLbl: label 'Description';
        QuantityCaptionLbl: label 'Quantity';
        UnitPriceCaptionLbl: label 'Unit Price';
        TotalPriceCaptionLbl: label 'Total Price';
        SubtotalCaptionLbl: label 'Subtotal';
        InvoiceDiscountCaptionLbl: label 'Invoice Discount:';
        TotalCaptionLbl: label 'Total';
}

