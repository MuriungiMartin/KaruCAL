#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 402 "Purchase Document - Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase Document - Test.rdlc';
    Caption = 'Purchase Document - Test';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Purchase Header";"Purchase Header")
        {
            DataItemTableView = where("Document Type"=filter(<>Quote));
            RequestFilterFields = "Document Type","No.";
            RequestFilterHeading = 'Purchase Document';
            column(ReportForNavId_4458; 4458)
            {
            }
            column(USERID;UserId)
            {
            }
            column(COMPANYNAME;CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(TIME;Time)
            {
            }
            column(STRSUBSTNO_Text018_PurchHeaderFilter_;StrSubstNo(Text018,PurchHeaderFilter))
            {
            }
            column(Summarize;Summarize)
            {
            }
            column(SalesTax;SalesTax)
            {
            }
            column(Purchase_Header_No_;"No.")
            {
            }
            column(Purchase_Header__Vendor_Invoice_No__;"Vendor Invoice No.")
            {
            }
            column(InvoiceAmount;InvoiceAmount)
            {
            }
            column(Purchase_Header__Currency_Code_;"Currency Code")
            {
            }
            column(Buy_from_Vendor_No______________Buy_from_Vendor_Name_;"Buy-from Vendor No." + ' - ' + "Buy-from Vendor Name")
            {
            }
            column(Purchase_Header__Buy_from_Address_;"Buy-from Address")
            {
            }
            column(Buy_from_City____________Buy_from_County___________Buy_from_Post_Code_;"Buy-from City" + ', ' + "Buy-from County" + ' ' + "Buy-from Post Code")
            {
            }
            column(Purchaser_Code____________Purchaser_Name;"Purchaser Code" + ' - ' + Purchaser.Name)
            {
            }
            column(Purchase_Header__Buy_from_Contact_;"Buy-from Contact")
            {
            }
            column(Purchase_Header__Posting_Description_;"Posting Description")
            {
            }
            column(Purchase_Header__Document_Date_;"Document Date")
            {
            }
            column(Purchase_Header__Posting_Date_;"Posting Date")
            {
            }
            column(Purchase_Header__Due_Date_;"Due Date")
            {
            }
            column(Purchase_Header__Shipment_Method_Code_;"Shipment Method Code")
            {
            }
            column(Purchase_Header__Payment_Terms_Code_;"Payment Terms Code")
            {
            }
            column(Purchase_Header_Status;Status)
            {
            }
            column(Purchase_Header_Document_Type;"Document Type")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Purchase_Document___TestCaption;Purchase_Document___TestCaptionLbl)
            {
            }
            column(Document_No_Caption;Document_No_CaptionLbl)
            {
            }
            column(Vendor_Invoice_No_Caption;Vendor_Invoice_No_CaptionLbl)
            {
            }
            column(Invoice_Amount_Excl__TaxCaption;Invoice_Amount_Excl__TaxCaptionLbl)
            {
            }
            column(Vendor_InformationCaption;Vendor_InformationCaptionLbl)
            {
            }
            column(PurchaserCaption;PurchaserCaptionLbl)
            {
            }
            column(ContactCaption;ContactCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(Due_DateCaption;Due_DateCaptionLbl)
            {
            }
            column(Posting_DateCaption;Posting_DateCaptionLbl)
            {
            }
            column(Doc__DateCaption;Doc__DateCaptionLbl)
            {
            }
            column(ShipmentCaption;ShipmentCaptionLbl)
            {
            }
            column(TermsCaption;TermsCaptionLbl)
            {
            }
            column(StatusCaption;StatusCaptionLbl)
            {
            }
            dataitem(PageCounter;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_8098; 8098)
                {
                }
                column(FORMAT_TODAY_0_4__Control1029001;Format(Today,0,4))
                {
                }
                column(TIME_Control1029002;Time)
                {
                }
                column(CompanyInformation_Name_Control1029003;CompanyInformation.Name)
                {
                }
                column(CurrReport_PAGENO_Control1029005;CurrReport.PageNo)
                {
                }
                column(USERID_Control1029006;UserId)
                {
                }
                column(STRSUBSTNO_Text018_PurchHeaderFilter__Control7;StrSubstNo(Text018,PurchHeaderFilter))
                {
                }
                column(PurchHeaderFilter;PurchHeaderFilter)
                {
                }
                column(ReceiveInvoiceText;ReceiveInvoiceText)
                {
                }
                column(ShipInvoiceText;ShipInvoiceText)
                {
                }
                column(Purchase_Header___Sell_to_Customer_No__;"Purchase Header"."Sell-to Customer No.")
                {
                }
                column(ShipToAddr_1_;ShipToAddr[1])
                {
                }
                column(ShipToAddr_2_;ShipToAddr[2])
                {
                }
                column(ShipToAddr_3_;ShipToAddr[3])
                {
                }
                column(ShipToAddr_4_;ShipToAddr[4])
                {
                }
                column(ShipToAddr_5_;ShipToAddr[5])
                {
                }
                column(ShipToAddr_6_;ShipToAddr[6])
                {
                }
                column(ShipToAddr_7_;ShipToAddr[7])
                {
                }
                column(ShipToAddr_8_;ShipToAddr[8])
                {
                }
                column(FORMAT__Purchase_Header___Document_Type____________Purchase_Header___No__;Format("Purchase Header"."Document Type") + ' ' + "Purchase Header"."No.")
                {
                }
                column(BuyFromAddr_8_;BuyFromAddr[8])
                {
                }
                column(BuyFromAddr_7_;BuyFromAddr[7])
                {
                }
                column(BuyFromAddr_6_;BuyFromAddr[6])
                {
                }
                column(BuyFromAddr_5_;BuyFromAddr[5])
                {
                }
                column(BuyFromAddr_4_;BuyFromAddr[4])
                {
                }
                column(BuyFromAddr_3_;BuyFromAddr[3])
                {
                }
                column(BuyFromAddr_2_;BuyFromAddr[2])
                {
                }
                column(BuyFromAddr_1_;BuyFromAddr[1])
                {
                }
                column(Purchase_Header___Buy_from_Vendor_No__;"Purchase Header"."Buy-from Vendor No.")
                {
                }
                column(Purchase_Header___Document_Type_;Format("Purchase Header"."Document Type",0,2))
                {
                }
                column(Purchase_Header___VAT_Base_Discount___;"Purchase Header"."VAT Base Discount %")
                {
                }
                column(PricesInclVATtxt;PricesInclVATtxt)
                {
                }
                column(ShowItemChargeAssgnt;ShowItemChargeAssgnt)
                {
                }
                column(PurchHeaderDocTypeNo;PurchHeaderDocTypeNo)
                {
                }
                column(PayToAddr_1_;PayToAddr[1])
                {
                }
                column(PayToAddr_2_;PayToAddr[2])
                {
                }
                column(PayToAddr_3_;PayToAddr[3])
                {
                }
                column(PayToAddr_4_;PayToAddr[4])
                {
                }
                column(PayToAddr_5_;PayToAddr[5])
                {
                }
                column(PayToAddr_6_;PayToAddr[6])
                {
                }
                column(PayToAddr_7_;PayToAddr[7])
                {
                }
                column(PayToAddr_8_;PayToAddr[8])
                {
                }
                column(Purchase_Header___Pay_to_Vendor_No__;"Purchase Header"."Pay-to Vendor No.")
                {
                }
                column(Purchase_Header___Purchaser_Code_;"Purchase Header"."Purchaser Code")
                {
                }
                column(Purchase_Header___Your_Reference_;"Purchase Header"."Your Reference")
                {
                }
                column(Purchase_Header___Vendor_Posting_Group_;"Purchase Header"."Vendor Posting Group")
                {
                }
                column(Purchase_Header___Posting_Date_;Format("Purchase Header"."Posting Date"))
                {
                }
                column(Purchase_Header___Document_Date_;Format("Purchase Header"."Document Date"))
                {
                }
                column(Purchase_Header___Prices_Including_VAT_;"Purchase Header"."Prices Including VAT")
                {
                }
                column(Purchase_Header___Payment_Terms_Code_;"Purchase Header"."Payment Terms Code")
                {
                }
                column(Purchase_Header___Payment_Discount___;"Purchase Header"."Payment Discount %")
                {
                }
                column(Purchase_Header___Due_Date_;Format("Purchase Header"."Due Date"))
                {
                }
                column(Purchase_Header___Pmt__Discount_Date_;Format("Purchase Header"."Pmt. Discount Date"))
                {
                }
                column(Purchase_Header___Shipment_Method_Code_;"Purchase Header"."Shipment Method Code")
                {
                }
                column(Purchase_Header___Payment_Method_Code_;"Purchase Header"."Payment Method Code")
                {
                }
                column(Purchase_Header___Vendor_Order_No__;"Purchase Header"."Vendor Order No.")
                {
                }
                column(Purchase_Header___Vendor_Shipment_No__;"Purchase Header"."Vendor Shipment No.")
                {
                }
                column(Purchase_Header___Vendor_Invoice_No__;"Purchase Header"."Vendor Invoice No.")
                {
                }
                column(Purchase_Header___Vendor_Posting_Group__Control104;"Purchase Header"."Vendor Posting Group")
                {
                }
                column(Purchase_Header___Posting_Date__Control106;Format("Purchase Header"."Posting Date"))
                {
                }
                column(Purchase_Header___Document_Date__Control107;Format("Purchase Header"."Document Date"))
                {
                }
                column(Purchase_Header___Order_Date_;Format("Purchase Header"."Order Date"))
                {
                }
                column(Purchase_Header___Expected_Receipt_Date_;Format("Purchase Header"."Expected Receipt Date"))
                {
                }
                column(Purchase_Header___Prices_Including_VAT__Control212;"Purchase Header"."Prices Including VAT")
                {
                }
                column(Purchase_Header___Payment_Discount____Control14;"Purchase Header"."Payment Discount %")
                {
                }
                column(Purchase_Header___Payment_Terms_Code__Control18;"Purchase Header"."Payment Terms Code")
                {
                }
                column(Purchase_Header___Due_Date__Control19;Format("Purchase Header"."Due Date"))
                {
                }
                column(Purchase_Header___Pmt__Discount_Date__Control22;Format("Purchase Header"."Pmt. Discount Date"))
                {
                }
                column(Purchase_Header___Payment_Method_Code__Control30;"Purchase Header"."Payment Method Code")
                {
                }
                column(Purchase_Header___Shipment_Method_Code__Control33;"Purchase Header"."Shipment Method Code")
                {
                }
                column(Purchase_Header___Vendor_Shipment_No___Control34;"Purchase Header"."Vendor Shipment No.")
                {
                }
                column(Purchase_Header___Vendor_Invoice_No___Control35;"Purchase Header"."Vendor Invoice No.")
                {
                }
                column(Purchase_Header___Vendor_Posting_Group__Control110;"Purchase Header"."Vendor Posting Group")
                {
                }
                column(Purchase_Header___Posting_Date__Control112;Format("Purchase Header"."Posting Date"))
                {
                }
                column(Purchase_Header___Document_Date__Control113;Format("Purchase Header"."Document Date"))
                {
                }
                column(Purchase_Header___Prices_Including_VAT__Control214;"Purchase Header"."Prices Including VAT")
                {
                }
                column(Purchase_Header___Vendor_Cr__Memo_No__;"Purchase Header"."Vendor Cr. Memo No.")
                {
                }
                column(Purchase_Header___Applies_to_Doc__Type_;"Purchase Header"."Applies-to Doc. Type")
                {
                }
                column(Purchase_Header___Applies_to_Doc__No__;"Purchase Header"."Applies-to Doc. No.")
                {
                }
                column(Purchase_Header___Vendor_Posting_Group__Control128;"Purchase Header"."Vendor Posting Group")
                {
                }
                column(Purchase_Header___Posting_Date__Control130;Format("Purchase Header"."Posting Date"))
                {
                }
                column(Purchase_Header___Document_Date__Control131;Format("Purchase Header"."Document Date"))
                {
                }
                column(Purchase_Header___Prices_Including_VAT__Control216;"Purchase Header"."Prices Including VAT")
                {
                }
                column(PageCounter_Number;Number)
                {
                }
                column(Purchase_Document___TestCaption_Control1;Purchase_Document___TestCaption_Control1Lbl)
                {
                }
                column(CurrReport_PAGENO_Control1029005Caption;CurrReport_PAGENO_Control1029005CaptionLbl)
                {
                }
                column(Purchase_Header___Sell_to_Customer_No__Caption;"Purchase Header".FieldCaption("Sell-to Customer No."))
                {
                }
                column(Ship_toCaption;Ship_toCaptionLbl)
                {
                }
                column(Buy_fromCaption;Buy_fromCaptionLbl)
                {
                }
                column(Purchase_Header___Buy_from_Vendor_No__Caption;"Purchase Header".FieldCaption("Buy-from Vendor No."))
                {
                }
                column(Pay_toCaption;Pay_toCaptionLbl)
                {
                }
                column(Purchase_Header___Pay_to_Vendor_No__Caption;"Purchase Header".FieldCaption("Pay-to Vendor No."))
                {
                }
                column(Purchase_Header___Purchaser_Code_Caption;"Purchase Header".FieldCaption("Purchaser Code"))
                {
                }
                column(Purchase_Header___Your_Reference_Caption;"Purchase Header".FieldCaption("Your Reference"))
                {
                }
                column(Purchase_Header___Vendor_Posting_Group_Caption;"Purchase Header".FieldCaption("Vendor Posting Group"))
                {
                }
                column(Purchase_Header___Posting_Date_Caption;Purchase_Header___Posting_Date_CaptionLbl)
                {
                }
                column(Purchase_Header___Document_Date_Caption;Purchase_Header___Document_Date_CaptionLbl)
                {
                }
                column(Purchase_Header___Prices_Including_VAT_Caption;"Purchase Header".FieldCaption("Prices Including VAT"))
                {
                }
                column(Purchase_Header___Payment_Terms_Code_Caption;"Purchase Header".FieldCaption("Payment Terms Code"))
                {
                }
                column(Purchase_Header___Payment_Discount___Caption;"Purchase Header".FieldCaption("Payment Discount %"))
                {
                }
                column(Purchase_Header___Due_Date_Caption;Purchase_Header___Due_Date_CaptionLbl)
                {
                }
                column(Purchase_Header___Pmt__Discount_Date_Caption;Purchase_Header___Pmt__Discount_Date_CaptionLbl)
                {
                }
                column(Purchase_Header___Shipment_Method_Code_Caption;"Purchase Header".FieldCaption("Shipment Method Code"))
                {
                }
                column(Purchase_Header___Payment_Method_Code_Caption;"Purchase Header".FieldCaption("Payment Method Code"))
                {
                }
                column(Purchase_Header___Vendor_Order_No__Caption;"Purchase Header".FieldCaption("Vendor Order No."))
                {
                }
                column(Purchase_Header___Vendor_Shipment_No__Caption;"Purchase Header".FieldCaption("Vendor Shipment No."))
                {
                }
                column(Purchase_Header___Vendor_Invoice_No__Caption;"Purchase Header".FieldCaption("Vendor Invoice No."))
                {
                }
                column(Purchase_Header___Vendor_Posting_Group__Control104Caption;"Purchase Header".FieldCaption("Vendor Posting Group"))
                {
                }
                column(Purchase_Header___Posting_Date__Control106Caption;Purchase_Header___Posting_Date__Control106CaptionLbl)
                {
                }
                column(Purchase_Header___Document_Date__Control107Caption;Purchase_Header___Document_Date__Control107CaptionLbl)
                {
                }
                column(Purchase_Header___Order_Date_Caption;Purchase_Header___Order_Date_CaptionLbl)
                {
                }
                column(Purchase_Header___Expected_Receipt_Date_Caption;Purchase_Header___Expected_Receipt_Date_CaptionLbl)
                {
                }
                column(Purchase_Header___Prices_Including_VAT__Control212Caption;"Purchase Header".FieldCaption("Prices Including VAT"))
                {
                }
                column(Purchase_Header___Payment_Discount____Control14Caption;"Purchase Header".FieldCaption("Payment Discount %"))
                {
                }
                column(Purchase_Header___Payment_Terms_Code__Control18Caption;"Purchase Header".FieldCaption("Payment Terms Code"))
                {
                }
                column(Purchase_Header___Due_Date__Control19Caption;Purchase_Header___Due_Date__Control19CaptionLbl)
                {
                }
                column(Purchase_Header___Pmt__Discount_Date__Control22Caption;Purchase_Header___Pmt__Discount_Date__Control22CaptionLbl)
                {
                }
                column(Purchase_Header___Payment_Method_Code__Control30Caption;"Purchase Header".FieldCaption("Payment Method Code"))
                {
                }
                column(Purchase_Header___Shipment_Method_Code__Control33Caption;"Purchase Header".FieldCaption("Shipment Method Code"))
                {
                }
                column(Purchase_Header___Vendor_Shipment_No___Control34Caption;"Purchase Header".FieldCaption("Vendor Shipment No."))
                {
                }
                column(Purchase_Header___Vendor_Invoice_No___Control35Caption;"Purchase Header".FieldCaption("Vendor Invoice No."))
                {
                }
                column(Purchase_Header___Vendor_Posting_Group__Control110Caption;"Purchase Header".FieldCaption("Vendor Posting Group"))
                {
                }
                column(Purchase_Header___Posting_Date__Control112Caption;Purchase_Header___Posting_Date__Control112CaptionLbl)
                {
                }
                column(Purchase_Header___Document_Date__Control113Caption;Purchase_Header___Document_Date__Control113CaptionLbl)
                {
                }
                column(Purchase_Header___Prices_Including_VAT__Control214Caption;"Purchase Header".FieldCaption("Prices Including VAT"))
                {
                }
                column(Purchase_Header___Vendor_Cr__Memo_No__Caption;"Purchase Header".FieldCaption("Vendor Cr. Memo No."))
                {
                }
                column(Purchase_Header___Applies_to_Doc__Type_Caption;"Purchase Header".FieldCaption("Applies-to Doc. Type"))
                {
                }
                column(Purchase_Header___Applies_to_Doc__No__Caption;"Purchase Header".FieldCaption("Applies-to Doc. No."))
                {
                }
                column(Purchase_Header___Vendor_Posting_Group__Control128Caption;"Purchase Header".FieldCaption("Vendor Posting Group"))
                {
                }
                column(Purchase_Header___Posting_Date__Control130Caption;Purchase_Header___Posting_Date__Control130CaptionLbl)
                {
                }
                column(Purchase_Header___Document_Date__Control131Caption;Purchase_Header___Document_Date__Control131CaptionLbl)
                {
                }
                column(Purchase_Header___Prices_Including_VAT__Control216Caption;"Purchase Header".FieldCaption("Prices Including VAT"))
                {
                }
                dataitem(DimensionLoop1;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=filter(1..));
                    column(ReportForNavId_7574; 7574)
                    {
                    }
                    column(DimText;DimText)
                    {
                    }
                    column(DimensionLoop1_Number;Number)
                    {
                    }
                    column(DimText_Control163;DimText)
                    {
                    }
                    column(Header_DimensionsCaption;Header_DimensionsCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then begin
                          if not DimSetEntry1.FindFirst then
                            CurrReport.Break;
                        end else
                          if not Continue then
                            CurrReport.Break;
                        DimText := '';
                        Continue := false;
                        repeat
                          OldDimText := DimText;
                          if DimText = '' then
                            DimText := StrSubstNo('%1 - %2',DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code")
                          else
                            DimText :=
                              StrSubstNo(
                                '%1; %2 - %3',DimText,DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code");
                          if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                            DimText := OldDimText;
                            Continue := true;
                            exit;
                          end;
                        until (DimSetEntry1.Next = 0);
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not ShowDim then
                          CurrReport.Break;
                    end;
                }
                dataitem(HeaderErrorCounter;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_3850; 3850)
                    {
                    }
                    column(ErrorText_Number_;ErrorText[Number])
                    {
                    }
                    column(HeaderErrorCounter_Number;Number)
                    {
                    }
                    column(ErrorText_Number_Caption;ErrorText_Number_CaptionLbl)
                    {
                    }

                    trigger OnPostDataItem()
                    begin
                        ErrorCounter := 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number,1,ErrorCounter);
                    end;
                }
                dataitem(CopyLoop;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    MaxIteration = 1;
                    column(ReportForNavId_5701; 5701)
                    {
                    }
                    dataitem("Purchase Line";"Purchase Line")
                    {
                        DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = sorting("Document Type","Document No.","Line No.");
                        column(ReportForNavId_6547; 6547)
                        {
                        }
                        column(Purchase_Line_Document_Type;"Document Type")
                        {
                        }
                        column(Purchase_Line_Document_No_;"Document No.")
                        {
                        }
                        column(Purchase_Line_Line_No_;"Line No.")
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if Find('+') then
                              OrigMaxLineNo := "Line No.";
                            CurrReport.Break;
                        end;
                    }
                    dataitem(RoundLoop;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_7551; 7551)
                        {
                        }
                        column(QtyToHandleCaption;QtyToHandleCaption)
                        {
                        }
                        column(Purchase_Line__Type;"Purchase Line".Type)
                        {
                        }
                        column(Purchase_Line___Line_Amount_;"Purchase Line"."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Purchase_Line___VAT_Identifier_;"Purchase Line"."VAT Identifier")
                        {
                        }
                        column(Purchase_Line___Allow_Invoice_Disc__;"Purchase Line"."Allow Invoice Disc.")
                        {
                        }
                        column(Purchase_Line___Line_Discount___;"Purchase Line"."Line Discount %")
                        {
                        }
                        column(Purchase_Line___Direct_Unit_Cost_;"Purchase Line"."Direct Unit Cost")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(Purchase_Line___Qty__to_Invoice_;"Purchase Line"."Qty. to Invoice")
                        {
                        }
                        column(QtyToHandle;QtyToHandle)
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(Purchase_Line__Quantity;"Purchase Line".Quantity)
                        {
                        }
                        column(Purchase_Line__Description;"Purchase Line".Description)
                        {
                        }
                        column(Purchase_Line___No__;"Purchase Line"."No.")
                        {
                        }
                        column(Purchase_Line___Line_No__;"Purchase Line"."Line No.")
                        {
                        }
                        column(Purchase_Line___Inv__Discount_Amount_;"Purchase Line"."Inv. Discount Amount")
                        {
                        }
                        column(AllowInvDisctxt;AllowInvDisctxt)
                        {
                        }
                        column(TempPurchLine__Inv__Discount_Amount_;-TempPurchLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TempPurchLine__Line_Amount_;TempPurchLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText;TotalText)
                        {
                        }
                        column(TempPurchLine__Line_Amount____TempPurchLine__Inv__Discount_Amount_;TempPurchLine."Line Amount" - TempPurchLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText;TotalInclVATText)
                        {
                        }
                        column(TotalExclVATText;TotalExclVATText)
                        {
                        }
                        column(TempPurchLine__Line_Amount____TempPurchLine__Inv__Discount_Amount____VATAmount;TempPurchLine."Line Amount" - TempPurchLine."Inv. Discount Amount" + VATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmount;VATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TempPurchLine__Line_Amount____TempPurchLine__Inv__Discount_Amount__Control224;TempPurchLine."Line Amount" - TempPurchLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SumInvDiscountAmount;SumInvDiscountAmount)
                        {
                        }
                        column(SumLineAmount;SumLineAmount)
                        {
                        }
                        column(VATDiscountAmount;-VATDiscountAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText_Control155;TotalInclVATText)
                        {
                        }
                        column(VATAmountLine_VATAmountText;VATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalExclVATText_Control153;TotalExclVATText)
                        {
                        }
                        column(VATBaseAmount;VATBaseAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseAmount___VATAmount;VATBaseAmount + VATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmount_Control150;VATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(RoundLoop_Number;Number)
                        {
                        }
                        column(AmountCaption;AmountCaptionLbl)
                        {
                        }
                        column(Purchase_Line___VAT_Identifier_Caption;"Purchase Line".FieldCaption("VAT Identifier"))
                        {
                        }
                        column(Purchase_Line___Allow_Invoice_Disc__Caption;"Purchase Line".FieldCaption("Allow Invoice Disc."))
                        {
                        }
                        column(Purchase_Line___Line_Discount___Caption;Purchase_Line___Line_Discount___CaptionLbl)
                        {
                        }
                        column(Direct_Unit_CostCaption;Direct_Unit_CostCaptionLbl)
                        {
                        }
                        column(Purchase_Line___Qty__to_Invoice_Caption;"Purchase Line".FieldCaption("Qty. to Invoice"))
                        {
                        }
                        column(Purchase_Line__QuantityCaption;"Purchase Line".FieldCaption(Quantity))
                        {
                        }
                        column(Purchase_Line__DescriptionCaption;"Purchase Line".FieldCaption(Description))
                        {
                        }
                        column(Purchase_Line___No__Caption;"Purchase Line".FieldCaption("No."))
                        {
                        }
                        column(Purchase_Line__TypeCaption;"Purchase Line".FieldCaption(Type))
                        {
                        }
                        column(TempPurchLine__Inv__Discount_Amount_Caption;TempPurchLine__Inv__Discount_Amount_CaptionLbl)
                        {
                        }
                        column(SubtotalCaption;SubtotalCaptionLbl)
                        {
                        }
                        column(VATDiscountAmountCaption;VATDiscountAmountCaptionLbl)
                        {
                        }
                        dataitem(DimensionLoop2;"Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number=filter(1..));
                            column(ReportForNavId_3591; 3591)
                            {
                            }
                            column(DimText_Control165;DimText)
                            {
                            }
                            column(DimensionLoop2_Number;Number)
                            {
                            }
                            column(DimText_Control167;DimText)
                            {
                            }
                            column(Line_DimensionsCaption;Line_DimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                  if not DimSetEntry2.FindFirst then
                                    CurrReport.Break;
                                end else
                                  if not Continue then
                                    CurrReport.Break;
                                DimText := '';
                                Continue := false;
                                repeat
                                  OldDimText := DimText;
                                  if DimText = '' then
                                    DimText := StrSubstNo('%1 - %2',DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code")
                                  else
                                    DimText :=
                                      StrSubstNo(
                                        '%1; %2 - %3',DimText,DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code");
                                  if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                  end;
                                until (DimSetEntry2.Next = 0);
                            end;

                            trigger OnPostDataItem()
                            begin
                                SumLineAmount := SumLineAmount + TempPurchLine."Line Amount";
                                SumInvDiscountAmount := SumInvDiscountAmount + TempPurchLine."Inv. Discount Amount";
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowDim then
                                  CurrReport.Break;
                            end;
                        }
                        dataitem(LineErrorCounter;"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_2217; 2217)
                            {
                            }
                            column(ErrorText_Number__Control103;ErrorText[Number])
                            {
                            }
                            column(LineErrorCounter_Number;Number)
                            {
                            }
                            column(ErrorText_Number__Control103Caption;ErrorText_Number__Control103CaptionLbl)
                            {
                            }

                            trigger OnPostDataItem()
                            begin
                                ErrorCounter := 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SetRange(Number,1,ErrorCounter);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            TableID: array [10] of Integer;
                            No: array [10] of Code[20];
                            Fraction: Decimal;
                        begin
                            if Number = 1 then
                              TempPurchLine.Find('-')
                            else
                              TempPurchLine.Next;
                            "Purchase Line" := TempPurchLine;

                            with "Purchase Line" do begin
                              if SalesTax and not HeaderTaxArea."Use External Tax Engine" then begin
                                SalesTaxCalculate.AddPurchLine("Purchase Line");
                              end;
                              if not "Purchase Header"."Prices Including VAT" and
                                 ("VAT Calculation Type" = "vat calculation type"::"Full VAT")
                              then
                                TempPurchLine."Line Amount" := 0;
                              DimSetEntry2.SetRange("Dimension Set ID","Purchase Line"."Dimension Set ID");
                              DimMgt.GetDimensionSet(TempDimSetEntry,"Purchase Line"."Dimension Set ID");

                              if "Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"]
                              then begin
                                if "Document Type" = "document type"::"Credit Memo" then begin
                                  if ("Return Qty. to Ship" <> Quantity) and ("Return Shipment No." = '') then
                                    AddError(StrSubstNo(Text019,FieldCaption("Return Qty. to Ship"),Quantity));
                                  if "Qty. to Invoice" <> Quantity then
                                    AddError(StrSubstNo(Text019,FieldCaption("Qty. to Invoice"),Quantity));
                                end;
                                if "Qty. to Receive" <> 0 then
                                  AddError(StrSubstNo(Text040,FieldCaption("Qty. to Receive")));
                              end else begin
                                if "Document Type" = "document type"::Invoice then begin
                                  if ("Qty. to Receive" <> Quantity) and ("Receipt No." = '') then
                                    AddError(StrSubstNo(Text019,FieldCaption("Qty. to Receive"),Quantity));
                                  if "Qty. to Invoice" <> Quantity then
                                    AddError(StrSubstNo(Text019,FieldCaption("Qty. to Invoice"),Quantity));
                                end;
                                if "Return Qty. to Ship" <> 0 then
                                  AddError(StrSubstNo(Text040,FieldCaption("Return Qty. to Ship")));
                              end;

                              if not "Purchase Header".Receive then
                                "Qty. to Receive" := 0;
                              if not "Purchase Header".Ship then
                                "Return Qty. to Ship" := 0;

                              if ("Document Type" = "document type"::Invoice) and ("Receipt No." <> '') then begin
                                "Quantity Received" := Quantity;
                                "Qty. to Receive" := 0;
                              end;

                              if ("Document Type" = "document type"::"Credit Memo") and ("Return Shipment No." <> '') then begin
                                "Return Qty. Shipped" := Quantity;
                                "Return Qty. to Ship" := 0;
                              end;

                              if "Purchase Header".Invoice then begin
                                if "Document Type" = "document type"::"Credit Memo" then
                                  MaxQtyToBeInvoiced := "Return Qty. to Ship" + "Return Qty. Shipped" - "Quantity Invoiced"
                                else
                                  MaxQtyToBeInvoiced := "Qty. to Receive" + "Quantity Received" - "Quantity Invoiced";
                                if Abs("Qty. to Invoice") > Abs(MaxQtyToBeInvoiced) then
                                  "Qty. to Invoice" := MaxQtyToBeInvoiced;
                              end else
                                "Qty. to Invoice" := 0;

                              if "Purchase Header".Receive then begin
                                QtyToHandle := "Qty. to Receive";
                                QtyToHandleCaption := FieldCaption("Qty. to Receive");
                              end;

                              if "Purchase Header".Ship then begin
                                QtyToHandle := "Return Qty. to Ship";
                                QtyToHandleCaption := FieldCaption("Return Qty. to Ship");
                              end;

                              if "Gen. Prod. Posting Group" <> '' then begin
                                Clear(GenPostingSetup);
                                GenPostingSetup.Reset;
                                GenPostingSetup.SetRange("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
                                GenPostingSetup.SetRange("Gen. Prod. Posting Group","Gen. Prod. Posting Group");
                                if not GenPostingSetup.FindLast then
                                  AddError(
                                    StrSubstNo(
                                      Text020,
                                      GenPostingSetup.TableCaption,"Gen. Bus. Posting Group","Gen. Prod. Posting Group"));
                              end;

                              if Quantity <> 0 then begin
                                if "No." = '' then
                                  AddError(StrSubstNo(Text006,FieldCaption("No.")));
                                if Type = 0 then
                                  AddError(StrSubstNo(Text006,FieldCaption(Type)));
                              end else
                                if Amount <> 0 then
                                  AddError(StrSubstNo(Text021,FieldCaption(Amount),FieldCaption(Quantity)));

                              PurchLine := "Purchase Line";
                              TestJobFields(PurchLine);
                              if "Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"]
                              then begin
                                PurchLine."Return Qty. to Ship" := -PurchLine."Return Qty. to Ship";
                                PurchLine."Qty. to Invoice" := -PurchLine."Qty. to Invoice";
                              end;

                              RemQtyToBeInvoiced := PurchLine."Qty. to Invoice";

                              case "Document Type" of
                                "document type"::"Return Order","document type"::"Credit Memo":
                                  CheckShptLines("Purchase Line");
                                "document type"::Order,"document type"::Invoice:
                                  CheckRcptLines("Purchase Line");
                              end;

                              if (Type >= Type::"G/L Account") and ("Qty. to Invoice" <> 0) then
                                if GLSetup."VAT in Use" then
                                if not GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group") then
                                  AddError(
                                    StrSubstNo(
                                      Text020,
                                      GenPostingSetup.TableCaption,"Gen. Bus. Posting Group","Gen. Prod. Posting Group"));

                              if "Prepayment %" > 0 then
                                if not "Prepayment Line" and (Quantity > 0) then begin
                                  Fraction := ("Qty. to Invoice" + "Quantity Invoiced") / Quantity;
                                  if Fraction > 1 then
                                    Fraction := 1;

                                  case true of
                                    (Fraction * "Line Amount" < "Prepmt Amt to Deduct") and
                                    ("Prepmt Amt to Deduct" <> 0):
                                      AddError(
                                        StrSubstNo(
                                          Text053,
                                          FieldCaption("Prepmt Amt to Deduct"),
                                          ROUND(Fraction * "Line Amount",GLSetup."Amount Rounding Precision")));
                                    (1 - Fraction) * "Line Amount" <
                                    "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" - "Prepmt Amt to Deduct":
                                      AddError(
                                        StrSubstNo(
                                          Text054,
                                          FieldCaption("Prepmt Amt to Deduct"),
                                          ROUND(
                                            "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" - (1 - Fraction) * "Line Amount",
                                            GLSetup."Amount Rounding Precision")));
                                  end;
                                end;
                              if not "Prepayment Line" and ("Prepmt. Line Amount" > 0) then
                                if "Prepmt. Line Amount" > "Prepmt. Amt. Inv." then
                                  AddError(StrSubstNo(Text042,FieldCaption("Prepmt. Line Amount")));

                              case Type of
                                Type::"G/L Account":
                                  begin
                                    if ("No." = '') and (Amount = 0) then
                                      exit;

                                    if "No." <> '' then
                                      if GLAcc.Get("No.") then begin
                                        if GLAcc.Blocked then
                                          AddError(
                                            StrSubstNo(
                                              Text007,
                                              GLAcc.FieldCaption(Blocked),false,GLAcc.TableCaption,"No."));
                                        if not GLAcc."Direct Posting" and ("Line No." <= OrigMaxLineNo) then
                                          AddError(
                                            StrSubstNo(
                                              Text007,
                                              GLAcc.FieldCaption("Direct Posting"),true,GLAcc.TableCaption,"No."));
                                      end else
                                        AddError(
                                          StrSubstNo(
                                            Text008,
                                            GLAcc.TableCaption,"No."));
                                  end;
                                Type::Item:
                                  begin
                                    if ("No." = '') and (Quantity = 0) then
                                      exit;

                                    if "No." <> '' then
                                      if Item.Get("No.") then begin
                                        if Item.Blocked then
                                          AddError(
                                            StrSubstNo(
                                              Text007,
                                              Item.FieldCaption(Blocked),false,Item.TableCaption,"No."));
                                        if Item."Costing Method" = Item."costing method"::Specific then
                                          if Item.Reserve = Item.Reserve::Always then begin
                                            CalcFields("Reserved Quantity");
                                            if (Signed(Quantity) < 0) and (Abs("Reserved Quantity") < Abs("Qty. to Receive")) then
                                              AddError(
                                                StrSubstNo(
                                                  Text019,
                                                  FieldCaption("Reserved Quantity"),Signed("Qty. to Receive")));
                                          end;
                                      end else
                                        AddError(
                                          StrSubstNo(
                                            Text008,
                                            Item.TableCaption,"No."));
                                  end;
                                Type::"Fixed Asset":
                                  begin
                                    if ("No." = '') and (Quantity = 0) then
                                      exit;

                                    if "No." <> '' then
                                      if FA.Get("No.") then begin
                                        if FA.Blocked then
                                          AddError(
                                            StrSubstNo(
                                              Text007,
                                              FA.FieldCaption(Blocked),false,FA.TableCaption,"No."));
                                        if FA.Inactive then
                                          AddError(
                                            StrSubstNo(
                                              Text007,
                                              FA.FieldCaption(Inactive),false,FA.TableCaption,"No."));
                                      end else
                                        AddError(
                                          StrSubstNo(
                                            Text008,
                                            FA.TableCaption,"No."));
                                  end;
                              end;

                              if "Line No." > OrigMaxLineNo then begin
                                AddDimToTempLine("Purchase Line",TempDimSetEntry);
                                if not DimMgt.CheckDimIDComb("Purchase Line"."Dimension Set ID") then
                                  AddError(DimMgt.GetDimCombErr);
                                if not DimMgt.CheckDimValuePosting(TableID,No,"Purchase Line"."Dimension Set ID") then
                                  AddError(DimMgt.GetDimValuePostingErr);
                              end else begin
                                if not DimMgt.CheckDimIDComb("Purchase Line"."Dimension Set ID") then
                                  AddError(DimMgt.GetDimCombErr);

                                TableID[1] := DimMgt.TypeToTableID3(Type);
                                No[1] := "No.";
                                TableID[2] := Database::Job;
                                No[2] := "Job No.";
                                TableID[3] := Database::"Work Center";
                                No[3] := "Work Center No.";
                                if not DimMgt.CheckDimValuePosting(TableID,No,"Purchase Line"."Dimension Set ID") then
                                  AddError(DimMgt.GetDimValuePostingErr);
                              end;

                              AllowInvDisctxt := Format("Purchase Line"."Allow Invoice Disc.");
                            end;
                            totAmount := totAmount + "Purchase Line"."Line Amount";
                            AllowInvDisctxt := Format("Purchase Line"."Allow Invoice Disc.");

                            if Number = TempPurchLine.Count then begin
                              if SalesTax then begin
                                if HeaderTaxArea."Use External Tax Engine" then
                                  SalesTaxCalculate.CallExternalTaxEngineForPurch("Purchase Header",true)
                                else
                                  SalesTaxCalculate.EndSalesTaxCalculation("Purchase Header"."Posting Date");
                                SalesTaxCalculate.GetSalesTaxAmountLineTable(SalesTaxAmountLine);
                                VATAmount := SalesTaxAmountLine.GetTotalTaxAmountFCY;
                                VATBaseAmount := SalesTaxAmountLine.GetTotalTaxBase;
                              end;
                              if SalesTax then
                                TaxText := SalesTaxAmountLine.TaxAmountText
                              else
                               TaxText := VATAmountLine.VATAmountText;
                            end
                        end;

                        trigger OnPreDataItem()
                        var
                            MoreLines: Boolean;
                        begin
                            CurrReport.CreateTotals(TempPurchLine."Line Amount",TempPurchLine."Inv. Discount Amount");

                            MoreLines := TempPurchLine.Find('+');
                            while MoreLines and (TempPurchLine.Description = '') and (TempPurchLine."Description 2" = '') and
                                  (TempPurchLine."No." = '') and (TempPurchLine.Quantity = 0) and
                                  (TempPurchLine.Amount = 0)
                            do
                              MoreLines := TempPurchLine.Next(-1) <> 0;
                            if not MoreLines then
                              CurrReport.Break;
                            TempPurchLine.SetRange("Line No.",0,TempPurchLine."Line No.");
                            SetRange(Number,1,TempPurchLine.Count);

                            SumLineAmount := 0;
                            SumInvDiscountAmount := 0;
                        end;
                    }
                    dataitem(VATCounter;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_6558; 6558)
                        {
                        }
                        column(VATAmountLine__VAT_Amount_;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base_;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount_;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount_;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount_;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control98;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base__Control138;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT___;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmountLine__VAT_Identifier_;VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountLine__Line_Amount__Control175;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control176;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control177;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control95;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base__Control139;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control181;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control182;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount__Control183;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control85;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base__Control137;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control187;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control188;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount__Control189;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATCounter_Number;Number)
                        {
                        }
                        column(VAT_Amount_SpecificationCaption;VAT_Amount_SpecificationCaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Amount__Control98Caption;VATAmountLine__VAT_Amount__Control98CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Base__Control138Caption;VATAmountLine__VAT_Base__Control138CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT___Caption;VATAmountLine__VAT___CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Identifier_Caption;VATAmountLine__VAT_Identifier_CaptionLbl)
                        {
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control176Caption;VATAmountLine__Inv__Disc__Base_Amount__Control176CaptionLbl)
                        {
                        }
                        column(VATAmountLine__Line_Amount__Control175Caption;VATAmountLine__Line_Amount__Control175CaptionLbl)
                        {
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control177Caption;VATAmountLine__Invoice_Discount_Amount__Control177CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Base_Caption;VATAmountLine__VAT_Base_CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Base__Control139Caption;VATAmountLine__VAT_Base__Control139CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Base__Control137Caption;VATAmountLine__VAT_Base__Control137CaptionLbl)
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
                              VATAmountLine."VAT Base",VATAmountLine."VAT Amount",VATAmountLine."Amount Including VAT",
                              VATAmountLine."Line Amount",VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount");
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
                        column(VALVATAmountLCY;VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY;VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY_Control242;VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY_Control243;VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT____Control244;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmountLine__VAT_Identifier__Control245;VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VALVATAmountLCY_Control246;VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY_Control247;VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY_Control249;VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY_Control250;VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATCounterLCY_Number;Number)
                        {
                        }
                        column(VALVATAmountLCY_Control242Caption;VALVATAmountLCY_Control242CaptionLbl)
                        {
                        }
                        column(VALVATBaseLCY_Control243Caption;VALVATBaseLCY_Control243CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT____Control244Caption;VATAmountLine__VAT____Control244CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Identifier__Control245Caption;VATAmountLine__VAT_Identifier__Control245CaptionLbl)
                        {
                        }
                        column(ContinuedCaption;ContinuedCaptionLbl)
                        {
                        }
                        column(ContinuedCaption_Control248;ContinuedCaption_Control248Lbl)
                        {
                        }
                        column(TotalCaption;TotalCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Purchase Header"."Posting Date","Purchase Header"."Currency Code","Purchase Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Purchase Header"."Posting Date","Purchase Header"."Currency Code","Purchase Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        var
                            CurrExchRate: Record "Currency Exchange Rate";
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Purchase Header"."Currency Code"  = '')
                            then
                              CurrReport.Break;

                            SetRange(Number,1,VATAmountLine.Count);
                            CurrReport.CreateTotals(VALVATBaseLCY,VALVATAmountLCY);

                            if GLSetup."LCY Code" = '' then
                              VALSpecLCYHeader := Text050 + Text051
                            else
                              VALSpecLCYHeader := Text050 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Purchase Header"."Posting Date","Purchase Header"."Currency Code",1);
                            CurrExchRate."Relational Exch. Rate Amount" := CurrExchRate."Exchange Rate Amount" / "Purchase Header"."Currency Factor";
                            VALExchRate := StrSubstNo(Text052,CurrExchRate."Relational Exch. Rate Amount",CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(SalesTaxCounter;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_5927; 5927)
                        {
                        }
                        column(SalesTax_AND__SalesTaxAmountLine__Tax_Amount_____0_;SalesTax and (SalesTaxAmountLine."Tax Amount" <> 0))
                        {
                        }
                        column(Purchase_Header___Currency_Code________;("Purchase Header"."Currency Code" <> ''))
                        {
                        }
                        column(SalesTaxAmountLine__Tax_Amount_;SalesTaxAmountLine."Tax Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesTaxAmountLine__Tax_Amount__Control1020000;SalesTaxAmountLine."Tax Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesTaxAmountLine__Tax_Area_Code_for_Key_;SalesTaxAmountLine."Tax Area Code for Key")
                        {
                            AutoFormatType = 1;
                        }
                        column(SalesTaxAmountLine__Tax_Base_Amount_;SalesTaxAmountLine."Tax Base Amount")
                        {
                            AutoFormatType = 1;
                        }
                        column(SalesTaxAmountLine__Inv__Disc__Base_Amount_;SalesTaxAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatType = 1;
                        }
                        column(SalesTaxAmountLine__Invoice_Discount_Amount_;SalesTaxAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatType = 1;
                        }
                        column(SalesTaxAmountLine__Tax___;SalesTaxAmountLine."Tax %")
                        {
                            AutoFormatType = 1;
                        }
                        column(SalesTaxAmountLine__Tax_Amount__Control1020011;SalesTaxAmountLine."Tax Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesTaxAmountLine__Tax_Amount__Control1020014;SalesTaxAmountLine."Tax Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesTaxAmountLine__Tax_Amount____ExchangeFactor;VATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Total______Purchase_Header___Currency_Code_;'Total ' + "Purchase Header"."Currency Code")
                        {
                        }
                        column(SalesTaxCounter_Number;Number)
                        {
                        }
                        column(SalesTaxAmountLine__Tax_Area_Code_for_Key_Caption;SalesTaxAmountLine__Tax_Area_Code_for_Key_CaptionLbl)
                        {
                        }
                        column(SalesTaxAmountLine__Tax_Base_Amount_Caption;SalesTaxAmountLine__Tax_Base_Amount_CaptionLbl)
                        {
                        }
                        column(SalesTaxAmountLine__Tax_Amount__Control1020000Caption;SalesTaxAmountLine__Tax_Amount__Control1020000CaptionLbl)
                        {
                        }
                        column(SalesTaxAmountLine__Inv__Disc__Base_Amount_Caption;SalesTaxAmountLine__Inv__Disc__Base_Amount_CaptionLbl)
                        {
                        }
                        column(SalesTaxAmountLine__Invoice_Discount_Amount_Caption;SalesTaxAmountLine__Invoice_Discount_Amount_CaptionLbl)
                        {
                        }
                        column(SalesTaxAmountLine__Tax___Caption;SalesTaxAmountLine__Tax___CaptionLbl)
                        {
                        }
                        column(Sales_Tax_AmountsCaption;Sales_Tax_AmountsCaptionLbl)
                        {
                        }
                        column(ContinuedCaption_Control1020002;ContinuedCaption_Control1020002Lbl)
                        {
                        }
                        column(ContinuedCaption_Control1020007;ContinuedCaption_Control1020007Lbl)
                        {
                        }
                        column(TotalCaption_Control1020012;TotalCaption_Control1020012Lbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                              SalesTaxAmountLine.Find('-')
                            else
                              SalesTaxAmountLine.Next;

                            if SalesTaxCountry = Salestaxcountry::CA then
                              SalesTaxAmountLine."Tax Amount" := ROUND(SalesTaxAmountLine."Tax Amount",GLSetup."Amount Rounding Precision")
                            else begin
                              SalesTaxAmountLine."Tax Amount" += RemSalesTaxAmt;
                              RemSalesTaxAmt :=
                                SalesTaxAmountLine."Tax Amount" - ROUND(
                                  SalesTaxAmountLine."Tax Amount",GLSetup."Amount Rounding Precision");
                              SalesTaxAmountLine."Tax Amount" := ROUND(SalesTaxAmountLine."Tax Amount",GLSetup."Amount Rounding Precision");
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not SalesTax then
                              CurrReport.Break;
                            SetRange(Number,1,SalesTaxAmountLine.Count);
                            SalesTaxAmountLine.Reset;
                            CurrReport.CreateTotals(
                              SalesTaxAmountLine."Tax Amount",SalesTaxAmountLine."Amount Including Tax",
                              SalesTaxAmountLine."Line Amount",SalesTaxAmountLine."Inv. Disc. Base Amount",
                              SalesTaxAmountLine."Invoice Discount Amount");
                            RemSalesTaxAmt := 0;
                        end;
                    }
                    dataitem("Item Charge Assignment (Purch)";"Item Charge Assignment (Purch)")
                    {
                        DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("Document No.");
                        DataItemLinkReference = "Purchase Line";
                        DataItemTableView = sorting("Document Type","Document No.","Document Line No.","Line No.");
                        column(ReportForNavId_8938; 8938)
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Qty__to_Assign_;"Qty. to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Amount_to_Assign_;"Amount to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Item_Charge_No__;"Item Charge No.")
                        {
                        }
                        column(PurchLine2_Description;PurchLine2.Description)
                        {
                        }
                        column(PurchLine2_Quantity;PurchLine2.Quantity)
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Item_No__;"Item No.")
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Qty__to_Assign__Control204;"Qty. to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Unit_Cost_;"Unit Cost")
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Amount_to_Assign__Control210;"Amount to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Qty__to_Assign__Control195;"Qty. to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Amount_to_Assign__Control196;"Amount to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Qty__to_Assign__Control191;"Qty. to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Amount_to_Assign__Control193;"Amount to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Purch__Document_Type;"Document Type")
                        {
                        }
                        column(Item_Charge_Assignment__Purch__Document_No_;"Document No.")
                        {
                        }
                        column(Item_Charge_Assignment__Purch__Document_Line_No_;"Document Line No.")
                        {
                        }
                        column(Item_Charge_Assignment__Purch__Line_No_;"Line No.")
                        {
                        }
                        column(Item_Charge_SpecificationCaption;Item_Charge_SpecificationCaptionLbl)
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Item_Charge_No__Caption;FieldCaption("Item Charge No."))
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Item_No__Caption;FieldCaption("Item No."))
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Qty__to_Assign__Control204Caption;FieldCaption("Qty. to Assign"))
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Unit_Cost_Caption;FieldCaption("Unit Cost"))
                        {
                        }
                        column(Item_Charge_Assignment__Purch___Amount_to_Assign__Control210Caption;FieldCaption("Amount to Assign"))
                        {
                        }
                        column(DescriptionCaption_Control227;DescriptionCaption_Control227Lbl)
                        {
                        }
                        column(PurchLine2_QuantityCaption;PurchLine2_QuantityCaptionLbl)
                        {
                        }
                        column(ContinuedCaption_Control197;ContinuedCaption_Control197Lbl)
                        {
                        }
                        column(TotalCaption_Control194;TotalCaption_Control194Lbl)
                        {
                        }
                        column(ContinuedCaption_Control192;ContinuedCaption_Control192Lbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if PurchLine2.Get("Document Type","Document No.","Document Line No.") then;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowItemChargeAssgnt then
                              CurrReport.Break;
                            CurrReport.CreateTotals("Amount to Assign","Qty. to Assign");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        PurchPost: Codeunit "Purch.-Post";
                    begin
                        Clear(TempPurchLine);
                        Clear(PurchPost);
                        TempPurchLine.DeleteAll;
                        VATAmountLine.DeleteAll;
                        PurchPost.GetPurchLines("Purchase Header",TempPurchLine,1);
                        TempPurchLine.CalcVATAmountLines(0,"Purchase Header",TempPurchLine,VATAmountLine);
                        TempPurchLine.UpdateVATOnLines(0,"Purchase Header",TempPurchLine,VATAmountLine);
                        VATAmount := VATAmountLine.GetTotalVATAmount;
                        VATBaseAmount := VATAmountLine.GetTotalVATBase;
                        VATDiscountAmount :=
                          VATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code","Purchase Header"."Prices Including VAT");

                        if SalesTax then begin
                          SalesTaxAmountLine.DeleteAll;
                          SalesTaxCalculate.StartSalesTaxCalculation;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    PurchHeaderDocTypeNo := "Purchase Header"."Document Type";
                end;
            }

            trigger OnAfterGetRecord()
            var
                TableID: array [10] of Integer;
                No: array [10] of Code[20];
                InvtPeriodEndDate: Date;
            begin
                DimSetEntry1.SetRange("Dimension Set ID","Purchase Header"."Dimension Set ID");

                FormatAddr.PurchHeaderPayTo(PayToAddr,"Purchase Header");
                FormatAddr.PurchHeaderBuyFrom(BuyFromAddr,"Purchase Header");
                FormatAddr.PurchHeaderShipTo(ShipToAddr,"Purchase Header");
                if "Currency Code" = '' then begin
                  GLSetup.TestField("LCY Code");
                  TotalText := StrSubstNo(Text004,GLSetup."LCY Code");
                  TotalInclVATText := StrSubstNo(Text005,GLSetup."LCY Code");
                  TotalExclVATText := StrSubstNo(Text031,GLSetup."LCY Code");
                  ExchangeFactor := 1;
                end else begin
                  TotalText := StrSubstNo(Text004,"Currency Code");
                  TotalInclVATText := StrSubstNo(Text005,"Currency Code");
                  TotalExclVATText := StrSubstNo(Text031,"Currency Code");
                  ExchangeFactor := "Currency Factor";
                end;

                Invoice := InvOnNextPostReq;
                Receive := ReceiveShipOnNextPostReq;
                Ship := ReceiveShipOnNextPostReq;

                SalesTax := "Tax Area Code" <> '';
                if SalesTax then begin
                  HeaderTaxArea.Get("Tax Area Code");
                  SalesTaxCountry := HeaderTaxArea."Country/Region";
                end else
                  SalesTaxCountry := Salestaxcountry::NoTax;

                if "Buy-from Vendor No." = '' then
                  AddError(StrSubstNo(Text006,FieldCaption("Buy-from Vendor No.")))
                else begin
                  if Vend.Get("Buy-from Vendor No.") then begin
                    if Vend.Blocked = Vend.Blocked::All then
                      AddError(
                        StrSubstNo(
                          Text041,
                          Vend.FieldCaption(Blocked),Vend.Blocked,Vend.TableCaption,"Buy-from Vendor No."));
                  end else
                    AddError(
                      StrSubstNo(
                        Text008,
                        Vend.TableCaption,"Buy-from Vendor No."));
                end;

                if "Pay-to Vendor No." = '' then
                  AddError(StrSubstNo(Text006,FieldCaption("Pay-to Vendor No.")))
                else
                  if "Pay-to Vendor No." <> "Buy-from Vendor No." then begin
                    if Vend.Get("Pay-to Vendor No.") then begin
                      if Vend.Blocked = Vend.Blocked::All then
                        AddError(
                          StrSubstNo(
                            Text041,
                            Vend.FieldCaption(Blocked),Vend.Blocked::All,Vend.TableCaption,"Pay-to Vendor No."));
                    end else
                      AddError(
                        StrSubstNo(
                          Text008,
                          Vend.TableCaption,"Pay-to Vendor No."));
                  end;

                PurchSetup.Get;

                if "Posting Date" = 0D then
                  AddError(StrSubstNo(Text006,FieldCaption("Posting Date")))
                else
                  if "Posting Date" <> NormalDate("Posting Date") then
                    AddError(StrSubstNo(Text009,FieldCaption("Posting Date")))
                  else begin
                    if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
                      if UserId <> '' then
                        if UserSetup.Get(UserId) then begin
                          AllowPostingFrom := UserSetup."Allow Posting From";
                          AllowPostingTo := UserSetup."Allow Posting To";
                        end;
                      if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
                        AllowPostingFrom := GLSetup."Allow Posting From";
                        AllowPostingTo := GLSetup."Allow Posting To";
                      end;
                      if AllowPostingTo = 0D then
                        AllowPostingTo := Dmy2date(31,12,9999);
                    end;
                    if ("Posting Date" < AllowPostingFrom) or ("Posting Date" > AllowPostingTo) then
                      AddError(StrSubstNo(Text010,FieldCaption("Posting Date")))
                    else
                      if IsInvtPosting then begin
                        InvtPeriodEndDate := "Posting Date";
                        if not InvtPeriod.IsValidDate(InvtPeriodEndDate) then
                          AddError(
                            StrSubstNo(Text010,Format("Posting Date")))
                      end;
                  end;

                if "Document Date" <> 0D then
                  if "Document Date" <> NormalDate("Document Date") then
                    AddError(StrSubstNo(Text009,FieldCaption("Document Date")));

                case "Document Type" of
                  "document type"::Order:
                    Ship := false;
                  "document type"::Invoice:
                    begin
                      Receive := true;
                      Invoice := true;
                      Ship := false;
                    end;
                  "document type"::"Return Order":
                    Receive := false;
                  "document type"::"Credit Memo":
                    begin
                      Receive := false;
                      Invoice := true;
                      Ship := true;
                    end;
                end;

                if not (Receive or Invoice or Ship) then
                  AddError(
                    StrSubstNo(
                      Text032,
                      FieldCaption(Receive),FieldCaption(Invoice),FieldCaption(Ship)));

                if Invoice then begin
                  PurchLine.Reset;
                  PurchLine.SetRange("Document Type","Document Type");
                  PurchLine.SetRange("Document No.","No.");
                  PurchLine.SetFilter(Quantity,'<>0');
                  if "Document Type" in ["document type"::Order,"document type"::"Return Order"] then
                    PurchLine.SetFilter("Qty. to Invoice",'<>0');
                  Invoice := PurchLine.Find('-');
                  if Invoice and (not Receive) and ("Document Type" = "document type"::Order) then begin
                    Invoice := false;
                    repeat
                      Invoice := PurchLine."Quantity Received" - PurchLine."Quantity Invoiced" <> 0;
                    until Invoice or (PurchLine.Next = 0);
                  end else
                    if Invoice and (not Ship) and ("Document Type" = "document type"::"Return Order") then begin
                      Invoice := false;
                      repeat
                        Invoice := PurchLine."Return Qty. Shipped" - PurchLine."Quantity Invoiced" <> 0;
                      until Invoice or (PurchLine.Next = 0);
                    end;
                end;

                if Receive then begin
                  PurchLine.Reset;
                  PurchLine.SetRange("Document Type","Document Type");
                  PurchLine.SetRange("Document No.","No.");
                  PurchLine.SetFilter(Quantity,'<>0');
                  if "Document Type" = "document type"::Order then
                    PurchLine.SetFilter("Qty. to Receive",'<>0');
                  PurchLine.SetRange("Receipt No.",'');
                  Receive := PurchLine.Find('-');
                end;
                if Ship then begin
                  PurchLine.Reset;
                  PurchLine.SetRange("Document Type","Document Type");
                  PurchLine.SetRange("Document No.","No.");
                  PurchLine.SetFilter(Quantity,'<>0');
                  if "Document Type" = "document type"::"Return Order" then
                    PurchLine.SetFilter("Return Qty. to Ship",'<>0');
                  PurchLine.SetRange("Return Shipment No.",'');
                  Ship := PurchLine.Find('-');
                end;

                if not (Receive or Invoice or Ship) then
                  AddError(Text012);

                if Invoice then begin
                  PurchLine.Reset;
                  PurchLine.SetRange("Document Type","Document Type");
                  PurchLine.SetRange("Document No.","No.");
                  PurchLine.SetFilter("Sales Order Line No.",'<>0');
                  if PurchLine.Find('-') then
                    repeat
                      SalesLine.Get(SalesLine."document type"::Order,PurchLine."Sales Order No.",PurchLine."Sales Order Line No.");
                      if Receive and
                         Invoice and
                         (PurchLine."Qty. to Invoice" <> 0) and
                         (PurchLine."Qty. to Receive" <> 0)
                      then
                        AddError(Text013);
                      if Abs(PurchLine."Quantity Received" - PurchLine."Quantity Invoiced") <
                         Abs(PurchLine."Qty. to Invoice")
                      then
                        PurchLine."Qty. to Invoice" := PurchLine."Quantity Received" - PurchLine."Quantity Invoiced";
                      if Abs(PurchLine.Quantity - (PurchLine."Qty. to Invoice" + PurchLine."Quantity Invoiced")) <
                         Abs(SalesLine.Quantity - SalesLine."Quantity Invoiced")
                      then
                        AddError(
                          StrSubstNo(
                            Text014,
                            PurchLine."Sales Order No."));
                    until PurchLine.Next = 0;
                end;

                if Invoice then
                  if not ("Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"]) then
                    if "Due Date" = 0D then
                      AddError(StrSubstNo(Text006,FieldCaption("Due Date")));

                if Receive and ("Receiving No." = '') then
                  if ("Document Type" = "document type"::Order) or
                     (("Document Type" = "document type"::Invoice) and PurchSetup."Receipt on Invoice")
                  then
                    if "Receiving No. Series" = '' then
                      AddError(
                        StrSubstNo(
                          Text015,
                          FieldCaption("Receiving No. Series")));

                if Ship and ("Return Shipment No." = '') then
                  if ("Document Type" = "document type"::"Return Order") or
                     (("Document Type" = "document type"::"Credit Memo") and PurchSetup."Return Shipment on Credit Memo")
                  then
                    if "Return Shipment No. Series" = '' then
                      AddError(
                        StrSubstNo(
                          Text015,
                          FieldCaption("Return Shipment No. Series")));

                if Invoice and ("Posting No." = '') then
                  if "Document Type" in ["document type"::Order,"document type"::"Return Order"] then
                    if "Posting No. Series" = '' then
                      AddError(
                        StrSubstNo(
                          Text015,
                          FieldCaption("Posting No. Series")));

                PurchLine.Reset;
                PurchLine.SetRange("Document Type","Document Type");
                PurchLine.SetRange("Document No.","No.");
                PurchLine.SetFilter("Sales Order Line No.",'<>0');
                if Receive then
                  if PurchLine.FindSet then
                    repeat
                      if SalesHeader."No." <> PurchLine."Sales Order No." then begin
                        SalesHeader.Get(1,PurchLine."Sales Order No.");
                        if SalesHeader."Bill-to Customer No." = '' then
                          AddError(
                            StrSubstNo(
                              Text016,
                              SalesHeader.FieldCaption("Bill-to Customer No.")));
                        if SalesHeader."Shipping No." = '' then
                          if SalesHeader."Shipping No. Series" = '' then
                            AddError(
                              StrSubstNo(
                                Text016,
                                SalesHeader.FieldCaption("Shipping No. Series")));
                      end;
                    until PurchLine.Next = 0;

                if Invoice then
                  if "Document Type" in ["document type"::Order,"document type"::Invoice] then begin
                    if PurchSetup."Ext. Doc. No. Mandatory" and ("Vendor Invoice No." = '') then
                      AddError(StrSubstNo(Text006,FieldCaption("Vendor Invoice No.")));
                  end else
                    if PurchSetup."Ext. Doc. No. Mandatory" and ("Vendor Cr. Memo No." = '') then
                      AddError(StrSubstNo(Text006,FieldCaption("Vendor Cr. Memo No.")));

                if "Vendor Invoice No." <> '' then begin
                  VendLedgEntry.SetCurrentkey("External Document No.");
                  VendLedgEntry.SetRange("Document Type","Document Type");
                  VendLedgEntry.SetRange("External Document No.","Vendor Invoice No.");
                  VendLedgEntry.SetRange("Vendor No.","Pay-to Vendor No.");
                  if VendLedgEntry.FindFirst then
                    AddError(
                      StrSubstNo(
                        Text017,
                        "Document Type","Vendor Invoice No."));
                end;

                if not DimMgt.CheckDimIDComb("Purchase Header"."Dimension Set ID") then
                  AddError(DimMgt.GetDimCombErr);

                TableID[1] := Database::Vendor;
                No[1] := "Pay-to Vendor No.";
                TableID[3] := Database::"Salesperson/Purchaser";
                No[3] := "Purchaser Code";
                TableID[4] := Database::Campaign;
                No[4] := "Campaign No.";
                TableID[5] := Database::"Responsibility Center";
                No[5] := "Responsibility Center";

                if not DimMgt.CheckDimValuePosting(TableID,No,"Purchase Header"."Dimension Set ID") then
                  AddError(DimMgt.GetDimValuePostingErr);

                PurchLine.Reset;
                PurchLine.SetRange("Document Type","Document Type");
                PurchLine.SetRange("Document No.","No.");
                InvoiceAmount := 0;
                if PurchLine.FindSet then
                  repeat
                    InvoiceAmount += PurchLine."Outstanding Amount";
                  until PurchLine.Next = 0;
                if Purchaser.Get("Purchaser Code") then;

                PricesInclVATtxt := Format("Purchase Header"."Prices Including VAT");
            end;

            trigger OnPreDataItem()
            begin
                PurchHeader.Copy("Purchase Header");
                PurchHeader.FilterGroup := 2;
                PurchHeader.SetRange("Document Type",PurchHeader."document type"::Order);
                if PurchHeader.FindFirst then begin
                  case true of
                    ReceiveShipOnNextPostReq and InvOnNextPostReq:
                      ReceiveInvoiceText := Text000;
                    ReceiveShipOnNextPostReq:
                      ReceiveInvoiceText := Text001;
                    InvOnNextPostReq:
                      ReceiveInvoiceText := Text002;
                  end;
                  ReceiveInvoiceText := StrSubstNo(Text003,ReceiveInvoiceText);
                end;
                PurchHeader.SetRange("Document Type",PurchHeader."document type"::"Return Order");
                if PurchHeader.FindFirst then begin
                  case true of
                    ReceiveShipOnNextPostReq and InvOnNextPostReq:
                      ShipInvoiceText := Text028;
                    ReceiveShipOnNextPostReq:
                      ShipInvoiceText := Text029;
                    InvOnNextPostReq:
                      ShipInvoiceText := Text002;
                  end;
                  ShipInvoiceText := StrSubstNo(Text030,ShipInvoiceText);
                end;
                CurrReport.NewPagePerRecord := not(Summarize);
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
                    group("Order/Credit Memo Posting")
                    {
                        Caption = 'Order/Credit Memo Posting';
                        field(ReceiveShip;ReceiveShipOnNextPostReq)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Receive/Ship';

                            trigger OnValidate()
                            begin
                                if not ReceiveShipOnNextPostReq then
                                  InvOnNextPostReq := true;
                            end;
                        }
                        field(Invoice;InvOnNextPostReq)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Invoice';

                            trigger OnValidate()
                            begin
                                if not InvOnNextPostReq then
                                  ReceiveShipOnNextPostReq := true;
                            end;
                        }
                    }
                    field(ShowDim;ShowDim)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Dimensions';
                    }
                    field(ShowItemChargeAssignment;ShowItemChargeAssgnt)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Item Charge Assgnt.';
                    }
                    field(Summary;Summarize)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Summary';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if not ReceiveShipOnNextPostReq and not InvOnNextPostReq then begin
              ReceiveShipOnNextPostReq := true;
              InvOnNextPostReq := true;
            end;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
    end;

    trigger OnPreReport()
    begin
        PurchHeaderFilter := "Purchase Header".GetFilters;
        CompanyInformation.Get;
    end;

    var
        Text000: label 'Receive and Invoice';
        Text001: label 'Receive';
        Text002: label 'Invoice';
        Text003: label 'Order Posting: %1';
        Text004: label 'Total %1';
        Text005: label 'Total %1 Incl. Tax';
        Text006: label '%1 must be specified.';
        Text007: label '%1 must be %2 for %3 %4.';
        Text008: label '%1 %2 does not exist.';
        Text009: label '%1 must not be a closing date.';
        Text010: label '%1 is not within your allowed range of posting dates.';
        Text012: label 'There is nothing to post.';
        Text013: label 'A drop shipment from a purchase order cannot be received and invoiced at the same time.';
        Text014: label 'Invoice sales order %1 before invoicing this purchase order.';
        Text015: label '%1 must be entered.';
        Text016: label '%1 must be entered on the sales order header.';
        Text017: label 'Purchase %1 %2 already exists for this vendor.';
        Text018: label 'Purchase Document: %1';
        Text019: label '%1 must be %2.';
        Text020: label '%1 %2 %3 does not exist.';
        Text021: label '%1 must be 0 when %2 is 0.';
        Text022: label 'The %1 on the receipt is not the same as the %1 on the purchase header.';
        Text023: label '%1 must have the same sign as the receipt.';
        Text025: label '%1 must have the same sign as the return shipment.';
        Text028: label 'Ship and Invoice';
        Text029: label 'Ship';
        Text030: label 'Return Order Posting: %1';
        Text031: label 'Total %1 Excl. Tax';
        Text032: label 'Enter "Yes" in %1 and/or %2 and/or %3.';
        Text033: label 'Line %1 of the receipt %2, which you are attempting to invoice, has already been invoiced.';
        Text034: label 'Line %1 of the return shipment %2, which you are attempting to invoice, has already been invoiced.';
        Text036: label 'The %1 on the return shipment is not the same as the %1 on the purchase header.';
        Text037: label 'The quantity you are attempting to invoice is greater than the quantity in receipt %1.';
        Text038: label 'The quantity you are attempting to invoice is greater than the quantity in return shipment %1.';
        CompanyInformation: Record "Company Information";
        PurchSetup: Record "Purchases & Payables Setup";
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        TempPurchLine: Record "Purchase Line" temporary;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FA: Record "Fixed Asset";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ReturnShptLine: Record "Return Shipment Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        GenPostingSetup: Record "General Posting Setup";
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        SalesTaxAmountLine: Record UnknownRecord10011 temporary;
        InvtPeriod: Record "Inventory Period";
        HeaderTaxArea: Record "Tax Area";
        Purchaser: Record "Salesperson/Purchaser";
        FormatAddr: Codeunit "Format Address";
        DimMgt: Codeunit DimensionManagement;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        PayToAddr: array [8] of Text[50];
        BuyFromAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        PurchHeaderFilter: Text;
        ErrorText: array [99] of Text[250];
        DimText: Text[120];
        OldDimText: Text[75];
        ReceiveInvoiceText: Text[50];
        ShipInvoiceText: Text[50];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        QtyToHandleCaption: Text[30];
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        MaxQtyToBeInvoiced: Decimal;
        RemQtyToBeInvoiced: Decimal;
        QtyToBeInvoiced: Decimal;
        QtyToHandle: Decimal;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        ErrorCounter: Integer;
        OrigMaxLineNo: Integer;
        InvOnNextPostReq: Boolean;
        ReceiveShipOnNextPostReq: Boolean;
        ShowDim: Boolean;
        Continue: Boolean;
        ShowItemChargeAssgnt: Boolean;
        Text040: label '%1 must be zero.';
        Text041: label '%1 must not be %2 for %3 %4.';
        Text042: label '%1 must be completely preinvoiced before you can ship or invoice the line.';
        Text050: label 'Tax Amount Specification in ';
        Text051: label 'Local Currency';
        Text052: label 'Exchange rate: %1/%2';
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        SalesTax: Boolean;
        ExchangeFactor: Decimal;
        Text053: label '%1 can at most be %2.';
        Text054: label '%1 must be at least %2.';
        PricesInclVATtxt: Text[30];
        AllowInvDisctxt: Text[30];
        SumLineAmount: Decimal;
        SumInvDiscountAmount: Decimal;
        TaxText: Text[30];
        totAmount: Decimal;
        Summarize: Boolean;
        InvoiceAmount: Decimal;
        PurchHeaderDocTypeNo: Integer;
        SalesTaxCountry: Option US,CA,,,,,,,,,,,,NoTax;
        RemSalesTaxAmt: Decimal;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Purchase_Document___TestCaptionLbl: label 'Purchase Document - Test';
        Document_No_CaptionLbl: label 'Document No.';
        Vendor_Invoice_No_CaptionLbl: label 'Vendor Invoice No.';
        Invoice_Amount_Excl__TaxCaptionLbl: label 'Invoice Amount Excl. Tax';
        Vendor_InformationCaptionLbl: label 'Vendor Information';
        PurchaserCaptionLbl: label 'Purchaser';
        ContactCaptionLbl: label 'Contact';
        DescriptionCaptionLbl: label 'Description';
        Due_DateCaptionLbl: label 'Due Date';
        Posting_DateCaptionLbl: label 'Posting Date';
        Doc__DateCaptionLbl: label 'Doc. Date';
        ShipmentCaptionLbl: label 'Shipment';
        TermsCaptionLbl: label 'Terms';
        StatusCaptionLbl: label 'Status';
        Purchase_Document___TestCaption_Control1Lbl: label 'Purchase Document - Test';
        CurrReport_PAGENO_Control1029005CaptionLbl: label 'Page';
        Ship_toCaptionLbl: label 'Ship-to';
        Buy_fromCaptionLbl: label 'Buy-from';
        Pay_toCaptionLbl: label 'Pay-to';
        Purchase_Header___Posting_Date_CaptionLbl: label 'Posting Date';
        Purchase_Header___Document_Date_CaptionLbl: label 'Document Date';
        Purchase_Header___Due_Date_CaptionLbl: label 'Due Date';
        Purchase_Header___Pmt__Discount_Date_CaptionLbl: label 'Pmt. Discount Date';
        Purchase_Header___Posting_Date__Control106CaptionLbl: label 'Posting Date';
        Purchase_Header___Document_Date__Control107CaptionLbl: label 'Document Date';
        Purchase_Header___Order_Date_CaptionLbl: label 'Order Date';
        Purchase_Header___Expected_Receipt_Date_CaptionLbl: label 'Expected Receipt Date';
        Purchase_Header___Due_Date__Control19CaptionLbl: label 'Due Date';
        Purchase_Header___Pmt__Discount_Date__Control22CaptionLbl: label 'Pmt. Discount Date';
        Purchase_Header___Posting_Date__Control112CaptionLbl: label 'Posting Date';
        Purchase_Header___Document_Date__Control113CaptionLbl: label 'Document Date';
        Purchase_Header___Posting_Date__Control130CaptionLbl: label 'Posting Date';
        Purchase_Header___Document_Date__Control131CaptionLbl: label 'Document Date';
        Header_DimensionsCaptionLbl: label 'Header Dimensions';
        ErrorText_Number_CaptionLbl: label 'Warning!';
        AmountCaptionLbl: label 'Amount';
        Purchase_Line___Line_Discount___CaptionLbl: label 'Line Disc. %';
        Direct_Unit_CostCaptionLbl: label 'Direct Unit Cost';
        TempPurchLine__Inv__Discount_Amount_CaptionLbl: label 'Inv. Discount Amount';
        SubtotalCaptionLbl: label 'Subtotal';
        VATDiscountAmountCaptionLbl: label 'Payment Discount on VAT';
        Line_DimensionsCaptionLbl: label 'Line Dimensions';
        ErrorText_Number__Control103CaptionLbl: label 'Warning!';
        VAT_Amount_SpecificationCaptionLbl: label 'Tax Amount Specification';
        VATAmountLine__VAT_Amount__Control98CaptionLbl: label 'Tax Amount';
        VATAmountLine__VAT_Base__Control138CaptionLbl: label 'Tax Base';
        VATAmountLine__VAT___CaptionLbl: label 'Tax %';
        VATAmountLine__VAT_Identifier_CaptionLbl: label 'Tax Identifier';
        VATAmountLine__Inv__Disc__Base_Amount__Control176CaptionLbl: label 'Invoice Discount Base Amount';
        VATAmountLine__Line_Amount__Control175CaptionLbl: label 'Line Amount';
        VATAmountLine__Invoice_Discount_Amount__Control177CaptionLbl: label 'Invoice Discount Amount';
        VATAmountLine__VAT_Base_CaptionLbl: label 'Continued';
        VATAmountLine__VAT_Base__Control139CaptionLbl: label 'Continued';
        VATAmountLine__VAT_Base__Control137CaptionLbl: label 'Total';
        VALVATAmountLCY_Control242CaptionLbl: label 'Tax Amount';
        VALVATBaseLCY_Control243CaptionLbl: label 'Tax Base';
        VATAmountLine__VAT____Control244CaptionLbl: label 'Tax %';
        VATAmountLine__VAT_Identifier__Control245CaptionLbl: label 'Tax Identifier';
        ContinuedCaptionLbl: label 'Continued';
        ContinuedCaption_Control248Lbl: label 'Continued';
        TotalCaptionLbl: label 'Total';
        SalesTaxAmountLine__Tax_Area_Code_for_Key_CaptionLbl: label 'Tax Area Code';
        SalesTaxAmountLine__Tax_Base_Amount_CaptionLbl: label 'Tax Base Amount';
        SalesTaxAmountLine__Tax_Amount__Control1020000CaptionLbl: label 'Tax Amount';
        SalesTaxAmountLine__Inv__Disc__Base_Amount_CaptionLbl: label 'Inv. Disc. Base Amount';
        SalesTaxAmountLine__Invoice_Discount_Amount_CaptionLbl: label 'Invoice Discount Amount';
        SalesTaxAmountLine__Tax___CaptionLbl: label 'Tax %';
        Sales_Tax_AmountsCaptionLbl: label 'Sales Tax Amounts';
        ContinuedCaption_Control1020002Lbl: label 'Continued';
        ContinuedCaption_Control1020007Lbl: label 'Continued';
        TotalCaption_Control1020012Lbl: label 'Total';
        Item_Charge_SpecificationCaptionLbl: label 'Item Charge Specification';
        DescriptionCaption_Control227Lbl: label 'Description';
        PurchLine2_QuantityCaptionLbl: label 'Assignable Qty';
        ContinuedCaption_Control197Lbl: label 'Continued';
        TotalCaption_Control194Lbl: label 'Total';
        ContinuedCaption_Control192Lbl: label 'Continued';

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;

    local procedure CheckRcptLines(PurchLine2: Record "Purchase Line")
    var
        TempPostedDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        with PurchLine2 do begin
          if Abs(RemQtyToBeInvoiced) > Abs("Qty. to Receive") then begin
            PurchRcptLine.Reset;
            case "Document Type" of
              "document type"::Order:
                begin
                  PurchRcptLine.SetCurrentkey("Order No.","Order Line No.");
                  PurchRcptLine.SetRange("Order No.","Document No.");
                  PurchRcptLine.SetRange("Order Line No.","Line No.");
                end;
              "document type"::Invoice:
                begin
                  PurchRcptLine.SetRange("Document No.","Receipt No.");
                  PurchRcptLine.SetRange("Line No.","Receipt Line No.");
                end;
            end;

            PurchRcptLine.SetFilter("Qty. Rcd. Not Invoiced",'<>0');
            if PurchRcptLine.Find('-') then
              repeat
                DimMgt.GetDimensionSet(TempPostedDimSetEntry,PurchRcptLine."Dimension Set ID");
                if not DimMgt.CheckDimIDConsistency(
                  TempDimSetEntry,TempPostedDimSetEntry,Database::"Purchase Line",Database::"Purch. Rcpt. Line")
                then
                  AddError(DimMgt.GetDocDimConsistencyErr);
                if PurchRcptLine."Buy-from Vendor No." <> "Buy-from Vendor No." then
                  AddError(
                    StrSubstNo(
                      Text022,
                      FieldCaption("Buy-from Vendor No.")));
                if PurchRcptLine.Type <> Type then
                  AddError(
                    StrSubstNo(
                      Text022,
                      FieldCaption(Type)));
                if PurchRcptLine."No." <> "No." then
                  AddError(
                    StrSubstNo(
                      Text022,
                      FieldCaption("No.")));
                if PurchRcptLine."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                  AddError(
                    StrSubstNo(
                      Text022,
                      FieldCaption("Gen. Bus. Posting Group")));
                if PurchRcptLine."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                  AddError(
                    StrSubstNo(
                      Text022,
                      FieldCaption("Gen. Prod. Posting Group")));
                if PurchRcptLine."Location Code" <> "Location Code" then
                  AddError(
                    StrSubstNo(
                      Text022,
                      FieldCaption("Location Code")));
                if PurchRcptLine."Job No." <> "Job No." then
                  AddError(
                    StrSubstNo(
                      Text022,
                      FieldCaption("Job No.")));

                if PurchLine."Qty. to Invoice" * PurchRcptLine.Quantity < 0 then
                  AddError(StrSubstNo(Text023,FieldCaption("Qty. to Invoice")));

                QtyToBeInvoiced := RemQtyToBeInvoiced - PurchLine."Qty. to Receive";
                if Abs(QtyToBeInvoiced) > Abs(PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced") then
                  QtyToBeInvoiced := PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";
                RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                PurchRcptLine."Quantity Invoiced" := PurchRcptLine."Quantity Invoiced" + QtyToBeInvoiced;
              until (PurchRcptLine.Next = 0) or (Abs(RemQtyToBeInvoiced) <= Abs("Qty. to Receive"))
            else
              AddError(
                StrSubstNo(
                  Text033,
                  "Receipt Line No.",
                  "Receipt No."));
          end;

          if Abs(RemQtyToBeInvoiced) > Abs("Qty. to Receive") then
            if "Document Type" = "document type"::Invoice then
              AddError(
                StrSubstNo(
                  Text037,
                  "Receipt No."))
        end;
    end;

    local procedure CheckShptLines(PurchLine2: Record "Purchase Line")
    var
        TempPostedDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        with PurchLine2 do begin
          if Abs(RemQtyToBeInvoiced) > Abs("Return Qty. to Ship") then begin
            ReturnShptLine.Reset;
            case "Document Type" of
              "document type"::"Return Order":
                begin
                  ReturnShptLine.SetCurrentkey("Return Order No.","Return Order Line No.");
                  ReturnShptLine.SetRange("Return Order No.","Document No.");
                  ReturnShptLine.SetRange("Return Order Line No.","Line No.");
                end;
              "document type"::"Credit Memo":
                begin
                  ReturnShptLine.SetRange("Document No.","Return Shipment No.");
                  ReturnShptLine.SetRange("Line No.","Return Shipment Line No.");
                end;
            end;

            PurchRcptLine.SetFilter("Qty. Rcd. Not Invoiced",'<>0');
            if ReturnShptLine.Find('-') then
              repeat
                DimMgt.GetDimensionSet(TempPostedDimSetEntry,ReturnShptLine."Dimension Set ID");
                if not DimMgt.CheckDimIDConsistency(
                  TempDimSetEntry,TempPostedDimSetEntry,Database::"Purchase Line",Database::"Return Shipment Line")
                then
                  AddError(DimMgt.GetDocDimConsistencyErr);

                if ReturnShptLine."Buy-from Vendor No." <> "Buy-from Vendor No." then
                  AddError(
                    StrSubstNo(
                      Text036,
                      FieldCaption("Buy-from Vendor No.")));
                if ReturnShptLine.Type <> Type then
                  AddError(
                    StrSubstNo(
                      Text036,
                      FieldCaption(Type)));
                if ReturnShptLine."No." <> "No." then
                  AddError(
                    StrSubstNo(
                      Text036,
                      FieldCaption("No.")));
                if ReturnShptLine."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                  AddError(
                    StrSubstNo(
                      Text036,
                      FieldCaption("Gen. Bus. Posting Group")));
                if ReturnShptLine."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                  AddError(
                    StrSubstNo(
                      Text036,
                      FieldCaption("Gen. Prod. Posting Group")));
                if ReturnShptLine."Location Code" <> "Location Code" then
                  AddError(
                    StrSubstNo(
                      Text036,
                      FieldCaption("Location Code")));
                if ReturnShptLine."Job No." <> "Job No." then
                  AddError(
                    StrSubstNo(
                      Text036,
                      FieldCaption("Job No.")));

                if -PurchLine."Qty. to Invoice" * ReturnShptLine.Quantity < 0 then
                  AddError(StrSubstNo(Text025,FieldCaption("Qty. to Invoice")));
                QtyToBeInvoiced := RemQtyToBeInvoiced - PurchLine."Return Qty. to Ship";
                if Abs(QtyToBeInvoiced) > Abs(ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced") then
                  QtyToBeInvoiced := ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced";
                RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                ReturnShptLine."Quantity Invoiced" := ReturnShptLine."Quantity Invoiced" + QtyToBeInvoiced;
              until (ReturnShptLine.Next = 0) or (Abs(RemQtyToBeInvoiced) <= Abs("Return Qty. to Ship"))
            else
              AddError(
                StrSubstNo(
                  Text034,
                  "Return Shipment Line No.",
                  "Return Shipment No."));
          end;

          if Abs(RemQtyToBeInvoiced) > Abs("Return Qty. to Ship") then
            if "Document Type" = "document type"::"Credit Memo" then
              AddError(
                StrSubstNo(
                  Text038,
                  "Return Shipment No."));
        end;
    end;


    procedure TestJobFields(var PurchLine: Record "Purchase Line")
    var
        Job: Record Job;
        JT: Record "Job Task";
    begin
        with PurchLine do begin
          if "Job No." = '' then
            exit;
          if (Type <> Type::"G/L Account") and (Type <> Type::Item) then
            exit;
          if ("Document Type" <> "document type"::Invoice) and
             ("Document Type" <> "document type"::"Credit Memo")
          then
            exit;
          if not Job.Get("Job No.") then
            AddError(StrSubstNo(Text053,Job.TableCaption,"Job No."))
          else
            if Job.Blocked > Job.Blocked::" " then
              AddError(
                StrSubstNo(
                  Text041,Job.FieldCaption(Blocked),Job.Blocked,Job.TableCaption,"Job No."));

          if "Job Task No." = '' then
            AddError(StrSubstNo(Text006,FieldCaption("Job Task No.")))
          else
            if not JT.Get("Job No.","Job Task No.") then
              AddError(StrSubstNo(Text053,JT.TableCaption,"Job Task No."))
        end;
    end;

    local procedure IsInvtPosting(): Boolean
    var
        PurchLine: Record "Purchase Line";
    begin
        with "Purchase Header" do begin
          PurchLine.SetRange("Document Type","Document Type");
          PurchLine.SetRange("Document No.","No.");
          PurchLine.SetFilter(Type,'%1|%2',PurchLine.Type::Item,PurchLine.Type::"Charge (Item)");
          if PurchLine.IsEmpty then
            exit(false);
          if Receive then begin
            PurchLine.SetFilter("Qty. to Receive",'<>%1',0);
            if not PurchLine.IsEmpty then
              exit(true);
          end;
          if Ship then begin
            PurchLine.SetFilter("Return Qty. to Ship",'<>%1',0);
            if not PurchLine.IsEmpty then
              exit(true);
          end;
          if Invoice then begin
            PurchLine.SetFilter("Qty. to Invoice",'<>%1',0);
            if not PurchLine.IsEmpty then
              exit(true);
          end;
        end;
    end;


    procedure AddDimToTempLine(PurchLine: Record "Purchase Line";var TempDimSetEntry: Record "Dimension Set Entry")
    var
        SourceCodesetup: Record "Source Code Setup";
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        SourceCodesetup.Get;

        with PurchLine do begin
          TableID[1] := DimMgt.TypeToTableID3(Type);
          No[1] := "No.";
          TableID[2] := Database::Job;
          No[2] := "Job No.";
          TableID[3] := Database::"Responsibility Center";
          No[3] := "Responsibility Center";

          "Shortcut Dimension 1 Code" := '';
          "Shortcut Dimension 2 Code" := '';

          "Dimension Set ID" :=
            DimMgt.GetDefaultDimID(TableID,No,SourceCodesetup.Purchases,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
              PurchLine."Dimension Set ID",Database::Vendor);
        end;
    end;


    procedure InitializeRequest(NewReceiveShipOnNextPostReq: Boolean;NewInvOnNextPostReq: Boolean;NewShowDim: Boolean;NewShowItemChargeAssgnt: Boolean)
    begin
        ReceiveShipOnNextPostReq := NewReceiveShipOnNextPostReq;
        InvOnNextPostReq := NewInvOnNextPostReq;
        ShowDim := NewShowDim;
        ShowItemChargeAssgnt := NewShowItemChargeAssgnt;
    end;
}

