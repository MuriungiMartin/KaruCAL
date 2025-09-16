#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60 "Sales-Calc. Discount"
{
    TableNo = "Sales Line";

    trigger OnRun()
    begin
        SalesLine.Copy(Rec);

        TempSalesHeader.Get("Document Type","Document No.");
        UpdateHeader := false;
        CalculateInvoiceDiscount(TempSalesHeader,TempSalesLine);

        if Get(SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.") then;
    end;

    var
        Text000: label 'Service Charge';
        TempSalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line";
        CustInvDisc: Record "Cust. Invoice Disc.";
        CustPostingGr: Record "Customer Posting Group";
        Currency: Record Currency;
        InvDiscBase: Decimal;
        ChargeBase: Decimal;
        CurrencyDate: Date;
        UpdateHeader: Boolean;

    local procedure CalculateInvoiceDiscount(var SalesHeader: Record "Sales Header";var SalesLine2: Record "Sales Line")
    var
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        SalesSetup: Record "Sales & Receivables Setup";
        TempServiceChargeLine: Record "Sales Line" temporary;
    begin
        SalesSetup.Get;
        if not UpdateHeader then
          SalesHeader.Find; // To ensure we have the latest - otherwise update fails.
        OnBeforeCalcSalesDiscount(SalesHeader);

        with SalesLine do begin
          LockTable;
          SalesHeader.TestField("Customer Posting Group");
          CustPostingGr.Get(SalesHeader."Customer Posting Group");

          SalesLine2.Reset;
          SalesLine2.SetRange("Document Type","Document Type");
          SalesLine2.SetRange("Document No.","Document No.");
          SalesLine2.SetRange("System-Created Entry",true);
          SalesLine2.SetRange(Type,SalesLine2.Type::"G/L Account");
          SalesLine2.SetRange("No.",CustPostingGr."Service Charge Acc.");
          if SalesLine2.FindSet(true,false) then
            repeat
              SalesLine2.Validate("Unit Price",0);
              SalesLine2.Modify;
              TempServiceChargeLine := SalesLine2;
              TempServiceChargeLine.Insert;
            until SalesLine2.Next = 0;

          SalesLine2.Reset;
          SalesLine2.SetRange("Document Type","Document Type");
          SalesLine2.SetRange("Document No.","Document No.");
          SalesLine2.SetFilter(Type,'<>0');
          if SalesLine2.FindFirst then;
          SalesLine2.CalcVATAmountLines(0,SalesHeader,SalesLine2,TempVATAmountLine);
          InvDiscBase :=
            TempVATAmountLine.GetTotalInvDiscBaseAmount(
              SalesHeader."Prices Including VAT",SalesHeader."Currency Code");
          ChargeBase :=
            TempVATAmountLine.GetTotalLineAmount(
              SalesHeader."Prices Including VAT",SalesHeader."Currency Code");

          if not UpdateHeader then
            SalesHeader.Modify;

          if SalesHeader."Posting Date" = 0D then
            CurrencyDate := WorkDate
          else
            CurrencyDate := SalesHeader."Posting Date";

          CustInvDisc.GetRec(
            SalesHeader."Invoice Disc. Code",SalesHeader."Currency Code",CurrencyDate,ChargeBase);

          if CustInvDisc."Service Charge" <> 0 then begin
            CustPostingGr.TestField("Service Charge Acc.");
            if SalesHeader."Currency Code" = '' then
              Currency.InitRoundingPrecision
            else
              Currency.Get(SalesHeader."Currency Code");
            if UpdateHeader then
              SalesLine2.SetSalesHeader(SalesHeader);
            if not TempServiceChargeLine.IsEmpty then begin
              TempServiceChargeLine.FindLast;
              SalesLine2.Get("Document Type","Document No.",TempServiceChargeLine."Line No.");
              if SalesHeader."Prices Including VAT" then
                SalesLine2.Validate(
                  "Unit Price",
                  ROUND(
                    (1 + SalesLine2."VAT %" / 100) * CustInvDisc."Service Charge",
                    Currency."Unit-Amount Rounding Precision"))
              else
                SalesLine2.Validate("Unit Price",CustInvDisc."Service Charge");
              SalesLine2.Modify;
            end else begin
              SalesLine2.Reset;
              SalesLine2.SetRange("Document Type","Document Type");
              SalesLine2.SetRange("Document No.","Document No.");
              SalesLine2.FindLast;
              SalesLine2.Init;
              if UpdateHeader then
                SalesLine2.SetSalesHeader(SalesHeader);
              SalesLine2."Line No." := SalesLine2."Line No." + 10000;
              SalesLine2."System-Created Entry" := true;
              SalesLine2.Type := SalesLine2.Type::"G/L Account";
              SalesLine2.Validate("No.",CustPostingGr."Service Charge Acc.");
              SalesLine2.Description := Text000;
              SalesLine2.Validate(Quantity,1);
              if SalesLine2."Document Type" in
                 [SalesLine2."document type"::"Return Order",SalesLine2."document type"::"Credit Memo"]
              then
                SalesLine2.Validate("Return Qty. to Receive",SalesLine2.Quantity)
              else
                SalesLine2.Validate("Qty. to Ship",SalesLine2.Quantity);
              if SalesHeader."Prices Including VAT" then
                SalesLine2.Validate(
                  "Unit Price",
                  ROUND(
                    (1 + SalesLine2."VAT %" / 100) * CustInvDisc."Service Charge",
                    Currency."Unit-Amount Rounding Precision"))
              else
                SalesLine2.Validate("Unit Price",CustInvDisc."Service Charge");
              SalesLine2.Insert;
            end;
            SalesLine2.CalcVATAmountLines(0,SalesHeader,SalesLine2,TempVATAmountLine);
          end else
            if TempServiceChargeLine.FindSet(false,false) then
              repeat
                if (TempServiceChargeLine."Shipment No." = '') and (TempServiceChargeLine."Qty. Shipped Not Invoiced" = 0) then begin
                  SalesLine2 := TempServiceChargeLine;
                  SalesLine2.Delete(true);
                end;
              until TempServiceChargeLine.Next = 0;

          if CustInvDiscRecExists(SalesHeader."Invoice Disc. Code") then begin
            if InvDiscBase <> ChargeBase then
              CustInvDisc.GetRec(
                SalesHeader."Invoice Disc. Code",SalesHeader."Currency Code",CurrencyDate,InvDiscBase);

            SalesHeader."Invoice Discount Calculation" := SalesHeader."invoice discount calculation"::"%";
            SalesHeader."Invoice Discount Value" := CustInvDisc."Discount %";
            if not UpdateHeader then
              SalesHeader.Modify;

            TempVATAmountLine.SetInvoiceDiscountPercent(
              CustInvDisc."Discount %",SalesHeader."Currency Code",
              SalesHeader."Prices Including VAT",SalesSetup."Calc. Inv. Disc. per VAT ID",
              SalesHeader."VAT Base Discount %");
          end;

          SalesLine2.SetSalesHeader(SalesHeader);
          SalesLine2.UpdateVATOnLines(0,SalesHeader,SalesLine2,TempVATAmountLine);
        end;

        OnAfterCalcSalesDiscount(SalesHeader);
    end;

    local procedure CustInvDiscRecExists(InvDiscCode: Code[20]): Boolean
    var
        CustInvDisc: Record "Cust. Invoice Disc.";
    begin
        CustInvDisc.SetRange(Code,InvDiscCode);
        exit(CustInvDisc.FindFirst);
    end;


    procedure CalculateWithSalesHeader(var TempSalesHeader: Record "Sales Header";var TempSalesLine: Record "Sales Line")
    var
        FilterSalesLine: Record "Sales Line";
    begin
        FilterSalesLine.Copy(TempSalesLine);
        SalesLine := TempSalesLine;

        UpdateHeader := true;
        CalculateInvoiceDiscount(TempSalesHeader,TempSalesLine);

        TempSalesLine.Copy(FilterSalesLine);
    end;


    procedure CalculateInvoiceDiscountOnLine(var SalesLineToUpdate: Record "Sales Line")
    begin
        SalesLine.Copy(SalesLineToUpdate);

        TempSalesHeader.Get(SalesLineToUpdate."Document Type",SalesLineToUpdate."Document No.");
        UpdateHeader := true;
        CalculateInvoiceDiscount(TempSalesHeader,SalesLineToUpdate);

        SalesLineToUpdate.Copy(SalesLine);
    end;


    procedure CalculateIncDiscForHeader(var TempSalesHeader: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        if not SalesSetup."Calc. Inv. Discount" then
          exit;
        with TempSalesHeader do begin
          SalesLine."Document Type" := "Document Type";
          SalesLine."Document No." := "No.";
          CalculateInvoiceDiscount(TempSalesHeader,TempSalesLine);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcSalesDiscount(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcSalesDiscount(var SalesHeader: Record "Sales Header")
    begin
    end;
}

