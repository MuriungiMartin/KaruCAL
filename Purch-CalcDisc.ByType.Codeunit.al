#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 66 "Purch - Calc Disc. By Type"
{
    TableNo = "Purchase Line";

    trigger OnRun()
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.Copy(Rec);

        if PurchHeader.Get("Document Type","Document No.") then begin
          ApplyDefaultInvoiceDiscount(0,PurchHeader);
          // on new order might be no line
          if Get(PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.") then;
        end;
    end;

    var
        InvDiscBaseAmountIsZeroErr: label 'There is no amount that you can apply an invoice discount to.';
        InvDiscSetToZeroMsg: label 'The current %1 is %2.\\The value will be set to zero because the total has changed. Review the new total and then re-enter the %1.', Comment='%1 - Invoice discount amount, %2 Previous value of Invoice discount amount';
        AmountInvDiscErr: label 'Manual %1 is not allowed.';


    procedure ApplyDefaultInvoiceDiscount(InvoiceDiscountAmount: Decimal;var PurchHeader: Record "Purchase Header")
    var
        AutoFormatManagement: Codeunit "Auto Format";
        PreviousInvoiceDiscountAmount: Decimal;
        ShowSetToZeroMessage: Boolean;
    begin
        if not ShouldRedistributeInvoiceDiscountAmount(PurchHeader) then
          exit;

        if PurchHeader."Invoice Discount Calculation" = PurchHeader."invoice discount calculation"::Amount then begin
          PreviousInvoiceDiscountAmount := PurchHeader."Invoice Discount Value";
          ShowSetToZeroMessage := (InvoiceDiscountAmount = 0) and (PurchHeader."Invoice Discount Value" <> 0);
          ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,PurchHeader);
          if ShowSetToZeroMessage then
            Message(
              StrSubstNo(
                InvDiscSetToZeroMsg,
                PurchHeader.FieldCaption("Invoice Discount Amount"),
                Format(PreviousInvoiceDiscountAmount,0,AutoFormatManagement.AutoFormatTranslate(1,PurchHeader."Currency Code"))));
        end else
          ApplyInvDiscBasedOnPct(PurchHeader);

        ResetRecalculateInvoiceDisc(PurchHeader);
    end;


    procedure ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount: Decimal;var PurchHeader: Record "Purchase Header")
    var
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        PurchLine: Record "Purchase Line";
        InvDiscBaseAmount: Decimal;
    begin
        with PurchHeader do begin
          if not InvoiceDiscIsAllowed("Invoice Disc. Code") then
            Error(StrSubstNo(AmountInvDiscErr,FieldCaption("Invoice Discount Amount")));

          PurchLine.SetRange("Document No.","No.");
          PurchLine.SetRange("Document Type","Document Type");

          PurchLine.CalcVATAmountLines(0,PurchHeader,PurchLine,TempVATAmountLine);

          InvDiscBaseAmount := TempVATAmountLine.GetTotalInvDiscBaseAmount(false,"Currency Code");

          if (InvDiscBaseAmount = 0) and (InvoiceDiscountAmount > 0) then
            Error(InvDiscBaseAmountIsZeroErr);

          TempVATAmountLine.SetInvoiceDiscountAmount(InvoiceDiscountAmount,"Currency Code",
            "Prices Including VAT","VAT Base Discount %");

          PurchLine.UpdateVATOnLines(0,PurchHeader,PurchLine,TempVATAmountLine);

          "Invoice Discount Calculation" := "invoice discount calculation"::Amount;
          "Invoice Discount Value" := InvoiceDiscountAmount;

          Modify;

          ResetRecalculateInvoiceDisc(PurchHeader);
        end;
    end;

    local procedure ApplyInvDiscBasedOnPct(var PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
    begin
        with PurchHeader do begin
          PurchLine.SetRange("Document No.","No.");
          PurchLine.SetRange("Document Type","Document Type");
          if PurchLine.FindFirst then begin
            Codeunit.Run(Codeunit::"Purch.-Calc.Discount",PurchLine);
            Get("Document Type","No.");
          end;
        end;
    end;


    procedure GetVendInvoiceDiscountPct(PurchLine: Record "Purchase Line"): Decimal
    var
        PurchHeader: Record "Purchase Header";
        InvoiceDiscountValue: Decimal;
    begin
        with PurchHeader do begin
          if not Get(PurchLine."Document Type",PurchLine."Document No.") then
            exit(0);

          CalcFields("Invoice Discount Amount");
          if "Invoice Discount Amount" = 0 then
            exit(0);

          case "Invoice Discount Calculation" of
            "invoice discount calculation"::"%":
              begin
                // Only if VendorInvDisc table is empty header is not updated
                if not VendorInvDiscRecExists("Invoice Disc. Code") then
                  exit(0);

                exit("Invoice Discount Value");
              end;
            "invoice discount calculation"::None,
            "invoice discount calculation"::Amount:
              begin
                CalcFields("Amount Including VAT",Amount);
                if Amount = 0 then
                  exit(0);

                if "Invoice Discount Calculation" = "invoice discount calculation"::None then
                  InvoiceDiscountValue := "Invoice Discount Amount"
                else
                  InvoiceDiscountValue := "Invoice Discount Value";

                if "Prices Including VAT" then
                  exit(ROUND(InvoiceDiscountValue / ("Amount Including VAT" + InvoiceDiscountValue) * 100,0.01));

                exit(ROUND(InvoiceDiscountValue / (Amount + InvoiceDiscountValue) * 100,0.01));
              end;
          end;
        end;

        exit(0);
    end;


    procedure ShouldRedistributeInvoiceDiscountAmount(PurchHeader: Record "Purchase Header"): Boolean
    var
        PurchPayablesSetup: Record "Purchases & Payables Setup";
        DummyApplicationAreaSetup: Record "Application Area Setup";
    begin
        PurchHeader.CalcFields("Recalculate Invoice Disc.");

        if not PurchHeader."Recalculate Invoice Disc." then
          exit(false);

        if (PurchHeader."Invoice Discount Calculation" = PurchHeader."invoice discount calculation"::Amount) and
           (PurchHeader."Invoice Discount Value" = 0)
        then
          exit(false);

        PurchPayablesSetup.Get;
        if (not DummyApplicationAreaSetup.IsFoundationEnabled and
            (not PurchPayablesSetup."Calc. Inv. Discount" and
             (PurchHeader."Invoice Discount Calculation" = PurchHeader."invoice discount calculation"::None)))
        then
          exit(false);

        exit(true);
    end;


    procedure ResetRecalculateInvoiceDisc(PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.SetRange("Document Type",PurchHeader."Document Type");
        PurchLine.SetRange("Document No.",PurchHeader."No.");
        PurchLine.ModifyAll("Recalculate Invoice Disc.",false);
    end;

    local procedure VendorInvDiscRecExists(InvDiscCode: Code[20]): Boolean
    var
        VendorInvoiceDisc: Record "Vendor Invoice Disc.";
    begin
        VendorInvoiceDisc.SetRange(Code,InvDiscCode);
        exit(not VendorInvoiceDisc.IsEmpty);
    end;


    procedure InvoiceDiscIsAllowed(InvDiscCode: Code[20]): Boolean
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        DummyApplicationAreaSetup: Record "Application Area Setup";
    begin
        PurchasesPayablesSetup.Get;
        exit((DummyApplicationAreaSetup.IsFoundationEnabled or not
              (PurchasesPayablesSetup."Calc. Inv. Discount" and VendorInvDiscRecExists(InvDiscCode))));
    end;
}

