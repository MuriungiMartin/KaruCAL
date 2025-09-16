#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10119 "Purchase Blanket Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase Blanket Order.rdlc';
    Caption = 'Purchase Blanket Order';

    dataset
    {
        dataitem("Purchase Header";"Purchase Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const("Blanket Order"));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Buy-from Vendor No.","Pay-to Vendor No.","No. Printed";
            column(ReportForNavId_4458; 4458)
            {
            }
            column(DocumentType_PurchHeader;"Document Type")
            {
            }
            column(No_PurchHeader;"No.")
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
                    column(ExpectRcptDt_PurchHeader;"Purchase Header"."Expected Receipt Date")
                    {
                    }
                    column(BlanketPurchaseOrder;StrSubstNo(Text009,CopyText))
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
                    column(BuyfromVenNo_PurchHeader;"Purchase Header"."Buy-from Vendor No.")
                    {
                    }
                    column(YourRef_PurchHeader;"Purchase Header"."Your Reference")
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(OrderDate_PurchHeader;"Purchase Header"."Order Date")
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
                    column(ShipmentMethodDescription;ShipmentMethod.Description)
                    {
                    }
                    column(PaymentTermsDescription;PaymentTerms.Description)
                    {
                    }
                    column(CompanyInformationPhoneNo;CompanyInformation."Phone No.")
                    {
                    }
                    column(CopyNo;CopyNo)
                    {
                    }
                    column(PrintFooter;PrintFooter)
                    {
                    }
                    column(VendTaxIdentificationType;Format(Vend."Tax Identification Type"))
                    {
                    }
                    column(ReceiveByCaption;ReceiveByCaptionLbl)
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
                    column(PurchaseOrderNumberCaption;PurchaseOrderNumberCaptionLbl)
                    {
                    }
                    column(PurchaseOrderDateCaption;PurchaseOrderDateCaptionLbl)
                    {
                    }
                    column(PageCaption;PageCaptionLbl)
                    {
                    }
                    column(ShipViaCaption;ShipViaCaptionLbl)
                    {
                    }
                    column(TermsCaption;TermsCaptionLbl)
                    {
                    }
                    column(PhoneNoCaption;PhoneNoCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption;TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(ToCaption;ToCaptionLbl)
                    {
                    }
                    dataitem("Purchase Line";"Purchase Line")
                    {
                        DataItemLink = "Document No."=field("No.");
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = sorting("Document Type","Document No.","Line No.") where("Document Type"=const("Blanket Order"));
                        column(ReportForNavId_6547; 6547)
                        {
                        }
                        column(AmountExclInvDisc;AmountExclInvDisc)
                        {
                        }
                        column(ItemNumberToPrint;ItemNumberToPrint)
                        {
                        }
                        column(UnitofMeasure_PurchLine;"Unit of Measure")
                        {
                        }
                        column(Quantity_PurchLine;Quantity)
                        {
                        }
                        column(UnitPriceToPrint;UnitPriceToPrint)
                        {
                            DecimalPlaces = 2:5;
                        }
                        column(Description_PurchLine;Description)
                        {
                        }
                        column(InvDiscountAmt_PurchLine;"Inv. Discount Amount")
                        {
                        }
                        column(TaxAmount;TaxAmount)
                        {
                        }
                        column(LineAmtTaxAmtInvDiscAmt;"Line Amount" + TaxAmount - "Inv. Discount Amount")
                        {
                        }
                        column(TotalTaxLabel;TotalTaxLabel)
                        {
                        }
                        column(BreakdownTitle;BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel1;BreakdownLabel[1])
                        {
                        }
                        column(BreakdownAmt1;BreakdownAmt[1])
                        {
                        }
                        column(BreakdownLabel2;BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt2;BreakdownAmt[2])
                        {
                        }
                        column(BreakdownLabel3;BreakdownLabel[3])
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
                        column(DocumentNo_PurchLine;"Document No.")
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

                            if ("Purchase Header"."Tax Area Code" <> '') and not UseExternalTaxEngine then
                              SalesTaxCalc.AddPurchLine("Purchase Line");

                            if "Vendor Item No." <> '' then
                              ItemNumberToPrint := "Vendor Item No."
                            else
                              ItemNumberToPrint := "No.";

                            if Type = 0 then begin
                              ItemNumberToPrint := '';
                              "Unit of Measure" := '';
                              "Line Amount" := 0;
                              "Inv. Discount Amount" := 0;
                              Quantity := 0;
                            end;

                            AmountExclInvDisc := "Line Amount";

                            if Quantity = 0 then
                              UnitPriceToPrint := 0 // so it won't print
                            else
                              UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity,0.00001);

                            if OnLineNumber = NumberOfLines then begin
                              PrintFooter := true;

                              if "Purchase Header"."Tax Area Code" <> '' then begin
                                if UseExternalTaxEngine then
                                  SalesTaxCalc.CallExternalTaxEngineForPurch("Purchase Header",true)
                                else
                                  SalesTaxCalc.EndSalesTaxCalculation(UseDate);
                                SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                                BrkIdx := 0;
                                PrevPrintOrder := 0;
                                PrevTaxPercent := 0;
                                TaxAmount := 0;
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
                                      TaxAmount := TaxAmount + "Tax Amount";
                                    until Next = 0;
                                end;
                                if BrkIdx = 1 then begin
                                  Clear(BreakdownLabel);
                                  Clear(BreakdownAmt);
                                end;
                              end;
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(AmountExclInvDisc,"Line Amount","Inv. Discount Amount");
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
                        PurchasePrinted.Run("Purchase Header");
                      CurrReport.Break;
                    end;
                    CopyNo := CopyNo + 1;
                    if CopyNo = 1 then // Original
                      Clear(CopyTxt)
                    else
                      CopyTxt := Text000;
                    TaxAmount := 0;

                    Clear(BreakdownTitle);
                    Clear(BreakdownLabel);
                    Clear(BreakdownAmt);
                    TotalTaxLabel := Text008;
                    if "Purchase Header"."Tax Area Code" <> '' then begin
                      TaxArea.Get("Purchase Header"."Tax Area Code");
                      case TaxArea."Country/Region" of
                        TaxArea."country/region"::US:
                          TotalTaxLabel := Text005;
                        TaxArea."country/region"::CA:
                          TotalTaxLabel := Text007;
                      end;
                      UseExternalTaxEngine := TaxArea."Use External Tax Engine";
                      SalesTaxCalc.StartSalesTaxCalculation;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + Abs(NoCopies);
                    if NoLoops <= 0 then
                      NoLoops := 1;
                    CopyNo := 0;
                    CopyText := '';
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

                if "Payment Terms Code" = '' then
                  Clear(PaymentTerms)
                else
                  PaymentTerms.Get("Payment Terms Code");

                if "Shipment Method Code" = '' then
                  Clear(ShipmentMethod)
                else
                  ShipmentMethod.Get("Shipment Method Code");

                FormatAddress.PurchHeaderBuyFrom(BuyFromAddress,"Purchase Header");
                FormatAddress.PurchHeaderShipTo(ShipToAddress,"Purchase Header");

                if LogInteraction then
                  SegManagement.LogDocument(
                    13,"No.","Doc. No. Occurrence","No. of Archived Versions",Database::Vendor,"Buy-from Vendor No.",
                    "Purchaser Code",'',"Posting Description",'');

                if "Posting Date" <> 0D then
                  UseDate := "Posting Date"
                else
                  UseDate := WorkDate;
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
                        ApplicationArea = Basic;
                        Caption = 'Number of Copies';
                    }
                    field(PrintCompanyAddress;PrintCompany)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Company Address';
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
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
            LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';
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
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
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
        CopyText: Text[30];
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        PurchasePrinted: Codeunit "Purch.Header-Printed";
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        SegManagement: Codeunit SegManagement;
        LogInteraction: Boolean;
        TaxAmount: Decimal;
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        BreakdownLabel: array [4] of Text[30];
        BreakdownAmt: array [4] of Decimal;
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        UseDate: Date;
        Text000: label 'COPY';
        Text003: label 'Sales Tax Breakdown:';
        Text004: label 'Other Taxes';
        Text005: label 'Total Sales Tax:';
        Text006: label 'Tax Breakdown:';
        Text007: label 'Total Tax:';
        Text008: label 'Tax:';
        Text009: label 'Blanket Purchase Order%1';
        UseExternalTaxEngine: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        ReceiveByCaptionLbl: label 'Receive By';
        VendorIDCaptionLbl: label 'Vendor ID';
        ConfirmToCaptionLbl: label 'Confirm To';
        BuyerCaptionLbl: label 'Buyer';
        ShipCaptionLbl: label 'Ship';
        PurchaseOrderNumberCaptionLbl: label 'Purchase Order Number:';
        PurchaseOrderDateCaptionLbl: label 'Purchase Order Date:';
        PageCaptionLbl: label 'Page';
        ShipViaCaptionLbl: label 'Ship Via';
        TermsCaptionLbl: label 'Terms';
        PhoneNoCaptionLbl: label 'Phone No.';
        TaxIdentTypeCaptionLbl: label 'Tax Ident. Type';
        ToCaptionLbl: label 'To:';
        ItemNoCaptionLbl: label 'Item No.';
        UnitCaptionLbl: label 'Unit';
        DescriptionCaptionLbl: label 'Description';
        QuantityCaptionLbl: label 'Quantity';
        UnitPriceCaptionLbl: label 'Unit Price';
        TotalPriceCaptionLbl: label 'Total Price';
        SubtotalCaptionLbl: label 'Subtotal:';
        InvoiceDiscountCaptionLbl: label 'Invoice Discount:';
        TotalCaptionLbl: label 'Total:';
}

