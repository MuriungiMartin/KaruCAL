#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6529 "Item Tracking Navigate Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ReservEntry: Record "Reservation Entry";
        MiscArticleInfo: Record "Misc. Article Information";
        FixedAsset: Record "Fixed Asset";
        WhseActivLine: Record "Warehouse Activity Line";
        RgstrdWhseActivLine: Record "Registered Whse. Activity Line";
        ServItemLine: Record "Service Item Line";
        Loaner: Record Loaner;
        ServiceItem: Record "Service Item";
        ServiceItemComponent: Record "Service Item Component";
        ServContractLine: Record "Service Contract Line";
        FiledContractLine: Record "Filed Contract Line";
        SerialNoInfo: Record "Serial No. Information";
        LotNoInfo: Record "Lot No. Information";
        WhseEntry: Record "Warehouse Entry";
        PostedInvtPutAwayLine: Record "Posted Invt. Put-away Line";
        PostedInvtPickLine: Record "Posted Invt. Pick Line";
        JobLedgEntry: Record "Job Ledger Entry";
        TempPostedWhseRcptLine: Record "Posted Whse. Receipt Line" temporary;
        TempPostedWhseShptLine: Record "Posted Whse. Shipment Line" temporary;
        TempPurchRcptHeader: Record "Purch. Rcpt. Header" temporary;
        TempPurchInvHeader: Record "Purch. Inv. Header" temporary;
        TempAssemblyLine: Record "Assembly Line" temporary;
        TempAssemblyHeader: Record "Assembly Header" temporary;
        TempPostedAssemblyLine: Record "Posted Assembly Line" temporary;
        TempPostedAssemblyHeader: Record "Posted Assembly Header" temporary;
        TempPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr." temporary;
        TempSalesShptHeader: Record "Sales Shipment Header" temporary;
        TempSalesInvHeader: Record "Sales Invoice Header" temporary;
        TempSalesCrMemoHeader: Record "Sales Cr.Memo Header" temporary;
        TempServShptHeader: Record "Service Shipment Header" temporary;
        TempServInvHeader: Record "Service Invoice Header" temporary;
        TempServCrMemoHeader: Record "Service Cr.Memo Header" temporary;
        TempReturnShipHeader: Record "Return Shipment Header" temporary;
        TempReturnRcptHeader: Record "Return Receipt Header" temporary;
        TempTransShipHeader: Record "Transfer Shipment Header" temporary;
        TempTransRcptHeader: Record "Transfer Receipt Header" temporary;
        TempProdOrder: Record "Production Order" temporary;
        TempSalesLine: Record "Sales Line" temporary;
        TempServLine: Record "Service Line" temporary;
        TempReqLine: Record "Requisition Line" temporary;
        TempPurchLine: Record "Purchase Line" temporary;
        TempItemJnlLine: Record "Item Journal Line" temporary;
        TempProdOrderLine: Record "Prod. Order Line" temporary;
        TempProdOrderComp: Record "Prod. Order Component" temporary;
        TempPlanningComponent: Record "Planning Component" temporary;
        TempTransLine: Record "Transfer Line" temporary;
        TempRecordBuffer: Record "Record Buffer" temporary;
        TempField: Record "Field" temporary;
        TempJobLedgEntry: Record "Job Ledger Entry" temporary;
        LastEntryNo: Integer;


    procedure FindTrackingRecords(SerialNoFilter: Text;LotNoFilter: Text;ItemNoFilter: Text;VariantFilter: Text)
    var
        AssemblyLine: Record "Assembly Line";
        AssemblyHeader: Record "Assembly Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        SalesShptHeader: Record "Sales Shipment Header";
        ServShptHeader: Record "Service Shipment Header";
        ReturnShipHeader: Record "Return Shipment Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        TransShipHeader: Record "Transfer Shipment Header";
        TransRcptHeader: Record "Transfer Receipt Header";
        PostedAssemblyHeader: Record "Posted Assembly Header";
        ProdOrder: Record "Production Order";
        SalesLine: Record "Sales Line";
        ServLine: Record "Service Line";
        ReqLine: Record "Requisition Line";
        PurchLine: Record "Purchase Line";
        ItemJnlLine: Record "Item Journal Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        PlanningComponent: Record "Planning Component";
        TransLine: Record "Transfer Line";
        RecRef: RecordRef;
    begin
        if (SerialNoFilter = '') and (LotNoFilter = '') then
          exit;

        if ItemLedgEntry.ReadPermission then
          with ItemLedgEntry do begin
            Reset;
            if LotNoFilter <> '' then
              if SetCurrentkey("Lot No.") then;
            if SerialNoFilter <> '' then
              if SetCurrentkey("Serial No.") then;
            SetFilter("Lot No.",LotNoFilter);
            SetFilter("Serial No.",SerialNoFilter);
            SetFilter("Item No.",ItemNoFilter);
            SetFilter("Variant Code",VariantFilter);
            if FindSet then
              repeat
                RecRef.GetTable(ItemLedgEntry);
                InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                case "Document Type" of
                  "document type"::"Sales Shipment":
                    if SalesShptHeader.ReadPermission then
                      if SalesShptHeader.Get("Document No.") then begin
                        RecRef.GetTable(SalesShptHeader);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempSalesShptHeader := SalesShptHeader;
                        if TempSalesShptHeader.Insert then;

                        FindPostedWhseShptLine;

                        // Find Invoice if it exists
                        SearchValueEntries;
                      end;
                  "document type"::"Sales Invoice":
                    FindSalesInvoice("Document No.");
                  "document type"::"Service Shipment":
                    if ServShptHeader.ReadPermission then
                      if ServShptHeader.Get("Document No.") then begin
                        RecRef.GetTable(ServShptHeader);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempServShptHeader := ServShptHeader;
                        if TempServShptHeader.Insert then;

                        // Find Invoice if it exists
                        SearchValueEntries;
                      end;
                  "document type"::"Service Invoice":
                    FindServInvoice("Document No.");
                  "document type"::"Service Credit Memo":
                    FindServCrMemo("Document No.");
                  "document type"::"Sales Return Receipt":
                    if ReturnRcptHeader.ReadPermission then
                      if ReturnRcptHeader.Get("Document No.") then begin
                        RecRef.GetTable(ReturnRcptHeader);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempReturnRcptHeader := ReturnRcptHeader;
                        if TempReturnRcptHeader.Insert then;

                        FindPostedWhseRcptLine;

                        // Find CreditMemo if it exists
                        SearchValueEntries;
                      end;
                  "document type"::"Sales Credit Memo":
                    FindSalesCrMemo("Document No.");
                  "document type"::"Purchase Receipt":
                    if PurchRcptHeader.ReadPermission then
                      if PurchRcptHeader.Get("Document No.") then begin
                        RecRef.GetTable(PurchRcptHeader);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempPurchRcptHeader := PurchRcptHeader;
                        if TempPurchRcptHeader.Insert then;

                        FindPostedWhseRcptLine;

                        // Find Invoice if it exists
                        SearchValueEntries;
                      end;
                  "document type"::"Purchase Invoice":
                    FindPurchInvoice("Document No.");
                  "document type"::"Purchase Return Shipment":
                    if ReturnShipHeader.ReadPermission then
                      if ReturnShipHeader.Get("Document No.") then begin
                        RecRef.GetTable(ReturnShipHeader);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempReturnShipHeader := ReturnShipHeader;
                        if TempReturnShipHeader.Insert then;

                        FindPostedWhseShptLine;

                        // Find CreditMemo if it exists
                        SearchValueEntries;
                      end;
                  "document type"::"Purchase Credit Memo":
                    FindPurchCrMemo("Document No.");
                  "document type"::"Transfer Shipment":
                    if TransShipHeader.ReadPermission then
                      if TransShipHeader.Get("Document No.") then begin
                        RecRef.GetTable(TransShipHeader);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempTransShipHeader := TransShipHeader;
                        if TempTransShipHeader.Insert then;

                        FindPostedWhseShptLine;
                      end;
                  "document type"::"Transfer Receipt":
                    if TransRcptHeader.ReadPermission then
                      if TransRcptHeader.Get("Document No.") then begin
                        RecRef.GetTable(TransRcptHeader);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempTransRcptHeader := TransRcptHeader;
                        if TempTransRcptHeader.Insert then;

                        FindPostedWhseRcptLine;
                      end;
                  "document type"::"Posted Assembly":
                    if PostedAssemblyHeader.ReadPermission then
                      if PostedAssemblyHeader.Get("Document No.") then begin
                        RecRef.GetTable(PostedAssemblyHeader);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempPostedAssemblyHeader := PostedAssemblyHeader;
                        if TempPostedAssemblyHeader.Insert then;
                      end;
                  else
                    if "Entry Type" in ["entry type"::Consumption,"entry type"::Output] then
                      if ProdOrder.ReadPermission then begin
                        ProdOrder.SetRange(Status,ProdOrder.Status::Released,ProdOrder.Status::Finished);
                        ProdOrder.SetRange("No.","Document No.");
                        if ProdOrder.FindFirst then begin
                          RecRef.GetTable(ProdOrder);
                          InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                          TempProdOrder := ProdOrder;
                          if TempProdOrder.Insert then;
                        end;
                      end;
                end;
              until Next = 0;
          end;

        if ReservEntry.ReadPermission then
          with ReservEntry do begin
            Reset;
            if LotNoFilter <> '' then
              if SetCurrentkey("Lot No.") then;
            if SerialNoFilter <> '' then
              if SetCurrentkey("Serial No.") then;
            SetFilter("Lot No.",LotNoFilter);
            SetFilter("Serial No.",SerialNoFilter);
            SetFilter("Item No.",ItemNoFilter);
            SetFilter("Variant Code",VariantFilter);
            if FindSet then
              repeat
                RecRef.GetTable(ReservEntry);
                InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                case "Source Type" of
                  Database::"Sales Line":
                    if SalesLine.ReadPermission then
                      if SalesLine.Get("Source Subtype","Source ID","Source Ref. No.") then begin
                        RecRef.GetTable(SalesLine);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempSalesLine := SalesLine;
                        if TempSalesLine.Insert then;
                      end;
                  Database::"Service Line":
                    if ServLine.ReadPermission then
                      if ServLine.Get("Source Subtype","Source ID","Source Ref. No.") then begin
                        RecRef.GetTable(ServLine);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempServLine := ServLine;
                        if TempServLine.Insert then;
                      end;
                  Database::"Purchase Line":
                    if PurchLine.ReadPermission then
                      if PurchLine.Get("Source Subtype","Source ID","Source Ref. No.") then begin
                        RecRef.GetTable(PurchLine);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempPurchLine := PurchLine;
                        if TempPurchLine.Insert then;
                      end;
                  Database::"Requisition Line":
                    if ReqLine.ReadPermission then
                      if ReqLine.Get("Source ID","Source Batch Name","Source Ref. No.") then begin
                        RecRef.GetTable(ReqLine);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempReqLine := ReqLine;
                        if TempReqLine.Insert then;
                      end;
                  Database::"Planning Component":
                    if PlanningComponent.ReadPermission then
                      if PlanningComponent.Get("Source ID","Source Batch Name","Source Prod. Order Line","Source Ref. No.") then begin
                        RecRef.GetTable(PlanningComponent);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempPlanningComponent := PlanningComponent;
                        if TempPlanningComponent.Insert then;
                      end;
                  Database::"Item Journal Line":
                    if ItemJnlLine.ReadPermission then
                      if ItemJnlLine.Get("Source ID","Source Batch Name","Source Ref. No.") then begin
                        RecRef.GetTable(ItemJnlLine);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempItemJnlLine := ItemJnlLine;
                        if TempItemJnlLine.Insert then;
                      end;
                  Database::"Assembly Line":
                    if AssemblyLine.ReadPermission then
                      if AssemblyLine.Get("Source Subtype","Source ID","Source Ref. No.") then begin
                        RecRef.GetTable(AssemblyLine);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempAssemblyLine := AssemblyLine;
                        if TempAssemblyLine.Insert then;
                      end;
                  Database::"Assembly Header":
                    if AssemblyHeader.ReadPermission then
                      if AssemblyHeader.Get("Source Subtype","Source ID") then begin
                        RecRef.GetTable(AssemblyHeader);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempAssemblyHeader := AssemblyHeader;
                        if TempAssemblyHeader.Insert then;
                      end;
                  Database::"Prod. Order Line":
                    if ProdOrderLine.ReadPermission then
                      if ProdOrderLine.Get("Source Subtype","Source ID","Source Prod. Order Line") then begin
                        RecRef.GetTable(ProdOrderLine);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempProdOrderLine := ProdOrderLine;
                        if TempProdOrderLine.Insert then;
                      end;
                  Database::"Prod. Order Component":
                    if ProdOrderComp.ReadPermission then
                      if ProdOrderComp.Get("Source Subtype","Source ID","Source Prod. Order Line","Source Ref. No.") then begin
                        RecRef.GetTable(ProdOrderComp);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempProdOrderComp := ProdOrderComp;
                        if TempProdOrderComp.Insert then;
                      end;
                  Database::"Transfer Line":
                    if TransLine.ReadPermission then
                      if TransLine.Get("Source ID","Source Ref. No.") then begin
                        RecRef.GetTable(TransLine);
                        InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

                        TempTransLine := TransLine;
                        if TempTransLine.Insert then;
                      end;
                end;
              until Next = 0;
          end;

        if WhseActivLine.ReadPermission then
          with WhseActivLine do begin
            Reset;
            if LotNoFilter <> '' then
              if SetCurrentkey("Lot No.") then;
            if SerialNoFilter <> '' then
              if SetCurrentkey("Serial No.") then;
            SetFilter("Lot No.",LotNoFilter);
            SetFilter("Serial No.",SerialNoFilter);
            SetFilter("Item No.",ItemNoFilter);
            SetFilter("Variant Code",VariantFilter);
            if FindSet then
              repeat
                RecRef.GetTable(WhseActivLine);
                InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");
              until Next = 0;
          end;

        if RgstrdWhseActivLine.ReadPermission then
          with RgstrdWhseActivLine do begin
            Reset;
            if LotNoFilter <> '' then
              if SetCurrentkey("Lot No.") then;
            if SerialNoFilter <> '' then
              if SetCurrentkey("Serial No.") then;
            SetFilter("Lot No.",LotNoFilter);
            SetFilter("Serial No.",SerialNoFilter);
            SetFilter("Item No.",ItemNoFilter);
            SetFilter("Variant Code",VariantFilter);
            if FindSet then
              repeat
                RecRef.GetTable(RgstrdWhseActivLine);
                InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");
              until Next = 0;
          end;

        if WhseEntry.ReadPermission then
          with WhseEntry do begin
            Reset;
            if LotNoFilter <> '' then
              if SetCurrentkey("Lot No.") then;
            if SerialNoFilter <> '' then
              if SetCurrentkey("Serial No.") then;
            SetFilter("Lot No.",LotNoFilter);
            SetFilter("Serial No.",SerialNoFilter);
            SetFilter("Item No.",ItemNoFilter);
            SetFilter("Variant Code",VariantFilter);
            if FindSet then
              repeat
                RecRef.GetTable(WhseEntry);
                InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");
              until Next = 0;
          end;

        if PostedInvtPutAwayLine.ReadPermission then
          with PostedInvtPutAwayLine do begin
            Reset;
            if LotNoFilter <> '' then
              if SetCurrentkey("Lot No.") then;
            if SerialNoFilter <> '' then
              if SetCurrentkey("Serial No.") then;
            SetFilter("Lot No.",LotNoFilter);
            SetFilter("Serial No.",SerialNoFilter);
            SetFilter("Item No.",ItemNoFilter);
            SetFilter("Variant Code",VariantFilter);
            if FindSet then
              repeat
                RecRef.GetTable(PostedInvtPutAwayLine);
                InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");
              until Next = 0;
          end;

        if PostedInvtPickLine.ReadPermission then
          with PostedInvtPickLine do begin
            Reset;
            if LotNoFilter <> '' then
              if SetCurrentkey("Lot No.") then;
            if SerialNoFilter <> '' then
              if SetCurrentkey("Serial No.") then;
            SetFilter("Lot No.",LotNoFilter);
            SetFilter("Serial No.",SerialNoFilter);
            SetFilter("Item No.",ItemNoFilter);
            SetFilter("Variant Code",VariantFilter);
            if FindSet then
              repeat
                RecRef.GetTable(PostedInvtPickLine);
                InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");
              until Next = 0;
          end;

        // Only LotNos
        if LotNoFilter <> '' then
          FindLotNoInfo(LotNoFilter,ItemNoFilter,VariantFilter);

        // Only SerialNos
        if SerialNoFilter <> '' then begin
          FindSerialNoInfo(SerialNoFilter,ItemNoFilter,VariantFilter);

          if MiscArticleInfo.ReadPermission then
            with MiscArticleInfo do begin
              Reset;
              if SetCurrentkey("Serial No.") then;
              SetFilter("Serial No.",SerialNoFilter);
              if FindSet then
                repeat
                  RecRef.GetTable(MiscArticleInfo);
                  InsertBufferRec(RecRef,"Serial No.",'','','');
                until Next = 0;
            end;

          if FixedAsset.ReadPermission then
            with FixedAsset do begin
              Reset;
              if SetCurrentkey("Serial No.") then;
              SetFilter("Serial No.",SerialNoFilter);
              if FindSet then
                repeat
                  RecRef.GetTable(FixedAsset);
                  InsertBufferRec(RecRef,"Serial No.",'','','');
                until Next = 0;
            end;

          if ServItemLine.ReadPermission then
            with ServItemLine do begin
              Reset;
              if SetCurrentkey("Serial No.") then;
              SetFilter("Serial No.",SerialNoFilter);
              SetFilter("Item No.",ItemNoFilter);
              SetFilter("Variant Code",VariantFilter);
              if FindSet then
                repeat
                  RecRef.GetTable(ServItemLine);
                  InsertBufferRec(RecRef,"Serial No.",'',"Item No.","Variant Code");
                until Next = 0;
            end;

          if Loaner.ReadPermission then
            with Loaner do begin
              Reset;
              if SetCurrentkey("Serial No.") then;
              SetFilter("Serial No.",SerialNoFilter);
              SetFilter("Item No.",ItemNoFilter);
              if FindSet then
                repeat
                  RecRef.GetTable(Loaner);
                  InsertBufferRec(RecRef,"Serial No.",'',"Item No.",'');
                until Next = 0;
            end;

          if ServiceItem.ReadPermission then
            with ServiceItem do begin
              Reset;
              if SetCurrentkey("Serial No.") then;
              SetFilter("Serial No.",SerialNoFilter);
              SetFilter("Item No.",ItemNoFilter);
              SetFilter("Variant Code",VariantFilter);
              if FindSet then
                repeat
                  RecRef.GetTable(ServiceItem);
                  InsertBufferRec(RecRef,"Serial No.",'',"Item No.","Variant Code");
                until Next = 0;
            end;

          if ServiceItemComponent.ReadPermission then
            with ServiceItemComponent do begin
              Reset;
              if SetCurrentkey("Serial No.") then;
              SetFilter("Serial No.",SerialNoFilter);
              SetFilter("Parent Service Item No.",ItemNoFilter);
              SetFilter("Variant Code",VariantFilter);
              if FindSet then
                repeat
                  RecRef.GetTable(ServiceItemComponent);
                  InsertBufferRec(RecRef,"Serial No.",'',"Parent Service Item No.","Variant Code");
                until Next = 0;
            end;

          if ServContractLine.ReadPermission then
            with ServContractLine do begin
              Reset;
              if SetCurrentkey("Serial No.") then;
              SetFilter("Serial No.",SerialNoFilter);
              SetFilter("Item No.",ItemNoFilter);
              SetFilter("Variant Code",VariantFilter);
              if FindSet then
                repeat
                  RecRef.GetTable(ServContractLine);
                  InsertBufferRec(RecRef,"Serial No.",'',"Item No.","Variant Code");
                until Next = 0;
            end;

          if FiledContractLine.ReadPermission then
            with FiledContractLine do begin
              Reset;
              if SetCurrentkey("Serial No.") then;
              SetFilter("Serial No.",SerialNoFilter);
              SetFilter("Item No.",ItemNoFilter);
              SetFilter("Variant Code",VariantFilter);
              if FindSet then
                repeat
                  RecRef.GetTable(FiledContractLine);
                  InsertBufferRec(RecRef,"Serial No.",'',"Item No.","Variant Code");
                until Next = 0;
            end;
        end;

        if JobLedgEntry.ReadPermission then
          with JobLedgEntry do begin
            Reset;
            if LotNoFilter <> '' then
              if SetCurrentkey("Lot No.") then;
            if SerialNoFilter <> '' then
              if SetCurrentkey("Serial No.") then;
            SetFilter("Lot No.",LotNoFilter);
            SetFilter("Serial No.",SerialNoFilter);
            SetFilter("Variant Code",VariantFilter);
            if FindSet then
              repeat
                RecRef.GetTable(JobLedgEntry);
                InsertBufferRec(RecRef,"Serial No.","Lot No.",'',"Variant Code");
                TempJobLedgEntry := JobLedgEntry;
                if TempJobLedgEntry.Insert then;
              until Next = 0;
          end;
    end;

    local procedure FindLotNoInfo(LotNoFilter: Text;ItemNoFilter: Text;VariantFilter: Text)
    var
        RecRef: RecordRef;
    begin
        if LotNoInfo.ReadPermission then
          with LotNoInfo do begin
            Reset;
            if SetCurrentkey("Lot No.") then;
            SetFilter("Lot No.",LotNoFilter);
            SetFilter("Item No.",ItemNoFilter);
            SetFilter("Variant Code",VariantFilter);
            if FindSet then
              repeat
                RecRef.GetTable(LotNoInfo);
                InsertBufferRec(RecRef,'',"Lot No.","Item No.","Variant Code");
              until Next = 0;
          end;
    end;

    local procedure FindSerialNoInfo(SerialNoFilter: Text;ItemNoFilter: Text;VariantFilter: Text)
    var
        RecRef: RecordRef;
    begin
        if SerialNoInfo.ReadPermission then
          with SerialNoInfo do begin
            Reset;
            if SetCurrentkey("Serial No.") then;
            SetFilter("Serial No.",SerialNoFilter);
            SetFilter("Item No.",ItemNoFilter);
            SetFilter("Variant Code",VariantFilter);
            if FindSet then
              repeat
                RecRef.GetTable(SerialNoInfo);
                InsertBufferRec(RecRef,"Serial No.",'',"Item No.","Variant Code");
              until Next = 0;
          end;
    end;

    local procedure SearchValueEntries()
    var
        ValueEntry: Record "Value Entry";
    begin
        if ValueEntry.ReadPermission then
          with ValueEntry do begin
            Reset;
            SetCurrentkey("Item Ledger Entry No.");
            SetRange("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
            SetRange("Entry Type","entry type"::"Direct Cost");
            SetFilter("Document Type",'<>%1',ItemLedgEntry."Document Type");
            if FindSet then
              repeat
                case "Document Type" of
                  "document type"::"Sales Invoice":
                    FindSalesInvoice("Document No.");
                  "document type"::"Sales Credit Memo":
                    FindSalesCrMemo("Document No.");
                  "document type"::"Service Invoice":
                    FindServInvoice("Document No.");
                  "document type"::"Service Credit Memo":
                    FindServCrMemo("Document No.");
                  "document type"::"Purchase Invoice":
                    FindPurchInvoice("Document No.");
                  "document type"::"Purchase Credit Memo":
                    FindPurchCrMemo("Document No.");
                end;
              until Next = 0;
          end;
    end;

    local procedure FindSalesInvoice(DocumentNo: Code[20])
    var
        SalesInvHeader: Record "Sales Invoice Header";
        RecRef: RecordRef;
    begin
        if SalesInvHeader.ReadPermission then
          if SalesInvHeader.Get(DocumentNo) then begin
            RecRef.GetTable(SalesInvHeader);
            with ItemLedgEntry do
              InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

            TempSalesInvHeader := SalesInvHeader;
            if TempSalesInvHeader.Insert then;
          end;
    end;

    local procedure FindSalesCrMemo(DocumentNo: Code[20])
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        RecRef: RecordRef;
    begin
        if SalesCrMemoHeader.ReadPermission then
          if SalesCrMemoHeader.Get(DocumentNo) then begin
            RecRef.GetTable(SalesCrMemoHeader);
            with ItemLedgEntry do
              InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

            TempSalesCrMemoHeader := SalesCrMemoHeader;
            if TempSalesCrMemoHeader.Insert then;
          end;
    end;

    local procedure FindServInvoice(DocumentNo: Code[20])
    var
        ServInvHeader: Record "Service Invoice Header";
        RecRef: RecordRef;
    begin
        if ServInvHeader.ReadPermission then
          if ServInvHeader.Get(DocumentNo) then begin
            RecRef.GetTable(ServInvHeader);
            with ItemLedgEntry do
              InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

            TempServInvHeader := ServInvHeader;
            if TempServInvHeader.Insert then;
          end;
    end;

    local procedure FindServCrMemo(DocumentNo: Code[20])
    var
        ServCrMemoHeader: Record "Service Cr.Memo Header";
        RecRef: RecordRef;
    begin
        if ServCrMemoHeader.ReadPermission then
          if ServCrMemoHeader.Get(DocumentNo) then begin
            RecRef.GetTable(ServCrMemoHeader);
            with ItemLedgEntry do
              InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

            TempServCrMemoHeader := ServCrMemoHeader;
            if TempServCrMemoHeader.Insert then;
          end;
    end;

    local procedure FindPurchInvoice(DocumentNo: Code[20])
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        RecRef: RecordRef;
    begin
        if PurchInvHeader.ReadPermission then
          if PurchInvHeader.Get(DocumentNo) then begin
            RecRef.GetTable(PurchInvHeader);
            with ItemLedgEntry do
              InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

            TempPurchInvHeader := PurchInvHeader;
            if TempPurchInvHeader.Insert then;
          end;
    end;

    local procedure FindPurchCrMemo(DocumentNo: Code[20])
    var
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        RecRef: RecordRef;
    begin
        if PurchCrMemoHeader.ReadPermission then
          if PurchCrMemoHeader.Get(DocumentNo) then begin
            RecRef.GetTable(PurchCrMemoHeader);
            with ItemLedgEntry do
              InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

            TempPurchCrMemoHeader := PurchCrMemoHeader;
            if TempPurchCrMemoHeader.Insert then;
          end;
    end;

    local procedure FindPostedWhseShptLine()
    var
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        RecRef: RecordRef;
    begin
        if PostedWhseShptLine.ReadPermission then
          with PostedWhseShptLine do begin
            Reset;
            SetCurrentkey("Posted Source No.","Posting Date");
            SetRange("Posted Source No.",ItemLedgEntry."Document No.");
            SetRange("Posting Date",ItemLedgEntry."Posting Date");
            SetRange("Item No.",ItemLedgEntry."Item No.");
            SetRange("Variant Code",ItemLedgEntry."Variant Code");
            SetRange("Source Line No.",ItemLedgEntry."Document Line No.");
            if FindFirst then begin
              RecRef.GetTable(PostedWhseShptLine);
              with ItemLedgEntry do
                InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

              TempPostedWhseShptLine := PostedWhseShptLine;
              if TempPostedWhseShptLine.Insert then;
            end;
          end;
    end;

    local procedure FindPostedWhseRcptLine()
    var
        PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
        RecRef: RecordRef;
    begin
        if PostedWhseRcptLine.ReadPermission then
          with PostedWhseRcptLine do begin
            Reset;
            SetCurrentkey("Posted Source No.","Posting Date");
            SetRange("Posted Source No.",ItemLedgEntry."Document No.");
            SetRange("Posting Date",ItemLedgEntry."Posting Date");
            SetRange("Item No.",ItemLedgEntry."Item No.");
            SetRange("Variant Code",ItemLedgEntry."Variant Code");
            SetRange("Source Line No.",ItemLedgEntry."Document Line No.");
            if FindFirst then begin
              RecRef.GetTable(PostedWhseRcptLine);
              with ItemLedgEntry do
                InsertBufferRec(RecRef,"Serial No.","Lot No.","Item No.","Variant Code");

              TempPostedWhseRcptLine := PostedWhseRcptLine;
              if TempPostedWhseRcptLine.Insert then;
            end;
          end;
    end;


    procedure Show(TableNo: Integer)
    begin
        case TableNo of
          Database::"Item Ledger Entry":
            Page.Run(0,ItemLedgEntry);
          Database::"Reservation Entry":
            Page.Run(0,ReservEntry);
          Database::"Misc. Article Information":
            Page.Run(0,MiscArticleInfo);
          Database::"Fixed Asset":
            Page.Run(0,FixedAsset);
          Database::"Warehouse Activity Line":
            Page.Run(0,WhseActivLine);
          Database::"Registered Whse. Activity Line":
            Page.Run(0,RgstrdWhseActivLine);
          Database::"Service Item Line":
            Page.Run(0,ServItemLine);
          Database::Loaner:
            Page.Run(0,Loaner);
          Database::"Service Item":
            Page.Run(0,ServiceItem);
          Database::"Service Item Component":
            Page.Run(0,ServiceItemComponent);
          Database::"Service Contract Line":
            Page.Run(0,ServContractLine);
          Database::"Filed Contract Line":
            Page.Run(0,FiledContractLine);
          Database::"Serial No. Information":
            Page.Run(0,SerialNoInfo);
          Database::"Lot No. Information":
            Page.Run(0,LotNoInfo);
          Database::"Warehouse Entry":
            Page.Run(0,WhseEntry);
          Database::"Posted Whse. Shipment Line":
            Page.Run(0,TempPostedWhseShptLine);
          Database::"Posted Whse. Receipt Line":
            Page.Run(0,TempPostedWhseRcptLine);
          Database::"Posted Invt. Put-away Line":
            Page.Run(0,PostedInvtPutAwayLine);
          Database::"Posted Invt. Pick Line":
            Page.Run(0,PostedInvtPickLine);
          Database::"Purch. Rcpt. Header":
            Page.Run(0,TempPurchRcptHeader);
          Database::"Purch. Inv. Header":
            Page.Run(0,TempPurchInvHeader);
          Database::"Purch. Cr. Memo Hdr.":
            Page.Run(0,TempPurchCrMemoHeader);
          Database::"Sales Shipment Header":
            Page.Run(0,TempSalesShptHeader);
          Database::"Sales Invoice Header":
            Page.Run(0,TempSalesInvHeader);
          Database::"Sales Cr.Memo Header":
            Page.Run(0,TempSalesCrMemoHeader);
          Database::"Service Shipment Header":
            Page.Run(0,TempServShptHeader);
          Database::"Service Invoice Header":
            Page.Run(0,TempServInvHeader);
          Database::"Service Cr.Memo Header":
            Page.Run(0,TempServCrMemoHeader);
          Database::"Transfer Shipment Header":
            Page.Run(0,TempTransShipHeader);
          Database::"Return Shipment Header":
            Page.Run(0,TempReturnShipHeader);
          Database::"Return Receipt Header":
            Page.Run(0,TempReturnRcptHeader);
          Database::"Transfer Receipt Header":
            Page.Run(0,TempTransRcptHeader);
          Database::"Production Order":
            Page.Run(0,TempProdOrder);
          Database::"Sales Line":
            Page.Run(0,TempSalesLine);
          Database::"Service Line":
            Page.Run(0,TempServLine);
          Database::"Purchase Line":
            Page.Run(0,TempPurchLine);
          Database::"Requisition Line":
            Page.Run(0,TempReqLine);
          Database::"Item Journal Line":
            Page.Run(0,TempItemJnlLine);
          Database::"Prod. Order Line":
            Page.Run(0,TempProdOrderLine);
          Database::"Prod. Order Component":
            Page.Run(0,TempProdOrderComp);
          Database::"Planning Component":
            Page.Run(0,TempPlanningComponent);
          Database::"Transfer Line":
            Page.Run(0,TempTransLine);
          Database::"Job Ledger Entry":
            Page.Run(0,TempJobLedgEntry);
          Database::"Assembly Line":
            Page.Run(0,TempAssemblyLine);
          Database::"Assembly Header":
            Page.Run(0,TempAssemblyHeader);
          Database::"Posted Assembly Line":
            Page.Run(0,TempPostedAssemblyLine);
          Database::"Posted Assembly Header":
            Page.Run(0,TempPostedAssemblyHeader);
        end;
    end;

    local procedure InsertBufferRec(RecRef: RecordRef;SerialNo: Code[20];LotNo: Code[20];ItemNo: Code[20];Variant: Code[10])
    var
        KeyFldRef: FieldRef;
        KeyRef1: KeyRef;
        i: Integer;
    begin
        if (SerialNo = '') and (LotNo = '') then
          exit;

        TempRecordBuffer.SetCurrentkey("Search Record ID");
        TempRecordBuffer.SetRange("Search Record ID",Format(RecRef.RecordId));
        TempRecordBuffer.SetRange("Serial No.",SerialNo);
        TempRecordBuffer.SetRange("Lot No.",LotNo);
        TempRecordBuffer.SetRange("Item No.",ItemNo);
        TempRecordBuffer.SetRange("Variant Code",Variant);
        if not TempRecordBuffer.Find('-') then begin
          TempRecordBuffer.Init;
          TempRecordBuffer."Entry No." := LastEntryNo + 10;
          LastEntryNo := TempRecordBuffer."Entry No.";

          TempRecordBuffer."Table No." := RecRef.Number;
          TempRecordBuffer."Table Name" := GetTableCaption(RecRef.Number);
          TempRecordBuffer."Record Identifier" := RecRef.RecordId;
          TempRecordBuffer."Search Record ID" := Format(TempRecordBuffer."Record Identifier");

          KeyRef1 := RecRef.KeyIndex(1);
          for i := 1 to KeyRef1.FieldCount do begin
            KeyFldRef := KeyRef1.FieldIndex(i);
            if i = 1 then
              TempRecordBuffer."Primary Key" :=
                StrSubstNo('%1=%2',KeyFldRef.Caption,FormatValue(KeyFldRef,RecRef.Number))
            else
              if MaxStrLen(TempRecordBuffer."Primary Key") >
                 StrLen(TempRecordBuffer."Primary Key") +
                 StrLen(StrSubstNo(', %1=%2',KeyFldRef.Caption,FormatValue(KeyFldRef,RecRef.Number)))
              then
                TempRecordBuffer."Primary Key" :=
                  CopyStr(
                    TempRecordBuffer."Primary Key" +
                    StrSubstNo(', %1=%2',KeyFldRef.Caption,FormatValue(KeyFldRef,RecRef.Number)),
                    1,MaxStrLen(TempRecordBuffer."Primary Key"));
            case i of
              1:
                begin
                  TempRecordBuffer."Primary Key Field 1 No." := KeyFldRef.Number;
                  TempRecordBuffer."Primary Key Field 1 Value" := FormatValue(KeyFldRef,RecRef.Number);
                end;
              2:
                begin
                  TempRecordBuffer."Primary Key Field 2 No." := KeyFldRef.Number;
                  TempRecordBuffer."Primary Key Field 2 Value" := FormatValue(KeyFldRef,RecRef.Number);
                end;
              3:
                begin
                  TempRecordBuffer."Primary Key Field 3 No." := KeyFldRef.Number;
                  TempRecordBuffer."Primary Key Field 3 Value" := FormatValue(KeyFldRef,RecRef.Number);
                end;
            end;
          end;

          TempRecordBuffer."Serial No." := SerialNo;
          TempRecordBuffer."Lot No." := LotNo;
          TempRecordBuffer."Item No." := ItemNo;
          TempRecordBuffer."Variant Code" := Variant;

          TempRecordBuffer.Insert;
        end;
    end;


    procedure Collect(var RecordBuffer: Record "Record Buffer" temporary)
    begin
        RecordBuffer.Reset;
        RecordBuffer.DeleteAll;

        TempRecordBuffer.Reset;
        if TempRecordBuffer.Find('-') then
          repeat
            RecordBuffer := TempRecordBuffer;
            RecordBuffer.Insert;
          until TempRecordBuffer.Next = 0;
    end;

    local procedure GetTableCaption(TableNumber: Integer): Text[80]
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.Reset;
        AllObjWithCaption.SetRange("Object Type",AllObjWithCaption."object type"::TableData);
        AllObjWithCaption.SetRange("Object ID",TableNumber);
        if AllObjWithCaption.FindFirst then
          exit(AllObjWithCaption."Object Caption");

        exit('');
    end;

    local procedure FormatValue(var FldRef: FieldRef;TableNumber: Integer): Text[250]
    var
        "Field": Record "Field";
        OptionNo: Integer;
        OptionStr: Text[1024];
        i: Integer;
    begin
        GetField(TableNumber,FldRef.Number,Field);
        if Field.Type = Field.Type::Option then begin
          OptionNo := FldRef.Value;
          OptionStr := Format(FldRef.OptionCaption);
          for i := 1 to OptionNo do
            OptionStr := CopyStr(OptionStr,StrPos(OptionStr,',') + 1);
          if StrPos(OptionStr,',') > 0 then
            if StrPos(OptionStr,',') = 1 then
              OptionStr := ''
            else
              OptionStr := CopyStr(OptionStr,1,StrPos(OptionStr,',') - 1);
          exit(OptionStr);
        end;
        exit(Format(FldRef.Value));
    end;

    local procedure GetField(TableNumber: Integer;FieldNumber: Integer;var Field2: Record "Field")
    var
        "Field": Record "Field";
    begin
        if not TempField.Get(TableNumber,FieldNumber) then begin
          Field.Get(TableNumber,FieldNumber);
          TempField := Field;
          TempField.Insert;
        end;
        Field2 := TempField;
    end;
}

