#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6034 "Service Credit Memo Statistics"
{
    Caption = 'Service Credit Memo Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SourceTable = "Service Cr.Memo Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Amount;CustAmount + InvDiscAmount)
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
                field(VATAmount;VATAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT(VATAmountText);
                    Caption = 'Tax Amount';
                }
                field(AmountInclVAT;AmountInclVAT)
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
                field(CostAdjmtAmountLCY;TotalAdjCostLCY - CostLCY)
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
                }
                field(CreditLimitLCY;Cust."Credit Limit (LCY)")
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
        CostCalcMgt: Codeunit "Cost Calculation Management";
    begin
        ClearAll;

        if "Currency Code" = '' then
          Currency.InitRoundingPrecision
        else
          Currency.Get("Currency Code");

        ServCrMemoLine.SetRange("Document No.","No.");

        if ServCrMemoLine.Find('-') then
          repeat
            CustAmount := CustAmount + ServCrMemoLine.Amount;
            AmountInclVAT := AmountInclVAT + ServCrMemoLine."Amount Including VAT";
            if "Prices Including VAT" then
              InvDiscAmount := InvDiscAmount + ServCrMemoLine."Inv. Discount Amount" / (1 + ServCrMemoLine."VAT %" / 100)
            else
              InvDiscAmount := InvDiscAmount + ServCrMemoLine."Inv. Discount Amount";
            CostLCY := CostLCY + (ServCrMemoLine.Quantity * ServCrMemoLine."Unit Cost (LCY)");
            LineQty := LineQty + ServCrMemoLine.Quantity;
            TotalNetWeight := TotalNetWeight + (ServCrMemoLine.Quantity * ServCrMemoLine."Net Weight");
            TotalGrossWeight := TotalGrossWeight + (ServCrMemoLine.Quantity * ServCrMemoLine."Gross Weight");
            TotalVolume := TotalVolume + (ServCrMemoLine.Quantity * ServCrMemoLine."Unit Volume");
            if ServCrMemoLine."Units per Parcel" > 0 then
              TotalParcels := TotalParcels + ROUND(ServCrMemoLine.Quantity / ServCrMemoLine."Units per Parcel",1,'>');
            if ServCrMemoLine."VAT %" <> VATpercentage then
              if VATpercentage = 0 then
                VATpercentage := ServCrMemoLine."VAT %"
              else
                VATpercentage := -1;
            TotalAdjCostLCY := TotalAdjCostLCY + CostCalcMgt.CalcServCrMemoLineCostLCY(ServCrMemoLine);
          until ServCrMemoLine.Next = 0;
        VATAmount := AmountInclVAT - CustAmount;
        InvDiscAmount := ROUND(InvDiscAmount,Currency."Amount Rounding Precision");

        if VATpercentage <= 0 then
          VATAmountText := Text000
        else
          VATAmountText := StrSubstNo(Text001,VATpercentage);

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

        ServCrMemoLine.CalcVATAmountLines(Rec,TempVATAmountLine);
        CurrPage.Subform.Page.SetTempVATAmountLine(TempVATAmountLine);
        CurrPage.Subform.Page.InitGlobals("Currency Code",false,false,false,false,"VAT Base Discount %");
    end;

    var
        Text000: label 'Tax Amount';
        Text001: label '%1% Tax';
        CurrExchRate: Record "Currency Exchange Rate";
        ServCrMemoLine: Record "Service Cr.Memo Line";
        Cust: Record Customer;
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        Currency: Record Currency;
        CustAmount: Decimal;
        AmountInclVAT: Decimal;
        InvDiscAmount: Decimal;
        VATAmount: Decimal;
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
        VATpercentage: Decimal;
        VATAmountText: Text[30];
}

