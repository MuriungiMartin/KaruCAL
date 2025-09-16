#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5817 "Undo Posting Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: label 'You cannot undo line %1 because there is not sufficient content in the receiving bins.';
        Text002: label 'You cannot undo line %1 because warehouse put-away lines have already been created.';
        Text003: label 'You cannot undo line %1 because warehouse activity lines have already been posted.';
        Text004: label 'You must delete the related %1 before you undo line %2.';
        Text005: label 'You cannot undo line %1 because warehouse receipt lines have already been created.';
        Text006: label 'You cannot undo line %1 because warehouse shipment lines have already been created.';
        Text007: label 'The items have been picked. If you undo line %1, the items will remain in the shipping area until you put them away.\Do you still want to undo the shipment?';
        Text008: label 'You cannot undo line %1 because warehouse receipt lines have already been posted.';
        Text009: label 'You cannot undo line %1 because warehouse put-away lines have already been posted.';
        Text010: label 'You cannot undo line %1 because inventory pick lines have already been posted.';
        Text011: label 'You cannot undo line %1 because there is an item charge assigned to it on %2 Doc No. %3 Line %4.';
        Text012: label 'You cannot undo line %1 because an item charge has already been invoiced.';
        Text013: label 'Item ledger entries are missing for line %1.';
        Text014: label 'You cannot undo line %1, because a revaluation has already been posted.';
        Text015: label 'You cannot undo posting of item %1 with variant ''%2'' and unit of measure %3 because it is not available at location %4, bin code %5. The required quantity is %6. The available quantity is %7.';
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";


    procedure TestSalesShptLine(SalesShptLine: Record "Sales Shipment Line")
    var
        SalesLine: Record "Sales Line";
    begin
        with SalesShptLine do
          TestAllTransactions(Database::"Sales Shipment Line",
            "Document No.","Line No.",
            Database::"Sales Line",
            SalesLine."document type"::Order,
            "Order No.",
            "Order Line No.");
    end;


    procedure TestServShptLine(ServShptLine: Record "Service Shipment Line")
    var
        ServLine: Record "Service Line";
    begin
        with ServShptLine do
          TestAllTransactions(Database::"Service Shipment Line",
            "Document No.","Line No.",
            Database::"Service Line",
            ServLine."document type"::Order,
            "Order No.",
            "Order Line No.");
    end;


    procedure TestPurchRcptLine(PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        PurchLine: Record "Purchase Line";
    begin
        with PurchRcptLine do
          TestAllTransactions(Database::"Purch. Rcpt. Line",
            "Document No.","Line No.",
            Database::"Purchase Line",
            PurchLine."document type"::Order,
            "Order No.",
            "Order Line No.");
    end;


    procedure TestReturnShptLine(ReturnShptLine: Record "Return Shipment Line")
    var
        PurchLine: Record "Purchase Line";
    begin
        with ReturnShptLine do
          TestAllTransactions(Database::"Return Shipment Line",
            "Document No.","Line No.",
            Database::"Purchase Line",
            PurchLine."document type"::"Return Order",
            "Return Order No.",
            "Return Order Line No.");
    end;


    procedure TestReturnRcptLine(ReturnRcptLine: Record "Return Receipt Line")
    var
        SalesLine: Record "Sales Line";
    begin
        with ReturnRcptLine do
          TestAllTransactions(Database::"Return Receipt Line",
            "Document No.","Line No.",
            Database::"Sales Line",
            SalesLine."document type"::"Return Order",
            "Return Order No.",
            "Return Order Line No.");
    end;


    procedure TestAsmHeader(PostedAsmHeader: Record "Posted Assembly Header")
    var
        AsmHeader: Record "Assembly Header";
    begin
        with PostedAsmHeader do
          TestAllTransactions(Database::"Posted Assembly Header",
            "No.",0,
            Database::"Assembly Header",
            AsmHeader."document type"::Order,
            "Order No.",
            0);
    end;


    procedure TestAsmLine(PostedAsmLine: Record "Posted Assembly Line")
    var
        AsmLine: Record "Assembly Line";
    begin
        with PostedAsmLine do
          TestAllTransactions(Database::"Posted Assembly Line",
            "Document No.","Line No.",
            Database::"Assembly Line",
            AsmLine."document type"::Order,
            "Order No.",
            "Order Line No.");
    end;

    local procedure TestAllTransactions(UndoType: Integer;UndoID: Code[20];UndoLineNo: Integer;SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceRefNo: Integer)
    begin
        if not TestPostedWhseReceiptLine(
             UndoType,UndoID,UndoLineNo,SourceType,SourceSubtype,SourceID,SourceRefNo)
        then begin
          TestWarehouseActivityLine(UndoType,UndoLineNo,SourceType,SourceSubtype,SourceID,SourceRefNo);
          TestRgstrdWhseActivityLine(UndoLineNo,SourceType,SourceSubtype,SourceID,SourceRefNo);
          TestWhseWorksheetLine(UndoLineNo,SourceType,SourceSubtype,SourceID,SourceRefNo);
        end;

        if not (UndoType in [Database::"Purch. Rcpt. Line",Database::"Return Receipt Line"]) then
          TestWarehouseReceiptLine(UndoLineNo,SourceType,SourceSubtype,SourceID,SourceRefNo);
        if not (UndoType in [Database::"Sales Shipment Line",Database::"Return Shipment Line",Database::"Service Shipment Line"]) then
          TestWarehouseShipmentLine(UndoLineNo,SourceType,SourceSubtype,SourceID,SourceRefNo);
        TestPostedWhseShipmentLine(UndoLineNo,SourceType,SourceSubtype,SourceID,SourceRefNo);
        TestPostedInvtPutAwayLine(UndoLineNo,SourceType,SourceSubtype,SourceID,SourceRefNo);
        TestPostedInvtPickLine(UndoLineNo,SourceType,SourceSubtype,SourceID,SourceRefNo);

        TestItemChargeAssignmentPurch(UndoType,UndoLineNo,SourceID,SourceRefNo);
        TestItemChargeAssignmentSales(UndoType,UndoLineNo,SourceID,SourceRefNo);
    end;

    local procedure TestPostedWhseReceiptLine(UndoType: Integer;UndoID: Code[20];UndoLineNo: Integer;SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceRefNo: Integer): Boolean
    var
        PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";
        PostedAsmHeader: Record "Posted Assembly Header";
        WhseUndoQty: Codeunit "Whse. Undo Quantity";
    begin
        case UndoType of
          Database::"Posted Assembly Line":
            begin
              TestWarehouseActivityLine(UndoType,UndoLineNo,SourceType,SourceSubtype,SourceID,SourceRefNo);
              exit(true);
            end;
          Database::"Posted Assembly Header":
            begin
              PostedAsmHeader.Get(UndoID);
              if not PostedAsmHeader.IsAsmToOrder then
                TestWarehouseBinContent(SourceType,SourceSubtype,SourceID,SourceRefNo,PostedAsmHeader."Quantity (Base)");
              exit(true);
            end;
        end;

        if not WhseUndoQty.FindPostedWhseRcptLine(
             PostedWhseReceiptLine,UndoType,UndoID,SourceType,SourceSubtype,SourceID,SourceRefNo)
        then
          exit(false);

        TestWarehouseEntry(UndoLineNo,PostedWhseReceiptLine);
        TestWarehouseActivityLine2(UndoLineNo,PostedWhseReceiptLine);
        TestRgstrdWhseActivityLine2(UndoLineNo,PostedWhseReceiptLine);
        TestWhseWorksheetLine2(UndoLineNo,PostedWhseReceiptLine);
        exit(true);
    end;

    local procedure TestWarehouseEntry(UndoLineNo: Integer;var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line")
    var
        WarehouseEntry: Record "Warehouse Entry";
        Location: Record Location;
    begin
        with WarehouseEntry do begin
          if PostedWhseReceiptLine."Location Code" = '' then
            exit;
          Location.Get(PostedWhseReceiptLine."Location Code");
          if Location."Bin Mandatory" then begin
            SetCurrentkey("Item No.","Location Code","Variant Code","Bin Type Code");
            SetRange("Item No.",PostedWhseReceiptLine."Item No.");
            SetRange("Location Code",PostedWhseReceiptLine."Location Code");
            SetRange("Variant Code",PostedWhseReceiptLine."Variant Code");
            if Location."Directed Put-away and Pick" then
              SetFilter("Bin Type Code",GetBinTypeFilter(0)); // Receiving area
            CalcSums("Qty. (Base)");
            if "Qty. (Base)" < PostedWhseReceiptLine."Qty. (Base)" then
              Error(Text001,UndoLineNo);
          end;
        end;
    end;

    local procedure TestWarehouseBinContent(SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceRefNo: Integer;UndoQtyBase: Decimal)
    var
        WhseEntry: Record "Warehouse Entry";
        BinContent: Record "Bin Content";
        QtyAvailToTake: Decimal;
    begin
        with WhseEntry do begin
          SetCurrentkey("Source Type","Source Subtype","Source No.");
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubtype);
          SetRange("Source No.",SourceID);
          SetRange("Source Line No.",SourceRefNo);
          if not FindFirst then
            exit;

          BinContent.Get("Location Code","Bin Code","Item No.","Variant Code","Unit of Measure Code");
          QtyAvailToTake := BinContent.CalcQtyAvailToTake(0);
          if QtyAvailToTake < UndoQtyBase then
            Error(Text015,
              "Item No.",
              "Variant Code",
              "Unit of Measure Code",
              "Location Code",
              "Bin Code",
              UndoQtyBase,
              QtyAvailToTake);
        end;
    end;

    local procedure TestWarehouseActivityLine2(UndoLineNo: Integer;var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line")
    var
        WarehouseActivityLine: Record "Warehouse Activity Line";
    begin
        with WarehouseActivityLine do begin
          SetCurrentkey("Whse. Document No.","Whse. Document Type","Activity Type","Whse. Document Line No.");
          SetRange("Whse. Document No.",PostedWhseReceiptLine."No.");
          SetRange("Whse. Document Type","whse. document type"::Receipt);
          SetRange("Activity Type","activity type"::"Put-away");
          SetRange("Whse. Document Line No.",PostedWhseReceiptLine."Line No.");
          if not IsEmpty then
            Error(Text002,UndoLineNo);
        end;
    end;

    local procedure TestRgstrdWhseActivityLine2(UndoLineNo: Integer;var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line")
    var
        RegisteredWhseActivityLine: Record "Registered Whse. Activity Line";
    begin
        with RegisteredWhseActivityLine do begin
          SetCurrentkey("Whse. Document Type","Whse. Document No.","Whse. Document Line No.");
          SetRange("Whse. Document Type","whse. document type"::Receipt);
          SetRange("Whse. Document No.",PostedWhseReceiptLine."No.");
          SetRange("Whse. Document Line No.",PostedWhseReceiptLine."Line No.");
          if not IsEmpty then
            Error(Text003,UndoLineNo);
        end;
    end;

    local procedure TestWhseWorksheetLine2(UndoLineNo: Integer;var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line")
    var
        WhseWorksheetLine: Record "Whse. Worksheet Line";
    begin
        with WhseWorksheetLine do begin
          SetCurrentkey("Whse. Document Type","Whse. Document No.","Whse. Document Line No.");
          SetRange("Whse. Document Type","whse. document type"::Receipt);
          SetRange("Whse. Document No.",PostedWhseReceiptLine."No.");
          SetRange("Whse. Document Line No.",PostedWhseReceiptLine."Line No.");
          if not IsEmpty then
            Error(Text004,TableCaption,UndoLineNo);
        end;
    end;

    local procedure TestWarehouseActivityLine(UndoType: Integer;UndoLineNo: Integer;SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceRefNo: Integer)
    var
        WarehouseActivityLine: Record "Warehouse Activity Line";
    begin
        with WarehouseActivityLine do begin
          SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubtype);
          SetRange("Source No.",SourceID);
          SetRange("Source Line No.",SourceRefNo);
          if not IsEmpty then begin
            if UndoType = Database::"Assembly Line" then
              Error(Text002,UndoLineNo);
            Error(Text003,UndoLineNo);
          end;
        end;
    end;

    local procedure TestRgstrdWhseActivityLine(UndoLineNo: Integer;SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceRefNo: Integer)
    var
        RegisteredWhseActivityLine: Record "Registered Whse. Activity Line";
    begin
        with RegisteredWhseActivityLine do begin
          SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubtype);
          SetRange("Source No.",SourceID);
          SetRange("Source Line No.",SourceRefNo);
          SetRange("Activity Type","activity type"::"Put-away");
          if not IsEmpty then
            Error(Text002,UndoLineNo);
        end;
    end;

    local procedure TestWarehouseReceiptLine(UndoLineNo: Integer;SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceRefNo: Integer)
    var
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
    begin
        with WarehouseReceiptLine do begin
          SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubtype);
          SetRange("Source No.",SourceID);
          SetRange("Source Line No.",SourceRefNo);
          if not IsEmpty then
            Error(Text005,UndoLineNo);
        end;
    end;

    local procedure TestWarehouseShipmentLine(UndoLineNo: Integer;SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceRefNo: Integer)
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        with WarehouseShipmentLine do begin
          SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubtype);
          SetRange("Source No.",SourceID);
          SetRange("Source Line No.",SourceRefNo);
          if not IsEmpty then
            Error(Text006,UndoLineNo);
        end;
    end;

    local procedure TestPostedWhseShipmentLine(UndoLineNo: Integer;SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceRefNo: Integer)
    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
    begin
        with PostedWhseShipmentLine do begin
          SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubtype);
          SetRange("Source No.",SourceID);
          SetRange("Source Line No.",SourceRefNo);
          if not IsEmpty then
            if not Confirm(Text007,true,UndoLineNo) then
              Error('');
        end;
    end;

    local procedure TestWhseWorksheetLine(UndoLineNo: Integer;SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceRefNo: Integer)
    var
        WhseWorksheetLine: Record "Whse. Worksheet Line";
    begin
        with WhseWorksheetLine do begin
          SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubtype);
          SetRange("Source No.",SourceID);
          SetRange("Source Line No.",SourceRefNo);
          if not IsEmpty then
            Error(Text008,UndoLineNo);
        end;
    end;

    local procedure TestPostedInvtPutAwayLine(UndoLineNo: Integer;SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceRefNo: Integer)
    var
        PostedInvtPutAwayLine: Record "Posted Invt. Put-away Line";
    begin
        with PostedInvtPutAwayLine do begin
          SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubtype);
          SetRange("Source No.",SourceID);
          SetRange("Source Line No.",SourceRefNo);
          if not IsEmpty then
            Error(Text009,UndoLineNo);
        end;
    end;

    local procedure TestPostedInvtPickLine(UndoLineNo: Integer;SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceRefNo: Integer)
    var
        PostedInvtPickLine: Record "Posted Invt. Pick Line";
    begin
        with PostedInvtPickLine do begin
          SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubtype);
          SetRange("Source No.",SourceID);
          SetRange("Source Line No.",SourceRefNo);
          if not IsEmpty then
            Error(Text010,UndoLineNo);
        end;
    end;

    local procedure TestItemChargeAssignmentPurch(UndoType: Integer;UndoLineNo: Integer;SourceID: Code[20];SourceRefNo: Integer)
    var
        ItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)";
    begin
        with ItemChargeAssignmentPurch do begin
          SetCurrentkey("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
          case UndoType of
            Database::"Purch. Rcpt. Line":
              SetRange("Applies-to Doc. Type","applies-to doc. type"::Receipt);
            Database::"Return Shipment Line":
              SetRange("Applies-to Doc. Type","applies-to doc. type"::"Return Shipment");
            else
              exit;
          end;
          SetRange("Applies-to Doc. No.",SourceID);
          SetRange("Applies-to Doc. Line No.",SourceRefNo);
          if not IsEmpty then
            if FindFirst then
              Error(Text011,UndoLineNo,"Document Type","Document No.","Line No.");
        end;
    end;

    local procedure TestItemChargeAssignmentSales(UndoType: Integer;UndoLineNo: Integer;SourceID: Code[20];SourceRefNo: Integer)
    var
        ItemChargeAssignmentSales: Record "Item Charge Assignment (Sales)";
    begin
        with ItemChargeAssignmentSales do begin
          SetCurrentkey("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
          case UndoType of
            Database::"Sales Shipment Line":
              SetRange("Applies-to Doc. Type","applies-to doc. type"::Shipment);
            Database::"Return Receipt Line":
              SetRange("Applies-to Doc. Type","applies-to doc. type"::"Return Receipt");
            else
              exit;
          end;
          SetRange("Applies-to Doc. No.",SourceID);
          SetRange("Applies-to Doc. Line No.",SourceRefNo);
          if not IsEmpty then
            if FindFirst then
              Error(Text011,UndoLineNo,"Document Type","Document No.","Line No.");
        end;
    end;

    local procedure GetBinTypeFilter(Type: Option Receive,Ship,"Put Away",Pick): Text[1024]
    var
        BinType: Record "Bin Type";
        "Filter": Text[1024];
    begin
        with BinType do begin
          case Type of
            Type::Receive:
              SetRange(Receive,true);
            Type::Ship:
              SetRange(Ship,true);
            Type::"Put Away":
              SetRange("Put Away",true);
            Type::Pick:
              SetRange(Pick,true);
          end;
          if Find('-') then
            repeat
              Filter := StrSubstNo('%1|%2',Filter,Code);
            until Next = 0;
          if Filter <> '' then
            Filter := CopyStr(Filter,2);
        end;
        exit(Filter);
    end;


    procedure CheckItemLedgEntries(var TempItemLedgEntry: Record "Item Ledger Entry" temporary;LineRef: Integer)
    var
        ValueEntry: Record "Value Entry";
        ItemRec: Record Item;
        PostedATOLink: Record "Posted Assemble-to-Order Link";
    begin
        with TempItemLedgEntry do begin
          Find('-'); // Assertion: will fail if not found.
          ValueEntry.SetCurrentkey("Item Ledger Entry No.");
          ItemRec.Get("Item No.");

          repeat
            if Positive then begin
              if ("Job No." = '') and
                 not (("Order Type" = "order type"::Assembly) and
                      PostedATOLink.Get(PostedATOLink."assembly document type"::Assembly,"Document No."))
              then
                TestField("Remaining Quantity",Quantity);
            end else
              TestField("Shipped Qty. Not Returned",Quantity);
            CalcFields("Reserved Quantity");
            TestField("Reserved Quantity",0);

            ValueEntry.SetRange("Item Ledger Entry No.","Entry No.");
            if ValueEntry.Find('-') then
              repeat
                if ValueEntry."Item Charge No." <> '' then
                  Error(Text012,LineRef);
                if ValueEntry."Entry Type" = ValueEntry."entry type"::Revaluation then
                  Error(Text014,LineRef);
              until ValueEntry.Next = 0;

            if ItemRec."Costing Method" = ItemRec."costing method"::Specific then
              TestField("Serial No.");
          until Next = 0;
        end; // WITH
    end;


    procedure PostItemJnlLineAppliedToList(ItemJnlLine: Record "Item Journal Line";var TempApplyToEntryList: Record "Item Ledger Entry" temporary;UndoQty: Decimal;UndoQtyBase: Decimal;var TempItemLedgEntry: Record "Item Ledger Entry" temporary;var TempItemEntryRelation: Record "Item Entry Relation" temporary)
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        NonDistrQuantity: Decimal;
        NonDistrQuantityBase: Decimal;
    begin
        TempApplyToEntryList.Find('-'); // Assertion: will fail if not found.
        if ItemJnlLine."Job No." = '' then
          ItemJnlLine.TestField(Correction,true);
        NonDistrQuantity := -UndoQty;
        NonDistrQuantityBase := -UndoQtyBase;
        repeat
          if ItemJnlLine."Job No." = '' then
            ItemJnlLine."Applies-to Entry" := TempApplyToEntryList."Entry No."
          else
            ItemJnlLine."Applies-to Entry" := 0;

          ItemJnlLine."Item Shpt. Entry No." := 0;
          ItemJnlLine."Quantity (Base)" := -TempApplyToEntryList.Quantity;
          ItemJnlLine."Serial No." := TempApplyToEntryList."Serial No.";
          ItemJnlLine."Lot No." := TempApplyToEntryList."Lot No.";

          // Quantity is filled in according to UOM:
          ItemTrackingMgt.AdjustQuantityRounding(
            NonDistrQuantity,ItemJnlLine.Quantity,
            NonDistrQuantityBase,ItemJnlLine."Quantity (Base)");

          NonDistrQuantity := NonDistrQuantity - ItemJnlLine.Quantity;
          NonDistrQuantityBase := NonDistrQuantityBase - ItemJnlLine."Quantity (Base)";

          PostItemJnlLine(ItemJnlLine);

          TempItemEntryRelation."Item Entry No." := ItemJnlLine."Item Shpt. Entry No.";
          TempItemEntryRelation."Serial No." := ItemJnlLine."Serial No.";
          TempItemEntryRelation."Lot No." := ItemJnlLine."Lot No.";
          TempItemEntryRelation.Insert;
          TempItemLedgEntry := TempApplyToEntryList;
          TempItemLedgEntry.Insert;
        until TempApplyToEntryList.Next = 0;
    end;


    procedure CollectItemLedgEntries(var TempItemLedgEntry: Record "Item Ledger Entry" temporary;SourceType: Integer;DocumentNo: Code[20];LineNo: Integer;BaseQty: Decimal;EntryRef: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        TempItemLedgEntry.Reset;
        if not TempItemLedgEntry.IsEmpty then
          TempItemLedgEntry.DeleteAll;
        if EntryRef <> 0 then begin
          ItemLedgEntry.Get(EntryRef); // Assertion: will fail if no entry exists.
          TempItemLedgEntry := ItemLedgEntry;
          TempItemLedgEntry.Insert;
        end else begin
          if SourceType in [Database::"Sales Shipment Line",
                            Database::"Return Shipment Line",
                            Database::"Service Shipment Line",
                            Database::"Posted Assembly Line"]
          then
            BaseQty := BaseQty * -1;
          if not
             ItemTrackingMgt.CollectItemEntryRelation(
               TempItemLedgEntry,SourceType,0,DocumentNo,'',0,LineNo,BaseQty)
          then
            Error(Text013,LineNo);
        end;
    end;


    procedure UpdatePurchLine(PurchLine: Record "Purchase Line";UndoQty: Decimal;UndoQtyBase: Decimal;var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        xPurchLine: Record "Purchase Line";
        PurchSetup: Record "Purchases & Payables Setup";
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
    begin
        PurchSetup.Get;
        with PurchLine do begin
          xPurchLine := PurchLine;
          case "Document Type" of
            "document type"::"Return Order":
              begin
                "Return Qty. Shipped" := "Return Qty. Shipped" - UndoQty;
                "Return Qty. Shipped (Base)" := "Return Qty. Shipped (Base)" - UndoQtyBase;
                InitOutstanding;
                if PurchSetup."Default Qty. to Receive" = PurchSetup."default qty. to receive"::Blank then
                  "Qty. to Receive" := 0
                else
                  InitQtyToShip;
              end;
            "document type"::Order:
              begin
                "Quantity Received" := "Quantity Received" - UndoQty;
                "Qty. Received (Base)" := "Qty. Received (Base)" - UndoQtyBase;
                InitOutstanding;
                if PurchSetup."Default Qty. to Receive" = PurchSetup."default qty. to receive"::Blank then
                  "Qty. to Receive" := 0
                else
                  InitQtyToReceive;
              end;
            else
              FieldError("Document Type");
          end;
          Modify;
          RevertPostedItemTracking(TempUndoneItemLedgEntry,"Expected Receipt Date");
          xPurchLine."Quantity (Base)" := 0;
          ReservePurchLine.VerifyQuantity(PurchLine,xPurchLine);
        end;
    end;


    procedure UpdateSalesLine(SalesLine: Record "Sales Line";UndoQty: Decimal;UndoQtyBase: Decimal;var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        xSalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
        SalesSetup.Get;
        with SalesLine do begin
          xSalesLine := SalesLine;
          case "Document Type" of
            "document type"::"Return Order":
              begin
                "Return Qty. Received" := "Return Qty. Received" - UndoQty;
                "Return Qty. Received (Base)" := "Return Qty. Received (Base)" - UndoQtyBase;
                InitOutstanding;
                if SalesSetup."Default Quantity to Ship" = SalesSetup."default quantity to ship"::Blank then
                  "Qty. to Ship" := 0
                else
                  InitQtyToReceive;
              end;
            "document type"::Order:
              begin
                "Quantity Shipped" := "Quantity Shipped" - UndoQty;
                "Qty. Shipped (Base)" := "Qty. Shipped (Base)" - UndoQtyBase;
                InitOutstanding;
                if SalesSetup."Default Quantity to Ship" = SalesSetup."default quantity to ship"::Blank then
                  "Qty. to Ship" := 0
                else
                  InitQtyToShip;
              end;
            else
              FieldError("Document Type");
          end;
          Modify;
          RevertPostedItemTracking(TempUndoneItemLedgEntry,"Shipment Date");
          xSalesLine."Quantity (Base)" := 0;
          ReserveSalesLine.VerifyQuantity(SalesLine,xSalesLine);
        end;
    end;


    procedure UpdateServLine(ServLine: Record "Service Line";UndoQty: Decimal;UndoQtyBase: Decimal;var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        xServLine: Record "Service Line";
        ReserveServLine: Codeunit "Service Line-Reserve";
    begin
        with ServLine do begin
          xServLine := ServLine;
          case "Document Type" of
            "document type"::Order:
              begin
                "Quantity Shipped" := "Quantity Shipped" - UndoQty;
                "Qty. Shipped (Base)" := "Qty. Shipped (Base)" - UndoQtyBase;
                "Qty. to Consume" := 0;
                "Qty. to Consume (Base)" := 0;
                InitOutstanding;
                InitQtyToShip;
              end;
            else
              FieldError("Document Type");
          end;
          Modify;
          RevertPostedItemTracking(TempUndoneItemLedgEntry,"Posting Date");
          xServLine."Quantity (Base)" := 0;
          ReserveServLine.VerifyQuantity(ServLine,xServLine);
        end;
    end;


    procedure UpdateServLineCnsm(var ServLine: Record "Service Line";UndoQty: Decimal;UndoQtyBase: Decimal;var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        ServHeader: Record "Service Header";
        xServLine: Record "Service Line";
        SalesSetup: Record "Sales & Receivables Setup";
        ReserveServLine: Codeunit "Service Line-Reserve";
        ServCalcDiscount: Codeunit "Service-Calc. Discount";
    begin
        with ServLine do begin
          xServLine := ServLine;
          case "Document Type" of
            "document type"::Order:
              begin
                "Quantity Consumed" := "Quantity Consumed" - UndoQty;
                "Qty. Consumed (Base)" := "Qty. Consumed (Base)" - UndoQtyBase;
                "Quantity Shipped" := "Quantity Shipped" - UndoQty;
                "Qty. Shipped (Base)" := "Qty. Shipped (Base)" - UndoQtyBase;
                "Qty. to Invoice" := 0;
                "Qty. to Invoice (Base)" := 0;
                InitOutstanding;
                InitQtyToShip;
                Validate("Line Discount %");
                ConfirmAdjPriceLineChange;
                Modify;

                SalesSetup.Get;
                if SalesSetup."Calc. Inv. Discount" then begin
                  ServHeader.Get("Document Type","Document No.");
                  ServCalcDiscount.CalculateWithServHeader(ServHeader,ServLine,ServLine);
                end;
              end;
            else
              FieldError("Document Type");
          end;
          Modify;
          RevertPostedItemTracking(TempUndoneItemLedgEntry,"Posting Date");
          xServLine."Quantity (Base)" := 0;
          ReserveServLine.VerifyQuantity(ServLine,xServLine);
        end;
    end;

    local procedure RevertPostedItemTracking(var TempItemLedgEntry: Record "Item Ledger Entry" temporary;AvailabilityDate: Date)
    var
        TrackingSpecification: Record "Tracking Specification";
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
    begin
        with TempItemLedgEntry do begin
          if Find('-') then begin
            repeat
              TrackingSpecification.Get("Entry No.");
              if not TrackingIsATO(TrackingSpecification) then begin
                ReservEntry.Init;
                ReservEntry.TransferFields(TrackingSpecification);
                ReservEntry.Validate("Quantity (Base)");
                ReservEntry."Reservation Status" := ReservEntry."reservation status"::Surplus;
                if ReservEntry.Positive then
                  ReservEntry."Expected Receipt Date" := AvailabilityDate
                else
                  ReservEntry."Shipment Date" := AvailabilityDate;
                ReservEntry."Entry No." := 0;
                ReservEntry.UpdateItemTracking;
                ReservEntry.Insert;

                TempReservEntry := ReservEntry;
                TempReservEntry.Insert;
              end;
              TrackingSpecification.Delete;
            until Next = 0;
            ReservEngineMgt.UpdateOrderTracking(TempReservEntry);
          end;
        end; // WITH
    end;


    procedure PostItemJnlLine(var ItemJnlLine: Record "Item Journal Line")
    var
        Job: Record Job;
        ItemJnlLine2: Record "Item Journal Line";
    begin
        Clear(ItemJnlLine2);
        ItemJnlLine2 := ItemJnlLine;
        if ItemJnlLine2."Job No." <> '' then begin
          ItemJnlLine2."Entry Type" := ItemJnlLine2."entry type"::"Negative Adjmt.";
          Job.Get(ItemJnlLine2."Job No.");
          ItemJnlLine2."Source No." := Job."Bill-to Customer No.";
          ItemJnlLine2."Source Type" := ItemJnlLine2."source type"::Customer;
          ItemJnlLine2."Discount Amount" := 0;
          ItemJnlPostLine.Run(ItemJnlLine2);

          ItemJnlLine."Applies-to Entry" := ItemJnlLine2."Item Shpt. Entry No.";
        end;
        ItemJnlPostLine.Run(ItemJnlLine);
    end;

    local procedure TrackingIsATO(TrackingSpecification: Record "Tracking Specification"): Boolean
    var
        ATOLink: Record "Assemble-to-Order Link";
    begin
        with TrackingSpecification do begin
          if "Source Type" <> Database::"Sales Line" then
            exit(false);
          if not "Prohibit Cancellation" then
            exit(false);

          ATOLink.SetCurrentkey(Type,"Document Type","Document No.","Document Line No.");
          ATOLink.SetRange(Type,ATOLink.Type::Sale);
          ATOLink.SetRange("Document Type","Source Subtype");
          ATOLink.SetRange("Document No.","Source ID");
          ATOLink.SetRange("Document Line No.","Source Ref. No.");
          exit(not ATOLink.IsEmpty);
        end;
    end;


    procedure TransferSourceValues(var ItemJnlLine: Record "Item Journal Line";EntryNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
    begin
        with ItemLedgEntry do begin
          Get(EntryNo);
          ItemJnlLine."Source Type" := "Source Type";
          ItemJnlLine."Source No." := "Source No.";
          ItemJnlLine."Country/Region Code" := "Country/Region Code";
        end;

        with ValueEntry do begin
          SetRange("Item Ledger Entry No.",EntryNo);
          FindFirst;
          ItemJnlLine."Source Posting Group" := "Source Posting Group";
          ItemJnlLine."Salespers./Purch. Code" := "Salespers./Purch. Code";
        end;
    end;


    procedure ReapplyJobConsumption(ItemRcptEntryNo: Integer)
    var
        ItemApplnEntry: Record "Item Application Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        // Purchase receipt and job consumption are reapplied with with fixed cost application
        ItemApplnEntry.SetRange("Inbound Item Entry No.",ItemRcptEntryNo);
        ItemApplnEntry.SetFilter("Item Ledger Entry No.",'<>%1',ItemRcptEntryNo);
        ItemApplnEntry.FindFirst;
        ItemJnlPostLine.UnApply(ItemApplnEntry);
        ItemLedgEntry.Get(ItemApplnEntry."Inbound Item Entry No.");
        ItemJnlPostLine.ReApply(ItemLedgEntry,ItemApplnEntry."Outbound Item Entry No.");
    end;
}

