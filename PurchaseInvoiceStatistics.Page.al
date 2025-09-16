#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 400 "Purchase Invoice Statistics"
{
    Caption = 'Purchase Invoice Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SourceTable = "Purch. Inv. Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("VendAmount + InvDiscAmount";VendAmount + InvDiscAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the net amount of all the lines in the purchase document.';
                }
                field(InvDiscAmount;InvDiscAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                    ToolTip = 'Specifies the invoice discount amount for the purchase document.';
                }
                field(VendAmount;VendAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Total';
                    ToolTip = 'Specifies the total amount, less any invoice discount amount, and excluding tax for the purchase document.';
                }
                field(VATAmount;VATAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT(VATAmountText);
                    Caption = 'Tax Amount';
                    ToolTip = 'Specifies the total tax amount that has been calculated for all the lines in the purchase document.';
                }
                field(AmountInclVAT;AmountInclVAT)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Total Incl. Tax';
                    ToolTip = 'Specifies the total amount, including tax, that will be posted to the vendor''s account for all the lines in the purchase document.';
                }
                field(AmountLCY;AmountLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Purchase ($)';
                    ToolTip = 'Specifies your total purchases.';
                }
                field(LineQty;LineQty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the total quantity of G/L account entries, items and/or resources in the purchase document.';
                }
                field(TotalParcels;TotalParcels)
                {
                    ApplicationArea = Basic;
                    Caption = 'Parcels';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the total number of parcels in the purchase document.';
                }
                field(TotalNetWeight;TotalNetWeight)
                {
                    ApplicationArea = Basic;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the total net weight of the items in the purchase document.';
                }
                field(TotalGrossWeight;TotalGrossWeight)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the total gross weight of the items in the purchase document.';
                }
                field(TotalVolume;TotalVolume)
                {
                    ApplicationArea = Basic;
                    Caption = 'Volume';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the total volume of the items in the purchase document.';
                }
            }
            part(SubForm;"VAT Specification Subform")
            {
                Editable = false;
            }
            group(Vendor)
            {
                Caption = 'Vendor';
                field("Vend.""Balance (LCY)""";Vend."Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Balance ($)';
                    ToolTip = 'Specifies the balance in $ on the vendor''s account.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        ClearAll;

        if "Currency Code" = '' then
          Currency.InitRoundingPrecision
        else
          Currency.Get("Currency Code");

        PurchInvLine.SetRange("Document No.","No.");

        if PurchInvLine.Find('-') then
          repeat
            VendAmount := VendAmount + PurchInvLine.Amount;
            AmountInclVAT := AmountInclVAT + PurchInvLine."Amount Including VAT";
            if "Prices Including VAT" then
              InvDiscAmount := InvDiscAmount + PurchInvLine."Inv. Discount Amount" / (1 + PurchInvLine."VAT %" / 100)
            else
              InvDiscAmount := InvDiscAmount + PurchInvLine."Inv. Discount Amount";
            LineQty := LineQty + PurchInvLine.Quantity;
            TotalNetWeight := TotalNetWeight + (PurchInvLine.Quantity * PurchInvLine."Net Weight");
            TotalGrossWeight := TotalGrossWeight + (PurchInvLine.Quantity * PurchInvLine."Gross Weight");
            TotalVolume := TotalVolume + (PurchInvLine.Quantity * PurchInvLine."Unit Volume");
            if PurchInvLine."Units per Parcel" > 0 then
              TotalParcels := TotalParcels + ROUND(PurchInvLine.Quantity / PurchInvLine."Units per Parcel",1,'>');
            if PurchInvLine."VAT %" <> VATPercentage then
              if VATPercentage = 0 then
                VATPercentage := PurchInvLine."VAT %"
              else
                VATPercentage := -1;
          until PurchInvLine.Next = 0;
        VATAmount := AmountInclVAT - VendAmount;
        InvDiscAmount := ROUND(InvDiscAmount,Currency."Amount Rounding Precision");

        if VATPercentage <= 0 then
          VATAmountText := Text000
        else
          VATAmountText := StrSubstNo(Text001,VATPercentage);

        if "Currency Code" = '' then
          AmountLCY := VendAmount
        else
          AmountLCY :=
            CurrExchRate.ExchangeAmtFCYToLCY(
              WorkDate,"Currency Code",VendAmount,"Currency Factor");

        VendLedgEntry.SetCurrentkey("Document No.");
        VendLedgEntry.SetRange("Document No.","No.");
        VendLedgEntry.SetRange("Document Type",VendLedgEntry."document type"::Invoice);
        VendLedgEntry.SetRange("Vendor No.","Pay-to Vendor No.");
        if VendLedgEntry.FindFirst then
          AmountLCY := VendLedgEntry."Purchase (LCY)";

        if not Vend.Get("Pay-to Vendor No.") then
          Clear(Vend);
        Vend.CalcFields("Balance (LCY)");

        PurchInvLine.CalcVATAmountLines(Rec,TempVATAmountLine);
        CurrPage.SubForm.Page.SetTempVATAmountLine(TempVATAmountLine);
        CurrPage.SubForm.Page.InitGlobals("Currency Code",false,false,false,false,"VAT Base Discount %");
    end;

    var
        Text000: label 'Tax Amount';
        Text001: label '%1% Tax';
        CurrExchRate: Record "Currency Exchange Rate";
        PurchInvLine: Record "Purch. Inv. Line";
        Vend: Record Vendor;
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        Currency: Record Currency;
        VendAmount: Decimal;
        AmountInclVAT: Decimal;
        InvDiscAmount: Decimal;
        AmountLCY: Decimal;
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
        VATAmount: Decimal;
        VATPercentage: Decimal;
        VATAmountText: Text[30];
}

