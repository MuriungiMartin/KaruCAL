#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 90 "Purch.-Post"
{
    Permissions = TableData "Sales Header"=m,
                  TableData "Sales Line"=m,
                  TableData "Purchase Line"=imd,
                  TableData "Invoice Post. Buffer"=imd,
                  TableData "Vendor Posting Group"=imd,
                  TableData "Inventory Posting Group"=imd,
                  TableData "Sales Shipment Header"=imd,
                  TableData "Sales Shipment Line"=imd,
                  TableData "Purch. Rcpt. Header"=imd,
                  TableData "Purch. Rcpt. Line"=imd,
                  TableData "Purch. Inv. Header"=imd,
                  TableData "Purch. Inv. Line"=imd,
                  TableData "Purch. Cr. Memo Hdr."=imd,
                  TableData "Purch. Cr. Memo Line"=imd,
                  TableData "Drop Shpt. Post. Buffer"=imd,
                  TableData "Gen. Jnl. Dim. Filter"=imd,
                  TableData "Reservation Worksheet Log"=imd,
                  TableData "Item Entry Relation"=ri,
                  TableData "Value Entry Relation"=rid,
                  TableData "Return Shipment Header"=imd,
                  TableData "Return Shipment Line"=imd;
    TableNo = "Purchase Header";

    trigger OnRun()
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;
        TempCombinedPurchLine: Record "Purchase Line" temporary;
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary;
        UpdateAnalysisView: Codeunit "Update Analysis View";
        UpdateItemAnalysisView: Codeunit "Update Item Analysis View";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        EverythingInvoiced: Boolean;
        BiggestLineNo: Integer;
        ICGenJnlLineNo: Integer;
        LineCount: Integer;
    begin
        OnBeforePostPurchaseDoc(Rec);

        ValidatePostingAndDocumentDate(Rec);

        if PreviewMode then begin
          ClearAll;
          PreviewMode := true;
        end else
          ClearAll;

        GetGLSetup;
        GetCurrency("Currency Code");

        PurchSetup.Get;
        PurchHeader := Rec;
        FillTempLines(PurchHeader);

        // Header
        CheckAndUpdate(PurchHeader);

        TempDeferralHeader.DeleteAll;
        TempDeferralLine.DeleteAll;
        TempInvoicePostBuffer.DeleteAll;
        TempDropShptPostBuffer.DeleteAll;
        EverythingInvoiced := true;

        // Lines
        PurchLine.Reset;
        PurchLine.SetRange("Document Type",PurchHeader."Document Type");
        PurchLine.SetRange("Document No.",PurchHeader."No.");

        LineCount := 0;
        RoundingLineInserted := false;
        MergePurchLines(PurchHeader,PurchLine,TempPrepmtPurchLine,TempCombinedPurchLine);
        AdjustFinalInvWith100PctPrepmt(TempCombinedPurchLine);

        SetTaxType(PurchHeader,PurchLine);

        if TaxOption = Taxoption::SalesTax then begin
          if "Tax Area Code" <> '' then begin
            if UseExternalTaxEngine then
              SalesTaxCalculate.CallExternalTaxEngineForPurch(PurchHeader,false)
            else
              SalesTaxCalculate.EndSalesTaxCalculation("Posting Date");
            SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxAmtLine);
            SalesTaxCalculate.DistTaxOverPurchLines(TempPurchLineForSalesTax);
            RemSalesTaxAmt := 0;
            RemSalesTaxAmtACY := 0;
            CalcProvincialSalesTax(PurchHeader);
          end;
        end else begin
          TempVATAmountLineRemainder.DeleteAll;
          PurchLine.CalcVATAmountLines(1,PurchHeader,TempCombinedPurchLine,TempVATAmountLine);
        end;

        PurchaseLinesProcessed := false;
        if PurchLine.FindFirst then
          repeat
            ItemJnlRollRndg := false;
            LineCount := LineCount + 1;
            if GuiAllowed then
              Window.Update(2,LineCount);

            PostPurchLine(
              PurchHeader,PurchLine,TempInvoicePostBuffer,TempVATAmountLine,TempVATAmountLineRemainder,
              TempDropShptPostBuffer,EverythingInvoiced,ICGenJnlLineNo);

            if not JobItem then
              JobItem := (PurchLine.Type = PurchLine.Type::Item) and (PurchLine."Job No." <> '');

            if RoundingLineInserted then
              LastLineRetrieved := true
            else begin
              BiggestLineNo := MAX(BiggestLineNo,PurchLine."Line No.");
              LastLineRetrieved := GetNextPurchline(PurchLine);
              if LastLineRetrieved and PurchSetup."Invoice Rounding" then
                InvoiceRounding(PurchHeader,PurchLine,false,BiggestLineNo);
            end;
          until LastLineRetrieved;

        if PurchHeader.IsCreditDocType then begin
          ReverseAmount(TotalPurchLine);
          ReverseAmount(TotalPurchLineLCY);
        end;

        // Post combine shipment of sales order
        PostCombineSalesOrderShipment(PurchHeader,TempDropShptPostBuffer);

        if PurchHeader.Invoice then
          PostGLAndVendor(PurchHeader,PurchLine,TempInvoicePostBuffer,LineCount);

        if ICGenJnlLineNo > 0 then
          PostICGenJnl;

        if PreviewMode then begin
          Window.Close;
          GenJnlPostPreview.ThrowError;
        end;

        MakeInventoryAdjustment(JobItem);
        UpdateLastPostingNos(PurchHeader);
        FinalizePosting(PurchHeader,TempDropShptPostBuffer,EverythingInvoiced);

        Rec := PurchHeader;

        if not InvtPickPutaway then begin
          Commit;
          UpdateAnalysisView.UpdateAll(0,true);
          UpdateItemAnalysisView.UpdateAll(0,true);
        end;

        OnAfterPostPurchaseDoc(
          Rec,GenJnlPostLine,PurchRcptHeader."No.",ReturnShptHeader."No.",PurchInvHeader."No.",PurchCrMemoHeader."No.");
    end;

    var
        NothingToPostErr: label 'There is nothing to post.';
        DropShipmentErr: label 'A drop shipment from a purchase order cannot be received and invoiced at the same time.';
        PostingLinesMsg: label 'Posting lines              #2######\', Comment='Counter';
        PostingPurchasesAndVATMsg: label 'Posting purchases and tax  #3######\', Comment='Counter';
        PostingVendorsMsg: label 'Posting to vendors         #4######\', Comment='Counter';
        PostingBalAccountMsg: label 'Posting to bal. account    #5######', Comment='Counter';
        PostingLines2Msg: label 'Posting lines              #2######', Comment='Counter';
        InvoiceNoMsg: label '%1 %2 -> Invoice %3', Comment='%1 = Document Type, %2 = Document No, %3 = Invoice No.';
        CreditMemoNoMsg: label '%1 %2 -> Credit Memo %3', Comment='%1 = Document Type, %2 = Document No, %3 = Credit Memo No.';
        CannotInvoiceBeforeAssosSalesOrderErr: label 'You cannot invoice this purchase order before the associated sales orders have been invoiced. Please invoice sales order %1 before invoicing this purchase order.', Comment='%1 = Document No.';
        ReceiptSameSignErr: label 'must have the same sign as the receipt';
        ReceiptLinesDeletedErr: label 'Receipt lines have been deleted.';
        CannotPurchaseResourcesErr: label 'You cannot purchase resources.';
        PurchaseAlreadyExistsErr: label 'Purchase %1 %2 already exists for this vendor.', Comment='%1 = Document Type, %2 = Document No.';
        InvoiceMoreThanReceivedErr: label 'You cannot invoice order %1 for more than you have received.', Comment='%1 = Order No.';
        CannotPostBeforeAssosSalesOrderErr: label 'You cannot post this purchase order before the associated sales orders have been invoiced. Post sales order %1 before posting this purchase order.', Comment='%1 = Sales Order No.';
        VATAmountTxt: label 'Tax Amount';
        VATRateTxt: label '%1% Tax', Comment='%1 = VAT Rate';
        BlanketOrderQuantityGreaterThanErr: label 'in the associated blanket order must not be greater than %1', Comment='%1 = Quantity';
        BlanketOrderQuantityReducedErr: label 'in the associated blanket order must be reduced';
        ReceiveInvoiceShipErr: label 'Please enter "Yes" in Receive and/or Invoice and/or Ship.';
        WarehouseRequiredErr: label 'Warehouse handling is required for %1 = %2, %3 = %4, %5 = %6.', Comment='%1/%2 = Document Type, %3/%4 - Document No.,%5/%6 = Line No.';
        ReturnShipmentSamesSignErr: label 'must have the same sign as the return shipment';
        ReturnShipmentInvoicedErr: label 'Line %1 of the return shipment %2, which you are attempting to invoice, has already been invoiced.', Comment='%1 = Line No., %2 = Document No.';
        ReceiptInvoicedErr: label 'Line %1 of the receipt %2, which you are attempting to invoice, has already been invoiced.', Comment='%1 = Line No., %2 = Document No.';
        QuantityToInvoiceGreaterErr: label 'The quantity you are attempting to invoice is greater than the quantity in receipt %1.', Comment='%1 = Receipt No.';
        DimensionIsBlockedErr: label 'The combination of dimensions used in %1 %2 is blocked (Error: %3).', Comment='%1 = Document Type, %2 = Document No, %3 = Error text';
        LineDimensionBlockedErr: label 'The combination of dimensions used in %1 %2, line no. %3 is blocked (Error: %4).', Comment='%1 = Document Type, %2 = Document No, %3 = LineNo., %4 = Error text';
        InvalidDimensionsErr: label 'The dimensions used in %1 %2 are invalid (Error: %3).', Comment='%1 = Document Type, %2 = Document No, %3 = Error text';
        LineInvalidDimensionsErr: label 'The dimensions used in %1 %2, line no. %3 are invalid (Error: %4).', Comment='%1 = Document Type, %2 = Document No, %3 = LineNo., %4 = Error text';
        CannotAssignMoreErr: label 'You cannot assign more than %1 units in %2 = %3,%4 = %5,%6 = %7.', Comment='%1 = Quantity, %2/%3 = Document Type, %4/%5 - Document No.,%6/%7 = Line No.';
        MustAssignErr: label 'You must assign all item charges, if you invoice everything.';
        CannotAssignInvoicedErr: label 'You cannot assign item charges to the %1 %2 = %3,%4 = %5, %6 = %7, because it has been invoiced.', Comment='%1 = Purchase Line, %2/%3 = Document Type, %4/%5 - Document No.,%6/%7 = Line No.';
        PurchSetup: Record "Purchases & Payables Setup";
        GLSetup: Record "General Ledger Setup";
        GLEntry: Record "G/L Entry";
        TempPurchLineGlobal: Record "Purchase Line" temporary;
        JobPurchLine: Record "Purchase Line";
        TotalPurchLine: Record "Purchase Line";
        TotalPurchLineLCY: Record "Purchase Line";
        xPurchLine: Record "Purchase Line";
        PurchLineACY: Record "Purchase Line";
        TempPrepmtPurchLine: Record "Purchase Line" temporary;
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        ReturnShptHeader: Record "Return Shipment Header";
        ReturnShptLine: Record "Return Shipment Line";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesShptLine: Record "Sales Shipment Line";
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        TempItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)" temporary;
        SourceCodeSetup: Record "Source Code Setup";
        Currency: Record Currency;
        VendLedgEntry: Record "Vendor Ledger Entry";
        WhseRcptHeader: Record "Warehouse Receipt Header";
        TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary;
        WhseShptHeader: Record "Warehouse Shipment Header";
        TempWhseShptHeader: Record "Warehouse Shipment Header" temporary;
        PostedWhseRcptHeader: Record "Posted Whse. Receipt Header";
        PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        Location: Record Location;
        TempHandlingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecificationInv: Record "Tracking Specification" temporary;
        TempWhseSplitSpecification: Record "Tracking Specification" temporary;
        TempValueEntryRelation: Record "Value Entry Relation" temporary;
        TaxAmountDifference: Record UnknownRecord10012;
        Job: Record Job;
        TempICGenJnlLine: Record "Gen. Journal Line" temporary;
        TempPrepmtDeductLCYPurchLine: Record "Purchase Line" temporary;
        TempSKU: Record "Stockkeeping Unit" temporary;
        DeferralPostBuffer: array [2] of Record "Deferral Post. Buffer";
        TaxArea: Record "Tax Area";
        TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;
        TempPurchLineForSalesTax: Record "Purchase Line" temporary;
        TempPurchLineForSpread: Record "Purchase Line" temporary;
        TempProvSalesTaxAmtLine: Record UnknownRecord10011 temporary;
        TempDeferralHeader: Record "Deferral Header" temporary;
        TempDeferralLine: Record "Deferral Line" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WhsePurchRelease: Codeunit "Whse.-Purch. Release";
        SalesPost: Codeunit "Sales-Post";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        WhseJnlPostLine: Codeunit "Whse. Jnl.-Register Line";
        WhsePostRcpt: Codeunit "Whse.-Post Receipt";
        WhsePostShpt: Codeunit "Whse.-Post Shipment";
        CostCalcMgt: Codeunit "Cost Calculation Management";
        JobPostLine: Codeunit "Job Post-Line";
        ServItemMgt: Codeunit ServItemManagement;
        DeferralUtilities: Codeunit "Deferral Utilities";
        Window: Dialog;
        PostingDate: Date;
        Usedate: Date;
        GenJnlLineDocNo: Code[20];
        GenJnlLineExtDocNo: Code[35];
        SrcCode: Code[10];
        ItemLedgShptEntryNo: Integer;
        GenJnlLineDocType: Integer;
        FALineNo: Integer;
        RoundingLineNo: Integer;
        DeferralLineNo: Integer;
        InvDefLineNo: Integer;
        RemQtyToBeInvoiced: Decimal;
        RemQtyToBeInvoicedBase: Decimal;
        RemAmt: Decimal;
        RemDiscAmt: Decimal;
        LastLineRetrieved: Boolean;
        RoundingLineInserted: Boolean;
        DropShipOrder: Boolean;
        PostingDateExists: Boolean;
        ReplacePostingDate: Boolean;
        ReplaceDocumentDate: Boolean;
        TotalAmount1099: Decimal;
        GLSetupRead: Boolean;
        InvoiceGreaterThanReturnShipmentErr: label 'The quantity you are attempting to invoice is greater than the quantity in return shipment %1.', Comment='%1 = Return Shipment No.';
        ReturnShipmentLinesDeletedErr: label 'Return shipment lines have been deleted.';
        InvoiceMoreThanShippedErr: label 'You cannot invoice return order %1 for more than you have shipped.', Comment='%1 = Order No.';
        RelatedItemLedgEntriesNotFoundErr: label 'Related item ledger entries cannot be found.';
        ItemTrackingWrongSignErr: label 'Item Tracking is signed wrongly.';
        ItemTrackingMismatchErr: label 'Item Tracking does not match.';
        PostingDateNotAllowedErr: label 'is not within your range of allowed posting dates';
        ItemTrackQuantityMismatchErr: label 'The %1 does not match the quantity defined in item tracking.', Comment='%1 = Quantity';
        CannotBeGreaterThanErr: label 'cannot be more than %1.', Comment='%1 = Amount';
        CannotBeSmallerThanErr: label 'must be at least %1.', Comment='%1 = Amount';
        ItemJnlRollRndg: Boolean;
        SalesTaxCountry: Option US,CA,,,,,,,,,,,,NoTax;
        TaxOption: Option ,VAT,SalesTax;
        RemSalesTaxAmt: Decimal;
        RemSalesTaxAmtACY: Decimal;
        WhseReceive: Boolean;
        WhseShip: Boolean;
        InvtPickPutaway: Boolean;
        JobItem: Boolean;
        PositiveWhseEntrycreated: Boolean;
        PrepAmountToDeductToBigErr: label 'The total %1 cannot be more than %2.', Comment='%1 = Prepmt Amt to Deduct, %2 = Max Amount';
        PrepAmountToDeductToSmallErr: label 'The total %1 must be at least %2.', Comment='%1 = Prepmt Amt to Deduct, %2 = Max Amount';
        UnpostedInvoiceDuplicateQst: label 'An unposted invoice for order %1 exists. To avoid duplicate postings, delete order %1 or invoice %2.\Do you still want to post order %1?', Comment='%1 = Order No.,%2 = Invoice No.';
        InvoiceDuplicateInboxQst: label 'An invoice for order %1 exists in the IC inbox. To avoid duplicate postings, cancel invoice %2 in the IC inbox.\Do you still want to post order %1?', Comment='%1 = Order No.';
        PostedInvoiceDuplicateQst: label 'Posted invoice %1 already exists for order %2. To avoid duplicate postings, do not post order %2.\Do you still want to post order %2?', Comment='%1 = Invoice No., %2 = Order No.';
        OrderFromSameTransactionQst: label 'Order %1 originates from the same IC transaction as invoice %2. To avoid duplicate postings, delete order %1 or invoice %2.\Do you still want to post invoice %2?', Comment='%1 = Order No., %2 = Invoice No.';
        DocumentFromSameTransactionQst: label 'A document originating from the same IC transaction as document %1 exists in the IC inbox. To avoid duplicate postings, cancel document %2 in the IC inbox.\Do you still want to post document %1?', Comment='%1 and %2 = Document No.';
        PostedInvoiceFromSameTransactionQst: label 'Posted invoice %1 originates from the same IC transaction as invoice %2. To avoid duplicate postings, do not post invoice %2.\Do you still want to post invoice %2?', Comment='%1 and %2 = Invoice No.';
        MustAssignItemChargeErr: label 'You must assign item charge %1 if you want to invoice it.', Comment='%1 = Item Charge No.';
        CannotInvoiceItemChargeErr: label 'You can not invoice item charge %1 because there is no item ledger entry to assign it to.', Comment='%1 = Item Charge No.';
        PurchaseLinesProcessed: Boolean;
        ProvTaxToBeExpensed: Decimal;
        UseExternalTaxEngine: Boolean;
        ReservationDisruptedQst: label 'One or more reservation entries exist for the item with %1 = %2, %3 = %4, %5 = %6 which may be disrupted if you post this negative adjustment. Do you want to continue?', Comment='One or more reservation entries exist for the item with No. = 1000, Location Code = SILVER, Variant Code = NEW which may be disrupted if you post this negative adjustment. Do you want to continue?';
        ReassignItemChargeErr: label 'The order line that the item charge was originally assigned to has been fully posted. You must reassign the item charge to the posted receipt or shipment.';
        SalesTaxExists: Boolean;
        GenProdPostingGrDiscErr: label 'You must enter a value in %1 for %2 %3 if you want to post discounts for that line.';
        PreviewMode: Boolean;
        NoDeferralScheduleErr: label 'You must create a deferral schedule because you have specified the deferral code %2 in line %1.', Comment='%1=The item number of the sales transaction line, %2=The Deferral Template Code';
        ZeroDeferralAmtErr: label 'Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.', Comment='%1=The item number of the sales transaction line, %2=The Deferral Template Code';
        EveryLineMustHaveSameErr: label 'Every sales line must have same %1 = %2.';
        TaxAreaSetupShouldBeSameErr: label 'If sales document has Tax Area Code whose %1 is %2, then any line with a Tax Area Code must have one whose %1 is %2. ';

    local procedure CopyToTempLines(PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.SetRange("Document Type",PurchHeader."Document Type");
        PurchLine.SetRange("Document No.",PurchHeader."No.");
        if PurchLine.FindSet then
          repeat
            TempPurchLineGlobal := PurchLine;
            TempPurchLineGlobal.Insert;
          until PurchLine.Next = 0;
    end;

    local procedure FillTempLines(PurchHeader: Record "Purchase Header")
    begin
        TempPurchLineGlobal.Reset;
        if TempPurchLineGlobal.IsEmpty then
          CopyToTempLines(PurchHeader);
    end;

    local procedure ModifyTempLine(var TempPurchLineLocal: Record "Purchase Line" temporary)
    var
        PurchLine: Record "Purchase Line";
    begin
        TempPurchLineLocal.Modify;
        PurchLine := TempPurchLineLocal;
        PurchLine.Modify;
    end;

    local procedure RefreshTempLines(PurchHeader: Record "Purchase Header")
    begin
        TempPurchLineGlobal.Reset;
        TempPurchLineGlobal.DeleteAll;
        CopyToTempLines(PurchHeader);
    end;

    local procedure ResetTempLines(var TempPurchLineLocal: Record "Purchase Line" temporary)
    begin
        TempPurchLineLocal.Reset;
        TempPurchLineLocal.Copy(TempPurchLineGlobal,true);
    end;

    local procedure CalcInvoice(var PurchHeader: Record "Purchase Header") NewInvoice: Boolean
    var
        TempPurchLine: Record "Purchase Line" temporary;
    begin
        with PurchHeader do begin
          ResetTempLines(TempPurchLine);
          TempPurchLine.SetFilter(Quantity,'<>0');
          if "Document Type" in ["document type"::Order,"document type"::"Return Order"] then
            TempPurchLine.SetFilter("Qty. to Invoice",'<>0');
          NewInvoice := not TempPurchLine.IsEmpty;
          if NewInvoice then
            case "Document Type" of
              "document type"::Order:
                if not Receive then begin
                  TempPurchLine.SetFilter("Qty. Rcd. Not Invoiced",'<>0');
                  NewInvoice := not TempPurchLine.IsEmpty;
                end;
              "document type"::"Return Order":
                if not Ship then begin
                  TempPurchLine.SetFilter("Return Qty. Shipped Not Invd.",'<>0');
                  NewInvoice := not TempPurchLine.IsEmpty;
                end;
            end;
        end;
        exit(NewInvoice);
    end;

    local procedure CalcInvDiscount(var PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        TempInvoice: Boolean;
        TempRcpt: Boolean;
        TempReturn: Boolean;
    begin
        with PurchHeader do begin
          if not (PurchSetup."Calc. Inv. Discount" and (Status <> Status::Open)) then
            exit;

          PurchLine.Reset;
          PurchLine.SetRange("Document Type","Document Type");
          PurchLine.SetRange("Document No.","No.");
          PurchLine.FindFirst;
          TempInvoice := Invoice;
          TempRcpt := Receive;
          TempReturn := Ship;
          Codeunit.Run(Codeunit::"Purch.-Calc.Discount",PurchLine);
          Get("Document Type","No.");
          Invoice := TempInvoice;
          Receive := TempRcpt;
          Ship := TempReturn;
          if not PreviewMode then
            Commit;
        end;
    end;

    local procedure CheckAndUpdate(var PurchHeader: Record "Purchase Header")
    var
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        ModifyHeader: Boolean;
    begin
        with PurchHeader do begin
          // Check
          CheckMandatoryHeaderFields(PurchHeader);
          if GenJnlCheckLine.DateNotAllowed("Posting Date") then
            FieldError("Posting Date",PostingDateNotAllowedErr);

          if "Tax Area Code" = '' then
            SalesTaxCountry := Salestaxcountry::NoTax
          else begin
            TaxArea.Get("Tax Area Code");
            SalesTaxCountry := TaxArea."Country/Region";
            UseExternalTaxEngine := TaxArea."Use External Tax Engine";
          end;

          SetPostingFlags(PurchHeader);
          InitProgressWindow(PurchHeader);

          InvtPickPutaway := "Posting from Whse. Ref." <> 0;
          "Posting from Whse. Ref." := 0;

          CheckDim(PurchHeader);

          CheckPostRestrictions(PurchHeader);

          CheckICDocumentDuplicatePosting(PurchHeader);

          if Invoice then
            Invoice := CalcInvoice(PurchHeader);

          if Invoice then
            CopyAndCheckItemCharge(PurchHeader);

          if Invoice and not IsCreditDocType then
            TestField("Due Date");

          if Receive then
            Receive := CheckTrackingAndWarehouseForReceive(PurchHeader);

          if Ship then
            Ship := CheckTrackingAndWarehouseForShip(PurchHeader);

          if not (Receive or Invoice or Ship) then
            Error(NothingToPostErr);

          if Invoice then
            CheckAssosOrderLines(PurchHeader);

          if Invoice and PurchSetup."Ext. Doc. No. Mandatory" then
            if "Document Type" in ["document type"::Order,"document type"::Invoice] then
              TestField("Vendor Invoice No.")
            else
              TestField("Vendor Cr. Memo No.");

          // Update
          if Invoice then
            CreatePrepmtLines(PurchHeader,TempPrepmtPurchLine,true);

          ModifyHeader := UpdatePostingNos(PurchHeader);

          DropShipOrder := UpdateAssosOrderPostingNos(PurchHeader);

          OnBeforePostCommitPurchaseDoc(PurchHeader,GenJnlPostLine,PreviewMode,ModifyHeader);
          if not PreviewMode and ModifyHeader then begin
            Modify;
            Commit;
          end;

          CalcInvDiscount(PurchHeader);
          ReleasePurchDocument(PurchHeader);

          if Receive or Ship then
            ArchiveUnpostedOrder(PurchHeader);

          CheckICPartnerBlocked(PurchHeader);
          SendICDocument(PurchHeader,ModifyHeader);
          UpdateHandledICInboxTransaction(PurchHeader);

          LockTables;

          SourceCodeSetup.Get;
          SrcCode := SourceCodeSetup.Purchases;

          InsertPostedHeaders(PurchHeader);

          UpdateIncomingDocument("Incoming Document Entry No.","Posting Date",GenJnlLineDocNo);
        end;
    end;


    procedure SetPostingDate(NewReplacePostingDate: Boolean;NewReplaceDocumentDate: Boolean;NewPostingDate: Date)
    begin
        PostingDateExists := true;
        ReplacePostingDate := NewReplacePostingDate;
        ReplaceDocumentDate := NewReplaceDocumentDate;
        PostingDate := NewPostingDate;
    end;

    local procedure PostPurchLine(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line";var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;var TempVATAmountLine: Record "VAT Amount Line" temporary;var TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;var TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary;var EverythingInvoiced: Boolean;var ICGenJnlLineNo: Integer)
    var
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        InvoicePostBuffer: Record "Invoice Post. Buffer";
        CostBaseAmount: Decimal;
    begin
        with PurchLine do begin
          if Type = Type::Item then
            CostBaseAmount := "Line Amount";
          UpdateQtyPerUnitOfMeasure(PurchLine);

          TestPurchLine(PurchHeader,PurchLine);
          UpdatePurchLineBeforePost(PurchHeader,PurchLine);

          if "Qty. to Invoice" + "Quantity Invoiced" <> Quantity then
            EverythingInvoiced := false;

          if Quantity <> 0 then begin
            TestField("No.");
            TestField(Type);
            if GLSetup."VAT in Use" then begin
              TestField("Gen. Bus. Posting Group");
              TestField("Gen. Prod. Posting Group");
            end;
            DivideAmount(PurchHeader,PurchLine,1,"Qty. to Invoice",TempVATAmountLine,TempVATAmountLineRemainder);
          end else
            TestField(Amount,0);

          if (PurchLine."Prepayment Line") and (PurchHeader."Prepmt. Include Tax") then begin
            PurchLine.Amount := PurchLine.Amount + (PurchLine."VAT Base Amount" * PurchLine."VAT %" / 100);
            PurchLine."Amount Including VAT" := PurchLine.Amount;
          end;

          CheckItemReservDisruption(PurchLine);
          RoundAmount(PurchHeader,PurchLine,"Qty. to Invoice");

          if IsCreditDocType then begin
            ReverseAmount(PurchLine);
            ReverseAmount(PurchLineACY);
            if TaxOption = Taxoption::SalesTax then
              if TempPurchLineForSalesTax.Get(PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.") then begin
                ReverseAmount(TempPurchLineForSalesTax);
                TempPurchLineForSalesTax.Modify;
              end;
          end;

          if PurchLine."IRS 1099 Liable" then
            if "Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"] then
              TotalAmount1099 :=
                TotalAmount1099 - (xPurchLine."Amount Including VAT" - TempPrepmtPurchLine."Amount Including VAT")
            else
              TotalAmount1099 :=
                TotalAmount1099 + (xPurchLine."Amount Including VAT" + TempPrepmtPurchLine."Amount Including VAT");

          RemQtyToBeInvoiced := "Qty. to Invoice";
          RemQtyToBeInvoicedBase := "Qty. to Invoice (Base)";

          // Job Credit Memo Item Qty Check
          if IsCreditDocType then
            if ("Job No." <> '') and (Type = Type::Item) and ("Qty. to Invoice" <> 0) then
              JobPostLine.CheckItemQuantityPurchCredit(PurchHeader,PurchLine);

          PostItemTrackingLine(PurchHeader,PurchLine);

          case Type of
            Type::"G/L Account":
              PostGLAccICLine(PurchHeader,PurchLine,ICGenJnlLineNo);
            Type::Item:
              PostItemLine(PurchHeader,PurchLine,TempDropShptPostBuffer);
            3:
              Error(CannotPurchaseResourcesErr);
            Type::"Charge (Item)":
              PostItemChargeLine(PurchHeader,PurchLine);
          end;

          if (Type >= Type::"G/L Account") and ("Qty. to Invoice" <> 0) then begin
            AdjustPrepmtAmountLCY(PurchHeader,PurchLine);
            FillInvoicePostBuffer(PurchHeader,PurchLine,PurchLineACY,TempInvoicePostBuffer,InvoicePostBuffer);
            InsertPrepmtAdjInvPostingBuf(PurchHeader,PurchLine,TempInvoicePostBuffer,InvoicePostBuffer);
          end;

          if (PurchRcptHeader."No." <> '') and ("Receipt No." = '') and
             not RoundingLineInserted and not "Prepayment Line"
          then
            InsertReceiptLine(PurchRcptHeader,PurchLine,CostBaseAmount);

          if (ReturnShptHeader."No." <> '') and ("Return Shipment No." = '') and
             not RoundingLineInserted
          then
            InsertReturnShipmentLine(ReturnShptHeader,PurchLine,CostBaseAmount);

          if PurchHeader.Invoice then
            if "Document Type" in ["document type"::Order,"document type"::Invoice] then begin
              PurchInvLine.InitFromPurchLine(PurchInvHeader,xPurchLine);
              ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,CopyStr(PurchInvLine.RowID1,1,100));
              PurchInvLine.Insert(true);
              CreatePostedDeferralScheduleFromPurchDoc(xPurchLine,PurchInvLine.GetDocumentType,
                PurchInvHeader."No.",PurchInvLine."Line No.",PurchInvHeader."Posting Date");
            end else begin // Credit Memo
              PurchCrMemoLine.InitFromPurchLine(PurchCrMemoHeader,xPurchLine);
              ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,CopyStr(PurchCrMemoLine.RowID1,1,100));
              PurchCrMemoLine.Insert(true);
              CreatePostedDeferralScheduleFromPurchDoc(xPurchLine,PurchCrMemoLine.GetDocumentType,
                PurchCrMemoHeader."No.",PurchCrMemoLine."Line No.",PurchCrMemoHeader."Posting Date");
            end;
        end;
    end;

    local procedure PostGLAndVendor(var PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;LineCount: Integer)
    var
        TotalUseTaxAmount: Decimal;
    begin
        with PurchHeader do begin
          // Post purchase and VAT to G/L entries from buffer
          PostInvoicePostingBuffer(PurchHeader,PurchLine,TempInvoicePostBuffer);

          if TaxOption = Taxoption::SalesTax then begin
            if PurchHeader."Tax Area Code" <> '' then begin
              PostSalesTaxToGL(PurchHeader,PurchLine,LineCount,TotalUseTaxAmount);
              if PurchHeader.Invoice then
                TaxAmountDifference.ClearDocDifference(TaxAmountDifference."document product area"::Purchase,"Document Type","No.");
              PostProvincialSalesTaxToGL(PurchHeader,TotalUseTaxAmount);
              if (PurchHeader."Currency Code" <> '') and (TotalPurchLineLCY."Tax To Be Expensed" <> 0) then
                TotalPurchLineLCY."Amount Including VAT" += TotalPurchLineLCY."Tax To Be Expensed" - TotalUseTaxAmount;
            end;
          end;

          // Check External Document number
          if PurchSetup."Ext. Doc. No. Mandatory" or (GenJnlLineExtDocNo <> '') then
            CheckExternalDocumentNumber(VendLedgEntry,PurchHeader);

          // Post vendor entries
          if GuiAllowed then
            Window.Update(4,1);
          PostVendorEntry(
            PurchHeader,TotalPurchLine,TotalPurchLineLCY,GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);

          UpdatePurchaseHeader(VendLedgEntry);

          // Balancing account
          if "Bal. Account No." <> '' then begin
            if GuiAllowed then
              Window.Update(5,1);
            PostBalancingEntry(
              PurchHeader,TotalPurchLine,TotalPurchLineLCY,GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);
          end;
        end;
    end;

    local procedure PostGLAccICLine(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";var ICGenJnlLineNo: Integer)
    var
        GLAcc: Record "G/L Account";
    begin
        if (PurchLine."No." <> '') and not PurchLine."System-Created Entry" then begin
          GLAcc.Get(PurchLine."No.");
          GLAcc.TestField("Direct Posting");
          if (PurchLine."Job No." <> '') and (PurchLine."Qty. to Invoice" <> 0) then begin
            CreateJobPurchLine(JobPurchLine,PurchLine,PurchHeader."Prices Including VAT");
            JobPostLine.PostJobOnPurchaseLine(PurchHeader,PurchInvHeader,PurchCrMemoHeader,JobPurchLine,SrcCode);
          end;
          if (PurchLine."IC Partner Code" <> '') and PurchHeader.Invoice then
            InsertICGenJnlLine(PurchHeader,xPurchLine,ICGenJnlLineNo);
        end;
    end;

    local procedure PostItemLine(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line";var TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary)
    var
        DummyTrackingSpecification: Record "Tracking Specification";
    begin
        with PurchHeader do begin
          if RemQtyToBeInvoiced <> 0 then
            ItemLedgShptEntryNo :=
              PostItemJnlLine(
                PurchHeader,PurchLine,
                RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
                RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
                0,'',DummyTrackingSpecification);
          if IsCreditDocType then begin
            if Abs(PurchLine."Return Qty. to Ship") > Abs(RemQtyToBeInvoiced) then
              ItemLedgShptEntryNo :=
                PostItemJnlLine(
                  PurchHeader,PurchLine,
                  PurchLine."Return Qty. to Ship" - RemQtyToBeInvoiced,
                  PurchLine."Return Qty. to Ship (Base)" - RemQtyToBeInvoicedBase,
                  0,0,0,'',DummyTrackingSpecification);
          end else begin
            if Abs(PurchLine."Qty. to Receive") > Abs(RemQtyToBeInvoiced) then
              ItemLedgShptEntryNo :=
                PostItemJnlLine(
                  PurchHeader,PurchLine,
                  PurchLine."Qty. to Receive" - RemQtyToBeInvoiced,
                  PurchLine."Qty. to Receive (Base)" - RemQtyToBeInvoicedBase,
                  0,0,0,'',DummyTrackingSpecification);
            if (PurchLine."Qty. to Receive" <> 0) and (PurchLine."Sales Order Line No." <> 0) then begin
              TempDropShptPostBuffer."Order No." := PurchLine."Sales Order No.";
              TempDropShptPostBuffer."Order Line No." := PurchLine."Sales Order Line No.";
              TempDropShptPostBuffer.Quantity := PurchLine."Qty. to Receive";
              TempDropShptPostBuffer."Quantity (Base)" := PurchLine."Qty. to Receive (Base)";
              TempDropShptPostBuffer."Item Shpt. Entry No." :=
                PostAssocItemJnlLine(PurchHeader,PurchLine,TempDropShptPostBuffer.Quantity,TempDropShptPostBuffer."Quantity (Base)");
              TempDropShptPostBuffer.Insert;
            end;
          end;
        end;
    end;

    local procedure PostItemChargeLine(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line")
    var
        PurchaseLineBackup: Record "Purchase Line";
    begin
        if not (PurchHeader.Invoice and (PurchLine."Qty. to Invoice" <> 0)) then
          exit;

        ItemJnlRollRndg := true;
        PurchaseLineBackup.Copy(PurchLine);
        if FindTempItemChargeAssgntPurch(PurchaseLineBackup."Line No.") then
          repeat
            case TempItemChargeAssgntPurch."Applies-to Doc. Type" of
              TempItemChargeAssgntPurch."applies-to doc. type"::Receipt:
                begin
                  PostItemChargePerRcpt(PurchHeader,PurchaseLineBackup);
                  TempItemChargeAssgntPurch.Mark(true);
                end;
              TempItemChargeAssgntPurch."applies-to doc. type"::"Transfer Receipt":
                begin
                  PostItemChargePerTransfer(PurchHeader,PurchaseLineBackup);
                  TempItemChargeAssgntPurch.Mark(true);
                end;
              TempItemChargeAssgntPurch."applies-to doc. type"::"Return Shipment":
                begin
                  PostItemChargePerRetShpt(PurchHeader,PurchaseLineBackup);
                  TempItemChargeAssgntPurch.Mark(true);
                end;
              TempItemChargeAssgntPurch."applies-to doc. type"::"Sales Shipment":
                begin
                  PostItemChargePerSalesShpt(PurchHeader,PurchaseLineBackup);
                  TempItemChargeAssgntPurch.Mark(true);
                end;
              TempItemChargeAssgntPurch."applies-to doc. type"::"Return Receipt":
                begin
                  PostItemChargePerRetRcpt(PurchHeader,PurchaseLineBackup);
                  TempItemChargeAssgntPurch.Mark(true);
                end;
              TempItemChargeAssgntPurch."applies-to doc. type"::Order,
              TempItemChargeAssgntPurch."applies-to doc. type"::Invoice,
              TempItemChargeAssgntPurch."applies-to doc. type"::"Return Order",
              TempItemChargeAssgntPurch."applies-to doc. type"::"Credit Memo":
                CheckItemCharge(TempItemChargeAssgntPurch);
            end;
          until TempItemChargeAssgntPurch.Next = 0;
    end;

    local procedure PostItemTrackingLine(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line")
    var
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        TrackingSpecificationExists: Boolean;
    begin
        if PurchLine."Prepayment Line" then
          exit;

        if PurchHeader.Invoice then
          if PurchLine."Qty. to Invoice" = 0 then
            TrackingSpecificationExists := false
          else
            TrackingSpecificationExists :=
              ReservePurchLine.RetrieveInvoiceSpecification(PurchLine,TempTrackingSpecification);

        PostItemTracking(PurchHeader,PurchLine,TempTrackingSpecification,TrackingSpecificationExists);

        if TrackingSpecificationExists then
          SaveInvoiceSpecification(TempTrackingSpecification);
    end;

    local procedure PostItemJnlLine(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";QtyToBeReceived: Decimal;QtyToBeReceivedBase: Decimal;QtyToBeInvoiced: Decimal;QtyToBeInvoicedBase: Decimal;ItemLedgShptEntryNo: Integer;ItemChargeNo: Code[20];TrackingSpecification: Record "Tracking Specification"): Integer
    var
        ItemJnlLine: Record "Item Journal Line";
        OriginalItemJnlLine: Record "Item Journal Line";
        TempWhseJnlLine: Record "Warehouse Journal Line" temporary;
        TempWhseTrackingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecificationChargeAssmt: Record "Tracking Specification" temporary;
        CurrExchRate: Record "Currency Exchange Rate";
        TempReservationEntry: Record "Reservation Entry" temporary;
        Factor: Decimal;
        PostWhseJnlLine: Boolean;
        CheckApplToItemEntry: Boolean;
        PostJobConsumptionBeforePurch: Boolean;
        TotalSalesTaxToExpense: Decimal;
    begin
        if not ItemJnlRollRndg then begin
          RemAmt := 0;
          RemDiscAmt := 0;
        end;
        with ItemJnlLine do begin
          Init;
          CopyFromPurchHeader(PurchHeader);
          CopyFromPurchLine(PurchLine);

          if QtyToBeReceived = 0 then
            if PurchLine.IsCreditDocType then
              CopyDocumentFields(
                "document type"::"Purchase Credit Memo",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PurchHeader."Posting No. Series")
            else
              CopyDocumentFields(
                "document type"::"Purchase Invoice",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PurchHeader."Posting No. Series")
          else begin
            if PurchLine.IsCreditDocType then
              CopyDocumentFields(
                "document type"::"Purchase Return Shipment",
                ReturnShptHeader."No.",ReturnShptHeader."Vendor Authorization No.",SrcCode,ReturnShptHeader."No. Series")
            else
              CopyDocumentFields(
                "document type"::"Purchase Receipt",
                PurchRcptHeader."No.",PurchRcptHeader."Vendor Shipment No.",SrcCode,PurchRcptHeader."No. Series");
            if QtyToBeInvoiced <> 0 then begin
              if "Document No." = '' then
                if PurchLine."Document Type" = PurchLine."document type"::"Credit Memo" then
                  CopyDocumentFields(
                    "document type"::"Purchase Credit Memo",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PurchHeader."Posting No. Series")
                else
                  CopyDocumentFields(
                    "document type"::"Purchase Invoice",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PurchHeader."Posting No. Series");
            end;
          end;

          if QtyToBeInvoiced <> 0 then
            "Invoice No." := GenJnlLineDocNo;

          "Serial No." := TrackingSpecification."Serial No.";
          "Lot No." := TrackingSpecification."Lot No.";
          "Item Shpt. Entry No." := ItemLedgShptEntryNo;

          Quantity := QtyToBeReceived;
          "Quantity (Base)" := QtyToBeReceivedBase;
          "Invoiced Quantity" := QtyToBeInvoiced;
          "Invoiced Qty. (Base)" := QtyToBeInvoicedBase;

          if ItemChargeNo <> '' then begin
            "Item Charge No." := ItemChargeNo;
            PurchLine."Qty. to Invoice" := QtyToBeInvoiced;
          end;

          if QtyToBeInvoiced <> 0 then begin
            if (QtyToBeInvoicedBase <> 0) and (PurchLine.Type = PurchLine.Type::Item)then
              Factor := QtyToBeInvoicedBase / PurchLine."Qty. to Invoice (Base)"
            else
              Factor := QtyToBeInvoiced / PurchLine."Qty. to Invoice";
            if TaxOption = Taxoption::SalesTax then
              TotalSalesTaxToExpense := PurchLine."Tax To Be Expensed"
            else
              TotalSalesTaxToExpense := 0;
            Amount := (PurchLine.Amount + TotalSalesTaxToExpense) * Factor + RemAmt;
            if PurchHeader."Prices Including VAT" then
              "Discount Amount" :=
                (PurchLine."Line Discount Amount" + PurchLine."Inv. Discount Amount") /
                (1 + PurchLine."VAT %" / 100) * Factor + RemDiscAmt
            else
              "Discount Amount" :=
                (PurchLine."Line Discount Amount" + PurchLine."Inv. Discount Amount") * Factor + RemDiscAmt;
            RemAmt := Amount - ROUND(Amount);
            RemDiscAmt := "Discount Amount" - ROUND("Discount Amount");
            Amount := ROUND(Amount);
            "Discount Amount" := ROUND("Discount Amount");
          end else begin
            if PurchHeader."Prices Including VAT" then
              Amount :=
                (QtyToBeReceived * PurchLine."Direct Unit Cost" * (1 - PurchLine."Line Discount %" / 100) /
                 (1 + PurchLine."VAT %" / 100)) + RemAmt
            else
              Amount :=
                (QtyToBeReceived * PurchLine."Direct Unit Cost" * (1 - PurchLine."Line Discount %" / 100)) + RemAmt;
            RemAmt := Amount - ROUND(Amount);
            if PurchHeader."Currency Code" <> '' then
              Amount :=
                ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    PurchHeader."Posting Date",PurchHeader."Currency Code",
                    Amount,PurchHeader."Currency Factor"))
            else
              Amount := ROUND(Amount);
          end;

          if PurchLine."Prod. Order No." <> '' then
            PostItemJnlLineCopyProdOrder(PurchLine,ItemJnlLine,QtyToBeReceived,QtyToBeInvoiced);

          CheckApplToItemEntry := SetCheckApplToItemEntry(PurchLine);

          PostWhseJnlLine := ShouldPostWhseJnlLine(PurchLine,ItemJnlLine,TempWhseJnlLine);

          if QtyToBeReceivedBase <> 0 then begin
            if PurchLine.IsCreditDocType then
              ReservePurchLine.TransferPurchLineToItemJnlLine(
                PurchLine,ItemJnlLine,-QtyToBeReceivedBase,CheckApplToItemEntry)
            else
              ReservePurchLine.TransferPurchLineToItemJnlLine(
                PurchLine,ItemJnlLine,QtyToBeReceivedBase,CheckApplToItemEntry);

            if CheckApplToItemEntry and (not PurchLine.IsServiceItem) then
              PurchLine.TestField("Appl.-to Item Entry");
          end;

          CollectPurchaseLineReservEntries(TempReservationEntry,ItemJnlLine);
          OriginalItemJnlLine := ItemJnlLine;

          if PurchLine."Job No." <> '' then begin
            PostJobConsumptionBeforePurch := IsPurchaseReturn;
            if PostJobConsumptionBeforePurch then
              PostItemJnlLineJobConsumption(
                PurchHeader,PurchLine,OriginalItemJnlLine,TempReservationEntry,QtyToBeInvoiced,QtyToBeReceived);
          end;

          ItemJnlPostLine.RunWithCheck(ItemJnlLine);

          if not Subcontracting then
            PostItemJnlLineTracking(
              PurchLine,TempWhseTrackingSpecification,TempTrackingSpecificationChargeAssmt,PostWhseJnlLine,QtyToBeInvoiced);

          if PurchLine."Job No." <> '' then
            if not PostJobConsumptionBeforePurch then
              PostItemJnlLineJobConsumption(
                PurchHeader,PurchLine,OriginalItemJnlLine,TempReservationEntry,QtyToBeInvoiced,QtyToBeReceived);

          if PostWhseJnlLine then
            PostItemJnlLineWhseLine(TempWhseJnlLine,TempWhseTrackingSpecification,PurchLine,PostJobConsumptionBeforePurch);

          if (PurchLine.Type = PurchLine.Type::Item) and PurchHeader.Invoice then
            PostItemJnlLineItemCharges(
              PurchHeader,PurchLine,OriginalItemJnlLine,"Item Shpt. Entry No.",TempTrackingSpecificationChargeAssmt);
        end;

        exit(ItemJnlLine."Item Shpt. Entry No.");
    end;

    local procedure PostItemJnlLineCopyProdOrder(PurchLine: Record "Purchase Line";var ItemJnlLine: Record "Item Journal Line";QtyToBeReceived: Decimal;QtyToBeInvoiced: Decimal)
    begin
        with PurchLine do begin
          ItemJnlLine.Subcontracting := true;
          ItemJnlLine."Quantity (Base)" := CalcBaseQty("No.","Unit of Measure Code",QtyToBeReceived);
          ItemJnlLine."Invoiced Qty. (Base)" := CalcBaseQty("No.","Unit of Measure Code",QtyToBeInvoiced);
          ItemJnlLine."Unit Cost" := "Unit Cost (LCY)";
          ItemJnlLine."Unit Cost (ACY)" := "Unit Cost";
          ItemJnlLine."Output Quantity (Base)" := ItemJnlLine."Quantity (Base)";
          ItemJnlLine."Output Quantity" := QtyToBeReceived;
          ItemJnlLine."Entry Type" := ItemJnlLine."entry type"::Output;
          ItemJnlLine.Type := ItemJnlLine.Type::"Work Center";
          ItemJnlLine."No." := "Work Center No.";
          ItemJnlLine."Routing No." := "Routing No.";
          ItemJnlLine."Routing Reference No." := "Routing Reference No.";
          ItemJnlLine."Operation No." := "Operation No.";
          ItemJnlLine."Work Center No." := "Work Center No.";
          ItemJnlLine."Unit Cost Calculation" := ItemJnlLine."unit cost calculation"::Units;
          if Finished then
            ItemJnlLine.Finished := Finished;
        end;
    end;

    local procedure PostItemJnlLineItemCharges(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";var OriginalItemJnlLine: Record "Item Journal Line";ItemShptEntryNo: Integer;var TempTrackingSpecificationChargeAssmt: Record "Tracking Specification" temporary)
    var
        ItemChargePurchLine: Record "Purchase Line";
    begin
        with PurchLine do begin
          ClearItemChargeAssgntFilter;
          TempItemChargeAssgntPurch.SetCurrentkey(
            "Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
          TempItemChargeAssgntPurch.SetRange("Applies-to Doc. Type","Document Type");
          TempItemChargeAssgntPurch.SetRange("Applies-to Doc. No.","Document No.");
          TempItemChargeAssgntPurch.SetRange("Applies-to Doc. Line No.","Line No.");
          if TempItemChargeAssgntPurch.Find('-') then
            repeat
              TestField("Allow Item Charge Assignment");
              GetItemChargeLine(PurchHeader,ItemChargePurchLine);
              ItemChargePurchLine.CalcFields("Qty. Assigned");
              if (ItemChargePurchLine."Qty. to Invoice" <> 0) or
                 (Abs(ItemChargePurchLine."Qty. Assigned") < Abs(ItemChargePurchLine."Quantity Invoiced"))
              then begin
                OriginalItemJnlLine."Item Shpt. Entry No." := ItemShptEntryNo;
                PostItemChargePerOrder(
                  PurchHeader,PurchLine,OriginalItemJnlLine,ItemChargePurchLine,TempTrackingSpecificationChargeAssmt);
                TempItemChargeAssgntPurch.Mark(true);
              end;
            until TempItemChargeAssgntPurch.Next = 0;
        end;
    end;

    local procedure PostItemJnlLineTracking(PurchLine: Record "Purchase Line";var TempWhseTrackingSpecification: Record "Tracking Specification" temporary;var TempTrackingSpecificationChargeAssmt: Record "Tracking Specification" temporary;PostWhseJnlLine: Boolean;QtyToBeInvoiced: Decimal)
    begin
        if ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification) then
          if TempHandlingSpecification.Find('-') then
            repeat
              TempTrackingSpecification := TempHandlingSpecification;
              TempTrackingSpecification.SetSourceFromPurchLine(PurchLine);
              if TempTrackingSpecification.Insert then;
              if QtyToBeInvoiced <> 0 then begin
                TempTrackingSpecificationInv := TempTrackingSpecification;
                if TempTrackingSpecificationInv.Insert then;
              end;
              if PostWhseJnlLine then begin
                TempWhseTrackingSpecification := TempTrackingSpecification;
                if TempWhseTrackingSpecification.Insert then;
              end;
              TempTrackingSpecificationChargeAssmt := TempTrackingSpecification;
              TempTrackingSpecificationChargeAssmt.Insert;
            until TempHandlingSpecification.Next = 0;
    end;

    local procedure PostItemJnlLineWhseLine(var TempWhseJnlLine: Record "Warehouse Journal Line" temporary;var TempWhseTrackingSpecification: Record "Tracking Specification" temporary;PurchLine: Record "Purchase Line";PostBefore: Boolean)
    var
        TempWhseJnlLine2: Record "Warehouse Journal Line" temporary;
    begin
        ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine,TempWhseJnlLine2,TempWhseTrackingSpecification,false);
        if TempWhseJnlLine2.Find('-') then
          repeat
            if PurchLine.IsCreditDocType and (PurchLine.Quantity > 0) or
               PurchLine.IsInvoiceDocType and (PurchLine.Quantity < 0)
            then
              CreatePositiveEntry(TempWhseJnlLine2,PurchLine."Job No.",PostBefore);
            WhseJnlPostLine.Run(TempWhseJnlLine2);
            if RevertWarehouseEntry(TempWhseJnlLine2,PurchLine."Job No.",PostBefore) then
              WhseJnlPostLine.Run(TempWhseJnlLine2);
          until TempWhseJnlLine2.Next = 0;
        TempWhseTrackingSpecification.DeleteAll;
    end;

    local procedure ShouldPostWhseJnlLine(PurchLine: Record "Purchase Line";var ItemJnlLine: Record "Item Journal Line";var TempWhseJnlLine: Record "Warehouse Journal Line" temporary): Boolean
    begin
        with PurchLine do
          if ("Location Code" <> '') and (Type = Type::Item) and (ItemJnlLine.Quantity <> 0) and
             not ItemJnlLine.Subcontracting
          then begin
            GetLocation("Location Code");
            if (("Document Type" in ["document type"::Invoice,"document type"::"Credit Memo"]) and
                Location."Directed Put-away and Pick") or
               (Location."Bin Mandatory" and not (WhseReceive or WhseShip or InvtPickPutaway or "Drop Shipment"))
            then begin
              CreateWhseJnlLine(ItemJnlLine,PurchLine,TempWhseJnlLine);
              exit(true);
            end;
          end;
    end;

    local procedure PostItemChargePerOrder(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";ItemJnlLine2: Record "Item Journal Line";ItemChargePurchLine: Record "Purchase Line";var TempTrackingSpecificationChargeAssmt: Record "Tracking Specification" temporary)
    var
        NonDistrItemJnlLine: Record "Item Journal Line";
        CurrExchRate: Record "Currency Exchange Rate";
        OriginalAmt: Decimal;
        OriginalAmtACY: Decimal;
        OriginalDiscountAmt: Decimal;
        OriginalQty: Decimal;
        QtyToInvoice: Decimal;
        Factor: Decimal;
        TotalChargeAmt2: Decimal;
        TotalChargeAmtLCY2: Decimal;
        SignFactor: Integer;
    begin
        with TempItemChargeAssgntPurch do begin
          PurchLine.TestField("Allow Item Charge Assignment",true);
          ItemJnlLine2."Document No." := GenJnlLineDocNo;
          ItemJnlLine2."External Document No." := GenJnlLineExtDocNo;
          ItemJnlLine2."Item Charge No." := "Item Charge No.";
          ItemJnlLine2.Description := ItemChargePurchLine.Description;
          ItemJnlLine2."Document Line No." := ItemChargePurchLine."Line No.";
          ItemJnlLine2."Unit of Measure Code" := '';
          ItemJnlLine2."Qty. per Unit of Measure" := 1;
          if "Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"] then
            QtyToInvoice :=
              CalcQtyToInvoice(PurchLine."Return Qty. to Ship (Base)",PurchLine."Qty. to Invoice (Base)")
          else
            QtyToInvoice :=
              CalcQtyToInvoice(PurchLine."Qty. to Receive (Base)",PurchLine."Qty. to Invoice (Base)");
          if ItemJnlLine2."Invoiced Quantity" = 0 then begin
            ItemJnlLine2."Invoiced Quantity" := ItemJnlLine2.Quantity;
            ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
          end;
          ItemJnlLine2.Amount := "Amount to Assign" * ItemJnlLine2."Invoiced Qty. (Base)" / QtyToInvoice;
          if "Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"] then
            ItemJnlLine2.Amount := -ItemJnlLine2.Amount;
          ItemJnlLine2."Unit Cost (ACY)" :=
            ROUND(
              ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
              Currency."Unit-Amount Rounding Precision");

          TotalChargeAmt2 := TotalChargeAmt2 + ItemJnlLine2.Amount;
          if PurchHeader."Currency Code" <> '' then
            ItemJnlLine2.Amount :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                Usedate,PurchHeader."Currency Code",TotalChargeAmt2 + TotalPurchLine.Amount,PurchHeader."Currency Factor") -
              TotalChargeAmtLCY2 - TotalPurchLineLCY.Amount
          else
            ItemJnlLine2.Amount := TotalChargeAmt2 - TotalChargeAmtLCY2;

          ItemJnlLine2.Amount := ROUND(ItemJnlLine2.Amount);
          TotalChargeAmtLCY2 := TotalChargeAmtLCY2 + ItemJnlLine2.Amount;
          ItemJnlLine2."Unit Cost" := ROUND(
              ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",GLSetup."Unit-Amount Rounding Precision");
          ItemJnlLine2."Applies-to Entry" := ItemJnlLine2."Item Shpt. Entry No.";
          ItemJnlLine2."Overhead Rate" := 0;

          if TaxOption = Taxoption::SalesTax then
            ItemJnlLine2.Amount +=
              ItemChargePurchLine."Tax To Be Expensed" * "Qty. to Assign" / ItemChargeQtyToAssign(ItemChargePurchLine);

          if PurchHeader."Currency Code" <> '' then
            ItemJnlLine2."Discount Amount" := ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  Usedate,PurchHeader."Currency Code",(ItemChargePurchLine."Inv. Discount Amount" +
                                                       ItemChargePurchLine."Line Discount Amount") *
                  ItemJnlLine2."Invoiced Qty. (Base)" /
                  ItemChargePurchLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
                  PurchHeader."Currency Factor"),GLSetup."Amount Rounding Precision")
          else
            ItemJnlLine2."Discount Amount" := ROUND(
                (ItemChargePurchLine."Line Discount Amount" + ItemChargePurchLine."Inv. Discount Amount") *
                ItemJnlLine2."Invoiced Qty. (Base)" /
                ItemChargePurchLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
                GLSetup."Amount Rounding Precision");

          ItemJnlLine2."Shortcut Dimension 1 Code" := ItemChargePurchLine."Shortcut Dimension 1 Code";
          ItemJnlLine2."Shortcut Dimension 2 Code" := ItemChargePurchLine."Shortcut Dimension 2 Code";
          ItemJnlLine2."Dimension Set ID" := ItemChargePurchLine."Dimension Set ID";
          ItemJnlLine2."Gen. Prod. Posting Group" := ItemChargePurchLine."Gen. Prod. Posting Group";
        end;

        with TempTrackingSpecificationChargeAssmt do begin
          Reset;
          SetRange("Source Type",Database::"Purchase Line");
          SetRange("Source ID",TempItemChargeAssgntPurch."Applies-to Doc. No.");
          SetRange("Source Ref. No.",TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
          if IsEmpty then
            ItemJnlPostLine.RunWithCheck(ItemJnlLine2)
          else begin
            FindSet;
            NonDistrItemJnlLine := ItemJnlLine2;
            OriginalAmt := NonDistrItemJnlLine.Amount;
            OriginalAmtACY := NonDistrItemJnlLine."Amount (ACY)";
            OriginalDiscountAmt := NonDistrItemJnlLine."Discount Amount";
            OriginalQty := NonDistrItemJnlLine."Quantity (Base)";
            if ("Quantity (Base)" / OriginalQty) > 0 then
              SignFactor := 1
            else
              SignFactor := -1;
            repeat
              Factor := "Quantity (Base)" / OriginalQty * SignFactor;
              if Abs("Quantity (Base)") < Abs(NonDistrItemJnlLine."Quantity (Base)") then begin
                ItemJnlLine2."Quantity (Base)" := "Quantity (Base)";
                ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
                ItemJnlLine2."Amount (ACY)" :=
                  ROUND(OriginalAmtACY * Factor,GLSetup."Amount Rounding Precision");
                ItemJnlLine2.Amount :=
                  ROUND(OriginalAmt * Factor,GLSetup."Amount Rounding Precision");
                ItemJnlLine2."Unit Cost (ACY)" :=
                  ROUND(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
                    Currency."Unit-Amount Rounding Precision") * SignFactor;
                ItemJnlLine2."Unit Cost" :=
                  ROUND(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
                    GLSetup."Unit-Amount Rounding Precision") * SignFactor;
                ItemJnlLine2."Discount Amount" :=
                  ROUND(OriginalDiscountAmt * Factor,GLSetup."Amount Rounding Precision");
                ItemJnlLine2."Item Shpt. Entry No." := "Item Ledger Entry No.";
                ItemJnlLine2."Applies-to Entry" := "Item Ledger Entry No.";
                ItemJnlLine2."Lot No." := "Lot No.";
                ItemJnlLine2."Serial No." := "Serial No.";
                ItemJnlPostLine.RunWithCheck(ItemJnlLine2);
                ItemJnlLine2."Location Code" := NonDistrItemJnlLine."Location Code";
                NonDistrItemJnlLine."Quantity (Base)" -= "Quantity (Base)";
                NonDistrItemJnlLine.Amount -= (ItemJnlLine2.Amount * SignFactor);
                NonDistrItemJnlLine."Amount (ACY)" -= (ItemJnlLine2."Amount (ACY)" * SignFactor);
                NonDistrItemJnlLine."Discount Amount" -= (ItemJnlLine2."Discount Amount" * SignFactor);
              end else begin
                NonDistrItemJnlLine."Quantity (Base)" := "Quantity (Base)";
                NonDistrItemJnlLine."Invoiced Qty. (Base)" := "Quantity (Base)";
                NonDistrItemJnlLine."Unit Cost" :=
                  ROUND(NonDistrItemJnlLine.Amount / NonDistrItemJnlLine."Invoiced Qty. (Base)",
                    GLSetup."Unit-Amount Rounding Precision") * SignFactor;
                NonDistrItemJnlLine."Unit Cost (ACY)" :=
                  ROUND(NonDistrItemJnlLine.Amount / NonDistrItemJnlLine."Invoiced Qty. (Base)",
                    Currency."Unit-Amount Rounding Precision") * SignFactor;
                NonDistrItemJnlLine."Item Shpt. Entry No." := "Item Ledger Entry No.";
                NonDistrItemJnlLine."Applies-to Entry" := "Item Ledger Entry No.";
                NonDistrItemJnlLine."Lot No." := "Lot No.";
                NonDistrItemJnlLine."Serial No." := "Serial No.";
                ItemJnlPostLine.RunWithCheck(NonDistrItemJnlLine);
                NonDistrItemJnlLine."Location Code" := ItemJnlLine2."Location Code";
              end;
            until Next = 0;
          end;
        end;
    end;

    local procedure PostItemChargePerRcpt(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line")
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        Sign: Decimal;
        DistributeCharge: Boolean;
    begin
        if not PurchRcptLine.Get(
             TempItemChargeAssgntPurch."Applies-to Doc. No.",TempItemChargeAssgntPurch."Applies-to Doc. Line No.")
        then
          Error(ReceiptLinesDeletedErr);

        Sign := GetSign(PurchRcptLine."Quantity (Base)");

        if PurchRcptLine."Item Rcpt. Entry No." <> 0 then
          DistributeCharge :=
            CostCalcMgt.SplitItemLedgerEntriesExist(
              TempItemLedgEntry,PurchRcptLine."Quantity (Base)",PurchRcptLine."Item Rcpt. Entry No.")
        else begin
          DistributeCharge := true;
          ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
            Database::"Purch. Rcpt. Line",0,PurchRcptLine."Document No.",
            '',0,PurchRcptLine."Line No.",PurchRcptLine."Quantity (Base)");
        end;

        if DistributeCharge then
          PostDistributeItemCharge(
            PurchHeader,PurchLine,TempItemLedgEntry,PurchRcptLine."Quantity (Base)",
            TempItemChargeAssgntPurch."Qty. to Assign",TempItemChargeAssgntPurch."Amount to Assign",
            Sign,PurchRcptLine."Indirect Cost %")
        else
          PostItemCharge(PurchHeader,PurchLine,
            PurchRcptLine."Item Rcpt. Entry No.",PurchRcptLine."Quantity (Base)",
            TempItemChargeAssgntPurch."Amount to Assign" * Sign,
            TempItemChargeAssgntPurch."Qty. to Assign",
            PurchRcptLine."Indirect Cost %");
    end;

    local procedure PostItemChargePerRetShpt(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line")
    var
        ReturnShptLine: Record "Return Shipment Line";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        Sign: Decimal;
        DistributeCharge: Boolean;
    begin
        ReturnShptLine.Get(
          TempItemChargeAssgntPurch."Applies-to Doc. No.",TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
        ReturnShptLine.TestField("Job No.",'');

        Sign := GetSign(PurchLine."Line Amount");
        if PurchLine.IsCreditDocType then
          Sign := -Sign;

        if ReturnShptLine."Item Shpt. Entry No." <> 0 then
          DistributeCharge :=
            CostCalcMgt.SplitItemLedgerEntriesExist(
              TempItemLedgEntry,-ReturnShptLine."Quantity (Base)",ReturnShptLine."Item Shpt. Entry No.")
        else begin
          DistributeCharge := true;
          ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
            Database::"Return Shipment Line",0,ReturnShptLine."Document No.",
            '',0,ReturnShptLine."Line No.",ReturnShptLine."Quantity (Base)");
        end;

        if DistributeCharge then
          PostDistributeItemCharge(
            PurchHeader,PurchLine,TempItemLedgEntry,-ReturnShptLine."Quantity (Base)",
            TempItemChargeAssgntPurch."Qty. to Assign",Abs(TempItemChargeAssgntPurch."Amount to Assign"),
            Sign,ReturnShptLine."Indirect Cost %")
        else
          PostItemCharge(PurchHeader,PurchLine,
            ReturnShptLine."Item Shpt. Entry No.",-ReturnShptLine."Quantity (Base)",
            Abs(TempItemChargeAssgntPurch."Amount to Assign") * Sign,
            TempItemChargeAssgntPurch."Qty. to Assign",
            ReturnShptLine."Indirect Cost %");
    end;

    local procedure PostItemChargePerTransfer(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line")
    var
        TransRcptLine: Record "Transfer Receipt Line";
        ItemApplnEntry: Record "Item Application Entry";
        DummyTrackingSpecification: Record "Tracking Specification";
        PurchLine2: Record "Purchase Line";
        CurrExchRate: Record "Currency Exchange Rate";
        TotalAmountToPostFCY: Decimal;
        TotalAmountToPostLCY: Decimal;
        TotalDiscAmountToPost: Decimal;
        AmountToPostFCY: Decimal;
        AmountToPostLCY: Decimal;
        DiscAmountToPost: Decimal;
        RemAmountToPostFCY: Decimal;
        RemAmountToPostLCY: Decimal;
        RemDiscAmountToPost: Decimal;
        CalcAmountToPostFCY: Decimal;
        CalcAmountToPostLCY: Decimal;
        CalcDiscAmountToPost: Decimal;
    begin
        with TempItemChargeAssgntPurch do begin
          TransRcptLine.Get("Applies-to Doc. No.","Applies-to Doc. Line No.");
          PurchLine2 := PurchLine;
          PurchLine2."No." := "Item No.";
          PurchLine2."Variant Code" := TransRcptLine."Variant Code";
          PurchLine2."Location Code" := TransRcptLine."Transfer-to Code";
          PurchLine2."Bin Code" := '';
          PurchLine2."Line No." := "Document Line No.";

          if TransRcptLine."Item Rcpt. Entry No." = 0 then
            PostItemChargePerITTransfer(PurchHeader,PurchLine,TransRcptLine)
          else begin
            TotalAmountToPostFCY := "Amount to Assign";
            if PurchHeader."Currency Code" <> '' then
              TotalAmountToPostLCY :=
                CurrExchRate.ExchangeAmtFCYToLCY(
                  Usedate,PurchHeader."Currency Code",
                  TotalAmountToPostFCY,PurchHeader."Currency Factor")
            else
              TotalAmountToPostLCY := TotalAmountToPostFCY;

            TotalDiscAmountToPost :=
              ROUND(
                PurchLine2."Inv. Discount Amount" / PurchLine2.Quantity * "Qty. to Assign",
                GLSetup."Amount Rounding Precision");
            TotalDiscAmountToPost :=
              TotalDiscAmountToPost +
              ROUND(
                PurchLine2."Line Discount Amount" * ("Qty. to Assign" / PurchLine2."Qty. to Invoice"),
                GLSetup."Amount Rounding Precision");

            TotalAmountToPostLCY := ROUND(TotalAmountToPostLCY,GLSetup."Amount Rounding Precision");

            ItemApplnEntry.SetCurrentkey("Outbound Item Entry No.","Item Ledger Entry No.","Cost Application");
            ItemApplnEntry.SetRange("Outbound Item Entry No.",TransRcptLine."Item Rcpt. Entry No.");
            ItemApplnEntry.SetFilter("Item Ledger Entry No.",'<>%1',TransRcptLine."Item Rcpt. Entry No.");
            ItemApplnEntry.SetRange("Cost Application",true);
            if ItemApplnEntry.FindSet then
              repeat
                PurchLine2."Appl.-to Item Entry" := ItemApplnEntry."Item Ledger Entry No.";
                CalcAmountToPostFCY :=
                  ((TotalAmountToPostFCY / TransRcptLine."Quantity (Base)") * ItemApplnEntry.Quantity) +
                  RemAmountToPostFCY;
                AmountToPostFCY := ROUND(CalcAmountToPostFCY);
                RemAmountToPostFCY := CalcAmountToPostFCY - AmountToPostFCY;
                CalcAmountToPostLCY :=
                  ((TotalAmountToPostLCY / TransRcptLine."Quantity (Base)") * ItemApplnEntry.Quantity) +
                  RemAmountToPostLCY;
                AmountToPostLCY := ROUND(CalcAmountToPostLCY);
                RemAmountToPostLCY := CalcAmountToPostLCY - AmountToPostLCY;
                CalcDiscAmountToPost :=
                  ((TotalDiscAmountToPost / TransRcptLine."Quantity (Base)") * ItemApplnEntry.Quantity) +
                  RemDiscAmountToPost;
                DiscAmountToPost := ROUND(CalcDiscAmountToPost);
                RemDiscAmountToPost := CalcDiscAmountToPost - DiscAmountToPost;
                PurchLine2.Amount := AmountToPostLCY;
                PurchLine2."Inv. Discount Amount" := DiscAmountToPost;
                PurchLine2."Line Discount Amount" := 0;
                PurchLine2."Unit Cost" :=
                  ROUND(AmountToPostFCY / ItemApplnEntry.Quantity,GLSetup."Unit-Amount Rounding Precision");
                PurchLine2."Unit Cost (LCY)" :=
                  ROUND(AmountToPostLCY / ItemApplnEntry.Quantity,GLSetup."Unit-Amount Rounding Precision");
                if "Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"] then
                  PurchLine2.Amount := -PurchLine2.Amount;
                PostItemJnlLine(
                  PurchHeader,PurchLine2,
                  0,0,
                  ItemApplnEntry.Quantity,ItemApplnEntry.Quantity,
                  PurchLine2."Appl.-to Item Entry","Item Charge No.",DummyTrackingSpecification);
              until ItemApplnEntry.Next = 0;
          end;
        end;
    end;

    local procedure PostItemChargePerITTransfer(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line";TransRcptLine: Record "Transfer Receipt Line")
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        with TempItemChargeAssgntPurch do begin
          ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
            Database::"Transfer Receipt Line",0,TransRcptLine."Document No.",
            '',0,TransRcptLine."Line No.",TransRcptLine."Quantity (Base)");
          PostDistributeItemCharge(
            PurchHeader,PurchLine,TempItemLedgEntry,TransRcptLine."Quantity (Base)",
            "Qty. to Assign","Amount to Assign",1,0);
        end;
    end;

    local procedure PostItemChargePerSalesShpt(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line")
    var
        SalesShptLine: Record "Sales Shipment Line";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        Sign: Decimal;
        DistributeCharge: Boolean;
    begin
        if not SalesShptLine.Get(
             TempItemChargeAssgntPurch."Applies-to Doc. No.",TempItemChargeAssgntPurch."Applies-to Doc. Line No.")
        then
          Error(RelatedItemLedgEntriesNotFoundErr);
        SalesShptLine.TestField("Job No.",'');

        Sign := -GetSign(SalesShptLine."Quantity (Base)");

        if SalesShptLine."Item Shpt. Entry No." <> 0 then
          DistributeCharge :=
            CostCalcMgt.SplitItemLedgerEntriesExist(
              TempItemLedgEntry,-SalesShptLine."Quantity (Base)",SalesShptLine."Item Shpt. Entry No.")
        else begin
          DistributeCharge := true;
          ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
            Database::"Sales Shipment Line",0,SalesShptLine."Document No.",
            '',0,SalesShptLine."Line No.",SalesShptLine."Quantity (Base)");
        end;

        if DistributeCharge then
          PostDistributeItemCharge(
            PurchHeader,PurchLine,TempItemLedgEntry,-SalesShptLine."Quantity (Base)",
            TempItemChargeAssgntPurch."Qty. to Assign",TempItemChargeAssgntPurch."Amount to Assign",Sign,0)
        else
          PostItemCharge(PurchHeader,PurchLine,
            SalesShptLine."Item Shpt. Entry No.",-SalesShptLine."Quantity (Base)",
            TempItemChargeAssgntPurch."Amount to Assign" * Sign,
            TempItemChargeAssgntPurch."Qty. to Assign",0)
    end;

    local procedure PostItemChargePerRetRcpt(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line")
    var
        ReturnRcptLine: Record "Return Receipt Line";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        Sign: Decimal;
        DistributeCharge: Boolean;
    begin
        if not ReturnRcptLine.Get(
             TempItemChargeAssgntPurch."Applies-to Doc. No.",TempItemChargeAssgntPurch."Applies-to Doc. Line No.")
        then
          Error(RelatedItemLedgEntriesNotFoundErr);
        ReturnRcptLine.TestField("Job No.",'');
        Sign := GetSign(ReturnRcptLine."Quantity (Base)");

        if ReturnRcptLine."Item Rcpt. Entry No." <> 0 then
          DistributeCharge :=
            CostCalcMgt.SplitItemLedgerEntriesExist(
              TempItemLedgEntry,ReturnRcptLine."Quantity (Base)",ReturnRcptLine."Item Rcpt. Entry No.")
        else begin
          DistributeCharge := true;
          ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
            Database::"Return Receipt Line",0,ReturnRcptLine."Document No.",
            '',0,ReturnRcptLine."Line No.",ReturnRcptLine."Quantity (Base)");
        end;

        if DistributeCharge then
          PostDistributeItemCharge(
            PurchHeader,PurchLine,TempItemLedgEntry,ReturnRcptLine."Quantity (Base)",
            TempItemChargeAssgntPurch."Qty. to Assign",TempItemChargeAssgntPurch."Amount to Assign",Sign,0)
        else
          PostItemCharge(PurchHeader,PurchLine,
            ReturnRcptLine."Item Rcpt. Entry No.",ReturnRcptLine."Quantity (Base)",
            TempItemChargeAssgntPurch."Amount to Assign" * Sign,
            TempItemChargeAssgntPurch."Qty. to Assign",0)
    end;

    local procedure PostDistributeItemCharge(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";var TempItemLedgEntry: Record "Item Ledger Entry" temporary;NonDistrQuantity: Decimal;NonDistrQtyToAssign: Decimal;NonDistrAmountToAssign: Decimal;Sign: Decimal;IndirectCostPct: Decimal)
    var
        Factor: Decimal;
        QtyToAssign: Decimal;
        AmountToAssign: Decimal;
    begin
        if TempItemLedgEntry.FindSet then begin
          repeat
            Factor := TempItemLedgEntry.Quantity / NonDistrQuantity;
            QtyToAssign := NonDistrQtyToAssign * Factor;
            AmountToAssign := ROUND(NonDistrAmountToAssign * Factor,GLSetup."Amount Rounding Precision");
            if Factor < 1 then begin
              PostItemCharge(PurchHeader,PurchLine,
                TempItemLedgEntry."Entry No.",TempItemLedgEntry.Quantity,
                AmountToAssign * Sign,QtyToAssign,IndirectCostPct);
              NonDistrQuantity := NonDistrQuantity - TempItemLedgEntry.Quantity;
              NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
              NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
            end else // the last time
              PostItemCharge(PurchHeader,PurchLine,
                TempItemLedgEntry."Entry No.",TempItemLedgEntry.Quantity,
                NonDistrAmountToAssign * Sign,NonDistrQtyToAssign,IndirectCostPct);
          until TempItemLedgEntry.Next = 0;
        end else
          Error(RelatedItemLedgEntriesNotFoundErr)
    end;

    local procedure PostAssocItemJnlLine(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";QtyToBeShipped: Decimal;QtyToBeShippedBase: Decimal): Integer
    var
        ItemJnlLine: Record "Item Journal Line";
        TempHandlingSpecification2: Record "Tracking Specification" temporary;
        ItemEntryRelation: Record "Item Entry Relation";
        CurrExchRate: Record "Currency Exchange Rate";
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
    begin
        SalesOrderHeader.Get(
          SalesOrderHeader."document type"::Order,PurchLine."Sales Order No.");
        SalesOrderLine.Get(
          SalesOrderLine."document type"::Order,PurchLine."Sales Order No.",PurchLine."Sales Order Line No.");

        with ItemJnlLine do begin
          Init;
          CopyDocumentFields(
            "document type"::"Sales Shipment",SalesOrderHeader."Shipping No.",'',SrcCode,SalesOrderHeader."Posting No. Series");

          CopyFromSalesHeader(SalesOrderHeader);
          "Country/Region Code" := GetCountryCode(SalesOrderLine,SalesOrderHeader);
          "Posting Date" := PurchHeader."Posting Date";
          "Document Date" := PurchHeader."Document Date";

          CopyFromSalesLine(SalesOrderLine);
          "Derived from Blanket Order" := SalesOrderLine."Blanket Order No." <> '';
          "Applies-to Entry" := ItemLedgShptEntryNo;

          Quantity := QtyToBeShipped;
          "Quantity (Base)" := QtyToBeShippedBase;
          "Invoiced Quantity" := 0;
          "Invoiced Qty. (Base)" := 0;
          "Source Currency Code" := PurchHeader."Currency Code";

          Amount := SalesOrderLine.Amount * QtyToBeShipped / SalesOrderLine.Quantity;
          if SalesOrderHeader."Currency Code" <> '' then begin
            Amount :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  SalesOrderHeader."Posting Date",SalesOrderHeader."Currency Code",
                  Amount,SalesOrderHeader."Currency Factor"));
            "Discount Amount" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  SalesOrderHeader."Posting Date",SalesOrderHeader."Currency Code",
                  SalesOrderLine."Line Discount Amount",SalesOrderHeader."Currency Factor"));
          end else begin
            Amount := ROUND(Amount);
            "Discount Amount" := SalesOrderLine."Line Discount Amount";
          end;
        end;

        if SalesOrderLine."Job Contract Entry No." = 0 then begin
          TransferReservToItemJnlLine(SalesOrderLine,ItemJnlLine,PurchLine,QtyToBeShippedBase,true);
          ItemJnlPostLine.RunWithCheck(ItemJnlLine);
          // Handle Item Tracking
          if ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification2) then begin
            if TempHandlingSpecification2.FindSet then
              repeat
                TempTrackingSpecification := TempHandlingSpecification2;
                TempTrackingSpecification.SetSourceFromSalesLine(SalesOrderLine);
                if TempTrackingSpecification.Insert then;
                ItemEntryRelation.Init;
                ItemEntryRelation."Item Entry No." := TempHandlingSpecification2."Entry No.";
                ItemEntryRelation."Serial No." := TempHandlingSpecification2."Serial No.";
                ItemEntryRelation."Lot No." := TempHandlingSpecification2."Lot No.";
                ItemEntryRelation."Source Type" := Database::"Sales Shipment Line";
                ItemEntryRelation."Source ID" := SalesOrderHeader."Shipping No.";
                ItemEntryRelation."Source Ref. No." := SalesOrderLine."Line No.";
                ItemEntryRelation."Order No." := SalesOrderLine."Document No.";
                ItemEntryRelation."Order Line No." := SalesOrderLine."Line No.";
                ItemEntryRelation.Insert;
              until TempHandlingSpecification2.Next = 0;
            exit(0);
          end;
        end;

        exit(ItemJnlLine."Item Shpt. Entry No.");
    end;

    local procedure ReleasePurchDocument(var PurchHeader: Record "Purchase Header")
    var
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        LinesWereModified: Boolean;
        TempInvoice: Boolean;
        TempRcpt: Boolean;
        TempReturn: Boolean;
        PrevStatus: Option;
    begin
        with PurchHeader do begin
          if not (Status = Status::Open) or (Status = Status::"Pending Prepayment") then
            exit;

          TempInvoice := Invoice;
          TempRcpt := Receive;
          TempReturn := Ship;
          PrevStatus := Status;
          LinesWereModified := ReleasePurchaseDocument.ReleasePurchaseHeader(PurchHeader,PreviewMode);
          if LinesWereModified then
            RefreshTempLines(PurchHeader);
          TestField(Status,Status::Released);
          Status := PrevStatus;
          Invoice := TempInvoice;
          Receive := TempRcpt;
          Ship := TempReturn;
          if PreviewMode and ("Posting No." = '') then
            "Posting No." := '***';
          if not PreviewMode then begin
            Modify;
            Commit;
          end;
          Status := Status::Released;
        end;
    end;

    local procedure TestPurchLine(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line")
    var
        FA: Record "Fixed Asset";
        FASetup: Record "FA Setup";
        DeprBook: Record "Depreciation Book";
        DummyTrackingSpecification: Record "Tracking Specification";
    begin
        with PurchLine do begin
          if Type = Type::Item then
            DummyTrackingSpecification.CheckItemTrackingQuantity(
              Database::"Purchase Line","Document Type","Document No.","Line No.",
              "Qty. to Receive (Base)","Qty. to Invoice (Base)",PurchHeader.Receive,PurchHeader.Invoice);

          if Type = Type::"Charge (Item)" then begin
            TestField(Amount);
            TestField("Job No.",'');
          end;
          if "Job No." <> '' then
            TestField("Job Task No.");
          if Type = Type::"Fixed Asset" then begin
            TestField("Job No.",'');
            TestField("Depreciation Book Code");
            TestField("FA Posting Type");
            FA.Get("No.");
            FA.TestField("Budgeted Asset",false);
            DeprBook.Get("Depreciation Book Code");
            if "Budgeted FA No." <> '' then begin
              FA.Get("Budgeted FA No.");
              FA.TestField("Budgeted Asset",true);
            end;
            if "FA Posting Type" = "fa posting type"::Maintenance then begin
              TestField("Insurance No.",'');
              TestField("Depr. until FA Posting Date",false);
              TestField("Depr. Acquisition Cost",false);
              DeprBook.TestField("G/L Integration - Maintenance",true);
            end;
            if "FA Posting Type" = "fa posting type"::"Acquisition Cost" then begin
              TestField("Maintenance Code",'');
              DeprBook.TestField("G/L Integration - Acq. Cost",true);
            end;
            if "Insurance No." <> '' then begin
              FASetup.Get;
              FASetup.TestField("Insurance Depr. Book","Depreciation Book Code");
            end;
          end else begin
            TestField("Depreciation Book Code",'');
            TestField("FA Posting Type",0);
            TestField("Maintenance Code",'');
            TestField("Insurance No.",'');
            TestField("Depr. until FA Posting Date",false);
            TestField("Depr. Acquisition Cost",false);
            TestField("Budgeted FA No.",'');
            TestField("FA Posting Date",0D);
            TestField("Salvage Value",0);
            TestField("Duplicate in Depreciation Book",'');
            TestField("Use Duplication List",false);
          end;
        end;
    end;

    local procedure UpdateAssocOrder(var TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
        TempDropShptPostBuffer.Reset;
        if TempDropShptPostBuffer.IsEmpty then
          exit;
        SalesSetup.Get;
        if TempDropShptPostBuffer.FindSet then begin
          repeat
            SalesOrderHeader.Get(
              SalesOrderHeader."document type"::Order,
              TempDropShptPostBuffer."Order No.");
            SalesOrderHeader."Last Shipping No." := SalesOrderHeader."Shipping No.";
            SalesOrderHeader."Shipping No." := '';
            SalesOrderHeader.Modify;
            ReserveSalesLine.UpdateItemTrackingAfterPosting(SalesOrderHeader);
            TempDropShptPostBuffer.SetRange("Order No.",TempDropShptPostBuffer."Order No.");
            repeat
              SalesOrderLine.Get(
                SalesOrderLine."document type"::Order,
                TempDropShptPostBuffer."Order No.",TempDropShptPostBuffer."Order Line No.");
              SalesOrderLine."Quantity Shipped" := SalesOrderLine."Quantity Shipped" + TempDropShptPostBuffer.Quantity;
              SalesOrderLine."Qty. Shipped (Base)" := SalesOrderLine."Qty. Shipped (Base)" + TempDropShptPostBuffer."Quantity (Base)";
              SalesOrderLine.InitOutstanding;
              if SalesSetup."Default Quantity to Ship" <> SalesSetup."default quantity to ship"::Blank then
                SalesOrderLine.InitQtyToShip
              else begin
                SalesOrderLine."Qty. to Ship" := 0;
                SalesOrderLine."Qty. to Ship (Base)" := 0;
              end;
              SalesOrderLine.Modify;
            until TempDropShptPostBuffer.Next = 0;
            TempDropShptPostBuffer.SetRange("Order No.");
          until TempDropShptPostBuffer.Next = 0;
          TempDropShptPostBuffer.DeleteAll;
        end;
    end;

    local procedure UpdateAssosOrderPostingNos(PurchHeader: Record "Purchase Header") DropShipment: Boolean
    var
        TempPurchLine: Record "Purchase Line" temporary;
        SalesOrderHeader: Record "Sales Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ReleaseSalesDocument: Codeunit "Release Sales Document";
    begin
        with PurchHeader do begin
          ResetTempLines(TempPurchLine);
          TempPurchLine.SetFilter("Sales Order Line No.",'<>0');
          if not TempPurchLine.IsEmpty then begin
            DropShipment := true;
            if Receive then begin
              TempPurchLine.FindSet;
              repeat
                if SalesOrderHeader."No." <> TempPurchLine."Sales Order No." then begin
                  SalesOrderHeader.Get(SalesOrderHeader."document type"::Order,TempPurchLine."Sales Order No.");
                  SalesOrderHeader.TestField("Bill-to Customer No.");
                  SalesOrderHeader.Ship := true;
                  ReleaseSalesDocument.ReleaseSalesHeader(SalesOrderHeader,PreviewMode);
                  if SalesOrderHeader."Shipping No." = '' then begin
                    SalesOrderHeader.TestField("Shipping No. Series");
                    SalesOrderHeader."Shipping No." :=
                      NoSeriesMgt.GetNextNo(SalesOrderHeader."Shipping No. Series","Posting Date",true);
                    SalesOrderHeader.Modify;
                  end;
                end;
              until TempPurchLine.Next = 0;
            end;
          end;
          exit(DropShipment);
        end;
    end;

    local procedure UpdateAfterPosting(PurchHeader: Record "Purchase Header")
    var
        TempPurchLine: Record "Purchase Line" temporary;
    begin
        with TempPurchLine do begin
          ResetTempLines(TempPurchLine);
          SetFilter("Blanket Order Line No.",'<>0');
          if FindSet then
            repeat
              UpdateBlanketOrderLine(TempPurchLine,PurchHeader.Receive,PurchHeader.Ship,PurchHeader.Invoice);
            until Next = 0;
        end;
    end;

    local procedure UpdateLastPostingNos(var PurchHeader: Record "Purchase Header")
    begin
        with PurchHeader do begin
          if Receive then begin
            "Last Receiving No." := "Receiving No.";
            "Receiving No." := '';
          end;
          if Invoice then begin
            "Last Posting No." := "Posting No.";
            "Posting No." := '';
          end;
          if Ship then begin
            "Last Return Shipment No." := "Return Shipment No.";
            "Return Shipment No." := '';
          end;
        end;
    end;

    local procedure UpdatePostingNos(var PurchHeader: Record "Purchase Header") ModifyHeader: Boolean
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        with PurchHeader do begin
          if Receive and ("Receiving No." = '') then
            if ("Document Type" = "document type"::Order) or
               (("Document Type" = "document type"::Invoice) and PurchSetup."Receipt on Invoice")
            then begin
              TestField("Receiving No. Series");
              "Receiving No." := NoSeriesMgt.GetNextNo("Receiving No. Series","Posting Date",true);
              ModifyHeader := true;
            end;

          if Ship and ("Return Shipment No." = '') then
            if IsCreditDocType and PurchSetup."Return Shipment on Credit Memo" then begin
              TestField("Return Shipment No. Series");
              "Return Shipment No." := NoSeriesMgt.GetNextNo("Return Shipment No. Series","Posting Date",true);
              ModifyHeader := true;
            end;

          if Invoice and ("Posting No." = '') then begin
            if ("No. Series" <> '') or
               ("Document Type" in ["document type"::Order,"document type"::"Return Order"])
            then
              TestField("Posting No. Series");
            if ("No. Series" <> "Posting No. Series") or
               ("Document Type" in ["document type"::Order,"document type"::"Return Order"])
            then begin
              if not PreviewMode then begin
                "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series","Posting Date",true);
                ModifyHeader := true;
              end else
                "Posting No." := '***';
            end;
          end;
        end;
    end;

    local procedure UpdatePurchLineBeforePost(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line")
    begin
        with PurchLine do begin
          case PurchHeader."Document Type" of
            "document type"::Order:
              TestField("Return Qty. to Ship",0);
            "document type"::Invoice:
              begin
                if "Receipt No." = '' then
                  TestField("Qty. to Receive",Quantity);
                TestField("Return Qty. to Ship",0);
                TestField("Qty. to Invoice",Quantity);
              end;
            "document type"::"Return Order":
              TestField("Qty. to Receive",0);
            "document type"::"Credit Memo":
              begin
                if "Return Shipment No." = '' then
                  TestField("Return Qty. to Ship",Quantity);
                TestField("Qty. to Receive",0);
                TestField("Qty. to Invoice",Quantity);
              end;
          end;

          if not (PurchHeader.Receive or RoundingLineInserted) then begin
            "Qty. to Receive" := 0;
            "Qty. to Receive (Base)" := 0;
          end;

          if not (PurchHeader.Ship or RoundingLineInserted) then begin
            "Return Qty. to Ship" := 0;
            "Return Qty. to Ship (Base)" := 0;
          end;

          if (PurchHeader."Document Type" = PurchHeader."document type"::Invoice) and ("Receipt No." <> '') then begin
            "Quantity Received" := Quantity;
            "Qty. Received (Base)" := "Quantity (Base)";
            "Qty. to Receive" := 0;
            "Qty. to Receive (Base)" := 0;
          end;

          if (PurchHeader."Document Type" = PurchHeader."document type"::"Credit Memo") and ("Return Shipment No." <> '')
          then begin
            "Return Qty. Shipped" := Quantity;
            "Return Qty. Shipped (Base)" := "Quantity (Base)";
            "Return Qty. to Ship" := 0;
            "Return Qty. to Ship (Base)" := 0;
          end;

          if PurchHeader.Invoice then begin
            if Abs("Qty. to Invoice") > Abs(MaxQtyToInvoice) then
              InitQtyToInvoice;
          end else begin
            "Qty. to Invoice" := 0;
            "Qty. to Invoice (Base)" := 0;
          end;
        end;
    end;

    local procedure UpdateWhseDocuments()
    begin
        if WhseReceive then begin
          WhsePostRcpt.PostUpdateWhseDocuments(WhseRcptHeader);
          TempWhseRcptHeader.Delete;
        end;
        if WhseShip then begin
          WhsePostShpt.PostUpdateWhseDocuments(WhseShptHeader);
          TempWhseShptHeader.Delete;
        end;
    end;

    local procedure DeleteAfterPosting(var PurchHeader: Record "Purchase Header")
    var
        PurchCommentLine: Record "Purch. Comment Line";
        PurchLine: Record "Purchase Line";
        TempPurchLine: Record "Purchase Line" temporary;
        WarehouseRequest: Record "Warehouse Request";
    begin
        with PurchHeader do begin
          if HasLinks then
            DeleteLinks;
          Delete;

          ReservePurchLine.DeleteInvoiceSpecFromHeader(PurchHeader);
          ResetTempLines(TempPurchLine);
          if TempPurchLine.FindFirst then
            repeat
              if TempPurchLine."Deferral Code" <> '' then
                DeferralUtilities.RemoveOrSetDeferralSchedule(
                  '',DeferralUtilities.GetPurchDeferralDocType,'','',
                  TempPurchLine."Document Type",
                  TempPurchLine."Document No.",
                  TempPurchLine."Line No.",0,0D,
                  TempPurchLine.Description,
                  '',
                  true);
              if TempPurchLine.HasLinks then
                TempPurchLine.DeleteLinks;
            until TempPurchLine.Next = 0;

          PurchLine.SetRange("Document Type","Document Type");
          PurchLine.SetRange("Document No.","No.");
          PurchLine.DeleteAll;

          DeleteItemChargeAssgnt(PurchHeader);
          PurchCommentLine.SetRange("Document Type","Document Type");
          PurchCommentLine.SetRange("No.","No.");
          if not PurchCommentLine.IsEmpty then
            PurchCommentLine.DeleteAll;
          WarehouseRequest.SetCurrentkey("Source Type","Source Subtype","Source No.");
          WarehouseRequest.SetRange("Source Type",Database::"Purchase Line");
          WarehouseRequest.SetRange("Source Subtype","Document Type");
          WarehouseRequest.SetRange("Source No.","No.");
          if not WarehouseRequest.IsEmpty then
            WarehouseRequest.DeleteAll;
        end;
    end;

    local procedure FinalizePosting(var PurchHeader: Record "Purchase Header";var TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary;EverythingInvoiced: Boolean)
    var
        TempPurchLine: Record "Purchase Line" temporary;
    begin
        with PurchHeader do begin
          if ("Document Type" in ["document type"::Order,"document type"::"Return Order"]) and
             (not EverythingInvoiced)
          then begin
            Modify;
            InsertTrackingSpecification(PurchHeader);
            PostUpdateOrderLine(PurchHeader);
            UpdateAssocOrder(TempDropShptPostBuffer);
            UpdateWhseDocuments;
            WhsePurchRelease.Release(PurchHeader);
            UpdateItemChargeAssgnt;
          end else begin
            case "Document Type" of
              "document type"::Invoice:
                begin
                  PostUpdateInvoiceLine(PurchHeader);
                  InsertTrackingSpecification(PurchHeader);
                end;
              "document type"::"Credit Memo":
                begin
                  PostUpdateCreditMemoLine;
                  InsertTrackingSpecification(PurchHeader);
                end;
              else begin
                ResetTempLines(TempPurchLine);
                TempPurchLine.SetFilter("Prepayment %",'<>0');
                if TempPurchLine.FindSet then
                  repeat
                    DecrementPrepmtAmtInvLCY(
                      PurchHeader,TempPurchLine,TempPurchLine."Prepmt. Amount Inv. (LCY)",TempPurchLine."Prepmt. VAT Amount Inv. (LCY)");
                  until TempPurchLine.Next = 0;
              end;
            end;
            UpdateAfterPosting(PurchHeader);
            UpdateWhseDocuments;
            ApprovalsMgmt.DeleteApprovalEntry(PurchHeader);
            DeleteAfterPosting(PurchHeader);
          end;

          InsertValueEntryRelation;
        end;

        if not InvtPickPutaway then
          Commit;
        ClearPostBuffers;
        if GuiAllowed then
          Window.Close;

        if PurchHeader.Invoice and (TaxOption = Taxoption::SalesTax) and UseExternalTaxEngine then begin
          if PurchHeader."Document Type" in [PurchHeader."document type"::Order,PurchHeader."document type"::Invoice] then
            SalesTaxCalculate.FinalizeExternalTaxCalcForDoc(Database::"Purch. Inv. Header",PurchInvHeader."No.")
          else
            SalesTaxCalculate.FinalizeExternalTaxCalcForDoc(Database::"Purch. Cr. Memo Hdr.",PurchCrMemoHeader."No.");
        end;
    end;

    local procedure FillInvoicePostBuffer(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";PurchLineACY: Record "Purchase Line";var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;var InvoicePostBuffer: Record "Invoice Post. Buffer")
    var
        GenPostingSetup: Record "General Posting Setup";
        TotalVAT: Decimal;
        TotalVATACY: Decimal;
        TotalAmount: Decimal;
        TotalAmountACY: Decimal;
        AmtToDefer: Decimal;
        AmtToDeferACY: Decimal;
        TotalVATBase: Decimal;
        TotalVATBaseACY: Decimal;
        DeferralAccount: Code[20];
        PurchAccount: Code[20];
    begin
        GetGenPostingSetup(GenPostingSetup,PurchLine);
        InvoicePostBuffer.PreparePurchase(PurchLine);
        InitAmounts(PurchLine,TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY,AmtToDefer,AmtToDeferACY,DeferralAccount);

        if PurchSetup."Discount Posting" in
           [PurchSetup."discount posting"::"Invoice Discounts",PurchSetup."discount posting"::"All Discounts"]
        then begin
          CalcInvoiceDiscountPosting(PurchHeader,PurchLine,PurchLineACY,InvoicePostBuffer);

          if TaxOption = Taxoption::SalesTax then
            InvoicePostBuffer.ClearVAT;

          if (InvoicePostBuffer.Amount <> 0) or (InvoicePostBuffer."Amount (ACY)" <> 0) then begin
            GenPostingSetup.TestField("Purch. Inv. Disc. Account");
            if InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" then begin
              FillInvoicePostBufferFADiscount(
                TempInvoicePostBuffer,InvoicePostBuffer,GenPostingSetup,PurchLine."No.",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
              InvoicePostBuffer.SetAccount(
                GenPostingSetup."Purch. Inv. Disc. Account",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
              InvoicePostBuffer.Type := InvoicePostBuffer.Type::"G/L Account";
              UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer);
              InvoicePostBuffer.Type := InvoicePostBuffer.Type::"Fixed Asset";
            end else begin
              InvoicePostBuffer.SetAccount(
                GenPostingSetup."Purch. Inv. Disc. Account",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
              UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer);
            end;
          end;
        end;

        if PurchSetup."Discount Posting" in
           [PurchSetup."discount posting"::"Line Discounts",PurchSetup."discount posting"::"All Discounts"]
        then begin
          CalcLineDiscountPosting(PurchHeader,PurchLine,PurchLineACY,InvoicePostBuffer);

          if TaxOption = Taxoption::SalesTax then
            InvoicePostBuffer.ClearVAT;

          if (InvoicePostBuffer.Amount <> 0) or (InvoicePostBuffer."Amount (ACY)" <> 0) then begin
            GenPostingSetup.TestField("Purch. Line Disc. Account");
            if InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" then begin
              FillInvoicePostBufferFADiscount(
                TempInvoicePostBuffer,InvoicePostBuffer,GenPostingSetup,PurchLine."No.",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
              InvoicePostBuffer.SetAccount(
                GenPostingSetup."Purch. Line Disc. Account",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
              InvoicePostBuffer.Type := InvoicePostBuffer.Type::"G/L Account";
              UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer);
              InvoicePostBuffer.Type := InvoicePostBuffer.Type::"Fixed Asset";
            end else begin
              InvoicePostBuffer.SetAccount(
                GenPostingSetup."Purch. Line Disc. Account",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
              UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer);
            end;
          end;
        end;
        // Don't adjust VAT Base Amounts when Deferrals are included
        DeferralUtilities.AdjustTotalAmountForDeferrals(PurchLine."Deferral Code",
          AmtToDefer,AmtToDeferACY,TotalAmount,TotalAmountACY,TotalVATBase,TotalVATBaseACY);

        if PurchLine."VAT Calculation Type" = PurchLine."vat calculation type"::"Reverse Charge VAT" then begin
          if PurchLine."Deferral Code" <> '' then
            InvoicePostBuffer.SetAmounts(
              TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY,PurchLine."VAT Difference",TotalVATBase,TotalVATBaseACY)
          else
            InvoicePostBuffer.SetAmountsNoVAT(TotalAmount,TotalAmountACY,PurchLine."VAT Difference")
        end else
          if (not PurchLine."Use Tax") or (PurchLine."VAT Calculation Type" <> PurchLine."vat calculation type"::"Sales Tax") then
            InvoicePostBuffer.SetAmounts(
              TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY,PurchLine."VAT Difference",TotalVATBase,TotalVATBaseACY)
          else
            InvoicePostBuffer.SetAmountsNoVAT(TotalAmount,TotalAmountACY,PurchLine."VAT Difference");

        if TaxOption = Taxoption::SalesTax then begin
          InvoicePostBuffer.ClearVAT;
          if PurchLine."Tax To Be Expensed" <> 0 then begin
            RemSalesTaxAmtACY := RemSalesTaxAmtACY + PurchLineACY."Tax To Be Expensed";
            InvoicePostBuffer."Amount (ACY)" += ROUND(RemSalesTaxAmtACY,Currency."Amount Rounding Precision");
            RemSalesTaxAmtACY := RemSalesTaxAmtACY - ROUND(RemSalesTaxAmtACY,Currency."Amount Rounding Precision");
            RemSalesTaxAmt += PurchLine."Tax To Be Expensed";
            InvoicePostBuffer.Amount += ROUND(RemSalesTaxAmt);
            RemSalesTaxAmt := RemSalesTaxAmt - ROUND(RemSalesTaxAmt);
          end;
        end;

        if (PurchLine.Type = PurchLine.Type::"G/L Account") or (PurchLine.Type = PurchLine.Type::"Fixed Asset") then begin
          PurchAccount := PurchLine."No.";
          InvoicePostBuffer.SetAccount(
            DefaultGLAccount(PurchLine."Deferral Code",AmtToDefer,PurchAccount,DeferralAccount),
            TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY)
        end else
          if PurchLine.IsCreditDocType then begin
            GenPostingSetup.TestField("Purch. Credit Memo Account");
            PurchAccount := GenPostingSetup."Purch. Credit Memo Account";
            InvoicePostBuffer.SetAccount(
              DefaultGLAccount(PurchLine."Deferral Code",AmtToDefer,PurchAccount,DeferralAccount),
              TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
          end else begin
            GenPostingSetup.TestField("Purch. Account");
            PurchAccount := GenPostingSetup."Purch. Account";
            InvoicePostBuffer.SetAccount(
              DefaultGLAccount(PurchLine."Deferral Code",AmtToDefer,PurchAccount,DeferralAccount),
              TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
          end;
        InvoicePostBuffer."Deferral Code" := PurchLine."Deferral Code";
        UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer);
        FillDeferralPostingBuffer(PurchHeader,PurchLine,InvoicePostBuffer,AmtToDefer,AmtToDeferACY,DeferralAccount,PurchAccount);
    end;

    local procedure FillInvoicePostBufferFADiscount(var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;var InvoicePostBuffer: Record "Invoice Post. Buffer";GenPostingSetup: Record "General Posting Setup";AccountNo: Code[20];TotalVAT: Decimal;TotalVATACY: Decimal;TotalAmount: Decimal;TotalAmountACY: Decimal)
    var
        DeprBook: Record "Depreciation Book";
    begin
        DeprBook.Get(InvoicePostBuffer."Depreciation Book Code");
        if DeprBook."Subtract Disc. in Purch. Inv." then begin
          GenPostingSetup.TestField("Purch. FA Disc. Account");
          InvoicePostBuffer.SetAccount(AccountNo,TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
          UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer);
          InvoicePostBuffer.ReverseAmounts;
          InvoicePostBuffer.SetAccount(GenPostingSetup."Purch. FA Disc. Account",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
          InvoicePostBuffer.Type := InvoicePostBuffer.Type::"G/L Account";
          UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer);
          InvoicePostBuffer.ReverseAmounts;
        end;
    end;

    local procedure UpdateInvoicePostBuffer(var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        if InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" then begin
          FALineNo := FALineNo + 1;
          InvoicePostBuffer."Fixed Asset Line No." := FALineNo;
        end;

        TempInvoicePostBuffer.Update(InvoicePostBuffer,InvDefLineNo,DeferralLineNo);
    end;

    local procedure InsertPrepmtAdjInvPostingBuf(PurchHeader: Record "Purchase Header";PrepmtPurchLine: Record "Purchase Line";var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;InvoicePostBuffer: Record "Invoice Post. Buffer")
    var
        PurchPostPrepayments: Codeunit "Purchase-Post Prepayments";
        AdjAmount: Decimal;
    begin
        with PrepmtPurchLine do
          if "Prepayment Line" then
            if "Prepmt. Amount Inv. (LCY)" <> 0 then begin
              AdjAmount := -"Prepmt. Amount Inv. (LCY)";
              TempInvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer,InvoicePostBuffer,
                "No.",AdjAmount,PurchHeader."Currency Code" = '');
              TempInvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer,InvoicePostBuffer,
                PurchPostPrepayments.GetCorrBalAccNo(PurchHeader,AdjAmount > 0),
                -AdjAmount,
                PurchHeader."Currency Code" = '');
            end else
              if ("Prepayment %" = 100) and ("Prepmt. VAT Amount Inv. (LCY)" <> 0) then
                TempInvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer,InvoicePostBuffer,
                  PurchPostPrepayments.GetInvRoundingAccNo(PurchHeader."Vendor Posting Group"),
                  "Prepmt. VAT Amount Inv. (LCY)",PurchHeader."Currency Code" = '');
    end;

    local procedure GetCurrency(CurrencyCode: Code[10])
    begin
        if CurrencyCode = '' then
          Currency.InitRoundingPrecision
        else begin
          Currency.Get(CurrencyCode);
          Currency.TestField("Amount Rounding Precision");
        end;
    end;

    local procedure DivideAmount(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line";QtyType: Option General,Invoicing,Shipping;PurchLineQty: Decimal;var TempVATAmountLine: Record "VAT Amount Line" temporary;var TempVATAmountLineRemainder: Record "VAT Amount Line" temporary)
    var
        OriginalDeferralAmount: Decimal;
    begin
        if RoundingLineInserted and (RoundingLineNo = PurchLine."Line No.") then
          exit;
        with PurchLine do
          if (PurchLineQty = 0) or ("Direct Unit Cost" = 0) then begin
            "Line Amount" := 0;
            "Line Discount Amount" := 0;
            "Inv. Discount Amount" := 0;
            "VAT Base Amount" := 0;
            Amount := 0;
            "Amount Including VAT" := 0;
            "Tax To Be Expensed" := 0;
          end else begin
            OriginalDeferralAmount := GetDeferralAmount;
            if "VAT Calculation Type" = "vat calculation type"::"Sales Tax" then begin
              if (QtyType = Qtytype::Invoicing) and
                 TempPurchLineForSalesTax.Get("Document Type","Document No.","Line No.")
              then begin
                "Line Amount" := TempPurchLineForSalesTax."Line Amount";
                "Line Discount Amount" := TempPurchLineForSalesTax."Line Discount Amount";
                Amount := TempPurchLineForSalesTax.Amount;
                "Amount Including VAT" := TempPurchLineForSalesTax."Amount Including VAT";
                "Inv. Discount Amount" := TempPurchLineForSalesTax."Inv. Discount Amount";
                "VAT Base Amount" := TempPurchLineForSalesTax."VAT Base Amount";
                "Tax To Be Expensed" := TempPurchLineForSalesTax."Tax To Be Expensed";
              end else begin
                "Line Amount" := ROUND(PurchLineQty * "Direct Unit Cost",Currency."Amount Rounding Precision");
                if PurchLineQty <> Quantity then
                  "Line Discount Amount" :=
                    ROUND("Line Amount" * "Line Discount %" / 100,Currency."Amount Rounding Precision");
                "Line Amount" := "Line Amount" - "Line Discount Amount";
                if "Allow Invoice Disc." then
                  if QtyType = Qtytype::Invoicing then
                    "Inv. Discount Amount" := "Inv. Disc. Amount to Invoice"
                  else begin
                    TempPurchLineForSpread."Inv. Discount Amount" :=
                      TempPurchLineForSpread."Inv. Discount Amount" +
                      "Inv. Discount Amount" * PurchLineQty / Quantity;
                    "Inv. Discount Amount" :=
                      ROUND(TempPurchLineForSpread."Inv. Discount Amount",Currency."Amount Rounding Precision");
                    TempPurchLineForSpread."Inv. Discount Amount" :=
                      TempPurchLineForSpread."Inv. Discount Amount" - "Inv. Discount Amount";
                  end;
                Amount := "Line Amount" - "Inv. Discount Amount";
                "VAT Base Amount" := Amount;
                "Amount Including VAT" := Amount;
              end;
            end else begin
              TempVATAmountLine.Get(
                "VAT Identifier","VAT Calculation Type","Tax Group Code","Tax Area Code","Use Tax",
                "Line Amount" >= 0);
              if "VAT Calculation Type" = "vat calculation type"::"Sales Tax" then
                "VAT %" := TempVATAmountLine."VAT %";
              TempVATAmountLineRemainder := TempVATAmountLine;
              if not TempVATAmountLineRemainder.Find then begin
                TempVATAmountLineRemainder.Init;
                TempVATAmountLineRemainder.Insert;
              end;
              "Line Amount" := GetLineAmountToHandle(PurchLineQty) + GetPrepmtDiffToLineAmount(PurchLine);
              if PurchLineQty <> Quantity then
                "Line Discount Amount" :=
                  ROUND("Line Discount Amount" * PurchLineQty / Quantity,Currency."Amount Rounding Precision");

              if "Allow Invoice Disc." and (TempVATAmountLine."Inv. Disc. Base Amount" <> 0) then
                if QtyType = Qtytype::Invoicing then
                  "Inv. Discount Amount" := "Inv. Disc. Amount to Invoice"
                else begin
                  TempVATAmountLineRemainder."Invoice Discount Amount" :=
                    TempVATAmountLineRemainder."Invoice Discount Amount" +
                    TempVATAmountLine."Invoice Discount Amount" * "Line Amount" /
                    TempVATAmountLine."Inv. Disc. Base Amount";
                  "Inv. Discount Amount" :=
                    ROUND(
                      TempVATAmountLineRemainder."Invoice Discount Amount",Currency."Amount Rounding Precision");
                  TempVATAmountLineRemainder."Invoice Discount Amount" :=
                    TempVATAmountLineRemainder."Invoice Discount Amount" - "Inv. Discount Amount";
                end;

              if PurchHeader."Prices Including VAT" then begin
                if (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount" = 0) or
                   ("Line Amount" = 0)
                then begin
                  TempVATAmountLineRemainder."VAT Amount" := 0;
                  TempVATAmountLineRemainder."Amount Including VAT" := 0;
                end else begin
                  TempVATAmountLineRemainder."VAT Amount" :=
                    TempVATAmountLineRemainder."VAT Amount" +
                    TempVATAmountLine."VAT Amount" *
                    ("Line Amount" - "Inv. Discount Amount") /
                    (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                  TempVATAmountLineRemainder."Amount Including VAT" :=
                    TempVATAmountLineRemainder."Amount Including VAT" +
                    TempVATAmountLine."Amount Including VAT" *
                    ("Line Amount" - "Inv. Discount Amount") /
                    (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                end;
                if "Line Discount %" <> 100 then
                  "Amount Including VAT" :=
                    ROUND(TempVATAmountLineRemainder."Amount Including VAT",Currency."Amount Rounding Precision")
                else
                  "Amount Including VAT" := 0;
                Amount :=
                  ROUND("Amount Including VAT",Currency."Amount Rounding Precision") -
                  ROUND(TempVATAmountLineRemainder."VAT Amount",Currency."Amount Rounding Precision");
                "VAT Base Amount" :=
                  ROUND(
                    Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                TempVATAmountLineRemainder."Amount Including VAT" :=
                  TempVATAmountLineRemainder."Amount Including VAT" - "Amount Including VAT";
                TempVATAmountLineRemainder."VAT Amount" :=
                  TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
              end else begin
                if "VAT Calculation Type" = "vat calculation type"::"Full VAT" then begin
                  if "Line Discount %" <> 100 then
                    "Amount Including VAT" := "Line Amount" - "Inv. Discount Amount"
                  else
                    "Amount Including VAT" := 0;
                  Amount := 0;
                  "VAT Base Amount" := 0;
                end else begin
                  Amount := "Line Amount" - "Inv. Discount Amount";
                  "VAT Base Amount" :=
                    ROUND(
                      Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                  if TempVATAmountLine."VAT Base" = 0 then
                    TempVATAmountLineRemainder."VAT Amount" := 0
                  else
                    TempVATAmountLineRemainder."VAT Amount" :=
                      TempVATAmountLineRemainder."VAT Amount" +
                      TempVATAmountLine."VAT Amount" *
                      ("Line Amount" - "Inv. Discount Amount") /
                      (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                  if "Line Discount %" <> 100 then
                    "Amount Including VAT" :=
                      Amount + ROUND(TempVATAmountLineRemainder."VAT Amount",Currency."Amount Rounding Precision")
                  else
                    "Amount Including VAT" := 0;
                  TempVATAmountLineRemainder."VAT Amount" :=
                    TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
                end;
              end;

              TempVATAmountLineRemainder.Modify;
            end;
            if "Deferral Code" <> '' then
              CalcDeferralAmounts(PurchHeader,PurchLine,OriginalDeferralAmount);
          end;
    end;

    local procedure RoundAmount(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line";PurchLineQty: Decimal)
    var
        CurrExchRate: Record "Currency Exchange Rate";
        NoVAT: Boolean;
    begin
        with PurchLine do begin
          IncrAmount(PurchHeader,PurchLine,TotalPurchLine);
          Increment(TotalPurchLine."Net Weight",ROUND(PurchLineQty * "Net Weight",0.00001));
          Increment(TotalPurchLine."Gross Weight",ROUND(PurchLineQty * "Gross Weight",0.00001));
          Increment(TotalPurchLine."Unit Volume",ROUND(PurchLineQty * "Unit Volume",0.00001));
          Increment(TotalPurchLine.Quantity,PurchLineQty);
          if "Units per Parcel" > 0 then
            Increment(TotalPurchLine."Units per Parcel",ROUND(PurchLineQty / "Units per Parcel",1,'>'));

          xPurchLine := PurchLine;
          PurchLineACY := PurchLine;
          if PurchHeader."Currency Code" <> '' then begin
            if PurchHeader."Posting Date" = 0D then
              Usedate := WorkDate
            else
              Usedate := PurchHeader."Posting Date";

            NoVAT := Amount = "Amount Including VAT";
            "Amount Including VAT" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  Usedate,PurchHeader."Currency Code",
                  TotalPurchLine."Amount Including VAT",PurchHeader."Currency Factor")) -
              TotalPurchLineLCY."Amount Including VAT";
            if NoVAT then
              Amount := "Amount Including VAT"
            else
              Amount :=
                ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    Usedate,PurchHeader."Currency Code",
                    TotalPurchLine.Amount,PurchHeader."Currency Factor")) -
                TotalPurchLineLCY.Amount;
            "Line Amount" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  Usedate,PurchHeader."Currency Code",
                  TotalPurchLine."Line Amount",PurchHeader."Currency Factor")) -
              TotalPurchLineLCY."Line Amount";
            "Line Discount Amount" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  Usedate,PurchHeader."Currency Code",
                  TotalPurchLine."Line Discount Amount",PurchHeader."Currency Factor")) -
              TotalPurchLineLCY."Line Discount Amount";
            "Inv. Discount Amount" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  Usedate,PurchHeader."Currency Code",
                  TotalPurchLine."Inv. Discount Amount",PurchHeader."Currency Factor")) -
              TotalPurchLineLCY."Inv. Discount Amount";
            "VAT Difference" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  Usedate,PurchHeader."Currency Code",
                  TotalPurchLine."VAT Difference",PurchHeader."Currency Factor")) -
              TotalPurchLineLCY."VAT Difference";
            "Tax To Be Expensed" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  Usedate,PurchHeader."Currency Code",
                  TotalPurchLine."Tax To Be Expensed",PurchHeader."Currency Factor")) -
              TotalPurchLineLCY."Tax To Be Expensed";
          end;

          IncrAmount(PurchHeader,PurchLine,TotalPurchLineLCY);
          Increment(TotalPurchLineLCY."Unit Cost (LCY)",ROUND(PurchLineQty * "Unit Cost (LCY)"));
          SalesTaxExists :=
            (Amount <> "Amount Including VAT") or ("Tax To Be Expensed" <> 0) or SalesTaxExists;
        end;
    end;

    local procedure ReverseAmount(var PurchLine: Record "Purchase Line")
    begin
        with PurchLine do begin
          "Qty. to Receive" := -"Qty. to Receive";
          "Qty. to Receive (Base)" := -"Qty. to Receive (Base)";
          "Return Qty. to Ship" := -"Return Qty. to Ship";
          "Return Qty. to Ship (Base)" := -"Return Qty. to Ship (Base)";
          "Qty. to Invoice" := -"Qty. to Invoice";
          "Qty. to Invoice (Base)" := -"Qty. to Invoice (Base)";
          "Line Amount" := -"Line Amount";
          Amount := -Amount;
          "VAT Base Amount" := -"VAT Base Amount";
          "VAT Difference" := -"VAT Difference";
          "Amount Including VAT" := -"Amount Including VAT";
          "Line Discount Amount" := -"Line Discount Amount";
          "Inv. Discount Amount" := -"Inv. Discount Amount";
          "Salvage Value" := -"Salvage Value";
          "Tax To Be Expensed" := -"Tax To Be Expensed";
        end;
    end;

    local procedure InvoiceRounding(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line";UseTempData: Boolean;BiggestLineNo: Integer)
    var
        VendPostingGr: Record "Vendor Posting Group";
        TempPurchLineForCalc: Record "Purchase Line" temporary;
        InvoiceRoundingAmount: Decimal;
    begin
        Currency.TestField("Invoice Rounding Precision");
        InvoiceRoundingAmount :=
          -ROUND(
            TotalPurchLine."Amount Including VAT" -
            ROUND(
              TotalPurchLine."Amount Including VAT",
              Currency."Invoice Rounding Precision",
              Currency.InvoiceRoundingDirection),
            Currency."Amount Rounding Precision");
        if InvoiceRoundingAmount <> 0 then begin
          VendPostingGr.Get(PurchHeader."Vendor Posting Group");
          VendPostingGr.TestField("Invoice Rounding Account");
          with PurchLine do begin
            Init;
            BiggestLineNo := BiggestLineNo + 10000;
            "System-Created Entry" := true;
            if UseTempData then begin
              "Line No." := 0;
              Type := Type::"G/L Account";
              TempPurchLineForCalc := PurchLine;
              TempPurchLineForCalc.Validate("No.",VendPostingGr."Invoice Rounding Account");
              PurchLine := TempPurchLineForCalc;
            end else begin
              "Line No." := BiggestLineNo;
              Validate(Type,Type::"G/L Account");
              Validate("No.",VendPostingGr."Invoice Rounding Account");
            end;
            "Tax Area Code" := '';
            "Tax Liable" := false;
            Validate(Quantity,1);
            if IsCreditDocType then
              Validate("Return Qty. to Ship",Quantity)
            else
              Validate("Qty. to Receive",Quantity);
            if PurchHeader."Prices Including VAT" then
              Validate("Direct Unit Cost",InvoiceRoundingAmount)
            else
              Validate(
                "Direct Unit Cost",
                ROUND(
                  InvoiceRoundingAmount /
                  (1 + (1 - PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                  Currency."Amount Rounding Precision"));
            Validate("Amount Including VAT",InvoiceRoundingAmount);
            "Line No." := BiggestLineNo;
            LastLineRetrieved := false;
            RoundingLineInserted := true;
            RoundingLineNo := "Line No.";
          end;
        end;
    end;

    local procedure IncrAmount(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";var TotalPurchLine: Record "Purchase Line")
    begin
        with PurchLine do begin
          if PurchHeader."Prices Including VAT" or
             ("VAT Calculation Type" <> "vat calculation type"::"Full VAT")
          then
            Increment(TotalPurchLine."Line Amount","Line Amount");
          Increment(TotalPurchLine.Amount,Amount);
          Increment(TotalPurchLine."VAT Base Amount","VAT Base Amount");
          Increment(TotalPurchLine."VAT Difference","VAT Difference");
          Increment(TotalPurchLine."Amount Including VAT","Amount Including VAT");
          Increment(TotalPurchLine."Line Discount Amount","Line Discount Amount");
          Increment(TotalPurchLine."Inv. Discount Amount","Inv. Discount Amount");
          Increment(TotalPurchLine."Inv. Disc. Amount to Invoice","Inv. Disc. Amount to Invoice");
          Increment(TotalPurchLine."Prepmt. Line Amount","Prepmt. Line Amount");
          Increment(TotalPurchLine."Prepmt. Amt. Inv.","Prepmt. Amt. Inv.");
          Increment(TotalPurchLine."Prepmt Amt to Deduct","Prepmt Amt to Deduct");
          Increment(TotalPurchLine."Prepmt Amt Deducted","Prepmt Amt Deducted");
          Increment(TotalPurchLine."Prepayment VAT Difference","Prepayment VAT Difference");
          Increment(TotalPurchLine."Prepmt VAT Diff. to Deduct","Prepmt VAT Diff. to Deduct");
          Increment(TotalPurchLine."Prepmt VAT Diff. Deducted","Prepmt VAT Diff. Deducted");
          Increment(TotalPurchLine."Tax To Be Expensed","Tax To Be Expensed");
        end;
    end;

    local procedure Increment(var Number: Decimal;Number2: Decimal)
    begin
        Number := Number + Number2;
    end;


    procedure GetPurchLines(var PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line";QtyType: Option General,Invoicing,Shipping)
    var
        OldPurchLine: Record "Purchase Line";
        MergedPurchLines: Record "Purchase Line" temporary;
    begin
        if QtyType = Qtytype::Invoicing then begin
          CreatePrepmtLines(PurchHeader,TempPrepmtPurchLine,false);
          MergePurchLines(PurchHeader,OldPurchLine,TempPrepmtPurchLine,MergedPurchLines);
          SumPurchLines2(PurchHeader,PurchLine,MergedPurchLines,QtyType,true);
        end else
          SumPurchLines2(PurchHeader,PurchLine,OldPurchLine,QtyType,true);
    end;


    procedure SumPurchLines(var NewPurchHeader: Record "Purchase Header";QtyType: Option General,Invoicing,Shipping;var NewTotalPurchLine: Record "Purchase Line";var NewTotalPurchLineLCY: Record "Purchase Line";var VATAmount: Decimal;var VATAmountText: Text[30])
    var
        OldPurchLine: Record "Purchase Line";
    begin
        SumPurchLinesTemp(
          NewPurchHeader,OldPurchLine,QtyType,NewTotalPurchLine,NewTotalPurchLineLCY,
          VATAmount,VATAmountText);
    end;


    procedure SumPurchLinesTemp(var PurchHeader: Record "Purchase Header";var OldPurchLine: Record "Purchase Line";QtyType: Option General,Invoicing,Shipping;var NewTotalPurchLine: Record "Purchase Line";var NewTotalPurchLineLCY: Record "Purchase Line";var VATAmount: Decimal;var VATAmountText: Text[30])
    var
        PurchLine: Record "Purchase Line";
    begin
        with PurchHeader do begin
          SumPurchLines2(PurchHeader,PurchLine,OldPurchLine,QtyType,false);
          VATAmount := TotalPurchLine."Amount Including VAT" - TotalPurchLine.Amount;
          if TotalPurchLine."VAT %" = 0 then
            VATAmountText := VATAmountTxt
          else
            VATAmountText := StrSubstNo(VATRateTxt,TotalPurchLine."VAT %");
          NewTotalPurchLine := TotalPurchLine;
          NewTotalPurchLineLCY := TotalPurchLineLCY;
        end;
    end;

    local procedure SumPurchLines2(PurchHeader: Record "Purchase Header";var NewPurchLine: Record "Purchase Line";var OldPurchLine: Record "Purchase Line";QtyType: Option General,Invoicing,Shipping;InsertPurchLine: Boolean)
    var
        PurchLine: Record "Purchase Line";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        PurchLineQty: Decimal;
        BiggestLineNo: Integer;
    begin
        TempVATAmountLineRemainder.DeleteAll;
        OldPurchLine.CalcVATAmountLines(QtyType,PurchHeader,OldPurchLine,TempVATAmountLine);
        with PurchHeader do begin
          GetGLSetup;
          PurchSetup.Get;
          GetCurrency("Currency Code");
          OldPurchLine.SetRange("Document Type","Document Type");
          OldPurchLine.SetRange("Document No.","No.");
          RoundingLineInserted := false;
          if OldPurchLine.FindSet then
            repeat
              if not RoundingLineInserted then
                PurchLine := OldPurchLine;
              case QtyType of
                Qtytype::General:
                  PurchLineQty := PurchLine.Quantity;
                Qtytype::Invoicing:
                  PurchLineQty := PurchLine."Qty. to Invoice";
                Qtytype::Shipping:
                  begin
                    if IsCreditDocType then
                      PurchLineQty := PurchLine."Return Qty. to Ship"
                    else
                      PurchLineQty := PurchLine."Qty. to Receive"
                  end;
              end;
              DivideAmount(PurchHeader,PurchLine,QtyType,PurchLineQty,TempVATAmountLine,TempVATAmountLineRemainder);
              PurchLine.Quantity := PurchLineQty;
              if PurchLineQty <> 0 then begin
                if (PurchLine.Amount <> 0) and not RoundingLineInserted then
                  if TotalPurchLine.Amount = 0 then
                    TotalPurchLine."VAT %" := PurchLine."VAT %"
                  else
                    if TotalPurchLine."VAT %" <> PurchLine."VAT %" then
                      TotalPurchLine."VAT %" := 0;
                RoundAmount(PurchHeader,PurchLine,PurchLineQty);
                PurchLine := xPurchLine;
              end;
              if InsertPurchLine then begin
                NewPurchLine := PurchLine;
                NewPurchLine.Insert;
              end;
              if RoundingLineInserted then
                LastLineRetrieved := true
              else begin
                BiggestLineNo := MAX(BiggestLineNo,OldPurchLine."Line No.");
                LastLineRetrieved := OldPurchLine.Next = 0;
                if LastLineRetrieved and PurchSetup."Invoice Rounding" then
                  InvoiceRounding(PurchHeader,PurchLine,true,BiggestLineNo);
              end;
            until LastLineRetrieved;
        end;
    end;


    procedure UpdateBlanketOrderLine(PurchLine: Record "Purchase Line";Receive: Boolean;Ship: Boolean;Invoice: Boolean)
    var
        BlanketOrderPurchLine: Record "Purchase Line";
        ModifyLine: Boolean;
        Sign: Decimal;
    begin
        if (PurchLine."Blanket Order No." <> '') and (PurchLine."Blanket Order Line No." <> 0) and
           ((Receive and (PurchLine."Qty. to Receive" <> 0)) or
            (Ship and (PurchLine."Return Qty. to Ship" <> 0)) or
            (Invoice and (PurchLine."Qty. to Invoice" <> 0)))
        then
          if BlanketOrderPurchLine.Get(
               BlanketOrderPurchLine."document type"::"Blanket Order",PurchLine."Blanket Order No.",
               PurchLine."Blanket Order Line No.")
          then begin
            BlanketOrderPurchLine.TestField(Type,PurchLine.Type);
            BlanketOrderPurchLine.TestField("No.",PurchLine."No.");
            BlanketOrderPurchLine.TestField("Buy-from Vendor No.",PurchLine."Buy-from Vendor No.");

            ModifyLine := false;
            case PurchLine."Document Type" of
              PurchLine."document type"::Order,
              PurchLine."document type"::Invoice:
                Sign := 1;
              PurchLine."document type"::"Return Order",
              PurchLine."document type"::"Credit Memo":
                Sign := -1;
            end;
            if Receive and (PurchLine."Receipt No." = '') then begin
              if BlanketOrderPurchLine."Qty. per Unit of Measure" =
                 PurchLine."Qty. per Unit of Measure"
              then
                BlanketOrderPurchLine."Quantity Received" :=
                  BlanketOrderPurchLine."Quantity Received" + Sign * PurchLine."Qty. to Receive"
              else
                BlanketOrderPurchLine."Quantity Received" :=
                  BlanketOrderPurchLine."Quantity Received" +
                  Sign *
                  ROUND(
                    (PurchLine."Qty. per Unit of Measure" /
                     BlanketOrderPurchLine."Qty. per Unit of Measure") *
                    PurchLine."Qty. to Receive",0.00001);
              BlanketOrderPurchLine."Qty. Received (Base)" :=
                BlanketOrderPurchLine."Qty. Received (Base)" + Sign * PurchLine."Qty. to Receive (Base)";
              ModifyLine := true;
            end;
            if Ship and (PurchLine."Return Shipment No." = '') then begin
              if BlanketOrderPurchLine."Qty. per Unit of Measure" =
                 PurchLine."Qty. per Unit of Measure"
              then
                BlanketOrderPurchLine."Quantity Received" :=
                  BlanketOrderPurchLine."Quantity Received" + Sign * PurchLine."Return Qty. to Ship"
              else
                BlanketOrderPurchLine."Quantity Received" :=
                  BlanketOrderPurchLine."Quantity Received" +
                  Sign *
                  ROUND(
                    (PurchLine."Qty. per Unit of Measure" /
                     BlanketOrderPurchLine."Qty. per Unit of Measure") *
                    PurchLine."Return Qty. to Ship",0.00001);
              BlanketOrderPurchLine."Qty. Received (Base)" :=
                BlanketOrderPurchLine."Qty. Received (Base)" + Sign * PurchLine."Return Qty. to Ship (Base)";
              ModifyLine := true;
            end;

            if Invoice then begin
              if BlanketOrderPurchLine."Qty. per Unit of Measure" =
                 PurchLine."Qty. per Unit of Measure"
              then
                BlanketOrderPurchLine."Quantity Invoiced" :=
                  BlanketOrderPurchLine."Quantity Invoiced" + Sign * PurchLine."Qty. to Invoice"
              else
                BlanketOrderPurchLine."Quantity Invoiced" :=
                  BlanketOrderPurchLine."Quantity Invoiced" +
                  Sign *
                  ROUND(
                    (PurchLine."Qty. per Unit of Measure" /
                     BlanketOrderPurchLine."Qty. per Unit of Measure") *
                    PurchLine."Qty. to Invoice",0.00001);
              BlanketOrderPurchLine."Qty. Invoiced (Base)" :=
                BlanketOrderPurchLine."Qty. Invoiced (Base)" + Sign * PurchLine."Qty. to Invoice (Base)";
              ModifyLine := true;
            end;

            if ModifyLine then begin
              BlanketOrderPurchLine.InitOutstanding;

              if (BlanketOrderPurchLine.Quantity * BlanketOrderPurchLine."Quantity Received" < 0) or
                 (Abs(BlanketOrderPurchLine.Quantity) < Abs(BlanketOrderPurchLine."Quantity Received"))
              then
                BlanketOrderPurchLine.FieldError(
                  "Quantity Received",
                  StrSubstNo(
                    BlanketOrderQuantityGreaterThanErr,
                    BlanketOrderPurchLine.FieldCaption(Quantity)));

              if (BlanketOrderPurchLine."Quantity (Base)" *
                  BlanketOrderPurchLine."Qty. Received (Base)" < 0) or
                 (Abs(BlanketOrderPurchLine."Quantity (Base)") <
                  Abs(BlanketOrderPurchLine."Qty. Received (Base)"))
              then
                BlanketOrderPurchLine.FieldError(
                  "Qty. Received (Base)",
                  StrSubstNo(
                    BlanketOrderQuantityGreaterThanErr,
                    BlanketOrderPurchLine.FieldCaption("Quantity Received")));

              BlanketOrderPurchLine.CalcFields("Reserved Qty. (Base)");
              if Abs(BlanketOrderPurchLine."Outstanding Qty. (Base)") <
                 Abs(BlanketOrderPurchLine."Reserved Qty. (Base)")
              then
                BlanketOrderPurchLine.FieldError(
                  "Reserved Qty. (Base)",BlanketOrderQuantityReducedErr);

              BlanketOrderPurchLine."Qty. to Invoice" :=
                BlanketOrderPurchLine.Quantity - BlanketOrderPurchLine."Quantity Invoiced";
              BlanketOrderPurchLine."Qty. to Receive" :=
                BlanketOrderPurchLine.Quantity - BlanketOrderPurchLine."Quantity Received";
              BlanketOrderPurchLine."Qty. to Invoice (Base)" :=
                BlanketOrderPurchLine."Quantity (Base)" - BlanketOrderPurchLine."Qty. Invoiced (Base)";
              BlanketOrderPurchLine."Qty. to Receive (Base)" :=
                BlanketOrderPurchLine."Quantity (Base)" - BlanketOrderPurchLine."Qty. Received (Base)";

              BlanketOrderPurchLine.Modify;
            end;
          end;
    end;

    local procedure UpdatePurchaseHeader(VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        case GenJnlLineDocType of
          GenJnlLine."document type"::Invoice:
            begin
              FindVendorLedgerEntry(GenJnlLineDocType,GenJnlLineDocNo,VendorLedgerEntry);
              PurchInvHeader."Vendor Ledger Entry No." := VendorLedgerEntry."Entry No.";
              PurchInvHeader.Modify;
            end;
          GenJnlLine."document type"::"Credit Memo":
            begin
              FindVendorLedgerEntry(GenJnlLineDocType,GenJnlLineDocNo,VendorLedgerEntry);
              PurchCrMemoHeader."Vendor Ledger Entry No." := VendorLedgerEntry."Entry No.";
              PurchCrMemoHeader.Modify;
            end;
        end;
    end;

    local procedure PostVendorEntry(PurchHeader: Record "Purchase Header";TotalPurchLine2: Record "Purchase Line";TotalPurchLineLCY2: Record "Purchase Line";DocType: Option;DocNo: Code[20];ExtDocNo: Code[35];SourceCode: Code[10])
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        with GenJnlLine do begin
          InitNewLine(
            PurchHeader."Posting Date",PurchHeader."Document Date",PurchHeader."Posting Description",
            PurchHeader."Shortcut Dimension 1 Code",PurchHeader."Shortcut Dimension 2 Code",
            PurchHeader."Dimension Set ID",PurchHeader."Reason Code");

          CopyDocumentFields(DocType,DocNo,ExtDocNo,SourceCode,'');
          "Account Type" := "account type"::Vendor;
          "Account No." := PurchHeader."Pay-to Vendor No.";
          CopyFromPurchHeader(PurchHeader);
          SetCurrencyFactor(PurchHeader."Currency Code",PurchHeader."Currency Factor");
          "System-Created Entry" := true;

          CopyFromPurchHeaderApplyTo(PurchHeader);
          CopyFromPurchHeaderPayment(PurchHeader);

          Amount := -TotalPurchLine2."Amount Including VAT";
          "Source Currency Amount" := -TotalPurchLine2."Amount Including VAT";
          "Amount (LCY)" := -TotalPurchLineLCY2."Amount Including VAT";
          "Sales/Purch. (LCY)" := -TotalPurchLineLCY2.Amount;
          "Inv. Discount (LCY)" := -TotalPurchLineLCY2."Inv. Discount Amount";
          if PurchHeader."IRS 1099 Code" <> '' then begin
            "IRS 1099 Code" := PurchHeader."IRS 1099 Code";
            "IRS 1099 Amount" := -ROUND(TotalAmount1099);
          end;

          GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;
    end;

    local procedure PostBalancingEntry(PurchHeader: Record "Purchase Header";TotalPurchLine2: Record "Purchase Line";TotalPurchLineLCY2: Record "Purchase Line";DocType: Option;DocNo: Code[20];ExtDocNo: Code[35];SourceCode: Code[10])
    var
        GenJnlLine: Record "Gen. Journal Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        FindVendorLedgerEntry(DocType,DocNo,VendLedgEntry);

        with GenJnlLine do begin
          InitNewLine(
            PurchHeader."Posting Date",PurchHeader."Document Date",PurchHeader."Posting Description",
            PurchHeader."Shortcut Dimension 1 Code",PurchHeader."Shortcut Dimension 2 Code",
            PurchHeader."Dimension Set ID",PurchHeader."Reason Code");

          CopyDocumentFields(0,DocNo,ExtDocNo,SourceCode,'');
          CopyFromPurchHeader(PurchHeader);
          "Account Type" := "account type"::Vendor;
          "Account No." := PurchHeader."Pay-to Vendor No.";
          SetCurrencyFactor(PurchHeader."Currency Code",PurchHeader."Currency Factor");

          if PurchHeader.IsCreditDocType then
            "Document Type" := "document type"::Refund
          else
            "Document Type" := "document type"::Payment;

          SetApplyToDocNo(PurchHeader,GenJnlLine,DocType,DocNo);

          Amount := TotalPurchLine2."Amount Including VAT" + VendLedgEntry."Remaining Pmt. Disc. Possible";
          "Source Currency Amount" := Amount;
          VendLedgEntry.CalcFields(Amount);
          if VendLedgEntry.Amount = 0 then
            "Amount (LCY)" := TotalPurchLineLCY2."Amount Including VAT"
          else
            "Amount (LCY)" :=
              TotalPurchLineLCY2."Amount Including VAT" +
              ROUND(VendLedgEntry."Remaining Pmt. Disc. Possible" / VendLedgEntry."Adjusted Currency Factor");
          "Allow Zero-Amount Posting" := true;

          GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;
    end;

    local procedure SetApplyToDocNo(PurchHeader: Record "Purchase Header";var GenJnlLine: Record "Gen. Journal Line";DocType: Option;DocNo: Code[20])
    begin
        with GenJnlLine do begin
          if PurchHeader."Bal. Account Type" = PurchHeader."bal. account type"::"Bank Account" then
            "Bal. Account Type" := "bal. account type"::"Bank Account";
          "Bal. Account No." := PurchHeader."Bal. Account No.";
          "Applies-to Doc. Type" := DocType;
          "Applies-to Doc. No." := DocNo;
        end;
    end;

    local procedure FindVendorLedgerEntry(DocType: Option;DocNo: Code[20];var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        VendorLedgerEntry.SetRange("Document Type",DocType);
        VendorLedgerEntry.SetRange("Document No.",DocNo);
        VendorLedgerEntry.FindLast;
    end;

    local procedure CopyCommentLines(FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
    var
        PurchCommentLine: Record "Purch. Comment Line";
        PurchCommentLine2: Record "Purch. Comment Line";
    begin
        PurchCommentLine.SetRange("Document Type",FromDocumentType);
        PurchCommentLine.SetRange("No.",FromNumber);
        if PurchCommentLine.FindSet then
          repeat
            PurchCommentLine2 := PurchCommentLine;
            PurchCommentLine2."Document Type" := ToDocumentType;
            PurchCommentLine2."No." := ToNumber;
            PurchCommentLine2.Insert;
          until PurchCommentLine.Next = 0;
    end;

    local procedure RunGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"): Integer
    begin
        exit(GenJnlPostLine.RunWithCheck(GenJnlLine));
    end;

    local procedure CheckPostRestrictions(PurchaseHeader: Record "Purchase Header")
    var
        Vendor: Record Vendor;
    begin
        if not PreviewMode then
          PurchaseHeader.OnCheckPurchasePostRestrictions;

        Vendor.Get(PurchaseHeader."Buy-from Vendor No.");
        Vendor.CheckBlockedVendOnDocs(Vendor,true);
        if PurchaseHeader."Pay-to Vendor No." <> PurchaseHeader."Buy-from Vendor No." then begin
          Vendor.Get(PurchaseHeader."Pay-to Vendor No.");
          Vendor.CheckBlockedVendOnDocs(Vendor,true);
        end;
    end;

    local procedure CheckDim(PurchHeader: Record "Purchase Header")
    begin
        CheckDimCombHeader(PurchHeader);
        CheckDimValuePostingHeader(PurchHeader);
        CheckDimLines(PurchHeader);
    end;

    local procedure CheckDimCombHeader(PurchHeader: Record "Purchase Header")
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        with PurchHeader do
          if not DimMgt.CheckDimIDComb("Dimension Set ID") then
            Error(DimensionIsBlockedErr,"Document Type","No.",DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimCombLine(PurchLine: Record "Purchase Line")
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        with PurchLine do
          if not DimMgt.CheckDimIDComb("Dimension Set ID") then
            Error(LineDimensionBlockedErr,"Document Type","Document No.","Line No.",DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimLines(PurchHeader: Record "Purchase Header")
    var
        TempPurchLine: Record "Purchase Line" temporary;
    begin
        with TempPurchLine do begin
          ResetTempLines(TempPurchLine);
          SetFilter(Type,'<>%1',Type::" ");
          if FindSet then
            repeat
              if (PurchHeader.Receive and ("Qty. to Receive" <> 0)) or
                 (PurchHeader.Invoice and ("Qty. to Invoice" <> 0)) or
                 (PurchHeader.Ship and ("Return Qty. to Ship" <> 0))
              then begin
                CheckDimCombLine(TempPurchLine);
                CheckDimValuePostingLine(TempPurchLine);
              end
            until Next = 0;
        end;
    end;

    local procedure CheckDimValuePostingHeader(PurchHeader: Record "Purchase Header")
    var
        DimMgt: Codeunit DimensionManagement;
        TableIDArr: array [10] of Integer;
        NumberArr: array [10] of Code[20];
    begin
        with PurchHeader do begin
          TableIDArr[1] := Database::Vendor;
          NumberArr[1] := "Pay-to Vendor No.";
          TableIDArr[2] := Database::"Salesperson/Purchaser";
          NumberArr[2] := "Purchaser Code";
          TableIDArr[3] := Database::Campaign;
          NumberArr[3] := "Campaign No.";
          TableIDArr[4] := Database::"Responsibility Center";
          NumberArr[4] := "Responsibility Center";
          if not DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,"Dimension Set ID") then
            Error(InvalidDimensionsErr,"Document Type","No.",DimMgt.GetDimValuePostingErr);
        end;
    end;

    local procedure CheckDimValuePostingLine(PurchLine: Record "Purchase Line")
    var
        DimMgt: Codeunit DimensionManagement;
        TableIDArr: array [10] of Integer;
        NumberArr: array [10] of Code[20];
    begin
        with PurchLine do begin
          TableIDArr[1] := DimMgt.TypeToTableID3(Type);
          NumberArr[1] := "No.";
          TableIDArr[2] := Database::Job;
          NumberArr[2] := "Job No.";
          TableIDArr[3] := Database::"Work Center";
          NumberArr[3] := "Work Center No.";
          if not DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,"Dimension Set ID") then
            Error(LineInvalidDimensionsErr,"Document Type","Document No.","Line No.",DimMgt.GetDimValuePostingErr);
        end;
    end;

    local procedure DeleteItemChargeAssgnt(PurchHeader: Record "Purchase Header")
    var
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
    begin
        ItemChargeAssgntPurch.SetRange("Document Type",PurchHeader."Document Type");
        ItemChargeAssgntPurch.SetRange("Document No.",PurchHeader."No.");
        if not ItemChargeAssgntPurch.IsEmpty then
          ItemChargeAssgntPurch.DeleteAll;
    end;

    local procedure UpdateItemChargeAssgnt()
    var
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
    begin
        with TempItemChargeAssgntPurch do begin
          ClearItemChargeAssgntFilter;
          MarkedOnly(true);
          if FindSet then
            repeat
              ItemChargeAssgntPurch.Get("Document Type","Document No.","Document Line No.","Line No.");
              ItemChargeAssgntPurch."Qty. Assigned" :=
                ItemChargeAssgntPurch."Qty. Assigned" + "Qty. to Assign";
              ItemChargeAssgntPurch."Qty. to Assign" := 0;
              ItemChargeAssgntPurch."Amount to Assign" := 0;
              ItemChargeAssgntPurch.Modify;
            until Next = 0;
        end;
    end;

    local procedure UpdatePurchOrderChargeAssgnt(PurchOrderInvLine: Record "Purchase Line";PurchOrderLine: Record "Purchase Line")
    var
        PurchOrderLine2: Record "Purchase Line";
        PurchOrderInvLine2: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ReturnShptLine: Record "Return Shipment Line";
    begin
        with PurchOrderInvLine do begin
          ClearItemChargeAssgntFilter;
          TempItemChargeAssgntPurch.SetRange("Document Type","Document Type");
          TempItemChargeAssgntPurch.SetRange("Document No.","Document No.");
          TempItemChargeAssgntPurch.SetRange("Document Line No.","Line No.");
          TempItemChargeAssgntPurch.MarkedOnly(true);
          if TempItemChargeAssgntPurch.FindSet then
            repeat
              if TempItemChargeAssgntPurch."Applies-to Doc. Type" = "Document Type" then begin
                PurchOrderInvLine2.Get(
                  TempItemChargeAssgntPurch."Applies-to Doc. Type",
                  TempItemChargeAssgntPurch."Applies-to Doc. No.",
                  TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
                if ((PurchOrderLine."Document Type" = PurchOrderLine."document type"::Order) and
                    (PurchOrderInvLine2."Receipt No." = "Receipt No.")) or
                   ((PurchOrderLine."Document Type" = PurchOrderLine."document type"::"Return Order") and
                    (PurchOrderInvLine2."Return Shipment No." = "Return Shipment No."))
                then begin
                  if PurchOrderLine."Document Type" in ["document type"::Order,"document type"::Invoice] then begin
                    if not
                       PurchRcptLine.Get(PurchOrderInvLine2."Receipt No.",PurchOrderInvLine2."Receipt Line No.")
                    then
                      Error(ReceiptLinesDeletedErr);
                    PurchOrderLine2.Get(
                      PurchOrderLine2."document type"::Order,
                      PurchRcptLine."Order No.",PurchRcptLine."Order Line No.");
                  end else begin
                    if not
                       ReturnShptLine.Get(PurchOrderInvLine2."Return Shipment No.",PurchOrderInvLine2."Return Shipment Line No.")
                    then
                      Error(ReturnShipmentLinesDeletedErr);
                    PurchOrderLine2.Get(
                      PurchOrderLine2."document type"::"Return Order",
                      ReturnShptLine."Return Order No.",ReturnShptLine."Return Order Line No.");
                  end;
                  UpdatePurchChargeAssgntLines(
                    PurchOrderLine,
                    PurchOrderLine2."Document Type",
                    PurchOrderLine2."Document No.",
                    PurchOrderLine2."Line No.",
                    TempItemChargeAssgntPurch."Qty. to Assign");
                end;
              end else
                UpdatePurchChargeAssgntLines(
                  PurchOrderLine,
                  TempItemChargeAssgntPurch."Applies-to Doc. Type",
                  TempItemChargeAssgntPurch."Applies-to Doc. No.",
                  TempItemChargeAssgntPurch."Applies-to Doc. Line No.",
                  TempItemChargeAssgntPurch."Qty. to Assign");
            until TempItemChargeAssgntPurch.Next = 0;
        end;
    end;

    local procedure UpdatePurchChargeAssgntLines(PurchOrderLine: Record "Purchase Line";ApplToDocType: Option;ApplToDocNo: Code[20];ApplToDocLineNo: Integer;QtytoAssign: Decimal)
    var
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        TempItemChargeAssgntPurch2: Record "Item Charge Assignment (Purch)";
        LastLineNo: Integer;
        TotalToAssign: Decimal;
    begin
        ItemChargeAssgntPurch.SetRange("Document Type",PurchOrderLine."Document Type");
        ItemChargeAssgntPurch.SetRange("Document No.",PurchOrderLine."Document No.");
        ItemChargeAssgntPurch.SetRange("Document Line No.",PurchOrderLine."Line No.");
        ItemChargeAssgntPurch.SetRange("Applies-to Doc. Type",ApplToDocType);
        ItemChargeAssgntPurch.SetRange("Applies-to Doc. No.",ApplToDocNo);
        ItemChargeAssgntPurch.SetRange("Applies-to Doc. Line No.",ApplToDocLineNo);
        if ItemChargeAssgntPurch.FindFirst then begin
          ItemChargeAssgntPurch."Qty. Assigned" :=
            ItemChargeAssgntPurch."Qty. Assigned" + QtytoAssign;
          ItemChargeAssgntPurch."Qty. to Assign" := 0;
          ItemChargeAssgntPurch."Amount to Assign" := 0;
          ItemChargeAssgntPurch.Modify;
        end else begin
          ItemChargeAssgntPurch.SetRange("Applies-to Doc. Type");
          ItemChargeAssgntPurch.SetRange("Applies-to Doc. No.");
          ItemChargeAssgntPurch.SetRange("Applies-to Doc. Line No.");
          ItemChargeAssgntPurch.CalcSums("Qty. to Assign");

          TempItemChargeAssgntPurch2.SetRange("Document Type",TempItemChargeAssgntPurch."Document Type");
          TempItemChargeAssgntPurch2.SetRange("Document No.",TempItemChargeAssgntPurch."Document No.");
          TempItemChargeAssgntPurch2.SetRange("Document Line No.",TempItemChargeAssgntPurch."Document Line No.");
          TempItemChargeAssgntPurch2.CalcSums("Qty. to Assign");

          TotalToAssign := ItemChargeAssgntPurch."Qty. to Assign" +
            TempItemChargeAssgntPurch2."Qty. to Assign";

          if ItemChargeAssgntPurch.FindLast then
            LastLineNo := ItemChargeAssgntPurch."Line No.";

          if PurchOrderLine.Quantity < TotalToAssign then
            repeat
              TotalToAssign := TotalToAssign - ItemChargeAssgntPurch."Qty. to Assign";
              ItemChargeAssgntPurch."Qty. to Assign" := 0;
              ItemChargeAssgntPurch."Amount to Assign" := 0;
              ItemChargeAssgntPurch.Modify;
            until (ItemChargeAssgntPurch.Next(-1) = 0) or
                  (TotalToAssign = PurchOrderLine.Quantity);

          InsertAssocOrderCharge(
            PurchOrderLine,
            ApplToDocType,
            ApplToDocNo,
            ApplToDocLineNo,
            LastLineNo,
            TempItemChargeAssgntPurch."Applies-to Doc. Line Amount");
        end;
    end;

    local procedure InsertAssocOrderCharge(PurchOrderLine: Record "Purchase Line";ApplToDocType: Option;ApplToDocNo: Code[20];ApplToDocLineNo: Integer;LastLineNo: Integer;ApplToDocLineAmt: Decimal)
    var
        NewItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
    begin
        with NewItemChargeAssgntPurch do begin
          Init;
          "Document Type" := PurchOrderLine."Document Type";
          "Document No." := PurchOrderLine."Document No.";
          "Document Line No." := PurchOrderLine."Line No.";
          "Line No." := LastLineNo + 10000;
          "Item Charge No." := TempItemChargeAssgntPurch."Item Charge No.";
          "Item No." := TempItemChargeAssgntPurch."Item No.";
          "Qty. Assigned" := TempItemChargeAssgntPurch."Qty. to Assign";
          "Qty. to Assign" := 0;
          "Amount to Assign" := 0;
          Description := TempItemChargeAssgntPurch.Description;
          "Unit Cost" := TempItemChargeAssgntPurch."Unit Cost";
          "Applies-to Doc. Type" := ApplToDocType;
          "Applies-to Doc. No." := ApplToDocNo;
          "Applies-to Doc. Line No." := ApplToDocLineNo;
          "Applies-to Doc. Line Amount" := ApplToDocLineAmt;
          Insert;
        end;
    end;

    local procedure CopyAndCheckItemCharge(PurchHeader: Record "Purchase Header")
    var
        TempPurchLine: Record "Purchase Line" temporary;
        PurchLine: Record "Purchase Line";
        InvoiceEverything: Boolean;
        AssignError: Boolean;
        QtyNeeded: Decimal;
    begin
        TempItemChargeAssgntPurch.Reset;
        TempItemChargeAssgntPurch.DeleteAll;

        // Check for max qty posting
        with TempPurchLine do begin
          ResetTempLines(TempPurchLine);
          SetRange(Type,Type::"Charge (Item)");
          if IsEmpty then
            exit;

          ItemChargeAssgntPurch.Reset;
          ItemChargeAssgntPurch.SetRange("Document Type","Document Type");
          ItemChargeAssgntPurch.SetRange("Document No.","Document No.");
          ItemChargeAssgntPurch.SetFilter("Qty. to Assign",'<>0');
          if ItemChargeAssgntPurch.FindSet then
            repeat
              TempItemChargeAssgntPurch.Init;
              TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
              TempItemChargeAssgntPurch.Insert;
            until ItemChargeAssgntPurch.Next = 0;

          SetFilter("Qty. to Invoice",'<>0');
          if FindSet then
            repeat
              TestField("Job No.",'');
              if PurchHeader.Invoice and
                 ("Qty. to Receive" + "Return Qty. to Ship" <> 0) and
                 ((PurchHeader.Ship or PurchHeader.Receive) or
                  (Abs("Qty. to Invoice") >
                   Abs("Qty. Rcd. Not Invoiced" + "Qty. to Receive") +
                   Abs("Ret. Qty. Shpd Not Invd.(Base)" + "Return Qty. to Ship")))
              then
                TestField("Line Amount");

              if not PurchHeader.Receive then
                "Qty. to Receive" := 0;
              if not PurchHeader.Ship then
                "Return Qty. to Ship" := 0;
              if Abs("Qty. to Invoice") >
                 Abs("Quantity Received" + "Qty. to Receive" +
                   "Return Qty. Shipped" + "Return Qty. to Ship" -
                   "Quantity Invoiced")
              then
                "Qty. to Invoice" :=
                  "Quantity Received" + "Qty. to Receive" +
                  "Return Qty. Shipped (Base)" + "Return Qty. to Ship (Base)" -
                  "Quantity Invoiced";

              CalcFields("Qty. to Assign","Qty. Assigned");
              if Abs("Qty. to Assign" + "Qty. Assigned") >
                 Abs("Qty. to Invoice" + "Quantity Invoiced")
              then
                Error(CannotAssignMoreErr,
                  "Qty. to Invoice" + "Quantity Invoiced" - "Qty. Assigned",
                  FieldCaption("Document Type"),"Document Type",
                  FieldCaption("Document No."),"Document No.",
                  FieldCaption("Line No."),"Line No.");
              if Quantity = "Qty. to Invoice" + "Quantity Invoiced" then begin
                if "Qty. to Assign" <> 0 then
                  if Quantity = "Quantity Invoiced" then begin
                    TempItemChargeAssgntPurch.SetRange("Document Line No.","Line No.");
                    TempItemChargeAssgntPurch.SetRange("Applies-to Doc. Type","Document Type");
                    if TempItemChargeAssgntPurch.FindSet then
                      repeat
                        PurchLine.Get(
                          TempItemChargeAssgntPurch."Applies-to Doc. Type",
                          TempItemChargeAssgntPurch."Applies-to Doc. No.",
                          TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
                        if PurchLine.Quantity = PurchLine."Quantity Invoiced" then
                          Error(CannotAssignInvoicedErr,PurchLine.TableCaption,
                            PurchLine.FieldCaption("Document Type"),PurchLine."Document Type",
                            PurchLine.FieldCaption("Document No."),PurchLine."Document No.",
                            PurchLine.FieldCaption("Line No."),PurchLine."Line No.");
                      until TempItemChargeAssgntPurch.Next = 0;
                  end;
                if Quantity <> "Qty. to Assign" + "Qty. Assigned" then
                  AssignError := true;
              end;

              if ("Qty. to Assign" + "Qty. Assigned") < ("Qty. to Invoice" + "Quantity Invoiced") then
                Error(MustAssignItemChargeErr,"No.");

              // check if all ILEs exist
              QtyNeeded := "Qty. to Assign";
              TempItemChargeAssgntPurch.SetRange("Document Line No.","Line No.");
              if TempItemChargeAssgntPurch.FindSet then
                repeat
                  if (TempItemChargeAssgntPurch."Applies-to Doc. Type" <> "Document Type") or
                     (TempItemChargeAssgntPurch."Applies-to Doc. No." <> "Document No.")
                  then
                    QtyNeeded := QtyNeeded - TempItemChargeAssgntPurch."Qty. to Assign"
                  else begin
                    PurchLine.Get(
                      TempItemChargeAssgntPurch."Applies-to Doc. Type",
                      TempItemChargeAssgntPurch."Applies-to Doc. No.",
                      TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
                    if ItemLedgerEntryExist(PurchLine,PurchHeader.Receive or PurchHeader.Ship) then
                      QtyNeeded := QtyNeeded - TempItemChargeAssgntPurch."Qty. to Assign";
                  end;
                until TempItemChargeAssgntPurch.Next = 0;

              if QtyNeeded > 0 then
                Error(CannotInvoiceItemChargeErr,"No.");
            until Next = 0;

          // Check purchlines
          if AssignError then
            if PurchHeader."Document Type" in
               [PurchHeader."document type"::Invoice,PurchHeader."document type"::"Credit Memo"]
            then
              InvoiceEverything := true
            else begin
              Reset;
              SetFilter(Type,'%1|%2',Type::Item,Type::"Charge (Item)");
              if FindSet then
                repeat
                  if PurchHeader.Ship or PurchHeader.Receive then
                    InvoiceEverything :=
                      Quantity = "Qty. to Invoice" + "Quantity Invoiced"
                  else
                    InvoiceEverything :=
                      (Quantity = "Qty. to Invoice" + "Quantity Invoiced") and
                      ("Qty. to Invoice" =
                       "Qty. Rcd. Not Invoiced" + "Return Qty. Shipped Not Invd.");
                until (Next = 0) or (not InvoiceEverything);
            end;
        end;

        if InvoiceEverything and AssignError then
          Error(MustAssignErr);
    end;

    local procedure ClearItemChargeAssgntFilter()
    begin
        TempItemChargeAssgntPurch.SetRange("Document Line No.");
        TempItemChargeAssgntPurch.SetRange("Applies-to Doc. Type");
        TempItemChargeAssgntPurch.SetRange("Applies-to Doc. No.");
        TempItemChargeAssgntPurch.SetRange("Applies-to Doc. Line No.");
        TempItemChargeAssgntPurch.MarkedOnly(false);
    end;

    local procedure GetItemChargeLine(PurchHeader: Record "Purchase Header";var ItemChargePurchLine: Record "Purchase Line")
    begin
        with TempItemChargeAssgntPurch do
          if (ItemChargePurchLine."Document Type" <> "Document Type") or
             (ItemChargePurchLine."Document No." <> "Document No.") or
             (ItemChargePurchLine."Line No." <> "Document Line No.")
          then begin
            ItemChargePurchLine.Get("Document Type","Document No.","Document Line No.");
            if not PurchHeader.Receive then
              ItemChargePurchLine."Qty. to Receive" := 0;
            if not PurchHeader.Ship then
              ItemChargePurchLine."Return Qty. to Ship" := 0;
            if Abs(ItemChargePurchLine."Qty. to Invoice") >
               Abs(ItemChargePurchLine."Quantity Received" + ItemChargePurchLine."Qty. to Receive" +
                 ItemChargePurchLine."Return Qty. Shipped" + ItemChargePurchLine."Return Qty. to Ship" -
                 ItemChargePurchLine."Quantity Invoiced")
            then
              ItemChargePurchLine."Qty. to Invoice" :=
                ItemChargePurchLine."Quantity Received" + ItemChargePurchLine."Qty. to Receive" +
                ItemChargePurchLine."Return Qty. Shipped (Base)" + ItemChargePurchLine."Return Qty. to Ship (Base)" -
                ItemChargePurchLine."Quantity Invoiced";
          end;
    end;

    local procedure CalcQtyToInvoice(QtyToHandle: Decimal;QtyToInvoice: Decimal): Decimal
    begin
        if Abs(QtyToHandle) > Abs(QtyToInvoice) then
          exit(QtyToHandle);

        exit(QtyToInvoice);
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
          GLSetup.Get;
        GLSetupRead := true;
    end;

    local procedure CheckWarehouse(var TempItemPurchLine: Record "Purchase Line" temporary)
    var
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        ShowError: Boolean;
    begin
        with TempItemPurchLine do begin
          if "Prod. Order No." <> '' then
            exit;
          SetRange(Type,Type::Item);
          SetRange("Drop Shipment",false);
          if FindSet then
            repeat
              GetLocation("Location Code");
              case "Document Type" of
                "document type"::Order:
                  if ((Location."Require Receive" or Location."Require Put-away") and (Quantity >= 0)) or
                     ((Location."Require Shipment" or Location."Require Pick") and (Quantity < 0))
                  then begin
                    if Location."Directed Put-away and Pick" then
                      ShowError := true
                    else
                      if WhseValidateSourceLine.WhseLinesExist(
                           Database::"Purchase Line","Document Type","Document No.","Line No.",0,Quantity)
                      then
                        ShowError := true;
                  end;
                "document type"::"Return Order":
                  if ((Location."Require Receive" or Location."Require Put-away") and (Quantity < 0)) or
                     ((Location."Require Shipment" or Location."Require Pick") and (Quantity >= 0))
                  then begin
                    if Location."Directed Put-away and Pick" then
                      ShowError := true
                    else
                      if WhseValidateSourceLine.WhseLinesExist(
                           Database::"Purchase Line","Document Type","Document No.","Line No.",0,Quantity)
                      then
                        ShowError := true;
                  end;
                "document type"::Invoice,"document type"::"Credit Memo":
                  if Location."Directed Put-away and Pick" then
                    Location.TestField("Adjustment Bin Code");
              end;
              if ShowError then
                Error(
                  WarehouseRequiredErr,
                  FieldCaption("Document Type"),"Document Type",
                  FieldCaption("Document No."),"Document No.",
                  FieldCaption("Line No."),"Line No.");
            until Next = 0;
        end;
    end;

    local procedure CreateWhseJnlLine(ItemJnlLine: Record "Item Journal Line";PurchLine: Record "Purchase Line";var TempWhseJnlLine: Record "Warehouse Journal Line" temporary)
    var
        WhseMgt: Codeunit "Whse. Management";
        WMSMgt: Codeunit "WMS Management";
    begin
        with PurchLine do begin
          WMSMgt.CheckAdjmtBin(Location,ItemJnlLine.Quantity,true);
          WMSMgt.CreateWhseJnlLine(ItemJnlLine,0,TempWhseJnlLine,false);
          TempWhseJnlLine."Source Type" := Database::"Purchase Line";
          TempWhseJnlLine."Source Subtype" := "Document Type";
          TempWhseJnlLine."Source Document" := WhseMgt.GetSourceDocument(TempWhseJnlLine."Source Type",TempWhseJnlLine."Source Subtype");
          TempWhseJnlLine."Source No." := "Document No.";
          TempWhseJnlLine."Source Line No." := "Line No.";
          TempWhseJnlLine."Source Code" := SrcCode;
          case "Document Type" of
            "document type"::Order:
              TempWhseJnlLine."Reference Document" :=
                TempWhseJnlLine."reference document"::"Posted Rcpt.";
            "document type"::Invoice:
              TempWhseJnlLine."Reference Document" :=
                TempWhseJnlLine."reference document"::"Posted P. Inv.";
            "document type"::"Credit Memo":
              TempWhseJnlLine."Reference Document" :=
                TempWhseJnlLine."reference document"::"Posted P. Cr. Memo";
            "document type"::"Return Order":
              TempWhseJnlLine."Reference Document" :=
                TempWhseJnlLine."reference document"::"Posted Rtrn. Rcpt.";
          end;
          TempWhseJnlLine."Reference No." := ItemJnlLine."Document No.";
        end;
    end;

    local procedure WhseHandlingRequired(PurchLine: Record "Purchase Line"): Boolean
    var
        WhseSetup: Record "Warehouse Setup";
    begin
        if (PurchLine.Type = PurchLine.Type::Item) and (not PurchLine."Drop Shipment") then begin
          if PurchLine."Location Code" = '' then begin
            WhseSetup.Get;
            if PurchLine."Document Type" = PurchLine."document type"::"Return Order" then
              exit(WhseSetup."Require Pick");

            exit(WhseSetup."Require Receive");
          end;

          GetLocation(PurchLine."Location Code");
          if PurchLine."Document Type" = PurchLine."document type"::"Return Order" then
            exit(Location."Require Pick");

          exit(Location."Require Receive");
        end;
        exit(false);
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Location.GetLocationSetup(LocationCode,Location)
        else
          if Location.Code <> LocationCode then
            Location.Get(LocationCode);
    end;

    local procedure InsertRcptEntryRelation(var PurchRcptLine: Record "Purch. Rcpt. Line"): Integer
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        TempTrackingSpecificationInv.Reset;
        if TempTrackingSpecificationInv.FindSet then begin
          repeat
            TempHandlingSpecification := TempTrackingSpecificationInv;
            if TempHandlingSpecification.Insert then;
          until TempTrackingSpecificationInv.Next = 0;
          TempTrackingSpecificationInv.DeleteAll;
        end;

        TempHandlingSpecification.Reset;
        if TempHandlingSpecification.FindSet then begin
          repeat
            ItemEntryRelation.Init;
            ItemEntryRelation."Item Entry No." := TempHandlingSpecification."Entry No.";
            ItemEntryRelation."Serial No." := TempHandlingSpecification."Serial No.";
            ItemEntryRelation."Lot No." := TempHandlingSpecification."Lot No.";
            ItemEntryRelation.TransferFieldsPurchRcptLine(PurchRcptLine);
            ItemEntryRelation.Insert;
          until TempHandlingSpecification.Next = 0;
          TempHandlingSpecification.DeleteAll;
          exit(0);
        end;
        exit(ItemLedgShptEntryNo);
    end;

    local procedure InsertReturnEntryRelation(var ReturnShptLine: Record "Return Shipment Line"): Integer
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        TempTrackingSpecificationInv.Reset;
        if TempTrackingSpecificationInv.FindSet then begin
          repeat
            TempHandlingSpecification := TempTrackingSpecificationInv;
            if TempHandlingSpecification.Insert then;
          until TempTrackingSpecificationInv.Next = 0;
          TempTrackingSpecificationInv.DeleteAll;
        end;

        TempHandlingSpecification.Reset;
        if TempHandlingSpecification.FindSet then begin
          repeat
            ItemEntryRelation.Init;
            ItemEntryRelation."Item Entry No." := TempHandlingSpecification."Entry No.";
            ItemEntryRelation."Serial No." := TempHandlingSpecification."Serial No.";
            ItemEntryRelation."Lot No." := TempHandlingSpecification."Lot No.";
            ItemEntryRelation.TransferFieldsReturnShptLine(ReturnShptLine);
            ItemEntryRelation.Insert;
          until TempHandlingSpecification.Next = 0;
          TempHandlingSpecification.DeleteAll;
          exit(0);
        end;
        exit(ItemLedgShptEntryNo);
    end;

    local procedure CheckTrackingSpecification(PurchHeader: Record "Purchase Header";var TempItemPurchLine: Record "Purchase Line" temporary)
    var
        ReservationEntry: Record "Reservation Entry";
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
        ItemJnlLine: Record "Item Journal Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ItemTrackingManagement: Codeunit "Item Tracking Management";
        ErrorFieldCaption: Text[250];
        SignFactor: Integer;
        PurchLineQtyToHandle: Decimal;
        TrackingQtyToHandle: Decimal;
        Inbound: Boolean;
        SNRequired: Boolean;
        LotRequired: Boolean;
        SNInfoRequired: Boolean;
        LotInfoRequired: Boolean;
        CheckPurchLine: Boolean;
    begin
        // if a PurchaseLine is posted with ItemTracking then tracked quantity must be equal to posted quantity
        if not (PurchHeader."Document Type" in
                [PurchHeader."document type"::Order,PurchHeader."document type"::"Return Order"])
        then
          exit;

        TrackingQtyToHandle := 0;

        with TempItemPurchLine do begin
          SetRange(Type,Type::Item);
          if PurchHeader.Receive then begin
            SetFilter("Quantity Received",'<>%1',0);
            ErrorFieldCaption := FieldCaption("Qty. to Receive");
          end else begin
            SetFilter("Return Qty. Shipped",'<>%1',0);
            ErrorFieldCaption := FieldCaption("Return Qty. to Ship");
          end;

          if FindSet then begin
            ReservationEntry."Source Type" := Database::"Purchase Line";
            ReservationEntry."Source Subtype" := PurchHeader."Document Type";
            SignFactor := CreateReservEntry.SignFactor(ReservationEntry);
            repeat
              // Only Item where no SerialNo or LotNo is required
              Item.Get("No.");
              if Item."Item Tracking Code" <> '' then begin
                Inbound := (Quantity * SignFactor) > 0;
                ItemTrackingCode.Code := Item."Item Tracking Code";
                ItemTrackingManagement.GetItemTrackingSettings(ItemTrackingCode,
                  ItemJnlLine."entry type"::Purchase,Inbound,
                  SNRequired,LotRequired,SNInfoRequired,LotInfoRequired);
                CheckPurchLine := (SNRequired = false) and (LotRequired = false);
                if CheckPurchLine then
                  CheckPurchLine := GetTrackingQuantities(TempItemPurchLine,0,TrackingQtyToHandle);
              end else
                CheckPurchLine := false;

              TrackingQtyToHandle := 0;

              if CheckPurchLine then begin
                GetTrackingQuantities(TempItemPurchLine,1,TrackingQtyToHandle);
                TrackingQtyToHandle := TrackingQtyToHandle * SignFactor;
                if PurchHeader.Receive then
                  PurchLineQtyToHandle := "Qty. to Receive (Base)"
                else
                  PurchLineQtyToHandle := "Return Qty. to Ship (Base)";
                if TrackingQtyToHandle <> PurchLineQtyToHandle then
                  Error(StrSubstNo(ItemTrackQuantityMismatchErr,ErrorFieldCaption));
              end;
            until Next = 0;
          end;
        end;
    end;

    local procedure GetTrackingQuantities(PurchLine: Record "Purchase Line";FunctionType: Option CheckTrackingExists,GetQty;var TrackingQtyToHandle: Decimal): Boolean
    var
        TrackingSpecification: Record "Tracking Specification";
        ReservEntry: Record "Reservation Entry";
    begin
        with TrackingSpecification do begin
          SetCurrentkey("Source ID","Source Type","Source Subtype","Source Batch Name",
            "Source Prod. Order Line","Source Ref. No.");
          SetRange("Source Type",Database::"Purchase Line");
          SetRange("Source Subtype",PurchLine."Document Type");
          SetRange("Source ID",PurchLine."Document No.");
          SetRange("Source Batch Name",'');
          SetRange("Source Prod. Order Line",0);
          SetRange("Source Ref. No.",PurchLine."Line No.");
        end;
        with ReservEntry do begin
          SetCurrentkey(
            "Source ID","Source Ref. No.","Source Type","Source Subtype",
            "Source Batch Name","Source Prod. Order Line");
          SetRange("Source ID",PurchLine."Document No.");
          SetRange("Source Ref. No.",PurchLine."Line No.");
          SetRange("Source Type",Database::"Purchase Line");
          SetRange("Source Subtype",PurchLine."Document Type");
          SetRange("Source Batch Name",'');
          SetRange("Source Prod. Order Line",0);
        end;

        case FunctionType of
          Functiontype::CheckTrackingExists:
            begin
              TrackingSpecification.SetRange(Correction,false);
              if not TrackingSpecification.IsEmpty then
                exit(true);
              ReservEntry.SetFilter("Serial No.",'<>%1','');
              if not ReservEntry.IsEmpty then
                exit(true);
              ReservEntry.SetRange("Serial No.");
              ReservEntry.SetFilter("Lot No.",'<>%1','');
              if not ReservEntry.IsEmpty then
                exit(true);
            end;
          Functiontype::GetQty:
            begin
              if ReservEntry.FindSet then
                repeat
                  if ReservEntry.TrackingExists then
                    TrackingQtyToHandle := TrackingQtyToHandle + ReservEntry."Qty. to Handle (Base)";
                until ReservEntry.Next = 0;
            end;
        end;
    end;

    local procedure SaveInvoiceSpecification(var TempInvoicingSpecification: Record "Tracking Specification" temporary)
    begin
        TempInvoicingSpecification.Reset;
        if TempInvoicingSpecification.FindSet then begin
          repeat
            TempInvoicingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
            TempTrackingSpecification := TempInvoicingSpecification;
            TempTrackingSpecification."Buffer Status" := TempTrackingSpecification."buffer status"::Modify;
            if not TempTrackingSpecification.Insert then begin
              TempTrackingSpecification.Get(TempInvoicingSpecification."Entry No.");
              TempTrackingSpecification."Qty. to Invoice (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
              if TempInvoicingSpecification."Qty. to Invoice (Base)" = TempInvoicingSpecification."Quantity Invoiced (Base)" then
                TempTrackingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Quantity Invoiced (Base)"
              else
                TempTrackingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
              TempTrackingSpecification."Qty. to Invoice" += TempInvoicingSpecification."Qty. to Invoice";
              TempTrackingSpecification.Modify;
            end;
          until TempInvoicingSpecification.Next = 0;
          TempInvoicingSpecification.DeleteAll;
        end;
    end;

    local procedure InsertTrackingSpecification(PurchHeader: Record "Purchase Header")
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        TempTrackingSpecification.Reset;
        if TempTrackingSpecification.FindSet then begin
          repeat
            TrackingSpecification := TempTrackingSpecification;
            TrackingSpecification."Buffer Status" := 0;
            TrackingSpecification.InitQtyToShip;
            TrackingSpecification.Correction := false;
            TrackingSpecification."Quantity actual Handled (Base)" := 0;
            if TempTrackingSpecification."Buffer Status" = TempTrackingSpecification."buffer status"::Modify then
              TrackingSpecification.Modify
            else
              TrackingSpecification.Insert;
          until TempTrackingSpecification.Next = 0;
          TempTrackingSpecification.DeleteAll;
          ReservePurchLine.UpdateItemTrackingAfterPosting(PurchHeader);
        end;
    end;

    local procedure CalcBaseQty(ItemNo: Code[20];UOMCode: Code[10];Qty: Decimal): Decimal
    var
        Item: Record Item;
        UOMMgt: Codeunit "Unit of Measure Management";
    begin
        Item.Get(ItemNo);
        exit(ROUND(Qty * UOMMgt.GetQtyPerUnitOfMeasure(Item,UOMCode),0.00001));
    end;

    local procedure InsertValueEntryRelation()
    var
        ValueEntryRelation: Record "Value Entry Relation";
    begin
        TempValueEntryRelation.Reset;
        if TempValueEntryRelation.FindSet then begin
          repeat
            ValueEntryRelation := TempValueEntryRelation;
            ValueEntryRelation.Insert;
          until TempValueEntryRelation.Next = 0;
          TempValueEntryRelation.DeleteAll;
        end;
    end;

    local procedure PostItemCharge(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line";ItemEntryNo: Integer;QuantityBase: Decimal;AmountToAssign: Decimal;QtyToAssign: Decimal;IndirectCostPct: Decimal)
    var
        DummyTrackingSpecification: Record "Tracking Specification";
        PurchLineToPost: Record "Purchase Line";
        CurrExchRate: Record "Currency Exchange Rate";
        TotalChargeAmt: Decimal;
        TotalChargeAmtLCY: Decimal;
    begin
        with TempItemChargeAssgntPurch do begin
          PurchLineToPost := PurchLine;
          PurchLineToPost."No." := "Item No.";
          PurchLineToPost."Line No." := "Document Line No.";
          PurchLineToPost."Appl.-to Item Entry" := ItemEntryNo;
          PurchLineToPost."Indirect Cost %" := IndirectCostPct;

          PurchLineToPost.Amount := AmountToAssign;
          if PurchLineToPost."Tax To Be Expensed" <> 0 then
            PurchLineToPost."Tax To Be Expensed" :=
              ROUND(PurchLineToPost."Tax To Be Expensed" * "Qty. to Assign" / PurchLineToPost."Qty. to Invoice");

          if "Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"] then
            PurchLineToPost.Amount := -PurchLineToPost.Amount;

          if PurchLineToPost."Currency Code" <> '' then
            PurchLineToPost."Unit Cost" := ROUND(
                PurchLineToPost.Amount / QuantityBase,Currency."Unit-Amount Rounding Precision")
          else
            PurchLineToPost."Unit Cost" := ROUND(
                PurchLineToPost.Amount / QuantityBase,GLSetup."Unit-Amount Rounding Precision");

          TotalChargeAmt := TotalChargeAmt + PurchLineToPost.Amount;
          if PurchHeader."Currency Code" <> '' then
            PurchLineToPost.Amount :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                Usedate,PurchHeader."Currency Code",TotalChargeAmt,PurchHeader."Currency Factor");

          PurchLineToPost.Amount := ROUND(PurchLineToPost.Amount,GLSetup."Amount Rounding Precision") - TotalChargeAmtLCY;
          if PurchHeader."Currency Code" <> '' then
            TotalChargeAmtLCY := TotalChargeAmtLCY + PurchLineToPost.Amount;
          PurchLineToPost."Unit Cost (LCY)" :=
            ROUND(
              PurchLineToPost.Amount / QuantityBase,GLSetup."Unit-Amount Rounding Precision");

          PurchLineToPost."Inv. Discount Amount" := ROUND(
              PurchLine."Inv. Discount Amount" / PurchLine.Quantity * QtyToAssign,
              GLSetup."Amount Rounding Precision");

          PurchLineToPost."Line Discount Amount" := ROUND(
              PurchLine."Line Discount Amount" / PurchLine.Quantity * QtyToAssign,
              GLSetup."Amount Rounding Precision");
          PurchLineToPost."Line Amount" := ROUND(
              PurchLine."Line Amount" / PurchLine.Quantity * QtyToAssign,
              GLSetup."Amount Rounding Precision");
          UpdatePurchLineDimSetIDFromAppliedEntry(PurchLineToPost,PurchLine);
          PurchLine."Inv. Discount Amount" := PurchLine."Inv. Discount Amount" - PurchLineToPost."Inv. Discount Amount";
          PurchLine."Line Discount Amount" := PurchLine."Line Discount Amount" - PurchLineToPost."Line Discount Amount";
          PurchLine."Line Amount" := PurchLine."Line Amount" - PurchLineToPost."Line Amount";
          PurchLine.Quantity := PurchLine.Quantity - QtyToAssign;
          PostItemJnlLine(
            PurchHeader,PurchLineToPost,
            0,0,
            QuantityBase,QuantityBase,
            PurchLineToPost."Appl.-to Item Entry","Item Charge No.",DummyTrackingSpecification);
        end;
    end;

    local procedure SaveTempWhseSplitSpec(PurchLine3: Record "Purchase Line")
    begin
        TempWhseSplitSpecification.Reset;
        TempWhseSplitSpecification.DeleteAll;
        if TempHandlingSpecification.FindSet then
          repeat
            TempWhseSplitSpecification := TempHandlingSpecification;
            TempWhseSplitSpecification."Source Type" := Database::"Purchase Line";
            TempWhseSplitSpecification."Source Subtype" := PurchLine3."Document Type";
            TempWhseSplitSpecification."Source ID" := PurchLine3."Document No.";
            TempWhseSplitSpecification."Source Ref. No." := PurchLine3."Line No.";
            TempWhseSplitSpecification.Insert;
          until TempHandlingSpecification.Next = 0;
    end;

    local procedure TransferReservToItemJnlLine(var SalesOrderLine: Record "Sales Line";var ItemJnlLine: Record "Item Journal Line";PurchLine: Record "Purchase Line";QtyToBeShippedBase: Decimal;ApplySpecificItemTracking: Boolean)
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        RemainingQuantity: Decimal;
        CheckApplFromItemEntry: Boolean;
    begin
        // Handle Item Tracking and reservations, also on drop shipment
        if QtyToBeShippedBase = 0 then
          exit;

        if not ApplySpecificItemTracking then
          ReserveSalesLine.TransferSalesLineToItemJnlLine(
            SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,false)
        else begin
          TempTrackingSpecification.Reset;
          TempTrackingSpecification.SetRange("Source Type",Database::"Purchase Line");
          TempTrackingSpecification.SetRange("Source Subtype",PurchLine."Document Type");
          TempTrackingSpecification.SetRange("Source ID",PurchLine."Document No.");
          TempTrackingSpecification.SetRange("Source Batch Name",'');
          TempTrackingSpecification.SetRange("Source Prod. Order Line",0);
          TempTrackingSpecification.SetRange("Source Ref. No.",PurchLine."Line No.");
          if TempTrackingSpecification.IsEmpty then
            ReserveSalesLine.TransferSalesLineToItemJnlLine(
              SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,false)
          else begin
            ReserveSalesLine.SetApplySpecificItemTracking(true);
            ReserveSalesLine.SetOverruleItemTracking(true);
            TempTrackingSpecification.FindSet;
            if TempTrackingSpecification."Quantity (Base)" / QtyToBeShippedBase < 0 then
              Error(ItemTrackingWrongSignErr);
            repeat
              ItemJnlLine."Serial No." := TempTrackingSpecification."Serial No.";
              ItemJnlLine."Lot No." := TempTrackingSpecification."Lot No.";
              ItemJnlLine."Applies-to Entry" := TempTrackingSpecification."Item Ledger Entry No.";
              RemainingQuantity :=
                ReserveSalesLine.TransferSalesLineToItemJnlLine(
                  SalesOrderLine,ItemJnlLine,TempTrackingSpecification."Quantity (Base)",CheckApplFromItemEntry,false);
              if RemainingQuantity <> 0 then
                Error(ItemTrackingMismatchErr);
            until TempTrackingSpecification.Next = 0;
            ItemJnlLine."Serial No." := '';
            ItemJnlLine."Lot No." := '';
            ItemJnlLine."Applies-to Entry" := 0;
          end;
        end;
    end;


    procedure SetWhseRcptHeader(var WhseRcptHeader2: Record "Warehouse Receipt Header")
    begin
        WhseRcptHeader := WhseRcptHeader2;
        TempWhseRcptHeader := WhseRcptHeader;
        TempWhseRcptHeader.Insert;
    end;


    procedure SetWhseShptHeader(var WhseShptHeader2: Record "Warehouse Shipment Header")
    begin
        WhseShptHeader := WhseShptHeader2;
        TempWhseShptHeader := WhseShptHeader;
        TempWhseShptHeader.Insert;
    end;

    local procedure CopySalesCommentLines(FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
    var
        SalesCommentLine: Record "Sales Comment Line";
        SalesCommentLine2: Record "Sales Comment Line";
    begin
        SalesCommentLine.SetRange("Document Type",FromDocumentType);
        SalesCommentLine.SetRange("No.",FromNumber);
        if SalesCommentLine.FindSet then
          repeat
            SalesCommentLine2 := SalesCommentLine;
            SalesCommentLine2."Document Type" := ToDocumentType;
            SalesCommentLine2."No." := ToNumber;
            SalesCommentLine2.Insert;
          until SalesCommentLine.Next = 0;
    end;

    local procedure GetNextPurchline(var PurchLine: Record "Purchase Line"): Boolean
    begin
        if not PurchaseLinesProcessed then
          if PurchLine.Next = 1 then
            exit(false);
        PurchaseLinesProcessed := true;
        if TempPrepmtPurchLine.Find('-') then begin
          PurchLine := TempPrepmtPurchLine;
          TempPrepmtPurchLine.Delete;
          exit(false);
        end;
        exit(true);
    end;

    local procedure CreatePrepmtLines(PurchHeader: Record "Purchase Header";var TempPrepmtPurchLine: Record "Purchase Line";CompleteFunctionality: Boolean)
    var
        GLAcc: Record "G/L Account";
        TempPurchLine: Record "Purchase Line" temporary;
        TempExtTextLine: Record "Extended Text Line" temporary;
        GenPostingSetup: Record "General Posting Setup";
        TransferExtText: Codeunit "Transfer Extended Text";
        NextLineNo: Integer;
        Fraction: Decimal;
        VATDifference: Decimal;
        TempLineFound: Boolean;
        PrepmtAmtToDeduct: Decimal;
    begin
        GetGLSetup;
        with TempPurchLine do begin
          FillTempLines(PurchHeader);
          ResetTempLines(TempPurchLine);
          if not FindLast then
            exit;
          NextLineNo := "Line No." + 10000;
          SetFilter(Quantity,'>0');
          SetFilter("Qty. to Invoice",'>0');
          if FindSet then begin
            if CompleteFunctionality and ("Document Type" = "document type"::Invoice) then
              TestGetRcptPPmtAmtToDeduct;
            repeat
              if CompleteFunctionality then
                if PurchHeader."Document Type" <> PurchHeader."document type"::Invoice then begin
                  if not PurchHeader.Receive and ("Qty. to Invoice" = Quantity - "Quantity Invoiced") then
                    if "Qty. Rcd. Not Invoiced" < "Qty. to Invoice" then
                      Validate("Qty. to Invoice","Qty. Rcd. Not Invoiced");
                  Fraction := ("Qty. to Invoice" + "Quantity Invoiced") / Quantity;

                  if "Prepayment %" <> 100 then
                    case true of
                      ("Prepmt Amt to Deduct" <> 0) and
                      (ROUND(Fraction * "Line Amount",Currency."Amount Rounding Precision") < "Prepmt Amt to Deduct"):
                        FieldError(
                          "Prepmt Amt to Deduct",
                          StrSubstNo(
                            CannotBeGreaterThanErr,
                            ROUND(Fraction * "Line Amount",Currency."Amount Rounding Precision")));
                      ("Prepmt. Amt. Inv." <> 0) and
                      (ROUND((1 - Fraction) * "Line Amount",Currency."Amount Rounding Precision") <
                       ROUND(
                         ROUND(
                           ROUND("Direct Unit Cost" * (Quantity - "Quantity Invoiced" - "Qty. to Invoice"),
                             Currency."Amount Rounding Precision") *
                           (1 - "Line Discount %" / 100),Currency."Amount Rounding Precision") *
                         "Prepayment %" / 100,Currency."Amount Rounding Precision")):
                        FieldError(
                          "Prepmt Amt to Deduct",
                          StrSubstNo(
                            CannotBeSmallerThanErr,
                            ROUND(
                              "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" -
                              (1 - Fraction) * "Line Amount",Currency."Amount Rounding Precision")));
                    end;
                end;
              if "Prepmt Amt to Deduct" <> 0 then begin
                if ("Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") or
                   ("Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
                then begin
                  GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                  GenPostingSetup.TestField("Purch. Prepayments Account");
                end;
                GLAcc.Get(GenPostingSetup."Purch. Prepayments Account");
                TempLineFound := false;
                if PurchHeader."Compress Prepayment" then begin
                  TempPrepmtPurchLine.SetRange("No.",GLAcc."No.");
                  TempPrepmtPurchLine.SetRange("Job No.","Job No.");
                  TempPrepmtPurchLine.SetRange("Dimension Set ID","Dimension Set ID");
                  TempLineFound := TempPrepmtPurchLine.FindFirst;
                end;
                if TempLineFound then begin
                  PrepmtAmtToDeduct :=
                    TempPrepmtPurchLine."Prepmt Amt to Deduct" +
                    InsertedPrepmtVATBaseToDeduct(
                      PurchHeader,TempPurchLine,TempPrepmtPurchLine."Line No.",TempPrepmtPurchLine."Direct Unit Cost");
                  VATDifference := TempPrepmtPurchLine."VAT Difference";
                  if PurchHeader."Prepmt. Include Tax" then
                    TempPrepmtPurchLine.Validate(
                      "Direct Unit Cost",
                      TempPrepmtPurchLine."Direct Unit Cost" + "Prepmt Amt to Deduct" * (1 + "VAT %" / 100))
                  else
                    TempPrepmtPurchLine.Validate(
                      "Direct Unit Cost",TempPrepmtPurchLine."Direct Unit Cost" + "Prepmt Amt to Deduct");
                  TempPrepmtPurchLine.Validate("VAT Difference",VATDifference - "Prepmt VAT Diff. to Deduct");
                  if PurchHeader."Prepmt. Include Tax" then
                    TempPrepmtPurchLine."Prepmt Amt to Deduct" += CalcAmountIncludingTax("Prepmt Amt to Deduct")
                  else
                    TempPrepmtPurchLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
                  if "Prepayment %" < TempPrepmtPurchLine."Prepayment %" then
                    TempPrepmtPurchLine."Prepayment %" := "Prepayment %";
                  TempPrepmtPurchLine.Modify;
                end else begin
                  TempPrepmtPurchLine.Init;
                  TempPrepmtPurchLine."Document Type" := PurchHeader."Document Type";
                  TempPrepmtPurchLine."Document No." := PurchHeader."No.";
                  TempPrepmtPurchLine."Line No." := 0;
                  TempPrepmtPurchLine."System-Created Entry" := true;
                  if CompleteFunctionality then
                    TempPrepmtPurchLine.Validate(Type,TempPrepmtPurchLine.Type::"G/L Account")
                  else
                    TempPrepmtPurchLine.Type := TempPrepmtPurchLine.Type::"G/L Account";
                  TempPrepmtPurchLine.Validate("No.",GenPostingSetup."Purch. Prepayments Account");
                  TempPrepmtPurchLine.Validate(Quantity,-1);
                  TempPrepmtPurchLine."Qty. to Receive" := TempPrepmtPurchLine.Quantity;
                  TempPrepmtPurchLine."Qty. to Invoice" := TempPrepmtPurchLine.Quantity;
                  PrepmtAmtToDeduct := InsertedPrepmtVATBaseToDeduct(PurchHeader,TempPurchLine,NextLineNo,0);
                  if PurchHeader."Prepmt. Include Tax" then
                    TempPrepmtPurchLine.Validate("Direct Unit Cost","Prepmt Amt to Deduct" * (1 + "VAT %" / 100))
                  else
                    TempPrepmtPurchLine.Validate("Direct Unit Cost","Prepmt Amt to Deduct");
                  TempPrepmtPurchLine.Validate("VAT Difference",-"Prepmt VAT Diff. to Deduct");
                  if PurchHeader."Prepmt. Include Tax" then
                    TempPrepmtPurchLine."Prepmt Amt to Deduct" := CalcAmountIncludingTax("Prepmt Amt to Deduct")
                  else
                    TempPrepmtPurchLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
                  TempPrepmtPurchLine."Prepayment %" := "Prepayment %";
                  TempPrepmtPurchLine."Prepayment Line" := true;
                  TempPrepmtPurchLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                  TempPrepmtPurchLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                  TempPrepmtPurchLine."Dimension Set ID" := "Dimension Set ID";
                  TempPrepmtPurchLine."Job No." := "Job No.";
                  TempPrepmtPurchLine."Job Task No." := "Job Task No.";
                  TempPrepmtPurchLine."Job Line Type" := "Job Line Type";
                  TempPrepmtPurchLine."Line No." := NextLineNo;
                  NextLineNo := NextLineNo + 10000;
                  TempPrepmtPurchLine.Insert;

                  TransferExtText.PrepmtGetAnyExtText(
                    TempPrepmtPurchLine."No.",Database::"Purch. Inv. Line",
                    PurchHeader."Document Date",PurchHeader."Language Code",TempExtTextLine);
                  if TempExtTextLine.Find('-') then
                    repeat
                      TempPrepmtPurchLine.Init;
                      TempPrepmtPurchLine.Description := TempExtTextLine.Text;
                      TempPrepmtPurchLine."System-Created Entry" := true;
                      TempPrepmtPurchLine."Prepayment Line" := true;
                      TempPrepmtPurchLine."Line No." := NextLineNo;
                      NextLineNo := NextLineNo + 10000;
                      TempPrepmtPurchLine.Insert;
                    until TempExtTextLine.Next = 0;
                end;
              end;
            until Next = 0
          end;
        end;
        DividePrepmtAmountLCY(TempPrepmtPurchLine,PurchHeader);

        if Is100PctPrepmtInvoice(TempPrepmtPurchLine) then
          TotalPurchLineLCY."Prepayment %" := 100;
    end;

    local procedure InsertedPrepmtVATBaseToDeduct(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";PrepmtLineNo: Integer;TotalPrepmtAmtToDeduct: Decimal): Decimal
    var
        PrepmtVATBaseToDeduct: Decimal;
    begin
        with PurchLine do begin
          if PurchHeader."Prices Including VAT" then
            PrepmtVATBaseToDeduct :=
              ROUND(
                (TotalPrepmtAmtToDeduct + "Prepmt Amt to Deduct") / (1 + "Prepayment VAT %" / 100),
                Currency."Amount Rounding Precision") -
              ROUND(
                TotalPrepmtAmtToDeduct / (1 + "Prepayment VAT %" / 100),
                Currency."Amount Rounding Precision")
          else
            PrepmtVATBaseToDeduct := "Prepmt Amt to Deduct";
        end;
        with TempPrepmtDeductLCYPurchLine do begin
          TempPrepmtDeductLCYPurchLine := PurchLine;
          if "Document Type" = "document type"::Order then
            "Qty. to Invoice" := GetQtyToInvoice(PurchLine,PurchHeader.Receive)
          else
            GetLineDataFromOrder(TempPrepmtDeductLCYPurchLine);
          CalcPrepaymentToDeduct;
          if PurchHeader."Prepmt. Include Tax" then
            "Prepmt Amt to Deduct" := CalcAmountIncludingTax(PurchLine."Prepmt Amt to Deduct");
          "Line Amount" := GetLineAmountToHandle("Qty. to Invoice");
          "Attached to Line No." := PrepmtLineNo;
          "VAT Base Amount" := PrepmtVATBaseToDeduct;
          Insert;
        end;
        exit(PrepmtVATBaseToDeduct);
    end;

    local procedure DividePrepmtAmountLCY(var PrepmtPurchLine: Record "Purchase Line";PurchHeader: Record "Purchase Header")
    var
        CurrExchRate: Record "Currency Exchange Rate";
        ActualCurrencyFactor: Decimal;
    begin
        with PrepmtPurchLine do begin
          Reset;
          SetFilter(Type,'<>%1',Type::" ");
          if FindSet then
            repeat
              if PurchHeader."Currency Code" <> '' then
                ActualCurrencyFactor :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      PurchHeader."Posting Date",
                      PurchHeader."Currency Code",
                      "Prepmt Amt to Deduct",
                      PurchHeader."Currency Factor")) /
                  "Prepmt Amt to Deduct"
              else
                ActualCurrencyFactor := 1;

              if not PurchHeader."Prepmt. Include Tax" then
                UpdatePrepmtAmountInvBuf("Line No.",ActualCurrencyFactor);
            until Next = 0;
          Reset;
        end;
    end;

    local procedure UpdatePrepmtAmountInvBuf(PrepmtSalesLineNo: Integer;CurrencyFactor: Decimal)
    var
        PrepmtAmtRemainder: Decimal;
    begin
        with TempPrepmtDeductLCYPurchLine do begin
          Reset;
          SetRange("Attached to Line No.",PrepmtSalesLineNo);
          if FindSet(true) then
            repeat
              "Prepmt. Amount Inv. (LCY)" :=
                CalcRoundedAmount(CurrencyFactor * "VAT Base Amount",PrepmtAmtRemainder);
              Modify;
            until Next = 0;
        end;
    end;

    local procedure AdjustPrepmtAmountLCY(PurchHeader: Record "Purchase Header";var PrepmtPurchLine: Record "Purchase Line")
    var
        PurchLine: Record "Purchase Line";
        PurchInvoiceLine: Record "Purchase Line";
        DeductionFactor: Decimal;
        PrepmtVATPart: Decimal;
        PrepmtVATAmtRemainder: Decimal;
        TotalRoundingAmount: array [2] of Decimal;
        TotalPrepmtAmount: array [2] of Decimal;
        FinalInvoice: Boolean;
        PricesInclVATRoundingAmount: array [2] of Decimal;
    begin
        if PrepmtPurchLine."Prepayment Line" then begin
          PrepmtVATPart :=
            (PrepmtPurchLine."Amount Including VAT" - PrepmtPurchLine.Amount) / PrepmtPurchLine."Direct Unit Cost";

          with TempPrepmtDeductLCYPurchLine do begin
            Reset;
            SetRange("Attached to Line No.",PrepmtPurchLine."Line No.");
            if FindSet(true) then begin
              FinalInvoice := IsFinalInvoice;
              repeat
                PurchLine := TempPrepmtDeductLCYPurchLine;
                PurchLine.Find;
                if "Document Type" = "document type"::Invoice then begin
                  PurchInvoiceLine := PurchLine;
                  GetPurchOrderLine(PurchLine,PurchInvoiceLine);
                  PurchLine."Qty. to Invoice" := PurchInvoiceLine."Qty. to Invoice";
                end;
                if (not PurchHeader."Prepmt. Include Tax") and (PurchLine."Qty. to Invoice" <> "Qty. to Invoice") then
                  PurchLine."Prepmt Amt to Deduct" := CalcPrepmtAmtToDeduct(PurchLine,PurchHeader.Receive);
                DeductionFactor :=
                  PurchLine."Prepmt Amt to Deduct" /
                  (PurchLine."Prepmt. Amt. Inv." - PurchLine."Prepmt Amt Deducted");

                "Prepmt. VAT Amount Inv. (LCY)" :=
                  -CalcRoundedAmount(PurchLine."Prepmt Amt to Deduct" * PrepmtVATPart,PrepmtVATAmtRemainder);
                if ("Prepayment %" <> 100) or IsFinalInvoice or ("Currency Code" <> '') then
                  CalcPrepmtRoundingAmounts(TempPrepmtDeductLCYPurchLine,PurchLine,DeductionFactor,TotalRoundingAmount);
                Modify;

                if PurchHeader."Prices Including VAT" then
                  if (("Prepayment %" <> 100) or IsFinalInvoice) and (DeductionFactor = 1) then begin
                    PricesInclVATRoundingAmount[1] := TotalRoundingAmount[1];
                    PricesInclVATRoundingAmount[2] := TotalRoundingAmount[2];
                  end;

                if "VAT Calculation Type" <> "vat calculation type"::"Full VAT" then
                  if PurchHeader."Prepmt. Include Tax" and not IsFinalInvoice then
                    TotalPrepmtAmount[1] += "Prepmt Amt to Deduct"
                  else
                    TotalPrepmtAmount[1] += "Prepmt. Amount Inv. (LCY)";
                TotalPrepmtAmount[2] += "Prepmt. VAT Amount Inv. (LCY)";
                FinalInvoice := FinalInvoice and IsFinalInvoice;
              until Next = 0;
            end;
          end;

          UpdatePrepmtPurchLineWithRounding(
            PrepmtPurchLine,TotalRoundingAmount,TotalPrepmtAmount,
            FinalInvoice,PricesInclVATRoundingAmount);
        end;
    end;

    local procedure CalcPrepmtAmtToDeduct(PurchLine: Record "Purchase Line";Receive: Boolean): Decimal
    begin
        with PurchLine do begin
          "Qty. to Invoice" := GetQtyToInvoice(PurchLine,Receive);
          CalcPrepaymentToDeduct;
          exit("Prepmt Amt to Deduct");
        end;
    end;

    local procedure GetQtyToInvoice(PurchLine: Record "Purchase Line";Receive: Boolean): Decimal
    var
        AllowedQtyToInvoice: Decimal;
    begin
        with PurchLine do begin
          AllowedQtyToInvoice := "Qty. Rcd. Not Invoiced";
          if Receive then
            AllowedQtyToInvoice := AllowedQtyToInvoice + "Qty. to Receive";
          if "Qty. to Invoice" > AllowedQtyToInvoice then
            exit(AllowedQtyToInvoice);
          exit("Qty. to Invoice");
        end;
    end;

    local procedure GetLineDataFromOrder(var PurchLine: Record "Purchase Line")
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchOrderLine: Record "Purchase Line";
    begin
        with PurchLine do begin
          PurchRcptLine.Get("Receipt No.","Receipt Line No.");
          PurchOrderLine.Get("document type"::Order,PurchRcptLine."Order No.",PurchRcptLine."Order Line No.");

          Quantity := PurchOrderLine.Quantity;
          "Qty. Rcd. Not Invoiced" := PurchOrderLine."Qty. Rcd. Not Invoiced";
          "Quantity Invoiced" := PurchOrderLine."Quantity Invoiced";
          "Prepmt Amt Deducted" := PurchOrderLine."Prepmt Amt Deducted";
          "Prepmt. Amt. Inv." := PurchOrderLine."Prepmt. Amt. Inv.";
          "Line Discount Amount" := PurchOrderLine."Line Discount Amount";
        end;
    end;

    local procedure CalcPrepmtRoundingAmounts(var PrepmtPurchLineBuf: Record "Purchase Line";PurchLine: Record "Purchase Line";DeductionFactor: Decimal;var TotalRoundingAmount: array [2] of Decimal)
    var
        RoundingAmount: array [2] of Decimal;
    begin
        with PrepmtPurchLineBuf do begin
          if "VAT Calculation Type" <> "vat calculation type"::"Full VAT" then begin
            RoundingAmount[1] :=
              "Prepmt. Amount Inv. (LCY)" - ROUND(DeductionFactor * PurchLine."Prepmt. Amount Inv. (LCY)");
            "Prepmt. Amount Inv. (LCY)" := "Prepmt. Amount Inv. (LCY)" - RoundingAmount[1];
            TotalRoundingAmount[1] += RoundingAmount[1];
          end;
          RoundingAmount[2] :=
            "Prepmt. VAT Amount Inv. (LCY)" - ROUND(DeductionFactor * PurchLine."Prepmt. VAT Amount Inv. (LCY)");
          "Prepmt. VAT Amount Inv. (LCY)" := "Prepmt. VAT Amount Inv. (LCY)" - RoundingAmount[2];
          TotalRoundingAmount[2] += RoundingAmount[2];
        end;
    end;

    local procedure UpdatePrepmtPurchLineWithRounding(var PrepmtPurchLine: Record "Purchase Line";TotalRoundingAmount: array [2] of Decimal;TotalPrepmtAmount: array [2] of Decimal;FinalInvoice: Boolean;PricesInclVATRoundingAmount: array [2] of Decimal)
    var
        NewAmountIncludingVAT: Decimal;
        Prepmt100PctVATRoundingAmt: Decimal;
        AmountRoundingPrecision: Decimal;
    begin
        with PrepmtPurchLine do begin
          NewAmountIncludingVAT := TotalPrepmtAmount[1] + TotalPrepmtAmount[2] + TotalRoundingAmount[1] + TotalRoundingAmount[2];
          if "Prepayment %" = 100 then
            TotalRoundingAmount[1] -= "Amount Including VAT" + NewAmountIncludingVAT;
          AmountRoundingPrecision :=
            GetAmountRoundingPrecisionInLCY("Document Type","Document No.","Currency Code");

          if Abs(TotalRoundingAmount[1]) <= AmountRoundingPrecision then begin
            if "Prepayment %" = 100 then
              Prepmt100PctVATRoundingAmt := TotalRoundingAmount[1];
            TotalRoundingAmount[1] := 0;
          end;
          "Prepmt. Amount Inv. (LCY)" := -TotalRoundingAmount[1];
          Amount := -(TotalPrepmtAmount[1] + TotalRoundingAmount[1]);

          if (PricesInclVATRoundingAmount[1] <> 0) and (TotalRoundingAmount[1] = 0) then begin
            if ("Prepayment %" = 100) and FinalInvoice and
               (Amount - TotalPrepmtAmount[2] = "Amount Including VAT")
            then
              Prepmt100PctVATRoundingAmt := 0;
            PricesInclVATRoundingAmount[1] := 0;
          end;

          if ((Abs(TotalRoundingAmount[2]) <= AmountRoundingPrecision) or
              FinalInvoice) and (TotalRoundingAmount[1] = 0)
          then begin
            if ("Prepayment %" = 100) and ("Prepmt. Amount Inv. (LCY)" = 0) then
              Prepmt100PctVATRoundingAmt += TotalRoundingAmount[2];
            TotalRoundingAmount[2] := 0;
          end;

          if (PricesInclVATRoundingAmount[2] <> 0) and (TotalRoundingAmount[2] = 0) then begin
            Prepmt100PctVATRoundingAmt := 0;
            PricesInclVATRoundingAmount[2] := 0;
          end;

          "Prepmt. VAT Amount Inv. (LCY)" := -(TotalRoundingAmount[2] + Prepmt100PctVATRoundingAmt);
          NewAmountIncludingVAT := Amount - (TotalPrepmtAmount[2] + TotalRoundingAmount[2]);
          if (PricesInclVATRoundingAmount[1] = 0) and (PricesInclVATRoundingAmount[2] = 0) or
             ("Currency Code" <> '') and FinalInvoice
          then
            Increment(
              TotalPurchLineLCY."Amount Including VAT",
              -("Amount Including VAT" - NewAmountIncludingVAT + Prepmt100PctVATRoundingAmt));
          if "Currency Code" = '' then
            TotalPurchLine."Amount Including VAT" := TotalPurchLineLCY."Amount Including VAT";
          "Amount Including VAT" := NewAmountIncludingVAT;

          if FinalInvoice and (TotalPurchLine.Amount = 0) and (TotalPurchLine."Amount Including VAT" <> 0) and
             (Abs(TotalPurchLine."Amount Including VAT") <= Currency."Amount Rounding Precision")
          then begin
            "Amount Including VAT" -= TotalPurchLineLCY."Amount Including VAT";
            TotalPurchLine."Amount Including VAT" := 0;
            TotalPurchLineLCY."Amount Including VAT" := 0;
          end;
        end;
    end;

    local procedure CalcRoundedAmount(Amount: Decimal;var Remainder: Decimal): Decimal
    var
        AmountRnded: Decimal;
    begin
        Amount := Amount + Remainder;
        AmountRnded := ROUND(Amount,GLSetup."Amount Rounding Precision");
        Remainder := Amount - AmountRnded;
        exit(AmountRnded);
    end;

    local procedure GetPurchOrderLine(var PurchOrderLine: Record "Purchase Line";PurchLine: Record "Purchase Line")
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.Get(PurchLine."Receipt No.",PurchLine."Receipt Line No.");
        PurchOrderLine.Get(
          PurchOrderLine."document type"::Order,
          PurchRcptLine."Order No.",PurchRcptLine."Order Line No.");
        PurchOrderLine."Prepmt Amt to Deduct" := PurchLine."Prepmt Amt to Deduct";
    end;

    local procedure Is100PctPrepmtInvoice(var TempPurchLine: Record "Purchase Line" temporary) Result: Boolean
    begin
        if TempPurchLine.IsEmpty then
          exit(false);
        TempPurchLine.SetFilter("Prepayment %",'<100');
        Result := TempPurchLine.IsEmpty;
        TempPurchLine.SetRange("Prepayment %");
    end;

    local procedure DecrementPrepmtAmtInvLCY(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";var PrepmtAmountInvLCY: Decimal;var PrepmtVATAmountInvLCY: Decimal)
    begin
        TempPrepmtDeductLCYPurchLine.Reset;
        TempPrepmtDeductLCYPurchLine := PurchLine;
        if TempPrepmtDeductLCYPurchLine.Find then begin
          if PurchHeader."Prepmt. Include Tax" then
            PrepmtAmountInvLCY := PrepmtAmountInvLCY - TempPrepmtDeductLCYPurchLine."Prepmt Amt to Deduct"
          else
            PrepmtAmountInvLCY := PrepmtAmountInvLCY - TempPrepmtDeductLCYPurchLine."Prepmt. Amount Inv. (LCY)";
          PrepmtVATAmountInvLCY := PrepmtVATAmountInvLCY - TempPrepmtDeductLCYPurchLine."Prepmt. VAT Amount Inv. (LCY)";
        end;
    end;

    local procedure AdjustFinalInvWith100PctPrepmt(var CombinedPurchLine: Record "Purchase Line")
    var
        DiffToLineDiscAmt: Decimal;
    begin
        with TempPrepmtDeductLCYPurchLine do begin
          Reset;
          SetRange("Prepayment %",100);
          if FindSet(true) then
            repeat
              if IsFinalInvoice then begin
                DiffToLineDiscAmt := "Prepmt Amt to Deduct" - "Line Amount";
                if "Document Type" = "document type"::Order then
                  DiffToLineDiscAmt := DiffToLineDiscAmt * Quantity / "Qty. to Invoice";
                if DiffToLineDiscAmt <> 0 then begin
                  CombinedPurchLine.Get("Document Type","Document No.","Line No.");
                  CombinedPurchLine."Line Discount Amount" -= DiffToLineDiscAmt;
                  CombinedPurchLine.Modify;

                  "Line Discount Amount" := CombinedPurchLine."Line Discount Amount";
                  Modify;
                end;
              end;
            until Next = 0;
          Reset;
        end;
    end;

    local procedure GetPrepmtDiffToLineAmount(PurchLine: Record "Purchase Line"): Decimal
    begin
        with TempPrepmtDeductLCYPurchLine do
          if PurchLine."Prepayment %" = 100 then
            if Get(PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.") then
              exit("Prepmt Amt to Deduct" - "Line Amount");
        exit(0);
    end;

    local procedure MergePurchLines(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line";var PurchLine2: Record "Purchase Line";var MergedPurchLine: Record "Purchase Line")
    begin
        with PurchLine do begin
          SetRange("Document Type",PurchHeader."Document Type");
          SetRange("Document No.",PurchHeader."No.");
          if Find('-') then
            repeat
              MergedPurchLine := PurchLine;
              MergedPurchLine.Insert;
            until Next = 0;
        end;
        with PurchLine2 do begin
          SetRange("Document Type",PurchHeader."Document Type");
          SetRange("Document No.",PurchHeader."No.");
          if Find('-') then
            repeat
              MergedPurchLine := PurchLine2;
              MergedPurchLine.Insert;
            until Next = 0;
        end;
    end;

    local procedure InsertICGenJnlLine(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";var ICGenJnlLineNo: Integer)
    var
        ICGLAccount: Record "IC G/L Account";
        Cust: Record Customer;
        Currency: Record Currency;
        ICPartner: Record "IC Partner";
        CurrExchRate: Record "Currency Exchange Rate";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        PurchHeader.TestField("Buy-from IC Partner Code",'');
        PurchHeader.TestField("Pay-to IC Partner Code",'');
        PurchLine.TestField("IC Partner Ref. Type",PurchLine."ic partner ref. type"::"G/L Account");
        ICGLAccount.Get(PurchLine."IC Partner Reference");
        ICGenJnlLineNo := ICGenJnlLineNo + 1;
        TempICGenJnlLine.Init;
        TempICGenJnlLine."Line No." := ICGenJnlLineNo;
        TempICGenJnlLine.Validate("Posting Date",PurchHeader."Posting Date");
        TempICGenJnlLine."Document Date" := PurchHeader."Document Date";
        TempICGenJnlLine.Description := PurchHeader."Posting Description";
        TempICGenJnlLine."Reason Code" := PurchHeader."Reason Code";
        TempICGenJnlLine."Document Type" := GenJnlLineDocType;
        TempICGenJnlLine."Document No." := GenJnlLineDocNo;
        TempICGenJnlLine."External Document No." := GenJnlLineExtDocNo;
        TempICGenJnlLine.Validate("Account Type",TempICGenJnlLine."account type"::"IC Partner");
        TempICGenJnlLine.Validate("Account No.",PurchLine."IC Partner Code");
        TempICGenJnlLine."Source Currency Code" := PurchHeader."Currency Code";
        TempICGenJnlLine."Source Currency Amount" := TempICGenJnlLine.Amount;
        TempICGenJnlLine.Correction := PurchHeader.Correction;
        TempICGenJnlLine."Source Code" := SrcCode;
        TempICGenJnlLine."Country/Region Code" := PurchHeader."VAT Country/Region Code";
        TempICGenJnlLine."Source Type" := GenJnlLine."source type"::Vendor;
        TempICGenJnlLine."Source No." := PurchHeader."Pay-to Vendor No.";
        TempICGenJnlLine."Source Line No." := PurchLine."Line No.";
        TempICGenJnlLine."Posting No. Series" := PurchHeader."Posting No. Series";
        TempICGenJnlLine.Validate("Bal. Account Type",TempICGenJnlLine."bal. account type"::"G/L Account");
        TempICGenJnlLine.Validate("Bal. Account No.",PurchLine."No.");
        TempICGenJnlLine."Shortcut Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
        TempICGenJnlLine."Shortcut Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
        TempICGenJnlLine."Dimension Set ID" := PurchLine."Dimension Set ID";
        Cust.SetRange("IC Partner Code",PurchLine."IC Partner Code");
        if Cust.FindFirst then begin
          TempICGenJnlLine.Validate("Bal. Gen. Bus. Posting Group",Cust."Gen. Bus. Posting Group");
          TempICGenJnlLine.Validate("Bal. VAT Bus. Posting Group",Cust."VAT Bus. Posting Group");
        end;
        TempICGenJnlLine.Validate("Bal. VAT Prod. Posting Group",PurchLine."VAT Prod. Posting Group");
        TempICGenJnlLine."IC Partner Code" := PurchLine."IC Partner Code";
        TempICGenJnlLine."IC Partner G/L Acc. No." := PurchLine."IC Partner Reference";
        TempICGenJnlLine."IC Direction" := TempICGenJnlLine."ic direction"::Outgoing;
        ICPartner.Get(PurchLine."IC Partner Code");
        if ICPartner."Cost Distribution in LCY" and (PurchLine."Currency Code" <> '') then begin
          TempICGenJnlLine."Currency Code" := '';
          TempICGenJnlLine."Currency Factor" := 0;
          Currency.Get(PurchLine."Currency Code");
          if PurchHeader.IsCreditDocType then
            TempICGenJnlLine.Amount :=
              -ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  PurchHeader."Posting Date",PurchLine."Currency Code",
                  PurchLine.Amount,PurchHeader."Currency Factor"))
          else
            TempICGenJnlLine.Amount :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  PurchHeader."Posting Date",PurchLine."Currency Code",
                  PurchLine.Amount,PurchHeader."Currency Factor"));
        end else begin
          Currency.InitRoundingPrecision;
          TempICGenJnlLine."Currency Code" := PurchHeader."Currency Code";
          TempICGenJnlLine."Currency Factor" := PurchHeader."Currency Factor";
          if PurchHeader.IsCreditDocType then
            TempICGenJnlLine.Amount := -PurchLine.Amount
          else
            TempICGenJnlLine.Amount := PurchLine.Amount;
        end;
        TempICGenJnlLine."Bal. VAT Calculation Type" := PurchLine."VAT Calculation Type";
        TempICGenJnlLine."Bal. Tax Area Code" := PurchLine."Tax Area Code";
        TempICGenJnlLine."Bal. Tax Liable" := PurchLine."Tax Liable";
        TempICGenJnlLine."Bal. Tax Group Code" := PurchLine."Tax Group Code";
        TempICGenJnlLine.Validate("Bal. VAT %");
        if TempICGenJnlLine."Bal. VAT %" <> 0 then
          TempICGenJnlLine.Amount := ROUND(TempICGenJnlLine.Amount * (1 + TempICGenJnlLine."Bal. VAT %" / 100),
              Currency."Amount Rounding Precision");
        TempICGenJnlLine.Validate(Amount);
        TempICGenJnlLine.Insert;
    end;

    local procedure PostICGenJnl()
    var
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
        ICTransactionNo: Integer;
    begin
        TempICGenJnlLine.Reset;
        if TempICGenJnlLine.Find('-') then
          repeat
            ICTransactionNo := ICInboxOutboxMgt.CreateOutboxJnlTransaction(TempICGenJnlLine,false);
            ICInboxOutboxMgt.CreateOutboxJnlLine(ICTransactionNo,1,TempICGenJnlLine);
            if TempICGenJnlLine.Amount <> 0 then
              GenJnlPostLine.RunWithCheck(TempICGenJnlLine);
          until TempICGenJnlLine.Next = 0;
    end;

    local procedure TestGetRcptPPmtAmtToDeduct()
    var
        TempPurchLine: Record "Purchase Line" temporary;
        TempRcvdPurchLine: Record "Purchase Line" temporary;
        TempTotalPurchLine: Record "Purchase Line" temporary;
        TempPurchRcptLine: Record "Purch. Rcpt. Line" temporary;
        PurchRcptLine: Record "Purch. Rcpt. Line";
        MaxAmtToDeduct: Decimal;
    begin
        with TempPurchLine do begin
          ResetTempLines(TempPurchLine);
          SetFilter(Quantity,'>0');
          SetFilter("Qty. to Invoice",'>0');
          SetFilter("Receipt No.",'<>%1','');
          SetFilter("Prepmt Amt to Deduct",'<>0');
          if IsEmpty then
            exit;

          SetRange("Prepmt Amt to Deduct");
          if FindSet then
            repeat
              if PurchRcptLine.Get("Receipt No.","Receipt Line No.") then begin
                TempRcvdPurchLine := TempPurchLine;
                TempRcvdPurchLine.Insert;
                TempPurchRcptLine := PurchRcptLine;
                if TempPurchRcptLine.Insert then;

                if not TempTotalPurchLine.Get("document type"::Order,PurchRcptLine."Order No.",PurchRcptLine."Order Line No.")
                then begin
                  TempTotalPurchLine.Init;
                  TempTotalPurchLine."Document Type" := "document type"::Order;
                  TempTotalPurchLine."Document No." := PurchRcptLine."Order No.";
                  TempTotalPurchLine."Line No." := PurchRcptLine."Order Line No.";
                  TempTotalPurchLine.Insert;
                end;
                TempTotalPurchLine."Qty. to Invoice" := TempTotalPurchLine."Qty. to Invoice" + "Qty. to Invoice";
                TempTotalPurchLine."Prepmt Amt to Deduct" := TempTotalPurchLine."Prepmt Amt to Deduct" + "Prepmt Amt to Deduct";
                AdjustInvLineWith100PctPrepmt(TempPurchLine,TempTotalPurchLine);
                TempTotalPurchLine.Modify;
              end;
            until Next = 0;

          if TempRcvdPurchLine.FindSet then
            repeat
              if TempPurchRcptLine.Get(TempRcvdPurchLine."Receipt No.",TempRcvdPurchLine."Receipt Line No.") then
                if   Get(TempRcvdPurchLine."document type"::Order,TempPurchRcptLine."Order No.",TempPurchRcptLine."Order Line No.") then
                  if TempTotalPurchLine.Get(
                       TempRcvdPurchLine."document type"::Order,TempPurchRcptLine."Order No.",TempPurchRcptLine."Order Line No.")
                  then begin
                    MaxAmtToDeduct := "Prepmt. Amt. Inv." - "Prepmt Amt Deducted";

                    if TempTotalPurchLine."Prepmt Amt to Deduct" > MaxAmtToDeduct then
                      Error(StrSubstNo(PrepAmountToDeductToBigErr,FieldCaption("Prepmt Amt to Deduct"),MaxAmtToDeduct));

                    if (TempTotalPurchLine."Qty. to Invoice" = Quantity - "Quantity Invoiced") and
                       (TempTotalPurchLine."Prepmt Amt to Deduct" <> MaxAmtToDeduct)
                    then
                      Error(StrSubstNo(PrepAmountToDeductToSmallErr,FieldCaption("Prepmt Amt to Deduct"),MaxAmtToDeduct));
                  end;
            until TempRcvdPurchLine.Next = 0;
        end;
    end;

    local procedure AdjustInvLineWith100PctPrepmt(var PurchInvoiceLine: Record "Purchase Line";var TempTotalPurchLine: Record "Purchase Line" temporary)
    var
        PurchOrderLine: Record "Purchase Line";
        DiffAmtToDeduct: Decimal;
    begin
        if PurchInvoiceLine."Prepayment %" = 100 then begin
          PurchOrderLine := TempTotalPurchLine;
          PurchOrderLine.Find;
          if TempTotalPurchLine."Qty. to Invoice" = PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced" then begin
            DiffAmtToDeduct :=
              PurchOrderLine."Prepmt. Amt. Inv." - PurchOrderLine."Prepmt Amt Deducted" - TempTotalPurchLine."Prepmt Amt to Deduct";
            if DiffAmtToDeduct <> 0 then begin
              PurchInvoiceLine."Prepmt Amt to Deduct" := PurchInvoiceLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
              PurchInvoiceLine."Line Amount" := PurchInvoiceLine."Prepmt Amt to Deduct";
              PurchInvoiceLine."Line Discount Amount" := PurchInvoiceLine."Line Discount Amount" - DiffAmtToDeduct;
              ModifyTempLine(PurchInvoiceLine);
              TempTotalPurchLine."Prepmt Amt to Deduct" := TempTotalPurchLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
            end;
          end;
        end;
    end;


    procedure ArchiveUnpostedOrder(PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        PurchSetup.Get;
        if not PurchSetup."Archive Quotes and Orders" then
          exit;
        if not (PurchHeader."Document Type" in [PurchHeader."document type"::Order,PurchHeader."document type"::"Return Order"]) then
          exit;

        PurchLine.Reset;
        PurchLine.SetRange("Document Type",PurchHeader."Document Type");
        PurchLine.SetRange("Document No.",PurchHeader."No.");
        PurchLine.SetFilter(Quantity,'<>0');
        if PurchHeader."Document Type" = PurchHeader."document type"::Order then
          PurchLine.SetFilter("Qty. to Receive",'<>0')
        else
          PurchLine.SetFilter("Return Qty. to Ship",'<>0');
        if not PurchLine.IsEmpty and not PreviewMode then begin
          RoundDeferralsForArchive(PurchHeader,PurchLine);
          ArchiveManagement.ArchPurchDocumentNoConfirm(PurchHeader);
        end;
    end;

    local procedure PostItemJnlLineJobConsumption(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line";ItemJournalLine: Record "Item Journal Line";var TempPurchReservEntry: Record "Reservation Entry" temporary;QtyToBeInvoiced: Decimal;QtyToBeReceived: Decimal)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempReservationEntry: Record "Reservation Entry" temporary;
    begin
        with PurchLine do
          if "Job No." <> '' then begin
            ItemJournalLine."Entry Type" := ItemJournalLine."entry type"::"Negative Adjmt.";
            Job.Get("Job No.");
            ItemJournalLine."Source No." := Job."Bill-to Customer No.";
            if PurchHeader.Invoice then begin
              ItemLedgEntry.Reset;
              ItemLedgEntry.SetRange("Document No.",ReturnShptLine."Document No.");
              ItemLedgEntry.SetRange("Item No.",ReturnShptLine."No.");
              ItemLedgEntry.SetRange("Entry Type",ItemLedgEntry."entry type"::"Negative Adjmt.");
              ItemLedgEntry.SetRange("Completely Invoiced",false);
              if ItemLedgEntry.FindFirst then
                ItemJournalLine."Item Shpt. Entry No." := ItemLedgEntry."Entry No.";
            end;
            ItemJournalLine."Source Type" := ItemJournalLine."source type"::Customer;
            ItemJournalLine."Discount Amount" := 0;
            if "Quantity Received" <> 0 then
              GetNextItemLedgEntryNo(ItemJournalLine);

            if QtyToBeReceived <> 0 then
              CopyJobConsumptionReservation(
                TempReservationEntry,TempPurchReservEntry,ItemJournalLine."Entry Type",ItemJournalLine."Line No.");

            ItemJnlPostLine.RunPostWithReservation(ItemJournalLine,TempReservationEntry);

            if QtyToBeInvoiced <> 0 then begin
              "Qty. to Invoice" := QtyToBeInvoiced;
              JobPostLine.PostJobOnPurchaseLine(PurchHeader,PurchInvHeader,PurchCrMemoHeader,PurchLine,SrcCode);
            end;
          end;
    end;

    local procedure CopyJobConsumptionReservation(var TempReservEntryJobCons: Record "Reservation Entry" temporary;var TempReservEntryPurchase: Record "Reservation Entry" temporary;SourceSubtype: Option;SourceRefNo: Integer)
    var
        NextReservationEntryNo: Integer;
    begin
        // Item tracking for consumption
        NextReservationEntryNo := 1;
        if TempReservEntryPurchase.FindSet then
          repeat
            TempReservEntryJobCons := TempReservEntryPurchase;

            with TempReservEntryJobCons do begin
              "Entry No." := NextReservationEntryNo;
              Positive := not Positive;
              "Quantity (Base)" := -"Quantity (Base)";
              "Shipment Date" := "Expected Receipt Date";
              "Expected Receipt Date" := 0D;
              Quantity := -Quantity;
              "Qty. to Handle (Base)" := -"Qty. to Handle (Base)";
              "Qty. to Invoice (Base)" := -"Qty. to Invoice (Base)";
              "Source Subtype" := SourceSubtype;
              "Source Ref. No." := SourceRefNo;
              Insert;
            end;

            NextReservationEntryNo := NextReservationEntryNo + 1;
          until TempReservEntryPurchase.Next = 0;
    end;

    local procedure GetNextItemLedgEntryNo(var ItemJnlLine: Record "Item Journal Line")
    var
        ItemApplicationEntry: Record "Item Application Entry";
    begin
        with ItemApplicationEntry do begin
          SetRange("Inbound Item Entry No.",ItemJnlLine."Item Shpt. Entry No.");
          if FindLast then
            ItemJnlLine."Item Shpt. Entry No." := "Outbound Item Entry No.";
        end
    end;

    local procedure ItemLedgerEntryExist(PurchLine2: Record "Purchase Line";ReceiveOrShip: Boolean): Boolean
    var
        HasItemLedgerEntry: Boolean;
    begin
        if ReceiveOrShip then
          // item ledger entry will be created during posting in this transaction
          HasItemLedgerEntry :=
            ((PurchLine2."Qty. to Receive" + PurchLine2."Quantity Received") <> 0) or
            ((PurchLine2."Qty. to Invoice" + PurchLine2."Quantity Invoiced") <> 0) or
            ((PurchLine2."Return Qty. to Ship" + PurchLine2."Return Qty. Shipped") <> 0)
        else
          // item ledger entry must already exist
          HasItemLedgerEntry :=
            (PurchLine2."Quantity Received" <> 0) or
            (PurchLine2."Return Qty. Shipped" <> 0);

        exit(HasItemLedgerEntry);
    end;

    local procedure LockTables()
    var
        PurchLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
    begin
        PurchLine.LockTable;
        SalesLine.LockTable;
        GetGLSetup;
        if not GLSetup.OptimGLEntLockForMultiuserEnv then begin
          GLEntry.LockTable;
          if GLEntry.FindLast then;
        end;
    end;

    local procedure "MAX"(number1: Integer;number2: Integer): Integer
    begin
        if number1 > number2 then
          exit(number1);
        exit(number2);
    end;

    local procedure CreateJobPurchLine(var JobPurchLine2: Record "Purchase Line";PurchLine2: Record "Purchase Line";PricesIncludingVAT: Boolean)
    begin
        JobPurchLine2 := PurchLine2;
        if PricesIncludingVAT then
          if JobPurchLine2."VAT Calculation Type" = JobPurchLine2."vat calculation type"::"Full VAT" then
            JobPurchLine2."Direct Unit Cost" := 0
          else
            JobPurchLine2."Direct Unit Cost" := JobPurchLine2."Direct Unit Cost" / (1 + JobPurchLine2."VAT %" / 100);
    end;

    local procedure AddSalesTaxLineToSalesTaxCalc(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";FirstLine: Boolean)
    var
        MaxInvQty: Decimal;
        MaxInvQtyBase: Decimal;
    begin
        if FirstLine then begin
          TempPurchLineForSalesTax.DeleteAll;
          TempSalesTaxAmtLine.Reset;
          TempSalesTaxAmtLine.DeleteAll;
          SalesTaxCalculate.StartSalesTaxCalculation;
        end;
        TempPurchLineForSalesTax := PurchLine;
        with TempPurchLineForSalesTax do begin
          if "Qty. per Unit of Measure" = 0 then
            "Qty. per Unit of Measure" := 1;
          if "Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"] then begin
            if "Return Shipment No." <> '' then begin
              "Return Qty. Shipped" := Quantity;
              "Return Qty. Shipped (Base)" := "Quantity (Base)";
              "Return Qty. to Ship" := 0;
              "Return Qty. to Ship (Base)" := 0;
            end;
            MaxInvQty := ("Return Qty. Shipped" - "Quantity Invoiced");
            MaxInvQtyBase := ("Return Qty. Shipped (Base)" - "Qty. Invoiced (Base)");
            if PurchHeader.Ship then begin
              MaxInvQty := MaxInvQty + "Return Qty. to Ship";
              MaxInvQtyBase := MaxInvQtyBase + "Return Qty. to Ship (Base)";
            end;
          end else begin
            if "Receipt No." = '' then begin
              MaxInvQty := ("Quantity Received" - "Quantity Invoiced");
              MaxInvQtyBase := ("Qty. Received (Base)" - "Qty. Invoiced (Base)");
            end else begin
              "Quantity Received" := Quantity;
              "Qty. Received (Base)" := "Quantity (Base)";
              "Qty. to Receive" := 0;
              "Qty. to Receive (Base)" := 0;
              MaxInvQty := (Quantity - "Quantity Invoiced");
              MaxInvQtyBase := ("Quantity (Base)" - "Qty. Invoiced (Base)");
            end;
            if PurchHeader.Receive then begin
              MaxInvQty := MaxInvQty + "Qty. to Receive";
              MaxInvQtyBase := MaxInvQtyBase + "Qty. to Receive (Base)";
            end;
          end;
          if Abs("Qty. to Invoice") > Abs(MaxInvQty) then begin
            "Qty. to Invoice" := MaxInvQty;
            "Qty. to Invoice (Base)" := MaxInvQtyBase;
          end;
          if Quantity = 0 then
            "Inv. Disc. Amount to Invoice" := 0
          else
            "Inv. Disc. Amount to Invoice" :=
              ROUND(
                "Inv. Discount Amount" * "Qty. to Invoice" / Quantity,
                Currency."Amount Rounding Precision");
          "Quantity (Base)" := "Qty. to Invoice (Base)";
          "Line Amount" := ROUND("Qty. to Invoice" * "Direct Unit Cost",Currency."Amount Rounding Precision");
          if Quantity <> "Qty. to Invoice" then
            "Line Discount Amount" :=
              ROUND("Line Amount" * "Line Discount %" / 100,Currency."Amount Rounding Precision");
          Quantity := "Qty. to Invoice";
          "Line Amount" := "Line Amount" - "Line Discount Amount";
          "Inv. Discount Amount" := "Inv. Disc. Amount to Invoice";
          Amount := "Line Amount" - "Inv. Discount Amount";
          "VAT Base Amount" := Amount;
          Insert;
        end;
        if not UseExternalTaxEngine then
          SalesTaxCalculate.AddPurchLine(TempPurchLineForSalesTax);
    end;

    local procedure RevertWarehouseEntry(var TempWhseJnlLine: Record "Warehouse Journal Line" temporary;JobNo: Code[20];PostJobConsumptionBeforePurch: Boolean): Boolean
    begin
        if PostJobConsumptionBeforePurch or (JobNo = '') or PositiveWhseEntrycreated then
          exit(false);
        with TempWhseJnlLine do begin
          "Entry Type" := "entry type"::"Negative Adjmt.";
          Quantity := -Quantity;
          "Qty. (Base)" := -"Qty. (Base)";
          "From Bin Code" := "To Bin Code";
          "To Bin Code" := '';
        end;
        exit(true);
    end;

    local procedure CreatePositiveEntry(WhseJnlLine: Record "Warehouse Journal Line";JobNo: Code[20];PostJobConsumptionBeforePurch: Boolean)
    begin
        if PostJobConsumptionBeforePurch or (JobNo <> '') then begin
          with WhseJnlLine do begin
            Quantity := -Quantity;
            "Qty. (Base)" := -"Qty. (Base)";
            "Qty. (Absolute)" := -"Qty. (Absolute)";
            "To Bin Code" := "From Bin Code";
            "From Bin Code" := '';
          end;
          WhseJnlPostLine.Run(WhseJnlLine);
          PositiveWhseEntrycreated := true;
        end;
    end;

    local procedure PostSalesTaxToGL(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";LineCount: Integer;var TotalUseTaxAmount: Decimal)
    var
        TaxJurisdiction: Record "Tax Jurisdiction";
        CurrExchRate: Record "Currency Exchange Rate";
        VendPostingGr: Record "Vendor Posting Group";
        GenJnlLine: Record "Gen. Journal Line";
        TaxLineCount: Integer;
        RemSalesTaxAmt: Decimal;
        RemSalesTaxSrcAmt: Decimal;
        UseTaxRemSalesTaxAmt: Decimal;
    begin
        TaxLineCount := 0;
        RemSalesTaxAmt := 0;
        RemSalesTaxSrcAmt := 0;

        if (PurchHeader."Currency Code" <> '') and SalesTaxExists then
          TotalPurchLineLCY."Amount Including VAT" := TotalPurchLineLCY.Amount;

        TempSalesTaxAmtLine.Reset;
        TempSalesTaxAmtLine.SetRange("Expense/Capitalize",false);
        if TempSalesTaxAmtLine.Find('-') then begin
          repeat
            TaxLineCount := TaxLineCount + 1;
            if GuiAllowed then
              Window.Update(3,StrSubstNo('%1 / %2',LineCount,TaxLineCount));
            if ((TempSalesTaxAmtLine."Tax Base Amount" <> 0) and
                (TempSalesTaxAmtLine."Tax Type" = TempSalesTaxAmtLine."tax type"::"Sales and Use Tax")) or
               ((TempSalesTaxAmtLine.Quantity <> 0) and
                (TempSalesTaxAmtLine."Tax Type" = TempSalesTaxAmtLine."tax type"::"Excise Tax"))
            then begin
              GenJnlLine.Init;
              GenJnlLine."Posting Date" := PurchHeader."Posting Date";
              GenJnlLine."Document Date" := PurchHeader."Document Date";
              GenJnlLine.Description := PurchHeader."Posting Description";
              GenJnlLine."Reason Code" := PurchHeader."Reason Code";
              GenJnlLine."Document Type" := GenJnlLineDocType;
              GenJnlLine."Document No." := GenJnlLineDocNo;
              GenJnlLine."External Document No." := GenJnlLineExtDocNo;
              GenJnlLine."System-Created Entry" := true;
              GenJnlLine.Amount := 0;
              GenJnlLine."Source Currency Code" := PurchHeader."Currency Code";
              GenJnlLine."Source Currency Amount" := 0;
              GenJnlLine.Correction := PurchHeader.Correction;
              GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::Purchase;
              GenJnlLine."Tax Area Code" := TempSalesTaxAmtLine."Tax Area Code";
              GenJnlLine."Tax Type" := TempSalesTaxAmtLine."Tax Type";
              GenJnlLine."Tax Group Code" := TempSalesTaxAmtLine."Tax Group Code";
              GenJnlLine."Tax Liable" := TempSalesTaxAmtLine."Tax Liable";
              GenJnlLine."Use Tax" := TempSalesTaxAmtLine."Use Tax";
              GenJnlLine.Quantity := TempSalesTaxAmtLine.Quantity;
              GenJnlLine."VAT Calculation Type" := GenJnlLine."vat calculation type"::"Sales Tax";
              GenJnlLine."VAT Posting" := GenJnlLine."vat posting"::"Manual VAT Entry";
              GenJnlLine."Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
              GenJnlLine."Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
              GenJnlLine."Dimension Set ID" := PurchHeader."Dimension Set ID";
              GenJnlLine."Source Code" := SrcCode;
              GenJnlLine."Bill-to/Pay-to No." := PurchHeader."Buy-from Vendor No.";
              GenJnlLine."Source Type" := GenJnlLine."source type"::Vendor;
              GenJnlLine."Source No." := PurchHeader."Pay-to Vendor No.";
              GenJnlLine."Posting No. Series" := PurchHeader."Posting No. Series";
              GenJnlLine."STE Transaction ID" := PurchHeader."STE Transaction ID";
              GenJnlLine."Source Curr. VAT Base Amount" := TempSalesTaxAmtLine."Tax Base Amount";
              GenJnlLine."VAT Base Amount (LCY)" :=
                ROUND(TempSalesTaxAmtLine."Tax Base Amount");
              GenJnlLine."VAT Base Amount" := GenJnlLine."VAT Base Amount (LCY)";
              GenJnlLine."GST/HST" := PurchLine."GST/HST";

              if TaxJurisdiction.Code <> TempSalesTaxAmtLine."Tax Jurisdiction Code" then begin
                TaxJurisdiction.Get(TempSalesTaxAmtLine."Tax Jurisdiction Code");
                if SalesTaxCountry = Salestaxcountry::CA then begin
                  RemSalesTaxAmt := 0;
                  RemSalesTaxSrcAmt := 0;
                end;
              end;
              if TaxJurisdiction."Unrealized VAT Type" > 0 then
                if GenJnlLine."Use Tax" then begin
                  TaxJurisdiction.TestField("Unreal. Rev. Charge (Purch.)");
                  GenJnlLine."Account No." := TaxJurisdiction."Unreal. Rev. Charge (Purch.)";
                end else begin
                  TaxJurisdiction.TestField("Unreal. Tax Acc. (Purchases)");
                  GenJnlLine."Account No." := TaxJurisdiction."Unreal. Tax Acc. (Purchases)";
                end
              else
                if GenJnlLine."Use Tax" then begin
                  TaxJurisdiction.TestField("Reverse Charge (Purchases)");
                  GenJnlLine."Account No." := TaxJurisdiction."Reverse Charge (Purchases)";
                end else begin
                  TaxJurisdiction.TestField("Tax Account (Purchases)");
                  GenJnlLine."Account No." := TaxJurisdiction."Tax Account (Purchases)";
                end;
              GenJnlLine."Tax Jurisdiction Code" := TempSalesTaxAmtLine."Tax Jurisdiction Code";
              if TempSalesTaxAmtLine."Tax Amount" <> 0 then begin
                RemSalesTaxSrcAmt := RemSalesTaxSrcAmt +
                  TempSalesTaxAmtLine."Tax Base Amount FCY" * TempSalesTaxAmtLine."Tax %" / 100;
                GenJnlLine."Source Curr. VAT Amount" := ROUND(RemSalesTaxSrcAmt,Currency."Amount Rounding Precision");
                RemSalesTaxSrcAmt := RemSalesTaxSrcAmt - GenJnlLine."Source Curr. VAT Amount";
                if GenJnlLine."Use Tax" then begin
                  GenJnlLine."VAT Amount (LCY)" :=
                    RoundSalesTaxAmount(UseTaxRemSalesTaxAmt,TempSalesTaxAmtLine."Tax Amount");
                  if PurchHeader."Currency Code" <> '' then
                    TotalUseTaxAmount += GenJnlLine."VAT Amount (LCY)";
                end else
                  GenJnlLine."VAT Amount (LCY)" :=
                    RoundSalesTaxAmount(RemSalesTaxAmt,TempSalesTaxAmtLine."Tax Amount");
                GenJnlLine."VAT Amount" := GenJnlLine."VAT Amount (LCY)";
              end;
              GenJnlLine."VAT Difference" := TempSalesTaxAmtLine."Tax Difference";

              if (PurchHeader."Document Type" in
                  [PurchHeader."document type"::"Return Order",PurchHeader."document type"::"Credit Memo"])
              then begin
                GenJnlLine."Source Curr. VAT Base Amount" := -GenJnlLine."Source Curr. VAT Base Amount";
                GenJnlLine."VAT Base Amount (LCY)" := -GenJnlLine."VAT Base Amount (LCY)";
                GenJnlLine."VAT Base Amount" := -GenJnlLine."VAT Base Amount";
                GenJnlLine."Source Curr. VAT Amount" := -GenJnlLine."Source Curr. VAT Amount";
                GenJnlLine."VAT Amount (LCY)" := -GenJnlLine."VAT Amount (LCY)";
                GenJnlLine."VAT Amount" := -GenJnlLine."VAT Amount";
                GenJnlLine.Quantity := -GenJnlLine.Quantity;
                GenJnlLine."VAT Difference" := -GenJnlLine."VAT Difference";
              end;
              if (PurchHeader."Currency Code" <> '') and not GenJnlLine."Use Tax" then
                TotalPurchLineLCY."Amount Including VAT" :=
                  TotalPurchLineLCY."Amount Including VAT" + GenJnlLine."VAT Amount (LCY)";

              GenJnlPostLine.RunWithCheck(GenJnlLine);
            end;
          until TempSalesTaxAmtLine.Next = 0;

          // Sales Tax rounding adjustment for Invoice with 100% Prepayment
          if PurchHeader.Invoice and PurchHeader."Prepmt. Include Tax" and (TotalPurchLineLCY."Prepayment %" = 100) and
             ((TotalPurchLine."Amount Including VAT" <> 0) or (TotalPurchLineLCY."Amount Including VAT" <> 0))
          then begin
            GenJnlLine.Init;
            GenJnlLine."Posting Date" := PurchHeader."Posting Date";
            GenJnlLine."Document Date" := PurchHeader."Document Date";
            GenJnlLine.Description := PurchHeader."Posting Description";
            GenJnlLine."Reason Code" := PurchHeader."Reason Code";
            GenJnlLine."Document Type" := GenJnlLineDocType;
            GenJnlLine."Document No." := GenJnlLineDocNo;
            GenJnlLine."External Document No." := GenJnlLineExtDocNo;
            GenJnlLine."System-Created Entry" := true;
            VendPostingGr.Get(PurchHeader."Vendor Posting Group");
            VendPostingGr.TestField("Invoice Rounding Account");
            GenJnlLine."Account No." := VendPostingGr."Invoice Rounding Account";
            GenJnlLine."Currency Code" := PurchHeader."Currency Code";
            GenJnlLine.Amount := -TotalPurchLine."Amount Including VAT";
            GenJnlLine."Source Currency Code" := PurchHeader."Currency Code";
            GenJnlLine."Source Currency Amount" := -TotalPurchLine."Amount Including VAT";
            GenJnlLine."Amount (LCY)" := -TotalPurchLineLCY."Amount Including VAT";
            if PurchHeader."Currency Code" = '' then
              GenJnlLine."Currency Factor" := 1
            else
              GenJnlLine."Currency Factor" := PurchHeader."Currency Factor";
            GenJnlLine.Correction := PurchHeader.Correction;
            GenJnlLine."Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := PurchHeader."Dimension Set ID";
            GenJnlPostLine.RunWithCheck(GenJnlLine);

            TotalPurchLine."Amount Including VAT" := 0;
            TotalPurchLineLCY."Amount Including VAT" := 0;
          end;
        end;
    end;

    local procedure CalcProvincialSalesTax(PurchHeader: Record "Purchase Header")
    var
        TempPurchLineForProvSalesTax: Record "Purchase Line" temporary;
        TaxAreaLine: Record "Tax Area Line";
        TaxJurisdiction: Record "Tax Jurisdiction";
    begin
        if (TaxOption <> Taxoption::SalesTax) or (SalesTaxCountry <> Salestaxcountry::CA) then
          exit;
        TempPurchLineForProvSalesTax.DeleteAll;
        TempProvSalesTaxAmtLine.Reset;
        TempProvSalesTaxAmtLine.DeleteAll;
        ProvTaxToBeExpensed := 0;

        TempPurchLineForSalesTax.Reset;
        TempPurchLineForSalesTax.SetFilter("Provincial Tax Area Code",'<>%1','');
        if TempPurchLineForSalesTax.FindSet then begin
          SalesTaxCalculate.StartSalesTaxCalculation;
          repeat
            TempPurchLineForProvSalesTax := TempPurchLineForSalesTax;
            TempPurchLineForProvSalesTax."Tax Area Code" := TempPurchLineForProvSalesTax."Provincial Tax Area Code";
            if TaxArea.Code <> TempPurchLineForProvSalesTax."Provincial Tax Area Code" then
              TaxArea.Get(TempPurchLineForProvSalesTax."Provincial Tax Area Code");
            if TaxArea."Country/Region" = TaxArea."country/region"::CA then begin
              if TaxAreaLine."Tax Area" <> TempPurchLineForProvSalesTax."Provincial Tax Area Code" then begin
                TaxAreaLine.SetRange("Tax Area",TempPurchLineForProvSalesTax."Provincial Tax Area Code");
                TaxAreaLine.FindFirst;
              end;
              if TaxJurisdiction.Code <> TaxAreaLine."Tax Jurisdiction Code" then
                TaxJurisdiction.Get(TaxAreaLine."Tax Jurisdiction Code");
              if TaxJurisdiction."Calculate Tax on Tax" then
                TempPurchLineForProvSalesTax."Line Amount" :=
                  TempPurchLineForProvSalesTax."Amount Including VAT" +
                  TempPurchLineForProvSalesTax."Inv. Discount Amount";
              TempPurchLineForProvSalesTax.Insert;
              SalesTaxCalculate.AddPurchLine(TempPurchLineForProvSalesTax);
            end;
          until TempPurchLineForSalesTax.Next = 0;
        end;
        TempPurchLineForSalesTax.Reset;
        if TempPurchLineForProvSalesTax.FindFirst then begin
          SalesTaxCalculate.EndSalesTaxCalculation(PurchHeader."Posting Date");
          SalesTaxCalculate.GetSalesTaxAmountLineTable(TempProvSalesTaxAmtLine);
          SalesTaxCalculate.DistTaxOverPurchLines(TempPurchLineForProvSalesTax);
          TempPurchLineForProvSalesTax.FindSet;
          repeat
            if TempPurchLineForProvSalesTax."Tax To Be Expensed" <> 0 then begin
              TempPurchLineForSalesTax.Get(
                TempPurchLineForProvSalesTax."Document Type",
                TempPurchLineForProvSalesTax."Document No.",
                TempPurchLineForProvSalesTax."Line No.");
              ProvTaxToBeExpensed += TempPurchLineForProvSalesTax."Tax To Be Expensed";
              TempPurchLineForSalesTax."Tax To Be Expensed" :=
                TempPurchLineForSalesTax."Tax To Be Expensed" +
                TempPurchLineForProvSalesTax."Tax To Be Expensed";
              TempPurchLineForSalesTax.Modify;
            end;
          until TempPurchLineForProvSalesTax.Next = 0;
        end;
    end;

    local procedure PostProvincialSalesTaxToGL(PurchHeader: Record "Purchase Header";var TotalUseTaxAmount: Decimal)
    var
        TaxJurisdiction: Record "Tax Jurisdiction";
        GenJnlLine: Record "Gen. Journal Line";
        RemSalesTaxAmt: Decimal;
        RemSalesTaxSrcAmt: Decimal;
    begin
        if (TaxOption <> Taxoption::SalesTax) or (SalesTaxCountry <> Salestaxcountry::CA) then
          exit;

        RemSalesTaxAmt := 0;
        RemSalesTaxSrcAmt := 0;
        TempProvSalesTaxAmtLine.Reset;
        if TempProvSalesTaxAmtLine.FindSet then
          repeat
            if ((TempProvSalesTaxAmtLine."Tax Base Amount" <> 0) and
                (TempProvSalesTaxAmtLine."Tax Type" = TempProvSalesTaxAmtLine."tax type"::"Sales and Use Tax")) or
               ((TempProvSalesTaxAmtLine.Quantity <> 0) and
                (TempProvSalesTaxAmtLine."Tax Type" = TempProvSalesTaxAmtLine."tax type"::"Excise Tax"))
            then begin
              GenJnlLine.Init;
              GenJnlLine."Posting Date" := PurchHeader."Posting Date";
              GenJnlLine."Document Date" := PurchHeader."Document Date";
              GenJnlLine.Description := PurchHeader."Posting Description";
              GenJnlLine."Reason Code" := PurchHeader."Reason Code";
              GenJnlLine."Document Type" := GenJnlLineDocType;
              GenJnlLine."Document No." := GenJnlLineDocNo;
              GenJnlLine."External Document No." := GenJnlLineExtDocNo;
              GenJnlLine."System-Created Entry" := true;
              GenJnlLine.Amount := 0;
              GenJnlLine."Source Currency Code" := PurchHeader."Currency Code";
              GenJnlLine."Source Currency Amount" := 0;
              GenJnlLine.Correction := PurchHeader.Correction;
              GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::Purchase;
              GenJnlLine."Tax Area Code" := TempProvSalesTaxAmtLine."Tax Area Code";
              GenJnlLine."Tax Type" := TempProvSalesTaxAmtLine."Tax Type";
              GenJnlLine."Tax Group Code" := TempProvSalesTaxAmtLine."Tax Group Code";
              GenJnlLine."Tax Liable" := true;
              GenJnlLine."Use Tax" := true;
              GenJnlLine.Quantity := TempProvSalesTaxAmtLine.Quantity;
              GenJnlLine."VAT Calculation Type" := GenJnlLine."vat calculation type"::"Sales Tax";
              GenJnlLine."VAT Posting" := GenJnlLine."vat posting"::"Manual VAT Entry";
              GenJnlLine."Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
              GenJnlLine."Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
              GenJnlLine."Dimension Set ID" := PurchHeader."Dimension Set ID";
              GenJnlLine."Source Code" := SrcCode;
              GenJnlLine."Bill-to/Pay-to No." := PurchHeader."Buy-from Vendor No.";
              GenJnlLine."Source Type" := GenJnlLine."source type"::Vendor;
              GenJnlLine."Source No." := PurchHeader."Pay-to Vendor No.";
              GenJnlLine."Posting No. Series" := PurchHeader."Posting No. Series";
              GenJnlLine."Source Curr. VAT Base Amount" := TempProvSalesTaxAmtLine."Tax Base Amount";
              GenJnlLine."VAT Base Amount (LCY)" :=
                ROUND(TempProvSalesTaxAmtLine."Tax Base Amount");
              GenJnlLine."VAT Base Amount" := GenJnlLine."VAT Base Amount (LCY)";

              if TaxJurisdiction.Code <> TempProvSalesTaxAmtLine."Tax Jurisdiction Code" then begin
                TaxJurisdiction.Get(TempProvSalesTaxAmtLine."Tax Jurisdiction Code");
                RemSalesTaxAmt := 0;
                RemSalesTaxSrcAmt := 0;
              end;
              if TaxJurisdiction."Unrealized VAT Type" > 0 then begin
                TaxJurisdiction.TestField("Unreal. Rev. Charge (Purch.)");
                GenJnlLine."Account No." := TaxJurisdiction."Unreal. Rev. Charge (Purch.)";
              end else begin
                TaxJurisdiction.TestField("Reverse Charge (Purchases)");
                GenJnlLine."Account No." := TaxJurisdiction."Reverse Charge (Purchases)";
              end;
              GenJnlLine."Tax Jurisdiction Code" := TempProvSalesTaxAmtLine."Tax Jurisdiction Code";
              if TempProvSalesTaxAmtLine."Tax Amount" <> 0 then begin
                RemSalesTaxSrcAmt := RemSalesTaxSrcAmt +
                  TempSalesTaxAmtLine."Tax Base Amount FCY" * TempSalesTaxAmtLine."Tax %" / 100;
                GenJnlLine."Source Curr. VAT Amount" := ROUND(RemSalesTaxSrcAmt,Currency."Amount Rounding Precision");
                RemSalesTaxSrcAmt := RemSalesTaxSrcAmt - GenJnlLine."Source Curr. VAT Amount";
                RemSalesTaxAmt := RemSalesTaxAmt + TempProvSalesTaxAmtLine."Tax Amount";
                GenJnlLine."VAT Amount (LCY)" := ROUND(RemSalesTaxAmt,GLSetup."Amount Rounding Precision");
                RemSalesTaxAmt := RemSalesTaxAmt - GenJnlLine."VAT Amount (LCY)";
                GenJnlLine."VAT Amount" := GenJnlLine."VAT Amount (LCY)";
                if PurchHeader."Currency Code" <> '' then
                  TotalUseTaxAmount += GenJnlLine."VAT Amount (LCY)";
              end;
              GenJnlLine."VAT Difference" := 0;

              if (PurchHeader."Document Type" in
                  [PurchHeader."document type"::"Return Order",PurchHeader."document type"::"Credit Memo"])
              then begin
                GenJnlLine."Source Curr. VAT Base Amount" := -GenJnlLine."Source Curr. VAT Base Amount";
                GenJnlLine."VAT Base Amount (LCY)" := -GenJnlLine."VAT Base Amount (LCY)";
                GenJnlLine."VAT Base Amount" := -GenJnlLine."VAT Base Amount";
                GenJnlLine."Source Curr. VAT Amount" := -GenJnlLine."Source Curr. VAT Amount";
                GenJnlLine."VAT Amount (LCY)" := -GenJnlLine."VAT Amount (LCY)";
                GenJnlLine."VAT Amount" := -GenJnlLine."VAT Amount";
                GenJnlLine.Quantity := -GenJnlLine.Quantity;
                GenJnlLine."VAT Difference" := -GenJnlLine."VAT Difference";
              end;

              GenJnlPostLine.RunWithCheck(GenJnlLine);

              if not TempProvSalesTaxAmtLine."Expense/Capitalize" then begin
                if TaxJurisdiction."Unrealized VAT Type" > 0 then begin
                  TaxJurisdiction.TestField("Unreal. Tax Acc. (Purchases)");
                  GenJnlLine."Account No." := TaxJurisdiction."Unreal. Tax Acc. (Purchases)";
                end else begin
                  TaxJurisdiction.TestField("Tax Account (Purchases)");
                  GenJnlLine."Account No." := TaxJurisdiction."Tax Account (Purchases)";
                end;
                GenJnlLine.Amount := GenJnlLine."VAT Amount";
                GenJnlLine."Source Currency Amount" := GenJnlLine."Source Curr. VAT Amount";
                GenJnlLine."Source Curr. VAT Base Amount" := 0;
                GenJnlLine."VAT Base Amount (LCY)" := 0;
                GenJnlLine."VAT Base Amount" := 0;
                GenJnlLine."VAT Amount (LCY)" := 0;
                GenJnlLine."VAT Amount" := 0;
                GenJnlLine.Quantity := 0;
                GenJnlLine."VAT Difference" := 0;
                GenJnlLine."Gen. Posting Type" := 0;
                GenJnlLine."Tax Area Code" := '';
                GenJnlLine."Tax Group Code" := '';
                GenJnlLine."Tax Jurisdiction Code" := '';
                GenJnlLine."Tax Liable" := false;
                GenJnlLine."Use Tax" := false;
                GenJnlPostLine.RunWithCheck(GenJnlLine);
              end;
            end;
          until TempProvSalesTaxAmtLine.Next = 0;
    end;

    local procedure UpdateIncomingDocument(IncomingDocNo: Integer;PostingDate: Date;GenJnlLineDocNo: Code[20])
    var
        IncomingDocument: Record "Incoming Document";
    begin
        IncomingDocument.UpdateIncomingDocumentFromPosting(IncomingDocNo,PostingDate,GenJnlLineDocNo);
    end;

    local procedure CheckItemCharge(ItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)")
    var
        PurchLineForCharge: Record "Purchase Line";
    begin
        with ItemChargeAssignmentPurch do
          case "Applies-to Doc. Type" of
            "applies-to doc. type"::Order,
            "applies-to doc. type"::Invoice:
              if PurchLineForCharge.Get("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.") then
                if (PurchLineForCharge."Quantity (Base)" = PurchLineForCharge."Qty. Received (Base)") and
                   (PurchLineForCharge."Qty. Rcd. Not Invoiced (Base)" = 0)
                then
                  Error(ReassignItemChargeErr);
            "applies-to doc. type"::"Return Order",
            "applies-to doc. type"::"Credit Memo":
              if PurchLineForCharge.Get("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.") then
                if (PurchLineForCharge."Quantity (Base)" = PurchLineForCharge."Return Qty. Shipped (Base)") and
                   (PurchLineForCharge."Ret. Qty. Shpd Not Invd.(Base)" = 0)
                then
                  Error(ReassignItemChargeErr);
          end;
    end;


    procedure InitProgressWindow(PurchHeader: Record "Purchase Header")
    begin
        if PurchHeader.Invoice then
          Window.Open(
            '#1#################################\\' +
            PostingLinesMsg +
            PostingPurchasesAndVATMsg +
            PostingVendorsMsg +
            PostingBalAccountMsg)
        else
          Window.Open(
            '#1############################\\' +
            PostingLines2Msg);

        Window.Update(1,StrSubstNo('%1 %2',PurchHeader."Document Type",PurchHeader."No."));
    end;


    procedure SetPreviewMode(NewPreviewMode: Boolean)
    begin
        PreviewMode := NewPreviewMode;
    end;

    local procedure UpdateQtyPerUnitOfMeasure(var PurchLine: Record "Purchase Line")
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        if PurchLine."Qty. per Unit of Measure" = 0 then
          if (PurchLine.Type = PurchLine.Type::Item) and
             (PurchLine."Unit of Measure" <> '') and
             ItemUnitOfMeasure.Get(PurchLine."No.",PurchLine."Unit of Measure")
          then
            PurchLine."Qty. per Unit of Measure" := ItemUnitOfMeasure."Qty. per Unit of Measure"
          else
            PurchLine."Qty. per Unit of Measure" := 1;
    end;

    local procedure UpdateQtyToBeInvoiced(var QtyToBeInvoiced: Decimal;var QtyToBeInvoicedBase: Decimal;TrackingSpecificationExists: Boolean;PurchLine: Record "Purchase Line";PurchRcptLine: Record "Purch. Rcpt. Line";InvoicingTrackingSpecification: Record "Tracking Specification")
    begin
        if PurchLine."Qty. to Invoice" * PurchRcptLine.Quantity < 0 then
          PurchLine.FieldError("Qty. to Invoice",ReceiptSameSignErr);
        if TrackingSpecificationExists then begin
          QtyToBeInvoiced := InvoicingTrackingSpecification."Qty. to Invoice";
          QtyToBeInvoicedBase := InvoicingTrackingSpecification."Qty. to Invoice (Base)";
        end else begin
          QtyToBeInvoiced := RemQtyToBeInvoiced - PurchLine."Qty. to Receive";
          QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - PurchLine."Qty. to Receive (Base)";
        end;
        if Abs(QtyToBeInvoiced) > Abs(PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced") then begin
          QtyToBeInvoiced := PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";
          QtyToBeInvoicedBase := PurchRcptLine."Quantity (Base)" - PurchRcptLine."Qty. Invoiced (Base)";
        end;
    end;

    local procedure UpdateRemainingQtyToBeInvoiced(var RemQtyToInvoiceCurrLine: Decimal;var RemQtyToInvoiceCurrLineBase: Decimal;PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        RemQtyToInvoiceCurrLine := PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";
        RemQtyToInvoiceCurrLineBase := PurchRcptLine."Quantity (Base)" - PurchRcptLine."Qty. Invoiced (Base)";
        if RemQtyToInvoiceCurrLine > RemQtyToBeInvoiced then begin
          RemQtyToInvoiceCurrLine := RemQtyToBeInvoiced;
          RemQtyToInvoiceCurrLineBase := RemQtyToBeInvoicedBase;
        end;
    end;

    local procedure GetCountryCode(SalesLine: Record "Sales Line";SalesHeader: Record "Sales Header"): Code[10]
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        if SalesLine."Shipment No." <> '' then begin
          SalesShipmentHeader.Get(SalesLine."Shipment No.");
          exit(
            GetCountryRegionCode(
              SalesLine."Sell-to Customer No.",
              SalesShipmentHeader."Ship-to Code",
              SalesShipmentHeader."Sell-to Country/Region Code"));
        end;
        exit(
          GetCountryRegionCode(
            SalesLine."Sell-to Customer No.",
            SalesHeader."Ship-to Code",
            SalesHeader."Sell-to Country/Region Code"));
    end;

    local procedure GetCountryRegionCode(CustNo: Code[20];ShipToCode: Code[10];SellToCountryRegionCode: Code[10]): Code[10]
    var
        ShipToAddress: Record "Ship-to Address";
    begin
        if ShipToCode <> '' then begin
          ShipToAddress.Get(CustNo,ShipToCode);
          exit(ShipToAddress."Country/Region Code");
        end;
        exit(SellToCountryRegionCode);
    end;

    local procedure CheckItemReservDisruption(PurchLine: Record "Purchase Line")
    var
        Item: Record Item;
        AvailableQty: Decimal;
    begin
        with PurchLine do begin
          if not IsCreditDocType or (Type <> Type::Item) or not ("Return Qty. to Ship (Base)" > 0) then
            exit;

          if Nonstock or "Special Order" or "Drop Shipment" or IsServiceItem or
             TempSKU.Get("Location Code","No.","Variant Code") // Warn against item
          then
            exit;

          Item.Get("No.");
          Item.SetFilter("Location Filter","Location Code");
          Item.SetFilter("Variant Filter","Variant Code");
          Item.CalcFields("Reserved Qty. on Inventory","Net Change");
          CalcFields("Reserved Qty. (Base)");
          AvailableQty := Item."Net Change" - (Item."Reserved Qty. on Inventory" - "Reserved Qty. (Base)");

          if (Item."Reserved Qty. on Inventory" > 0) and
             (AvailableQty < "Return Qty. to Ship (Base)") and
             (Item."Reserved Qty. on Inventory" > Abs("Reserved Qty. (Base)"))
          then begin
            InsertTempSKU("Location Code","No.","Variant Code");
            if not Confirm(
                 ReservationDisruptedQst,false,FieldCaption("No."),Item."No.",FieldCaption("Location Code"),
                 "Location Code",FieldCaption("Variant Code"),"Variant Code")
            then
              Error('');
          end;
        end;
    end;

    local procedure InsertTempSKU(LocationCode: Code[10];ItemNo: Code[20];VariantCode: Code[10])
    begin
        with TempSKU do begin
          Init;
          "Location Code" := LocationCode;
          "Item No." := ItemNo;
          "Variant Code" := VariantCode;
          Insert;
        end;
    end;

    local procedure UpdatePurchLineDimSetIDFromAppliedEntry(var PurchLineToPost: Record "Purchase Line";PurchLine: Record "Purchase Line")
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        DimensionMgt: Codeunit DimensionManagement;
        DimSetID: array [10] of Integer;
    begin
        DimSetID[1] := PurchLine."Dimension Set ID";
        with PurchLineToPost do begin
          if "Appl.-to Item Entry" <> 0 then begin
            ItemLedgEntry.Get("Appl.-to Item Entry");
            DimSetID[2] := ItemLedgEntry."Dimension Set ID";
          end;
          "Dimension Set ID" :=
            DimensionMgt.GetCombinedDimensionSetID(DimSetID,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        end;
    end;

    local procedure CheckCertificateOfSupplyStatus(ReturnShptHeader: Record "Return Shipment Header";ReturnShptLine: Record "Return Shipment Line")
    var
        CertificateOfSupply: Record "Certificate of Supply";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if ReturnShptLine.Quantity <> 0 then
          if VATPostingSetup.Get(ReturnShptHeader."VAT Bus. Posting Group",ReturnShptLine."VAT Prod. Posting Group") and
             VATPostingSetup."Certificate of Supply Required"
          then begin
            CertificateOfSupply.InitFromPurchase(ReturnShptHeader);
            CertificateOfSupply.SetRequired(ReturnShptHeader."No.")
          end;
    end;

    local procedure CheckSalesCertificateOfSupplyStatus(SalesShptHeader: Record "Sales Shipment Header";SalesShptLine: Record "Sales Shipment Line")
    var
        CertificateOfSupply: Record "Certificate of Supply";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if SalesShptLine.Quantity <> 0 then
          if VATPostingSetup.Get(SalesShptHeader."VAT Bus. Posting Group",SalesShptLine."VAT Prod. Posting Group") and
             VATPostingSetup."Certificate of Supply Required"
          then begin
            CertificateOfSupply.InitFromSales(SalesShptHeader);
            CertificateOfSupply.SetRequired(SalesShptHeader."No.");
          end;
    end;

    local procedure InsertPostedHeaders(PurchHeader: Record "Purchase Header")
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        with PurchHeader do begin
          // Insert receipt header
          if Receive then
            if ("Document Type" = "document type"::Order) or
               (("Document Type" = "document type"::Invoice) and PurchSetup."Receipt on Invoice")
            then begin
              if DropShipOrder then begin
                PurchRcptHeader.LockTable;
                PurchRcptLine.LockTable;
                SalesShptHeader.LockTable;
                SalesShptLine.LockTable;
              end;
              InsertReceiptHeader(PurchHeader,PurchRcptHeader);
              ServItemMgt.CopyReservation(PurchHeader);
            end;

          // Insert return shipment header
          if Ship then
            if IsCreditDocType and PurchSetup."Return Shipment on Credit Memo" then
              InsertReturnShipmentHeader(PurchHeader,ReturnShptHeader);

          // Insert invoice header or credit memo header
          if Invoice then
            if "Document Type" in ["document type"::Order,"document type"::Invoice] then begin
              InsertInvoiceHeader(PurchHeader,PurchInvHeader);
              if SalesTaxCountry <> Salestaxcountry::NoTax then
                TaxAmountDifference.CopyTaxDifferenceRecords(
                  TaxAmountDifference."document product area"::Purchase,"Document Type","No.",
                  TaxAmountDifference."document product area"::"Posted Purchase",
                  TaxAmountDifference."document type"::Invoice,PurchInvHeader."No.");
              GenJnlLineDocType := GenJnlLine."document type"::Invoice;
              GenJnlLineDocNo := PurchInvHeader."No.";
              GenJnlLineExtDocNo := "Vendor Invoice No.";
            end else begin // Credit Memo
              InsertCrMemoHeader(PurchHeader,PurchCrMemoHeader);
              if SalesTaxCountry <> Salestaxcountry::NoTax then
                TaxAmountDifference.CopyTaxDifferenceRecords(
                  TaxAmountDifference."document product area"::Purchase,"Document Type","No.",
                  TaxAmountDifference."document product area"::"Posted Purchase",
                  TaxAmountDifference."document type"::"Credit Memo",PurchCrMemoHeader."No.");
              GenJnlLineDocType := GenJnlLine."document type"::"Credit Memo";
              GenJnlLineDocNo := PurchCrMemoHeader."No.";
              GenJnlLineExtDocNo := "Vendor Cr. Memo No.";
            end;
        end;
    end;

    local procedure InsertReceiptHeader(var PurchHeader: Record "Purchase Header";var PurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        PurchCommentLine: Record "Purch. Comment Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        with PurchHeader do begin
          PurchRcptHeader.Init;
          PurchRcptHeader.TransferFields(PurchHeader);
          PurchRcptHeader."No." := "Receiving No.";
          if "Document Type" = "document type"::Order then begin
            PurchRcptHeader."Order No. Series" := "No. Series";
            PurchRcptHeader."Order No." := "No.";
          end;
          PurchRcptHeader."No. Printed" := 0;
          PurchRcptHeader."Source Code" := SrcCode;
          PurchRcptHeader."User ID" := UserId;
          PurchRcptHeader.Insert;

          ApprovalsMgmt.PostApprovalEntries(RecordId,PurchRcptHeader.RecordId,PurchRcptHeader."No.");

          if PurchSetup."Copy Comments Order to Receipt" then begin
            CopyCommentLines(
              "Document Type",PurchCommentLine."document type"::Receipt,
              "No.",PurchRcptHeader."No.");
            RecordLinkManagement.CopyLinks(PurchHeader,PurchRcptHeader);
          end;
          if WhseReceive then begin
            WhseRcptHeader.Get(TempWhseRcptHeader."No.");
            WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader,WhseRcptHeader,"Receiving No.","Posting Date");
          end;
          if WhseShip then begin
            WhseShptHeader.Get(TempWhseShptHeader."No.");
            WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader,WhseShptHeader,"Receiving No.","Posting Date");
          end;
        end;
    end;

    local procedure InsertReceiptLine(PurchRcptHeader: Record "Purch. Rcpt. Header";PurchLine: Record "Purchase Line";CostBaseAmount: Decimal)
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        WhseRcptLine: Record "Warehouse Receipt Line";
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        PurchRcptLine.InitFromPurchLine(PurchRcptHeader,xPurchLine);
        if (PurchLine.Type = PurchLine.Type::Item) and (PurchLine."Qty. to Receive" <> 0) then begin
          if WhseReceive then begin
            WhseRcptLine.GetWhseRcptLine(
              WhseRcptLine,WhseRcptHeader."No.",Database::"Purchase Line",
              PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.");
            WhseRcptLine.TestField("Qty. to Receive",PurchRcptLine.Quantity);
            SaveTempWhseSplitSpec(PurchLine);
            WhsePostRcpt.CreatePostedRcptLine(
              WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
          end;
          if WhseShip then begin
            WhseShptLine.GetWhseShptLine(
              WhseShptLine,WhseShptHeader."No.",Database::"Purchase Line",
              PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.");
            WhseShptLine.TestField("Qty. to Ship",-PurchRcptLine.Quantity);
            SaveTempWhseSplitSpec(PurchLine);
            WhsePostShpt.CreatePostedShptLine(
              WhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
          end;
          PurchRcptLine."Item Rcpt. Entry No." := InsertRcptEntryRelation(PurchRcptLine);
          PurchRcptLine."Item Charge Base Amount" := ROUND(CostBaseAmount / PurchLine.Quantity * PurchRcptLine.Quantity);
        end;
        PurchRcptLine.Insert;
    end;

    local procedure InsertReturnShipmentHeader(var PurchHeader: Record "Purchase Header";var ReturnShptHeader: Record "Return Shipment Header")
    var
        PurchCommentLine: Record "Purch. Comment Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        with PurchHeader do begin
          ReturnShptHeader.Init;
          ReturnShptHeader.TransferFields(PurchHeader);
          ReturnShptHeader."No." := "Return Shipment No.";
          if "Document Type" = "document type"::"Return Order" then begin
            ReturnShptHeader."Return Order No. Series" := "No. Series";
            ReturnShptHeader."Return Order No." := "No.";
          end;
          ReturnShptHeader."No. Series" := "Return Shipment No. Series";
          ReturnShptHeader."No. Printed" := 0;
          ReturnShptHeader."Source Code" := SrcCode;
          ReturnShptHeader."User ID" := UserId;
          ReturnShptHeader.Insert;

          ApprovalsMgmt.PostApprovalEntries(RecordId,ReturnShptHeader.RecordId,ReturnShptHeader."No.");

          if PurchSetup."Copy Cmts Ret.Ord. to Ret.Shpt" then begin
            CopyCommentLines(
              "Document Type",PurchCommentLine."document type"::"Posted Return Shipment",
              "No.",ReturnShptHeader."No.");
            RecordLinkManagement.CopyLinks(PurchHeader,ReturnShptHeader);
          end;
          if WhseShip then begin
            WhseShptHeader.Get(TempWhseShptHeader."No.");
            WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader,WhseShptHeader,"Return Shipment No.","Posting Date");
          end;
          if WhseReceive then begin
            WhseRcptHeader.Get(TempWhseRcptHeader."No.");
            WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader,WhseRcptHeader,"Return Shipment No.","Posting Date");
          end;
        end;
    end;

    local procedure InsertReturnShipmentLine(ReturnShptHeader: Record "Return Shipment Header";PurchLine: Record "Purchase Line";CostBaseAmount: Decimal)
    var
        ReturnShptLine: Record "Return Shipment Line";
        WhseRcptLine: Record "Warehouse Receipt Line";
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        ReturnShptLine.InitFromPurchLine(ReturnShptHeader,xPurchLine);
        if (PurchLine.Type = PurchLine.Type::Item) and (PurchLine."Return Qty. to Ship" <> 0) then begin
          if WhseShip then begin
            WhseShptLine.GetWhseShptLine(
              WhseShptLine,WhseShptHeader."No.",Database::"Purchase Line",
              PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.");
            WhseShptLine.TestField("Qty. to Ship",ReturnShptLine.Quantity);
            SaveTempWhseSplitSpec(PurchLine);
            WhsePostShpt.CreatePostedShptLine(
              WhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
          end;
          if WhseReceive then begin
            WhseRcptLine.GetWhseRcptLine(
              WhseRcptLine,WhseRcptHeader."No.",Database::"Purchase Line",
              PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.");
            WhseRcptLine.TestField("Qty. to Receive",-ReturnShptLine.Quantity);
            SaveTempWhseSplitSpec(PurchLine);
            WhsePostRcpt.CreatePostedRcptLine(
              WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
          end;

          ReturnShptLine."Item Shpt. Entry No." := InsertReturnEntryRelation(ReturnShptLine);
          ReturnShptLine."Item Charge Base Amount" := ROUND(CostBaseAmount / PurchLine.Quantity * ReturnShptLine.Quantity);
        end;
        ReturnShptLine.Insert;

        CheckCertificateOfSupplyStatus(ReturnShptHeader,ReturnShptLine);
    end;

    local procedure InsertInvoiceHeader(var PurchHeader: Record "Purchase Header";var PurchInvHeader: Record "Purch. Inv. Header")
    var
        PurchCommentLine: Record "Purch. Comment Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        with PurchHeader do begin
          PurchInvHeader.Init;
          PurchInvHeader.TransferFields(PurchHeader);
          if "Document Type" = "document type"::Order then begin
            PurchInvHeader."Pre-Assigned No. Series" := '';
            PurchInvHeader."No." := "Posting No.";
            PurchInvHeader."Order No. Series" := "No. Series";
            PurchInvHeader."Order No." := "No.";
            if GuiAllowed then
              Window.Update(1,StrSubstNo(InvoiceNoMsg,"Document Type","No.",PurchInvHeader."No."));
          end else begin
            if "Posting No." <> '' then begin
              PurchInvHeader."No." := "Posting No.";
              if GuiAllowed then
                Window.Update(1,StrSubstNo(InvoiceNoMsg,"Document Type","No.",PurchInvHeader."No."));
            end;
            PurchInvHeader."Pre-Assigned No. Series" := "No. Series";
            PurchInvHeader."Pre-Assigned No." := "No.";
          end;
          PurchInvHeader."Creditor No." := "Creditor No.";
          PurchInvHeader."Payment Reference" := "Payment Reference";
          PurchInvHeader."Payment Method Code" := "Payment Method Code";
          PurchInvHeader."Source Code" := SrcCode;
          PurchInvHeader."User ID" := UserId;
          PurchInvHeader."No. Printed" := 0;
          PurchInvHeader.Insert;

          ApprovalsMgmt.PostApprovalEntries(RecordId,PurchInvHeader.RecordId,PurchInvHeader."No.");
          if PurchSetup."Copy Comments Order to Invoice" then begin
            CopyCommentLines(
              "Document Type",PurchCommentLine."document type"::"Posted Invoice",
              "No.",PurchInvHeader."No.");
            RecordLinkManagement.CopyLinks(PurchHeader,PurchInvHeader);
          end;
        end;
    end;

    local procedure InsertCrMemoHeader(var PurchHeader: Record "Purchase Header";var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        PurchCommentLine: Record "Purch. Comment Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        with PurchHeader do begin
          PurchCrMemoHdr.Init;
          PurchCrMemoHdr.TransferFields(PurchHeader);
          if "Document Type" = "document type"::"Return Order" then begin
            PurchCrMemoHdr."No." := "Posting No.";
            PurchCrMemoHdr."Pre-Assigned No. Series" := '';
            PurchCrMemoHdr."Return Order No. Series" := "No. Series";
            PurchCrMemoHdr."Return Order No." := "No.";
            if GuiAllowed then
              Window.Update(1,StrSubstNo(CreditMemoNoMsg,"Document Type","No.",PurchCrMemoHdr."No."));
          end else begin
            PurchCrMemoHdr."Pre-Assigned No. Series" := "No. Series";
            PurchCrMemoHdr."Pre-Assigned No." := "No.";
            if "Posting No." <> '' then begin
              PurchCrMemoHdr."No." := "Posting No.";
              if GuiAllowed then
                Window.Update(1,StrSubstNo(CreditMemoNoMsg,"Document Type","No.",PurchCrMemoHdr."No."));
            end;
          end;
          PurchCrMemoHdr."Source Code" := SrcCode;
          PurchCrMemoHdr."User ID" := UserId;
          PurchCrMemoHdr."No. Printed" := 0;
          PurchCrMemoHdr.Insert(true);

          ApprovalsMgmt.PostApprovalEntries(RecordId,PurchCrMemoHdr.RecordId,PurchCrMemoHdr."No.");

          if PurchSetup."Copy Cmts Ret.Ord. to Cr. Memo" then begin
            CopyCommentLines(
              "Document Type",PurchCommentLine."document type"::"Posted Credit Memo",
              "No.",PurchCrMemoHdr."No.");
            RecordLinkManagement.CopyLinks(PurchHeader,PurchCrMemoHdr);
          end;
        end;
    end;

    local procedure GetSign(Value: Decimal): Integer
    begin
        if Value > 0 then
          exit(1);

        exit(-1);
    end;

    local procedure CheckICDocumentDuplicatePosting(PurchHeader: Record "Purchase Header")
    var
        PurchHeader2: Record "Purchase Header";
        ICInboxPurchHeader: Record "IC Inbox Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        with PurchHeader do
          if Invoice and ("IC Direction" = "ic direction"::Incoming) then begin
            if "Document Type" = "document type"::Order then begin
              PurchHeader2.SetRange("Document Type","document type"::Invoice);
              PurchHeader2.SetRange("Vendor Order No.","Vendor Order No.");
              if PurchHeader2.FindFirst then
                if not Confirm(UnpostedInvoiceDuplicateQst,true,"No.",PurchHeader2."No.") then
                  Error('');
              ICInboxPurchHeader.SetRange("Document Type","document type"::Invoice);
              ICInboxPurchHeader.SetRange("Vendor Order No.","Vendor Order No.");
              if ICInboxPurchHeader.FindFirst then
                if not Confirm(InvoiceDuplicateInboxQst,true,"No.",ICInboxPurchHeader."No.") then
                  Error('');
              PurchInvHeader.SetRange("Vendor Order No.","Vendor Order No.");
              if PurchInvHeader.FindFirst then
                if not Confirm(PostedInvoiceDuplicateQst,false,PurchInvHeader."No.","No.") then
                  Error('');
            end;
            if ("Document Type" = "document type"::Invoice) and ("Vendor Order No." <> '') then begin
              PurchHeader2.SetRange("Document Type","document type"::Order);
              PurchHeader2.SetRange("Vendor Order No.","Vendor Order No.");
              if PurchHeader2.FindFirst then
                if not Confirm(OrderFromSameTransactionQst,true,PurchHeader2."No.","No.") then
                  Error('');
              ICInboxPurchHeader.SetRange("Document Type","document type"::Order);
              ICInboxPurchHeader.SetRange("Vendor Order No.","Vendor Order No.");
              if ICInboxPurchHeader.FindFirst then
                if not Confirm(DocumentFromSameTransactionQst,true,"No.",ICInboxPurchHeader."No.") then
                  Error('');
              PurchInvHeader.SetRange("Vendor Order No.","Vendor Order No.");
              if PurchInvHeader.FindFirst then
                if not Confirm(PostedInvoiceFromSameTransactionQst,false,PurchInvHeader."No.","No.") then
                  Error('');
            end;
          end;
    end;

    local procedure CheckICPartnerBlocked(PurchHeader: Record "Purchase Header")
    var
        ICPartner: Record "IC Partner";
    begin
        with PurchHeader do begin
          if "Buy-from IC Partner Code" <> '' then
            if ICPartner.Get("Buy-from IC Partner Code") then
              ICPartner.TestField(Blocked,false);
          if "Pay-to IC Partner Code" <> '' then
            if ICPartner.Get("Pay-to IC Partner Code") then
              ICPartner.TestField(Blocked,false);
        end;
    end;

    local procedure SendICDocument(var PurchHeader: Record "Purchase Header";var ModifyHeader: Boolean)
    var
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
    begin
        with PurchHeader do
          if "Send IC Document" and ("IC Status" = "ic status"::New) and ("IC Direction" = "ic direction"::Outgoing) and
             ("Document Type" in ["document type"::Order,"document type"::"Return Order"])
          then begin
            ICInboxOutboxMgt.SendPurchDoc(PurchHeader,true);
            "IC Status" := "ic status"::Pending;
            ModifyHeader := true;
          end;
    end;

    local procedure UpdateHandledICInboxTransaction(PurchHeader: Record "Purchase Header")
    var
        HandledICInboxTrans: Record "Handled IC Inbox Trans.";
        Vendor: Record Vendor;
    begin
        with PurchHeader do
          if "IC Direction" = "ic direction"::Incoming then begin
            case "Document Type" of
              "document type"::Invoice:
                HandledICInboxTrans.SetRange("Document No.","Vendor Invoice No.");
              "document type"::Order:
                HandledICInboxTrans.SetRange("Document No.","Vendor Order No.");
              "document type"::"Credit Memo":
                HandledICInboxTrans.SetRange("Document No.","Vendor Cr. Memo No.");
              "document type"::"Return Order":
                HandledICInboxTrans.SetRange("Document No.","Vendor Order No.");
            end;
            Vendor.Get("Buy-from Vendor No.");
            HandledICInboxTrans.SetRange("IC Partner Code",Vendor."IC Partner Code");
            HandledICInboxTrans.LockTable;
            if HandledICInboxTrans.FindFirst then begin
              HandledICInboxTrans.Status := HandledICInboxTrans.Status::Posted;
              HandledICInboxTrans.Modify;
            end;
          end;
    end;

    local procedure MakeInventoryAdjustment(JobItem: Boolean)
    var
        InvtSetup: Record "Inventory Setup";
        InvtAdjmt: Codeunit "Inventory Adjustment";
    begin
        InvtSetup.Get;
        if InvtSetup."Automatic Cost Adjustment" <>
           InvtSetup."automatic cost adjustment"::Never
        then begin
          InvtAdjmt.SetProperties(true,InvtSetup."Automatic Cost Posting");
          InvtAdjmt.SetJobUpdateProperties(not JobItem);
          InvtAdjmt.MakeMultiLevelAdjmt;
        end;
    end;

    local procedure CheckTrackingAndWarehouseForReceive(PurchHeader: Record "Purchase Header") Receive: Boolean
    var
        TempPurchLine: Record "Purchase Line" temporary;
    begin
        with TempPurchLine do begin
          ResetTempLines(TempPurchLine);
          SetFilter(Quantity,'<>0');
          if PurchHeader."Document Type" = PurchHeader."document type"::Order then
            SetFilter("Qty. to Receive",'<>0');
          SetRange("Receipt No.",'');
          Receive := FindFirst;
          WhseReceive := TempWhseRcptHeader.FindFirst;
          WhseShip := TempWhseShptHeader.FindFirst;
          if Receive then begin
            CheckTrackingSpecification(PurchHeader,TempPurchLine);
            if not (WhseReceive or WhseShip or InvtPickPutaway) then
              CheckWarehouse(TempPurchLine);
          end;
          exit(Receive);
        end;
    end;

    local procedure CheckTrackingAndWarehouseForShip(PurchHeader: Record "Purchase Header") Ship: Boolean
    var
        TempPurchLine: Record "Purchase Line" temporary;
    begin
        with TempPurchLine do begin
          ResetTempLines(TempPurchLine);
          SetFilter(Quantity,'<>0');
          SetFilter("Return Qty. to Ship",'<>0');
          SetRange("Return Shipment No.",'');
          Ship := FindFirst;
          WhseReceive := TempWhseRcptHeader.FindFirst;
          WhseShip := TempWhseShptHeader.FindFirst;
          if Ship then begin
            CheckTrackingSpecification(PurchHeader,TempPurchLine);
            if not (WhseShip or WhseReceive or InvtPickPutaway) then
              CheckWarehouse(TempPurchLine);
          end;
          exit(Ship);
        end;
    end;

    local procedure CheckAssosOrderLines(PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        SalesOrderLine: Record "Sales Line";
    begin
        with PurchHeader do begin
          PurchLine.Reset;
          PurchLine.SetRange("Document Type","Document Type");
          PurchLine.SetRange("Document No.","No.");
          PurchLine.SetFilter("Sales Order Line No.",'<>0');
          if PurchLine.FindSet then
            repeat
              SalesOrderLine.Get(SalesOrderLine."document type"::Order,
                PurchLine."Sales Order No.",PurchLine."Sales Order Line No.");
              if Receive and Invoice and (PurchLine."Qty. to Invoice" <> 0) and (PurchLine."Qty. to Receive" <> 0) then
                Error(DropShipmentErr);
              if Abs(PurchLine."Quantity Received" - PurchLine."Quantity Invoiced") < Abs(PurchLine."Qty. to Invoice")
              then begin
                PurchLine."Qty. to Invoice" := PurchLine."Quantity Received" - PurchLine."Quantity Invoiced";
                PurchLine."Qty. to Invoice (Base)" := PurchLine."Qty. Received (Base)" - PurchLine."Qty. Invoiced (Base)";
              end;
              if Abs(PurchLine.Quantity - (PurchLine."Qty. to Invoice" + PurchLine."Quantity Invoiced")) <
                 Abs(SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced")
              then
                Error(CannotInvoiceBeforeAssosSalesOrderErr,PurchLine."Sales Order No.");
            until PurchLine.Next = 0;
        end;
    end;

    local procedure RoundSalesTaxAmount(var Remainder: Decimal;TaxAmount: Decimal): Decimal
    var
        SalesTaxAmount: Decimal;
    begin
        Remainder += TaxAmount;
        SalesTaxAmount := ROUND(Remainder,GLSetup."Amount Rounding Precision");
        Remainder -= SalesTaxAmount;
        exit(SalesTaxAmount);
    end;

    local procedure QuantityInvoicedNotAssigned(ItemChargePurchLine: Record "Purchase Line"): Decimal
    begin
        exit(Abs(ItemChargePurchLine."Quantity Invoiced") - Abs(ItemChargePurchLine."Qty. Assigned"));
    end;

    local procedure ItemChargeQtyToAssign(ItemChargePurchLine: Record "Purchase Line"): Decimal
    begin
        if ItemChargePurchLine."Qty. to Invoice" <> 0 then
          exit(ItemChargePurchLine."Qty. to Invoice");

        exit(QuantityInvoicedNotAssigned(ItemChargePurchLine));
    end;

    local procedure GetGenPostingSetup(var GenPostingSetup: Record "General Posting Setup";PurchLine: Record "Purchase Line")
    begin
        if GLSetup."VAT in Use" then
          GenPostingSetup.Get(PurchLine."Gen. Bus. Posting Group",PurchLine."Gen. Prod. Posting Group")
        else
          if (PurchLine.Type >= PurchLine.Type::"G/L Account") and
             ((PurchLine."Qty. to Invoice" <> 0) or (PurchLine."Qty. to Receive" <> 0))
          then
            if (PurchLine.Type in [PurchLine.Type::"G/L Account",PurchLine.Type::"Fixed Asset"]) then
              if (((PurchSetup."Discount Posting" = PurchSetup."discount posting"::"Invoice Discounts") and
                 (PurchLine."Inv. Discount Amount" <> 0)) or
                 ((PurchSetup."Discount Posting" = PurchSetup."discount posting"::"Line Discounts") and
                 (PurchLine."Line Discount Amount" <> 0)) or
                 ((PurchSetup."Discount Posting" = PurchSetup."discount posting"::"All Discounts") and
                 ((PurchLine."Inv. Discount Amount" <> 0) or (PurchLine."Line Discount Amount" <> 0))))
              then begin
                if not GenPostingSetup.Get(PurchLine."Gen. Bus. Posting Group",PurchLine."Gen. Prod. Posting Group") then
                  if PurchLine."Gen. Prod. Posting Group" = '' then
                    Error(
                      GenProdPostingGrDiscErr,
                      PurchLine.FieldName("Gen. Prod. Posting Group"),PurchLine.FieldName("Line No."),PurchLine."Line No.")
                  else
                    GenPostingSetup.Get(PurchLine."Gen. Bus. Posting Group",PurchLine."Gen. Prod. Posting Group");
              end else
                Clear(GenPostingSetup)
            else
              GenPostingSetup.Get(PurchLine."Gen. Bus. Posting Group",PurchLine."Gen. Prod. Posting Group");
    end;

    local procedure PostCombineSalesOrderShipment(var PurchHeader: Record "Purchase Header";var TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesCommentLine: Record "Sales Comment Line";
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        with PurchHeader do
          if TempDropShptPostBuffer.FindSet then begin
            SalesSetup.Get;
            repeat
              SalesOrderHeader.Get(
                SalesOrderHeader."document type"::Order,
                TempDropShptPostBuffer."Order No.");
              SalesPost.ArchiveUnpostedOrder(SalesOrderHeader);
              SalesShptHeader.Init;
              SalesShptHeader.TransferFields(SalesOrderHeader);
              SalesShptHeader."No." := SalesOrderHeader."Shipping No.";
              SalesShptHeader."Order No." := SalesOrderHeader."No.";
              SalesShptHeader."Posting Date" := "Posting Date";
              SalesShptHeader."Document Date" := "Document Date";
              SalesShptHeader."No. Printed" := 0;
              SalesShptHeader.Insert(true);

              ApprovalsMgmt.PostApprovalEntries(RecordId,SalesShptHeader.RecordId,SalesShptHeader."No.");

              if SalesSetup."Copy Comments Order to Shpt." then begin
                CopySalesCommentLines(
                  SalesOrderHeader."Document Type",SalesCommentLine."document type"::Shipment,
                  SalesOrderHeader."No.",SalesShptHeader."No.");
                RecordLinkManagement.CopyLinks(SalesOrderHeader,SalesShptHeader);
              end;
              TempDropShptPostBuffer.SetRange("Order No.",TempDropShptPostBuffer."Order No.");
              repeat
                SalesOrderLine.Get(
                  SalesOrderLine."document type"::Order,
                  TempDropShptPostBuffer."Order No.",TempDropShptPostBuffer."Order Line No.");
                SalesShptLine.Init;
                SalesShptLine.TransferFields(SalesOrderLine);
                SalesShptLine."Posting Date" := SalesShptHeader."Posting Date";
                SalesShptLine."Document No." := SalesShptHeader."No.";
                SalesShptLine.Quantity := TempDropShptPostBuffer.Quantity;
                SalesShptLine."Quantity (Base)" := TempDropShptPostBuffer."Quantity (Base)";
                SalesShptLine."Quantity Invoiced" := 0;
                SalesShptLine."Qty. Invoiced (Base)" := 0;
                SalesShptLine."Order No." := SalesOrderLine."Document No.";
                SalesShptLine."Order Line No." := SalesOrderLine."Line No.";
                SalesShptLine."Qty. Shipped Not Invoiced" :=
                  SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced";
                if SalesShptLine.Quantity <> 0 then begin
                  SalesShptLine."Item Shpt. Entry No." := TempDropShptPostBuffer."Item Shpt. Entry No.";
                  SalesShptLine."Item Charge Base Amount" := SalesOrderLine."Line Amount";
                end;
                SalesShptLine.Insert;
                CheckSalesCertificateOfSupplyStatus(SalesShptHeader,SalesShptLine);

                SalesOrderLine."Qty. to Ship" := SalesShptLine.Quantity;
                SalesOrderLine."Qty. to Ship (Base)" := SalesShptLine."Quantity (Base)";
                ServItemMgt.CreateServItemOnSalesLineShpt(SalesOrderHeader,SalesOrderLine,SalesShptLine);
                SalesPost.UpdateBlanketOrderLine(SalesOrderLine,true,false,false);

                SalesOrderLine.SetRange("Document Type",SalesOrderLine."document type"::Order);
                SalesOrderLine.SetRange("Document No.",TempDropShptPostBuffer."Order No.");
                SalesOrderLine.SetRange("Attached to Line No.",TempDropShptPostBuffer."Order Line No.");
                SalesOrderLine.SetRange(Type,SalesOrderLine.Type::" ");
                if SalesOrderLine.FindSet then
                  repeat
                    SalesShptLine.Init;
                    SalesShptLine.TransferFields(SalesOrderLine);
                    SalesShptLine."Document No." := SalesShptHeader."No.";
                    SalesShptLine."Order No." := SalesOrderLine."Document No.";
                    SalesShptLine."Order Line No." := SalesOrderLine."Line No.";
                    SalesShptLine.Insert;
                  until SalesOrderLine.Next = 0;

              until TempDropShptPostBuffer.Next = 0;
              TempDropShptPostBuffer.SetRange("Order No.");
            until TempDropShptPostBuffer.Next = 0;
          end;
    end;

    local procedure PostInvoicePostBufferLine(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";InvoicePostBuffer: Record "Invoice Post. Buffer"): Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        with GenJnlLine do begin
          InitNewLine(
            PurchHeader."Posting Date",PurchHeader."Document Date",PurchHeader."Posting Description",
            InvoicePostBuffer."Global Dimension 1 Code",InvoicePostBuffer."Global Dimension 2 Code",
            InvoicePostBuffer."Dimension Set ID",PurchHeader."Reason Code");

          CopyDocumentFields(GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,'');

          CopyFromPurchHeader(PurchHeader);

          CopyFromInvoicePostBuffer(InvoicePostBuffer);
          if InvoicePostBuffer.Type <> InvoicePostBuffer.Type::"Prepmt. Exch. Rate Difference" then
            "Gen. Posting Type" := "gen. posting type"::Purchase;
          if InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" then begin
            if InvoicePostBuffer."FA Posting Type" = InvoicePostBuffer."fa posting type"::"Acquisition Cost" then
              "FA Posting Type" := "fa posting type"::"Acquisition Cost";
            if InvoicePostBuffer."FA Posting Type" = InvoicePostBuffer."fa posting type"::Maintenance then
              "FA Posting Type" := "fa posting type"::Maintenance;
            CopyFromInvoicePostBufferFA(InvoicePostBuffer);
          end;

          "GST/HST" := PurchLine."GST/HST";

          exit(RunGenJnlPostLine(GenJnlLine));
        end;
    end;

    local procedure FindTempItemChargeAssgntPurch(PurchLineNo: Integer): Boolean
    begin
        ClearItemChargeAssgntFilter;
        TempItemChargeAssgntPurch.SetCurrentkey("Applies-to Doc. Type");
        TempItemChargeAssgntPurch.SetRange("Document Line No.",PurchLineNo);
        exit(TempItemChargeAssgntPurch.FindSet);
    end;

    local procedure UpdateInvoicedQtyOnPurchRcptLine(var PurchRcptLine: Record "Purch. Rcpt. Line";QtyToBeInvoiced: Decimal;QtyToBeInvoicedBase: Decimal)
    begin
        with PurchRcptLine do begin
          "Quantity Invoiced" := "Quantity Invoiced" + QtyToBeInvoiced;
          "Qty. Invoiced (Base)" := "Qty. Invoiced (Base)" + QtyToBeInvoicedBase;
          "Qty. Rcd. Not Invoiced" := Quantity - "Quantity Invoiced";
          Modify;
        end;
    end;

    local procedure FillDeferralPostingBuffer(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";InvoicePostBuffer: Record "Invoice Post. Buffer";RemainAmtToDefer: Decimal;RemainAmtToDeferACY: Decimal;DeferralAccount: Code[20];PurchAccount: Code[20])
    var
        DeferralTemplate: Record "Deferral Template";
    begin
        if PurchLine."Deferral Code" <> '' then begin
          DeferralTemplate.Get(PurchLine."Deferral Code");

          if TempDeferralHeader.Get(DeferralUtilities.GetPurchDeferralDocType,'','',
               PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.")
          then begin
            if TempDeferralHeader."Amount to Defer" <> 0 then begin
              TempDeferralLine.SetRange("Deferral Doc. Type",DeferralUtilities.GetPurchDeferralDocType);
              TempDeferralLine.SetRange("Gen. Jnl. Template Name",'');
              TempDeferralLine.SetRange("Gen. Jnl. Batch Name",'');
              TempDeferralLine.SetRange("Document Type",PurchLine."Document Type");
              TempDeferralLine.SetRange("Document No.",PurchLine."Document No.");
              TempDeferralLine.SetRange("Line No.",PurchLine."Line No.");

              // The remaining amounts only need to be adjusted into the deferral account and are always reversed
              if (RemainAmtToDefer <> 0) or (RemainAmtToDeferACY <> 0) then begin
                DeferralPostBuffer[1].PreparePurch(PurchLine,GenJnlLineDocNo);
                DeferralPostBuffer[1]."Amount (LCY)" := -RemainAmtToDefer;
                DeferralPostBuffer[1].Amount := -RemainAmtToDeferACY;
                DeferralPostBuffer[1]."Sales/Purch Amount (LCY)" := 0;
                DeferralPostBuffer[1]."Sales/Purch Amount" := 0;
                // DeferralPostBuffer[1].ReverseAmounts;
                DeferralPostBuffer[1]."G/L Account" := PurchAccount;
                DeferralPostBuffer[1]."Deferral Account" := DeferralAccount;
                // Remainder always goes to the Posting Date
                DeferralPostBuffer[1]."Posting Date" := PurchHeader."Posting Date";
                DeferralPostBuffer[1].Description := PurchHeader."Posting Description";
                DeferralPostBuffer[1]."Period Description" := DeferralTemplate."Period Description";
                DeferralPostBuffer[1]."Deferral Line No." := InvDefLineNo;
                DeferralPostBuffer[1]."Partial Deferral" := true;
                UpdDeferralPostBuffer(InvoicePostBuffer);
              end;

              // Add the deferral lines for each period to the deferral posting buffer merging when they are the same
              if TempDeferralLine.FindSet then
                repeat
                  if (TempDeferralLine."Amount (LCY)" <> 0) or (TempDeferralLine.Amount <> 0) then begin
                    DeferralPostBuffer[1].PreparePurch(PurchLine,GenJnlLineDocNo);
                    DeferralPostBuffer[1]."Amount (LCY)" := TempDeferralLine."Amount (LCY)";
                    DeferralPostBuffer[1].Amount := TempDeferralLine.Amount;
                    DeferralPostBuffer[1]."Sales/Purch Amount (LCY)" := TempDeferralLine."Amount (LCY)";
                    DeferralPostBuffer[1]."Sales/Purch Amount" := TempDeferralLine.Amount;
                    if PurchLine.IsCreditDocType then
                      DeferralPostBuffer[1].ReverseAmounts;
                    DeferralPostBuffer[1]."G/L Account" := PurchAccount;
                    DeferralPostBuffer[1]."Deferral Account" := DeferralAccount;
                    DeferralPostBuffer[1]."Posting Date" := TempDeferralLine."Posting Date";
                    DeferralPostBuffer[1].Description := TempDeferralLine.Description;
                    DeferralPostBuffer[1]."Period Description" := DeferralTemplate."Period Description";
                    DeferralPostBuffer[1]."Deferral Line No." := InvDefLineNo;
                    UpdDeferralPostBuffer(InvoicePostBuffer);
                  end else
                    Error(ZeroDeferralAmtErr,PurchLine."No.",PurchLine."Deferral Code");

                until TempDeferralLine.Next = 0

              else
                Error(NoDeferralScheduleErr,PurchLine."No.",PurchLine."Deferral Code");
            end else
              Error(NoDeferralScheduleErr,PurchLine."No.",PurchLine."Deferral Code")
          end else
            Error(NoDeferralScheduleErr,PurchLine."No.",PurchLine."Deferral Code")
        end;
    end;

    local procedure UpdDeferralPostBuffer(InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        DeferralPostBuffer[1]."Dimension Set ID" := InvoicePostBuffer."Dimension Set ID";
        DeferralPostBuffer[1]."Global Dimension 1 Code" := InvoicePostBuffer."Global Dimension 1 Code";
        DeferralPostBuffer[1]."Global Dimension 2 Code" := InvoicePostBuffer."Global Dimension 2 Code";

        DeferralPostBuffer[2] := DeferralPostBuffer[1];
        if DeferralPostBuffer[2].Find then begin
          DeferralPostBuffer[2].Amount += DeferralPostBuffer[1].Amount;
          DeferralPostBuffer[2]."Amount (LCY)" += DeferralPostBuffer[1]."Amount (LCY)";
          DeferralPostBuffer[2]."Sales/Purch Amount" += DeferralPostBuffer[1]."Sales/Purch Amount";
          DeferralPostBuffer[2]."Sales/Purch Amount (LCY)" += DeferralPostBuffer[1]."Sales/Purch Amount (LCY)";

          if not DeferralPostBuffer[1]."System-Created Entry" then
            DeferralPostBuffer[2]."System-Created Entry" := false;
          if IsCombinedDeferralZero then
            DeferralPostBuffer[2].Delete
          else
            DeferralPostBuffer[2].Modify;
        end else
          DeferralPostBuffer[1].Insert;
    end;

    local procedure RoundDeferralsForArchive(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line")
    var
        DeferralHeader: Record "Deferral Header";
        AmtToDefer: Decimal;
        AmtToDeferACY: Decimal;
    begin
        PurchLine.SetFilter("Deferral Code",'<>%1','');
        if PurchLine.FindSet then
          repeat
            if DeferralHeader.Get(DeferralUtilities.GetPurchDeferralDocType,'','',
                 PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.")
            then
              DeferralUtilities.RoundDeferralAmount(
                DeferralHeader,PurchHeader."Currency Code",
                PurchHeader."Currency Factor",PurchHeader."Posting Date",
                AmtToDeferACY,AmtToDefer);
          until PurchLine.Next = 0;
    end;

    local procedure GetAmountsForDeferral(PurchLine: Record "Purchase Line";var AmtToDefer: Decimal;var AmtToDeferACY: Decimal;var DeferralAccount: Code[20])
    var
        DeferralTemplate: Record "Deferral Template";
    begin
        if PurchLine."Deferral Code" <> '' then begin
          DeferralTemplate.Get(PurchLine."Deferral Code");
          DeferralTemplate.TestField("Deferral Account");
          DeferralAccount := DeferralTemplate."Deferral Account";

          if TempDeferralHeader.Get(DeferralUtilities.GetPurchDeferralDocType,'','',
               PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.")
          then begin
            AmtToDeferACY := TempDeferralHeader."Amount to Defer";
            AmtToDefer := TempDeferralHeader."Amount to Defer (LCY)";
          end;

          if PurchLine.IsCreditDocType then begin
            AmtToDefer := -AmtToDefer;
            AmtToDeferACY := -AmtToDeferACY;
          end
        end else begin
          AmtToDefer := 0;
          AmtToDeferACY := 0;
          DeferralAccount := '';
        end;
    end;

    local procedure DefaultGLAccount(DeferralCode: Code[10];AmtToDefer: Decimal;GLAccNo: Code[20];DeferralAccNo: Code[20]): Code[20]
    begin
        if (DeferralCode <> '') and (AmtToDefer = 0) then
          exit(DeferralAccNo);

        exit(GLAccNo);
    end;

    local procedure IsCombinedDeferralZero(): Boolean
    begin
        if (DeferralPostBuffer[2].Amount = 0) and (DeferralPostBuffer[2]."Amount (LCY)" = 0) and
           (DeferralPostBuffer[2]."Sales/Purch Amount" = 0) and (DeferralPostBuffer[2]."Sales/Purch Amount (LCY)" = 0)
        then
          exit(true);

        exit(false);
    end;

    local procedure CheckMandatoryHeaderFields(PurchHeader: Record "Purchase Header")
    begin
        PurchHeader.TestField("Document Type");
        PurchHeader.TestField("Buy-from Vendor No.");
        PurchHeader.TestField("Pay-to Vendor No.");
        PurchHeader.TestField("Posting Date");
        PurchHeader.TestField("Document Date");
    end;

    local procedure InitVATAmounts(PurchLine: Record "Purchase Line";var TotalVAT: Decimal;var TotalVATACY: Decimal;var TotalAmount: Decimal;var TotalAmountACY: Decimal)
    begin
        TotalVAT := PurchLine."Amount Including VAT" - PurchLine.Amount;
        TotalVATACY := PurchLineACY."Amount Including VAT" - PurchLineACY.Amount;
        TotalAmount := PurchLine.Amount;
        TotalAmountACY := PurchLineACY.Amount;
    end;

    local procedure InitAmounts(PurchLine: Record "Purchase Line";var TotalVAT: Decimal;var TotalVATACY: Decimal;var TotalAmount: Decimal;var TotalAmountACY: Decimal;var AmtToDefer: Decimal;var AmtToDeferACY: Decimal;var DeferralAccount: Code[20])
    begin
        InitVATAmounts(PurchLine,TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
        GetAmountsForDeferral(PurchLine,AmtToDefer,AmtToDeferACY,DeferralAccount);
    end;

    local procedure CalcInvoiceDiscountPosting(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";PurchLineACY: Record "Purchase Line";var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        case PurchLine."VAT Calculation Type" of
          PurchLine."vat calculation type"::"Normal VAT",PurchLine."vat calculation type"::"Full VAT":
            InvoicePostBuffer.CalcDiscount(
              PurchHeader."Prices Including VAT",-PurchLine."Inv. Discount Amount",-PurchLineACY."Inv. Discount Amount");
          PurchLine."vat calculation type"::"Reverse Charge VAT":
            InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Inv. Discount Amount",-PurchLineACY."Inv. Discount Amount");
          PurchLine."vat calculation type"::"Sales Tax":
            if not PurchLine."Use Tax" then // Use Tax is calculated later, based on totals
              InvoicePostBuffer.CalcDiscount(
                PurchHeader."Prices Including VAT",-PurchLine."Inv. Discount Amount",-PurchLineACY."Inv. Discount Amount")
            else
              InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Inv. Discount Amount",-PurchLineACY."Inv. Discount Amount");
        end;
    end;

    local procedure CalcLineDiscountPosting(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";PurchLineACY: Record "Purchase Line";var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        case PurchLine."VAT Calculation Type" of
          PurchLine."vat calculation type"::"Normal VAT",PurchLine."vat calculation type"::"Full VAT":
            InvoicePostBuffer.CalcDiscount(
              PurchHeader."Prices Including VAT",-PurchLine."Line Discount Amount",-PurchLineACY."Line Discount Amount");
          PurchLine."vat calculation type"::"Reverse Charge VAT":
            InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Line Discount Amount",-PurchLineACY."Line Discount Amount");
          PurchLine."vat calculation type"::"Sales Tax":
            if not PurchLine."Use Tax" then // Use Tax is calculated later, based on totals
              InvoicePostBuffer.CalcDiscount(
                PurchHeader."Prices Including VAT",-PurchLine."Line Discount Amount",-PurchLineACY."Line Discount Amount")
            else
              InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Line Discount Amount",-PurchLineACY."Line Discount Amount");
        end;
    end;

    local procedure ClearPostBuffers()
    begin
        Clear(WhsePostRcpt);
        Clear(WhsePostShpt);
        Clear(GenJnlPostLine);
        Clear(JobPostLine);
        Clear(ItemJnlPostLine);
        Clear(WhseJnlPostLine);
    end;

    local procedure ValidatePostingAndDocumentDate(var PurchaseHeader: Record "Purchase Header")
    begin
        if PostingDateExists and (ReplacePostingDate or (PurchaseHeader."Posting Date" = 0D)) then begin
          PurchaseHeader."Posting Date" := PostingDate;
          PurchaseHeader.Validate("Currency Code");
        end;

        if PostingDateExists and (ReplaceDocumentDate or (PurchaseHeader."Document Date" = 0D)) then
          PurchaseHeader.Validate("Document Date",PostingDate);
    end;

    local procedure CheckExternalDocumentNumber(var VendLedgEntry: Record "Vendor Ledger Entry";var PurchaseHeader: Record "Purchase Header")
    begin
        VendLedgEntry.Reset;
        VendLedgEntry.SetCurrentkey("External Document No.");
        VendLedgEntry.SetRange("Document Type",GenJnlLineDocType);
        VendLedgEntry.SetRange("External Document No.",GenJnlLineExtDocNo);
        VendLedgEntry.SetRange("Vendor No.",PurchaseHeader."Pay-to Vendor No.");
        VendLedgEntry.SetRange(Reversed,false);
        if VendLedgEntry.FindFirst then
          Error(
            PurchaseAlreadyExistsErr,VendLedgEntry."Document Type",GenJnlLineExtDocNo);
    end;

    local procedure PostInvoicePostingBuffer(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        CurrExchRate: Record "Currency Exchange Rate";
        LineCount: Integer;
        GLEntryNo: Integer;
    begin
        LineCount := 0;
        if TempInvoicePostBuffer.Find('+') then
          repeat
            LineCount := LineCount + 1;
            if GuiAllowed then
              Window.Update(3,LineCount);

            case TempInvoicePostBuffer."VAT Calculation Type" of
              TempInvoicePostBuffer."vat calculation type"::"Reverse Charge VAT":
                begin
                  VATPostingSetup.Get(
                    TempInvoicePostBuffer."VAT Bus. Posting Group",TempInvoicePostBuffer."VAT Prod. Posting Group");
                  TempInvoicePostBuffer."VAT Amount" :=
                    ROUND(
                      TempInvoicePostBuffer."VAT Base Amount" *
                      (1 - PurchHeader."VAT Base Discount %" / 100) * VATPostingSetup."VAT %" / 100);
                  TempInvoicePostBuffer."VAT Amount (ACY)" :=
                    ROUND(
                      TempInvoicePostBuffer."VAT Base Amount (ACY)" * (1 - PurchHeader."VAT Base Discount %" / 100) *
                      VATPostingSetup."VAT %" / 100,Currency."Amount Rounding Precision");
                end;
            end;

            GLEntryNo := PostInvoicePostBufferLine(PurchHeader,PurchLine,TempInvoicePostBuffer);

            if (TempInvoicePostBuffer."Job No." <> '') and
               (TempInvoicePostBuffer.Type = TempInvoicePostBuffer.Type::"G/L Account")
            then
              JobPostLine.PostPurchaseGLAccounts(TempInvoicePostBuffer,GLEntryNo);

          until TempInvoicePostBuffer.Next(-1) = 0;

        TempInvoicePostBuffer.DeleteAll;
    end;

    local procedure PostItemTracking(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";var TempTrackingSpecification: Record "Tracking Specification" temporary;TrackingSpecificationExists: Boolean)
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ItemEntryRelation: Record "Item Entry Relation";
        EndLoop: Boolean;
        RemQtyToInvoiceCurrLine: Decimal;
        RemQtyToInvoiceCurrLineBase: Decimal;
        QtyToBeInvoiced: Decimal;
        QtyToBeInvoicedBase: Decimal;
    begin
        with PurchHeader do begin
          EndLoop := false;
          if IsCreditDocType then begin
            if Abs(RemQtyToBeInvoiced) > Abs(PurchLine."Return Qty. to Ship") then begin
              ReturnShptLine.Reset;
              case "Document Type" of
                "document type"::"Return Order":
                  begin
                    ReturnShptLine.SetCurrentkey("Return Order No.","Return Order Line No.");
                    ReturnShptLine.SetRange("Return Order No.",PurchLine."Document No.");
                    ReturnShptLine.SetRange("Return Order Line No.",PurchLine."Line No.");
                  end;
                "document type"::"Credit Memo":
                  begin
                    ReturnShptLine.SetRange("Document No.",PurchLine."Return Shipment No.");
                    ReturnShptLine.SetRange("Line No.",PurchLine."Return Shipment Line No.");
                  end;
              end;
              ReturnShptLine.SetFilter("Return Qty. Shipped Not Invd.",'<>0');
              if ReturnShptLine.FindSet(true,false) then begin
                ItemJnlRollRndg := true;
                repeat
                  if TrackingSpecificationExists then begin  // Item Tracking
                    ItemEntryRelation.Get(TempTrackingSpecification."Item Ledger Entry No.");
                    ReturnShptLine.Get(ItemEntryRelation."Source ID",ItemEntryRelation."Source Ref. No.");
                  end else
                    ItemEntryRelation."Item Entry No." := ReturnShptLine."Item Shpt. Entry No.";
                  ReturnShptLine.TestField("Buy-from Vendor No.",PurchLine."Buy-from Vendor No.");
                  ReturnShptLine.TestField(Type,PurchLine.Type);
                  ReturnShptLine.TestField("No.",PurchLine."No.");
                  ReturnShptLine.TestField("Gen. Bus. Posting Group",PurchLine."Gen. Bus. Posting Group");
                  ReturnShptLine.TestField("Gen. Prod. Posting Group",PurchLine."Gen. Prod. Posting Group");
                  ReturnShptLine.TestField("Job No.",PurchLine."Job No.");
                  ReturnShptLine.TestField("Unit of Measure Code",PurchLine."Unit of Measure Code");
                  ReturnShptLine.TestField("Variant Code",PurchLine."Variant Code");
                  ReturnShptLine.TestField("Prod. Order No.",PurchLine."Prod. Order No.");
                  if PurchLine."Qty. to Invoice" * ReturnShptLine.Quantity > 0 then
                    PurchLine.FieldError("Qty. to Invoice",ReturnShipmentSamesSignErr);
                  if TrackingSpecificationExists then begin  // Item Tracking
                    QtyToBeInvoiced := TempTrackingSpecification."Qty. to Invoice";
                    QtyToBeInvoicedBase := TempTrackingSpecification."Qty. to Invoice (Base)";
                  end else begin
                    QtyToBeInvoiced := RemQtyToBeInvoiced - PurchLine."Return Qty. to Ship";
                    QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - PurchLine."Return Qty. to Ship (Base)";
                  end;
                  if Abs(QtyToBeInvoiced) >
                     Abs(ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced")
                  then begin
                    QtyToBeInvoiced := ReturnShptLine."Quantity Invoiced" - ReturnShptLine.Quantity;
                    QtyToBeInvoicedBase := ReturnShptLine."Qty. Invoiced (Base)" - ReturnShptLine."Quantity (Base)";
                  end;

                  if TrackingSpecificationExists then
                    ItemTrackingMgt.AdjustQuantityRounding(
                      RemQtyToBeInvoiced,QtyToBeInvoiced,
                      RemQtyToBeInvoicedBase,QtyToBeInvoicedBase);

                  RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                  RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
                  ReturnShptLine."Quantity Invoiced" :=
                    ReturnShptLine."Quantity Invoiced" - QtyToBeInvoiced;
                  ReturnShptLine."Qty. Invoiced (Base)" :=
                    ReturnShptLine."Qty. Invoiced (Base)" - QtyToBeInvoicedBase;
                  ReturnShptLine."Return Qty. Shipped Not Invd." :=
                    ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced";
                  ReturnShptLine.Modify;
                  if PurchLine.Type = PurchLine.Type::Item then
                    PostItemJnlLine(
                      PurchHeader,PurchLine,
                      0,0,
                      QtyToBeInvoiced,QtyToBeInvoicedBase,
                      ItemEntryRelation."Item Entry No.",'',TempTrackingSpecification);
                  if TrackingSpecificationExists then
                    EndLoop := (TempTrackingSpecification.Next = 0)
                  else
                    EndLoop :=
                      (ReturnShptLine.Next = 0) or (Abs(RemQtyToBeInvoiced) <= Abs(PurchLine."Return Qty. to Ship"));
                until EndLoop;
              end else
                Error(
                  ReturnShipmentInvoicedErr,
                  PurchLine."Return Shipment Line No.",PurchLine."Return Shipment No.");
            end;

            if Abs(RemQtyToBeInvoiced) > Abs(PurchLine."Return Qty. to Ship") then begin
              if "Document Type" = "document type"::"Credit Memo" then
                Error(InvoiceGreaterThanReturnShipmentErr,ReturnShptLine."Document No.");
              Error(ReturnShipmentLinesDeletedErr);
            end;
          end else begin
            if Abs(RemQtyToBeInvoiced) > Abs(PurchLine."Qty. to Receive") then begin
              PurchRcptLine.Reset;
              case "Document Type" of
                "document type"::Order:
                  begin
                    PurchRcptLine.SetCurrentkey("Order No.","Order Line No.");
                    PurchRcptLine.SetRange("Order No.",PurchLine."Document No.");
                    PurchRcptLine.SetRange("Order Line No.",PurchLine."Line No.");
                  end;
                "document type"::Invoice:
                  begin
                    PurchRcptLine.SetRange("Document No.",PurchLine."Receipt No.");
                    PurchRcptLine.SetRange("Line No.",PurchLine."Receipt Line No.");
                  end;
              end;

              PurchRcptLine.SetFilter("Qty. Rcd. Not Invoiced",'<>0');
              if PurchRcptLine.FindSet(true,false) then begin
                ItemJnlRollRndg := true;
                repeat
                  if TrackingSpecificationExists then begin
                    ItemEntryRelation.Get(TempTrackingSpecification."Item Ledger Entry No.");
                    PurchRcptLine.Get(ItemEntryRelation."Source ID",ItemEntryRelation."Source Ref. No.");
                  end else
                    ItemEntryRelation."Item Entry No." := PurchRcptLine."Item Rcpt. Entry No.";
                  UpdateRemainingQtyToBeInvoiced(RemQtyToInvoiceCurrLine,RemQtyToInvoiceCurrLineBase,PurchRcptLine);
                  PurchRcptLine.TestField("Buy-from Vendor No.",PurchLine."Buy-from Vendor No.");
                  PurchRcptLine.TestField(Type,PurchLine.Type);
                  PurchRcptLine.TestField("No.",PurchLine."No.");
                  PurchRcptLine.TestField("Gen. Bus. Posting Group",PurchLine."Gen. Bus. Posting Group");
                  PurchRcptLine.TestField("Gen. Prod. Posting Group",PurchLine."Gen. Prod. Posting Group");
                  PurchRcptLine.TestField("Job No.",PurchLine."Job No.");
                  PurchRcptLine.TestField("Unit of Measure Code",PurchLine."Unit of Measure Code");
                  PurchRcptLine.TestField("Variant Code",PurchLine."Variant Code");
                  PurchRcptLine.TestField("Prod. Order No.",PurchLine."Prod. Order No.");

                  UpdateQtyToBeInvoiced(
                    QtyToBeInvoiced,QtyToBeInvoicedBase,
                    TrackingSpecificationExists,PurchLine,PurchRcptLine,TempTrackingSpecification);

                  if TrackingSpecificationExists then
                    ItemTrackingMgt.AdjustQuantityRounding(
                      RemQtyToInvoiceCurrLine,QtyToBeInvoiced,
                      RemQtyToInvoiceCurrLineBase,QtyToBeInvoicedBase);

                  RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                  RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
                  UpdateInvoicedQtyOnPurchRcptLine(PurchRcptLine,QtyToBeInvoiced,QtyToBeInvoicedBase);
                  if PurchLine.Type = PurchLine.Type::Item then
                    PostItemJnlLine(
                      PurchHeader,PurchLine,
                      0,0,
                      QtyToBeInvoiced,QtyToBeInvoicedBase,
                      ItemEntryRelation."Item Entry No.",'',TempTrackingSpecification);
                  if TrackingSpecificationExists then
                    EndLoop := (TempTrackingSpecification.Next = 0)
                  else
                    EndLoop :=
                      (PurchRcptLine.Next = 0) or (Abs(RemQtyToBeInvoiced) <= Abs(PurchLine."Qty. to Receive"));
                until EndLoop;
              end else
                Error(ReceiptInvoicedErr,PurchLine."Receipt Line No.",PurchLine."Receipt No.");
            end;

            if Abs(RemQtyToBeInvoiced) > Abs(PurchLine."Qty. to Receive") then begin
              if "Document Type" = "document type"::Invoice then
                Error(QuantityToInvoiceGreaterErr,PurchRcptLine."Document No.");
              Error(ReceiptLinesDeletedErr);
            end;
          end;
        end;
    end;

    local procedure PostUpdateOrderLine(PurchHeader: Record "Purchase Header")
    var
        TempPurchLine: Record "Purchase Line" temporary;
    begin
        ResetTempLines(TempPurchLine);
        with TempPurchLine do begin
          SetFilter(Quantity,'<>0');
          if FindSet then
            repeat
              if PurchHeader.Receive then begin
                "Quantity Received" += "Qty. to Receive";
                "Qty. Received (Base)" += "Qty. to Receive (Base)";
              end;
              if PurchHeader.Ship then begin
                "Return Qty. Shipped" += "Return Qty. to Ship";
                "Return Qty. Shipped (Base)" += "Return Qty. to Ship (Base)";
              end;
              if PurchHeader.Invoice then begin
                if "Document Type" = "document type"::Order then begin
                  if Abs("Quantity Invoiced" + "Qty. to Invoice") > Abs("Quantity Received") then begin
                    Validate("Qty. to Invoice","Quantity Received" - "Quantity Invoiced");
                    "Qty. to Invoice (Base)" := "Qty. Received (Base)" - "Qty. Invoiced (Base)";
                  end
                end else
                  if Abs("Quantity Invoiced" + "Qty. to Invoice") > Abs("Return Qty. Shipped") then begin
                    Validate("Qty. to Invoice","Return Qty. Shipped" - "Quantity Invoiced");
                    "Qty. to Invoice (Base)" := "Return Qty. Shipped (Base)" - "Qty. Invoiced (Base)";
                  end;

                "Quantity Invoiced" := "Quantity Invoiced" + "Qty. to Invoice";
                "Qty. Invoiced (Base)" := "Qty. Invoiced (Base)" + "Qty. to Invoice (Base)";
                if "Qty. to Invoice" <> 0 then begin
                  "Prepmt Amt Deducted" += "Prepmt Amt to Deduct";
                  "Prepmt VAT Diff. Deducted" += "Prepmt VAT Diff. to Deduct";
                  DecrementPrepmtAmtInvLCY(
                    PurchHeader,TempPurchLine,"Prepmt. Amount Inv. (LCY)","Prepmt. VAT Amount Inv. (LCY)");
                  "Prepmt Amt to Deduct" := "Prepmt. Amt. Inv." - "Prepmt Amt Deducted";
                  "Prepmt VAT Diff. to Deduct" := 0;
                end;
              end;

              UpdateBlanketOrderLine(TempPurchLine,PurchHeader.Receive,PurchHeader.Ship,PurchHeader.Invoice);
              InitOutstanding;

              if WhseHandlingRequired(TempPurchLine) or
                 (PurchSetup."Default Qty. to Receive" = PurchSetup."default qty. to receive"::Blank)
              then begin
                if "Document Type" = "document type"::"Return Order" then begin
                  "Return Qty. to Ship" := 0;
                  "Return Qty. to Ship (Base)" := 0;
                end else begin
                  "Qty. to Receive" := 0;
                  "Qty. to Receive (Base)" := 0;
                end;
                InitQtyToInvoice;
              end else begin
                if "Document Type" = "document type"::"Return Order" then
                  InitQtyToShip
                else
                  InitQtyToReceive2;
              end;
              SetDefaultQuantity;
              ModifyTempLine(TempPurchLine);
            until Next = 0;
        end;
    end;

    local procedure PostUpdateInvoiceLine(PurchHeader: Record "Purchase Header")
    var
        PurchOrderLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        SalesOrderLine: Record "Sales Line";
        TempPurchLine: Record "Purchase Line" temporary;
    begin
        ResetTempLines(TempPurchLine);
        with TempPurchLine do begin
          SetFilter("Receipt No.",'<>%1','');
          SetFilter(Type,'<>%1',Type::" ");
          if FindSet then
            repeat
              PurchRcptLine.Get("Receipt No.","Receipt Line No.");
              PurchOrderLine.Get(
                PurchOrderLine."document type"::Order,
                PurchRcptLine."Order No.",PurchRcptLine."Order Line No.");
              if Type = Type::"Charge (Item)" then
                UpdatePurchOrderChargeAssgnt(TempPurchLine,PurchOrderLine);
              PurchOrderLine."Quantity Invoiced" += "Qty. to Invoice";
              PurchOrderLine."Qty. Invoiced (Base)" += "Qty. to Invoice (Base)";
              if Abs(PurchOrderLine."Quantity Invoiced") > Abs(PurchOrderLine."Quantity Received") then
                Error(InvoiceMoreThanReceivedErr,PurchOrderLine."Document No.");
              if PurchOrderLine."Sales Order Line No." <> 0 then begin // Drop Shipment
                SalesOrderLine.Get(
                  SalesOrderLine."document type"::Order,
                  PurchOrderLine."Sales Order No.",PurchOrderLine."Sales Order Line No.");
                if Abs(PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced") <
                   Abs(SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced")
                then
                  Error(CannotPostBeforeAssosSalesOrderErr,PurchOrderLine."Sales Order No.");
              end;
              PurchOrderLine.InitQtyToInvoice;
              if PurchOrderLine."Prepayment %" <> 0 then begin
                PurchOrderLine."Prepmt Amt Deducted" += "Prepmt Amt to Deduct";
                PurchOrderLine."Prepmt VAT Diff. Deducted" += "Prepmt VAT Diff. to Deduct";
                DecrementPrepmtAmtInvLCY(
                  PurchHeader,TempPurchLine,PurchOrderLine."Prepmt. Amount Inv. (LCY)",PurchOrderLine."Prepmt. VAT Amount Inv. (LCY)");
                PurchOrderLine."Prepmt Amt to Deduct" :=
                  PurchOrderLine."Prepmt. Amt. Inv." - PurchOrderLine."Prepmt Amt Deducted";
                PurchOrderLine."Prepmt VAT Diff. to Deduct" := 0;
              end;
              PurchOrderLine.InitOutstanding;
              PurchOrderLine.Modify;
            until Next = 0;
        end;
    end;

    local procedure PostUpdateCreditMemoLine()
    var
        PurchOrderLine: Record "Purchase Line";
        ReturnShptLine: Record "Return Shipment Line";
        TempPurchLine: Record "Purchase Line" temporary;
    begin
        ResetTempLines(TempPurchLine);
        with TempPurchLine do begin
          SetFilter("Return Shipment No.",'<>%1','');
          SetFilter(Type,'<>%1',Type::" ");
          if FindSet then
            repeat
              ReturnShptLine.Get("Return Shipment No.","Return Shipment Line No.");
              PurchOrderLine.Get(
                PurchOrderLine."document type"::"Return Order",
                ReturnShptLine."Return Order No.",ReturnShptLine."Return Order Line No.");
              if Type = Type::"Charge (Item)" then
                UpdatePurchOrderChargeAssgnt(TempPurchLine,PurchOrderLine);
              PurchOrderLine."Quantity Invoiced" :=
                PurchOrderLine."Quantity Invoiced" + "Qty. to Invoice";
              PurchOrderLine."Qty. Invoiced (Base)" :=
                PurchOrderLine."Qty. Invoiced (Base)" + "Qty. to Invoice (Base)";
              if Abs(PurchOrderLine."Quantity Invoiced") > Abs(PurchOrderLine."Return Qty. Shipped") then
                Error(InvoiceMoreThanShippedErr,PurchOrderLine."Document No.");
              PurchOrderLine.InitQtyToInvoice;
              PurchOrderLine.InitOutstanding;
              PurchOrderLine.Modify;
            until Next = 0;
        end;
    end;

    local procedure SetPostingFlags(var PurchHeader: Record "Purchase Header")
    begin
        with PurchHeader do begin
          case "Document Type" of
            "document type"::Order:
              Ship := false;
            "document type"::Invoice:
              begin
                Receive := true;
                Invoice := true;
                Ship := false;
              end;
            "document type"::"Return Order":
              Receive := false;
            "document type"::"Credit Memo":
              begin
                Receive := false;
                Invoice := true;
                Ship := true;
              end;
          end;
          if not (Receive or Invoice or Ship) then
            Error(ReceiveInvoiceShipErr);
        end;
    end;

    local procedure SetCheckApplToItemEntry(PurchLine: Record "Purchase Line"): Boolean
    begin
        with PurchLine do
          exit(
            PurchSetup."Exact Cost Reversing Mandatory" and (Type = Type::Item) and
            (((Quantity < 0) and ("Document Type" in ["document type"::Order,"document type"::Invoice])) or
             ((Quantity > 0) and IsCreditDocType)) and
            ("Job No." = ''));
    end;

    local procedure SetTaxType(PurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line")
    begin
        TaxOption := 0;
        if PurchHeader.Invoice then begin
          PurchLine.SetFilter("Qty. to Invoice",'<>0');
          if PurchLine.Find('-') then
            repeat
              if PurchLine."VAT Calculation Type" = PurchLine."vat calculation type"::"Sales Tax" then begin
                if PurchLine."Tax Area Code" <> '' then begin
                  if SalesTaxCountry = Salestaxcountry::NoTax then
                    Error(EveryLineMustHaveSameErr,PurchLine.FieldCaption("Tax Area Code"),PurchLine."Tax Area Code");
                  TaxArea.Get(PurchLine."Tax Area Code");
                  if TaxArea."Country/Region" <> SalesTaxCountry then
                    Error(TaxAreaSetupShouldBeSameErr,TaxArea.FieldCaption("Country/Region"),SalesTaxCountry);
                  if TaxArea."Use External Tax Engine" <> UseExternalTaxEngine then
                    Error(TaxAreaSetupShouldBeSameErr,TaxArea.FieldCaption("Use External Tax Engine"),UseExternalTaxEngine);
                end;
                if TaxOption = 0 then begin
                  TaxOption := Taxoption::SalesTax;
                  if PurchLine."Tax Area Code" <> '' then
                    AddSalesTaxLineToSalesTaxCalc(PurchHeader,PurchLine,true);
                end else
                  if TaxOption = Taxoption::VAT then
                    Error(EveryLineMustHaveSameErr,PurchLine.FieldCaption("VAT Calculation Type"),TaxOption)
                  else
                    if PurchLine."Tax Area Code" <> '' then
                      AddSalesTaxLineToSalesTaxCalc(PurchHeader,PurchLine,false);
              end else begin
                if TaxOption = 0 then
                  TaxOption := Taxoption::VAT
                else
                  if TaxOption = Taxoption::SalesTax then
                    Error(EveryLineMustHaveSameErr,PurchLine.FieldCaption("VAT Calculation Type"),TaxOption);
              end;
            until PurchLine.Next = 0;
          PurchLine.SetRange("Qty. to Invoice");
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostCommitPurchaseDoc(var PurchaseHeader: Record "Purchase Header";var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";PreviewMode: Boolean;ModifyHeader: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header";var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";PurchRcpHdrNo: Code[20];RetShptHdrNo: Code[20];PurchInvHdrNo: Code[20];PurchCrMemoHdrNo: Code[20])
    begin
    end;

    local procedure CreatePostedDeferralScheduleFromPurchDoc(PurchLine: Record "Purchase Line";NewDocumentType: Integer;NewDocumentNo: Code[20];NewLineNo: Integer;PostingDate: Date)
    var
        PostedDeferralHeader: Record "Posted Deferral Header";
        PostedDeferralLine: Record "Posted Deferral Line";
        DeferralTemplate: Record "Deferral Template";
        DeferralAccount: Code[20];
    begin
        if PurchLine."Deferral Code" = '' then
          exit;

        if DeferralTemplate.Get(PurchLine."Deferral Code") then
          DeferralAccount := DeferralTemplate."Deferral Account";

        if TempDeferralHeader.Get(
             DeferralUtilities.GetPurchDeferralDocType,'','',PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.")
        then begin
          PostedDeferralHeader.InitFromDeferralHeader(TempDeferralHeader,'','',NewDocumentType,
            NewDocumentNo,NewLineNo,DeferralAccount,PurchLine."Buy-from Vendor No.",PostingDate);
          with TempDeferralLine do begin
            SetRange("Deferral Doc. Type",DeferralUtilities.GetPurchDeferralDocType);
            SetRange("Gen. Jnl. Template Name",'');
            SetRange("Gen. Jnl. Batch Name",'');
            SetRange("Document Type",PurchLine."Document Type");
            SetRange("Document No.",PurchLine."Document No.");
            SetRange("Line No.",PurchLine."Line No.");
            if FindSet then begin
              repeat
                PostedDeferralLine.InitFromDeferralLine(
                  TempDeferralLine,'','',NewDocumentType,NewDocumentNo,NewLineNo,DeferralAccount);
              until Next = 0;
            end;
          end;
        end;
    end;

    local procedure CalcDeferralAmounts(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";OriginalDeferralAmount: Decimal)
    var
        DeferralHeader: Record "Deferral Header";
        DeferralLine: Record "Deferral Line";
        CurrExchRate: Record "Currency Exchange Rate";
        TotalAmountLCY: Decimal;
        TotalAmount: Decimal;
        TotalDeferralCount: Integer;
        DeferralCount: Integer;
        UseDate: Date;
    begin
        // Populate temp and calculate the LCY amounts for posting
        if PurchHeader."Posting Date" = 0D then
          UseDate := WorkDate
        else
          UseDate := PurchHeader."Posting Date";

        if DeferralHeader.Get(
             DeferralUtilities.GetPurchDeferralDocType,'','',PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.")
        then begin
          TempDeferralHeader := DeferralHeader;
          if PurchLine.Quantity <> PurchLine."Qty. to Invoice" then
            TempDeferralHeader."Amount to Defer" :=
              ROUND(TempDeferralHeader."Amount to Defer" *
                PurchLine.GetDeferralAmount / OriginalDeferralAmount,Currency."Amount Rounding Precision");
          TempDeferralHeader."Amount to Defer (LCY)" :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                UseDate,PurchHeader."Currency Code",
                TempDeferralHeader."Amount to Defer",PurchHeader."Currency Factor"));
          TempDeferralHeader.Insert;

          with DeferralLine do begin
            SetRange("Deferral Doc. Type",DeferralUtilities.GetPurchDeferralDocType);
            SetRange("Gen. Jnl. Template Name",'');
            SetRange("Gen. Jnl. Batch Name",'');
            SetRange("Document Type",PurchLine."Document Type");
            SetRange("Document No.",PurchLine."Document No.");
            SetRange("Line No.",PurchLine."Line No.");
            if FindSet then begin
              TotalDeferralCount := Count;
              repeat
                TempDeferralLine.Init;
                TempDeferralLine := DeferralLine;
                DeferralCount := DeferralCount + 1;

                if DeferralCount = TotalDeferralCount then begin
                  TempDeferralLine.Amount := TempDeferralHeader."Amount to Defer" - TotalAmount;
                  TempDeferralLine."Amount (LCY)" := TempDeferralHeader."Amount to Defer (LCY)" - TotalAmountLCY;
                end else begin
                  if PurchLine.Quantity <> PurchLine."Qty. to Invoice" then
                    TempDeferralLine.Amount :=
                      ROUND(TempDeferralLine.Amount *
                        PurchLine.GetDeferralAmount / OriginalDeferralAmount,Currency."Amount Rounding Precision");

                  TempDeferralLine."Amount (LCY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        UseDate,PurchHeader."Currency Code",
                        TempDeferralLine.Amount,PurchHeader."Currency Factor"));
                  TotalAmount := TotalAmount + TempDeferralLine.Amount;
                  TotalAmountLCY := TotalAmountLCY + TempDeferralLine."Amount (LCY)";
                end;
                TempDeferralLine.Insert;
              until Next = 0;
            end;
          end;
        end;
    end;

    local procedure GetAmountRoundingPrecisionInLCY(DocType: Option;DocNo: Code[20];CurrencyCode: Code[10]): Decimal
    var
        PurchHeader: Record "Purchase Header";
    begin
        if CurrencyCode = '' then
          exit(GLSetup."Amount Rounding Precision");
        PurchHeader.Get(DocType,DocNo);
        exit(Currency."Amount Rounding Precision" / PurchHeader."Currency Factor");
    end;

    local procedure CollectPurchaseLineReservEntries(var JobReservEntry: Record "Reservation Entry";ItemJournalLine: Record "Item Journal Line")
    var
        ReservationEntry: Record "Reservation Entry";
        ItemJnlLineReserve: Codeunit "Item Jnl. Line-Reserve";
    begin
        if ItemJournalLine."Job No." <> '' then begin
          JobReservEntry.DeleteAll;
          ItemJnlLineReserve.FindReservEntry(ItemJournalLine,ReservationEntry);
          ReservationEntry.SetRange("Lot No.");
          ReservationEntry.SetRange("Serial No.");
          if ReservationEntry.FindSet then
            repeat
              JobReservEntry := ReservationEntry;
              JobReservEntry.Insert;
            until ReservationEntry.Next = 0;
        end;
    end;
}

