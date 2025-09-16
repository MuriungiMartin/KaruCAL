#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 216 "Archived Sales Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Archived Sales Order.rdlc';
    Caption = 'Archived Sales Order';

    dataset
    {
        dataitem("Sales Header Archive";"Sales Header Archive")
        {
            DataItemTableView = sorting("Document Type","No.","Doc. No. Occurrence","Version No.") where("Document Type"=const(Order));
            RequestFilterFields = "No.","Sell-to Customer No.","No. Printed","Version No.";
            RequestFilterHeading = 'Archived Sales Order';
            column(ReportForNavId_3260; 3260)
            {
            }
            column(Sales_Header_Archive_Document_Type;"Document Type")
            {
            }
            column(Sales_Header_Archive_No_;"No.")
            {
            }
            column(Sales_Header_Archive_Doc__No__Occurrence;"Doc. No. Occurrence")
            {
            }
            column(Sales_Header_Archive_Version_No_;"Version No.")
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
                    column(CompanyInfo_Picture;CompanyInfo.Picture)
                    {
                    }
                    column(CompanyInfo1_Picture;CompanyInfo1.Picture)
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
                    column(Sales_Header_Archive___Bill_to_Customer_No__;"Sales Header Archive"."Bill-to Customer No.")
                    {
                    }
                    column(FORMAT__Sales_Header_Archive___Document_Date__0_4_;Format("Sales Header Archive"."Document Date",0,4))
                    {
                    }
                    column(VATNoText;VATNoText)
                    {
                    }
                    column(Sales_Header_Archive___VAT_Registration_No__;"Sales Header Archive"."VAT Registration No.")
                    {
                    }
                    column(Sales_Header_Archive___Shipment_Date_;Format("Sales Header Archive"."Shipment Date"))
                    {
                    }
                    column(SalesPersonText;SalesPersonText)
                    {
                    }
                    column(SalesPurchPerson_Name;SalesPurchPerson.Name)
                    {
                    }
                    column(Sales_Header_Archive___No__;"Sales Header Archive"."No.")
                    {
                    }
                    column(ReferenceText;ReferenceText)
                    {
                    }
                    column(Sales_Header_Archive___Your_Reference_;"Sales Header Archive"."Your Reference")
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
                    column(Sales_Header_Archive___Prices_Including_VAT_;"Sales Header Archive"."Prices Including VAT")
                    {
                    }
                    column(STRSUBSTNO_Text011__Sales_Header_Archive___Version_No____Sales_Header_Archive___No__of_Archived_Versions__;StrSubstNo(Text011,"Sales Header Archive"."Version No.","Sales Header Archive"."No. of Archived Versions"))
                    {
                    }
                    column(VATBaseDiscountPercent;"Sales Header Archive"."VAT Base Discount %")
                    {
                    }
                    column(PricesInclVAT_YesNo;Format("Sales Header Archive"."Prices Including VAT"))
                    {
                    }
                    column(PageCaption;StrSubstNo(Text005,''))
                    {
                    }
                    column(OutputNo;OutputNo)
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
                    column(Sales_Header_Archive___Bill_to_Customer_No__Caption;"Sales Header Archive".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(Sales_Header_Archive___Shipment_Date_Caption;Sales_Header_Archive___Shipment_Date_CaptionLbl)
                    {
                    }
                    column(Order_No_Caption;Order_No_CaptionLbl)
                    {
                    }
                    column(Sales_Header_Archive___Prices_Including_VAT_Caption;"Sales Header Archive".FieldCaption("Prices Including VAT"))
                    {
                    }
                    dataitem(DimensionLoop1;"Integer")
                    {
                        DataItemLinkReference = "Sales Header Archive";
                        DataItemTableView = sorting(Number) where(Number=filter(1..));
                        column(ReportForNavId_7574; 7574)
                        {
                        }
                        column(DimText;DimText)
                        {
                        }
                        column(DimText_Control80;DimText)
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
                    dataitem("Sales Line Archive";"Sales Line Archive")
                    {
                        DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                        DataItemLinkReference = "Sales Header Archive";
                        DataItemTableView = sorting("Document Type","Document No.","Line No.");
                        column(ReportForNavId_6985; 6985)
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
                        column(SalesLineArch__Line_Amount_;TempSalesLineArchive."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Sales_Line_Archive__Description;"Sales Line Archive".Description)
                        {
                        }
                        column(RoundLoopBody3Visibility;TempSalesLineArchive.Type = 0)
                        {
                        }
                        column(Sales_Line_Archive___No__;"Sales Line Archive"."No.")
                        {
                        }
                        column(Sales_Line_Archive__Description_Control63;"Sales Line Archive".Description)
                        {
                        }
                        column(Sales_Line_Archive__Quantity;"Sales Line Archive".Quantity)
                        {
                        }
                        column(Sales_Line_Archive___Unit_of_Measure_;"Sales Line Archive"."Unit of Measure")
                        {
                        }
                        column(Sales_Line_Archive___Unit_Price_;"Sales Line Archive"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(Sales_Line_Archive___Line_Discount___;"Sales Line Archive"."Line Discount %")
                        {
                        }
                        column(Sales_Line_Archive___Line_Amount_;"Sales Line Archive"."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Sales_Line_Archive___Allow_Invoice_Disc__;"Sales Line Archive"."Allow Invoice Disc.")
                        {
                        }
                        column(Sales_Line_Archive___VAT_Identifier_;"Sales Line Archive"."VAT Identifier")
                        {
                        }
                        column(SalesLineType;Format("Sales Line Archive".Type))
                        {
                        }
                        column(AllowInvoiceDis_YesNo;Format("Sales Line Archive"."Allow Invoice Disc."))
                        {
                        }
                        column(SalesLineNo;Format("Sales Line Archive"."Line No."))
                        {
                        }
                        column(RoundLoopBody4Visibility;TempSalesLineArchive.Type > 0)
                        {
                        }
                        column(SalesLineArch__Line_Amount__Control84;TempSalesLineArchive."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLineArch__Inv__Discount_Amount_;-TempSalesLineArchive."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLineArch__Line_Amount__Control70;TempSalesLineArchive."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText;TotalText)
                        {
                        }
                        column(SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount_;TempSalesLineArchive."Line Amount" - TempSalesLineArchive."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText;TotalExclVATText)
                        {
                        }
                        column(VATAmountLine_VATAmountText;VATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalInclVATText;TotalInclVATText)
                        {
                        }
                        column(SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount__Control88;TempSalesLineArchive."Line Amount" - TempSalesLineArchive."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmount;VATAmount)
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount____VATAmount;TempSalesLineArchive."Line Amount" - TempSalesLineArchive."Inv. Discount Amount" + VATAmount)
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATDiscountAmount;-VATDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText_Control131;TotalExclVATText)
                        {
                        }
                        column(VATBaseAmount;VATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine_VATAmountText_Control133;VATAmountLine.VATAmountText)
                        {
                        }
                        column(VATAmount_Control134;VATAmount)
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText_Control135;TotalInclVATText)
                        {
                        }
                        column(TotalAmountInclVAT;TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(RoundLoop_Number;Number)
                        {
                        }
                        column(Sales_Line_Archive___No__Caption;"Sales Line Archive".FieldCaption("No."))
                        {
                        }
                        column(Sales_Line_Archive__Description_Control63Caption;"Sales Line Archive".FieldCaption(Description))
                        {
                        }
                        column(Sales_Line_Archive__QuantityCaption;"Sales Line Archive".FieldCaption(Quantity))
                        {
                        }
                        column(Sales_Line_Archive___Unit_of_Measure_Caption;"Sales Line Archive".FieldCaption("Unit of Measure"))
                        {
                        }
                        column(Unit_PriceCaption;Unit_PriceCaptionLbl)
                        {
                        }
                        column(Sales_Line_Archive___Line_Discount___Caption;Sales_Line_Archive___Line_Discount___CaptionLbl)
                        {
                        }
                        column(AmountCaption;AmountCaptionLbl)
                        {
                        }
                        column(Sales_Line_Archive___VAT_Identifier_Caption;"Sales Line Archive".FieldCaption("VAT Identifier"))
                        {
                        }
                        column(Sales_Line_Archive___Allow_Invoice_Disc__Caption;"Sales Line Archive".FieldCaption("Allow Invoice Disc."))
                        {
                        }
                        column(ContinuedCaption;ContinuedCaptionLbl)
                        {
                        }
                        column(ContinuedCaption_Control83;ContinuedCaption_Control83Lbl)
                        {
                        }
                        column(SalesLineArch__Inv__Discount_Amount_Caption;SalesLineArch__Inv__Discount_Amount_CaptionLbl)
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

                                DimSetEntry2.SetRange("Dimension Set ID","Sales Line Archive"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                              TempSalesLineArchive.Find('-')
                            else
                              TempSalesLineArchive.Next;
                            "Sales Line Archive" := TempSalesLineArchive;

                            if not "Sales Header Archive"."Prices Including VAT" and
                               (TempSalesLineArchive."VAT Calculation Type" = TempSalesLineArchive."vat calculation type"::"Full VAT")
                            then
                              TempSalesLineArchive."Line Amount" := 0;

                            if (TempSalesLineArchive.Type = TempSalesLineArchive.Type::"G/L Account") and (not ShowInternalInfo) then
                              "Sales Line Archive"."No." := '';
                        end;

                        trigger OnPostDataItem()
                        begin
                            TempSalesLineArchive.DeleteAll;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := TempSalesLineArchive.Find('+');
                            while MoreLines and (TempSalesLineArchive.Description = '') and (TempSalesLineArchive."Description 2" = '') and
                                  (TempSalesLineArchive."No." = '') and (TempSalesLineArchive.Quantity = 0) and
                                  (TempSalesLineArchive.Amount = 0)
                            do
                              MoreLines := TempSalesLineArchive.Next(-1) <> 0;
                            if not MoreLines then
                              CurrReport.Break;
                            TempSalesLineArchive.SetRange("Line No.",0,TempSalesLineArchive."Line No.");
                            SetRange(Number,1,TempSalesLineArchive.Count);
                            CurrReport.CreateTotals(TempSalesLineArchive."Line Amount",TempSalesLineArchive."Inv. Discount Amount");
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
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount_;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount_;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount_;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount_;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT___;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmountLine__VAT_Base__Control106;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control107;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Identifier_;VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountLine__Line_Amount__Control72;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control73;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control74;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base__Control110;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control111;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount__Control100;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control104;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control108;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base__Control114;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control115;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount__Control112;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control116;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control130;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATCounter_Number;Number)
                        {
                        }
                        column(VATAmountLine__VAT___Caption;VATAmountLine__VAT___CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Base__Control106Caption;VATAmountLine__VAT_Base__Control106CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Amount__Control107Caption;VATAmountLine__VAT_Amount__Control107CaptionLbl)
                        {
                        }
                        column(VAT_Amount_SpecificationCaption;VAT_Amount_SpecificationCaptionLbl)
                        {
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control73Caption;VATAmountLine__Inv__Disc__Base_Amount__Control73CaptionLbl)
                        {
                        }
                        column(VATAmountLine__Line_Amount__Control72Caption;VATAmountLine__Line_Amount__Control72CaptionLbl)
                        {
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control74Caption;VATAmountLine__Invoice_Discount_Amount__Control74CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Identifier_Caption;VATAmountLine__VAT_Identifier_CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Base_Caption;VATAmountLine__VAT_Base_CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Base__Control110Caption;VATAmountLine__VAT_Base__Control110CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Base__Control114Caption;VATAmountLine__VAT_Base__Control114CaptionLbl)
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
                        column(VALVATAmountLCY_Control149;VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY_Control150;VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT____Control151;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmountLine__VAT_Identifier__Control152;VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VALVATAmountLCY_Control156;VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY_Control157;VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY_Control159;VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY_Control160;VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATCounterLCY_Number;Number)
                        {
                        }
                        column(VALVATAmountLCY_Control149Caption;VALVATAmountLCY_Control149CaptionLbl)
                        {
                        }
                        column(VALVATBaseLCY_Control150Caption;VALVATBaseLCY_Control150CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT____Control151Caption;VATAmountLine__VAT____Control151CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Identifier__Control152Caption;VATAmountLine__VAT_Identifier__Control152CaptionLbl)
                        {
                        }
                        column(VALVATBaseLCYCaption;VALVATBaseLCYCaptionLbl)
                        {
                        }
                        column(VALVATBaseLCY_Control157Caption;VALVATBaseLCY_Control157CaptionLbl)
                        {
                        }
                        column(VALVATBaseLCY_Control160Caption;VALVATBaseLCY_Control160CaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Sales Header Archive"."Posting Date","Sales Header Archive"."Currency Code",
                                "Sales Header Archive"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Sales Header Archive"."Posting Date","Sales Header Archive"."Currency Code",
                                "Sales Header Archive"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Sales Header Archive"."Currency Code" = '') or
                               (VATAmountLine.GetTotalVATAmount = 0)
                            then
                              CurrReport.Break;

                            SetRange(Number,1,VATAmountLine.Count);
                            CurrReport.CreateTotals(VALVATBaseLCY,VALVATAmountLCY);

                            if GLSetup."LCY Code" = '' then
                              VALSpecLCYHeader := Text007 + Text008
                            else
                              VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Header Archive"."Posting Date","Sales Header Archive"."Currency Code",1);
                            VALExchRate := StrSubstNo(Text009,CurrExchRate."Relational Exch. Rate Amount",CurrExchRate."Exchange Rate Amount");
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
                        column(ShipmentMethod_Description;ShipmentMethod.Description)
                        {
                        }
                        column(Total_Number;Number)
                        {
                        }
                        column(PaymentTerms_DescriptionCaption;PaymentTerms_DescriptionCaptionLbl)
                        {
                        }
                        column(ShipmentMethod_DescriptionCaption;ShipmentMethod_DescriptionCaptionLbl)
                        {
                        }
                    }
                    dataitem(Total2;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_3363; 3363)
                        {
                        }
                        column(Sales_Header_Archive___Sell_to_Customer_No__;"Sales Header Archive"."Sell-to Customer No.")
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
                        column(Total2_Number;Number)
                        {
                        }
                        column(Ship_to_AddressCaption;Ship_to_AddressCaptionLbl)
                        {
                        }
                        column(Sales_Header_Archive___Sell_to_Customer_No__Caption;"Sales Header Archive".FieldCaption("Sell-to Customer No."))
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
                    TempSalesHeader: Record "Sales Header" temporary;
                    TempSalesLine: Record "Sales Line" temporary;
                begin
                    InitTempLines(TempSalesHeader,TempSalesLine);

                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount(TempSalesHeader."Currency Code",TempSalesHeader."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                    if Number > 1 then begin
                      CopyText := FormatDocument.GetCOPYText;
                      OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                      Codeunit.Run(Codeunit::"SalesCount-PrintedArch","Sales Header Archive");
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

                FormatAddressFields("Sales Header Archive");
                FormatDocumentFields("Sales Header Archive");

                DimSetEntry1.SetRange("Dimension Set ID","Dimension Set ID");

                CalcFields("No. of Archived Versions");
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
        SalesSetup.Get;

        case SalesSetup."Logo Position on Documents" of
          SalesSetup."logo position on documents"::"No Logo":
            ;
          SalesSetup."logo position on documents"::Left:
            CompanyInfo.CalcFields(Picture);
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

    var
        Text004: label 'Sales Order Archived %1', Comment='%1 = Document No.';
        Text005: label 'Page %1';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        VATAmountLine: Record "VAT Amount Line" temporary;
        TempSalesLineArchive: Record "Sales Line Archive" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        CurrExchRate: Record "Currency Exchange Rate";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
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
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: label 'Tax Amount Specification in ';
        Text008: label 'Local Currency';
        Text009: label 'Exchange rate: %1/%2';
        VALExchRate: Text[50];
        Text011: label 'Version %1 of %2';
        OutputNo: Integer;
        CompanyInfo__Phone_No__CaptionLbl: label 'Phone No.';
        CompanyInfo__Fax_No__CaptionLbl: label 'Fax No.';
        CompanyInfo__VAT_Registration_No__CaptionLbl: label 'Tax Reg. No.';
        CompanyInfo__Giro_No__CaptionLbl: label 'Giro No.';
        CompanyInfo__Bank_Name_CaptionLbl: label 'Bank';
        CompanyInfo__Bank_Account_No__CaptionLbl: label 'Account No.';
        Sales_Header_Archive___Shipment_Date_CaptionLbl: label 'Shipment Date';
        Order_No_CaptionLbl: label 'Order No.';
        Header_DimensionsCaptionLbl: label 'Header Dimensions';
        Unit_PriceCaptionLbl: label 'Unit Price';
        Sales_Line_Archive___Line_Discount___CaptionLbl: label 'Disc. %';
        AmountCaptionLbl: label 'Amount';
        ContinuedCaptionLbl: label 'Continued';
        ContinuedCaption_Control83Lbl: label 'Continued';
        SalesLineArch__Inv__Discount_Amount_CaptionLbl: label 'Inv. Discount Amount';
        SubtotalCaptionLbl: label 'Subtotal';
        VATDiscountAmountCaptionLbl: label 'Payment Discount on VAT';
        Line_DimensionsCaptionLbl: label 'Line Dimensions';
        VATAmountLine__VAT___CaptionLbl: label 'Tax %';
        VATAmountLine__VAT_Base__Control106CaptionLbl: label 'Tax Base';
        VATAmountLine__VAT_Amount__Control107CaptionLbl: label 'Tax Amount';
        VAT_Amount_SpecificationCaptionLbl: label 'Tax Amount Specification';
        VATAmountLine__Inv__Disc__Base_Amount__Control73CaptionLbl: label 'Inv. Disc. Base Amount';
        VATAmountLine__Line_Amount__Control72CaptionLbl: label 'Line Amount';
        VATAmountLine__Invoice_Discount_Amount__Control74CaptionLbl: label 'Invoice Discount Amount';
        VATAmountLine__VAT_Identifier_CaptionLbl: label 'Tax Identifier';
        VATAmountLine__VAT_Base_CaptionLbl: label 'Continued';
        VATAmountLine__VAT_Base__Control110CaptionLbl: label 'Continued';
        VATAmountLine__VAT_Base__Control114CaptionLbl: label 'Total';
        VALVATAmountLCY_Control149CaptionLbl: label 'Tax Amount';
        VALVATBaseLCY_Control150CaptionLbl: label 'Tax Base';
        VATAmountLine__VAT____Control151CaptionLbl: label 'Tax %';
        VATAmountLine__VAT_Identifier__Control152CaptionLbl: label 'Tax Identifier';
        VALVATBaseLCYCaptionLbl: label 'Continued';
        VALVATBaseLCY_Control157CaptionLbl: label 'Continued';
        VALVATBaseLCY_Control160CaptionLbl: label 'Total';
        PaymentTerms_DescriptionCaptionLbl: label 'Payment Terms';
        ShipmentMethod_DescriptionCaptionLbl: label 'Shipment Method';
        Ship_to_AddressCaptionLbl: label 'Ship-to Address';

    local procedure FormatAddressFields(var SalesHeaderArchive: Record "Sales Header Archive")
    begin
        FormatAddr.GetCompanyAddr(SalesHeaderArchive."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
        FormatAddr.SalesHeaderArchBillTo(CustAddr,SalesHeaderArchive);
        ShowShippingAddr := FormatAddr.SalesHeaderArchShipTo(ShipToAddr,CustAddr,SalesHeaderArchive);
    end;

    local procedure FormatDocumentFields(SalesHeaderArchive: Record "Sales Header Archive")
    begin
        with SalesHeaderArchive do begin
          FormatDocument.SetTotalLabels("Currency Code",TotalText,TotalInclVATText,TotalExclVATText);
          FormatDocument.SetSalesPerson(SalesPurchPerson,"Salesperson Code",SalesPersonText);
          FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
          FormatDocument.SetPaymentTerms(PrepmtPaymentTerms,"Prepmt. Payment Terms Code","Language Code");
          FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");

          ReferenceText := FormatDocument.SetText("Your Reference" <> '',FieldCaption("Your Reference"));
          VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FieldCaption("VAT Registration No."));
        end;
    end;

    local procedure InitTempLines(var TempSalesHeader: Record "Sales Header" temporary;var TempSalesLine: Record "Sales Line" temporary)
    begin
        TempSalesLineArchive.CopyTempLines("Sales Header Archive",TempSalesLine);

        VATAmountLine.DeleteAll;
        TempSalesHeader.TransferFields("Sales Header Archive");
        TempSalesLine."Prepayment Line" := true;  // used as flag in CalcVATAmountLines -> not invoice rounding
        TempSalesLine.CalcVATAmountLines(0,TempSalesHeader,TempSalesLine,VATAmountLine);
    end;
}

