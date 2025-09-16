#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 70 "Purch.-Calc.Discount"
{
    TableNo = "Purchase Line";

    trigger OnRun()
    var
        TempPurchHeader: Record "Purchase Header";
        TempPurchLine: Record "Purchase Line";
    begin
        PurchLine.Copy(Rec);

        TempPurchHeader.Get("Document Type","Document No.");
        UpdateHeader := false;
        CalculateInvoiceDiscount(TempPurchHeader,TempPurchLine);

        Rec := PurchLine;
    end;

    var
        Text000: label 'Service Charge';
        PurchLine: Record "Purchase Line";
        VendInvDisc: Record "Vendor Invoice Disc.";
        VendPostingGr: Record "Vendor Posting Group";
        Currency: Record Currency;
        InvDiscBase: Decimal;
        ChargeBase: Decimal;
        CurrencyDate: Date;
        UpdateHeader: Boolean;


    procedure CalculateInvoiceDiscount(var PurchHeader: Record "Purchase Header";var PurchLine2: Record "Purchase Line")
    var
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        PurchSetup: Record "Purchases & Payables Setup";
        TempServiceChargeLine: Record "Purchase Line" temporary;
    begin
        PurchSetup.Get;

        OnBeforeCalcPurchaseDiscount(PurchHeader);

        with PurchLine do begin
          LockTable;
          PurchHeader.TestField("Vendor Posting Group");
          VendPostingGr.Get(PurchHeader."Vendor Posting Group");

          PurchLine2.Reset;
          PurchLine2.SetRange("Document Type","Document Type");
          PurchLine2.SetRange("Document No.","Document No.");
          PurchLine2.SetFilter(Type,'<>0');
          PurchLine2.SetRange("System-Created Entry",true);
          PurchLine2.SetRange(Type,PurchLine2.Type::"G/L Account");
          PurchLine2.SetRange("No.",VendPostingGr."Service Charge Acc.");
          if PurchLine2.FindSet(true,false) then
            repeat
              PurchLine2.Validate("Direct Unit Cost",0);
              PurchLine2.Modify;
              TempServiceChargeLine := PurchLine2;
              TempServiceChargeLine.Insert;
            until PurchLine2.Next = 0;

          PurchLine2.Reset;
          PurchLine2.SetRange("Document Type","Document Type");
          PurchLine2.SetRange("Document No.","Document No.");
          PurchLine2.SetFilter(Type,'<>0');
          if PurchLine2.Find('-') then;
          PurchLine2.CalcVATAmountLines(0,PurchHeader,PurchLine2,TempVATAmountLine);
          InvDiscBase :=
            TempVATAmountLine.GetTotalInvDiscBaseAmount(
              PurchHeader."Prices Including VAT",PurchHeader."Currency Code");
          ChargeBase :=
            TempVATAmountLine.GetTotalLineAmount(
              PurchHeader."Prices Including VAT",PurchHeader."Currency Code");

          if not UpdateHeader then
            PurchHeader.Modify;

          if PurchHeader."Posting Date" = 0D then
            CurrencyDate := WorkDate
          else
            CurrencyDate := PurchHeader."Posting Date";

          VendInvDisc.GetRec(
            PurchHeader."Invoice Disc. Code",PurchHeader."Currency Code",CurrencyDate,ChargeBase);

          if VendInvDisc."Service Charge" <> 0 then begin
            VendPostingGr.TestField("Service Charge Acc.");
            if PurchHeader."Currency Code" = '' then
              Currency.InitRoundingPrecision
            else
              Currency.Get(PurchHeader."Currency Code");
            if UpdateHeader then
              PurchLine2.SetPurchHeader(PurchHeader);
            if not TempServiceChargeLine.IsEmpty then begin
              TempServiceChargeLine.FindLast;
              PurchLine2.Get("Document Type","Document No.",TempServiceChargeLine."Line No.");
              if PurchHeader."Prices Including VAT" then
                PurchLine2.Validate(
                  "Direct Unit Cost",
                  ROUND(
                    (1 + PurchLine2."VAT %" / 100) * VendInvDisc."Service Charge",
                    Currency."Unit-Amount Rounding Precision"))
              else
                PurchLine2.Validate("Direct Unit Cost",VendInvDisc."Service Charge");
              PurchLine2.Modify;
            end else begin
              PurchLine2.Reset;
              PurchLine2.SetRange("Document Type","Document Type");
              PurchLine2.SetRange("Document No.","Document No.");
              PurchLine2.Find('+');
              PurchLine2.Init;
              if UpdateHeader then
                PurchLine2.SetPurchHeader(PurchHeader);
              PurchLine2."Line No." := PurchLine2."Line No." + 10000;
              PurchLine2.Type := PurchLine2.Type::"G/L Account";
              PurchLine2.Validate("No.",VendPostingGr."Service Charge Acc.");
              PurchLine2.Description := Text000;
              PurchLine2.Validate(Quantity,1);
              if PurchLine2."Document Type" in
                 [PurchLine2."document type"::"Return Order",PurchLine2."document type"::"Credit Memo"]
              then
                PurchLine2.Validate("Return Qty. to Ship",PurchLine2.Quantity)
              else
                PurchLine2.Validate("Qty. to Receive",PurchLine2.Quantity);
              if PurchHeader."Prices Including VAT" then
                PurchLine2.Validate(
                  "Direct Unit Cost",
                  ROUND(
                    (1 + PurchLine2."VAT %" / 100) * VendInvDisc."Service Charge",
                    Currency."Unit-Amount Rounding Precision"))
              else
                PurchLine2.Validate("Direct Unit Cost",VendInvDisc."Service Charge");
              PurchLine2."System-Created Entry" := true;
              PurchLine2.Insert;
            end;
            PurchLine2.CalcVATAmountLines(0,PurchHeader,PurchLine2,TempVATAmountLine);
          end else
            if TempServiceChargeLine.FindSet(false,false) then
              repeat
                if (TempServiceChargeLine."Receipt No." = '') and (TempServiceChargeLine."Qty. Rcd. Not Invoiced (Base)" = 0) then begin
                  PurchLine2 := TempServiceChargeLine;
                  PurchLine2.Delete(true);
                end;
              until TempServiceChargeLine.Next = 0;

          if VendInvDiscRecExists(PurchHeader."Invoice Disc. Code") then begin
            if InvDiscBase <> ChargeBase then
              VendInvDisc.GetRec(
                PurchHeader."Invoice Disc. Code",PurchHeader."Currency Code",CurrencyDate,InvDiscBase);

            PurchHeader."Invoice Discount Calculation" := PurchHeader."invoice discount calculation"::"%";
            PurchHeader."Invoice Discount Value" := VendInvDisc."Discount %";

            if not UpdateHeader then
              PurchHeader.Modify;

            TempVATAmountLine.SetInvoiceDiscountPercent(
              VendInvDisc."Discount %",PurchHeader."Currency Code",
              PurchHeader."Prices Including VAT",PurchSetup."Calc. Inv. Disc. per VAT ID",
              PurchHeader."VAT Base Discount %");
          end;

          PurchLine2.UpdateVATOnLines(0,PurchHeader,PurchLine2,TempVATAmountLine);
        end;

        OnAfterCalcPurchaseDiscount(PurchHeader);
    end;

    local procedure VendInvDiscRecExists(InvDiscCode: Code[20]): Boolean
    var
        VendInvDisc: Record "Vendor Invoice Disc.";
    begin
        VendInvDisc.SetRange(Code,InvDiscCode);
        exit(VendInvDisc.FindFirst);
    end;


    procedure CalculateIncDiscForHeader(var PurchHeader: Record "Purchase Header")
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        PurchSetup.Get;
        if not PurchSetup."Calc. Inv. Discount" then
          exit;
        with PurchHeader do begin
          PurchLine."Document Type" := "Document Type";
          PurchLine."Document No." := "No.";
          CalculateInvoiceDiscount(PurchHeader,PurchLine);
        end;
    end;


    procedure CalculateInvoiceDiscountOnLine(var PurchLineToUpdate: Record "Purchase Line")
    var
        PurchHeaderTemp: Record "Purchase Header";
    begin
        PurchLine.Copy(PurchLineToUpdate);

        PurchHeaderTemp.Get(PurchLineToUpdate."Document Type",PurchLineToUpdate."Document No.");
        UpdateHeader := true;
        CalculateInvoiceDiscount(PurchHeaderTemp,PurchLineToUpdate);

        PurchLineToUpdate.Copy(PurchLine);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcPurchaseDiscount(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcPurchaseDiscount(var PurchaseHeader: Record "Purchase Header")
    begin
    end;
}

