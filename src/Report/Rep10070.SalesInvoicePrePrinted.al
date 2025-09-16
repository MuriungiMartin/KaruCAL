#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10070 "Sales Invoice (Pre-Printed)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales Invoice (Pre-Printed).rdlc';
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
            column(Sales_Invoice_Header_No_;"No.")
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
                        InsertTempLine(Comment,10);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TempSalesInvoiceLine := "Sales Invoice Line";
                    TempSalesInvoiceLine.Insert;
                    HighestLineNo := "Line No.";
                end;

                trigger OnPreDataItem()
                begin
                    TempSalesInvoiceLine.Reset;
                    TempSalesInvoiceLine.DeleteAll;
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
                    InsertTempLine(Comment,1000);
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
                    column(Sales_Invoice_Header___No__;"Sales Invoice Header"."No.")
                    {
                    }
                    column(Sales_Invoice_Header___Document_Date_;"Sales Invoice Header"."Document Date")
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
                    column(TaxRegLabel;TaxRegLabel)
                    {
                    }
                    column(TaxRegNo;TaxRegNo)
                    {
                    }
                    column(CopyNo;CopyNo)
                    {
                    }
                    column(SalesInvLine_Number;SalesInvLine.Number)
                    {
                    }
                    column(PageLoop_Number;Number)
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
                        column(PrintFooter;PrintFooter)
                        {
                        }
                        column(STRSUBSTNO_Text002_CurrReport_PAGENO___1_;StrSubstNo(Text002,CurrReport.PageNo + 1))
                        {
                        }
                        column(AmountExclInvDisc_Control40;AmountExclInvDisc)
                        {
                        }
                        column(TaxLiable;TaxLiable)
                        {
                        }
                        column(TempSalesInvoiceLine_Amount___TaxLiable;TempSalesInvoiceLine.Amount - TaxLiable)
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
                        column(BreakdownTitle;BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel_1_;BreakdownLabel[1])
                        {
                        }
                        column(BreakdownLabel_2_;BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt_1_;BreakdownAmt[1])
                        {
                        }
                        column(BreakdownAmt_2_;BreakdownAmt[2])
                        {
                        }
                        column(BreakdownAmt_3_;BreakdownAmt[3])
                        {
                        }
                        column(BreakdownLabel_3_;BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt_4_;BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel_4_;BreakdownLabel[4])
                        {
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
                            end;
                            if OnLineNumber = NumberOfLines then
                              PrintFooter := true;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(TaxLiable,AmountExclInvDisc,TempSalesInvoiceLine.Amount,TempSalesInvoiceLine."Amount Including VAT");
                            NumberOfLines := TempSalesInvoiceLine.Count;
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
                CurrReport.Language := Language.GetLanguageID("Language Code");

                if PrintCompany then
                  if RespCenter.Get("Responsibility Center") then begin
                    FormatAddress.RespCenter(CompanyAddress,RespCenter);
                    CompanyInformation."Phone No." := RespCenter."Phone No.";
                    CompanyInformation."Fax No." := RespCenter."Fax No.";
                  end;

                if not Customer.Get("Bill-to Customer No.") then begin
                  Clear(Customer);
                  "Bill-to Name" := Text009;
                  "Ship-to Name" := Text009;
                end;

                FormatAddress.SalesInvBillTo(BillToAddress,"Sales Invoice Header");
                FormatAddress.SalesInvShipTo(ShipToAddress,ShipToAddress,"Sales Invoice Header");

                FormatDocumentFields("Sales Invoice Header");

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
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        OrderLine: Record "Sales Line";
        ShipmentLine: Record "Sales Shipment Line";
        TempSalesInvoiceLine: Record "Sales Invoice Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;
        TaxArea: Record "Tax Area";
        SalesInvPrinted: Codeunit "Sales Inv.-Printed";
        FormatAddress: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        SegManagement: Codeunit SegManagement;
        CompanyAddress: array [8] of Text[50];
        BillToAddress: array [8] of Text[50];
        ShipToAddress: array [8] of Text[50];
        CopyTxt: Text[10];
        SalespersonText: Text[50];
        DescriptionToPrint: Text[210];
        HighDescriptionToPrint: Text[210];
        LowDescriptionToPrint: Text[210];
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        LogInteraction: Boolean;
        Text000: label 'COPY';
        Text001: label 'Transferred from page %1';
        Text002: label 'Transferred to page %1';
        TaxRegNo: Text[30];
        TaxRegLabel: Text[30];
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        BreakdownLabel: array [4] of Text[30];
        BreakdownAmt: array [4] of Decimal;
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        Text003: label 'Sales Tax Breakdown:';
        Text004: label 'Other Taxes';
        Text005: label 'Total Sales Tax:';
        Text006: label 'Tax Breakdown:';
        Text007: label 'Total Tax:';
        Text008: label 'Tax:';
        Text009: label 'VOID INVOICE';
        [InDataSet]
        LogInteractionEnable: Boolean;


    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;

    local procedure FormatDocumentFields(SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        with SalesInvoiceHeader do begin
          FormatDocument.SetSalesPerson(SalesPurchPerson,"Salesperson Code",SalespersonText);
          FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
          FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");
        end;
    end;

    local procedure InsertTempLine(Comment: Text[80];IncrNo: Integer)
    begin
        with TempSalesInvoiceLine do begin
          Init;
          "Document No." := "Sales Invoice Header"."No.";
          "Line No." := HighestLineNo + IncrNo;
          HighestLineNo := "Line No.";
        end;
        FormatDocument.ParseComment(Comment,TempSalesInvoiceLine.Description,TempSalesInvoiceLine."Description 2");
        TempSalesInvoiceLine.Insert;
    end;
}

