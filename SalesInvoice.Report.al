#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10074 "Sales Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales Invoice.rdlc';
    Caption = 'Sales - Invoice';

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
            column(No_SalesInvHeader;"No.")
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
                    TempSalesInvoiceLineAsm := "Sales Invoice Line";
                    TempSalesInvoiceLineAsm.Insert;

                    HighestLineNo := "Line No.";
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
                column(DisplayAdditionalFeeNote;DisplayAdditionalFeeNote)
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
                    column(CompanyInfo2Picture;CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture;CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInformationPicture;CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyAddress1;CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress2;CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress3;CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress4;CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress5;CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress6;CompanyAddress[6])
                    {
                    }
                    column(CopyTxt;CopyTxt)
                    {
                    }
                    column(BillToAddress1;BillToAddress[1])
                    {
                    }
                    column(BillToAddress2;BillToAddress[2])
                    {
                    }
                    column(BillToAddress3;BillToAddress[3])
                    {
                    }
                    column(BillToAddress4;BillToAddress[4])
                    {
                    }
                    column(BillToAddress5;BillToAddress[5])
                    {
                    }
                    column(BillToAddress6;BillToAddress[6])
                    {
                    }
                    column(BillToAddress7;BillToAddress[7])
                    {
                    }
                    column(ShipmentMethodDescription;ShipmentMethod.Description)
                    {
                    }
                    column(ShptDate_SalesInvHeader;"Sales Invoice Header"."Shipment Date")
                    {
                    }
                    column(DueDate_SalesInvHeader;"Sales Invoice Header"."Due Date")
                    {
                    }
                    column(PaymentTermsDescription;PaymentTerms.Description)
                    {
                    }
                    column(ShipToAddress1;ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress2;ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress3;ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress4;ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress5;ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress6;ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress7;ShipToAddress[7])
                    {
                    }
                    column(BilltoCustNo_SalesInvHeader;"Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(ExtDocNo_SalesInvHeader;"Sales Invoice Header"."External Document No.")
                    {
                    }
                    column(OrderDate_SalesInvHeader;"Sales Invoice Header"."Order Date")
                    {
                    }
                    column(OrderNo_SalesInvHeader;"Sales Invoice Header"."Order No.")
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(DocumentDate_SalesInvHeader;"Sales Invoice Header"."Document Date")
                    {
                    }
                    column(CompanyAddress7;CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8;CompanyAddress[8])
                    {
                    }
                    column(BillToAddress8;BillToAddress[8])
                    {
                    }
                    column(ShipToAddress8;ShipToAddress[8])
                    {
                    }
                    column(TaxRegNo;TaxRegNo)
                    {
                    }
                    column(TaxRegLabel;TaxRegLabel)
                    {
                    }
                    column(DocumentText;DocumentText)
                    {
                    }
                    column(CopyNo;CopyNo)
                    {
                    }
                    column(CustTaxIdentificationType;Format(Cust."Tax Identification Type"))
                    {
                    }
                    column(BillCaption;BillCaptionLbl)
                    {
                    }
                    column(ToCaption;ToCaptionLbl)
                    {
                    }
                    column(ShipViaCaption;ShipViaCaptionLbl)
                    {
                    }
                    column(ShipDateCaption;ShipDateCaptionLbl)
                    {
                    }
                    column(DueDateCaption;DueDateCaptionLbl)
                    {
                    }
                    column(TermsCaption;TermsCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption;CustomerIDCaptionLbl)
                    {
                    }
                    column(PONumberCaption;PONumberCaptionLbl)
                    {
                    }
                    column(PODateCaption;PODateCaptionLbl)
                    {
                    }
                    column(OurOrderNoCaption;OurOrderNoCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption;SalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption;ShipCaptionLbl)
                    {
                    }
                    column(InvoiceNumberCaption;InvoiceNumberCaptionLbl)
                    {
                    }
                    column(InvoiceDateCaption;InvoiceDateCaptionLbl)
                    {
                    }
                    column(PageCaption;PageCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption;TaxIdentTypeCaptionLbl)
                    {
                    }
                    dataitem(SalesInvLine;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_3054; 3054)
                        {
                        }
                        column(AmountExclInvDisc;AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLineNo;TempSalesInvoiceLine."No.")
                        {
                        }
                        column(TempSalesInvoiceLineUOM;TempSalesInvoiceLine."Unit of Measure")
                        {
                        }
                        column(OrderedQuantity;OrderedQuantity)
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(TempSalesInvoiceLineQty;TempSalesInvoiceLine.Quantity)
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(UnitPriceToPrint;UnitPriceToPrint)
                        {
                            DecimalPlaces = 2:5;
                        }
                        column(LowDescriptionToPrint;LowDescriptionToPrint)
                        {
                        }
                        column(HighDescriptionToPrint;HighDescriptionToPrint)
                        {
                        }
                        column(TempSalesInvoiceLineDocNo;TempSalesInvoiceLine."Document No.")
                        {
                        }
                        column(TempSalesInvoiceLineLineNo;TempSalesInvoiceLine."Line No.")
                        {
                        }
                        column(TaxLiable;TaxLiable)
                        {
                        }
                        column(TempSalesInvoiceLineAmtTaxLiable;TempSalesInvoiceLine.Amount - TaxLiable)
                        {
                        }
                        column(TempSalesInvoiceLineAmtAmtExclInvDisc;TempSalesInvoiceLine.Amount - AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLineAmtInclVATAmount;TempSalesInvoiceLine."Amount Including VAT" - TempSalesInvoiceLine.Amount)
                        {
                        }
                        column(TempSalesInvoiceLineAmtInclVAT;TempSalesInvoiceLine."Amount Including VAT")
                        {
                        }
                        column(TotalTaxLabel;TotalTaxLabel)
                        {
                        }
                        column(BreakdownTitle;BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel1;BreakdownLabel[1])
                        {
                        }
                        column(BreakdownAmt1;BreakdownAmt[1])
                        {
                        }
                        column(BreakdownAmt2;BreakdownAmt[2])
                        {
                        }
                        column(BreakdownLabel2;BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt3;BreakdownAmt[3])
                        {
                        }
                        column(BreakdownLabel3;BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt4;BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel4;BreakdownLabel[4])
                        {
                        }
                        column(ItemDescriptionCaption;ItemDescriptionCaptionLbl)
                        {
                        }
                        column(UnitCaption;UnitCaptionLbl)
                        {
                        }
                        column(OrderQtyCaption;OrderQtyCaptionLbl)
                        {
                        }
                        column(QuantityCaption;QuantityCaptionLbl)
                        {
                        }
                        column(UnitPriceCaption;UnitPriceCaptionLbl)
                        {
                        }
                        column(TotalPriceCaption;TotalPriceCaptionLbl)
                        {
                        }
                        column(SubtotalCaption;SubtotalCaptionLbl)
                        {
                        }
                        column(InvoiceDiscountCaption;InvoiceDiscountCaptionLbl)
                        {
                        }
                        column(TotalCaption;TotalCaption)
                        {
                        }
                        column(AmountSubjecttoSalesTaxCaption;AmountSubjecttoSalesTaxCaption)
                        {
                        }
                        column(AmountExemptfromSalesTaxCaption;AmountExemptfromSalesTaxCaption)
                        {
                        }
                        dataitem(AsmLoop;"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_9462; 9462)
                            {
                            }
                            column(TempPostedAsmLineUOMCode;GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(TempPostedAsmLineQuantity;TempPostedAsmLine.Quantity)
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
                            begin
                                if Number = 1 then
                                  TempPostedAsmLine.FindSet
                                else begin
                                  TempPostedAsmLine.Next;
                                  TaxLiable := 0;
                                  AmountExclInvDisc := 0;
                                  TempSalesInvoiceLine.Amount := 0;
                                  TempSalesInvoiceLine."Amount Including VAT" := 0;
                                end;
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
                            end;

                            CollectAsmInformation(TempSalesInvoiceLine);
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(TaxLiable,AmountExclInvDisc,TempSalesInvoiceLine.Amount,TempSalesInvoiceLine."Amount Including VAT");
                            NumberOfLines := TempSalesInvoiceLine.Count;
                            SetRange(Number,1,NumberOfLines);
                            OnLineNumber := 0;
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
                DocumentText := USText000;
                if "Prepayment Invoice" then
                  DocumentText := USText001;

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

                if "Currency Code" = '' then begin
                  GLSetup.TestField("LCY Code");
                  TotalCaption := StrSubstNo(TotalCaptionTxt,GLSetup."LCY Code");
                  AmountExemptfromSalesTaxCaption := StrSubstNo(AmountExemptfromSalesTaxCaptionTxt,GLSetup."LCY Code");
                  AmountSubjecttoSalesTaxCaption := StrSubstNo(AmountSubjecttoSalesTaxCaptionTxt,GLSetup."LCY Code");
                end else begin
                  TotalCaption := StrSubstNo(TotalCaptionTxt,"Currency Code");
                  AmountExemptfromSalesTaxCaption := StrSubstNo(AmountExemptfromSalesTaxCaption,"Currency Code");
                  AmountSubjecttoSalesTaxCaption := StrSubstNo(AmountSubjecttoSalesTaxCaption,"Currency Code");
                end;

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

                Clear(BreakdownTitle);
                Clear(BreakdownLabel);
                Clear(BreakdownAmt);
                TotalTaxLabel := Text008;
                TaxRegNo := '';
                TaxRegLabel := '';
                if "Tax Area Code" <> '' then begin
                  TaxArea.Get("Tax Area Code");
                  case TaxArea."Country/Region" of
                    TaxArea."country/region"::US:
                      TotalTaxLabel := Text005;
                    TaxArea."country/region"::CA:
                      begin
                        TotalTaxLabel := Text007;
                        TaxRegNo := CompanyInformation."VAT Registration No.";
                        TaxRegLabel := CompanyInformation.FieldCaption("VAT Registration No.");
                      end;
                  end;
                  SalesTaxCalc.StartSalesTaxCalculation;
                  if TaxArea."Use External Tax Engine" then
                    SalesTaxCalc.CallExternalTaxEngineForDoc(Database::"Sales Invoice Header",0,"No.")
                  else begin
                    SalesTaxCalc.AddSalesInvoiceLines("No.");
                    SalesTaxCalc.EndSalesTaxCalculation("Posting Date");
                  end;
                  SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                  BrkIdx := 0;
                  PrevPrintOrder := 0;
                  PrevTaxPercent := 0;
                  with TempSalesTaxAmtLine do begin
                    Reset;
                    SetCurrentkey("Print Order","Tax Area Code for Key","Tax Jurisdiction Code");
                    if Find('-') then
                      repeat
                        if ("Print Order" = 0) or
                           ("Print Order" <> PrevPrintOrder) or
                           ("Tax %" <> PrevTaxPercent)
                        then begin
                          BrkIdx := BrkIdx + 1;
                          if BrkIdx > 1 then begin
                            if TaxArea."Country/Region" = TaxArea."country/region"::CA then
                              BreakdownTitle := Text006
                            else
                              BreakdownTitle := Text003;
                          end;
                          if BrkIdx > ArrayLen(BreakdownAmt) then begin
                            BrkIdx := BrkIdx - 1;
                            BreakdownLabel[BrkIdx] := Text004;
                          end else
                            BreakdownLabel[BrkIdx] := StrSubstNo("Print Description","Tax %");
                        end;
                        BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Amount";
                      until Next = 0;
                  end;
                  if BrkIdx = 1 then begin
                    Clear(BreakdownLabel);
                    Clear(BreakdownAmt);
                  end;
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
                    field(NoCopies;NoCopies)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Number of Copies';
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                    field(PrintCompanyAddress;PrintCompany)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.';
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.';
                    }
                    field(DisplayAsmInfo;DisplayAssemblyInformation)
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
    end;

    trigger OnPreReport()
    begin
        ShipmentLine.SetCurrentkey("Order No.","Order Line No.");
        if not CurrReport.UseRequestPage then
          InitLogInteraction;

        CompanyInformation.Get;
        SalesSetup.Get;

        case SalesSetup."Logo Position on Documents" of
          SalesSetup."logo position on documents"::"No Logo":
            ;
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
        CompanyInfo3: Record "Company Information";
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
        TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;
        TaxArea: Record "Tax Area";
        Cust: Record Customer;
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        GLSetup: Record "General Ledger Setup";
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
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        SegManagement: Codeunit SegManagement;
        LogInteraction: Boolean;
        Text000: label 'COPY';
        TaxRegNo: Text[30];
        TaxRegLabel: Text[30];
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        BreakdownLabel: array [4] of Text[30];
        BreakdownAmt: array [4] of Decimal;
        Text003: label 'Sales Tax Breakdown:';
        Text004: label 'Other Taxes';
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        Text005: label 'Total Sales Tax:';
        Text006: label 'Tax Breakdown:';
        Text007: label 'Total Tax:';
        Text008: label 'Tax:';
        Text009: label 'VOID INVOICE';
        DocumentText: Text[20];
        USText000: label 'INVOICE';
        USText001: label 'PREPAYMENT REQUEST';
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        BillCaptionLbl: label 'Bill';
        ToCaptionLbl: label 'To:';
        ShipViaCaptionLbl: label 'Ship Via';
        ShipDateCaptionLbl: label 'Ship Date';
        DueDateCaptionLbl: label 'Due Date';
        TermsCaptionLbl: label 'Terms';
        CustomerIDCaptionLbl: label 'Customer ID';
        PONumberCaptionLbl: label 'P.O. Number';
        PODateCaptionLbl: label 'P.O. Date';
        OurOrderNoCaptionLbl: label 'Our Order No.';
        SalesPersonCaptionLbl: label 'SalesPerson';
        ShipCaptionLbl: label 'Ship';
        InvoiceNumberCaptionLbl: label 'Invoice Number:';
        InvoiceDateCaptionLbl: label 'Invoice Date:';
        PageCaptionLbl: label 'Page:';
        TaxIdentTypeCaptionLbl: label 'Tax Ident. Type';
        ItemDescriptionCaptionLbl: label 'Item/Description';
        UnitCaptionLbl: label 'Unit';
        OrderQtyCaptionLbl: label 'Order Qty';
        QuantityCaptionLbl: label 'Quantity';
        UnitPriceCaptionLbl: label 'Unit Price';
        TotalPriceCaptionLbl: label 'Total Price';
        SubtotalCaptionLbl: label 'Subtotal:';
        InvoiceDiscountCaptionLbl: label 'Invoice Discount:';
        TotalCaptionTxt: label 'Total %1:';
        AmountSubjecttoSalesTaxCaptionTxt: label 'Amount Subject to Sales Tax %1';
        AmountExemptfromSalesTaxCaptionTxt: label 'Amount Exempt from Sales Tax %1';
        TotalCaption: Text;
        AmountSubjecttoSalesTaxCaption: Text;
        AmountExemptfromSalesTaxCaption: Text;
        DisplayAdditionalFeeNote: Boolean;


    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
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
          SetRange("Applies-to Entry",0);
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

