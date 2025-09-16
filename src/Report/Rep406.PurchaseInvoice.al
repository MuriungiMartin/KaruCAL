#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 406 "Purchase - Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase - Invoice.rdlc';
    Caption = 'Purchase - Invoice';
    PreviewMode = PrintLayout;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Purch. Inv. Header";"Purch. Inv. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Buy-from Vendor No.","No. Printed";
            RequestFilterHeading = 'Posted Purchase Invoice';
            column(ReportForNavId_3733; 3733)
            {
            }
            column(No_PurchInvHdr;"No.")
            {
            }
            column(PaymentTermsCaption;PaymentTermsCaptionLbl)
            {
            }
            column(ShipmentMethodCaption;ShipmentMethodCaptionLbl)
            {
            }
            column(HomePageCaption;HomePageCaptionLbl)
            {
            }
            column(EMailCaption;EMailCaptionLbl)
            {
            }
            column(DocumentDateCaption;DocumentDateCaptionLbl)
            {
            }
            column(AllowInvoiceDiscountCaption;AllowInvoiceDiscountCaptionLbl)
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
                    column(CopyText;StrSubstNo(DocumentCaption,CopyText))
                    {
                    }
                    column(VendAddr1;VendAddr[1])
                    {
                    }
                    column(CompanyAddr1;CompanyAddr[1])
                    {
                    }
                    column(VendAddr2;VendAddr[2])
                    {
                    }
                    column(CompanyAddr2;CompanyAddr[2])
                    {
                    }
                    column(VendAddr3;VendAddr[3])
                    {
                    }
                    column(CompanyAddr3;CompanyAddr[3])
                    {
                    }
                    column(VendAddr4;VendAddr[4])
                    {
                    }
                    column(CompanyAddr4;CompanyAddr[4])
                    {
                    }
                    column(VendAddr5;VendAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
                    {
                    }
                    column(VendAddr6;VendAddr[6])
                    {
                    }
                    column(CompanyInfoVATRegistrationNo;CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo;CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName;CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccountNo;CompanyInfo."Bank Account No.")
                    {
                    }
                    column(CompanyInfoHomePage;CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEMail;CompanyInfo."E-Mail")
                    {
                    }
                    column(PaytoVendNo_PurchInvHdr;"Purch. Inv. Header"."Pay-to Vendor No.")
                    {
                    }
                    column(DocDate_PurchInvHdr;Format("Purch. Inv. Header"."Document Date",0,4))
                    {
                    }
                    column(VATNoText;VATNoText)
                    {
                    }
                    column(VATRegNo_PurchInvHdr;"Purch. Inv. Header"."VAT Registration No.")
                    {
                    }
                    column(DueDate_PurchInvHdr;Format("Purch. Inv. Header"."Due Date"))
                    {
                    }
                    column(PurchaserText;PurchaserText)
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(No1_PurchInvHdr;"Purch. Inv. Header"."No.")
                    {
                    }
                    column(ReferenceText;ReferenceText)
                    {
                    }
                    column(YourReference_PurchInvHdr;"Purch. Inv. Header"."Your Reference")
                    {
                    }
                    column(OrderNoText;OrderNoText)
                    {
                    }
                    column(OrderNo_PurchInvHdr;"Purch. Inv. Header"."Order No.")
                    {
                    }
                    column(VendAddr7;VendAddr[7])
                    {
                    }
                    column(VendAddr8;VendAddr[8])
                    {
                    }
                    column(CompanyAddr5;CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6;CompanyAddr[6])
                    {
                    }
                    column(PostingDate_PurchInvHdr;Format("Purch. Inv. Header"."Posting Date" ))
                    {
                    }
                    column(BuyfromVendNo_PurchInvHdr;"Purch. Inv. Header"."Buy-from Vendor No.")
                    {
                    }
                    column(PricesInclVAT_PurchInvHdr;"Purch. Inv. Header"."Prices Including VAT")
                    {
                    }
                    column(OutputNo;OutputNo)
                    {
                    }
                    column(ShowInternalInfo;ShowInternalInfo)
                    {
                    }
                    column(VATBaseDisc_PurchInvHdr;"Purch. Inv. Header"."VAT Base Discount %")
                    {
                    }
                    column(PricesInclVATtxt;PricesInclVATtxt)
                    {
                    }
                    column(VendTaxIdentificationType;Format(Vend."Tax Identification Type"))
                    {
                    }
                    column(PaymentTermsDescr;PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodDesc;ShipmentMethod.Description)
                    {
                    }
                    column(PhoneNoCaption;PhoneNoCaptionLbl)
                    {
                    }
                    column(VATRegistrationNoCaption;VATRegistrationNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption;GiroNoCaptionLbl)
                    {
                    }
                    column(BankNameCaption;BankNameCaptionLbl)
                    {
                    }
                    column(BankAccountNoCaption;BankAccountNoCaptionLbl)
                    {
                    }
                    column(DueDateCaption;DueDateCaptionLbl)
                    {
                    }
                    column(InvoiceNoCaption;InvoiceNoCaptionLbl)
                    {
                    }
                    column(PostingDateCaption;PostingDateCaptionLbl)
                    {
                    }
                    column(PageCaption;PageCaptionLbl)
                    {
                    }
                    column(VATPercentCaption;VATPercentCaptionLbl)
                    {
                    }
                    column(VATBaseCaption;VATBaseCaptionLbl)
                    {
                    }
                    column(VATAmountCaption;VATAmountCaptionLbl)
                    {
                    }
                    column(VATAmountSpecificationCaption;VATAmountSpecificationCaptionLbl)
                    {
                    }
                    column(InvoiceDiscountAmountCaption;InvoiceDiscountAmountCaptionLbl)
                    {
                    }
                    column(InvDiscBaseAmountCaption;InvDiscBaseAmountCaptionLbl)
                    {
                    }
                    column(LineAmountCaption;LineAmountCaptionLbl)
                    {
                    }
                    column(VATIdentifierCaption;VATIdentifierCaptionLbl)
                    {
                    }
                    column(TotalCaption;TotalCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption;TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(PaytoVendNo_PurchInvHdrCaption;"Purch. Inv. Header".FieldCaption("Pay-to Vendor No."))
                    {
                    }
                    column(BuyfromVendNo_PurchInvHdrCaption;"Purch. Inv. Header".FieldCaption("Buy-from Vendor No."))
                    {
                    }
                    column(PricesInclVAT_PurchInvHdrCaption;"Purch. Inv. Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    dataitem(DimensionLoop1;"Integer")
                    {
                        DataItemLinkReference = "Purch. Inv. Header";
                        DataItemTableView = sorting(Number) where(Number=filter(1..));
                        column(ReportForNavId_7574; 7574)
                        {
                        }
                        column(DimText;DimText)
                        {
                        }
                        column(HeaderDimensionsCaption;HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                              if not DimSetEntry1.Find('-') then
                                CurrReport.Break;
                            end else
                              if not Continue then
                                CurrReport.Break;

                            Clear(DimText);
                            Continue := false;
                            repeat
                              OldDimText := DimText;
                              if DimText = '' then
                                DimText := StrSubstNo(
                                    '%1 %2',DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code")
                              else
                                DimText :=
                                  StrSubstNo(
                                    '%1, %2 %3',DimText,
                                    DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code");
                              if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                DimText := OldDimText;
                                Continue := true;
                                exit;
                              end;
                            until (DimSetEntry1.Next = 0);
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                              CurrReport.Break;
                        end;
                    }
                    dataitem("Purch. Inv. Line";"Purch. Inv. Line")
                    {
                        DataItemLink = "Document No."=field("No.");
                        DataItemLinkReference = "Purch. Inv. Header";
                        DataItemTableView = sorting("Document No.","Line No.");
                        column(ReportForNavId_5707; 5707)
                        {
                        }
                        column(LineAmt_PurchInvLine;"Line Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Desc_PurchInvLine;Description)
                        {
                        }
                        column(No_PurchInvLine;"No.")
                        {
                        }
                        column(Quantity_PurchInvLine;Quantity)
                        {
                        }
                        column(UnitofMeasure_PurchInvLine;"Unit of Measure")
                        {
                        }
                        column(DirectUnitCost_PurchInvLine;"Direct Unit Cost")
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(LineDisc_PurchInvLine;"Line Discount %")
                        {
                        }
                        column(AllowInvoiceDisc_PurchInvLine;"Allow Invoice Disc.")
                        {
                        }
                        column(VATIdentifier_PurchInvLine;"VAT Identifier")
                        {
                        }
                        column(LineNo_PurchInvLine;"Purch. Inv. Line"."Line No.")
                        {
                        }
                        column(AllowVATDisctxt;AllowVATDisctxt)
                        {
                        }
                        column(PurchInLineTypeNo;PurchInLineTypeNo)
                        {
                        }
                        column(VATAmtText;VATAmountText)
                        {
                        }
                        column(InvDiscAmt;-"Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalText;TotalText)
                        {
                        }
                        column(PurchInvLineAmt;Amount)
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText;TotalInclVATText)
                        {
                        }
                        column(AmtInclVAT_PurchInvLine;"Amount Including VAT")
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AmtInclVATAmt;"Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText;VATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalExclVATText;TotalExclVATText)
                        {
                        }
                        column(DocNo_PurchInvLine;"Document No.")
                        {
                        }
                        column(TotalSubTotal;TotalSubTotal)
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvoiceDiscAmt;TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmt;TotalAmount)
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmtInclVAT;TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmtVAT;TotalAmountVAT)
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalPaymentDiscOnVAT;TotalPaymentDiscountOnVAT)
                        {
                            AutoFormatType = 1;
                        }
                        column(DirectUnitCostCaption;DirectUnitCostCaptionLbl)
                        {
                        }
                        column(DiscountPercentCaption;DiscountPercentCaptionLbl)
                        {
                        }
                        column(AmountCaption;AmountCaptionLbl)
                        {
                        }
                        column(InvDiscountAmountCaption;InvDiscountAmountCaptionLbl)
                        {
                        }
                        column(SubtotalCaption;SubtotalCaptionLbl)
                        {
                        }
                        column(PaymentDisconVATCaption;PaymentDisconVATCaptionLbl)
                        {
                        }
                        column(Desc_PurchInvLineCaption;FieldCaption(Description))
                        {
                        }
                        column(No_PurchInvLineCaption;FieldCaption("No."))
                        {
                        }
                        column(Quantity_PurchInvLineCaption;FieldCaption(Quantity))
                        {
                        }
                        column(UnitofMeasure_PurchInvLineCaption;FieldCaption("Unit of Measure"))
                        {
                        }
                        column(VATIdentifier_PurchInvLineCaption;FieldCaption("VAT Identifier"))
                        {
                        }
                        dataitem(DimensionLoop2;"Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number=filter(1..));
                            column(ReportForNavId_3591; 3591)
                            {
                            }
                            column(DimText1;DimText)
                            {
                            }
                            column(LineDimensionsCaption;LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                  if not DimSetEntry2.Find('-') then
                                    CurrReport.Break;
                                end else
                                  if not Continue then
                                    CurrReport.Break;

                                Clear(DimText);
                                Continue := false;
                                repeat
                                  OldDimText := DimText;
                                  if DimText = '' then
                                    DimText := StrSubstNo(
                                        '%1 %2',DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code")
                                  else
                                    DimText :=
                                      StrSubstNo(
                                        '%1, %2 %3',DimText,
                                        DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code");
                                  if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                  end;
                                until (DimSetEntry2.Next = 0);
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                  CurrReport.Break;

                                DimSetEntry2.SetRange("Dimension Set ID","Purch. Inv. Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if (Type = Type::"G/L Account") and (not ShowInternalInfo) then
                              "No." := '';

                            VATAmountLine.Init;
                            VATAmountLine."VAT Identifier" := "Purch. Inv. Line"."VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                            VATAmountLine."Tax Group Code" := "Tax Group Code";
                            VATAmountLine."Tax Area Code" := "Tax Area Code";
                            VATAmountLine."Use Tax" := "Use Tax";
                            VATAmountLine."VAT %" := "VAT %";
                            VATAmountLine."VAT Base" := Amount;
                            VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                            VATAmountLine."Line Amount" := "Line Amount";
                            if "Allow Invoice Disc." then
                              VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                            VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                            VATAmountLine.InsertLine;

                            AllowVATDisctxt := Format("Purch. Inv. Line"."Allow Invoice Disc.");
                            PurchInLineTypeNo := "Purch. Inv. Line".Type;

                            TotalSubTotal += "Line Amount";
                            TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                            TotalAmount += Amount;
                            TotalAmountVAT += "Amount Including VAT" - Amount;
                            TotalAmountInclVAT += "Amount Including VAT";
                            TotalPaymentDiscountOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
                        end;

                        trigger OnPreDataItem()
                        var
                            PurchInvLine: Record "Purch. Inv. Line";
                            VATIdentifier: Code[10];
                        begin
                            VATAmountLine.DeleteAll;
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do
                              MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                              CurrReport.Break;
                            SetRange("Line No.",0,"Line No.");
                            CurrReport.CreateTotals("Line Amount","Inv. Discount Amount",Amount,"Amount Including VAT");

                            PurchInvLine.SetRange("Document No.","Purch. Inv. Header"."No.");
                            PurchInvLine.SetFilter(Type,'<>%1',0);
                            VATAmountText := '';
                            if PurchInvLine.Find('-') then begin
                              VATAmountText := StrSubstNo(Text011,PurchInvLine."VAT %");
                              VATIdentifier := PurchInvLine."VAT Identifier";
                              repeat
                                if (PurchInvLine."VAT Identifier" <> VATIdentifier) and (PurchInvLine.Quantity <> 0) then
                                  VATAmountText := Text012;
                              until PurchInvLine.Next = 0;
                            end;
                        end;
                    }
                    dataitem(VATCounter;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_6558; 6558)
                        {
                        }
                        column(VATAmtLineVATBase;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvoiceDiscAmt;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmtLineVATIdentifier;VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number,1,VATAmountLine.Count);
                            CurrReport.CreateTotals(
                              VATAmountLine."Line Amount",VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount",VATAmountLine."VAT Base",VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VATCounterLCY;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_2038; 2038)
                        {
                        }
                        column(VALExchRate;VALExchRate)
                        {
                        }
                        column(VALSpecLCYHdr;VALSpecLCYHeader)
                        {
                        }
                        column(VALVATAmtLCY;VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY;VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT1;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmtLineVATIdent1;VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Purch. Inv. Header"."Posting Date","Purch. Inv. Header"."Currency Code",
                                "Purch. Inv. Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Purch. Inv. Header"."Posting Date","Purch. Inv. Header"."Currency Code",
                                "Purch. Inv. Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Purch. Inv. Header"."Currency Code" = '')
                            then
                              CurrReport.Break;

                            SetRange(Number,1,VATAmountLine.Count);
                            CurrReport.CreateTotals(VALVATBaseLCY,VALVATAmountLCY);

                            if GLSetup."LCY Code" = '' then
                              VALSpecLCYHeader := Text007 + Text008
                            else
                              VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Purch. Inv. Header"."Posting Date","Purch. Inv. Header"."Currency Code",1);
                            CalculatedExchRate := ROUND(1 / "Purch. Inv. Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount",0.000001);
                            VALExchRate := StrSubstNo(Text009,CalculatedExchRate,CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_3476; 3476)
                        {
                        }
                    }
                    dataitem(Total2;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_3363; 3363)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if "Purch. Inv. Header"."Buy-from Vendor No." = "Purch. Inv. Header"."Pay-to Vendor No." then
                              CurrReport.Break;
                        end;
                    }
                    dataitem(Total3;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_8272; 8272)
                        {
                        }
                        column(ShipToAddr1;ShipToAddr[1])
                        {
                        }
                        column(ShipToAddr2;ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr3;ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr4;ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr5;ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr6;ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr7;ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr8;ShipToAddr[8])
                        {
                        }
                        column(ShipToAddressCaption;ShipToAddressCaptionLbl)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if ShipToAddr[1] = '' then
                              CurrReport.Break;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                      OutputNo := OutputNo + 1;
                      CopyText := FormatDocument.GetCOPYText;
                    end;
                    CurrReport.PageNo := 1;

                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalPaymentDiscountOnVAT := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                      Codeunit.Run(Codeunit::"Purch. Inv.-Printed","Purch. Inv. Header");
                end;

                trigger OnPreDataItem()
                begin
                    OutputNo := 1;
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number,1,NoOfLoops);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                FormatAddressFields("Purch. Inv. Header");
                FormatDocumentFields("Purch. Inv. Header");
                PricesInclVATtxt := Format("Prices Including VAT");

                DimSetEntry1.SetRange("Dimension Set ID","Dimension Set ID");

                if not Vend.Get("Buy-from Vendor No.") then
                  Clear(Vend);

                if LogInteraction then
                  if not CurrReport.Preview then
                    SegManagement.LogDocument(
                      14,"No.",0,0,Database::Vendor,"Buy-from Vendor No.","Purchaser Code",'',"Posting Description",'');
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
                    field(NoOfCopies;NoOfCopies)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                    field(ShowInternalInfo;ShowInternalInfo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies if the document shows internal information.';
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';
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
            LogInteraction := SegManagement.FindInteractTmplCode(14) <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
    end;

    var
        Text004: label 'Purchase - Invoice %1', Comment='%1 = Document No.';
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        CurrExchRate: Record "Currency Exchange Rate";
        Vend: Record Vendor;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        VendAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        PurchaserText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        OrderNoText: Text[80];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        Text007: label 'Tax Amount Specification in ';
        Text008: label 'Local Currency';
        Text009: label 'Exchange rate: %1/%2';
        CalculatedExchRate: Decimal;
        Text010: label 'Purchase - Prepayment Invoice %1';
        OutputNo: Integer;
        PricesInclVATtxt: Text[30];
        AllowVATDisctxt: Text[30];
        VATAmountText: Text[30];
        Text011: label '%1% Tax';
        Text012: label 'Tax Amount';
        PurchInLineTypeNo: Integer;
        [InDataSet]
        LogInteractionEnable: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        PhoneNoCaptionLbl: label 'Phone No.';
        HomePageCaptionLbl: label 'Home Page';
        EMailCaptionLbl: label 'Email';
        VATRegistrationNoCaptionLbl: label 'Tax Registration No.';
        GiroNoCaptionLbl: label 'Giro No.';
        BankNameCaptionLbl: label 'Bank';
        BankAccountNoCaptionLbl: label 'Account No.';
        DueDateCaptionLbl: label 'Due Date';
        InvoiceNoCaptionLbl: label 'Invoice No.';
        PostingDateCaptionLbl: label 'Posting Date';
        PageCaptionLbl: label 'Page';
        PaymentTermsCaptionLbl: label 'Payment Terms';
        ShipmentMethodCaptionLbl: label 'Shipment Method';
        DocumentDateCaptionLbl: label 'Document Date';
        TaxIdentTypeCaptionLbl: label 'Tax Identification Type';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions';
        DirectUnitCostCaptionLbl: label 'Direct Unit Cost';
        DiscountPercentCaptionLbl: label 'Discount %';
        AmountCaptionLbl: label 'Amount';
        InvDiscountAmountCaptionLbl: label 'Invoice Discount Amount';
        SubtotalCaptionLbl: label 'Subtotal';
        PaymentDisconVATCaptionLbl: label 'Payment Discount on VAT';
        LineDimensionsCaptionLbl: label 'Line Dimensions';
        VATPercentCaptionLbl: label 'Tax %';
        VATBaseCaptionLbl: label 'Tax Base';
        VATAmountCaptionLbl: label 'Tax Amount';
        VATAmountSpecificationCaptionLbl: label 'Tax Amount Specification';
        InvDiscBaseAmountCaptionLbl: label 'Inv. Disc. Base Amount';
        LineAmountCaptionLbl: label 'Line Amount';
        VATIdentifierCaptionLbl: label 'Tax Identifier';
        TotalCaptionLbl: label 'Total';
        ShipToAddressCaptionLbl: label 'Ship-to Address';
        InvoiceDiscountAmountCaptionLbl: label 'Invoice Discount Amount';
        AllowInvoiceDiscountCaptionLbl: label 'Allow Invoice Discount';

    local procedure DocumentCaption(): Text[250]
    begin
        if "Purch. Inv. Header"."Prepayment Invoice" then
          exit(Text010);
        exit(Text004);
    end;


    procedure InitializeRequest(NewNoOfCopies: Integer;NewShowInternalInfo: Boolean;NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
    end;

    local procedure FormatAddressFields(var PurchInvHeader: Record "Purch. Inv. Header")
    begin
        FormatAddr.GetCompanyAddr(PurchInvHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
        FormatAddr.PurchInvPayTo(VendAddr,PurchInvHeader);
        FormatAddr.PurchInvShipTo(ShipToAddr,PurchInvHeader);
    end;

    local procedure FormatDocumentFields(PurchInvHeader: Record "Purch. Inv. Header")
    begin
        with PurchInvHeader do begin
          FormatDocument.SetTotalLabels("Currency Code",TotalText,TotalInclVATText,TotalExclVATText);
          FormatDocument.SetPurchaser(SalesPurchPerson,"Purchaser Code",PurchaserText);
          FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
          FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");

          OrderNoText := FormatDocument.SetText("Order No." <> '',FieldCaption("Order No."));
          ReferenceText := FormatDocument.SetText("Your Reference" <> '',FieldCaption("Your Reference"));
          VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FieldCaption("VAT Registration No."));
        end;
    end;
}

