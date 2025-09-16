#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10042 "Sales Stats."
{
    Caption = 'Sales Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Sales Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("TotalSalesLine.""Line Amount""";TotalSalesLine."Line Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Caption = 'Amount';
                    Editable = false;
                }
                field("TotalSalesLine.""Inv. Discount Amount""";TotalSalesLine."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        UpdateInvDiscAmount;
                    end;
                }
                field(TotalAmount1;TotalAmount1)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Caption = 'Total';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        UpdateTotalAmount;
                    end;
                }
                field(TaxAmount;TaxAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Tax Amount';
                    Editable = false;
                }
                field(TotalAmount2;TotalAmount2)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,true);
                    Caption = 'Total Incl. Tax';
                    Editable = false;
                }
                field("TotalSalesLineLCY.Amount";TotalSalesLineLCY.Amount)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Sales ($)';
                    Editable = false;
                }
                field(ProfitLCY;ProfitLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Profit ($)';
                    Editable = false;
                }
                field(ProfitPct;ProfitPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                }
                field("TotalSalesLine.Quantity";TotalSalesLine.Quantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalSalesLine.""Units per Parcel""";TotalSalesLine."Units per Parcel")
                {
                    ApplicationArea = Basic;
                    Caption = 'Parcels';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalSalesLine.""Net Weight""";TotalSalesLine."Net Weight")
                {
                    ApplicationArea = Basic;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalSalesLine.""Gross Weight""";TotalSalesLine."Gross Weight")
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalSalesLine.""Unit Volume""";TotalSalesLine."Unit Volume")
                {
                    ApplicationArea = Basic;
                    Caption = 'Volume';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                label(BreakdownTitle)
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(BreakdownTitle);
                    Editable = false;
                }
                field("BreakdownAmt[1]";BreakdownAmt[1])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[1]);
                    Editable = false;
                }
                field("BreakdownAmt[2]";BreakdownAmt[2])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[2]);
                    Editable = false;
                }
                field("BreakdownAmt[3]";BreakdownAmt[3])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[3]);
                    Editable = false;
                }
                field("BreakdownAmt[4]";BreakdownAmt[4])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[4]);
                    Editable = false;
                }
            }
            part(SubForm;"Sales Tax Lines Subform")
            {
            }
            group(Customer)
            {
                Caption = 'Customer';
                field("Cust.""Balance (LCY)""";Cust."Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Balance ($)';
                    Editable = false;
                }
                field("Cust.""Credit Limit (LCY)""";Cust."Credit Limit (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Credit Limit ($)';
                    Editable = false;
                }
                field(CreditLimitLCYExpendedPct;CreditLimitLCYExpendedPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Expended % of Credit Limit ($)';
                    ExtendedDatatype = Ratio;
                    ToolTip = 'Specifies the Expended Percentage of Credit Limit ($).';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;
    begin
        CurrPage.Caption(StrSubstNo(Text000,"Document Type"));
        if PrevNo = "No." then
          exit;
        PrevNo := "No.";
        FilterGroup(2);
        SetRange("No.",PrevNo);
        FilterGroup(0);
        Clear(SalesLine);
        Clear(TotalSalesLine);
        Clear(TotalSalesLineLCY);
        Clear(SalesPost);
        Clear(TaxAmount);
        SalesTaxCalculate.StartSalesTaxCalculation;
        SalesLine.SetRange("Document Type","Document Type");
        SalesLine.SetRange("Document No.","No.");
        SalesLine.SetFilter(Type,'>0');
        SalesLine.SetFilter(Quantity,'<>0');
        if SalesLine.Find('-') then
          repeat
            TempSalesLine.Copy(SalesLine);
            TempSalesLine.Insert;
            if not TaxArea."Use External Tax Engine" then
              SalesTaxCalculate.AddSalesLine(TempSalesLine);
          until SalesLine.Next = 0;
        TempSalesTaxLine.DeleteAll;

        OnBeforeCalculateSalesTax(Rec,TempSalesTaxLine,TempSalesTaxAmtLine,SalesTaxCalculationOverridden);

        if not SalesTaxCalculationOverridden then begin
          if TaxArea."Use External Tax Engine" then
            SalesTaxCalculate.CallExternalTaxEngineForSales(Rec,true)
          else
            SalesTaxCalculate.EndSalesTaxCalculation("Posting Date");

          SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine);
          SalesTaxCalculate.DistTaxOverSalesLines(TempSalesLine);
        end;

        SalesPost.SumSalesLinesTemp(
          Rec,TempSalesLine,0,TotalSalesLine,TotalSalesLineLCY,
          TaxAmount,TaxAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);

        if "Prices Including VAT" then begin
          TotalAmount2 := TotalSalesLine.Amount;
          TotalAmount1 := TotalAmount2 + TaxAmount;
          TotalSalesLine."Line Amount" := TotalAmount1 + TotalSalesLine."Inv. Discount Amount";
        end else begin
          TotalAmount1 := TotalSalesLine.Amount;
          TotalAmount2 := TotalSalesLine."Amount Including VAT";
        end;

        if not SalesTaxCalculationOverridden then
          SalesTaxCalculate.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
        UpdateTaxBreakdown(TempSalesTaxAmtLine,true);
        if Cust.Get("Bill-to Customer No.") then
          Cust.CalcFields("Balance (LCY)")
        else
          Clear(Cust);
        if Cust."Credit Limit (LCY)" = 0 then
          CreditLimitLCYExpendedPct := 0
        else
          if Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0 then
            CreditLimitLCYExpendedPct := 0
          else
            if Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1 then
              CreditLimitLCYExpendedPct := 10000
            else
              CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000,1);

        TempSalesTaxLine.ModifyAll(Modified,false);
        SetVATSpecification;
        OnActivateForm;
    end;

    trigger OnOpenPage()
    begin
        SalesSetup.Get;
        AllowInvDisc :=
          not (SalesSetup."Calc. Inv. Discount" and CustInvDiscRecExists("Invoice Disc. Code"));
        AllowVATDifference :=
          SalesSetup."Allow VAT Difference" and
          not ("Document Type" in ["document type"::Quote,"document type"::"Blanket Order"]);
        CurrPage.Editable :=
          AllowVATDifference or AllowInvDisc;
        TaxArea.Get("Tax Area Code");
        SetVATSpecification;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        GetVATSpecification;
        if TempSalesTaxLine.GetAnyLineModified then
          UpdateVATOnSalesLines;
        exit(true);
    end;

    var
        Text000: label 'Sales %1 Statistics';
        Text001: label 'Total';
        Text002: label 'Amount';
        Text003: label '%1 must not be 0.';
        Text004: label '%1 must not be greater than %2.';
        Text005: label 'You cannot change the invoice discount because there is a %1 record for %2 %3.';
        TotalSalesLine: Record "Sales Line";
        TotalSalesLineLCY: Record "Sales Line";
        Cust: Record Customer;
        TempSalesTaxLine: Record UnknownRecord10011 temporary;
        SalesSetup: Record "Sales & Receivables Setup";
        TaxArea: Record "Tax Area";
        SalesTaxDifference: Record UnknownRecord10012;
        SalesPost: Codeunit "Sales-Post";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        TotalAmount1: Decimal;
        TotalAmount2: Decimal;
        TaxAmount: Decimal;
        TaxAmountText: Text[30];
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        TotalAdjCostLCY: Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        PrevNo: Code[20];
        AllowInvDisc: Boolean;
        AllowVATDifference: Boolean;
        BreakdownTitle: Text[35];
        BreakdownLabel: array [4] of Text[30];
        BreakdownAmt: array [4] of Decimal;
        BrkIdx: Integer;
        Text006: label 'Tax Breakdown:';
        Text007: label 'Sales Tax Breakdown:';
        Text008: label 'Other Taxes';
        SalesTaxCalculationOverridden: Boolean;

    local procedure UpdateHeaderInfo()
    var
        CurrExchRate: Record "Currency Exchange Rate";
        UseDate: Date;
    begin
        TotalAmount1 :=
          TotalSalesLine."Line Amount" - TotalSalesLine."Inv. Discount Amount";
        if not SalesTaxCalculationOverridden then
          TaxAmount := TempSalesTaxLine.GetTotalTaxAmountFCY;
        if "Prices Including VAT" then
          TotalAmount2 := TotalSalesLine.Amount
        else
          TotalAmount2 := TotalAmount1 + TaxAmount;

        if "Prices Including VAT" then
          TotalSalesLineLCY.Amount := TotalAmount2
        else
          TotalSalesLineLCY.Amount := TotalAmount1;
        if "Currency Code" <> '' then begin
          if "Document Type" = "document type"::Quote then
            UseDate := WorkDate
          else
            UseDate := "Posting Date";
          TotalSalesLineLCY.Amount :=
            CurrExchRate.ExchangeAmtFCYToLCY(
              UseDate,"Currency Code",TotalSalesLineLCY.Amount,"Currency Factor");
        end;
        ProfitLCY := TotalSalesLineLCY.Amount - TotalSalesLineLCY."Unit Cost (LCY)";
        if TotalSalesLineLCY.Amount = 0 then
          ProfitPct := 0
        else
          ProfitPct := ROUND(100 * ProfitLCY / TotalSalesLineLCY.Amount,0.01);
    end;

    local procedure GetVATSpecification()
    begin
        CurrPage.SubForm.Page.GetTempTaxAmountLine(TempSalesTaxLine);
        UpdateHeaderInfo;
    end;

    local procedure SetVATSpecification()
    begin
        CurrPage.SubForm.Page.SetTempTaxAmountLine(TempSalesTaxLine);
        CurrPage.SubForm.Page.InitGlobals(
          "Currency Code",AllowVATDifference,AllowVATDifference,
          "Prices Including VAT",AllowInvDisc,"VAT Base Discount %");
    end;

    local procedure UpdateTotalAmount()
    var
        SaveTotalAmount: Decimal;
    begin
        CheckAllowInvDisc;
        if "Prices Including VAT" then begin
          SaveTotalAmount := TotalAmount1;
          UpdateInvDiscAmount;
          TotalAmount1 := SaveTotalAmount;
        end;
        with TotalSalesLine do
          "Inv. Discount Amount" := "Line Amount" - TotalAmount1;
        UpdateInvDiscAmount;
    end;

    local procedure UpdateInvDiscAmount()
    var
        InvDiscBaseAmount: Decimal;
    begin
        CheckAllowInvDisc;
        InvDiscBaseAmount := TempSalesTaxLine.GetTotalInvDiscBaseAmount(false,"Currency Code");
        if InvDiscBaseAmount = 0 then
          Error(Text003,TempSalesTaxLine.FieldCaption("Inv. Disc. Base Amount"));

        if TotalSalesLine."Inv. Discount Amount" / InvDiscBaseAmount > 1 then
          Error(
            Text004,
            TotalSalesLine.FieldCaption("Inv. Discount Amount"),
            TempSalesTaxLine.FieldCaption("Inv. Disc. Base Amount"));

        TempSalesTaxLine.SetInvoiceDiscountAmount(
          TotalSalesLine."Inv. Discount Amount","Currency Code","Prices Including VAT","VAT Base Discount %");
        CurrPage.SubForm.Page.SetTempTaxAmountLine(TempSalesTaxLine);
        UpdateHeaderInfo;

        "Invoice Discount Calculation" := "invoice discount calculation"::Amount;
        "Invoice Discount Value" := TotalSalesLine."Inv. Discount Amount";
        Modify;
        UpdateVATOnSalesLines;
    end;

    local procedure GetCaptionClass(FieldCaption: Text[100];ReverseCaption: Boolean): Text[80]
    begin
        if "Prices Including VAT" xor ReverseCaption then
          exit('2,1,' + FieldCaption);

        exit('2,0,' + FieldCaption);
    end;

    local procedure UpdateVATOnSalesLines()
    var
        SalesLine: Record "Sales Line";
    begin
        GetVATSpecification;

        SalesLine.Reset;
        SalesLine.SetRange("Document Type","Document Type");
        SalesLine.SetRange("Document No.","No.");
        SalesLine.FindFirst;

        if TempSalesTaxLine.GetAnyLineModified then begin
          SalesTaxCalculate.StartSalesTaxCalculation;
          SalesTaxCalculate.PutSalesTaxAmountLineTable(
            TempSalesTaxLine,
            SalesTaxDifference."document product area"::Sales,
            "Document Type","No.");
          SalesTaxCalculate.DistTaxOverSalesLines(SalesLine);
          SalesTaxCalculate.SaveTaxDifferences;
        end;

        PrevNo := '';
    end;

    local procedure CustInvDiscRecExists(InvDiscCode: Code[20]): Boolean
    var
        CustInvDisc: Record "Cust. Invoice Disc.";
    begin
        CustInvDisc.SetRange(Code,InvDiscCode);
        exit(CustInvDisc.FindFirst);
    end;

    local procedure CheckAllowInvDisc()
    var
        CustInvDisc: Record "Cust. Invoice Disc.";
    begin
        if not AllowInvDisc then
          Error(
            Text005,
            CustInvDisc.TableCaption,FieldCaption("Invoice Disc. Code"),"Invoice Disc. Code");
    end;

    local procedure UpdateTaxBreakdown(var TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;UpdateTaxAmount: Boolean)
    var
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
    begin
        Clear(BreakdownLabel);
        Clear(BreakdownAmt);
        BrkIdx := 0;
        PrevPrintOrder := 0;
        PrevTaxPercent := 0;
        if TaxArea."Country/Region" = TaxArea."country/region"::CA then
          BreakdownTitle := Text006
        else
          BreakdownTitle := Text007;
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
                if BrkIdx > ArrayLen(BreakdownAmt) then begin
                  BrkIdx := BrkIdx - 1;
                  BreakdownLabel[BrkIdx] := Text008;
                end else
                  BreakdownLabel[BrkIdx] := StrSubstNo("Print Description","Tax %");
              end;
              BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Amount";
              if UpdateTaxAmount then
                TaxAmount := TaxAmount + "Tax Amount"
              else
                BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Difference";
            until Next = 0;
        end;
    end;

    local procedure OnActivateForm()
    begin
        if "No." = PrevNo then
          GetVATSpecification;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateSalesTax(var SalesHeader: Record "Sales Header";var SalesTaxAmountLine: Record UnknownRecord10011;var SalesTaxAmountLine2: Record UnknownRecord10011;var Handled: Boolean)
    begin
    end;
}

