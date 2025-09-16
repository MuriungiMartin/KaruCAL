#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 205 "Order Confirmation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Order Confirmation.rdlc';
    Caption = 'Order Confirmation';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Header";"Sales Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const(Order));
            RequestFilterFields = "No.","Sell-to Customer No.","No. Printed";
            RequestFilterHeading = 'Sales Order';
            column(ReportForNavId_6640; 6640)
            {
            }
            column(DocumentType_SalesHeader;"Document Type")
            {
            }
            column(No_SalesHeader;"No.")
            {
            }
            column(PmtTermsDescCaption;PmtTermsDescCaptionLbl)
            {
            }
            column(ShpMethodDescCaption;ShpMethodDescCaptionLbl)
            {
            }
            column(PrepmtPmtTermsDescCaption;PrepmtPmtTermsDescCaptionLbl)
            {
            }
            column(DocDateCaption;DocDateCaptionLbl)
            {
            }
            column(AllowInvDiscCaption;AllowInvDiscCaptionLbl)
            {
            }
            column(HomePageCaption;HomePageCaptionLbl)
            {
            }
            column(EmailCaption;EmailCaptionLbl)
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
                    column(CompanyInfoHomePage;CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoEmail;CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfo2Picture;CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture;CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyInfo1Picture;CompanyInfo1.Picture)
                    {
                    }
                    column(OrderConfirmation;StrSubstNo(Text004,CopyText))
                    {
                    }
                    column(CustAddr1;CustAddr[1])
                    {
                    }
                    column(CompanyAddr1;CompanyAddr[1])
                    {
                    }
                    column(CustAddr2;CustAddr[2])
                    {
                    }
                    column(CompanyAddr2;CompanyAddr[2])
                    {
                    }
                    column(CustAddr3;CustAddr[3])
                    {
                    }
                    column(CompanyAddr3;CompanyAddr[3])
                    {
                    }
                    column(CustAddr4;CustAddr[4])
                    {
                    }
                    column(CompanyAddr4;CompanyAddr[4])
                    {
                    }
                    column(CustAddr5;CustAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
                    {
                    }
                    column(CustAddr6;CustAddr[6])
                    {
                    }
                    column(CompanyInfoVATRegNo;CompanyInfo."VAT Registration No.")
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
                    column(BilltoCustNo_SalesHeader;"Sales Header"."Bill-to Customer No.")
                    {
                    }
                    column(DocumentDate_SalesHeader;Format("Sales Header"."Document Date",0,4))
                    {
                    }
                    column(VATNoText;VATNoText)
                    {
                    }
                    column(VATRegistrationNo_SalesHeader;"Sales Header"."VAT Registration No.")
                    {
                    }
                    column(ShipmentDate_SalesHeader;Format("Sales Header"."Shipment Date"))
                    {
                    }
                    column(SalesPersonText;SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(No1_SalesHeader;"Sales Header"."No.")
                    {
                    }
                    column(ReferenceText;ReferenceText)
                    {
                    }
                    column(YourReference_SalesHeader;"Sales Header"."Your Reference")
                    {
                    }
                    column(CustAddr7;CustAddr[7])
                    {
                    }
                    column(CustAddr8;CustAddr[8])
                    {
                    }
                    column(CompanyAddr5;CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6;CompanyAddr[6])
                    {
                    }
                    column(PricesIncVAT_SalesHeader;"Sales Header"."Prices Including VAT")
                    {
                    }
                    column(PageCaption;PageCaptionCap)
                    {
                    }
                    column(OutputNo;OutputNo)
                    {
                    }
                    column(PricesInclVAT_SalesHeader;Format("Sales Header"."Prices Including VAT"))
                    {
                    }
                    column(CustTaxIdentificationType;Cust.GetLegalEntityType)
                    {
                    }
                    column(PmtTermsDesc;PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodDesc;ShipmentMethod.Description)
                    {
                    }
                    column(PrepmtPmtTermsDesc;PrepmtPaymentTerms.Description)
                    {
                    }
                    column(PhoneNoCaption;PhoneNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption;GiroNoCaptionLbl)
                    {
                    }
                    column(BankNameCaption;BankNameCaptionLbl)
                    {
                    }
                    column(BankAccNoCaption;BankAccNoCaptionLbl)
                    {
                    }
                    column(ShipmentDateCaption;ShipmentDateCaptionLbl)
                    {
                    }
                    column(OrderNoCaption;OrderNoCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption;Cust.GetLegalEntityTypeLbl)
                    {
                    }
                    column(BilltoCustNo_SalesHeaderCaption;"Sales Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesIncVAT_SalesHeaderCaption;"Sales Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    dataitem(DimensionLoop1;"Integer")
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = sorting(Number) where(Number=filter(1..));
                        column(ReportForNavId_7574; 7574)
                        {
                        }
                        column(DimText;DimText)
                        {
                        }
                        column(DimensionLoop1Number;Number)
                        {
                        }
                        column(HdrDimCaption;HdrDimCaptionLbl)
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
                                DimText := StrSubstNo('%1 %2',DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code")
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
                            until DimSetEntry1.Next = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                              CurrReport.Break;
                        end;
                    }
                    dataitem("Sales Line";"Sales Line")
                    {
                        DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = sorting("Document Type","Document No.","Line No.");
                        column(ReportForNavId_2844; 2844)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break;
                        end;
                    }
                    dataitem(RoundLoop;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_7551; 7551)
                        {
                        }
                        column(SalesLineLineAmount;SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLineDesc_SalesLine;"Sales Line".Description)
                        {
                        }
                        column(NNCSalesLineLineAmt;NNC_SalesLineLineAmt)
                        {
                        }
                        column(NNCSalesLineInvDiscAmt;NNC_SalesLineInvDiscAmt)
                        {
                        }
                        column(NNCTotalLCY;NNC_TotalLCY)
                        {
                        }
                        column(NNCTotalExclVAT;NNC_TotalExclVAT)
                        {
                        }
                        column(NNCVATAmt;NNC_VATAmt)
                        {
                        }
                        column(NNCPmtDiscOnVAT;NNC_PmtDiscOnVAT)
                        {
                        }
                        column(NNCTotalInclVAT2;NNC_TotalInclVAT2)
                        {
                        }
                        column(NNCVatAmt2;NNC_VatAmt2)
                        {
                        }
                        column(NNCTotalExclVAT2;NNC_TotalExclVAT2)
                        {
                        }
                        column(VATBaseDisc_SalesHeader;"Sales Header"."VAT Base Discount %")
                        {
                        }
                        column(No2_SalesLine;"Sales Line"."No.")
                        {
                        }
                        column(Quantity_SalesLine;"Sales Line".Quantity)
                        {
                        }
                        column(UnitofMeasure_SalesLine;"Sales Line"."Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesLine;"Sales Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineDiscount_SalesLine;"Sales Line"."Line Discount %")
                        {
                        }
                        column(LineAmt_SalesLine;"Sales Line"."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AllowInvDisc_SalesLine;"Sales Line"."Allow Invoice Disc.")
                        {
                        }
                        column(VATIdentifier_SalesLine;"Sales Line"."VAT Identifier")
                        {
                        }
                        column(Type_SalesLine;Format("Sales Line".Type))
                        {
                        }
                        column(LineNo_SalesLine;"Sales Line"."Line No.")
                        {
                        }
                        column(AllwInvDiscformat_SalesLine;Format("Sales Line"."Allow Invoice Disc."))
                        {
                        }
                        column(AsmInfoExistsForLine;AsmInfoExistsForLine)
                        {
                        }
                        column(SalesLineInvDiscountAmt;SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText;TotalText)
                        {
                        }
                        column(SalesLineLineAmtInvDiscAmt;SalesLine."Line Amount" - SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText;TotalExclVATText)
                        {
                        }
                        column(VATAmtLineVATAmtText;VATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalInclVATText;TotalInclVATText)
                        {
                        }
                        column(VATAmt;VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(LineAmtInvDiscAmtVATAmt;SalesLine."Line Amount" - SalesLine."Inv. Discount Amount" + VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATDiscountAmt;-VATDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseAmt;VATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmtInclVAT;TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(UnitPriceCaption;UnitPriceCaptionLbl)
                        {
                        }
                        column(DiscPercentCaption;DiscPercentCaptionLbl)
                        {
                        }
                        column(AmtCaption;AmtCaptionLbl)
                        {
                        }
                        column(InvDiscAmtCaption;InvDiscAmtCaptionLbl)
                        {
                        }
                        column(SubtotalCaption;SubtotalCaptionLbl)
                        {
                        }
                        column(PmtDiscOnVATCaption;PmtDiscOnVATCaptionLbl)
                        {
                        }
                        column(SalesLineDesc_SalesLineCaption;"Sales Line".FieldCaption(Description))
                        {
                        }
                        column(No_SalesLineCaption;"Sales Line".FieldCaption("No."))
                        {
                        }
                        column(Quantity_SalesLineCaption;"Sales Line".FieldCaption(Quantity))
                        {
                        }
                        column(UnitofMeasure_SalesLineCaption;"Sales Line".FieldCaption("Unit of Measure"))
                        {
                        }
                        column(AllowInvDisc_SalesLineCaption;"Sales Line".FieldCaption("Allow Invoice Disc."))
                        {
                        }
                        column(VATIdentifier_SalesLineCaption;"Sales Line".FieldCaption("VAT Identifier"))
                        {
                        }
                        dataitem(DimensionLoop2;"Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number=filter(1..));
                            column(ReportForNavId_3591; 3591)
                            {
                            }
                            column(DimText_DimLoop2;DimText)
                            {
                            }
                            column(LineDimCaption;LineDimCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                  if not DimSetEntry2.FindSet then
                                    CurrReport.Break;
                                end else
                                  if not Continue then
                                    CurrReport.Break;

                                Clear(DimText);
                                Continue := false;
                                repeat
                                  OldDimText := DimText;
                                  if DimText = '' then
                                    DimText := StrSubstNo('%1 %2',DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code")
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
                                until DimSetEntry2.Next = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                  CurrReport.Break;

                                DimSetEntry2.SetRange("Dimension Set ID","Sales Line"."Dimension Set ID");
                            end;
                        }
                        dataitem(AsmLoop;"Integer")
                        {
                            column(ReportForNavId_9462; 9462)
                            {
                            }
                            column(AsmLineUnitOfMeasureText;GetUnitOfMeasureDescr(AsmLine."Unit of Measure Code"))
                            {
                            }
                            column(AsmLineQuantity;AsmLine.Quantity)
                            {
                            }
                            column(AsmLineDescription;BlanksForIndent + AsmLine.Description)
                            {
                            }
                            column(AsmLineNo;BlanksForIndent + AsmLine."No.")
                            {
                            }
                            column(AsmLineType;AsmLine.Type)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                  AsmLine.FindSet
                                else
                                  AsmLine.Next;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not DisplayAssemblyInformation then
                                  CurrReport.Break;
                                if not AsmInfoExistsForLine then
                                  CurrReport.Break;
                                AsmLine.SetRange("Document Type",AsmHeader."Document Type");
                                AsmLine.SetRange("Document No.",AsmHeader."No.");
                                SetRange(Number,1,AsmLine.Count);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                              SalesLine.Find('-')
                            else
                              SalesLine.Next;
                            "Sales Line" := SalesLine;
                            if DisplayAssemblyInformation then
                              AsmInfoExistsForLine := SalesLine.AsmToOrderExists(AsmHeader);
                            if not "Sales Header"."Prices Including VAT" and
                               (SalesLine."VAT Calculation Type" = SalesLine."vat calculation type"::"Full VAT")
                            then
                              SalesLine."Line Amount" := 0;

                            if (SalesLine.Type = SalesLine.Type::"G/L Account") and (not ShowInternalInfo) then
                              "Sales Line"."No." := '';

                            NNC_SalesLineLineAmt += SalesLine."Line Amount";
                            NNC_SalesLineInvDiscAmt += SalesLine."Inv. Discount Amount";

                            NNC_TotalLCY := NNC_SalesLineLineAmt - NNC_SalesLineInvDiscAmt;

                            NNC_TotalExclVAT := NNC_TotalLCY;
                            NNC_VATAmt := VATAmount;
                            NNC_TotalInclVAT := NNC_TotalLCY - NNC_VATAmt;

                            NNC_PmtDiscOnVAT := -VATDiscountAmount;

                            NNC_TotalInclVAT2 := TotalAmountInclVAT;

                            NNC_VatAmt2 := VATAmount;
                            NNC_TotalExclVAT2 := VATBaseAmount;
                        end;

                        trigger OnPostDataItem()
                        begin
                            SalesLine.DeleteAll;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := SalesLine.Find('+');
                            while MoreLines and (SalesLine.Description = '') and (SalesLine."Description 2" = '') and
                                  (SalesLine."No." = '') and (SalesLine.Quantity = 0) and
                                  (SalesLine.Amount = 0)
                            do
                              MoreLines := SalesLine.Next(-1) <> 0;
                            if not MoreLines then
                              CurrReport.Break;
                            SalesLine.SetRange("Line No.",0,SalesLine."Line No.");
                            SetRange(Number,1,SalesLine.Count);
                            CurrReport.CreateTotals(SalesLine."Line Amount",SalesLine."Inv. Discount Amount");
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
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmtLineVATIdentifier;VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATPercentCaption;VATPercentCaptionLbl)
                        {
                        }
                        column(VATBaseCaption;VATBaseCaptionLbl)
                        {
                        }
                        column(VATAmtCaption;VATAmtCaptionLbl)
                        {
                        }
                        column(VATAmtSpecCaption;VATAmtSpecCaptionLbl)
                        {
                        }
                        column(InvDiscBaseCaption;InvDiscBaseCaptionLbl)
                        {
                        }
                        column(LineAmtCaption;LineAmtCaptionLbl)
                        {
                        }
                        column(VATIdentCaption;VATIdentCaptionLbl)
                        {
                        }
                        column(TotalCaption;TotalCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            if VATAmount = 0 then
                              CurrReport.Break;
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
                        column(VALSpecLCYHeader;VALSpecLCYHeader)
                        {
                        }
                        column(VALVATBaseLCY;VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY;VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VAT_VATAmountLine;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATIdentifier_VATAmtLine;VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Sales Header"."Posting Date","Sales Header"."Currency Code","Sales Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Sales Header"."Posting Date","Sales Header"."Currency Code","Sales Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Sales Header"."Currency Code" = '') or
                               (VATAmountLine.GetTotalVATAmount = 0)
                            then
                              CurrReport.Break;

                            SetRange(Number,1,VATAmountLine.Count);
                            CurrReport.CreateTotals(VALVATBaseLCY,VALVATAmountLCY);

                            if GLSetup."LCY Code" = '' then
                              VALSpecLCYHeader := Text007 + Text008
                            else
                              VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Header"."Posting Date","Sales Header"."Currency Code",1);
                            VALExchRate := StrSubstNo(Text009,CurrExchRate."Relational Exch. Rate Amount",CurrExchRate."Exchange Rate Amount");
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
                        column(SelltoCustNo_SalesHeader;"Sales Header"."Sell-to Customer No.")
                        {
                        }
                        column(ShipToAddr8;ShipToAddr[8])
                        {
                        }
                        column(ShipToAddr7;ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr6;ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr5;ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr4;ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr3;ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr2;ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr1;ShipToAddr[1])
                        {
                        }
                        column(ShiptoAddrCaption;ShiptoAddrCaptionLbl)
                        {
                        }
                        column(SelltoCustNo_SalesHeaderCaption;"Sales Header".FieldCaption("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not ShowShippingAddr then
                              CurrReport.Break;
                        end;
                    }
                    dataitem(PrepmtLoop;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=filter(1..));
                        column(ReportForNavId_1849; 1849)
                        {
                        }
                        column(PrepmtLineAmount;PrepmtLineAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvBufDesc;PrepmtInvBuf.Description)
                        {
                        }
                        column(PrepmtInvBufGLAccNo;PrepmtInvBuf."G/L Account No.")
                        {
                        }
                        column(TotalExclVATText_PrepmtLoop;TotalExclVATText)
                        {
                        }
                        column(PrepmtVATAmtLineVATAmtTxt;PrepmtVATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalInclVATText1_PrepmtLoop;TotalInclVATText)
                        {
                        }
                        column(PrepmtInvBufAmt;PrepmtInvBuf.Amount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmt;PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvBufAmtVATAmt;PrepmtInvBuf.Amount + PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtText_VATAmountLine;VATAmountLine.VATAmountText)
                        {
                        }
                        column(PrepmtTotalAmountInclVAT;PrepmtTotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATBaseAmount;PrepmtVATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(DescriptionCaption;DescriptionCaptionLbl)
                        {
                        }
                        column(GLAccNoCaption;GLAccNoCaptionLbl)
                        {
                        }
                        column(PrepaymentSpecCaption;PrepaymentSpecCaptionLbl)
                        {
                        }
                        dataitem(PrepmtDimLoop;"Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number=filter(1..));
                            column(ReportForNavId_6278; 6278)
                            {
                            }
                            column(DimText_PrepmtDimLoop;DimText)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                  if not TempPrepmtDimSetEntry.Find('-') then
                                    CurrReport.Break;
                                end else
                                  if not Continue then
                                    CurrReport.Break;

                                Clear(DimText);
                                Continue := false;
                                repeat
                                  OldDimText := DimText;
                                  if DimText = '' then
                                    DimText :=
                                      StrSubstNo('%1 %2',TempPrepmtDimSetEntry."Dimension Code",TempPrepmtDimSetEntry."Dimension Value Code")
                                  else
                                    DimText :=
                                      StrSubstNo(
                                        '%1, %2 %3',DimText,
                                        TempPrepmtDimSetEntry."Dimension Code",TempPrepmtDimSetEntry."Dimension Value Code");
                                  if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                  end;
                                until TempPrepmtDimSetEntry.Next = 0;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                              if not PrepmtInvBuf.Find('-') then
                                CurrReport.Break;
                            end else
                              if PrepmtInvBuf.Next = 0 then
                                CurrReport.Break;

                            if ShowInternalInfo then
                              DimMgt.GetDimensionSet(TempPrepmtDimSetEntry,PrepmtInvBuf."Dimension Set ID");

                            if "Sales Header"."Prices Including VAT" then
                              PrepmtLineAmount := PrepmtInvBuf."Amount Incl. VAT"
                            else
                              PrepmtLineAmount := PrepmtInvBuf.Amount;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(
                              PrepmtInvBuf.Amount,PrepmtInvBuf."Amount Incl. VAT",
                              PrepmtVATAmountLine."Line Amount",PrepmtVATAmountLine."VAT Base",
                              PrepmtVATAmountLine."VAT Amount",
                              PrepmtLineAmount);
                        end;
                    }
                    dataitem(PrepmtVATCounter;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_3388; 3388)
                        {
                        }
                        column(PrepmtVATAmtLineVATAmt;PrepmtVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineVATBase;PrepmtVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineLineAmt;PrepmtVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineVAT;PrepmtVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(PrepmtVATAmtLineVATIdent;PrepmtVATAmountLine."VAT Identifier")
                        {
                        }
                        column(PrepaymentVATAmtSpecCaption;PrepaymentVATAmtSpecCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            PrepmtVATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number,1,PrepmtVATAmountLine.Count);
                        end;
                    }
                    dataitem(PrepmtTotal;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_7808; 7808)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not PrepmtInvBuf.Find('-') then
                              CurrReport.Break;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                var
                    PrepmtSalesLine: Record "Sales Line" temporary;
                    TempSalesLine: Record "Sales Line" temporary;
                    SalesPost: Codeunit "Sales-Post";
                begin
                    Clear(SalesLine);
                    Clear(SalesPost);
                    VATAmountLine.DeleteAll;
                    SalesLine.DeleteAll;
                    SalesPost.GetSalesLines("Sales Header",SalesLine,0);
                    SalesLine.CalcVATAmountLines(0,"Sales Header",SalesLine,VATAmountLine);
                    SalesLine.UpdateVATOnLines(0,"Sales Header",SalesLine,VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code","Sales Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                    PrepmtInvBuf.DeleteAll;
                    SalesPostPrepmt.GetSalesLines("Sales Header",0,PrepmtSalesLine);

                    if not PrepmtSalesLine.IsEmpty then begin
                      SalesPostPrepmt.GetSalesLinesToDeduct("Sales Header",TempSalesLine);
                      if not TempSalesLine.IsEmpty then
                        SalesPostPrepmt.CalcVATAmountLines("Sales Header",TempSalesLine,PrepmtVATAmountLineDeduct,1);
                    end;
                    SalesPostPrepmt.CalcVATAmountLines("Sales Header",PrepmtSalesLine,PrepmtVATAmountLine,0);
                    PrepmtVATAmountLine.DeductVATAmountLine(PrepmtVATAmountLineDeduct);
                    SalesPostPrepmt.UpdateVATOnLines("Sales Header",PrepmtSalesLine,PrepmtVATAmountLine,0);
                    SalesPostPrepmt.BuildInvLineBuffer2("Sales Header",PrepmtSalesLine,0,PrepmtInvBuf);
                    PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount;
                    PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase;
                    PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT;

                    if Number > 1 then begin
                      CopyText := FormatDocument.GetCOPYText;
                      OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;

                    NNC_TotalLCY := 0;
                    NNC_TotalExclVAT := 0;
                    NNC_VATAmt := 0;
                    NNC_TotalInclVAT := 0;
                    NNC_PmtDiscOnVAT := 0;
                    NNC_TotalInclVAT2 := 0;
                    NNC_VatAmt2 := 0;
                    NNC_TotalExclVAT2 := 0;
                    NNC_SalesLineLineAmt := 0;
                    NNC_SalesLineInvDiscAmt := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if Print then
                      Codeunit.Run(Codeunit::"Sales-Printed","Sales Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number,1,NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                FormatAddressFields("Sales Header");
                FormatDocumentFields("Sales Header");

                DimSetEntry1.SetRange("Dimension Set ID","Dimension Set ID");

                if not Cust.Get("Bill-to Customer No.") then
                  Clear(Cust);

                if Print then begin
                  if CurrReport.UseRequestPage and ArchiveDocument or
                     not CurrReport.UseRequestPage and SalesSetup."Archive Quotes and Orders"
                  then
                    ArchiveManagement.StoreSalesDocument("Sales Header",LogInteraction);

                  if LogInteraction then begin
                    CalcFields("No. of Archived Versions");
                    if "Bill-to Contact No." <> '' then
                      SegManagement.LogDocument(
                        3,"No.","Doc. No. Occurrence",
                        "No. of Archived Versions",Database::Contact,"Bill-to Contact No."
                        ,"Salesperson Code","Campaign No.","Posting Description","Opportunity No.")
                    else
                      SegManagement.LogDocument(
                        3,"No.","Doc. No. Occurrence",
                        "No. of Archived Versions",Database::Customer,"Bill-to Customer No.",
                        "Salesperson Code","Campaign No.","Posting Description","Opportunity No.");
                  end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                Print := Print or not CurrReport.Preview;
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
                    field(ArchiveDocument;ArchiveDocument)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Archive Document';
                        ToolTip = 'Specifies if the document is archived after you preview or print it.';

                        trigger OnValidate()
                        begin
                            if not ArchiveDocument then
                              LogInteraction := false;
                        end;
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';

                        trigger OnValidate()
                        begin
                            if LogInteraction then
                              ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                    field(ShowAssemblyComponents;DisplayAssemblyInformation)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Assembly Components';
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
            ArchiveDocument := SalesSetup."Archive Quotes and Orders";
            LogInteraction := SegManagement.FindInteractTmplCode(3) <> '';

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
        SalesSetup.Get;
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents",CompanyInfo1,CompanyInfo2,CompanyInfo3);
    end;

    var
        Text004: label 'Order Confirmation %1', Comment='%1 = Document No.';
        PageCaptionCap: label 'Page %1 of %2';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        VATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        SalesLine: Record "Sales Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        TempPrepmtDimSetEntry: Record "Dimension Set Entry" temporary;
        PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        CurrExchRate: Record "Currency Exchange Rate";
        AsmHeader: Record "Assembly Header";
        AsmLine: Record "Assembly Line";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
        FormatDocument: Codeunit "Format Document";
        SalesPostPrepmt: Codeunit "Sales-Post Prepayments";
        DimMgt: Codeunit DimensionManagement;
        CustAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: label 'Tax Amount Specification in ';
        Text008: label 'Local Currency';
        Text009: label 'Exchange rate: %1/%2';
        VALExchRate: Text[50];
        PrepmtVATAmount: Decimal;
        PrepmtVATBaseAmount: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        OutputNo: Integer;
        NNC_TotalLCY: Decimal;
        NNC_TotalExclVAT: Decimal;
        NNC_VATAmt: Decimal;
        NNC_TotalInclVAT: Decimal;
        NNC_PmtDiscOnVAT: Decimal;
        NNC_TotalInclVAT2: Decimal;
        NNC_VatAmt2: Decimal;
        NNC_TotalExclVAT2: Decimal;
        NNC_SalesLineLineAmt: Decimal;
        NNC_SalesLineInvDiscAmt: Decimal;
        Print: Boolean;
        Cust: Record Customer;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmInfoExistsForLine: Boolean;
        PhoneNoCaptionLbl: label 'Phone No.';
        GiroNoCaptionLbl: label 'Giro No.';
        BankNameCaptionLbl: label 'Bank';
        BankAccNoCaptionLbl: label 'Account No.';
        ShipmentDateCaptionLbl: label 'Shipment Date';
        OrderNoCaptionLbl: label 'Order No.';
        HdrDimCaptionLbl: label 'Header Dimensions';
        UnitPriceCaptionLbl: label 'Unit Price';
        DiscPercentCaptionLbl: label 'Discount %';
        AmtCaptionLbl: label 'Amount';
        InvDiscAmtCaptionLbl: label 'Invoice Discount Amount';
        SubtotalCaptionLbl: label 'Subtotal';
        PmtDiscOnVATCaptionLbl: label 'Payment Discount on VAT';
        LineDimCaptionLbl: label 'Line Dimensions';
        VATPercentCaptionLbl: label 'Tax %';
        VATBaseCaptionLbl: label 'Tax Base';
        VATAmtCaptionLbl: label 'Tax Amount';
        VATAmtSpecCaptionLbl: label 'Tax Amount Specification';
        InvDiscBaseCaptionLbl: label 'Invoice Discount Base Amount';
        LineAmtCaptionLbl: label 'Line Amount';
        VATIdentCaptionLbl: label 'Tax Identifier';
        TotalCaptionLbl: label 'Total';
        ShiptoAddrCaptionLbl: label 'Ship-to Address';
        DescriptionCaptionLbl: label 'Description';
        GLAccNoCaptionLbl: label 'G/L Account No.';
        PrepaymentSpecCaptionLbl: label 'Prepayment Specification';
        PrepaymentVATAmtSpecCaptionLbl: label 'Prepayment Tax Amount Specification';
        PmtTermsDescCaptionLbl: label 'Payment Terms';
        ShpMethodDescCaptionLbl: label 'Shipment Method';
        PrepmtPmtTermsDescCaptionLbl: label 'Prepayment Payment Terms';
        DocDateCaptionLbl: label 'Document Date';
        AllowInvDiscCaptionLbl: label 'Allow Invoice Discount';
        HomePageCaptionLbl: label 'HomePage';
        EmailCaptionLbl: label 'E-Mail';


    procedure InitializeRequest(NoOfCopiesFrom: Integer;ShowInternalInfoFrom: Boolean;ArchiveDocumentFrom: Boolean;LogInteractionFrom: Boolean;PrintFrom: Boolean;DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        ShowInternalInfo := ShowInternalInfoFrom;
        ArchiveDocument := ArchiveDocumentFrom;
        LogInteraction := LogInteractionFrom;
        Print := PrintFrom;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    local procedure FormatAddressFields(var SalesHeader: Record "Sales Header")
    begin
        FormatAddr.GetCompanyAddr(SalesHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
        FormatAddr.SalesHeaderBillTo(CustAddr,SalesHeader);
        ShowShippingAddr := FormatAddr.SalesHeaderShipTo(ShipToAddr,CustAddr,SalesHeader);
    end;

    local procedure FormatDocumentFields(SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do begin
          FormatDocument.SetTotalLabels("Currency Code",TotalText,TotalInclVATText,TotalExclVATText);
          FormatDocument.SetSalesPerson(SalesPurchPerson,"Salesperson Code",SalesPersonText);
          FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
          FormatDocument.SetPaymentTerms(PrepmtPaymentTerms,"Prepmt. Payment Terms Code","Language Code");
          FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");

          ReferenceText := FormatDocument.SetText("Your Reference" <> '',FieldCaption("Your Reference"));
          VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FieldCaption("VAT Registration No."));
        end;
    end;

    local procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
          exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;


    procedure BlanksForIndent(): Text[10]
    begin
        exit(PadStr('',2,' '));
    end;
}

