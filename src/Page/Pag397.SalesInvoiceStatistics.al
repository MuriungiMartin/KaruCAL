#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 397 "Sales Invoice Statistics"
{
    Caption = 'Sales Invoice Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SourceTable = "Sales Invoice Header";

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
                    ToolTip = 'Specifies the net amount of all the lines in the sales document.';
                }
                field(InvDiscAmount;InvDiscAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                    ToolTip = 'Specifies the invoice discount amount for the sales document.';
                }
                field(CustAmount;CustAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Total';
                    ToolTip = 'Specifies the total amount, less any invoice discount amount, and excluding tax for the sales document.';
                }
                field(VATAmount;VATAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT(VATAmountText);
                    Caption = 'Tax Amount';
                    ToolTip = 'Specifies the total tax amount that has been calculated for all the lines in the sales document.';
                }
                field(AmountInclVAT;AmountInclVAT)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Total Incl. Tax';
                    ToolTip = 'Specifies the total amount, including tax, that will be posted to the customer''s account for all the lines in the sales document.';
                }
                field(AmountLCY;AmountLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Sales ($)';
                    ToolTip = 'Specifies your total sales turnover in the fiscal year.';
                }
                field(ProfitLCY;ProfitLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Original Profit ($)';
                    ToolTip = 'Specifies the original profit that was associated with the sales when they were originally posted.';
                }
                field(AdjProfitLCY;AdjProfitLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Profit ($)';
                    ToolTip = 'Specifies the profit, taking into consideration changes in the purchase prices of the goods.';
                }
                field(ProfitPct;ProfitPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Original Profit %';
                    DecimalPlaces = 1:1;
                    ToolTip = 'Specifies the original percentage of profit that was associated with the sales when they were originally posted.';
                }
                field(AdjProfitPct;AdjProfitPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Adjusted Profit %';
                    DecimalPlaces = 1:1;
                    ToolTip = 'Specifies the percentage of profit for all sales, including changes that occurred in the purchase prices of the goods.';
                }
                field(LineQty;LineQty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the total quantity of G/L account entries, items and/or resources in the sales document.';
                }
                field(TotalParcels;TotalParcels)
                {
                    ApplicationArea = Basic;
                    Caption = 'Parcels';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the total number of parcels in the sales document.';
                }
                field(TotalNetWeight;TotalNetWeight)
                {
                    ApplicationArea = Basic;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the total net weight of the items in the sales document.';
                }
                field(TotalGrossWeight;TotalGrossWeight)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the total gross weight of the items in the sales document.';
                }
                field(TotalVolume;TotalVolume)
                {
                    ApplicationArea = Basic;
                    Caption = 'Volume';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the total volume of the items in the sales document.';
                }
                field(CostLCY;CostLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Original Cost ($)';
                    ToolTip = 'Specifies the total cost, in $, of the G/L account entries, items and/or resources in the sales document.';
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
            }
            part(Subform;"VAT Specification Subform")
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
                    ToolTip = 'Specifies the balance in $ on the customer''s account.';
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
                    ToolTip = 'Specifies the expended percentage of the credit limit in ($).';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        CostCalcMgt: Codeunit "Cost Calculation Management";
    begin
        ClearAll;

        if "Currency Code" = '' then
          currency.InitRoundingPrecision
        else
          currency.Get("Currency Code");

        SalesInvLine.SetRange("Document No.","No.");
        if SalesInvLine.Find('-') then
          repeat
            CustAmount := CustAmount + SalesInvLine.Amount;
            AmountInclVAT := AmountInclVAT + SalesInvLine."Amount Including VAT";
            if "Prices Including VAT" then
              InvDiscAmount := InvDiscAmount + SalesInvLine."Inv. Discount Amount" / (1 + SalesInvLine."VAT %" / 100)
            else
              InvDiscAmount := InvDiscAmount + SalesInvLine."Inv. Discount Amount";
            CostLCY := CostLCY + (SalesInvLine.Quantity * SalesInvLine."Unit Cost (LCY)");
            LineQty := LineQty + SalesInvLine.Quantity;
            TotalNetWeight := TotalNetWeight + (SalesInvLine.Quantity * SalesInvLine."Net Weight");
            TotalGrossWeight := TotalGrossWeight + (SalesInvLine.Quantity * SalesInvLine."Gross Weight");
            TotalVolume := TotalVolume + (SalesInvLine.Quantity * SalesInvLine."Unit Volume");
            if SalesInvLine."Units per Parcel" > 0 then
              TotalParcels := TotalParcels + ROUND(SalesInvLine.Quantity / SalesInvLine."Units per Parcel",1,'>');
            if SalesInvLine."VAT %" <> VATPercentage then
              if VATPercentage = 0 then
                VATPercentage := SalesInvLine."VAT %"
              else
                VATPercentage := -1;
            TotalAdjCostLCY := TotalAdjCostLCY + CostCalcMgt.CalcSalesInvLineCostLCY(SalesInvLine);
          until SalesInvLine.Next = 0;
        VATAmount := AmountInclVAT - CustAmount;
        InvDiscAmount := ROUND(InvDiscAmount,currency."Amount Rounding Precision");

        if VATPercentage <= 0 then
          VATAmountText := Text000
        else
          VATAmountText := StrSubstNo(Text001,VATPercentage);

        if "Currency Code" = '' then
          AmountLCY := CustAmount
        else
          AmountLCY :=
            CurrExchRate.ExchangeAmtFCYToLCY(
              WorkDate,"Currency Code",CustAmount,"Currency Factor");

        CustLedgEntry.SetCurrentkey("Document No.");
        CustLedgEntry.SetRange("Document No.","No.");
        CustLedgEntry.SetRange("Document Type",CustLedgEntry."document type"::Invoice);
        CustLedgEntry.SetRange("Customer No.","Bill-to Customer No.");
        if CustLedgEntry.FindFirst then
          AmountLCY := CustLedgEntry."Sales (LCY)";

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

        case true of
          Cust."Credit Limit (LCY)" = 0:
            CreditLimitLCYExpendedPct := 0;
          Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0:
            CreditLimitLCYExpendedPct := 0;
          Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1:
            CreditLimitLCYExpendedPct := 10000;
          else
            CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000,1);
        end;

        SalesInvLine.CalcVATAmountLines(Rec,TempVATAmountLine);
        CurrPage.Subform.Page.SetTempVATAmountLine(TempVATAmountLine);
        CurrPage.Subform.Page.InitGlobals("Currency Code",false,false,false,false,"VAT Base Discount %");
    end;

    var
        Text000: label 'Tax Amount';
        Text001: label '%1% Tax';
        CurrExchRate: Record "Currency Exchange Rate";
        SalesInvLine: Record "Sales Invoice Line";
        Cust: Record Customer;
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        currency: Record Currency;
        TotalAdjCostLCY: Decimal;
        CustAmount: Decimal;
        AmountInclVAT: Decimal;
        InvDiscAmount: Decimal;
        VATAmount: Decimal;
        CostLCY: Decimal;
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        AdjProfitLCY: Decimal;
        AdjProfitPct: Decimal;
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
        AmountLCY: Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        VATPercentage: Decimal;
        VATAmountText: Text[30];
}

