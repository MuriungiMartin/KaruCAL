#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10477 "Elec. Sales Invoice MX"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Elec. Sales Invoice MX.rdlc';
    Caption = 'Electronic Sales Invoice Mexico';
    Permissions = TableData "Sales Invoice Line"=rimd;

    dataset
    {
        dataitem("Sales Invoice Header";"Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Sell-to Customer No.","Bill-to Customer No.","Ship-to Code","No. Printed";
            RequestFilterHeading = 'Sales Invoice';
            column(ReportForNavId_5581; 5581)
            {
            }
            column(Sales_Invoice_Header_No_;"No.")
            {
            }
            column(DocumentFooter;DocumentFooterLbl)
            {
            }
            dataitem("Sales Invoice Line";"Sales Invoice Line")
            {
                DataItemLink = "Document No."=field("No.");
                DataItemTableView = sorting("Document No.","Line No.");
                column(ReportForNavId_1570; 1570)
                {
                }
                dataitem(SalesLineComments;"Sales Comment Line")
                {
                    DataItemLink = "No."=field("Document No."),"Document Line No."=field("Line No.");
                    DataItemTableView = sorting("Document Type","No.","Document Line No.","Line No.") where("Document Type"=const("Posted Invoice"),"Print On Invoice"=const(Yes));
                    column(ReportForNavId_7380; 7380)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        with TempSalesInvoiceLine do begin
                          Init;
                          "Document No." := "Sales Invoice Header"."No.";
                          "Line No." := HighestLineNo + 10;
                          HighestLineNo := "Line No.";
                        end;
                        if StrLen(Comment) <= MaxStrLen(TempSalesInvoiceLine.Description) then begin
                          TempSalesInvoiceLine.Description := Comment;
                          TempSalesInvoiceLine."Description 2" := '';
                        end else begin
                          SpacePointer := MaxStrLen(TempSalesInvoiceLine.Description) + 1;
                          while (SpacePointer > 1) and (Comment[SpacePointer] <> ' ') do
                            SpacePointer := SpacePointer - 1;
                          if SpacePointer = 1 then
                            SpacePointer := MaxStrLen(TempSalesInvoiceLine.Description) + 1;
                          TempSalesInvoiceLine.Description := CopyStr(Comment,1,SpacePointer - 1);
                          TempSalesInvoiceLine."Description 2" :=
                            CopyStr(CopyStr(Comment,SpacePointer + 1),1,MaxStrLen(TempSalesInvoiceLine."Description 2"));
                        end;
                        TempSalesInvoiceLine.Insert;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TempSalesInvoiceLine := "Sales Invoice Line";
                    TempSalesInvoiceLine.Insert;
                    HighestLineNo := "Line No.";
                    TempSalesInvoiceLineAsm := "Sales Invoice Line";
                    TempSalesInvoiceLineAsm.Insert;
                end;

                trigger OnPreDataItem()
                begin
                    TempSalesInvoiceLine.Reset;
                    TempSalesInvoiceLine.DeleteAll;
                    TempSalesInvoiceLineAsm.Reset;
                    TempSalesInvoiceLineAsm.DeleteAll;
                end;
            }
            dataitem("Sales Comment Line";"Sales Comment Line")
            {
                DataItemLink = "No."=field("No.");
                DataItemTableView = sorting("Document Type","No.","Document Line No.","Line No.") where("Document Type"=const("Posted Invoice"),"Print On Invoice"=const(Yes),"Document Line No."=const(0));
                column(ReportForNavId_8541; 8541)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    with TempSalesInvoiceLine do begin
                      Init;
                      "Document No." := "Sales Invoice Header"."No.";
                      "Line No." := HighestLineNo + 1000;
                      HighestLineNo := "Line No.";
                    end;
                    if StrLen(Comment) <= MaxStrLen(TempSalesInvoiceLine.Description) then begin
                      TempSalesInvoiceLine.Description := Comment;
                      TempSalesInvoiceLine."Description 2" := '';
                    end else begin
                      SpacePointer := MaxStrLen(TempSalesInvoiceLine.Description) + 1;
                      while (SpacePointer > 1) and (Comment[SpacePointer] <> ' ') do
                        SpacePointer := SpacePointer - 1;
                      if SpacePointer = 1 then
                        SpacePointer := MaxStrLen(TempSalesInvoiceLine.Description) + 1;
                      TempSalesInvoiceLine.Description := CopyStr(Comment,1,SpacePointer - 1);
                      TempSalesInvoiceLine."Description 2" :=
                        CopyStr(CopyStr(Comment,SpacePointer + 1),1,MaxStrLen(TempSalesInvoiceLine."Description 2"));
                    end;
                    TempSalesInvoiceLine.Insert;
                end;

                trigger OnPreDataItem()
                begin
                    with TempSalesInvoiceLine do begin
                      Init;
                      "Document No." := "Sales Invoice Header"."No.";
                      "Line No." := HighestLineNo + 1000;
                      HighestLineNo := "Line No.";
                    end;
                    TempSalesInvoiceLine.Insert;
                end;
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
                    column(CompanyInformation_Picture;CompanyInformation.Picture)
                    {
                    }
                    column(CompanyAddress_1_;CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress_2_;CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress_3_;CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress_4_;CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress_5_;CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress_6_;CompanyAddress[6])
                    {
                    }
                    column(CopyTxt;CopyTxt)
                    {
                    }
                    column(BillToAddress_1_;BillToAddress[1])
                    {
                    }
                    column(BillToAddress_2_;BillToAddress[2])
                    {
                    }
                    column(BillToAddress_3_;BillToAddress[3])
                    {
                    }
                    column(BillToAddress_4_;BillToAddress[4])
                    {
                    }
                    column(BillToAddress_5_;BillToAddress[5])
                    {
                    }
                    column(BillToAddress_6_;BillToAddress[6])
                    {
                    }
                    column(BillToAddress_7_;BillToAddress[7])
                    {
                    }
                    column(ShipmentMethod_Description;ShipmentMethod.Description)
                    {
                    }
                    column(Sales_Invoice_Header___Shipment_Date_;"Sales Invoice Header"."Shipment Date")
                    {
                    }
                    column(Sales_Invoice_Header___Due_Date_;"Sales Invoice Header"."Due Date")
                    {
                    }
                    column(PaymentTerms_Description;PaymentTerms.Description)
                    {
                    }
                    column(ShipToAddress_1_;ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress_2_;ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress_3_;ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress_4_;ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress_5_;ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress_6_;ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress_7_;ShipToAddress[7])
                    {
                    }
                    column(Sales_Invoice_Header___Bill_to_Customer_No__;"Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(Sales_Invoice_Header___Your_Reference_;"Sales Invoice Header"."Your Reference")
                    {
                    }
                    column(Sales_Invoice_Header___Order_Date_;"Sales Invoice Header"."Order Date")
                    {
                    }
                    column(Sales_Invoice_Header___Order_No__;"Sales Invoice Header"."Order No.")
                    {
                    }
                    column(SalesPurchPerson_Name;SalesPurchPerson.Name)
                    {
                    }
                    column(CurrReport_PAGENO;CurrReport.PageNo)
                    {
                    }
                    column(CompanyAddress_7_;CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress_8_;CompanyAddress[8])
                    {
                    }
                    column(BillToAddress_8_;BillToAddress[8])
                    {
                    }
                    column(ShipToAddress_8_;ShipToAddress[8])
                    {
                    }
                    column(CopyNo;CopyNo)
                    {
                    }
                    column(DocumentText;DocumentText)
                    {
                    }
                    column(CompanyInformation__RFC_No__;CompanyInformation."RFC No.")
                    {
                    }
                    column(FolioText;"Sales Invoice Header"."Fiscal Invoice Number PAC")
                    {
                    }
                    column(Sales_Invoice_Header___Certificate_Serial_No__;"Sales Invoice Header"."Certificate Serial No.")
                    {
                    }
                    column(NoSeriesLine__Authorization_Code_;"Sales Invoice Header"."Date/Time Stamped")
                    {
                    }
                    column(NoSeriesLine__Authorization_Year_;StrSubstNo(Text013,"Sales Invoice Header"."Bill-to City","Sales Invoice Header"."Document Date"))
                    {
                    }
                    column(Customer__RFC_No__;Customer."RFC No.")
                    {
                    }
                    column(Sales_Invoice_Header___No__;"Sales Invoice Header"."No.")
                    {
                    }
                    column(Customer__Phone_No__;Customer."Phone No.")
                    {
                    }
                    column(PageLoop_Number;Number)
                    {
                    }
                    column(BillCaption;BillCaptionLbl)
                    {
                    }
                    column(Ship_ViaCaption;Ship_ViaCaptionLbl)
                    {
                    }
                    column(Ship_DateCaption;Ship_DateCaptionLbl)
                    {
                    }
                    column(Due_DateCaption;Due_DateCaptionLbl)
                    {
                    }
                    column(TermsCaption;TermsCaptionLbl)
                    {
                    }
                    column(Customer_IDCaption;Customer_IDCaptionLbl)
                    {
                    }
                    column(P_O__NumberCaption;P_O__NumberCaptionLbl)
                    {
                    }
                    column(P_O__DateCaption;P_O__DateCaptionLbl)
                    {
                    }
                    column(Our_Order_No_Caption;Our_Order_No_CaptionLbl)
                    {
                    }
                    column(SalesPersonCaption;SalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption;ShipCaptionLbl)
                    {
                    }
                    column(Page_Caption;Page_CaptionLbl)
                    {
                    }
                    column(CompanyInformation__RFC_No__Caption;CompanyInformation__RFC_No__CaptionLbl)
                    {
                    }
                    column(FolioTextCaption;FolioTextCaptionLbl)
                    {
                    }
                    column(Sales_Invoice_Header___Certificate_Serial_No__Caption;Sales_Invoice_Header___Certificate_Serial_No__CaptionLbl)
                    {
                    }
                    column(NoSeriesLine__Authorization_Code_Caption;NoSeriesLine__Authorization_Code_CaptionLbl)
                    {
                    }
                    column(NoSeriesLine__Authorization_Year_Caption;NoSeriesLine__Authorization_Year_CaptionLbl)
                    {
                    }
                    column(Customer__RFC_No__Caption;Customer__RFC_No__CaptionLbl)
                    {
                    }
                    column(Customer__Phone_No__Caption;Customer__Phone_No__CaptionLbl)
                    {
                    }
                    dataitem(SalesInvLine;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_3054; 3054)
                        {
                        }
                        column(STRSUBSTNO_Text001_CurrReport_PAGENO___1_;StrSubstNo(Text001,CurrReport.PageNo - 1))
                        {
                        }
                        column(AmountExclInvDisc;AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLine__No__;TempSalesInvoiceLine."No.")
                        {
                        }
                        column(TempSalesInvoiceLine__Unit_of_Measure_;TempSalesInvoiceLine."Unit of Measure")
                        {
                        }
                        column(OrderedQuantity;OrderedQuantity)
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(TempSalesInvoiceLine_Quantity;TempSalesInvoiceLine.Quantity)
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(UnitPriceToPrint;UnitPriceToPrint)
                        {
                            DecimalPlaces = 2:5;
                        }
                        column(AmountExclInvDisc_Control53;AmountExclInvDisc)
                        {
                        }
                        column(LowDescription;LowDescriptionToPrint)
                        {
                        }
                        column(HighDescription;HighDescriptionToPrint)
                        {
                        }
                        column(SalesInvLine_Number;Number)
                        {
                        }
                        column(STRSUBSTNO_Text002_CurrReport_PAGENO___1_;StrSubstNo(Text002,CurrReport.PageNo + 1))
                        {
                        }
                        column(AmountExclInvDisc_Control40;AmountExclInvDisc)
                        {
                        }
                        column(AmountExclInvDisc_Control79;AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLine_Amount___AmountExclInvDisc;TempSalesInvoiceLine.Amount - AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLine__Amount_Including_VAT____TempSalesInvoiceLine_Amount;TempSalesInvoiceLine."Amount Including VAT" - TempSalesInvoiceLine.Amount)
                        {
                        }
                        column(TempSalesInvoiceLine__Amount_Including_VAT_;TempSalesInvoiceLine."Amount Including VAT")
                        {
                        }
                        column(AmountInWords_1_;AmountInWords[1])
                        {
                        }
                        column(AmountInWords_2_;AmountInWords[2])
                        {
                        }
                        column(Item_DescriptionCaption;Item_DescriptionCaptionLbl)
                        {
                        }
                        column(UnitCaption;UnitCaptionLbl)
                        {
                        }
                        column(Order_QtyCaption;Order_QtyCaptionLbl)
                        {
                        }
                        column(QuantityCaption;QuantityCaptionLbl)
                        {
                        }
                        column(Unit_PriceCaption;Unit_PriceCaptionLbl)
                        {
                        }
                        column(Total_PriceCaption;Total_PriceCaptionLbl)
                        {
                        }
                        column(Subtotal_Caption;Subtotal_CaptionLbl)
                        {
                        }
                        column(Invoice_Discount_Caption;Invoice_Discount_CaptionLbl)
                        {
                        }
                        column(Total_Caption;Total_CaptionLbl)
                        {
                        }
                        column(Amount_in_words_Caption;Amount_in_words_CaptionLbl)
                        {
                        }
                        column(TempSalesInvoiceLine__Amount_Including_VAT____TempSalesInvoiceLine_AmountCaption;TempSalesInvoiceLine__Amount_Including_VAT____TempSalesInvoiceLine_AmountCaptionLbl)
                        {
                        }
                        dataitem(AsmLoop;"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_9462; 9462)
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
                            column(TempPostedAsmLineDescription;BlanksForIndent + TempPostedAsmLine.Description)
                            {
                            }
                            column(TempPostedAsmLineNo;BlanksForIndent + TempPostedAsmLine."No.")
                            {
                            }
                            column(AsmLoop_Number;Number)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                  TempPostedAsmLine.FindSet
                                else
                                  TempPostedAsmLine.Next;
                            end;

                            trigger OnPreDataItem()
                            begin
                                Clear(TempPostedAsmLine);
                                SetRange(Number,1,TempPostedAsmLine.Count);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            with TempSalesInvoiceLine do begin
                              if OnLineNumber = 1 then
                                Find('-')
                              else
                                Next;

                              OrderedQuantity := 0;
                              if "Sales Invoice Header"."Order No." = '' then
                                OrderedQuantity := Quantity
                              else
                                if OrderLine.Get(1,"Sales Invoice Header"."Order No.","Line No.") then
                                  OrderedQuantity := OrderLine.Quantity
                                else begin
                                  ShipmentLine.SetRange("Order No.","Sales Invoice Header"."Order No.");
                                  ShipmentLine.SetRange("Order Line No.","Line No.");
                                  if ShipmentLine.Find('-') then
                                    repeat
                                      OrderedQuantity := OrderedQuantity + ShipmentLine.Quantity;
                                    until 0 = ShipmentLine.Next;
                                end;

                              DescriptionToPrint := Description + ' ' + "Description 2";
                              if Type = 0 then begin
                                if OnLineNumber < NumberOfLines then begin
                                  Next;
                                  if Type = 0 then begin
                                    DescriptionToPrint :=
                                      CopyStr(DescriptionToPrint + ' ' + Description + ' ' + "Description 2",1,MaxStrLen(DescriptionToPrint));
                                    OnLineNumber := OnLineNumber + 1;
                                    SalesInvLine.Next;
                                  end else
                                    Next(-1);
                                end;
                                "No." := '';
                                "Unit of Measure" := '';
                                Amount := 0;
                                "Amount Including VAT" := 0;
                                "Inv. Discount Amount" := 0;
                                Quantity := 0;
                              end else
                                if Type = Type::"G/L Account" then
                                  "No." := '';

                              if "No." = '' then begin
                                HighDescriptionToPrint := DescriptionToPrint;
                                LowDescriptionToPrint := '';
                              end else begin
                                HighDescriptionToPrint := '';
                                LowDescriptionToPrint := DescriptionToPrint;
                              end;

                              if Amount <> "Amount Including VAT" then
                                TaxLiable := Amount
                              else
                                TaxLiable := 0;

                              AmountExclInvDisc := Amount + "Inv. Discount Amount";

                              if Quantity = 0 then
                                UnitPriceToPrint := 0 // so it won't print
                              else
                                UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity,0.00001);
                              TotalAmountIncludingVAT += "Amount Including VAT";
                            end;

                            CollectAsmInformation(TempSalesInvoiceLine);
                            if OnLineNumber = NumberOfLines then
                              ConvertAmounttoWords(TotalAmountIncludingVAT);
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(TaxLiable,AmountExclInvDisc,TempSalesInvoiceLine.Amount,TempSalesInvoiceLine."Amount Including VAT");
                            NumberOfLines := TempSalesInvoiceLine.Count;
                            SetRange(Number,1,NumberOfLines);
                            OnLineNumber := 0;
                            TotalAmountIncludingVAT := 0;
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
                        column(Digital_stampCaption_Control1020008;Digital_stampCaption_Control1020008Lbl)
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
                        column(Sales_Invoice_Header___QR_Code_;"Sales Invoice Header"."QR Code")
                        {
                        }
                        column(QRCode_Number;Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            "Sales Invoice Header".CalcFields("QR Code");
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    CurrReport.PageNo := 1;

                    if CopyNo = NoLoops then begin
                      if not CurrReport.Preview then
                        SalesInvPrinted.Run("Sales Invoice Header");
                      CurrReport.Break;
                    end;
                    CopyNo := CopyNo + 1;
                    if CopyNo = 1 then // Original
                      Clear(CopyTxt)
                    else
                      CopyTxt := Text000;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + Abs(NoCopies) + Customer."Invoice Copies";
                    if NoLoops <= 0 then
                      NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Source Code" = SourceCodeSetup."Deleted Document" then
                  Error(Text012);

                if PrintCompany then
                  if RespCenter.Get("Responsibility Center") then begin
                    FormatAddress.RespCenter(CompanyAddress,RespCenter);
                    CompanyInformation."Phone No." := RespCenter."Phone No.";
                    CompanyInformation."Fax No." := RespCenter."Fax No.";
                  end;
                CurrReport.Language := Language.GetLanguageID("Language Code");

                if "Salesperson Code" = '' then
                  Clear(SalesPurchPerson)
                else
                  SalesPurchPerson.Get("Salesperson Code");

                if not Customer.Get("Bill-to Customer No.") then begin
                  Clear(Customer);
                  "Bill-to Name" := Text009;
                  "Ship-to Name" := Text009;
                end;
                DocumentText := Text010;
                if "Prepayment Invoice" then
                  DocumentText := Text011;

                FormatAddress.SalesInvBillTo(BillToAddress,"Sales Invoice Header");
                FormatAddress.SalesInvShipTo(ShipToAddress,ShipToAddress,"Sales Invoice Header");

                if "Payment Terms Code" = '' then
                  Clear(PaymentTerms)
                else
                  PaymentTerms.Get("Payment Terms Code");

                if "Shipment Method Code" = '' then
                  Clear(ShipmentMethod)
                else
                  ShipmentMethod.Get("Shipment Method Code");

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

                "Sales Invoice Header".CalcFields("Original String","Digital Stamp SAT","Digital Stamp PAC");
                Clear(OriginalStringBigText);
                TempBlob.Blob := "Sales Invoice Header"."Original String";
                BlobMgt.Read(OriginalStringBigText,TempBlob);
                TempBlob.Blob := "Sales Invoice Header"."Digital Stamp SAT";
                Clear(DigitalSignatureBigText);
                BlobMgt.Read(DigitalSignatureBigText,TempBlob);
                TempBlob.Blob := "Sales Invoice Header"."Digital Stamp PAC";
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
                    field(NoCopies;NoCopies)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Number of Copies';
                        ToolTip = 'Specifies the number of copies to print of the document.';
                    }
                    field(PrintCompany;PrintCompany)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if the printed document includes your company address.';
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with contact persons in connection with the report are logged.';
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

    trigger OnPreReport()
    begin
        ShipmentLine.SetCurrentkey("Order No.","Order Line No.");
        if not CurrReport.UseRequestPage then
          InitLogInteraction;

        CompanyInformation.Get;
        SalesSetup.Get;
        SourceCodeSetup.Get;

        case SalesSetup."Logo Position on Documents" of
          SalesSetup."logo position on documents"::"No Logo":
            ;
          SalesSetup."logo position on documents"::Left:
            CompanyInformation.CalcFields(Picture);
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

        if PrintCompany then
          FormatAddress.Company(CompanyAddress,CompanyInformation)
        else
          Clear(CompanyAddress);
    end;

    var
        TaxLiable: Decimal;
        OrderedQuantity: Decimal;
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        OrderLine: Record "Sales Line";
        ShipmentLine: Record "Sales Shipment Line";
        TempSalesInvoiceLine: Record "Sales Invoice Line" temporary;
        TempSalesInvoiceLineAsm: Record "Sales Invoice Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        TempBlob: Record TempBlob;
        SourceCodeSetup: Record "Source Code Setup";
        TranslationManagement: Report "Check Translation Management";
        BlobMgt: Codeunit "Blob Management";
        CompanyAddress: array [8] of Text[50];
        BillToAddress: array [8] of Text[50];
        ShipToAddress: array [8] of Text[50];
        CopyTxt: Text[10];
        DescriptionToPrint: Text[210];
        HighDescriptionToPrint: Text[210];
        LowDescriptionToPrint: Text[210];
        PrintCompany: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        SpacePointer: Integer;
        SalesInvPrinted: Codeunit "Sales Inv.-Printed";
        FormatAddress: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        Position: Integer;
        LogInteraction: Boolean;
        Text000: label 'COPY';
        Text001: label 'Transferred from page %1';
        Text002: label 'Transferred to page %1';
        TotalAmountIncludingVAT: Decimal;
        OriginalStringText: Text[80];
        DigitalSignatureText: Text[80];
        DigitalSignaturePACText: Text[80];
        AmountInWords: array [2] of Text[80];
        Text009: label 'VOID INVOICE';
        DocumentText: Text[100];
        OriginalStringBigText: BigText;
        DigitalSignatureBigText: BigText;
        Text010: label 'ELECTRONIC INVOICE';
        Text011: label 'ELECTRONIC PREPAYMENT REQUEST';
        Text012: label 'You can not sign or send or print a deleted document.';
        Text013: label '%1, %2';
        DigitalSignaturePACBigText: BigText;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        BillCaptionLbl: label 'Bill-To:';
        Ship_ViaCaptionLbl: label 'Ship Via';
        Ship_DateCaptionLbl: label 'Ship Date';
        Due_DateCaptionLbl: label 'Due Date';
        TermsCaptionLbl: label 'Terms';
        Customer_IDCaptionLbl: label 'Customer ID';
        P_O__NumberCaptionLbl: label 'P.O. Number';
        P_O__DateCaptionLbl: label 'P.O. Date';
        Our_Order_No_CaptionLbl: label 'Our Order No.';
        SalesPersonCaptionLbl: label 'SalesPerson';
        ShipCaptionLbl: label 'Ship-To:';
        Page_CaptionLbl: label 'Page:';
        CompanyInformation__RFC_No__CaptionLbl: label 'Company RFC';
        FolioTextCaptionLbl: label 'Folio:';
        Sales_Invoice_Header___Certificate_Serial_No__CaptionLbl: label 'Certificate Serial No.';
        NoSeriesLine__Authorization_Code_CaptionLbl: label 'Date and time of certification:';
        NoSeriesLine__Authorization_Year_CaptionLbl: label 'Location and Issue date:';
        Customer__RFC_No__CaptionLbl: label 'Customer RFC';
        Customer__Phone_No__CaptionLbl: label 'Phone number ';
        Item_DescriptionCaptionLbl: label 'Item/Description';
        UnitCaptionLbl: label 'Unit';
        Order_QtyCaptionLbl: label 'Order Qty';
        QuantityCaptionLbl: label 'Quantity';
        Unit_PriceCaptionLbl: label 'Unit Price';
        Total_PriceCaptionLbl: label 'Total Price';
        Subtotal_CaptionLbl: label 'Subtotal:';
        Invoice_Discount_CaptionLbl: label 'Invoice Discount:';
        Total_CaptionLbl: label 'Total:';
        Amount_in_words_CaptionLbl: label 'Amount in words:';
        TempSalesInvoiceLine__Amount_Including_VAT____TempSalesInvoiceLine_AmountCaptionLbl: label 'Tax Amount';
        Original_StringCaptionLbl: label 'Original string of digital certificate complement from SAT';
        Digital_StampCaptionLbl: label 'Digital stamp from SAT';
        Digital_stampCaption_Control1020008Lbl: label 'Digital stamp';
        DocumentFooterLbl: label 'This document is a printed version for electronic invoice';


    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;


    procedure ConvertAmounttoWords(AmountLoc: Decimal)
    var
        LanguageId: Integer;
    begin
        if CurrReport.Language in [1033,3084,2058,4105] then
          LanguageId := CurrReport.Language
        else
          LanguageId := GlobalLanguage;
        TranslationManagement.FormatNoText(AmountInWords,AmountLoc,
          LanguageId,"Sales Invoice Header"."Currency Code");
    end;


    procedure CollectAsmInformation(TempSalesInvoiceLine: Record "Sales Invoice Line" temporary)
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        TempPostedAsmLine.DeleteAll;
        if not DisplayAssemblyInformation then
          exit;
        if not TempSalesInvoiceLineAsm.Get(TempSalesInvoiceLine."Document No.",TempSalesInvoiceLine."Line No.") then
          exit;
        SalesInvoiceLine.Get(TempSalesInvoiceLineAsm."Document No.",TempSalesInvoiceLineAsm."Line No.");
        if SalesInvoiceLine.Type <> SalesInvoiceLine.Type::Item then
          exit;
        with ValueEntry do begin
          SetCurrentkey("Document No.");
          SetRange("Document No.",SalesInvoiceLine."Document No.");
          SetRange("Document Type","document type"::"Sales Invoice");
          SetRange("Document Line No.",SalesInvoiceLine."Line No.");
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

