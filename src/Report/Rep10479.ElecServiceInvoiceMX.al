#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10479 "Elec. Service Invoice MX"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Elec. Service Invoice MX.rdlc';
    Caption = 'Elec. Service Invoice MX';
    Permissions = TableData "Sales Shipment Buffer"=rimd;

    dataset
    {
        dataitem("Service Invoice Header";"Service Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Customer No.","No. Printed";
            RequestFilterHeading = 'Posted Service Invoice';
            column(ReportForNavId_5614; 5614)
            {
            }
            column(Service_Invoice_Header_No_;"No.")
            {
            }
            column(DocumentFooter;DocumentFooterLbl)
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
                    column(CompanyInfo2_Picture;CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1_Picture;CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo_Picture;CompanyInfo.Picture)
                    {
                    }
                    column(STRSUBSTNO_Text004_CopyText_;StrSubstNo(Text004,CopyText))
                    {
                    }
                    column(STRSUBSTNO_Text005_FORMAT_CurrReport_PAGENO__;StrSubstNo(Text005,Format(CurrReport.PageNo)))
                    {
                    }
                    column(CustAddr_1_;CustAddr[1])
                    {
                    }
                    column(CompanyAddr_1_;CompanyAddr[1])
                    {
                    }
                    column(CustAddr_2_;CustAddr[2])
                    {
                    }
                    column(CompanyAddr_2_;CompanyAddr[2])
                    {
                    }
                    column(CustAddr_3_;CustAddr[3])
                    {
                    }
                    column(CompanyAddr_3_;CompanyAddr[3])
                    {
                    }
                    column(CustAddr_4_;CustAddr[4])
                    {
                    }
                    column(CompanyAddr_4_;CompanyAddr[4])
                    {
                    }
                    column(CustAddr_5_;CustAddr[5])
                    {
                    }
                    column(CompanyInfo__Phone_No__;CompanyInfo."Phone No.")
                    {
                    }
                    column(CustAddr_6_;CustAddr[6])
                    {
                    }
                    column(CompanyInfo__Fax_No__;CompanyInfo."Fax No.")
                    {
                    }
                    column(CompanyInfo__VAT_Registration_No__;CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfo__Giro_No__;CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfo__Bank_Name_;CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfo__Bank_Account_No__;CompanyInfo."Bank Account No.")
                    {
                    }
                    column(Service_Invoice_Header___Bill_to_Customer_No__;"Service Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(Service_Invoice_Header___Posting_Date_;Format("Service Invoice Header"."Posting Date"))
                    {
                    }
                    column(VATNoText;VATNoText)
                    {
                    }
                    column(Service_Invoice_Header___VAT_Registration_No__;"Service Invoice Header"."VAT Registration No.")
                    {
                    }
                    column(Service_Invoice_Header___Due_Date_;Format("Service Invoice Header"."Due Date"))
                    {
                    }
                    column(SalesPersonText;SalesPersonText)
                    {
                    }
                    column(SalesPurchPerson_Name;SalesPurchPerson.Name)
                    {
                    }
                    column(Service_Invoice_Header___No__;"Service Invoice Header"."No.")
                    {
                    }
                    column(ReferenceText;ReferenceText)
                    {
                    }
                    column(Service_Invoice_Header___Your_Reference_;"Service Invoice Header"."Your Reference")
                    {
                    }
                    column(OrderNoText;OrderNoText)
                    {
                    }
                    column(Service_Invoice_Header___Order_No__;"Service Invoice Header"."Order No.")
                    {
                    }
                    column(CustAddr_7_;CustAddr[7])
                    {
                    }
                    column(CustAddr_8_;CustAddr[8])
                    {
                    }
                    column(CompanyAddr_5_;CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr_6_;CompanyAddr[6])
                    {
                    }
                    column(Service_Invoice_Header___Prices_Including_VAT_;"Service Invoice Header"."Prices Including VAT")
                    {
                    }
                    column(PageCaption;StrSubstNo(Text005,''))
                    {
                    }
                    column(OutputNo;OutputNo)
                    {
                    }
                    column(Formatted_Service_Invoice_Header___Prices_Including_VAT;Format("Service Invoice Header"."Prices Including VAT"))
                    {
                    }
                    column(FORMAT_Cust__Tax_Identification_Type__;Format(Cust."Tax Identification Type"))
                    {
                    }
                    column(Service_Invoice_Header___Certificate_Serial_No__;"Service Invoice Header"."Certificate Serial No.")
                    {
                    }
                    column(NoSeriesLine__Authorization_Year_;StrSubstNo(Text008,"Service Invoice Header"."Bill-to City","Service Invoice Header"."Document Date"))
                    {
                    }
                    column(NoSeriesLine__Authorization_Code_;"Service Invoice Header"."Date/Time Stamped")
                    {
                    }
                    column(FolioText;"Service Invoice Header"."Fiscal Invoice Number PAC")
                    {
                    }
                    column(Cust__RFC_No__;Cust."RFC No.")
                    {
                    }
                    column(CompanyInfo__RFC_No__;CompanyInfo."RFC No.")
                    {
                    }
                    column(Cust__Phone_No__;Cust."Phone No.")
                    {
                    }
                    column(PageLoop_Number;Number)
                    {
                    }
                    column(CompanyInfo__Phone_No__Caption;CompanyInfo__Phone_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__Fax_No__Caption;CompanyInfo__Fax_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__VAT_Registration_No__Caption;CompanyInfo__VAT_Registration_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__Giro_No__Caption;CompanyInfo__Giro_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__Bank_Name_Caption;CompanyInfo__Bank_Name_CaptionLbl)
                    {
                    }
                    column(CompanyInfo__Bank_Account_No__Caption;CompanyInfo__Bank_Account_No__CaptionLbl)
                    {
                    }
                    column(Service_Invoice_Header___Bill_to_Customer_No__Caption;"Service Invoice Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(Service_Invoice_Header___Due_Date_Caption;Service_Invoice_Header___Due_Date_CaptionLbl)
                    {
                    }
                    column(Service_Invoice_Header___Posting_Date_Caption;Service_Invoice_Header___Posting_Date_CaptionLbl)
                    {
                    }
                    column(Service_Invoice_Header___Prices_Including_VAT_Caption;"Service Invoice Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    column(Tax_Ident__TypeCaption;Tax_Ident__TypeCaptionLbl)
                    {
                    }
                    column(Service_Invoice_Header___Certificate_Serial_No__Caption;"Service Invoice Header".FieldCaption("Certificate Serial No."))
                    {
                    }
                    column(NoSeriesLine__Authorization_Year_Caption;NoSeriesLine__Authorization_Year_CaptionLbl)
                    {
                    }
                    column(NoSeriesLine__Authorization_Code_Caption;NoSeriesLine__Authorization_Code_CaptionLbl)
                    {
                    }
                    column(FolioTextCaption;FolioTextCaptionLbl)
                    {
                    }
                    column(Cust__RFC_No__Caption;Cust__RFC_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__RFC_No__Caption;CompanyInfo__RFC_No__CaptionLbl)
                    {
                    }
                    column(Cust__Phone_No__Caption;Cust__Phone_No__CaptionLbl)
                    {
                    }
                    dataitem(DimensionLoop1;"Integer")
                    {
                        DataItemLinkReference = "Service Invoice Header";
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_7574; 7574)
                        {
                        }
                        column(DimText;DimText)
                        {
                        }
                        column(DimText_Control98;DimText)
                        {
                        }
                        column(DimensionLoop1_Number;Number)
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
                            if not ShowInternalInfo then
                              CurrReport.Break;
                            FindDimTxt("Service Invoice Header"."Dimension Set ID");
                            SetRange(Number,1,DimTxtArrLength);
                        end;
                    }
                    dataitem("Service Invoice Line";"Service Invoice Line")
                    {
                        DataItemLink = "Document No."=field("No.");
                        DataItemLinkReference = "Service Invoice Header";
                        DataItemTableView = sorting("Document No.","Line No.");
                        column(ReportForNavId_2800; 2800)
                        {
                        }
                        column(TypeInt;TypeInt)
                        {
                        }
                        column(ServInvHeader__VAT_Base_Disc_;"Service Invoice Header"."VAT Base Discount %")
                        {
                        }
                        column(TotalLineAmount;TotalLineAmount)
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
                        column(ServiceInvoiceLine__Line_No__;"Service Invoice Line"."Line No.")
                        {
                        }
                        column(Service_Invoice_Line__Line_Amount_;"Line Amount")
                        {
                            AutoFormatExpression = "Service Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Service_Invoice_Line_Description;Description)
                        {
                        }
                        column(Service_Invoice_Line__No__;"No.")
                        {
                        }
                        column(Service_Invoice_Line_Description_Control65;Description)
                        {
                        }
                        column(Service_Invoice_Line_Quantity;Quantity)
                        {
                        }
                        column(Service_Invoice_Line__Unit_of_Measure_;"Unit of Measure")
                        {
                        }
                        column(Service_Invoice_Line__Unit_Price_;"Unit Price")
                        {
                            AutoFormatExpression = "Service Invoice Line".GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(Service_Invoice_Line__Line_Discount___;"Line Discount %")
                        {
                        }
                        column(Service_Invoice_Line__Line_Amount__Control70;"Line Amount")
                        {
                            AutoFormatExpression = "Service Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Service_Invoice_Line__VAT_Identifier_;"VAT Identifier")
                        {
                        }
                        column(PostedShipmentDate;Format(PostedShipmentDate))
                        {
                        }
                        column(Service_Invoice_Line__Line_Amount__Control86;"Line Amount")
                        {
                            AutoFormatExpression = "Service Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Inv__Discount_Amount_;-"Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Service Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Service_Invoice_Line__Line_Amount__Control99;"Line Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText;TotalText)
                        {
                        }
                        column(Service_Invoice_Line_Amount;Amount)
                        {
                            AutoFormatExpression = "Service Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AmountInWords_1_;AmountInWords[1])
                        {
                        }
                        column(AmountInWords_2_;AmountInWords[2])
                        {
                        }
                        column(Service_Invoice_Line_Amount_Control90;Amount)
                        {
                            AutoFormatExpression = "Service Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Amount_Including_VAT____Amount;"Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = "Service Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Service_Invoice_Line__Amount_Including_VAT_;"Amount Including VAT")
                        {
                            AutoFormatExpression = "Service Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine_VATAmountText;VATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalExclVATText;TotalExclVATText)
                        {
                        }
                        column(TotalInclVATText;TotalInclVATText)
                        {
                        }
                        column(AmountInWords_1__Control1020014;AmountInWords[1])
                        {
                        }
                        column(AmountInWords_2__Control1020015;AmountInWords[2])
                        {
                        }
                        column(Line_Amount_____Inv__Discount_Amount_____Amount_Including_VAT__;-("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT"))
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText_Control60;TotalInclVATText)
                        {
                        }
                        column(VATAmountLine_VATAmountText_Control61;VATAmountLine.VATAmountText)
                        {
                        }
                        column(Amount_Including_VAT____Amount_Control62;"Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = "Service Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Service_Invoice_Line_Amount_Control63;Amount)
                        {
                            AutoFormatExpression = "Service Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Service_Invoice_Line__Amount_Including_VAT__Control71;"Amount Including VAT")
                        {
                            AutoFormatExpression = "Service Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText_Control72;TotalExclVATText)
                        {
                        }
                        column(AmountInWords_1__Control1020017;AmountInWords[1])
                        {
                        }
                        column(AmountInWords_2__Control1020018;AmountInWords[2])
                        {
                        }
                        column(Service_Invoice_Line_Document_No_;"Document No.")
                        {
                        }
                        column(Service_Invoice_Line__No__Caption;FieldCaption("No."))
                        {
                        }
                        column(Service_Invoice_Line_Description_Control65Caption;FieldCaption(Description))
                        {
                        }
                        column(Service_Invoice_Line_QuantityCaption;FieldCaption(Quantity))
                        {
                        }
                        column(Service_Invoice_Line__Unit_of_Measure_Caption;FieldCaption("Unit of Measure"))
                        {
                        }
                        column(Unit_PriceCaption;Unit_PriceCaptionLbl)
                        {
                        }
                        column(Service_Invoice_Line__Line_Discount___Caption;Service_Invoice_Line__Line_Discount___CaptionLbl)
                        {
                        }
                        column(AmountCaption;AmountCaptionLbl)
                        {
                        }
                        column(Service_Invoice_Line__VAT_Identifier_Caption;FieldCaption("VAT Identifier"))
                        {
                        }
                        column(PostedShipmentDateCaption;PostedShipmentDateCaptionLbl)
                        {
                        }
                        column(ContinuedCaption;ContinuedCaptionLbl)
                        {
                        }
                        column(ContinuedCaption_Control85;ContinuedCaption_Control85Lbl)
                        {
                        }
                        column(Inv__Discount_Amount_Caption;Inv__Discount_Amount_CaptionLbl)
                        {
                        }
                        column(SubtotalCaption;SubtotalCaptionLbl)
                        {
                        }
                        column(Amount_in_words_Caption;Amount_in_words_CaptionLbl)
                        {
                        }
                        column(Amount_in_words_Caption_Control1020013;Amount_in_words_Caption_Control1020013Lbl)
                        {
                        }
                        column(Line_Amount_____Inv__Discount_Amount_____Amount_Including_VAT__Caption;Line_Amount_____Inv__Discount_Amount_____Amount_Including_VAT__CaptionLbl)
                        {
                        }
                        column(Amount_in_words_Caption_Control1020016;Amount_in_words_Caption_Control1020016Lbl)
                        {
                        }
                        dataitem("Service Shipment Buffer";"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_9516; 9516)
                            {
                            }
                            column(ServiceShipmentBuffer__Posting_Date_;Format(ServiceShipmentBuffer."Posting Date"))
                            {
                            }
                            column(ServiceShipmentBuffer_Quantity;ServiceShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(Service_Shipment_Buffer_Number;Number)
                            {
                            }
                            column(ShipmentCaption;ShipmentCaptionLbl)
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
                                ServiceShipmentBuffer.SetRange("Document No.","Service Invoice Line"."Document No.");
                                ServiceShipmentBuffer.SetRange("Line No.","Service Invoice Line"."Line No.");

                                SetRange(Number,1,ServiceShipmentBuffer.Count);
                            end;
                        }
                        dataitem(DimensionLoop2;"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_3591; 3591)
                            {
                            }
                            column(DimText_Control82;DimText)
                            {
                            }
                            column(DimensionLoop2_Number;Number)
                            {
                            }
                            column(Line_DimensionsCaption;Line_DimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number <= DimTxtArrLength then
                                  DimText := DimTxtArr[Number]
                                else
                                  DimText := Format("Service Invoice Line".Type) + ' ' + AccNo;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                  CurrReport.Break;

                                FindDimTxt("Service Invoice Line"."Dimension Set ID");
                                if IsServiceContractLine then
                                  SetRange(Number,1,DimTxtArrLength + 1)
                                else
                                  SetRange(Number,1,DimTxtArrLength);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Counter := Counter + 1;
                            PostedShipmentDate := 0D;
                            if Quantity <> 0 then
                              PostedShipmentDate := FindPostedShipmentDate;

                            IsServiceContractLine := (Type = Type::"G/L Account") and ("Service Item No." <> '') and ("Contract No." <> '');
                            if IsServiceContractLine then begin
                              AccNo := "No.";
                              "No." := "Service Item No.";
                            end;

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

                            TotalLineAmount += "Line Amount";
                            TotalAmount += Amount;
                            TotalAmountInclVAT += "Amount Including VAT";
                            TotalInvDiscAmount += "Inv. Discount Amount";
                            TypeInt := Type;
                            CalculateAmountInWords(TotalAmountInclVAT);
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
                            CurrReport.CreateTotals("Line Amount",Amount,"Amount Including VAT","Inv. Discount Amount");

                            TotalLineAmount := 0;
                            TotalAmount := 0;
                            TotalAmountInclVAT := 0;
                            TotalInvDiscAmount := 0;
                        end;
                    }
                    dataitem(VATCounter;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_6558; 6558)
                        {
                        }
                        column(VATAmountLine__VAT_Base_;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Service Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount_;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount_;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount_;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount_;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT___;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmountLine__VAT_Base__Control108;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control109;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Identifier_;VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountLine__Line_Amount__Control140;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control141;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control142;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base__Control112;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control113;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount__Control110;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control114;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control118;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base__Control116;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control117;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount__Control132;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control133;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control134;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATCounter_Number;Number)
                        {
                        }
                        column(VATAmountLine__VAT___Caption;VATAmountLine__VAT___CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Base__Control108Caption;VATAmountLine__VAT_Base__Control108CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Amount__Control109Caption;VATAmountLine__VAT_Amount__Control109CaptionLbl)
                        {
                        }
                        column(VAT_Amount_SpecificationCaption;VAT_Amount_SpecificationCaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Identifier_Caption;VATAmountLine__VAT_Identifier_CaptionLbl)
                        {
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control141Caption;VATAmountLine__Inv__Disc__Base_Amount__Control141CaptionLbl)
                        {
                        }
                        column(VATAmountLine__Line_Amount__Control140Caption;VATAmountLine__Line_Amount__Control140CaptionLbl)
                        {
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control142Caption;VATAmountLine__Invoice_Discount_Amount__Control142CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Base_Caption;VATAmountLine__VAT_Base_CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Base__Control112Caption;VATAmountLine__VAT_Base__Control112CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Base__Control116Caption;VATAmountLine__VAT_Base__Control116CaptionLbl)
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
                        column(PaymentTerms_Description;PaymentTerms.Description)
                        {
                        }
                        column(Total_Number;Number)
                        {
                        }
                        column(PaymentTerms_DescriptionCaption;PaymentTerms_DescriptionCaptionLbl)
                        {
                        }
                    }
                    dataitem(Total2;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_3363; 3363)
                        {
                        }
                        column(Service_Invoice_Header___Customer_No__;"Service Invoice Header"."Customer No.")
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
                        column(Total2_Number;Number)
                        {
                        }
                        column(Ship_to_AddressCaption;Ship_to_AddressCaptionLbl)
                        {
                        }
                        column(Service_Invoice_Header___Customer_No__Caption;"Service Invoice Header".FieldCaption("Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not ShowShippingAddr then
                              CurrReport.Break;
                        end;
                    }
                    dataitem(OriginalStringLoop;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_5410; 5410)
                        {
                        }
                        column(OriginalStringText;OriginalStringText)
                        {
                        }
                        column(OriginalStringLoop_Number;Number)
                        {
                        }
                        column(Original_StringCaption;Original_StringCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            ReturnLength: Integer;
                        begin
                            OriginalStringText := '';
                            ReturnLength := OriginalStringBigText.GetSubText(OriginalStringText,Position,MaxStrLen(OriginalStringText));
                            Position := Position + ReturnLength;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number,1,ROUND(OriginalStringBigText.Length / MaxStrLen(OriginalStringText),1,'>'));
                            Position := 1;
                        end;
                    }
                    dataitem(DigitalSignaturePACLoop;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_4802; 4802)
                        {
                        }
                        column(DigitalSignaturePACText;DigitalSignaturePACText)
                        {
                        }
                        column(DigitalSignaturePACLoop_Number;Number)
                        {
                        }
                        column(Digital_StampCaption;Digital_StampCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            ReturnLength: Integer;
                        begin
                            DigitalSignaturePACText := '';
                            ReturnLength := DigitalSignaturePACBigText.GetSubText(DigitalSignaturePACText,Position,MaxStrLen(DigitalSignaturePACText));
                            Position := Position + ReturnLength;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number,1,ROUND(DigitalSignaturePACBigText.Length / MaxStrLen(DigitalSignaturePACText),1,'>'));
                            Position := 1;
                        end;
                    }
                    dataitem(DigitalSignatureLoop;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_8590; 8590)
                        {
                        }
                        column(DigitalSignatureText;DigitalSignatureText)
                        {
                        }
                        column(DigitalSignatureLoop_Number;Number)
                        {
                        }
                        column(DigitalSignaturePACTextCaption;DigitalSignaturePACTextCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            ReturnLength: Integer;
                        begin
                            DigitalSignatureText := '';
                            ReturnLength := DigitalSignatureBigText.GetSubText(DigitalSignatureText,Position,MaxStrLen(DigitalSignatureText));
                            Position := Position + ReturnLength;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number,1,ROUND(DigitalSignatureBigText.Length / MaxStrLen(DigitalSignatureText),1,'>'));
                            Position := 1;
                        end;
                    }
                    dataitem(QRCode;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_4393; 4393)
                        {
                        }
                        column(Service_Invoice_Header___QR_Code_;"Service Invoice Header"."QR Code")
                        {
                        }
                        column(QRCode_Number;Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            "Service Invoice Header".CalcFields("QR Code");
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
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                      ServiceInvCountPrinted.Run("Service Invoice Header");
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
            var
                TempBlob: Record TempBlob;
            begin
                if "Source Code" = SourceCodeSetup."Deleted Document" then
                  Error(Text007);

                CurrReport.Language := Language.GetLanguageID("Language Code");

                if RespCenter.Get("Responsibility Center") then begin
                  FormatAddr.RespCenter(CompanyAddr,RespCenter);
                  CompanyInfo."Phone No." := RespCenter."Phone No.";
                  CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                  FormatAddr.Company(CompanyAddr,CompanyInfo);

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
                FormatAddr.ServiceInvBillTo(CustAddr,"Service Invoice Header");
                if not Cust.Get("Bill-to Customer No.") then
                  Clear(Cust);

                if "Payment Terms Code" = '' then
                  PaymentTerms.Init
                else
                  PaymentTerms.Get("Payment Terms Code");

                ShowShippingAddr := FormatAddr.ServiceInvShipTo(ShipToAddr,CustAddr,"Service Invoice Header");

                "Service Invoice Header".CalcFields("Original String","Digital Stamp SAT","Digital Stamp PAC");

                Clear(OriginalStringBigText);
                TempBlob.Blob := "Service Invoice Header"."Original String";
                BlobMgt.Read(OriginalStringBigText,TempBlob);
                Clear(DigitalSignatureBigText);
                TempBlob.Blob := "Service Invoice Header"."Digital Stamp SAT";
                BlobMgt.Read(DigitalSignatureBigText,TempBlob);
                TempBlob.Blob := "Service Invoice Header"."Digital Stamp PAC";
                Clear(DigitalSignaturePACBigText);
                BlobMgt.Read(DigitalSignaturePACBigText,TempBlob);
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
                        ToolTip = 'Specifies the number of copies to print of the document.';
                    }
                    field(ShowInternalInfo;ShowInternalInfo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies if the printed document includes dimensions that your company uses.';
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
        SourceCodeSetup.Get;

        case ServiceSetup."Logo Position on Documents" of
          ServiceSetup."logo position on documents"::"No Logo":
            ;
          ServiceSetup."logo position on documents"::Left:
            CompanyInfo.CalcFields(Picture);
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
        Text000: label 'Salesperson';
        Text001: label 'Total %1';
        Text002: label 'Total %1 Incl. Tax';
        Text003: label 'COPY';
        Text004: label 'Service - Invoice %1';
        Text005: label 'Page %1';
        Text006: label 'Total %1 Excl. Tax';
        GLSetup: Record "General Ledger Setup";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        ServiceSetup: Record "Service Mgt. Setup";
        Cust: Record Customer;
        DimSetEntry: Record "Dimension Set Entry";
        VATAmountLine: Record "VAT Amount Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        ServiceShipmentBuffer: Record "Service Shipment Buffer" temporary;
        SourceCodeSetup: Record "Source Code Setup";
        ServiceInvCountPrinted: Codeunit "Service Inv.-Printed";
        FormatAddr: Codeunit "Format Address";
        BlobMgt: Codeunit "Blob Management";
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
        OriginalStringText: Text[80];
        DigitalSignatureText: Text[80];
        DigitalSignaturePACText: Text[80];
        AmountInWords: array [2] of Text[80];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        OutputNo: Integer;
        TypeInt: Integer;
        DimText: Text[120];
        Position: Integer;
        ShowInternalInfo: Boolean;
        TotalLineAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        DimTxtArrLength: Integer;
        DimTxtArr: array [500] of Text[50];
        IsServiceContractLine: Boolean;
        OriginalStringBigText: BigText;
        DigitalSignatureBigText: BigText;
        Text007: label 'You can not sign or send or print a deleted document.';
        DigitalSignaturePACBigText: BigText;
        Counter: Integer;
        Text008: label '%1, %2';
        AccNo: Code[20];
        CompanyInfo__Phone_No__CaptionLbl: label 'Phone No.';
        CompanyInfo__Fax_No__CaptionLbl: label 'Fax No.';
        CompanyInfo__VAT_Registration_No__CaptionLbl: label 'Tax Reg. No.';
        CompanyInfo__Giro_No__CaptionLbl: label 'Giro No.';
        CompanyInfo__Bank_Name_CaptionLbl: label 'Bank';
        CompanyInfo__Bank_Account_No__CaptionLbl: label 'Account No.';
        Service_Invoice_Header___Due_Date_CaptionLbl: label 'Due Date';
        Service_Invoice_Header___Posting_Date_CaptionLbl: label 'Posting Date';
        Tax_Ident__TypeCaptionLbl: label 'Tax Ident. Type';
        NoSeriesLine__Authorization_Year_CaptionLbl: label 'Location and Issue date:';
        NoSeriesLine__Authorization_Code_CaptionLbl: label 'Date and time of certification:';
        FolioTextCaptionLbl: label 'Folio:';
        Cust__RFC_No__CaptionLbl: label 'Customer RFC';
        CompanyInfo__RFC_No__CaptionLbl: label 'Company RFC';
        Cust__Phone_No__CaptionLbl: label 'Phone number';
        Header_DimensionsCaptionLbl: label 'Header Dimensions';
        Unit_PriceCaptionLbl: label 'Unit Price';
        Service_Invoice_Line__Line_Discount___CaptionLbl: label 'Disc. %';
        AmountCaptionLbl: label 'Amount';
        PostedShipmentDateCaptionLbl: label 'Posted Shipment Date';
        ContinuedCaptionLbl: label 'Continued';
        ContinuedCaption_Control85Lbl: label 'Continued';
        Inv__Discount_Amount_CaptionLbl: label 'Inv. Discount Amount';
        SubtotalCaptionLbl: label 'Subtotal';
        Amount_in_words_CaptionLbl: label 'Amount in words:';
        Amount_in_words_Caption_Control1020013Lbl: label 'Amount in words:';
        Line_Amount_____Inv__Discount_Amount_____Amount_Including_VAT__CaptionLbl: label 'Payment Discount on VAT';
        Amount_in_words_Caption_Control1020016Lbl: label 'Amount in words:';
        ShipmentCaptionLbl: label 'Shipment';
        Line_DimensionsCaptionLbl: label 'Line Dimensions';
        VATAmountLine__VAT___CaptionLbl: label 'Tax %';
        VATAmountLine__VAT_Base__Control108CaptionLbl: label 'Tax Base';
        VATAmountLine__VAT_Amount__Control109CaptionLbl: label 'Tax Amount';
        VAT_Amount_SpecificationCaptionLbl: label 'Tax Amount Specification';
        VATAmountLine__VAT_Identifier_CaptionLbl: label 'Tax Identifier';
        VATAmountLine__Inv__Disc__Base_Amount__Control141CaptionLbl: label 'Inv. Disc. Base Amount';
        VATAmountLine__Line_Amount__Control140CaptionLbl: label 'Line Amount';
        VATAmountLine__Invoice_Discount_Amount__Control142CaptionLbl: label 'Invoice Discount Amount';
        VATAmountLine__VAT_Base_CaptionLbl: label 'Continued';
        VATAmountLine__VAT_Base__Control112CaptionLbl: label 'Continued';
        VATAmountLine__VAT_Base__Control116CaptionLbl: label 'Total';
        PaymentTerms_DescriptionCaptionLbl: label 'Payment Terms';
        Ship_to_AddressCaptionLbl: label 'Ship-to Address';
        Original_StringCaptionLbl: label 'Original string of digital certificate complement from SAT';
        Digital_StampCaptionLbl: label 'Digital stamp from SAT';
        DigitalSignaturePACTextCaptionLbl: label 'Digital stamp';
        DocumentFooterLbl: label 'This document is a printed version for electronic invoice';


    procedure FindPostedShipmentDate(): Date
    var
        ServiceShipmentHeader: Record "Service Shipment Header";
        ServiceShipmentBuffer2: Record "Service Shipment Buffer" temporary;
    begin
        NextEntryNo := 1;
        if "Service Invoice Line"."Shipment No." <> '' then
          if ServiceShipmentHeader.Get("Service Invoice Line"."Shipment No.") then
            exit(ServiceShipmentHeader."Posting Date");

        if "Service Invoice Header"."Order No." = '' then
          exit("Service Invoice Header"."Posting Date");

        case "Service Invoice Line".Type of
          "Service Invoice Line".Type::Item:
            GenerateBufferFromValueEntry("Service Invoice Line");
          "Service Invoice Line".Type::"G/L Account","Service Invoice Line".Type::Resource,
          "Service Invoice Line".Type::Cost:
            GenerateBufferFromShipment("Service Invoice Line");
          "Service Invoice Line".Type::" ":
            exit(0D);
        end;

        ServiceShipmentBuffer.Reset;
        ServiceShipmentBuffer.SetRange("Document No.","Service Invoice Line"."Document No.");
        ServiceShipmentBuffer.SetRange("Line No." ,"Service Invoice Line"."Line No.");
        if ServiceShipmentBuffer.Find('-') then begin
          ServiceShipmentBuffer2 := ServiceShipmentBuffer;
          if ServiceShipmentBuffer.Next = 0 then begin
            ServiceShipmentBuffer.Get(
              ServiceShipmentBuffer2."Document No.",ServiceShipmentBuffer2."Line No.",ServiceShipmentBuffer2."Entry No.");
            ServiceShipmentBuffer.Delete;
            exit(ServiceShipmentBuffer2."Posting Date");
          end ;
          ServiceShipmentBuffer.CalcSums(Quantity);
          if ServiceShipmentBuffer.Quantity <> "Service Invoice Line".Quantity then begin
            ServiceShipmentBuffer.DeleteAll;
            exit("Service Invoice Header"."Posting Date");
          end;
        end else
          exit("Service Invoice Header"."Posting Date");
    end;


    procedure GenerateBufferFromValueEntry(ServiceInvoiceLine2: Record "Service Invoice Line")
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := ServiceInvoiceLine2."Quantity (Base)";
        ValueEntry.SetCurrentkey("Document No.");
        ValueEntry.SetRange("Document No.",ServiceInvoiceLine2."Document No.");
        ValueEntry.SetRange("Posting Date","Service Invoice Header"."Posting Date");
        ValueEntry.SetRange("Item Charge No.",'');
        ValueEntry.SetFilter("Entry No.",'%1..',FirstValueEntryNo);
        if ValueEntry.Find('-') then
          repeat
            if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
              if ServiceInvoiceLine2."Qty. per Unit of Measure" <> 0 then
                Quantity := ValueEntry."Invoiced Quantity" / ServiceInvoiceLine2."Qty. per Unit of Measure"
              else
                Quantity := ValueEntry."Invoiced Quantity";
              AddBufferEntry(
                ServiceInvoiceLine2,
                -Quantity,
                ItemLedgerEntry."Posting Date");
              TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
            end;
            FirstValueEntryNo := ValueEntry."Entry No." + 1;
          until (ValueEntry.Next = 0) or (TotalQuantity = 0);
    end;


    procedure GenerateBufferFromShipment(ServiceInvoiceLine: Record "Service Invoice Line")
    var
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceInvoiceLine2: Record "Service Invoice Line";
        ServiceShipmentHeader: Record "Service Shipment Header";
        ServiceShipmentLine: Record "Service Shipment Line";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := 0;
        ServiceInvoiceHeader.SetCurrentkey("Order No.");
        ServiceInvoiceHeader.SetFilter("No.",'..%1',"Service Invoice Header"."No.");
        ServiceInvoiceHeader.SetRange("Order No.","Service Invoice Header"."Order No.");
        if ServiceInvoiceHeader.Find('-') then
          repeat
            ServiceInvoiceLine2.SetRange("Document No.",ServiceInvoiceHeader."No.");
            ServiceInvoiceLine2.SetRange("Line No.",ServiceInvoiceLine."Line No.");
            ServiceInvoiceLine2.SetRange(Type,ServiceInvoiceLine.Type);
            ServiceInvoiceLine2.SetRange("No.",ServiceInvoiceLine."No.");
            ServiceInvoiceLine2.SetRange("Unit of Measure Code",ServiceInvoiceLine."Unit of Measure Code");
            if ServiceInvoiceLine2.Find('-') then
              repeat
                TotalQuantity := TotalQuantity + ServiceInvoiceLine2.Quantity;
              until ServiceInvoiceLine2.Next = 0;
          until ServiceInvoiceHeader.Next = 0;

        ServiceShipmentLine.SetCurrentkey("Order No.","Order Line No.");
        ServiceShipmentLine.SetRange("Order No.","Service Invoice Header"."Order No.");
        ServiceShipmentLine.SetRange("Order Line No.",ServiceInvoiceLine."Line No.");
        ServiceShipmentLine.SetRange("Line No.",ServiceInvoiceLine."Line No.");
        ServiceShipmentLine.SetRange(Type,ServiceInvoiceLine.Type);
        ServiceShipmentLine.SetRange("No.",ServiceInvoiceLine."No.");
        ServiceShipmentLine.SetRange("Unit of Measure Code",ServiceInvoiceLine."Unit of Measure Code");
        ServiceShipmentLine.SetFilter(Quantity,'<>%1',0);

        if ServiceShipmentLine.Find('-') then
          repeat
            if Abs(ServiceShipmentLine.Quantity) <= Abs(TotalQuantity - ServiceInvoiceLine.Quantity) then
              TotalQuantity := TotalQuantity - ServiceShipmentLine.Quantity
            else begin
              if Abs(ServiceShipmentLine.Quantity) > Abs(TotalQuantity) then
                ServiceShipmentLine.Quantity := TotalQuantity;
              Quantity :=
                ServiceShipmentLine.Quantity - (TotalQuantity - ServiceInvoiceLine.Quantity);

              TotalQuantity := TotalQuantity - ServiceShipmentLine.Quantity;
              ServiceInvoiceLine.Quantity := ServiceInvoiceLine.Quantity - Quantity;

              if ServiceShipmentHeader.Get(ServiceShipmentLine."Document No.") then
                AddBufferEntry(
                  ServiceInvoiceLine,
                  Quantity,
                  ServiceShipmentHeader."Posting Date");
            end;
          until (ServiceShipmentLine.Next = 0) or (TotalQuantity = 0);
    end;


    procedure AddBufferEntry(ServiceInvoiceLine: Record "Service Invoice Line";QtyOnShipment: Decimal;PostingDate: Date)
    begin
        ServiceShipmentBuffer.SetRange("Document No.",ServiceInvoiceLine."Document No.");
        ServiceShipmentBuffer.SetRange("Line No.",ServiceInvoiceLine."Line No.");
        ServiceShipmentBuffer.SetRange("Posting Date",PostingDate);
        if ServiceShipmentBuffer.Find('-') then begin
          ServiceShipmentBuffer.Quantity := ServiceShipmentBuffer.Quantity + QtyOnShipment;
          ServiceShipmentBuffer.Modify;
          exit;
        end;

        with ServiceShipmentBuffer do begin
          "Document No." := ServiceInvoiceLine."Document No.";
          "Line No." := ServiceInvoiceLine."Line No.";
          "Entry No." := NextEntryNo;
          Type := ServiceInvoiceLine.Type;
          "No." := ServiceInvoiceLine."No.";
          Quantity := QtyOnShipment;
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

    local procedure CalculateAmountInWords(AmountInclVAT: Decimal)
    var
        LanguageId: Integer;
        TranslationManagement: Report "Check Translation Management";
    begin
        if CurrReport.Language in [1033,3084,2058,4105] then
          LanguageId := CurrReport.Language
        else
          LanguageId := GlobalLanguage;
        TranslationManagement.FormatNoText(AmountInWords,AmountInclVAT,
          LanguageId,"Service Invoice Header"."Currency Code")
    end;
}

