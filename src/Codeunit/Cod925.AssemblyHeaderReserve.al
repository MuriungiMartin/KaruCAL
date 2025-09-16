#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 925 "Assembly Header-Reserve"
{
    Permissions = TableData "Reservation Entry"=rimd;

    trigger OnRun()
    begin
    end;

    var
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservMgt: Codeunit "Reservation Management";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        SetFromType: Integer;
        SetFromSubtype: Integer;
        SetFromID: Code[20];
        SetFromBatchName: Code[10];
        SetFromProdOrderLine: Integer;
        SetFromRefNo: Integer;
        SetFromVariantCode: Code[10];
        SetFromLocationCode: Code[10];
        SetFromSerialNo: Code[20];
        SetFromLotNo: Code[20];
        SetFromQtyPerUOM: Decimal;
        Text000: label 'Reserved quantity cannot be greater than %1.';
        Text001: label 'Codeunit is not initialized correctly.';
        DeleteItemTracking: Boolean;
        Text002: label 'must be filled in when a quantity is reserved', Comment='starts with "Due Date"';
        Text003: label 'must not be changed when a quantity is reserved', Comment='starts with some field name';


    procedure CreateReservation(var AssemblyHeader: Record "Assembly Header";Description: Text[50];ExpectedReceiptDate: Date;Quantity: Decimal;QuantityBase: Decimal;ForSerialNo: Code[20];ForLotNo: Code[20])
    var
        ShipmentDate: Date;
    begin
        if SetFromType = 0 then
          Error(Text001);

        AssemblyHeader.TestField("Item No.");
        AssemblyHeader.TestField("Due Date");

        AssemblyHeader.CalcFields("Reserved Qty. (Base)");
        if Abs(AssemblyHeader."Remaining Quantity (Base)") < Abs(AssemblyHeader."Reserved Qty. (Base)") + QuantityBase then
          Error(
            Text000,
            Abs(AssemblyHeader."Remaining Quantity (Base)") - Abs(AssemblyHeader."Reserved Qty. (Base)"));

        AssemblyHeader.TestField("Variant Code",SetFromVariantCode);
        AssemblyHeader.TestField("Location Code",SetFromLocationCode);

        if QuantityBase * SignFactor(AssemblyHeader) < 0 then
          ShipmentDate := AssemblyHeader."Due Date"
        else begin
          ShipmentDate := ExpectedReceiptDate;
          ExpectedReceiptDate := AssemblyHeader."Due Date";
        end;

        if AssemblyHeader."Planning Flexibility" <> AssemblyHeader."planning flexibility"::Unlimited then
          CreateReservEntry.SetPlanningFlexibility(AssemblyHeader."Planning Flexibility");

        CreateReservEntry.CreateReservEntryFor(
          Database::"Assembly Header",AssemblyHeader."Document Type",
          AssemblyHeader."No.",'',0,0,AssemblyHeader."Qty. per Unit of Measure",
          Quantity,QuantityBase,ForSerialNo,ForLotNo);
        CreateReservEntry.CreateReservEntryFrom(
          SetFromType,SetFromSubtype,SetFromID,SetFromBatchName,SetFromProdOrderLine,SetFromRefNo,
          SetFromQtyPerUOM,SetFromSerialNo,SetFromLotNo);
        CreateReservEntry.CreateReservEntry(
          AssemblyHeader."Item No.",AssemblyHeader."Variant Code",AssemblyHeader."Location Code",
          Description,ExpectedReceiptDate,ShipmentDate);

        SetFromType := 0;
    end;


    procedure CreateReservationSetFrom(TrackingSpecificationFrom: Record "Tracking Specification")
    begin
        with TrackingSpecificationFrom do begin
          SetFromType := "Source Type";
          SetFromSubtype := "Source Subtype";
          SetFromID := "Source ID";
          SetFromBatchName := "Source Batch Name";
          SetFromProdOrderLine := "Source Prod. Order Line";
          SetFromRefNo := "Source Ref. No.";
          SetFromVariantCode := "Variant Code";
          SetFromLocationCode := "Location Code";
          SetFromSerialNo := "Serial No.";
          SetFromLotNo := "Lot No.";
          SetFromQtyPerUOM := "Qty. per Unit of Measure";
        end;
    end;

    local procedure SignFactor(AssemblyHeader: Record "Assembly Header"): Integer
    begin
        if AssemblyHeader."Document Type" in [2,3,5] then
          Error(Text001);

        exit(1);
    end;


    procedure SetBinding(Binding: Option " ","Order-to-Order")
    begin
        CreateReservEntry.SetBinding(Binding);
    end;


    procedure SetDisallowCancellation(DisallowCancellation: Boolean)
    begin
        CreateReservEntry.SetDisallowCancellation(DisallowCancellation);
    end;


    procedure FilterReservFor(var FilterReservEntry: Record "Reservation Entry";AssemblyHeader: Record "Assembly Header")
    begin
        FilterReservEntry.SetRange("Source Type",Database::"Assembly Header");
        FilterReservEntry.SetRange("Source Subtype",AssemblyHeader."Document Type");
        FilterReservEntry.SetRange("Source ID",AssemblyHeader."No.");
        FilterReservEntry.SetRange("Source Batch Name",'');
        FilterReservEntry.SetRange("Source Prod. Order Line",0);
        FilterReservEntry.SetRange("Source Ref. No.",0);
    end;


    procedure FindReservEntry(AssemblyHeader: Record "Assembly Header";var ReservEntry: Record "Reservation Entry"): Boolean
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,false);
        FilterReservFor(ReservEntry,AssemblyHeader);
        exit(ReservEntry.FindLast);
    end;

    local procedure AssignForPlanning(var AssemblyHeader: Record "Assembly Header")
    var
        PlanningAssignment: Record "Planning Assignment";
    begin
        with AssemblyHeader do begin
          if "Document Type" <> "document type"::Order then
            exit;

          if "Item No." <> '' then
            PlanningAssignment.ChkAssignOne("Item No.","Variant Code","Location Code",WorkDate);
        end;
    end;


    procedure UpdatePlanningFlexibility(var AssemblyHeader: Record "Assembly Header")
    var
        ReservEntry: Record "Reservation Entry";
    begin
        if FindReservEntry(AssemblyHeader,ReservEntry) then
          ReservEntry.ModifyAll("Planning Flexibility",AssemblyHeader."Planning Flexibility");
    end;


    procedure ReservEntryExist(AssemblyHeader: Record "Assembly Header"): Boolean
    var
        ReservEntry: Record "Reservation Entry";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,false);
        FilterReservFor(ReservEntry,AssemblyHeader);
        exit(not ReservEntry.IsEmpty);
    end;


    procedure DeleteLine(var AssemblyHeader: Record "Assembly Header")
    begin
        with AssemblyHeader do begin
          ReservMgt.SetAssemblyHeader(AssemblyHeader);
          if DeleteItemTracking then
            ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
          ReservMgt.DeleteReservEntries(true,0);
          ReservMgt.ClearActionMessageReferences;
          CalcFields("Reserved Qty. (Base)");
          AssignForPlanning(AssemblyHeader);
        end;
    end;


    procedure VerifyChange(var NewAssemblyHeader: Record "Assembly Header";var OldAssemblyHeader: Record "Assembly Header")
    var
        ReservEntry: Record "Reservation Entry";
        ShowError: Boolean;
        HasError: Boolean;
    begin
        NewAssemblyHeader.CalcFields("Reserved Qty. (Base)");
        ShowError := NewAssemblyHeader."Reserved Qty. (Base)" <> 0;

        if NewAssemblyHeader."Due Date" = 0D then begin
          if ShowError then
            NewAssemblyHeader.FieldError("Due Date",Text002);
          HasError := true;
        end;

        if NewAssemblyHeader."Item No." <> OldAssemblyHeader."Item No." then begin
          if ShowError then
            NewAssemblyHeader.FieldError("Item No.",Text003);
          HasError := true;
        end;

        if NewAssemblyHeader."Location Code" <> OldAssemblyHeader."Location Code" then begin
          if ShowError then
            NewAssemblyHeader.FieldError("Location Code",Text003);
          HasError := true;
        end;

        if NewAssemblyHeader."Variant Code" <> OldAssemblyHeader."Variant Code" then begin
          if ShowError then
            NewAssemblyHeader.FieldError("Variant Code",Text003);
          HasError := true;
        end;

        if HasError then
          if (NewAssemblyHeader."Item No." <> OldAssemblyHeader."Item No.") or
             FindReservEntry(NewAssemblyHeader,ReservEntry)
          then begin
            if NewAssemblyHeader."Item No." <> OldAssemblyHeader."Item No." then begin
              ReservMgt.SetAssemblyHeader(OldAssemblyHeader);
              ReservMgt.DeleteReservEntries(true,0);
              ReservMgt.SetAssemblyHeader(NewAssemblyHeader);
            end else begin
              ReservMgt.SetAssemblyHeader(NewAssemblyHeader);
              ReservMgt.DeleteReservEntries(true,0);
            end;
            ReservMgt.AutoTrack(NewAssemblyHeader."Remaining Quantity (Base)");
          end;

        if HasError or (NewAssemblyHeader."Due Date" <> OldAssemblyHeader."Due Date") then begin
          AssignForPlanning(NewAssemblyHeader);
          if (NewAssemblyHeader."Item No." <> OldAssemblyHeader."Item No.") or
             (NewAssemblyHeader."Variant Code" <> OldAssemblyHeader."Variant Code") or
             (NewAssemblyHeader."Location Code" <> OldAssemblyHeader."Location Code")
          then
            AssignForPlanning(OldAssemblyHeader);
        end;
    end;


    procedure VerifyQuantity(var NewAssemblyHeader: Record "Assembly Header";var OldAssemblyHeader: Record "Assembly Header")
    begin
        with NewAssemblyHeader do begin
          if "Quantity (Base)" = OldAssemblyHeader."Quantity (Base)" then
            exit;

          ReservMgt.SetAssemblyHeader(NewAssemblyHeader);
          if "Qty. per Unit of Measure" <> OldAssemblyHeader."Qty. per Unit of Measure" then
            ReservMgt.ModifyUnitOfMeasure;
          ReservMgt.DeleteReservEntries(false,"Remaining Quantity (Base)");
          ReservMgt.ClearSurplus;
          ReservMgt.AutoTrack("Remaining Quantity (Base)");
          AssignForPlanning(NewAssemblyHeader);
        end;
    end;


    procedure Caption(AssemblyHeader: Record "Assembly Header") CaptionText: Text[80]
    begin
        CaptionText :=
          StrSubstNo('%1 %2',AssemblyHeader."Document Type",AssemblyHeader."No.");
    end;


    procedure CallItemTracking(var AssemblyHeader: Record "Assembly Header")
    var
        TrackingSpecification: Record "Tracking Specification";
        ItemTrackingLines: Page "Item Tracking Lines";
    begin
        TrackingSpecification.InitFromAsmHeader(AssemblyHeader);
        ItemTrackingLines.SetSourceSpec(TrackingSpecification,AssemblyHeader."Due Date");
        ItemTrackingLines.SetInbound(AssemblyHeader.IsInbound);
        ItemTrackingLines.RunModal;
    end;


    procedure DeleteLineConfirm(var AssemblyHeader: Record "Assembly Header"): Boolean
    begin
        with AssemblyHeader do begin
          if not ReservEntryExist(AssemblyHeader) then
            exit(true);

          ReservMgt.SetAssemblyHeader(AssemblyHeader);
          if ReservMgt.DeleteItemTrackingConfirm then
            DeleteItemTracking := true;
        end;

        exit(DeleteItemTracking);
    end;


    procedure UpdateItemTrackingAfterPosting(AssemblyHeader: Record "Assembly Header")
    var
        ReservEntry: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
    begin
        // Used for updating Quantity to Handle and Quantity to Invoice after posting
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,false);
        ReservEntry.SetRange("Source Type",Database::"Assembly Header");
        ReservEntry.SetRange("Source Subtype",AssemblyHeader."Document Type");
        ReservEntry.SetRange("Source ID",AssemblyHeader."No.");
        ReservEntry.SetRange("Source Batch Name",'');
        ReservEntry.SetRange("Source Prod. Order Line",0);
        CreateReservEntry.UpdateItemTrackingAfterPosting(ReservEntry);
    end;


    procedure TransferAsmHeaderToItemJnlLine(var AssemblyHeader: Record "Assembly Header";var ItemJnlLine: Record "Item Journal Line";TransferQty: Decimal;CheckApplToItemEntry: Boolean): Decimal
    var
        OldReservEntry: Record "Reservation Entry";
        OldReservEntry2: Record "Reservation Entry";
    begin
        if TransferQty = 0 then
          exit;
        if not FindReservEntry(AssemblyHeader,OldReservEntry) then
          exit(TransferQty);

        ItemJnlLine.TestField("Item No.",AssemblyHeader."Item No.");
        ItemJnlLine.TestField("Variant Code",AssemblyHeader."Variant Code");
        ItemJnlLine.TestField("Location Code",AssemblyHeader."Location Code");

        OldReservEntry.Lock;

        if ReservEngineMgt.InitRecordSet(OldReservEntry) then begin
          repeat
            OldReservEntry.TestField("Item No.",AssemblyHeader."Item No.");
            OldReservEntry.TestField("Variant Code",AssemblyHeader."Variant Code");
            OldReservEntry.TestField("Location Code",AssemblyHeader."Location Code");
            if CheckApplToItemEntry and
               (OldReservEntry."Reservation Status" = OldReservEntry."reservation status"::Reservation)
            then begin
              OldReservEntry2.Get(OldReservEntry."Entry No.",not OldReservEntry.Positive);
              OldReservEntry2.TestField("Source Type",Database::"Item Ledger Entry");
            end;

            TransferQty := CreateReservEntry.TransferReservEntry(Database::"Item Journal Line",
                ItemJnlLine."Entry Type",ItemJnlLine."Journal Template Name",
                ItemJnlLine."Journal Batch Name",0,ItemJnlLine."Line No.",
                ItemJnlLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);

          until (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0) or (TransferQty = 0);
          CheckApplToItemEntry := false;
        end;
        exit(TransferQty);
    end;
}

