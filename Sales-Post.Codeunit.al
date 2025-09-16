#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 80 "Sales-Post"
{
    Permissions = TableData "Sales Line"=imd,
                  TableData "Purchase Header"=m,
                  TableData "Purchase Line"=m,
                  TableData "Invoice Post. Buffer"=imd,
                  TableData "Sales Shipment Header"=imd,
                  TableData "Sales Shipment Line"=imd,
                  TableData "Sales Invoice Header"=imd,
                  TableData "Sales Invoice Line"=imd,
                  TableData "Sales Cr.Memo Header"=imd,
                  TableData "Sales Cr.Memo Line"=imd,
                  TableData "Purch. Rcpt. Header"=imd,
                  TableData "Purch. Rcpt. Line"=imd,
                  TableData "Drop Shpt. Post. Buffer"=imd,
                  TableData "General Posting Setup"=imd,
                  TableData "Posted Assemble-to-Order Link"=i,
                  TableData "Item Entry Relation"=ri,
                  TableData "Value Entry Relation"=rid,
                  TableData "Return Receipt Header"=imd,
                  TableData "Return Receipt Line"=imd;
    TableNo = "Sales Header";

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;
        TempItemLedgEntryNotInvoiced: Record "Item Ledger Entry" temporary;
        CustLedgEntry: Record "Cust. Ledger Entry";
        TempCombinedSalesLine: Record "Sales Line" temporary;
        TempServiceItem2: Record "Service Item" temporary;
        TempServiceItemComp2: Record "Service Item Component" temporary;
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary;
        UpdateAnalysisView: Codeunit "Update Analysis View";
        UpdateItemAnalysisView: Codeunit "Update Item Analysis View";
        HasATOShippedNotInvoiced: Boolean;
        EverythingInvoiced: Boolean;
        BiggestLineNo: Integer;
        ICGenJnlLineNo: Integer;
        LineCount: Integer;
    begin
        OnBeforePostSalesDoc(Rec);

        if PostingDateExists and (ReplacePostingDate or ("Posting Date" = 0D)) then begin
          "Posting Date" := PostingDate;
          Validate("Currency Code");
        end;

        if PostingDateExists and (ReplaceDocumentDate or ("Document Date" = 0D)) then
          Validate("Document Date",PostingDate);

        if PreviewMode then begin
          ClearAll;
          PreviewMode := true;
        end else
          ClearAll;

        GetGLSetup;
        GetCurrency("Currency Code");

        SalesSetup.Get;
        SalesHeader := Rec;
        FillTempLines(SalesHeader);
        TempServiceItem2.DeleteAll;
        TempServiceItemComp2.DeleteAll;

        // Header
        CheckAndUpdate(SalesHeader);

        TempDeferralHeader.DeleteAll;
        TempDeferralLine.DeleteAll;
        TempInvoicePostBuffer.DeleteAll;
        TempDropShptPostBuffer.DeleteAll;
        EverythingInvoiced := true;

        // Lines
        SalesLine.Reset;
        SalesLine.SetRange("Document Type",SalesHeader."Document Type");
        SalesLine.SetRange("Document No.",SalesHeader."No.");
        LineCount := 0;
        RoundingLineInserted := false;
        MergeSaleslines(SalesHeader,SalesLine,TempPrepaymentSalesLine,TempCombinedSalesLine);
        AdjustFinalInvWith100PctPrepmt(TempCombinedSalesLine);

        SetTaxType(SalesHeader,SalesLine);

        if TaxOption = Taxoption::SalesTax then begin
          OnBeforeCalculateSalesTax(SalesHeader,TempSalesLineForSalesTax,TempSalesTaxAmtLine,SalesTaxCalculationOverridden);
          if not SalesTaxCalculationOverridden then
            if SalesTaxCountry <> Salestaxcountry::NoTax then begin
              if UseExternalTaxEngine then
                SalesTaxCalculate.CallExternalTaxEngineForSales(SalesHeader,false)
              else
                SalesTaxCalculate.EndSalesTaxCalculation("Posting Date");
              SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxAmtLine);
              SalesTaxCalculate.DistTaxOverSalesLines(TempSalesLineForSalesTax);
            end;
        end else begin
          TempVATAmountLineRemainder.DeleteAll;
          SalesLine.CalcVATAmountLines(1,SalesHeader,TempCombinedSalesLine,TempVATAmountLine);
        end;

        SalesLinesProcessed := false;
        if SalesLine.FindFirst then
          repeat
            ItemJnlRollRndg := false;
            LineCount := LineCount + 1;
            Window.Update(2,LineCount);

            PostSalesLine(
              SalesHeader,SalesLine,EverythingInvoiced,TempInvoicePostBuffer,TempVATAmountLine,TempVATAmountLineRemainder,
              TempItemLedgEntryNotInvoiced,HasATOShippedNotInvoiced,TempDropShptPostBuffer,ICGenJnlLineNo,
              TempServiceItem2,TempServiceItemComp2);

            if RoundingLineInserted then
              LastLineRetrieved := true
            else begin
              BiggestLineNo := MAX(BiggestLineNo,SalesLine."Line No.");
              LastLineRetrieved := GetNextSalesline(SalesLine);
              if LastLineRetrieved and SalesSetup."Invoice Rounding" then
                InvoiceRounding(SalesHeader,SalesLine,false,BiggestLineNo);
            end;
          until LastLineRetrieved;

        if not SalesHeader.IsCreditDocType then begin
          ReverseAmount(TotalSalesLine);
          ReverseAmount(TotalSalesLineLCY);
          TotalSalesLineLCY."Unit Cost (LCY)" := -TotalSalesLineLCY."Unit Cost (LCY)";
        end;

        PostDropOrderShipment(SalesHeader,TempDropShptPostBuffer);
        if SalesHeader.Invoice then
          PostGLAndCustomer(SalesHeader,TempInvoicePostBuffer,CustLedgEntry,LineCount);

        if ICGenJnlLineNo > 0 then
          PostICGenJnl;

        if PreviewMode then begin
          Window.Close;
          GenJnlPostPreview.ThrowError;
        end;

        MakeInventoryAdjustment;
        UpdateLastPostingNos(SalesHeader);

        FinalizePosting(SalesHeader,EverythingInvoiced,TempDropShptPostBuffer);

        Rec := SalesHeader;
        SynchBOMSerialNo(TempServiceItem2,TempServiceItemComp2);
        if not InvtPickPutaway then begin
          Commit;
          UpdateAnalysisView.UpdateAll(0,true);
          UpdateItemAnalysisView.UpdateAll(0,true);
        end;

        OnAfterPostSalesDoc(
          Rec,GenJnlPostLine,SalesShptHeader."No.",ReturnRcptHeader."No.",SalesInvHeader."No.",SalesCrMemoHeader."No.",
          SalesInvHeader,SalesCrMemoHeader);
    end;

    var
        NothingToPostErr: label 'There is nothing to post.';
        PostingLinesMsg: label 'Posting lines              #2######\', Comment='Counter';
        PostingSalesAndVATMsg: label 'Posting sales and tax      #3######\', Comment='Counter';
        PostingCustomersMsg: label 'Posting to customers       #4######\', Comment='Counter';
        PostingBalAccountMsg: label 'Posting to bal. account    #5######', Comment='Counter';
        PostingLines2Msg: label 'Posting lines              #2######', Comment='Counter';
        InvoiceNoMsg: label '%1 %2 -> Invoice %3', Comment='%1 = Document Type, %2 = Document No, %3 = Invoice No.';
        CreditMemoNoMsg: label '%1 %2 -> Credit Memo %3', Comment='%1 = Document Type, %2 = Document No, %3 = Credit Memo No.';
        DropShipmentErr: label 'You cannot ship sales order line %1. The line is marked as a drop shipment and is not yet associated with a purchase order.', Comment='%1 = Line No.';
        ShipmentSameSignErr: label 'must have the same sign as the shipment';
        ShipmentLinesDeletedErr: label 'The shipment lines have been deleted.';
        InvoiceMoreThanShippedErr: label 'You cannot invoice more than you have shipped for order %1.', Comment='%1 = Order No.';
        VATAmountTxt: label 'Tax Amount';
        VATRateTxt: label '%1% Tax', Comment='%1 = VAT Rate';
        BlanketOrderQuantityGreaterThanErr: label 'in the associated blanket order must not be greater than %1', Comment='%1 = Quantity';
        BlanketOrderQuantityReducedErr: label 'in the associated blanket order must not be reduced';
        ShipInvoiceReceiveErr: label 'Please enter "Yes" in Ship and/or Invoice and/or Receive.';
        WarehouseRequiredErr: label 'Warehouse handling is required for %1 = %2, %3 = %4, %5 = %6.', Comment='%1/%2 = Document Type, %3/%4 - Document No.,%5/%6 = Line No.';
        ReturnReceiptSameSignErr: label 'must have the same sign as the return receipt';
        ReturnReceiptInvoicedErr: label 'Line %1 of the return receipt %2, which you are attempting to invoice, has already been invoiced.', Comment='%1 = Line No., %2 = Document No.';
        ShipmentInvoiceErr: label 'Line %1 of the shipment %2, which you are attempting to invoice, has already been invoiced.', Comment='%1 = Line No., %2 = Document No.';
        QuantityToInvoiceGreaterErr: label 'The quantity you are attempting to invoice is greater than the quantity in shipment %1.', Comment='%1 = Document No.';
        DimensionIsBlockedErr: label 'The combination of dimensions used in %1 %2 is blocked (Error: %3).', Comment='%1 = Document Type, %2 = Document No, %3 = Error text';
        LineDimensionBlockedErr: label 'The combination of dimensions used in %1 %2, line no. %3 is blocked (Error: %4).', Comment='%1 = Document Type, %2 = Document No, %3 = LineNo., %4 = Error text';
        InvalidDimensionsErr: label 'The dimensions used in %1 %2 are invalid (Error: %3).', Comment='%1 = Document Type, %2 = Document No, %3 = Error text';
        LineInvalidDimensionsErr: label 'The dimensions used in %1 %2, line no. %3 are invalid (Error: %4).', Comment='%1 = Document Type, %2 = Document No, %3 = LineNo., %4 = Error text';
        CannotAssignMoreErr: label 'You cannot assign more than %1 units in %2 = %3, %4 = %5,%6 = %7.', Comment='%1 = Quantity, %2/%3 = Document Type, %4/%5 - Document No.,%6/%7 = Line No.';
        MustAssignErr: label 'You must assign all item charges, if you invoice everything.';
        Item: Record Item;
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        GLEntry: Record "G/L Entry";
        TempSalesLineGlobal: Record "Sales Line" temporary;
        xSalesLine: Record "Sales Line";
        SalesLineACY: Record "Sales Line";
        TotalSalesLine: Record "Sales Line";
        TotalSalesLineLCY: Record "Sales Line";
        TempPrepaymentSalesLine: Record "Sales Line" temporary;
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary;
        SourceCodeSetup: Record "Source Code Setup";
        Currency: Record Currency;
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
        TempATOTrackingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecificationInv: Record "Tracking Specification" temporary;
        TempWhseSplitSpecification: Record "Tracking Specification" temporary;
        TempValueEntryRelation: Record "Value Entry Relation" temporary;
        TaxAmountDifference: Record UnknownRecord10012;
        JobTaskSalesLine: Record "Sales Line";
        TempICGenJnlLine: Record "Gen. Journal Line" temporary;
        TempPrepmtDeductLCYSalesLine: Record "Sales Line" temporary;
        TempSKU: Record "Stockkeeping Unit" temporary;
        DeferralPostBuffer: array [2] of Record "Deferral Post. Buffer";
        TempDeferralHeader: Record "Deferral Header" temporary;
        TempDeferralLine: Record "Deferral Line" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        WhseJnlPostLine: Codeunit "Whse. Jnl.-Register Line";
        WhsePostRcpt: Codeunit "Whse.-Post Receipt";
        WhsePostShpt: Codeunit "Whse.-Post Shipment";
        PurchPost: Codeunit "Purch.-Post";
        CostCalcMgt: Codeunit "Cost Calculation Management";
        JobPostLine: Codeunit "Job Post-Line";
        ServItemMgt: Codeunit ServItemManagement;
        AsmPost: Codeunit "Assembly-Post";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        DeferralUtilities: Codeunit "Deferral Utilities";
        Window: Dialog;
        PostingDate: Date;
        UseDate: Date;
        GenJnlLineDocNo: Code[20];
        GenJnlLineExtDocNo: Code[35];
        SrcCode: Code[10];
        GenJnlLineDocType: Integer;
        ItemLedgShptEntryNo: Integer;
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
        CannotAssignInvoicedErr: label 'You cannot assign item charges to the %1 %2 = %3,%4 = %5, %6 = %7, because it has been invoiced.', Comment='%1 = Sales Line, %2/%3 = Document Type, %4/%5 - Document No.,%6/%7 = Line No.';
        InvoiceMoreThanReceivedErr: label 'You cannot invoice more than you have received for return order %1.', Comment='%1 = Order No.';
        ReturnReceiptLinesDeletedErr: label 'The return receipt lines have been deleted.';
        InvoiceGreaterThanReturnReceiptErr: label 'The quantity you are attempting to invoice is greater than the quantity in return receipt %1.', Comment='%1 = Receipt No.';
        ItemJnlRollRndg: Boolean;
        RelatedItemLedgEntriesNotFoundErr: label 'Related item ledger entries cannot be found.';
        ItemTrackingWrongSignErr: label 'Item Tracking is signed wrongly.';
        ItemTrackingMismatchErr: label 'Item Tracking does not match.';
        WhseShip: Boolean;
        WhseReceive: Boolean;
        InvtPickPutaway: Boolean;
        PostingDateNotAllowedErr: label 'is not within your range of allowed posting dates';
        ItemTrackQuantityMismatchErr: label 'The %1 does not match the quantity defined in item tracking.', Comment='%1 = Quantity';
        CannotBeGreaterThanErr: label 'cannot be more than %1.', Comment='%1 = Amount';
        CannotBeSmallerThanErr: label 'must be at least %1.', Comment='%1 = Amount';
        JobContractLine: Boolean;
        GLSetupRead: Boolean;
        ItemTrkgAlreadyOverruled: Boolean;
        PrepAmountToDeductToBigErr: label 'The total %1 cannot be more than %2.', Comment='%1 = Prepmt Amt to Deduct, %2 = Max Amount';
        PrepAmountToDeductToSmallErr: label 'The total %1 must be at least %2.', Comment='%1 = Prepmt Amt to Deduct, %2 = Max Amount';
        MustAssignItemChargeErr: label 'You must assign item charge %1 if you want to invoice it.', Comment='%1 = Item Charge No.';
        CannotInvoiceItemChargeErr: label 'You can not invoice item charge %1 because there is no item ledger entry to assign it to.', Comment='%1 = Item Charge No.';
        SalesLinesProcessed: Boolean;
        AssemblyCheckProgressMsg: label '#1#################################\\Checking Assembly #2###########', Comment='%1 = Text, %2 = Progress bar';
        AssemblyPostProgressMsg: label '#1#################################\\Posting Assembly #2###########', Comment='%1 = Text, %2 = Progress bar';
        AssemblyFinalizeProgressMsg: label '#1#################################\\Finalizing Assembly #2###########', Comment='%1 = Text, %2 = Progress bar';
        ReassignItemChargeErr: label 'The order line that the item charge was originally assigned to has been fully posted. You must reassign the item charge to the posted receipt or shipment.';
        ReservationDisruptedQst: label 'One or more reservation entries exist for the item with %1 = %2, %3 = %4, %5 = %6 which may be disrupted if you post this negative adjustment. Do you want to continue?', Comment='One or more reservation entries exist for the item with No. = 1000, Location Code = SILVER, Variant Code = NEW which may be disrupted if you post this negative adjustment. Do you want to continue?';
        GenProdPostingGrDiscErr: label 'You must enter a value in %1 for %2 %3 if you want to post discounts for that line.';
        NotSupportedDocumentTypeErr: label 'Document type %1 is not supported.', Comment='%1 = Document Type';
        PreviewMode: Boolean;
        NoDeferralScheduleErr: label 'You must create a deferral schedule because you have specified the deferral code %2 in line %1.', Comment='%1=The item number of the sales transaction line, %2=The Deferral Template Code';
        ZeroDeferralAmtErr: label 'Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.', Comment='%1=The item number of the sales transaction line, %2=The Deferral Template Code';
        TaxArea: Record "Tax Area";
        TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;
        TempSalesLineForSalesTax: Record "Sales Line" temporary;
        TempSalesLineForSpread: Record "Sales Line" temporary;
        SalesTaxCountry: Option US,CA,,,,,,,,,,,,NoTax;
        TaxOption: Option ,VAT,SalesTax;
        UseExternalTaxEngine: Boolean;
        EveryLineMustHaveSameErr: label 'Every sales line must have same %1 = %2.';
        TaxAreaSetupShouldBeSameErr: label 'If sales document has Tax Area Code whose %1 is %2, then any line with a Tax Area Code must have one whose %1 is %2. ';
        SalesTaxCalculationOverridden: Boolean;
        DownloadShipmentAlsoQst: label 'You can also download the Sales - Shipment document now. Alternatively, you can access it from the Posted Sales Shipments window later.\\Do you want to download the Sales - Shipment document now?';

    local procedure CopyToTempLines(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type",SalesHeader."Document Type");
        SalesLine.SetRange("Document No.",SalesHeader."No.");
        if SalesLine.FindSet then
          repeat
            TempSalesLineGlobal := SalesLine;
            TempSalesLineGlobal.Insert;
          until SalesLine.Next = 0;
    end;

    local procedure FillTempLines(SalesHeader: Record "Sales Header")
    begin
        TempSalesLineGlobal.Reset;
        if TempSalesLineGlobal.IsEmpty then
          CopyToTempLines(SalesHeader);
    end;

    local procedure ModifyTempLine(var TempSalesLineLocal: Record "Sales Line" temporary)
    var
        SalesLine: Record "Sales Line";
    begin
        TempSalesLineLocal.Modify;
        SalesLine := TempSalesLineLocal;
        SalesLine.Modify;
    end;

    local procedure RefreshTempLines(SalesHeader: Record "Sales Header")
    begin
        TempSalesLineGlobal.Reset;
        TempSalesLineGlobal.DeleteAll;
        CopyToTempLines(SalesHeader);
    end;

    local procedure ResetTempLines(var TempSalesLineLocal: Record "Sales Line" temporary)
    begin
        TempSalesLineLocal.Reset;
        TempSalesLineLocal.Copy(TempSalesLineGlobal,true);
    end;

    local procedure CalcInvoice(SalesHeader: Record "Sales Header") NewInvoice: Boolean
    var
        TempSalesLine: Record "Sales Line" temporary;
    begin
        with SalesHeader do begin
          ResetTempLines(TempSalesLine);
          TempSalesLine.SetFilter(Quantity,'<>0');
          if "Document Type" in ["document type"::Order,"document type"::"Return Order"] then
            TempSalesLine.SetFilter("Qty. to Invoice",'<>0');
          NewInvoice := not TempSalesLine.IsEmpty;
          if NewInvoice then
            case "Document Type" of
              "document type"::Order:
                if not Ship then begin
                  TempSalesLine.SetFilter("Qty. Shipped Not Invoiced",'<>0');
                  NewInvoice := not TempSalesLine.IsEmpty;
                end;
              "document type"::"Return Order":
                if not Receive then begin
                  TempSalesLine.SetFilter("Return Qty. Rcd. Not Invd.",'<>0');
                  NewInvoice := not TempSalesLine.IsEmpty;
                end;
            end;
          exit(NewInvoice);
        end;
    end;

    local procedure CalcInvDiscount(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        TempInvoice: Boolean;
        TempShpt: Boolean;
        TempReturn: Boolean;
    begin
        with SalesHeader do begin
          if not (SalesSetup."Calc. Inv. Discount" and (Status <> Status::Open)) then
            exit;

          SalesLine.Reset;
          SalesLine.SetRange("Document Type","Document Type");
          SalesLine.SetRange("Document No.","No.");
          SalesLine.FindFirst;
          TempInvoice := Invoice;
          TempShpt := Ship;
          TempReturn := Receive;
          Codeunit.Run(Codeunit::"Sales-Calc. Discount",SalesLine);
          Get("Document Type","No.");
          Invoice := TempInvoice;
          Ship := TempShpt;
          Receive := TempReturn;
          if not PreviewMode then
            Commit;
        end;
    end;

    local procedure CheckAndUpdate(var SalesHeader: Record "Sales Header")
    var
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        ModifyHeader: Boolean;
    begin
        with SalesHeader do begin
          // Check
          TestField("On Hold",'');
          CheckMandatoryHeaderFields(SalesHeader);
          GLSetup.Get;
          if GLSetup."PAC Environment" <> GLSetup."pac environment"::Disabled then
            TestField("Payment Method Code");

          if GenJnlCheckLine.DateNotAllowed("Posting Date") then
            FieldError("Posting Date",PostingDateNotAllowedErr);

          if "Tax Area Code" = '' then
            SalesTaxCountry := Salestaxcountry::NoTax
          else begin
            TaxArea.Get("Tax Area Code");
            SalesTaxCountry := TaxArea."Country/Region";
            UseExternalTaxEngine := TaxArea."Use External Tax Engine";
          end;

          SetPostingFlags(SalesHeader);
          InitProgressWindow(SalesHeader);

          InvtPickPutaway := "Posting from Whse. Ref." <> 0;
          "Posting from Whse. Ref." := 0;

          CheckDim(SalesHeader);

          CheckPostRestrictions(SalesHeader);

          if Invoice then
            Invoice := CalcInvoice(SalesHeader);

          if Invoice then
            CopyAndCheckItemCharge(SalesHeader);

          if Invoice and not IsCreditDocType then
            TestField("Due Date");

          if Ship then begin
            InitPostATOs(SalesHeader);
            Ship := CheckTrackingAndWarehouseForShip(SalesHeader);
          end;

          if Receive then
            Receive := CheckTrackingAndWarehouseForReceive(SalesHeader);

          if not (Ship or Invoice or Receive) then
            Error(NothingToPostErr);

          if ("Shipping Advice" = "shipping advice"::Complete) and Ship then
            CheckShippingAdvice;

          // Update
          if Invoice then
            CreatePrepaymentLines(SalesHeader,TempPrepaymentSalesLine,true);

          ModifyHeader := UpdatePostingNos(SalesHeader);

          DropShipOrder := UpdateAssosOrderPostingNos(SalesHeader);

          OnBeforePostCommitSalesDoc(SalesHeader,GenJnlPostLine,PreviewMode,ModifyHeader);
          if not PreviewMode and ModifyHeader then begin
            Modify;
            Commit;
          end;

          CalcInvDiscount(SalesHeader);
          ReleaseSalesDocument(SalesHeader);

          if Ship or Receive then
            ArchiveUnpostedOrder(SalesHeader);

          CheckICPartnerBlocked(SalesHeader);
          SendICDocument(SalesHeader,ModifyHeader);
          UpdateHandledICInboxTransaction(SalesHeader);

          LockTables;

          SourceCodeSetup.Get;
          SrcCode := SourceCodeSetup.Sales;

          InsertPostedHeaders(SalesHeader);

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

    local procedure PostSalesLine(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";var EverythingInvoiced: Boolean;var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;var TempVATAmountLine: Record "VAT Amount Line" temporary;var TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;var TempItemLedgEntryNotInvoiced: Record "Item Ledger Entry" temporary;HasATOShippedNotInvoiced: Boolean;var TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary;var ICGenJnlLineNo: Integer;var TempServiceItem2: Record "Service Item" temporary;var TempServiceItemComp2: Record "Service Item Component" temporary)
    var
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        TempPostedATOLink: Record "Posted Assemble-to-Order Link" temporary;
        InvoicePostBuffer: Record "Invoice Post. Buffer";
        CostBaseAmount: Decimal;
    begin
        with SalesLine do begin
          if Type = Type::Item then
            CostBaseAmount := "Line Amount";
          if "Qty. per Unit of Measure" = 0 then
            "Qty. per Unit of Measure" := 1;

          TestSalesLine(SalesHeader,SalesLine);

          TempPostedATOLink.Reset;
          TempPostedATOLink.DeleteAll;
          if SalesHeader.Ship then
            PostATO(SalesHeader,SalesLine,TempPostedATOLink);

          UpdateSalesLineBeforePost(SalesHeader,SalesLine);

          if "Qty. to Invoice" + "Quantity Invoiced" <> Quantity then
            EverythingInvoiced := false;

          if Quantity = 0 then
            TestField(Amount,0)
          else begin
            TestField("No.");
            TestField(Type);
            if GLSetup."VAT in Use" then begin
              TestField("Gen. Bus. Posting Group");
              TestField("Gen. Prod. Posting Group");
            end;
            DivideAmount(SalesHeader,SalesLine,1,"Qty. to Invoice",TempVATAmountLine,TempVATAmountLineRemainder);
          end;

          if "Prepayment Line" and SalesHeader."Prepmt. Include Tax" then begin
            Amount := Amount + ("VAT Base Amount" * "VAT %" / 100);
            "Amount Including VAT" := Amount;
          end;

          CheckItemReservDisruption(SalesLine);
          RoundAmount(SalesHeader,SalesLine,"Qty. to Invoice");

          if not IsCreditDocType then begin
            ReverseAmount(SalesLine);
            ReverseAmount(SalesLineACY);
            if TaxOption = Taxoption::SalesTax then
              if TempSalesLineForSalesTax.Get("Document Type","Document No.","Line No.") then begin
                ReverseAmount(TempSalesLineForSalesTax);
                TempSalesLineForSalesTax.Modify;
              end;
          end;

          RemQtyToBeInvoiced := "Qty. to Invoice";
          RemQtyToBeInvoicedBase := "Qty. to Invoice (Base)";

          PostItemTrackingLine(SalesHeader,SalesLine,TempItemLedgEntryNotInvoiced,HasATOShippedNotInvoiced);

          case Type of
            Type::"G/L Account":
              PostGLAccICLine(SalesHeader,SalesLine,ICGenJnlLineNo);
            Type::Item:
              PostItemLine(SalesHeader,SalesLine,TempDropShptPostBuffer,TempPostedATOLink);
            Type::Resource:
              PostResJnlLine(SalesHeader,SalesLine,JobTaskSalesLine);
            Type::"Charge (Item)":
              PostItemChargeLine(SalesHeader,SalesLine);
          end;

          if (Type >= Type::"G/L Account") and ("Qty. to Invoice" <> 0) then begin
            AdjustPrepmtAmountLCY(SalesHeader,SalesLine);
            FillInvoicePostingBuffer(SalesHeader,SalesLine,SalesLineACY,TempInvoicePostBuffer,InvoicePostBuffer);
            InsertPrepmtAdjInvPostingBuf(SalesHeader,SalesLine,TempInvoicePostBuffer,InvoicePostBuffer);
          end;

          if not ("Document Type" in ["document type"::Invoice,"document type"::"Credit Memo"]) then
            TestField("Job No.",'');

          if (SalesShptHeader."No." <> '') and ("Shipment No." = '') and
             not RoundingLineInserted and not "Prepayment Line"
          then
            InsertShipmentLine(SalesHeader,SalesShptHeader,SalesLine,CostBaseAmount,TempServiceItem2,TempServiceItemComp2);

          if (ReturnRcptHeader."No." <> '') and ("Return Receipt No." = '') and
             not RoundingLineInserted
          then
            InsertReturnReceiptLine(ReturnRcptHeader,SalesLine,CostBaseAmount);

          if SalesHeader.Invoice then
            if SalesHeader."Document Type" in [SalesHeader."document type"::Order,SalesHeader."document type"::Invoice] then begin
              SalesInvLine.InitFromSalesLine(SalesInvHeader,xSalesLine);
              ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,SalesInvLine.RowID1);
              SalesInvLine.Insert(true);
              CreatePostedDeferralScheduleFromSalesDoc(xSalesLine,SalesInvLine.GetDocumentType,
                SalesInvHeader."No.",SalesInvLine."Line No.",SalesInvHeader."Posting Date");
            end else begin
              SalesCrMemoLine.InitFromSalesLine(SalesCrMemoHeader,xSalesLine);
              ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,SalesCrMemoLine.RowID1);
              SalesCrMemoLine.Insert(true);
              CreatePostedDeferralScheduleFromSalesDoc(xSalesLine,SalesCrMemoLine.GetDocumentType,
                SalesCrMemoHeader."No.",SalesCrMemoLine."Line No.",SalesCrMemoHeader."Posting Date");
            end;
        end;
    end;

    local procedure PostGLAndCustomer(SalesHeader: Record "Sales Header";var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;var CustLedgEntry: Record "Cust. Ledger Entry";LineCount: Integer)
    begin
        with SalesHeader do begin
          // Post sales and VAT to G/L entries from posting buffer
          PostInvoicePostBuffer(SalesHeader,TempInvoicePostBuffer);

          if TaxOption = Taxoption::SalesTax then
            if "Tax Area Code" <> '' then begin
              PostSalesTaxToGL(SalesHeader,LineCount);
              if Invoice then
                TaxAmountDifference.ClearDocDifference(TaxAmountDifference."document product area"::Sales,"Document Type","No.");
            end;

          // Post customer entry
          if GuiAllowed then
            Window.Update(4,1);
          PostCustomerEntry(
            SalesHeader,TotalSalesLine,TotalSalesLineLCY,GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);

          UpdateSalesHeader(CustLedgEntry);

          // Balancing account
          if "Bal. Account No." <> '' then begin
            if GuiAllowed then
              Window.Update(5,1);
            PostBalancingEntry(
              SalesHeader,TotalSalesLine,TotalSalesLineLCY,GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);
          end;
        end;
    end;

    local procedure PostGLAccICLine(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";var ICGenJnlLineNo: Integer)
    var
        GLAcc: Record "G/L Account";
    begin
        if (SalesLine."No." <> '') and not SalesLine."System-Created Entry" then begin
          GLAcc.Get(SalesLine."No.");
          GLAcc.TestField("Direct Posting",true);
          if (SalesLine."IC Partner Code" <> '') and SalesHeader.Invoice then
            InsertICGenJnlLine(SalesHeader,xSalesLine,ICGenJnlLineNo);
        end;
    end;

    local procedure PostItemLine(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";var TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary;var TempPostedATOLink: Record "Posted Assemble-to-Order Link" temporary)
    var
        DummyTrackingSpecification: Record "Tracking Specification";
    begin
        with SalesHeader do begin
          if (SalesLine."Qty. to Ship" <> 0) and (SalesLine."Purch. Order Line No." <> 0) then begin
            TempDropShptPostBuffer."Order No." := SalesLine."Purchase Order No.";
            TempDropShptPostBuffer."Order Line No." := SalesLine."Purch. Order Line No.";
            TempDropShptPostBuffer.Quantity := -SalesLine."Qty. to Ship";
            TempDropShptPostBuffer."Quantity (Base)" := -SalesLine."Qty. to Ship (Base)";
            TempDropShptPostBuffer."Item Shpt. Entry No." :=
              PostAssocItemJnlLine(SalesHeader,SalesLine,TempDropShptPostBuffer.Quantity,TempDropShptPostBuffer."Quantity (Base)");
            TempDropShptPostBuffer.Insert;
            SalesLine."Appl.-to Item Entry" := TempDropShptPostBuffer."Item Shpt. Entry No.";
          end;

          Clear(TempPostedATOLink);
          TempPostedATOLink.SetRange("Order No.",SalesLine."Document No.");
          TempPostedATOLink.SetRange("Order Line No.",SalesLine."Line No.");
          if TempPostedATOLink.FindFirst then
            PostATOAssocItemJnlLine(SalesHeader,SalesLine,TempPostedATOLink,RemQtyToBeInvoiced,RemQtyToBeInvoicedBase);

          if RemQtyToBeInvoiced <> 0 then
            ItemLedgShptEntryNo :=
              PostItemJnlLine(
                SalesHeader,SalesLine,
                RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
                RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
                0,'',DummyTrackingSpecification,false);

          if SalesLine.IsCreditDocType then begin
            if Abs(SalesLine."Return Qty. to Receive") > Abs(RemQtyToBeInvoiced) then
              ItemLedgShptEntryNo :=
                PostItemJnlLine(
                  SalesHeader,SalesLine,
                  SalesLine."Return Qty. to Receive" - RemQtyToBeInvoiced,
                  SalesLine."Return Qty. to Receive (Base)" - RemQtyToBeInvoicedBase,
                  0,0,0,'',DummyTrackingSpecification,false);
          end else begin
            if Abs(SalesLine."Qty. to Ship") > Abs(RemQtyToBeInvoiced) + Abs(TempPostedATOLink."Assembled Quantity") then
              ItemLedgShptEntryNo :=
                PostItemJnlLine(
                  SalesHeader,SalesLine,
                  SalesLine."Qty. to Ship" - TempPostedATOLink."Assembled Quantity" - RemQtyToBeInvoiced,
                  SalesLine."Qty. to Ship (Base)" - TempPostedATOLink."Assembled Quantity (Base)" - RemQtyToBeInvoicedBase,
                  0,0,0,'',DummyTrackingSpecification,false);
          end;
        end;
    end;

    local procedure PostItemChargeLine(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line")
    var
        SalesLineBackup: Record "Sales Line";
    begin
        if not (SalesHeader.Invoice and (SalesLine."Qty. to Invoice" <> 0)) then
          exit;

        ItemJnlRollRndg := true;
        SalesLineBackup.Copy(SalesLine);
        if FindTempItemChargeAssgntSales(SalesLineBackup."Line No.") then
          repeat
            case TempItemChargeAssgntSales."Applies-to Doc. Type" of
              TempItemChargeAssgntSales."applies-to doc. type"::Shipment:
                begin
                  PostItemChargePerShpt(SalesHeader,SalesLineBackup);
                  TempItemChargeAssgntSales.Mark(true);
                end;
              TempItemChargeAssgntSales."applies-to doc. type"::"Return Receipt":
                begin
                  PostItemChargePerRetRcpt(SalesHeader,SalesLineBackup);
                  TempItemChargeAssgntSales.Mark(true);
                end;
              TempItemChargeAssgntSales."applies-to doc. type"::Order,
              TempItemChargeAssgntSales."applies-to doc. type"::Invoice,
              TempItemChargeAssgntSales."applies-to doc. type"::"Return Order",
              TempItemChargeAssgntSales."applies-to doc. type"::"Credit Memo":
                CheckItemCharge(TempItemChargeAssgntSales);
            end;
          until TempItemChargeAssgntSales.Next = 0;
    end;

    local procedure PostItemTrackingLine(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";var TempItemLedgEntryNotInvoiced: Record "Item Ledger Entry" temporary;HasATOShippedNotInvoiced: Boolean)
    var
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        TrackingSpecificationExists: Boolean;
    begin
        if SalesLine."Prepayment Line" then
          exit;

        if SalesHeader.Invoice then
          if SalesLine."Qty. to Invoice" = 0 then
            TrackingSpecificationExists := false
          else
            TrackingSpecificationExists :=
              ReserveSalesLine.RetrieveInvoiceSpecification(SalesLine,TempTrackingSpecification);

        PostItemTracking(
          SalesHeader,SalesLine,TrackingSpecificationExists,TempTrackingSpecification,
          TempItemLedgEntryNotInvoiced,HasATOShippedNotInvoiced);

        if TrackingSpecificationExists then
          SaveInvoiceSpecification(TempTrackingSpecification);
    end;

    local procedure PostItemJnlLine(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";QtyToBeShipped: Decimal;QtyToBeShippedBase: Decimal;QtyToBeInvoiced: Decimal;QtyToBeInvoicedBase: Decimal;ItemLedgShptEntryNo: Integer;ItemChargeNo: Code[20];TrackingSpecification: Record "Tracking Specification";IsATO: Boolean): Integer
    var
        ItemJnlLine: Record "Item Journal Line";
        TempWhseJnlLine: Record "Warehouse Journal Line" temporary;
        TempWhseTrackingSpecification: Record "Tracking Specification" temporary;
        OriginalItemJnlLine: Record "Item Journal Line";
        CurrExchRate: Record "Currency Exchange Rate";
        PostWhseJnlLine: Boolean;
        CheckApplFromItemEntry: Boolean;
    begin
        if not ItemJnlRollRndg then begin
          RemAmt := 0;
          RemDiscAmt := 0;
        end;

        with ItemJnlLine do begin
          Init;
          CopyFromSalesHeader(SalesHeader);
          CopyFromSalesLine(SalesLine);
          "Country/Region Code" := GetCountryCode(SalesLine,SalesHeader);

          "Serial No." := TrackingSpecification."Serial No.";
          "Lot No." := TrackingSpecification."Lot No.";
          "Item Shpt. Entry No." := ItemLedgShptEntryNo;

          Quantity := -QtyToBeShipped;
          "Quantity (Base)" := -QtyToBeShippedBase;
          "Invoiced Quantity" := -QtyToBeInvoiced;
          "Invoiced Qty. (Base)" := -QtyToBeInvoicedBase;

          if QtyToBeShipped = 0 then
            if SalesLine.IsCreditDocType then
              CopyDocumentFields(
                "document type"::"Sales Credit Memo",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,SalesHeader."Posting No. Series")
            else
              CopyDocumentFields(
                "document type"::"Sales Invoice",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,SalesHeader."Posting No. Series")
          else begin
            if SalesLine.IsCreditDocType then
              CopyDocumentFields(
                "document type"::"Sales Return Receipt",
                ReturnRcptHeader."No.",ReturnRcptHeader."External Document No.",SrcCode,ReturnRcptHeader."No. Series")
            else
              CopyDocumentFields(
                "document type"::"Sales Shipment",SalesShptHeader."No.",SalesShptHeader."External Document No.",SrcCode,
                SalesShptHeader."No. Series");
            if QtyToBeInvoiced <> 0 then begin
              if "Document No." = '' then
                if SalesLine."Document Type" = SalesLine."document type"::"Credit Memo" then
                  CopyDocumentFields(
                    "document type"::"Sales Credit Memo",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,SalesHeader."Posting No. Series")
                else
                  CopyDocumentFields(
                    "document type"::"Sales Invoice",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,SalesHeader."Posting No. Series");
              "Posting No. Series" := SalesHeader."Posting No. Series";
            end;
          end;

          if QtyToBeInvoiced <> 0 then
            "Invoice No." := GenJnlLineDocNo;

          "Assemble to Order" := IsATO;
          if "Assemble to Order" then
            "Applies-to Entry" := SalesLine.FindOpenATOEntry('','')
          else
            "Applies-to Entry" := SalesLine."Appl.-to Item Entry";

          if ItemChargeNo <> '' then begin
            "Item Charge No." := ItemChargeNo;
            SalesLine."Qty. to Invoice" := QtyToBeInvoiced;
          end else
            "Applies-from Entry" := SalesLine."Appl.-from Item Entry";

          if QtyToBeInvoiced <> 0 then begin
            Amount := -(SalesLine.Amount * (QtyToBeInvoiced / SalesLine."Qty. to Invoice") - RemAmt);
            if SalesHeader."Prices Including VAT" then
              "Discount Amount" :=
                -((SalesLine."Line Discount Amount" + SalesLine."Inv. Discount Amount") /
                  (1 + SalesLine."VAT %" / 100) * (QtyToBeInvoiced / SalesLine."Qty. to Invoice") - RemDiscAmt)
            else
              "Discount Amount" :=
                -((SalesLine."Line Discount Amount" + SalesLine."Inv. Discount Amount") *
                  (QtyToBeInvoiced / SalesLine."Qty. to Invoice") - RemDiscAmt);
            RemAmt := Amount - ROUND(Amount);
            RemDiscAmt := "Discount Amount" - ROUND("Discount Amount");
            Amount := ROUND(Amount);
            "Discount Amount" := ROUND("Discount Amount");
          end else begin
            if SalesHeader."Prices Including VAT" then
              Amount :=
                -((QtyToBeShipped * SalesLine."Unit Price" * (1 - SalesLine."Line Discount %" / 100) /
                   (1 + SalesLine."VAT %" / 100)) - RemAmt)
            else
              Amount :=
                -((QtyToBeShipped * SalesLine."Unit Price" * (1 - SalesLine."Line Discount %" / 100)) - RemAmt);
            RemAmt := Amount - ROUND(Amount);
            if SalesHeader."Currency Code" <> '' then
              Amount :=
                ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    SalesHeader."Posting Date",SalesHeader."Currency Code",
                    Amount,SalesHeader."Currency Factor"))
            else
              Amount := ROUND(Amount);
          end;

          if not JobContractLine then begin
            if SalesSetup."Exact Cost Reversing Mandatory" and (SalesLine.Type = SalesLine.Type::Item) then
              if SalesLine.IsCreditDocType then
                CheckApplFromItemEntry := SalesLine.Quantity > 0
              else
                CheckApplFromItemEntry := SalesLine.Quantity < 0;

            if (SalesLine."Location Code" <> '') and (SalesLine.Type = SalesLine.Type::Item) and (Quantity <> 0) then
              if ShouldPostWhseJnlLine(SalesLine) then begin
                CreateWhseJnlLine(ItemJnlLine,SalesLine,TempWhseJnlLine);
                PostWhseJnlLine := true;
              end;

            if QtyToBeShippedBase <> 0 then begin
              if SalesLine.IsCreditDocType then
                ReserveSalesLine.TransferSalesLineToItemJnlLine(SalesLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,false)
              else
                TransferReservToItemJnlLine(
                  SalesLine,ItemJnlLine,-QtyToBeShippedBase,TempTrackingSpecification,CheckApplFromItemEntry);

              if CheckApplFromItemEntry and (not SalesLine.IsServiceItem) then
                SalesLine.TestField("Appl.-from Item Entry");
            end;

            OriginalItemJnlLine := ItemJnlLine;
            ItemJnlPostLine.RunWithCheck(ItemJnlLine);

            if IsATO then
              PostItemJnlLineTracking(
                SalesLine,TempWhseTrackingSpecification,PostWhseJnlLine,QtyToBeInvoiced,TempATOTrackingSpecification)
            else
              PostItemJnlLineTracking(SalesLine,TempWhseTrackingSpecification,PostWhseJnlLine,QtyToBeInvoiced,TempHandlingSpecification);
            PostItemJnlLineWhseLine(TempWhseJnlLine,TempWhseTrackingSpecification);

            if (SalesLine.Type = SalesLine.Type::Item) and SalesHeader.Invoice then
              PostItemJnlLineItemCharges(SalesHeader,SalesLine,OriginalItemJnlLine,"Item Shpt. Entry No.");
          end;
          exit("Item Shpt. Entry No.");
        end;
    end;

    local procedure PostItemJnlLineItemCharges(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";var OriginalItemJnlLine: Record "Item Journal Line";ItemShptEntryNo: Integer)
    var
        ItemChargeSalesLine: Record "Sales Line";
    begin
        with SalesLine do begin
          ClearItemChargeAssgntFilter;
          TempItemChargeAssgntSales.SetCurrentkey(
            "Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
          TempItemChargeAssgntSales.SetRange("Applies-to Doc. Type","Document Type");
          TempItemChargeAssgntSales.SetRange("Applies-to Doc. No.","Document No.");
          TempItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.","Line No.");
          if TempItemChargeAssgntSales.FindSet then
            repeat
              TestField("Allow Item Charge Assignment");
              GetItemChargeLine(SalesHeader,ItemChargeSalesLine);
              ItemChargeSalesLine.CalcFields("Qty. Assigned");
              if (ItemChargeSalesLine."Qty. to Invoice" <> 0) or
                 (Abs(ItemChargeSalesLine."Qty. Assigned") < Abs(ItemChargeSalesLine."Quantity Invoiced"))
              then begin
                OriginalItemJnlLine."Item Shpt. Entry No." := ItemShptEntryNo;
                PostItemChargePerOrder(SalesHeader,SalesLine,OriginalItemJnlLine,ItemChargeSalesLine);
                TempItemChargeAssgntSales.Mark(true);
              end;
            until TempItemChargeAssgntSales.Next = 0;
        end;
    end;

    local procedure PostItemJnlLineTracking(SalesLine: Record "Sales Line";var TempWhseTrackingSpecification: Record "Tracking Specification" temporary;PostWhseJnlLine: Boolean;QtyToBeInvoiced: Decimal;var TempTrackingSpec: Record "Tracking Specification" temporary)
    begin
        if ItemJnlPostLine.CollectTrackingSpecification(TempTrackingSpec) then
          if TempTrackingSpec.FindSet then
            repeat
              TempTrackingSpecification := TempTrackingSpec;
              TempTrackingSpecification.SetSourceFromSalesLine(SalesLine);
              if TempTrackingSpecification.Insert then;
              if QtyToBeInvoiced <> 0 then begin
                TempTrackingSpecificationInv := TempTrackingSpecification;
                if TempTrackingSpecificationInv.Insert then;
              end;
              if PostWhseJnlLine then begin
                TempWhseTrackingSpecification := TempTrackingSpecification;
                if TempWhseTrackingSpecification.Insert then;
              end;
            until TempTrackingSpec.Next = 0;
    end;

    local procedure PostItemJnlLineWhseLine(var TempWhseJnlLine: Record "Warehouse Journal Line" temporary;var TempWhseTrackingSpecification: Record "Tracking Specification" temporary)
    var
        TempWhseJnlLine2: Record "Warehouse Journal Line" temporary;
    begin
        ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine,TempWhseJnlLine2,TempWhseTrackingSpecification,false);
        if TempWhseJnlLine2.FindSet then
          repeat
            WhseJnlPostLine.Run(TempWhseJnlLine2);
          until TempWhseJnlLine2.Next = 0;
        TempWhseTrackingSpecification.DeleteAll;
    end;

    local procedure ShouldPostWhseJnlLine(SalesLine: Record "Sales Line"): Boolean
    begin
        with SalesLine do begin
          GetLocation("Location Code");
          if (("Document Type" in ["document type"::Invoice,"document type"::"Credit Memo"]) and
              Location."Directed Put-away and Pick") or
             (Location."Bin Mandatory" and not (WhseShip or WhseReceive or InvtPickPutaway or "Drop Shipment"))
          then
            exit(true);
        end;
        exit(false);
    end;

    local procedure PostItemChargePerOrder(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";ItemJnlLine2: Record "Item Journal Line";ItemChargeSalesLine: Record "Sales Line")
    var
        NonDistrItemJnlLine: Record "Item Journal Line";
        CurrExchRate: Record "Currency Exchange Rate";
        QtyToInvoice: Decimal;
        Factor: Decimal;
        OriginalAmt: Decimal;
        OriginalDiscountAmt: Decimal;
        OriginalQty: Decimal;
        SignFactor: Integer;
        TotalChargeAmt2: Decimal;
        TotalChargeAmtLCY2: Decimal;
    begin
        with TempItemChargeAssgntSales do begin
          SalesLine.TestField("Job No.",'');
          SalesLine.TestField("Allow Item Charge Assignment",true);
          ItemJnlLine2."Document No." := GenJnlLineDocNo;
          ItemJnlLine2."External Document No." := GenJnlLineExtDocNo;
          ItemJnlLine2."Item Charge No." := "Item Charge No.";
          ItemJnlLine2.Description := ItemChargeSalesLine.Description;
          ItemJnlLine2."Unit of Measure Code" := '';
          ItemJnlLine2."Qty. per Unit of Measure" := 1;
          ItemJnlLine2."Applies-from Entry" := 0;
          if "Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"] then
            QtyToInvoice :=
              CalcQtyToInvoice(SalesLine."Return Qty. to Receive (Base)",SalesLine."Qty. to Invoice (Base)")
          else
            QtyToInvoice :=
              CalcQtyToInvoice(SalesLine."Qty. to Ship (Base)",SalesLine."Qty. to Invoice (Base)");
          if ItemJnlLine2."Invoiced Quantity" = 0 then begin
            ItemJnlLine2."Invoiced Quantity" := ItemJnlLine2.Quantity;
            ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
          end;
          ItemJnlLine2."Document Line No." := ItemChargeSalesLine."Line No.";

          ItemJnlLine2.Amount := "Amount to Assign" * ItemJnlLine2."Invoiced Qty. (Base)" / QtyToInvoice;
          if "Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"] then
            ItemJnlLine2.Amount := -ItemJnlLine2.Amount;
          ItemJnlLine2."Unit Cost (ACY)" :=
            ROUND(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
              Currency."Unit-Amount Rounding Precision");

          TotalChargeAmt2 := TotalChargeAmt2 + ItemJnlLine2.Amount;
          if SalesHeader."Currency Code" <> '' then
            ItemJnlLine2.Amount :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                UseDate,SalesHeader."Currency Code",TotalChargeAmt2 + TotalSalesLine.Amount,SalesHeader."Currency Factor") -
              TotalChargeAmtLCY2 - TotalSalesLineLCY.Amount
          else
            ItemJnlLine2.Amount := TotalChargeAmt2 - TotalChargeAmtLCY2;

          ItemJnlLine2.Amount := ROUND(ItemJnlLine2.Amount);
          TotalChargeAmtLCY2 := TotalChargeAmtLCY2 + ItemJnlLine2.Amount;
          ItemJnlLine2."Unit Cost" := ROUND(
              ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",GLSetup."Unit-Amount Rounding Precision");
          ItemJnlLine2."Applies-to Entry" := ItemJnlLine2."Item Shpt. Entry No.";

          if SalesHeader."Currency Code" <> '' then
            ItemJnlLine2."Discount Amount" := ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate,SalesHeader."Currency Code",
                  ItemChargeSalesLine."Inv. Discount Amount" * ItemJnlLine2."Invoiced Qty. (Base)" /
                  ItemChargeSalesLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
                  SalesHeader."Currency Factor"),GLSetup."Amount Rounding Precision")
          else
            ItemJnlLine2."Discount Amount" := ROUND(
                ItemChargeSalesLine."Inv. Discount Amount" * ItemJnlLine2."Invoiced Qty. (Base)" /
                ItemChargeSalesLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
                GLSetup."Amount Rounding Precision");

          if SalesLine.IsCreditDocType then
            ItemJnlLine2."Discount Amount" := -ItemJnlLine2."Discount Amount";
          ItemJnlLine2."Shortcut Dimension 1 Code" := ItemChargeSalesLine."Shortcut Dimension 1 Code";
          ItemJnlLine2."Shortcut Dimension 2 Code" := ItemChargeSalesLine."Shortcut Dimension 2 Code";
          ItemJnlLine2."Dimension Set ID" := ItemChargeSalesLine."Dimension Set ID";
          ItemJnlLine2."Gen. Prod. Posting Group" := ItemChargeSalesLine."Gen. Prod. Posting Group";
        end;

        with TempTrackingSpecificationInv do begin
          Reset;
          SetRange("Source Type",Database::"Sales Line");
          SetRange("Source ID",TempItemChargeAssgntSales."Applies-to Doc. No.");
          SetRange("Source Ref. No.",TempItemChargeAssgntSales."Applies-to Doc. Line No.");
          if IsEmpty then
            ItemJnlPostLine.RunWithCheck(ItemJnlLine2)
          else begin
            FindSet;
            NonDistrItemJnlLine := ItemJnlLine2;
            OriginalAmt := NonDistrItemJnlLine.Amount;
            OriginalDiscountAmt := NonDistrItemJnlLine."Discount Amount";
            OriginalQty := NonDistrItemJnlLine."Quantity (Base)";
            if ("Quantity (Base)" / OriginalQty) > 0 then
              SignFactor := 1
            else
              SignFactor := -1;
            repeat
              Factor := "Quantity (Base)" / OriginalQty * SignFactor;
              if Abs("Quantity (Base)") < Abs(NonDistrItemJnlLine."Quantity (Base)") then begin
                ItemJnlLine2."Quantity (Base)" := -"Quantity (Base)";
                ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
                ItemJnlLine2.Amount :=
                  ROUND(OriginalAmt * Factor,GLSetup."Amount Rounding Precision");
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
                NonDistrItemJnlLine."Quantity (Base)" -= ItemJnlLine2."Quantity (Base)";
                NonDistrItemJnlLine.Amount -= ItemJnlLine2.Amount;
                NonDistrItemJnlLine."Discount Amount" -= ItemJnlLine2."Discount Amount";
              end else begin // the last time
                NonDistrItemJnlLine."Quantity (Base)" := -"Quantity (Base)";
                NonDistrItemJnlLine."Invoiced Qty. (Base)" := -"Quantity (Base)";
                NonDistrItemJnlLine."Unit Cost" :=
                  ROUND(NonDistrItemJnlLine.Amount / NonDistrItemJnlLine."Invoiced Qty. (Base)",
                    GLSetup."Unit-Amount Rounding Precision");
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

    local procedure PostItemChargePerShpt(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line")
    var
        SalesShptLine: Record "Sales Shipment Line";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        DistributeCharge: Boolean;
    begin
        if not SalesShptLine.Get(
             TempItemChargeAssgntSales."Applies-to Doc. No.",TempItemChargeAssgntSales."Applies-to Doc. Line No.")
        then
          Error(ShipmentLinesDeletedErr);
        SalesShptLine.TestField("Job No.",'');

        if SalesShptLine."Item Shpt. Entry No." <> 0 then
          DistributeCharge :=
            CostCalcMgt.SplitItemLedgerEntriesExist(
              TempItemLedgEntry,-SalesShptLine."Quantity (Base)",SalesShptLine."Item Shpt. Entry No.")
        else begin
          DistributeCharge := true;
          if not ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
               Database::"Sales Shipment Line",0,SalesShptLine."Document No.",
               '',0,SalesShptLine."Line No.",-SalesShptLine."Quantity (Base)")
          then
            Error(RelatedItemLedgEntriesNotFoundErr);
        end;

        if DistributeCharge then
          PostDistributeItemCharge(
            SalesHeader,SalesLine,TempItemLedgEntry,SalesShptLine."Quantity (Base)",
            TempItemChargeAssgntSales."Qty. to Assign",TempItemChargeAssgntSales."Amount to Assign")
        else
          PostItemCharge(SalesHeader,SalesLine,
            SalesShptLine."Item Shpt. Entry No.",SalesShptLine."Quantity (Base)",
            TempItemChargeAssgntSales."Amount to Assign",
            TempItemChargeAssgntSales."Qty. to Assign");
    end;

    local procedure PostItemChargePerRetRcpt(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line")
    var
        ReturnRcptLine: Record "Return Receipt Line";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        DistributeCharge: Boolean;
    begin
        if not ReturnRcptLine.Get(
             TempItemChargeAssgntSales."Applies-to Doc. No.",TempItemChargeAssgntSales."Applies-to Doc. Line No.")
        then
          Error(ShipmentLinesDeletedErr);
        ReturnRcptLine.TestField("Job No.",'');

        if ReturnRcptLine."Item Rcpt. Entry No." <> 0 then
          DistributeCharge :=
            CostCalcMgt.SplitItemLedgerEntriesExist(
              TempItemLedgEntry,ReturnRcptLine."Quantity (Base)",ReturnRcptLine."Item Rcpt. Entry No.")
        else begin
          DistributeCharge := true;
          if not ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
               Database::"Return Receipt Line",0,ReturnRcptLine."Document No.",
               '',0,ReturnRcptLine."Line No.",ReturnRcptLine."Quantity (Base)")
          then
            Error(RelatedItemLedgEntriesNotFoundErr);
        end;

        if DistributeCharge then
          PostDistributeItemCharge(
            SalesHeader,SalesLine,TempItemLedgEntry,ReturnRcptLine."Quantity (Base)",
            TempItemChargeAssgntSales."Qty. to Assign",TempItemChargeAssgntSales."Amount to Assign")
        else
          PostItemCharge(SalesHeader,SalesLine,
            ReturnRcptLine."Item Rcpt. Entry No.",ReturnRcptLine."Quantity (Base)",
            TempItemChargeAssgntSales."Amount to Assign",
            TempItemChargeAssgntSales."Qty. to Assign")
    end;

    local procedure PostDistributeItemCharge(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";var TempItemLedgEntry: Record "Item Ledger Entry" temporary;NonDistrQuantity: Decimal;NonDistrQtyToAssign: Decimal;NonDistrAmountToAssign: Decimal)
    var
        Factor: Decimal;
        QtyToAssign: Decimal;
        AmountToAssign: Decimal;
    begin
        if TempItemLedgEntry.FindSet then
          repeat
            Factor := Abs(TempItemLedgEntry.Quantity) / NonDistrQuantity;
            QtyToAssign := NonDistrQtyToAssign * Factor;
            AmountToAssign := ROUND(NonDistrAmountToAssign * Factor,GLSetup."Amount Rounding Precision");
            if Factor < 1 then begin
              PostItemCharge(SalesHeader,SalesLine,
                TempItemLedgEntry."Entry No.",Abs(TempItemLedgEntry.Quantity),
                AmountToAssign,QtyToAssign);
              NonDistrQuantity := NonDistrQuantity - Abs(TempItemLedgEntry.Quantity);
              NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
              NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
            end else // the last time
              PostItemCharge(SalesHeader,SalesLine,
                TempItemLedgEntry."Entry No.",Abs(TempItemLedgEntry.Quantity),
                NonDistrAmountToAssign,NonDistrQtyToAssign);
          until TempItemLedgEntry.Next = 0
        else
          Error(RelatedItemLedgEntriesNotFoundErr);
    end;

    local procedure PostAssocItemJnlLine(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";QtyToBeShipped: Decimal;QtyToBeShippedBase: Decimal): Integer
    var
        ItemJnlLine: Record "Item Journal Line";
        TempHandlingSpecification2: Record "Tracking Specification" temporary;
        ItemEntryRelation: Record "Item Entry Relation";
        PurchOrderHeader: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";
    begin
        PurchOrderHeader.Get(
          PurchOrderHeader."document type"::Order,SalesLine."Purchase Order No.");
        PurchOrderLine.Get(
          PurchOrderLine."document type"::Order,SalesLine."Purchase Order No.",SalesLine."Purch. Order Line No.");

        with ItemJnlLine do begin
          Init;
          "Entry Type" := "entry type"::Purchase;
          CopyDocumentFields(
            "document type"::"Purchase Receipt",PurchOrderHeader."Receiving No.",PurchOrderHeader."No.",SrcCode,
            PurchOrderHeader."Posting No. Series");

          CopyFromPurchHeader(PurchOrderHeader);
          "Posting Date" := SalesHeader."Posting Date";
          "Document Date" := SalesHeader."Document Date";
          CopyFromPurchLine(PurchOrderLine);

          Quantity := QtyToBeShipped;
          "Quantity (Base)" := QtyToBeShippedBase;
          "Invoiced Quantity" := 0;
          "Invoiced Qty. (Base)" := 0;
          "Source Currency Code" := SalesHeader."Currency Code";
          Amount := ROUND(PurchOrderLine.Amount * QtyToBeShipped / PurchOrderLine.Quantity);
          "Discount Amount" := PurchOrderLine."Line Discount Amount";

          "Applies-to Entry" := 0;
        end;

        if PurchOrderLine."Job No." = '' then begin
          TransferReservFromPurchLine(PurchOrderLine,ItemJnlLine,SalesLine,QtyToBeShippedBase);
          ItemJnlPostLine.RunWithCheck(ItemJnlLine);

          // Handle Item Tracking
          if ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification2) then begin
            if TempHandlingSpecification2.FindSet then
              repeat
                TempTrackingSpecification := TempHandlingSpecification2;
                TempTrackingSpecification.SetSourceFromPurchLine(PurchOrderLine);
                if TempTrackingSpecification.Insert then;
                ItemEntryRelation.Init;
                ItemEntryRelation."Item Entry No." := TempHandlingSpecification2."Entry No.";
                ItemEntryRelation."Serial No." := TempHandlingSpecification2."Serial No.";
                ItemEntryRelation."Lot No." := TempHandlingSpecification2."Lot No.";
                ItemEntryRelation."Source Type" := Database::"Purch. Rcpt. Line";
                ItemEntryRelation."Source ID" := PurchOrderHeader."Receiving No.";
                ItemEntryRelation."Source Ref. No." := PurchOrderLine."Line No.";
                ItemEntryRelation."Order No." := PurchOrderLine."Document No.";
                ItemEntryRelation."Order Line No." := PurchOrderLine."Line No.";
                ItemEntryRelation.Insert;
              until TempHandlingSpecification2.Next = 0;
            exit(0);
          end;
        end;

        exit(ItemJnlLine."Item Shpt. Entry No.");
    end;

    local procedure ReleaseSalesDocument(var SalesHeader: Record "Sales Header")
    var
        TempAsmHeader: Record "Assembly Header" temporary;
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        TempInvoice: Boolean;
        LinesWereModified: Boolean;
        TempShpt: Boolean;
        TempReturn: Boolean;
        SavedStatus: Option;
    begin
        with SalesHeader do begin
          if not (Status = Status::Open) or (Status = Status::"Pending Prepayment") then
            exit;

          TempInvoice := Invoice;
          TempShpt := Ship;
          TempReturn := Receive;
          SavedStatus := Status;
          GetOpenLinkedATOs(TempAsmHeader);
          LinesWereModified := ReleaseSalesDocument.ReleaseSalesHeader(SalesHeader,PreviewMode);
          if LinesWereModified then
            RefreshTempLines(SalesHeader);
          TestField(Status,Status::Released);
          Status := SavedStatus;
          Invoice := TempInvoice;
          Ship := TempShpt;
          Receive := TempReturn;
          ReopenAsmOrders(TempAsmHeader);
          if PreviewMode and ("Posting No." = '') then
            "Posting No." := '***';
          if not PreviewMode then begin
            Modify;
            Commit;
          end;
          Status := Status::Released;
        end;
    end;

    local procedure TestSalesLine(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line")
    var
        FA: Record "Fixed Asset";
        DeprBook: Record "Depreciation Book";
        DummyTrackingSpecification: Record "Tracking Specification";
    begin
        with SalesHeader do begin
          if SalesLine.Type = SalesLine.Type::Item then
            DummyTrackingSpecification.CheckItemTrackingQuantity(
              Database::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.",
              SalesLine."Qty. to Ship (Base)",SalesLine."Qty. to Invoice (Base)",Ship,Invoice);

          case "Document Type" of
            "document type"::Order:
              SalesLine.TestField("Return Qty. to Receive",0);
            "document type"::Invoice:
              begin
                if SalesLine."Shipment No." = '' then
                  SalesLine.TestField("Qty. to Ship",SalesLine.Quantity);
                SalesLine.TestField("Return Qty. to Receive",0);
                SalesLine.TestField("Qty. to Invoice",SalesLine.Quantity);
              end;
            "document type"::"Return Order":
              SalesLine.TestField("Qty. to Ship",0);
            "document type"::"Credit Memo":
              begin
                if SalesLine."Return Receipt No." = '' then
                  SalesLine.TestField("Return Qty. to Receive",SalesLine.Quantity);
                SalesLine.TestField("Qty. to Ship",0);
                SalesLine.TestField("Qty. to Invoice",SalesLine.Quantity);
              end;
          end;
          if SalesLine.Type = SalesLine.Type::"Charge (Item)" then begin
            SalesLine.TestField(Amount);
            SalesLine.TestField("Job No.",'');
            SalesLine.TestField("Job Contract Entry No.",0);
          end;
          if SalesLine.Type = SalesLine.Type::"Fixed Asset" then begin
            SalesLine.TestField("Job No.",'');
            SalesLine.TestField("Depreciation Book Code");
            DeprBook.Get(SalesLine."Depreciation Book Code");
            DeprBook.TestField("G/L Integration - Disposal",true);
            FA.Get(SalesLine."No.");
            FA.TestField("Budgeted Asset",false);
          end else begin
            SalesLine.TestField("Depreciation Book Code",'');
            SalesLine.TestField("Depr. until FA Posting Date",false);
            SalesLine.TestField("FA Posting Date",0D);
            SalesLine.TestField("Duplicate in Depreciation Book",'');
            SalesLine.TestField("Use Duplication List",false);
          end;
          if SalesLine."Drop Shipment" then begin
            if SalesLine.Type <> SalesLine.Type::Item then
              SalesLine.TestField("Drop Shipment",false);
            if (SalesLine."Qty. to Ship" <> 0) and (SalesLine."Purch. Order Line No." = 0) then
              Error(DropShipmentErr,SalesLine."Line No.");
          end;
          if not ("Document Type" in ["document type"::Invoice,"document type"::"Credit Memo"]) then
            SalesLine.TestField("Job No.",'');
        end;
    end;

    local procedure UpdatePostingNos(var SalesHeader: Record "Sales Header") ModifyHeader: Boolean
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        with SalesHeader do begin
          if "Posting No." = '***' then
            "Posting No." := '';

          if Ship and ("Shipping No." = '') then
            if ("Document Type" = "document type"::Order) or
               (("Document Type" = "document type"::Invoice) and SalesSetup."Shipment on Invoice")
            then begin
              TestField("Shipping No. Series");
              "Shipping No." := NoSeriesMgt.GetNextNo("Shipping No. Series","Posting Date",true);
              ModifyHeader := true;
            end;

          if Receive and ("Return Receipt No." = '') then
            if IsCreditDocType and SalesSetup."Return Receipt on Credit Memo" then begin
              TestField("Return Receipt No. Series");
              "Return Receipt No." := NoSeriesMgt.GetNextNo("Return Receipt No. Series","Posting Date",true);
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

    local procedure UpdateAssocOrder(var TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary)
    var
        PurchOrderHeader: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
    begin
        TempDropShptPostBuffer.Reset;
        if TempDropShptPostBuffer.IsEmpty then
          exit;
        Clear(PurchOrderHeader);
        TempDropShptPostBuffer.FindSet;
        repeat
          if PurchOrderHeader."No." <> TempDropShptPostBuffer."Order No." then begin
            PurchOrderHeader.Get(PurchOrderHeader."document type"::Order,TempDropShptPostBuffer."Order No.");
            PurchOrderHeader."Last Receiving No." := PurchOrderHeader."Receiving No.";
            PurchOrderHeader."Receiving No." := '';
            PurchOrderHeader.Modify;
            ReservePurchLine.UpdateItemTrackingAfterPosting(PurchOrderHeader);
          end;
          PurchOrderLine.Get(
            PurchOrderLine."document type"::Order,
            TempDropShptPostBuffer."Order No.",TempDropShptPostBuffer."Order Line No.");
          PurchOrderLine."Quantity Received" := PurchOrderLine."Quantity Received" + TempDropShptPostBuffer.Quantity;
          PurchOrderLine."Qty. Received (Base)" := PurchOrderLine."Qty. Received (Base)" + TempDropShptPostBuffer."Quantity (Base)";
          PurchOrderLine.InitOutstanding;
          PurchOrderLine.ClearQtyIfBlank;
          PurchOrderLine.InitQtyToReceive;
          PurchOrderLine.Modify;
        until TempDropShptPostBuffer.Next = 0;
        TempDropShptPostBuffer.DeleteAll;
    end;

    local procedure UpdateAssocLines(var SalesOrderLine: Record "Sales Line")
    var
        PurchOrderLine: Record "Purchase Line";
    begin
        PurchOrderLine.Get(
          PurchOrderLine."document type"::Order,
          SalesOrderLine."Purchase Order No.",SalesOrderLine."Purch. Order Line No.");
        PurchOrderLine."Sales Order No." := '';
        PurchOrderLine."Sales Order Line No." := 0;
        PurchOrderLine.Modify;
        SalesOrderLine."Purchase Order No." := '';
        SalesOrderLine."Purch. Order Line No." := 0;
    end;

    local procedure UpdateAssosOrderPostingNos(SalesHeader: Record "Sales Header") DropShipment: Boolean
    var
        TempSalesLine: Record "Sales Line" temporary;
        PurchOrderHeader: Record "Purchase Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
    begin
        with SalesHeader do begin
          ResetTempLines(TempSalesLine);
          TempSalesLine.SetFilter("Purch. Order Line No.",'<>0');
          if not TempSalesLine.IsEmpty then begin
            DropShipment := true;
            if Ship then begin
              TempSalesLine.FindSet;
              repeat
                if PurchOrderHeader."No." <> TempSalesLine."Purchase Order No." then begin
                  PurchOrderHeader.Get(PurchOrderHeader."document type"::Order,TempSalesLine."Purchase Order No.");
                  PurchOrderHeader.TestField("Pay-to Vendor No.");
                  PurchOrderHeader.Receive := true;
                  ReleasePurchaseDocument.ReleasePurchaseHeader(PurchOrderHeader,PreviewMode);
                  if PurchOrderHeader."Receiving No." = '' then begin
                    PurchOrderHeader.TestField("Receiving No. Series");
                    PurchOrderHeader."Receiving No." :=
                      NoSeriesMgt.GetNextNo(PurchOrderHeader."Receiving No. Series","Posting Date",true);
                    PurchOrderHeader.Modify;
                  end;
                end;
              until TempSalesLine.Next = 0;
            end;
          end;
          exit(DropShipment);
        end;
    end;

    local procedure UpdateAfterPosting(SalesHeader: Record "Sales Header")
    var
        TempSalesLine: Record "Sales Line" temporary;
    begin
        with TempSalesLine do begin
          ResetTempLines(TempSalesLine);
          SetFilter("Qty. to Assemble to Order",'<>0');
          if FindSet then
            repeat
              FinalizePostATO(TempSalesLine);
            until Next = 0;

          ResetTempLines(TempSalesLine);
          SetFilter("Blanket Order Line No.",'<>0');
          if FindSet then
            repeat
              UpdateBlanketOrderLine(TempSalesLine,SalesHeader.Ship,SalesHeader.Receive,SalesHeader.Invoice);
            until Next = 0;
        end;
    end;

    local procedure UpdateLastPostingNos(var SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do begin
          if Ship then begin
            "Last Shipping No." := "Shipping No.";
            "Shipping No." := '';
          end;
          if Invoice then begin
            "Last Posting No." := "Posting No.";
            "Posting No." := '';
          end;
          if Receive then begin
            "Last Return Receipt No." := "Return Receipt No.";
            "Return Receipt No." := '';
          end;
        end;
    end;

    local procedure UpdateSalesLineBeforePost(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line")
    begin
        with SalesLine do begin
          if not (SalesHeader.Ship or RoundingLineInserted) then begin
            "Qty. to Ship" := 0;
            "Qty. to Ship (Base)" := 0;
          end;
          if not (SalesHeader.Receive or RoundingLineInserted) then begin
            "Return Qty. to Receive" := 0;
            "Return Qty. to Receive (Base)" := 0;
          end;

          JobContractLine := false;
          if (Type = Type::Item) or (Type = Type::"G/L Account") or (Type = Type::" ") then
            if "Job Contract Entry No." > 0 then
              PostJobContractLine(SalesHeader,SalesLine);
          if Type = Type::Resource then
            JobTaskSalesLine := SalesLine;

          if (SalesHeader."Document Type" = SalesHeader."document type"::Invoice) and ("Shipment No." <> '') then begin
            "Quantity Shipped" := Quantity;
            "Qty. Shipped (Base)" := "Quantity (Base)";
            "Qty. to Ship" := 0;
            "Qty. to Ship (Base)" := 0;
          end;

          if (SalesHeader."Document Type" = SalesHeader."document type"::"Credit Memo") and ("Return Receipt No." <> '') then begin
            "Return Qty. Received" := Quantity;
            "Return Qty. Received (Base)" := "Quantity (Base)";
            "Return Qty. to Receive" := 0;
            "Return Qty. to Receive (Base)" := 0;
          end;

          if SalesHeader.Invoice then begin
            if Abs("Qty. to Invoice") > Abs(MaxQtyToInvoice) then
              InitQtyToInvoice;
          end else begin
            "Qty. to Invoice" := 0;
            "Qty. to Invoice (Base)" := 0;
          end;

          if (Type = Type::Item) and ("No." <> '') then begin
            GetItem(SalesLine);
            if (Item."Costing Method" = Item."costing method"::Standard) and not IsShipment then
              GetUnitCost;
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

    local procedure DeleteAfterPosting(var SalesHeader: Record "Sales Header")
    var
        SalesCommentLine: Record "Sales Comment Line";
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        WarehouseRequest: Record "Warehouse Request";
    begin
        with SalesHeader do begin
          if HasLinks then
            DeleteLinks;
          Delete;
          ReserveSalesLine.DeleteInvoiceSpecFromHeader(SalesHeader);
          DeleteATOLinks(SalesHeader);
          ResetTempLines(TempSalesLine);
          if TempSalesLine.FindFirst then
            repeat
              if TempSalesLine."Deferral Code" <> '' then
                DeferralUtilities.RemoveOrSetDeferralSchedule(
                  '',DeferralUtilities.GetSalesDeferralDocType,'','',
                  TempSalesLine."Document Type",
                  TempSalesLine."Document No.",
                  TempSalesLine."Line No.",0,0D,
                  TempSalesLine.Description,
                  '',
                  true);
              if TempSalesLine.HasLinks then
                TempSalesLine.DeleteLinks;
            until TempSalesLine.Next = 0;

          SalesLine.SetRange("Document Type","Document Type");
          SalesLine.SetRange("Document No.","No.");
          SalesLine.DeleteAll;

          DeleteItemChargeAssgnt(SalesHeader);
          SalesCommentLine.SetRange("Document Type","Document Type");
          SalesCommentLine.SetRange("No.","No.");
          if not SalesCommentLine.IsEmpty then
            SalesCommentLine.DeleteAll;
          WarehouseRequest.SetCurrentkey("Source Type","Source Subtype","Source No.");
          WarehouseRequest.SetRange("Source Type",Database::"Sales Line");
          WarehouseRequest.SetRange("Source Subtype","Document Type");
          WarehouseRequest.SetRange("Source No.","No.");
          if not WarehouseRequest.IsEmpty then
            WarehouseRequest.DeleteAll;
        end;
    end;

    local procedure FinalizePosting(var SalesHeader: Record "Sales Header";EverythingInvoiced: Boolean;var TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary)
    var
        TempSalesLine: Record "Sales Line" temporary;
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
        WhseSalesRelease: Codeunit "Whse.-Sales Release";
    begin
        with SalesHeader do begin
          if ("Document Type" in ["document type"::Order,"document type"::"Return Order"]) and
             (not EverythingInvoiced)
          then begin
            Modify;
            InsertTrackingSpecification(SalesHeader);
            PostUpdateOrderLine(SalesHeader);
            UpdateAssocOrder(TempDropShptPostBuffer);
            UpdateWhseDocuments;
            WhseSalesRelease.Release(SalesHeader);
            UpdateItemChargeAssgnt;
          end else begin
            case "Document Type" of
              "document type"::Invoice:
                begin
                  PostUpdateInvoiceLine(SalesHeader);
                  InsertTrackingSpecification(SalesHeader);
                end;
              "document type"::"Credit Memo":
                begin
                  PostUpdateReturnReceiptLine;
                  InsertTrackingSpecification(SalesHeader);
                end;
              else begin
                UpdateAssocOrder(TempDropShptPostBuffer);
                if DropShipOrder then
                  InsertTrackingSpecification(SalesHeader);

                ResetTempLines(TempSalesLine);
                TempSalesLine.SetFilter("Purch. Order Line No.",'<>0');
                if TempSalesLine.FindSet then
                  repeat
                    UpdateAssocLines(TempSalesLine);
                    TempSalesLine.Modify;
                  until TempSalesLine.Next = 0;

                ResetTempLines(TempSalesLine);
                TempSalesLine.SetFilter("Prepayment %",'<>0');
                if TempSalesLine.FindSet then
                  repeat
                    DecrementPrepmtAmtInvLCY(
                      SalesHeader,TempSalesLine,TempSalesLine."Prepmt. Amount Inv. (LCY)",TempSalesLine."Prepmt. VAT Amount Inv. (LCY)");
                    TempSalesLine.Modify;
                  until TempSalesLine.Next = 0;
              end;
            end;
            UpdateAfterPosting(SalesHeader);
            UpdateWhseDocuments;
            ApprovalsMgmt.DeleteApprovalEntry(SalesHeader);
            DeleteAfterPosting(SalesHeader);
          end;

          InsertValueEntryRelation;

          if SalesTaxCalculationOverridden then begin
            if "Document Type" in ["document type"::Order,"document type"::Invoice] then
              OnFinalizeInvoicePostingSalesTax(SalesHeader,SalesInvHeader)
            else
              OnFinalizeCreditmemoPostingSalesTax(SalesHeader,SalesCrMemoHeader);
          end;

          if not InvtPickPutaway then
            Commit;
          ClearPostBuffers;
          Window.Close;
          if Invoice and ("Bill-to IC Partner Code" <> '') then
            if "Document Type" in ["document type"::Order,"document type"::Invoice] then
              ICInboxOutboxMgt.CreateOutboxSalesInvTrans(SalesInvHeader)
            else
              ICInboxOutboxMgt.CreateOutboxSalesCrMemoTrans(SalesCrMemoHeader);

          if Invoice and (TaxOption = Taxoption::SalesTax) and UseExternalTaxEngine then
            if "Document Type" in ["document type"::Order,"document type"::Invoice] then
              SalesTaxCalculate.FinalizeExternalTaxCalcForDoc(Database::"Sales Invoice Header",SalesInvHeader."No.")
            else
              SalesTaxCalculate.FinalizeExternalTaxCalcForDoc(Database::"Sales Cr.Memo Header",SalesCrMemoHeader."No.");
        end;
    end;

    local procedure FillInvoicePostingBuffer(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";SalesLineACY: Record "Sales Line";var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;var InvoicePostBuffer: Record "Invoice Post. Buffer")
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
        SalesAccount: Code[20];
    begin
        GetGenPostingSetup(GenPostingSetup,SalesLine);

        InvoicePostBuffer.PrepareSales(SalesLine);

        TotalVAT := SalesLine."Amount Including VAT" - SalesLine.Amount;
        TotalVATACY := SalesLineACY."Amount Including VAT" - SalesLineACY.Amount;
        TotalAmount := SalesLine.Amount;
        TotalAmountACY := SalesLineACY.Amount;

        if SalesLine."Deferral Code" <> '' then
          GetAmountsForDeferral(SalesLine,AmtToDefer,AmtToDeferACY,DeferralAccount)
        else begin
          AmtToDefer := 0;
          AmtToDeferACY := 0;
          DeferralAccount := '';
        end;

        if SalesSetup."Discount Posting" in
           [SalesSetup."discount posting"::"Invoice Discounts",SalesSetup."discount posting"::"All Discounts"]
        then begin
          CalcInvoiceDiscountPosting(SalesHeader,SalesLine,SalesLineACY,InvoicePostBuffer);
          if (InvoicePostBuffer.Amount <> 0) or (InvoicePostBuffer."Amount (ACY)" <> 0) then begin
            GenPostingSetup.TestField("Sales Inv. Disc. Account");
            InvoicePostBuffer.SetAccount(
              GenPostingSetup."Sales Inv. Disc. Account",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
            if TaxOption = Taxoption::SalesTax then
              InvoicePostBuffer.ClearVAT;
            UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer,true);
          end;
        end;

        if SalesSetup."Discount Posting" in
           [SalesSetup."discount posting"::"Line Discounts",SalesSetup."discount posting"::"All Discounts"]
        then begin
          CalcLineDiscountPosting(SalesHeader,SalesLine,SalesLineACY,InvoicePostBuffer);
          if (InvoicePostBuffer.Amount <> 0) or (InvoicePostBuffer."Amount (ACY)" <> 0) then begin
            GenPostingSetup.TestField("Sales Line Disc. Account");
            InvoicePostBuffer.SetAccount(
              GenPostingSetup."Sales Line Disc. Account",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
            if TaxOption = Taxoption::SalesTax then
              InvoicePostBuffer.ClearVAT;
            UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer,true);
          end;
        end;

        // Don't adjust VAT Base Amounts if deferrals are adjusting total amount
        DeferralUtilities.AdjustTotalAmountForDeferrals(SalesLine."Deferral Code",
          AmtToDefer,AmtToDeferACY,TotalAmount,TotalAmountACY,TotalVATBase,TotalVATBaseACY);

        InvoicePostBuffer.SetAmounts(
          TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY,SalesLine."VAT Difference",TotalVATBase,TotalVATBaseACY);

        if (SalesLine.Type = SalesLine.Type::"G/L Account") or (SalesLine.Type = SalesLine.Type::"Fixed Asset") then begin
          SalesAccount := SalesLine."No.";
          InvoicePostBuffer.SetAccount(
            DefaultGLAccount(SalesLine."Deferral Code",AmtToDefer,SalesAccount,DeferralAccount),
            TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY)
        end else
          if SalesLine.IsCreditDocType then begin
            GenPostingSetup.TestField("Sales Credit Memo Account");
            SalesAccount := GenPostingSetup."Sales Credit Memo Account";
            InvoicePostBuffer.SetAccount(
              DefaultGLAccount(SalesLine."Deferral Code",AmtToDefer,SalesAccount,DeferralAccount),
              TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
          end else begin
            GenPostingSetup.TestField("Sales Account");
            SalesAccount := GenPostingSetup."Sales Account";
            InvoicePostBuffer.SetAccount(
              DefaultGLAccount(SalesLine."Deferral Code",AmtToDefer,SalesAccount,DeferralAccount),
              TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
          end;
        InvoicePostBuffer."Deferral Code" := SalesLine."Deferral Code";
        if TaxOption = Taxoption::SalesTax then
          InvoicePostBuffer.ClearVAT;
        UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer,false);
        if SalesLine."Deferral Code" <> '' then
          FillDeferralPostingBuffer(SalesHeader,SalesLine,InvoicePostBuffer,AmtToDefer,AmtToDeferACY,DeferralAccount,SalesAccount);
    end;

    local procedure UpdateInvoicePostBuffer(var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;InvoicePostBuffer: Record "Invoice Post. Buffer";ForceGLAccountType: Boolean)
    var
        RestoreFAType: Boolean;
    begin
        if InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" then begin
          FALineNo := FALineNo + 1;
          InvoicePostBuffer."Fixed Asset Line No." := FALineNo;
          if ForceGLAccountType then begin
            RestoreFAType := true;
            InvoicePostBuffer.Type := InvoicePostBuffer.Type::"G/L Account";
          end;
        end;

        TempInvoicePostBuffer.Update(InvoicePostBuffer,InvDefLineNo,DeferralLineNo);

        if RestoreFAType then
          TempInvoicePostBuffer.Type := TempInvoicePostBuffer.Type::"Fixed Asset";
    end;

    local procedure InsertPrepmtAdjInvPostingBuf(SalesHeader: Record "Sales Header";PrepmtSalesLine: Record "Sales Line";var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;InvoicePostBuffer: Record "Invoice Post. Buffer")
    var
        SalesPostPrepayments: Codeunit "Sales-Post Prepayments";
        AdjAmount: Decimal;
    begin
        with PrepmtSalesLine do
          if "Prepayment Line" then
            if "Prepmt. Amount Inv. (LCY)" <> 0 then begin
              AdjAmount := -"Prepmt. Amount Inv. (LCY)";
              InvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer,InvoicePostBuffer,
                "No.",AdjAmount,SalesHeader."Currency Code" = '');
              InvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer,InvoicePostBuffer,
                SalesPostPrepayments.GetCorrBalAccNo(SalesHeader,AdjAmount > 0),
                -AdjAmount,SalesHeader."Currency Code" = '');
            end else
              if ("Prepayment %" = 100) and ("Prepmt. VAT Amount Inv. (LCY)" <> 0) then
                InvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer,InvoicePostBuffer,
                  SalesPostPrepayments.GetInvRoundingAccNo(SalesHeader."Customer Posting Group"),
                  "Prepmt. VAT Amount Inv. (LCY)",SalesHeader."Currency Code" = '');
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

    local procedure DivideAmount(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";QtyType: Option General,Invoicing,Shipping;SalesLineQty: Decimal;var TempVATAmountLine: Record "VAT Amount Line" temporary;var TempVATAmountLineRemainder: Record "VAT Amount Line" temporary)
    var
        OriginalDeferralAmount: Decimal;
    begin
        if RoundingLineInserted and (RoundingLineNo = SalesLine."Line No.") then
          exit;
        with SalesLine do
          if (SalesLineQty = 0) or ("Unit Price" = 0) then begin
            "Line Amount" := 0;
            "Line Discount Amount" := 0;
            "Inv. Discount Amount" := 0;
            "VAT Base Amount" := 0;
            Amount := 0;
            "Amount Including VAT" := 0;
          end else begin
            OriginalDeferralAmount := GetDeferralAmount;
            if "VAT Calculation Type" = "vat calculation type"::"Sales Tax" then begin
              if (QtyType = Qtytype::Invoicing) and
                 TempSalesLineForSalesTax.Get("Document Type","Document No.","Line No.")
              then begin
                "Line Amount" := TempSalesLineForSalesTax."Line Amount";
                "Line Discount Amount" := TempSalesLineForSalesTax."Line Discount Amount";
                Amount := TempSalesLineForSalesTax.Amount;
                "Amount Including VAT" := TempSalesLineForSalesTax."Amount Including VAT";
                "Inv. Discount Amount" := TempSalesLineForSalesTax."Inv. Discount Amount";
                "VAT Base Amount" := TempSalesLineForSalesTax."VAT Base Amount";
              end else begin
                "Line Amount" := ROUND(SalesLineQty * "Unit Price",Currency."Amount Rounding Precision");
                if SalesLineQty <> Quantity then
                  "Line Discount Amount" :=
                    ROUND("Line Amount" * "Line Discount %" / 100,Currency."Amount Rounding Precision");
                "Line Amount" := "Line Amount" - "Line Discount Amount";
                if "Allow Invoice Disc." then
                  if QtyType = Qtytype::Invoicing then
                    "Inv. Discount Amount" := "Inv. Disc. Amount to Invoice"
                  else begin
                    TempSalesLineForSpread."Inv. Discount Amount" :=
                      TempSalesLineForSpread."Inv. Discount Amount" +
                      "Inv. Discount Amount" * SalesLineQty / Quantity;
                    "Inv. Discount Amount" :=
                      ROUND(TempSalesLineForSpread."Inv. Discount Amount",Currency."Amount Rounding Precision");
                    TempSalesLineForSpread."Inv. Discount Amount" :=
                      TempSalesLineForSpread."Inv. Discount Amount" - "Inv. Discount Amount";
                  end;
                Amount := "Line Amount" - "Inv. Discount Amount";
                "VAT Base Amount" := Amount;
                "Amount Including VAT" := Amount;
              end;
            end else begin
              TempVATAmountLine.Get("VAT Identifier","VAT Calculation Type","Tax Group Code","Tax Area Code",false,"Line Amount" >= 0);
              if "VAT Calculation Type" = "vat calculation type"::"Sales Tax" then
                "VAT %" := TempVATAmountLine."VAT %";
              TempVATAmountLineRemainder := TempVATAmountLine;
              if not TempVATAmountLineRemainder.Find then begin
                TempVATAmountLineRemainder.Init;
                TempVATAmountLineRemainder.Insert;
              end;
              "Line Amount" := GetLineAmountToHandle(SalesLineQty) + GetPrepmtDiffToLineAmount(SalesLine);
              if SalesLineQty <> Quantity then
                "Line Discount Amount" :=
                  ROUND("Line Discount Amount" * SalesLineQty / Quantity,Currency."Amount Rounding Precision");

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

              if SalesHeader."Prices Including VAT" then begin
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
                    Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                TempVATAmountLineRemainder."Amount Including VAT" :=
                  TempVATAmountLineRemainder."Amount Including VAT" - "Amount Including VAT";
                TempVATAmountLineRemainder."VAT Amount" :=
                  TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
              end else
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
                      Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
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

              TempVATAmountLineRemainder.Modify;
            end;
            if "Deferral Code" <> '' then
              CalcDeferralAmounts(SalesHeader,SalesLine,OriginalDeferralAmount);
          end;
    end;

    local procedure RoundAmount(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";SalesLineQty: Decimal)
    var
        CurrExchRate: Record "Currency Exchange Rate";
        NoVAT: Boolean;
    begin
        with SalesLine do begin
          IncrAmount(SalesHeader,SalesLine,TotalSalesLine);
          Increment(TotalSalesLine."Net Weight",ROUND(SalesLineQty * "Net Weight",0.00001));
          Increment(TotalSalesLine."Gross Weight",ROUND(SalesLineQty * "Gross Weight",0.00001));
          Increment(TotalSalesLine."Unit Volume",ROUND(SalesLineQty * "Unit Volume",0.00001));
          Increment(TotalSalesLine.Quantity,SalesLineQty);
          if "Units per Parcel" > 0 then
            Increment(
              TotalSalesLine."Units per Parcel",
              ROUND(SalesLineQty / "Units per Parcel",1,'>'));

          xSalesLine := SalesLine;
          SalesLineACY := SalesLine;

          if SalesHeader."Currency Code" <> '' then begin
            if SalesHeader."Posting Date" = 0D then
              UseDate := WorkDate
            else
              UseDate := SalesHeader."Posting Date";

            NoVAT := Amount = "Amount Including VAT";
            "Amount Including VAT" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate,SalesHeader."Currency Code",
                  TotalSalesLine."Amount Including VAT",SalesHeader."Currency Factor")) -
              TotalSalesLineLCY."Amount Including VAT";
            if NoVAT then
              Amount := "Amount Including VAT"
            else
              Amount :=
                ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    UseDate,SalesHeader."Currency Code",
                    TotalSalesLine.Amount,SalesHeader."Currency Factor")) -
                TotalSalesLineLCY.Amount;
            "Line Amount" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate,SalesHeader."Currency Code",
                  TotalSalesLine."Line Amount",SalesHeader."Currency Factor")) -
              TotalSalesLineLCY."Line Amount";
            "Line Discount Amount" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate,SalesHeader."Currency Code",
                  TotalSalesLine."Line Discount Amount",SalesHeader."Currency Factor")) -
              TotalSalesLineLCY."Line Discount Amount";
            "Inv. Discount Amount" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate,SalesHeader."Currency Code",
                  TotalSalesLine."Inv. Discount Amount",SalesHeader."Currency Factor")) -
              TotalSalesLineLCY."Inv. Discount Amount";
            "VAT Difference" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate,SalesHeader."Currency Code",
                  TotalSalesLine."VAT Difference",SalesHeader."Currency Factor")) -
              TotalSalesLineLCY."VAT Difference";
          end;
          IncrAmount(SalesHeader,SalesLine,TotalSalesLineLCY);
          if "VAT %" <> 0 then
            TotalSalesLineLCY."VAT %" := "VAT %";
          Increment(TotalSalesLineLCY."Unit Cost (LCY)",ROUND(SalesLineQty * "Unit Cost (LCY)"));
        end;
    end;

    local procedure ReverseAmount(var SalesLine: Record "Sales Line")
    begin
        with SalesLine do begin
          "Qty. to Ship" := -"Qty. to Ship";
          "Qty. to Ship (Base)" := -"Qty. to Ship (Base)";
          "Return Qty. to Receive" := -"Return Qty. to Receive";
          "Return Qty. to Receive (Base)" := -"Return Qty. to Receive (Base)";
          "Qty. to Invoice" := -"Qty. to Invoice";
          "Qty. to Invoice (Base)" := -"Qty. to Invoice (Base)";
          "Line Amount" := -"Line Amount";
          Amount := -Amount;
          "VAT Base Amount" := -"VAT Base Amount";
          "VAT Difference" := -"VAT Difference";
          "Amount Including VAT" := -"Amount Including VAT";
          "Line Discount Amount" := -"Line Discount Amount";
          "Inv. Discount Amount" := -"Inv. Discount Amount";
        end;
    end;

    local procedure InvoiceRounding(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";UseTempData: Boolean;BiggestLineNo: Integer)
    var
        CustPostingGr: Record "Customer Posting Group";
        TempSalesLineForCalc: Record "Sales Line" temporary;
        InvoiceRoundingAmount: Decimal;
    begin
        Currency.TestField("Invoice Rounding Precision");
        InvoiceRoundingAmount :=
          -ROUND(
            TotalSalesLine."Amount Including VAT" -
            ROUND(
              TotalSalesLine."Amount Including VAT",
              Currency."Invoice Rounding Precision",
              Currency.InvoiceRoundingDirection),
            Currency."Amount Rounding Precision");
        if InvoiceRoundingAmount <> 0 then begin
          CustPostingGr.Get(SalesHeader."Customer Posting Group");
          CustPostingGr.TestField("Invoice Rounding Account");
          with SalesLine do begin
            Init;
            BiggestLineNo := BiggestLineNo + 10000;
            "System-Created Entry" := true;
            if UseTempData then begin
              "Line No." := 0;
              Type := Type::"G/L Account";
              CreateTempSalesLineForCalc(TempSalesLineForCalc,SalesLine,CustPostingGr."Invoice Rounding Account");
              SalesLine := TempSalesLineForCalc;
            end else begin
              "Line No." := BiggestLineNo;
              Validate(Type,Type::"G/L Account");
              Validate("No.",CustPostingGr."Invoice Rounding Account");
            end;
            "Tax Area Code" := '';
            "Tax Liable" := false;
            Validate(Quantity,1);
            if IsCreditDocType then
              Validate("Return Qty. to Receive",Quantity)
            else
              Validate("Qty. to Ship",Quantity);
            if SalesHeader."Prices Including VAT" then
              Validate("Unit Price",InvoiceRoundingAmount)
            else
              Validate(
                "Unit Price",
                ROUND(
                  InvoiceRoundingAmount /
                  (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                  Currency."Amount Rounding Precision"));
            Validate("Amount Including VAT",InvoiceRoundingAmount);
            "Line No." := BiggestLineNo;
            LastLineRetrieved := false;
            RoundingLineInserted := true;
            RoundingLineNo := "Line No.";
          end;
        end;
    end;

    local procedure IncrAmount(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";var TotalSalesLine: Record "Sales Line")
    begin
        with SalesLine do begin
          if SalesHeader."Prices Including VAT" or
             ("VAT Calculation Type" <> "vat calculation type"::"Full VAT")
          then
            Increment(TotalSalesLine."Line Amount","Line Amount");
          Increment(TotalSalesLine.Amount,Amount);
          Increment(TotalSalesLine."VAT Base Amount","VAT Base Amount");
          Increment(TotalSalesLine."VAT Difference","VAT Difference");
          Increment(TotalSalesLine."Amount Including VAT","Amount Including VAT");
          Increment(TotalSalesLine."Line Discount Amount","Line Discount Amount");
          Increment(TotalSalesLine."Inv. Discount Amount","Inv. Discount Amount");
          Increment(TotalSalesLine."Inv. Disc. Amount to Invoice","Inv. Disc. Amount to Invoice");
          Increment(TotalSalesLine."Prepmt. Line Amount","Prepmt. Line Amount");
          Increment(TotalSalesLine."Prepmt. Amt. Inv.","Prepmt. Amt. Inv.");
          Increment(TotalSalesLine."Prepmt Amt to Deduct","Prepmt Amt to Deduct");
          Increment(TotalSalesLine."Prepmt Amt Deducted","Prepmt Amt Deducted");
          Increment(TotalSalesLine."Prepayment VAT Difference","Prepayment VAT Difference");
          Increment(TotalSalesLine."Prepmt VAT Diff. to Deduct","Prepmt VAT Diff. to Deduct");
          Increment(TotalSalesLine."Prepmt VAT Diff. Deducted","Prepmt VAT Diff. Deducted");
        end;
    end;

    local procedure Increment(var Number: Decimal;Number2: Decimal)
    begin
        Number := Number + Number2;
    end;


    procedure GetSalesLines(var SalesHeader: Record "Sales Header";var NewSalesLine: Record "Sales Line";QtyType: Option General,Invoicing,Shipping)
    var
        OldSalesLine: Record "Sales Line";
        MergedSalesLines: Record "Sales Line" temporary;
        TotalAdjCostLCY: Decimal;
    begin
        if QtyType = Qtytype::Invoicing then begin
          CreatePrepaymentLines(SalesHeader,TempPrepaymentSalesLine,false);
          MergeSaleslines(SalesHeader,OldSalesLine,TempPrepaymentSalesLine,MergedSalesLines);
          SumSalesLines2(SalesHeader,NewSalesLine,MergedSalesLines,QtyType,true,false,TotalAdjCostLCY);
        end else
          SumSalesLines2(SalesHeader,NewSalesLine,OldSalesLine,QtyType,true,false,TotalAdjCostLCY);
    end;


    procedure GetSalesLinesTemp(var SalesHeader: Record "Sales Header";var NewSalesLine: Record "Sales Line";var OldSalesLine: Record "Sales Line";QtyType: Option General,Invoicing,Shipping)
    var
        TotalAdjCostLCY: Decimal;
    begin
        OldSalesLine.SetSalesHeader(SalesHeader);
        SumSalesLines2(SalesHeader,NewSalesLine,OldSalesLine,QtyType,true,false,TotalAdjCostLCY);
    end;


    procedure SumSalesLines(var NewSalesHeader: Record "Sales Header";QtyType: Option General,Invoicing,Shipping;var NewTotalSalesLine: Record "Sales Line";var NewTotalSalesLineLCY: Record "Sales Line";var VATAmount: Decimal;var VATAmountText: Text[30];var ProfitLCY: Decimal;var ProfitPct: Decimal;var TotalAdjCostLCY: Decimal)
    var
        OldSalesLine: Record "Sales Line";
    begin
        SumSalesLinesTemp(
          NewSalesHeader,OldSalesLine,QtyType,NewTotalSalesLine,NewTotalSalesLineLCY,
          VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);
    end;


    procedure SumSalesLinesTemp(var SalesHeader: Record "Sales Header";var OldSalesLine: Record "Sales Line";QtyType: Option General,Invoicing,Shipping;var NewTotalSalesLine: Record "Sales Line";var NewTotalSalesLineLCY: Record "Sales Line";var VATAmount: Decimal;var VATAmountText: Text[30];var ProfitLCY: Decimal;var ProfitPct: Decimal;var TotalAdjCostLCY: Decimal)
    var
        SalesLine: Record "Sales Line";
    begin
        with SalesHeader do begin
          SumSalesLines2(SalesHeader,SalesLine,OldSalesLine,QtyType,false,true,TotalAdjCostLCY);
          ProfitLCY := TotalSalesLineLCY.Amount - TotalSalesLineLCY."Unit Cost (LCY)";
          if TotalSalesLineLCY.Amount = 0 then
            ProfitPct := 0
          else
            ProfitPct := ROUND(ProfitLCY / TotalSalesLineLCY.Amount * 100,0.1);
          VATAmount := TotalSalesLine."Amount Including VAT" - TotalSalesLine.Amount;
          if TotalSalesLine."VAT %" = 0 then
            VATAmountText := VATAmountTxt
          else
            VATAmountText := StrSubstNo(VATRateTxt,TotalSalesLine."VAT %");
          NewTotalSalesLine := TotalSalesLine;
          NewTotalSalesLineLCY := TotalSalesLineLCY;
        end;
    end;

    local procedure SumSalesLines2(SalesHeader: Record "Sales Header";var NewSalesLine: Record "Sales Line";var OldSalesLine: Record "Sales Line";QtyType: Option General,Invoicing,Shipping;InsertSalesLine: Boolean;CalcAdCostLCY: Boolean;var TotalAdjCostLCY: Decimal)
    var
        SalesLine: Record "Sales Line";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        SalesLineQty: Decimal;
        AdjCostLCY: Decimal;
        BiggestLineNo: Integer;
    begin
        TotalAdjCostLCY := 0;
        TempVATAmountLineRemainder.DeleteAll;
        OldSalesLine.CalcVATAmountLines(QtyType,SalesHeader,OldSalesLine,TempVATAmountLine);
        with SalesHeader do begin
          GetGLSetup;
          SalesSetup.Get;
          GetCurrency("Currency Code");
          OldSalesLine.SetRange("Document Type","Document Type");
          OldSalesLine.SetRange("Document No.","No.");
          RoundingLineInserted := false;
          if OldSalesLine.FindSet then
            repeat
              if not RoundingLineInserted then
                SalesLine := OldSalesLine;
              case QtyType of
                Qtytype::General:
                  SalesLineQty := SalesLine.Quantity;
                Qtytype::Invoicing:
                  SalesLineQty := SalesLine."Qty. to Invoice";
                Qtytype::Shipping:
                  begin
                    if IsCreditDocType then
                      SalesLineQty := SalesLine."Return Qty. to Receive"
                    else
                      SalesLineQty := SalesLine."Qty. to Ship";
                  end;
              end;
              DivideAmount(SalesHeader,SalesLine,QtyType,SalesLineQty,TempVATAmountLine,TempVATAmountLineRemainder);
              SalesLine.Quantity := SalesLineQty;
              if SalesLineQty <> 0 then begin
                if (SalesLine.Amount <> 0) and not RoundingLineInserted then
                  if TotalSalesLine.Amount = 0 then
                    TotalSalesLine."VAT %" := SalesLine."VAT %"
                  else
                    if TotalSalesLine."VAT %" <> SalesLine."VAT %" then
                      TotalSalesLine."VAT %" := 0;
                RoundAmount(SalesHeader,SalesLine,SalesLineQty);

                if (QtyType in [Qtytype::General,Qtytype::Invoicing]) and
                   not InsertSalesLine and CalcAdCostLCY
                then begin
                  AdjCostLCY := CostCalcMgt.CalcSalesLineCostLCY(SalesLine,QtyType);
                  TotalAdjCostLCY := TotalAdjCostLCY + GetSalesLineAdjCostLCY(SalesLine,QtyType,AdjCostLCY);
                end;

                SalesLine := xSalesLine;
              end;
              if InsertSalesLine then begin
                NewSalesLine := SalesLine;
                NewSalesLine.Insert;
              end;
              if RoundingLineInserted then
                LastLineRetrieved := true
              else begin
                BiggestLineNo := MAX(BiggestLineNo,OldSalesLine."Line No.");
                LastLineRetrieved := OldSalesLine.Next = 0;
                if LastLineRetrieved and SalesSetup."Invoice Rounding" then
                  InvoiceRounding(SalesHeader,SalesLine,true,BiggestLineNo);
              end;
            until LastLineRetrieved;
        end;
    end;

    local procedure GetSalesLineAdjCostLCY(SalesLine2: Record "Sales Line";QtyType: Option General,Invoicing,Shipping;AdjCostLCY: Decimal): Decimal
    begin
        with SalesLine2 do begin
          if "Document Type" in ["document type"::Order,"document type"::Invoice] then
            AdjCostLCY := -AdjCostLCY;

          case true of
            "Shipment No." <> '',"Return Receipt No." <> '':
              exit(AdjCostLCY);
            QtyType = Qtytype::General:
              exit(ROUND("Outstanding Quantity" * "Unit Cost (LCY)") + AdjCostLCY);
            "Document Type" in ["document type"::Order,"document type"::Invoice]:
              begin
                if "Qty. to Invoice" > "Qty. to Ship" then
                  exit(ROUND("Qty. to Ship" * "Unit Cost (LCY)") + AdjCostLCY);
                exit(ROUND("Qty. to Invoice" * "Unit Cost (LCY)"));
              end;
            IsCreditDocType:
              begin
                if "Qty. to Invoice" > "Return Qty. to Receive" then
                  exit(ROUND("Return Qty. to Receive" * "Unit Cost (LCY)") + AdjCostLCY);
                exit(ROUND("Qty. to Invoice" * "Unit Cost (LCY)"));
              end;
          end;
        end;
    end;


    procedure UpdateBlanketOrderLine(SalesLine: Record "Sales Line";Ship: Boolean;Receive: Boolean;Invoice: Boolean)
    var
        BlanketOrderSalesLine: Record "Sales Line";
        xBlanketOrderSalesLine: Record "Sales Line";
        ModifyLine: Boolean;
        Sign: Decimal;
    begin
        if (SalesLine."Blanket Order No." <> '') and (SalesLine."Blanket Order Line No." <> 0) and
           ((Ship and (SalesLine."Qty. to Ship" <> 0)) or
            (Receive and (SalesLine."Return Qty. to Receive" <> 0)) or
            (Invoice and (SalesLine."Qty. to Invoice" <> 0)))
        then
          if BlanketOrderSalesLine.Get(
               BlanketOrderSalesLine."document type"::"Blanket Order",SalesLine."Blanket Order No.",
               SalesLine."Blanket Order Line No.")
          then begin
            BlanketOrderSalesLine.TestField(Type,SalesLine.Type);
            BlanketOrderSalesLine.TestField("No.",SalesLine."No.");
            BlanketOrderSalesLine.TestField("Sell-to Customer No.",SalesLine."Sell-to Customer No.");

            ModifyLine := false;
            case SalesLine."Document Type" of
              SalesLine."document type"::Order,
              SalesLine."document type"::Invoice:
                Sign := 1;
              SalesLine."document type"::"Return Order",
              SalesLine."document type"::"Credit Memo":
                Sign := -1;
            end;
            if Ship and (SalesLine."Shipment No." = '') then begin
              xBlanketOrderSalesLine := BlanketOrderSalesLine;

              if BlanketOrderSalesLine."Qty. per Unit of Measure" =
                 SalesLine."Qty. per Unit of Measure"
              then
                BlanketOrderSalesLine."Quantity Shipped" :=
                  BlanketOrderSalesLine."Quantity Shipped" + Sign * SalesLine."Qty. to Ship"
              else
                BlanketOrderSalesLine."Quantity Shipped" :=
                  BlanketOrderSalesLine."Quantity Shipped" +
                  Sign *
                  ROUND(
                    (SalesLine."Qty. per Unit of Measure" /
                     BlanketOrderSalesLine."Qty. per Unit of Measure") *
                    SalesLine."Qty. to Ship",0.00001);
              BlanketOrderSalesLine."Qty. Shipped (Base)" :=
                BlanketOrderSalesLine."Qty. Shipped (Base)" + Sign * SalesLine."Qty. to Ship (Base)";
              ModifyLine := true;

              AsmPost.UpdateBlanketATO(xBlanketOrderSalesLine,BlanketOrderSalesLine);
            end;
            if Receive and (SalesLine."Return Receipt No." = '') then begin
              if BlanketOrderSalesLine."Qty. per Unit of Measure" =
                 SalesLine."Qty. per Unit of Measure"
              then
                BlanketOrderSalesLine."Quantity Shipped" :=
                  BlanketOrderSalesLine."Quantity Shipped" + Sign * SalesLine."Return Qty. to Receive"
              else
                BlanketOrderSalesLine."Quantity Shipped" :=
                  BlanketOrderSalesLine."Quantity Shipped" +
                  Sign *
                  ROUND(
                    (SalesLine."Qty. per Unit of Measure" /
                     BlanketOrderSalesLine."Qty. per Unit of Measure") *
                    SalesLine."Return Qty. to Receive",0.00001);
              BlanketOrderSalesLine."Qty. Shipped (Base)" :=
                BlanketOrderSalesLine."Qty. Shipped (Base)" + Sign * SalesLine."Return Qty. to Receive (Base)";
              ModifyLine := true;
            end;
            if Invoice then begin
              if BlanketOrderSalesLine."Qty. per Unit of Measure" =
                 SalesLine."Qty. per Unit of Measure"
              then
                BlanketOrderSalesLine."Quantity Invoiced" :=
                  BlanketOrderSalesLine."Quantity Invoiced" + Sign * SalesLine."Qty. to Invoice"
              else
                BlanketOrderSalesLine."Quantity Invoiced" :=
                  BlanketOrderSalesLine."Quantity Invoiced" +
                  Sign *
                  ROUND(
                    (SalesLine."Qty. per Unit of Measure" /
                     BlanketOrderSalesLine."Qty. per Unit of Measure") *
                    SalesLine."Qty. to Invoice",0.00001);
              BlanketOrderSalesLine."Qty. Invoiced (Base)" :=
                BlanketOrderSalesLine."Qty. Invoiced (Base)" + Sign * SalesLine."Qty. to Invoice (Base)";
              ModifyLine := true;
            end;

            if ModifyLine then begin
              BlanketOrderSalesLine.InitOutstanding;
              if (BlanketOrderSalesLine.Quantity * BlanketOrderSalesLine."Quantity Shipped" < 0) or
                 (Abs(BlanketOrderSalesLine.Quantity) < Abs(BlanketOrderSalesLine."Quantity Shipped"))
              then
                BlanketOrderSalesLine.FieldError(
                  "Quantity Shipped",StrSubstNo(
                    BlanketOrderQuantityGreaterThanErr,
                    BlanketOrderSalesLine.FieldCaption(Quantity)));

              if (BlanketOrderSalesLine."Quantity (Base)" *
                  BlanketOrderSalesLine."Qty. Shipped (Base)" < 0) or
                 (Abs(BlanketOrderSalesLine."Quantity (Base)") <
                  Abs(BlanketOrderSalesLine."Qty. Shipped (Base)"))
              then
                BlanketOrderSalesLine.FieldError(
                  "Qty. Shipped (Base)",
                  StrSubstNo(
                    BlanketOrderQuantityGreaterThanErr,
                    BlanketOrderSalesLine.FieldCaption("Quantity (Base)")));

              BlanketOrderSalesLine.CalcFields("Reserved Qty. (Base)");
              if Abs(BlanketOrderSalesLine."Outstanding Qty. (Base)") <
                 Abs(BlanketOrderSalesLine."Reserved Qty. (Base)")
              then
                BlanketOrderSalesLine.FieldError(
                  "Reserved Qty. (Base)",BlanketOrderQuantityReducedErr);

              BlanketOrderSalesLine."Qty. to Invoice" :=
                BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Invoiced";
              BlanketOrderSalesLine."Qty. to Ship" :=
                BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Shipped";
              BlanketOrderSalesLine."Qty. to Invoice (Base)" :=
                BlanketOrderSalesLine."Quantity (Base)" - BlanketOrderSalesLine."Qty. Invoiced (Base)";
              BlanketOrderSalesLine."Qty. to Ship (Base)" :=
                BlanketOrderSalesLine."Quantity (Base)" - BlanketOrderSalesLine."Qty. Shipped (Base)";

              BlanketOrderSalesLine.Modify;
            end;
          end;
    end;

    local procedure CopyCommentLines(FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
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

    local procedure RunGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"): Integer
    begin
        exit(GenJnlPostLine.RunWithCheck(GenJnlLine));
    end;

    local procedure CheckDim(SalesHeader: Record "Sales Header")
    begin
        CheckDimCombHeader(SalesHeader);
        CheckDimValuePostingHeader(SalesHeader);
        CheckDimLines(SalesHeader);
    end;

    local procedure CheckDimCombHeader(SalesHeader: Record "Sales Header")
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        with SalesHeader do
          if not DimMgt.CheckDimIDComb("Dimension Set ID") then
            Error(DimensionIsBlockedErr,"Document Type","No.",DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimCombLine(SalesLine: Record "Sales Line")
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        with SalesLine do
          if not DimMgt.CheckDimIDComb("Dimension Set ID") then
            Error(LineDimensionBlockedErr,"Document Type","Document No.","Line No.",DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimLines(SalesHeader: Record "Sales Header")
    var
        TempSalesLine: Record "Sales Line" temporary;
    begin
        with TempSalesLine do begin
          ResetTempLines(TempSalesLine);
          SetFilter(Type,'<>%1',Type::" ");
          if FindSet then
            repeat
              if (SalesHeader.Invoice and ("Qty. to Invoice" <> 0)) or
                 (SalesHeader.Ship and ("Qty. to Ship" <> 0)) or
                 (SalesHeader.Receive and ("Return Qty. to Receive" <> 0))
              then begin
                CheckDimCombLine(TempSalesLine);
                CheckDimValuePostingLine(TempSalesLine);
              end
            until Next = 0;
        end;
    end;

    local procedure CheckDimValuePostingHeader(SalesHeader: Record "Sales Header")
    var
        DimMgt: Codeunit DimensionManagement;
        TableIDArr: array [10] of Integer;
        NumberArr: array [10] of Code[20];
    begin
        with SalesHeader do begin
          TableIDArr[1] := Database::Customer;
          NumberArr[1] := "Bill-to Customer No.";
          TableIDArr[2] := Database::"Salesperson/Purchaser";
          NumberArr[2] := "Salesperson Code";
          TableIDArr[3] := Database::Campaign;
          NumberArr[3] := "Campaign No.";
          TableIDArr[4] := Database::"Responsibility Center";
          NumberArr[4] := "Responsibility Center";
          if not DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,"Dimension Set ID") then
            Error(InvalidDimensionsErr,"Document Type","No.",DimMgt.GetDimValuePostingErr);
        end;
    end;

    local procedure CreateTempSalesLineForCalc(var SalesLineForCalc: Record "Sales Line";SalesLine: Record "Sales Line";InvoiceRoundingAccount: Code[20])
    begin
        SalesLineForCalc := SalesLine;
        SalesLineForCalc.SetHideValidationDialog(true);
        SalesLineForCalc.Validate("No.",InvoiceRoundingAccount);
    end;

    local procedure CheckDimValuePostingLine(SalesLine: Record "Sales Line")
    var
        DimMgt: Codeunit DimensionManagement;
        TableIDArr: array [10] of Integer;
        NumberArr: array [10] of Code[20];
    begin
        with SalesLine do begin
          TableIDArr[1] := DimMgt.TypeToTableID3(Type);
          NumberArr[1] := "No.";
          TableIDArr[2] := Database::Job;
          NumberArr[2] := "Job No.";
          if not DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,"Dimension Set ID") then
            Error(LineInvalidDimensionsErr,"Document Type","Document No.","Line No.",DimMgt.GetDimValuePostingErr);
        end;
    end;

    local procedure DeleteItemChargeAssgnt(SalesHeader: Record "Sales Header")
    var
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
    begin
        ItemChargeAssgntSales.SetRange("Document Type",SalesHeader."Document Type");
        ItemChargeAssgntSales.SetRange("Document No.",SalesHeader."No.");
        if not ItemChargeAssgntSales.IsEmpty then
          ItemChargeAssgntSales.DeleteAll;
    end;

    local procedure UpdateItemChargeAssgnt()
    var
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
    begin
        with TempItemChargeAssgntSales do begin
          ClearItemChargeAssgntFilter;
          MarkedOnly(true);
          if FindSet then
            repeat
              ItemChargeAssgntSales.Get("Document Type","Document No.","Document Line No.","Line No.");
              ItemChargeAssgntSales."Qty. Assigned" :=
                ItemChargeAssgntSales."Qty. Assigned" + "Qty. to Assign";
              ItemChargeAssgntSales."Qty. to Assign" := 0;
              ItemChargeAssgntSales."Amount to Assign" := 0;
              ItemChargeAssgntSales.Modify;
            until Next = 0;
        end;
    end;

    local procedure UpdateSalesOrderChargeAssgnt(SalesOrderInvLine: Record "Sales Line";SalesOrderLine: Record "Sales Line")
    var
        SalesOrderLine2: Record "Sales Line";
        SalesOrderInvLine2: Record "Sales Line";
        SalesShptLine: Record "Sales Shipment Line";
        ReturnRcptLine: Record "Return Receipt Line";
    begin
        with SalesOrderInvLine do begin
          ClearItemChargeAssgntFilter;
          TempItemChargeAssgntSales.SetRange("Document Type","Document Type");
          TempItemChargeAssgntSales.SetRange("Document No.","Document No.");
          TempItemChargeAssgntSales.SetRange("Document Line No.","Line No.");
          TempItemChargeAssgntSales.MarkedOnly(true);
          if TempItemChargeAssgntSales.FindSet then
            repeat
              if TempItemChargeAssgntSales."Applies-to Doc. Type" = "Document Type" then begin
                SalesOrderInvLine2.Get(
                  TempItemChargeAssgntSales."Applies-to Doc. Type",
                  TempItemChargeAssgntSales."Applies-to Doc. No.",
                  TempItemChargeAssgntSales."Applies-to Doc. Line No.");
                if ((SalesOrderLine."Document Type" = SalesOrderLine."document type"::Order) and
                    (SalesOrderInvLine2."Shipment No." = "Shipment No.")) or
                   ((SalesOrderLine."Document Type" = SalesOrderLine."document type"::"Return Order") and
                    (SalesOrderInvLine2."Return Receipt No." = "Return Receipt No."))
                then begin
                  if SalesOrderLine."Document Type" = SalesOrderLine."document type"::Order then begin
                    if not
                       SalesShptLine.Get(SalesOrderInvLine2."Shipment No.",SalesOrderInvLine2."Shipment Line No.")
                    then
                      Error(ShipmentLinesDeletedErr);
                    SalesOrderLine2.Get(
                      SalesOrderLine2."document type"::Order,
                      SalesShptLine."Order No.",SalesShptLine."Order Line No.");
                  end else begin
                    if not
                       ReturnRcptLine.Get(SalesOrderInvLine2."Return Receipt No.",SalesOrderInvLine2."Return Receipt Line No.")
                    then
                      Error(ReturnReceiptLinesDeletedErr);
                    SalesOrderLine2.Get(
                      SalesOrderLine2."document type"::"Return Order",
                      ReturnRcptLine."Return Order No.",ReturnRcptLine."Return Order Line No.");
                  end;
                  UpdateSalesChargeAssgntLines(
                    SalesOrderLine,
                    SalesOrderLine2."Document Type",
                    SalesOrderLine2."Document No.",
                    SalesOrderLine2."Line No.",
                    TempItemChargeAssgntSales."Qty. to Assign");
                end;
              end else
                UpdateSalesChargeAssgntLines(
                  SalesOrderLine,
                  TempItemChargeAssgntSales."Applies-to Doc. Type",
                  TempItemChargeAssgntSales."Applies-to Doc. No.",
                  TempItemChargeAssgntSales."Applies-to Doc. Line No.",
                  TempItemChargeAssgntSales."Qty. to Assign");
            until TempItemChargeAssgntSales.Next = 0;
        end;
    end;

    local procedure UpdateSalesChargeAssgntLines(SalesOrderLine: Record "Sales Line";ApplToDocType: Option;ApplToDocNo: Code[20];ApplToDocLineNo: Integer;QtyToAssign: Decimal)
    var
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        TempItemChargeAssgntSales2: Record "Item Charge Assignment (Sales)";
        LastLineNo: Integer;
        TotalToAssign: Decimal;
    begin
        ItemChargeAssgntSales.SetRange("Document Type",SalesOrderLine."Document Type");
        ItemChargeAssgntSales.SetRange("Document No.",SalesOrderLine."Document No.");
        ItemChargeAssgntSales.SetRange("Document Line No.",SalesOrderLine."Line No.");
        ItemChargeAssgntSales.SetRange("Applies-to Doc. Type",ApplToDocType);
        ItemChargeAssgntSales.SetRange("Applies-to Doc. No.",ApplToDocNo);
        ItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.",ApplToDocLineNo);
        if ItemChargeAssgntSales.FindFirst then begin
          ItemChargeAssgntSales."Qty. Assigned" := ItemChargeAssgntSales."Qty. Assigned" + QtyToAssign;
          ItemChargeAssgntSales."Qty. to Assign" := 0;
          ItemChargeAssgntSales."Amount to Assign" := 0;
          ItemChargeAssgntSales.Modify;
        end else begin
          ItemChargeAssgntSales.SetRange("Applies-to Doc. Type");
          ItemChargeAssgntSales.SetRange("Applies-to Doc. No.");
          ItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.");
          ItemChargeAssgntSales.CalcSums("Qty. to Assign");

          // calculate total qty. to assign of the invoice charge line
          TempItemChargeAssgntSales2.SetRange("Document Type",TempItemChargeAssgntSales."Document Type");
          TempItemChargeAssgntSales2.SetRange("Document No.",TempItemChargeAssgntSales."Document No.");
          TempItemChargeAssgntSales2.SetRange("Document Line No.",TempItemChargeAssgntSales."Document Line No.");
          TempItemChargeAssgntSales2.CalcSums("Qty. to Assign");

          TotalToAssign := ItemChargeAssgntSales."Qty. to Assign" +
            TempItemChargeAssgntSales2."Qty. to Assign";

          if ItemChargeAssgntSales.FindLast then
            LastLineNo := ItemChargeAssgntSales."Line No.";

          if SalesOrderLine.Quantity < TotalToAssign then
            repeat
              TotalToAssign := TotalToAssign - ItemChargeAssgntSales."Qty. to Assign";
              ItemChargeAssgntSales."Qty. to Assign" := 0;
              ItemChargeAssgntSales."Amount to Assign" := 0;
              ItemChargeAssgntSales.Modify;
            until (ItemChargeAssgntSales.Next(-1) = 0) or
                  (TotalToAssign = SalesOrderLine.Quantity);

          InsertAssocOrderCharge(
            SalesOrderLine,
            ApplToDocType,
            ApplToDocNo,
            ApplToDocLineNo,
            LastLineNo,
            TempItemChargeAssgntSales."Applies-to Doc. Line Amount");
        end;
    end;

    local procedure InsertAssocOrderCharge(SalesOrderLine: Record "Sales Line";ApplToDocType: Option;ApplToDocNo: Code[20];ApplToDocLineNo: Integer;LastLineNo: Integer;ApplToDocLineAmt: Decimal)
    var
        NewItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
    begin
        with NewItemChargeAssgntSales do begin
          Init;
          "Document Type" := SalesOrderLine."Document Type";
          "Document No." := SalesOrderLine."Document No.";
          "Document Line No." := SalesOrderLine."Line No.";
          "Line No." := LastLineNo + 10000;
          "Item Charge No." := TempItemChargeAssgntSales."Item Charge No.";
          "Item No." := TempItemChargeAssgntSales."Item No.";
          "Qty. Assigned" := TempItemChargeAssgntSales."Qty. to Assign";
          "Qty. to Assign" := 0;
          "Amount to Assign" := 0;
          Description := TempItemChargeAssgntSales.Description;
          "Unit Cost" := TempItemChargeAssgntSales."Unit Cost";
          "Applies-to Doc. Type" := ApplToDocType;
          "Applies-to Doc. No." := ApplToDocNo;
          "Applies-to Doc. Line No." := ApplToDocLineNo;
          "Applies-to Doc. Line Amount" := ApplToDocLineAmt;
          Insert;
        end;
    end;

    local procedure CopyAndCheckItemCharge(SalesHeader: Record "Sales Header")
    var
        TempSalesLine: Record "Sales Line" temporary;
        SalesLine: Record "Sales Line";
        InvoiceEverything: Boolean;
        AssignError: Boolean;
        QtyNeeded: Decimal;
    begin
        TempItemChargeAssgntSales.Reset;
        TempItemChargeAssgntSales.DeleteAll;

        // Check for max qty posting
        with TempSalesLine do begin
          ResetTempLines(TempSalesLine);
          SetRange(Type,Type::"Charge (Item)");
          if IsEmpty then
            exit;

          ItemChargeAssgntSales.Reset;
          ItemChargeAssgntSales.SetRange("Document Type","Document Type");
          ItemChargeAssgntSales.SetRange("Document No.","Document No.");
          ItemChargeAssgntSales.SetFilter("Qty. to Assign",'<>0');
          if ItemChargeAssgntSales.FindSet then
            repeat
              TempItemChargeAssgntSales.Init;
              TempItemChargeAssgntSales := ItemChargeAssgntSales;
              TempItemChargeAssgntSales.Insert;
            until ItemChargeAssgntSales.Next = 0;

          SetFilter("Qty. to Invoice",'<>0');
          if FindSet then
            repeat
              TestField("Job No.",'');
              TestField("Job Contract Entry No.",0);
              if ("Qty. to Ship" + "Return Qty. to Receive" <> 0) and
                 ((SalesHeader.Ship or SalesHeader.Receive) or
                  (Abs("Qty. to Invoice") >
                   Abs("Qty. Shipped Not Invoiced" + "Qty. to Ship") +
                   Abs("Ret. Qty. Rcd. Not Invd.(Base)" + "Return Qty. to Receive")))
              then
                TestField("Line Amount");

              if not SalesHeader.Ship then
                "Qty. to Ship" := 0;
              if not SalesHeader.Receive then
                "Return Qty. to Receive" := 0;
              if Abs("Qty. to Invoice") >
                 Abs("Quantity Shipped" + "Qty. to Ship" + "Return Qty. Received" + "Return Qty. to Receive" - "Quantity Invoiced")
              then
                "Qty. to Invoice" :=
                  "Quantity Shipped" + "Qty. to Ship" + "Return Qty. Received" + "Return Qty. to Receive" - "Quantity Invoiced";

              CalcFields("Qty. to Assign","Qty. Assigned");
              if Abs("Qty. to Assign" + "Qty. Assigned") > Abs("Qty. to Invoice" + "Quantity Invoiced") then
                Error(CannotAssignMoreErr,
                  "Qty. to Invoice" + "Quantity Invoiced" - "Qty. Assigned",
                  FieldCaption("Document Type"),"Document Type",
                  FieldCaption("Document No."),"Document No.",
                  FieldCaption("Line No."),"Line No.");
              if Quantity = "Qty. to Invoice" + "Quantity Invoiced" then begin
                if "Qty. to Assign" <> 0 then
                  if Quantity = "Quantity Invoiced" then begin
                    TempItemChargeAssgntSales.SetRange("Document Line No.","Line No.");
                    TempItemChargeAssgntSales.SetRange("Applies-to Doc. Type","Document Type");
                    if TempItemChargeAssgntSales.FindSet then
                      repeat
                        SalesLine.Get(
                          TempItemChargeAssgntSales."Applies-to Doc. Type",
                          TempItemChargeAssgntSales."Applies-to Doc. No.",
                          TempItemChargeAssgntSales."Applies-to Doc. Line No.");
                        if SalesLine.Quantity = SalesLine."Quantity Invoiced" then
                          Error(CannotAssignInvoicedErr,SalesLine.TableCaption,
                            SalesLine.FieldCaption("Document Type"),SalesLine."Document Type",
                            SalesLine.FieldCaption("Document No."),SalesLine."Document No.",
                            SalesLine.FieldCaption("Line No."),SalesLine."Line No.");
                      until TempItemChargeAssgntSales.Next = 0;
                  end;
                if Quantity <> "Qty. to Assign" + "Qty. Assigned" then
                  AssignError := true;
              end;

              if ("Qty. to Assign" + "Qty. Assigned") < ("Qty. to Invoice" + "Quantity Invoiced") then
                Error(MustAssignItemChargeErr,"No.");

              // check if all ILEs exist
              QtyNeeded := "Qty. to Assign";
              TempItemChargeAssgntSales.SetRange("Document Line No.","Line No.");
              if TempItemChargeAssgntSales.FindSet then
                repeat
                  if (TempItemChargeAssgntSales."Applies-to Doc. Type" <> "Document Type") or
                     (TempItemChargeAssgntSales."Applies-to Doc. No." <> "Document No.")
                  then
                    QtyNeeded := QtyNeeded - TempItemChargeAssgntSales."Qty. to Assign"
                  else begin
                    SalesLine.Get(
                      TempItemChargeAssgntSales."Applies-to Doc. Type",
                      TempItemChargeAssgntSales."Applies-to Doc. No.",
                      TempItemChargeAssgntSales."Applies-to Doc. Line No.");
                    if ItemLedgerEntryExist(SalesLine,SalesHeader.Ship or SalesHeader.Receive) then
                      QtyNeeded := QtyNeeded - TempItemChargeAssgntSales."Qty. to Assign";
                  end;
                until TempItemChargeAssgntSales.Next = 0;

              if QtyNeeded > 0 then
                Error(CannotInvoiceItemChargeErr,"No.");
            until Next = 0;

          // Check saleslines
          if AssignError then
            if SalesHeader."Document Type" in
               [SalesHeader."document type"::Invoice,SalesHeader."document type"::"Credit Memo"]
            then
              InvoiceEverything := true
            else begin
              Reset;
              SetFilter(Type,'%1|%2',Type::Item,Type::"Charge (Item)");
              if FindSet then
                repeat
                  if SalesHeader.Ship or SalesHeader.Receive then
                    InvoiceEverything :=
                      Quantity = "Qty. to Invoice" + "Quantity Invoiced"
                  else
                    InvoiceEverything :=
                      (Quantity = "Qty. to Invoice" + "Quantity Invoiced") and
                      ("Qty. to Invoice" =
                       "Qty. Shipped Not Invoiced" + "Ret. Qty. Rcd. Not Invd.(Base)");
                until (Next = 0) or (not InvoiceEverything);
            end;
        end;

        if InvoiceEverything and AssignError then
          Error(MustAssignErr);
    end;

    local procedure ClearItemChargeAssgntFilter()
    begin
        TempItemChargeAssgntSales.SetRange("Document Line No.");
        TempItemChargeAssgntSales.SetRange("Applies-to Doc. Type");
        TempItemChargeAssgntSales.SetRange("Applies-to Doc. No.");
        TempItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.");
        TempItemChargeAssgntSales.MarkedOnly(false);
    end;

    local procedure GetItemChargeLine(SalesHeader: Record "Sales Header";var ItemChargeSalesLine: Record "Sales Line")
    var
        SalesShptLine: Record "Sales Shipment Line";
        ReturnReceiptLine: Record "Return Receipt Line";
        QtyShippedNotInvd: Decimal;
        QtyReceivedNotInvd: Decimal;
    begin
        with TempItemChargeAssgntSales do
          if (ItemChargeSalesLine."Document Type" <> "Document Type") or
             (ItemChargeSalesLine."Document No." <> "Document No.") or
             (ItemChargeSalesLine."Line No." <> "Document Line No.")
          then begin
            ItemChargeSalesLine.Get("Document Type","Document No.","Document Line No.");
            if not SalesHeader.Ship then
              ItemChargeSalesLine."Qty. to Ship" := 0;
            if not SalesHeader.Receive then
              ItemChargeSalesLine."Return Qty. to Receive" := 0;
            if ItemChargeSalesLine."Shipment No." <> '' then begin
              SalesShptLine.Get(ItemChargeSalesLine."Shipment No.",ItemChargeSalesLine."Shipment Line No.");
              QtyShippedNotInvd := "Qty. to Assign" - "Qty. Assigned";
            end else
              QtyShippedNotInvd := ItemChargeSalesLine."Quantity Shipped";
            if ItemChargeSalesLine."Return Receipt No." <> '' then begin
              ReturnReceiptLine.Get(ItemChargeSalesLine."Return Receipt No.",ItemChargeSalesLine."Return Receipt Line No.");
              QtyReceivedNotInvd := "Qty. to Assign" - "Qty. Assigned";
            end else
              QtyReceivedNotInvd := ItemChargeSalesLine."Return Qty. Received";
            if Abs(ItemChargeSalesLine."Qty. to Invoice") >
               Abs(QtyShippedNotInvd + ItemChargeSalesLine."Qty. to Ship" +
                 QtyReceivedNotInvd + ItemChargeSalesLine."Return Qty. to Receive" -
                 ItemChargeSalesLine."Quantity Invoiced")
            then
              ItemChargeSalesLine."Qty. to Invoice" :=
                QtyShippedNotInvd + ItemChargeSalesLine."Qty. to Ship" +
                QtyReceivedNotInvd + ItemChargeSalesLine."Return Qty. to Receive" -
                ItemChargeSalesLine."Quantity Invoiced";
          end;
    end;

    local procedure CalcQtyToInvoice(QtyToHandle: Decimal;QtyToInvoice: Decimal): Decimal
    begin
        if Abs(QtyToHandle) > Abs(QtyToInvoice) then
          exit(-QtyToHandle);

        exit(-QtyToInvoice);
    end;

    local procedure CheckWarehouse(var TempItemSalesLine: Record "Sales Line" temporary)
    var
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        ShowError: Boolean;
    begin
        with TempItemSalesLine do begin
          SetRange(Type,Type::Item);
          SetRange("Drop Shipment",false);
          if FindSet then
            repeat
              GetLocation("Location Code");
              case "Document Type" of
                "document type"::Order:
                  if ((Location."Require Receive" or Location."Require Put-away") and (Quantity < 0)) or
                     ((Location."Require Shipment" or Location."Require Pick") and (Quantity >= 0))
                  then begin
                    if Location."Directed Put-away and Pick" then
                      ShowError := true
                    else
                      if WhseValidateSourceLine.WhseLinesExist(
                           Database::"Sales Line","Document Type","Document No.","Line No.",0,Quantity)
                      then
                        ShowError := true;
                  end;
                "document type"::"Return Order":
                  if ((Location."Require Receive" or Location."Require Put-away") and (Quantity >= 0)) or
                     ((Location."Require Shipment" or Location."Require Pick") and (Quantity < 0))
                  then begin
                    if Location."Directed Put-away and Pick" then
                      ShowError := true
                    else
                      if WhseValidateSourceLine.WhseLinesExist(
                           Database::"Sales Line","Document Type","Document No.","Line No.",0,Quantity)
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

    local procedure CreateWhseJnlLine(ItemJnlLine: Record "Item Journal Line";SalesLine: Record "Sales Line";var TempWhseJnlLine: Record "Warehouse Journal Line" temporary)
    var
        WhseMgt: Codeunit "Whse. Management";
        WMSMgt: Codeunit "WMS Management";
    begin
        with SalesLine do begin
          WMSMgt.CheckAdjmtBin(Location,ItemJnlLine.Quantity,true);
          WMSMgt.CreateWhseJnlLine(ItemJnlLine,0,TempWhseJnlLine,false);
          TempWhseJnlLine."Source Type" := Database::"Sales Line";
          TempWhseJnlLine."Source Subtype" := "Document Type";
          TempWhseJnlLine."Source Code" := SrcCode;
          TempWhseJnlLine."Source Document" := WhseMgt.GetSourceDocument(TempWhseJnlLine."Source Type",TempWhseJnlLine."Source Subtype");
          TempWhseJnlLine."Source No." := "Document No.";
          TempWhseJnlLine."Source Line No." := "Line No.";
          case "Document Type" of
            "document type"::Order:
              TempWhseJnlLine."Reference Document" :=
                TempWhseJnlLine."reference document"::"Posted Shipment";
            "document type"::Invoice:
              TempWhseJnlLine."Reference Document" :=
                TempWhseJnlLine."reference document"::"Posted S. Inv.";
            "document type"::"Credit Memo":
              TempWhseJnlLine."Reference Document" :=
                TempWhseJnlLine."reference document"::"Posted S. Cr. Memo";
            "document type"::"Return Order":
              TempWhseJnlLine."Reference Document" :=
                TempWhseJnlLine."reference document"::"Posted Rtrn. Shipment";
          end;
          TempWhseJnlLine."Reference No." := ItemJnlLine."Document No.";
        end;
    end;

    local procedure WhseHandlingRequired(SalesLine: Record "Sales Line"): Boolean
    var
        WhseSetup: Record "Warehouse Setup";
    begin
        if (SalesLine.Type = SalesLine.Type::Item) and (not SalesLine."Drop Shipment") then begin
          if SalesLine."Location Code" = '' then begin
            WhseSetup.Get;
            if SalesLine."Document Type" = SalesLine."document type"::"Return Order" then
              exit(WhseSetup."Require Receive");

            exit(WhseSetup."Require Shipment");
          end;

          GetLocation(SalesLine."Location Code");
          if SalesLine."Document Type" = SalesLine."document type"::"Return Order" then
            exit(Location."Require Receive");

          exit(Location."Require Shipment");
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

    local procedure TransferTrackingSpecification(var FromTrackingSpec: Record "Tracking Specification";var ToTrackingSpec: Record "Tracking Specification")
    begin
        FromTrackingSpec.Reset;
        if FromTrackingSpec.FindSet then begin
          repeat
            ToTrackingSpec := FromTrackingSpec;
            if ToTrackingSpec.Insert then;
          until FromTrackingSpec.Next = 0;
          FromTrackingSpec.DeleteAll;
        end;
    end;

    local procedure InsertShptEntryRelation(var SalesShptLine: Record "Sales Shipment Line"): Integer
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        TransferTrackingSpecification(TempTrackingSpecificationInv,TempHandlingSpecification);
        TransferTrackingSpecification(TempATOTrackingSpecification,TempHandlingSpecification);

        TempHandlingSpecification.Reset;
        if TempHandlingSpecification.FindSet then begin
          repeat
            ItemEntryRelation.Init;
            ItemEntryRelation."Item Entry No." := TempHandlingSpecification."Entry No.";
            ItemEntryRelation."Serial No." := TempHandlingSpecification."Serial No.";
            ItemEntryRelation."Lot No." := TempHandlingSpecification."Lot No.";
            ItemEntryRelation.TransferFieldsSalesShptLine(SalesShptLine);
            ItemEntryRelation.Insert;
          until TempHandlingSpecification.Next = 0;
          TempHandlingSpecification.DeleteAll;
          exit(0);
        end;
        exit(ItemLedgShptEntryNo);
    end;

    local procedure InsertReturnEntryRelation(var ReturnRcptLine: Record "Return Receipt Line"): Integer
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        TransferTrackingSpecification(TempTrackingSpecificationInv,TempHandlingSpecification);
        TransferTrackingSpecification(TempATOTrackingSpecification,TempHandlingSpecification);

        TempHandlingSpecification.Reset;
        if TempHandlingSpecification.FindSet then begin
          repeat
            ItemEntryRelation.Init;
            ItemEntryRelation."Item Entry No." := TempHandlingSpecification."Entry No.";
            ItemEntryRelation."Serial No." := TempHandlingSpecification."Serial No.";
            ItemEntryRelation."Lot No." := TempHandlingSpecification."Lot No.";
            ItemEntryRelation.TransferFieldsReturnRcptLine(ReturnRcptLine);
            ItemEntryRelation.Insert;
          until TempHandlingSpecification.Next = 0;
          TempHandlingSpecification.DeleteAll;
          exit(0);
        end;
        exit(ItemLedgShptEntryNo);
    end;

    local procedure CheckTrackingSpecification(SalesHeader: Record "Sales Header";var TempItemSalesLine: Record "Sales Line" temporary)
    var
        ReservationEntry: Record "Reservation Entry";
        ItemTrackingCode: Record "Item Tracking Code";
        ItemJnlLine: Record "Item Journal Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ItemTrackingManagement: Codeunit "Item Tracking Management";
        ErrorFieldCaption: Text[250];
        SignFactor: Integer;
        SalesLineQtyToHandle: Decimal;
        TrackingQtyToHandle: Decimal;
        Inbound: Boolean;
        SNRequired: Boolean;
        LotRequired: Boolean;
        SNInfoRequired: Boolean;
        LotInfoRequired: Boolean;
        CheckSalesLine: Boolean;
    begin
        // if a SalesLine is posted with ItemTracking then tracked quantity must be equal to posted quantity
        if not (SalesHeader."Document Type" in
                [SalesHeader."document type"::Order,SalesHeader."document type"::"Return Order"])
        then
          exit;

        TrackingQtyToHandle := 0;

        with TempItemSalesLine do begin
          SetRange(Type,Type::Item);
          if SalesHeader.Ship then begin
            SetFilter("Quantity Shipped",'<>%1',0);
            ErrorFieldCaption := FieldCaption("Qty. to Ship");
          end else begin
            SetFilter("Return Qty. Received",'<>%1',0);
            ErrorFieldCaption := FieldCaption("Return Qty. to Receive");
          end;

          if FindSet then begin
            ReservationEntry."Source Type" := Database::"Sales Line";
            ReservationEntry."Source Subtype" := SalesHeader."Document Type";
            SignFactor := CreateReservEntry.SignFactor(ReservationEntry);
            repeat
              // Only Item where no SerialNo or LotNo is required
              GetItem(TempItemSalesLine);
              if Item."Item Tracking Code" <> '' then begin
                Inbound := (Quantity * SignFactor) > 0;
                ItemTrackingCode.Code := Item."Item Tracking Code";
                ItemTrackingManagement.GetItemTrackingSettings(ItemTrackingCode,
                  ItemJnlLine."entry type"::Sale,Inbound,
                  SNRequired,LotRequired,SNInfoRequired,LotInfoRequired);
                CheckSalesLine := (SNRequired = false) and (LotRequired = false);
                if CheckSalesLine then
                  CheckSalesLine := GetTrackingQuantities(TempItemSalesLine,0,TrackingQtyToHandle);
              end else
                CheckSalesLine := false;

              TrackingQtyToHandle := 0;

              if CheckSalesLine then begin
                GetTrackingQuantities(TempItemSalesLine,1,TrackingQtyToHandle);
                TrackingQtyToHandle := TrackingQtyToHandle * SignFactor;
                if SalesHeader.Ship then
                  SalesLineQtyToHandle := "Qty. to Ship (Base)"
                else
                  SalesLineQtyToHandle := "Return Qty. to Receive (Base)";
                if TrackingQtyToHandle <> SalesLineQtyToHandle then
                  Error(StrSubstNo(ItemTrackQuantityMismatchErr,ErrorFieldCaption));
              end;
            until Next = 0;
          end;
        end;
    end;

    local procedure GetTrackingQuantities(SalesLine: Record "Sales Line";FunctionType: Option CheckTrackingExists,GetQty;var TrackingQtyToHandle: Decimal): Boolean
    var
        TrackingSpecification: Record "Tracking Specification";
        ReservEntry: Record "Reservation Entry";
    begin
        with TrackingSpecification do begin
          SetCurrentkey("Source ID","Source Type","Source Subtype","Source Batch Name",
            "Source Prod. Order Line","Source Ref. No.");
          SetRange("Source Type",Database::"Sales Line");
          SetRange("Source Subtype",SalesLine."Document Type");
          SetRange("Source ID",SalesLine."Document No.");
          SetRange("Source Batch Name",'');
          SetRange("Source Prod. Order Line",0);
          SetRange("Source Ref. No.",SalesLine."Line No.");
        end;
        with ReservEntry do begin
          SetCurrentkey(
            "Source ID","Source Ref. No.","Source Type","Source Subtype",
            "Source Batch Name","Source Prod. Order Line");
          SetRange("Source ID",SalesLine."Document No.");
          SetRange("Source Ref. No.",SalesLine."Line No.");
          SetRange("Source Type",Database::"Sales Line");
          SetRange("Source Subtype",SalesLine."Document Type");
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

    local procedure InsertTrackingSpecification(SalesHeader: Record "Sales Header")
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        TempTrackingSpecification.Reset;
        if TempTrackingSpecification.FindSet then begin
          repeat
            TrackingSpecification := TempTrackingSpecification;
            TrackingSpecification."Buffer Status" := 0;
            TrackingSpecification.Correction := false;
            TrackingSpecification.InitQtyToShip;
            TrackingSpecification."Quantity actual Handled (Base)" := 0;
            if TempTrackingSpecification."Buffer Status" = TempTrackingSpecification."buffer status"::Modify then
              TrackingSpecification.Modify
            else
              TrackingSpecification.Insert;
          until TempTrackingSpecification.Next = 0;
          TempTrackingSpecification.DeleteAll;
          ReserveSalesLine.UpdateItemTrackingAfterPosting(SalesHeader);
        end;
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

    local procedure PostItemCharge(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";ItemEntryNo: Integer;QuantityBase: Decimal;AmountToAssign: Decimal;QtyToAssign: Decimal)
    var
        DummyTrackingSpecification: Record "Tracking Specification";
        SalesLineToPost: Record "Sales Line";
        CurrExchRate: Record "Currency Exchange Rate";
        TotalChargeAmt: Decimal;
        TotalChargeAmtLCY: Decimal;
    begin
        with TempItemChargeAssgntSales do begin
          SalesLineToPost := SalesLine;
          SalesLineToPost."No." := "Item No.";
          SalesLineToPost."Appl.-to Item Entry" := ItemEntryNo;
          if not ("Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"]) then
            SalesLineToPost.Amount := -AmountToAssign
          else
            SalesLineToPost.Amount := AmountToAssign;

          if SalesLineToPost."Currency Code" <> '' then
            SalesLineToPost."Unit Cost" := ROUND(
                -SalesLineToPost.Amount / QuantityBase,Currency."Unit-Amount Rounding Precision")
          else
            SalesLineToPost."Unit Cost" := ROUND(
                -SalesLineToPost.Amount / QuantityBase,GLSetup."Unit-Amount Rounding Precision");
          TotalChargeAmt := TotalChargeAmt + SalesLineToPost.Amount;

          if SalesHeader."Currency Code" <> '' then
            SalesLineToPost.Amount :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                UseDate,SalesHeader."Currency Code",TotalChargeAmt,SalesHeader."Currency Factor");
          SalesLineToPost."Inv. Discount Amount" := ROUND(
              SalesLine."Inv. Discount Amount" / SalesLine.Quantity * QtyToAssign,
              GLSetup."Amount Rounding Precision");
          SalesLineToPost."Line Discount Amount" := ROUND(
              SalesLine."Line Discount Amount" / SalesLine.Quantity * QtyToAssign,
              GLSetup."Amount Rounding Precision");
          SalesLineToPost."Line Amount" := ROUND(
              SalesLine."Line Amount" / SalesLine.Quantity * QtyToAssign,
              GLSetup."Amount Rounding Precision");
          SalesLine."Inv. Discount Amount" := SalesLine."Inv. Discount Amount" - SalesLineToPost."Inv. Discount Amount";
          SalesLine."Line Discount Amount" := SalesLine."Line Discount Amount" - SalesLineToPost."Line Discount Amount";
          SalesLine."Line Amount" := SalesLine."Line Amount" - SalesLineToPost."Line Amount";
          SalesLine.Quantity := SalesLine.Quantity - QtyToAssign;
          SalesLineToPost.Amount := ROUND(SalesLineToPost.Amount,GLSetup."Amount Rounding Precision") - TotalChargeAmtLCY;
          if SalesHeader."Currency Code" <> '' then
            TotalChargeAmtLCY := TotalChargeAmtLCY + SalesLineToPost.Amount;
          SalesLineToPost."Unit Cost (LCY)" := ROUND(
              SalesLineToPost.Amount / QuantityBase,GLSetup."Unit-Amount Rounding Precision");
          UpdateSalesLineDimSetIDFromAppliedEntry(SalesLineToPost,SalesLine);
          SalesLineToPost."Line No." := "Document Line No.";
          PostItemJnlLine(
            SalesHeader,SalesLineToPost,
            0,0,-QuantityBase,-QuantityBase,
            SalesLineToPost."Appl.-to Item Entry",
            "Item Charge No.",DummyTrackingSpecification,false);
        end;
    end;

    local procedure SaveTempWhseSplitSpec(var SalesLine3: Record "Sales Line";var TempSrcTrackingSpec: Record "Tracking Specification" temporary)
    begin
        TempWhseSplitSpecification.Reset;
        TempWhseSplitSpecification.DeleteAll;
        if TempSrcTrackingSpec.FindSet then
          repeat
            TempWhseSplitSpecification := TempSrcTrackingSpec;
            TempWhseSplitSpecification."Source Type" := Database::"Sales Line";
            TempWhseSplitSpecification."Source Subtype" := SalesLine3."Document Type";
            TempWhseSplitSpecification."Source ID" := SalesLine3."Document No.";
            TempWhseSplitSpecification."Source Ref. No." := SalesLine3."Line No.";
            TempWhseSplitSpecification.Insert;
          until TempSrcTrackingSpec.Next = 0;
    end;

    local procedure TransferReservToItemJnlLine(var SalesOrderLine: Record "Sales Line";var ItemJnlLine: Record "Item Journal Line";QtyToBeShippedBase: Decimal;var TempTrackingSpecification2: Record "Tracking Specification" temporary;var CheckApplFromItemEntry: Boolean)
    begin
        // Handle Item Tracking and reservations, also on drop shipment
        if QtyToBeShippedBase = 0 then
          exit;

        Clear(ReserveSalesLine);
        if not SalesOrderLine."Drop Shipment" then
          if not HasSpecificTracking(SalesOrderLine."No.") and HasInvtPickLine(SalesOrderLine) then
            ReserveSalesLine.TransferSalesLineToItemJnlLine(
              SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,true)
          else
            ReserveSalesLine.TransferSalesLineToItemJnlLine(
              SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,false)
        else begin
          TempTrackingSpecification2.Reset;
          TempTrackingSpecification2.SetRange("Source Type",Database::"Purchase Line");
          TempTrackingSpecification2.SetRange("Source Subtype",1);
          TempTrackingSpecification2.SetRange("Source ID",SalesOrderLine."Purchase Order No.");
          TempTrackingSpecification2.SetRange("Source Batch Name",'');
          TempTrackingSpecification2.SetRange("Source Prod. Order Line",0);
          TempTrackingSpecification2.SetRange("Source Ref. No.",SalesOrderLine."Purch. Order Line No.");
          if TempTrackingSpecification2.IsEmpty then
            ReserveSalesLine.TransferSalesLineToItemJnlLine(
              SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,false)
          else begin
            ReserveSalesLine.SetApplySpecificItemTracking(true);
            ReserveSalesLine.SetOverruleItemTracking(true);
            ReserveSalesLine.SetItemTrkgAlreadyOverruled(ItemTrkgAlreadyOverruled);
            TempTrackingSpecification2.FindSet;
            if TempTrackingSpecification2."Quantity (Base)" / QtyToBeShippedBase < 0 then
              Error(ItemTrackingWrongSignErr);
            repeat
              ItemJnlLine."Serial No." := TempTrackingSpecification2."Serial No.";
              ItemJnlLine."Lot No." := TempTrackingSpecification2."Lot No.";
              ItemJnlLine."Applies-to Entry" := TempTrackingSpecification2."Item Ledger Entry No.";
              ReserveSalesLine.TransferSalesLineToItemJnlLine(SalesOrderLine,ItemJnlLine,
                TempTrackingSpecification2."Quantity (Base)",CheckApplFromItemEntry,false);
            until TempTrackingSpecification2.Next = 0;
            ItemJnlLine."Serial No." := '';
            ItemJnlLine."Lot No." := '';
            ItemJnlLine."Applies-to Entry" := 0;
          end;
        end;
    end;

    local procedure TransferReservFromPurchLine(var PurchOrderLine: Record "Purchase Line";var ItemJnlLine: Record "Item Journal Line";SalesLine: Record "Sales Line";QtyToBeShippedBase: Decimal)
    var
        ReservEntry: Record "Reservation Entry";
        TempTrackingSpecification2: Record "Tracking Specification" temporary;
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        RemainingQuantity: Decimal;
        CheckApplToItemEntry: Boolean;
    begin
        // Handle Item Tracking on Drop Shipment
        ItemTrkgAlreadyOverruled := false;
        if QtyToBeShippedBase = 0 then
          exit;

        ReservEntry.SetCurrentkey(
          "Source ID","Source Ref. No.","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line");
        ReservEntry.SetRange("Source ID",SalesLine."Document No.");
        ReservEntry.SetRange("Source Ref. No.",SalesLine."Line No.");
        ReservEntry.SetRange("Source Type",Database::"Sales Line");
        ReservEntry.SetRange("Source Subtype",SalesLine."Document Type");
        ReservEntry.SetRange("Source Batch Name",'');
        ReservEntry.SetRange("Source Prod. Order Line",0);
        ReservEntry.SetFilter("Qty. to Handle (Base)",'<>0');
        if not ReservEntry.IsEmpty then
          ItemTrackingMgt.SumUpItemTracking(ReservEntry,TempTrackingSpecification2,false,true);
        TempTrackingSpecification2.SetFilter("Qty. to Handle (Base)",'<>0');
        if TempTrackingSpecification2.IsEmpty then
          ReservePurchLine.TransferPurchLineToItemJnlLine(
            PurchOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplToItemEntry)
        else begin
          ReservePurchLine.SetOverruleItemTracking(true);
          ItemTrkgAlreadyOverruled := true;
          TempTrackingSpecification2.FindSet;
          if -TempTrackingSpecification2."Quantity (Base)" / QtyToBeShippedBase < 0 then
            Error(ItemTrackingWrongSignErr);
          repeat
            ItemJnlLine."Serial No." := TempTrackingSpecification2."Serial No.";
            ItemJnlLine."Lot No." := TempTrackingSpecification2."Lot No.";
            RemainingQuantity :=
              ReservePurchLine.TransferPurchLineToItemJnlLine(
                PurchOrderLine,ItemJnlLine,
                -TempTrackingSpecification2."Qty. to Handle (Base)",CheckApplToItemEntry);
            if RemainingQuantity <> 0 then
              Error(ItemTrackingMismatchErr);
          until TempTrackingSpecification2.Next = 0;
          ItemJnlLine."Serial No." := '';
          ItemJnlLine."Lot No." := '';
          ItemJnlLine."Applies-to Entry" := 0;
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

    local procedure CopyPurchCommentLines(FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
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

    local procedure GetItem(SalesLine: Record "Sales Line")
    begin
        with SalesLine do begin
          TestField(Type,Type::Item);
          TestField("No.");
          if "No." <> Item."No." then
            Item.Get("No.");
        end;
    end;

    local procedure GetNextSalesline(var SalesLine: Record "Sales Line"): Boolean
    begin
        if not SalesLinesProcessed then
          if SalesLine.Next = 1 then
            exit(false);
        SalesLinesProcessed := true;
        if TempPrepaymentSalesLine.Find('-') then begin
          SalesLine := TempPrepaymentSalesLine;
          TempPrepaymentSalesLine.Delete;
          exit(false);
        end;
        exit(true);
    end;

    local procedure CreatePrepaymentLines(SalesHeader: Record "Sales Header";var TempPrepmtSalesLine: Record "Sales Line";CompleteFunctionality: Boolean)
    var
        GLAcc: Record "G/L Account";
        TempSalesLine: Record "Sales Line" temporary;
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
        with TempSalesLine do begin
          FillTempLines(SalesHeader);
          ResetTempLines(TempSalesLine);
          if not FindLast then
            exit;
          NextLineNo := "Line No." + 10000;
          SetFilter(Quantity,'>0');
          SetFilter("Qty. to Invoice",'>0');
          TempPrepmtSalesLine.SetHasBeenShown;
          if FindSet then begin
            if CompleteFunctionality and ("Document Type" = "document type"::Invoice) then
              TestGetShipmentPPmtAmtToDeduct;
            repeat
              if CompleteFunctionality then
                if SalesHeader."Document Type" <> SalesHeader."document type"::Invoice then begin
                  if not SalesHeader.Ship and ("Qty. to Invoice" = Quantity - "Quantity Invoiced") then
                    if "Qty. Shipped Not Invoiced" < "Qty. to Invoice" then
                      Validate("Qty. to Invoice","Qty. Shipped Not Invoiced");
                  Fraction := ("Qty. to Invoice" + "Quantity Invoiced") / Quantity;

                  if "Prepayment %" <> 100 then
                    case true of
                      ("Prepmt Amt to Deduct" <> 0) and
                      ("Prepmt Amt to Deduct" > ROUND(Fraction * "Line Amount",Currency."Amount Rounding Precision")):
                        FieldError(
                          "Prepmt Amt to Deduct",
                          StrSubstNo(CannotBeGreaterThanErr,
                            ROUND(Fraction * "Line Amount",Currency."Amount Rounding Precision")));
                      ("Prepmt. Amt. Inv." <> 0) and
                      (ROUND((1 - Fraction) * "Line Amount",Currency."Amount Rounding Precision") <
                       ROUND(
                         ROUND(
                           ROUND("Unit Price" * (Quantity - "Quantity Invoiced" - "Qty. to Invoice"),
                             Currency."Amount Rounding Precision") *
                           (1 - ("Line Discount %" / 100)),Currency."Amount Rounding Precision") *
                         "Prepayment %" / 100,Currency."Amount Rounding Precision")):
                        FieldError(
                          "Prepmt Amt to Deduct",
                          StrSubstNo(CannotBeSmallerThanErr,
                            ROUND(
                              "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" - (1 - Fraction) * "Line Amount",
                              Currency."Amount Rounding Precision")));
                    end;
                end;
              if "Prepmt Amt to Deduct" <> 0 then begin
                if ("Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") or
                   ("Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
                then begin
                  GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                  GenPostingSetup.TestField("Sales Prepayments Account");
                end;
                GLAcc.Get(GenPostingSetup."Sales Prepayments Account");
                TempLineFound := false;
                if SalesHeader."Compress Prepayment" then begin
                  TempPrepmtSalesLine.SetRange("No.",GLAcc."No.");
                  TempPrepmtSalesLine.SetRange("Dimension Set ID","Dimension Set ID");
                  TempLineFound := TempPrepmtSalesLine.FindFirst;
                end;
                if TempLineFound then begin
                  PrepmtAmtToDeduct :=
                    TempPrepmtSalesLine."Prepmt Amt to Deduct" +
                    InsertedPrepmtVATBaseToDeduct(
                      SalesHeader,TempSalesLine,TempPrepmtSalesLine."Line No.",TempPrepmtSalesLine."Unit Price");
                  VATDifference := TempPrepmtSalesLine."VAT Difference";
                  if SalesHeader."Prepmt. Include Tax" then
                    TempPrepmtSalesLine.Validate(
                      "Unit Price",
                      TempPrepmtSalesLine."Unit Price" + "Prepmt Amt to Deduct" * (1 + "VAT %" / 100))
                  else
                    TempPrepmtSalesLine.Validate(
                      "Unit Price",TempPrepmtSalesLine."Unit Price" + "Prepmt Amt to Deduct");
                  TempPrepmtSalesLine.Validate("VAT Difference",VATDifference - "Prepmt VAT Diff. to Deduct");
                  if SalesHeader."Prepmt. Include Tax" then
                    TempPrepmtSalesLine."Prepmt Amt to Deduct" += CalcAmountIncludingTax("Prepmt Amt to Deduct")
                  else
                    TempPrepmtSalesLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
                  if "Prepayment %" < TempPrepmtSalesLine."Prepayment %" then
                    TempPrepmtSalesLine."Prepayment %" := "Prepayment %";
                  TempPrepmtSalesLine.Modify;
                end else begin
                  TempPrepmtSalesLine.Init;
                  TempPrepmtSalesLine."Document Type" := SalesHeader."Document Type";
                  TempPrepmtSalesLine."Document No." := SalesHeader."No.";
                  TempPrepmtSalesLine."Line No." := 0;
                  TempPrepmtSalesLine."System-Created Entry" := true;
                  if CompleteFunctionality then
                    TempPrepmtSalesLine.Validate(Type,TempPrepmtSalesLine.Type::"G/L Account")
                  else
                    TempPrepmtSalesLine.Type := TempPrepmtSalesLine.Type::"G/L Account";
                  TempPrepmtSalesLine.Validate("No.",GenPostingSetup."Sales Prepayments Account");
                  TempPrepmtSalesLine.Validate(Quantity,-1);
                  TempPrepmtSalesLine."Qty. to Ship" := TempPrepmtSalesLine.Quantity;
                  TempPrepmtSalesLine."Qty. to Invoice" := TempPrepmtSalesLine.Quantity;
                  PrepmtAmtToDeduct := InsertedPrepmtVATBaseToDeduct(SalesHeader,TempSalesLine,NextLineNo,0);
                  if SalesHeader."Prepmt. Include Tax" then
                    TempPrepmtSalesLine.Validate("Unit Price","Prepmt Amt to Deduct" * (1 + "VAT %" / 100))
                  else
                    TempPrepmtSalesLine.Validate("Unit Price","Prepmt Amt to Deduct");
                  TempPrepmtSalesLine.Validate("VAT Difference",-"Prepmt VAT Diff. to Deduct");
                  if SalesHeader."Prepmt. Include Tax" then
                    TempPrepmtSalesLine."Prepmt Amt to Deduct" := CalcAmountIncludingTax("Prepmt Amt to Deduct")
                  else
                    TempPrepmtSalesLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
                  TempPrepmtSalesLine."Prepayment %" := "Prepayment %";
                  TempPrepmtSalesLine."Prepayment Line" := true;
                  TempPrepmtSalesLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                  TempPrepmtSalesLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                  TempPrepmtSalesLine."Dimension Set ID" := "Dimension Set ID";
                  TempPrepmtSalesLine."Line No." := NextLineNo;
                  NextLineNo := NextLineNo + 10000;
                  TempPrepmtSalesLine.Insert;

                  TransferExtText.PrepmtGetAnyExtText(
                    TempPrepmtSalesLine."No.",Database::"Sales Invoice Line",
                    SalesHeader."Document Date",SalesHeader."Language Code",TempExtTextLine);
                  if TempExtTextLine.Find('-') then
                    repeat
                      TempPrepmtSalesLine.Init;
                      TempPrepmtSalesLine.Description := TempExtTextLine.Text;
                      TempPrepmtSalesLine."System-Created Entry" := true;
                      TempPrepmtSalesLine."Prepayment Line" := true;
                      TempPrepmtSalesLine."Line No." := NextLineNo;
                      NextLineNo := NextLineNo + 10000;
                      TempPrepmtSalesLine.Insert;
                    until TempExtTextLine.Next = 0;
                end;
              end;
            until Next = 0
          end;
        end;
        DividePrepmtAmountLCY(TempPrepmtSalesLine,SalesHeader);

        if Is100PctPrepmtInvoice(TempPrepmtSalesLine) then
          TotalSalesLineLCY."Prepayment %" := 100;
    end;

    local procedure InsertedPrepmtVATBaseToDeduct(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";PrepmtLineNo: Integer;TotalPrepmtAmtToDeduct: Decimal): Decimal
    var
        PrepmtVATBaseToDeduct: Decimal;
    begin
        with SalesLine do begin
          if SalesHeader."Prices Including VAT" then
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
        with TempPrepmtDeductLCYSalesLine do begin
          TempPrepmtDeductLCYSalesLine := SalesLine;
          if "Document Type" = "document type"::Order then
            "Qty. to Invoice" := GetQtyToInvoice(SalesLine,SalesHeader.Ship)
          else
            GetLineDataFromOrder(TempPrepmtDeductLCYSalesLine);
          CalcPrepaymentToDeduct;
          if SalesHeader."Prepmt. Include Tax" then
            "Prepmt Amt to Deduct" := CalcAmountIncludingTax(SalesLine."Prepmt Amt to Deduct");
          "Line Amount" := GetLineAmountToHandle("Qty. to Invoice");
          "Attached to Line No." := PrepmtLineNo;
          "VAT Base Amount" := PrepmtVATBaseToDeduct;
          Insert;
        end;
        exit(PrepmtVATBaseToDeduct);
    end;

    local procedure DividePrepmtAmountLCY(var PrepmtSalesLine: Record "Sales Line";SalesHeader: Record "Sales Header")
    var
        CurrExchRate: Record "Currency Exchange Rate";
        ActualCurrencyFactor: Decimal;
    begin
        with PrepmtSalesLine do begin
          Reset;
          SetFilter(Type,'<>%1',Type::" ");
          if FindSet then
            repeat
              if SalesHeader."Currency Code" <> '' then
                ActualCurrencyFactor :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      SalesHeader."Posting Date",
                      SalesHeader."Currency Code",
                      "Prepmt Amt to Deduct",
                      SalesHeader."Currency Factor")) /
                  "Prepmt Amt to Deduct"
              else
                ActualCurrencyFactor := 1;

              if not SalesHeader."Prepmt. Include Tax" then
                UpdatePrepmtAmountInvBuf("Line No.",ActualCurrencyFactor);
            until Next = 0;
          Reset;
        end;
    end;

    local procedure UpdatePrepmtAmountInvBuf(PrepmtSalesLineNo: Integer;CurrencyFactor: Decimal)
    var
        PrepmtAmtRemainder: Decimal;
    begin
        with TempPrepmtDeductLCYSalesLine do begin
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

    local procedure AdjustPrepmtAmountLCY(SalesHeader: Record "Sales Header";var PrepmtSalesLine: Record "Sales Line")
    var
        SalesLine: Record "Sales Line";
        SalesInvoiceLine: Record "Sales Line";
        DeductionFactor: Decimal;
        PrepmtVATPart: Decimal;
        PrepmtVATAmtRemainder: Decimal;
        TotalRoundingAmount: array [2] of Decimal;
        TotalPrepmtAmount: array [2] of Decimal;
        FinalInvoice: Boolean;
        PricesInclVATRoundingAmount: array [2] of Decimal;
    begin
        if PrepmtSalesLine."Prepayment Line" then begin
          PrepmtVATPart :=
            (PrepmtSalesLine."Amount Including VAT" - PrepmtSalesLine.Amount) / PrepmtSalesLine."Unit Price";

          with TempPrepmtDeductLCYSalesLine do begin
            Reset;
            SetRange("Attached to Line No.",PrepmtSalesLine."Line No.");
            if FindSet(true) then begin
              FinalInvoice := IsFinalInvoice;
              repeat
                SalesLine := TempPrepmtDeductLCYSalesLine;
                SalesLine.Find;
                if "Document Type" = "document type"::Invoice then begin
                  SalesInvoiceLine := SalesLine;
                  GetSalesOrderLine(SalesLine,SalesInvoiceLine);
                  SalesLine."Qty. to Invoice" := SalesInvoiceLine."Qty. to Invoice";
                end;
                if (not SalesHeader."Prepmt. Include Tax") and (SalesLine."Qty. to Invoice" <> "Qty. to Invoice" ) then
                  SalesLine."Prepmt Amt to Deduct" := CalcPrepmtAmtToDeduct(SalesLine,SalesHeader.Ship);
                DeductionFactor :=
                  SalesLine."Prepmt Amt to Deduct" /
                  (SalesLine."Prepmt. Amt. Inv." - SalesLine."Prepmt Amt Deducted");

                "Prepmt. VAT Amount Inv. (LCY)" :=
                  CalcRoundedAmount(SalesLine."Prepmt Amt to Deduct" * PrepmtVATPart,PrepmtVATAmtRemainder);
                if ("Prepayment %" <> 100) or IsFinalInvoice or ("Currency Code" <> '') then
                  CalcPrepmtRoundingAmounts(TempPrepmtDeductLCYSalesLine,SalesLine,DeductionFactor,TotalRoundingAmount);
                Modify;

                if SalesHeader."Prices Including VAT" then
                  if (("Prepayment %" <> 100) or IsFinalInvoice) and (DeductionFactor = 1) then begin
                    PricesInclVATRoundingAmount[1] := TotalRoundingAmount[1];
                    PricesInclVATRoundingAmount[2] := TotalRoundingAmount[2];
                  end;

                if "VAT Calculation Type" <> "vat calculation type"::"Full VAT" then
                  if SalesHeader."Prepmt. Include Tax" and not IsFinalInvoice then
                    TotalPrepmtAmount[1] += "Prepmt Amt to Deduct"
                  else
                    TotalPrepmtAmount[1] += "Prepmt. Amount Inv. (LCY)";
                TotalPrepmtAmount[2] += "Prepmt. VAT Amount Inv. (LCY)";
                FinalInvoice := FinalInvoice and IsFinalInvoice;
              until Next = 0;
            end;
          end;

          UpdatePrepmtSalesLineWithRounding(
            PrepmtSalesLine,TotalRoundingAmount,TotalPrepmtAmount,
            FinalInvoice,PricesInclVATRoundingAmount);
        end;
    end;

    local procedure CalcPrepmtAmtToDeduct(SalesLine: Record "Sales Line";Ship: Boolean): Decimal
    begin
        with SalesLine do begin
          "Qty. to Invoice" := GetQtyToInvoice(SalesLine,Ship);
          CalcPrepaymentToDeduct;
          exit("Prepmt Amt to Deduct");
        end;
    end;

    local procedure GetQtyToInvoice(SalesLine: Record "Sales Line";Ship: Boolean): Decimal
    var
        AllowedQtyToInvoice: Decimal;
    begin
        with SalesLine do begin
          AllowedQtyToInvoice := "Qty. Shipped Not Invoiced";
          if Ship then
            AllowedQtyToInvoice := AllowedQtyToInvoice + "Qty. to Ship";
          if "Qty. to Invoice" > AllowedQtyToInvoice then
            exit(AllowedQtyToInvoice);
          exit("Qty. to Invoice");
        end;
    end;

    local procedure GetLineDataFromOrder(var SalesLine: Record "Sales Line")
    var
        SalesShptLine: Record "Sales Shipment Line";
        SalesOrderLine: Record "Sales Line";
    begin
        with SalesLine do begin
          SalesShptLine.Get("Shipment No.","Shipment Line No.");
          SalesOrderLine.Get("document type"::Order,SalesShptLine."Order No.",SalesShptLine."Order Line No.");

          Quantity := SalesOrderLine.Quantity;
          "Qty. Shipped Not Invoiced" := SalesOrderLine."Qty. Shipped Not Invoiced";
          "Quantity Invoiced" := SalesOrderLine."Quantity Invoiced";
          "Prepmt Amt Deducted" := SalesOrderLine."Prepmt Amt Deducted";
          "Prepmt. Amt. Inv." := SalesOrderLine."Prepmt. Amt. Inv.";
          "Line Discount Amount" := SalesOrderLine."Line Discount Amount";
        end;
    end;

    local procedure CalcPrepmtRoundingAmounts(var PrepmtSalesLineBuf: Record "Sales Line";SalesLine: Record "Sales Line";DeductionFactor: Decimal;var TotalRoundingAmount: array [2] of Decimal)
    var
        RoundingAmount: array [2] of Decimal;
    begin
        with PrepmtSalesLineBuf do begin
          if "VAT Calculation Type" <> "vat calculation type"::"Full VAT" then begin
            RoundingAmount[1] :=
              "Prepmt. Amount Inv. (LCY)" - ROUND(DeductionFactor * SalesLine."Prepmt. Amount Inv. (LCY)");
            "Prepmt. Amount Inv. (LCY)" := "Prepmt. Amount Inv. (LCY)" - RoundingAmount[1];
            TotalRoundingAmount[1] += RoundingAmount[1];
          end;
          RoundingAmount[2] :=
            "Prepmt. VAT Amount Inv. (LCY)" - ROUND(DeductionFactor * SalesLine."Prepmt. VAT Amount Inv. (LCY)");
          "Prepmt. VAT Amount Inv. (LCY)" := "Prepmt. VAT Amount Inv. (LCY)" - RoundingAmount[2];
          TotalRoundingAmount[2] += RoundingAmount[2];
        end;
    end;

    local procedure UpdatePrepmtSalesLineWithRounding(var PrepmtSalesLine: Record "Sales Line";TotalRoundingAmount: array [2] of Decimal;TotalPrepmtAmount: array [2] of Decimal;FinalInvoice: Boolean;PricesInclVATRoundingAmount: array [2] of Decimal)
    var
        NewAmountIncludingVAT: Decimal;
        Prepmt100PctVATRoundingAmt: Decimal;
        AmountRoundingPrecision: Decimal;
    begin
        with PrepmtSalesLine do begin
          NewAmountIncludingVAT := TotalPrepmtAmount[1] + TotalPrepmtAmount[2] + TotalRoundingAmount[1] + TotalRoundingAmount[2];
          if "Prepayment %" = 100 then
            TotalRoundingAmount[1] += "Amount Including VAT" - NewAmountIncludingVAT;
          AmountRoundingPrecision :=
            GetAmountRoundingPrecisionInLCY("Document Type","Document No.","Currency Code");

          if Abs(TotalRoundingAmount[1]) <= AmountRoundingPrecision then begin
            if "Prepayment %" = 100 then
              Prepmt100PctVATRoundingAmt := TotalRoundingAmount[1];
            TotalRoundingAmount[1] := 0;
          end;
          "Prepmt. Amount Inv. (LCY)" := TotalRoundingAmount[1];
          Amount := TotalPrepmtAmount[1] + TotalRoundingAmount[1];

          if (PricesInclVATRoundingAmount[1] <> 0) and (TotalRoundingAmount[1] = 0) then begin
            if ("Prepayment %" = 100) and FinalInvoice and
               (Amount + TotalPrepmtAmount[2] = "Amount Including VAT")
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

          "Prepmt. VAT Amount Inv. (LCY)" := TotalRoundingAmount[2] + Prepmt100PctVATRoundingAmt;
          NewAmountIncludingVAT := Amount + TotalPrepmtAmount[2] + TotalRoundingAmount[2];
          if (PricesInclVATRoundingAmount[1] = 0) and (PricesInclVATRoundingAmount[2] = 0) or
             ("Currency Code" <> '') and FinalInvoice
          then
            Increment(
              TotalSalesLineLCY."Amount Including VAT",
              "Amount Including VAT" - NewAmountIncludingVAT - Prepmt100PctVATRoundingAmt);
          if "Currency Code" = '' then
            TotalSalesLine."Amount Including VAT" := TotalSalesLineLCY."Amount Including VAT";
          "Amount Including VAT" := NewAmountIncludingVAT;

          if FinalInvoice and (TotalSalesLine.Amount = 0) and (TotalSalesLine."Amount Including VAT" <> 0) and
             (Abs(TotalSalesLine."Amount Including VAT") <= Currency."Amount Rounding Precision")
          then begin
            "Amount Including VAT" += TotalSalesLineLCY."Amount Including VAT";
            TotalSalesLine."Amount Including VAT" := 0;
            TotalSalesLineLCY."Amount Including VAT" := 0;
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

    local procedure GetSalesOrderLine(var SalesOrderLine: Record "Sales Line";SalesLine: Record "Sales Line")
    var
        SalesShptLine: Record "Sales Shipment Line";
    begin
        SalesShptLine.Get(SalesLine."Shipment No.",SalesLine."Shipment Line No.");
        SalesOrderLine.Get(
          SalesOrderLine."document type"::Order,
          SalesShptLine."Order No.",SalesShptLine."Order Line No.");
        SalesOrderLine."Prepmt Amt to Deduct" := SalesLine."Prepmt Amt to Deduct";
    end;

    local procedure Is100PctPrepmtInvoice(var TempSalesLine: Record "Sales Line" temporary) Result: Boolean
    begin
        if TempSalesLine.IsEmpty then
          exit(false);
        TempSalesLine.SetFilter("Prepayment %",'<100');
        Result := TempSalesLine.IsEmpty;
        TempSalesLine.SetRange("Prepayment %");
    end;

    local procedure DecrementPrepmtAmtInvLCY(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";var PrepmtAmountInvLCY: Decimal;var PrepmtVATAmountInvLCY: Decimal)
    begin
        TempPrepmtDeductLCYSalesLine.Reset;
        TempPrepmtDeductLCYSalesLine := SalesLine;
        if TempPrepmtDeductLCYSalesLine.Find then begin
          if SalesHeader."Prepmt. Include Tax" then
            PrepmtAmountInvLCY := PrepmtAmountInvLCY - TempPrepmtDeductLCYSalesLine."Prepmt Amt to Deduct"
          else
            PrepmtAmountInvLCY := PrepmtAmountInvLCY - TempPrepmtDeductLCYSalesLine."Prepmt. Amount Inv. (LCY)";
          PrepmtVATAmountInvLCY := PrepmtVATAmountInvLCY - TempPrepmtDeductLCYSalesLine."Prepmt. VAT Amount Inv. (LCY)";
        end;
    end;

    local procedure AdjustFinalInvWith100PctPrepmt(var CombinedSalesLine: Record "Sales Line")
    var
        DiffToLineDiscAmt: Decimal;
    begin
        with TempPrepmtDeductLCYSalesLine do begin
          Reset;
          SetRange("Prepayment %",100);
          if FindSet(true) then
            repeat
              if IsFinalInvoice then begin
                DiffToLineDiscAmt := "Prepmt Amt to Deduct" - "Line Amount";
                if "Document Type" = "document type"::Order then
                  DiffToLineDiscAmt := DiffToLineDiscAmt * Quantity / "Qty. to Invoice";
                if DiffToLineDiscAmt <> 0 then begin
                  CombinedSalesLine.Get("Document Type","Document No.","Line No.");
                  CombinedSalesLine."Line Discount Amount" -= DiffToLineDiscAmt;
                  CombinedSalesLine.Modify;

                  "Line Discount Amount" := CombinedSalesLine."Line Discount Amount";
                  Modify;
                end;
              end;
            until Next = 0;
          Reset;
        end;
    end;

    local procedure GetPrepmtDiffToLineAmount(SalesLine: Record "Sales Line"): Decimal
    begin
        with TempPrepmtDeductLCYSalesLine do
          if SalesLine."Prepayment %" = 100 then
            if Get(SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.") then
              exit("Prepmt Amt to Deduct" - "Line Amount");
        exit(0);
    end;

    local procedure MergeSaleslines(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";var SalesLine2: Record "Sales Line";var MergedSalesLine: Record "Sales Line")
    begin
        with SalesLine do begin
          SetRange("Document Type",SalesHeader."Document Type");
          SetRange("Document No.",SalesHeader."No.");
          if Find('-') then
            repeat
              MergedSalesLine := SalesLine;
              MergedSalesLine.Insert;
            until Next = 0;
        end;
        with SalesLine2 do begin
          SetRange("Document Type",SalesHeader."Document Type");
          SetRange("Document No.",SalesHeader."No.");
          if Find('-') then
            repeat
              MergedSalesLine := SalesLine2;
              MergedSalesLine.Insert;
            until Next = 0;
        end;
    end;

    local procedure PostJobContractLine(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line")
    begin
        if SalesLine."Job Contract Entry No." = 0 then
          exit;
        if (SalesHeader."Document Type" <> SalesHeader."document type"::Invoice) and
           (SalesHeader."Document Type" <> SalesHeader."document type"::"Credit Memo")
        then
          SalesLine.TestField("Job Contract Entry No.",0);

        SalesLine.TestField("Job No.");
        SalesLine.TestField("Job Task No.");

        if SalesHeader."Document Type" = SalesHeader."document type"::Invoice then
          SalesLine."Document No." := SalesInvHeader."No.";
        if SalesHeader."Document Type" = SalesHeader."document type"::"Credit Memo" then
          SalesLine."Document No." := SalesCrMemoHeader."No.";
        JobContractLine := true;
        JobPostLine.PostInvoiceContractLine(SalesHeader,SalesLine);
    end;

    local procedure InsertICGenJnlLine(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";var ICGenJnlLineNo: Integer)
    var
        ICGLAccount: Record "IC G/L Account";
        Vend: Record Vendor;
        ICPartner: Record "IC Partner";
        CurrExchRate: Record "Currency Exchange Rate";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        SalesHeader.TestField("Sell-to IC Partner Code",'');
        SalesHeader.TestField("Bill-to IC Partner Code",'');
        SalesLine.TestField("IC Partner Ref. Type",SalesLine."ic partner ref. type"::"G/L Account");
        ICGLAccount.Get(SalesLine."IC Partner Reference");
        ICGenJnlLineNo := ICGenJnlLineNo + 1;
        TempICGenJnlLine.Init;
        TempICGenJnlLine."Line No." := ICGenJnlLineNo;
        TempICGenJnlLine.Validate("Posting Date",SalesHeader."Posting Date");
        TempICGenJnlLine."Document Date" := SalesHeader."Document Date";
        TempICGenJnlLine.Description := SalesHeader."Posting Description";
        TempICGenJnlLine."Reason Code" := SalesHeader."Reason Code";
        TempICGenJnlLine."Document Type" := GenJnlLineDocType;
        TempICGenJnlLine."Document No." := GenJnlLineDocNo;
        TempICGenJnlLine."External Document No." := GenJnlLineExtDocNo;
        TempICGenJnlLine.Validate("Account Type",TempICGenJnlLine."account type"::"IC Partner");
        TempICGenJnlLine.Validate("Account No.",SalesLine."IC Partner Code");
        TempICGenJnlLine."Source Currency Code" := SalesHeader."Currency Code";
        TempICGenJnlLine."Source Currency Amount" := TempICGenJnlLine.Amount;
        TempICGenJnlLine.Correction := SalesHeader.Correction;
        TempICGenJnlLine."Source Code" := SrcCode;
        TempICGenJnlLine."Country/Region Code" := SalesHeader."VAT Country/Region Code";
        TempICGenJnlLine."Source Type" := GenJnlLine."source type"::Customer;
        TempICGenJnlLine."Source No." := SalesHeader."Bill-to Customer No.";
        TempICGenJnlLine."Source Line No." := SalesLine."Line No.";
        TempICGenJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
        TempICGenJnlLine.Validate("Bal. Account Type",TempICGenJnlLine."bal. account type"::"G/L Account");
        TempICGenJnlLine.Validate("Bal. Account No.",SalesLine."No.");
        TempICGenJnlLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
        TempICGenJnlLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
        TempICGenJnlLine."Dimension Set ID" := SalesLine."Dimension Set ID";
        Vend.SetRange("IC Partner Code",SalesLine."IC Partner Code");
        if Vend.FindFirst then begin
          TempICGenJnlLine.Validate("Bal. Gen. Bus. Posting Group",Vend."Gen. Bus. Posting Group");
          TempICGenJnlLine.Validate("Bal. VAT Bus. Posting Group",Vend."VAT Bus. Posting Group");
        end;
        TempICGenJnlLine.Validate("Bal. VAT Prod. Posting Group",SalesLine."VAT Prod. Posting Group");
        TempICGenJnlLine."IC Partner Code" := SalesLine."IC Partner Code";
        TempICGenJnlLine."IC Partner G/L Acc. No." := SalesLine."IC Partner Reference";
        TempICGenJnlLine."IC Direction" := TempICGenJnlLine."ic direction"::Outgoing;
        ICPartner.Get(SalesLine."IC Partner Code");
        if ICPartner."Cost Distribution in LCY" and (SalesLine."Currency Code" <> '') then begin
          TempICGenJnlLine."Currency Code" := '';
          TempICGenJnlLine."Currency Factor" := 0;
          Currency.Get(SalesLine."Currency Code");
          if SalesHeader.IsCreditDocType then
            TempICGenJnlLine.Amount :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  SalesHeader."Posting Date",SalesLine."Currency Code",
                  SalesLine.Amount,SalesHeader."Currency Factor"))
          else
            TempICGenJnlLine.Amount :=
              -ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  SalesHeader."Posting Date",SalesLine."Currency Code",
                  SalesLine.Amount,SalesHeader."Currency Factor"));
        end else begin
          Currency.InitRoundingPrecision;
          TempICGenJnlLine."Currency Code" := SalesHeader."Currency Code";
          TempICGenJnlLine."Currency Factor" := SalesHeader."Currency Factor";
          if SalesHeader.IsCreditDocType then
            TempICGenJnlLine.Amount := SalesLine.Amount
          else
            TempICGenJnlLine.Amount := -SalesLine.Amount;
        end;
        TempICGenJnlLine."Bal. VAT Calculation Type" := SalesLine."VAT Calculation Type";
        TempICGenJnlLine."Bal. Tax Area Code" := SalesLine."Tax Area Code";
        TempICGenJnlLine."Bal. Tax Liable" := SalesLine."Tax Liable";
        TempICGenJnlLine."Bal. Tax Group Code" := SalesLine."Tax Group Code";
        TempICGenJnlLine.Validate("Bal. VAT %");
        if TempICGenJnlLine."Bal. VAT %" <> 0 then
          TempICGenJnlLine.Amount := ROUND(TempICGenJnlLine.Amount * (1 + TempICGenJnlLine."Bal. VAT %" / 100),
              Currency."Amount Rounding Precision");
        TempICGenJnlLine.Validate(Amount);
        TempICGenJnlLine.Insert;
    end;

    local procedure PostICGenJnl()
    var
        ICInOutBoxMgt: Codeunit ICInboxOutboxMgt;
        ICTransactionNo: Integer;
    begin
        TempICGenJnlLine.Reset;
        TempICGenJnlLine.SetFilter(Amount,'<>%1',0);
        if TempICGenJnlLine.Find('-') then
          repeat
            ICTransactionNo := ICInOutBoxMgt.CreateOutboxJnlTransaction(TempICGenJnlLine,false);
            ICInOutBoxMgt.CreateOutboxJnlLine(ICTransactionNo,1,TempICGenJnlLine);
            GenJnlPostLine.RunWithCheck(TempICGenJnlLine);
          until TempICGenJnlLine.Next = 0;
    end;

    local procedure AddSalesTaxLineToSalesTaxCalc(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";FirstLine: Boolean)
    var
        MaxInvQty: Decimal;
        MaxInvQtyBase: Decimal;
    begin
        if FirstLine then begin
          TempSalesLineForSalesTax.DeleteAll;
          TempSalesTaxAmtLine.DeleteAll;
          SalesTaxCalculate.StartSalesTaxCalculation;
        end;
        TempSalesLineForSalesTax := SalesLine;
        with TempSalesLineForSalesTax do begin
          if "Qty. per Unit of Measure" = 0 then
            "Qty. per Unit of Measure" := 1;
          if ("Document Type" = "document type"::Invoice) and ("Shipment No." <> '') then begin
            "Quantity Shipped" := Quantity;
            "Qty. Shipped (Base)" := "Quantity (Base)";
            "Qty. to Ship" := 0;
            "Qty. to Ship (Base)" := 0;
          end;
          if ("Document Type" = "document type"::"Credit Memo") and ("Return Receipt No." <> '') then begin
            "Return Qty. Received" := Quantity;
            "Return Qty. Received (Base)" := "Quantity (Base)";
            "Return Qty. to Receive" := 0;
            "Return Qty. to Receive (Base)" := 0;
          end;
          if "Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"] then begin
            MaxInvQty := ("Return Qty. Received" - "Quantity Invoiced");
            MaxInvQtyBase := ("Return Qty. Received (Base)" - "Qty. Invoiced (Base)");
            if SalesHeader.Receive then begin
              MaxInvQty := MaxInvQty + "Return Qty. to Receive";
              MaxInvQtyBase := MaxInvQtyBase + "Return Qty. to Receive (Base)";
            end;
          end else begin
            MaxInvQty := ("Quantity Shipped" - "Quantity Invoiced");
            MaxInvQtyBase := ("Qty. Shipped (Base)" - "Qty. Invoiced (Base)");
            if SalesHeader.Ship then begin
              MaxInvQty := MaxInvQty + "Qty. to Ship";
              MaxInvQtyBase := MaxInvQtyBase + "Qty. to Ship (Base)";
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
          "Line Amount" := ROUND("Qty. to Invoice" * "Unit Price",Currency."Amount Rounding Precision");
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
          SalesTaxCalculate.AddSalesLine(TempSalesLineForSalesTax);
    end;

    local procedure TestGetShipmentPPmtAmtToDeduct()
    var
        TempSalesLine: Record "Sales Line" temporary;
        TempShippedSalesLine: Record "Sales Line" temporary;
        TempTotalSalesLine: Record "Sales Line" temporary;
        TempSalesShptLine: Record "Sales Shipment Line" temporary;
        SalesShptLine: Record "Sales Shipment Line";
        MaxAmtToDeduct: Decimal;
    begin
        with TempSalesLine do begin
          ResetTempLines(TempSalesLine);
          SetFilter(Quantity,'>0');
          SetFilter("Qty. to Invoice",'>0');
          SetFilter("Shipment No.",'<>%1','');
          SetFilter("Prepmt Amt to Deduct",'<>0');
          if IsEmpty then
            exit;

          SetRange("Prepmt Amt to Deduct");
          if FindSet then
            repeat
              if SalesShptLine.Get("Shipment No.","Shipment Line No.") then begin
                TempShippedSalesLine := TempSalesLine;
                TempShippedSalesLine.Insert;
                TempSalesShptLine := SalesShptLine;
                if TempSalesShptLine.Insert then;

                if not TempTotalSalesLine.Get("document type"::Order,SalesShptLine."Order No.",SalesShptLine."Order Line No.") then begin
                  TempTotalSalesLine.Init;
                  TempTotalSalesLine."Document Type" := "document type"::Order;
                  TempTotalSalesLine."Document No." := SalesShptLine."Order No.";
                  TempTotalSalesLine."Line No." := SalesShptLine."Order Line No.";
                  TempTotalSalesLine.Insert;
                end;
                TempTotalSalesLine."Qty. to Invoice" := TempTotalSalesLine."Qty. to Invoice" + "Qty. to Invoice";
                TempTotalSalesLine."Prepmt Amt to Deduct" := TempTotalSalesLine."Prepmt Amt to Deduct" + "Prepmt Amt to Deduct";
                AdjustInvLineWith100PctPrepmt(TempSalesLine,TempTotalSalesLine);
                TempTotalSalesLine.Modify;
              end;
            until Next = 0;

          if TempShippedSalesLine.FindSet then
            repeat
              if TempSalesShptLine.Get(TempShippedSalesLine."Shipment No.",TempShippedSalesLine."Shipment Line No.") then
                if Get(TempShippedSalesLine."document type"::Order,TempSalesShptLine."Order No.",TempSalesShptLine."Order Line No.") then
                  if TempTotalSalesLine.Get(
                       TempShippedSalesLine."document type"::Order,TempSalesShptLine."Order No.",TempSalesShptLine."Order Line No.")
                  then begin
                    MaxAmtToDeduct := "Prepmt. Amt. Inv." - "Prepmt Amt Deducted";

                    if TempTotalSalesLine."Prepmt Amt to Deduct" > MaxAmtToDeduct then
                      Error(StrSubstNo(PrepAmountToDeductToBigErr,FieldCaption("Prepmt Amt to Deduct"),MaxAmtToDeduct));

                    if (TempTotalSalesLine."Qty. to Invoice" = Quantity - "Quantity Invoiced") and
                       (TempTotalSalesLine."Prepmt Amt to Deduct" <> MaxAmtToDeduct)
                    then
                      Error(StrSubstNo(PrepAmountToDeductToSmallErr,FieldCaption("Prepmt Amt to Deduct"),MaxAmtToDeduct));
                  end;
            until TempShippedSalesLine.Next = 0;
        end;
    end;

    local procedure AdjustInvLineWith100PctPrepmt(var SalesInvoiceLine: Record "Sales Line";var TempTotalSalesLine: Record "Sales Line" temporary)
    var
        SalesOrderLine: Record "Sales Line";
        DiffAmtToDeduct: Decimal;
    begin
        if SalesInvoiceLine."Prepayment %" = 100 then begin
          SalesOrderLine := TempTotalSalesLine;
          SalesOrderLine.Find;
          if TempTotalSalesLine."Qty. to Invoice" = SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced" then begin
            DiffAmtToDeduct :=
              SalesOrderLine."Prepmt. Amt. Inv." - SalesOrderLine."Prepmt Amt Deducted" - TempTotalSalesLine."Prepmt Amt to Deduct";
            if DiffAmtToDeduct <> 0 then begin
              SalesInvoiceLine."Prepmt Amt to Deduct" := SalesInvoiceLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
              SalesInvoiceLine."Line Amount" := SalesInvoiceLine."Prepmt Amt to Deduct";
              SalesInvoiceLine."Line Discount Amount" := SalesInvoiceLine."Line Discount Amount" - DiffAmtToDeduct;
              ModifyTempLine(SalesInvoiceLine);
              TempTotalSalesLine."Prepmt Amt to Deduct" := TempTotalSalesLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
            end;
          end;
        end;
    end;


    procedure ArchiveUnpostedOrder(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        SalesSetup.Get;
        if not SalesSetup."Archive Quotes and Orders" then
          exit;
        if not (SalesHeader."Document Type" in [SalesHeader."document type"::Order,SalesHeader."document type"::"Return Order"]) then
          exit;

        SalesLine.Reset;
        SalesLine.SetRange("Document Type",SalesHeader."Document Type");
        SalesLine.SetRange("Document No.",SalesHeader."No.");
        SalesLine.SetFilter(Quantity,'<>0');
        if SalesHeader."Document Type" = SalesHeader."document type"::Order then
          SalesLine.SetFilter("Qty. to Ship",'<>0')
        else
          SalesLine.SetFilter("Return Qty. to Receive",'<>0');
        if not SalesLine.IsEmpty and not PreviewMode then begin
          RoundDeferralsForArchive(SalesHeader,SalesLine);
          ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);
        end;
    end;

    local procedure SynchBOMSerialNo(var ServItemTmp3: Record "Service Item" temporary;var ServItemTmpCmp3: Record "Service Item Component" temporary)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemLedgEntry2: Record "Item Ledger Entry";
        TempSalesShipMntLine: Record "Sales Shipment Line" temporary;
        ServItemTmpCmp4: Record "Service Item Component" temporary;
        ServItemCompLocal: Record "Service Item Component";
        TempItemLedgEntry2: Record "Item Ledger Entry" temporary;
        ChildCount: Integer;
        EndLoop: Boolean;
    begin
        if not ServItemTmpCmp3.Find('-') then
          exit;

        if not ServItemTmp3.Find('-') then
          exit;

        TempSalesShipMntLine.DeleteAll;
        repeat
          Clear(TempSalesShipMntLine);
          TempSalesShipMntLine."Document No." := ServItemTmp3."Sales/Serv. Shpt. Document No.";
          TempSalesShipMntLine."Line No." := ServItemTmp3."Sales/Serv. Shpt. Line No.";
          if TempSalesShipMntLine.Insert then;
        until ServItemTmp3.Next = 0;

        if not TempSalesShipMntLine.Find('-') then
          exit;

        ServItemTmp3.SetCurrentkey("Sales/Serv. Shpt. Document No.","Sales/Serv. Shpt. Line No.");
        Clear(ItemLedgEntry);
        ItemLedgEntry.SetCurrentkey("Document No.","Document Type","Document Line No.");

        repeat
          ChildCount := 0;
          ServItemTmpCmp4.DeleteAll;
          ServItemTmp3.SetRange("Sales/Serv. Shpt. Document No.",TempSalesShipMntLine."Document No.");
          ServItemTmp3.SetRange("Sales/Serv. Shpt. Line No.",TempSalesShipMntLine."Line No.");
          if ServItemTmp3.Find('-') then
            repeat
              ServItemTmpCmp3.SetRange(Active,true);
              ServItemTmpCmp3.SetRange("Parent Service Item No.",ServItemTmp3."No.");
              if ServItemTmpCmp3.Find('-') then
                repeat
                  ChildCount += 1;
                  ServItemTmpCmp4 := ServItemTmpCmp3;
                  ServItemTmpCmp4.Insert;
                until ServItemTmpCmp3.Next = 0;
            until ServItemTmp3.Next = 0;
          ItemLedgEntry.SetRange("Document No.",TempSalesShipMntLine."Document No.");
          ItemLedgEntry.SetRange("Document Type",ItemLedgEntry."document type"::"Sales Shipment");
          ItemLedgEntry.SetRange("Document Line No.",TempSalesShipMntLine."Line No.");
          if ItemLedgEntry.FindFirst and ServItemTmpCmp4.Find('-') then begin
            Clear(ItemLedgEntry2);
            ItemLedgEntry2.Get(ItemLedgEntry."Entry No.");
            EndLoop := false;
            repeat
              if ItemLedgEntry2."Item No." = ServItemTmpCmp4."No." then
                EndLoop := true
              else
                if ItemLedgEntry2.Next = 0 then
                  EndLoop := true;
            until EndLoop;
            ItemLedgEntry2.SetRange("Entry No.",ItemLedgEntry2."Entry No.",ItemLedgEntry2."Entry No." + ChildCount - 1);
            if ItemLedgEntry2.FindSet then
              repeat
                TempItemLedgEntry2 := ItemLedgEntry2;
                TempItemLedgEntry2.Insert;
              until ItemLedgEntry2.Next = 0;
            repeat
              if ServItemCompLocal.Get(
                   ServItemTmpCmp4.Active,
                   ServItemTmpCmp4."Parent Service Item No.",
                   ServItemTmpCmp4."Line No.")
              then begin
                TempItemLedgEntry2.SetRange("Item No.",ServItemCompLocal."No.");
                if TempItemLedgEntry2.FindFirst then begin
                  ServItemCompLocal."Serial No." := TempItemLedgEntry2."Serial No.";
                  ServItemCompLocal.Modify;
                  TempItemLedgEntry2.Delete;
                end;
              end;
            until ServItemTmpCmp4.Next = 0;
          end;
        until TempSalesShipMntLine.Next = 0;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
          GLSetup.Get;
        GLSetupRead := true;
    end;

    local procedure LockTables()
    var
        SalesLine: Record "Sales Line";
        PurchOrderHeader: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";
    begin
        SalesLine.LockTable;
        ItemChargeAssgntSales.LockTable;
        PurchOrderLine.LockTable;
        PurchOrderHeader.LockTable;
        GetGLSetup;
        if not GLSetup.OptimGLEntLockForMultiuserEnv then begin
          GLEntry.LockTable;
          if GLEntry.FindLast then;
        end;
    end;

    local procedure PostCustomerEntry(SalesHeader: Record "Sales Header";TotalSalesLine2: Record "Sales Line";TotalSalesLineLCY2: Record "Sales Line";DocType: Option;DocNo: Code[20];ExtDocNo: Code[35];SourceCode: Code[10])
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        with GenJnlLine do begin
          InitNewLine(
            SalesHeader."Posting Date",SalesHeader."Document Date",SalesHeader."Posting Description",
            SalesHeader."Shortcut Dimension 1 Code",SalesHeader."Shortcut Dimension 2 Code",
            SalesHeader."Dimension Set ID",SalesHeader."Reason Code");

          CopyDocumentFields(DocType,DocNo,ExtDocNo,SourceCode,'');
          "Account Type" := "account type"::Customer;
          "Account No." := SalesHeader."Bill-to Customer No.";
          CopyFromSalesHeader(SalesHeader);
          SetCurrencyFactor(SalesHeader."Currency Code",SalesHeader."Currency Factor");

          "System-Created Entry" := true;

          CopyFromSalesHeaderApplyTo(SalesHeader);
          CopyFromSalesHeaderPayment(SalesHeader);

          Amount := -TotalSalesLine2."Amount Including VAT";
          "Source Currency Amount" := -TotalSalesLine2."Amount Including VAT";
          "Amount (LCY)" := -TotalSalesLineLCY2."Amount Including VAT";
          "Sales/Purch. (LCY)" := -TotalSalesLineLCY2.Amount;
          "Profit (LCY)" := -(TotalSalesLineLCY2.Amount - TotalSalesLineLCY2."Unit Cost (LCY)");
          "Inv. Discount (LCY)" := -TotalSalesLineLCY2."Inv. Discount Amount";

          GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;
    end;

    local procedure UpdateSalesHeader(var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        case GenJnlLineDocType of
          GenJnlLine."document type"::Invoice:
            begin
              FindCustLedgEntry(GenJnlLineDocType,GenJnlLineDocNo,CustLedgerEntry);
              SalesInvHeader."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
              SalesInvHeader.Modify;
            end;
          GenJnlLine."document type"::"Credit Memo":
            begin
              FindCustLedgEntry(GenJnlLineDocType,GenJnlLineDocNo,CustLedgerEntry);
              SalesCrMemoHeader."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
              SalesCrMemoHeader.Modify;
            end;
        end;
    end;

    local procedure "MAX"(number1: Integer;number2: Integer): Integer
    begin
        if number1 > number2 then
          exit(number1);
        exit(number2);
    end;

    local procedure PostBalancingEntry(SalesHeader: Record "Sales Header";TotalSalesLine2: Record "Sales Line";TotalSalesLineLCY2: Record "Sales Line";DocType: Option;DocNo: Code[20];ExtDocNo: Code[35];SourceCode: Code[10])
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        FindCustLedgEntry(DocType,DocNo,CustLedgEntry);

        with GenJnlLine do begin
          InitNewLine(
            SalesHeader."Posting Date",SalesHeader."Document Date",SalesHeader."Posting Description",
            SalesHeader."Shortcut Dimension 1 Code",SalesHeader."Shortcut Dimension 2 Code",
            SalesHeader."Dimension Set ID",SalesHeader."Reason Code");

          CopyDocumentFields(0,DocNo,ExtDocNo,SourceCode,'');
          CopyFromSalesHeader(SalesHeader);
          "Account Type" := "account type"::Customer;
          "Account No." := SalesHeader."Bill-to Customer No.";
          SetCurrencyFactor(SalesHeader."Currency Code",SalesHeader."Currency Factor");

          if SalesHeader.IsCreditDocType then
            "Document Type" := "document type"::Refund
          else
            "Document Type" := "document type"::Payment;

          SetApplyToDocNo(SalesHeader,GenJnlLine,DocType,DocNo);

          Amount := TotalSalesLine2."Amount Including VAT" + CustLedgEntry."Remaining Pmt. Disc. Possible";
          "Source Currency Amount" := Amount;
          CustLedgEntry.CalcFields(Amount);
          if CustLedgEntry.Amount = 0 then
            "Amount (LCY)" := TotalSalesLineLCY2."Amount Including VAT"
          else
            "Amount (LCY)" :=
              TotalSalesLineLCY2."Amount Including VAT" +
              ROUND(CustLedgEntry."Remaining Pmt. Disc. Possible" / CustLedgEntry."Adjusted Currency Factor");
          "Allow Zero-Amount Posting" := true;

          GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;
    end;

    local procedure SetApplyToDocNo(SalesHeader: Record "Sales Header";var GenJnlLine: Record "Gen. Journal Line";DocType: Option;DocNo: Code[20])
    begin
        with GenJnlLine do begin
          if SalesHeader."Bal. Account Type" = SalesHeader."bal. account type"::"Bank Account" then
            "Bal. Account Type" := "bal. account type"::"Bank Account";
          "Bal. Account No." := SalesHeader."Bal. Account No.";
          "Applies-to Doc. Type" := DocType;
          "Applies-to Doc. No." := DocNo;
        end;
    end;

    local procedure FindCustLedgEntry(DocType: Option;DocNo: Code[20];var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry.SetRange("Document Type",DocType);
        CustLedgEntry.SetRange("Document No.",DocNo);
        CustLedgEntry.FindLast;
    end;

    local procedure ItemLedgerEntryExist(SalesLine2: Record "Sales Line";ShipOrReceive: Boolean): Boolean
    var
        HasItemLedgerEntry: Boolean;
    begin
        if ShipOrReceive then
          // item ledger entry will be created during posting in this transaction
          HasItemLedgerEntry :=
            ((SalesLine2."Qty. to Ship" + SalesLine2."Quantity Shipped") <> 0) or
            ((SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced") <> 0) or
            ((SalesLine2."Return Qty. to Receive" + SalesLine2."Return Qty. Received") <> 0)
        else
          // item ledger entry must already exist
          HasItemLedgerEntry :=
            (SalesLine2."Quantity Shipped" <> 0) or
            (SalesLine2."Return Qty. Received" <> 0);

        exit(HasItemLedgerEntry);
    end;

    local procedure CheckPostRestrictions(SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do begin
          if not PreviewMode then
            OnCheckSalesPostRestrictions;

          CheckCustBlockage(SalesHeader,"Sell-to Customer No.",true);

          if "Bill-to Customer No." <> "Sell-to Customer No." then
            CheckCustBlockage(SalesHeader,"Bill-to Customer No.",false);
        end;
    end;

    local procedure CheckCustBlockage(SalesHeader: Record "Sales Header";CustCode: Code[20];ExecuteDocCheck: Boolean)
    var
        Cust: Record Customer;
        TempSalesLine: Record "Sales Line" temporary;
    begin
        with SalesHeader do begin
          Cust.Get(CustCode);
          if Receive then
            Cust.CheckBlockedCustOnDocs(Cust,"Document Type",false,true)
          else begin
            if Ship and CheckDocumentType(SalesHeader,ExecuteDocCheck) then begin
              ResetTempLines(TempSalesLine);
              TempSalesLine.SetFilter("Qty. to Ship",'<>0');
              TempSalesLine.SetRange("Shipment No.",'');
              if not TempSalesLine.IsEmpty then
                Cust.CheckBlockedCustOnDocs(Cust,"Document Type",true,true);
            end else
              Cust.CheckBlockedCustOnDocs(Cust,"Document Type",false,true);
          end;
        end;
    end;

    local procedure CheckDocumentType(SalesHeader: Record "Sales Header";ExecuteDocCheck: Boolean): Boolean
    begin
        with SalesHeader do
          if ExecuteDocCheck then
            exit(
              ("Document Type" = "document type"::Order) or
              (("Document Type" = "document type"::Invoice) and SalesSetup."Shipment on Invoice"));
        exit(true);
    end;

    local procedure UpdateWonOpportunities(var SalesHeader: Record "Sales Header")
    var
        Opp: Record Opportunity;
        OpportunityEntry: Record "Opportunity Entry";
    begin
        with SalesHeader do
          if "Document Type" = "document type"::Order then begin
            Opp.Reset;
            Opp.SetCurrentkey("Sales Document Type","Sales Document No.");
            Opp.SetRange("Sales Document Type",Opp."sales document type"::Order);
            Opp.SetRange("Sales Document No.","No.");
            Opp.SetRange(Status,Opp.Status::Won);
            if Opp.FindFirst then begin
              Opp."Sales Document Type" := Opp."sales document type"::"Posted Invoice";
              Opp."Sales Document No." := SalesInvHeader."No.";
              Opp.Modify;
              OpportunityEntry.Reset;
              OpportunityEntry.SetCurrentkey(Active,"Opportunity No.");
              OpportunityEntry.SetRange(Active,true);
              OpportunityEntry.SetRange("Opportunity No.",Opp."No.");
              if OpportunityEntry.FindFirst then begin
                OpportunityEntry."Calcd. Current Value (LCY)" := OpportunityEntry.GetSalesDocValue(SalesHeader);
                OpportunityEntry.Modify;
              end;
            end;
          end;
    end;

    local procedure UpdateQtyToBeInvoiced(var QtyToBeInvoiced: Decimal;var QtyToBeInvoicedBase: Decimal;TrackingSpecificationExists: Boolean;HasATOShippedNotInvoiced: Boolean;SalesLine: Record "Sales Line";SalesShptLine: Record "Sales Shipment Line";InvoicingTrackingSpecification: Record "Tracking Specification";ItemLedgEntryNotInvoiced: Record "Item Ledger Entry")
    begin
        if TrackingSpecificationExists then begin
          QtyToBeInvoiced := InvoicingTrackingSpecification."Qty. to Invoice";
          QtyToBeInvoicedBase := InvoicingTrackingSpecification."Qty. to Invoice (Base)";
        end else
          if HasATOShippedNotInvoiced then begin
            QtyToBeInvoicedBase := ItemLedgEntryNotInvoiced.Quantity - ItemLedgEntryNotInvoiced."Invoiced Quantity";
            if Abs(QtyToBeInvoicedBase) > Abs(RemQtyToBeInvoicedBase) then
              QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Qty. to Ship (Base)";
            QtyToBeInvoiced := ROUND(QtyToBeInvoicedBase / SalesShptLine."Qty. per Unit of Measure",0.00001);
          end else begin
            QtyToBeInvoiced := RemQtyToBeInvoiced - SalesLine."Qty. to Ship";
            QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Qty. to Ship (Base)";
          end;

        if Abs(QtyToBeInvoiced) > Abs(SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced") then begin
          QtyToBeInvoiced := -(SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced");
          QtyToBeInvoicedBase := -(SalesShptLine."Quantity (Base)" - SalesShptLine."Qty. Invoiced (Base)");
        end;
    end;

    local procedure UpdateRemainingQtyToBeInvoiced(SalesShptLine: Record "Sales Shipment Line";var RemQtyToInvoiceCurrLine: Decimal;var RemQtyToInvoiceCurrLineBase: Decimal)
    begin
        RemQtyToInvoiceCurrLine := -SalesShptLine.Quantity + SalesShptLine."Quantity Invoiced";
        RemQtyToInvoiceCurrLineBase := -SalesShptLine."Quantity (Base)" + SalesShptLine."Qty. Invoiced (Base)";
        if RemQtyToInvoiceCurrLine < RemQtyToBeInvoiced then begin
          RemQtyToInvoiceCurrLine := RemQtyToBeInvoiced;
          RemQtyToInvoiceCurrLineBase := RemQtyToBeInvoicedBase;
        end;
    end;

    local procedure IsEndLoopForShippedNotInvoiced(RemQtyToBeInvoiced: Decimal;TrackingSpecificationExists: Boolean;var HasATOShippedNotInvoiced: Boolean;var SalesShptLine: Record "Sales Shipment Line";var InvoicingTrackingSpecification: Record "Tracking Specification";var ItemLedgEntryNotInvoiced: Record "Item Ledger Entry";SalesLine: Record "Sales Line"): Boolean
    begin
        if TrackingSpecificationExists then
          exit(InvoicingTrackingSpecification.Next = 0);

        if HasATOShippedNotInvoiced then begin
          HasATOShippedNotInvoiced := ItemLedgEntryNotInvoiced.Next <> 0;
          if not HasATOShippedNotInvoiced then
            exit(not SalesShptLine.FindSet or (Abs(RemQtyToBeInvoiced) <= Abs(SalesLine."Qty. to Ship")));
          exit(Abs(RemQtyToBeInvoiced) <= Abs(SalesLine."Qty. to Ship"));
        end;

        exit((SalesShptLine.Next = 0) or (Abs(RemQtyToBeInvoiced) <= Abs(SalesLine."Qty. to Ship")));
    end;


    procedure SetItemEntryRelation(var ItemEntryRelation: Record "Item Entry Relation";var SalesShptLine: Record "Sales Shipment Line";var InvoicingTrackingSpecification: Record "Tracking Specification";var ItemLedgEntryNotInvoiced: Record "Item Ledger Entry";TrackingSpecificationExists: Boolean;HasATOShippedNotInvoiced: Boolean)
    begin
        if TrackingSpecificationExists then begin
          ItemEntryRelation.Get(InvoicingTrackingSpecification."Item Ledger Entry No.");
          SalesShptLine.Get(ItemEntryRelation."Source ID",ItemEntryRelation."Source Ref. No.");
        end else
          if HasATOShippedNotInvoiced then begin
            ItemEntryRelation."Item Entry No." := ItemLedgEntryNotInvoiced."Entry No.";
            SalesShptLine.Get(ItemLedgEntryNotInvoiced."Document No.",ItemLedgEntryNotInvoiced."Document Line No.");
          end else
            ItemEntryRelation."Item Entry No." := SalesShptLine."Item Shpt. Entry No.";
    end;

    local procedure PostATOAssocItemJnlLine(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";var PostedATOLink: Record "Posted Assemble-to-Order Link";var RemQtyToBeInvoiced: Decimal;var RemQtyToBeInvoicedBase: Decimal)
    var
        DummyTrackingSpecification: Record "Tracking Specification";
    begin
        with PostedATOLink do begin
          DummyTrackingSpecification.Init;
          if SalesLine."Document Type" = SalesLine."document type"::Order then begin
            "Assembled Quantity" := -"Assembled Quantity";
            "Assembled Quantity (Base)" := -"Assembled Quantity (Base)";
            if Abs(RemQtyToBeInvoiced) >= Abs("Assembled Quantity") then begin
              ItemLedgShptEntryNo :=
                PostItemJnlLine(
                  SalesHeader,SalesLine,
                  "Assembled Quantity","Assembled Quantity (Base)",
                  "Assembled Quantity","Assembled Quantity (Base)",
                  0,'',DummyTrackingSpecification,true);
              RemQtyToBeInvoiced -= "Assembled Quantity";
              RemQtyToBeInvoicedBase -= "Assembled Quantity (Base)";
            end else begin
              if RemQtyToBeInvoiced <> 0 then
                ItemLedgShptEntryNo :=
                  PostItemJnlLine(
                    SalesHeader,SalesLine,
                    RemQtyToBeInvoiced,
                    RemQtyToBeInvoicedBase,
                    RemQtyToBeInvoiced,
                    RemQtyToBeInvoicedBase,
                    0,'',DummyTrackingSpecification,true);

              ItemLedgShptEntryNo :=
                PostItemJnlLine(
                  SalesHeader,SalesLine,
                  "Assembled Quantity" - RemQtyToBeInvoiced,
                  "Assembled Quantity (Base)" - RemQtyToBeInvoicedBase,
                  0,0,
                  0,'',DummyTrackingSpecification,true);

              RemQtyToBeInvoiced := 0;
              RemQtyToBeInvoicedBase := 0;
            end;
          end;
        end;
    end;

    local procedure GetOpenLinkedATOs(var TempAsmHeader: Record "Assembly Header" temporary)
    var
        TempSalesLine: Record "Sales Line" temporary;
        AsmHeader: Record "Assembly Header";
    begin
        with TempSalesLine do begin
          ResetTempLines(TempSalesLine);
          if FindSet then
            repeat
              if AsmToOrderExists(AsmHeader) then
                if AsmHeader.Status = AsmHeader.Status::Open then begin
                  TempAsmHeader.TransferFields(AsmHeader);
                  TempAsmHeader.Insert;
                end;
            until Next = 0;
        end;
    end;

    local procedure ReopenAsmOrders(var TempAsmHeader: Record "Assembly Header" temporary)
    var
        AsmHeader: Record "Assembly Header";
    begin
        if TempAsmHeader.Find('-') then
          repeat
            AsmHeader.Get(TempAsmHeader."Document Type",TempAsmHeader."No.");
            AsmHeader.Status := AsmHeader.Status::Open;
            AsmHeader.Modify;
          until TempAsmHeader.Next = 0;
    end;

    local procedure InitPostATO(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line")
    var
        AsmHeader: Record "Assembly Header";
        Window: Dialog;
    begin
        if SalesLine.AsmToOrderExists(AsmHeader) then begin
          Window.Open(AssemblyCheckProgressMsg);
          Window.Update(1,
            StrSubstNo('%1 %2 %3 %4',
              SalesLine."Document Type",SalesLine."Document No.",SalesLine.FieldCaption("Line No."),SalesLine."Line No."));
          Window.Update(2,StrSubstNo('%1 %2',AsmHeader."Document Type",AsmHeader."No."));

          SalesLine.CheckAsmToOrder(AsmHeader);
          if not HasQtyToAsm(SalesLine,AsmHeader) then
            exit;

          AsmPost.SetPostingDate(true,SalesHeader."Posting Date");
          AsmPost.InitPostATO(AsmHeader);

          Window.Close;
        end;
    end;

    local procedure InitPostATOs(SalesHeader: Record "Sales Header")
    var
        TempSalesLine: Record "Sales Line" temporary;
    begin
        with TempSalesLine do begin
          FindNotShippedLines(SalesHeader,TempSalesLine);
          SetFilter("Qty. to Assemble to Order",'<>0');
          if FindSet then
            repeat
              InitPostATO(SalesHeader,TempSalesLine);
            until Next = 0;
        end;
    end;

    local procedure PostATO(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";var TempPostedATOLink: Record "Posted Assemble-to-Order Link" temporary)
    var
        AsmHeader: Record "Assembly Header";
        PostedATOLink: Record "Posted Assemble-to-Order Link";
        Window: Dialog;
    begin
        if SalesLine.AsmToOrderExists(AsmHeader) then begin
          Window.Open(AssemblyPostProgressMsg);
          Window.Update(1,
            StrSubstNo('%1 %2 %3 %4',
              SalesLine."Document Type",SalesLine."Document No.",SalesLine.FieldCaption("Line No."),SalesLine."Line No."));
          Window.Update(2,StrSubstNo('%1 %2',AsmHeader."Document Type",AsmHeader."No."));

          SalesLine.CheckAsmToOrder(AsmHeader);
          if not HasQtyToAsm(SalesLine,AsmHeader) then
            exit;
          if AsmHeader."Remaining Quantity (Base)" = 0 then
            exit;

          PostedATOLink.Init;
          PostedATOLink."Assembly Document Type" := PostedATOLink."assembly document type"::Assembly;
          PostedATOLink."Assembly Document No." := AsmHeader."Posting No.";
          PostedATOLink."Document Type" := PostedATOLink."document type"::"Sales Shipment";
          PostedATOLink."Document No." := SalesHeader."Shipping No.";
          PostedATOLink."Document Line No." := SalesLine."Line No.";

          PostedATOLink."Assembly Order No." := AsmHeader."No.";
          PostedATOLink."Order No." := SalesLine."Document No.";
          PostedATOLink."Order Line No." := SalesLine."Line No.";

          PostedATOLink."Assembled Quantity" := AsmHeader."Quantity to Assemble";
          PostedATOLink."Assembled Quantity (Base)" := AsmHeader."Quantity to Assemble (Base)";
          PostedATOLink.Insert;

          TempPostedATOLink := PostedATOLink;
          TempPostedATOLink.Insert;

          AsmPost.PostATO(AsmHeader,ItemJnlPostLine,ResJnlPostLine,WhseJnlPostLine);

          Window.Close;
        end;
    end;

    local procedure FinalizePostATO(var SalesLine: Record "Sales Line")
    var
        ATOLink: Record "Assemble-to-Order Link";
        AsmHeader: Record "Assembly Header";
        Window: Dialog;
    begin
        if SalesLine.AsmToOrderExists(AsmHeader) then begin
          Window.Open(AssemblyFinalizeProgressMsg);
          Window.Update(1,
            StrSubstNo('%1 %2 %3 %4',
              SalesLine."Document Type",SalesLine."Document No.",SalesLine.FieldCaption("Line No."),SalesLine."Line No."));
          Window.Update(2,StrSubstNo('%1 %2',AsmHeader."Document Type",AsmHeader."No."));

          SalesLine.CheckAsmToOrder(AsmHeader);
          AsmHeader.TestField("Remaining Quantity (Base)",0);
          AsmPost.FinalizePostATO(AsmHeader);
          ATOLink.Get(AsmHeader."Document Type",AsmHeader."No.");
          ATOLink.Delete;

          Window.Close;
        end;
    end;

    local procedure CheckATOLink(SalesLine: Record "Sales Line")
    var
        AsmHeader: Record "Assembly Header";
    begin
        if SalesLine."Qty. to Asm. to Order (Base)" = 0 then
          exit;
        if SalesLine.AsmToOrderExists(AsmHeader) then
          SalesLine.CheckAsmToOrder(AsmHeader);
    end;

    local procedure DeleteATOLinks(SalesHeader: Record "Sales Header")
    var
        ATOLink: Record "Assemble-to-Order Link";
    begin
        with ATOLink do begin
          SetCurrentkey(Type,"Document Type","Document No.");
          SetRange(Type,Type::Sale);
          SetRange("Document Type",SalesHeader."Document Type");
          SetRange("Document No.",SalesHeader."No.");
          if not IsEmpty then
            DeleteAll;
        end;
    end;

    local procedure HasQtyToAsm(SalesLine: Record "Sales Line";AsmHeader: Record "Assembly Header"): Boolean
    begin
        if SalesLine."Qty. to Asm. to Order (Base)" = 0 then
          exit(false);
        if SalesLine."Qty. to Ship (Base)" = 0 then
          exit(false);
        if AsmHeader."Quantity to Assemble (Base)" = 0 then
          exit(false);
        exit(true);
    end;

    local procedure GetATOItemLedgEntriesNotInvoiced(SalesLine: Record "Sales Line";var ItemLedgEntryNotInvoiced: Record "Item Ledger Entry"): Boolean
    var
        PostedATOLink: Record "Posted Assemble-to-Order Link";
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntryNotInvoiced.Reset;
        ItemLedgEntryNotInvoiced.DeleteAll;
        if PostedATOLink.FindLinksFromSalesLine(SalesLine) then
          repeat
            ItemLedgEntry.SetCurrentkey("Document No.","Document Type","Document Line No.");
            ItemLedgEntry.SetRange("Document Type",ItemLedgEntry."document type"::"Sales Shipment");
            ItemLedgEntry.SetRange("Document No.",PostedATOLink."Document No.");
            ItemLedgEntry.SetRange("Document Line No.",PostedATOLink."Document Line No.");
            ItemLedgEntry.SetRange("Assemble to Order",true);
            ItemLedgEntry.SetRange("Completely Invoiced",false);
            if ItemLedgEntry.FindSet then
              repeat
                if ItemLedgEntry.Quantity <> ItemLedgEntry."Invoiced Quantity" then begin
                  ItemLedgEntryNotInvoiced := ItemLedgEntry;
                  ItemLedgEntryNotInvoiced.Insert;
                end;
              until ItemLedgEntry.Next = 0;
          until PostedATOLink.Next = 0;

        exit(ItemLedgEntryNotInvoiced.FindSet);
    end;

    local procedure PostSalesTaxToGL(SalesHeader: Record "Sales Header";LineCount: Integer)
    var
        TaxJurisdiction: Record "Tax Jurisdiction";
        CurrExchRate: Record "Currency Exchange Rate";
        CustPostingGr: Record "Customer Posting Group";
        GenJnlLine: Record "Gen. Journal Line";
        TaxLineCount: Integer;
        RemSalesTaxAmt: Decimal;
        RemSalesTaxSrcAmt: Decimal;
    begin
        TaxLineCount := 0;
        RemSalesTaxAmt := 0;
        RemSalesTaxSrcAmt := 0;
        if SalesHeader."Currency Code" <> '' then
          TotalSalesLineLCY."Amount Including VAT" := TotalSalesLineLCY.Amount;
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
              GenJnlLine."Posting Date" := SalesHeader."Posting Date";
              GenJnlLine."Document Date" := SalesHeader."Document Date";
              GenJnlLine.Description := SalesHeader."Posting Description";
              GenJnlLine."Reason Code" := SalesHeader."Reason Code";
              GenJnlLine."Document Type" := GenJnlLineDocType;
              GenJnlLine."Document No." := GenJnlLineDocNo;
              GenJnlLine."External Document No." := GenJnlLineExtDocNo;
              GenJnlLine."System-Created Entry" := true;
              GenJnlLine.Amount := 0;
              GenJnlLine."Source Currency Code" := SalesHeader."Currency Code";
              GenJnlLine."Source Currency Amount" := 0;
              GenJnlLine.Correction := SalesHeader.Correction;
              GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::Sale;
              GenJnlLine."Tax Area Code" := TempSalesTaxAmtLine."Tax Area Code";
              GenJnlLine."Tax Type" := TempSalesTaxAmtLine."Tax Type";
              GenJnlLine."Tax Exemption No." := SalesHeader."Tax Exemption No.";
              GenJnlLine."Tax Group Code" := TempSalesTaxAmtLine."Tax Group Code";
              GenJnlLine."Tax Liable" := TempSalesTaxAmtLine."Tax Liable";
              GenJnlLine.Quantity := TempSalesTaxAmtLine.Quantity;
              GenJnlLine."VAT Calculation Type" := GenJnlLine."vat calculation type"::"Sales Tax";
              GenJnlLine."VAT Posting" := GenJnlLine."vat posting"::"Manual VAT Entry";
              GenJnlLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
              GenJnlLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
              GenJnlLine."Dimension Set ID" := SalesHeader."Dimension Set ID";
              GenJnlLine."Source Code" := SrcCode;
              GenJnlLine."EU 3-Party Trade" := SalesHeader."EU 3-Party Trade";
              GenJnlLine."Bill-to/Pay-to No." := SalesHeader."Sell-to Customer No.";
              GenJnlLine."Source Type" := GenJnlLine."source type"::Customer;
              GenJnlLine."Source No." := SalesHeader."Bill-to Customer No.";
              GenJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
              GenJnlLine."STE Transaction ID" := SalesHeader."STE Transaction ID";
              GenJnlLine."Source Curr. VAT Base Amount" :=
                CurrExchRate.ExchangeAmtLCYToFCY(
                  UseDate,SalesHeader."Currency Code",TempSalesTaxAmtLine."Tax Base Amount",SalesHeader."Currency Factor");
              GenJnlLine."VAT Base Amount (LCY)" :=
                ROUND(TempSalesTaxAmtLine."Tax Base Amount");
              GenJnlLine."VAT Base Amount" := GenJnlLine."VAT Base Amount (LCY)";

              if TaxJurisdiction.Code <> TempSalesTaxAmtLine."Tax Jurisdiction Code" then begin
                TaxJurisdiction.Get(TempSalesTaxAmtLine."Tax Jurisdiction Code");
                if SalesTaxCountry = Salestaxcountry::CA then begin
                  RemSalesTaxAmt := 0;
                  RemSalesTaxSrcAmt := 0;
                end;
              end;
              if TaxJurisdiction."Unrealized VAT Type" > 0 then begin
                TaxJurisdiction.TestField("Unreal. Tax Acc. (Sales)");
                GenJnlLine."Account No." := TaxJurisdiction."Unreal. Tax Acc. (Sales)";
              end else begin
                TaxJurisdiction.TestField("Tax Account (Sales)");
                GenJnlLine."Account No." := TaxJurisdiction."Tax Account (Sales)";
              end;
              GenJnlLine."Tax Jurisdiction Code" := TempSalesTaxAmtLine."Tax Jurisdiction Code";
              if TempSalesTaxAmtLine."Tax Amount" <> 0 then begin
                RemSalesTaxSrcAmt := RemSalesTaxSrcAmt +
                  TempSalesTaxAmtLine."Tax Base Amount FCY" * TempSalesTaxAmtLine."Tax %" / 100;
                GenJnlLine."Source Curr. VAT Amount" := ROUND(RemSalesTaxSrcAmt,Currency."Amount Rounding Precision");
                RemSalesTaxSrcAmt := RemSalesTaxSrcAmt - GenJnlLine."Source Curr. VAT Amount";
                RemSalesTaxAmt := RemSalesTaxAmt + TempSalesTaxAmtLine."Tax Amount";
                GenJnlLine."VAT Amount (LCY)" := ROUND(RemSalesTaxAmt,GLSetup."Amount Rounding Precision");
                RemSalesTaxAmt := RemSalesTaxAmt - GenJnlLine."VAT Amount (LCY)";
                GenJnlLine."VAT Amount" := GenJnlLine."VAT Amount (LCY)";
              end;
              GenJnlLine."VAT Difference" := TempSalesTaxAmtLine."Tax Difference";

              if not
                 (SalesHeader."Document Type" in
                  [SalesHeader."document type"::"Return Order",SalesHeader."document type"::"Credit Memo"])
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
              if SalesHeader."Currency Code" <> '' then
                TotalSalesLineLCY."Amount Including VAT" :=
                  TotalSalesLineLCY."Amount Including VAT" + GenJnlLine."VAT Amount (LCY)";

              GenJnlPostLine.RunWithCheck(GenJnlLine);
            end;
          until TempSalesTaxAmtLine.Next = 0;

          // Sales Tax rounding adjustment for Invoice with 100% Prepayment
          if SalesHeader.Invoice and SalesHeader."Prepmt. Include Tax" and (TotalSalesLineLCY."Prepayment %" = 100) and
             ((TotalSalesLine."Amount Including VAT" <> 0) or (TotalSalesLineLCY."Amount Including VAT" <> 0))
          then begin
            GenJnlLine.Init;
            GenJnlLine."Posting Date" := SalesHeader."Posting Date";
            GenJnlLine."Document Date" := SalesHeader."Document Date";
            GenJnlLine.Description := SalesHeader."Posting Description";
            GenJnlLine."Reason Code" := SalesHeader."Reason Code";
            GenJnlLine."Document Type" := GenJnlLineDocType;
            GenJnlLine."Document No." := GenJnlLineDocNo;
            GenJnlLine."External Document No." := GenJnlLineExtDocNo;
            GenJnlLine."System-Created Entry" := true;
            CustPostingGr.Get(SalesHeader."Customer Posting Group");
            CustPostingGr.TestField("Invoice Rounding Account");
            GenJnlLine."Account No." := CustPostingGr."Invoice Rounding Account";
            GenJnlLine."Currency Code" := SalesHeader."Currency Code";
            GenJnlLine.Amount := -TotalSalesLine."Amount Including VAT";
            GenJnlLine."Source Currency Code" := SalesHeader."Currency Code";
            GenJnlLine."Source Currency Amount" := -TotalSalesLine."Amount Including VAT";
            GenJnlLine."Amount (LCY)" := -TotalSalesLineLCY."Amount Including VAT";
            if SalesHeader."Currency Code" = '' then
              GenJnlLine."Currency Factor" := 1
            else
              GenJnlLine."Currency Factor" := SalesHeader."Currency Factor";
            GenJnlLine.Correction := SalesHeader.Correction;
            GenJnlLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := SalesHeader."Dimension Set ID";
            GenJnlPostLine.RunWithCheck(GenJnlLine);

            TotalSalesLine."Amount Including VAT" := 0;
            TotalSalesLineLCY."Amount Including VAT" := 0;
          end;
        end;
    end;


    procedure SetWhseJnlRegisterCU(var WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line")
    begin
        WhseJnlPostLine := WhseJnlRegisterLine;
    end;

    local procedure PostWhseShptLines(var WhseShptLine2: Record "Warehouse Shipment Line";SalesShptLine2: Record "Sales Shipment Line";var SalesLine2: Record "Sales Line")
    var
        ATOWhseShptLine: Record "Warehouse Shipment Line";
        NonATOWhseShptLine: Record "Warehouse Shipment Line";
        ATOLineFound: Boolean;
        NonATOLineFound: Boolean;
        TotalSalesShptLineQty: Decimal;
    begin
        WhseShptLine2.GetATOAndNonATOLines(ATOWhseShptLine,NonATOWhseShptLine,ATOLineFound,NonATOLineFound);
        if ATOLineFound then
          TotalSalesShptLineQty += ATOWhseShptLine."Qty. to Ship";
        if NonATOLineFound then
          TotalSalesShptLineQty += NonATOWhseShptLine."Qty. to Ship";
        SalesShptLine2.TestField(Quantity,TotalSalesShptLineQty);

        SaveTempWhseSplitSpec(SalesLine2,TempATOTrackingSpecification);
        WhsePostShpt.SetWhseJnlRegisterCU(WhseJnlPostLine);
        if ATOLineFound and (ATOWhseShptLine."Qty. to Ship (Base)" > 0) then
          WhsePostShpt.CreatePostedShptLine(
            ATOWhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);

        SaveTempWhseSplitSpec(SalesLine2,TempHandlingSpecification);
        if NonATOLineFound and (NonATOWhseShptLine."Qty. to Ship (Base)" > 0) then
          WhsePostShpt.CreatePostedShptLine(
            NonATOWhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
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

    local procedure UpdateIncomingDocument(IncomingDocNo: Integer;PostingDate: Date;GenJnlLineDocNo: Code[20])
    var
        IncomingDocument: Record "Incoming Document";
    begin
        IncomingDocument.UpdateIncomingDocumentFromPosting(IncomingDocNo,PostingDate,GenJnlLineDocNo);
    end;

    local procedure CheckItemCharge(ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)")
    var
        SalesLineForCharge: Record "Sales Line";
    begin
        with ItemChargeAssgntSales do
          case "Applies-to Doc. Type" of
            "applies-to doc. type"::Order,
            "applies-to doc. type"::Invoice:
              if SalesLineForCharge.Get(
                   "Applies-to Doc. Type",
                   "Applies-to Doc. No.",
                   "Applies-to Doc. Line No.")
              then
                if (SalesLineForCharge."Quantity (Base)" = SalesLineForCharge."Qty. Shipped (Base)") and
                   (SalesLineForCharge."Qty. Shipped Not Invd. (Base)" = 0)
                then
                  Error(ReassignItemChargeErr);
            "applies-to doc. type"::"Return Order",
            "applies-to doc. type"::"Credit Memo":
              if SalesLineForCharge.Get(
                   "Applies-to Doc. Type",
                   "Applies-to Doc. No.",
                   "Applies-to Doc. Line No.")
              then
                if (SalesLineForCharge."Quantity (Base)" = SalesLineForCharge."Return Qty. Received (Base)") and
                   (SalesLineForCharge."Ret. Qty. Rcd. Not Invd.(Base)" = 0)
                then
                  Error(ReassignItemChargeErr);
          end;
    end;

    local procedure CheckItemReservDisruption(SalesLine: Record "Sales Line")
    var
        AvailableQty: Decimal;
    begin
        with SalesLine do begin
          if not ("Document Type" in ["document type"::Order,"document type"::Invoice]) or
             (Type <> Type::Item) or not ("Qty. to Ship (Base)" > 0)
          then
            exit;
          if ("Job Contract Entry No." <> 0) or
             Nonstock or "Special Order" or "Drop Shipment" or
             IsServiceItem or FullQtyIsForAsmToOrder or
             TempSKU.Get("Location Code","No.","Variant Code") // Warn against item
          then
            exit;

          Item.SetFilter("Location Filter","Location Code");
          Item.SetFilter("Variant Filter","Variant Code");
          Item.CalcFields("Reserved Qty. on Inventory","Net Change");
          CalcFields("Reserved Qty. (Base)");
          AvailableQty := Item."Net Change" - (Item."Reserved Qty. on Inventory" - "Reserved Qty. (Base)");

          if (Item."Reserved Qty. on Inventory" > 0) and
             (AvailableQty < "Qty. to Ship (Base)") and
             (Item."Reserved Qty. on Inventory" > "Reserved Qty. (Base)")
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


    procedure InitProgressWindow(SalesHeader: Record "Sales Header")
    begin
        if SalesHeader.Invoice then
          Window.Open(
            '#1#################################\\' +
            PostingLinesMsg +
            PostingSalesAndVATMsg +
            PostingCustomersMsg +
            PostingBalAccountMsg)
        else
          Window.Open(
            '#1#################################\\' +
            PostingLines2Msg);

        Window.Update(1,StrSubstNo('%1 %2',SalesHeader."Document Type",SalesHeader."No."));
    end;

    local procedure CheckCertificateOfSupplyStatus(SalesShptHeader: Record "Sales Shipment Header";SalesShptLine: Record "Sales Shipment Line")
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

    local procedure HasSpecificTracking(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
    begin
        Item.Get(ItemNo);
        if Item."Item Tracking Code" <> '' then begin
          ItemTrackingCode.Get(Item."Item Tracking Code");
          exit(ItemTrackingCode."SN Specific Tracking" or ItemTrackingCode."Lot Specific Tracking");
        end;
    end;

    local procedure HasInvtPickLine(SalesLine: Record "Sales Line"): Boolean
    var
        WhseActivityLine: Record "Warehouse Activity Line";
    begin
        with WhseActivityLine do begin
          SetRange("Activity Type","activity type"::"Invt. Pick");
          SetRange("Source Type",Database::"Sales Line");
          SetRange("Source Subtype",SalesLine."Document Type");
          SetRange("Source No.",SalesLine."Document No.");
          SetRange("Source Line No.",SalesLine."Line No.");
          exit(not IsEmpty);
        end;
    end;

    local procedure InsertPostedHeaders(SalesHeader: Record "Sales Header")
    var
        SalesShptLine: Record "Sales Shipment Line";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        with SalesHeader do begin
          // Insert shipment header
          if Ship then begin
            if ("Document Type" = "document type"::Order) or
               (("Document Type" = "document type"::Invoice) and SalesSetup."Shipment on Invoice")
            then begin
              if DropShipOrder then begin
                PurchRcptHeader.LockTable;
                PurchRcptLine.LockTable;
                SalesShptHeader.LockTable;
                SalesShptLine.LockTable;
              end;
              InsertShipmentHeader(SalesHeader,SalesShptHeader);
            end;

            ServItemMgt.CopyReservationEntry(SalesHeader);
            if ("Document Type" = "document type"::Invoice) and
               (not SalesSetup."Shipment on Invoice")
            then
              ServItemMgt.CreateServItemOnSalesInvoice(SalesHeader);
          end;

          ServItemMgt.DeleteServItemOnSaleCreditMemo(SalesHeader);

          // Insert return receipt header
          if Receive then
            if ("Document Type" = "document type"::"Return Order") or
               (("Document Type" = "document type"::"Credit Memo") and SalesSetup."Return Receipt on Credit Memo")
            then
              InsertReturnReceiptHeader(SalesHeader,ReturnRcptHeader);

          // Insert invoice header or credit memo header
          if Invoice then
            if "Document Type" in ["document type"::Order,"document type"::Invoice] then begin
              InsertInvoiceHeader(SalesHeader,SalesInvHeader);
              if SalesTaxCountry <> Salestaxcountry::NoTax then
                TaxAmountDifference.CopyTaxDifferenceRecords(
                  TaxAmountDifference."document product area"::Sales,"Document Type","No.",
                  TaxAmountDifference."document product area"::"Posted Sale",
                  TaxAmountDifference."document type"::Invoice,SalesInvHeader."No.");
              GenJnlLineDocType := GenJnlLine."document type"::Invoice;
              GenJnlLineDocNo := SalesInvHeader."No.";
              GenJnlLineExtDocNo := SalesInvHeader."External Document No.";
            end else begin // Credit Memo
              InsertCrMemoHeader(SalesHeader,SalesCrMemoHeader);
              if SalesTaxCountry <> Salestaxcountry::NoTax then
                TaxAmountDifference.CopyTaxDifferenceRecords(
                  TaxAmountDifference."document product area"::Sales,"Document Type","No.",
                  TaxAmountDifference."document product area"::"Posted Sale",
                  TaxAmountDifference."document type"::"Credit Memo",SalesCrMemoHeader."No.");
              GenJnlLineDocType := GenJnlLine."document type"::"Credit Memo";
              GenJnlLineDocNo := SalesCrMemoHeader."No.";
              GenJnlLineExtDocNo := SalesCrMemoHeader."External Document No.";
            end;
        end;
    end;

    local procedure InsertShipmentHeader(SalesHeader: Record "Sales Header";var SalesShptHeader: Record "Sales Shipment Header")
    var
        SalesCommentLine: Record "Sales Comment Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        with SalesHeader do begin
          SalesShptHeader.Init;
          SalesShptHeader.TransferFields(SalesHeader);

          SalesShptHeader."No." := "Shipping No.";
          if "Document Type" = "document type"::Order then begin
            SalesShptHeader."Order No. Series" := "No. Series";
            SalesShptHeader."Order No." := "No.";
            if SalesSetup."Ext. Doc. No. Mandatory" then
              TestField("External Document No.");
          end;
          SalesShptHeader."Source Code" := SrcCode;
          SalesShptHeader."User ID" := UserId;
          SalesShptHeader."No. Printed" := 0;
          SalesShptHeader.Insert;

          ApprovalsMgmt.PostApprovalEntries(RecordId,SalesShptHeader.RecordId,SalesShptHeader."No.");

          if SalesSetup."Copy Comments Order to Shpt." then begin
            CopyCommentLines(
              "Document Type",SalesCommentLine."document type"::Shipment,
              "No.",SalesShptHeader."No.");
            RecordLinkManagement.CopyLinks(SalesHeader,SalesShptHeader);
          end;
          if WhseShip then begin
            WhseShptHeader.Get(TempWhseShptHeader."No.");
            WhsePostShpt.CreatePostedShptHeader(
              PostedWhseShptHeader,WhseShptHeader,"Shipping No.","Posting Date");
          end;
          if WhseReceive then begin
            WhseRcptHeader.Get(TempWhseRcptHeader."No.");
            WhsePostRcpt.CreatePostedRcptHeader(
              PostedWhseRcptHeader,WhseRcptHeader,"Shipping No.","Posting Date");
          end;
        end;
    end;

    local procedure InsertReturnReceiptHeader(SalesHeader: Record "Sales Header";var ReturnRcptHeader: Record "Return Receipt Header")
    var
        SalesCommentLine: Record "Sales Comment Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        with SalesHeader do begin
          ReturnRcptHeader.Init;
          ReturnRcptHeader.TransferFields(SalesHeader);
          ReturnRcptHeader."No." := "Return Receipt No.";
          if "Document Type" = "document type"::"Return Order" then begin
            ReturnRcptHeader."Return Order No. Series" := "No. Series";
            ReturnRcptHeader."Return Order No." := "No.";
            if SalesSetup."Ext. Doc. No. Mandatory" then
              TestField("External Document No.");
          end;
          ReturnRcptHeader."No. Series" := "Return Receipt No. Series";
          ReturnRcptHeader."Source Code" := SrcCode;
          ReturnRcptHeader."User ID" := UserId;
          ReturnRcptHeader."No. Printed" := 0;
          ReturnRcptHeader.Insert(true);

          ApprovalsMgmt.PostApprovalEntries(RecordId,ReturnRcptHeader.RecordId,ReturnRcptHeader."No.");

          if SalesSetup."Copy Cmts Ret.Ord. to Ret.Rcpt" then begin
            CopyCommentLines(
              "Document Type",SalesCommentLine."document type"::"Posted Return Receipt",
              "No.",ReturnRcptHeader."No.");
            RecordLinkManagement.CopyLinks(SalesHeader,ReturnRcptHeader);
          end;
          if WhseReceive then begin
            WhseRcptHeader.Get(TempWhseRcptHeader."No.");
            WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader,WhseRcptHeader,"Return Receipt No.","Posting Date");
          end;
          if WhseShip then begin
            WhseShptHeader.Get(TempWhseShptHeader."No.");
            WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader,WhseShptHeader,"Return Receipt No.","Posting Date");
          end;
        end;
    end;

    local procedure InsertInvoiceHeader(SalesHeader: Record "Sales Header";var SalesInvHeader: Record "Sales Invoice Header")
    var
        SalesCommentLine: Record "Sales Comment Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        with SalesHeader do begin
          SalesInvHeader.Init;
          CalcFields("Work Description");
          SalesInvHeader.TransferFields(SalesHeader);

          if "Document Type" = "document type"::Order then begin
            if PreviewMode then
              SalesInvHeader."No." := '***'
            else
              SalesInvHeader."No." := "Posting No.";
            if SalesSetup."Ext. Doc. No. Mandatory" then
              TestField("External Document No.");
            SalesInvHeader."Pre-Assigned No. Series" := '';
            SalesInvHeader."Order No. Series" := "No. Series";
            SalesInvHeader."Order No." := "No.";
            Window.Update(1,StrSubstNo(InvoiceNoMsg,"Document Type","No.",SalesInvHeader."No."));
          end else begin
            SalesInvHeader."Pre-Assigned No. Series" := "No. Series";
            SalesInvHeader."Pre-Assigned No." := "No.";
            if "Posting No." <> '' then begin
              SalesInvHeader."No." := "Posting No.";
              Window.Update(1,StrSubstNo(InvoiceNoMsg,"Document Type","No.",SalesInvHeader."No."));
            end;
          end;
          SalesInvHeader."Source Code" := SrcCode;
          SalesInvHeader."User ID" := UserId;
          SalesInvHeader."No. Printed" := 0;
          SalesInvHeader.Insert;

          UpdateWonOpportunities(SalesHeader);

          ApprovalsMgmt.PostApprovalEntries(RecordId,SalesInvHeader.RecordId,SalesInvHeader."No.");

          if SalesSetup."Copy Comments Order to Invoice" then begin
            CopyCommentLines(
              "Document Type",SalesCommentLine."document type"::"Posted Invoice",
              "No.",SalesInvHeader."No.");
            RecordLinkManagement.CopyLinks(SalesHeader,SalesInvHeader);
          end;
        end;
    end;

    local procedure InsertCrMemoHeader(SalesHeader: Record "Sales Header";var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        SalesCommentLine: Record "Sales Comment Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        with SalesHeader do begin
          SalesCrMemoHeader.Init;
          SalesCrMemoHeader.TransferFields(SalesHeader);
          if "Document Type" = "document type"::"Return Order" then begin
            SalesCrMemoHeader."No." := "Posting No.";
            if SalesSetup."Ext. Doc. No. Mandatory" then
              TestField("External Document No.");
            SalesCrMemoHeader."Pre-Assigned No. Series" := '';
            SalesCrMemoHeader."Return Order No. Series" := "No. Series";
            SalesCrMemoHeader."Return Order No." := "No.";
            Window.Update(1,StrSubstNo(CreditMemoNoMsg,"Document Type","No.",SalesCrMemoHeader."No."));
          end else begin
            SalesCrMemoHeader."Pre-Assigned No. Series" := "No. Series";
            SalesCrMemoHeader."Pre-Assigned No." := "No.";
            if "Posting No." <> '' then begin
              SalesCrMemoHeader."No." := "Posting No.";
              Window.Update(1,StrSubstNo(CreditMemoNoMsg,"Document Type","No.",SalesCrMemoHeader."No."));
            end;
          end;
          SalesCrMemoHeader."Source Code" := SrcCode;
          SalesCrMemoHeader."User ID" := UserId;
          SalesCrMemoHeader."No. Printed" := 0;
          SalesCrMemoHeader.Insert;

          ApprovalsMgmt.PostApprovalEntries(RecordId,SalesCrMemoHeader.RecordId,SalesCrMemoHeader."No.");

          if SalesSetup."Copy Cmts Ret.Ord. to Cr. Memo" then begin
            CopyCommentLines(
              "Document Type",SalesCommentLine."document type"::"Posted Credit Memo",
              "No.",SalesCrMemoHeader."No.");
            RecordLinkManagement.CopyLinks(SalesHeader,SalesCrMemoHeader);
          end;
        end;
    end;

    local procedure InsertShipmentLine(SalesHeader: Record "Sales Header";SalesShptHeader: Record "Sales Shipment Header";SalesLine: Record "Sales Line";CostBaseAmount: Decimal;var TempServiceItem2: Record "Service Item" temporary;var TempServiceItemComp2: Record "Service Item Component" temporary)
    var
        SalesShptLine: Record "Sales Shipment Line";
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseRcptLine: Record "Warehouse Receipt Line";
        TempServiceItem1: Record "Service Item" temporary;
        TempServiceItemComp1: Record "Service Item Component" temporary;
    begin
        SalesShptLine.InitFromSalesLine(SalesShptHeader,xSalesLine);
        if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."Qty. to Ship" <> 0) then begin
          if WhseShip then begin
            WhseShptLine.GetWhseShptLine(
              WhseShptLine,WhseShptHeader."No.",Database::"Sales Line",
              SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.");
            PostWhseShptLines(WhseShptLine,SalesShptLine,SalesLine);
          end;
          if WhseReceive then begin
            WhseRcptLine.GetWhseRcptLine(
              WhseRcptLine,WhseRcptHeader."No.",Database::"Sales Line",
              SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.");
            WhseRcptLine.TestField("Qty. to Receive",-SalesShptLine.Quantity);
            SaveTempWhseSplitSpec(SalesLine,TempHandlingSpecification);
            WhsePostRcpt.CreatePostedRcptLine(
              WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
          end;

          SalesShptLine."Item Shpt. Entry No." :=
            InsertShptEntryRelation(SalesShptLine); // ItemLedgShptEntryNo
          SalesShptLine."Item Charge Base Amount" :=
            ROUND(CostBaseAmount / SalesLine.Quantity * SalesShptLine.Quantity);
        end;
        SalesShptLine.Insert;

        CheckCertificateOfSupplyStatus(SalesShptHeader,SalesShptLine);

        ServItemMgt.CreateServItemOnSalesLineShpt(SalesHeader,xSalesLine,SalesShptLine);
        if SalesLine."BOM Item No." <> '' then begin
          ServItemMgt.ReturnServItemComp(TempServiceItem1,TempServiceItemComp1);
          if TempServiceItem1.FindSet then
            repeat
              TempServiceItem2 := TempServiceItem1;
              if TempServiceItem2.Insert then;
            until TempServiceItem1.Next = 0;
          if TempServiceItemComp1.FindSet then
            repeat
              TempServiceItemComp2 := TempServiceItemComp1;
              if TempServiceItemComp2.Insert then;
            until TempServiceItemComp1.Next = 0;
        end;
    end;

    local procedure InsertReturnReceiptLine(ReturnRcptHeader: Record "Return Receipt Header";SalesLine: Record "Sales Line";CostBaseAmount: Decimal)
    var
        ReturnRcptLine: Record "Return Receipt Line";
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseRcptLine: Record "Warehouse Receipt Line";
    begin
        ReturnRcptLine.InitFromSalesLine(ReturnRcptHeader,xSalesLine);
        if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."Return Qty. to Receive" <> 0) then begin
          if WhseReceive then begin
            WhseRcptLine.GetWhseRcptLine(
              WhseRcptLine,WhseRcptHeader."No.",Database::"Sales Line",
              SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.");
            WhseRcptLine.TestField("Qty. to Receive",ReturnRcptLine.Quantity);
            SaveTempWhseSplitSpec(SalesLine,TempHandlingSpecification);
            WhsePostRcpt.CreatePostedRcptLine(
              WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
          end;
          if WhseShip then begin
            WhseShptLine.GetWhseShptLine(
              WhseShptLine,WhseShptHeader."No.",Database::"Sales Line",
              SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.");
            WhseShptLine.TestField("Qty. to Ship",-ReturnRcptLine.Quantity);
            SaveTempWhseSplitSpec(SalesLine,TempHandlingSpecification);
            WhsePostShpt.SetWhseJnlRegisterCU(WhseJnlPostLine);
            WhsePostShpt.CreatePostedShptLine(
              WhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
          end;

          ReturnRcptLine."Item Rcpt. Entry No." :=
            InsertReturnEntryRelation(ReturnRcptLine); // ItemLedgShptEntryNo;
          ReturnRcptLine."Item Charge Base Amount" :=
            ROUND(CostBaseAmount / SalesLine.Quantity * ReturnRcptLine.Quantity);
        end;
        ReturnRcptLine.Insert;
    end;

    local procedure CheckICPartnerBlocked(SalesHeader: Record "Sales Header")
    var
        ICPartner: Record "IC Partner";
    begin
        with SalesHeader do begin
          if "Sell-to IC Partner Code" <> '' then
            if ICPartner.Get("Sell-to IC Partner Code") then
              ICPartner.TestField(Blocked,false);
          if "Bill-to IC Partner Code" <> '' then
            if ICPartner.Get("Bill-to IC Partner Code") then
              ICPartner.TestField(Blocked,false);
        end;
    end;

    local procedure SendICDocument(var SalesHeader: Record "Sales Header";var ModifyHeader: Boolean)
    var
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
    begin
        with SalesHeader do
          if "Send IC Document" and ("IC Status" = "ic status"::New) and ("IC Direction" = "ic direction"::Outgoing) and
             ("Document Type" in ["document type"::Order,"document type"::"Return Order"])
          then begin
            ICInboxOutboxMgt.SendSalesDoc(SalesHeader,true);
            "IC Status" := "ic status"::Pending;
            ModifyHeader := true;
          end;
    end;

    local procedure UpdateHandledICInboxTransaction(SalesHeader: Record "Sales Header")
    var
        HandledICInboxTrans: Record "Handled IC Inbox Trans.";
        Customer: Record Customer;
    begin
        with SalesHeader do
          if "IC Direction" = "ic direction"::Incoming then begin
            HandledICInboxTrans.SetRange("Document No.","External Document No.");
            Customer.Get("Sell-to Customer No.");
            HandledICInboxTrans.SetRange("IC Partner Code",Customer."IC Partner Code");
            HandledICInboxTrans.LockTable;
            if HandledICInboxTrans.FindFirst then begin
              HandledICInboxTrans.Status := HandledICInboxTrans.Status::Posted;
              HandledICInboxTrans.Modify;
            end;
          end;
    end;

    local procedure GetGenPostingSetup(var GenPostingSetup: Record "General Posting Setup";SalesLine: Record "Sales Line")
    begin
        if GLSetup."VAT in Use" then
          GenPostingSetup.Get(SalesLine."Gen. Bus. Posting Group",SalesLine."Gen. Prod. Posting Group")
        else
          if (SalesLine.Type >= SalesLine.Type::"G/L Account") and
             ((SalesLine."Qty. to Invoice" <> 0) or (SalesLine."Qty. to Ship" <> 0))
          then
            if SalesLine.Type in [SalesLine.Type::"G/L Account",SalesLine.Type::"Fixed Asset"] then
              if (((SalesSetup."Discount Posting" = SalesSetup."discount posting"::"Invoice Discounts") and
                   (SalesLine."Inv. Discount Amount" <> 0)) or
                  ((SalesSetup."Discount Posting" = SalesSetup."discount posting"::"Line Discounts") and
                   (SalesLine."Line Discount Amount" <> 0)) or
                  ((SalesSetup."Discount Posting" = SalesSetup."discount posting"::"All Discounts") and
                   ((SalesLine."Inv. Discount Amount" <> 0) or (SalesLine."Line Discount Amount" <> 0))))
              then begin
                if not GenPostingSetup.Get(SalesLine."Gen. Bus. Posting Group",SalesLine."Gen. Prod. Posting Group") then
                  if SalesLine."Gen. Prod. Posting Group" = '' then
                    Error(
                      GenProdPostingGrDiscErr,
                      SalesLine.FieldName("Gen. Prod. Posting Group"),SalesLine.FieldName("Line No."),SalesLine."Line No.")
                  else
                    GenPostingSetup.Get(SalesLine."Gen. Bus. Posting Group",SalesLine."Gen. Prod. Posting Group");
              end else
                Clear(GenPostingSetup)
            else
              GenPostingSetup.Get(SalesLine."Gen. Bus. Posting Group",SalesLine."Gen. Prod. Posting Group");
    end;


    procedure GetPostedDocumentRecord(SalesHeader: Record "Sales Header";var PostedSalesDocumentVariant: Variant)
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        with SalesHeader do
          case "Document Type" of
            "document type"::Order:
              if Invoice then begin
                SalesInvHeader.Get("Last Posting No.");
                SalesInvHeader.SetRecfilter;
                PostedSalesDocumentVariant := SalesInvHeader;
              end;
            "document type"::Invoice:
              begin
                if "Last Posting No." = '' then
                  SalesInvHeader.Get("No.")
                else
                  SalesInvHeader.Get("Last Posting No.");

                SalesInvHeader.SetRecfilter;
                PostedSalesDocumentVariant := SalesInvHeader;
              end;
            "document type"::"Credit Memo":
              begin
                if "Last Posting No." = '' then
                  SalesCrMemoHeader.Get("No.")
                else
                  SalesCrMemoHeader.Get("Last Posting No.");
                SalesCrMemoHeader.SetRecfilter;
                PostedSalesDocumentVariant := SalesCrMemoHeader;
              end;
            else
              Error(StrSubstNo(NotSupportedDocumentTypeErr,"Document Type"));
          end;
    end;


    procedure SendPostedDocumentRecord(SalesHeader: Record "Sales Header";var DocumentSendingProfile: Record "Document Sending Profile")
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        OfficeManagement: Codeunit "Office Management";
    begin
        with SalesHeader do
          case "Document Type" of
            "document type"::Order:
              begin
                OnSendSalesDocument(Invoice and Ship);
                if Invoice then begin
                  SalesInvHeader.Get("Last Posting No.");
                  SalesInvHeader.SetRecfilter;
                  SalesInvHeader.SendProfile(DocumentSendingProfile);
                end;
                if Ship and Invoice and not (CurrentClientType in [Clienttype::Tablet,Clienttype::Phone]) and
                   (not OfficeManagement.IsAvailable)
                then
                  if not Confirm(DownloadShipmentAlsoQst,true) then
                    exit;
                if Ship then begin
                  SalesShipmentHeader.Get("Last Shipping No.");
                  SalesShipmentHeader.SetRecfilter;
                  SalesShipmentHeader.SendProfile(DocumentSendingProfile);
                end;
              end;
            "document type"::Invoice:
              begin
                if "Last Posting No." = '' then
                  SalesInvHeader.Get("No.")
                else
                  SalesInvHeader.Get("Last Posting No.");

                SalesInvHeader.SetRecfilter;
                SalesInvHeader.SendProfile(DocumentSendingProfile);
              end;
            "document type"::"Credit Memo":
              begin
                if "Last Posting No." = '' then
                  SalesCrMemoHeader.Get("No.")
                else
                  SalesCrMemoHeader.Get("Last Posting No.");
                SalesCrMemoHeader.SetRecfilter;
                SalesCrMemoHeader.SendProfile(DocumentSendingProfile);
              end;
            else
              Error(StrSubstNo(NotSupportedDocumentTypeErr,"Document Type"));
          end;
    end;

    local procedure MakeInventoryAdjustment()
    var
        InvtSetup: Record "Inventory Setup";
        InvtAdjmt: Codeunit "Inventory Adjustment";
    begin
        InvtSetup.Get;
        if InvtSetup."Automatic Cost Adjustment" <>
           InvtSetup."automatic cost adjustment"::Never
        then begin
          InvtAdjmt.SetProperties(true,InvtSetup."Automatic Cost Posting");
          InvtAdjmt.SetJobUpdateProperties(true);
          InvtAdjmt.MakeMultiLevelAdjmt;
        end;
    end;

    local procedure FindNotShippedLines(SalesHeader: Record "Sales Header";var TempSalesLine: Record "Sales Line" temporary)
    begin
        with TempSalesLine do begin
          ResetTempLines(TempSalesLine);
          SetFilter(Quantity,'<>0');
          if SalesHeader."Document Type" = SalesHeader."document type"::Order then
            SetFilter("Qty. to Ship",'<>0');
          SetRange("Shipment No.",'');
        end;
    end;

    local procedure CheckTrackingAndWarehouseForShip(SalesHeader: Record "Sales Header") Ship: Boolean
    var
        TempSalesLine: Record "Sales Line" temporary;
    begin
        with TempSalesLine do begin
          FindNotShippedLines(SalesHeader,TempSalesLine);
          Ship := FindFirst;
          WhseShip := TempWhseShptHeader.FindFirst;
          WhseReceive := TempWhseRcptHeader.FindFirst;
          if Ship then begin
            CheckTrackingSpecification(SalesHeader,TempSalesLine);
            if not (WhseShip or WhseReceive or InvtPickPutaway) then
              CheckWarehouse(TempSalesLine);
          end;
          exit(Ship);
        end;
    end;

    local procedure CheckTrackingAndWarehouseForReceive(SalesHeader: Record "Sales Header") Receive: Boolean
    var
        TempSalesLine: Record "Sales Line" temporary;
    begin
        with TempSalesLine do begin
          ResetTempLines(TempSalesLine);
          SetFilter(Quantity,'<>0');
          SetFilter("Return Qty. to Receive",'<>0');
          SetRange("Return Receipt No.",'');
          Receive := FindFirst;
          WhseShip := TempWhseShptHeader.FindFirst;
          WhseReceive := TempWhseRcptHeader.FindFirst;
          if Receive then begin
            CheckTrackingSpecification(SalesHeader,TempSalesLine);
            if not (WhseReceive or WhseShip or InvtPickPutaway) then
              CheckWarehouse(TempSalesLine);
          end;
          exit(Receive);
        end;
    end;

    local procedure CalcInvoiceDiscountPosting(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";SalesLineACY: Record "Sales Line";var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        if SalesLine."VAT Calculation Type" = SalesLine."vat calculation type"::"Reverse Charge VAT" then
          InvoicePostBuffer.CalcDiscountNoVAT(-SalesLine."Inv. Discount Amount",-SalesLineACY."Inv. Discount Amount")
        else
          InvoicePostBuffer.CalcDiscount(
            SalesHeader."Prices Including VAT",-SalesLine."Inv. Discount Amount",-SalesLineACY."Inv. Discount Amount");
    end;

    local procedure CalcLineDiscountPosting(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";SalesLineACY: Record "Sales Line";var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        if SalesLine."VAT Calculation Type" = SalesLine."vat calculation type"::"Reverse Charge VAT" then
          InvoicePostBuffer.CalcDiscountNoVAT(-SalesLine."Line Discount Amount",-SalesLineACY."Line Discount Amount")
        else
          InvoicePostBuffer.CalcDiscount(
            SalesHeader."Prices Including VAT",-SalesLine."Line Discount Amount",-SalesLineACY."Line Discount Amount");
    end;

    local procedure FindTempItemChargeAssgntSales(SalesLineNo: Integer): Boolean
    begin
        ClearItemChargeAssgntFilter;
        TempItemChargeAssgntSales.SetCurrentkey("Applies-to Doc. Type");
        TempItemChargeAssgntSales.SetRange("Document Line No.",SalesLineNo);
        exit(TempItemChargeAssgntSales.FindSet);
    end;

    local procedure UpdateInvoicedQtyOnShipmentLine(var SalesShptLine: Record "Sales Shipment Line";QtyToBeInvoiced: Decimal;QtyToBeInvoicedBase: Decimal)
    begin
        with SalesShptLine do begin
          "Quantity Invoiced" := "Quantity Invoiced" - QtyToBeInvoiced;
          "Qty. Invoiced (Base)" := "Qty. Invoiced (Base)" - QtyToBeInvoicedBase;
          "Qty. Shipped Not Invoiced" := Quantity - "Quantity Invoiced";
          Modify;
        end;
    end;


    procedure SetPreviewMode(NewPreviewMode: Boolean)
    begin
        PreviewMode := NewPreviewMode;
    end;

    local procedure PostDropOrderShipment(var SalesHeader: Record "Sales Header";var TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary)
    var
        PurchSetup: Record "Purchases & Payables Setup";
        PurchCommentLine: Record "Purch. Comment Line";
        PurchOrderHeader: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        with SalesHeader do
          if TempDropShptPostBuffer.Find('-') then begin
            PurchSetup.Get;
            repeat
              PurchOrderHeader.Get(PurchOrderHeader."document type"::Order,TempDropShptPostBuffer."Order No.");
              PurchPost.ArchiveUnpostedOrder(PurchOrderHeader);
              PurchRcptHeader.Init;
              PurchRcptHeader.TransferFields(PurchOrderHeader);
              PurchRcptHeader."No." := PurchOrderHeader."Receiving No.";
              PurchRcptHeader."Order No." := PurchOrderHeader."No.";
              PurchRcptHeader."Posting Date" := "Posting Date";
              PurchRcptHeader."Document Date" := "Document Date";
              PurchRcptHeader."No. Printed" := 0;
              PurchRcptHeader.Insert;

              ApprovalsMgmt.PostApprovalEntries(RecordId,PurchRcptHeader.RecordId,PurchRcptHeader."No.");

              if PurchSetup."Copy Comments Order to Receipt" then begin
                CopyPurchCommentLines(
                  PurchOrderHeader."Document Type",PurchCommentLine."document type"::Receipt,
                  PurchOrderHeader."No.",PurchRcptHeader."No.");
                RecordLinkManagement.CopyLinks(PurchOrderHeader,PurchRcptHeader);
              end;
              TempDropShptPostBuffer.SetRange("Order No.",TempDropShptPostBuffer."Order No.");
              repeat
                PurchOrderLine.Get(
                  PurchOrderLine."document type"::Order,
                  TempDropShptPostBuffer."Order No.",TempDropShptPostBuffer."Order Line No.");
                PurchRcptLine.Init;
                PurchRcptLine.TransferFields(PurchOrderLine);
                PurchRcptLine."Posting Date" := PurchRcptHeader."Posting Date";
                PurchRcptLine."Document No." := PurchRcptHeader."No.";
                PurchRcptLine.Quantity := TempDropShptPostBuffer.Quantity;
                PurchRcptLine."Quantity (Base)" := TempDropShptPostBuffer."Quantity (Base)";
                PurchRcptLine."Quantity Invoiced" := 0;
                PurchRcptLine."Qty. Invoiced (Base)" := 0;
                PurchRcptLine."Order No." := PurchOrderLine."Document No.";
                PurchRcptLine."Order Line No." := PurchOrderLine."Line No.";
                PurchRcptLine."Qty. Rcd. Not Invoiced" :=
                  PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";

                if PurchRcptLine.Quantity <> 0 then begin
                  PurchRcptLine."Item Rcpt. Entry No." := TempDropShptPostBuffer."Item Shpt. Entry No.";
                  PurchRcptLine."Item Charge Base Amount" := PurchOrderLine."Line Amount"
                end;
                PurchRcptLine.Insert;
                PurchOrderLine."Qty. to Receive" := TempDropShptPostBuffer.Quantity;
                PurchOrderLine."Qty. to Receive (Base)" := TempDropShptPostBuffer."Quantity (Base)";
                PurchPost.UpdateBlanketOrderLine(PurchOrderLine,true,false,false);
              until TempDropShptPostBuffer.Next = 0;
              TempDropShptPostBuffer.SetRange("Order No.");
            until TempDropShptPostBuffer.Next = 0;
          end;
    end;

    local procedure PostInvoicePostBuffer(SalesHeader: Record "Sales Header";var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary)
    var
        LineCount: Integer;
        GLEntryNo: Integer;
    begin
        LineCount := 0;
        if TempInvoicePostBuffer.Find('+') then
          repeat
            LineCount := LineCount + 1;
            if GuiAllowed then
              Window.Update(3,LineCount);

            GLEntryNo := PostInvoicePostBufferLine(SalesHeader,TempInvoicePostBuffer);

            if (TempInvoicePostBuffer."Job No." <> '') and
               (TempInvoicePostBuffer.Type = TempInvoicePostBuffer.Type::"G/L Account")
            then
              JobPostLine.PostSalesGLAccounts(TempInvoicePostBuffer,GLEntryNo);

          until TempInvoicePostBuffer.Next(-1) = 0;

        TempInvoicePostBuffer.DeleteAll;
    end;

    local procedure PostInvoicePostBufferLine(SalesHeader: Record "Sales Header";InvoicePostBuffer: Record "Invoice Post. Buffer") GLEntryNo: Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        with GenJnlLine do begin
          InitNewLine(
            SalesHeader."Posting Date",SalesHeader."Document Date",SalesHeader."Posting Description",
            InvoicePostBuffer."Global Dimension 1 Code",InvoicePostBuffer."Global Dimension 2 Code",
            InvoicePostBuffer."Dimension Set ID",SalesHeader."Reason Code");

          CopyDocumentFields(GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,'');

          CopyFromSalesHeader(SalesHeader);

          CopyFromInvoicePostBuffer(InvoicePostBuffer);
          if InvoicePostBuffer.Type <> InvoicePostBuffer.Type::"Prepmt. Exch. Rate Difference" then
            "Gen. Posting Type" := "gen. posting type"::Sale;
          if InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" then begin
            "FA Posting Type" := "fa posting type"::Disposal;
            CopyFromInvoicePostBufferFA(InvoicePostBuffer);
          end;

          GLEntryNo := RunGenJnlPostLine(GenJnlLine);
        end;
    end;

    local procedure PostItemTracking(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";TrackingSpecificationExists: Boolean;var TempTrackingSpecification: Record "Tracking Specification" temporary;var TempItemLedgEntryNotInvoiced: Record "Item Ledger Entry" temporary;HasATOShippedNotInvoiced: Boolean)
    var
        ItemEntryRelation: Record "Item Entry Relation";
        ReturnRcptLine: Record "Return Receipt Line";
        SalesShptLine: Record "Sales Shipment Line";
        EndLoop: Boolean;
        RemQtyToInvoiceCurrLine: Decimal;
        RemQtyToInvoiceCurrLineBase: Decimal;
        QtyToBeInvoiced: Decimal;
        QtyToBeInvoicedBase: Decimal;
    begin
        with SalesHeader do begin
          EndLoop := false;
          if SalesLine.IsCreditDocType then begin
            if Abs(RemQtyToBeInvoiced) > Abs(SalesLine."Return Qty. to Receive") then begin
              ReturnRcptLine.Reset;
              case "Document Type" of
                "document type"::"Return Order":
                  begin
                    ReturnRcptLine.SetCurrentkey("Return Order No.","Return Order Line No.");
                    ReturnRcptLine.SetRange("Return Order No.",SalesLine."Document No.");
                    ReturnRcptLine.SetRange("Return Order Line No.",SalesLine."Line No.");
                  end;
                "document type"::"Credit Memo":
                  begin
                    ReturnRcptLine.SetRange("Document No.",SalesLine."Return Receipt No.");
                    ReturnRcptLine.SetRange("Line No.",SalesLine."Return Receipt Line No.");
                  end;
              end;
              ReturnRcptLine.SetFilter("Return Qty. Rcd. Not Invd.",'<>0');
              if ReturnRcptLine.Find('-') then begin
                ItemJnlRollRndg := true;
                repeat
                  if TrackingSpecificationExists then begin  // Item Tracking
                    ItemEntryRelation.Get(TempTrackingSpecification."Item Ledger Entry No.");
                    ReturnRcptLine.Get(ItemEntryRelation."Source ID",ItemEntryRelation."Source Ref. No.");
                  end else
                    ItemEntryRelation."Item Entry No." := ReturnRcptLine."Item Rcpt. Entry No.";
                  ReturnRcptLine.TestField("Sell-to Customer No.",SalesLine."Sell-to Customer No.");
                  ReturnRcptLine.TestField(Type,SalesLine.Type);
                  ReturnRcptLine.TestField("No.",SalesLine."No.");
                  ReturnRcptLine.TestField("Gen. Bus. Posting Group",SalesLine."Gen. Bus. Posting Group");
                  ReturnRcptLine.TestField("Gen. Prod. Posting Group",SalesLine."Gen. Prod. Posting Group");
                  ReturnRcptLine.TestField("Job No.",SalesLine."Job No.");
                  ReturnRcptLine.TestField("Unit of Measure Code",SalesLine."Unit of Measure Code");
                  ReturnRcptLine.TestField("Variant Code",SalesLine."Variant Code");
                  if SalesLine."Qty. to Invoice" * ReturnRcptLine.Quantity < 0 then
                    SalesLine.FieldError("Qty. to Invoice",ReturnReceiptSameSignErr);
                  if TrackingSpecificationExists then begin  // Item Tracking
                    QtyToBeInvoiced := TempTrackingSpecification."Qty. to Invoice";
                    QtyToBeInvoicedBase := TempTrackingSpecification."Qty. to Invoice (Base)";
                  end else begin
                    QtyToBeInvoiced := RemQtyToBeInvoiced - SalesLine."Return Qty. to Receive";
                    QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Return Qty. to Receive (Base)";
                  end;
                  if Abs(QtyToBeInvoiced) >
                     Abs(ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced")
                  then begin
                    QtyToBeInvoiced := ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";
                    QtyToBeInvoicedBase := ReturnRcptLine."Quantity (Base)" - ReturnRcptLine."Qty. Invoiced (Base)";
                  end;

                  if TrackingSpecificationExists then
                    ItemTrackingMgt.AdjustQuantityRounding(
                      RemQtyToBeInvoiced,QtyToBeInvoiced,
                      RemQtyToBeInvoicedBase,QtyToBeInvoicedBase);

                  RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                  RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
                  ReturnRcptLine."Quantity Invoiced" :=
                    ReturnRcptLine."Quantity Invoiced" + QtyToBeInvoiced;
                  ReturnRcptLine."Qty. Invoiced (Base)" :=
                    ReturnRcptLine."Qty. Invoiced (Base)" + QtyToBeInvoicedBase;
                  ReturnRcptLine."Return Qty. Rcd. Not Invd." :=
                    ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";
                  ReturnRcptLine.Modify;
                  if SalesLine.Type = SalesLine.Type::Item then
                    PostItemJnlLine(
                      SalesHeader,SalesLine,
                      0,0,
                      QtyToBeInvoiced,
                      QtyToBeInvoicedBase,
                      // ReturnRcptLine."Item Rcpt. Entry No."
                      ItemEntryRelation."Item Entry No.",'',TempTrackingSpecification,false);
                  if TrackingSpecificationExists then
                    EndLoop := (TempTrackingSpecification.Next = 0)
                  else
                    EndLoop :=
                      (ReturnRcptLine.Next = 0) or (Abs(RemQtyToBeInvoiced) <= Abs(SalesLine."Return Qty. to Receive"));
                until EndLoop;
              end else
                Error(
                  ReturnReceiptInvoicedErr,
                  SalesLine."Return Receipt Line No.",SalesLine."Return Receipt No.");
            end;

            if Abs(RemQtyToBeInvoiced) > Abs(SalesLine."Return Qty. to Receive") then begin
              if "Document Type" = "document type"::"Credit Memo" then
                Error(
                  InvoiceGreaterThanReturnReceiptErr,
                  ReturnRcptLine."Document No.");
              Error(ReturnReceiptLinesDeletedErr);
            end;
          end else begin
            if Abs(RemQtyToBeInvoiced) > Abs(SalesLine."Qty. to Ship") then begin
              SalesShptLine.Reset;
              case "Document Type" of
                "document type"::Order:
                  begin
                    SalesShptLine.SetCurrentkey("Order No.","Order Line No.");
                    SalesShptLine.SetRange("Order No.",SalesLine."Document No.");
                    SalesShptLine.SetRange("Order Line No.",SalesLine."Line No.");
                  end;
                "document type"::Invoice:
                  begin
                    SalesShptLine.SetRange("Document No.",SalesLine."Shipment No.");
                    SalesShptLine.SetRange("Line No.",SalesLine."Shipment Line No.");
                  end;
              end;

              if not TrackingSpecificationExists then
                HasATOShippedNotInvoiced := GetATOItemLedgEntriesNotInvoiced(SalesLine,TempItemLedgEntryNotInvoiced);

              SalesShptLine.SetFilter("Qty. Shipped Not Invoiced",'<>0');
              if SalesShptLine.FindFirst then begin
                ItemJnlRollRndg := true;
                repeat
                  SetItemEntryRelation(
                    ItemEntryRelation,SalesShptLine,
                    TempTrackingSpecification,TempItemLedgEntryNotInvoiced,
                    TrackingSpecificationExists,HasATOShippedNotInvoiced);

                  UpdateRemainingQtyToBeInvoiced(SalesShptLine,RemQtyToInvoiceCurrLine,RemQtyToInvoiceCurrLineBase);

                  SalesShptLine.TestField("Sell-to Customer No.",SalesLine."Sell-to Customer No.");
                  SalesShptLine.TestField(Type,SalesLine.Type);
                  SalesShptLine.TestField("No.",SalesLine."No.");
                  SalesShptLine.TestField("Gen. Bus. Posting Group",SalesLine."Gen. Bus. Posting Group");
                  SalesShptLine.TestField("Gen. Prod. Posting Group",SalesLine."Gen. Prod. Posting Group");
                  SalesShptLine.TestField("Job No.",SalesLine."Job No.");
                  SalesShptLine.TestField("Unit of Measure Code",SalesLine."Unit of Measure Code");
                  SalesShptLine.TestField("Variant Code",SalesLine."Variant Code");
                  if -SalesLine."Qty. to Invoice" * SalesShptLine.Quantity < 0 then
                    SalesLine.FieldError("Qty. to Invoice",ShipmentSameSignErr);

                  UpdateQtyToBeInvoiced(
                    QtyToBeInvoiced,QtyToBeInvoicedBase,
                    TrackingSpecificationExists,HasATOShippedNotInvoiced,
                    SalesLine,SalesShptLine,
                    TempTrackingSpecification,TempItemLedgEntryNotInvoiced);

                  if TrackingSpecificationExists or HasATOShippedNotInvoiced then
                    ItemTrackingMgt.AdjustQuantityRounding(
                      RemQtyToInvoiceCurrLine,QtyToBeInvoiced,
                      RemQtyToInvoiceCurrLineBase,QtyToBeInvoicedBase);

                  RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                  RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
                  UpdateInvoicedQtyOnShipmentLine(SalesShptLine,QtyToBeInvoiced,QtyToBeInvoicedBase);
                  if SalesLine.Type = SalesLine.Type::Item then
                    PostItemJnlLine(
                      SalesHeader,SalesLine,
                      0,0,
                      QtyToBeInvoiced,
                      QtyToBeInvoicedBase,
                      // SalesShptLine."Item Shpt. Entry No."
                      ItemEntryRelation."Item Entry No.",'',TempTrackingSpecification,false);
                until IsEndLoopForShippedNotInvoiced(
                        RemQtyToBeInvoiced,TrackingSpecificationExists,HasATOShippedNotInvoiced,
                        SalesShptLine,TempTrackingSpecification,TempItemLedgEntryNotInvoiced,SalesLine);
              end else
                Error(
                  ShipmentInvoiceErr,SalesLine."Shipment Line No.",SalesLine."Shipment No.");
            end;

            if Abs(RemQtyToBeInvoiced) > Abs(SalesLine."Qty. to Ship") then begin
              if "Document Type" = "document type"::Invoice then
                Error(QuantityToInvoiceGreaterErr,SalesShptLine."Document No.");
              Error(ShipmentLinesDeletedErr);
            end;
          end;
        end;
    end;

    local procedure PostUpdateOrderLine(SalesHeader: Record "Sales Header")
    var
        TempSalesLine: Record "Sales Line" temporary;
    begin
        ResetTempLines(TempSalesLine);
        with TempSalesLine do begin
          SetFilter(Quantity,'<>0');
          if FindSet then
            repeat
              if SalesHeader.Ship then begin
                "Quantity Shipped" += "Qty. to Ship";
                "Qty. Shipped (Base)" += "Qty. to Ship (Base)";
              end;
              if SalesHeader.Receive then begin
                "Return Qty. Received" += "Return Qty. to Receive";
                "Return Qty. Received (Base)" += "Return Qty. to Receive (Base)";
              end;
              if SalesHeader.Invoice then begin
                if "Document Type" = "document type"::Order then begin
                  if Abs("Quantity Invoiced" + "Qty. to Invoice") > Abs("Quantity Shipped") then begin
                    Validate("Qty. to Invoice","Quantity Shipped" - "Quantity Invoiced");
                    "Qty. to Invoice (Base)" := "Qty. Shipped (Base)" - "Qty. Invoiced (Base)";
                  end
                end else
                  if Abs("Quantity Invoiced" + "Qty. to Invoice") > Abs("Return Qty. Received") then begin
                    Validate("Qty. to Invoice","Return Qty. Received" - "Quantity Invoiced");
                    "Qty. to Invoice (Base)" := "Return Qty. Received (Base)" - "Qty. Invoiced (Base)";
                  end;

                "Quantity Invoiced" += "Qty. to Invoice";
                "Qty. Invoiced (Base)" += "Qty. to Invoice (Base)";
                if "Qty. to Invoice" <> 0 then begin
                  "Prepmt Amt Deducted" += "Prepmt Amt to Deduct";
                  "Prepmt VAT Diff. Deducted" += "Prepmt VAT Diff. to Deduct";
                  DecrementPrepmtAmtInvLCY(
                    SalesHeader,TempSalesLine,"Prepmt. Amount Inv. (LCY)","Prepmt. VAT Amount Inv. (LCY)");
                  "Prepmt Amt to Deduct" := "Prepmt. Amt. Inv." - "Prepmt Amt Deducted";
                  "Prepmt VAT Diff. to Deduct" := 0;
                end;
              end;

              UpdateBlanketOrderLine(TempSalesLine,SalesHeader.Ship,SalesHeader.Receive,SalesHeader.Invoice);
              InitOutstanding;
              CheckATOLink(TempSalesLine);
              if WhseHandlingRequired(TempSalesLine) or
                 (SalesSetup."Default Quantity to Ship" = SalesSetup."default quantity to ship"::Blank)
              then begin
                if "Document Type" = "document type"::"Return Order" then begin
                  "Return Qty. to Receive" := 0;
                  "Return Qty. to Receive (Base)" := 0;
                end else begin
                  "Qty. to Ship" := 0;
                  "Qty. to Ship (Base)" := 0;
                end;
                InitQtyToInvoice;
              end else begin
                if "Document Type" = "document type"::"Return Order" then
                  InitQtyToReceive
                else
                  InitQtyToShip2;
              end;

              if ("Purch. Order Line No." <> 0) and (Quantity = "Quantity Invoiced") then
                UpdateAssocLines(TempSalesLine);
              SetDefaultQuantity;
              ModifyTempLine(TempSalesLine);
            until Next = 0;
        end;
    end;

    local procedure PostUpdateInvoiceLine(SalesHeader: Record "Sales Header")
    var
        SalesOrderLine: Record "Sales Line";
        SalesShptLine: Record "Sales Shipment Line";
        TempSalesLine: Record "Sales Line" temporary;
    begin
        ResetTempLines(TempSalesLine);
        with TempSalesLine do begin
          SetFilter("Shipment No.",'<>%1','');
          SetFilter(Type,'<>%1',Type::" ");
          if FindSet then
            repeat
              SalesShptLine.Get("Shipment No.","Shipment Line No.");
              SalesOrderLine.Get(
                SalesOrderLine."document type"::Order,
                SalesShptLine."Order No.",SalesShptLine."Order Line No.");
              if Type = Type::"Charge (Item)" then
                UpdateSalesOrderChargeAssgnt(TempSalesLine,SalesOrderLine);
              SalesOrderLine."Quantity Invoiced" += "Qty. to Invoice";
              SalesOrderLine."Qty. Invoiced (Base)" += "Qty. to Invoice (Base)";
              if Abs(SalesOrderLine."Quantity Invoiced") > Abs(SalesOrderLine."Quantity Shipped") then
                Error(InvoiceMoreThanShippedErr,SalesOrderLine."Document No.");
              SalesOrderLine.InitQtyToInvoice;
              if SalesOrderLine."Prepayment %" <> 0 then begin
                SalesOrderLine."Prepmt Amt Deducted" += "Prepmt Amt to Deduct";
                SalesOrderLine."Prepmt VAT Diff. Deducted" += "Prepmt VAT Diff. to Deduct";
                DecrementPrepmtAmtInvLCY(
                  SalesHeader,TempSalesLine,SalesOrderLine."Prepmt. Amount Inv. (LCY)",SalesOrderLine."Prepmt. VAT Amount Inv. (LCY)");
                SalesOrderLine."Prepmt Amt to Deduct" :=
                  SalesOrderLine."Prepmt. Amt. Inv." - SalesOrderLine."Prepmt Amt Deducted";
                SalesOrderLine."Prepmt VAT Diff. to Deduct" := 0;
              end;
              SalesOrderLine.InitOutstanding;
              if (SalesOrderLine."Purch. Order Line No." <> 0) and
                 (SalesOrderLine.Quantity = SalesOrderLine."Quantity Invoiced")
              then
                UpdateAssocLines(SalesOrderLine);
              SalesOrderLine.Modify;
            until Next = 0;
        end;
    end;

    local procedure PostUpdateReturnReceiptLine()
    var
        SalesOrderLine: Record "Sales Line";
        ReturnRcptLine: Record "Return Receipt Line";
        TempSalesLine: Record "Sales Line" temporary;
    begin
        ResetTempLines(TempSalesLine);
        with TempSalesLine do begin
          SetFilter("Return Receipt No.",'<>%1','');
          SetFilter(Type,'<>%1',Type::" ");
          if FindSet then
            repeat
              ReturnRcptLine.Get("Return Receipt No.","Return Receipt Line No.");
              SalesOrderLine.Get(
                SalesOrderLine."document type"::"Return Order",
                ReturnRcptLine."Return Order No.",ReturnRcptLine."Return Order Line No.");
              if Type = Type::"Charge (Item)" then
                UpdateSalesOrderChargeAssgnt(TempSalesLine,SalesOrderLine);
              SalesOrderLine."Quantity Invoiced" += "Qty. to Invoice";
              SalesOrderLine."Qty. Invoiced (Base)" += "Qty. to Invoice (Base)";
              if Abs(SalesOrderLine."Quantity Invoiced") > Abs(SalesOrderLine."Return Qty. Received") then
                Error(InvoiceMoreThanReceivedErr,SalesOrderLine."Document No.");
              SalesOrderLine.InitQtyToInvoice;
              SalesOrderLine.InitOutstanding;
              SalesOrderLine.Modify;
            until Next = 0;
        end;
    end;

    local procedure FillDeferralPostingBuffer(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";InvoicePostBuffer: Record "Invoice Post. Buffer";RemainAmtToDefer: Decimal;RemainAmtToDeferACY: Decimal;DeferralAccount: Code[20];SalesAccount: Code[20])
    var
        DeferralTemplate: Record "Deferral Template";
    begin
        DeferralTemplate.Get(SalesLine."Deferral Code");

        if TempDeferralHeader.Get(DeferralUtilities.GetSalesDeferralDocType,'','',
             SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.")
        then begin
          if TempDeferralHeader."Amount to Defer" <> 0 then begin
            TempDeferralLine.SetRange("Deferral Doc. Type",DeferralUtilities.GetSalesDeferralDocType);
            TempDeferralLine.SetRange("Gen. Jnl. Template Name",'');
            TempDeferralLine.SetRange("Gen. Jnl. Batch Name",'');
            TempDeferralLine.SetRange("Document Type",SalesLine."Document Type");
            TempDeferralLine.SetRange("Document No.",SalesLine."Document No.");
            TempDeferralLine.SetRange("Line No.",SalesLine."Line No.");

            // The remaining amounts only need to be adjusted into the deferral account and are always reversed
            if (RemainAmtToDefer <> 0) or (RemainAmtToDeferACY <> 0) then begin
              DeferralPostBuffer[1].PrepareSales(SalesLine,GenJnlLineDocNo);
              DeferralPostBuffer[1]."Amount (LCY)" := RemainAmtToDefer;
              DeferralPostBuffer[1].Amount := RemainAmtToDeferACY;
              DeferralPostBuffer[1]."Sales/Purch Amount (LCY)" := 0;
              DeferralPostBuffer[1]."Sales/Purch Amount" := 0;
              DeferralPostBuffer[1].ReverseAmounts;
              DeferralPostBuffer[1]."G/L Account" := SalesAccount;
              DeferralPostBuffer[1]."Deferral Account" := DeferralAccount;
              // Remainder always goes to the Posting Date
              DeferralPostBuffer[1]."Posting Date" := SalesHeader."Posting Date";
              DeferralPostBuffer[1].Description := SalesHeader."Posting Description";
              DeferralPostBuffer[1]."Period Description" := DeferralTemplate."Period Description";
              DeferralPostBuffer[1]."Deferral Line No." := InvDefLineNo;
              DeferralPostBuffer[1]."Partial Deferral" := true;
              UpdDeferralPostBuffer(InvoicePostBuffer);
            end;

            // Add the deferral lines for each period to the deferral posting buffer merging when they are the same
            if TempDeferralLine.FindSet then
              repeat
                if (TempDeferralLine."Amount (LCY)" <> 0) or (TempDeferralLine.Amount <> 0) then begin
                  DeferralPostBuffer[1].PrepareSales(SalesLine,GenJnlLineDocNo);
                  DeferralPostBuffer[1]."Amount (LCY)" := TempDeferralLine."Amount (LCY)";
                  DeferralPostBuffer[1].Amount := TempDeferralLine.Amount;
                  DeferralPostBuffer[1]."Sales/Purch Amount (LCY)" := TempDeferralLine."Amount (LCY)";
                  DeferralPostBuffer[1]."Sales/Purch Amount" := TempDeferralLine.Amount;
                  if not SalesLine.IsCreditDocType then
                    DeferralPostBuffer[1].ReverseAmounts;
                  DeferralPostBuffer[1]."G/L Account" := SalesAccount;
                  DeferralPostBuffer[1]."Deferral Account" := DeferralAccount;
                  DeferralPostBuffer[1]."Posting Date" := TempDeferralLine."Posting Date";
                  DeferralPostBuffer[1].Description := TempDeferralLine.Description;
                  DeferralPostBuffer[1]."Period Description" := DeferralTemplate."Period Description";
                  DeferralPostBuffer[1]."Deferral Line No." := InvDefLineNo;
                  UpdDeferralPostBuffer(InvoicePostBuffer);
                end else
                  Error(ZeroDeferralAmtErr,SalesLine."No.",SalesLine."Deferral Code");

              until TempDeferralLine.Next = 0

            else
              Error(NoDeferralScheduleErr,SalesLine."No.",SalesLine."Deferral Code");
          end else
            Error(NoDeferralScheduleErr,SalesLine."No.",SalesLine."Deferral Code")
        end else
          Error(NoDeferralScheduleErr,SalesLine."No.",SalesLine."Deferral Code");
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

    local procedure RoundDeferralsForArchive(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line")
    var
        DeferralHeader: Record "Deferral Header";
        AmtToDefer: Decimal;
        AmtToDeferACY: Decimal;
    begin
        SalesLine.SetFilter("Deferral Code",'<>%1','');
        if SalesLine.FindSet then
          repeat
            if DeferralHeader.Get(DeferralUtilities.GetSalesDeferralDocType,'','',
                 SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.")
            then
              DeferralUtilities.RoundDeferralAmount(
                DeferralHeader,SalesHeader."Currency Code",
                SalesHeader."Currency Factor",SalesHeader."Posting Date",
                AmtToDeferACY,AmtToDefer);

          until SalesLine.Next = 0;
    end;

    local procedure GetAmountsForDeferral(SalesLine: Record "Sales Line";var AmtToDefer: Decimal;var AmtToDeferACY: Decimal;var DeferralAccount: Code[20])
    var
        DeferralTemplate: Record "Deferral Template";
    begin
        DeferralTemplate.Get(SalesLine."Deferral Code");
        DeferralTemplate.TestField("Deferral Account");
        DeferralAccount := DeferralTemplate."Deferral Account";

        if TempDeferralHeader.Get(DeferralUtilities.GetSalesDeferralDocType,'','',
             SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.")
        then begin
          AmtToDeferACY := TempDeferralHeader."Amount to Defer";
          AmtToDefer := TempDeferralHeader."Amount to Defer (LCY)";
        end;

        if not SalesLine.IsCreditDocType then begin
          AmtToDefer := -AmtToDefer;
          AmtToDeferACY := -AmtToDeferACY;
        end;
    end;

    local procedure CheckMandatoryHeaderFields(SalesHeader: Record "Sales Header")
    begin
        SalesHeader.TestField("Document Type");
        SalesHeader.TestField("Sell-to Customer No.");
        SalesHeader.TestField("Bill-to Customer No.");
        SalesHeader.TestField("Posting Date");
        SalesHeader.TestField("Document Date");
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

    local procedure ClearPostBuffers()
    begin
        Clear(WhsePostRcpt);
        Clear(WhsePostShpt);
        Clear(GenJnlPostLine);
        Clear(ResJnlPostLine);
        Clear(JobPostLine);
        Clear(ItemJnlPostLine);
        Clear(WhseJnlPostLine);
    end;

    local procedure SetPostingFlags(var SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do begin
          case "Document Type" of
            "document type"::Order:
              Receive := false;
            "document type"::Invoice:
              begin
                Ship := true;
                Invoice := true;
                Receive := false;
              end;
            "document type"::"Return Order":
              Ship := false;
            "document type"::"Credit Memo":
              begin
                Ship := false;
                Invoice := true;
                Receive := true;
              end;
          end;
          if not (Ship or Invoice or Receive) then
            Error(ShipInvoiceReceiveErr);
        end;
    end;

    local procedure SetTaxType(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line")
    begin
        TaxOption := 0;
        if SalesHeader.Invoice then begin
          SalesLine.SetFilter("Qty. to Invoice",'<>0');
          if SalesLine.Find('-') then
            repeat
              if SalesLine."VAT Calculation Type" = SalesLine."vat calculation type"::"Sales Tax" then begin
                if SalesLine."Tax Area Code" <> '' then begin
                  if SalesTaxCountry = Salestaxcountry::NoTax then
                    Error(EveryLineMustHaveSameErr,SalesLine.FieldCaption("Tax Area Code"),SalesLine."Tax Area Code");
                  TaxArea.Get(SalesLine."Tax Area Code");
                  if TaxArea."Country/Region" <> SalesTaxCountry then
                    Error(TaxAreaSetupShouldBeSameErr,TaxArea.FieldCaption("Country/Region"),SalesTaxCountry);
                  if TaxArea."Use External Tax Engine" <> UseExternalTaxEngine then
                    Error(TaxAreaSetupShouldBeSameErr,TaxArea.FieldCaption("Use External Tax Engine"),UseExternalTaxEngine);
                end;
                if TaxOption = 0 then begin
                  TaxOption := Taxoption::SalesTax;
                  if SalesLine."Tax Area Code" <> '' then
                    AddSalesTaxLineToSalesTaxCalc(SalesHeader,SalesLine,true);
                end else
                  if TaxOption = Taxoption::VAT then
                    Error(EveryLineMustHaveSameErr,SalesLine.FieldCaption("VAT Calculation Type"),TaxOption)
                  else
                    if SalesLine."Tax Area Code" <> '' then
                      AddSalesTaxLineToSalesTaxCalc(SalesHeader,SalesLine,false);
              end else begin
                if TaxOption = 0 then
                  TaxOption := Taxoption::VAT
                else
                  if TaxOption = Taxoption::SalesTax then
                    Error(EveryLineMustHaveSameErr,SalesLine.FieldCaption("VAT Calculation Type"),TaxOption);
              end;
            until SalesLine.Next = 0;
          SalesLine.SetRange("Qty. to Invoice");
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostCommitSalesDoc(var SalesHeader: Record "Sales Header";var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";PreviewMode: Boolean;ModifyHeader: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header";var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";SalesShptHdrNo: Code[20];RetRcpHdrNo: Code[20];SalesInvHdrNo: Code[20];SalesCrMemoHdrNo: Code[20];var SalesInvHdr: Record "Sales Invoice Header";var SalesCrMemoHdr: Record "Sales Cr.Memo Header")
    begin
    end;

    local procedure PostResJnlLine(var SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";var JobTaskSalesLine: Record "Sales Line")
    var
        ResJnlLine: Record "Res. Journal Line";
    begin
        if SalesLine."Qty. to Invoice" = 0 then
          exit;

        with ResJnlLine do begin
          Init;
          "Posting Date" := SalesHeader."Posting Date";
          "Document Date" := SalesHeader."Document Date";
          "Reason Code" := SalesHeader."Reason Code";

          CopyDocumentFields(GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,SalesHeader."Posting No. Series");

          CopyFromSalesLine(SalesLine);

          ResJnlPostLine.RunWithCheck(ResJnlLine);
          if JobTaskSalesLine."Job Contract Entry No." > 0 then
            PostJobContractLine(SalesHeader,JobTaskSalesLine);
        end;
    end;

    local procedure UpdateSalesLineDimSetIDFromAppliedEntry(var SalesLineToPost: Record "Sales Line";SalesLine: Record "Sales Line")
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        DimensionMgt: Codeunit DimensionManagement;
        DimSetID: array [10] of Integer;
    begin
        DimSetID[1] := SalesLine."Dimension Set ID";
        with SalesLineToPost do begin
          if "Appl.-to Item Entry" <> 0 then begin
            ItemLedgEntry.Get("Appl.-to Item Entry");
            DimSetID[2] := ItemLedgEntry."Dimension Set ID";
          end;
          "Dimension Set ID" :=
            DimensionMgt.GetCombinedDimensionSetID(DimSetID,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        end;
    end;

    local procedure CalcDeferralAmounts(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";OriginalDeferralAmount: Decimal)
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
        if SalesHeader."Posting Date" = 0D then
          UseDate := WorkDate
        else
          UseDate := SalesHeader."Posting Date";

        if DeferralHeader.Get(
             DeferralUtilities.GetSalesDeferralDocType,'','',SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.")
        then begin
          TempDeferralHeader := DeferralHeader;
          if SalesLine.Quantity <> SalesLine."Qty. to Invoice" then
            TempDeferralHeader."Amount to Defer" :=
              ROUND(TempDeferralHeader."Amount to Defer" *
                SalesLine.GetDeferralAmount / OriginalDeferralAmount,Currency."Amount Rounding Precision");
          TempDeferralHeader."Amount to Defer (LCY)" :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                UseDate,SalesHeader."Currency Code",
                TempDeferralHeader."Amount to Defer",SalesHeader."Currency Factor"));
          TempDeferralHeader.Insert;

          with DeferralLine do begin
            SetRange("Deferral Doc. Type",DeferralHeader."Deferral Doc. Type");
            SetRange("Gen. Jnl. Template Name",DeferralHeader."Gen. Jnl. Template Name");
            SetRange("Gen. Jnl. Batch Name",DeferralHeader."Gen. Jnl. Batch Name");
            SetRange("Document Type",DeferralHeader."Document Type");
            SetRange("Document No.",DeferralHeader."Document No.");
            SetRange("Line No.",DeferralHeader."Line No.");
            if FindSet then begin
              TotalDeferralCount := Count;
              repeat
                DeferralCount := DeferralCount + 1;
                TempDeferralLine.Init;
                TempDeferralLine := DeferralLine;

                if DeferralCount = TotalDeferralCount then begin
                  TempDeferralLine.Amount := TempDeferralHeader."Amount to Defer" - TotalAmount;
                  TempDeferralLine."Amount (LCY)" := TempDeferralHeader."Amount to Defer (LCY)" - TotalAmountLCY;
                end else begin
                  if SalesLine.Quantity <> SalesLine."Qty. to Invoice" then
                    TempDeferralLine.Amount :=
                      ROUND(TempDeferralLine.Amount *
                        SalesLine.GetDeferralAmount / OriginalDeferralAmount,Currency."Amount Rounding Precision");

                  TempDeferralLine."Amount (LCY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        UseDate,SalesHeader."Currency Code",
                        TempDeferralLine.Amount,SalesHeader."Currency Factor"));
                  TotalAmount := TotalAmount + TempDeferralLine.Amount;
                  TotalAmountLCY := TotalAmountLCY + TempDeferralLine."Amount (LCY)";
                end;
                TempDeferralLine.Insert;
              until Next = 0;
            end;
          end;
        end;
    end;

    local procedure CreatePostedDeferralScheduleFromSalesDoc(SalesLine: Record "Sales Line";NewDocumentType: Integer;NewDocumentNo: Code[20];NewLineNo: Integer;PostingDate: Date)
    var
        PostedDeferralHeader: Record "Posted Deferral Header";
        PostedDeferralLine: Record "Posted Deferral Line";
        DeferralTemplate: Record "Deferral Template";
        DeferralAccount: Code[20];
    begin
        if SalesLine."Deferral Code" = '' then
          exit;

        if DeferralTemplate.Get(SalesLine."Deferral Code") then
          DeferralAccount := DeferralTemplate."Deferral Account";

        if TempDeferralHeader.Get(
             DeferralUtilities.GetSalesDeferralDocType,'','',SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.")
        then begin
          PostedDeferralHeader.InitFromDeferralHeader(TempDeferralHeader,'','',
            NewDocumentType,NewDocumentNo,NewLineNo,DeferralAccount,SalesLine."Sell-to Customer No.",PostingDate);
          with TempDeferralLine do begin
            SetRange("Deferral Doc. Type",DeferralUtilities.GetSalesDeferralDocType);
            SetRange("Gen. Jnl. Template Name",'');
            SetRange("Gen. Jnl. Batch Name",'');
            SetRange("Document Type",SalesLine."Document Type");
            SetRange("Document No.",SalesLine."Document No.");
            SetRange("Line No.",SalesLine."Line No.");
            if FindSet then begin
              repeat
                PostedDeferralLine.InitFromDeferralLine(
                  TempDeferralLine,'','',NewDocumentType,NewDocumentNo,NewLineNo,DeferralAccount);
              until Next = 0;
            end;
          end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSendSalesDocument(ShipAndInvoice: Boolean)
    begin
    end;

    local procedure GetAmountRoundingPrecisionInLCY(DocType: Option;DocNo: Code[20];CurrencyCode: Code[10]) AmountRoundingPrecision: Decimal
    var
        SalesHeader: Record "Sales Header";
    begin
        if CurrencyCode = '' then
          exit(GLSetup."Amount Rounding Precision");
        SalesHeader.Get(DocType,DocNo);
        AmountRoundingPrecision := Currency."Amount Rounding Precision" / SalesHeader."Currency Factor";
        if AmountRoundingPrecision < GLSetup."Amount Rounding Precision" then
          exit(GLSetup."Amount Rounding Precision");
        exit(AmountRoundingPrecision);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateSalesTax(var SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";var SalesTaxAmountLine: Record UnknownRecord10011;var LocalwasProcessed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizeInvoicePostingSalesTax(var SalesHeader: Record "Sales Header";var SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizeCreditmemoPostingSalesTax(var SalesHeader: Record "Sales Header";var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
    end;
}

