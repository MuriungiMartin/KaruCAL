#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 206 "Sales - Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales - Invoice.rdlc';
    Caption = 'Sales - Invoice';
    EnableHyperlinks = true;
    Permissions = TableData "Sales Shipment Buffer"=rimd;
    PreviewMode = PrintLayout;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Sales Invoice Header";"Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Sell-to Customer No.","No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';
            column(ReportForNavId_186; 186)
            {
            }
            column(No_SalesInvHdr;"No.")
            {
            }
            column(PmtTermsDescCaption;PmtTermsDescCaptionLbl)
            {
            }
            column(ShpMethodDescCaption;ShpMethodDescCaptionLbl)
            {
            }
            column(HomepageCaption;HomePageCaptionLbl)
            {
            }
            column(EMailCaption;EMailCaptionLbl)
            {
            }
            column(DocDateCaption;DocDateCaptionLbl)
            {
            }
            column(DisplayAdditionalFeeNote;DisplayAdditionalFeeNote)
            {
            }
            dataitem(CopyLoop;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_187; 187)
                {
                }
                dataitem(PageLoop;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=const(1));
                    column(ReportForNavId_188; 188)
                    {
                    }
                    column(CompanyInfo2Picture;CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture;CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo3Picture;CompanyInfo3.Picture)
                    {
                    }
                    column(DocCopyText;StrSubstNo(DocumentCaption,CopyText))
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
                    column(CompanyInfoHomePage;CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEMail;CompanyInfo."E-Mail")
                    {
                    }
                    column(BilltoCustNo_SalesInvHdr;"Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(PostingDate_SalesInvHdr;Format("Sales Invoice Header"."Posting Date",0,4))
                    {
                    }
                    column(VATNoText;VATNoText)
                    {
                    }
                    column(VATRegNo_SalesInvHdr;"Sales Invoice Header"."VAT Registration No.")
                    {
                    }
                    column(DueDate_SalesInvHdr;Format("Sales Invoice Header"."Due Date",0,4))
                    {
                    }
                    column(SalesPersonText;SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText;ReferenceText)
                    {
                    }
                    column(YourReference_SalesInvHdr;"Sales Invoice Header"."Your Reference")
                    {
                    }
                    column(OrderNoText;OrderNoText)
                    {
                    }
                    column(OrderNo_SalesInvHdr;"Sales Invoice Header"."Order No.")
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
                    column(DocDate_SalesInvoiceHdr;Format("Sales Invoice Header"."Document Date",0,4))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdr;"Sales Invoice Header"."Prices Including VAT")
                    {
                    }
                    column(OutputNo;OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo;Format("Sales Invoice Header"."Prices Including VAT"))
                    {
                    }
                    column(PageCaption;PageCaptionCap)
                    {
                    }
                    column(CustTaxIdentType;Cust.GetLegalEntityType)
                    {
                    }
                    column(PaymentTermsDesc;PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodDesc;ShipmentMethod.Description)
                    {
                    }
                    column(PhoneNoCaption;Text011)
                    {
                    }
                    column(VATRegNoCaption;Text012)
                    {
                    }
                    column(GiroNoCaption;Text013)
                    {
                    }
                    column(BankNameCaption;Text014)
                    {
                    }
                    column(BankAccNoCaption;Text015)
                    {
                    }
                    column(DueDateCaption;Text016)
                    {
                    }
                    column(InvoiceNoCaption;Text017)
                    {
                    }
                    column(PostingDateCaption;Text018)
                    {
                    }
                    column(TaxIdentTypeCaption;Cust.GetLegalEntityTypeLbl)
                    {
                    }
                    column(BilltoCustNo_SalesInvHdrCaption;"Sales Invoice Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdrCaption;"Sales Invoice Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    dataitem(DimensionLoop1;"Integer")
                    {
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = sorting(Number) where(Number=filter(1..));
                        column(ReportForNavId_189; 189)
                        {
                        }
                        column(DimText;DimText)
                        {
                        }
                        column(Number_DimensionLoop1;Number)
                        {
                        }
                        column(HdrDimsCaption;Text020)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                              if not DimSetEntry1.FindSet then
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
                    dataitem("Sales Invoice Line";"Sales Invoice Line")
                    {
                        DataItemLink = "Document No."=field("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = sorting("Document No.","Line No.");
                        column(ReportForNavId_190; 190)
                        {
                        }
                        column(LineAmt_SalesInvLine;"Line Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesInvLine;Description)
                        {
                        }
                        column(No_SalesInvLine;"No.")
                        {
                        }
                        column(Quantity_SalesInvLine;Quantity)
                        {
                        }
                        column(UnitofMeasure_SalesInvLine;"Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesInvLine;"Unit Price")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(LineDisc_SalesInvoiceLine;"Line Discount %")
                        {
                        }
                        column(VATIdent_SalesInvLine;"VAT Identifier")
                        {
                        }
                        column(PostedShipmentDate;Format(PostedShipmentDate))
                        {
                        }
                        column(SalesLineType;Format("Sales Invoice Line".Type))
                        {
                        }
                        column(InvDiscountAmt;-"Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal;TotalSubTotal)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvoiceDiscountAmt;TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText;TotalText)
                        {
                        }
                        column(SalesInvLineAmt;Amount)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalAmt;TotalAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AmtIncludingVATAmt;"Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Amt_SalesInvLine;"Amount Including VAT")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText;VATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalExclVATText;TotalExclVATText)
                        {
                        }
                        column(TotalInclVATText;TotalInclVATText)
                        {
                        }
                        column(TotalAmtInclVAT;TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmtVAT;TotalAmountVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseDisc_SalesInvHdr;"Sales Invoice Header"."VAT Base Discount %")
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalPaymentDiscountOnVAT;TotalPaymentDiscountOnVAT)
                        {
                            AutoFormatType = 1;
                        }
                        column(LineNo_SalesInvoiceLine;"Line No.")
                        {
                        }
                        column(UnitPriceCaption;Text021)
                        {
                        }
                        column(DiscountCaption;Text022)
                        {
                        }
                        column(AmtCaption;Text023)
                        {
                        }
                        column(PostedShpDateCaption;Text024)
                        {
                        }
                        column(InvDiscAmtCaption;Text025)
                        {
                        }
                        column(SubtotalCaption;Text026)
                        {
                        }
                        column(PmtDiscVATCaption;Text027)
                        {
                        }
                        column(Desc_SalesInvLineCaption;FieldCaption(Description))
                        {
                        }
                        column(No_SalesInvLineCaption;FieldCaption("No."))
                        {
                        }
                        column(Quantity_SalesInvLineCaption;FieldCaption(Quantity))
                        {
                        }
                        column(UnitofMeasure_SalesInvLineCaption;FieldCaption("Unit of Measure"))
                        {
                        }
                        column(VATIdent_SalesInvLineCaption;FieldCaption("VAT Identifier"))
                        {
                        }
                        column(IsLineWithTotals;LineNoWithTotal = "Line No.")
                        {
                        }
                        dataitem("Sales Shipment Buffer";"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_191; 191)
                            {
                            }
                            column(SalesShipBufferPostingDate;Format(SalesShipmentBuffer."Posting Date"))
                            {
                            }
                            column(SalesShipBufferQuantity;SalesShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(ShpCaption;Text028)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                  SalesShipmentBuffer.Find('-')
                                else
                                  SalesShipmentBuffer.Next;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SalesShipmentBuffer.SetRange("Document No.","Sales Invoice Line"."Document No.");
                                SalesShipmentBuffer.SetRange("Line No.","Sales Invoice Line"."Line No.");

                                SetRange(Number,1,SalesShipmentBuffer.Count);
                            end;
                        }
                        dataitem(DimensionLoop2;"Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number=filter(1..));
                            column(ReportForNavId_192; 192)
                            {
                            }
                            column(DimText1;DimText)
                            {
                            }
                            column(LineDimsCaption;Text029)
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

                                DimSetEntry2.SetRange("Dimension Set ID","Sales Invoice Line"."Dimension Set ID");
                            end;
                        }
                        dataitem(AsmLoop;"Integer")
                        {
                            column(ReportForNavId_1020007; 1020007)
                            {
                            }
                            column(TempPostedAsmLineUnitofMeasureCode;GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(TempPostedAsmLineQuantity;TempPostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(TempPostedAsmLineVariantCode;BlanksForIndent + TempPostedAsmLine."Variant Code")
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(TempPostedAsmLineDesc;BlanksForIndent + TempPostedAsmLine.Description)
                            {
                            }
                            column(TempPostedAsmLineNo;BlanksForIndent + TempPostedAsmLine."No.")
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                ItemTranslation: Record "Item Translation";
                            begin
                                if Number = 1 then
                                  TempPostedAsmLine.FindSet
                                else
                                  TempPostedAsmLine.Next;

                                if ItemTranslation.Get(TempPostedAsmLine."No.",
                                     TempPostedAsmLine."Variant Code",
                                     "Sales Invoice Header"."Language Code")
                                then
                                  TempPostedAsmLine.Description := ItemTranslation.Description;
                            end;

                            trigger OnPreDataItem()
                            begin
                                Clear(TempPostedAsmLine);
                                if not DisplayAssemblyInformation then
                                  CurrReport.Break;
                                CollectAsmInformation;
                                Clear(TempPostedAsmLine);
                                SetRange(Number,1,TempPostedAsmLine.Count);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            PostedShipmentDate := 0D;
                            if Quantity <> 0 then
                              PostedShipmentDate := FindPostedShipmentDate;

                            if (Type = Type::"G/L Account") and (not ShowInternalInfo) then
                              "No." := '';

                            VATAmountLine.Init;
                            VATAmountLine."VAT Identifier" := "VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                            VATAmountLine."Tax Group Code" := "Tax Group Code";
                            VATAmountLine."Tax Area Code" := "Tax Area Code";
                            VATAmountLine."VAT %" := "VAT %";
                            VATAmountLine."VAT Base" := Amount;
                            VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                            VATAmountLine."Line Amount" := "Line Amount";
                            if "Allow Invoice Disc." then
                              VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                            VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                            VATAmountLine.InsertLine;

                            TotalSubTotal += "Line Amount";
                            TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                            TotalAmount += Amount;
                            TotalAmountVAT += "Amount Including VAT" - Amount;
                            TotalAmountInclVAT += "Amount Including VAT";
                            TotalPaymentDiscountOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DeleteAll;
                            SalesShipmentBuffer.Reset;
                            SalesShipmentBuffer.DeleteAll;
                            FirstValueEntryNo := 0;
                            MoreLines := Find('+');
                            LineNoWithTotal := "Line No.";
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do
                              MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                              CurrReport.Break;
                            SetRange("Line No.",0,"Line No.");
                            CurrReport.CreateTotals("Line Amount",Amount,"Amount Including VAT","Inv. Discount Amount");
                        end;
                    }
                    dataitem(VATCounter;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_194; 194)
                        {
                        }
                        column(VATAmountLineVATBase;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVATAmount;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineLineAmount;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmountLineVATIdentifier;VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATPercentCaption;Text030)
                        {
                        }
                        column(VATBaseCaption;Text031)
                        {
                        }
                        column(VATAmtCaption;Text032)
                        {
                        }
                        column(VATAmtSpecCaption;Text033)
                        {
                        }
                        column(VATIdentCaption;Text034)
                        {
                        }
                        column(InvDiscBaseAmtCaption;Text035)
                        {
                        }
                        column(LineAmtCaption;Text036)
                        {
                        }
                        column(InvDiscAmtCaption1;Text037)
                        {
                        }
                        column(TotalCaption;Text038)
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
                    dataitem(VatCounterLCY;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_195; 195)
                        {
                        }
                        column(VALSpecLCYHeader;VALSpecLCYHeader)
                        {
                        }
                        column(VALExchRate;VALExchRate)
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
                        column(VATAmountLineVAT1;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmountLineVATIdentifier1;VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Sales Invoice Header"."Posting Date","Sales Invoice Header"."Currency Code",
                                "Sales Invoice Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Sales Invoice Header"."Posting Date","Sales Invoice Header"."Currency Code",
                                "Sales Invoice Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Sales Invoice Header"."Currency Code" = '')
                            then
                              CurrReport.Break;

                            SetRange(Number,1,VATAmountLine.Count);
                            CurrReport.CreateTotals(VALVATBaseLCY,VALVATAmountLCY);

                            if GLSetup."LCY Code" = '' then
                              VALSpecLCYHeader := Text007 + Text008
                            else
                              VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Invoice Header"."Posting Date","Sales Invoice Header"."Currency Code",1);
                            CalculatedExchRate := ROUND(1 / "Sales Invoice Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount",0.000001);
                            VALExchRate := StrSubstNo(Text009,CalculatedExchRate,CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(PaymentReportingArgument;"Payment Reporting Argument")
                    {
                        DataItemTableView = sorting("Key");
                        UseTemporary = true;
                        column(ReportForNavId_1020018; 1020018)
                        {
                        }
                        column(PaymentServiceLogo;Logo)
                        {
                        }
                        column(PaymentServiceURLText;"URL Caption")
                        {
                        }
                        column(PaymentServiceURL;GetTargetURL)
                        {
                        }

                        trigger OnPreDataItem()
                        var
                            PaymentServiceSetup: Record "Payment Service Setup";
                        begin
                            PaymentServiceSetup.CreateReportingArgs(PaymentReportingArgument,"Sales Invoice Header");
                            if IsEmpty then
                              CurrReport.Break;
                        end;
                    }
                    dataitem(Total;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_196; 196)
                        {
                        }
                    }
                    dataitem(Total2;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_197; 197)
                        {
                        }
                        column(CustNo_SalesInvoiceHdr;"Sales Invoice Header"."Sell-to Customer No.")
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
                        column(ShiptoAddrCaption;Text039)
                        {
                        }
                        column(CustNo_SalesInvoiceHdrCaption;"Sales Invoice Header".FieldCaption("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not ShowShippingAddr then
                              CurrReport.Break;
                        end;
                    }
                    dataitem(LineFee;"Integer")
                    {
                        DataItemTableView = sorting(Number) order(ascending) where(Number=filter(1..));
                        column(ReportForNavId_300; 300)
                        {
                        }
                        column(LineFeeCaptionLbl;TempLineFeeNoteOnReportHist.ReportText)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if not DisplayAdditionalFeeNote then
                              CurrReport.Break;

                            if Number = 1 then begin
                              if not TempLineFeeNoteOnReportHist.FindSet then
                                CurrReport.Break
                            end else
                              if TempLineFeeNoteOnReportHist.Next = 0 then
                                CurrReport.Break;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                      CopyText := FormatDocument.GetCOPYText;
                      OutputNo += 1;
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
                      Codeunit.Run(Codeunit::"Sales Inv.-Printed","Sales Invoice Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + Cust."Invoice Copies" + 1;
                    if NoOfLoops <= 0 then
                      NoOfLoops := 1;
                    CopyText := '';
                    SetRange(Number,1,NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                FormatAddressFields("Sales Invoice Header");
                FormatDocumentFields("Sales Invoice Header");

                if not Cust.Get("Bill-to Customer No.") then
                  Clear(Cust);

                DimSetEntry1.SetRange("Dimension Set ID","Dimension Set ID");

                GetLineFeeNoteOnReportHist("No.");

                if LogInteraction then
                  if not CurrReport.Preview then begin
                    if "Bill-to Contact No." <> '' then
                      SegManagement.LogDocument(
                        4,"No.",0,0,Database::Contact,"Bill-to Contact No.","Salesperson Code",
                        "Campaign No.","Posting Description",'')
                    else
                      SegManagement.LogDocument(
                        4,"No.",0,0,Database::Customer,"Bill-to Customer No.","Salesperson Code",
                        "Campaign No.","Posting Description",'');
                  end;
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
                    field(DisplayAsmInformation;DisplayAssemblyInformation)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Assembly Components';
                    }
                    field(DisplayAdditionalFeeNote;DisplayAdditionalFeeNote)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Show Additional Fee Note';
                        ToolTip = 'Specifies if you want notes about additional fees to be shown on the document.';
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
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        SalesSetup.Get;
        CompanyInfo.Get;
        CompanyInfo.VerifyAndSetPaymentInfo;
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents",CompanyInfo1,CompanyInfo2,CompanyInfo3);
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
          InitLogInteraction;
    end;

    var
        Text004: label 'Sales - Invoice %1', Comment='%1 = Document No.';
        PageCaptionCap: label 'Page %1 of %2';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        Cust: Record Customer;
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        CurrExchRate: Record "Currency Exchange Rate";
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        PostedShipmentDate: Date;
        CustAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        OrderNoText: Text[80];
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
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: label 'Tax Amount Specification in ';
        Text008: label 'Local Currency';
        VALExchRate: Text[50];
        Text009: label 'Exchange rate: %1/%2';
        CalculatedExchRate: Decimal;
        Text010: label 'Sales - Prepayment Invoice %1';
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        Text011: label 'Phone No.';
        Text012: label 'Tax Registration No.';
        Text013: label 'Giro No.';
        Text014: label 'Bank';
        Text015: label 'Account No.';
        Text016: label 'Due Date';
        Text017: label 'Invoice No.';
        Text018: label 'Posting Date';
        Text020: label 'Header Dimensions';
        Text021: label 'Unit Price';
        Text022: label 'Discount %';
        Text023: label 'Amount';
        Text024: label 'Posted Shipment Date';
        Text025: label 'Invoice Discount Amount';
        Text026: label 'Subtotal';
        Text027: label 'Payment Discount on VAT';
        Text028: label 'Shipment';
        Text029: label 'Line Dimensions';
        Text030: label 'Tax %';
        Text031: label 'Tax Base';
        Text032: label 'Tax Amount';
        Text033: label 'Tax Amount Specification';
        Text034: label 'Tax Identifier';
        Text035: label 'Invoice Discount Base Amount';
        Text036: label 'Line Amount';
        Text037: label 'Invoice Discount Amount';
        Text038: label 'Total';
        Text039: label 'Ship-to Address';
        PmtTermsDescCaptionLbl: label 'Payment Terms';
        ShpMethodDescCaptionLbl: label 'Shipment Method';
        HomePageCaptionLbl: label 'Home Page';
        EMailCaptionLbl: label 'Email';
        DocDateCaptionLbl: label 'Document Date';
        DisplayAdditionalFeeNote: Boolean;
        LineNoWithTotal: Integer;


    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;


    procedure FindPostedShipmentDate(): Date
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentBuffer2: Record "Sales Shipment Buffer" temporary;
    begin
        NextEntryNo := 1;
        if "Sales Invoice Line"."Shipment No." <> '' then
          if SalesShipmentHeader.Get("Sales Invoice Line"."Shipment No.") then
            exit(SalesShipmentHeader."Posting Date");

        if "Sales Invoice Header"."Order No." = '' then
          exit("Sales Invoice Header"."Posting Date");

        case "Sales Invoice Line".Type of
          "Sales Invoice Line".Type::Item:
            GenerateBufferFromValueEntry("Sales Invoice Line");
          "Sales Invoice Line".Type::"G/L Account","Sales Invoice Line".Type::Resource,
          "Sales Invoice Line".Type::"Charge (Item)","Sales Invoice Line".Type::"Fixed Asset":
            GenerateBufferFromShipment("Sales Invoice Line");
          "Sales Invoice Line".Type::" ":
            exit(0D);
        end;

        SalesShipmentBuffer.Reset;
        SalesShipmentBuffer.SetRange("Document No.","Sales Invoice Line"."Document No.");
        SalesShipmentBuffer.SetRange("Line No." ,"Sales Invoice Line"."Line No.");
        if SalesShipmentBuffer.Find('-') then begin
          SalesShipmentBuffer2 := SalesShipmentBuffer;
          if SalesShipmentBuffer.Next = 0 then begin
            SalesShipmentBuffer.Get(
              SalesShipmentBuffer2."Document No.",SalesShipmentBuffer2."Line No.",SalesShipmentBuffer2."Entry No.");
            SalesShipmentBuffer.Delete;
            exit(SalesShipmentBuffer2."Posting Date");
          end ;
          SalesShipmentBuffer.CalcSums(Quantity);
          if SalesShipmentBuffer.Quantity <> "Sales Invoice Line".Quantity then begin
            SalesShipmentBuffer.DeleteAll;
            exit("Sales Invoice Header"."Posting Date");
          end;
        end else
          exit("Sales Invoice Header"."Posting Date");
    end;


    procedure GenerateBufferFromValueEntry(SalesInvoiceLine2: Record "Sales Invoice Line")
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := SalesInvoiceLine2."Quantity (Base)";
        ValueEntry.SetCurrentkey("Document No.");
        ValueEntry.SetRange("Document No.",SalesInvoiceLine2."Document No.");
        ValueEntry.SetRange("Posting Date","Sales Invoice Header"."Posting Date");
        ValueEntry.SetRange("Item Charge No.",'');
        ValueEntry.SetFilter("Entry No.",'%1..',FirstValueEntryNo);
        if ValueEntry.Find('-') then
          repeat
            if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
              if SalesInvoiceLine2."Qty. per Unit of Measure" <> 0 then
                Quantity := ValueEntry."Invoiced Quantity" / SalesInvoiceLine2."Qty. per Unit of Measure"
              else
                Quantity := ValueEntry."Invoiced Quantity";
              AddBufferEntry(
                SalesInvoiceLine2,
                -Quantity,
                ItemLedgerEntry."Posting Date");
              TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
            end;
            FirstValueEntryNo := ValueEntry."Entry No." + 1;
          until (ValueEntry.Next = 0) or (TotalQuantity = 0);
    end;


    procedure GenerateBufferFromShipment(SalesInvoiceLine: Record "Sales Invoice Line")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine2: Record "Sales Invoice Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesInvoiceHeader.SetCurrentkey("Order No.");
        SalesInvoiceHeader.SetFilter("No.",'..%1',"Sales Invoice Header"."No.");
        SalesInvoiceHeader.SetRange("Order No.","Sales Invoice Header"."Order No.");
        if SalesInvoiceHeader.Find('-') then
          repeat
            SalesInvoiceLine2.SetRange("Document No.",SalesInvoiceHeader."No.");
            SalesInvoiceLine2.SetRange("Line No.",SalesInvoiceLine."Line No.");
            SalesInvoiceLine2.SetRange(Type,SalesInvoiceLine.Type);
            SalesInvoiceLine2.SetRange("No.",SalesInvoiceLine."No.");
            SalesInvoiceLine2.SetRange("Unit of Measure Code",SalesInvoiceLine."Unit of Measure Code");
            if SalesInvoiceLine2.Find('-') then
              repeat
                TotalQuantity := TotalQuantity + SalesInvoiceLine2.Quantity;
              until SalesInvoiceLine2.Next = 0;
          until SalesInvoiceHeader.Next = 0;

        SalesShipmentLine.SetCurrentkey("Order No.","Order Line No.");
        SalesShipmentLine.SetRange("Order No.","Sales Invoice Header"."Order No.");
        SalesShipmentLine.SetRange("Order Line No.",SalesInvoiceLine."Line No.");
        SalesShipmentLine.SetRange("Line No.",SalesInvoiceLine."Line No.");
        SalesShipmentLine.SetRange(Type,SalesInvoiceLine.Type);
        SalesShipmentLine.SetRange("No.",SalesInvoiceLine."No.");
        SalesShipmentLine.SetRange("Unit of Measure Code",SalesInvoiceLine."Unit of Measure Code");
        SalesShipmentLine.SetFilter(Quantity,'<>%1',0);

        if SalesShipmentLine.Find('-') then
          repeat
            if "Sales Invoice Header"."Get Shipment Used" then
              CorrectShipment(SalesShipmentLine);
            if Abs(SalesShipmentLine.Quantity) <= Abs(TotalQuantity - SalesInvoiceLine.Quantity) then
              TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity
            else begin
              if Abs(SalesShipmentLine.Quantity) > Abs(TotalQuantity) then
                SalesShipmentLine.Quantity := TotalQuantity;
              Quantity :=
                SalesShipmentLine.Quantity - (TotalQuantity - SalesInvoiceLine.Quantity);

              TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity;
              SalesInvoiceLine.Quantity := SalesInvoiceLine.Quantity - Quantity;

              if SalesShipmentHeader.Get(SalesShipmentLine."Document No.") then
                AddBufferEntry(
                  SalesInvoiceLine,
                  Quantity,
                  SalesShipmentHeader."Posting Date");
            end;
          until (SalesShipmentLine.Next = 0) or (TotalQuantity = 0);
    end;


    procedure CorrectShipment(var SalesShipmentLine: Record "Sales Shipment Line")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetCurrentkey("Shipment No.","Shipment Line No.");
        SalesInvoiceLine.SetRange("Shipment No.",SalesShipmentLine."Document No.");
        SalesInvoiceLine.SetRange("Shipment Line No.",SalesShipmentLine."Line No.");
        if SalesInvoiceLine.Find('-') then
          repeat
            SalesShipmentLine.Quantity := SalesShipmentLine.Quantity - SalesInvoiceLine.Quantity;
          until SalesInvoiceLine.Next = 0;
    end;


    procedure AddBufferEntry(SalesInvoiceLine: Record "Sales Invoice Line";QtyOnShipment: Decimal;PostingDate: Date)
    begin
        SalesShipmentBuffer.SetRange("Document No.",SalesInvoiceLine."Document No.");
        SalesShipmentBuffer.SetRange("Line No.",SalesInvoiceLine."Line No.");
        SalesShipmentBuffer.SetRange("Posting Date",PostingDate);
        if SalesShipmentBuffer.Find('-') then begin
          SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity + QtyOnShipment;
          SalesShipmentBuffer.Modify;
          exit;
        end;

        with SalesShipmentBuffer do begin
          "Document No." := SalesInvoiceLine."Document No.";
          "Line No." := SalesInvoiceLine."Line No.";
          "Entry No." := NextEntryNo;
          Type := SalesInvoiceLine.Type;
          "No." := SalesInvoiceLine."No.";
          Quantity := QtyOnShipment;
          "Posting Date" := PostingDate;
          Insert;
          NextEntryNo := NextEntryNo + 1
        end;
    end;

    local procedure DocumentCaption(): Text[250]
    begin
        if "Sales Invoice Header"."Prepayment Invoice" then
          exit(Text010);
        exit(Text004);
    end;


    procedure InitializeRequest(NewNoOfCopies: Integer;NewShowInternalInfo: Boolean;NewLogInteraction: Boolean;DisplAsmInfo: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplAsmInfo;
    end;

    local procedure FormatDocumentFields(SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        with SalesInvoiceHeader do begin
          FormatDocument.SetTotalLabels("Currency Code",TotalText,TotalInclVATText,TotalExclVATText);
          FormatDocument.SetSalesPerson(SalesPurchPerson,"Salesperson Code",SalesPersonText);
          FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
          FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");

          OrderNoText := FormatDocument.SetText("Order No." <> '',FieldCaption("Order No."));
          ReferenceText := FormatDocument.SetText("Your Reference" <> '',FieldCaption("Your Reference"));
          VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FieldCaption("VAT Registration No."));
        end;
    end;

    local procedure FormatAddressFields(SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        FormatAddr.GetCompanyAddr(SalesInvoiceHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
        FormatAddr.SalesInvBillTo(CustAddr,SalesInvoiceHeader);
        ShowShippingAddr := FormatAddr.SalesInvShipTo(ShipToAddr,CustAddr,SalesInvoiceHeader);
    end;


    procedure CollectAsmInformation()
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        TempPostedAsmLine.DeleteAll;
        if "Sales Invoice Line".Type <> "Sales Invoice Line".Type::Item then
          exit;
        with ValueEntry do begin
          SetCurrentkey("Document No.");
          SetRange("Document No.","Sales Invoice Line"."Document No.");
          SetRange("Document Type","document type"::"Sales Invoice");
          SetRange("Document Line No.","Sales Invoice Line"."Line No.");
          SetRange(Adjustment,false);
          if not FindSet then
            exit;
        end;
        repeat
          if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
            if ItemLedgerEntry."Document Type" = ItemLedgerEntry."document type"::"Sales Shipment" then begin
              SalesShipmentLine.Get(ItemLedgerEntry."Document No.",ItemLedgerEntry."Document Line No.");
              if SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) then begin
                PostedAsmLine.SetRange("Document No.",PostedAsmHeader."No.");
                if PostedAsmLine.FindSet then
                  repeat
                    TreatAsmLineBuffer(PostedAsmLine);
                  until PostedAsmLine.Next = 0;
              end;
            end;
          end;
        until ValueEntry.Next = 0;
    end;


    procedure TreatAsmLineBuffer(PostedAsmLine: Record "Posted Assembly Line")
    begin
        Clear(TempPostedAsmLine);
        TempPostedAsmLine.SetRange(Type,PostedAsmLine.Type);
        TempPostedAsmLine.SetRange("No.",PostedAsmLine."No.");
        TempPostedAsmLine.SetRange("Variant Code",PostedAsmLine."Variant Code");
        TempPostedAsmLine.SetRange(Description,PostedAsmLine.Description);
        TempPostedAsmLine.SetRange("Unit of Measure Code",PostedAsmLine."Unit of Measure Code");
        if TempPostedAsmLine.FindFirst then begin
          TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
          TempPostedAsmLine.Modify;
        end else begin
          Clear(TempPostedAsmLine);
          TempPostedAsmLine := PostedAsmLine;
          TempPostedAsmLine.Insert;
        end;
    end;


    procedure GetUOMText(UOMCode: Code[10]): Text[10]
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

    local procedure GetLineFeeNoteOnReportHist(SalesInvoiceHeaderNo: Code[20])
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
    begin
        TempLineFeeNoteOnReportHist.DeleteAll;
        CustLedgerEntry.SetRange("Document Type",CustLedgerEntry."document type"::Invoice);
        CustLedgerEntry.SetRange("Document No.",SalesInvoiceHeaderNo);
        if not CustLedgerEntry.FindFirst then
          exit;

        if not Customer.Get(CustLedgerEntry."Customer No.") then
          exit;

        LineFeeNoteOnReportHist.SetRange("Cust. Ledger Entry No",CustLedgerEntry."Entry No.");
        LineFeeNoteOnReportHist.SetRange("Language Code",Customer."Language Code");
        if LineFeeNoteOnReportHist.FindSet then begin
          repeat
            TempLineFeeNoteOnReportHist.Init;
            TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
            TempLineFeeNoteOnReportHist.Insert;
          until LineFeeNoteOnReportHist.Next = 0;
        end else begin
          LineFeeNoteOnReportHist.SetRange("Language Code",Language.GetUserLanguage);
          if LineFeeNoteOnReportHist.FindSet then
            repeat
              TempLineFeeNoteOnReportHist.Init;
              TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
              TempLineFeeNoteOnReportHist.Insert;
            until LineFeeNoteOnReportHist.Next = 0;
        end;
    end;
}

