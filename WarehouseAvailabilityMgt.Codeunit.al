#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7314 "Warehouse Availability Mgt."
{

    trigger OnRun()
    begin
    end;


    procedure CalcLineReservedQtyOnInvt(SourceType: Integer;SourceSubType: Option;SourceNo: Code[20];SourceLineNo: Integer;SourceSubLineNo: Integer;HandleResPickAndShipQty: Boolean;SerialNo: Code[20];LotNo: Code[20];var WarehouseActivityLine: Record "Warehouse Activity Line"): Decimal
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        ReservQtyonInvt: Decimal;
    begin
        // Returns the reserved quantity against ILE for the demand line
        ReservEntry.SetCurrentkey(
          "Source ID","Source Ref. No.","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line","Reservation Status");
        ReservEntry.SetRange("Source ID",SourceNo);
        if SourceType = Database::"Prod. Order Component" then begin
          ReservEntry.SetRange("Source Ref. No.",SourceSubLineNo);
          ReservEntry.SetRange("Source Prod. Order Line",SourceLineNo);
        end else
          ReservEntry.SetRange("Source Ref. No.",SourceLineNo);
        ReservEntry.SetRange("Source Type",SourceType);
        ReservEntry.SetRange("Source Subtype",SourceSubType);
        ReservEntry.SetRange("Reservation Status",ReservEntry."reservation status"::Reservation);
        if ReservEntry."Serial No." <> '' then
          ReservEntry.SetRange("Serial No.",SerialNo);
        if ReservEntry."Lot No." <> '' then
          ReservEntry.SetRange("Lot No.",LotNo);
        if ReservEntry.Find('-') then
          repeat
            ReservEntry2.SetRange("Entry No.",ReservEntry."Entry No.");
            ReservEntry2.SetRange(Positive,true);
            ReservEntry2.SetRange("Source Type",Database::"Item Ledger Entry");
            ReservEntry2.SetRange(
              "Reservation Status",ReservEntry2."reservation status"::Reservation);
            if SerialNo <> '' then
              ReservEntry2.SetRange("Serial No.",SerialNo);
            if LotNo <> '' then
              ReservEntry2.SetRange("Lot No.",LotNo);
            if ReservEntry2.Find('-') then
              repeat
                ReservQtyonInvt += ReservEntry2."Quantity (Base)";
              until ReservEntry2.Next = 0;
          until ReservEntry.Next = 0;

        if HandleResPickAndShipQty then
          ReservQtyonInvt -=
            CalcLineReservQtyOnPicksShips(ReservEntry."Source Type",ReservEntry."Source Subtype",
              ReservEntry."Source ID",ReservEntry."Source Ref. No.",ReservEntry."Source Prod. Order Line",
              ReservEntry."Quantity (Base)",WarehouseActivityLine);

        exit(ReservQtyonInvt);
    end;


    procedure CalcReservQtyOnPicksShips(LocationCode: Code[10];ItemNo: Code[20];VariantCode: Code[10];var WarehouseActivityLine: Record "Warehouse Activity Line"): Decimal
    var
        ReservEntry: Record "Reservation Entry";
        TempReservEntryBuffer: Record "Reservation Entry Buffer" temporary;
        ResPickShipQty: Decimal;
    begin
        // Returns the reserved part of the sum of outstanding quantity on pick lines and
        // quantity on shipment lines picked but not yet shipped for a given item
        ReservEntry.SetCurrentkey(
          "Item No.","Variant Code","Location Code","Reservation Status");
        ReservEntry.SetRange("Item No.",ItemNo);
        ReservEntry.SetRange("Variant Code",VariantCode);
        ReservEntry.SetRange("Location Code",LocationCode);
        ReservEntry.SetRange("Reservation Status",ReservEntry."reservation status"::Reservation);
        ReservEntry.SetRange(Positive,false);
        if ReservEntry.FindSet then begin
          repeat
            TempReservEntryBuffer.TransferFields(ReservEntry);
            if TempReservEntryBuffer.Find then begin
              TempReservEntryBuffer."Quantity (Base)" += ReservEntry."Quantity (Base)";
              TempReservEntryBuffer.Modify
            end else
              TempReservEntryBuffer.Insert;
          until ReservEntry.Next = 0;

          if TempReservEntryBuffer.FindSet then
            repeat
              ResPickShipQty +=
                CalcLineReservQtyOnPicksShips(TempReservEntryBuffer."Source Type",
                  TempReservEntryBuffer."Source Subtype",TempReservEntryBuffer."Source ID",TempReservEntryBuffer."Source Ref. No.",
                  TempReservEntryBuffer."Source Prod. Order Line",TempReservEntryBuffer."Quantity (Base)",WarehouseActivityLine);
            until TempReservEntryBuffer.Next = 0;
        end;

        exit(ResPickShipQty);
    end;


    procedure CalcLineReservQtyOnPicksShips(SourceType: Integer;SourceSubType: Option;SourceID: Code[20];SourceRefNo: Integer;SourceProdOrderLine: Integer;ReservedQtyBase: Decimal;var WarehouseActivityLine: Record "Warehouse Activity Line"): Decimal
    var
        WhseActivityLine: Record "Warehouse Activity Line";
        PickedNotYetShippedQty: Decimal;
        OutstandingQtyOnPickLines: Decimal;
    begin
        // Returns the reserved part of the sum of outstanding quantity on pick lines and
        // quantity on shipment lines picked but not yet shipped for a given demand line
        if SourceType = Database::"Prod. Order Component" then
          PickedNotYetShippedQty := CalcQtyPickedOnProdOrderComponentLine(SourceSubType,SourceID,SourceProdOrderLine,SourceRefNo)
        else
          PickedNotYetShippedQty := CalcQtyPickedOnWhseShipmentLine(SourceType,SourceSubType,SourceID,SourceRefNo);

        WhseActivityLine.SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
        WhseActivityLine.SetRange("Source Type",SourceType);
        WhseActivityLine.SetRange("Source Subtype",SourceSubType);
        WhseActivityLine.SetRange("Source No.",SourceID);

        if SourceType = Database::"Prod. Order Component" then begin
          WhseActivityLine.SetRange("Source Line No.",SourceProdOrderLine);
        end else
          WhseActivityLine.SetRange("Source Line No.",SourceRefNo);

        WhseActivityLine.SetFilter("Action Type",'%1|%2',WhseActivityLine."action type"::Take,WhseActivityLine."action type"::" ");
        WhseActivityLine.CalcSums("Qty. Outstanding (Base)");
        OutstandingQtyOnPickLines := WhseActivityLine."Qty. Outstanding (Base)";

        // For not yet committed warehouse activity lines
        WarehouseActivityLine.SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
        WarehouseActivityLine.SetRange("Source Type",SourceType);
        WarehouseActivityLine.SetRange("Source Subtype",SourceSubType);
        WarehouseActivityLine.SetRange("Source No.",SourceID);

        if SourceType = Database::"Prod. Order Component" then begin
          WarehouseActivityLine.SetRange("Source Line No.",SourceProdOrderLine);
        end else
          WarehouseActivityLine.SetRange("Source Line No.",SourceRefNo);

        WarehouseActivityLine.SetFilter("Action Type",'%1|%2',WhseActivityLine."action type"::Take,WhseActivityLine."action type"::" ");
        WarehouseActivityLine.CalcSums("Qty. Outstanding (Base)");
        OutstandingQtyOnPickLines += WarehouseActivityLine."Qty. Outstanding (Base)";

        if -ReservedQtyBase > (PickedNotYetShippedQty + OutstandingQtyOnPickLines) then
          exit(PickedNotYetShippedQty + OutstandingQtyOnPickLines);

        exit(-ReservedQtyBase)
    end;


    procedure CalcInvtAvailQty(Item: Record Item;Location: Record Location;VariantCode: Code[10];var WarehouseActivityLine: Record "Warehouse Activity Line"): Decimal
    var
        QtyReceivedNotAvail: Decimal;
        QtyAssgndtoPick: Decimal;
        QtyShipped: Decimal;
        QtyReservedOnPickShip: Decimal;
        QtyOnDedicatedBins: Decimal;
        SubTotal: Decimal;
    begin
        // Returns the available quantity to pick for pick/ship/receipt/put-away
        // locations without directed put-away and pick
        with Item do begin
          SetRange("Location Filter",Location.Code);
          SetRange("Variant Filter",VariantCode);
          if Location."Require Shipment" then
            CalcFields(Inventory,"Reserved Qty. on Inventory","Qty. Picked")
          else
            CalcFields(Inventory,"Reserved Qty. on Inventory");

          if Location."Require Receive" and Location."Require Put-away" then
            QtyReceivedNotAvail := CalcQtyRcvdNotAvailable(Location.Code,"No.",VariantCode);

          QtyAssgndtoPick := CalcQtyAssgndtoPick(Location,"No.",VariantCode,'');
          QtyShipped := CalcQtyShipped(Location,"No.",VariantCode);
          QtyReservedOnPickShip := CalcReservQtyOnPicksShips(Location.Code,"No.",VariantCode,WarehouseActivityLine);
          QtyOnDedicatedBins := CalcQtyOnDedicatedBins(Location.Code,"No.",VariantCode,'','');

          // The reserved qty might exceed the qty available in warehouse and thereby
          // having reserved from the qty not yet put-away
          if (Inventory - QtyReceivedNotAvail - QtyAssgndtoPick - "Qty. Picked" + QtyShipped - QtyOnDedicatedBins) <
             (Abs("Reserved Qty. on Inventory") - QtyReservedOnPickShip)
          then
            exit(0);

          SubTotal :=
            Inventory - QtyReceivedNotAvail - QtyAssgndtoPick -
            Abs("Reserved Qty. on Inventory") - "Qty. Picked" + QtyShipped - QtyOnDedicatedBins;

          exit(SubTotal);
        end;
    end;

    local procedure CalcQtyRcvdNotAvailable(LocationCode: Code[10];ItemNo: Code[20];VariantCode: Code[10]): Decimal
    var
        PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
    begin
        // Returns the quantity received but not yet put-away for a given item
        // for pick/ship/receipt/put-away locations without directed put-away and pick
        with PostedWhseRcptLine do begin
          SetCurrentkey("Item No.","Location Code","Variant Code");
          SetRange("Item No.",ItemNo);
          SetRange("Location Code",LocationCode);
          SetRange("Variant Code",VariantCode);
          CalcSums("Qty. (Base)","Qty. Put Away (Base)");
          exit("Qty. (Base)" - "Qty. Put Away (Base)");
        end;
    end;


    procedure CalcQtyAssgndtoPick(Location: Record Location;ItemNo: Code[20];VariantCode: Code[10];BinTypeFilter: Text[250]): Decimal
    var
        WhseActivLine: Record "Warehouse Activity Line";
    begin
        // Returns the outstanding quantity on pick lines for a given item
        // for a pick location without directed put-away and pick
        with WhseActivLine do begin
          SetCurrentkey(
            "Item No.","Location Code","Activity Type","Bin Type Code",
            "Unit of Measure Code","Variant Code","Breakbulk No.");
          SetRange("Item No.",ItemNo);
          SetRange("Location Code",Location.Code);
          SetRange("Variant Code",VariantCode);
          SetRange("Bin Type Code",BinTypeFilter);

          if Location."Bin Mandatory" then
            SetRange("Action Type","action type"::Take)
          else begin
            SetRange("Action Type","action type"::" ");
            SetRange("Breakbulk No.",0);
          end;

          if Location."Require Shipment" then
            SetRange("Activity Type","activity type"::Pick)
          else begin
            SetRange("Activity Type","activity type"::"Invt. Pick");
            SetRange("Assemble to Order",false);
          end;

          CalcSums("Qty. Outstanding (Base)");
          exit("Qty. Outstanding (Base)");
        end;
    end;


    procedure CalcQtyAssgndOnWksh(DefWhseWkshLine: Record "Whse. Worksheet Line";RespectUOMCode: Boolean;ExcludeLine: Boolean): Decimal
    var
        WhseWkshLine: Record "Whse. Worksheet Line";
    begin
        with WhseWkshLine do begin
          SetCurrentkey(
            "Item No.","Location Code","Worksheet Template Name","Variant Code","Unit of Measure Code");
          SetRange("Item No.",DefWhseWkshLine."Item No.");
          SetRange("Location Code",DefWhseWkshLine."Location Code");
          SetRange("Worksheet Template Name",DefWhseWkshLine."Worksheet Template Name");
          SetRange("Variant Code",DefWhseWkshLine."Variant Code");
          if RespectUOMCode then
            SetRange("Unit of Measure Code",DefWhseWkshLine."Unit of Measure Code");
          CalcSums("Qty. to Handle (Base)");

          if ExcludeLine then
            "Qty. to Handle (Base)" := "Qty. to Handle (Base)" - DefWhseWkshLine."Qty. to Handle (Base)";

          exit("Qty. to Handle (Base)");
        end;
    end;

    local procedure CalcQtyShipped(Location: Record Location;ItemNo: Code[20];VariantCode: Code[10]): Decimal
    var
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        with WhseShptLine do begin
          SetCurrentkey("Item No.","Location Code","Variant Code","Due Date");
          SetRange("Item No.",ItemNo);
          SetRange("Location Code",Location.Code);
          SetRange("Variant Code",VariantCode);
          CalcSums("Qty. Shipped (Base)");

          exit("Qty. Shipped (Base)");
        end;
    end;


    procedure CalcQtyOnDedicatedBins(LocationCode: Code[10];ItemNo: Code[20];VariantCode: Code[10];LotNo: Code[20];SerialNo: Code[20]): Decimal
    var
        WhseEntry: Record "Warehouse Entry";
    begin
        WhseEntry.SetCurrentkey("Item No.","Bin Code","Location Code","Variant Code",
          "Unit of Measure Code","Lot No.","Serial No.","Entry Type");
        WhseEntry.SetRange("Item No.",ItemNo);
        WhseEntry.SetRange("Location Code",LocationCode);
        WhseEntry.SetRange("Variant Code",VariantCode);
        WhseEntry.SetRange(Dedicated,true);
        if LotNo <> '' then
          WhseEntry.SetRange("Lot No.",LotNo);
        if SerialNo <> '' then
          WhseEntry.SetRange("Serial No.",SerialNo);
        WhseEntry.CalcSums(WhseEntry."Qty. (Base)");
        exit(WhseEntry."Qty. (Base)");
    end;


    procedure CalcQtyOnBlockedITOrOnBlockedOutbndBins(LocationCode: Code[10];ItemNo: Code[20];VariantCode: Code[10];LotNo: Code[20];SerialNo: Code[20];LNRequired: Boolean;SNRequired: Boolean) QtyBlocked: Decimal
    var
        BinContent: Record "Bin Content";
    begin
        with BinContent do begin
          SetCurrentkey("Location Code","Item No.","Variant Code");
          SetRange("Location Code",LocationCode);
          SetRange("Item No.",ItemNo);
          SetRange("Variant Code",VariantCode);
          if LotNo <> '' then
            if LNRequired then
              SetRange("Lot No. Filter",LotNo);
          if SerialNo <> '' then
            if SNRequired then
              SetRange("Serial No. Filter",SerialNo);
          if FindSet then
            repeat
              if "Block Movement" in ["block movement"::All,"block movement"::Outbound] then begin
                CalcFields("Quantity (Base)");
                QtyBlocked += "Quantity (Base)";
              end else
                QtyBlocked += CalcQtyWithBlockedItemTracking;
            until Next = 0;
        end;
    end;

    local procedure CalcQtyPickedOnProdOrderComponentLine(SourceSubtype: Option;SourceID: Code[20];SourceProdOrderLineNo: Integer;SourceRefNo: Integer): Decimal
    var
        ProdOrderComponent: Record "Prod. Order Component";
    begin
        with ProdOrderComponent do begin
          SetRange(Status,SourceSubtype);
          SetRange("Prod. Order No.",SourceID);
          SetRange("Prod. Order Line No.",SourceProdOrderLineNo);
          SetRange("Line No.",SourceRefNo);
          if FindFirst then
            exit("Qty. Picked (Base)");
        end;

        exit(0);
    end;

    local procedure CalcQtyPickedOnWhseShipmentLine(SourceType: Integer;SourceSubType: Option;SourceID: Code[20];SourceRefNo: Integer): Decimal
    var
        WhseShipmentLine: Record "Warehouse Shipment Line";
    begin
        with WhseShipmentLine do begin
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubType);
          SetRange("Source No.",SourceID);
          SetRange("Source Line No.",SourceRefNo);
          CalcSums("Qty. Picked (Base)","Qty. Shipped (Base)");
          exit("Qty. Picked (Base)" - "Qty. Shipped (Base)");
        end;
    end;
}

