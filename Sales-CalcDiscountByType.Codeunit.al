#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 56 "Sales - Calc Discount By Type"
{
    TableNo = "Sales Line";

    trigger OnRun()
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
    begin
        SalesLine.Copy(Rec);

        if SalesHeader.Get("Document Type","Document No.") then begin
          ApplyDefaultInvoiceDiscount(0,SalesHeader);
          // on new order might be no line
          if Get(SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.") then;
        end;
    end;

    var
        InvDiscBaseAmountIsZeroErr: label 'There is no amount that you can apply an invoice discount to.';
        InvDiscSetToZeroMsg: label 'The current %1 is %2.\\The value will be set to zero because the total has changed. Review the new total and then re-enter the %1.', Comment='%1 - Invoice discount amount, %2 Previous value of Invoice discount amount';
        AmountInvDiscErr: label 'Manual %1 is not allowed.', Comment='%1 will be "Invoice Discount Amount"';


    procedure ApplyDefaultInvoiceDiscount(InvoiceDiscountAmount: Decimal;var SalesHeader: Record "Sales Header")
    var
        AutoFormatManagement: Codeunit "Auto Format";
        ShowSetToZeroMessage: Boolean;
        PreviousInvoiceDiscountAmount: Decimal;
    begin
        if not ShouldRedistributeInvoiceDiscountAmount(SalesHeader) then
          exit;

        if SalesHeader."Invoice Discount Calculation" = SalesHeader."invoice discount calculation"::Amount then begin
          PreviousInvoiceDiscountAmount := SalesHeader."Invoice Discount Value";
          ShowSetToZeroMessage := (InvoiceDiscountAmount = 0) and (SalesHeader."Invoice Discount Value" <> 0);
          ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
          if ShowSetToZeroMessage then
            Message(
              StrSubstNo(
                InvDiscSetToZeroMsg,
                SalesHeader.FieldCaption("Invoice Discount Amount"),
                Format(PreviousInvoiceDiscountAmount,0,AutoFormatManagement.AutoFormatTranslate(1,SalesHeader."Currency Code"))));
        end else
          ApplyInvDiscBasedOnPct(SalesHeader);

        ResetRecalculateInvoiceDisc(SalesHeader);
    end;


    procedure ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount: Decimal;var SalesHeader: Record "Sales Header")
    var
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        SalesLine: Record "Sales Line";
        InvDiscBaseAmount: Decimal;
    begin
        with SalesHeader do begin
          if not InvoiceDiscIsAllowed("Invoice Disc. Code") then
            Error(StrSubstNo(AmountInvDiscErr,FieldCaption("Invoice Discount Amount")));

          SalesLine.SetRange("Document No.","No.");
          SalesLine.SetRange("Document Type","Document Type");

          SalesLine.CalcVATAmountLines(0,SalesHeader,SalesLine,TempVATAmountLine);

          InvDiscBaseAmount := TempVATAmountLine.GetTotalInvDiscBaseAmount(false,"Currency Code");

          if (InvDiscBaseAmount = 0) and (InvoiceDiscountAmount > 0) then
            Error(InvDiscBaseAmountIsZeroErr);

          TempVATAmountLine.SetInvoiceDiscountAmount(InvoiceDiscountAmount,"Currency Code",
            "Prices Including VAT","VAT Base Discount %");

          SalesLine.UpdateVATOnLines(0,SalesHeader,SalesLine,TempVATAmountLine);

          "Invoice Discount Calculation" := "invoice discount calculation"::Amount;
          "Invoice Discount Value" := InvoiceDiscountAmount;

          Modify;

          ResetRecalculateInvoiceDisc(SalesHeader);
        end;
    end;

    local procedure ApplyInvDiscBasedOnPct(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        with SalesHeader do begin
          SalesLine.SetRange("Document No.","No.");
          SalesLine.SetRange("Document Type","Document Type");
          if SalesLine.FindFirst then begin
            Codeunit.Run(Codeunit::"Sales-Calc. Discount",SalesLine);
            Get("Document Type","No.");
          end;
        end;
    end;


    procedure GetCustInvoiceDiscountPct(SalesLine: Record "Sales Line"): Decimal
    var
        SalesHeader: Record "Sales Header";
        InvoiceDiscountValue: Decimal;
    begin
        with SalesHeader do begin
          if not Get(SalesLine."Document Type",SalesLine."Document No.") then
            exit(0);

          CalcFields("Invoice Discount Amount");
          if "Invoice Discount Amount" = 0 then
            exit(0);

          case "Invoice Discount Calculation" of
            "invoice discount calculation"::"%":
              begin
                // Only if CustInvDisc table is empty header is not updated
                if not CustInvDiscRecExists("Invoice Disc. Code") then
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


    procedure ShouldRedistributeInvoiceDiscountAmount(var SalesHeader: Record "Sales Header"): Boolean
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        DummyApplicationAreaSetup: Record "Application Area Setup";
    begin
        SalesHeader.CalcFields("Recalculate Invoice Disc.");

        if not SalesHeader."Recalculate Invoice Disc." then
          exit(false);

        SalesReceivablesSetup.Get;
        if (SalesHeader."Invoice Discount Calculation" = SalesHeader."invoice discount calculation"::Amount) and
           (SalesHeader."Invoice Discount Value" = 0)
        then
          exit(false);

        if (not DummyApplicationAreaSetup.IsFoundationEnabled and
            (not SalesReceivablesSetup."Calc. Inv. Discount" and
             (SalesHeader."Invoice Discount Calculation" = SalesHeader."invoice discount calculation"::None)))
        then
          exit(false);

        exit(true);
    end;


    procedure ResetRecalculateInvoiceDisc(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type",SalesHeader."Document Type");
        SalesLine.SetRange("Document No.",SalesHeader."No.");
        SalesLine.ModifyAll("Recalculate Invoice Disc.",false);
    end;

    local procedure CustInvDiscRecExists(InvDiscCode: Code[20]): Boolean
    var
        CustInvDisc: Record "Cust. Invoice Disc.";
    begin
        CustInvDisc.SetRange(Code,InvDiscCode);
        exit(not CustInvDisc.IsEmpty);
    end;


    procedure InvoiceDiscIsAllowed(InvDiscCode: Code[20]): Boolean
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        DummyApplicationAreaSetup: Record "Application Area Setup";
    begin
        SalesReceivablesSetup.Get;
        exit((DummyApplicationAreaSetup.IsFoundationEnabled or not
              (SalesReceivablesSetup."Calc. Inv. Discount" and CustInvDiscRecExists(InvDiscCode))));
    end;
}

