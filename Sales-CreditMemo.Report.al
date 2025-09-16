#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 207 "Sales - Credit Memo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales - Credit Memo.rdlc';
    Caption = 'Sales - Credit Memo';
    Permissions = TableData "Sales Shipment Buffer"=rimd;
    PreviewMode = PrintLayout;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Sales Cr.Memo Header";"Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Sell-to Customer No.","No. Printed";
            RequestFilterHeading = 'Posted Sales Credit Memo';
            column(ReportForNavId_8098; 8098)
            {
            }
            column(No_SalesCrMemoHdr;"No.")
            {
            }
            column(InvDiscAmtCaption;InvDiscAmtCaptionLbl)
            {
            }
            column(AppliesToCaption;AppliesToCaptionLbl)
            {
            }
            column(VATPercentageCaption;VATPercentageCaptionLbl)
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
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(CompanyInfoHomePageCaption;CompanyInfoHomePageCaptionLbl)
            {
            }
            column(CompanyInfoEmailCaption;CompanyInfoEmailCaptionLbl)
            {
            }
            column(DocDateCaption;DocDateCaptionLbl)
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
                    column(SalesCrMemoHeaderCopyText;StrSubstNo(DocumentCaption,CopyText))
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
                    column(CompanyInfoHomePage;CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail;CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfo1Picture;CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo2Picture;CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture;CompanyInfo3.Picture)
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
                    column(BillToCustNo_SalesCrMemoHdr;"Sales Cr.Memo Header"."Bill-to Customer No.")
                    {
                    }
                    column(PostingDate_SalesCrMemoHdr;Format("Sales Cr.Memo Header"."Posting Date",0,4))
                    {
                    }
                    column(VATNoText;VATNoText)
                    {
                    }
                    column(VATRegNo_SalesCrMemoHdr;"Sales Cr.Memo Header"."VAT Registration No.")
                    {
                    }
                    column(SalesPersonText;SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(AppliedToText;AppliedToText)
                    {
                    }
                    column(ReferenceText;ReferenceText)
                    {
                    }
                    column(YourReference_SalesCrMemoHdr;"Sales Cr.Memo Header"."Your Reference")
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
                    column(DocDate_SalesCrMemoHdr;Format("Sales Cr.Memo Header"."Document Date",0,4))
                    {
                    }
                    column(PricesInclVAT_SalesCrMemoHdr;"Sales Cr.Memo Header"."Prices Including VAT")
                    {
                    }
                    column(ReturnOrderNoText;ReturnOrderNoText)
                    {
                    }
                    column(ReturnOrderNo_SalesCrMemoHdr;"Sales Cr.Memo Header"."Return Order No.")
                    {
                    }
                    column(PageCaption;PageCaptionCap)
                    {
                    }
                    column(OutputNo;OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo;Format("Sales Cr.Memo Header"."Prices Including VAT"))
                    {
                    }
                    column(VATBaseDiscPercentage;"Sales Cr.Memo Header"."VAT Base Discount %")
                    {
                    }
                    column(CustTaxIdentificationType;Cust.GetLegalEntityType)
                    {
                    }
                    column(CompanyInfoPhoneNoCaption;CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegNoCaption;CompanyInfoVATRegNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoGiroNoCaption;CompanyInfoGiroNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankNameCaption;CompanyInfoBankNameCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankAccNoCaption;CompanyInfoBankAccNoCaptionLbl)
                    {
                    }
                    column(CrMemoHdrNoCaption;CrMemoHdrNoCaptionLbl)
                    {
                    }
                    column(PostingDateCaption;PostingDateCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption;Cust.GetLegalEntityTypeLbl)
                    {
                    }
                    column(BillToCustNo_SalesCrMemoHdrCaption;"Sales Cr.Memo Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_SalesCrMemoHdrCaption;"Sales Cr.Memo Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    dataitem(DimensionLoop1;"Integer")
                    {
                        DataItemLinkReference = "Sales Cr.Memo Header";
                        DataItemTableView = sorting(Number) where(Number=filter(1..));
                        column(ReportForNavId_7574; 7574)
                        {
                        }
                        column(DimText_DimensionLoop1;DimText)
                        {
                        }
                        column(No_DimensionLoop1;Number)
                        {
                        }
                        column(HdrDimensionsCaption;HdrDimensionsCaptionLbl)
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
                    dataitem("Sales Cr.Memo Line";"Sales Cr.Memo Line")
                    {
                        DataItemLink = "Document No."=field("No.");
                        DataItemLinkReference = "Sales Cr.Memo Header";
                        DataItemTableView = sorting("Document No.","Line No.");
                        column(ReportForNavId_3364; 3364)
                        {
                        }
                        column(LineAmt_SalesCrMemoLine;"Line Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesCrMemoLine;Description)
                        {
                        }
                        column(No_SalesCrMemoLine;"No.")
                        {
                        }
                        column(Qty_SalesCrMemoLine;Quantity)
                        {
                        }
                        column(UOM_SalesCrMemoLine;"Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesCrMemoLine;"Unit Price")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(LineDisc_SalesCrMemoLine;"Line Discount %")
                        {
                        }
                        column(VATIdentifier_SalesCrMemoLine;"VAT Identifier")
                        {
                        }
                        column(PostedRcptDate;Format(PostedReceiptDate))
                        {
                        }
                        column(Type_SalesCrMemoLine;Format(Type))
                        {
                        }
                        column(NNCTotalLineAmt;NNC_TotalLineAmount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(NNCTotalAmtInclVat;NNC_TotalAmountInclVat)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(NNCTotalInvDiscAmt;NNC_TotalInvDiscAmount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(NNCTotalAmt;NNC_TotalAmount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalText;TotalText)
                        {
                        }
                        column(Amt_SalesCrMemoLine;Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText;TotalExclVATText)
                        {
                        }
                        column(TotalInclVATText;TotalInclVATText)
                        {
                        }
                        column(AmtInclVAT_SalesCrMemoLine;"Amount Including VAT")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AmtInclVATAmt;"Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText;VATAmountLine.VATAmountText)
                        {
                        }
                        column(DocNo_SalesCrMemoLine;"Document No.")
                        {
                        }
                        column(LineNo_SalesCrMemoLine;"Line No.")
                        {
                        }
                        column(UnitPriceCaption;UnitPriceCaptionLbl)
                        {
                        }
                        column(DiscPercentageCaption;DiscPercentageCaptionLbl)
                        {
                        }
                        column(AmtCaption;AmtCaptionLbl)
                        {
                        }
                        column(PostedReturnRcptDateCaption;PostedReturnRcptDateCaptionLbl)
                        {
                        }
                        column(SubtotalCaption;SubtotalCaptionLbl)
                        {
                        }
                        column(PymtDiscOnVATCaption;PymtDiscOnVATCaptionLbl)
                        {
                        }
                        column(Desc_SalesCrMemoLineCaption;FieldCaption(Description))
                        {
                        }
                        column(No_SalesCrMemoLineCaption;FieldCaption("No."))
                        {
                        }
                        column(Qty_SalesCrMemoLineCaption;FieldCaption(Quantity))
                        {
                        }
                        column(UOM_SalesCrMemoLineCaption;FieldCaption("Unit of Measure"))
                        {
                        }
                        column(VATIdentifier_SalesCrMemoLineCaption;FieldCaption("VAT Identifier"))
                        {
                        }
                        dataitem("Sales Shipment Buffer";"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_1484; 1484)
                            {
                            }
                            column(SalesShipmentBufferQty;SalesShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0:5;
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
                                SetRange(Number,1,SalesShipmentBuffer.Count);
                            end;
                        }
                        dataitem(DimensionLoop2;"Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number=filter(1..));
                            column(ReportForNavId_3591; 3591)
                            {
                            }
                            column(DimText_DimensionLoop2;DimText)
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

                                DimSetEntry2.SetRange("Dimension Set ID","Sales Cr.Memo Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            NNC_TotalLineAmount += "Line Amount";
                            NNC_TotalAmountInclVat += "Amount Including VAT";
                            NNC_TotalInvDiscAmount += "Inv. Discount Amount";
                            NNC_TotalAmount += Amount;

                            SalesShipmentBuffer.DeleteAll;
                            PostedReceiptDate := 0D;
                            if Quantity <> 0 then
                              PostedReceiptDate := FindPostedShipmentDate;

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
                            CurrReport.CreateTotals(Amount,"Amount Including VAT","Inv. Discount Amount");
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
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT_VATCounter;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmtLineVATIdentifier_VATCounter;VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmtSpecificationCaption;VATAmtSpecificationCaptionLbl)
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
                    dataitem(VATCounterLCY;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_2038; 2038)
                        {
                        }
                        column(VALSpecLCYHdr;VALSpecLCYHeader)
                        {
                        }
                        column(VALExchRate;VALExchRate)
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
                        column(VATAmLineVATIdentifier_VATCounterLCY;VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Sales Cr.Memo Header"."Posting Date","Sales Cr.Memo Header"."Currency Code",
                                "Sales Cr.Memo Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Sales Cr.Memo Header"."Posting Date","Sales Cr.Memo Header"."Currency Code",
                                "Sales Cr.Memo Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Sales Cr.Memo Header"."Currency Code" = '')
                            then
                              CurrReport.Break;

                            SetRange(Number,1,VATAmountLine.Count);
                            CurrReport.CreateTotals(VALVATBaseLCY,VALVATAmountLCY);

                            if GLSetup."LCY Code" = '' then
                              VALSpecLCYHeader := Text008 + Text009
                            else
                              VALSpecLCYHeader := Text008 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Cr.Memo Header"."Posting Date","Sales Cr.Memo Header"."Currency Code",1);
                            CalculatedExchRate := ROUND(1 / "Sales Cr.Memo Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount",0.000001);
                            VALExchRate := StrSubstNo(Text010,CalculatedExchRate,CurrExchRate."Exchange Rate Amount");
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
                        column(SellToCustNo_SalesCrMemoHdr;"Sales Cr.Memo Header"."Sell-to Customer No.")
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
                        column(ShiptoAddressCaption;ShiptoAddressCaptionLbl)
                        {
                        }
                        column(SellToCustNo_SalesCrMemoHdrCaption;"Sales Cr.Memo Header".FieldCaption("Sell-to Customer No."))
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
                    CurrReport.PageNo := 1;
                    if Number > 1 then begin
                      CopyText := FormatDocument.GetCOPYText;
                      OutputNo += 1;
                    end;

                    NNC_TotalLineAmount := 0;
                    NNC_TotalAmountInclVat := 0;
                    NNC_TotalInvDiscAmount := 0;
                    NNC_TotalAmount := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                      Codeunit.Run(Codeunit::"Sales Cr. Memo-Printed","Sales Cr.Memo Header");
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

                FormatAddressFields("Sales Cr.Memo Header");
                FormatDocumentFields("Sales Cr.Memo Header");

                if not Cust.Get("Bill-to Customer No.") then
                  Clear(Cust);

                DimSetEntry1.SetRange("Dimension Set ID","Dimension Set ID");

                if LogInteraction then
                  if not CurrReport.Preview then
                    if "Bill-to Contact No." <> '' then
                      SegManagement.LogDocument(
                        6,"No.",0,0,Database::Contact,"Bill-to Contact No.","Salesperson Code",
                        "Campaign No.","Posting Description",'')
                    else
                      SegManagement.LogDocument(
                        6,"No.",0,0,Database::Customer,"Sell-to Customer No.","Salesperson Code",
                        "Campaign No.","Posting Description",'');
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
            LogInteraction := SegManagement.FindInteractTmplCode(6) <> '';
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

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
          InitLogInteraction;
    end;

    var
        Text003: label '(Applies to %1 %2)';
        Text005: label 'Sales - Credit Memo %1', Comment='%1 = Document No.';
        PageCaptionCap: label 'Page %1 of %2';
        GLSetup: Record "General Ledger Setup";
        RespCenter: Record "Responsibility Center";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        Language: Record Language;
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        CurrExchRate: Record "Currency Exchange Rate";
        Cust: Record Customer;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        CustAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        ReturnOrderNoText: Text[80];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        AppliedToText: Text;
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
        LogInteraction: Boolean;
        FirstValueEntryNo: Integer;
        PostedReceiptDate: Date;
        NextEntryNo: Integer;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        Text008: label 'Tax Amount Specification in ';
        Text009: label 'Local Currency';
        Text010: label 'Exchange rate: %1/%2';
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        CalculatedExchRate: Decimal;
        Text011: label 'Sales - Prepmt. Credit Memo %1';
        OutputNo: Integer;
        NNC_TotalLineAmount: Decimal;
        NNC_TotalAmountInclVat: Decimal;
        NNC_TotalInvDiscAmount: Decimal;
        NNC_TotalAmount: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        InvDiscAmtCaptionLbl: label 'Invoice Discount Amount';
        AppliesToCaptionLbl: label 'Applies To';
        CompanyInfoPhoneNoCaptionLbl: label 'Phone No.';
        CompanyInfoVATRegNoCaptionLbl: label 'Tax Registration No.';
        CompanyInfoGiroNoCaptionLbl: label 'Giro No.';
        CompanyInfoBankNameCaptionLbl: label 'Bank';
        CompanyInfoBankAccNoCaptionLbl: label 'Account No.';
        CrMemoHdrNoCaptionLbl: label 'Credit Memo No.';
        PostingDateCaptionLbl: label 'Posting Date';
        HdrDimensionsCaptionLbl: label 'Header Dimensions';
        UnitPriceCaptionLbl: label 'Unit Price';
        DiscPercentageCaptionLbl: label 'Discount %';
        AmtCaptionLbl: label 'Amount';
        PostedReturnRcptDateCaptionLbl: label 'Posted Return Receipt Date';
        SubtotalCaptionLbl: label 'Subtotal';
        PymtDiscOnVATCaptionLbl: label 'Payment Discount on VAT';
        LineDimensionsCaptionLbl: label 'Line Dimensions';
        VATAmtSpecificationCaptionLbl: label 'Tax Amount Specification';
        InvDiscBaseAmtCaptionLbl: label 'Invoice Discount Base Amount';
        LineAmtCaptionLbl: label 'Line Amount';
        ShiptoAddressCaptionLbl: label 'Ship-to Address';
        VATPercentageCaptionLbl: label 'Tax %';
        VATBaseCaptionLbl: label 'Tax Base';
        VATAmtCaptionLbl: label 'Tax Amount';
        VATIdentifierCaptionLbl: label 'Tax Identifier';
        TotalCaptionLbl: label 'Total';
        CompanyInfoHomePageCaptionLbl: label 'Home Page';
        CompanyInfoEmailCaptionLbl: label 'Email';
        DocDateCaptionLbl: label 'Document Date';


    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(6) <> '';
    end;

    local procedure FindPostedShipmentDate(): Date
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
        SalesShipmentBuffer2: Record "Sales Shipment Buffer" temporary;
    begin
        NextEntryNo := 1;
        if "Sales Cr.Memo Line"."Return Receipt No." <> '' then
          if ReturnReceiptHeader.Get("Sales Cr.Memo Line"."Return Receipt No.") then
            exit(ReturnReceiptHeader."Posting Date");
        if "Sales Cr.Memo Header"."Return Order No." = '' then
          exit("Sales Cr.Memo Header"."Posting Date");

        case "Sales Cr.Memo Line".Type of
          "Sales Cr.Memo Line".Type::Item:
            GenerateBufferFromValueEntry("Sales Cr.Memo Line");
          "Sales Cr.Memo Line".Type::"G/L Account","Sales Cr.Memo Line".Type::Resource,
          "Sales Cr.Memo Line".Type::"Charge (Item)","Sales Cr.Memo Line".Type::"Fixed Asset":
            GenerateBufferFromShipment("Sales Cr.Memo Line");
          "Sales Cr.Memo Line".Type::" ":
            exit(0D);
        end;

        SalesShipmentBuffer.Reset;
        SalesShipmentBuffer.SetRange("Document No.","Sales Cr.Memo Line"."Document No.");
        SalesShipmentBuffer.SetRange("Line No." ,"Sales Cr.Memo Line"."Line No.");

        if SalesShipmentBuffer.Find('-') then begin
          SalesShipmentBuffer2 := SalesShipmentBuffer;
          if SalesShipmentBuffer.Next = 0 then begin
            SalesShipmentBuffer.Get(
              SalesShipmentBuffer2."Document No.",SalesShipmentBuffer2."Line No.",SalesShipmentBuffer2."Entry No.");
            SalesShipmentBuffer.Delete;
            exit(SalesShipmentBuffer2."Posting Date");
          end;
          SalesShipmentBuffer.CalcSums(Quantity);
          if SalesShipmentBuffer.Quantity <> "Sales Cr.Memo Line".Quantity then begin
            SalesShipmentBuffer.DeleteAll;
            exit("Sales Cr.Memo Header"."Posting Date");
          end;
        end else
          exit("Sales Cr.Memo Header"."Posting Date");
    end;

    local procedure GenerateBufferFromValueEntry(SalesCrMemoLine2: Record "Sales Cr.Memo Line")
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := SalesCrMemoLine2."Quantity (Base)";
        ValueEntry.SetCurrentkey("Document No.");
        ValueEntry.SetRange("Document No.",SalesCrMemoLine2."Document No.");
        ValueEntry.SetRange("Posting Date","Sales Cr.Memo Header"."Posting Date");
        ValueEntry.SetRange("Item Charge No.",'');
        ValueEntry.SetFilter("Entry No.",'%1..',FirstValueEntryNo);
        if ValueEntry.Find('-') then
          repeat
            if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
              if SalesCrMemoLine2."Qty. per Unit of Measure" <> 0 then
                Quantity := ValueEntry."Invoiced Quantity" / SalesCrMemoLine2."Qty. per Unit of Measure"
              else
                Quantity := ValueEntry."Invoiced Quantity";
              AddBufferEntry(
                SalesCrMemoLine2,
                -Quantity,
                ItemLedgerEntry."Posting Date");
              TotalQuantity := TotalQuantity - ValueEntry."Invoiced Quantity";
            end;
            FirstValueEntryNo := ValueEntry."Entry No." + 1;
          until (ValueEntry.Next = 0) or (TotalQuantity = 0);
    end;

    local procedure GenerateBufferFromShipment(SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine2: Record "Sales Cr.Memo Line";
        ReturnReceiptHeader: Record "Return Receipt Header";
        ReturnReceiptLine: Record "Return Receipt Line";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesCrMemoHeader.SetCurrentkey("Return Order No.");
        SalesCrMemoHeader.SetFilter("No.",'..%1',"Sales Cr.Memo Header"."No.");
        SalesCrMemoHeader.SetRange("Return Order No.","Sales Cr.Memo Header"."Return Order No.");
        if SalesCrMemoHeader.Find('-') then
          repeat
            SalesCrMemoLine2.SetRange("Document No.",SalesCrMemoHeader."No.");
            SalesCrMemoLine2.SetRange("Line No.",SalesCrMemoLine."Line No.");
            SalesCrMemoLine2.SetRange(Type,SalesCrMemoLine.Type);
            SalesCrMemoLine2.SetRange("No.",SalesCrMemoLine."No.");
            SalesCrMemoLine2.SetRange("Unit of Measure Code",SalesCrMemoLine."Unit of Measure Code");
            if SalesCrMemoLine2.Find('-') then
              repeat
                TotalQuantity := TotalQuantity + SalesCrMemoLine2.Quantity;
              until SalesCrMemoLine2.Next = 0;
          until SalesCrMemoHeader.Next = 0;

        ReturnReceiptLine.SetCurrentkey("Return Order No.","Return Order Line No.");
        ReturnReceiptLine.SetRange("Return Order No.","Sales Cr.Memo Header"."Return Order No.");
        ReturnReceiptLine.SetRange("Return Order Line No.",SalesCrMemoLine."Line No.");
        ReturnReceiptLine.SetRange("Line No.",SalesCrMemoLine."Line No.");
        ReturnReceiptLine.SetRange(Type,SalesCrMemoLine.Type);
        ReturnReceiptLine.SetRange("No.",SalesCrMemoLine."No.");
        ReturnReceiptLine.SetRange("Unit of Measure Code",SalesCrMemoLine."Unit of Measure Code");
        ReturnReceiptLine.SetFilter(Quantity,'<>%1',0);

        if ReturnReceiptLine.Find('-') then
          repeat
            if "Sales Cr.Memo Header"."Get Return Receipt Used" then
              CorrectShipment(ReturnReceiptLine);
            if Abs(ReturnReceiptLine.Quantity) <= Abs(TotalQuantity - SalesCrMemoLine.Quantity) then
              TotalQuantity := TotalQuantity - ReturnReceiptLine.Quantity
            else begin
              if Abs(ReturnReceiptLine.Quantity) > Abs(TotalQuantity) then
                ReturnReceiptLine.Quantity := TotalQuantity;
              Quantity :=
                ReturnReceiptLine.Quantity - (TotalQuantity - SalesCrMemoLine.Quantity);

              SalesCrMemoLine.Quantity := SalesCrMemoLine.Quantity - Quantity;
              TotalQuantity := TotalQuantity - ReturnReceiptLine.Quantity;

              if ReturnReceiptHeader.Get(ReturnReceiptLine."Document No.") then
                AddBufferEntry(
                  SalesCrMemoLine,
                  -Quantity,
                  ReturnReceiptHeader."Posting Date");
            end;
          until (ReturnReceiptLine.Next = 0) or (TotalQuantity = 0);
    end;

    local procedure CorrectShipment(var ReturnReceiptLine: Record "Return Receipt Line")
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        SalesCrMemoLine.SetCurrentkey("Return Receipt No.","Return Receipt Line No.");
        SalesCrMemoLine.SetRange("Return Receipt No.",ReturnReceiptLine."Document No.");
        SalesCrMemoLine.SetRange("Return Receipt Line No.",ReturnReceiptLine."Line No.");
        if SalesCrMemoLine.Find('-') then
          repeat
            ReturnReceiptLine.Quantity := ReturnReceiptLine.Quantity - SalesCrMemoLine.Quantity;
          until SalesCrMemoLine.Next = 0;
    end;

    local procedure AddBufferEntry(SalesCrMemoLine: Record "Sales Cr.Memo Line";QtyOnShipment: Decimal;PostingDate: Date)
    begin
        SalesShipmentBuffer.SetRange("Document No.",SalesCrMemoLine."Document No.");
        SalesShipmentBuffer.SetRange("Line No.",SalesCrMemoLine."Line No.");
        SalesShipmentBuffer.SetRange("Posting Date",PostingDate);
        if SalesShipmentBuffer.Find('-') then begin
          SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity - QtyOnShipment;
          SalesShipmentBuffer.Modify;
          exit;
        end;

        with SalesShipmentBuffer do begin
          Init;
          "Document No." := SalesCrMemoLine."Document No.";
          "Line No." := SalesCrMemoLine."Line No.";
          "Entry No." := NextEntryNo;
          Type := SalesCrMemoLine.Type;
          "No." := SalesCrMemoLine."No.";
          Quantity := -QtyOnShipment;
          "Posting Date" := PostingDate;
          Insert;
          NextEntryNo := NextEntryNo + 1
        end;
    end;

    local procedure DocumentCaption(): Text[250]
    begin
        if "Sales Cr.Memo Header"."Prepayment Credit Memo" then
          exit(Text011);
        exit(Text005);
    end;


    procedure InitializeRequest(NewNoOfCopies: Integer;NewShowInternalInfo: Boolean;NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
    end;

    local procedure FormatAddressFields(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        FormatAddr.GetCompanyAddr(SalesCrMemoHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
        FormatAddr.SalesCrMemoBillTo(CustAddr,SalesCrMemoHeader);
        ShowShippingAddr := FormatAddr.SalesCrMemoShipTo(ShipToAddr,CustAddr,SalesCrMemoHeader);
    end;

    local procedure FormatDocumentFields(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        with SalesCrMemoHeader do begin
          FormatDocument.SetTotalLabels("Currency Code",TotalText,TotalInclVATText,TotalExclVATText);
          FormatDocument.SetSalesPerson(SalesPurchPerson,"Salesperson Code",SalesPersonText);

          ReturnOrderNoText := FormatDocument.SetText("Return Order No." <> '',FieldCaption("Return Order No."));
          ReferenceText := FormatDocument.SetText("Your Reference" <> '',FieldCaption("Your Reference"));
          VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FieldCaption("VAT Registration No."));
          AppliedToText :=
            FormatDocument.SetText(
              "Applies-to Doc. No." <> '',Format(StrSubstNo(Text003,Format("Applies-to Doc. Type"),"Applies-to Doc. No.")));
        end;
    end;
}

