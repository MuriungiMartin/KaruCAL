#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6503 "Item Tracking Doc. Management"
{

    trigger OnRun()
    begin
    end;

    var
        CountingRecordsMsg: label 'Counting records...';
        TableNotSupportedErr: label 'Table %1 is not supported.';
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        RetrieveAsmItemTracking: Boolean;

    local procedure AddTempRecordToSet(var TempItemLedgEntry: Record "Item Ledger Entry" temporary;SignFactor: Integer)
    var
        TempItemLedgEntry2: Record "Item Ledger Entry" temporary;
    begin
        if SignFactor <> 1 then begin
          TempItemLedgEntry.Quantity *= SignFactor;
          TempItemLedgEntry."Remaining Quantity" *= SignFactor;
          TempItemLedgEntry."Invoiced Quantity" *= SignFactor;
        end;
        ItemTrackingMgt.RetrieveAppliedExpirationDate(TempItemLedgEntry);
        TempItemLedgEntry2 := TempItemLedgEntry;
        TempItemLedgEntry.Reset;
        TempItemLedgEntry.SetRange("Serial No.",TempItemLedgEntry2."Serial No.");
        TempItemLedgEntry.SetRange("Lot No.",TempItemLedgEntry2."Lot No.");
        TempItemLedgEntry.SetRange("Warranty Date",TempItemLedgEntry2."Warranty Date");
        TempItemLedgEntry.SetRange("Expiration Date",TempItemLedgEntry2."Expiration Date");
        if TempItemLedgEntry.FindFirst then begin
          TempItemLedgEntry.Quantity += TempItemLedgEntry2.Quantity;
          TempItemLedgEntry."Remaining Quantity" += TempItemLedgEntry2."Remaining Quantity";
          TempItemLedgEntry."Invoiced Quantity" += TempItemLedgEntry2."Invoiced Quantity";
          TempItemLedgEntry.Modify;
        end else
          TempItemLedgEntry.Insert;

        TempItemLedgEntry.Reset;
    end;


    procedure CollectItemTrkgPerPostedDocLine(var TempReservEntry: Record "Reservation Entry" temporary;var TempItemLedgEntry: Record "Item Ledger Entry" temporary;FromPurchase: Boolean;DocNo: Code[20];LineNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        TempItemLedgEntry.Reset;
        TempItemLedgEntry.DeleteAll;

        with TempReservEntry do begin
          Reset;
          SetCurrentkey("Source ID","Source Ref. No.");
          SetRange("Source ID",DocNo);
          SetRange("Source Ref. No.",LineNo);
          if FindSet then
            repeat
              ItemLedgEntry.Get("Item Ledger Entry No.");
              TempItemLedgEntry := ItemLedgEntry;
              if "Reservation Status" = "reservation status"::Prospect then
                TempItemLedgEntry."Entry No." := -TempItemLedgEntry."Entry No.";
              if FromPurchase then
                TempItemLedgEntry."Remaining Quantity" := "Quantity (Base)"
              else
                TempItemLedgEntry."Shipped Qty. Not Returned" := "Quantity (Base)";
              TempItemLedgEntry."Document No." := "Source ID";
              TempItemLedgEntry."Document Line No." := "Source Ref. No.";
              TempItemLedgEntry.Insert;
            until Next = 0;
        end;
    end;


    procedure CopyItemLedgerEntriesToTemp(var TempItemLedgEntry: Record "Item Ledger Entry" temporary;var FromItemLedgEntry: Record "Item Ledger Entry")
    begin
        TempItemLedgEntry.Reset;
        TempItemLedgEntry.DeleteAll;
        if FromItemLedgEntry.FindSet then
          repeat
            TempItemLedgEntry := FromItemLedgEntry;
            AddTempRecordToSet(TempItemLedgEntry,1);
          until FromItemLedgEntry.Next = 0;

        TempItemLedgEntry.Reset;
    end;

    local procedure FillTrackingSpecBuffer(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;Description: Text[50];ItemNo: Code[20];LN: Code[20];SN: Code[20];Qty: Decimal;Correction: Boolean)
    var
        LastEntryNo: Integer;
    begin
        // creates or sums up a record in TempTrackingSpecBuffer

        TempTrackingSpecBuffer.Reset;
        if TempTrackingSpecBuffer.FindLast then
          LastEntryNo := TempTrackingSpecBuffer."Entry No.";

        if ItemTrackingExistsInBuffer(TempTrackingSpecBuffer,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo,LN,SN) then begin
          TempTrackingSpecBuffer."Quantity (Base)" += Abs(Qty);                      // Sum up Qty
          TempTrackingSpecBuffer.Modify;
        end else begin
          LastEntryNo += 1;
          InitTrackingSpecBuffer(TempTrackingSpecBuffer,LastEntryNo,Type,Subtype,ID,BatchName,
            ProdOrderLine,RefNo,Description,ItemNo,LN,SN,Correction);
          TempTrackingSpecBuffer."Quantity (Base)" := Abs(Qty);
          TempTrackingSpecBuffer.Insert;
        end;
    end;

    local procedure FillTrackingSpecBufferFromILE(var TempItemLedgEntry: Record "Item Ledger Entry" temporary;var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;Description: Text[50])
    begin
        // creates a new record in TempTrackingSpecBuffer (used for Posted Shipments/Receipts/Invoices)

        if TempItemLedgEntry.FindSet then
          repeat
            if TempItemLedgEntry.TrackingExists then
              FillTrackingSpecBuffer(TempTrackingSpecBuffer,Type,Subtype,ID,BatchName,
                ProdOrderLine,RefNo,Description,TempItemLedgEntry."Item No.",TempItemLedgEntry."Lot No.",
                TempItemLedgEntry."Serial No.",TempItemLedgEntry.Quantity,TempItemLedgEntry.Correction);
          until TempItemLedgEntry.Next = 0;
    end;

    local procedure FilterReservEntries(var ReservEntry: Record "Reservation Entry";Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer)
    begin
        ReservEntry.SetCurrentkey("Source ID","Source Ref. No.","Source Type","Source Subtype","Source Batch Name",
          "Source Prod. Order Line","Reservation Status","Shipment Date","Expected Receipt Date");
        ReservEntry.SetRange("Source ID",ID);
        ReservEntry.SetRange("Source Ref. No.",RefNo);
        ReservEntry.SetRange("Source Type",Type);
        ReservEntry.SetRange("Source Subtype",Subtype);
        ReservEntry.SetRange("Source Batch Name",BatchName);
        ReservEntry.SetRange("Source Prod. Order Line",ProdOrderLine);
    end;

    local procedure FilterTrackingEntries(var TrackingSpec: Record "Tracking Specification";Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer)
    begin
        TrackingSpec.SetCurrentkey("Source ID","Source Type","Source Subtype","Source Batch Name",
          "Source Prod. Order Line","Source Ref. No.");
        TrackingSpec.SetRange("Source ID",ID);
        TrackingSpec.SetRange("Source Type",Type);
        TrackingSpec.SetRange("Source Subtype",Subtype);
        TrackingSpec.SetRange("Source Batch Name",BatchName);
        TrackingSpec.SetRange("Source Prod. Order Line",ProdOrderLine);
        TrackingSpec.SetRange("Source Ref. No.",RefNo);
    end;

    local procedure FindReservEntries(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;Description: Text[50])
    var
        ReservEntry: Record "Reservation Entry";
    begin
        // finds Item Tracking for Quote, Order, Invoice, Credit Memo, Return Order

        FilterReservEntries(ReservEntry,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo);
        if ReservEntry.FindSet then
          repeat
            if ReservEntry.TrackingExists then
              FillTrackingSpecBuffer(TempTrackingSpecBuffer,Type,Subtype,ID,BatchName,
                ProdOrderLine,RefNo,Description,ReservEntry."Item No.",ReservEntry."Lot No.",
                ReservEntry."Serial No.",ReservEntry."Quantity (Base)",ReservEntry.Correction);
          until ReservEntry.Next = 0;
    end;

    local procedure FindTrackingEntries(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;Description: Text[50])
    var
        TrackingSpec: Record "Tracking Specification";
    begin
        // finds Item Tracking for Quote, Order, Invoice, Credit Memo, Return Order when shipped/received

        FilterTrackingEntries(TrackingSpec,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo);
        if TrackingSpec.FindSet then
          repeat
            if TrackingSpec.TrackingExists then
              FillTrackingSpecBuffer(TempTrackingSpecBuffer,Type,Subtype,ID,BatchName,
                ProdOrderLine,RefNo,Description,TrackingSpec."Item No.",TrackingSpec."Lot No.",
                TrackingSpec."Serial No.",TrackingSpec."Quantity (Base)",TrackingSpec.Correction);
          until TrackingSpec.Next = 0;
    end;

    local procedure FindShptRcptEntries(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;Description: Text[50])
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
    begin
        // finds Item Tracking for Posted Shipments/Receipts

        RetrieveEntriesFromShptRcpt(TempItemLedgEntry,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo);
        FillTrackingSpecBufferFromILE(
          TempItemLedgEntry,TempTrackingSpecBuffer,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo,Description);
    end;

    local procedure FindInvoiceEntries(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;Description: Text[50])
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        InvoiceRowID: Text[250];
    begin
        InvoiceRowID := ItemTrackingMgt.ComposeRowID(Type,Subtype,ID,BatchName,ProdOrderLine,RefNo);
        RetrieveEntriesFromPostedInv(TempItemLedgEntry,InvoiceRowID);
        FillTrackingSpecBufferFromILE(
          TempItemLedgEntry,TempTrackingSpecBuffer,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo,Description);
    end;

    local procedure InitTrackingSpecBuffer(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;EntryNo: Integer;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;Description: Text[50];ItemNo: Code[20];LN: Code[20];SN: Code[20];Correction: Boolean)
    begin
        // initializes a new record for TempTrackingSpecBuffer

        TempTrackingSpecBuffer.Init;
        TempTrackingSpecBuffer."Source Type" := Type;
        TempTrackingSpecBuffer."Entry No." := EntryNo;
        TempTrackingSpecBuffer."Item No." := ItemNo;
        TempTrackingSpecBuffer.Description := Description;
        TempTrackingSpecBuffer."Source Subtype" := Subtype;
        TempTrackingSpecBuffer."Source ID" := ID;
        TempTrackingSpecBuffer."Source Batch Name" := BatchName;
        TempTrackingSpecBuffer."Source Prod. Order Line" := ProdOrderLine;
        TempTrackingSpecBuffer."Source Ref. No." := RefNo;
        TempTrackingSpecBuffer."Lot No." := LN;
        TempTrackingSpecBuffer."Serial No." := SN;
        TempTrackingSpecBuffer.Correction := Correction;
    end;

    local procedure ItemTrackingExistsInBuffer(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;LN: Code[20];SN: Code[20]): Boolean
    begin
        // searches after existing record in TempTrackingSpecBuffer

        TempTrackingSpecBuffer.SetCurrentkey("Source ID","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line","Source Ref. No.");
        TempTrackingSpecBuffer.SetRange("Source ID",ID);
        TempTrackingSpecBuffer.SetRange("Source Type",Type);
        TempTrackingSpecBuffer.SetRange("Source Subtype",Subtype);
        TempTrackingSpecBuffer.SetRange("Source Batch Name",BatchName);
        TempTrackingSpecBuffer.SetRange("Source Prod. Order Line",ProdOrderLine);
        TempTrackingSpecBuffer.SetRange("Source Ref. No.",RefNo);
        TempTrackingSpecBuffer.SetRange("Serial No.",SN);
        TempTrackingSpecBuffer.SetRange("Lot No.",LN);

        if not TempTrackingSpecBuffer.IsEmpty then begin
          TempTrackingSpecBuffer.FindFirst;
          exit(true);
        end;
        exit(false);
    end;


    procedure RetrieveDocumentItemTracking(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;SourceID: Code[20];SourceType: Integer;SourceSubType: Option): Integer
    begin
        // retrieves Item Tracking for Purchase Header, Sales Header, Sales Shipment Header, Sales Invoice Header

        TempTrackingSpecBuffer.DeleteAll;

        case SourceType of
          Database::"Purchase Header":
            RetrieveTrackingPurchase(TempTrackingSpecBuffer,SourceID,SourceSubType);
          Database::"Sales Header":
            RetrieveTrackingSales(TempTrackingSpecBuffer,SourceID,SourceSubType);
          Database::"Service Header":
            RetrieveTrackingService(TempTrackingSpecBuffer,SourceID,SourceSubType);
          Database::"Sales Shipment Header":
            RetrieveTrackingSalesShipment(TempTrackingSpecBuffer,SourceID);
          Database::"Sales Invoice Header":
            RetrieveTrackingSalesInvoice(TempTrackingSpecBuffer,SourceID);
          Database::"Service Shipment Header":
            RetrieveTrackingServiceShipment(TempTrackingSpecBuffer,SourceID);
          Database::"Service Invoice Header":
            RetrieveTrackingServiceInvoice(TempTrackingSpecBuffer,SourceID);
          else
            Error(TableNotSupportedErr,SourceType);
        end;

        TempTrackingSpecBuffer.Reset;
        exit(TempTrackingSpecBuffer.Count);
    end;

    local procedure RetrieveEntriesFromShptRcpt(var TempItemLedgEntry: Record "Item Ledger Entry" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer)
    var
        ItemEntryRelation: Record "Item Entry Relation";
        ItemLedgEntry: Record "Item Ledger Entry";
        SignFactor: Integer;
    begin
        // retrieves a data set of Item Ledger Entries (Posted Shipments/Receipts)

        ItemEntryRelation.SetCurrentkey("Source ID","Source Type");
        ItemEntryRelation.SetRange("Source Type",Type);
        ItemEntryRelation.SetRange("Source Subtype",Subtype);
        ItemEntryRelation.SetRange("Source ID",ID);
        ItemEntryRelation.SetRange("Source Batch Name",BatchName);
        ItemEntryRelation.SetRange("Source Prod. Order Line",ProdOrderLine);
        ItemEntryRelation.SetRange("Source Ref. No.",RefNo);
        if ItemEntryRelation.FindSet then begin
          SignFactor := TableSignFactor(Type);
          repeat
            ItemLedgEntry.Get(ItemEntryRelation."Item Entry No.");
            TempItemLedgEntry := ItemLedgEntry;
            AddTempRecordToSet(TempItemLedgEntry,SignFactor);
          until ItemEntryRelation.Next = 0;
        end;
    end;

    local procedure RetrieveEntriesFromPostedInv(var TempItemLedgEntry: Record "Item Ledger Entry" temporary;InvoiceRowID: Text[250])
    var
        ValueEntryRelation: Record "Value Entry Relation";
        ValueEntry: Record "Value Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        SignFactor: Integer;
    begin
        // retrieves a data set of Item Ledger Entries (Posted Invoices)

        ValueEntryRelation.SetCurrentkey("Source RowId");
        ValueEntryRelation.SetRange("Source RowId",InvoiceRowID);
        if ValueEntryRelation.Find('-') then begin
          SignFactor := TableSignFactor2(InvoiceRowID);
          repeat
            ValueEntry.Get(ValueEntryRelation."Value Entry No.");
            ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.");
            TempItemLedgEntry := ItemLedgEntry;
            TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";
            if TempItemLedgEntry."Entry Type" in [TempItemLedgEntry."entry type"::Purchase,TempItemLedgEntry."entry type"::Sale] then
              if TempItemLedgEntry.Quantity <> 0 then
                AddTempRecordToSet(TempItemLedgEntry,SignFactor);
          until ValueEntryRelation.Next = 0;
        end;
    end;

    local procedure RetrieveTrackingPurchase(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;SourceID: Code[20];SourceSubType: Option)
    var
        PurchaseLine: Record "Purchase Line";
        Item: Record Item;
        Descr: Text[50];
    begin
        PurchaseLine.SetRange("Document Type",SourceSubType);
        PurchaseLine.SetRange("Document No.",SourceID);
        if not PurchaseLine.IsEmpty then begin
          PurchaseLine.FindSet;
          repeat
            if (PurchaseLine.Type = PurchaseLine.Type::Item) and
               (PurchaseLine."Quantity (Base)" <> 0)
            then begin
              if Item.Get(PurchaseLine."No.") then
                Descr := Item.Description;
              FindReservEntries(TempTrackingSpecBuffer,Database::"Purchase Line",PurchaseLine."Document Type",
                PurchaseLine."Document No.",'',0,PurchaseLine."Line No.",Descr);
              FindTrackingEntries(TempTrackingSpecBuffer,Database::"Purchase Line",PurchaseLine."Document Type",
                PurchaseLine."Document No.",'',0,PurchaseLine."Line No.",Descr);
            end;
          until PurchaseLine.Next = 0;
        end;
    end;

    local procedure RetrieveTrackingSales(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;SourceID: Code[20];SourceSubType: Option)
    var
        SalesLine: Record "Sales Line";
        Item: Record Item;
        Descr: Text[50];
    begin
        SalesLine.SetRange("Document Type",SourceSubType);
        SalesLine.SetRange("Document No.",SourceID);
        if not SalesLine.IsEmpty then begin
          SalesLine.FindSet;
          repeat
            if (SalesLine.Type = SalesLine.Type::Item) and
               (SalesLine."No." <> '') and
               (SalesLine."Quantity (Base)" <> 0)
            then begin
              if Item.Get(SalesLine."No.") then
                Descr := Item.Description;
              FindReservEntries(TempTrackingSpecBuffer,Database::"Sales Line",SalesLine."Document Type",
                SalesLine."Document No.",'',0,SalesLine."Line No.",Descr);
              FindTrackingEntries(TempTrackingSpecBuffer,Database::"Sales Line",SalesLine."Document Type",
                SalesLine."Document No.",'',0,SalesLine."Line No.",Descr);
            end;
          until SalesLine.Next = 0;
        end;
    end;

    local procedure RetrieveTrackingService(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;SourceID: Code[20];SourceSubType: Option)
    var
        ServLine: Record "Service Line";
        Item: Record Item;
        Descr: Text[50];
    begin
        ServLine.SetRange("Document Type",SourceSubType);
        ServLine.SetRange("Document No.",SourceID);
        if not ServLine.IsEmpty then begin
          ServLine.FindSet;
          repeat
            if (ServLine.Type = ServLine.Type::Item) and
               (ServLine."No." <> '') and
               (ServLine."Quantity (Base)" <> 0)
            then begin
              if Item.Get(ServLine."No.") then
                Descr := Item.Description;
              FindReservEntries(TempTrackingSpecBuffer,Database::"Service Line",ServLine."Document Type",
                ServLine."Document No.",'',0,ServLine."Line No.",Descr);
              FindTrackingEntries(TempTrackingSpecBuffer,Database::"Service Line",ServLine."Document Type",
                ServLine."Document No.",'',0,ServLine."Line No.",Descr);
            end;
          until ServLine.Next = 0;
        end;
    end;

    local procedure RetrieveTrackingSalesShipment(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;SourceID: Code[20])
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        Item: Record Item;
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        Descr: Text[50];
    begin
        SalesShipmentLine.SetRange("Document No.",SourceID);
        if not SalesShipmentLine.IsEmpty then begin
          SalesShipmentLine.FindSet;
          repeat
            if (SalesShipmentLine.Type = SalesShipmentLine.Type::Item) and
               (SalesShipmentLine."No." <> '') and
               (SalesShipmentLine."Quantity (Base)" <> 0)
            then begin
              if Item.Get(SalesShipmentLine."No.") then
                Descr := Item.Description;
              FindShptRcptEntries(TempTrackingSpecBuffer,
                Database::"Sales Shipment Line",0,SalesShipmentLine."Document No.",'',0,SalesShipmentLine."Line No.",Descr);
              if RetrieveAsmItemTracking then
                if SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) then begin
                  PostedAsmLine.SetRange("Document No.",PostedAsmHeader."No.");
                  if PostedAsmLine.FindSet then
                    repeat
                      Descr := PostedAsmLine.Description;
                      FindShptRcptEntries(TempTrackingSpecBuffer,
                        Database::"Posted Assembly Line",0,PostedAsmLine."Document No.",'',0,PostedAsmLine."Line No.",Descr);
                    until PostedAsmLine.Next = 0;
                end;
            end;
          until SalesShipmentLine.Next = 0;
        end;
    end;

    local procedure RetrieveTrackingSalesInvoice(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;SourceID: Code[20])
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        Item: Record Item;
        Descr: Text[50];
    begin
        SalesInvoiceLine.SetRange("Document No.",SourceID);
        if not SalesInvoiceLine.IsEmpty then begin
          SalesInvoiceLine.FindSet;
          repeat
            if (SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item) and
               (SalesInvoiceLine."No." <> '') and
               (SalesInvoiceLine."Quantity (Base)" <> 0)
            then begin
              if Item.Get(SalesInvoiceLine."No.") then
                Descr := Item.Description;
              FindInvoiceEntries(TempTrackingSpecBuffer,
                Database::"Sales Invoice Line",0,SalesInvoiceLine."Document No.",'',0,SalesInvoiceLine."Line No.",Descr);
            end;
          until SalesInvoiceLine.Next = 0;
        end;
    end;

    local procedure RetrieveTrackingServiceShipment(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;SourceID: Code[20])
    var
        ServShptLine: Record "Service Shipment Line";
        Item: Record Item;
        Descr: Text[50];
    begin
        ServShptLine.SetRange("Document No.",SourceID);
        if not ServShptLine.IsEmpty then begin
          ServShptLine.FindSet;
          repeat
            if (ServShptLine.Type = ServShptLine.Type::Item) and
               (ServShptLine."No." <> '') and
               (ServShptLine."Quantity (Base)" <> 0)
            then begin
              if Item.Get(ServShptLine."No.") then
                Descr := Item.Description;
              FindShptRcptEntries(TempTrackingSpecBuffer,
                Database::"Service Shipment Line",0,ServShptLine."Document No.",'',0,ServShptLine."Line No.",Descr);
            end;
          until ServShptLine.Next = 0;
        end;
    end;

    local procedure RetrieveTrackingServiceInvoice(var TempTrackingSpecBuffer: Record "Tracking Specification" temporary;SourceID: Code[20])
    var
        ServInvLine: Record "Service Invoice Line";
        Item: Record Item;
        Descr: Text[50];
    begin
        ServInvLine.SetRange("Document No.",SourceID);
        if not ServInvLine.IsEmpty then begin
          ServInvLine.FindSet;
          repeat
            if (ServInvLine.Type = ServInvLine.Type::Item) and
               (ServInvLine."No." <> '') and
               (ServInvLine."Quantity (Base)" <> 0)
            then begin
              if Item.Get(ServInvLine."No.") then
                Descr := Item.Description;
              FindInvoiceEntries(TempTrackingSpecBuffer,
                Database::"Service Invoice Line",0,ServInvLine."Document No.",'',0,ServInvLine."Line No.",Descr);
            end;
          until ServInvLine.Next = 0;
        end;
    end;


    procedure SetRetrieveAsmItemTracking(RetrieveAsmItemTracking2: Boolean)
    begin
        RetrieveAsmItemTracking := RetrieveAsmItemTracking2;
    end;


    procedure ShowItemTrackingForInvoiceLine(InvoiceRowID: Text[250]): Boolean
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
    begin
        RetrieveEntriesFromPostedInv(TempItemLedgEntry,InvoiceRowID);
        if not TempItemLedgEntry.IsEmpty then begin
          Page.RunModal(Page::"Posted Item Tracking Lines",TempItemLedgEntry);
          exit(true);
        end;
        exit(false);
    end;


    procedure ShowItemTrackingForMasterData(SourceType: Option " ",Customer,Vendor,Item;SourceNo: Code[20];ItemNo: Code[20];VariantCode: Code[20];SerialNo: Code[20];LotNo: Code[20];LocationCode: Code[10])
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        Item: Record Item;
        Window: Dialog;
    begin
        // Used when calling Item Tracking from Item, Stockkeeping Unit, Customer, Vendor and information card:
        Window.Open(CountingRecordsMsg);

        if SourceNo <> '' then begin
          ItemLedgEntry.SetCurrentkey("Source Type","Source No.","Item No.","Variant Code");
          ItemLedgEntry.SetRange("Source No.",SourceNo);
          ItemLedgEntry.SetRange("Source Type",SourceType);
        end else
          ItemLedgEntry.SetCurrentkey("Item No.",Open,"Variant Code");

        if LocationCode <> '' then
          ItemLedgEntry.SetRange("Location Code",LocationCode);

        if ItemNo <> '' then begin
          Item.Get(ItemNo);
          Item.TestField("Item Tracking Code");
          ItemLedgEntry.SetRange("Item No.",ItemNo);
        end;
        if SourceType = 0 then
          ItemLedgEntry.SetRange("Variant Code",VariantCode);
        if SerialNo <> '' then
          ItemLedgEntry.SetRange("Serial No.",SerialNo);
        if LotNo <> '' then
          ItemLedgEntry.SetRange("Lot No.",LotNo);

        if ItemLedgEntry.FindSet then
          repeat
            if ItemLedgEntry.TrackingExists then begin
              TempItemLedgEntry := ItemLedgEntry;
              TempItemLedgEntry.Insert;
            end
          until ItemLedgEntry.Next = 0;
        Window.Close;
        Page.RunModal(Page::"Item Tracking Entries",TempItemLedgEntry);
    end;


    procedure ShowItemTrackingForProdOrderComp(Type: Integer;ID: Code[20];ProdOrderLine: Integer;RefNo: Integer): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        Window: Dialog;
    begin
        Window.Open(CountingRecordsMsg);
        ItemLedgEntry.SetCurrentkey("Order Type","Order No.","Order Line No.",
          "Entry Type","Prod. Order Comp. Line No.");
        ItemLedgEntry.SetRange("Order Type",ItemLedgEntry."order type"::Production);
        ItemLedgEntry.SetRange("Order No.",ID);
        ItemLedgEntry.SetRange("Order Line No.",ProdOrderLine);
        case Type of
          Database::"Prod. Order Line":
            begin
              ItemLedgEntry.SetRange("Entry Type",ItemLedgEntry."entry type"::Output);
              ItemLedgEntry.SetRange("Prod. Order Comp. Line No.",0);
            end;
          Database::"Prod. Order Component":
            begin
              ItemLedgEntry.SetRange("Entry Type",ItemLedgEntry."entry type"::Consumption);
              ItemLedgEntry.SetRange("Prod. Order Comp. Line No.",RefNo);
            end;
          else
            exit(false);
        end;
        if ItemLedgEntry.FindSet then
          repeat
            if ItemLedgEntry.TrackingExists then begin
              TempItemLedgEntry := ItemLedgEntry;
              TempItemLedgEntry.Insert;
            end
          until ItemLedgEntry.Next = 0;
        Window.Close;
        if TempItemLedgEntry.IsEmpty then
          exit(false);

        Page.RunModal(Page::"Posted Item Tracking Lines",TempItemLedgEntry);
        exit(true);
    end;


    procedure ShowItemTrackingForShptRcptLine(Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer): Boolean
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
    begin
        RetrieveEntriesFromShptRcpt(TempItemLedgEntry,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo);
        if not TempItemLedgEntry.IsEmpty then begin
          Page.RunModal(Page::"Posted Item Tracking Lines",TempItemLedgEntry);
          exit(true);
        end;
        exit(false);
    end;

    local procedure TableSignFactor(TableNo: Integer): Integer
    begin
        if TableNo in [
                       Database::"Sales Line",
                       Database::"Sales Shipment Line",
                       Database::"Sales Invoice Line",
                       Database::"Purch. Cr. Memo Line",
                       Database::"Prod. Order Component",
                       Database::"Transfer Shipment Line",
                       Database::"Return Shipment Line",
                       Database::"Planning Component",
                       Database::"Posted Assembly Line",
                       Database::"Service Line",
                       Database::"Service Shipment Line",
                       Database::"Service Invoice Line"]
        then
          exit(-1);

        exit(1);
    end;

    local procedure TableSignFactor2(RowID: Text[250]): Integer
    var
        TableNo: Integer;
    begin
        RowID := DelChr(RowID,'<','"');
        RowID := CopyStr(RowID,1,StrPos(RowID,'"') - 1);
        if Evaluate(TableNo,RowID) then
          exit(TableSignFactor(TableNo));

        exit(1);
    end;
}

