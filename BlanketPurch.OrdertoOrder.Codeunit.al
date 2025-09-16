#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 97 "Blanket Purch. Order to Order"
{
    TableNo = "Purchase Header";

    trigger OnRun()
    var
        Vend: Record Vendor;
        AttachedToPurchaseLine: Record "Purchase Line";
        PrepmtMgt: Codeunit "Prepayment Mgt.";
        ShouldRedistributeInvoiceAmount: Boolean;
    begin
        TestField("Document Type","document type"::"Blanket Order");
        ShouldRedistributeInvoiceAmount := PurchCalcDiscByType.ShouldRedistributeInvoiceDiscountAmount(Rec);

        Vend.Get("Buy-from Vendor No.");
        Vend.CheckBlockedVendOnDocs(Vend,false);

        if QtyToReceiveIsZero then
          Error(Text002);

        PurchSetup.Get;

        PurchOrderHeader := Rec;
        PurchOrderHeader."Document Type" := PurchOrderHeader."document type"::Order;
        PurchOrderHeader."No. Printed" := 0;
        PurchOrderHeader.Status := PurchOrderHeader.Status::Open;
        PurchOrderHeader."No." := '';

        PurchOrderLine.LockTable;
        PurchOrderHeader.Insert(true);

        if "Order Date" = 0D then
          PurchOrderHeader."Order Date" := WorkDate
        else
          PurchOrderHeader."Order Date" := "Order Date";
        if "Posting Date" <> 0D then
          PurchOrderHeader."Posting Date" := "Posting Date";
        PurchOrderHeader."Document Date" := "Document Date";
        PurchOrderHeader."Expected Receipt Date" := "Expected Receipt Date";
        PurchOrderHeader."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        PurchOrderHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        PurchOrderHeader."Dimension Set ID" := "Dimension Set ID";
        PurchOrderHeader."Inbound Whse. Handling Time" := "Inbound Whse. Handling Time";
        PurchOrderHeader."Location Code" := "Location Code";
        PurchOrderHeader."Ship-to Name" := "Ship-to Name";
        PurchOrderHeader."Ship-to Name 2" := "Ship-to Name 2";
        PurchOrderHeader."Ship-to Address" := "Ship-to Address";
        PurchOrderHeader."Ship-to Address 2" := "Ship-to Address 2";
        PurchOrderHeader."Ship-to City" := "Ship-to City";
        PurchOrderHeader."Ship-to Post Code" := "Ship-to Post Code";
        PurchOrderHeader."Ship-to County" := "Ship-to County";
        PurchOrderHeader."Ship-to Country/Region Code" := "Ship-to Country/Region Code";
        PurchOrderHeader."Ship-to Contact" := "Ship-to Contact";

        PurchOrderHeader."Prepayment %" := Vend."Prepayment %";
        if PurchOrderHeader."Posting Date" = 0D then
          PurchOrderHeader."Posting Date" := WorkDate;

        PurchOrderHeader."Tax Area Code" := "Tax Area Code";
        PurchOrderHeader."Provincial Tax Area Code" := "Provincial Tax Area Code";

        PurchOrderHeader.Modify;

        PurchBlanketOrderLine.Reset;
        PurchBlanketOrderLine.SetRange("Document Type","Document Type");
        PurchBlanketOrderLine.SetRange("Document No.","No.");

        if PurchBlanketOrderLine.FindSet then
          repeat
            if (PurchBlanketOrderLine.Type = PurchBlanketOrderLine.Type::" ") or
               (PurchBlanketOrderLine."Qty. to Receive" <> 0)
            then begin
              PurchLine.SetCurrentkey("Document Type","Blanket Order No.","Blanket Order Line No.");
              PurchLine.SetRange("Blanket Order No.",PurchBlanketOrderLine."Document No.");
              PurchLine.SetRange("Blanket Order Line No.",PurchBlanketOrderLine."Line No.");
              QuantityOnOrders := 0;
              if PurchLine.FindSet then
                repeat
                  if (PurchLine."Document Type" = PurchLine."document type"::"Return Order") or
                     ((PurchLine."Document Type" = PurchLine."document type"::"Credit Memo") and
                      (PurchLine."Return Shipment No." = ''))
                  then
                    QuantityOnOrders := QuantityOnOrders - PurchLine."Outstanding Qty. (Base)"
                  else
                    if (PurchLine."Document Type" = PurchLine."document type"::Order) or
                       ((PurchLine."Document Type" = PurchLine."document type"::Invoice) and
                        (PurchLine."Receipt No." = ''))
                    then
                      QuantityOnOrders := QuantityOnOrders + PurchLine."Outstanding Qty. (Base)";
                until PurchLine.Next = 0;
              if (Abs(PurchBlanketOrderLine."Qty. to Receive (Base)" + QuantityOnOrders +
                    PurchBlanketOrderLine."Qty. Received (Base)") >
                  Abs(PurchBlanketOrderLine."Quantity (Base)")) or
                 (PurchBlanketOrderLine."Quantity (Base)" * PurchBlanketOrderLine."Outstanding Qty. (Base)" < 0)
              then
                Error(
                  QuantityCheckErr,
                  PurchBlanketOrderLine.FieldCaption("Qty. to Receive (Base)"),
                  PurchBlanketOrderLine.Type,PurchBlanketOrderLine."No.",
                  PurchBlanketOrderLine.FieldCaption("Line No."),PurchBlanketOrderLine."Line No.",
                  PurchBlanketOrderLine."Outstanding Qty. (Base)" - QuantityOnOrders,
                  StrSubstNo(
                    Text001,
                    PurchBlanketOrderLine.FieldCaption("Outstanding Qty. (Base)"),
                    PurchBlanketOrderLine.FieldCaption("Qty. to Receive (Base)")),
                  PurchBlanketOrderLine."Outstanding Qty. (Base)",QuantityOnOrders);

              PurchOrderLine := PurchBlanketOrderLine;
              ResetQuantityFields(PurchOrderLine);
              PurchOrderLine."Document Type" := PurchOrderHeader."Document Type";
              PurchOrderLine."Document No." := PurchOrderHeader."No.";
              PurchOrderLine."Blanket Order No." := "No.";
              PurchOrderLine."Blanket Order Line No." := PurchBlanketOrderLine."Line No.";

              if (PurchOrderLine."No." <> '') and (PurchOrderLine.Type <> 0)then begin
                PurchOrderLine.Amount := 0;
                PurchOrderLine."Amount Including VAT" := 0;
                PurchOrderLine.Validate(Quantity,PurchBlanketOrderLine."Qty. to Receive");
                if PurchBlanketOrderLine."Expected Receipt Date" <> 0D then
                  PurchOrderLine.Validate("Expected Receipt Date",PurchBlanketOrderLine."Expected Receipt Date")
                else
                  PurchOrderLine.Validate("Order Date",PurchOrderHeader."Order Date");
                PurchOrderLine.Validate("Direct Unit Cost",PurchBlanketOrderLine."Direct Unit Cost");
                PurchOrderLine.Validate("Line Discount %",PurchBlanketOrderLine."Line Discount %");
                if PurchOrderLine.Quantity <> 0 then
                  PurchOrderLine.Validate("Inv. Discount Amount",PurchBlanketOrderLine."Inv. Discount Amount");
                PurchBlanketOrderLine.CalcFields("Reserved Qty. (Base)");
                if PurchBlanketOrderLine."Reserved Qty. (Base)" <> 0 then
                  ReservePurchLine.TransferPurchLineToPurchLine(
                    PurchBlanketOrderLine,PurchOrderLine,-PurchBlanketOrderLine."Qty. to Receive (Base)");
              end;

              if Vend."Prepayment %" <> 0 then
                PurchOrderLine."Prepayment %" := Vend."Prepayment %";
              PrepmtMgt.SetPurchPrepaymentPct(PurchOrderLine,PurchOrderHeader."Posting Date");
              PurchOrderLine.Validate("Prepayment %");

              PurchOrderLine."Shortcut Dimension 1 Code" := PurchBlanketOrderLine."Shortcut Dimension 1 Code";
              PurchOrderLine."Shortcut Dimension 2 Code" := PurchBlanketOrderLine."Shortcut Dimension 2 Code";
              PurchOrderLine."Dimension Set ID" := PurchBlanketOrderLine."Dimension Set ID";
              PurchOrderLine.DefaultDeferralCode;
              if (PurchOrderLine."Attached to Line No." = 0) or
                 AttachedToPurchaseLine.Get(
                   PurchOrderLine."Document Type",PurchOrderLine."Document No.",PurchOrderLine."Attached to Line No.")
              then
                PurchOrderLine.Insert;

              if PurchBlanketOrderLine."Qty. to Receive" <> 0 then begin
                PurchBlanketOrderLine.Validate("Qty. to Receive",0);
                PurchBlanketOrderLine.Modify;
              end;
            end;
          until PurchBlanketOrderLine.Next = 0;

        if PurchSetup."Default Posting Date" = PurchSetup."default posting date"::"No Date" then begin
          PurchOrderHeader."Posting Date" := 0D;
          PurchOrderHeader.Modify;
        end;

        PurchOrderLine.CalcSalesTaxLines(PurchOrderHeader,PurchOrderLine);
        CopyCommentsFromBlanketToOrder(Rec);

        if not ShouldRedistributeInvoiceAmount then
          PurchCalcDiscByType.ResetRecalculateInvoiceDisc(PurchOrderHeader);
        Commit;
    end;

    var
        QuantityCheckErr: label '%1 of %2 %3 in %4 %5 cannot be more than %6.\%7\%8 - %9 = %6.', Comment='%1: FIELDCAPTION("Qty. to Receive (Base)"); %2: Field(Type); %3: Field(No.); %4: FIELDCAPTION("Line No."); %5: Field(Line No.); %6: Decimal Qty Difference; %7: Text001; %8: Field(Outstanding Qty. (Base)); %9: Decimal Quantity On Orders';
        Text001: label '%1 - Unposted %1 = Possible %2';
        PurchBlanketOrderLine: Record "Purchase Line";
        PurchOrderHeader: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";
        PurchCommentLine: Record "Purch. Comment Line";
        PurchCommentLine2: Record "Purch. Comment Line";
        PurchSetup: Record "Purchases & Payables Setup";
        PurchLine: Record "Purchase Line";
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        QuantityOnOrders: Decimal;
        Text002: label 'There is nothing to create.';

    local procedure ResetQuantityFields(var TempPurchLine: Record "Purchase Line")
    begin
        TempPurchLine.Quantity := 0;
        TempPurchLine."Quantity (Base)" := 0;
        TempPurchLine."Qty. Rcd. Not Invoiced" := 0;
        TempPurchLine."Quantity Received" := 0;
        TempPurchLine."Quantity Invoiced" := 0;
        TempPurchLine."Qty. Rcd. Not Invoiced (Base)" := 0;
        TempPurchLine."Qty. Received (Base)" := 0;
        TempPurchLine."Qty. Invoiced (Base)" := 0;
    end;


    procedure GetPurchOrderHeader(var PurchHeader: Record "Purchase Header")
    begin
        PurchHeader := PurchOrderHeader;
    end;

    local procedure CopyCommentsFromBlanketToOrder(BlanketOrderPurchaseHeader: Record "Purchase Header")
    var
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        if PurchSetup."Copy Comments Blanket to Order" then begin
          PurchCommentLine.SetRange("Document Type",PurchCommentLine."document type"::"Blanket Order");
          PurchCommentLine.SetRange("No.",BlanketOrderPurchaseHeader."No.");
          if PurchCommentLine.FindSet then
            repeat
              PurchCommentLine2 := PurchCommentLine;
              PurchCommentLine2."Document Type" := PurchOrderHeader."Document Type";
              PurchCommentLine2."No." := PurchOrderHeader."No.";
              PurchCommentLine2.Insert;
            until PurchCommentLine.Next = 0;
          RecordLinkManagement.CopyLinks(BlanketOrderPurchaseHeader,PurchOrderHeader);
        end;
    end;
}

