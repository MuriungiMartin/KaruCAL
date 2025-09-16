#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10473 "Service Credit Memo-Sales Tax"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service Credit Memo-Sales Tax.rdlc';
    Caption = 'Service Credit Memo';
    Permissions = TableData "Sales Shipment Buffer"=rimd;

    dataset
    {
        dataitem("Service Cr.Memo Header";"Service Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Customer No.","No. Printed";
            RequestFilterHeading = 'Service Credit Memo';
            column(ReportForNavId_1020012; 1020012)
            {
            }
            dataitem("Service Cr.Memo Line";"Service Cr.Memo Line")
            {
                DataItemLink = "Document No."=field("No.");
                DataItemTableView = sorting("Document No.","Line No.");
                column(ReportForNavId_1020013; 1020013)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TempServCrMemoLine := "Service Cr.Memo Line";
                    TempServCrMemoLine.Insert;
                end;

                trigger OnPreDataItem()
                begin
                    TempServCrMemoLine.Reset;
                    TempServCrMemoLine.DeleteAll;
                end;
            }
            dataitem(CopyLoop;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_1020017; 1020017)
                {
                }
                dataitem(PageLoop;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=const(1));
                    column(ReportForNavId_1020018; 1020018)
                    {
                    }
                    column(CompanyInfo2Picture;CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture;CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyInfo1Picture;CompanyInfo1.Picture)
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
                    column(AppltoDocType_ServCrMemoHeader;"Service Cr.Memo Header"."Applies-to Doc. Type")
                    {
                    }
                    column(AppltoDocNo_ServCrMemoHeader;"Service Cr.Memo Header"."Applies-to Doc. No.")
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
                    column(BilltoCustNo_ServCrMemoHeader;"Service Cr.Memo Header"."Bill-to Customer No.")
                    {
                    }
                    column(YourRef_ServCrMemoHeader;"Service Cr.Memo Header"."Your Reference")
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(No_ServCrMemoHeader;"Service Cr.Memo Header"."No.")
                    {
                    }
                    column(DocDate_ServCrMemoHeader;"Service Cr.Memo Header"."Document Date")
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
                    column(TaxRegLabel;TaxRegLabel)
                    {
                    }
                    column(TaxRegNo;TaxRegNo)
                    {
                    }
                    column(PrintFooter;PrintFooter)
                    {
                    }
                    column(CopyNo;CopyNo)
                    {
                    }
                    column(CustTaxIdentificationType;Format(Cust."Tax Identification Type"))
                    {
                    }
                    column(CreditCaption;Text010)
                    {
                    }
                    column(ToCaption;Text011)
                    {
                    }
                    column(ApplytoTypeCaption;Text012)
                    {
                    }
                    column(ApplytoNumberCaption;Text013)
                    {
                    }
                    column(CustomerIDCaption;Text014)
                    {
                    }
                    column(PONumberCaption;Text015)
                    {
                    }
                    column(SalesPersonCaption;Text016)
                    {
                    }
                    column(ShipCaption;Text017)
                    {
                    }
                    column(CreditMemoCaption;Text018)
                    {
                    }
                    column(CreditMemoNumberCaption;Text019)
                    {
                    }
                    column(CreditMemoDateCaption;Text020)
                    {
                    }
                    column(PageCaption;Text021)
                    {
                    }
                    column(TaxIdentTypeCaption;Text022)
                    {
                    }
                    dataitem(ServCrMemoLine;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_1020021; 1020021)
                        {
                        }
                        column(Number_IntegerLine;Number)
                        {
                        }
                        column(AmountExclInvDisc;AmountExclInvDisc)
                        {
                        }
                        column(TempServCrMemoLineNo;TempServCrMemoLine."No.")
                        {
                        }
                        column(TempServCrMemoLineUOM;TempServCrMemoLine."Unit of Measure")
                        {
                        }
                        column(TempServCrMemoLineQty;TempServCrMemoLine.Quantity)
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(UnitPriceToPrint;UnitPriceToPrint)
                        {
                            DecimalPlaces = 2:5;
                        }
                        column(TempServCrMemoLineDesc;TempServCrMemoLine.Description + ' ' + TempServCrMemoLine."Description 2")
                        {
                        }
                        column(BreakdownLabel1;BreakdownLabel[1])
                        {
                        }
                        column(BreakdownTitle;BreakdownTitle)
                        {
                        }
                        column(BreakdownAmt1;BreakdownAmt[1])
                        {
                        }
                        column(TaxLiable;TaxLiable)
                        {
                        }
                        column(TempServCrMemoLineAmtTaxLiable;TempServCrMemoLine.Amount - TaxLiable)
                        {
                        }
                        column(BreakdownLabel2;BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt2;BreakdownAmt[2])
                        {
                        }
                        column(TotalTaxLabel;TotalTaxLabel)
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
                        column(TempServCrMemoLineAmtAmtExclInvDisc;TempServCrMemoLine.Amount - AmountExclInvDisc)
                        {
                        }
                        column(TempServCrMemoLineAmtInclVATAmount;TempServCrMemoLine."Amount Including VAT" - TempServCrMemoLine.Amount)
                        {
                        }
                        column(TempServCrMemoLineAmtInclVAT;TempServCrMemoLine."Amount Including VAT")
                        {
                        }
                        column(ItemNoCaption;Text023)
                        {
                        }
                        column(UnitCaption;Text024)
                        {
                        }
                        column(DescriptionCaption;Text025)
                        {
                        }
                        column(QuantityCaption;Text026)
                        {
                        }
                        column(UnitPriceCaption;Text027)
                        {
                        }
                        column(TotalPriceCaption;Text028)
                        {
                        }
                        column(AmountSubjecttoSalesTaxCaption;Text029)
                        {
                        }
                        column(AmountExemptfromSalesTaxCaption;Text030)
                        {
                        }
                        column(InvoiceDiscountCaption;Text031)
                        {
                        }
                        column(SubtotalCaption;Text032)
                        {
                        }
                        column(TotalCaption;Text033)
                        {
                        }
                        dataitem("Service Shipment Buffer";"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_1020022; 1020022)
                            {
                            }
                            column(ServiceShptBufferPostDate;ServiceShipmentBuffer."Posting Date")
                            {
                            }
                            column(ServiceShptBufferQty;ServiceShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(ReturnReceiptCaption;Text034)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                  ServiceShipmentBuffer.Find('-')
                                else
                                  ServiceShipmentBuffer.Next;

                                if Number > 1 then begin
                                  TaxLiable := 0;
                                  AmountExclInvDisc := 0;
                                  TempServCrMemoLine.Amount := 0;
                                  TempServCrMemoLine."Amount Including VAT" := 0;
                                end
                            end;

                            trigger OnPreDataItem()
                            begin
                                SetRange(Number,1,ServiceShipmentBuffer.Count);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;
                            with TempServCrMemoLine do begin
                              if OnLineNumber = 1 then
                                Find('-')
                              else
                                Next;

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
                            CurrReport.CreateTotals(TaxLiable,AmountExclInvDisc,TempServCrMemoLine.Amount,TempServCrMemoLine."Amount Including VAT");
                            NumberOfLines := TempServCrMemoLine.Count;
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
                        ServiceCrMemoPrinted.Run("Service Cr.Memo Header");
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

                if "Bill-to Customer No." = '' then begin
                  "Bill-to Name" := Text009;
                  "Ship-to Name" := Text009;
                end;

                FormatAddress.ServiceCrMemoBillTo(BillToAddress,"Service Cr.Memo Header");
                FormatAddress.ServiceCrMemoShipTo(ShipToAddress,ShipToAddress,"Service Cr.Memo Header");

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
                    SalesTaxCalc.CallExternalTaxEngineForDoc(Database::"Service Cr.Memo Header",0,"No.")
                  else begin
                    SalesTaxCalc.AddServCrMemoLines("No.");
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
                    field(NumberOfCopies;NoCopies)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Number of Copies';
                    }
                    field(PrintCompanyAddress;PrintCompany)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Company Address';
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

    trigger OnPreReport()
    begin
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
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        TempServCrMemoLine: Record "Service Cr.Memo Line" temporary;
        ServiceShipmentBuffer: Record "Service Shipment Buffer" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;
        TaxArea: Record "Tax Area";
        Cust: Record Customer;
        CompanyAddress: array [8] of Text[50];
        BillToAddress: array [8] of Text[50];
        ShipToAddress: array [8] of Text[50];
        CopyTxt: Text[10];
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        ServiceCrMemoPrinted: Codeunit "Service Cr. Memo-Printed";
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        Text000: label 'COPY';
        TaxRegNo: Text[30];
        TaxRegLabel: Text[30];
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        BreakdownLabel: array [4] of Text[30];
        BreakdownAmt: array [4] of Decimal;
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        Text003: label 'Sales Tax Breakdown:';
        Text004: label 'Other Taxes';
        Text005: label 'Total Sales Tax:';
        Text006: label 'Tax Breakdown:';
        Text007: label 'Total Tax:';
        Text008: label 'Tax:';
        Text009: label 'VOID CREDIT MEMO';
        Text010: label 'Credit';
        Text011: label 'To:';
        Text012: label 'Apply to Type';
        Text013: label 'Apply to Number';
        Text014: label 'Customer ID';
        Text015: label 'P.O. Number';
        Text016: label 'SalesPerson';
        Text017: label 'Ship';
        Text018: label 'Credit Memo';
        Text019: label 'Credit Memo Number:';
        Text020: label 'Credit Memo Date:';
        Text021: label 'Page';
        Text022: label 'Tax Ident. Type';
        Text023: label 'Item No.';
        Text024: label 'Unit';
        Text025: label 'Description';
        Text026: label 'Quantity';
        Text027: label 'Unit Price';
        Text028: label 'Total Price';
        Text029: label 'Amount Subject to Sales Tax';
        Text030: label 'Amount Exempt from Sales Tax';
        Text031: label 'Invoice Discount:';
        Text032: label 'Subtotal:';
        Text033: label 'Total:';
        Text034: label 'Return Receipt';


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
}

