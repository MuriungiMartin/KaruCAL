#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5912 "Service - Credit Memo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service - Credit Memo.rdlc';
    Caption = 'Service - Credit Memo';
    Permissions = TableData "Sales Shipment Buffer"=rimd;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Service Cr.Memo Header";"Service Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Customer No.","No. Printed";
            RequestFilterHeading = 'Posted Service Credit Memo';
            column(ReportForNavId_6248; 6248)
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
                    column(CompanyInfoPicture;CompanyInfo.Picture)
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
                    column(SerCreditMemoPercentage;StrSubstNo(Text005,CopyText))
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
                    column(CompanyInfoFaxNo;CompanyInfo."Fax No.")
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
                    column(BilltoCustNo_ServCrMemoHdr;"Service Cr.Memo Header"."Bill-to Customer No.")
                    {
                    }
                    column(PostingDate_ServCrMemoHdr;Format("Service Cr.Memo Header"."Posting Date"))
                    {
                    }
                    column(VATNoText;VATNoText)
                    {
                    }
                    column(VATRegNo_ServCrMemoHdr;"Service Cr.Memo Header"."VAT Registration No.")
                    {
                    }
                    column(No_ServCrMemoHdr;"Service Cr.Memo Header"."No.")
                    {
                    }
                    column(SalesPersonText;SalesPersonText)
                    {
                    }
                    column(Name_SalesPurchPerson;SalesPurchPerson.Name)
                    {
                    }
                    column(AppliedToText;AppliedToText)
                    {
                    }
                    column(ReferenceText;ReferenceText)
                    {
                    }
                    column(YourReference_ServCrMemoHdr;"Service Cr.Memo Header"."Your Reference")
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
                    column(DocDate_ServCrMemoHdr;Format("Service Cr.Memo Header"."Document Date",0,4))
                    {
                    }
                    column(PricesInclVAT_ServCrMemoHdr;"Service Cr.Memo Header"."Prices Including VAT")
                    {
                    }
                    column(PageCaption;StrSubstNo(Text006,''))
                    {
                    }
                    column(OutputNo;OutputNo)
                    {
                    }
                    column(PricesInclVATFormat_ServCrMemoHdr;Format("Service Cr.Memo Header"."Prices Including VAT"))
                    {
                    }
                    column(TaxIdentificationType_Cust;Format(Cust."Tax Identification Type"))
                    {
                    }
                    column(CompanyInfoPhoneNoCaption;CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoFaxNoCaption;CompanyInfoFaxNoCaptionLbl)
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
                    column(ServiceCrMemoHdrNoCaption;ServiceCrMemoHdrNoCaptionLbl)
                    {
                    }
                    column(ServCrMemoHdrPostDtCaption;ServCrMemoHdrPostDtCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption;TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(BilltoCustNo_ServCrMemoHdrCaption;"Service Cr.Memo Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_ServCrMemoHdrCaption;"Service Cr.Memo Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    dataitem(DimensionLoop1;"Integer")
                    {
                        DataItemLinkReference = "Service Cr.Memo Header";
                        DataItemTableView = sorting(Number);
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
                            DimText := DimTxtArr[Number];
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                              CurrReport.Break;
                            FindDimTxt("Service Cr.Memo Header"."Dimension Set ID");
                            SetRange(Number,1,DimTxtArrLength);
                        end;
                    }
                    dataitem("Service Cr.Memo Line";"Service Cr.Memo Line")
                    {
                        DataItemLink = "Document No."=field("No.");
                        DataItemLinkReference = "Service Cr.Memo Header";
                        DataItemTableView = sorting("Document No.","Line No.");
                        column(ReportForNavId_4594; 4594)
                        {
                        }
                        column(TypeInt;TypeInt)
                        {
                        }
                        column(TotalAmount;TotalAmount)
                        {
                        }
                        column(TotalAmountInclVAT;TotalAmountInclVAT)
                        {
                        }
                        column(TotalInvDiscAmount;TotalInvDiscAmount)
                        {
                        }
                        column(LineNo_ServCrMemoLine;"Service Cr.Memo Line"."Line No.")
                        {
                        }
                        column(VATBaseDisc_ServCrMemoHdr;"Service Cr.Memo Header"."VAT Base Discount %")
                        {
                        }
                        column(TotalLineAmount;TotalLineAmount)
                        {
                        }
                        column(LineAmount_ServCrMemoLine;"Line Amount")
                        {
                            AutoFormatExpression = "Service Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Desc_ServCrMemoLine;Description)
                        {
                        }
                        column(No_ServCrMemoLine;"No.")
                        {
                        }
                        column(Quantity_ServCrMemoLine;Quantity)
                        {
                        }
                        column(UnitofMeasure_ServCrMemoLine;"Unit of Measure")
                        {
                        }
                        column(UnitPrice_ServCrMemoLine;"Unit Price")
                        {
                            AutoFormatExpression = "Service Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(LineDisc_ServCrMemoLine;"Line Discount %")
                        {
                        }
                        column(VATIdentifier_ServCrMemoLine;"VAT Identifier")
                        {
                        }
                        column(PostedRcptDate;Format(PostedReceiptDate))
                        {
                        }
                        column(InvDisAmt_ServiceCrMemoLine;-"Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Service Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalText;TotalText)
                        {
                        }
                        column(Amt_ServCrMemoLine;Amount)
                        {
                            AutoFormatExpression = "Service Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText;TotalExclVATText)
                        {
                        }
                        column(TotalInclVATText;TotalInclVATText)
                        {
                        }
                        column(AmtInclVAT_ServCrMemoLine;"Amount Including VAT")
                        {
                            AutoFormatExpression = "Service Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AmtInclVATAmt_ServCrMemoLine;"Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = "Service Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtText_VATAmountLine;VATAmountLine.VATAmountText)
                        {
                        }
                        column(PaymentDisOnVAT;-("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT"))
                        {
                            AutoFormatExpression = "Service Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(ServiceCrMemoLineNoCaption;FieldCaption("No."))
                        {
                        }
                        column(UnitPriceCaption;UnitPriceCaptionLbl)
                        {
                        }
                        column(ServCrMemoLineLineDisCaption;ServCrMemoLineLineDisCaptionLbl)
                        {
                        }
                        column(AmountCaption;AmountCaptionLbl)
                        {
                        }
                        column(PostedReceiptDateCaption;PostedReceiptDateCaptionLbl)
                        {
                        }
                        column(InvDiscountAmountCaption;InvDiscountAmountCaptionLbl)
                        {
                        }
                        column(SubtotalCaption;SubtotalCaptionLbl)
                        {
                        }
                        column(PaymentDisOnVATCaption;PaymentDisOnVATCaptionLbl)
                        {
                        }
                        column(Description_ServCrMemoLineCaption;FieldCaption(Description))
                        {
                        }
                        column(Quantity_ServCrMemoLineCaption;FieldCaption(Quantity))
                        {
                        }
                        column(UnitofMeasure_ServCrMemoLineCaption;FieldCaption("Unit of Measure"))
                        {
                        }
                        column(VATIdent_ServiceCrMemoLineCaption;FieldCaption("VAT Identifier"))
                        {
                        }
                        dataitem("Service Shipment Buffer";"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_9516; 9516)
                            {
                            }
                            column(PostDate_ServShiptBuffer;Format(ServiceShipmentBuffer."Posting Date"))
                            {
                            }
                            column(Quantity_ServShiptBuffer;ServiceShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(ReturnReceiptCaption;ReturnReceiptCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                  ServiceShipmentBuffer.Find('-')
                                else
                                  ServiceShipmentBuffer.Next;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SetRange(Number,1,ServiceShipmentBuffer.Count);
                            end;
                        }
                        dataitem(DimensionLoop2;"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_3591; 3591)
                            {
                            }
                            column(DimText_DimLoop2;DimText)
                            {
                            }
                            column(LineDimensionsCaption;LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                DimText := DimTxtArr[Number];
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                  CurrReport.Break;

                                FindDimTxt("Service Cr.Memo Line"."Dimension Set ID");
                                SetRange(Number,1,DimTxtArrLength);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            ServiceShipmentBuffer.DeleteAll;
                            PostedReceiptDate := 0D;
                            if Quantity <> 0 then
                              PostedReceiptDate := FindPostedShipmentDate;

                            if (Type = Type::"G/L Account") and not ShowInternalInfo then
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
                            VATAmountLine.InsertLine;

                            TotalAmount += Amount;
                            TotalAmountInclVAT += "Amount Including VAT";
                            TotalInvDiscAmount += "Inv. Discount Amount";
                            TotalLineAmount += "Line Amount";
                            TypeInt := Type;
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DeleteAll;
                            ServiceShipmentBuffer.Reset;
                            ServiceShipmentBuffer.DeleteAll;
                            FirstValueEntryNo := 0;
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do
                              MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                              CurrReport.Break;
                            SetRange("Line No.",0,"Line No.");
                            CurrReport.CreateTotals(Amount,"Amount Including VAT","Inv. Discount Amount");

                            TotalAmount := 0;
                            TotalAmountInclVAT := 0;
                            TotalInvDiscAmount := 0;
                            TotalLineAmount := 0;
                        end;
                    }
                    dataitem(VATCounter;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_6558; 6558)
                        {
                        }
                        column(VATBase_VATAmountLine;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Service Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmount_VATAmountLine;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Service Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(LineAmount_VATAmountLine;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Service Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(InvDiscBaseAmt_VATAmtLine;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Service Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(InvoiceDisAmt_VATAmtLine;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Service Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VAT_VATAmtLine;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATIdentifier_VATAmtLine;VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountLineVATCaption;VATAmountLineVATCaptionLbl)
                        {
                        }
                        column(VATAmountLineVATBaseCaption;VATAmountLineVATBaseCaptionLbl)
                        {
                        }
                        column(VATAmtLineVATAmtCaption;VATAmtLineVATAmtCaptionLbl)
                        {
                        }
                        column(VATAmtSpecificationCaption;VATAmtSpecificationCaptionLbl)
                        {
                        }
                        column(VATAmtLineVATIdentifierCaption;VATAmtLineVATIdentifierCaptionLbl)
                        {
                        }
                        column(VATAmtLineInvDiscBaseAmtCaption;VATAmtLineInvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(VATAmountLineLineAmtCaption;VATAmountLineLineAmtCaptionLbl)
                        {
                        }
                        column(VATAmtLineInvDisAmtCaption;VATAmtLineInvDisAmtCaptionLbl)
                        {
                        }
                        column(VATAmtLineVATBase1Caption;VATAmtLineVATBase1CaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            if VATAmountLine.GetTotalVATAmount = 0 then
                              CurrReport.Break;
                            SetRange(Number,1,VATAmountLine.Count);
                            CurrReport.CreateTotals(
                              VATAmountLine."Line Amount",VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount",VATAmountLine."VAT Base",VATAmountLine."VAT Amount");
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
                        column(CustomerNo_ServCrMemoHdr;"Service Cr.Memo Header"."Customer No.")
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
                        column(CustomerNo_ServCrMemoHdrCaption;"Service Cr.Memo Header".FieldCaption("Customer No."))
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
                      CopyText := Text004;
                      OutputNo += 1;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                      Codeunit.Run(Codeunit::"Service Cr. Memo-Printed","Service Cr.Memo Header");
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

                FormatAddressFields("Service Cr.Memo Header");
                FormatDocumentFields("Service Cr.Memo Header");

                if not Cust.Get("Bill-to Customer No.") then
                  Clear(Cust);
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

    trigger OnInitReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        ServiceSetup.Get;

        case ServiceSetup."Logo Position on Documents" of
          ServiceSetup."logo position on documents"::"No Logo":
            ;
          ServiceSetup."logo position on documents"::Left:
            begin
              CompanyInfo3.Get;
              CompanyInfo3.CalcFields(Picture);
            end;
          ServiceSetup."logo position on documents"::Center:
            begin
              CompanyInfo1.Get;
              CompanyInfo1.CalcFields(Picture);
            end;
          ServiceSetup."logo position on documents"::Right:
            begin
              CompanyInfo2.Get;
              CompanyInfo2.CalcFields(Picture);
            end;
        end;
    end;

    var
        Text003: label '(Applies to %1 %2)';
        Text004: label 'COPY';
        Text005: label 'Service - Credit Memo %1';
        Text006: label 'Page %1';
        GLSetup: Record "General Ledger Setup";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        ServiceSetup: Record "Service Mgt. Setup";
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry: Record "Dimension Set Entry";
        Language: Record Language;
        ServiceShipmentBuffer: Record "Service Shipment Buffer" temporary;
        RespCenter: Record "Responsibility Center";
        Cust: Record Customer;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        CustAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
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
        OutputNo: Integer;
        TypeInt: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        DimText: Text[120];
        ShowInternalInfo: Boolean;
        FirstValueEntryNo: Integer;
        PostedReceiptDate: Date;
        NextEntryNo: Integer;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalLineAmount: Decimal;
        DimTxtArrLength: Integer;
        DimTxtArr: array [500] of Text[50];
        CompanyInfoPhoneNoCaptionLbl: label 'Phone No.';
        CompanyInfoFaxNoCaptionLbl: label 'Fax No.';
        CompanyInfoVATRegNoCaptionLbl: label 'Tax Reg. No.';
        CompanyInfoGiroNoCaptionLbl: label 'Giro No.';
        CompanyInfoBankNameCaptionLbl: label 'Bank';
        CompanyInfoBankAccNoCaptionLbl: label 'Account No.';
        ServiceCrMemoHdrNoCaptionLbl: label 'Credit Memo No.';
        ServCrMemoHdrPostDtCaptionLbl: label 'Posting Date';
        TaxIdentTypeCaptionLbl: label 'Tax Ident. Type';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions';
        UnitPriceCaptionLbl: label 'Unit Price';
        ServCrMemoLineLineDisCaptionLbl: label 'Disc. %';
        AmountCaptionLbl: label 'Amount';
        PostedReceiptDateCaptionLbl: label 'Posted Return Receipt Date';
        InvDiscountAmountCaptionLbl: label 'Inv. Discount Amount';
        SubtotalCaptionLbl: label 'Subtotal';
        PaymentDisOnVATCaptionLbl: label 'Payment Discount on VAT';
        ReturnReceiptCaptionLbl: label 'Return Receipt';
        LineDimensionsCaptionLbl: label 'Line Dimensions';
        VATAmountLineVATCaptionLbl: label 'Tax %';
        VATAmountLineVATBaseCaptionLbl: label 'Tax Base';
        VATAmtLineVATAmtCaptionLbl: label 'Tax Amount';
        VATAmtSpecificationCaptionLbl: label 'Tax Amount Specification';
        VATAmtLineVATIdentifierCaptionLbl: label 'Tax Identifier';
        VATAmtLineInvDiscBaseAmtCaptionLbl: label 'Inv. Disc. Base Amount';
        VATAmountLineLineAmtCaptionLbl: label 'Line Amount';
        VATAmtLineInvDisAmtCaptionLbl: label 'Invoice Discount Amount';
        VATAmtLineVATBase1CaptionLbl: label 'Total';
        ShiptoAddressCaptionLbl: label 'Ship-to Address';


    procedure FindPostedShipmentDate(): Date
    var
        ServiceShipmentBuffer2: Record "Service Shipment Buffer" temporary;
    begin
        NextEntryNo := 1;

        case "Service Cr.Memo Line".Type of
          "Service Cr.Memo Line".Type::Item:
            GenerateBufferFromValueEntry("Service Cr.Memo Line");
          "Service Cr.Memo Line".Type::" ":
            exit(0D);
        end;

        ServiceShipmentBuffer.Reset;
        ServiceShipmentBuffer.SetRange("Document No.","Service Cr.Memo Line"."Document No.");
        ServiceShipmentBuffer.SetRange("Line No." ,"Service Cr.Memo Line"."Line No.");

        if ServiceShipmentBuffer.Find('-') then begin
          ServiceShipmentBuffer2 := ServiceShipmentBuffer;
          if ServiceShipmentBuffer.Next = 0 then begin
            ServiceShipmentBuffer.Get(ServiceShipmentBuffer2."Document No.",ServiceShipmentBuffer2."Line No.",ServiceShipmentBuffer2.
              "Entry No.");
            ServiceShipmentBuffer.Delete;
            exit(ServiceShipmentBuffer2."Posting Date");
          end;
          ServiceShipmentBuffer.CalcSums(Quantity);
          if ServiceShipmentBuffer.Quantity <> "Service Cr.Memo Line".Quantity then begin
            ServiceShipmentBuffer.DeleteAll;
            exit("Service Cr.Memo Header"."Posting Date");
          end;
        end else
          exit("Service Cr.Memo Header"."Posting Date");
    end;


    procedure GenerateBufferFromValueEntry(ServiceCrMemoLine2: Record "Service Cr.Memo Line")
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := ServiceCrMemoLine2."Quantity (Base)";
        ValueEntry.SetCurrentkey("Document No.");
        ValueEntry.SetRange("Document No.",ServiceCrMemoLine2."Document No.");
        ValueEntry.SetRange("Posting Date","Service Cr.Memo Header"."Posting Date");
        ValueEntry.SetRange("Item Charge No.",'');
        ValueEntry.SetFilter("Entry No.",'%1..',FirstValueEntryNo);
        if ValueEntry.Find('-') then
          repeat
            if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
              if ServiceCrMemoLine2."Qty. per Unit of Measure" <> 0 then
                Quantity := ValueEntry."Invoiced Quantity" / ServiceCrMemoLine2."Qty. per Unit of Measure"
              else
                Quantity := ValueEntry."Invoiced Quantity";
              AddBufferEntry(
                ServiceCrMemoLine2,
                -Quantity,
                ItemLedgerEntry."Posting Date");
              TotalQuantity := TotalQuantity - ValueEntry."Invoiced Quantity";
            end;
            FirstValueEntryNo := ValueEntry."Entry No." + 1;
          until (ValueEntry.Next = 0) or (TotalQuantity = 0);
    end;


    procedure AddBufferEntry(ServiceCrMemoLine: Record "Service Cr.Memo Line";QtyOnShipment: Decimal;PostingDate: Date)
    begin
        ServiceShipmentBuffer.SetRange("Document No.",ServiceCrMemoLine."Document No.");
        ServiceShipmentBuffer.SetRange("Line No.",ServiceCrMemoLine."Line No.");
        ServiceShipmentBuffer.SetRange("Posting Date",PostingDate);
        if ServiceShipmentBuffer.Find('-') then begin
          ServiceShipmentBuffer.Quantity := ServiceShipmentBuffer.Quantity - QtyOnShipment;
          ServiceShipmentBuffer.Modify;
          exit;
        end;

        with ServiceShipmentBuffer do begin
          Init;
          "Document No." := ServiceCrMemoLine."Document No.";
          "Line No." := ServiceCrMemoLine."Line No.";
          "Entry No." := NextEntryNo;
          Type := ServiceCrMemoLine.Type;
          "No." := ServiceCrMemoLine."No.";
          Quantity := -QtyOnShipment;
          "Posting Date" := PostingDate;
          Insert;
          NextEntryNo := NextEntryNo + 1
        end;
    end;


    procedure FindDimTxt(DimSetID: Integer)
    var
        Separation: Text[5];
        i: Integer;
        TxtToAdd: Text[120];
        StartNewLine: Boolean;
    begin
        DimSetEntry.SetRange("Dimension Set ID",DimSetID);
        DimTxtArrLength := 0;
        for i := 1 to ArrayLen(DimTxtArr) do
          DimTxtArr[i] := '';
        if not DimSetEntry.Find('-') then
          exit;
        Separation := '; ';
        repeat
          TxtToAdd := DimSetEntry."Dimension Code" + ' - ' + DimSetEntry."Dimension Value Code";
          if DimTxtArrLength = 0 then
            StartNewLine := true
          else
            StartNewLine := StrLen(DimTxtArr[DimTxtArrLength]) + StrLen(Separation) + StrLen(TxtToAdd) > MaxStrLen(DimTxtArr[1]);
          if StartNewLine then begin
            DimTxtArrLength += 1;
            DimTxtArr[DimTxtArrLength] := TxtToAdd
          end else
            DimTxtArr[DimTxtArrLength] := DimTxtArr[DimTxtArrLength] + Separation + TxtToAdd;
        until DimSetEntry.Next = 0;
    end;


    procedure InitializeRequest(NewShowInternalInfo: Boolean)
    begin
        ShowInternalInfo := NewShowInternalInfo;
    end;

    local procedure FormatAddressFields(var ServiceCrMemoHeader: Record "Service Cr.Memo Header")
    begin
        FormatAddr.GetCompanyAddr(ServiceCrMemoHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
        FormatAddr.ServiceCrMemoBillTo(CustAddr,ServiceCrMemoHeader);
        ShowShippingAddr := FormatAddr.ServiceCrMemoShipTo(ShipToAddr,CustAddr,ServiceCrMemoHeader);
    end;

    local procedure FormatDocumentFields(ServiceCrMemoHeader: Record "Service Cr.Memo Header")
    begin
        with ServiceCrMemoHeader do begin
          FormatDocument.SetTotalLabels("Currency Code",TotalText,TotalInclVATText,TotalExclVATText);
          FormatDocument.SetSalesPerson(SalesPurchPerson,"Salesperson Code",SalesPersonText);

          ReferenceText := FormatDocument.SetText("Your Reference" <> '',FieldCaption("Your Reference"));
          VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FieldCaption("VAT Registration No."));
          AppliedToText :=
            FormatDocument.SetText(
              "Applies-to Doc. No." <> '',Format(StrSubstNo(Text003,Format("Applies-to Doc. Type"),"Applies-to Doc. No.")));
        end;
    end;
}

