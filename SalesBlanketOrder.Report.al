#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10069 "Sales Blanket Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales Blanket Order.rdlc';
    Caption = 'Sales Blanket Order';

    dataset
    {
        dataitem("Sales Header";"Sales Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const("Blanket Order"));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Sell-to Customer No.","No. Printed";
            RequestFilterHeading = 'Blanket Sales Order';
            column(ReportForNavId_6640; 6640)
            {
            }
            column(No_SalesHeader;"No.")
            {
            }
            dataitem("Sales Line";"Sales Line")
            {
                DataItemLink = "Document No."=field("No.");
                DataItemTableView = sorting("Document Type","Document No.","Line No.") where("Document Type"=const("Blanket Order"));
                column(ReportForNavId_2844; 2844)
                {
                }
                dataitem(SalesLineComments;"Sales Comment Line")
                {
                    DataItemLink = "No."=field("Document No."),"Document Line No."=field("Line No.");
                    DataItemTableView = sorting("Document Type","No.","Document Line No.","Line No.") where("Document Type"=const("Blanket Order"),"Print On Order Confirmation"=const(Yes));
                    column(ReportForNavId_7380; 7380)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        InsertTempLine(Comment,10);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TempSalesLine := "Sales Line";
                    TempSalesLine.Insert;
                    HighestLineNo := "Line No.";
                    if ("Sales Header"."Tax Area Code" <> '') and not UseExternalTaxEngine then
                      SalesTaxCalc.AddSalesLine(TempSalesLine);
                end;

                trigger OnPostDataItem()
                begin
                    if "Sales Header"."Tax Area Code" <> '' then begin
                      if UseExternalTaxEngine then
                        SalesTaxCalc.CallExternalTaxEngineForSales("Sales Header",true)
                      else
                        SalesTaxCalc.EndSalesTaxCalculation(UseDate);
                      SalesTaxCalc.DistTaxOverSalesLines(TempSalesLine);
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

                trigger OnPreDataItem()
                begin
                    TempSalesLine.Reset;
                    TempSalesLine.DeleteAll;
                end;
            }
            dataitem("Sales Comment Line";"Sales Comment Line")
            {
                DataItemLink = "No."=field("No.");
                DataItemTableView = sorting("Document Type","No.","Document Line No.","Line No.") where("Document Type"=const("Blanket Order"),"Print On Order Confirmation"=const(Yes),"Document Line No."=const(0));
                column(ReportForNavId_8541; 8541)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    InsertTempLine(Comment,1000);
                end;

                trigger OnPreDataItem()
                begin
                    with TempSalesLine do begin
                      Init;
                      "Document Type" := "Sales Header"."Document Type";
                      "Document No." := "Sales Header"."No.";
                      "Line No." := HighestLineNo + 1000;
                      HighestLineNo := "Line No.";
                    end;
                    TempSalesLine.Insert;
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
                    column(CompanyInfoPicture;CompanyInfo3.Picture)
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(OrderDate_SalesHeader;"Sales Header"."Order Date")
                    {
                    }
                    column(YourRef_SalesHeader;"Sales Header"."Your Reference")
                    {
                    }
                    column(BilltoCustNo_SalesHeader;"Sales Header"."Bill-to Customer No.")
                    {
                    }
                    column(ShipToAddress8;ShipToAddress[8])
                    {
                    }
                    column(ShipToAddress7;ShipToAddress[7])
                    {
                    }
                    column(ShipToAddress6;ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress5;ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress4;ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress3;ShipToAddress[3])
                    {
                    }
                    column(ShipmentMethodDesc;ShipmentMethod.Description)
                    {
                    }
                    column(PaymentTermsDesc;PaymentTerms.Description)
                    {
                    }
                    column(TaxRegNo;TaxRegNo)
                    {
                    }
                    column(ShipToAddress2;ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress1;ShipToAddress[1])
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
                    column(BillToAddress8;BillToAddress[8])
                    {
                    }
                    column(BillToAddress4;BillToAddress[4])
                    {
                    }
                    column(BillToAddress3;BillToAddress[3])
                    {
                    }
                    column(BillToAddress2;BillToAddress[2])
                    {
                    }
                    column(BillToAddress1;BillToAddress[1])
                    {
                    }
                    column(CompanyAddress8;CompanyAddress[8])
                    {
                    }
                    column(CompanyAddress7;CompanyAddress[7])
                    {
                    }
                    column(ShptDate_SalesHeader;"Sales Header"."Shipment Date")
                    {
                    }
                    column(CompanyAddress6;CompanyAddress[6])
                    {
                    }
                    column(CompanyAddress5;CompanyAddress[5])
                    {
                    }
                    column(CopyTxt;CopyTxt)
                    {
                    }
                    column(CompanyAddress4;CompanyAddress[4])
                    {
                    }
                    column(TaxRegLabel;TaxRegLabel)
                    {
                    }
                    column(CompanyAddress3;CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress2;CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress1;CompanyAddress[1])
                    {
                    }
                    column(Number_IntegerLine;SalesLine.Number)
                    {
                    }
                    column(CopyNo;CopyNo)
                    {
                    }
                    column(CustTaxIdentificationType;Format(Cust."Tax Identification Type"))
                    {
                    }
                    column(PONumberCaption;PONumberCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption;SalesPersonCaptionLbl)
                    {
                    }
                    column(PODateCaption;PODateCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption;CustomerIDCaptionLbl)
                    {
                    }
                    column(ToCaption;ToCaptionLbl)
                    {
                    }
                    column(ShipCaption;ShipCaptionLbl)
                    {
                    }
                    column(PageCaption;PageCaptionLbl)
                    {
                    }
                    column(SalesOrderDateCaption;SalesOrderDateCaptionLbl)
                    {
                    }
                    column(SalesOrderNumberCaption;SalesOrderNumberCaptionLbl)
                    {
                    }
                    column(ShipDateCaption;ShipDateCaptionLbl)
                    {
                    }
                    column(ShipViaCaption;ShipViaCaptionLbl)
                    {
                    }
                    column(TermsCaption;TermsCaptionLbl)
                    {
                    }
                    column(BlanketSalesOrderCaption;BlanketSalesOrderCaptionLbl)
                    {
                    }
                    column(SoldCaption;SoldCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption;TaxIdentTypeCaptionLbl)
                    {
                    }
                    dataitem(SalesLine;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_9018; 9018)
                        {
                        }
                        column(PrintFooter;PrintFooter)
                        {
                        }
                        column(AmountExclInvDisc;AmountExclInvDisc)
                        {
                        }
                        column(TempSalesLineNo;TempSalesLine."No.")
                        {
                        }
                        column(TempSalesLineDesc;TempSalesLine.Description + ' ' + TempSalesLine."Description 2")
                        {
                        }
                        column(TempSalesLineUOM;TempSalesLine."Unit of Measure")
                        {
                        }
                        column(TempSalesLineQuantity;TempSalesLine.Quantity)
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(UnitPriceToPrint;UnitPriceToPrint)
                        {
                            DecimalPlaces = 2:5;
                        }
                        column(TaxLiable;TaxLiable)
                        {
                        }
                        column(TempSalesLineLineAmtTaxLiable;TempSalesLine."Line Amount" - TaxLiable)
                        {
                        }
                        column(BreakdownLabel1;BreakdownLabel[1])
                        {
                        }
                        column(BreakdownLabel2;BreakdownLabel[2])
                        {
                        }
                        column(BreakdownLabel3;BreakdownLabel[3])
                        {
                        }
                        column(BreakdownTitle;BreakdownTitle)
                        {
                        }
                        column(BreakdownAmt1;BreakdownAmt[1])
                        {
                        }
                        column(BreakdownAmt2;BreakdownAmt[2])
                        {
                        }
                        column(BreakdownAmt3;BreakdownAmt[3])
                        {
                        }
                        column(TotalTaxLabel;TotalTaxLabel)
                        {
                        }
                        column(TempSalesLineInvDiscAmt;TempSalesLine."Inv. Discount Amount")
                        {
                        }
                        column(TaxAmount;TaxAmount)
                        {
                        }
                        column(TempSalesLineLineAmtTaxAmtInvDiscAmt;TempSalesLine."Line Amount" + TaxAmount - TempSalesLine."Inv. Discount Amount")
                        {
                        }
                        column(BreakdownAmt4;BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel4;BreakdownLabel[4])
                        {
                        }
                        column(ItemNoCaption;ItemNoCaptionLbl)
                        {
                        }
                        column(DescriptionCaption;DescriptionCaptionLbl)
                        {
                        }
                        column(UnitCaption;UnitCaptionLbl)
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
                        column(AmtSubjecttoSalesTaxCptn;AmtSubjecttoSalesTaxCptnLbl)
                        {
                        }
                        column(AmtExemptfromSalesTaxCptn;AmtExemptfromSalesTaxCptnLbl)
                        {
                        }
                        column(InvoiceDiscountCaption;InvoiceDiscountCaptionLbl)
                        {
                        }
                        column(SubtotalCaption;SubtotalCaptionLbl)
                        {
                        }
                        column(TotalCaption;TotalCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            with TempSalesLine do begin
                              if OnLineNumber = 1 then
                                Find('-')
                              else
                                Next;

                              if Type = 0 then begin
                                "No." := '';
                                "Unit of Measure" := '';
                                "Line Amount" := 0;
                                "Inv. Discount Amount" := 0;
                                Quantity := 0;
                              end else
                                if Type = Type::"G/L Account" then
                                  "No." := '';

                              if "Tax Area Code" <> '' then
                                TaxAmount := "Amount Including VAT" - Amount
                              else
                                TaxAmount := 0;
                              if TaxAmount <> 0 then
                                TaxLiable := Amount
                              else
                                TaxLiable := 0;

                              AmountExclInvDisc := "Line Amount";

                              if Quantity = 0 then
                                UnitPriceToPrint := 0 // so it won't print
                              else
                                UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity,0.00001);
                            end;
                            if OnLineNumber = NumberOfLines then
                              PrintFooter := true;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(TaxLiable,TaxAmount,AmountExclInvDisc,TempSalesLine."Line Amount",TempSalesLine."Inv. Discount Amount");
                            NumberOfLines := TempSalesLine.Count;
                            SetRange(Number,1,NumberOfLines);
                            OnLineNumber := 0;
                            PrintFooter := false;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    CurrReport.PageNo := 1;

                    if CopyNo = NoLoops then begin
                      if not CurrReport.Preview then
                        SalesPrinted.Run("Sales Header");
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
                    NoLoops := 1 + Abs(NoCopies);
                    if NoLoops <= 0 then
                      NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                if PrintCompany then
                  if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddress,RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                  end;

                FormatAddr.SalesHeaderSellTo(BillToAddress,"Sales Header");
                FormatAddr.SalesHeaderShipTo(ShipToAddress,ShipToAddress,"Sales Header");

                FormatDocumentFields("Sales Header");

                if not Cust.Get("Sell-to Customer No.") then
                  Clear(Cust);

                if LogInteraction then
                  if not CurrReport.Preview then begin
                    if "Bill-to Contact No." <> '' then
                      SegManagement.LogDocument(
                        2,"No.",0,0,Database::Contact,"Bill-to Contact No.","Salesperson Code",
                        "Campaign No.","Posting Description","Opportunity No.")
                    else
                      SegManagement.LogDocument(
                        2,"No.",0,0,Database::Customer,"Bill-to Customer No.","Salesperson Code",
                        "Campaign No.","Posting Description","Opportunity No.");
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
                        TaxRegNo := CompanyInfo."VAT Registration No.";
                        TaxRegLabel := CompanyInfo.FieldCaption("VAT Registration No.");
                      end;
                  end;
                  UseExternalTaxEngine := TaxArea."Use External Tax Engine";
                  SalesTaxCalc.StartSalesTaxCalculation;
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
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                    field(PrintCompany;PrintCompany)
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
            LogInteraction := SegManagement.FindInteractTmplCode(2) <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        SalesSetup.Get;
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents",CompanyInfo1,CompanyInfo2,CompanyInfo3);
    end;

    trigger OnPreReport()
    begin
        if PrintCompany then
          FormatAddr.Company(CompanyAddress,CompanyInfo)
        else
          Clear(CompanyAddress);
    end;

    var
        Text000: label 'COPY';
        UnitPriceToPrint: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        CompanyInfo: Record "Company Information";
        TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;
        TaxArea: Record "Tax Area";
        Language: Record Language;
        RespCenter: Record "Responsibility Center";
        TempSalesLine: Record "Sales Line" temporary;
        Cust: Record Customer;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        SalesPrinted: Codeunit "Sales-Printed";
        ShipToAddress: array [8] of Text[50];
        BillToAddress: array [8] of Text[50];
        CompanyAddress: array [8] of Text[50];
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        CopyTxt: Text[30];
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        LogInteraction: Boolean;
        TaxLiable: Decimal;
        TaxAmount: Decimal;
        Text003: label 'Sales Tax Breakdown:';
        Text004: label 'Other Taxes';
        Text005: label 'Total Sales Tax:';
        Text006: label 'Tax Breakdown:';
        Text007: label 'Total Tax:';
        Text008: label 'Tax:';
        TaxRegNo: Text[30];
        TaxRegLabel: Text[30];
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        BreakdownLabel: array [4] of Text[30];
        BreakdownAmt: array [4] of Decimal;
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        AmountExclInvDisc: Decimal;
        UseDate: Date;
        UseExternalTaxEngine: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        PONumberCaptionLbl: label 'P.O. Number';
        SalesPersonCaptionLbl: label 'SalesPerson';
        PODateCaptionLbl: label 'P.O. Date';
        CustomerIDCaptionLbl: label 'Customer ID';
        ToCaptionLbl: label 'To:';
        ShipCaptionLbl: label 'Ship';
        PageCaptionLbl: label 'Page:';
        SalesOrderDateCaptionLbl: label 'Sales Order Date:';
        SalesOrderNumberCaptionLbl: label 'Sales Order Number:';
        ShipDateCaptionLbl: label 'Ship Date';
        ShipViaCaptionLbl: label 'Ship Via';
        TermsCaptionLbl: label 'Terms';
        BlanketSalesOrderCaptionLbl: label 'Blanket Sales Order';
        SoldCaptionLbl: label 'Sold';
        TaxIdentTypeCaptionLbl: label 'Tax Ident. Type';
        ItemNoCaptionLbl: label 'Item No.';
        DescriptionCaptionLbl: label 'Description';
        UnitCaptionLbl: label 'Unit';
        QuantityCaptionLbl: label 'Quantity';
        UnitPriceCaptionLbl: label 'Unit Price';
        TotalPriceCaptionLbl: label 'Total Price';
        AmtSubjecttoSalesTaxCptnLbl: label 'Amount Subject to Sales Tax';
        AmtExemptfromSalesTaxCptnLbl: label 'Amount Exempt from Sales Tax';
        InvoiceDiscountCaptionLbl: label 'Invoice Discount:';
        SubtotalCaptionLbl: label 'Subtotal:';
        TotalCaptionLbl: label 'Total:';

    local procedure FormatDocumentFields(SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do begin
          FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
          FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");
        end;
    end;

    local procedure InsertTempLine(Comment: Text[80];IncrNo: Integer)
    begin
        with TempSalesLine do begin
          Init;
          "Document Type" := "Sales Header"."Document Type";
          "Document No." := "Sales Header"."No.";
          "Line No." := HighestLineNo + IncrNo;
          HighestLineNo := "Line No.";
        end;
        FormatDocument.ParseComment(Comment,TempSalesLine.Description,TempSalesLine."Description 2");
        TempSalesLine.Insert;
    end;
}

