#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5915 "Service Document - Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service Document - Test.rdlc';
    Caption = 'Service Document - Test';

    dataset
    {
        dataitem("Service Header";"Service Header")
        {
            DataItemTableView = where("Document Type"=filter(<>Quote));
            RequestFilterFields = "Document Type","No.";
            RequestFilterHeading = 'Service Document';
            column(ReportForNavId_1634; 1634)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(Service_Document___TestCaption;Service_Document___TestCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            dataitem(PageCounter;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_8098; 8098)
                {
                }
                column(STRSUBSTNO_Text014_ServiceHeaderFilter_;StrSubstNo(Text014,ServiceHeaderFilter))
                {
                }
                column(ShowServiceHeaderFilter;ServiceHeaderFilter)
                {
                }
                column(ShipInvText;ShipInvText)
                {
                }
                column(ReceiveInvText;ReceiveInvText)
                {
                }
                column(Service_Header___Customer_No__;"Service Header"."Customer No.")
                {
                }
                column(ShipToAddr_8_;ShipToAddr[8])
                {
                }
                column(ShipToAddr_7_;ShipToAddr[7])
                {
                }
                column(ShipToAddr_6_;ShipToAddr[6])
                {
                }
                column(ShipToAddr_5_;ShipToAddr[5])
                {
                }
                column(ShipToAddr_4_;ShipToAddr[4])
                {
                }
                column(ShipToAddr_3_;ShipToAddr[3])
                {
                }
                column(ShipToAddr_2_;ShipToAddr[2])
                {
                }
                column(ShipToAddr_1_;ShipToAddr[1])
                {
                }
                column(Service_Header___Ship_to_Code_;"Service Header"."Ship-to Code")
                {
                }
                column(FORMAT__Service_Header___Document_Type____________Service_Header___No__;Format("Service Header"."Document Type") + ' ' + "Service Header"."No.")
                {
                }
                column(FORMAT__Service_Header___Prices_Including_VAT__;Format("Service Header"."Prices Including VAT"))
                {
                }
                column(BillToAddr_8_;BillToAddr[8])
                {
                }
                column(BillToAddr_7_;BillToAddr[7])
                {
                }
                column(BillToAddr_6_;BillToAddr[6])
                {
                }
                column(BillToAddr_5_;BillToAddr[5])
                {
                }
                column(BillToAddr_4_;BillToAddr[4])
                {
                }
                column(BillToAddr_3_;BillToAddr[3])
                {
                }
                column(BillToAddr_2_;BillToAddr[2])
                {
                }
                column(BillToAddr_1_;BillToAddr[1])
                {
                }
                column(Service_Header___Bill_to_Customer_No__;"Service Header"."Bill-to Customer No.")
                {
                }
                column(ShowBillAddrInfo;"Service Header"."Bill-to Customer No." <> "Service Header"."Customer No.")
                {
                }
                column(Service_Header___Salesperson_Code_;"Service Header"."Salesperson Code")
                {
                }
                column(Service_Header___Your_Reference_;"Service Header"."Your Reference")
                {
                }
                column(Service_Header___Customer_Posting_Group_;"Service Header"."Customer Posting Group")
                {
                }
                column(Service_Header___Posting_Date_;Format("Service Header"."Posting Date"))
                {
                }
                column(Service_Header___Document_Date_;Format("Service Header"."Document Date"))
                {
                }
                column(Service_Header___Prices_Including_VAT_;"Service Header"."Prices Including VAT")
                {
                }
                column(ShowQuote;"Service Header"."Document Type" = "Service Header"."document type"::Quote)
                {
                }
                column(Service_Header___Payment_Terms_Code_;"Service Header"."Payment Terms Code")
                {
                }
                column(Service_Header___Payment_Discount___;"Service Header"."Payment Discount %")
                {
                }
                column(Service_Header___Due_Date_;Format("Service Header"."Due Date"))
                {
                }
                column(Service_Header___Customer_Disc__Group_;"Service Header"."Customer Disc. Group")
                {
                }
                column(Service_Header___Pmt__Discount_Date_;Format("Service Header"."Pmt. Discount Date"))
                {
                }
                column(Service_Header___Invoice_Disc__Code_;"Service Header"."Invoice Disc. Code")
                {
                }
                column(Service_Header___Payment_Method_Code_;"Service Header"."Payment Method Code")
                {
                }
                column(Service_Header___Posting_Date__Control105;Format("Service Header"."Posting Date"))
                {
                }
                column(Service_Header___Document_Date__Control106;Format("Service Header"."Document Date"))
                {
                }
                column(Service_Header___Order_Date_;Format("Service Header"."Order Date"))
                {
                }
                column(Service_Header___Prices_Including_VAT__Control194;"Service Header"."Prices Including VAT")
                {
                }
                column(ShowOrder;"Service Header"."Document Type" = "Service Header"."document type"::Order)
                {
                }
                column(Service_Header___Payment_Terms_Code__Control18;"Service Header"."Payment Terms Code")
                {
                }
                column(Service_Header___Due_Date__Control19;Format("Service Header"."Due Date"))
                {
                }
                column(Service_Header___Pmt__Discount_Date__Control22;Format("Service Header"."Pmt. Discount Date"))
                {
                }
                column(Service_Header___Payment_Discount____Control23;"Service Header"."Payment Discount %")
                {
                }
                column(Service_Header___Payment_Method_Code__Control26;"Service Header"."Payment Method Code")
                {
                }
                column(Service_Header___Customer_Disc__Group__Control100;"Service Header"."Customer Disc. Group")
                {
                }
                column(Service_Header___Invoice_Disc__Code__Control102;"Service Header"."Invoice Disc. Code")
                {
                }
                column(Service_Header___Customer_Posting_Group__Control130;"Service Header"."Customer Posting Group")
                {
                }
                column(Service_Header___Posting_Date__Control131;Format("Service Header"."Posting Date"))
                {
                }
                column(Service_Header___Document_Date__Control132;Format("Service Header"."Document Date"))
                {
                }
                column(Service_Header___Prices_Including_VAT__Control196;"Service Header"."Prices Including VAT")
                {
                }
                column(ShowInvoice;"Service Header"."Document Type" = "Service Header"."document type"::Invoice)
                {
                }
                column(Service_Header___Applies_to_Doc__Type_;"Service Header"."Applies-to Doc. Type")
                {
                }
                column(Service_Header___Applies_to_Doc__No__;"Service Header"."Applies-to Doc. No.")
                {
                }
                column(Service_Header___Customer_Posting_Group__Control136;"Service Header"."Customer Posting Group")
                {
                }
                column(Service_Header___Posting_Date__Control137;Format("Service Header"."Posting Date"))
                {
                }
                column(Service_Header___Document_Date__Control138;Format("Service Header"."Document Date"))
                {
                }
                column(Service_Header___Prices_Including_VAT__Control198;"Service Header"."Prices Including VAT")
                {
                }
                column(ShowCreditMemo;"Service Header"."Document Type" = "Service Header"."document type"::"Credit Memo")
                {
                }
                column(Service_Header___Customer_No__Caption;"Service Header".FieldCaption("Customer No."))
                {
                }
                column(Ship_toCaption;Ship_toCaptionLbl)
                {
                }
                column(CustomerCaption;CustomerCaptionLbl)
                {
                }
                column(Service_Header___Ship_to_Code_Caption;"Service Header".FieldCaption("Ship-to Code"))
                {
                }
                column(Bill_toCaption;Bill_toCaptionLbl)
                {
                }
                column(Service_Header___Bill_to_Customer_No__Caption;"Service Header".FieldCaption("Bill-to Customer No."))
                {
                }
                column(Service_Header___Salesperson_Code_Caption;"Service Header".FieldCaption("Salesperson Code"))
                {
                }
                column(Service_Header___Your_Reference_Caption;"Service Header".FieldCaption("Your Reference"))
                {
                }
                column(Service_Header___Customer_Posting_Group_Caption;"Service Header".FieldCaption("Customer Posting Group"))
                {
                }
                column(Service_Header___Posting_Date_Caption;Service_Header___Posting_Date_CaptionLbl)
                {
                }
                column(Service_Header___Document_Date_Caption;Service_Header___Document_Date_CaptionLbl)
                {
                }
                column(Service_Header___Prices_Including_VAT_Caption;"Service Header".FieldCaption("Prices Including VAT"))
                {
                }
                column(Service_Header___Payment_Terms_Code_Caption;"Service Header".FieldCaption("Payment Terms Code"))
                {
                }
                column(Service_Header___Payment_Discount___Caption;"Service Header".FieldCaption("Payment Discount %"))
                {
                }
                column(Service_Header___Due_Date_Caption;Service_Header___Due_Date_CaptionLbl)
                {
                }
                column(Service_Header___Customer_Disc__Group_Caption;"Service Header".FieldCaption("Customer Disc. Group"))
                {
                }
                column(Service_Header___Pmt__Discount_Date_Caption;Service_Header___Pmt__Discount_Date_CaptionLbl)
                {
                }
                column(Service_Header___Invoice_Disc__Code_Caption;"Service Header".FieldCaption("Invoice Disc. Code"))
                {
                }
                column(Service_Header___Payment_Method_Code_Caption;"Service Header".FieldCaption("Payment Method Code"))
                {
                }
                column(Service_Header___Posting_Date__Control105Caption;Service_Header___Posting_Date__Control105CaptionLbl)
                {
                }
                column(Service_Header___Document_Date__Control106Caption;Service_Header___Document_Date__Control106CaptionLbl)
                {
                }
                column(Service_Header___Order_Date_Caption;Service_Header___Order_Date_CaptionLbl)
                {
                }
                column(Service_Header___Prices_Including_VAT__Control194Caption;"Service Header".FieldCaption("Prices Including VAT"))
                {
                }
                column(Service_Header___Payment_Terms_Code__Control18Caption;"Service Header".FieldCaption("Payment Terms Code"))
                {
                }
                column(Service_Header___Payment_Discount____Control23Caption;"Service Header".FieldCaption("Payment Discount %"))
                {
                }
                column(Service_Header___Due_Date__Control19Caption;Service_Header___Due_Date__Control19CaptionLbl)
                {
                }
                column(Service_Header___Pmt__Discount_Date__Control22Caption;Service_Header___Pmt__Discount_Date__Control22CaptionLbl)
                {
                }
                column(Service_Header___Payment_Method_Code__Control26Caption;"Service Header".FieldCaption("Payment Method Code"))
                {
                }
                column(Service_Header___Customer_Disc__Group__Control100Caption;"Service Header".FieldCaption("Customer Disc. Group"))
                {
                }
                column(Service_Header___Invoice_Disc__Code__Control102Caption;"Service Header".FieldCaption("Invoice Disc. Code"))
                {
                }
                column(Service_Header___Customer_Posting_Group__Control130Caption;"Service Header".FieldCaption("Customer Posting Group"))
                {
                }
                column(Service_Header___Posting_Date__Control131Caption;Service_Header___Posting_Date__Control131CaptionLbl)
                {
                }
                column(Service_Header___Document_Date__Control132Caption;Service_Header___Document_Date__Control132CaptionLbl)
                {
                }
                column(Service_Header___Prices_Including_VAT__Control196Caption;"Service Header".FieldCaption("Prices Including VAT"))
                {
                }
                column(Service_Header___Applies_to_Doc__Type_Caption;"Service Header".FieldCaption("Applies-to Doc. Type"))
                {
                }
                column(Service_Header___Applies_to_Doc__No__Caption;"Service Header".FieldCaption("Applies-to Doc. No."))
                {
                }
                column(Service_Header___Customer_Posting_Group__Control136Caption;"Service Header".FieldCaption("Customer Posting Group"))
                {
                }
                column(Service_Header___Posting_Date__Control137Caption;Service_Header___Posting_Date__Control137CaptionLbl)
                {
                }
                column(Service_Header___Document_Date__Control138Caption;Service_Header___Document_Date__Control138CaptionLbl)
                {
                }
                column(Service_Header___Prices_Including_VAT__Control198Caption;"Service Header".FieldCaption("Prices Including VAT"))
                {
                }
                column(SellToAddr_1_;SellToAddr[1])
                {
                }
                column(SellToAddr_2_;SellToAddr[2])
                {
                }
                column(SellToAddr_3_;SellToAddr[3])
                {
                }
                column(SellToAddr_4_;SellToAddr[4])
                {
                }
                column(SellToAddr_5_;SellToAddr[5])
                {
                }
                column(SellToAddr_6_;SellToAddr[6])
                {
                }
                column(SellToAddr_7_;SellToAddr[7])
                {
                }
                column(SellToAddr_8_;SellToAddr[8])
                {
                }
                dataitem(DimensionLoop1;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_7574; 7574)
                    {
                    }
                    column(DimText;DimText)
                    {
                    }
                    column(Header_DimensionsCaption;Header_DimensionsCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        DimText := DimTxtArr[Number];
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not ShowDim then
                          CurrReport.Break;
                        FindDimTxt("Service Header"."Dimension Set ID");
                        SetRange(Number,1,DimTxtArrLength);
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
                    dataitem("Service Line";"Service Line")
                    {
                        DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                        DataItemLinkReference = "Service Header";
                        DataItemTableView = sorting("Document Type","Document No.","Line No.");
                        column(ReportForNavId_6560; 6560)
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
                        column(Service_Line__Type;"Service Line".Type)
                        {
                        }
                        column(Service_Line___No__;"Service Line"."No.")
                        {
                        }
                        column(Service_Line__Description;"Service Line".Description)
                        {
                        }
                        column(Service_Line__Quantity;"Service Line".Quantity)
                        {
                        }
                        column(QtyToHandle;QtyToHandle)
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(Service_Line___Qty__to_Invoice_;"Service Line"."Qty. to Invoice")
                        {
                        }
                        column(Service_Line___Unit_Price_;"Service Line"."Unit Price")
                        {
                            AutoFormatExpression = "Service Line"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(Service_Line___Line_Discount___;"Service Line"."Line Discount %")
                        {
                        }
                        column(Service_Line___Line_Amount_;"Service Line"."Line Amount")
                        {
                            AutoFormatExpression = "Service Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Service_Line___Allow_Invoice_Disc__;"Service Line"."Allow Invoice Disc.")
                        {
                        }
                        column(Service_Line___VAT_Identifier_;"Service Line"."VAT Identifier")
                        {
                        }
                        column(FORMAT__Service_Line___Allow_Invoice_Disc___;Format("Service Line"."Allow Invoice Disc."))
                        {
                        }
                        column(ServiceLineLineNo;ServiceLine."Line No.")
                        {
                        }
                        column(SumLineAmount;SumLineAmount)
                        {
                        }
                        column(SumInvDiscountAmount;SumInvDiscountAmount)
                        {
                        }
                        column(TempServiceLine__Inv__Discount_Amount_;-TempServiceLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TempServiceLine__Line_Amount_;TempServiceLine."Line Amount")
                        {
                            AutoFormatExpression = "Service Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText;TotalText)
                        {
                        }
                        column(TempServiceLine__Line_Amount_____Service_Line___Inv__Discount_Amount_;TempServiceLine."Line Amount" - TempServiceLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(ShowRoundLoop5;VATAmount = 0)
                        {
                        }
                        column(TotalExclVATText;TotalExclVATText)
                        {
                        }
                        column(VATAmountLine_VATAmountText;VATAmountLine.VATAmountText)
                        {
                        }
                        column(TempServiceLine__Line_Amount____TempServiceLine__Inv__Discount_Amount_;TempServiceLine."Line Amount" - TempServiceLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmount;VATAmount)
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TempServiceLine__Line_Amount____TempServiceLine__Inv__Discount_Amount____VATAmount;TempServiceLine."Line Amount" - TempServiceLine."Inv. Discount Amount" + VATAmount)
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText;TotalInclVATText)
                        {
                        }
                        column(ShowRoundLoop6;not "Service Header"."Prices Including VAT" and (VATAmount <> 0))
                        {
                        }
                        column(VATDiscountAmount;-VATDiscountAmount)
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(ShowRoundLoop7;"Service Header"."Prices Including VAT" and (VATAmount <> 0) and ("Service Header"."VAT Base Discount %" <> 0))
                        {
                        }
                        column(VATBaseAmount___VATAmount;VATBaseAmount + VATAmount)
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseAmount;VATBaseAmount)
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(ShowRoundLoop8;"Service Header"."Prices Including VAT" and (VATAmount <> 0))
                        {
                        }
                        column(Service_Line___No__Caption;"Service Line".FieldCaption("No."))
                        {
                        }
                        column(Service_Line__DescriptionCaption;"Service Line".FieldCaption(Description))
                        {
                        }
                        column(Service_Line___Qty__to_Invoice_Caption;"Service Line".FieldCaption("Qty. to Invoice"))
                        {
                        }
                        column(Unit_PriceCaption;Unit_PriceCaptionLbl)
                        {
                        }
                        column(Service_Line___Line_Discount___Caption;Service_Line___Line_Discount___CaptionLbl)
                        {
                        }
                        column(Service_Line___Allow_Invoice_Disc__Caption;"Service Line".FieldCaption("Allow Invoice Disc."))
                        {
                        }
                        column(Service_Line___VAT_Identifier_Caption;"Service Line".FieldCaption("VAT Identifier"))
                        {
                        }
                        column(AmountCaption;AmountCaptionLbl)
                        {
                        }
                        column(Service_Line__TypeCaption;"Service Line".FieldCaption(Type))
                        {
                        }
                        column(Service_Line__QuantityCaption;Service_Line__QuantityCaptionLbl)
                        {
                        }
                        column(QtyToHandleCaption;QtyToHandleCaptionLbl)
                        {
                        }
                        column(TempServiceLine__Inv__Discount_Amount_Caption;TempServiceLine__Inv__Discount_Amount_CaptionLbl)
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
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_3591; 3591)
                            {
                            }
                            column(DimText_Control159;DimText)
                            {
                            }
                            column(Line_DimensionsCaption;Line_DimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                DimText := DimTxtArr[Number];
                            end;

                            trigger OnPostDataItem()
                            begin
                                SumLineAmount := SumLineAmount + TempServiceLine."Line Amount";
                                SumInvDiscountAmount := SumInvDiscountAmount + TempServiceLine."Inv. Discount Amount";
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowDim then
                                  CurrReport.Break;
                                FindDimTxt("Service Line"."Dimension Set ID");
                                SetRange(Number,1,DimTxtArrLength);
                            end;
                        }
                        dataitem(LineErrorCounter;"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_2217; 2217)
                            {
                            }
                            column(ErrorText_Number__Control97;ErrorText[Number])
                            {
                            }
                            column(ErrorText_Number__Control97Caption;ErrorText_Number__Control97CaptionLbl)
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
                        begin
                            if Number = 1 then
                              TempServiceLine.Find('-')
                            else
                              TempServiceLine.Next;
                            "Service Line" := TempServiceLine;

                            with "Service Line" do begin
                              if SalesTax and not HeaderTaxArea."Use External Tax Engine" then
                                SalesTaxCalculate.AddServiceLine("Service Line");

                              if not "Service Header"."Prices Including VAT" and
                                 ("VAT Calculation Type" = "vat calculation type"::"Full VAT")
                              then
                                TempServiceLine."Line Amount" := 0;

                              TempDimSetEntry.SetRange("Dimension Set ID","Dimension Set ID");
                              if "Document Type" = "document type"::"Credit Memo"
                              then begin
                                if "Document Type" = "document type"::"Credit Memo" then begin
                                  if "Qty. to Invoice" <> Quantity then
                                    AddError(StrSubstNo(Text015,FieldCaption("Qty. to Invoice"),Quantity));
                                end;
                                if "Qty. to Ship" <> 0 then
                                  AddError(StrSubstNo(Text043,FieldCaption("Qty. to Ship")));
                              end else
                                if "Document Type" = "document type"::Invoice then begin
                                  if ("Qty. to Ship" <> Quantity) and ("Shipment No." = '') then
                                    AddError(StrSubstNo(Text015,FieldCaption("Qty. to Ship"),Quantity));
                                  if "Qty. to Invoice" <> Quantity then
                                    AddError(StrSubstNo(Text015,FieldCaption("Qty. to Invoice"),Quantity));
                                end;

                              if not Ship then
                                "Qty. to Ship" := 0;

                              if ("Document Type" = "document type"::Invoice) and ("Shipment No." <> '') then begin
                                "Quantity Shipped" := Quantity;
                                "Qty. to Ship" := 0;
                              end;

                              if Invoice then begin
                                if "Document Type" = "document type"::"Credit Memo" then
                                  MaxQtyToBeInvoiced := Quantity
                                else
                                  MaxQtyToBeInvoiced := "Qty. to Ship" + "Quantity Shipped" - "Quantity Invoiced";
                                if Abs("Qty. to Invoice") > Abs(MaxQtyToBeInvoiced) then
                                  "Qty. to Invoice" := MaxQtyToBeInvoiced;
                              end else
                                "Qty. to Invoice" := 0;

                              if "Gen. Prod. Posting Group" <> '' then begin
                                if ("Service Header"."Document Type" = "Service Header"."document type"::"Credit Memo") and
                                   ("Service Header"."Applies-to Doc. Type" = "Service Header"."applies-to doc. type"::Invoice) and
                                   ("Service Header"."Applies-to Doc. No." <> '')
                                then begin
                                  CustLedgEntry.SetCurrentkey("Document No.");
                                  CustLedgEntry.SetRange("Customer No.","Service Header"."Bill-to Customer No.");
                                  CustLedgEntry.SetRange("Document Type",CustLedgEntry."document type"::Invoice);
                                  CustLedgEntry.SetRange("Document No.","Service Header"."Applies-to Doc. No.");
                                  if not CustLedgEntry.FindLast and not ApplNoError then begin
                                    ApplNoError := true;
                                    AddError(
                                      StrSubstNo(
                                        Text016,
                                        "Service Header".FieldCaption("Applies-to Doc. No."),"Service Header"."Applies-to Doc. No."));
                                  end;
                                end;

                                if not VATPostingSetup.Get("VAT Bus. Posting Group","VAT Prod. Posting Group") then
                                  AddError(
                                    StrSubstNo(
                                      Text017,
                                      VATPostingSetup.TableCaption,"VAT Bus. Posting Group","VAT Prod. Posting Group"));
                                if VATPostingSetup."VAT Calculation Type" = VATPostingSetup."vat calculation type"::"Reverse Charge VAT" then
                                  if ("Service Header"."VAT Registration No." = '') and not VATNoError then begin
                                    VATNoError := true;
                                    AddError(
                                      StrSubstNo(
                                        Text035,"Service Header".FieldCaption("VAT Registration No.")));
                                  end;
                              end;

                              if Quantity <> 0 then begin
                                if "No." = '' then
                                  AddError(StrSubstNo(Text019,Type,FieldCaption("No.")));
                                if Type = 0 then
                                  AddError(StrSubstNo(Text006,FieldCaption(Type)));
                              end else
                                if Amount <> 0 then
                                  AddError(
                                    StrSubstNo(Text020,FieldCaption(Amount),FieldCaption(Quantity)));

                              ServiceLine := "Service Line";
                              if not ("Document Type" = "document type"::"Credit Memo") then begin
                                ServiceLine."Qty. to Ship" := -ServiceLine."Qty. to Ship";
                                ServiceLine."Qty. to Invoice" := -ServiceLine."Qty. to Invoice";
                              end;

                              RemQtyToBeInvoiced := ServiceLine."Qty. to Invoice";

                              case "Document Type" of
                                "document type"::Order,"document type"::Invoice:
                                  CheckShptLines("Service Line");
                              end;

                              if (Type >= Type::"G/L Account") and ("Qty. to Invoice" <> 0) then begin
                                if not GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group") then
                                  AddError(
                                    StrSubstNo(
                                      Text017,
                                      GenPostingSetup.TableCaption,"Gen. Bus. Posting Group","Gen. Prod. Posting Group"));
                                if not VATPostingSetup.Get("VAT Bus. Posting Group","VAT Prod. Posting Group") then
                                  AddError(
                                    StrSubstNo(
                                      Text017,
                                      VATPostingSetup.TableCaption,"VAT Bus. Posting Group","VAT Prod. Posting Group"));
                              end;

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
                                        if Item.Reserve = Item.Reserve::Always then begin
                                          CalcFields("Reserved Quantity");
                                          if "Document Type" = "document type"::"Credit Memo" then begin
                                            if (SignedXX(Quantity) < 0) and (Abs("Reserved Quantity") < Abs(Quantity)) then
                                              AddError(
                                                StrSubstNo(
                                                  Text015,
                                                  FieldCaption("Reserved Quantity"),SignedXX(Quantity)));
                                          end else
                                            if (SignedXX(Quantity) < 0) and (Abs("Reserved Quantity") < Abs("Qty. to Ship")) then
                                              AddError(
                                                StrSubstNo(
                                                  Text015,
                                                  FieldCaption("Reserved Quantity"),SignedXX("Qty. to Ship")));
                                        end
                                      end else
                                        AddError(
                                          StrSubstNo(
                                            Text008,
                                            Item.TableCaption,"No."));
                                  end;
                                Type::Resource:
                                  begin
                                    if ("No." = '') and (Quantity = 0) then
                                      exit;

                                    if "No." <> '' then
                                      if Res.Get("No.") then begin
                                        if Res.Blocked then
                                          AddError(
                                            StrSubstNo(
                                              Text007,
                                              Res.FieldCaption(Blocked),false,Res.TableCaption,"No."));
                                      end else
                                        AddError(
                                          StrSubstNo(
                                            Text008,
                                            Res.TableCaption,"No."));
                                  end;
                              end;

                              if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                                AddError(DimMgt.GetDimCombErr);

                              TableID[1] := DimMgt.TypeToTableID3(Type);
                              No[1] := "No.";
                              TableID[2] := Database::Job;
                              No[2] := "Job No.";
                              if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
                                AddError(DimMgt.GetDimValuePostingErr);
                              if "Line No." > OrigMaxLineNo then begin
                                "No." := '';
                                Type := Type::" ";
                              end;
                              if "Line No." = OrigMaxLineNo then begin
                                if SalesTax then begin
                                  if HeaderTaxArea."Use External Tax Engine" then
                                    SalesTaxCalculate.CallExternalTaxEngineForServ("Service Header",true)
                                  else
                                    SalesTaxCalculate.EndSalesTaxCalculation("Service Header"."Posting Date");
                                  SalesTaxCalculate.GetSalesTaxAmountLineTable(SalesTaxAmountLine);
                                  VATAmount := SalesTaxAmountLine.GetTotalTaxAmountFCY;
                                  VATBaseAmount := SalesTaxAmountLine.GetTotalTaxBase;
                                  TaxText := SalesTaxAmountLine.TaxAmountText;
                                end else
                                  TaxText := VATAmountLine.VATAmountText;
                              end;
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATNoError := false;
                            ApplNoError := false;
                            CurrReport.CreateTotals(TempServiceLine."Line Amount",TempServiceLine."Inv. Discount Amount");

                            MoreLines := TempServiceLine.Find('+');
                            while MoreLines and (TempServiceLine.Description = '') and (TempServiceLine."Description 2" = '') and
                                  (TempServiceLine."No." = '') and (TempServiceLine.Quantity = 0) and
                                  (TempServiceLine.Amount = 0)
                            do
                              MoreLines := TempServiceLine.Next(-1) <> 0;
                            if not MoreLines then
                              CurrReport.Break;
                            TempServiceLine.SetRange("Line No.",0,TempServiceLine."Line No.");
                            SetRange(Number,1,TempServiceLine.Count);

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
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base_;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Service Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount_;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount_;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount_;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control150;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base__Control151;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Service Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT___;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmountLine__VAT_Identifier_;VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control173;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control171;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount__Control169;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control181;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base__Control182;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Service Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control183;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control184;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control150Caption;VATAmountLine__VAT_Amount__Control150CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Base__Control151Caption;VATAmountLine__VAT_Base__Control151CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT___Caption;VATAmountLine__VAT___CaptionLbl)
                        {
                        }
                        column(VAT_Amount_SpecificationCaption;VAT_Amount_SpecificationCaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Identifier_Caption;VATAmountLine__VAT_Identifier_CaptionLbl)
                        {
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control173Caption;VATAmountLine__Invoice_Discount_Amount__Control173CaptionLbl)
                        {
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control171Caption;VATAmountLine__Inv__Disc__Base_Amount__Control171CaptionLbl)
                        {
                        }
                        column(VATAmountLine__Line_Amount__Control169Caption;VATAmountLine__Line_Amount__Control169CaptionLbl)
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
                            if SalesTax then
                              CurrReport.Break;
                            if VATAmount = 0 then
                              CurrReport.Break;
                            SetRange(Number,1,VATAmountLine.Count);
                            CurrReport.CreateTotals(
                              VATAmountLine."VAT Base",VATAmountLine."VAT Amount",VATAmountLine."Amount Including VAT",
                              VATAmountLine."Line Amount",VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount");
                        end;
                    }
                    dataitem(SalesTaxCounter;"Integer")
                    {
                        column(ReportForNavId_5927; 5927)
                        {
                        }
                        column(SalesTaxAmountLine__Tax_Amount_;SalesTaxAmountLine."Tax Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesTaxAmountLine__Tax_Area_Code_for_Key_;SalesTaxAmountLine."Tax Area Code for Key")
                        {
                        }
                        column(SalesTaxAmountLine__Tax___;SalesTaxAmountLine."Tax %")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesTaxAmountLine__Inv__Disc__Base_Amount_;SalesTaxAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesTaxAmountLine__Invoice_Discount_Amount_;SalesTaxAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesTaxAmountLine__Tax_Base_Amount_;SalesTaxAmountLine."Tax Base Amount")
                        {
                            AutoFormatExpression = "Service Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesTaxAmountLine__Tax_Amount__Control1020016;SalesTaxAmountLine."Tax Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesTax_;SalesTax)
                        {
                        }
                        column(SalesTaxAmountLine__Tax_Amount__Control1020010;SalesTaxAmountLine."Tax Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SumtotalVAT_;SumtotalVAT)
                        {
                        }
                        column(SumtotalExchFactor_;ExchangeFactor)
                        {
                        }
                        column(SalesTaxAmountLine__Tax_Amount__Control1020018;SalesTaxAmountLine."Tax Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(ServiceHeader_CurrCode_;"Service Header"."Currency Code")
                        {
                        }
                        column(SalesTaxAmountLine__Tax_Amount__Control1020020;SalesTaxAmountLine."Tax Amount")
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Total______Service_Header___Currency_Code_;'Total ' + "Service Header"."Currency Code")
                        {
                        }
                        column(SalesTaxAmountLine__Tax_Amount____ExchangeFactor;SalesTaxAmountLine.GetTotalTaxAmountFCY)
                        {
                            AutoFormatExpression = "Service Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesTaxCounter_Number;Number)
                        {
                        }
                        column(Sales_Tax_AmountsCaption;Sales_Tax_AmountsCaptionLbl)
                        {
                        }
                        column(Tax_Area_CodeCaption;Tax_Area_CodeCaptionLbl)
                        {
                        }
                        column(Tax__Caption;Tax__CaptionLbl)
                        {
                        }
                        column(Inv__Disc__Base_AmountCaption;Inv__Disc__Base_AmountCaptionLbl)
                        {
                        }
                        column(Invoice_Discount_AmountCaption;Invoice_Discount_AmountCaptionLbl)
                        {
                        }
                        column(Tax_Base_AmountCaption;Tax_Base_AmountCaptionLbl)
                        {
                        }
                        column(Tax_AmountCaption;Tax_AmountCaptionLbl)
                        {
                        }
                        column(ContinuedCaption_Control1020007;ContinuedCaption_Control1020007Lbl)
                        {
                        }
                        column(ContinuedCaption_Control1020009;ContinuedCaption_Control1020009Lbl)
                        {
                        }
                        column(TotalCaption_Control1020017;TotalCaption_Control1020017Lbl)
                        {
                        }
                        column(TotalCaption_Control1020019;TotalCaption_Control1020019Lbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                              SalesTaxAmountLine.FindFirst
                            else
                              SalesTaxAmountLine.Next;

                            if SalesTax and (SalesTaxAmountLine."Tax Amount" <> 0) then
                              SumtotalVAT := SumtotalVAT + SalesTaxAmountLine."Tax Amount";

                            SumtotalExchFactor := SalesTaxAmountLine.GetTotalTaxAmountFCY;
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

                            SumtotalVAT := 0;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(TempServiceLine);
                        Clear(ServAmountsMgt);
                        VATAmountLine.DeleteAll;
                        TempServiceLine.DeleteAll;

                        ServAmountsMgt.GetServiceLines("Service Header",TempServiceLine,1);

                        // Ship prm added
                        TempServiceLine.CalcVATAmountLines(0,"Service Header",TempServiceLine,VATAmountLine,Ship);
                        TempServiceLine.UpdateVATOnLines(0,"Service Header",TempServiceLine,VATAmountLine);
                        VATAmount := VATAmountLine.GetTotalVATAmount;
                        VATBaseAmount := VATAmountLine.GetTotalVATBase;
                        VATDiscountAmount :=
                          VATAmountLine.GetTotalVATDiscount("Service Header"."Currency Code","Service Header"."Prices Including VAT");
                        if SalesTax then begin
                          SalesTaxAmountLine.DeleteAll;
                          SalesTaxCalculate.StartSalesTaxCalculation;
                        end;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            var
                TableID: array [10] of Integer;
                No: array [10] of Code[20];
                ShipQtyExist: Boolean;
            begin
                FormatAddr.ServiceHeaderSellTo(SellToAddr,"Service Header");
                FormatAddr.ServiceHeaderBillTo(BillToAddr,"Service Header");
                FormatAddr.ServiceHeaderShipTo(ShipToAddr,"Service Header");
                if "Currency Code" = '' then begin
                  GLSetup.TestField("LCY Code");
                  TotalText := StrSubstNo(Text004,GLSetup."LCY Code");
                  TotalExclVATText := StrSubstNo(Text033,GLSetup."LCY Code");
                  TotalInclVATText := StrSubstNo(Text005,GLSetup."LCY Code");
                  ExchangeFactor := 1;
                end else begin
                  TotalText := StrSubstNo(Text004,"Currency Code");
                  TotalExclVATText := StrSubstNo(Text033,"Currency Code");
                  TotalInclVATText := StrSubstNo(Text005,"Currency Code");
                  ExchangeFactor := "Currency Factor";
                end;

                Invoice := InvOnNextPostReq;
                Ship := ShipReceiveOnNextPostReq;

                SalesTax := "Tax Area Code" <> '';
                if SalesTax then
                  HeaderTaxArea.Get("Tax Area Code");

                if "Customer No." = '' then
                  AddError(StrSubstNo(Text006,FieldCaption("Customer No.")))
                else begin
                  if Cust.Get("Customer No.") then begin
                    if (Cust.Blocked = Cust.Blocked::Ship) and Ship then begin
                      ServiceLine2.SetRange("Document Type",ServiceHeader."Document Type");
                      ServiceLine2.SetRange("Document No.",ServiceHeader."No.");
                      ServiceLine2.SetFilter("Qty. to Ship",'>0');
                      if ServiceLine2.FindFirst then
                        ShipQtyExist := true;
                    end;
                    if (Cust.Blocked = Cust.Blocked::All) or
                       ((Cust.Blocked = Cust.Blocked::Invoice) and
                        (not ("Document Type" = "document type"::"Credit Memo"))) or
                       ShipQtyExist
                    then
                      AddError(
                        StrSubstNo(
                          Text045,
                          Cust.FieldCaption(Blocked),Cust.Blocked,Cust.TableCaption,"Customer No."));
                  end else
                    AddError(
                      StrSubstNo(
                        Text008,
                        Cust.TableCaption,"Customer No."));
                end;

                if "Bill-to Customer No." = '' then
                  AddError(StrSubstNo(Text006,FieldCaption("Bill-to Customer No.")))
                else begin
                  if "Bill-to Customer No." <> "Customer No." then
                    if Cust.Get("Bill-to Customer No.") then begin
                      if (Cust.Blocked = Cust.Blocked::All) or
                         ((Cust.Blocked = Cust.Blocked::Invoice) and
                          ("Document Type" = "document type"::"Credit Memo"))
                      then
                        AddError(
                          StrSubstNo(
                            Text045,
                            Cust.FieldCaption(Blocked),false,Cust.TableCaption,"Bill-to Customer No."));
                    end else
                      AddError(
                        StrSubstNo(
                          Text008,
                          Cust.TableCaption,"Bill-to Customer No."));
                end;

                ServiceSetup.Get;

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
                      AddError(
                        StrSubstNo(
                          Text010,FieldCaption("Posting Date")));
                  end;

                if "Document Date" <> 0D then
                  if "Document Date" <> NormalDate("Document Date") then
                    AddError(StrSubstNo(Text009,FieldCaption("Document Date")));

                case "Document Type" of
                  "document type"::Invoice:
                    begin
                      Ship := true;
                      Invoice := true;
                    end;
                  "document type"::"Credit Memo":
                    begin
                      Ship := false;
                      Invoice := true;
                    end;
                end;

                if not (Ship or Invoice) then
                  AddError(
                    StrSubstNo(
                      Text034,
                      Text001,Text002));

                if Invoice then begin
                  ServiceLine.Reset;
                  ServiceLine.SetRange("Document Type","Document Type");
                  ServiceLine.SetRange("Document No.","No.");
                  ServiceLine.SetFilter(Quantity,'<>0');
                  if "Document Type" = "document type"::Order then
                    ServiceLine.SetFilter("Qty. to Invoice",'<>0');
                  Invoice := ServiceLine.Find('-');
                  if Invoice and not Ship and ("Document Type" = "document type"::Order) then begin
                    Invoice := false;
                    repeat
                      Invoice := (ServiceLine."Quantity Shipped" - ServiceLine."Quantity Invoiced") <> 0;
                    until Invoice or (ServiceLine.Next = 0);
                  end;
                end;

                if Ship then begin
                  ServiceLine.Reset;
                  ServiceLine.SetRange("Document Type","Document Type");
                  ServiceLine.SetRange("Document No.","No.");
                  ServiceLine.SetFilter(Quantity,'<>0');
                  if "Document Type" = "document type"::Order then
                    ServiceLine.SetFilter("Qty. to Ship",'<>0');
                  ServiceLine.SetRange("Shipment No.",'');
                  Ship := ServiceLine.Find('-');
                end;

                if not (Ship or Invoice) then
                  AddError(Text012);

                if Invoice then
                  if not ("Document Type" = "document type"::"Credit Memo") then
                    if "Due Date" = 0D then
                      AddError(StrSubstNo(Text006,FieldCaption("Due Date")));

                if Ship and ("Shipping No." = '') then // Order,Invoice
                  if ("Document Type" = "document type"::Order) or
                     (("Document Type" = "document type"::Invoice) and ServiceSetup."Shipment on Invoice")
                  then
                    if "Shipping No. Series" = '' then
                      AddError(
                        StrSubstNo(
                          Text006,
                          FieldCaption("Shipping No. Series")));

                if Invoice and ("Posting No." = '') then
                  if "Document Type" = "document type"::Order then
                    if "Posting No. Series" = '' then
                      AddError(
                        StrSubstNo(
                          Text006,
                          FieldCaption("Posting No. Series")));

                ServiceLine.Reset;
                ServiceLine.SetRange("Document Type","Document Type");
                ServiceLine.SetRange("Document No.","No.");
                if ServiceLine.FindFirst then;

                if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                  AddError(DimMgt.GetDimCombErr);

                TableID[1] := Database::Customer;
                No[1] := "Bill-to Customer No.";
                TableID[3] := Database::"Salesperson/Purchaser";
                No[3] := "Salesperson Code";
                TableID[4] := Database::"Responsibility Center";
                No[4] := "Responsibility Center";

                if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
                  AddError(DimMgt.GetDimValuePostingErr);
            end;

            trigger OnPreDataItem()
            begin
                ServiceHeader.Copy("Service Header");
                ServiceHeader.FilterGroup := 2;
                ServiceHeader.SetRange("Document Type",ServiceHeader."document type"::Order);
                if ServiceHeader.FindFirst then begin
                  case true of
                    ShipReceiveOnNextPostReq and InvOnNextPostReq:
                      ShipInvText := Text000;
                    ShipReceiveOnNextPostReq:
                      ShipInvText := Text001;
                    InvOnNextPostReq:
                      ShipInvText := Text002;
                  end;
                  ShipInvText := StrSubstNo(Text003,ShipInvText);
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
                    group("Order Posting")
                    {
                        Caption = 'Order Posting';
                        field(ShipReceiveOnNextPostReq;ShipReceiveOnNextPostReq)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Ship';

                            trigger OnValidate()
                            begin
                                if not ShipReceiveOnNextPostReq then
                                  InvOnNextPostReq := true;
                            end;
                        }
                        field(InvOnNextPostReq;InvOnNextPostReq)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Invoice';

                            trigger OnValidate()
                            begin
                                if not InvOnNextPostReq then
                                  ShipReceiveOnNextPostReq := true;
                            end;
                        }
                    }
                    field(ShowDim;ShowDim)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Dimensions';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if not ShipReceiveOnNextPostReq and not InvOnNextPostReq then begin
              ShipReceiveOnNextPostReq := true;
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
        ServiceHeaderFilter := "Service Header".GetFilters;
    end;

    var
        Text000: label 'Ship and Invoice';
        Text001: label 'Ship';
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
        Text014: label 'Service Document: %1';
        Text015: label '%1 must be %2.';
        Text016: label '%1 %2 does not exist on customer entries.';
        Text017: label '%1 %2 %3 does not exist.';
        Text019: label '%1 %2 must be specified.';
        Text020: label '%1 must be 0 when %2 is 0.';
        Text024: label 'The %1 on the shipment is not the same as the %1 on the Service Header.';
        Text026: label 'Line %1 of the shipment %2, which you are attempting to invoice, has already been invoiced.';
        Text027: label '%1 must have the same sign as the shipments.';
        Text033: label 'Total %1 Excl. Tax';
        Text034: label 'Enter "Yes" in %1 and/or %2.';
        Text035: label 'You must enter the customer''s %1.';
        Text036: label 'The quantity you are attempting to invoice is greater than the quantity in shipment %1.';
        ServiceSetup: Record "Service Mgt. Setup";
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        Cust: Record Customer;
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceLine2: Record "Service Line";
        TempServiceLine: Record "Service Line" temporary;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        Res: Record Resource;
        ServiceShptLine: Record "Service Shipment Line";
        GenPostingSetup: Record "General Posting Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry: Record "Dimension Set Entry";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        FormatAddr: Codeunit "Format Address";
        DimMgt: Codeunit DimensionManagement;
        ServAmountsMgt: Codeunit "Serv-Amounts Mgt.";
        ServiceHeaderFilter: Text;
        SellToAddr: array [8] of Text[50];
        BillToAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        ShipInvText: Text[50];
        ReceiveInvText: Text[50];
        DimText: Text;
        ErrorText: array [99] of Text[250];
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        MaxQtyToBeInvoiced: Decimal;
        RemQtyToBeInvoiced: Decimal;
        QtyToBeInvoiced: Decimal;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        QtyToHandle: Decimal;
        SumLineAmount: Decimal;
        SumInvDiscountAmount: Decimal;
        ErrorCounter: Integer;
        OrigMaxLineNo: Integer;
        InvOnNextPostReq: Boolean;
        ShipReceiveOnNextPostReq: Boolean;
        VATNoError: Boolean;
        ApplNoError: Boolean;
        ShowDim: Boolean;
        Text043: label '%1 must be zero.';
        Text045: label '%1 must not be %2 for %3 %4.';
        MoreLines: Boolean;
        Ship: Boolean;
        Invoice: Boolean;
        DimTxtArrLength: Integer;
        DimTxtArr: array [500] of Text;
        ExchangeFactor: Decimal;
        SalesTax: Boolean;
        HeaderTaxArea: Record "Tax Area";
        SalesTaxAmountLine: Record UnknownRecord10011;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        TaxText: Text[30];
        SumtotalVAT: Decimal;
        SumtotalExchFactor: Decimal;
        Service_Document___TestCaptionLbl: label 'Service Document - Test';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Ship_toCaptionLbl: label 'Ship-to';
        CustomerCaptionLbl: label 'Customer';
        Bill_toCaptionLbl: label 'Bill-to';
        Service_Header___Posting_Date_CaptionLbl: label 'Posting Date';
        Service_Header___Document_Date_CaptionLbl: label 'Document Date';
        Service_Header___Due_Date_CaptionLbl: label 'Due Date';
        Service_Header___Pmt__Discount_Date_CaptionLbl: label 'Pmt. Discount Date';
        Service_Header___Posting_Date__Control105CaptionLbl: label 'Posting Date';
        Service_Header___Document_Date__Control106CaptionLbl: label 'Document Date';
        Service_Header___Order_Date_CaptionLbl: label 'Order Date';
        Service_Header___Due_Date__Control19CaptionLbl: label 'Due Date';
        Service_Header___Pmt__Discount_Date__Control22CaptionLbl: label 'Pmt. Discount Date';
        Service_Header___Posting_Date__Control131CaptionLbl: label 'Posting Date';
        Service_Header___Document_Date__Control132CaptionLbl: label 'Document Date';
        Service_Header___Posting_Date__Control137CaptionLbl: label 'Posting Date';
        Service_Header___Document_Date__Control138CaptionLbl: label 'Document Date';
        Header_DimensionsCaptionLbl: label 'Header Dimensions';
        ErrorText_Number_CaptionLbl: label 'Warning!';
        Unit_PriceCaptionLbl: label 'Unit Price';
        Service_Line___Line_Discount___CaptionLbl: label 'Line Disc. %';
        AmountCaptionLbl: label 'Amount';
        Service_Line__QuantityCaptionLbl: label 'Quantity';
        QtyToHandleCaptionLbl: label 'Qty. to Handle';
        TempServiceLine__Inv__Discount_Amount_CaptionLbl: label 'Inv. Discount Amount';
        SubtotalCaptionLbl: label 'Subtotal';
        VATDiscountAmountCaptionLbl: label 'Payment Discount on VAT';
        Line_DimensionsCaptionLbl: label 'Line Dimensions';
        ErrorText_Number__Control97CaptionLbl: label 'Warning!';
        VATAmountLine__VAT_Amount__Control150CaptionLbl: label 'Tax Amount';
        VATAmountLine__VAT_Base__Control151CaptionLbl: label 'Tax Base';
        VATAmountLine__VAT___CaptionLbl: label 'Tax %';
        VAT_Amount_SpecificationCaptionLbl: label 'Tax Amount Specification';
        VATAmountLine__VAT_Identifier_CaptionLbl: label 'Tax Identifier';
        VATAmountLine__Invoice_Discount_Amount__Control173CaptionLbl: label 'Invoice Discount Amount';
        VATAmountLine__Inv__Disc__Base_Amount__Control171CaptionLbl: label 'Inv. Disc. Base Amount';
        VATAmountLine__Line_Amount__Control169CaptionLbl: label 'Line Amount';
        TotalCaptionLbl: label 'Total';
        Sales_Tax_AmountsCaptionLbl: label 'Sales Tax Amounts';
        Tax_Area_CodeCaptionLbl: label 'Tax Area Code';
        Tax__CaptionLbl: label 'Tax %';
        Inv__Disc__Base_AmountCaptionLbl: label 'Inv. Disc. Base Amount';
        Invoice_Discount_AmountCaptionLbl: label 'Invoice Discount Amount';
        Tax_Base_AmountCaptionLbl: label 'Tax Base Amount';
        Tax_AmountCaptionLbl: label 'Tax Amount';
        ContinuedCaption_Control1020007Lbl: label 'Continued';
        ContinuedCaption_Control1020009Lbl: label 'Continued';
        TotalCaption_Control1020017Lbl: label 'Total';
        TotalCaption_Control1020019Lbl: label 'Total';

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;

    local procedure CheckShptLines(ServiceLine2: Record "Service Line")
    var
        TempPostedDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        with ServiceLine2 do begin
          if Abs(RemQtyToBeInvoiced) > Abs("Qty. to Ship") then begin
            ServiceShptLine.Reset;
            case "Document Type" of
              "document type"::Order:
                begin
                  ServiceShptLine.SetCurrentkey("Order No.","Order Line No.");
                  ServiceShptLine.SetRange("Order No.","Document No.");
                  ServiceShptLine.SetRange("Order Line No.","Line No.");
                end;
              "document type"::Invoice:
                begin
                  ServiceShptLine.SetRange("Document No.","Shipment No.");
                  ServiceShptLine.SetRange("Line No.","Shipment Line No.");
                end;
            end;

            ServiceShptLine.SetFilter("Qty. Shipped Not Invoiced",'<>0');

            if ServiceShptLine.Find('-') then
              repeat
                DimMgt.GetDimensionSet(TempPostedDimSetEntry,ServiceShptLine."Dimension Set ID");
                if not DimMgt.CheckDimIDConsistency(
                     TempDimSetEntry,TempPostedDimSetEntry,Database::"Service Line",Database::"Service Shipment Line")
                then
                  AddError(DimMgt.GetDocDimConsistencyErr);

                if ServiceShptLine."Customer No." <> "Customer No." then
                  AddError(
                    StrSubstNo(
                      Text024,
                      FieldCaption("Customer No.")));
                if ServiceShptLine.Type <> Type then
                  AddError(
                    StrSubstNo(
                      Text024,
                      FieldCaption(Type)));
                if ServiceShptLine."No." <> "No." then
                  AddError(
                    StrSubstNo(
                      Text024,
                      FieldCaption("No.")));
                if ServiceShptLine."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                  AddError(
                    StrSubstNo(
                      Text024,
                      FieldCaption("Gen. Bus. Posting Group")));
                if ServiceShptLine."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                  AddError(
                    StrSubstNo(
                      Text024,
                      FieldCaption("Gen. Prod. Posting Group")));
                if ServiceShptLine."Location Code" <> "Location Code" then
                  AddError(
                    StrSubstNo(
                      Text024,
                      FieldCaption("Location Code")));

                if -ServiceLine."Qty. to Invoice" * ServiceShptLine.Quantity < 0 then
                  AddError(
                    StrSubstNo(
                      Text027,FieldCaption("Qty. to Invoice")));

                QtyToBeInvoiced := RemQtyToBeInvoiced - ServiceLine."Qty. to Ship";
                if Abs(QtyToBeInvoiced) > Abs(ServiceShptLine.Quantity - ServiceShptLine."Quantity Invoiced") then
                  QtyToBeInvoiced := -(ServiceShptLine.Quantity - ServiceShptLine."Quantity Invoiced");
                RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                ServiceShptLine."Quantity Invoiced" := ServiceShptLine."Quantity Invoiced" - QtyToBeInvoiced;
                ServiceShptLine."Qty. Shipped Not Invoiced" :=
                  ServiceShptLine.Quantity - ServiceShptLine."Quantity Invoiced"
              until (ServiceShptLine.Next = 0) or (Abs(RemQtyToBeInvoiced) <= Abs("Qty. to Ship"))
            else
              AddError(
                StrSubstNo(
                  Text026,
                  "Shipment Line No.",
                  "Shipment No."));
          end;

          if Abs(RemQtyToBeInvoiced) > Abs("Qty. to Ship") then
            if "Document Type" = "document type"::Invoice then
              AddError(
                StrSubstNo(
                  Text036,
                  "Shipment No."));
        end;
    end;


    procedure FindDimTxt(DimSetID: Integer)
    var
        i: Integer;
        TxtToAdd: Text[120];
        Separation: Text[5];
        StartNewLine: Boolean;
    begin
        DimSetEntry.SetRange("Dimension Set ID",DimSetID);
        DimTxtArrLength := 0;
        for i := 1 to ArrayLen(DimTxtArr) do
          DimTxtArr[i] := '';
        if not DimSetEntry.FindSet then
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


    procedure InitializeRequest(ShipReceiveOnNextPostReqFrom: Boolean;InvOnNextPostReqFrom: Boolean;ShowDimFrom: Boolean)
    begin
        ShipReceiveOnNextPostReq := ShipReceiveOnNextPostReqFrom;
        if not ShipReceiveOnNextPostReq then
          InvOnNextPostReq := true;
        InvOnNextPostReq := InvOnNextPostReqFrom;
        if not InvOnNextPostReq then
          ShipReceiveOnNextPostReq := true;
        ShowDim := ShowDimFrom;
    end;
}

