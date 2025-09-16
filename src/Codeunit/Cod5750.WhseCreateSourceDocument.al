#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5750 "Whse.-Create Source Document"
{

    trigger OnRun()
    begin
    end;

    var
        WhseMgt: Codeunit "Whse. Management";


    procedure FromSalesLine2ShptLine(WhseShptHeader: Record "Warehouse Shipment Header";SalesLine: Record "Sales Line"): Boolean
    var
        AsmHeader: Record "Assembly Header";
        TotalOutstandingWhseShptQty: Decimal;
        TotalOutstandingWhseShptQtyBase: Decimal;
        ATOWhseShptLineQty: Decimal;
        ATOWhseShptLineQtyBase: Decimal;
    begin
        SalesLine.CalcFields("Whse. Outstanding Qty.","ATO Whse. Outstanding Qty.",
          "Whse. Outstanding Qty. (Base)","ATO Whse. Outstd. Qty. (Base)");
        TotalOutstandingWhseShptQty := Abs(SalesLine."Outstanding Quantity") - SalesLine."Whse. Outstanding Qty.";
        TotalOutstandingWhseShptQtyBase := Abs(SalesLine."Outstanding Qty. (Base)") - SalesLine."Whse. Outstanding Qty. (Base)";
        if SalesLine.AsmToOrderExists(AsmHeader) then begin
          ATOWhseShptLineQty := AsmHeader."Remaining Quantity" - SalesLine."ATO Whse. Outstanding Qty.";
          ATOWhseShptLineQtyBase := AsmHeader."Remaining Quantity (Base)" - SalesLine."ATO Whse. Outstd. Qty. (Base)";
          if ATOWhseShptLineQtyBase > 0 then begin
            if not CreateShptLineFromSalesLine(WhseShptHeader,SalesLine,ATOWhseShptLineQty,ATOWhseShptLineQtyBase,true) then
              exit(false);
            TotalOutstandingWhseShptQty -= ATOWhseShptLineQty;
            TotalOutstandingWhseShptQtyBase -= ATOWhseShptLineQtyBase;
          end;
        end;
        if TotalOutstandingWhseShptQtyBase > 0 then
          exit(CreateShptLineFromSalesLine(WhseShptHeader,SalesLine,TotalOutstandingWhseShptQty,TotalOutstandingWhseShptQtyBase,false));
        exit(true);
    end;

    local procedure CreateShptLineFromSalesLine(WhseShptHeader: Record "Warehouse Shipment Header";SalesLine: Record "Sales Line";WhseShptLineQty: Decimal;WhseShptLineQtyBase: Decimal;AssembleToOrder: Boolean): Boolean
    var
        WhseShptLine: Record "Warehouse Shipment Line";
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get(SalesLine."Document Type",SalesLine."Document No.");

        with WhseShptLine do begin
          Reset;
          "No." := WhseShptHeader."No.";
          SetRange("No.","No.");
          LockTable;
          if FindLast then;

          Init;
          SetIgnoreErrors;
          "Line No." := "Line No." + 10000;
          "Source Type" := Database::"Sales Line";
          "Source Subtype" := SalesLine."Document Type";
          "Source No." := SalesLine."Document No.";
          "Source Line No." := SalesLine."Line No.";
          "Source Document" := WhseMgt.GetSourceDocument("Source Type","Source Subtype");
          "Location Code" := SalesLine."Location Code";
          "Item No." := SalesLine."No.";
          "Variant Code" := SalesLine."Variant Code";
          SalesLine.TestField("Unit of Measure Code");
          "Unit of Measure Code" := SalesLine."Unit of Measure Code";
          "Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
          Description := SalesLine.Description;
          "Description 2" := SalesLine."Description 2";
          SetQtysOnShptLine(WhseShptLine,WhseShptLineQty,WhseShptLineQtyBase);
          "Assemble to Order" := AssembleToOrder;
          if SalesLine."Document Type" = SalesLine."document type"::Order then
            "Due Date" := SalesLine."Planned Shipment Date";
          if SalesLine."Document Type" = SalesLine."document type"::"Return Order" then
            "Due Date" := WorkDate;
          if WhseShptHeader."Shipment Date" = 0D then
            "Shipment Date" := SalesLine."Shipment Date"
          else
            "Shipment Date" := WhseShptHeader."Shipment Date";
          "Destination Type" := "destination type"::Customer;
          "Destination No." := SalesLine."Sell-to Customer No.";
          "Shipping Advice" := SalesHeader."Shipping Advice";
          if "Location Code" = WhseShptHeader."Location Code" then
            "Bin Code" := WhseShptHeader."Bin Code";
          if "Bin Code" = '' then
            "Bin Code" := SalesLine."Bin Code";
          UpdateShptLine(WhseShptLine,WhseShptHeader);
          CreateShptLine(WhseShptLine);
          exit(not HasErrorOccured);
        end;
    end;


    procedure SalesLine2ReceiptLine(WhseReceiptHeader: Record "Warehouse Receipt Header";SalesLine: Record "Sales Line"): Boolean
    var
        WhseReceiptLine: Record "Warehouse Receipt Line";
    begin
        with WhseReceiptLine do begin
          Reset;
          "No." := WhseReceiptHeader."No.";
          SetRange("No.","No.");
          LockTable;
          if FindLast then;

          Init;
          SetIgnoreErrors;
          "Line No." := "Line No." + 10000;
          "Source Type" := Database::"Sales Line";
          "Source Subtype" := SalesLine."Document Type";
          "Source No." := SalesLine."Document No.";
          "Source Line No." := SalesLine."Line No.";
          "Source Document" := WhseMgt.GetSourceDocument("Source Type","Source Subtype");
          "Location Code" := SalesLine."Location Code";
          "Item No." := SalesLine."No.";
          "Variant Code" := SalesLine."Variant Code";
          SalesLine.TestField("Unit of Measure Code");
          "Unit of Measure Code" := SalesLine."Unit of Measure Code";
          "Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
          Description := SalesLine.Description;
          "Description 2" := SalesLine."Description 2";
          case SalesLine."Document Type" of
            SalesLine."document type"::Order:
              begin
                Validate("Qty. Received",Abs(SalesLine."Quantity Shipped"));
                "Due Date" := SalesLine."Planned Shipment Date";
              end;
            SalesLine."document type"::"Return Order":
              begin
                Validate("Qty. Received",Abs(SalesLine."Return Qty. Received"));
                "Due Date" := WorkDate;
              end;
          end;
          SetQtysOnRcptLine(WhseReceiptLine,Abs(SalesLine.Quantity),Abs(SalesLine."Quantity (Base)"));
          "Starting Date" := SalesLine."Shipment Date";
          if "Location Code" = WhseReceiptHeader."Location Code" then
            "Bin Code" := WhseReceiptHeader."Bin Code";
          if "Bin Code" = '' then
            "Bin Code" := SalesLine."Bin Code";
          UpdateReceiptLine(WhseReceiptLine,WhseReceiptHeader);
          CreateReceiptLine(WhseReceiptLine);
          exit(not HasErrorOccured);
        end;
    end;


    procedure FromServiceLine2ShptLine(WhseShptHeader: Record "Warehouse Shipment Header";ServiceLine: Record "Service Line"): Boolean
    var
        WhseShptLine: Record "Warehouse Shipment Line";
        ServiceHeader: Record "Service Header";
    begin
        ServiceHeader.Get(ServiceLine."Document Type",ServiceLine."Document No.");

        with WhseShptLine do begin
          Reset;
          "No." := WhseShptHeader."No.";
          SetRange("No.","No.");
          LockTable;
          if FindLast then;

          Init;
          SetIgnoreErrors;
          "Line No." := "Line No." + 10000;
          "Source Type" := Database::"Service Line";
          "Source Subtype" := ServiceLine."Document Type";
          "Source No." := ServiceLine."Document No.";
          "Source Line No." := ServiceLine."Line No.";
          "Source Document" := WhseMgt.GetSourceDocument("Source Type","Source Subtype");
          "Location Code" := ServiceLine."Location Code";
          "Item No." := ServiceLine."No.";
          "Variant Code" := ServiceLine."Variant Code";
          ServiceLine.TestField("Unit of Measure Code");
          "Unit of Measure Code" := ServiceLine."Unit of Measure Code";
          "Qty. per Unit of Measure" := ServiceLine."Qty. per Unit of Measure";
          Description := ServiceLine.Description;
          "Description 2" := ServiceLine."Description 2";
          SetQtysOnShptLine(WhseShptLine,Abs(ServiceLine."Outstanding Quantity"),Abs(ServiceLine."Outstanding Qty. (Base)"));
          if ServiceLine."Document Type" = ServiceLine."document type"::Order then
            "Due Date" := ServiceLine.GetDueDate;
          if WhseShptHeader."Shipment Date" = 0D then
            "Shipment Date" := ServiceLine.GetShipmentDate
          else
            "Shipment Date" := WhseShptHeader."Shipment Date";
          "Destination Type" := "destination type"::Customer;
          "Destination No." := ServiceLine."Bill-to Customer No.";
          "Shipping Advice" := ServiceHeader."Shipping Advice";
          if "Location Code" = WhseShptHeader."Location Code" then
            "Bin Code" := WhseShptHeader."Bin Code";
          if "Bin Code" = '' then
            "Bin Code" := ServiceLine."Bin Code";
          UpdateShptLine(WhseShptLine,WhseShptHeader);
          CreateShptLine(WhseShptLine);
          exit(not HasErrorOccured);
        end;
    end;


    procedure FromPurchLine2ShptLine(WhseShptHeader: Record "Warehouse Shipment Header";PurchLine: Record "Purchase Line"): Boolean
    var
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        with WhseShptLine do begin
          Reset;
          "No." := WhseShptHeader."No.";
          SetRange("No.","No.");
          LockTable;
          if FindLast then;

          Init;
          SetIgnoreErrors;
          "Line No." := "Line No." + 10000;
          "Source Type" := Database::"Purchase Line";
          "Source Subtype" := PurchLine."Document Type";
          "Source No." := PurchLine."Document No.";
          "Source Line No." := PurchLine."Line No.";
          "Source Document" := WhseMgt.GetSourceDocument("Source Type","Source Subtype");
          "Location Code" := PurchLine."Location Code";
          "Item No." := PurchLine."No.";
          "Variant Code" := PurchLine."Variant Code";
          PurchLine.TestField("Unit of Measure Code");
          "Unit of Measure Code" := PurchLine."Unit of Measure Code";
          "Qty. per Unit of Measure" := PurchLine."Qty. per Unit of Measure";
          Description := PurchLine.Description;
          "Description 2" := PurchLine."Description 2";
          SetQtysOnShptLine(WhseShptLine,Abs(PurchLine."Outstanding Quantity"),Abs(PurchLine."Outstanding Qty. (Base)"));
          if PurchLine."Document Type" = PurchLine."document type"::Order then
            "Due Date" := PurchLine."Expected Receipt Date";
          if PurchLine."Document Type" = PurchLine."document type"::"Return Order" then
            "Due Date" := WorkDate;
          if WhseShptHeader."Shipment Date" = 0D then
            "Shipment Date" := PurchLine."Planned Receipt Date"
          else
            "Shipment Date" := WhseShptHeader."Shipment Date";
          "Destination Type" := "destination type"::Vendor;
          "Destination No." := PurchLine."Buy-from Vendor No.";
          if "Location Code" = WhseShptHeader."Location Code" then
            "Bin Code" := WhseShptHeader."Bin Code";
          if "Bin Code" = '' then
            "Bin Code" := PurchLine."Bin Code";
          UpdateShptLine(WhseShptLine,WhseShptHeader);
          CreateShptLine(WhseShptLine);
          exit(not HasErrorOccured);
        end;
    end;


    procedure PurchLine2ReceiptLine(WhseReceiptHeader: Record "Warehouse Receipt Header";PurchLine: Record "Purchase Line"): Boolean
    var
        WhseReceiptLine: Record "Warehouse Receipt Line";
    begin
        with WhseReceiptLine do begin
          Reset;
          "No." := WhseReceiptHeader."No.";
          SetRange("No.","No.");
          LockTable;
          if FindLast then;

          Init;
          SetIgnoreErrors;
          "Line No." := "Line No." + 10000;
          "Source Type" := Database::"Purchase Line";
          "Source Subtype" := PurchLine."Document Type";
          "Source No." := PurchLine."Document No.";
          "Source Line No." := PurchLine."Line No.";
          "Source Document" := WhseMgt.GetSourceDocument("Source Type","Source Subtype");
          "Location Code" := PurchLine."Location Code";
          "Item No." := PurchLine."No.";
          "Variant Code" := PurchLine."Variant Code";
          PurchLine.TestField("Unit of Measure Code");
          "Unit of Measure Code" := PurchLine."Unit of Measure Code";
          "Qty. per Unit of Measure" := PurchLine."Qty. per Unit of Measure";
          Description := PurchLine.Description;
          "Description 2" := PurchLine."Description 2";
          case PurchLine."Document Type" of
            PurchLine."document type"::Order:
              begin
                Validate("Qty. Received",Abs(PurchLine."Quantity Received"));
                "Due Date" := PurchLine."Expected Receipt Date";
              end;
            PurchLine."document type"::"Return Order":
              begin
                Validate("Qty. Received",Abs(PurchLine."Return Qty. Shipped"));
                "Due Date" := WorkDate;
              end;
          end;
          SetQtysOnRcptLine(WhseReceiptLine,Abs(PurchLine.Quantity),Abs(PurchLine."Quantity (Base)"));
          "Starting Date" := PurchLine."Planned Receipt Date";
          if "Location Code" = WhseReceiptHeader."Location Code" then
            "Bin Code" := WhseReceiptHeader."Bin Code";
          if "Bin Code" = '' then
            "Bin Code" := PurchLine."Bin Code";
          UpdateReceiptLine(WhseReceiptLine,WhseReceiptHeader);
          CreateReceiptLine(WhseReceiptLine);
          exit(not HasErrorOccured);
        end;
    end;


    procedure FromTransLine2ShptLine(WhseShptHeader: Record "Warehouse Shipment Header";TransLine: Record "Transfer Line"): Boolean
    var
        WhseShptLine: Record "Warehouse Shipment Line";
        TransHeader: Record "Transfer Header";
    begin
        with WhseShptLine do begin
          Reset;
          "No." := WhseShptHeader."No.";
          SetRange("No.","No.");
          LockTable;
          if FindLast then;

          Init;
          SetIgnoreErrors;
          "Line No." := "Line No." + 10000;
          "Source Type" := Database::"Transfer Line";
          "Source No." := TransLine."Document No.";
          "Source Line No." := TransLine."Line No.";
          "Source Subtype" := 0;
          "Source Document" := WhseMgt.GetSourceDocument("Source Type","Source Subtype");
          "Item No." := TransLine."Item No.";
          "Variant Code" := TransLine."Variant Code";
          TransLine.TestField("Unit of Measure Code");
          "Unit of Measure Code" := TransLine."Unit of Measure Code";
          "Qty. per Unit of Measure" := TransLine."Qty. per Unit of Measure";
          Description := TransLine.Description;
          "Description 2" := TransLine."Description 2";
          "Location Code" := TransLine."Transfer-from Code";
          SetQtysOnShptLine(WhseShptLine,TransLine."Outstanding Quantity",TransLine."Outstanding Qty. (Base)");
          "Due Date" := TransLine."Shipment Date";
          if WhseShptHeader."Shipment Date" = 0D then
            "Shipment Date" := WorkDate
          else
            "Shipment Date" := WhseShptHeader."Shipment Date";
          "Destination Type" := "destination type"::Location;
          "Destination No." := TransLine."Transfer-to Code";
          if TransHeader.Get(TransLine."Document No.") then
            "Shipping Advice" := TransHeader."Shipping Advice";
          if "Location Code" = WhseShptHeader."Location Code" then
            "Bin Code" := WhseShptHeader."Bin Code";
          if "Bin Code" = '' then
            "Bin Code" := TransLine."Transfer-from Bin Code";
          UpdateShptLine(WhseShptLine,WhseShptHeader);
          CreateShptLine(WhseShptLine);
          exit(not HasErrorOccured);
        end;
    end;


    procedure TransLine2ReceiptLine(WhseReceiptHeader: Record "Warehouse Receipt Header";TransLine: Record "Transfer Line"): Boolean
    var
        WhseReceiptLine: Record "Warehouse Receipt Line";
    begin
        with WhseReceiptLine do begin
          Reset;
          "No." := WhseReceiptHeader."No.";
          SetRange("No.","No.");
          LockTable;
          if FindLast then;

          Init;
          SetIgnoreErrors;
          "Line No." := "Line No." + 10000;
          "Source Type" := Database::"Transfer Line";
          "Source No." := TransLine."Document No.";
          "Source Line No." := TransLine."Line No.";
          "Source Subtype" := 1;
          "Source Document" := WhseMgt.GetSourceDocument("Source Type","Source Subtype");
          "Item No." := TransLine."Item No.";
          "Variant Code" := TransLine."Variant Code";
          TransLine.TestField("Unit of Measure Code");
          "Unit of Measure Code" := TransLine."Unit of Measure Code";
          "Qty. per Unit of Measure" := TransLine."Qty. per Unit of Measure";
          Description := TransLine.Description;
          "Description 2" := TransLine."Description 2";
          "Location Code" := TransLine."Transfer-to Code";
          Validate("Qty. Received",TransLine."Quantity Received");
          SetQtysOnRcptLine(WhseReceiptLine,TransLine."Quantity Received" + TransLine."Qty. in Transit",
            TransLine."Qty. Received (Base)" + TransLine."Qty. in Transit (Base)");
          "Due Date" := TransLine."Receipt Date";
          "Starting Date" := WorkDate;
          if "Location Code" = WhseReceiptHeader."Location Code" then
            "Bin Code" := WhseReceiptHeader."Bin Code";
          if "Bin Code" = '' then
            "Bin Code" := TransLine."Transfer-To Bin Code";
          UpdateReceiptLine(WhseReceiptLine,WhseReceiptHeader);
          CreateReceiptLine(WhseReceiptLine);
          exit(not HasErrorOccured);
        end;
    end;

    local procedure CreateShptLine(var WhseShptLine: Record "Warehouse Shipment Line")
    var
        Item: Record Item;
    begin
        with WhseShptLine do begin
          Item."No." := "Item No.";
          Item.ItemSKUGet(Item,"Location Code","Variant Code");
          "Shelf No." := Item."Shelf No.";
          Insert;
          CreateWhseItemTrackingLines;
        end;
    end;

    local procedure SetQtysOnShptLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line";Qty: Decimal;QtyBase: Decimal)
    var
        Location: Record Location;
    begin
        with WarehouseShipmentLine do begin
          Quantity := Qty;
          "Qty. (Base)" := QtyBase;
          InitOutstandingQtys;
          CheckSourceDocLineQty;
          if Location.Get("Location Code") then
            if Location."Directed Put-away and Pick" then
              CheckBin(0,0);
        end;
    end;

    local procedure CreateReceiptLine(var WhseReceiptLine: Record "Warehouse Receipt Line")
    var
        Item: Record Item;
    begin
        with WhseReceiptLine do begin
          Item."No." := "Item No.";
          Item.ItemSKUGet(Item,"Location Code","Variant Code");
          "Shelf No." := Item."Shelf No.";
          Status := GetLineStatus;
          Insert;
        end;
    end;

    local procedure SetQtysOnRcptLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line";Qty: Decimal;QtyBase: Decimal)
    begin
        with WarehouseReceiptLine do begin
          Quantity := Qty;
          "Qty. (Base)" := QtyBase;
          InitOutstandingQtys;
        end;
    end;

    local procedure UpdateShptLine(var WhseShptLine: Record "Warehouse Shipment Line";WhseShptHeader: Record "Warehouse Shipment Header")
    begin
        with WhseShptLine do begin
          if WhseShptHeader."Zone Code" <> '' then
            Validate("Zone Code",WhseShptHeader."Zone Code");
          if WhseShptHeader."Bin Code" <> '' then
            Validate("Bin Code",WhseShptHeader."Bin Code");
        end;
    end;

    local procedure UpdateReceiptLine(var WhseReceiptLine: Record "Warehouse Receipt Line";WhseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        with WhseReceiptLine do begin
          if WhseReceiptHeader."Zone Code" <> '' then
            Validate("Zone Code",WhseReceiptHeader."Zone Code");
          if WhseReceiptHeader."Bin Code" <> '' then
            Validate("Bin Code",WhseReceiptHeader."Bin Code");
          if WhseReceiptHeader."Cross-Dock Zone Code" <> '' then
            Validate("Cross-Dock Zone Code",WhseReceiptHeader."Cross-Dock Zone Code");
          if WhseReceiptHeader."Cross-Dock Bin Code" <> '' then
            Validate("Cross-Dock Bin Code",WhseReceiptHeader."Cross-Dock Bin Code");
        end;
    end;


    procedure CheckIfFromSalesLine2ShptLine(SalesLine: Record "Sales Line"): Boolean
    begin
        SalesLine.CalcFields("Whse. Outstanding Qty. (Base)");
        if Abs(SalesLine."Outstanding Qty. (Base)") <= Abs(SalesLine."Whse. Outstanding Qty. (Base)") then
          exit;
        exit(true);
    end;


    procedure CheckIfFromServiceLine2ShptLin(ServiceLine: Record "Service Line"): Boolean
    begin
        ServiceLine.CalcFields("Whse. Outstanding Qty. (Base)");
        exit(
          (Abs(ServiceLine."Outstanding Qty. (Base)") > Abs(ServiceLine."Whse. Outstanding Qty. (Base)")) and
          (ServiceLine."Qty. to Consume (Base)" = 0));
    end;


    procedure CheckIfSalesLine2ReceiptLine(SalesLine: Record "Sales Line"): Boolean
    var
        WhseReceiptLine: Record "Warehouse Receipt Line";
    begin
        with WhseReceiptLine do begin
          SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          SetRange("Source Type",Database::"Sales Line");
          SetRange("Source Subtype",SalesLine."Document Type");
          SetRange("Source No.",SalesLine."Document No.");
          SetRange("Source Line No.",SalesLine."Line No.");
          CalcSums("Qty. Outstanding (Base)");
          if Abs(SalesLine."Outstanding Qty. (Base)") <= Abs("Qty. Outstanding (Base)") then
            exit;
          exit(true);
        end;
    end;


    procedure CheckIfFromPurchLine2ShptLine(PurchLine: Record "Purchase Line"): Boolean
    var
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        with WhseShptLine do begin
          SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.");
          SetRange("Source Type",Database::"Purchase Line");
          SetRange("Source Subtype",PurchLine."Document Type");
          SetRange("Source No.",PurchLine."Document No.");
          SetRange("Source Line No.",PurchLine."Line No.");
          CalcSums("Qty. Outstanding (Base)");
          if Abs(PurchLine."Outstanding Qty. (Base)") <= "Qty. Outstanding (Base)" then
            exit;
          exit(true);
        end;
    end;


    procedure CheckIfPurchLine2ReceiptLine(PurchLine: Record "Purchase Line"): Boolean
    begin
        PurchLine.CalcFields("Whse. Outstanding Qty. (Base)");
        if Abs(PurchLine."Outstanding Qty. (Base)") <= Abs(PurchLine."Whse. Outstanding Qty. (Base)") then
          exit;
        exit(true);
    end;


    procedure CheckIfFromTransLine2ShptLine(TransLine: Record "Transfer Line"): Boolean
    var
        Location: Record Location;
    begin
        TransLine.CalcFields("Whse Outbnd. Otsdg. Qty (Base)");

        if Location.GetLocationSetup(TransLine."Transfer-from Code",Location) then
          if Location."Use As In-Transit" then
            exit;
        if TransLine."Outstanding Qty. (Base)" <= TransLine."Whse Outbnd. Otsdg. Qty (Base)" then
          exit;
        exit(true);
    end;


    procedure CheckIfTransLine2ReceiptLine(TransLine: Record "Transfer Line"): Boolean
    var
        Location: Record Location;
    begin
        TransLine.CalcFields("Whse. Inbnd. Otsdg. Qty (Base)");

        if Location.GetLocationSetup(TransLine."Transfer-to Code",Location) then
          if Location."Use As In-Transit" then
            exit;
        if TransLine."Qty. in Transit (Base)" <= TransLine."Whse. Inbnd. Otsdg. Qty (Base)" then
          exit;

        exit(true);
    end;
}

