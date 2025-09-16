#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6501 "Item Tracking Data Collection"
{
    Permissions = TableData "Item Entry Relation"=rd,
                  TableData "Value Entry Relation"=rd;

    trigger OnRun()
    begin
    end;

    var
        Text004: label 'Counting records...';
        TempGlobalReservEntry: Record "Reservation Entry" temporary;
        TempGlobalAdjustEntry: Record "Reservation Entry" temporary;
        TempGlobalEntrySummary: Record "Entry Summary" temporary;
        TempGlobalChangedEntrySummary: Record "Entry Summary" temporary;
        CurrItemTrackingCode: Record "Item Tracking Code";
        TempGlobalEntrySummaryFEFO: Record "Entry Summary" temporary;
        TempGlobalTrackingSpec: Record "Tracking Specification" temporary;
        SourceReservationEntry: Record "Reservation Entry";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        CurrBinCode: Code[20];
        LastSummaryEntryNo: Integer;
        LastReservEntryNo: Integer;
        FullGlobalDataSetExists: Boolean;
        Text006: label 'The data used for availability calculation has been updated.\';
        Text007: label 'There are availability warnings on one or more lines.';
        Text008: label 'There are no availability warnings.';
        Text009: label '%1 List';
        Text010: label '%1 %2 - Availability';
        Text011: label 'Item Tracking - Select Entries';
        PartialGlobalDataSetExists: Boolean;
        StrictExpirationPosting: Boolean;
        HasExpiredItems: Boolean;
        Text012: label '\\Some items were not included in the pick due to their expiration date.';
        SkipLot: Boolean;
        Text013: label 'Neutralize consumption/output';
        SourceSet: Boolean;


    procedure AssistEditLotSerialNo(var TrackingSpecification: Record "Tracking Specification" temporary;SearchForSupply: Boolean;CurrentSignFactor: Integer;LookupMode: Option "Serial No.","Lot No.";MaxQuantity: Decimal)
    var
        ItemTrackingSummaryForm: Page "Item Tracking Summary";
        Window: Dialog;
        AvailableQty: Decimal;
        AdjustmentQty: Decimal;
        QtyOnLine: Decimal;
        QtyHandledOnLine: Decimal;
        NewQtyOnLine: Decimal;
    begin
        Window.Open(Text004);

        if not FullGlobalDataSetExists then
          RetrieveLookupData(TrackingSpecification,true);

        TempGlobalReservEntry.Reset;
        TempGlobalEntrySummary.Reset;

        // Select the proper key on form
        TempGlobalEntrySummary.SetCurrentkey("Expiration Date");
        TempGlobalEntrySummary.SetFilter("Expiration Date",'<>%1',0D);
        if TempGlobalEntrySummary.IsEmpty then
          TempGlobalEntrySummary.SetCurrentkey("Lot No.","Serial No.");
        TempGlobalEntrySummary.SetRange("Expiration Date");
        ItemTrackingSummaryForm.SetTableview(TempGlobalEntrySummary);

        TempGlobalEntrySummary.SetCurrentkey("Lot No.","Serial No.");
        case LookupMode of
          Lookupmode::"Serial No.":
            begin
              if TrackingSpecification."Lot No." <> '' then
                TempGlobalEntrySummary.SetRange("Lot No.",TrackingSpecification."Lot No.");
              TempGlobalEntrySummary.SetRange("Serial No.",TrackingSpecification."Serial No.");
              if TempGlobalEntrySummary.FindFirst then
                ItemTrackingSummaryForm.SetRecord(TempGlobalEntrySummary);
              TempGlobalEntrySummary.SetFilter("Serial No.",'<>%1','');
              TempGlobalEntrySummary.SetFilter("Table ID",'<>%1',0);
              ItemTrackingSummaryForm.Caption := StrSubstNo(Text009,TempGlobalReservEntry.FieldCaption("Serial No."));
            end;
          Lookupmode::"Lot No.":
            begin
              if TrackingSpecification."Serial No." <> '' then
                TempGlobalEntrySummary.SetRange("Serial No.",TrackingSpecification."Serial No.")
              else
                TempGlobalEntrySummary.SetRange("Serial No.",'');
              TempGlobalEntrySummary.SetRange("Lot No.",TrackingSpecification."Lot No.");
              if TempGlobalEntrySummary.FindFirst then
                ItemTrackingSummaryForm.SetRecord(TempGlobalEntrySummary);
              TempGlobalEntrySummary.SetFilter("Lot No.",'<>%1','');
              ItemTrackingSummaryForm.Caption := StrSubstNo(Text009,TempGlobalEntrySummary.FieldCaption("Lot No."));
            end;
        end;

        ItemTrackingSummaryForm.SetCurrentBinAndItemTrkgCode(CurrBinCode,CurrItemTrackingCode);
        ItemTrackingSummaryForm.SetSources(TempGlobalReservEntry,TempGlobalEntrySummary);
        ItemTrackingSummaryForm.LookupMode(SearchForSupply);
        ItemTrackingSummaryForm.SetSelectionMode(false);

        Window.Close;
        if ItemTrackingSummaryForm.RunModal = Action::LookupOK then begin
          ItemTrackingSummaryForm.GetRecord(TempGlobalEntrySummary);

          if TempGlobalEntrySummary."Bin Active" then
            AvailableQty := MinValueAbs(TempGlobalEntrySummary."Bin Content",TempGlobalEntrySummary."Total Available Quantity")
          else
            AvailableQty := TempGlobalEntrySummary."Total Available Quantity";
          QtyHandledOnLine := TrackingSpecification."Quantity Handled (Base)";
          QtyOnLine := TrackingSpecification."Quantity (Base)" - QtyHandledOnLine;

          if CurrentSignFactor > 0 then begin
            AvailableQty := -AvailableQty;
            QtyHandledOnLine := -QtyHandledOnLine;
            QtyOnLine := -QtyOnLine;
          end;

          if MaxQuantity < 0 then begin
            AdjustmentQty := MaxQuantity;
            if AvailableQty < 0 then
              if AdjustmentQty > AvailableQty then
                AdjustmentQty := AvailableQty;
            if QtyOnLine + AdjustmentQty < 0 then
              AdjustmentQty := -QtyOnLine;
          end else begin
            AdjustmentQty := AvailableQty;
            if AvailableQty < 0 then begin
              if QtyOnLine + AdjustmentQty < 0 then
                AdjustmentQty := -QtyOnLine;
            end else
              AdjustmentQty := MinValueAbs(MaxQuantity,AvailableQty);
          end;
          if LookupMode = Lookupmode::"Serial No." then
            TrackingSpecification.Validate("Serial No.",TempGlobalEntrySummary."Serial No.");
          TrackingSpecification.Validate("Lot No.",TempGlobalEntrySummary."Lot No.");

          TransferExpDateFromSummary(TrackingSpecification,TempGlobalEntrySummary);
          if TrackingSpecification.IsReclass then
            begin
            TrackingSpecification."New Serial No." := TrackingSpecification."Serial No.";
            TrackingSpecification."New Lot No." := TrackingSpecification."Lot No.";
          end;

          NewQtyOnLine := QtyOnLine + AdjustmentQty + QtyHandledOnLine;
          if TrackingSpecification."Serial No." <> '' then
            if Abs(NewQtyOnLine) > 1 then
              NewQtyOnLine := NewQtyOnLine / Abs(NewQtyOnLine); // Set to a signed value of 1.

          TrackingSpecification.Validate("Quantity (Base)",NewQtyOnLine);
        end;
    end;


    procedure SelectMultipleLotSerialNo(var TrackingSpecification: Record "Tracking Specification" temporary;MaxQuantity: Decimal;CurrentSignFactor: Integer)
    var
        TempEntrySummary: Record "Entry Summary" temporary;
        ItemTrackingSummaryForm: Page "Item Tracking Summary";
        Window: Dialog;
        LookupMode: Option "Serial No.","Lot No.",All;
    begin
        Clear(ItemTrackingSummaryForm);
        Window.Open(Text004);
        LookupMode := Lookupmode::All;
        if not FullGlobalDataSetExists then
          RetrieveLookupData(TrackingSpecification,true);

        TempGlobalReservEntry.Reset;
        TempGlobalEntrySummary.Reset;

        // Swap sign if negative supply lines
        if CurrentSignFactor > 0 then
          MaxQuantity := -MaxQuantity;

        // Select the proper key
        TempGlobalEntrySummary.SetCurrentkey("Expiration Date");
        TempGlobalEntrySummary.SetFilter("Expiration Date",'<>%1',0D);
        if TempGlobalEntrySummary.IsEmpty then
          TempGlobalEntrySummary.SetCurrentkey("Lot No.","Serial No.");
        TempGlobalEntrySummary.SetRange("Expiration Date");

        // Initialize form
        ItemTrackingSummaryForm.Caption := Text011;
        ItemTrackingSummaryForm.SetTableview(TempGlobalEntrySummary);
        TempGlobalEntrySummary.SetFilter("Table ID",'<>%1',0); // Filter out summations
        ItemTrackingSummaryForm.SetSources(TempGlobalReservEntry,TempGlobalEntrySummary);
        ItemTrackingSummaryForm.SetSelectionMode(true);
        ItemTrackingSummaryForm.LookupMode(true);
        ItemTrackingSummaryForm.SetMaxQuantity(MaxQuantity);
        ItemTrackingSummaryForm.SetCurrentBinAndItemTrkgCode(CurrBinCode,CurrItemTrackingCode);

        // Run preselection on form
        ItemTrackingSummaryForm.AutoSelectLotSerialNo;

        Window.Close;

        if not (ItemTrackingSummaryForm.RunModal = Action::LookupOK) then
          exit;
        ItemTrackingSummaryForm.GetSelected(TempEntrySummary);
        if TempEntrySummary.IsEmpty then
          exit;

        // Swap sign on the selected entries if parent is a negative supply line
        if CurrentSignFactor > 0 then // Negative supply lines
          if TempEntrySummary.Find('-') then
            repeat
              TempEntrySummary."Selected Quantity" := -TempEntrySummary."Selected Quantity";
              TempEntrySummary.Modify;
            until TempEntrySummary.Next = 0;

        // Modify the item tracking lines with the selected quantities
        AddSelectedLotSNToDataSet(TempEntrySummary,TrackingSpecification,CurrentSignFactor);
    end;


    procedure LookupLotSerialNoAvailability(var TrackingSpecification: Record "Tracking Specification" temporary;LookupMode: Option "Serial No.","Lot No.")
    var
        ItemTrackingSummaryForm: Page "Item Tracking Summary";
        Window: Dialog;
    begin
        case LookupMode of
          Lookupmode::"Serial No.":
            if TrackingSpecification."Serial No." = '' then
              exit;
          Lookupmode::"Lot No.":
            if TrackingSpecification."Lot No." = '' then
              exit;
        end;

        Clear(ItemTrackingSummaryForm);
        Window.Open(Text004);
        TempGlobalChangedEntrySummary.Reset;

        if not (PartialGlobalDataSetExists or FullGlobalDataSetExists) then
          RetrieveLookupData(TrackingSpecification,true);

        TempGlobalEntrySummary.Reset;
        TempGlobalEntrySummary.SetCurrentkey("Lot No.","Serial No.");

        TempGlobalReservEntry.Reset;

        case LookupMode of
          Lookupmode::"Serial No.":
            begin
              TempGlobalEntrySummary.SetRange("Serial No.",TrackingSpecification."Serial No.");
              TempGlobalEntrySummary.SetFilter("Table ID",'<>%1',0); // Filter out summations
              TempGlobalReservEntry.SetRange("Serial No.",TrackingSpecification."Serial No.");
              ItemTrackingSummaryForm.Caption := StrSubstNo(
                  Text010,TrackingSpecification.FieldCaption("Serial No."),TrackingSpecification."Serial No.");
            end;
          Lookupmode::"Lot No.":
            begin
              TempGlobalEntrySummary.SetRange("Serial No.",'');
              TempGlobalEntrySummary.SetRange("Lot No.",TrackingSpecification."Lot No.");
              TempGlobalReservEntry.SetRange("Lot No.",TrackingSpecification."Lot No.");
              ItemTrackingSummaryForm.Caption := StrSubstNo(
                  Text010,TrackingSpecification.FieldCaption("Lot No."),TrackingSpecification."Lot No.");
            end;
        end;

        ItemTrackingSummaryForm.SetSources(TempGlobalReservEntry,TempGlobalEntrySummary);
        ItemTrackingSummaryForm.SetCurrentBinAndItemTrkgCode(CurrBinCode,CurrItemTrackingCode);
        ItemTrackingSummaryForm.LookupMode(false);
        ItemTrackingSummaryForm.SetSelectionMode(false);
        Window.Close;
        ItemTrackingSummaryForm.RunModal;
    end;


    procedure RetrieveLookupData(var TrackingSpecification: Record "Tracking Specification" temporary;FullDataSet: Boolean)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ReservEntry: Record "Reservation Entry";
        xTrackingSpecification: Record "Tracking Specification" temporary;
    begin
        LastSummaryEntryNo := 0;
        LastReservEntryNo := 0;
        xTrackingSpecification := TrackingSpecification;
        TempGlobalReservEntry.Reset;
        TempGlobalReservEntry.DeleteAll;
        TempGlobalEntrySummary.Reset;
        TempGlobalEntrySummary.DeleteAll;

        ReservEntry.Reset;
        if ReservEntry.FindLast then
          LastReservEntryNo := ReservEntry."Entry No.";
        ReservEntry.SetCurrentkey(
          "Item No.","Variant Code","Location Code","Item Tracking","Reservation Status","Lot No.","Serial No.");
        ReservEntry.SetRange("Item No.",TrackingSpecification."Item No.");
        ReservEntry.SetRange("Variant Code",TrackingSpecification."Variant Code");
        ReservEntry.SetRange("Location Code",TrackingSpecification."Location Code");
        ReservEntry.SetFilter("Item Tracking",'<>%1',ReservEntry."item tracking"::None);

        ItemLedgEntry.Reset;
        ItemLedgEntry.SetCurrentkey("Item No.",Open,"Variant Code","Location Code","Item Tracking",
          "Lot No.","Serial No.");
        ItemLedgEntry.SetRange("Item No.",TrackingSpecification."Item No.");
        ItemLedgEntry.SetRange("Variant Code",TrackingSpecification."Variant Code");
        ItemLedgEntry.SetRange(Open,true);
        ItemLedgEntry.SetRange("Location Code",TrackingSpecification."Location Code");

        if FullDataSet then begin
          TransferReservEntryToTempRec(ReservEntry,TrackingSpecification);
          TransferItemLedgToTempRec(ItemLedgEntry,TrackingSpecification);
        end else begin
          if TrackingSpecification.Find('-') then
            repeat
              ItemLedgEntry.SetRange("Lot No.",TrackingSpecification."Lot No.");
              ReservEntry.SetRange("Lot No.",TrackingSpecification."Lot No.");
              ItemLedgEntry.SetRange("Serial No.",TrackingSpecification."Serial No.");
              ReservEntry.SetRange("Serial No.",TrackingSpecification."Serial No.");
              TransferReservEntryToTempRec(ReservEntry,TrackingSpecification);
              TransferItemLedgToTempRec(ItemLedgEntry,TrackingSpecification);
            until TrackingSpecification.Next = 0;
        end;

        TempGlobalEntrySummary.Reset;
        UpdateCurrentPendingQty;
        TrackingSpecification := xTrackingSpecification;

        PartialGlobalDataSetExists := true;
        FullGlobalDataSetExists := FullDataSet;
        AdjustForDoubleEntries;
    end;

    local procedure TransferItemLedgToTempRec(var ItemLedgEntry: Record "Item Ledger Entry";var TrackingSpecification: Record "Tracking Specification" temporary)
    begin
        if ItemLedgEntry.FindSet then
          repeat
            if ItemLedgEntry.TrackingExists then begin
              TempGlobalReservEntry.Init;
              TempGlobalReservEntry."Entry No." := -ItemLedgEntry."Entry No.";
              TempGlobalReservEntry."Reservation Status" := TempGlobalReservEntry."reservation status"::Surplus;
              TempGlobalReservEntry.Positive := ItemLedgEntry.Positive;
              TempGlobalReservEntry."Item No." := ItemLedgEntry."Item No.";
              TempGlobalReservEntry."Location Code" := ItemLedgEntry."Location Code";
              TempGlobalReservEntry."Quantity (Base)" := ItemLedgEntry."Remaining Quantity";
              TempGlobalReservEntry."Source Type" := Database::"Item Ledger Entry";
              TempGlobalReservEntry."Source Ref. No." := ItemLedgEntry."Entry No.";
              TempGlobalReservEntry."Serial No." := ItemLedgEntry."Serial No.";
              TempGlobalReservEntry."Lot No." := ItemLedgEntry."Lot No.";
              TempGlobalReservEntry."Variant Code" := ItemLedgEntry."Variant Code";

              if TempGlobalReservEntry.Positive then begin
                TempGlobalReservEntry."Warranty Date" := ItemLedgEntry."Warranty Date";
                TempGlobalReservEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
                TempGlobalReservEntry."Expected Receipt Date" := 0D
              end else
                TempGlobalReservEntry."Shipment Date" := Dmy2date(31,12,9999);

              if TempGlobalReservEntry.Insert then
                CreateEntrySummary(TrackingSpecification,TempGlobalReservEntry);
            end;
          until ItemLedgEntry.Next = 0;
    end;

    local procedure TransferReservEntryToTempRec(var ReservEntry: Record "Reservation Entry";var TrackingSpecification: Record "Tracking Specification" temporary)
    begin
        if ReservEntry.FindSet then
          repeat
            TempGlobalReservEntry := ReservEntry;
            TempGlobalReservEntry."Transferred from Entry No." := 0;
            if TempGlobalReservEntry.Insert then
              CreateEntrySummary(TrackingSpecification,TempGlobalReservEntry);
          until ReservEntry.Next = 0;
    end;

    local procedure CreateEntrySummary(TrackingSpecification: Record "Tracking Specification" temporary;TempReservEntry: Record "Reservation Entry" temporary)
    var
        LookupMode: Option "Serial No.","Lot No.";
    begin
        CreateEntrySummary2(TrackingSpecification,Lookupmode::"Serial No.",TempReservEntry);
        CreateEntrySummary2(TrackingSpecification,Lookupmode::"Lot No.",TempReservEntry);
    end;

    local procedure CreateEntrySummary2(TrackingSpecification: Record "Tracking Specification" temporary;LookupMode: Option "Serial No.","Lot No.";TempReservEntry: Record "Reservation Entry" temporary)
    var
        DoInsert: Boolean;
    begin
        TempGlobalEntrySummary.Reset;
        TempGlobalEntrySummary.SetCurrentkey("Lot No.","Serial No.");

        // Set filters
        case LookupMode of
          Lookupmode::"Serial No.":
            begin
              if TempReservEntry."Serial No." = '' then
                exit;
              TempGlobalEntrySummary.SetRange("Serial No.",TempReservEntry."Serial No.");
              TempGlobalEntrySummary.SetRange("Lot No.",TempReservEntry."Lot No.");
            end;
          Lookupmode::"Lot No.":
            begin
              TempGlobalEntrySummary.SetRange("Serial No.",'');
              TempGlobalEntrySummary.SetRange("Lot No.",TempReservEntry."Lot No.");
              if TempReservEntry."Serial No." <> '' then
                TempGlobalEntrySummary.SetRange("Table ID",0)
              else
                TempGlobalEntrySummary.SetFilter("Table ID",'<>%1',0);
            end;
        end;

        // If no summary exists, create new record
        if not TempGlobalEntrySummary.FindFirst then begin
          TempGlobalEntrySummary.Init;
          TempGlobalEntrySummary."Entry No." := LastSummaryEntryNo + 1;
          LastSummaryEntryNo := TempGlobalEntrySummary."Entry No.";

          if (LookupMode = Lookupmode::"Lot No.") and (TempReservEntry."Serial No." <> '') then
            TempGlobalEntrySummary."Table ID" := 0 // Mark as summation
          else
            TempGlobalEntrySummary."Table ID" := TempReservEntry."Source Type";
          if LookupMode = Lookupmode::"Serial No." then
            TempGlobalEntrySummary."Serial No." := TempReservEntry."Serial No."
          else
            TempGlobalEntrySummary."Serial No." := '';
          TempGlobalEntrySummary."Lot No." := TempReservEntry."Lot No.";
          TempGlobalEntrySummary."Bin Active" := CurrBinCode <> '';
          UpdateBinContent(TempGlobalEntrySummary);

          // If consumption/output fill in double entry value here:
          TempGlobalEntrySummary."Double-entry Adjustment" :=
            MaxDoubleEntryAdjustQty(TrackingSpecification,TempGlobalEntrySummary);

          DoInsert := true;
        end;

        // Sum up values
        if TempReservEntry.Positive then begin
          TempGlobalEntrySummary."Warranty Date" := TempReservEntry."Warranty Date";
          TempGlobalEntrySummary."Expiration Date" := TempReservEntry."Expiration Date";
          if TempReservEntry."Entry No." < 0 then // The record represents an Item ledger entry
            TempGlobalEntrySummary."Total Quantity" += TempReservEntry."Quantity (Base)";
          if TempReservEntry."Reservation Status" = TempReservEntry."reservation status"::Reservation then
            TempGlobalEntrySummary."Total Reserved Quantity" += TempReservEntry."Quantity (Base)";
        end else begin
          TempGlobalEntrySummary."Total Requested Quantity" -= TempReservEntry."Quantity (Base)";
          if HasSamePointer(TrackingSpecification,TempReservEntry) then begin
            if TempReservEntry."Reservation Status" = TempReservEntry."reservation status"::Reservation then
              TempGlobalEntrySummary."Current Reserved Quantity" -= TempReservEntry."Quantity (Base)";
            if TempReservEntry."Entry No." > 0 then // The record represents a reservation entry
              TempGlobalEntrySummary."Current Requested Quantity" -= TempReservEntry."Quantity (Base)";
          end;
        end;

        // Update available quantity on the record
        TempGlobalEntrySummary.UpdateAvailable;
        if DoInsert then
          TempGlobalEntrySummary.Insert
        else
          TempGlobalEntrySummary.Modify;
    end;


    procedure AutoSelectLotSerialNo(var TempEntrySummary: Record "Entry Summary" temporary;SelectQty: Decimal)
    var
        AvailableQty: Decimal;
    begin
        if SelectQty = 0 then
          exit;

        if TempEntrySummary.FindSet then
          repeat
            if TempEntrySummary."Bin Active" then
              AvailableQty := MinValueAbs(TempEntrySummary."Bin Content",TempEntrySummary."Total Available Quantity")
            else
              AvailableQty := TempEntrySummary."Total Available Quantity";

            if AvailableQty > 0 then begin
              TempEntrySummary."Selected Quantity" := MinValueAbs(AvailableQty,SelectQty);
              SelectQty -= TempEntrySummary."Selected Quantity";
              TempEntrySummary.Modify;
            end;
          until (TempEntrySummary.Next = 0) or (SelectQty <= 0);
    end;

    local procedure MinValueAbs(Value1: Decimal;Value2: Decimal): Decimal
    begin
        if Abs(Value1) < Abs(Value2) then
          exit(Value1);

        exit(Value2);
    end;

    local procedure AddSelectedLotSNToDataSet(var TempEntrySummary: Record "Entry Summary" temporary;var TrackingSpecification: Record "Tracking Specification" temporary;CurrentSignFactor: Integer)
    var
        TrackingSpecification2: Record "Tracking Specification";
        LastEntryNo: Integer;
        ChangeType: Option Insert,Modify,Delete;
    begin
        TempEntrySummary.Reset;
        TempEntrySummary.SetFilter("Selected Quantity",'<>%1',0);
        if TempEntrySummary.IsEmpty then
          exit;

        // To save general and pointer information
        TrackingSpecification2.Init;
        TrackingSpecification2."Item No." := TrackingSpecification."Item No.";
        TrackingSpecification2."Location Code" := TrackingSpecification."Location Code";
        TrackingSpecification2."Source Type" := TrackingSpecification."Source Type";
        TrackingSpecification2."Source Subtype" := TrackingSpecification."Source Subtype";
        TrackingSpecification2."Source ID" := TrackingSpecification."Source ID";
        TrackingSpecification2."Source Batch Name" := TrackingSpecification."Source Batch Name";
        TrackingSpecification2."Source Prod. Order Line" := TrackingSpecification."Source Prod. Order Line";
        TrackingSpecification2."Source Ref. No." := TrackingSpecification."Source Ref. No.";
        TrackingSpecification2.Positive := TrackingSpecification.Positive;
        TrackingSpecification2."Qty. per Unit of Measure" := TrackingSpecification."Qty. per Unit of Measure";
        TrackingSpecification2."Variant Code" := TrackingSpecification."Variant Code";

        TrackingSpecification.Reset;
        if TrackingSpecification.FindLast then
          LastEntryNo := TrackingSpecification."Entry No.";

        TempEntrySummary.FindFirst;
        repeat
          TrackingSpecification.SetRange("Serial No.",TempEntrySummary."Serial No.");
          TrackingSpecification.SetRange("Lot No.",TempEntrySummary."Lot No.");
          if TrackingSpecification.FindFirst then begin
            TrackingSpecification.Validate("Quantity (Base)",
              TrackingSpecification."Quantity (Base)" + TempEntrySummary."Selected Quantity");
            TrackingSpecification."Buffer Status" := TrackingSpecification."buffer status"::Modify;
            TransferExpDateFromSummary(TrackingSpecification,TempEntrySummary);
            TrackingSpecification.Modify;
            UpdateLotSNDataSetWithChange(TrackingSpecification,true,CurrentSignFactor,Changetype::Modify);
          end else begin
            TrackingSpecification := TrackingSpecification2;
            TrackingSpecification."Entry No." := LastEntryNo + 1;
            LastEntryNo := TrackingSpecification."Entry No.";
            TrackingSpecification."Serial No." := TempEntrySummary."Serial No.";
            TrackingSpecification."Lot No." := TempEntrySummary."Lot No.";
            TrackingSpecification."Buffer Status" := TrackingSpecification."buffer status"::Insert;
            TransferExpDateFromSummary(TrackingSpecification,TempEntrySummary);
            if TrackingSpecification.IsReclass then
              begin
              TrackingSpecification."New Serial No." := TrackingSpecification."Serial No.";
              TrackingSpecification."New Lot No." := TrackingSpecification."Lot No.";
            end;
            TrackingSpecification.Validate("Quantity (Base)",TempEntrySummary."Selected Quantity");
            TrackingSpecification.Insert;
            UpdateLotSNDataSetWithChange(TrackingSpecification,true,CurrentSignFactor,Changetype::Insert);
          end;
        until TempEntrySummary.Next = 0;

        TrackingSpecification.Reset;
    end;


    procedure LotSNAvailable(TrackingSpecification: Record "Tracking Specification" temporary;LookupMode: Option "Serial No.","Lot No."): Boolean
    begin
        CurrItemTrackingCode.TestField(Code);
        case LookupMode of
          Lookupmode::"Serial No.":
            if (TrackingSpecification."Serial No." = '') or (not CurrItemTrackingCode."SN Specific Tracking") then
              exit(true);
          Lookupmode::"Lot No.":
            if (TrackingSpecification."Lot No." = '') or (not CurrItemTrackingCode."Lot Specific Tracking") then
              exit(true);
        end;

        if not (PartialGlobalDataSetExists or FullGlobalDataSetExists) then
          RetrieveLookupData(TrackingSpecification,true);

        TempGlobalEntrySummary.Reset;
        TempGlobalEntrySummary.SetCurrentkey("Lot No.","Serial No.");

        case LookupMode of
          Lookupmode::"Serial No.":
            begin
              TempGlobalEntrySummary.SetRange("Serial No.",TrackingSpecification."Serial No.");
              TempGlobalEntrySummary.SetFilter("Total Available Quantity",'< %1',0);
              if CheckJobInPurchLine(TrackingSpecification) then
                exit(TempGlobalEntrySummary.FindFirst);
              exit(TempGlobalEntrySummary.IsEmpty);
            end;
          Lookupmode::"Lot No.":
            begin
              TempGlobalEntrySummary.SetRange("Serial No.",'');
              TempGlobalEntrySummary.SetRange("Lot No.",TrackingSpecification."Lot No.");
              TempGlobalEntrySummary.CalcSums("Total Available Quantity");
              if CheckJobInPurchLine(TrackingSpecification) then
                exit(TempGlobalEntrySummary.FindFirst);
              exit(TempGlobalEntrySummary."Total Available Quantity" >= 0);
            end;
        end;
    end;

    local procedure HasSamePointer(TrackingSpecification: Record "Tracking Specification";ReservEntry: Record "Reservation Entry"): Boolean
    begin
        exit((ReservEntry."Source Type" = TrackingSpecification."Source Type") and
          (ReservEntry."Source Subtype" = TrackingSpecification."Source Subtype") and
          (ReservEntry."Source ID" = TrackingSpecification."Source ID") and
          (ReservEntry."Source Batch Name" = TrackingSpecification."Source Batch Name") and
          (ReservEntry."Source Prod. Order Line" = TrackingSpecification."Source Prod. Order Line") and
          (ReservEntry."Source Ref. No." = TrackingSpecification."Source Ref. No."));
    end;


    procedure UpdateLotSNDataSetWithChange(var TempItemTrackLineChanged: Record "Tracking Specification" temporary;LineIsDemand: Boolean;CurrentSignFactor: Integer;ChangeType: Option Insert,Modify,Delete)
    var
        LastEntryNo: Integer;
    begin
        if not TempItemTrackLineChanged.TrackingExists then
          exit;
        LastEntryNo := UpdateLotSNGlobalChangeRec(TempItemTrackLineChanged,LineIsDemand,CurrentSignFactor,ChangeType);
        TempGlobalChangedEntrySummary.Get(LastEntryNo);
        UpdateTempSummaryWithChange(TempGlobalChangedEntrySummary);
    end;

    local procedure UpdateLotSNGlobalChangeRec(var TempItemTrackLineChanged: Record "Tracking Specification" temporary;LineIsDemand: Boolean;CurrentSignFactor: Integer;ChangeType: Option Insert,Modify,Delete): Integer
    var
        NewQuantity: Decimal;
        LastEntryNo: Integer;
    begin
        if (ChangeType = Changetype::Delete) or not LineIsDemand then
          NewQuantity := 0
        else
          NewQuantity := TempItemTrackLineChanged."Quantity (Base)" - TempItemTrackLineChanged."Quantity Handled (Base)";

        if CurrentSignFactor > 0 then // Negative supply lines
          NewQuantity := -NewQuantity;

        TempGlobalChangedEntrySummary.Reset;
        TempGlobalChangedEntrySummary.SetCurrentkey("Lot No.","Serial No.");

        TempGlobalChangedEntrySummary.SetRange("Serial No.",TempItemTrackLineChanged."Serial No.");
        TempGlobalChangedEntrySummary.SetRange("Lot No.",TempItemTrackLineChanged."Lot No.");

        if TempGlobalChangedEntrySummary.FindFirst then begin
          if LineIsDemand then begin
            TempGlobalChangedEntrySummary."Current Pending Quantity" := NewQuantity;
            TempGlobalChangedEntrySummary.Modify;
          end;
        end else begin
          TempGlobalChangedEntrySummary.Reset;
          if TempGlobalChangedEntrySummary.FindLast then
            LastEntryNo := TempGlobalChangedEntrySummary."Entry No.";
          TempGlobalChangedEntrySummary.Init;
          TempGlobalChangedEntrySummary."Entry No." := LastEntryNo + 1;
          TempGlobalChangedEntrySummary."Lot No." := TempItemTrackLineChanged."Lot No.";
          TempGlobalChangedEntrySummary."Serial No." := TempItemTrackLineChanged."Serial No.";
          TempGlobalChangedEntrySummary."Current Pending Quantity" := NewQuantity;
          if TempItemTrackLineChanged."Serial No." <> '' then
            TempGlobalChangedEntrySummary."Table ID" := Database::"Tracking Specification"; // Not a summary line
          TempGlobalChangedEntrySummary.Insert;
          PartialGlobalDataSetExists := false; // The partial data set does not cover the new line
        end;
        exit(TempGlobalChangedEntrySummary."Entry No.");
    end;

    local procedure UpdateCurrentPendingQty()
    var
        TempLastGlobalEntrySummary: Record "Entry Summary" temporary;
    begin
        TempGlobalChangedEntrySummary.Reset;
        TempGlobalChangedEntrySummary.SetCurrentkey("Lot No.","Serial No.");
        if TempGlobalChangedEntrySummary.FindSet then
          repeat
            if TempGlobalChangedEntrySummary."Lot No." <> '' then begin
              // only last record with Lot Number updates Summary
              if TempGlobalChangedEntrySummary."Lot No." <> TempLastGlobalEntrySummary."Lot No." then
                FindLastGlobalEntrySummary(TempGlobalChangedEntrySummary,TempLastGlobalEntrySummary);
              SkipLot := not (TempGlobalChangedEntrySummary."Entry No." = TempLastGlobalEntrySummary."Entry No.");
            end;
            UpdateTempSummaryWithChange(TempGlobalChangedEntrySummary);
          until TempGlobalChangedEntrySummary.Next = 0;
    end;

    local procedure UpdateTempSummaryWithChange(var ChangedEntrySummary: Record "Entry Summary" temporary)
    var
        LastEntryNo: Integer;
        SumOfSNPendingQuantity: Decimal;
        SumOfSNRequestedQuantity: Decimal;
    begin
        TempGlobalEntrySummary.Reset;
        if TempGlobalEntrySummary.FindLast then
          LastEntryNo := TempGlobalEntrySummary."Entry No.";

        TempGlobalEntrySummary.SetCurrentkey("Lot No.","Serial No.");
        if ChangedEntrySummary."Serial No." <> '' then begin
          TempGlobalEntrySummary.SetRange("Serial No.",ChangedEntrySummary."Serial No.");
          TempGlobalEntrySummary.SetRange("Lot No.",ChangedEntrySummary."Lot No.");
          if TempGlobalEntrySummary.FindFirst then begin
            TempGlobalEntrySummary."Current Pending Quantity" := ChangedEntrySummary."Current Pending Quantity" -
              TempGlobalEntrySummary."Current Requested Quantity";
            TempGlobalEntrySummary.UpdateAvailable;
            TempGlobalEntrySummary.Modify;
          end else begin
            TempGlobalEntrySummary := ChangedEntrySummary;
            TempGlobalEntrySummary."Entry No." := LastEntryNo + 1;
            LastEntryNo := TempGlobalEntrySummary."Entry No.";
            TempGlobalEntrySummary."Bin Active" := CurrBinCode <> '';
            UpdateBinContent(TempGlobalEntrySummary);
            TempGlobalEntrySummary.UpdateAvailable;
            TempGlobalEntrySummary.Insert;
          end;

          if (ChangedEntrySummary."Lot No." <> '') and not SkipLot then begin
            TempGlobalEntrySummary.SetFilter("Serial No.",'<>%1','');
            TempGlobalEntrySummary.SetRange("Lot No.",ChangedEntrySummary."Lot No.");
            TempGlobalEntrySummary.CalcSums("Current Pending Quantity","Current Requested Quantity");
            SumOfSNPendingQuantity := TempGlobalEntrySummary."Current Pending Quantity";
            SumOfSNRequestedQuantity := TempGlobalEntrySummary."Current Requested Quantity";
          end;
        end;

        if (ChangedEntrySummary."Lot No." <> '') and not SkipLot then begin
          TempGlobalEntrySummary.SetRange("Serial No.",'');
          TempGlobalEntrySummary.SetRange("Lot No.",ChangedEntrySummary."Lot No.");

          if ChangedEntrySummary."Serial No." <> '' then
            TempGlobalEntrySummary.SetRange("Table ID",0)
          else
            TempGlobalEntrySummary.SetFilter("Table ID",'<>%1',0);

          if TempGlobalEntrySummary.FindFirst then begin
            if ChangedEntrySummary."Serial No." <> '' then begin
              TempGlobalEntrySummary."Current Pending Quantity" := SumOfSNPendingQuantity;
              TempGlobalEntrySummary."Current Requested Quantity" := SumOfSNRequestedQuantity;
            end else
              TempGlobalEntrySummary."Current Pending Quantity" := ChangedEntrySummary."Current Pending Quantity" -
                TempGlobalEntrySummary."Current Requested Quantity";

            TempGlobalEntrySummary.UpdateAvailable;
            TempGlobalEntrySummary.Modify;
          end else begin
            TempGlobalEntrySummary := ChangedEntrySummary;
            TempGlobalEntrySummary."Entry No." := LastEntryNo + 1;
            TempGlobalEntrySummary."Serial No." := '';
            if ChangedEntrySummary."Serial No." <> '' then // Mark as summation
              TempGlobalEntrySummary."Table ID" := 0
            else
              TempGlobalEntrySummary."Table ID" := Database::"Tracking Specification";
            TempGlobalEntrySummary."Bin Active" := CurrBinCode <> '';
            UpdateBinContent(TempGlobalEntrySummary);
            TempGlobalEntrySummary.UpdateAvailable;
            TempGlobalEntrySummary.Insert;
          end;
        end;
    end;


    procedure RefreshLotSNAvailability(var TrackingSpecification: Record "Tracking Specification" temporary;ShowMessage: Boolean) AvailabilityOK: Boolean
    var
        TrackingSpecification2: Record "Tracking Specification";
        LookupMode: Option "Serial No.","Lot No.";
        PreviousLotNo: Code[20];
    begin
        AvailabilityOK := true;
        if TrackingSpecification.Positive then
          exit;

        TrackingSpecification2.Copy(TrackingSpecification);
        TrackingSpecification.Reset;
        if TrackingSpecification.IsEmpty then begin
          TrackingSpecification.Copy(TrackingSpecification2);
          exit;
        end;

        FullGlobalDataSetExists := false;
        PartialGlobalDataSetExists := false;
        RetrieveLookupData(TrackingSpecification,false);

        TrackingSpecification.SetCurrentkey("Lot No.","Serial No.");
        TrackingSpecification.Find('-');
        LookupMode := Lookupmode::"Serial No.";
        repeat
          if TrackingSpecification."Lot No." <> PreviousLotNo then begin
            PreviousLotNo := TrackingSpecification."Lot No.";
            LookupMode := Lookupmode::"Lot No.";

            if not LotSNAvailable(TrackingSpecification,LookupMode) then
              AvailabilityOK := false;

            LookupMode := Lookupmode::"Serial No.";
          end;

          if not LotSNAvailable(TrackingSpecification,LookupMode) then
            AvailabilityOK := false;
        until TrackingSpecification.Next = 0;

        if ShowMessage then
          if AvailabilityOK then
            Message(Text006 + Text008)
          else
            Message(Text006 + Text007);

        TrackingSpecification.Copy(TrackingSpecification2);
    end;


    procedure SetCurrentBinAndItemTrkgCode(BinCode: Code[20];ItemTrackingCode: Record "Item Tracking Code")
    var
        xBinCode: Code[20];
    begin
        xBinCode := CurrBinCode;
        CurrBinCode := BinCode;
        CurrItemTrackingCode := ItemTrackingCode;

        if xBinCode <> BinCode then
          if PartialGlobalDataSetExists then
            RefreshBinContent(TempGlobalEntrySummary);
    end;

    local procedure UpdateBinContent(var TempEntrySummary: Record "Entry Summary" temporary)
    var
        WarehouseEntry: Record "Warehouse Entry";
    begin
        if CurrBinCode = '' then
          exit;
        CurrItemTrackingCode.TestField(Code);
        WarehouseEntry.Reset;
        WarehouseEntry.SetCurrentkey(
          "Item No.","Bin Code","Location Code","Variant Code",
          "Unit of Measure Code","Lot No.","Serial No.");
        WarehouseEntry.SetRange("Item No.",TempGlobalReservEntry."Item No.");
        WarehouseEntry.SetRange("Bin Code",CurrBinCode);
        WarehouseEntry.SetRange("Location Code",TempGlobalReservEntry."Location Code");
        WarehouseEntry.SetRange("Variant Code",TempGlobalReservEntry."Variant Code");
        if CurrItemTrackingCode."SN Warehouse Tracking" then
          if TempEntrySummary."Serial No." <> '' then
            WarehouseEntry.SetRange("Serial No.",TempEntrySummary."Serial No.");
        if CurrItemTrackingCode."Lot Warehouse Tracking" then
          if TempEntrySummary."Lot No." <> '' then
            WarehouseEntry.SetRange("Lot No.",TempEntrySummary."Lot No.");
        WarehouseEntry.CalcSums("Qty. (Base)");

        TempEntrySummary."Bin Content" := WarehouseEntry."Qty. (Base)";
    end;

    local procedure RefreshBinContent(var TempEntrySummary: Record "Entry Summary" temporary)
    begin
        TempEntrySummary.Reset;
        if TempEntrySummary.FindSet then
          repeat
            if CurrBinCode <> '' then
              UpdateBinContent(TempEntrySummary)
            else
              TempEntrySummary."Bin Content" := 0;
            TempEntrySummary.Modify;
          until TempEntrySummary.Next = 0;
    end;

    local procedure TransferExpDateFromSummary(var TrackingSpecification: Record "Tracking Specification" temporary;var TempEntrySummary: Record "Entry Summary" temporary)
    begin
        // Handle Expiration Date
        if TempEntrySummary."Total Quantity" <> 0 then begin
          TrackingSpecification."Buffer Status2" := TrackingSpecification."buffer status2"::"ExpDate blocked";
          TrackingSpecification."Expiration Date" := TempEntrySummary."Expiration Date";
          if TrackingSpecification.IsReclass then
            TrackingSpecification."New Expiration Date" := TrackingSpecification."Expiration Date"
          else
            TrackingSpecification."New Expiration Date" := 0D;
        end else begin
          TrackingSpecification."Buffer Status2" := 0;
          TrackingSpecification."Expiration Date" := 0D;
          TrackingSpecification."New Expiration Date" := 0D;
        end;
    end;


    procedure CreateEntrySummaryFEFO(Location: Record Location;ItemNo: Code[20];VariantCode: Code[10];UseExpDates: Boolean)
    begin
        InitEntrySummaryFEFO;
        LastSummaryEntryNo := 0;
        StrictExpirationPosting := ItemTrackingMgt.StrictExpirationPosting(ItemNo);

        SummarizeInventoryFEFO(Location,ItemNo,VariantCode,UseExpDates);
        if UseExpDates then
          SummarizeAdjustmentBinFEFO(Location,ItemNo,VariantCode);
    end;

    local procedure SummarizeInventoryFEFO(Location: Record Location;ItemNo: Code[20];VariantCode: Code[10];HasExpirationDate: Boolean)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        with ItemLedgEntry do begin
          Reset;
          SetCurrentkey("Item No.",Open,"Variant Code",Positive,"Expiration Date","Lot No.","Serial No.");
          SetRange("Item No.",ItemNo);
          SetRange(Open,true);
          SetRange("Variant Code",VariantCode);
          SetRange(Positive,true);
          if HasExpirationDate then
            SetFilter("Expiration Date",'<>%1',0D)
          else
            SetRange("Expiration Date",0D);
          SetRange("Location Code",Location.Code);
          if IsEmpty then
            exit;

          FindSet;
          repeat
            CalcFields("Reserved Quantity");
            if "Remaining Quantity" - ("Reserved Quantity" - CalcReservedToSource("Entry No.")) > 0 then
              if not EntrySummaryFEFOExists("Lot No.","Serial No.") then
                InsertEntrySummaryFEFO("Lot No.","Serial No.","Expiration Date");
          until Next = 0;
        end;
    end;

    local procedure SummarizeAdjustmentBinFEFO(Location: Record Location;ItemNo: Code[20];VariantCode: Code[10])
    var
        WhseEntry: Record "Warehouse Entry";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ExpirationDate: Date;
        EntriesExist: Boolean;
    begin
        if Location."Adjustment Bin Code" = '' then
          exit;

        with WhseEntry do begin
          Reset;
          SetCurrentkey("Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code","Lot No.","Serial No.");
          SetRange("Item No.",ItemNo);
          SetRange("Bin Code",Location."Adjustment Bin Code");
          SetRange("Location Code",Location.Code);
          SetRange("Variant Code",VariantCode);
          if IsEmpty then
            exit;

          if FindSet then
            repeat
              if not EntrySummaryFEFOExists("Lot No.","Serial No.") then begin
                ExpirationDate :=
                  ItemTrackingMgt.WhseExistingExpirationDate(
                    "Item No.","Variant Code",Location,"Lot No.","Serial No.",EntriesExist);

                if not EntriesExist then
                  ExpirationDate := 0D;

                InsertEntrySummaryFEFO("Lot No.","Serial No.",ExpirationDate);
              end;
            until Next = 0;
        end;
    end;

    local procedure InitEntrySummaryFEFO()
    begin
        with TempGlobalEntrySummaryFEFO do begin
          DeleteAll;
          Reset;
          SetCurrentkey("Lot No.","Serial No.");
        end;
    end;

    local procedure InsertEntrySummaryFEFO(LotNo: Code[20];SerialNo: Code[20];ExpirationDate: Date)
    begin
        with TempGlobalEntrySummaryFEFO do begin
          if (not StrictExpirationPosting) or (ExpirationDate >= WorkDate) then begin
            Init;
            "Entry No." := LastSummaryEntryNo + 1;
            "Serial No." := SerialNo;
            "Lot No." := LotNo;
            "Expiration Date" := ExpirationDate;
            Insert;
            LastSummaryEntryNo := "Entry No.";
          end else
            HasExpiredItems := true;
        end;
    end;

    local procedure EntrySummaryFEFOExists(LotNo: Code[20];SerialNo: Code[20]): Boolean
    begin
        with TempGlobalEntrySummaryFEFO do begin
          SetRange("Lot No.",LotNo);
          SetRange("Serial No.",SerialNo);
          exit(FindSet);
        end;
    end;


    procedure FindFirstEntrySummaryFEFO(var EntrySummary: Record "Entry Summary"): Boolean
    begin
        with TempGlobalEntrySummaryFEFO do begin
          Reset;
          SetCurrentkey("Expiration Date");

          if not Find('-') then
            exit(false);

          EntrySummary := TempGlobalEntrySummaryFEFO;
          exit(true);
        end;
    end;


    procedure FindNextEntrySummaryFEFO(var EntrySummary: Record "Entry Summary"): Boolean
    begin
        with TempGlobalEntrySummaryFEFO do begin
          if Next = 0 then
            exit(false);

          EntrySummary := TempGlobalEntrySummaryFEFO;
          exit(true);
        end;
    end;

    local procedure AdjustForDoubleEntries()
    begin
        TempGlobalAdjustEntry.Reset;
        TempGlobalAdjustEntry.DeleteAll;

        TempGlobalTrackingSpec.Reset;
        TempGlobalTrackingSpec.DeleteAll;

        // Check if there is any need to investigate:
        TempGlobalReservEntry.Reset;
        TempGlobalReservEntry.SetCurrentkey("Source ID","Source Ref. No.","Source Type","Source Subtype","Source Batch Name");
        TempGlobalReservEntry.SetRange("Reservation Status",TempGlobalReservEntry."reservation status"::Prospect);
        TempGlobalReservEntry.SetRange("Source Type",Database::"Item Journal Line");
        TempGlobalReservEntry.SetRange("Source Subtype",5,6); // Consumption, Output
        if TempGlobalReservEntry.IsEmpty then  // No journal lines with consumption or output exist
          exit;

        TempGlobalReservEntry.Reset;
        TempGlobalReservEntry.SetCurrentkey("Source ID","Source Ref. No.","Source Type","Source Subtype","Source Batch Name");
        TempGlobalReservEntry.SetRange("Source Type",Database::"Prod. Order Line");
        TempGlobalReservEntry.SetRange("Source Subtype",3); // Released order
        if TempGlobalReservEntry.FindSet then
          repeat
            // Sum up per prod. order line per lot/sn
            SumUpTempTrkgSpec(TempGlobalTrackingSpec,TempGlobalReservEntry);
          until TempGlobalReservEntry.Next = 0;

        TempGlobalReservEntry.Reset;
        TempGlobalReservEntry.SetCurrentkey("Source ID","Source Ref. No.","Source Type","Source Subtype","Source Batch Name");
        TempGlobalReservEntry.SetRange("Source Type",Database::"Prod. Order Component");
        TempGlobalReservEntry.SetRange("Source Subtype",3); // Released order
        if TempGlobalReservEntry.FindSet then
          repeat
            // Sum up per prod. order component per lot/sn
            SumUpTempTrkgSpec(TempGlobalTrackingSpec,TempGlobalReservEntry);
          until TempGlobalReservEntry.Next = 0;

        TempGlobalReservEntry.Reset;
        TempGlobalReservEntry.SetCurrentkey("Source ID","Source Ref. No.","Source Type","Source Subtype","Source Batch Name");
        TempGlobalReservEntry.SetRange("Reservation Status",TempGlobalReservEntry."reservation status"::Prospect);
        TempGlobalReservEntry.SetRange("Source Type",Database::"Item Journal Line");
        TempGlobalReservEntry.SetRange("Source Subtype",5,6); // Consumption, Output

        if TempGlobalReservEntry.FindSet then
          repeat
            // Sum up per Component line per lot/sn
            RelateJnlLineToTempTrkgSpec(TempGlobalReservEntry,TempGlobalTrackingSpec);
          until TempGlobalReservEntry.Next = 0;

        InsertAdjustmentEntries;
    end;

    local procedure SumUpTempTrkgSpec(var TempTrackingSpecification: Record "Tracking Specification" temporary;ReservEntry: Record "Reservation Entry")
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        TempTrackingSpecification.SetRange("Source Type",ReservEntry."Source Type");
        TempTrackingSpecification.SetRange("Source Subtype",ReservEntry."Source Subtype");
        TempTrackingSpecification.SetRange("Source ID",ReservEntry."Source ID");
        TempTrackingSpecification.SetRange("Source Batch Name",ReservEntry."Source Batch Name");
        TempTrackingSpecification.SetRange("Source Prod. Order Line",ReservEntry."Source Prod. Order Line");
        TempTrackingSpecification.SetRange("Source Ref. No.",ReservEntry."Source Ref. No.");
        TempTrackingSpecification.SetRange("Serial No.",ReservEntry."Serial No.");
        TempTrackingSpecification.SetRange("Lot No.",ReservEntry."Lot No.");
        if TempTrackingSpecification.FindFirst then begin
          TempTrackingSpecification."Quantity (Base)" += ReservEntry."Quantity (Base)";
          TempTrackingSpecification.Modify;
        end else begin
          ItemTrackingMgt.CreateTrackingSpecification(ReservEntry,TempTrackingSpecification);
          if not ReservEntry.Positive then               // To avoid inserting existing entry when both sides of the reservation
            TempTrackingSpecification."Entry No." *= -1; // are handled.
          TempTrackingSpecification.Insert;
        end;
    end;

    local procedure RelateJnlLineToTempTrkgSpec(var ReservEntry: Record "Reservation Entry";var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ItemJnlLine: Record "Item Journal Line";
        RemainingQty: Decimal;
        AdjustQty: Decimal;
        QtyOnJnlLine: Decimal;
    begin
        // Pre-check
        ReservEntry.TestField("Reservation Status",ReservEntry."reservation status"::Prospect);
        ReservEntry.TestField("Source Type",Database::"Item Journal Line");
        if not (ReservEntry."Source Subtype" in [5,6]) then
          ReservEntry.FieldError("Source Subtype");

        if not ItemJnlLine.Get(ReservEntry."Source ID",
             ReservEntry."Source Batch Name",ReservEntry."Source Ref. No.")
        then
          exit;

        if (ItemJnlLine."Order Type" <> ItemJnlLine."order type"::Production) or
           (ItemJnlLine."Order No." = '') or
           (ItemJnlLine."Order Line No." = 0)
        then
          exit;

        // Buffer fields are used as follows:
        // "Buffer Value1" : Summed up quantity on journal line(s)
        // "Buffer Value2" : Adjustment needed to neutralize double entries

        if FindRelatedParentTrkgSpec(ItemJnlLine,TempTrackingSpecification,
             ReservEntry."Serial No.",ReservEntry."Lot No.")
        then begin
          RemainingQty := TempTrackingSpecification."Quantity (Base)" + TempTrackingSpecification."Buffer Value2";
          QtyOnJnlLine := ReservEntry."Quantity (Base)";
          ReservEntry."Transferred from Entry No." := Abs(TempTrackingSpecification."Entry No.");
          ReservEntry.Modify;

          if (RemainingQty <> 0) and (RemainingQty * QtyOnJnlLine > 0) then begin
            if Abs(QtyOnJnlLine) <= Abs(RemainingQty) then
              AdjustQty := -QtyOnJnlLine
            else
              AdjustQty := -RemainingQty;
          end;

          TempTrackingSpecification."Buffer Value1" += QtyOnJnlLine;
          TempTrackingSpecification."Buffer Value2" += AdjustQty;
          TempTrackingSpecification.Modify;
          AddToAdjustmentEntryDataSet(ReservEntry,AdjustQty);
        end;
    end;

    local procedure FindRelatedParentTrkgSpec(ItemJnlLine: Record "Item Journal Line";var TempTrackingSpecification: Record "Tracking Specification" temporary;SerialNo: Code[20];LotNo: Code[20]): Boolean
    begin
        ItemJnlLine.TestField("Order Type",ItemJnlLine."order type"::Production);
        TempTrackingSpecification.Reset;
        TempTrackingSpecification.SetRange("Source Subtype",3); // Released
        TempTrackingSpecification.SetRange("Source ID",ItemJnlLine."Order No.");
        TempTrackingSpecification.SetRange("Source Prod. Order Line",ItemJnlLine."Order Line No.");
        TempTrackingSpecification.SetRange("Source Batch Name",'');

        TempTrackingSpecification.SetRange("Serial No.",SerialNo);
        TempTrackingSpecification.SetRange("Lot No.",LotNo);

        case ItemJnlLine."Entry Type" of
          ItemJnlLine."entry type"::Consumption:
            begin
              if ItemJnlLine."Prod. Order Comp. Line No." = 0 then
                exit;
              TempTrackingSpecification.SetRange("Source Type",Database::"Prod. Order Component");
              TempTrackingSpecification.SetRange("Source Ref. No.",ItemJnlLine."Prod. Order Comp. Line No.");
            end;
          ItemJnlLine."entry type"::Output:
            TempTrackingSpecification.SetRange("Source Type",Database::"Prod. Order Line");
        end;

        exit(TempTrackingSpecification.FindFirst);
    end;

    local procedure AddToAdjustmentEntryDataSet(var ReservEntry: Record "Reservation Entry";AdjustQty: Decimal)
    begin
        if AdjustQty = 0 then
          exit;

        TempGlobalAdjustEntry := ReservEntry;
        TempGlobalAdjustEntry."Source Type" := -ReservEntry."Source Type";
        TempGlobalAdjustEntry.Description := CopyStr(Text013,1,MaxStrLen(TempGlobalAdjustEntry.Description));
        TempGlobalAdjustEntry."Quantity (Base)" := AdjustQty;
        TempGlobalAdjustEntry."Entry No." += LastReservEntryNo; // Use last entry no as offset to avoid inserting existing entry
        TempGlobalAdjustEntry.Insert;
    end;

    local procedure InsertAdjustmentEntries()
    var
        TempTrackingSpecification: Record "Tracking Specification" temporary;
    begin
        TempGlobalAdjustEntry.Reset;
        if not TempGlobalAdjustEntry.FindSet then
          exit;

        TempTrackingSpecification.Init;
        TempTrackingSpecification.Insert;
        repeat
          CreateEntrySummary(TempTrackingSpecification,TempGlobalAdjustEntry); // TrackingSpecification is a dummy record
          TempGlobalReservEntry := TempGlobalAdjustEntry;
          TempGlobalReservEntry.Insert;
        until TempGlobalAdjustEntry.Next = 0;
    end;

    local procedure MaxDoubleEntryAdjustQty(var TempItemTrackLineChanged: Record "Tracking Specification" temporary;var ChangedEntrySummary: Record "Entry Summary" temporary): Decimal
    var
        ItemJnlLine: Record "Item Journal Line";
    begin
        if not (TempItemTrackLineChanged."Source Type" = Database::"Item Journal Line") then
          exit;

        if not (TempItemTrackLineChanged."Source Subtype" in [5,6]) then
          exit;

        if not ItemJnlLine.Get(TempItemTrackLineChanged."Source ID",
             TempItemTrackLineChanged."Source Batch Name",TempItemTrackLineChanged."Source Ref. No.")
        then
          exit;

        TempGlobalTrackingSpec.Reset;

        if FindRelatedParentTrkgSpec(ItemJnlLine,TempGlobalTrackingSpec,
             ChangedEntrySummary."Serial No.",ChangedEntrySummary."Lot No.")
        then
          exit(-TempGlobalTrackingSpec."Quantity (Base)" - TempGlobalTrackingSpec."Buffer Value2");
    end;


    procedure CurrentDataSetMatches(ItemNo: Code[20];VariantCode: Code[20];LocationCode: Code[10]): Boolean
    begin
        exit(
          (TempGlobalReservEntry."Item No." = ItemNo) and
          (TempGlobalReservEntry."Variant Code" = VariantCode) and
          (TempGlobalReservEntry."Location Code" = LocationCode));
    end;

    local procedure CheckJobInPurchLine(TrackingSpecification: Record "Tracking Specification"): Boolean
    var
        PurchLine: Record "Purchase Line";
    begin
        with TrackingSpecification do begin
          if ("Source Type" = Database::"Purchase Line") and ("Source Subtype" = "source subtype"::"3") then begin
            PurchLine.Reset;
            PurchLine.SetRange("Document Type","Source Subtype");
            PurchLine.SetRange("Document No.","Source ID");
            PurchLine.SetRange("Line No.","Source Ref. No.");
            if PurchLine.FindFirst then
              exit(PurchLine."Job No." <> '');
          end;
        end;
    end;


    procedure GetHasExpiredItems(): Boolean
    begin
        exit(HasExpiredItems);
    end;


    procedure GetResultMessageForExpiredItem(): Text[100]
    begin
        if HasExpiredItems then
          exit(Text012);
        exit('');
    end;


    procedure FindLotNoBySN(TrackingSpecification: Record "Tracking Specification"): Code[20]
    begin
        if not (PartialGlobalDataSetExists or FullGlobalDataSetExists) then
          RetrieveLookupData(TrackingSpecification,true);

        TempGlobalEntrySummary.Reset;
        TempGlobalEntrySummary.SetCurrentkey("Lot No.","Serial No.");
        TempGlobalEntrySummary.SetRange("Serial No.",TrackingSpecification."Serial No.");
        TempGlobalEntrySummary.FindFirst;

        exit(TempGlobalEntrySummary."Lot No.");
    end;


    procedure SetSkipLot(SkipLot2: Boolean)
    begin
        // only last record with Lot Number updates Summary.
        SkipLot := SkipLot2;
    end;

    local procedure FindLastGlobalEntrySummary(var GlobalChangedEntrySummary: Record "Entry Summary";var LastGlobalEntrySummary: Record "Entry Summary")
    var
        TempGlobalChangedEntrySummary2: Record "Entry Summary" temporary;
    begin
        TempGlobalChangedEntrySummary2 := GlobalChangedEntrySummary;
        GlobalChangedEntrySummary.SetRange("Lot No.",GlobalChangedEntrySummary."Lot No.");
        if GlobalChangedEntrySummary.FindLast then
          LastGlobalEntrySummary := GlobalChangedEntrySummary;
        GlobalChangedEntrySummary.Copy(TempGlobalChangedEntrySummary2);
    end;


    procedure SetSource(SourceType2: Integer;SourceSubType2: Option "0","1","2","3","4","5","6","7","8","9","10";SourceNo2: Code[20];SourceLineNo2: Integer;SourceSubLineNo2: Integer)
    var
        CreatePick: Codeunit "Create Pick";
    begin
        SourceReservationEntry.Reset;
        CreatePick.SetFiltersOnReservEntry(
          SourceReservationEntry,SourceType2,SourceSubType2,SourceNo2,SourceLineNo2,SourceSubLineNo2);
        SourceSet := true;
    end;

    local procedure CalcReservedToSource(ILENo: Integer) Result: Decimal
    begin
        Result := 0;
        if not SourceSet then
          exit(Result);

        with SourceReservationEntry do begin
          if FindSet then
            repeat
              if ReservedFromILE(SourceReservationEntry,ILENo) then
                Result -= "Quantity (Base)"; // "Quantity (Base)" is negative
            until Next = 0;
        end;

        exit(Result);
    end;

    local procedure ReservedFromILE(ReservationEntry: Record "Reservation Entry";ILENo: Integer): Boolean
    begin
        with ReservationEntry do begin
          Positive := not Positive;
          Find;
          exit(
            ("Source ID" = '') and ("Source Ref. No." = ILENo) and
            ("Source Type" = Database::"Item Ledger Entry") and ("Source Subtype" = 0) and
            ("Source Batch Name" = '') and ("Source Prod. Order Line" = 0) and
            ("Reservation Status" = "reservation status"::Reservation));
        end;
    end;
}

