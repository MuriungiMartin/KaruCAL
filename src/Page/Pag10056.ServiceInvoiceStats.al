#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10056 "Service Invoice Stats."
{
    Caption = 'Service Invoice Stats.';
    Editable = false;
    PageType = Document;
    SourceTable = "Service Invoice Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("CustAmount + InvDiscAmount";CustAmount + InvDiscAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Amount';
                }
                field(InvDiscAmount;InvDiscAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                }
                field(CustAmount;CustAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Total';
                }
                field(TaxAmount;TaxAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Tax Amount';
                }
                field(AmountInclTax;AmountInclTax)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Total Incl. Tax';
                }
                field(AmountLCY;AmountLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Sales ($)';
                }
                field(ProfitLCY;ProfitLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Original Profit ($)';
                }
                field(AdjProfitLCY;AdjProfitLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Profit ($)';
                }
                field(ProfitPct;ProfitPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Original Profit %';
                    DecimalPlaces = 1:1;
                }
                field(AdjProfitPct;AdjProfitPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Adjusted Profit %';
                    DecimalPlaces = 1:1;
                }
                field(LineQty;LineQty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                }
                field(TotalParcels;TotalParcels)
                {
                    ApplicationArea = Basic;
                    Caption = 'Parcels';
                    DecimalPlaces = 0:5;
                }
                field(TotalNetWeight;TotalNetWeight)
                {
                    ApplicationArea = Basic;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0:5;
                }
                field(TotalGrossWeight;TotalGrossWeight)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0:5;
                }
                field(TotalVolume;TotalVolume)
                {
                    ApplicationArea = Basic;
                    Caption = 'Volume';
                    DecimalPlaces = 0:5;
                }
                field(CostLCY;CostLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Original Cost ($)';
                }
                field(TotalAdjCostLCY;TotalAdjCostLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Cost ($)';
                }
                field("TotalAdjCostLCY - CostLCY";TotalAdjCostLCY - CostLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Cost Adjmt. Amount ($)';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupAdjmtValueEntries;
                    end;
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
            part(Subform;"Sales Tax Lines Serv. Subform")
            {
                Editable = false;
            }
            group(Customer)
            {
                Caption = 'Customer';
                field("Cust.""Balance (LCY)""";Cust."Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Balance ($)';
                }
                field("Cust.""Credit Limit (LCY)""";Cust."Credit Limit (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Credit Limit ($)';
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
        TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        CostCalcMgt: Codeunit "Cost Calculation Management";
    begin
        ClearAll;
        TaxArea.Get("Tax Area Code");

        if "Currency Code" = '' then
          Currency.InitRoundingPrecision
        else
          Currency.Get("Currency Code");

        ServInvLine.SetRange("Document No.","No.");

        if ServInvLine.Find('-') then
          repeat
            CustAmount := CustAmount + ServInvLine.Amount;
            AmountInclTax := AmountInclTax + ServInvLine."Amount Including VAT";
            if "Prices Including VAT" then
              InvDiscAmount := InvDiscAmount + ServInvLine."Inv. Discount Amount" / (1 + ServInvLine."VAT %" / 100)
            else
              InvDiscAmount := InvDiscAmount + ServInvLine."Inv. Discount Amount";
            CostLCY := CostLCY + (ServInvLine.Quantity * ServInvLine."Unit Cost (LCY)");
            LineQty := LineQty + ServInvLine.Quantity;
            TotalNetWeight := TotalNetWeight + (ServInvLine.Quantity * ServInvLine."Net Weight");
            TotalGrossWeight := TotalGrossWeight + (ServInvLine.Quantity * ServInvLine."Gross Weight");
            TotalVolume := TotalVolume + (ServInvLine.Quantity * ServInvLine."Unit Volume");
            if ServInvLine."Units per Parcel" > 0 then
              TotalParcels := TotalParcels + ROUND(ServInvLine.Quantity / ServInvLine."Units per Parcel",1,'>');
            if ServInvLine."VAT %" <> TaxPercentage then
              if TaxPercentage = 0 then
                TaxPercentage := ServInvLine."VAT %"
              else
                TaxPercentage := -1;
            TotalAdjCostLCY := TotalAdjCostLCY + CostCalcMgt.CalcServInvLineCostLCY(ServInvLine);
          until ServInvLine.Next = 0;
        TaxAmount := AmountInclTax - CustAmount;
        InvDiscAmount := ROUND(InvDiscAmount,Currency."Amount Rounding Precision");

        if "Currency Code" = '' then
          AmountLCY := CustAmount
        else
          AmountLCY :=
            CurrExchRate.ExchangeAmtFCYToLCY(
              WorkDate,"Currency Code",CustAmount,"Currency Factor");
        ProfitLCY := AmountLCY - CostLCY;
        if AmountLCY <> 0 then
          ProfitPct := ROUND(100 * ProfitLCY / AmountLCY,0.1);

        AdjProfitLCY := AmountLCY - TotalAdjCostLCY;
        if AmountLCY <> 0 then
          AdjProfitPct := ROUND(100 * AdjProfitLCY / AmountLCY,0.1);

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

        SalesTaxCalculate.StartSalesTaxCalculation;
        TempSalesTaxLine.DeleteAll;
        if TaxArea."Use External Tax Engine" then
          SalesTaxCalculate.CallExternalTaxEngineForDoc(Database::"Service Invoice Header",0,"No.")
        else begin
          SalesTaxCalculate.AddServInvoiceLines("No.");
          SalesTaxCalculate.EndSalesTaxCalculation("Posting Date");
        end;
        SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine);
        SalesTaxCalculate.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
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
            until Next = 0;
        end;
        CurrPage.Subform.Page.SetTempTaxAmountLine(TempSalesTaxLine);
        CurrPage.Subform.Page.InitGlobals("Currency Code",false,false,false,false,"VAT Base Discount %");
    end;

    var
        CurrExchRate: Record "Currency Exchange Rate";
        ServInvLine: Record "Service Invoice Line";
        Cust: Record Customer;
        TempSalesTaxLine: Record UnknownRecord10011 temporary;
        Currency: Record Currency;
        TaxArea: Record "Tax Area";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        CustAmount: Decimal;
        AmountInclTax: Decimal;
        InvDiscAmount: Decimal;
        TaxAmount: Decimal;
        CostLCY: Decimal;
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        AdjProfitLCY: Decimal;
        AdjProfitPct: Decimal;
        TotalAdjCostLCY: Decimal;
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
        AmountLCY: Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        TaxPercentage: Decimal;
        BreakdownTitle: Text[35];
        BreakdownLabel: array [4] of Text[30];
        BreakdownAmt: array [4] of Decimal;
        BrkIdx: Integer;
        Text006: label 'Tax Breakdown:';
        Text007: label 'Sales Tax Breakdown:';
        Text008: label 'Other Taxes';
}

