#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 57 "Document Totals"
{

    trigger OnRun()
    begin
    end;

    var
        TotalVATLbl: label 'Total Tax';
        TotalAmountInclVatLbl: label 'Total Incl. Tax';
        TotalAmountExclVATLbl: label 'Total Excl. Tax';
        InvoiceDiscountAmountLbl: label 'Invoice Discount Amount';
        RefreshMsgTxt: label 'Totals or discounts may not be up-to-date. Choose the link to update.';
        PreviousTotalSalesHeader: Record "Sales Header";
        PreviousTotalPurchaseHeader: Record "Purchase Header";
        ForceTotalsRecalculation: Boolean;
        PreviousTotalSalesVATDifference: Decimal;
        PreviousTotalPurchVATDifference: Decimal;
        TotalLineAmountLbl: label 'Subtotal';


    procedure CalculateSalesTotals(var TotalSalesLine: Record "Sales Line";var VATAmount: Decimal;var SalesLine: Record "Sales Line")
    begin
        TotalSalesLine.SetRange("Document Type",SalesLine."Document Type");
        TotalSalesLine.SetRange("Document No.",SalesLine."Document No.");
        TotalSalesLine.CalcSums("Line Amount",Amount,"Amount Including VAT","Inv. Discount Amount");
        VATAmount := TotalSalesLine."Amount Including VAT" - TotalSalesLine.Amount;
    end;


    procedure CalculatePostedSalesInvoiceTotals(var SalesInvoiceHeader: Record "Sales Invoice Header";var VATAmount: Decimal;SalesInvoiceLine: Record "Sales Invoice Line")
    begin
        if SalesInvoiceHeader.Get(SalesInvoiceLine."Document No.") then begin
          SalesInvoiceHeader.CalcFields(Amount,"Amount Including VAT","Invoice Discount Amount");
          VATAmount := SalesInvoiceHeader."Amount Including VAT" - SalesInvoiceHeader.Amount;
        end;
    end;


    procedure CalculatePostedSalesCreditMemoTotals(var SalesCrMemoHeader: Record "Sales Cr.Memo Header";var VATAmount: Decimal;SalesCrMemoLine: Record "Sales Cr.Memo Line")
    begin
        if SalesCrMemoHeader.Get(SalesCrMemoLine."Document No.") then begin
          SalesCrMemoHeader.CalcFields(Amount,"Amount Including VAT","Invoice Discount Amount");
          VATAmount := SalesCrMemoHeader."Amount Including VAT" - SalesCrMemoHeader.Amount;
        end;
    end;

    local procedure CalcTotalPurchVATDifference(PurchHeader: Record "Purchase Header"): Decimal
    var
        PurchLine: Record "Purchase Line";
    begin
        with PurchLine do begin
          SetRange("Document Type",PurchHeader."Document Type");
          SetRange("Document No.",PurchHeader."No.");
          CalcSums("VAT Difference");
          exit("VAT Difference");
        end;
    end;

    local procedure CalcTotalSalesVATDifference(SalesHeader: Record "Sales Header"): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        with SalesLine do begin
          SetRange("Document Type",SalesHeader."Document Type");
          SetRange("Document No.",SalesHeader."No.");
          CalcSums("VAT Difference");
          exit("VAT Difference");
        end;
    end;


    procedure SalesUpdateTotalsControls(CurrentSalesLine: Record "Sales Line";var TotalSalesHeader: Record "Sales Header";var TotalsSalesLine: Record "Sales Line";var RefreshMessageEnabled: Boolean;var ControlStyle: Text;var RefreshMessageText: Text;var InvDiscAmountEditable: Boolean;CurrPageEditable: Boolean;var VATAmount: Decimal)
    var
        SalesLine: Record "Sales Line";
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
    begin
        if CurrentSalesLine."Document No." = '' then
          exit;

        TotalSalesHeader.Get(CurrentSalesLine."Document Type",CurrentSalesLine."Document No.");
        RefreshMessageEnabled := SalesCalcDiscountByType.ShouldRedistributeInvoiceDiscountAmount(TotalSalesHeader);

        if not RefreshMessageEnabled then
          RefreshMessageEnabled := not SalesUpdateTotals(TotalSalesHeader,CurrentSalesLine,TotalsSalesLine,VATAmount);

        SalesLine.SetRange("Document Type",CurrentSalesLine."Document Type");
        SalesLine.SetRange("Document No.",CurrentSalesLine."Document No.");
        InvDiscAmountEditable := SalesLine.FindFirst and
          SalesCalcDiscountByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") and
          (not RefreshMessageEnabled) and CurrPageEditable;

        TotalControlsUpdateStyle(RefreshMessageEnabled,ControlStyle,RefreshMessageText);

        if RefreshMessageEnabled then begin
          TotalsSalesLine.Amount := 0;
          TotalsSalesLine."Amount Including VAT" := 0;
          VATAmount := 0;
          Clear(PreviousTotalSalesHeader);
        end;
    end;

    local procedure SalesUpdateTotals(var SalesHeader: Record "Sales Header";CurrentSalesLine: Record "Sales Line";var TotalsSalesLine: Record "Sales Line";var VATAmount: Decimal): Boolean
    begin
        SalesHeader.CalcFields(Amount,"Amount Including VAT","Invoice Discount Amount");

        if SalesHeader."No." <> PreviousTotalSalesHeader."No." then
          ForceTotalsRecalculation := true;

        if (not ForceTotalsRecalculation) and
           (PreviousTotalSalesHeader.Amount = SalesHeader.Amount) and
           (PreviousTotalSalesHeader."Amount Including VAT" = SalesHeader."Amount Including VAT") and
           (PreviousTotalSalesVATDifference = CalcTotalSalesVATDifference(SalesHeader))
        then
          exit(true);

        ForceTotalsRecalculation := false;

        if not SalesCheckNumberOfLinesLimit(SalesHeader) then
          exit(false);

        SalesCalculateTotalsNoRounding(CurrentSalesLine,VATAmount,TotalsSalesLine,SalesHeader."Tax Area Code");
        exit(true);
    end;

    local procedure SalesCalculateTotalsWithInvoiceRounding(var TempCurrentSalesLine: Record "Sales Line" temporary;var VATAmount: Decimal;var TempTotalSalesLine: Record "Sales Line" temporary)
    var
        TempSalesLine: Record "Sales Line" temporary;
        TempTotalSalesLineLCY: Record "Sales Line" temporary;
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
        VATAmountText: Text[30];
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        TotalAdjCostLCY: Decimal;
    begin
        Clear(TempTotalSalesLine);
        if SalesHeader.Get(TempCurrentSalesLine."Document Type",TempCurrentSalesLine."Document No.") then begin
          SalesPost.GetSalesLines(SalesHeader,TempSalesLine,0);
          Clear(SalesPost);
          SalesPost.SumSalesLinesTemp(
            SalesHeader,TempSalesLine,0,TempTotalSalesLine,TempTotalSalesLineLCY,
            VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);

          if PreviousTotalSalesHeader."No." <> TempCurrentSalesLine."Document No." then begin
            PreviousTotalSalesHeader.Get(TempCurrentSalesLine."Document Type",TempCurrentSalesLine."Document No.");
            ForceTotalsRecalculation := true;
          end;
          PreviousTotalSalesHeader.CalcFields(Amount,"Amount Including VAT");
          PreviousTotalSalesVATDifference := CalcTotalSalesVATDifference(PreviousTotalSalesHeader);
        end;
    end;


    procedure SalesRedistributeInvoiceDiscountAmounts(var TempSalesLine: Record "Sales Line" temporary;var VATAmount: Decimal;var TempTotalSalesLine: Record "Sales Line" temporary)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        with SalesHeader do
          if Get(TempSalesLine."Document Type",TempSalesLine."Document No.") then begin
            TestField(Status,Status::Open);
            SalesLine.Copy(TempSalesLine);
            SalesLine.CalcSalesTaxLines(SalesHeader,SalesLine);
            if TempSalesLine.Get(TempSalesLine."Document Type",TempSalesLine."Document No.",TempSalesLine."Line No.") then;

            CalcFields("Recalculate Invoice Disc.");
            if "Recalculate Invoice Disc." then
              Codeunit.Run(Codeunit::"Sales - Calc Discount By Type",TempSalesLine);

            SalesCalculateTotalsNoRounding(TempSalesLine,VATAmount,TempTotalSalesLine,"Tax Area Code");
          end;
    end;


    procedure PurchaseUpdateTotalsControls(CurrentPurchaseLine: Record "Purchase Line";var TotalPurchaseHeader: Record "Purchase Header";var TotalsPurchaseLine: Record "Purchase Line";var RefreshMessageEnabled: Boolean;var ControlStyle: Text;var RefreshMessageText: Text;var InvDiscAmountEditable: Boolean;var VATAmount: Decimal)
    var
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
    begin
        if CurrentPurchaseLine."Document No." = '' then
          exit;

        TotalPurchaseHeader.Get(CurrentPurchaseLine."Document Type",CurrentPurchaseLine."Document No.");
        RefreshMessageEnabled := PurchCalcDiscByType.ShouldRedistributeInvoiceDiscountAmount(TotalPurchaseHeader);

        if not RefreshMessageEnabled then
          RefreshMessageEnabled := not PurchaseUpdateTotals(TotalPurchaseHeader,CurrentPurchaseLine,TotalsPurchaseLine,VATAmount);

        InvDiscAmountEditable := PurchCalcDiscByType.InvoiceDiscIsAllowed(TotalPurchaseHeader."Invoice Disc. Code") and
          (not RefreshMessageEnabled);
        TotalControlsUpdateStyle(RefreshMessageEnabled,ControlStyle,RefreshMessageText);

        if RefreshMessageEnabled then begin
          TotalsPurchaseLine.Amount := 0;
          TotalsPurchaseLine."Amount Including VAT" := 0;
          VATAmount := 0;
          Clear(PreviousTotalPurchaseHeader);
        end;
    end;

    local procedure PurchaseUpdateTotals(var PurchaseHeader: Record "Purchase Header";CurrentPurchaseLine: Record "Purchase Line";var TotalsPurchaseLine: Record "Purchase Line";var VATAmount: Decimal): Boolean
    begin
        PurchaseHeader.CalcFields(Amount,"Amount Including VAT","Invoice Discount Amount");

        if (PreviousTotalPurchaseHeader.Amount = PurchaseHeader.Amount) and
           (PreviousTotalPurchaseHeader."Amount Including VAT" = PurchaseHeader."Amount Including VAT") and
           (PreviousTotalPurchVATDifference = CalcTotalPurchVATDifference(PurchaseHeader))
        then
          exit(true);

        if not PurchaseCheckNumberOfLinesLimit(PurchaseHeader) then
          exit(false);

        PurchaseCalculateTotalsNoRounding(CurrentPurchaseLine,VATAmount,TotalsPurchaseLine,PurchaseHeader."Tax Area Code");
        exit(true);
    end;


    procedure PurchaseCalculateTotalsWithInvoiceRounding(var TempCurrentPurchaseLine: Record "Purchase Line" temporary;var VATAmount: Decimal;var TempTotalPurchaseLine: Record "Purchase Line" temporary)
    var
        TempPurchaseLine: Record "Purchase Line" temporary;
        TempTotalPurchaseLineLCY: Record "Purchase Line" temporary;
        PurchaseHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
        VATAmountText: Text[30];
    begin
        Clear(TempTotalPurchaseLine);
        if PurchaseHeader.Get(TempCurrentPurchaseLine."Document Type",TempCurrentPurchaseLine."Document No.") then begin
          PurchPost.GetPurchLines(PurchaseHeader,TempPurchaseLine,0);
          Clear(PurchPost);

          PurchPost.SumPurchLinesTemp(
            PurchaseHeader,TempPurchaseLine,0,TempTotalPurchaseLine,TempTotalPurchaseLineLCY,VATAmount,VATAmountText);

          if PreviousTotalPurchaseHeader."No." <> TempCurrentPurchaseLine."Document No." then
            PreviousTotalPurchaseHeader.Get(TempCurrentPurchaseLine."Document Type",TempCurrentPurchaseLine."Document No.");
          PreviousTotalPurchaseHeader.CalcFields(Amount,"Amount Including VAT");
          PreviousTotalPurchVATDifference := CalcTotalPurchVATDifference(PreviousTotalPurchaseHeader);
        end;
    end;


    procedure PurchaseRedistributeInvoiceDiscountAmounts(var TempPurchaseLine: Record "Purchase Line" temporary;var VATAmount: Decimal;var TempTotalPurchaseLine: Record "Purchase Line" temporary)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        with PurchaseHeader do
          if Get(TempPurchaseLine."Document Type",TempPurchaseLine."Document No.") then begin
            PurchaseLine.Copy(TempPurchaseLine);
            PurchaseLine.CalcSalesTaxLines(PurchaseHeader,PurchaseLine);
            if TempPurchaseLine.Get(TempPurchaseLine."Document Type",TempPurchaseLine."Document No.",TempPurchaseLine."Line No.") then;
            CalcFields("Recalculate Invoice Disc.");
            if "Recalculate Invoice Disc." then
              Codeunit.Run(Codeunit::"Purch - Calc Disc. By Type",TempPurchaseLine);

            PurchaseCalculateTotalsNoRounding(TempPurchaseLine,VATAmount,TempTotalPurchaseLine,"Tax Area Code");
          end;
    end;


    procedure CalculatePurchaseTotals(var TotalPurchaseLine: Record "Purchase Line";var VATAmount: Decimal;var PurchaseLine: Record "Purchase Line")
    begin
        TotalPurchaseLine.SetRange("Document Type",PurchaseLine."Document Type");
        TotalPurchaseLine.SetRange("Document No.",PurchaseLine."Document No.");
        TotalPurchaseLine.CalcSums("Line Amount",Amount,"Amount Including VAT","Inv. Discount Amount");
        VATAmount := TotalPurchaseLine."Amount Including VAT" - TotalPurchaseLine.Amount;
    end;


    procedure CalculatePostedPurchInvoiceTotals(var PurchInvHeader: Record "Purch. Inv. Header";var VATAmount: Decimal;PurchInvLine: Record "Purch. Inv. Line")
    begin
        if PurchInvHeader.Get(PurchInvLine."Document No.") then begin
          PurchInvHeader.CalcFields(Amount,"Amount Including VAT","Invoice Discount Amount");
          VATAmount := PurchInvHeader."Amount Including VAT" - PurchInvHeader.Amount;
        end;
    end;


    procedure CalculatePostedPurchCreditMemoTotals(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";var VATAmount: Decimal;PurchCrMemoLine: Record "Purch. Cr. Memo Line")
    begin
        if PurchCrMemoHdr.Get(PurchCrMemoLine."Document No.") then begin
          PurchCrMemoHdr.CalcFields(Amount,"Amount Including VAT","Invoice Discount Amount");
          VATAmount := PurchCrMemoHdr."Amount Including VAT" - PurchCrMemoHdr.Amount;
        end;
    end;

    local procedure TotalControlsUpdateStyle(RefreshMessageEnabled: Boolean;var ControlStyle: Text;var RefreshMessageText: Text)
    begin
        if RefreshMessageEnabled then begin
          ControlStyle := 'Subordinate';
          RefreshMessageText := RefreshMsgTxt;
        end else begin
          ControlStyle := 'Strong';
          RefreshMessageText := '';
        end;
    end;


    procedure GetTotalVATCaption(CurrencyCode: Code[10]): Text
    begin
        exit(GetCaptionClassWithCurrencyCode(TotalVATLbl,CurrencyCode));
    end;


    procedure GetTotalInclVATCaption(CurrencyCode: Code[10]): Text
    begin
        exit(GetCaptionClassWithCurrencyCode(TotalAmountInclVatLbl,CurrencyCode));
    end;


    procedure GetTotalExclVATCaption(CurrencyCode: Code[10]): Text
    begin
        exit(GetCaptionClassWithCurrencyCode(TotalAmountExclVATLbl,CurrencyCode));
    end;

    local procedure GetCaptionClassWithCurrencyCode(CaptionWithoutCurrencyCode: Text;CurrencyCode: Code[10]): Text
    begin
        exit('3,' + GetCaptionWithCurrencyCode(CaptionWithoutCurrencyCode,CurrencyCode));
    end;

    local procedure GetCaptionWithCurrencyCode(CaptionWithoutCurrencyCode: Text;CurrencyCode: Code[10]): Text
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if CurrencyCode = '' then begin
          GLSetup.Get;
          CurrencyCode := GLSetup.GetCurrencyCode(CurrencyCode);
        end;

        if CurrencyCode <> '' then
          exit(CaptionWithoutCurrencyCode + StrSubstNo(' (%1)',CurrencyCode));

        exit(CaptionWithoutCurrencyCode);
    end;

    local procedure GetCaptionWithVATInfo(CaptionWithoutVATInfo: Text;IncludesVAT: Boolean): Text
    begin
        if IncludesVAT then
          exit('2,1,' + CaptionWithoutVATInfo);

        exit('2,0,' + CaptionWithoutVATInfo);
    end;


    procedure GetInvoiceDiscAmountWithVATCaption(IncludesVAT: Boolean): Text
    begin
        exit(GetCaptionWithVATInfo(InvoiceDiscountAmountLbl,IncludesVAT));
    end;


    procedure GetInvoiceDiscAmountWithVATAndCurrencyCaption(InvDiscAmountCaptionClassWithVAT: Text;CurrencyCode: Code[10]): Text
    begin
        exit(GetCaptionWithCurrencyCode(InvDiscAmountCaptionClassWithVAT,CurrencyCode));
    end;


    procedure GetTotalLineAmountWithVATAndCurrencyCaption(CurrencyCode: Code[10];IncludesVAT: Boolean): Text
    begin
        exit(GetCaptionWithCurrencyCode(CaptionClassTranslate(GetCaptionWithVATInfo(TotalLineAmountLbl,IncludesVAT)),CurrencyCode));
    end;


    procedure SalesCheckNumberOfLinesLimit(SalesHeader: Record "Sales Header"): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document No.",SalesHeader."No.");
        SalesLine.SetRange("Document Type",SalesHeader."Document Type");
        SalesLine.SetFilter(Type,'<>%1',SalesLine.Type::" ");
        SalesLine.SetFilter("No.",'<>%1','');

        exit(SalesLine.Count <= 100);
    end;


    procedure PurchaseCheckNumberOfLinesLimit(PurchaseHeader: Record "Purchase Header"): Boolean
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document No.",PurchaseHeader."No.");
        PurchaseLine.SetRange("Document Type",PurchaseHeader."Document Type");
        PurchaseLine.SetFilter(Type,'<>%1',PurchaseLine.Type::" ");
        PurchaseLine.SetFilter("No.",'<>%1','');

        exit(PurchaseLine.Count <= 100);
    end;

    local procedure SalesCalculateTotalsNoRounding(var TempCurrentSalesLine: Record "Sales Line";var VATAmount: Decimal;var TempTotalSalesLine: Record "Sales Line";TaxAreaCode: Code[20])
    var
        SalesLine: Record "Sales Line";
    begin
        Clear(TempTotalSalesLine);
        SalesLine.SetRange("Document Type",TempCurrentSalesLine."Document Type");
        SalesLine.SetRange("Document No.",TempCurrentSalesLine."Document No.");
        if SalesLine.FindSet then
          repeat
            if ((SalesLine."Tax Group Code" = '') or
               ((SalesLine."Tax Area Code" = '') and (TaxAreaCode <> '')))
            then begin
              TempTotalSalesLine.Amount += (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount");
              TempTotalSalesLine."Inv. Discount Amount" += SalesLine."Inv. Discount Amount";
              TempTotalSalesLine."Amount Including VAT" += (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount");
            end else begin
              TempTotalSalesLine.Amount += SalesLine.Amount;
              TempTotalSalesLine."Inv. Discount Amount" += SalesLine."Inv. Discount Amount";
              TempTotalSalesLine."Amount Including VAT" += SalesLine."Amount Including VAT";
            end
          until SalesLine.Next = 0;
        VATAmount := TempTotalSalesLine."Amount Including VAT" - TempTotalSalesLine.Amount;
    end;

    local procedure PurchaseCalculateTotalsNoRounding(var TempCurrentPurchaseLine: Record "Purchase Line";var VATAmount: Decimal;var TempTotalPurchaseLine: Record "Purchase Line";var TaxAreaCode: Code[20])
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(TempTotalPurchaseLine);
        PurchaseLine.SetRange("Document Type",TempCurrentPurchaseLine."Document Type");
        PurchaseLine.SetRange("Document No.",TempCurrentPurchaseLine."Document No.");
        if PurchaseLine.FindSet then
          repeat
            if ((PurchaseLine."Tax Group Code" = '') or
               ((PurchaseLine."Tax Area Code" = '') and (TaxAreaCode <> '')))
            then begin
              TempTotalPurchaseLine.Amount += (PurchaseLine."Line Amount" - PurchaseLine."Inv. Discount Amount");
              TempTotalPurchaseLine."Inv. Discount Amount" += PurchaseLine."Inv. Discount Amount";
              TempTotalPurchaseLine."Amount Including VAT" += (PurchaseLine."Line Amount" - PurchaseLine."Inv. Discount Amount");
            end else begin
              TempTotalPurchaseLine.Amount += PurchaseLine.Amount;
              TempTotalPurchaseLine."Inv. Discount Amount" += PurchaseLine."Inv. Discount Amount";
              TempTotalPurchaseLine."Amount Including VAT" += PurchaseLine."Amount Including VAT";
            end
          until PurchaseLine.Next = 0;
        VATAmount := TempTotalPurchaseLine."Amount Including VAT" - TempTotalPurchaseLine.Amount;
    end;
}

