#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 87 "Blanket Sales Order to Order"
{
    TableNo = "Sales Header";

    trigger OnRun()
    var
        Cust: Record Customer;
        TempSalesLine: Record "Sales Line" temporary;
        AttachedToSalesLine: Record "Sales Line";
        ATOLink: Record "Assemble-to-Order Link";
        PrepmtMgt: Codeunit "Prepayment Mgt.";
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        Reservation: Page Reservation;
        ShouldRedistributeInvoiceAmount: Boolean;
        CreditLimitExceeded: Boolean;
    begin
        TestField("Document Type","document type"::"Blanket Order");
        ShouldRedistributeInvoiceAmount := SalesCalcDiscountByType.ShouldRedistributeInvoiceDiscountAmount(Rec);

        Cust.Get("Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust,"document type"::Order,true,false);

        if QtyToShipIsZero then
          Error(Text002);

        SalesSetup.Get;

        CheckAvailability(Rec);

        SalesOrderHeader := Rec;
        SalesOrderHeader."Document Type" := SalesOrderHeader."document type"::Order;
        if not HideValidationDialog then
          CreditLimitExceeded := CustCheckCreditLimit.SalesHeaderCheck(SalesOrderHeader);

        SalesOrderHeader."No. Printed" := 0;
        SalesOrderHeader.Status := SalesOrderHeader.Status::Open;
        SalesOrderHeader."No." := '';

        SalesOrderLine.LockTable;
        SalesOrderHeader.Insert(true);

        if "Order Date" = 0D then
          SalesOrderHeader."Order Date" := WorkDate
        else
          SalesOrderHeader."Order Date" := "Order Date";
        if "Posting Date" <> 0D then
          SalesOrderHeader."Posting Date" := "Posting Date";

        SalesOrderHeader.InitFromSalesHeader(Rec);
        SalesOrderHeader."Outbound Whse. Handling Time" := "Outbound Whse. Handling Time";
        SalesOrderHeader.Reserve := Reserve;

        SalesOrderHeader."Prepayment %" := Cust."Prepayment %";
        if SalesOrderHeader."Posting Date" = 0D then
          SalesOrderHeader."Posting Date" := WorkDate;

        SalesOrderHeader.Modify;

        BlanketOrderSalesLine.Reset;
        BlanketOrderSalesLine.SetRange("Document Type","Document Type");
        BlanketOrderSalesLine.SetRange("Document No.","No.");

        if BlanketOrderSalesLine.FindSet then begin
          TempSalesLine.DeleteAll;
          repeat
            if (BlanketOrderSalesLine.Type = BlanketOrderSalesLine.Type::" ") or (BlanketOrderSalesLine."Qty. to Ship" <> 0) then begin
              SalesLine.SetCurrentkey("Document Type","Blanket Order No.","Blanket Order Line No.");
              SalesLine.SetRange("Blanket Order No.",BlanketOrderSalesLine."Document No.");
              SalesLine.SetRange("Blanket Order Line No.",BlanketOrderSalesLine."Line No.");
              QuantityOnOrders := 0;
              if SalesLine.FindSet then
                repeat
                  if (SalesLine."Document Type" = SalesLine."document type"::"Return Order") or
                     ((SalesLine."Document Type" = SalesLine."document type"::"Credit Memo") and
                      (SalesLine."Return Receipt No." = ''))
                  then
                    QuantityOnOrders := QuantityOnOrders - SalesLine."Outstanding Qty. (Base)"
                  else
                    if (SalesLine."Document Type" = SalesLine."document type"::Order) or
                       ((SalesLine."Document Type" = SalesLine."document type"::Invoice) and
                        (SalesLine."Shipment No." = ''))
                    then
                      QuantityOnOrders := QuantityOnOrders + SalesLine."Outstanding Qty. (Base)";
                until SalesLine.Next = 0;
              if (Abs(BlanketOrderSalesLine."Qty. to Ship (Base)" + QuantityOnOrders +
                    BlanketOrderSalesLine."Qty. Shipped (Base)") >
                  Abs(BlanketOrderSalesLine."Quantity (Base)")) or
                 (BlanketOrderSalesLine."Quantity (Base)" * BlanketOrderSalesLine."Outstanding Qty. (Base)" < 0)
              then
                Error(
                  QuantityCheckErr,
                  BlanketOrderSalesLine.FieldCaption("Qty. to Ship (Base)"),
                  BlanketOrderSalesLine.Type,BlanketOrderSalesLine."No.",
                  BlanketOrderSalesLine.FieldCaption("Line No."),BlanketOrderSalesLine."Line No.",
                  BlanketOrderSalesLine."Outstanding Qty. (Base)" - QuantityOnOrders,
                  StrSubstNo(
                    Text001,
                    BlanketOrderSalesLine.FieldCaption("Outstanding Qty. (Base)"),
                    BlanketOrderSalesLine.FieldCaption("Qty. to Ship (Base)")),
                  BlanketOrderSalesLine."Outstanding Qty. (Base)",QuantityOnOrders);
              SalesOrderLine := BlanketOrderSalesLine;
              ResetQuantityFields(SalesOrderLine);
              SalesOrderLine."Document Type" := SalesOrderHeader."Document Type";
              SalesOrderLine."Document No." := SalesOrderHeader."No.";
              SalesOrderLine."Blanket Order No." := "No.";
              SalesOrderLine."Blanket Order Line No." := BlanketOrderSalesLine."Line No.";
              if (SalesOrderLine."No." <> '') and (SalesOrderLine.Type <> 0) then begin
                SalesOrderLine.Amount := 0;
                SalesOrderLine."Amount Including VAT" := 0;
                SalesOrderLine.Validate(Quantity,BlanketOrderSalesLine."Qty. to Ship");
                SalesOrderLine.Validate("Shipment Date",BlanketOrderSalesLine."Shipment Date");
                SalesOrderLine.Validate("Unit Price",BlanketOrderSalesLine."Unit Price");
                SalesOrderLine."Allow Invoice Disc." := BlanketOrderSalesLine."Allow Invoice Disc.";
                SalesOrderLine."Allow Line Disc." := BlanketOrderSalesLine."Allow Line Disc.";
                SalesOrderLine.Validate("Line Discount %",BlanketOrderSalesLine."Line Discount %");
                if SalesOrderLine.Quantity <> 0 then
                  SalesOrderLine.Validate("Inv. Discount Amount",BlanketOrderSalesLine."Inv. Discount Amount");
                ReserveSalesLine.TransferSaleLineToSalesLine(
                  BlanketOrderSalesLine,SalesOrderLine,BlanketOrderSalesLine."Outstanding Qty. (Base)");
              end;

              if Cust."Prepayment %" <> 0 then
                SalesOrderLine."Prepayment %" := Cust."Prepayment %";
              PrepmtMgt.SetSalesPrepaymentPct(SalesOrderLine,SalesOrderHeader."Posting Date");
              SalesOrderLine.Validate("Prepayment %");

              SalesOrderLine."Shortcut Dimension 1 Code" := BlanketOrderSalesLine."Shortcut Dimension 1 Code";
              SalesOrderLine."Shortcut Dimension 2 Code" := BlanketOrderSalesLine."Shortcut Dimension 2 Code";
              SalesOrderLine."Dimension Set ID" := BlanketOrderSalesLine."Dimension Set ID";
              if ATOLink.AsmExistsForSalesLine(BlanketOrderSalesLine) then begin
                SalesOrderLine."Qty. to Assemble to Order" := SalesOrderLine.Quantity;
                SalesOrderLine."Qty. to Asm. to Order (Base)" := SalesOrderLine."Quantity (Base)";
              end;
              SalesOrderLine.DefaultDeferralCode;
              if (SalesOrderLine."Attached to Line No." = 0) or
                 AttachedToSalesLine.Get(
                   SalesOrderLine."Document Type",SalesOrderLine."Document No.",SalesOrderLine."Attached to Line No.")
              then
                SalesOrderLine.Insert;

              if ATOLink.AsmExistsForSalesLine(BlanketOrderSalesLine) then
                ATOLink.MakeAsmOrderLinkedToSalesOrderLine(BlanketOrderSalesLine,SalesOrderLine);

              if BlanketOrderSalesLine."Qty. to Ship" <> 0 then begin
                BlanketOrderSalesLine.Validate("Qty. to Ship",0);
                BlanketOrderSalesLine.Modify;
                AutoReserve(SalesOrderLine,TempSalesLine);
              end;
            end;
          until BlanketOrderSalesLine.Next = 0;
        end;

        if SalesSetup."Default Posting Date" = SalesSetup."default posting date"::"No Date" then begin
          SalesOrderHeader."Posting Date" := 0D;
          SalesOrderHeader.Modify;
        end;
        SalesOrderLine.CalcSalesTaxLines(SalesOrderHeader,SalesOrderLine);
        CopyCommentsFromBlanketToOrder(Rec);

        if not ShouldRedistributeInvoiceAmount then
          SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(SalesOrderHeader);

        if (not HideValidationDialog) and (not CreditLimitExceeded) then
          CustCheckCreditLimit.BlanketSalesOrderToOrderCheck(SalesOrderHeader);

        Commit;

        if TempSalesLine.Find('-') then
          if Confirm(Text003,true) then
            repeat
              Clear(Reservation);
              Reservation.SetSalesLine(TempSalesLine);
              Reservation.RunModal;
              Find;
            until TempSalesLine.Next = 0;

        Clear(CustCheckCreditLimit);
        Clear(ItemCheckAvail);
    end;

    var
        QuantityCheckErr: label '%1 of %2 %3 in %4 %5 cannot be more than %6.\%7\%8 - %9 = %6.', Comment='%1: FIELDCAPTION("Qty. to Ship (Base)"); %2: Field(Type); %3: Field(No.); %4: FIELDCAPTION("Line No."); %5: Field(Line No.); %6: Decimal Qty Difference; %7: Text001; %8: Field(Outstanding Qty. (Base)); %9: Decimal Quantity On Orders';
        Text001: label '%1 - Unposted %1 = Possible %2';
        BlanketOrderSalesLine: Record "Sales Line";
        SalesLine: Record "Sales Line";
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        SalesCommentLine: Record "Sales Comment Line";
        SalesCommentLine2: Record "Sales Comment Line";
        SalesSetup: Record "Sales & Receivables Setup";
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        HideValidationDialog: Boolean;
        QuantityOnOrders: Decimal;
        Text002: label 'There is nothing to create.';
        Text003: label 'Full automatic reservation was not possible.\Reserve items manually?';

    local procedure ResetQuantityFields(var TempSalesLine: Record "Sales Line")
    begin
        TempSalesLine.Quantity := 0;
        TempSalesLine."Quantity (Base)" := 0;
        TempSalesLine."Qty. Shipped Not Invoiced" := 0;
        TempSalesLine."Quantity Shipped" := 0;
        TempSalesLine."Quantity Invoiced" := 0;
        TempSalesLine."Qty. Shipped Not Invd. (Base)" := 0;
        TempSalesLine."Qty. Shipped (Base)" := 0;
        TempSalesLine."Qty. Invoiced (Base)" := 0;
        TempSalesLine."Outstanding Quantity" := 0;
        TempSalesLine."Outstanding Qty. (Base)" := 0;
    end;


    procedure GetSalesOrderHeader(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader := SalesOrderHeader;
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    local procedure AutoReserve(var SalesLine: Record "Sales Line";var TempSalesLine: Record "Sales Line" temporary)
    var
        ReservMgt: Codeunit "Reservation Management";
        FullAutoReservation: Boolean;
    begin
        with SalesLine do
          if (Type = Type::Item) and
             (Reserve = Reserve::Always) and
             ("No." <> '')
          then begin
            TestField("Shipment Date");
            ReservMgt.SetSalesLine(SalesLine);
            ReservMgt.AutoReserve(FullAutoReservation,'',"Shipment Date","Qty. to Ship","Qty. to Ship (Base)");
            Find;
            if not FullAutoReservation then begin
              TempSalesLine.TransferFields(SalesLine);
              TempSalesLine.Insert;
            end;
          end;
    end;

    local procedure CheckAvailability(BlanketOrderSalesHeader: Record "Sales Header")
    var
        ATOLink: Record "Assemble-to-Order Link";
    begin
        with BlanketOrderSalesLine do begin
          SetRange("Document Type",BlanketOrderSalesHeader."Document Type");
          SetRange("Document No.",BlanketOrderSalesHeader."No.");
          SetRange(Type,Type::Item);
          SetFilter("No.",'<>%1','');
          if FindSet then
            repeat
              if "Qty. to Ship" > 0 then begin
                SalesLine := BlanketOrderSalesLine;
                ResetQuantityFields(SalesLine);
                SalesLine.Quantity := "Qty. to Ship";
                SalesLine."Quantity (Base)" := ROUND(SalesLine.Quantity * SalesLine."Qty. per Unit of Measure",0.00001);
                SalesLine."Qty. to Ship" := SalesLine.Quantity;
                SalesLine."Qty. to Ship (Base)" := SalesLine."Quantity (Base)";
                SalesLine.InitOutstanding;
                if ATOLink.AsmExistsForSalesLine(BlanketOrderSalesLine) then begin
                  SalesLine."Qty. to Assemble to Order" := SalesLine.Quantity;
                  SalesLine."Qty. to Asm. to Order (Base)" := SalesLine."Quantity (Base)";
                  SalesLine."Outstanding Quantity" -= SalesLine."Qty. to Assemble to Order";
                  SalesLine."Outstanding Qty. (Base)" -= SalesLine."Qty. to Asm. to Order (Base)";
                end;
                if SalesLine.Reserve <> SalesLine.Reserve::Always then
                  if not HideValidationDialog then
                    if ItemCheckAvail.SalesLineCheck(SalesLine) then
                      ItemCheckAvail.RaiseUpdateInterruptedError;
              end;
            until Next = 0;
        end;
    end;

    local procedure CopyCommentsFromBlanketToOrder(BlanketOrderSalesHeader: Record "Sales Header")
    var
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        if SalesSetup."Copy Comments Blanket to Order" then begin
          SalesCommentLine.SetRange("Document Type",SalesCommentLine."document type"::"Blanket Order");
          SalesCommentLine.SetRange("No.",BlanketOrderSalesHeader."No.");
          if SalesCommentLine.FindSet then
            repeat
              SalesCommentLine2 := SalesCommentLine;
              SalesCommentLine2."Document Type" := SalesOrderHeader."Document Type";
              SalesCommentLine2."No." := SalesOrderHeader."No.";
              SalesCommentLine2.Insert;
            until SalesCommentLine.Next = 0;
          RecordLinkManagement.CopyLinks(BlanketOrderSalesHeader,SalesOrderHeader);
        end;
    end;
}

