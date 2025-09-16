#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7321 "Create Inventory Put-away"
{
    TableNo = "Warehouse Activity Header";

    trigger OnRun()
    begin
        WhseActivHeader := Rec;
        Code;
        Rec := WhseActivHeader;
    end;

    var
        WhseActivHeader: Record "Warehouse Activity Header";
        WhseRequest: Record "Warehouse Request";
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        Location: Record Location;
        Item: Record Item;
        PurchHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        TransferHeader: Record "Transfer Header";
        ProdOrder: Record "Production Order";
        PostingDate: Date;
        VendorDocNo: Code[35];
        RemQtyToPutAway: Decimal;
        NextLineNo: Integer;
        LineCreated: Boolean;
        SNRequired: Boolean;
        LNRequired: Boolean;
        ReservationFound: Boolean;
        HideDialog: Boolean;
        CheckLineExist: Boolean;
        AutoCreation: Boolean;
        Text000: label 'Nothing to handle.';

    local procedure "Code"()
    begin
        WhseActivHeader.TestField("No.");
        WhseActivHeader.TestField("Location Code");

        if not HideDialog then
          if not GetWhseRequest(WhseRequest) then
            exit;

        GetSourceDocHeader;
        UpdateWhseActivHeader(WhseRequest);

        case WhseRequest."Source Document" of
          WhseRequest."source document"::"Purchase Order":
            CreatePutAwayLinesFromPurchase(PurchHeader);
          WhseRequest."source document"::"Purchase Return Order":
            CreatePutAwayLinesFromPurchase(PurchHeader);
          WhseRequest."source document"::"Sales Order":
            CreatePutAwayLinesFromSales(SalesHeader);
          WhseRequest."source document"::"Sales Return Order":
            CreatePutAwayLinesFromSales(SalesHeader);
          WhseRequest."source document"::"Inbound Transfer":
            CreatePutAwayLinesFromTransfer(TransferHeader);
          WhseRequest."source document"::"Prod. Output":
            CreatePutAwayLinesFromProd(ProdOrder);
          WhseRequest."source document"::"Prod. Consumption":
            CreatePutAwayLinesFromComp(ProdOrder);
        end;

        if LineCreated then
          WhseActivHeader.Modify
        else
          if not AutoCreation then
            Error(Text000);
    end;

    local procedure GetWhseRequest(var WhseRequest: Record "Warehouse Request"): Boolean
    begin
        with WhseRequest do begin
          FilterGroup := 2;
          SetRange(Type,Type::Inbound);
          SetRange("Location Code",WhseActivHeader."Location Code");
          SetRange("Document Status","document status"::Released);
          if WhseActivHeader."Source Document" <> 0 then
            SetRange("Source Document",WhseActivHeader."Source Document");
          if WhseActivHeader."Source No." <> '' then
            SetRange("Source No.",WhseActivHeader."Source No.");
          SetRange("Completely Handled",false);
          FilterGroup := 0;
          if Page.RunModal(
               Page::"Source Documents",WhseRequest,"Source No.") = Action::LookupOK
          then
            exit(true);
        end;
    end;

    local procedure GetSourceDocHeader()
    begin
        case WhseRequest."Source Document" of
          WhseRequest."source document"::"Purchase Order":
            begin
              PurchHeader.Get(PurchHeader."document type"::Order,WhseRequest."Source No.");
              PostingDate := PurchHeader."Posting Date";
              VendorDocNo := PurchHeader."Vendor Invoice No.";
            end;
          WhseRequest."source document"::"Purchase Return Order":
            begin
              PurchHeader.Get(PurchHeader."document type"::"Return Order",WhseRequest."Source No.");
              PostingDate := PurchHeader."Posting Date";
              VendorDocNo := PurchHeader."Vendor Cr. Memo No.";
            end;
          WhseRequest."source document"::"Sales Order":
            begin
              SalesHeader.Get(SalesHeader."document type"::Order,WhseRequest."Source No.");
              PostingDate := SalesHeader."Posting Date";
            end;
          WhseRequest."source document"::"Sales Return Order":
            begin
              SalesHeader.Get(SalesHeader."document type"::"Return Order",WhseRequest."Source No.");
              PostingDate := SalesHeader."Posting Date";
            end;
          WhseRequest."source document"::"Inbound Transfer":
            begin
              TransferHeader.Get(WhseRequest."Source No.");
              PostingDate := TransferHeader."Posting Date";
            end;
          WhseRequest."source document"::"Prod. Output":
            begin
              ProdOrder.Get(ProdOrder.Status::Released,WhseRequest."Source No.");
              PostingDate := WorkDate;
            end;
          WhseRequest."source document"::"Prod. Consumption":
            begin
              ProdOrder.Get(WhseRequest."Source Subtype",WhseRequest."Source No.");
              PostingDate := WorkDate;
            end;
        end;
    end;

    local procedure UpdateWhseActivHeader(WhseRequest: Record "Warehouse Request")
    begin
        with WhseRequest do begin
          if WhseActivHeader."Source Document" = 0 then begin
            WhseActivHeader."Source Document" := "Source Document";
            WhseActivHeader."Source Type" := "Source Type";
            WhseActivHeader."Source Subtype" := "Source Subtype";
          end else
            WhseActivHeader.TestField("Source Document","Source Document");
          if WhseActivHeader."Source No." = '' then begin
            WhseActivHeader."Source No." := "Source No.";
          end else
            WhseActivHeader.TestField("Source No.","Source No.");

          WhseActivHeader."Destination Type" := "Destination Type";
          WhseActivHeader."Destination No." := "Destination No.";
          WhseActivHeader."External Document No." := "External Document No.";
          WhseActivHeader."Expected Receipt Date" := "Expected Receipt Date";
          WhseActivHeader."Posting Date" := PostingDate;
          WhseActivHeader."External Document No.2" := VendorDocNo;
          GetLocation("Location Code");
        end;
    end;

    local procedure CreatePutAwayLinesFromPurchase(PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        NewWhseActivLine: Record "Warehouse Activity Line";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        with PurchLine do begin
          if not SetFilterPurchLine(PurchLine,PurchHeader) then begin
            if not HideDialog then
              Message(Text000);
            exit;
          end;

          FindNextLineNo;

          repeat
            if not FindPutAwayLine(Database::"Purchase Line","Document Type","Document No.","Line No.",0) then begin
              if "Document Type" = "document type"::Order then
                RemQtyToPutAway := "Qty. to Receive"
              else
                RemQtyToPutAway := -"Return Qty. to Ship";

              ItemTrackingMgt.CheckWhseItemTrkgSetup("No.",SNRequired,LNRequired,false);
              if SNRequired or LNRequired then
                ReservationFound :=
                  FindReservationEntry(Database::"Purchase Line","Document Type","Document No.","Line No.",SNRequired,LNRequired);

              repeat
                NewWhseActivLine.Init;
                NewWhseActivLine."Activity Type" := WhseActivHeader.Type;
                NewWhseActivLine."No." := WhseActivHeader."No.";
                NewWhseActivLine."Line No." := NextLineNo;
                NewWhseActivLine."Source Type" := Database::"Purchase Line";
                NewWhseActivLine."Source Subtype" := "Document Type";
                NewWhseActivLine."Source No." := "Document No.";
                NewWhseActivLine."Source Line No." := "Line No.";
                NewWhseActivLine."Location Code" := "Location Code";
                if "Bin Code" = '' then
                  NewWhseActivLine."Bin Code" := GetDefaultBinCode("No.","Variant Code","Location Code")
                else
                  NewWhseActivLine."Bin Code" := "Bin Code";
                if not Location."Bin Mandatory" then
                  NewWhseActivLine."Shelf No." := GetShelfNo("No.");
                NewWhseActivLine."Item No." := "No.";
                NewWhseActivLine."Variant Code" := "Variant Code";
                NewWhseActivLine."Unit of Measure Code" := "Unit of Measure Code";
                NewWhseActivLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                NewWhseActivLine.Description := Description;
                NewWhseActivLine."Description 2" := "Description 2";
                NewWhseActivLine."Due Date" := "Expected Receipt Date";
                if "Document Type" = "document type"::Order then
                  NewWhseActivLine."Source Document" := NewWhseActivLine."source document"::"Purchase Order"
                else
                  NewWhseActivLine."Source Document" := NewWhseActivLine."source document"::"Purchase Return Order";

                if not ReservationFound and SNRequired then
                  repeat
                    NewWhseActivLine."Line No." := NextLineNo;
                    InsertWhseActivLine(NewWhseActivLine,1);
                  until RemQtyToPutAway <= 0
                else
                  InsertWhseActivLine(NewWhseActivLine,RemQtyToPutAway);
              until RemQtyToPutAway <= 0;
            end;
          until Next = 0;
        end;
    end;


    procedure SetFilterPurchLine(var PurchLine: Record "Purchase Line";PurchHeader: Record "Purchase Header"): Boolean
    begin
        with PurchLine do begin
          SetCurrentkey("Document Type","Document No.","Location Code");
          SetRange("Document Type",PurchHeader."Document Type");
          SetRange("Document No.",PurchHeader."No.");
          SetRange("Drop Shipment",false);
          if not CheckLineExist then
            SetRange("Location Code",WhseActivHeader."Location Code");
          SetRange(Type,Type::Item);
          if PurchHeader."Document Type" = PurchHeader."document type"::Order then
            SetFilter("Qty. to Receive",'>%1',0)
          else
            SetFilter("Return Qty. to Ship",'<%1',0);
          exit(Find('-'));
        end;
    end;

    local procedure CreatePutAwayLinesFromSales(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        NewWhseActivLine: Record "Warehouse Activity Line";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        with SalesLine do begin
          if not SetFilterSalesLine(SalesLine,SalesHeader) then begin
            if not HideDialog then
              Message(Text000);
            exit;
          end;

          FindNextLineNo;

          repeat
            if not FindPutAwayLine(Database::"Sales Line","Document Type","Document No.","Line No.",0) then begin
              if "Document Type" = "document type"::Order then
                RemQtyToPutAway := -"Qty. to Ship"
              else
                RemQtyToPutAway := "Return Qty. to Receive";

              ItemTrackingMgt.CheckWhseItemTrkgSetup("No.",SNRequired,LNRequired,false);
              if SNRequired or LNRequired then
                ReservationFound :=
                  FindReservationEntry(Database::"Sales Line","Document Type","Document No.","Line No.",SNRequired,LNRequired);

              repeat
                NewWhseActivLine.Init;
                NewWhseActivLine."Activity Type" := WhseActivHeader.Type;
                NewWhseActivLine."No." := WhseActivHeader."No.";
                NewWhseActivLine."Line No." := NextLineNo;
                NewWhseActivLine."Source Type" := Database::"Sales Line";
                NewWhseActivLine."Source Subtype" := "Document Type";
                NewWhseActivLine."Source No." := "Document No.";
                NewWhseActivLine."Source Line No." := "Line No.";
                NewWhseActivLine."Location Code" := "Location Code";
                if "Bin Code" = '' then
                  NewWhseActivLine."Bin Code" := GetDefaultBinCode("No.","Variant Code","Location Code")
                else
                  NewWhseActivLine."Bin Code" := "Bin Code";
                if not Location."Bin Mandatory" then
                  NewWhseActivLine."Shelf No." := GetShelfNo("No.");
                NewWhseActivLine."Item No." := "No.";
                NewWhseActivLine."Variant Code" := "Variant Code";
                NewWhseActivLine."Unit of Measure Code" := "Unit of Measure Code";
                NewWhseActivLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                NewWhseActivLine.Description := Description;
                NewWhseActivLine."Description 2" := "Description 2";
                NewWhseActivLine."Due Date" := "Planned Shipment Date";
                if "Document Type" = "document type"::Order then
                  NewWhseActivLine."Source Document" := NewWhseActivLine."source document"::"Sales Order"
                else
                  NewWhseActivLine."Source Document" := NewWhseActivLine."source document"::"Sales Return Order";

                if not ReservationFound and SNRequired then
                  repeat
                    NewWhseActivLine."Line No." := NextLineNo;
                    InsertWhseActivLine(NewWhseActivLine,1);
                  until RemQtyToPutAway <= 0
                else
                  InsertWhseActivLine(NewWhseActivLine,RemQtyToPutAway);
              until RemQtyToPutAway <= 0;
            end;
          until Next = 0;
        end;
    end;


    procedure SetFilterSalesLine(var SalesLine: Record "Sales Line";SalesHeader: Record "Sales Header"): Boolean
    begin
        with SalesLine do begin
          SetCurrentkey("Document Type","Document No.","Location Code");
          SetRange("Document Type",SalesHeader."Document Type");
          SetRange("Document No.",SalesHeader."No.");
          SetRange("Drop Shipment",false);
          if not CheckLineExist then
            SetRange("Location Code",WhseActivHeader."Location Code");
          SetRange(Type,Type::Item);
          if SalesHeader."Document Type" = SalesHeader."document type"::Order then
            SetFilter("Qty. to Ship",'<%1',0)
          else
            SetFilter("Return Qty. to Receive",'>%1',0);
          exit(Find('-'));
        end;
    end;

    local procedure CreatePutAwayLinesFromTransfer(TransferHeader: Record "Transfer Header")
    var
        TransferLine: Record "Transfer Line";
        NewWhseActivLine: Record "Warehouse Activity Line";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        with TransferLine do begin
          if not SetFilterTransferLine(TransferLine,TransferHeader) then begin
            if not HideDialog then
              Message(Text000);
            exit;
          end;

          FindNextLineNo;

          repeat
            if not FindPutAwayLine(Database::"Transfer Line",1,"Document No.","Line No.",0) then begin
              RemQtyToPutAway := "Qty. to Receive";

              ItemTrackingMgt.CheckWhseItemTrkgSetup("Item No.",SNRequired,LNRequired,false);
              if SNRequired or LNRequired then
                ReservationFound :=
                  FindReservationEntry(Database::"Transfer Line",1,"Document No.","Line No.",SNRequired,LNRequired);

              repeat
                NewWhseActivLine.Init;
                NewWhseActivLine."Activity Type" := WhseActivHeader.Type;
                NewWhseActivLine."No." := WhseActivHeader."No.";
                NewWhseActivLine."Line No." := NextLineNo;
                NewWhseActivLine."Source Type" := Database::"Transfer Line";
                NewWhseActivLine."Source Subtype" := 1;
                NewWhseActivLine."Source No." := "Document No.";
                NewWhseActivLine."Source Line No." := "Line No.";
                NewWhseActivLine."Source Document" := NewWhseActivLine."source document"::"Inbound Transfer";
                NewWhseActivLine."Location Code" := "Transfer-to Code";
                if "Transfer-To Bin Code" = '' then
                  NewWhseActivLine."Bin Code" := GetDefaultBinCode("Item No.","Variant Code","Transfer-to Code")
                else
                  NewWhseActivLine."Bin Code" := "Transfer-To Bin Code";
                if not Location."Bin Mandatory" then
                  NewWhseActivLine."Shelf No." := GetShelfNo("Item No.");
                NewWhseActivLine."Item No." := "Item No.";
                NewWhseActivLine."Variant Code" := "Variant Code";
                NewWhseActivLine."Unit of Measure Code" := "Unit of Measure Code";
                NewWhseActivLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                NewWhseActivLine.Description := Description;
                NewWhseActivLine."Description 2" := "Description 2";
                NewWhseActivLine."Due Date" := "Receipt Date";
                if not ReservationFound and SNRequired then
                  repeat
                    NewWhseActivLine."Line No." := NextLineNo;
                    InsertWhseActivLine(NewWhseActivLine,1);
                  until RemQtyToPutAway <= 0
                else
                  InsertWhseActivLine(NewWhseActivLine,RemQtyToPutAway);
              until RemQtyToPutAway <= 0;
            end;
          until Next = 0;
        end;
    end;


    procedure SetFilterTransferLine(var TransferLine: Record "Transfer Line";TransferHeader: Record "Transfer Header"): Boolean
    begin
        with TransferLine do begin
          SetRange("Document No.",TransferHeader."No.");
          SetRange("Derived From Line No.",0);
          if not CheckLineExist then
            SetRange("Transfer-to Code",WhseActivHeader."Location Code");
          SetFilter("Qty. to Receive",'>%1',0);
          exit(Find('-'));
        end;
    end;

    local procedure CreatePutAwayLinesFromProd(ProdOrder: Record "Production Order")
    var
        ProdOrderLine: Record "Prod. Order Line";
        NewWhseActivLine: Record "Warehouse Activity Line";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        with ProdOrderLine do begin
          if not SetFilterProdOrderLine(ProdOrderLine,ProdOrder) then begin
            if not HideDialog then
              Message(Text000);
            exit;
          end;

          FindNextLineNo;

          repeat
            if not FindPutAwayLine(Database::"Prod. Order Line",Status,"Prod. Order No.","Line No.",0) then begin
              RemQtyToPutAway := "Remaining Quantity";

              ItemTrackingMgt.CheckWhseItemTrkgSetup("Item No.",SNRequired,LNRequired,false);
              if SNRequired or LNRequired then
                ReservationFound :=
                  FindReservationEntry(Database::"Prod. Order Line",Status,"Prod. Order No.","Line No.",SNRequired,LNRequired);

              repeat
                NewWhseActivLine.Init;
                NewWhseActivLine."Activity Type" := WhseActivHeader.Type;
                NewWhseActivLine."No." := WhseActivHeader."No.";
                NewWhseActivLine."Line No." := NextLineNo;
                NewWhseActivLine."Source Type" := Database::"Prod. Order Line";
                NewWhseActivLine."Source Subtype" := Status;
                NewWhseActivLine."Source No." := "Prod. Order No.";
                NewWhseActivLine."Source Line No." := "Line No.";
                NewWhseActivLine."Location Code" := "Location Code";
                if "Bin Code" = '' then
                  NewWhseActivLine."Bin Code" := GetDefaultBinCode("Item No.","Variant Code","Location Code")
                else
                  NewWhseActivLine."Bin Code" := "Bin Code";
                if not Location."Bin Mandatory" then
                  NewWhseActivLine."Shelf No." := GetShelfNo("Item No.");
                NewWhseActivLine."Item No." := "Item No.";
                NewWhseActivLine."Variant Code" := "Variant Code";
                NewWhseActivLine."Unit of Measure Code" := "Unit of Measure Code";
                NewWhseActivLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                NewWhseActivLine.Description := Description;
                NewWhseActivLine."Description 2" := "Description 2";
                NewWhseActivLine."Due Date" := "Due Date";
                NewWhseActivLine."Source Document" := NewWhseActivLine."source document"::"Prod. Output";

                if not ReservationFound and SNRequired then
                  repeat
                    NewWhseActivLine."Line No." := NextLineNo;
                    InsertWhseActivLine(NewWhseActivLine,1);
                  until RemQtyToPutAway <= 0
                else
                  InsertWhseActivLine(NewWhseActivLine,RemQtyToPutAway);
              until RemQtyToPutAway <= 0;
            end;
          until Next = 0;
        end;
    end;


    procedure SetFilterProdOrderLine(var ProdOrderLine: Record "Prod. Order Line";ProdOrder: Record "Production Order"): Boolean
    begin
        with ProdOrderLine do begin
          SetRange(Status,ProdOrder.Status);
          SetRange("Prod. Order No.",ProdOrder."No.");
          if not CheckLineExist then
            SetRange("Location Code",WhseActivHeader."Location Code");
          SetFilter("Remaining Quantity",'>%1',0);
          exit(Find('-'));
        end;
    end;

    local procedure CreatePutAwayLinesFromComp(ProdOrder: Record "Production Order")
    var
        ProdOrderComp: Record "Prod. Order Component";
        NewWhseActivLine: Record "Warehouse Activity Line";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        with ProdOrderComp do begin
          if not SetFilterProdCompLine(ProdOrderComp,ProdOrder) then begin
            if not HideDialog then
              Message(Text000);
            exit;
          end;

          FindNextLineNo;

          repeat
            if not FindPutAwayLine(Database::"Prod. Order Component",Status,"Prod. Order No.","Prod. Order Line No.","Line No.") then
              begin
              RemQtyToPutAway := -"Remaining Quantity";

              ItemTrackingMgt.CheckWhseItemTrkgSetup("Item No.",SNRequired,LNRequired,false);
              if SNRequired or LNRequired then
                ReservationFound :=
                  FindReservationEntry(Database::"Prod. Order Component",Status,"Prod. Order No.","Line No.",SNRequired,LNRequired);

              repeat
                NewWhseActivLine.Init;
                NewWhseActivLine."Activity Type" := WhseActivHeader.Type;
                NewWhseActivLine."No." := WhseActivHeader."No.";
                NewWhseActivLine."Source Type" := Database::"Prod. Order Component";
                NewWhseActivLine."Source Subtype" := Status;
                NewWhseActivLine."Source No." := "Prod. Order No.";
                NewWhseActivLine."Source Line No." := "Prod. Order Line No.";
                NewWhseActivLine."Source Subline No." := "Line No.";
                NewWhseActivLine."Location Code" := "Location Code";
                NewWhseActivLine."Item No." := "Item No.";
                NewWhseActivLine."Variant Code" := "Variant Code";
                if "Bin Code" = '' then
                  NewWhseActivLine."Bin Code" := GetDefaultBinCode("Item No.","Variant Code","Location Code")
                else
                  NewWhseActivLine."Bin Code" := "Bin Code";
                if not Location."Bin Mandatory" then
                  NewWhseActivLine."Shelf No." := GetShelfNo("Item No.");
                NewWhseActivLine."Unit of Measure Code" := "Unit of Measure Code";
                NewWhseActivLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                NewWhseActivLine.Description := Description;
                NewWhseActivLine."Due Date" := "Due Date";
                NewWhseActivLine."Source Document" := NewWhseActivLine."source document"::"Prod. Consumption";

                if not ReservationFound and SNRequired then
                  repeat
                    NewWhseActivLine."Line No." := NextLineNo;
                    InsertWhseActivLine(NewWhseActivLine,1);
                  until RemQtyToPutAway <= 0
                else
                  InsertWhseActivLine(NewWhseActivLine,RemQtyToPutAway);
              until RemQtyToPutAway <= 0;
            end;
          until Next = 0;
        end;
    end;

    local procedure SetFilterProdCompLine(var ProdOrderComp: Record "Prod. Order Component";ProdOrder: Record "Production Order"): Boolean
    begin
        with ProdOrderComp do begin
          SetRange(Status,ProdOrder.Status);
          SetRange("Prod. Order No.",ProdOrder."No.");
          if not CheckLineExist then
            SetRange("Location Code",WhseActivHeader."Location Code");
          SetRange("Flushing Method","flushing method"::Manual);
          SetRange("Planning Level Code",0);
          SetFilter("Remaining Quantity",'<0');
          exit(Find('-'));
        end;
    end;

    local procedure FindPutAwayLine(SourceType: Option;SourceSubType: Option;SourceNo: Code[20];SourceLineNo: Integer;SourceSubLineNo: Integer): Boolean
    var
        WhseActivLine: Record "Warehouse Activity Line";
    begin
        with WhseActivLine do begin
          SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubType);
          SetRange("Source No.",SourceNo);
          SetRange("Source Line No.",SourceLineNo);
          SetRange("Source Subline No.",SourceSubLineNo);
          exit(not IsEmpty);
        end;
    end;

    local procedure FindNextLineNo()
    var
        WhseActivLine: Record "Warehouse Activity Line";
    begin
        with WhseActivHeader do begin
          WhseActivLine.SetRange("Activity Type",WhseActivLine."activity type"::"Invt. Put-away");
          WhseActivLine.SetRange("No.","No.");
          if WhseActivLine.FindLast then
            NextLineNo := WhseActivLine."Line No." + 10000
          else
            NextLineNo := 10000;
        end;
    end;

    local procedure FindReservationEntry(SourceType: Integer;DocType: Integer;DocNo: Code[20];DocLineNo: Integer;SNRequired: Boolean;LNRequired: Boolean): Boolean
    var
        ReservEntry: Record "Reservation Entry";
        ItemTrackMgt: Codeunit "Item Tracking Management";
    begin
        with ReservEntry do begin
          SetCurrentkey(
            "Source ID","Source Ref. No.","Source Type","Source Subtype",
            "Source Batch Name","Source Prod. Order Line");
          SetRange("Source ID",DocNo);
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",DocType);
          if SourceType in [Database::"Prod. Order Line",Database::"Transfer Line"] then
            SetRange("Source Prod. Order Line",DocLineNo)
          else
            SetRange("Source Ref. No.",DocLineNo);
          if SNRequired then
            SetFilter("Serial No.",'<>%1','');
          if LNRequired then
            SetFilter("Lot No.",'<>%1','');
          if FindFirst then
            if ItemTrackMgt.SumUpItemTracking(ReservEntry,TempTrackingSpecification,true,true) then
              exit(true);
        end;
    end;

    local procedure InsertWhseActivLine(var NewWhseActivLine: Record "Warehouse Activity Line";PutAwayQty: Decimal)
    begin
        with NewWhseActivLine do begin
          if Location."Bin Mandatory" then
            "Action Type" := "action type"::Place;

          "Serial No." := '';
          "Expiration Date" := 0D;
          if ReservationFound then begin
            "Serial No." := TempTrackingSpecification."Serial No.";
            "Lot No." := TempTrackingSpecification."Lot No.";
            "Expiration Date" := TempTrackingSpecification."Expiration Date";
            Validate(Quantity,CalcQty(TempTrackingSpecification."Qty. to Handle (Base)"));
            ReservationFound := false;
          end else
            if (SNRequired or LNRequired) and (TempTrackingSpecification.Next <> 0) then begin
              "Serial No." := TempTrackingSpecification."Serial No.";
              "Lot No." := TempTrackingSpecification."Lot No.";
              "Expiration Date" := TempTrackingSpecification."Expiration Date";
              Validate(Quantity,CalcQty(TempTrackingSpecification."Qty. to Handle (Base)"));
            end else
              Validate(Quantity,PutAwayQty);
          Validate("Qty. to Handle",0);
        end;

        if AutoCreation and not LineCreated then begin
          WhseActivHeader."No." := '';
          WhseActivHeader.Insert(true);
          UpdateWhseActivHeader(WhseRequest);
          NextLineNo := 10000;
          Commit;
        end;
        NewWhseActivLine."No." := WhseActivHeader."No.";
        NewWhseActivLine."Line No." := NextLineNo;
        NewWhseActivLine.Insert;

        LineCreated := true;
        NextLineNo := NextLineNo + 10000;
        RemQtyToPutAway -= NewWhseActivLine.Quantity;
    end;

    local procedure GetDefaultBinCode(ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10]): Code[20]
    var
        WMSMgt: Codeunit "WMS Management";
        BinCode: Code[20];
    begin
        GetLocation(LocationCode);
        if Location."Bin Mandatory" then
          if WMSMgt.GetDefaultBin(ItemNo,VariantCode,LocationCode,BinCode) then
            exit(BinCode);
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Clear(Location)
        else
          if LocationCode <> Location.Code then
            Location.Get(LocationCode);
    end;

    local procedure GetShelfNo(ItemNo: Code[20]): Code[10]
    begin
        GetItem(ItemNo);
        exit(Item."Shelf No.");
    end;

    local procedure GetItem(ItemNo: Code[20])
    begin
        if ItemNo <> Item."No." then
          Item.Get(ItemNo);
    end;


    procedure SetWhseRequest(NewWhseRequest: Record "Warehouse Request";SetHideDialog: Boolean)
    begin
        WhseRequest := NewWhseRequest;
        HideDialog := SetHideDialog;
        LineCreated := false;
    end;


    procedure CheckSourceDoc(NewWhseRequest: Record "Warehouse Request"): Boolean
    var
        PurchLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
        TransferLine: Record "Transfer Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
    begin
        WhseRequest := NewWhseRequest;
        if Location.RequireReceive(WhseRequest."Location Code") then
          exit(false);

        GetSourceDocHeader;
        CheckLineExist := true;
        case WhseRequest."Source Document" of
          WhseRequest."source document"::"Purchase Order":
            exit(SetFilterPurchLine(PurchLine,PurchHeader));
          WhseRequest."source document"::"Purchase Return Order":
            exit(SetFilterPurchLine(PurchLine,PurchHeader));
          WhseRequest."source document"::"Sales Order":
            exit(SetFilterSalesLine(SalesLine,SalesHeader));
          WhseRequest."source document"::"Sales Return Order":
            exit(SetFilterSalesLine(SalesLine,SalesHeader));
          WhseRequest."source document"::"Inbound Transfer":
            exit(SetFilterTransferLine(TransferLine,TransferHeader));
          WhseRequest."source document"::"Prod. Output":
            exit(SetFilterProdOrderLine(ProdOrderLine,ProdOrder));
          WhseRequest."source document"::"Prod. Consumption":
            exit(SetFilterProdCompLine(ProdOrderComp,ProdOrder));
        end;
    end;


    procedure AutoCreatePutAway(var WhseActivHeaderNew: Record "Warehouse Activity Header")
    begin
        WhseActivHeader := WhseActivHeaderNew;
        CheckLineExist := false;
        AutoCreation := true;
        GetLocation(WhseRequest."Location Code");

        case WhseRequest."Source Document" of
          WhseRequest."source document"::"Purchase Order":
            CreatePutAwayLinesFromPurchase(PurchHeader);
          WhseRequest."source document"::"Purchase Return Order":
            CreatePutAwayLinesFromPurchase(PurchHeader);
          WhseRequest."source document"::"Sales Order":
            CreatePutAwayLinesFromSales(SalesHeader);
          WhseRequest."source document"::"Sales Return Order":
            CreatePutAwayLinesFromSales(SalesHeader);
          WhseRequest."source document"::"Inbound Transfer":
            CreatePutAwayLinesFromTransfer(TransferHeader);
          WhseRequest."source document"::"Prod. Output":
            CreatePutAwayLinesFromProd(ProdOrder);
          WhseRequest."source document"::"Prod. Consumption":
            CreatePutAwayLinesFromComp(ProdOrder);
        end;
        if LineCreated then begin
          WhseActivHeader.Modify;
          WhseActivHeaderNew := WhseActivHeader;
        end;
    end;
}

