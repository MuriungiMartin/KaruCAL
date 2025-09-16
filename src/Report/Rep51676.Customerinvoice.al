#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51676 "Customer  invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Customer  invoice.rdlc';
    Caption = 'Sales - Invoice';
    Permissions = TableData "Sales Shipment Buffer"=rimd;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Invoice Header";"Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Sell-to Customer No.","No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';
            column(ReportForNavId_175; 175)
            {
            }
            column(No_SalesInvHdr;"No.")
            {
            }
            column(NUMBER;"Sales Invoice Header"."No.")
            {
            }
            column(name;"Sales Invoice Header"."Bill-to Name")
            {
            }
            column(COURSE;"Sales Invoice Header".period)
            {
            }
            column(PERIOD;"Sales Invoice Header".Contact)
            {
            }
            column(CONTACT;"Sales Invoice Header".Course)
            {
            }
            column(dUEDATE;"Sales Invoice Header"."Due Date")
            {
            }
            column(DATE;"Sales Invoice Header"."Document Date")
            {
            }
            column(custNo;"Sales Invoice Header"."Sell-to Customer No.")
            {
            }
            column(InvDiscountAmtCaption;InvDiscountAmtCaptionLbl)
            {
            }
            column(DocumentDateCaption;DocumentDateCaptionLbl)
            {
            }
            column(PaymentTermsDescCaption;PaymentTermsDescCaptionLbl)
            {
            }
            column(ShptMethodDescCaption;ShptMethodDescCaptionLbl)
            {
            }
            column(VATPercentageCaption;VATPercentageCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(VATBaseCaption;VATBaseCaptionLbl)
            {
            }
            column(VATAmtCaption;VATAmtCaptionLbl)
            {
            }
            column(VATIdentifierCaption;VATIdentifierCaptionLbl)
            {
            }
            column(HomePageCaption;HomePageCaptionCap)
            {
            }
            column(PostingDescription;"Sales Invoice Header"."Posting Description")
            {
            }
            column(EMailCaption;EMailCaptionLbl)
            {
            }
            dataitem(CopyLoop;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_153; 153)
                {
                }
                dataitem(PageLoop;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=const(1));
                    column(ReportForNavId_154; 154)
                    {
                    }
                    column(HomePage;CompanyInfo."Home Page")
                    {
                    }
                    column(EMail;CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfo2Picture;CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture;CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfoPicture;CompanyInfo.Picture)
                    {
                    }
                    column(CompanyInfo3Picture;CompanyInfo3.Picture)
                    {
                    }
                    column(DocumentCaptionCopyText;StrSubstNo(DocumentCaption,CopyText))
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
                    column(CompanyInfoBankAccNo;CompanyInfo."Bank Account No.")
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
                    column(HdrOrderNo_SalesInvHdr;"Sales Invoice Header"."Order No.")
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
                    column(DocDate_SalesInvHdr;Format("Sales Invoice Header"."Document Date",0,4))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdr;"Sales Invoice Header"."Prices Including VAT")
                    {
                    }
                    column(OutputNo;OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo_SalesInvHdr;Format("Sales Invoice Header"."Prices Including VAT"))
                    {
                    }
                    column(PageCaption;PageCaptionCap)
                    {
                    }
                    column(PaymentTermsDesc;PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodDesc;ShipmentMethod.Description)
                    {
                    }
                    column(CompanyInfoPhoneNoCaption;CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegNoCptn;CompanyInfoVATRegNoCptnLbl)
                    {
                    }
                    column(CompanyInfoGiroNoCaption;CompanyInfoGiroNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankNameCptn;CompanyInfoBankNameCptnLbl)
                    {
                    }
                    column(CompanyInfoBankAccNoCptn;CompanyInfoBankAccNoCptnLbl)
                    {
                    }
                    column(SalesInvDueDateCaption;SalesInvDueDateCaptionLbl)
                    {
                    }
                    column(InvNoCaption;InvNoCaptionLbl)
                    {
                    }
                    column(SalesInvPostingDateCptn;SalesInvPostingDateCptnLbl)
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
                        column(ReportForNavId_97; 97)
                        {
                        }
                        column(DimText;DimText)
                        {
                        }
                        column(DimensionLoop1Number;Number)
                        {
                        }
                        column(HeaderDimCaption;HeaderDimCaptionLbl)
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
                        column(ReportForNavId_93; 93)
                        {
                        }
                        column(LineAmt_SalesInvLine;"Line Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesInvLine;Description)
                        {
                        }
                        column(No_SalesInvLine;"No.")
                        {
                        }
                        column(Qty_SalesInvLine;Quantity)
                        {
                        }
                        column(UOM_SalesInvLine;"Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesInvLine;"Unit Price")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(Discount_SalesInvLine;"Line Discount %")
                        {
                        }
                        column(VATIdentifier_SalesInvLine;"VAT Identifier")
                        {
                        }
                        column(PostedShipmentDate;Format(PostedShipmentDate))
                        {
                        }
                        column(Type_SalesInvLine;Format(Type))
                        {
                        }
                        column(InvDiscLineAmt_SalesInvLine;-"Inv. Discount Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal;TotalSubTotal)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvDiscAmount;TotalInvDiscAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText;TotalText)
                        {
                        }
                        column(Amount_SalesInvLine;Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalAmount;TotalAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Amount_AmtInclVAT;"Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AmtInclVAT_SalesInvLine;"Amount Including VAT")
                        {
                            AutoFormatExpression = GetCurrencyCode;
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
                        column(TotalAmountInclVAT;TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountVAT;TotalAmountVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(LineAmtAfterInvDiscAmt;-("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT"))
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseDisc_SalesInvHdr;"Sales Invoice Header"."VAT Base Discount %")
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalPaymentDiscOnVAT;TotalPaymentDiscOnVAT)
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText_SalesInvLine;TotalInclVATText)
                        {
                        }
                        column(VATAmtText_SalesInvLine;VATAmountLine.VATAmountText)
                        {
                        }
                        column(DocNo_SalesInvLine;"Document No.")
                        {
                        }
                        column(LineNo_SalesInvLine;"Line No.")
                        {
                        }
                        column(UnitPriceCaption;UnitPriceCaptionLbl)
                        {
                        }
                        column(SalesInvLineDiscCaption;SalesInvLineDiscCaptionLbl)
                        {
                        }
                        column(AmountCaption;AmountCaptionLbl)
                        {
                        }
                        column(PostedShipmentDateCaption;PostedShipmentDateCaptionLbl)
                        {
                        }
                        column(SubtotalCaption;SubtotalCaptionLbl)
                        {
                        }
                        column(LineAmtAfterInvDiscCptn;LineAmtAfterInvDiscCptnLbl)
                        {
                        }
                        column(Desc_SalesInvLineCaption;FieldCaption(Description))
                        {
                        }
                        column(No_SalesInvLineCaption;FieldCaption("No."))
                        {
                        }
                        column(Qty_SalesInvLineCaption;FieldCaption(Quantity))
                        {
                        }
                        column(UOM_SalesInvLineCaption;FieldCaption("Unit of Measure"))
                        {
                        }
                        column(VATIdentifier_SalesInvLineCaption;FieldCaption("VAT Identifier"))
                        {
                        }
                        dataitem("Sales Shipment Buffer";"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_51; 51)
                            {
                            }
                            column(SalesShptBufferPostDate;Format(SalesShipmentBuffer."Posting Date"))
                            {
                            }
                            column(SalesShptBufferQty;SalesShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(ShipmentCaption;ShipmentCaptionLbl)
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
                            column(ReportForNavId_47; 47)
                            {
                            }
                            column(DimText_DimLoop;DimText)
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

                                DimSetEntry2.SetRange("Dimension Set ID","Sales Invoice Line"."Dimension Set ID");
                            end;
                        }
                        dataitem(AsmLoop;"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_46; 46)
                            {
                            }
                            column(TempPostedAsmLineNo;BlanksForIndent + TempPostedAsmLine."No.")
                            {
                            }
                            column(TempPostedAsmLineQuantity;TempPostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(TempPostedAsmLineDesc;BlanksForIndent + TempPostedAsmLine.Description)
                            {
                            }
                            column(TempPostAsmLineVartCode;BlanksForIndent + TempPostedAsmLine."Variant Code")
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(TempPostedAsmLineUOM;GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                                DecimalPlaces = 0:5;
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
                            VATAmountLine."VAT %" := "VAT %";
                            VATAmountLine."VAT Base" := Amount;
                            VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                            VATAmountLine."Line Amount" := "Line Amount";
                            if "Allow Invoice Disc." then
                              VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                            VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                            VATAmountLine."VAT Clause Code" := "VAT Clause Code";
                            VATAmountLine.InsertLine;

                            TotalSubTotal += "Line Amount";
                            TotalInvDiscAmount -= "Inv. Discount Amount";
                            TotalAmount += Amount;
                            TotalAmountVAT += "Amount Including VAT" - Amount;
                            TotalAmountInclVAT += "Amount Including VAT";
                            TotalPaymentDiscOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DeleteAll;
                            SalesShipmentBuffer.Reset;
                            SalesShipmentBuffer.DeleteAll;
                            FirstValueEntryNo := 0;
                            MoreLines := Find('+');
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
                        column(ReportForNavId_40; 40)
                        {
                        }
                        column(VATAmtLineVATBase;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt;VATAmountLine."Line Amount")
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
                        column(VATAmtLineVATPer;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmtLineVATIdentifier;VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmtSpecificationCptn;VATAmtSpecificationCptnLbl)
                        {
                        }
                        column(InvDiscBaseAmtCaption;InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(LineAmtCaption;LineAmtCaptionLbl)
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
                    dataitem(VATClauseEntryCounter;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_27; 27)
                        {
                        }
                        column(VATClauseVATIdentifier;VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATClauseCode;VATAmountLine."VAT Clause Code")
                        {
                        }
                        column(VATClauseDescription;VATClause.Description)
                        {
                        }
                        column(VATClauseDescription2;VATClause."Description 2")
                        {
                        }
                        column(VATClauseAmount;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATClausesCaption;VATClausesCap)
                        {
                        }
                        column(VATClauseVATIdentifierCaption;VATIdentifierCaptionLbl)
                        {
                        }
                        column(VATClauseVATAmtCaption;VATAmtCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            if not VATClause.Get(VATAmountLine."VAT Clause Code") then
                              CurrReport.Skip;
                            VATClause.TranslateDescription("Sales Invoice Header"."Language Code");
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(VATClause);
                            SetRange(Number,1,VATAmountLine.Count);
                            CurrReport.CreateTotals(VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VatCounterLCY;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_20; 20)
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
                        column(VATPer_VATCounterLCY;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATIdentifier_VATCounterLCY;VATAmountLine."VAT Identifier")
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
                    dataitem(Total;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_11; 11)
                        {
                        }
                        column(SelltoCustNo_SalesInvHdr;"Sales Invoice Header"."Sell-to Customer No.")
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
                        column(ShiptoAddrCaption;ShiptoAddrCaptionLbl)
                        {
                        }
                        column(SelltoCustNo_SalesInvHdrCaption;"Sales Invoice Header".FieldCaption("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not ShowShippingAddr then
                              CurrReport.Break;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                      CopyText := Text003;
                      OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;

                    TotalSubTotal := 0;
                    TotalInvDiscAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalPaymentDiscOnVAT := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                      SalesInvCountPrinted.Run("Sales Invoice Header");
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

                if RespCenter.Get("Responsibility Center") then begin
                  FormatAddr.RespCenter(CompanyAddr,RespCenter);
                  CompanyInfo."Phone No." := RespCenter."Phone No.";
                  CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                  FormatAddr.Company(CompanyAddr,CompanyInfo);

                DimSetEntry1.SetRange("Dimension Set ID","Dimension Set ID");

                if "Order No." = '' then
                  OrderNoText := ''
                else
                  OrderNoText := FieldCaption("Order No.");
                if "Salesperson Code" = '' then begin
                  SalesPurchPerson.Init;
                  SalesPersonText := '';
                end else begin
                  SalesPurchPerson.Get("Salesperson Code");
                  SalesPersonText := Text000;
                end;
                if "Your Reference" = '' then
                  ReferenceText := ''
                else
                  ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                  VATNoText := ''
                else
                  VATNoText := FieldCaption("VAT Registration No.");
                if "Currency Code" = '' then begin
                  GLSetup.TestField("LCY Code");
                  TotalText := StrSubstNo(Text001,GLSetup."LCY Code");
                  TotalInclVATText := StrSubstNo(Text002,GLSetup."LCY Code");
                  TotalExclVATText := StrSubstNo(Text006,GLSetup."LCY Code");
                end else begin
                  TotalText := StrSubstNo(Text001,"Currency Code");
                  TotalInclVATText := StrSubstNo(Text002,"Currency Code");
                  TotalExclVATText := StrSubstNo(Text006,"Currency Code");
                end;
                FormatAddr.SalesInvBillTo(CustAddr,"Sales Invoice Header");
                if not Cust.Get("Bill-to Customer No.") then
                  Clear(Cust);

                if "Payment Terms Code" = '' then
                  PaymentTerms.Init
                else begin
                  PaymentTerms.Get("Payment Terms Code");
                  PaymentTerms.TranslateDescription(PaymentTerms,"Language Code");
                end;
                if "Shipment Method Code" = '' then
                  ShipmentMethod.Init
                else begin
                  ShipmentMethod.Get("Shipment Method Code");
                  ShipmentMethod.TranslateDescription(ShipmentMethod,"Language Code");
                end;
                //FormatAddr.SalesInvShipTo(ShipToAddr,"Sales Invoice Header");
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do
                  if ShipToAddr[i] <> CustAddr[i] then
                    ShowShippingAddr := true;

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
                        ApplicationArea = Basic;
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInfo;ShowInternalInfo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Internal Information';
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                    field(DisplayAsmInformation;DisplayAssemblyInformation)
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
        CompanyInfo.Get;
        SalesSetup.Get;
        CompanyInfo.VerifyAndSetPaymentInfo;
        case SalesSetup."Logo Position on Documents" of
          SalesSetup."logo position on documents"::Left:
            begin
              CompanyInfo3.Get;
              CompanyInfo3.CalcFields(Picture);
            end;
          SalesSetup."logo position on documents"::Center:
            begin
              CompanyInfo1.Get;
              CompanyInfo1.CalcFields(Picture);
            end;
          SalesSetup."logo position on documents"::Right:
            begin
              CompanyInfo2.Get;
              CompanyInfo2.CalcFields(Picture);
            end;
        end;
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
          InitLogInteraction;
    end;

    var
        Text000: label 'Salesperson';
        Text001: label 'Total %1';
        Text002: label 'Total %1 Incl. VAT';
        Text003: label 'COPY';
        Text004: label 'Sales - Invoice %1';
        PageCaptionCap: label 'Page %1 of %2';
        Text006: label 'Total %1 Excl. VAT';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        CurrExchRate: Record "Currency Exchange Rate";
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        VATClause: Record "VAT Clause";
        SalesInvCountPrinted: Codeunit "Sales Inv.-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
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
        i: Integer;
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
        Text007: label 'VAT Amount Specification in ';
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
        TotalInvDiscAmount: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        CompanyInfoPhoneNoCaptionLbl: label 'Phone No.';
        CompanyInfoVATRegNoCptnLbl: label 'VAT Reg. No.';
        CompanyInfoGiroNoCaptionLbl: label 'Giro No.';
        CompanyInfoBankNameCptnLbl: label 'Bank';
        CompanyInfoBankAccNoCptnLbl: label 'Account No.';
        SalesInvDueDateCaptionLbl: label 'Due Date';
        InvNoCaptionLbl: label 'Invoice No.';
        SalesInvPostingDateCptnLbl: label 'Posting Date';
        HeaderDimCaptionLbl: label 'Header Dimensions';
        UnitPriceCaptionLbl: label 'Unit Price';
        SalesInvLineDiscCaptionLbl: label 'Discount %';
        AmountCaptionLbl: label 'Amount';
        VATClausesCap: label 'VAT Clause';
        PostedShipmentDateCaptionLbl: label 'Posted Shipment Date';
        SubtotalCaptionLbl: label 'Subtotal';
        LineAmtAfterInvDiscCptnLbl: label 'Payment Discount on VAT';
        ShipmentCaptionLbl: label 'Shipment';
        LineDimCaptionLbl: label 'Line Dimensions';
        VATAmtSpecificationCptnLbl: label 'VAT Amount Specification';
        InvDiscBaseAmtCaptionLbl: label 'Invoice Discount Base Amount';
        LineAmtCaptionLbl: label 'Line Amount';
        ShiptoAddrCaptionLbl: label 'Ship-to Address';
        InvDiscountAmtCaptionLbl: label 'Invoice Discount Amount';
        DocumentDateCaptionLbl: label 'Document Date';
        PaymentTermsDescCaptionLbl: label 'Payment Terms';
        ShptMethodDescCaptionLbl: label 'Shipment Method';
        VATPercentageCaptionLbl: label 'VAT %';
        TotalCaptionLbl: label 'Total';
        VATBaseCaptionLbl: label 'VAT Base';
        VATAmtCaptionLbl: label 'VAT Amount';
        VATIdentifierCaptionLbl: label 'VAT Identifier';
        HomePageCaptionCap: label 'Home Page';
        EMailCaptionLbl: label 'E-Mail';


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

        if "Sales Invoice Header"."Order No."='' then
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
              if Abs(SalesShipmentLine.Quantity)  > Abs(TotalQuantity) then
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


    procedure InitializeRequest(NewNoOfCopies: Integer;NewShowInternalInfo: Boolean;NewLogInteraction: Boolean;DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
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
          if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then
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
}

