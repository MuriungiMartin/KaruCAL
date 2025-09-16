#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6631 "Return Order Confirmation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Return Order Confirmation.rdlc';
    Caption = 'Return Order Confirmation';
    PreviewMode = PrintLayout;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Sales Header";"Sales Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const("Return Order"));
            RequestFilterFields = "No.","Sell-to Customer No.","No. Printed";
            RequestFilterHeading = 'Sales Return Order';
            column(ReportForNavId_6640; 6640)
            {
            }
            column(No_SalesHdr;"No.")
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
                    column(CompanyInfo1Picture;CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo2Picture;CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture;CompanyInfo3.Picture)
                    {
                    }
                    column(ReturnOrderConfirmCopyText;StrSubstNo(Text004,CopyText))
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
                    column(CompanyInfoHomePage;CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEMail;CompanyInfo."E-Mail")
                    {
                    }
                    column(BilltoCustomerNo_SalesHdr;"Sales Header"."Bill-to Customer No.")
                    {
                    }
                    column(DocDate_SalesHdr;Format("Sales Header"."Document Date",0,4))
                    {
                    }
                    column(VATNoText;VATNoText)
                    {
                    }
                    column(VATRegNo_SalesHdr;"Sales Header"."VAT Registration No.")
                    {
                    }
                    column(SalesPersonText;SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(No1_SalesHdr;"Sales Header"."No.")
                    {
                    }
                    column(ReferenceText;ReferenceText)
                    {
                    }
                    column(YourRef_SalesHdr;"Sales Header"."Your Reference")
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
                    column(PricesInclVAT_SalesHdr;"Sales Header"."Prices Including VAT")
                    {
                    }
                    column(PageCaption;StrSubstNo(Text005,''))
                    {
                    }
                    column(OutputNo;OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo;Format("Sales Header"."Prices Including VAT"))
                    {
                    }
                    column(CustTaxIdentificationType;Format(Cust."Tax Identification Type"))
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
                    column(ReturnOrderNoCaption;ReturnOrderNoCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption;TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(BilltoCustomerNo_SalesHdrCaption;"Sales Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_SalesHdrCaption;"Sales Header".FieldCaption("Prices Including VAT"))
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
                        column(Number_DimensionLoop1;Number)
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
                        column(TypeInt;TypeInt)
                        {
                        }
                        column(SalesLineNo;SalesLineNo)
                        {
                        }
                        column(SalesLineLineNo;SalesLineLineNo)
                        {
                        }
                        column(SalesLineLineAmt;SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesLine;"Sales Line".Description)
                        {
                        }
                        column(DocNo_SalesLine;SalesLine."Document No.")
                        {
                        }
                        column(No2_SalesLine;"Sales Line"."No.")
                        {
                        }
                        column(Qty_SalesLine;"Sales Line".Quantity)
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
                        column(LineDisc_SalesLine;"Sales Line"."Line Discount %")
                        {
                        }
                        column(AllowInvDisc_SalesLine;"Sales Line"."Allow Invoice Disc.")
                        {
                        }
                        column(VATIdentifier_SalesLine;"Sales Line"."VAT Identifier")
                        {
                        }
                        column(AllowInvDisc1_SalesLine;Format("Sales Line"."Allow Invoice Disc."))
                        {
                        }
                        column(SalesLineInvDiscAmt;-SalesLine."Inv. Discount Amount")
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
                        column(VATDiscAmt;-VATDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseDiscPercentage_SaleHdr;"Sales Header"."VAT Base Discount %")
                        {
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
                        column(TotalSubTotal;TotalSubTotal)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvDiscAmt;TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmt;TotalAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(UnitPriceCaption;UnitPriceCaptionLbl)
                        {
                        }
                        column(DiscountCaption;DiscountCaptionLbl)
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
                        column(PaymentDiscOnVATCaption;PaymentDiscOnVATCaptionLbl)
                        {
                        }
                        column(NoSalesLineCaption;NoSalesLineCaptionLbl)
                        {
                        }
                        column(Quantity_SalesLineCaption;"Sales Line".FieldCaption(Quantity))
                        {
                        }
                        column(UnitofMeasure_SalesLineCaption;"Sales Line".FieldCaption("Unit of Measure"))
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
                            column(DimText1;DimText)
                            {
                            }
                            column(Number_DimensionLoop2;Number)
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

                                DimSetEntry2.SetRange("Dimension Set ID","Sales Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                              SalesLine.Find('-')
                            else
                              SalesLine.Next;
                            "Sales Line" := SalesLine;

                            if (SalesLine.Type = SalesLine.Type::"G/L Account") and (not ShowInternalInfo) then begin
                              SalesLineNo := "Sales Line"."No.";
                              "Sales Line"."No." := '';
                            end;

                            TypeInt := "Sales Line".Type;
                            SalesLineLineNo := "Sales Line"."Line No.";
                            TotalSubTotal += "Sales Line"."Line Amount";
                            TotalInvoiceDiscountAmount -= "Sales Line"."Inv. Discount Amount";
                            TotalAmount += "Sales Line".Amount;
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
                        column(VATAmtLineInvoiceDiscountAmt;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmtLineVATIdentifier;VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATPercentageCaption;VATPercentageCaptionLbl)
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
                        column(InvDiscBaseAmtCaption;InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(LineAmountCaption;LineAmountCaptionLbl)
                        {
                        }
                        column(InvDiscAmountCaption;InvDiscAmountCaptionLbl)
                        {
                        }
                        column(VATIdentifierCaption;VATIdentifierCaptionLbl)
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
                        column(VALVATAmtLCY;VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATPercentage;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmtLineVATIdentifier2;VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);

                            VALVATBaseLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                  "Sales Header"."Posting Date","Sales Header"."Currency Code",
                                  VATAmountLine."VAT Base","Sales Header"."Currency Factor"));
                            VALVATAmountLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                  "Sales Header"."Posting Date","Sales Header"."Currency Code",
                                  VATAmountLine."VAT Amount","Sales Header"."Currency Factor"));
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
                        column(SelltoCustomerNo_SalesHdr;"Sales Header"."Sell-to Customer No.")
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
                        column(ShowShippingAddr;ShowShippingAddr)
                        {
                        }
                        column(ShiptoAddressCaption;ShiptoAddressCaptionLbl)
                        {
                        }
                        column(SelltoCustomerNo_SalesHdrCaption;"Sales Header".FieldCaption("Sell-to Customer No."))
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
                var
                    SalesPost: Codeunit "Sales-Post";
                begin
                    Clear(SalesLine);
                    Clear(SalesPost);
                    SalesLine.DeleteAll;
                    VATAmountLine.DeleteAll;
                    SalesPost.GetSalesLines("Sales Header",SalesLine,0);
                    SalesLine.CalcVATAmountLines(0,"Sales Header",SalesLine,VATAmountLine);
                    SalesLine.UpdateVATOnLines(0,"Sales Header",SalesLine,VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code","Sales Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                    if Number > 1 then begin
                      CopyText := FormatDocument.GetCOPYText;
                      OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;

                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
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

                if LogInteraction then
                  if not CurrReport.Preview then begin
                    if "Bill-to Contact No." <> '' then
                      SegManagement.LogDocument(
                        18,"No.",0,0,Database::Contact,"Bill-to Contact No.","Salesperson Code",
                        "Campaign No.","Posting Description","Opportunity No.")
                    else
                      SegManagement.LogDocument(
                        18,"No.",0,0,Database::Customer,"Bill-to Customer No.","Salesperson Code",
                        "Campaign No.","Posting Description","Opportunity No.");
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
        case SalesSetup."Logo Position on Documents" of
          SalesSetup."logo position on documents"::"No Logo":
            ;
          SalesSetup."logo position on documents"::Left:
            begin
              CompanyInfo1.Get;
              CompanyInfo1.CalcFields(Picture);
            end;
          SalesSetup."logo position on documents"::Center:
            begin
              CompanyInfo2.Get;
              CompanyInfo2.CalcFields(Picture);
            end;
          SalesSetup."logo position on documents"::Right:
            begin
              CompanyInfo3.Get;
              CompanyInfo3.CalcFields(Picture);
            end;
        end;
        GLSetup.Get;
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
          InitLogInteraction;
    end;

    var
        Text004: label 'Return Order Confirmation %1', Comment='%1 = Document No.';
        Text005: label 'Page %1';
        GLSetup: Record "General Ledger Setup";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        VATAmountLine: Record "VAT Amount Line" temporary;
        SalesLine: Record "Sales Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        CurrExchRate: Record "Currency Exchange Rate";
        Cust: Record Customer;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
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
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        Text007: label 'Tax Amount Specification in ';
        Text008: label 'Local Currency';
        Text009: label 'Exchange rate: %1/%2';
        OutputNo: Integer;
        TypeInt: Integer;
        SalesLineNo: Code[20];
        SalesLineLineNo: Integer;
        [InDataSet]
        LogInteractionEnable: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        SalesSetup: Record "Sales & Receivables Setup";
        PhoneNoCaptionLbl: label 'Phone No.';
        VATRegistrationNoCaptionLbl: label 'Tax Registration No.';
        GiroNoCaptionLbl: label 'Giro No.';
        BankNameCaptionLbl: label 'Bank';
        BankAccountNoCaptionLbl: label 'Account No.';
        ReturnOrderNoCaptionLbl: label 'Return Order No.';
        TaxIdentTypeCaptionLbl: label 'Tax Identification Type';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions';
        UnitPriceCaptionLbl: label 'Unit Price';
        DiscountCaptionLbl: label 'Discount %';
        AmountCaptionLbl: label 'Amount';
        InvDiscountAmountCaptionLbl: label 'Invoice Discount Amount';
        SubtotalCaptionLbl: label 'Subtotal';
        PaymentDiscOnVATCaptionLbl: label 'Payment Discount on VAT';
        NoSalesLineCaptionLbl: label 'No.';
        LineDimensionsCaptionLbl: label 'Line Dimensions';
        VATPercentageCaptionLbl: label 'Tax %';
        VATBaseCaptionLbl: label 'Tax Base';
        VATAmountCaptionLbl: label 'Tax Amount';
        VATAmountSpecificationCaptionLbl: label 'Tax Amount Specification';
        InvDiscBaseAmtCaptionLbl: label 'Inv. Disc. Base Amount';
        LineAmountCaptionLbl: label 'Line Amount';
        InvDiscAmountCaptionLbl: label 'Invoice Discount Amount';
        VATIdentifierCaptionLbl: label 'Tax Identifier';
        TotalCaptionLbl: label 'Total';
        ShiptoAddressCaptionLbl: label 'Ship-to Address';
        HomePageCaptionLbl: label 'Home Page';
        EMailCaptionLbl: label 'Email';
        DocumentDateCaptionLbl: label 'Document Date';
        AllowInvoiceDiscountCaptionLbl: label 'Allow Invoice Discount';


    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(18) <> '';
    end;


    procedure InitializeRequest(ShowInternalInfoFrom: Boolean;LogInteractionFrom: Boolean)
    begin
        InitLogInteraction;
        ShowInternalInfo := ShowInternalInfoFrom;
        LogInteraction := LogInteractionFrom;
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

          ReferenceText := FormatDocument.SetText("Your Reference" <> '',FieldCaption("Your Reference"));
          VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FieldCaption("VAT Registration No."));
        end;
    end;
}

