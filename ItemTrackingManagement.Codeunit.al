#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6500 "Item Tracking Management"
{
    Permissions = TableData "Item Entry Relation"=rd,
                  TableData "Value Entry Relation"=rd,
                  TableData "Whse. Item Tracking Line"=rimd;

    trigger OnRun()
    var
        ItemTrackingLines: Page "Item Tracking Lines";
    begin
        SourceSpecification.TestField("Source Type");
        ItemTrackingLines.RegisterItemTrackingLines(
          SourceSpecification,DueDate,TempTrackingSpecification)
    end;

    var
        Text001: label 'The quantity to %1 does not match the quantity defined in item tracking.';
        Text002: label 'Cannot match item tracking.';
        Text003: label 'No information exists for %1 %2.';
        Text005: label 'Warehouse item tracking is not enabled for %1 %2.';
        SourceSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        TempGlobalWhseItemTrkgLine: Record "Whse. Item Tracking Line" temporary;
        DueDate: Date;
        Text006: label 'Synchronization canceled.';
        Registering: Boolean;
        Text007: label 'There are multiple expiration dates registered for lot %1.';
        text008: label '%1 already exists for %2 %3. Do you want to overwrite the existing information?';
        IsConsume: Boolean;
        Text010: label 'invoice';
        Text011: label '%1 must not be %2.';
        Text012: label 'Only one expiration date is allowed per lot number.\%1 currently has two different expiration dates: %2 and %3.';
        IsPick: Boolean;
        DeleteReservationEntries: Boolean;
        Text004: label 'Counting records...';


    procedure SetPointerFilter(var TrackingSpecification: Record "Tracking Specification")
    begin
        with TrackingSpecification do begin
          SetCurrentkey("Source ID","Source Type","Source Subtype","Source Batch Name",
            "Source Prod. Order Line","Source Ref. No.");
          SetRange("Source Type","Source Type");
          SetRange("Source Subtype","Source Subtype");
          SetRange("Source ID","Source ID");
          SetRange("Source Batch Name","Source Batch Name");
          SetRange("Source Prod. Order Line","Source Prod. Order Line");
          SetRange("Source Ref. No.","Source Ref. No.");
        end;
    end;


    procedure LookupLotSerialNoInfo(ItemNo: Code[20];Variant: Code[20];LookupType: Option "Serial No.","Lot No.";LookupNo: Code[20])
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
    begin
        case LookupType of
          Lookuptype::"Serial No.":
            begin
              if not SerialNoInfo.Get(ItemNo,Variant,LookupNo) then
                Error(Text003,SerialNoInfo.FieldCaption("Serial No."),LookupNo);
              Page.RunModal(0,SerialNoInfo);
            end;
          Lookuptype::"Lot No.":
            begin
              if not LotNoInfo.Get(ItemNo,Variant,LookupNo) then
                Error(Text003,LotNoInfo.FieldCaption("Lot No."),LookupNo);
              Page.RunModal(0,LotNoInfo);
            end;
        end;
    end;


    procedure CreateTrackingSpecification(var FromReservEntry: Record "Reservation Entry";var ToTrackingSpecification: Record "Tracking Specification")
    begin
        ToTrackingSpecification.Init;
        ToTrackingSpecification.TransferFields(FromReservEntry);
        ToTrackingSpecification."Qty. to Handle (Base)" := 0;
        ToTrackingSpecification."Qty. to Invoice (Base)" := 0;
        ToTrackingSpecification."Quantity Handled (Base)" := FromReservEntry."Qty. to Handle (Base)";
        ToTrackingSpecification."Quantity Invoiced (Base)" := FromReservEntry."Qty. to Invoice (Base)";
    end;


    procedure GetItemTrackingSettings(var ItemTrackingCode: Record "Item Tracking Code";EntryType: Option Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";Inbound: Boolean;var SNRequired: Boolean;var LotRequired: Boolean;var SNInfoRequired: Boolean;var LotInfoRequired: Boolean)
    begin
        SNRequired := false;
        LotRequired := false;
        SNInfoRequired := false;
        LotInfoRequired := false;

        if ItemTrackingCode.Code = '' then begin
          Clear(ItemTrackingCode);
          exit;
        end;
        ItemTrackingCode.Get(ItemTrackingCode.Code);

        if EntryType = Entrytype::Transfer then begin
          LotInfoRequired := ItemTrackingCode."Lot Info. Outbound Must Exist" or ItemTrackingCode."Lot Info. Inbound Must Exist";
          SNInfoRequired := ItemTrackingCode."SN Info. Outbound Must Exist" or ItemTrackingCode."SN Info. Inbound Must Exist";
        end else begin
          SNInfoRequired := (Inbound and ItemTrackingCode."SN Info. Inbound Must Exist") or
            (not Inbound and ItemTrackingCode."SN Info. Outbound Must Exist");

          LotInfoRequired := (Inbound and ItemTrackingCode."Lot Info. Inbound Must Exist") or
            (not Inbound and ItemTrackingCode."Lot Info. Outbound Must Exist");
        end;

        if ItemTrackingCode."SN Specific Tracking" then begin
          SNRequired := true;
        end else
          case EntryType of
            Entrytype::Purchase:
              if Inbound then
                SNRequired := ItemTrackingCode."SN Purchase Inbound Tracking"
              else
                SNRequired := ItemTrackingCode."SN Purchase Outbound Tracking";
            Entrytype::Sale:
              if Inbound then
                SNRequired := ItemTrackingCode."SN Sales Inbound Tracking"
              else
                SNRequired := ItemTrackingCode."SN Sales Outbound Tracking";
            Entrytype::"Positive Adjmt.":
              if Inbound then
                SNRequired := ItemTrackingCode."SN Pos. Adjmt. Inb. Tracking"
              else
                SNRequired := ItemTrackingCode."SN Pos. Adjmt. Outb. Tracking";
            Entrytype::"Negative Adjmt.":
              if Inbound then
                SNRequired := ItemTrackingCode."SN Neg. Adjmt. Inb. Tracking"
              else
                SNRequired := ItemTrackingCode."SN Neg. Adjmt. Outb. Tracking";
            Entrytype::Transfer:
              SNRequired := ItemTrackingCode."SN Transfer Tracking";
            Entrytype::Consumption,Entrytype::Output:
              if Inbound then
                SNRequired := ItemTrackingCode."SN Manuf. Inbound Tracking"
              else
                SNRequired := ItemTrackingCode."SN Manuf. Outbound Tracking";
            Entrytype::"Assembly Consumption",Entrytype::"Assembly Output":
              if Inbound then
                SNRequired := ItemTrackingCode."SN Assembly Inbound Tracking"
              else
                SNRequired := ItemTrackingCode."SN Assembly Outbound Tracking";
          end;

        if ItemTrackingCode."Lot Specific Tracking" then begin
          LotRequired := true;
        end else
          case EntryType of
            Entrytype::Purchase:
              if Inbound then
                LotRequired := ItemTrackingCode."Lot Purchase Inbound Tracking"
              else
                LotRequired := ItemTrackingCode."Lot Purchase Outbound Tracking";
            Entrytype::Sale:
              if Inbound then
                LotRequired := ItemTrackingCode."Lot Sales Inbound Tracking"
              else
                LotRequired := ItemTrackingCode."Lot Sales Outbound Tracking";
            Entrytype::"Positive Adjmt.":
              if Inbound then
                LotRequired := ItemTrackingCode."Lot Pos. Adjmt. Inb. Tracking"
              else
                LotRequired := ItemTrackingCode."Lot Pos. Adjmt. Outb. Tracking";
            Entrytype::"Negative Adjmt.":
              if Inbound then
                LotRequired := ItemTrackingCode."Lot Neg. Adjmt. Inb. Tracking"
              else
                LotRequired := ItemTrackingCode."Lot Neg. Adjmt. Outb. Tracking";
            Entrytype::Transfer:
              LotRequired := ItemTrackingCode."Lot Transfer Tracking";
            Entrytype::Consumption,Entrytype::Output:
              if Inbound then
                LotRequired := ItemTrackingCode."Lot Manuf. Inbound Tracking"
              else
                LotRequired := ItemTrackingCode."Lot Manuf. Outbound Tracking";
            Entrytype::"Assembly Consumption",Entrytype::"Assembly Output":
              if Inbound then
                LotRequired := ItemTrackingCode."Lot Assembly Inbound Tracking"
              else
                LotRequired := ItemTrackingCode."Lot Assembly Outbound Tracking";
          end;
    end;


    procedure RetrieveInvoiceSpecification(SourceSpecification: Record "Tracking Specification";var TempInvoicingSpecification: Record "Tracking Specification" temporary) OK: Boolean
    var
        TrackingSpecification: Record "Tracking Specification";
        TotalQtyToInvoiceBase: Decimal;
    begin
        OK := false;
        TempInvoicingSpecification.Reset;
        TempInvoicingSpecification.DeleteAll;

        // TrackingSpecification contains information about lines that should be invoiced:

        TrackingSpecification.SetCurrentkey("Source ID","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line","Source Ref. No.");

        TrackingSpecification.SetRange("Source Type",SourceSpecification."Source Type");
        TrackingSpecification.SetRange("Source Subtype",SourceSpecification."Source Subtype");
        TrackingSpecification.SetRange("Source ID",SourceSpecification."Source ID");
        TrackingSpecification.SetRange("Source Batch Name",SourceSpecification."Source Batch Name");
        TrackingSpecification.SetRange("Source Prod. Order Line",SourceSpecification."Source Prod. Order Line");
        TrackingSpecification.SetRange("Source Ref. No.",SourceSpecification."Source Ref. No.");
        if TrackingSpecification.FindSet then
          repeat
            TrackingSpecification.TestField("Qty. to Handle (Base)",0);
            TrackingSpecification.TestField("Qty. to Handle",0);
            if not TrackingSpecification.Correction then begin
              TempInvoicingSpecification := TrackingSpecification;
              TempInvoicingSpecification."Qty. to Invoice" :=
                ROUND(TempInvoicingSpecification."Qty. to Invoice (Base)" /
                  SourceSpecification."Qty. per Unit of Measure",0.00001);
              TotalQtyToInvoiceBase += TempInvoicingSpecification."Qty. to Invoice (Base)";
              TempInvoicingSpecification.Insert;
            end;
          until TrackingSpecification.Next = 0;

        if SourceSpecification."Qty. to Invoice (Base)" <> 0 then begin
          if TempInvoicingSpecification.FindFirst then begin
            if (TotalQtyToInvoiceBase <>
                SourceSpecification."Qty. to Invoice (Base)" - SourceSpecification."Qty. to Handle (Base)") and
               (TotalQtyToInvoiceBase <> 0) and
               not IsConsume
            then
              Error(Text001,Text010);
            OK := true;
          end;
        end;
        TempInvoicingSpecification.SetFilter("Qty. to Invoice (Base)",'<>0');
        if not TempInvoicingSpecification.FindFirst then
          TempInvoicingSpecification.Init;
    end;


    procedure RetrieveInvoiceSpecWithService(SourceSpecification: Record "Tracking Specification";var TempInvoicingSpecification: Record "Tracking Specification" temporary;Consume: Boolean) OK: Boolean
    begin
        IsConsume := Consume;
        OK := RetrieveInvoiceSpecification(SourceSpecification,TempInvoicingSpecification);
    end;


    procedure RetrieveItemTracking(ItemJnlLine: Record "Item Journal Line";var TempHandlingSpecification: Record "Tracking Specification" temporary): Boolean
    var
        ReservEntry: Record "Reservation Entry";
    begin
        exit(RetrieveItemTrackingFromReservEntry(ItemJnlLine,ReservEntry,TempHandlingSpecification));
    end;


    procedure RetrieveItemTrackingFromReservEntry(ItemJnlLine: Record "Item Journal Line";var ReservEntry: Record "Reservation Entry";var TempTrackingSpec: Record "Tracking Specification" temporary): Boolean
    begin
        if ItemJnlLine.Subcontracting then
          exit(RetrieveSubcontrItemTracking(ItemJnlLine,TempTrackingSpec));

        ReservEntry.SetCurrentkey(
          "Source ID","Source Ref. No.","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line");
        ReservEntry.SetRange("Source ID",ItemJnlLine."Journal Template Name");
        ReservEntry.SetRange("Source Ref. No.",ItemJnlLine."Line No.");
        ReservEntry.SetRange("Source Type",Database::"Item Journal Line");
        ReservEntry.SetRange("Source Subtype",ItemJnlLine."Entry Type");
        ReservEntry.SetRange("Source Batch Name",ItemJnlLine."Journal Batch Name");
        ReservEntry.SetRange("Source Prod. Order Line",0);
        ReservEntry.SetFilter("Qty. to Handle (Base)",'<>0');

        if SumUpItemTracking(ReservEntry,TempTrackingSpec,false,true) then begin
          ReservEntry.SetRange("Reservation Status",ReservEntry."reservation status"::Prospect);
          if not ReservEntry.IsEmpty then
            ReservEntry.DeleteAll;
          exit(true);
        end;
        exit(false);
    end;

    local procedure RetrieveSubcontrItemTracking(ItemJnlLine: Record "Item Journal Line";var TempHandlingSpecification: Record "Tracking Specification" temporary): Boolean
    var
        ReservEntry: Record "Reservation Entry";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
    begin
        if not ItemJnlLine.Subcontracting then
          exit(false);

        if ItemJnlLine."Operation No." = '' then
          exit(false);

        ItemJnlLine.TestField("Routing No.");
        ItemJnlLine.TestField("Order Type",ItemJnlLine."order type"::Production);
        if not ProdOrderRtngLine.Get(
             ProdOrderRtngLine.Status::Released,ItemJnlLine."Order No.",
             ItemJnlLine."Routing Reference No.",ItemJnlLine."Routing No.",ItemJnlLine."Operation No.")
        then
          exit(false);
        if not (ProdOrderRtngLine."Next Operation No." = '') then
          exit(false);

        ReservEntry.SetCurrentkey(
          "Source ID","Source Ref. No.","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line");
        ReservEntry.SetRange("Source ID",ItemJnlLine."Order No.");
        ReservEntry.SetRange("Source Ref. No.",0);
        ReservEntry.SetRange("Source Type",Database::"Prod. Order Line");
        ReservEntry.SetRange("Source Subtype",3);
        ReservEntry.SetRange("Source Batch Name",'');
        ReservEntry.SetRange("Source Prod. Order Line",ItemJnlLine."Order Line No.");
        ReservEntry.SetFilter("Qty. to Handle (Base)",'<>0');

        if SumUpItemTracking(ReservEntry,TempHandlingSpecification,false,true) then begin
          ReservEntry.SetRange("Reservation Status",ReservEntry."reservation status"::Prospect);
          if not ReservEntry.IsEmpty then
            ReservEntry.DeleteAll;
          exit(true);
        end;
        exit(false);
    end;


    procedure RetrieveConsumpItemTracking(ItemJnlLine: Record "Item Journal Line";var TempHandlingSpecification: Record "Tracking Specification" temporary): Boolean
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ItemJnlLine.TestField("Order Type",ItemJnlLine."order type"::Production);
        ReservEntry.SetCurrentkey(
          "Source ID","Source Ref. No.","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line");
        ReservEntry.SetRange("Source ID",ItemJnlLine."Order No.");
        if ItemJnlLine."Prod. Order Comp. Line No." <> 0 then
          ReservEntry.SetRange("Source Ref. No.",ItemJnlLine."Prod. Order Comp. Line No.");
        ReservEntry.SetRange("Source Type",Database::"Prod. Order Component");
        ReservEntry.SetRange("Source Subtype",3); // Released
        ReservEntry.SetRange("Source Batch Name",'');
        ReservEntry.SetRange("Source Prod. Order Line",ItemJnlLine."Order Line No.");
        ReservEntry.SetFilter("Qty. to Handle (Base)",'<>0');
        ReservEntry.SetRange("Serial No.",ItemJnlLine."Serial No.");
        ReservEntry.SetRange("Lot No.",ItemJnlLine."Lot No.");

        // Sum up in a temporary table per component line:
        exit(SumUpItemTracking(ReservEntry,TempHandlingSpecification,true,true));
    end;


    procedure SumUpItemTracking(var ReservEntry: Record "Reservation Entry";var TempHandlingSpecification: Record "Tracking Specification" temporary;SumPerLine: Boolean;SumPerLotSN: Boolean): Boolean
    var
        NextEntryNo: Integer;
        ExpDate: Date;
        EntriesExist: Boolean;
    begin
        // Sum up Item Tracking in a temporary table (to defragment the ReservEntry records)
        TempHandlingSpecification.Reset;
        TempHandlingSpecification.DeleteAll;
        if SumPerLotSN then
          TempHandlingSpecification.SetCurrentkey("Lot No.","Serial No.");

        if ReservEntry.FindSet then
          repeat
            if ReservEntry.TrackingExists then begin
              if SumPerLine then
                TempHandlingSpecification.SetRange("Source Ref. No.",ReservEntry."Source Ref. No."); // Sum up line per line
              if SumPerLotSN then begin
                TempHandlingSpecification.SetRange("Serial No.",ReservEntry."Serial No.");
                TempHandlingSpecification.SetRange("Lot No.",ReservEntry."Lot No.");
                if ReservEntry."New Serial No." <> '' then
                  TempHandlingSpecification.SetRange("New Serial No.",ReservEntry."New Serial No." );
                if ReservEntry."New Lot No." <> '' then
                  TempHandlingSpecification.SetRange("New Lot No.",ReservEntry."New Lot No.");
              end;
              if TempHandlingSpecification.FindFirst then begin
                TempHandlingSpecification."Quantity (Base)" += ReservEntry."Quantity (Base)";
                TempHandlingSpecification."Qty. to Handle (Base)" += ReservEntry."Qty. to Handle (Base)";
                TempHandlingSpecification."Qty. to Invoice (Base)" += ReservEntry."Qty. to Invoice (Base)";
                TempHandlingSpecification."Quantity Invoiced (Base)" += ReservEntry."Quantity Invoiced (Base)";
                TempHandlingSpecification."Qty. to Handle" :=
                  TempHandlingSpecification."Qty. to Handle (Base)" /
                  ReservEntry."Qty. per Unit of Measure";
                TempHandlingSpecification."Qty. to Invoice" :=
                  TempHandlingSpecification."Qty. to Invoice (Base)" /
                  ReservEntry."Qty. per Unit of Measure";
                if ReservEntry."Reservation Status" > ReservEntry."reservation status"::Tracking then
                  TempHandlingSpecification."Buffer Value1" += // Late Binding
                    TempHandlingSpecification."Qty. to Handle (Base)";
                TempHandlingSpecification.Modify;
              end else begin
                TempHandlingSpecification.Init;
                TempHandlingSpecification.TransferFields(ReservEntry);
                NextEntryNo += 1;
                TempHandlingSpecification."Entry No." := NextEntryNo;
                TempHandlingSpecification."Qty. to Handle" :=
                  TempHandlingSpecification."Qty. to Handle (Base)" /
                  ReservEntry."Qty. per Unit of Measure";
                TempHandlingSpecification."Qty. to Invoice" :=
                  TempHandlingSpecification."Qty. to Invoice (Base)" /
                  ReservEntry."Qty. per Unit of Measure";
                if ReservEntry."Reservation Status" > ReservEntry."reservation status"::Tracking then
                  TempHandlingSpecification."Buffer Value1" += // Late Binding
                    TempHandlingSpecification."Qty. to Handle (Base)";
                ExpDate :=
                  ExistingExpirationDate(
                    ReservEntry."Item No.",ReservEntry."Variant Code",ReservEntry."Lot No.",ReservEntry."Serial No.",false,EntriesExist);
                if EntriesExist then
                  TempHandlingSpecification."Expiration Date" := ExpDate;
                TempHandlingSpecification.Insert;
              end;
            end;
          until ReservEntry.Next = 0;

        TempHandlingSpecification.Reset;
        exit(TempHandlingSpecification.FindFirst);
    end;


    procedure SumUpItemTrackingOnlyInventoryOrATO(var ReservationEntry: Record "Reservation Entry";var TrackingSpecification: Record "Tracking Specification";SumPerLine: Boolean;SumPerLotSN: Boolean): Boolean
    var
        TempReservationEntry: Record "Reservation Entry" temporary;
    begin
        if ReservationEntry.FindSet then
          repeat
            if (ReservationEntry."Reservation Status" <> ReservationEntry."reservation status"::Reservation) or
               IsResEntryReservedAgainstInventory(ReservationEntry)
            then begin
              TempReservationEntry := ReservationEntry;
              TempReservationEntry.Insert;
            end;
          until ReservationEntry.Next = 0;

        exit(SumUpItemTracking(TempReservationEntry,TrackingSpecification,SumPerLine,SumPerLotSN));
    end;

    local procedure IsResEntryReservedAgainstInventory(ReservationEntry: Record "Reservation Entry"): Boolean
    var
        ReservationEntry2: Record "Reservation Entry";
    begin
        if (ReservationEntry."Reservation Status" <> ReservationEntry."reservation status"::Reservation) or
           ReservationEntry.Positive
        then
          exit(false);

        ReservationEntry2.Get(ReservationEntry."Entry No.",not ReservationEntry.Positive);
        if ReservationEntry2."Source Type" = Database::"Item Ledger Entry" then
          exit(true);

        exit(IsResEntryReservedAgainstATO(ReservationEntry));
    end;

    local procedure IsResEntryReservedAgainstATO(ReservationEntry: Record "Reservation Entry"): Boolean
    var
        ReservationEntry2: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        AssembleToOrderLink: Record "Assemble-to-Order Link";
    begin
        if (ReservationEntry."Source Type" <> Database::"Sales Line") or
           (ReservationEntry."Source Subtype" <> SalesLine."document type"::Order) or
           (not SalesLine.Get(ReservationEntry."Source Subtype",ReservationEntry."Source ID",ReservationEntry."Source Ref. No.")) or
           (not AssembleToOrderLink.AsmExistsForSalesLine(SalesLine))
        then
          exit(false);

        ReservationEntry2.Get(ReservationEntry."Entry No.",not ReservationEntry.Positive);
        if (ReservationEntry2."Source Type" <> Database::"Assembly Header") or
           (ReservationEntry2."Source Subtype" <> AssembleToOrderLink."Assembly Document Type") or
           (ReservationEntry2."Source ID" <> AssembleToOrderLink."Assembly Document No.")
        then
          exit(false);

        exit(true);
    end;


    procedure DecomposeRowID(IDtext: Text[250];var StrArray: array [6] of Text[100])
    var
        Len: Integer;
        Pos: Integer;
        ArrayIndex: Integer;
        "Count": Integer;
        Char: Text[1];
        NoWriteSinceLastNext: Boolean;
        Write: Boolean;
        Next: Boolean;
    begin
        for ArrayIndex := 1 to 6 do
          StrArray[ArrayIndex] := '';
        Len := StrLen(IDtext);
        Pos := 1;
        ArrayIndex := 1;

        while not (Pos > Len) do begin
          Char := CopyStr(IDtext,Pos,1);
          if Char = '"' then begin
            Write := false;
            Count += 1;
          end else begin
            if Count = 0 then
              Write := true
            else begin
              if Count MOD 2 = 1 then begin
                Next := (Char = ';');
                Count -= 1;
              end else
                if NoWriteSinceLastNext and (Char = ';') then begin
                  Count -= 2;
                  Next := true;
                end;
              Count /= 2;
              while Count > 0 do begin
                StrArray[ArrayIndex] += '"';
                Count -= 1;
              end;
              Write := not Next;
            end;
            NoWriteSinceLastNext := Next;
          end;

          if Next then begin
            ArrayIndex += 1;
            Next := false
          end;

          if Write then
            StrArray[ArrayIndex] += Char;
          Pos += 1;
        end;
    end;


    procedure ComposeRowID(Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer): Text[250]
    var
        StrArray: array [2] of Text[100];
        Pos: Integer;
        Len: Integer;
        T: Integer;
    begin
        StrArray[1] := ID;
        StrArray[2] := BatchName;
        for T := 1 to 2 do begin
          if StrPos(StrArray[T],'"') > 0 then begin
            Len := StrLen(StrArray[T]);
            Pos := 1;
            repeat
              if CopyStr(StrArray[T],Pos,1) = '"' then begin
                StrArray[T] := InsStr(StrArray[T],'"',Pos + 1);
                Len += 1;
                Pos += 1;
              end;
              Pos += 1;
            until Pos > Len;
          end;
        end;
        exit(StrSubstNo('"%1";"%2";"%3";"%4";"%5";"%6"',Type,Subtype,StrArray[1],StrArray[2],ProdOrderLine,RefNo));
    end;


    procedure CopyItemTracking(FromRowID: Text[250];ToRowID: Text[250];SwapSign: Boolean)
    begin
        CopyItemTracking2(FromRowID,ToRowID,SwapSign,false);
    end;


    procedure CopyItemTracking2(FromRowID: Text[250];ToRowID: Text[250];SwapSign: Boolean;SkipReservation: Boolean)
    var
        ReservEntry: Record "Reservation Entry";
        ReservMgt: Codeunit "Reservation Management";
    begin
        ReservEntry.SetPointer(FromRowID);
        ReservMgt.SetPointerFilter(ReservEntry);
        CopyItemTracking3(ReservEntry,ToRowID,SwapSign,SkipReservation);
    end;

    local procedure CopyItemTracking3(var ReservEntry: Record "Reservation Entry";ToRowID: Text[250];SwapSign: Boolean;SkipReservation: Boolean)
    var
        ReservEntry1: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
    begin
        if SkipReservation then
          ReservEntry.SetFilter("Reservation Status",'<>%1',ReservEntry."reservation status"::Reservation);
        if ReservEntry.FindSet then begin
          repeat
            if ReservEntry.TrackingExists then begin
              TempReservEntry := ReservEntry;
              TempReservEntry."Reservation Status" := TempReservEntry."reservation status"::Prospect;
              TempReservEntry.SetPointer(ToRowID);
              if SwapSign then begin
                TempReservEntry."Quantity (Base)" := -TempReservEntry."Quantity (Base)";
                TempReservEntry.Quantity := -TempReservEntry.Quantity;
                TempReservEntry."Qty. to Handle (Base)" := -TempReservEntry."Qty. to Handle (Base)";
                TempReservEntry."Qty. to Invoice (Base)" := -TempReservEntry."Qty. to Invoice (Base)";
                TempReservEntry."Quantity Invoiced (Base)" := -TempReservEntry."Quantity Invoiced (Base)";
                TempReservEntry.Positive := TempReservEntry."Quantity (Base)" > 0;
                TempReservEntry.ClearApplFromToItemEntry;
              end;
              TempReservEntry.Insert;
            end;
          until ReservEntry.Next = 0;

          ModifyTemp337SetIfTransfer(TempReservEntry);

          if TempReservEntry.FindSet then begin
            ReservEntry1.Reset;
            repeat
              ReservEntry1 := TempReservEntry;
              ReservEntry1."Entry No." := 0;
              ReservEntry1.Insert;
            until TempReservEntry.Next = 0;
          end;
        end;
    end;


    procedure CopyHandledItemTrkgToInvLine(FromSalesLine: Record "Sales Line";ToSalesInvLine: Record "Sales Line")
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        // Used for combined shipment/returns:
        if FromSalesLine.Type <> FromSalesLine.Type::Item then
          exit;

        ItemEntryRelation.SetCurrentkey("Source ID","Source Type","Source Subtype","Source Ref. No.");
        ItemEntryRelation.SetRange("Source Subtype",0);
        ItemEntryRelation.SetRange("Source Batch Name",'');
        ItemEntryRelation.SetRange("Source Prod. Order Line",0);

        case ToSalesInvLine."Document Type" of
          ToSalesInvLine."document type"::Invoice:
            begin
              ItemEntryRelation.SetRange("Source Type",Database::"Sales Shipment Line");
              ItemEntryRelation.SetRange("Source ID",ToSalesInvLine."Shipment No.");
              ItemEntryRelation.SetRange("Source Ref. No.",ToSalesInvLine."Shipment Line No.");
            end;
          ToSalesInvLine."document type"::"Credit Memo":
            begin
              ItemEntryRelation.SetRange("Source Type",Database::"Return Receipt Line");
              ItemEntryRelation.SetRange("Source ID",ToSalesInvLine."Return Receipt No.");
              ItemEntryRelation.SetRange("Source Ref. No.",ToSalesInvLine."Return Receipt Line No.");
            end;
          else
            ToSalesInvLine.FieldError("Document Type",Format(ToSalesInvLine."Document Type"));
        end;

        InsertProspectReservEntryFromItemEntryRelationAndSourceData(
          ItemEntryRelation,ToSalesInvLine."Document Type",ToSalesInvLine."Document No.",ToSalesInvLine."Line No.");
    end;


    procedure CopyHandledItemTrkgToInvLine2(FromPurchLine: Record "Purchase Line";ToPurchInvLine: Record "Purchase Line")
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        // Used for combined receipts/returns:
        if FromPurchLine.Type <> FromPurchLine.Type::Item then
          exit;

        ItemEntryRelation.SetCurrentkey("Source ID","Source Type","Source Subtype","Source Ref. No.");
        ItemEntryRelation.SetRange("Source Subtype",0);
        ItemEntryRelation.SetRange("Source Batch Name",'');
        ItemEntryRelation.SetRange("Source Prod. Order Line",0);

        case ToPurchInvLine."Document Type" of
          ToPurchInvLine."document type"::Invoice:
            begin
              ItemEntryRelation.SetRange("Source Type",Database::"Purch. Rcpt. Line");
              ItemEntryRelation.SetRange("Source ID",ToPurchInvLine."Receipt No.");
              ItemEntryRelation.SetRange("Source Ref. No.",ToPurchInvLine."Receipt Line No.");
            end;
          ToPurchInvLine."document type"::"Credit Memo":
            begin
              ItemEntryRelation.SetRange("Source Type",Database::"Return Shipment Line");
              ItemEntryRelation.SetRange("Source ID",ToPurchInvLine."Return Shipment No.");
              ItemEntryRelation.SetRange("Source Ref. No.",ToPurchInvLine."Return Shipment Line No.");
            end;
          else
            ToPurchInvLine.FieldError("Document Type",Format(ToPurchInvLine."Document Type"));
        end;

        InsertProspectReservEntryFromItemEntryRelationAndSourceData(
          ItemEntryRelation,ToPurchInvLine."Document Type",ToPurchInvLine."Document No.",ToPurchInvLine."Line No.");
    end;


    procedure CopyHandledItemTrkgToServLine(FromServLine: Record "Service Line";ToServLine: Record "Service Line")
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        // Used for combined shipment/returns:
        if FromServLine.Type <> FromServLine.Type::Item then
          exit;

        ItemEntryRelation.SetCurrentkey("Source ID","Source Type","Source Subtype","Source Ref. No.");
        ItemEntryRelation.SetRange("Source Subtype",0);
        ItemEntryRelation.SetRange("Source Batch Name",'');
        ItemEntryRelation.SetRange("Source Prod. Order Line",0);

        case ToServLine."Document Type" of
          ToServLine."document type"::Invoice:
            begin
              ItemEntryRelation.SetRange("Source Type",Database::"Service Shipment Line");
              ItemEntryRelation.SetRange("Source ID",ToServLine."Shipment No.");
              ItemEntryRelation.SetRange("Source Ref. No.",ToServLine."Shipment Line No.");
            end;
          else
            ToServLine.FieldError("Document Type",Format(ToServLine."Document Type"));
        end;

        InsertProspectReservEntryFromItemEntryRelationAndSourceData(
          ItemEntryRelation,ToServLine."Document Type",ToServLine."Document No.",ToServLine."Line No.");
    end;


    procedure CollectItemEntryRelation(var TempItemLedgEntry: Record "Item Ledger Entry" temporary;SourceType: Integer;SourceSubtype: Option "0","1","2","3","4","5","6","7","8","9","10";SourceID: Code[20];SourceBatchName: Code[10];SourceProdOrderLine: Integer;SourceRefNo: Integer;TotalQty: Decimal): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemEntryRelation: Record "Item Entry Relation";
        Quantity: Decimal;
    begin
        Quantity := 0;
        TempItemLedgEntry.Reset;
        TempItemLedgEntry.DeleteAll;
        ItemEntryRelation.SetCurrentkey("Source ID","Source Type");
        ItemEntryRelation.SetRange("Source Type",SourceType);
        ItemEntryRelation.SetRange("Source Subtype",SourceSubtype);
        ItemEntryRelation.SetRange("Source ID",SourceID);
        ItemEntryRelation.SetRange("Source Batch Name",SourceBatchName);
        ItemEntryRelation.SetRange("Source Prod. Order Line",SourceProdOrderLine);
        ItemEntryRelation.SetRange("Source Ref. No.",SourceRefNo);
        if ItemEntryRelation.FindSet then
          repeat
            ItemLedgEntry.Get(ItemEntryRelation."Item Entry No.");
            TempItemLedgEntry := ItemLedgEntry;
            TempItemLedgEntry.Insert;
            Quantity := Quantity + ItemLedgEntry.Quantity;
          until ItemEntryRelation.Next = 0;
        exit(Quantity = TotalQty);
    end;


    procedure IsOrderNetworkEntity(Type: Integer;Subtype: Integer): Boolean
    begin
        case Type of
          Database::"Sales Line":
            exit(Subtype in [1,5]);
          Database::"Purchase Line":
            exit(Subtype in [1,5]);
          Database::"Prod. Order Line":
            exit(Subtype in [2,3]);
          Database::"Prod. Order Component":
            exit(Subtype in [2,3]);
          Database::"Assembly Header":
            exit(Subtype in [1]);
          Database::"Assembly Line":
            exit(Subtype in [1]);
          Database::"Transfer Line":
            exit(true);
          Database::"Service Line":
            exit(Subtype in [1]);
          else
            exit(false);
        end;
    end;


    procedure DeleteItemEntryRelation(SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceBatchName: Code[10];SourceProdOrderLine: Integer;SourceRefNo: Integer;DeleteAllDocLines: Boolean)
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        ItemEntryRelation.SetCurrentkey("Source ID","Source Type");
        ItemEntryRelation.SetRange("Source Type",SourceType);
        ItemEntryRelation.SetRange("Source Subtype",SourceSubtype);
        ItemEntryRelation.SetRange("Source ID",SourceID);
        ItemEntryRelation.SetRange("Source Batch Name",SourceBatchName);
        ItemEntryRelation.SetRange("Source Prod. Order Line",SourceProdOrderLine);
        if not DeleteAllDocLines then
          ItemEntryRelation.SetRange("Source Ref. No.",SourceRefNo);
        if not ItemEntryRelation.IsEmpty then
          ItemEntryRelation.DeleteAll;
    end;


    procedure DeleteValueEntryRelation(RowID: Text[100])
    var
        ValueEntryRelation: Record "Value Entry Relation";
    begin
        ValueEntryRelation.SetCurrentkey("Source RowId");
        ValueEntryRelation.SetRange("Source RowId",RowID);
        if not ValueEntryRelation.IsEmpty then
          ValueEntryRelation.DeleteAll;
    end;


    procedure FindInInventory(ItemNo: Code[20];VariantCode: Code[20];SerialNo: Code[20]): Boolean
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentkey("Item No.",Open,"Variant Code",Positive);
        ItemLedgerEntry.SetRange("Item No.",ItemNo);
        ItemLedgerEntry.SetRange(Open,true);
        ItemLedgerEntry.SetRange("Variant Code",VariantCode);
        ItemLedgerEntry.SetRange(Positive,true);
        if SerialNo <> '' then
          ItemLedgerEntry.SetRange("Serial No.",SerialNo);
        exit(ItemLedgerEntry.FindFirst);
    end;


    procedure SplitWhseJnlLine(TempWhseJnlLine: Record "Warehouse Journal Line" temporary;var TempWhseJnlLine2: Record "Warehouse Journal Line" temporary;var TempWhseSplitSpecification: Record "Tracking Specification" temporary;ToTransfer: Boolean)
    var
        NonDistrQtyBase: Decimal;
        NonDistrCubage: Decimal;
        NonDistrWeight: Decimal;
        SplitFactor: Decimal;
        LineNo: Integer;
        WhseSNRequired: Boolean;
        WhseLNRequired: Boolean;
    begin
        TempWhseJnlLine2.DeleteAll;

        CheckWhseItemTrkgSetup(TempWhseJnlLine."Item No.",WhseSNRequired,WhseLNRequired,false);
        if not (WhseSNRequired or WhseLNRequired) then begin
          TempWhseJnlLine2 := TempWhseJnlLine;
          TempWhseJnlLine2.Insert;
          exit;
        end;

        LineNo := TempWhseJnlLine."Line No.";
        with TempWhseSplitSpecification do begin
          Reset;
          SetCurrentkey(
            "Source ID","Source Type","Source Subtype","Source Batch Name",
            "Source Prod. Order Line","Source Ref. No.");
          case TempWhseJnlLine."Source Type" of
            Database::"Item Journal Line",
            Database::"Job Journal Line":
              begin
                SetRange("Source Type",TempWhseJnlLine."Source Type");
                SetRange("Source ID",TempWhseJnlLine."Journal Template Name");
                SetRange("Source Ref. No.",TempWhseJnlLine."Source Line No.");
              end;
            0: // Whse. journal line
              begin
                SetRange("Source Type",Database::"Warehouse Journal Line");
                SetRange("Source ID",TempWhseJnlLine."Journal Batch Name");
                SetRange("Source Ref. No.",TempWhseJnlLine."Line No.");
              end;
            else begin
              SetRange("Source Type",TempWhseJnlLine."Source Type");
              SetRange("Source ID",TempWhseJnlLine."Source No.");
              SetRange("Source Ref. No.",TempWhseJnlLine."Source Line No.");
            end;
          end;
          SetFilter("Quantity actual Handled (Base)",'<>%1',0);
          NonDistrQtyBase := TempWhseJnlLine."Qty. (Absolute, Base)";
          NonDistrCubage := TempWhseJnlLine.Cubage;
          NonDistrWeight := TempWhseJnlLine.Weight;
          if FindSet then
            repeat
              LineNo += 10000;
              TempWhseJnlLine2 := TempWhseJnlLine;
              TempWhseJnlLine2."Line No." := LineNo;

              if "Serial No." <> '' then
                if Abs("Quantity (Base)") <> 1 then
                  FieldError("Quantity (Base)");

              if ToTransfer then begin
                SetWhseSerialLotNo(TempWhseJnlLine2."Serial No.","New Serial No.",WhseSNRequired);
                SetWhseSerialLotNo(TempWhseJnlLine2."Lot No.","New Lot No.",WhseLNRequired);
                if "New Expiration Date" <> 0D then
                  TempWhseJnlLine2."Expiration Date" := "New Expiration Date"
              end else begin
                SetWhseSerialLotNo(TempWhseJnlLine2."Serial No.","Serial No.",WhseSNRequired);
                SetWhseSerialLotNo(TempWhseJnlLine2."Lot No.","Lot No.",WhseLNRequired);
                TempWhseJnlLine2."Expiration Date" := "Expiration Date";
              end;
              SetWhseSerialLotNo(TempWhseJnlLine2."New Serial No.","New Serial No.",WhseSNRequired);
              SetWhseSerialLotNo(TempWhseJnlLine2."New Lot No.","New Lot No.",WhseLNRequired);
              TempWhseJnlLine2."New Expiration Date" := "New Expiration Date";
              TempWhseJnlLine2."Warranty Date" := "Warranty Date";
              TempWhseJnlLine2."Qty. (Absolute, Base)" := Abs("Quantity (Base)");
              TempWhseJnlLine2."Qty. (Absolute)" :=
                ROUND(TempWhseJnlLine2."Qty. (Absolute, Base)" / TempWhseJnlLine."Qty. per Unit of Measure",0.00001);
              if TempWhseJnlLine.Quantity > 0 then begin
                TempWhseJnlLine2."Qty. (Base)" := TempWhseJnlLine2."Qty. (Absolute, Base)";
                TempWhseJnlLine2.Quantity := TempWhseJnlLine2."Qty. (Absolute)";
              end else begin
                TempWhseJnlLine2."Qty. (Base)" := -TempWhseJnlLine2."Qty. (Absolute, Base)";
                TempWhseJnlLine2.Quantity := -TempWhseJnlLine2."Qty. (Absolute)";
              end;
              SplitFactor := "Quantity (Base)" / NonDistrQtyBase;
              if SplitFactor < 1 then begin
                TempWhseJnlLine2.Cubage := ROUND(NonDistrCubage * SplitFactor,0.00001);
                TempWhseJnlLine2.Weight := ROUND(NonDistrWeight * SplitFactor,0.00001);
                NonDistrQtyBase -= "Quantity (Base)";
                NonDistrCubage -= TempWhseJnlLine2.Cubage;
                NonDistrWeight -= TempWhseJnlLine2.Weight;
              end else begin // the last record
                TempWhseJnlLine2.Cubage := NonDistrCubage;
                TempWhseJnlLine2.Weight := NonDistrWeight;
              end;
              TempWhseJnlLine2.Insert;
            until Next = 0
          else begin
            TempWhseJnlLine2 := TempWhseJnlLine;
            TempWhseJnlLine2.Insert;
          end;
        end;
    end;


    procedure SplitPostedWhseRcptLine(PostedWhseRcptLine: Record "Posted Whse. Receipt Line";var TempPostedWhseRcptlLine: Record "Posted Whse. Receipt Line" temporary)
    var
        WhseItemEntryRelation: Record "Whse. Item Entry Relation";
        ItemLedgEntry: Record "Item Ledger Entry";
        LineNo: Integer;
        WhseSNRequired: Boolean;
        WhseLNRequired: Boolean;
        CrossDockQty: Decimal;
        CrossDockQtyBase: Decimal;
    begin
        TempPostedWhseRcptlLine.Reset;
        TempPostedWhseRcptlLine.DeleteAll;

        CheckWhseItemTrkgSetup(PostedWhseRcptLine."Item No.",WhseSNRequired,WhseLNRequired,false);
        if not (WhseSNRequired or WhseLNRequired) then begin
          TempPostedWhseRcptlLine := PostedWhseRcptLine;
          TempPostedWhseRcptlLine.Insert;
          exit;
        end;

        WhseItemEntryRelation.Reset;
        WhseItemEntryRelation.SetCurrentkey(
          "Source ID","Source Type","Source Subtype","Source Ref. No.");
        WhseItemEntryRelation.SetRange("Source ID",PostedWhseRcptLine."No.");
        WhseItemEntryRelation.SetRange("Source Type",Database::"Posted Whse. Receipt Line");
        WhseItemEntryRelation.SetRange("Source Subtype",0);
        WhseItemEntryRelation.SetRange("Source Ref. No.",PostedWhseRcptLine."Line No.");
        if WhseItemEntryRelation.FindSet then begin
          repeat
            ItemLedgEntry.Get(WhseItemEntryRelation."Item Entry No.");
            TempPostedWhseRcptlLine.SetRange("Serial No.",ItemLedgEntry."Serial No.");
            TempPostedWhseRcptlLine.SetRange("Lot No.",ItemLedgEntry."Lot No.");
            TempPostedWhseRcptlLine.SetRange("Warranty Date",ItemLedgEntry."Warranty Date");
            TempPostedWhseRcptlLine.SetRange("Expiration Date",ItemLedgEntry."Expiration Date");
            if TempPostedWhseRcptlLine.FindFirst then begin
              TempPostedWhseRcptlLine."Qty. (Base)" += ItemLedgEntry.Quantity;
              TempPostedWhseRcptlLine.Quantity :=
                ROUND(TempPostedWhseRcptlLine."Qty. (Base)" / TempPostedWhseRcptlLine."Qty. per Unit of Measure",0.00001);
              TempPostedWhseRcptlLine.Modify;

              CrossDockQty := CrossDockQty - TempPostedWhseRcptlLine."Qty. Cross-Docked";
              CrossDockQtyBase := CrossDockQtyBase - TempPostedWhseRcptlLine."Qty. Cross-Docked (Base)";
            end else begin
              LineNo += 10000;
              TempPostedWhseRcptlLine.Reset;
              TempPostedWhseRcptlLine := PostedWhseRcptLine;
              TempPostedWhseRcptlLine."Line No." := LineNo;
              TempPostedWhseRcptlLine."Serial No." := WhseItemEntryRelation."Serial No.";
              TempPostedWhseRcptlLine."Lot No." := WhseItemEntryRelation."Lot No.";
              TempPostedWhseRcptlLine."Warranty Date" := ItemLedgEntry."Warranty Date";
              TempPostedWhseRcptlLine."Expiration Date" := ItemLedgEntry."Expiration Date";
              TempPostedWhseRcptlLine."Qty. (Base)" := ItemLedgEntry.Quantity;
              TempPostedWhseRcptlLine.Quantity :=
                ROUND(TempPostedWhseRcptlLine."Qty. (Base)" / TempPostedWhseRcptlLine."Qty. per Unit of Measure",0.00001);
              TempPostedWhseRcptlLine.Insert;
            end;

            if WhseSNRequired then begin
              if CrossDockQty < PostedWhseRcptLine."Qty. Cross-Docked" then begin
                TempPostedWhseRcptlLine."Qty. Cross-Docked" := TempPostedWhseRcptlLine.Quantity;
                TempPostedWhseRcptlLine."Qty. Cross-Docked (Base)" := TempPostedWhseRcptlLine."Qty. (Base)";
              end else begin
                TempPostedWhseRcptlLine."Qty. Cross-Docked" := 0;
                TempPostedWhseRcptlLine."Qty. Cross-Docked (Base)" := 0;
              end;
              CrossDockQty := CrossDockQty + TempPostedWhseRcptlLine.Quantity;
            end else
              if PostedWhseRcptLine."Qty. Cross-Docked" > 0 then begin
                if TempPostedWhseRcptlLine.Quantity <=
                   PostedWhseRcptLine."Qty. Cross-Docked" - CrossDockQty
                then begin
                  TempPostedWhseRcptlLine."Qty. Cross-Docked" := TempPostedWhseRcptlLine.Quantity;
                  TempPostedWhseRcptlLine."Qty. Cross-Docked (Base)" := TempPostedWhseRcptlLine."Qty. (Base)";
                end else begin
                  TempPostedWhseRcptlLine."Qty. Cross-Docked" := PostedWhseRcptLine."Qty. Cross-Docked" - CrossDockQty;
                  TempPostedWhseRcptlLine."Qty. Cross-Docked (Base)" :=
                    PostedWhseRcptLine."Qty. Cross-Docked (Base)" - CrossDockQtyBase;
                end;
                CrossDockQty := CrossDockQty + TempPostedWhseRcptlLine."Qty. Cross-Docked";
                CrossDockQtyBase := CrossDockQtyBase + TempPostedWhseRcptlLine."Qty. Cross-Docked (Base)";
                if CrossDockQty >= PostedWhseRcptLine."Qty. Cross-Docked" then begin
                  PostedWhseRcptLine."Qty. Cross-Docked" := 0;
                  PostedWhseRcptLine."Qty. Cross-Docked (Base)" := 0;
                end;
              end;
            TempPostedWhseRcptlLine.Modify;
          until WhseItemEntryRelation.Next = 0;
        end else begin
          TempPostedWhseRcptlLine := PostedWhseRcptLine;
          TempPostedWhseRcptlLine.Insert;
        end
    end;


    procedure SplitInternalPutAwayLine(PostedWhseRcptLine: Record "Posted Whse. Receipt Line";var TempPostedWhseRcptlLine: Record "Posted Whse. Receipt Line" temporary)
    var
        WhseItemTrackingLine: Record "Whse. Item Tracking Line";
        LineNo: Integer;
        WhseSNRequired: Boolean;
        WhseLNRequired: Boolean;
    begin
        TempPostedWhseRcptlLine.DeleteAll;

        CheckWhseItemTrkgSetup(PostedWhseRcptLine."Item No.",WhseSNRequired,WhseLNRequired,false);
        if not (WhseSNRequired or WhseLNRequired) then begin
          TempPostedWhseRcptlLine := PostedWhseRcptLine;
          TempPostedWhseRcptlLine.Insert;
          exit;
        end;

        WhseItemTrackingLine.Reset;
        WhseItemTrackingLine.SetCurrentkey(
          "Source ID","Source Type","Source Subtype","Source Batch Name",
          "Source Prod. Order Line","Source Ref. No.");
        WhseItemTrackingLine.SetRange("Source Type",Database::"Whse. Internal Put-away Line");
        WhseItemTrackingLine.SetRange("Source ID",PostedWhseRcptLine."No.");
        WhseItemTrackingLine.SetRange("Source Subtype",0);
        WhseItemTrackingLine.SetRange("Source Batch Name",'');
        WhseItemTrackingLine.SetRange("Source Prod. Order Line",0);
        WhseItemTrackingLine.SetRange("Source Ref. No.",PostedWhseRcptLine."Line No.");
        WhseItemTrackingLine.SetFilter("Qty. to Handle (Base)",'<>0');
        if WhseItemTrackingLine.FindSet then
          repeat
            LineNo += 10000;
            TempPostedWhseRcptlLine := PostedWhseRcptLine;
            TempPostedWhseRcptlLine."Line No." := LineNo;
            TempPostedWhseRcptlLine."Serial No." := WhseItemTrackingLine."Serial No.";
            TempPostedWhseRcptlLine."Lot No." := WhseItemTrackingLine."Lot No.";
            TempPostedWhseRcptlLine."Warranty Date" := WhseItemTrackingLine."Warranty Date";
            TempPostedWhseRcptlLine."Expiration Date" := WhseItemTrackingLine."Expiration Date";
            TempPostedWhseRcptlLine."Qty. (Base)" := WhseItemTrackingLine."Qty. to Handle (Base)";
            TempPostedWhseRcptlLine.Quantity :=
              ROUND(TempPostedWhseRcptlLine."Qty. (Base)" / TempPostedWhseRcptlLine."Qty. per Unit of Measure",0.00001);
            TempPostedWhseRcptlLine.Insert;
          until WhseItemTrackingLine.Next = 0
        else begin
          TempPostedWhseRcptlLine := PostedWhseRcptLine;
          TempPostedWhseRcptlLine.Insert;
        end
    end;


    procedure DeleteWhseItemTrkgLines(SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceBatchName: Code[10];SourceProdOrderLine: Integer;SourceRefNo: Integer;LocationCode: Code[10];RelatedToLine: Boolean)
    var
        WhseItemTrkgLine: Record "Whse. Item Tracking Line";
    begin
        with WhseItemTrkgLine do begin
          Reset;
          SetCurrentkey(
            "Source ID","Source Type","Source Subtype","Source Batch Name",
            "Source Prod. Order Line","Source Ref. No.","Location Code");
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubtype);
          SetRange("Source ID",SourceID);
          if RelatedToLine then begin
            SetRange("Source Prod. Order Line",SourceProdOrderLine);
            SetRange("Source Ref. No.",SourceRefNo);
            SetRange("Source Batch Name",SourceBatchName);
            SetRange("Location Code",LocationCode);
          end;

          if FindSet then
            repeat
              // If the item tracking information was added through a pick registration, the reservation entry needs to
              // be modified/deleted as well in order to remove this item tracking information again.
              if DeleteReservationEntries and
                 "Created by Whse. Activity Line" and
                 ("Source Type" = Database::"Warehouse Shipment Line")
              then
                RemoveItemTrkgFromReservEntry("Source ID","Source Ref. No.","Serial No.","Lot No.");
              Delete;
            until Next = 0;
        end;
    end;

    local procedure RemoveItemTrkgFromReservEntry(SourceID: Code[20];SourceRefNo: Integer;SerialNo: Code[20];LotNo: Code[20])
    var
        ReservEntry: Record "Reservation Entry";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        WarehouseShipmentLine.SetRange("No.",SourceID);
        WarehouseShipmentLine.SetRange("Line No.",SourceRefNo);
        if WarehouseShipmentLine.FindFirst then
          with ReservEntry do begin
            SetCurrentkey("Source ID","Source Ref. No.","Source Type","Source Subtype");
            SetRange("Source Type",WarehouseShipmentLine."Source Type");
            SetRange("Source Subtype",WarehouseShipmentLine."Source Subtype");
            SetRange("Source ID",WarehouseShipmentLine."Source No.");
            SetRange("Source Ref. No.",WarehouseShipmentLine."Source Line No.");
            SetRange("Serial No.",SerialNo);
            SetRange("Lot No.",LotNo);
            if FindSet then
              repeat
                case "Reservation Status" of
                  "reservation status"::Surplus:
                    Delete(true);
                  else begin
                    ClearItemTrackingFields;
                    Modify(true);
                  end;
                end;
              until Next = 0;
          end;
    end;


    procedure SetDeleteReservationEntries(DeleteEntries: Boolean)
    begin
        DeleteReservationEntries := DeleteEntries;
    end;


    procedure InitTrackingSpecification(WhseWkshLine: Record "Whse. Worksheet Line")
    var
        WhseItemTrkgLine: Record "Whse. Item Tracking Line";
        PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";
        TempWhseItemTrkgLine: Record "Whse. Item Tracking Line" temporary;
        WhseManagement: Codeunit "Whse. Management";
        SourceType: Integer;
    begin
        SourceType := WhseManagement.GetSourceType(WhseWkshLine);
        with WhseWkshLine do begin
          if "Whse. Document Type" = "whse. document type"::Receipt then begin
            PostedWhseReceiptLine.SetRange("No.","Whse. Document No.");
            if PostedWhseReceiptLine.FindSet then
              repeat
                InsertWhseItemTrkgLines(PostedWhseReceiptLine,SourceType);
              until PostedWhseReceiptLine.Next = 0;
          end;

          WhseItemTrkgLine.SetCurrentkey(
            "Source ID","Source Type","Source Subtype","Source Batch Name","Source Prod. Order Line","Source Ref. No.");

          WhseItemTrkgLine.SetRange("Source Type",SourceType);
          if SourceType = Database::"Prod. Order Component" then begin
            WhseItemTrkgLine.SetRange("Source Subtype","Source Subtype");
            WhseItemTrkgLine.SetRange("Source ID","Source No.");
            WhseItemTrkgLine.SetRange("Source Prod. Order Line","Source Line No.");
            WhseItemTrkgLine.SetRange("Source Ref. No.","Source Subline No.");
          end else begin
            WhseItemTrkgLine.SetRange("Source ID","Whse. Document No.");
            WhseItemTrkgLine.SetRange("Source Ref. No.","Whse. Document Line No.");
          end;

          WhseItemTrkgLine.LockTable;
          if WhseItemTrkgLine.FindSet then begin
            repeat
              CalcWhseItemTrkgLine(WhseItemTrkgLine);
              WhseItemTrkgLine.Modify;
              if SourceType in [Database::"Prod. Order Component",Database::"Assembly Line"] then begin
                TempWhseItemTrkgLine := WhseItemTrkgLine;
                TempWhseItemTrkgLine.Insert;
              end;
            until WhseItemTrkgLine.Next = 0;
            if not TempWhseItemTrkgLine.IsEmpty then
              CheckWhseItemTrkg(TempWhseItemTrkgLine,WhseWkshLine);
          end else
            case SourceType of
              Database::"Posted Whse. Receipt Line":
                CreateWhseItemTrkgForReceipt(WhseWkshLine);
              Database::"Warehouse Shipment Line":
                CreateWhseItemTrkgBatch(WhseWkshLine);
              Database::"Prod. Order Component":
                CreateWhseItemTrkgBatch(WhseWkshLine);
              Database::"Assembly Line":
                CreateWhseItemTrkgBatch(WhseWkshLine);
            end;
        end;
    end;

    local procedure CreateWhseItemTrkgForReceipt(WhseWkshLine: Record "Whse. Worksheet Line")
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        WhseItemEntryRelation: Record "Whse. Item Entry Relation";
        WhseItemTrackingLine: Record "Whse. Item Tracking Line";
        EntryNo: Integer;
    begin
        with WhseWkshLine do begin
          WhseItemTrackingLine.Reset;
          if WhseItemTrackingLine.FindLast then
            EntryNo := WhseItemTrackingLine."Entry No.";

          WhseItemEntryRelation.SetCurrentkey(
            "Source ID","Source Type","Source Subtype","Source Ref. No.");
          WhseItemEntryRelation.SetRange("Source ID","Whse. Document No.");
          WhseItemEntryRelation.SetRange("Source Type",Database::"Posted Whse. Receipt Line");
          WhseItemEntryRelation.SetRange("Source Subtype",0);
          WhseItemEntryRelation.SetRange("Source Ref. No.","Whse. Document Line No.");
          if WhseItemEntryRelation.FindSet then
            repeat
              WhseItemTrackingLine.Init;
              EntryNo += 1;
              WhseItemTrackingLine."Entry No." := EntryNo;
              WhseItemTrackingLine."Item No." := "Item No.";
              WhseItemTrackingLine."Variant Code" := "Variant Code";
              WhseItemTrackingLine."Location Code" := "Location Code";
              WhseItemTrackingLine.Description := Description;
              WhseItemTrackingLine."Qty. per Unit of Measure" := "Qty. per From Unit of Measure";
              WhseItemTrackingLine."Source Type" := Database::"Posted Whse. Receipt Line";
              WhseItemTrackingLine."Source ID" := "Whse. Document No.";
              WhseItemTrackingLine."Source Ref. No." := "Whse. Document Line No.";
              ItemLedgEntry.Get(WhseItemEntryRelation."Item Entry No.");
              WhseItemTrackingLine."Serial No." := ItemLedgEntry."Serial No.";
              WhseItemTrackingLine."Lot No." := ItemLedgEntry."Lot No.";
              WhseItemTrackingLine."Warranty Date" := ItemLedgEntry."Warranty Date";
              WhseItemTrackingLine."Expiration Date" := ItemLedgEntry."Expiration Date";
              WhseItemTrackingLine."Quantity (Base)" := ItemLedgEntry.Quantity;
              if "Qty. (Base)" = "Qty. to Handle (Base)" then
                WhseItemTrackingLine."Qty. to Handle (Base)" := WhseItemTrackingLine."Quantity (Base)";
              WhseItemTrackingLine."Qty. to Handle" :=
                ROUND(WhseItemTrackingLine."Qty. to Handle (Base)" / WhseItemTrackingLine."Qty. per Unit of Measure",0.00001);
              WhseItemTrackingLine.Insert;
            until WhseItemEntryRelation.Next = 0;
        end;
    end;

    local procedure CreateWhseItemTrkgBatch(WhseWkshLine: Record "Whse. Worksheet Line")
    var
        SourceItemTrackingLine: Record "Reservation Entry";
        WhseManagement: Codeunit "Whse. Management";
        SourceType: Integer;
    begin
        SourceType := WhseManagement.GetSourceType(WhseWkshLine);

        with WhseWkshLine do begin
          SourceItemTrackingLine.SetCurrentkey(
            "Source ID","Source Ref. No.","Source Type","Source Subtype",
            "Source Batch Name","Source Prod. Order Line");
          SourceItemTrackingLine.SetRange("Source ID","Source No.");
          SourceItemTrackingLine.SetRange("Source Type","Source Type");
          SourceItemTrackingLine.SetRange("Source Subtype","Source Subtype");
          SourceItemTrackingLine.SetRange("Source Batch Name",'');
          case SourceType of
            Database::"Prod. Order Component":
              begin
                SourceItemTrackingLine.SetRange("Source Ref. No.","Source Subline No.");
                SourceItemTrackingLine.SetRange("Source Prod. Order Line","Source Line No.");
              end;
            else begin
              SourceItemTrackingLine.SetRange("Source Ref. No.","Source Line No.");
              SourceItemTrackingLine.SetRange("Source Prod. Order Line",0);
            end;
          end;
          if SourceItemTrackingLine.FindSet then
            repeat
              CreateWhseItemTrkgForResEntry(SourceItemTrackingLine,WhseWkshLine);
            until SourceItemTrackingLine.Next = 0;
        end;
    end;


    procedure CreateWhseItemTrkgForResEntry(SourceItemTrackingLine: Record "Reservation Entry";WhseWkshLine: Record "Whse. Worksheet Line")
    var
        WhseItemTrackingLine: Record "Whse. Item Tracking Line";
        WhseManagement: Codeunit "Whse. Management";
        EntryNo: Integer;
        SourceType: Integer;
    begin
        if not ((SourceItemTrackingLine."Reservation Status" <> SourceItemTrackingLine."reservation status"::Reservation) or
                IsResEntryReservedAgainstInventory(SourceItemTrackingLine))
        then
          exit;

        if not SourceItemTrackingLine.TrackingExists then
          exit;

        SourceType := WhseManagement.GetSourceType(WhseWkshLine);

        if WhseItemTrackingLine.FindLast then
          EntryNo := WhseItemTrackingLine."Entry No.";

        WhseItemTrackingLine.Init;

        with WhseWkshLine do
          case SourceType of
            Database::"Posted Whse. Receipt Line":
              begin
                WhseItemTrackingLine."Source Type" := Database::"Posted Whse. Receipt Line";
                WhseItemTrackingLine."Source ID" := "Whse. Document No.";
                WhseItemTrackingLine."Source Ref. No." := "Whse. Document Line No.";
              end;
            Database::"Warehouse Shipment Line":
              begin
                WhseItemTrackingLine."Source Type" := Database::"Warehouse Shipment Line";
                WhseItemTrackingLine."Source ID" := "Whse. Document No.";
                WhseItemTrackingLine."Source Ref. No." := "Whse. Document Line No.";
              end;
            Database::"Assembly Line":
              begin
                WhseItemTrackingLine."Source Type" := Database::"Assembly Line";
                WhseItemTrackingLine."Source ID" := "Whse. Document No.";
                WhseItemTrackingLine."Source Ref. No." := "Whse. Document Line No.";
                WhseItemTrackingLine."Source Subtype" := "Source Subtype";
              end;
            Database::"Prod. Order Component":
              begin
                WhseItemTrackingLine."Source Type" := "Source Type";
                WhseItemTrackingLine."Source Subtype" := "Source Subtype";
                WhseItemTrackingLine."Source ID" := "Source No.";
                WhseItemTrackingLine."Source Prod. Order Line" := "Source Line No.";
                WhseItemTrackingLine."Source Ref. No." := "Source Subline No.";
              end;
          end;

        WhseItemTrackingLine."Entry No." := EntryNo + 1;
        WhseItemTrackingLine."Item No." := SourceItemTrackingLine."Item No.";
        WhseItemTrackingLine."Variant Code" := SourceItemTrackingLine."Variant Code";
        WhseItemTrackingLine."Location Code" := SourceItemTrackingLine."Location Code";
        WhseItemTrackingLine.Description := SourceItemTrackingLine.Description;
        WhseItemTrackingLine."Qty. per Unit of Measure" := SourceItemTrackingLine."Qty. per Unit of Measure";
        WhseItemTrackingLine."Serial No." := SourceItemTrackingLine."Serial No.";
        WhseItemTrackingLine."Lot No." := SourceItemTrackingLine."Lot No.";
        WhseItemTrackingLine."Warranty Date" := SourceItemTrackingLine."Warranty Date";
        WhseItemTrackingLine."Expiration Date" := SourceItemTrackingLine."Expiration Date";
        WhseItemTrackingLine."Quantity (Base)" := -SourceItemTrackingLine."Quantity (Base)";
        if WhseWkshLine."Qty. (Base)" = WhseWkshLine."Qty. to Handle (Base)" then begin
          WhseItemTrackingLine."Qty. to Handle (Base)" := WhseItemTrackingLine."Quantity (Base)";
          WhseItemTrackingLine."Qty. to Handle" := -SourceItemTrackingLine.Quantity;
        end;
        WhseItemTrackingLine.Insert;
    end;


    procedure CalcWhseItemTrkgLine(var WhseItemTrkgLine: Record "Whse. Item Tracking Line")
    var
        WhseActivQtyBase: Decimal;
    begin
        case WhseItemTrkgLine."Source Type" of
          Database::"Posted Whse. Receipt Line":
            WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."source type filter"::Receipt;
          Database::"Whse. Internal Put-away Line":
            WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."source type filter"::"Internal Put-away";
          Database::"Warehouse Shipment Line":
            WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."source type filter"::Shipment;
          Database::"Whse. Internal Pick Line":
            WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."source type filter"::"Internal Pick";
          Database::"Prod. Order Component":
            WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."source type filter"::Production;
          Database::"Assembly Line":
            WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."source type filter"::Assembly;
          Database::"Whse. Worksheet Line":
            WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."source type filter"::"Movement Worksheet";
        end;
        WhseItemTrkgLine.CalcFields("Put-away Qty. (Base)","Pick Qty. (Base)");

        if WhseItemTrkgLine."Put-away Qty. (Base)" > 0 then
          WhseActivQtyBase := WhseItemTrkgLine."Put-away Qty. (Base)";
        if WhseItemTrkgLine."Pick Qty. (Base)" > 0 then
          WhseActivQtyBase := WhseItemTrkgLine."Pick Qty. (Base)";

        if not Registering then
          WhseItemTrkgLine.Validate("Quantity Handled (Base)",
            WhseActivQtyBase + WhseItemTrkgLine."Qty. Registered (Base)")
        else
          WhseItemTrkgLine.Validate("Quantity Handled (Base)",
            WhseItemTrkgLine."Qty. Registered (Base)");

        if WhseItemTrkgLine."Quantity (Base)" >= WhseItemTrkgLine."Quantity Handled (Base)" then
          WhseItemTrkgLine.Validate("Qty. to Handle (Base)",
            WhseItemTrkgLine."Quantity (Base)" - WhseItemTrkgLine."Quantity Handled (Base)");
    end;


    procedure InitItemTrkgForTempWkshLine(WhseDocType: Option;WhseDocNo: Code[20];WhseDocLineNo: Integer;SourceType: Integer;SourceSubtype: Option "0","1","2","3","4","5","6","7","8","9","10";SourceNo: Code[20];SourceLineNo: Integer;SourceSublineNo: Integer)
    var
        TempWhseWkshLine: Record "Whse. Worksheet Line";
    begin
        InitWhseWkshLine(TempWhseWkshLine,WhseDocType,WhseDocNo,WhseDocLineNo,SourceType,SourceSubtype,SourceNo,
          SourceLineNo,SourceSublineNo);
        InitTrackingSpecification(TempWhseWkshLine);
    end;


    procedure InitWhseWkshLine(var WhseWkshLine: Record "Whse. Worksheet Line";WhseDocType: Option;WhseDocNo: Code[20];WhseDocLineNo: Integer;SourceType: Integer;SourceSubtype: Option "0","1","2","3","4","5","6","7","8","9","10";SourceNo: Code[20];SourceLineNo: Integer;SourceSublineNo: Integer)
    begin
        WhseWkshLine.Init;
        WhseWkshLine."Whse. Document Type" := WhseDocType;
        WhseWkshLine."Whse. Document No." := WhseDocNo;
        WhseWkshLine."Whse. Document Line No." := WhseDocLineNo;
        WhseWkshLine."Source Type" := SourceType;
        WhseWkshLine."Source Subtype" := SourceSubtype;
        WhseWkshLine."Source No." := SourceNo;
        WhseWkshLine."Source Line No." := SourceLineNo;
        WhseWkshLine."Source Subline No." := SourceSublineNo;
    end;


    procedure UpdateWhseItemTrkgLines(var TempWhseItemTrkgLine: Record "Whse. Item Tracking Line" temporary)
    var
        WhseItemTrkgLine: Record "Whse. Item Tracking Line";
    begin
        if TempWhseItemTrkgLine.FindSet then
          repeat
            WhseItemTrkgLine.SetCurrentkey("Serial No.","Lot No.");
            WhseItemTrkgLine.SetRange("Serial No.",TempWhseItemTrkgLine."Serial No.");
            WhseItemTrkgLine.SetRange("Lot No.",TempWhseItemTrkgLine."Lot No.");
            WhseItemTrkgLine.SetRange("Source Type",TempWhseItemTrkgLine."Source Type");
            WhseItemTrkgLine.SetRange("Source Subtype",TempWhseItemTrkgLine."Source Subtype");
            WhseItemTrkgLine.SetRange("Source ID",TempWhseItemTrkgLine."Source ID");
            WhseItemTrkgLine.SetRange("Source Batch Name",TempWhseItemTrkgLine."Source Batch Name");
            WhseItemTrkgLine.SetRange("Source Prod. Order Line",TempWhseItemTrkgLine."Source Prod. Order Line");
            WhseItemTrkgLine.SetRange("Source Ref. No.",TempWhseItemTrkgLine."Source Ref. No.");
            WhseItemTrkgLine.LockTable;
            if WhseItemTrkgLine.FindFirst then begin
              CalcWhseItemTrkgLine(WhseItemTrkgLine);
              WhseItemTrkgLine.Modify;
            end;
          until TempWhseItemTrkgLine.Next = 0
    end;

    local procedure InsertWhseItemTrkgLines(PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";SourceType: Integer)
    var
        WhseItemTrkgLine: Record "Whse. Item Tracking Line";
        WhseItemEntryRelation: Record "Whse. Item Entry Relation";
        ItemLedgEntry: Record "Item Ledger Entry";
        EntryNo: Integer;
        QtyHandledBase: Decimal;
    begin
        if WhseItemTrkgLine.FindLast then
          EntryNo := WhseItemTrkgLine."Entry No." + 1
        else
          EntryNo := 1;

        with PostedWhseReceiptLine do begin
          WhseItemEntryRelation.Reset;
          WhseItemEntryRelation.SetCurrentkey(
            "Source ID","Source Type","Source Subtype","Source Ref. No.");
          WhseItemEntryRelation.SetRange("Source ID","No.");
          WhseItemEntryRelation.SetRange("Source Type",SourceType);
          WhseItemEntryRelation.SetRange("Source Subtype",0);
          WhseItemEntryRelation.SetRange("Source Ref. No.","Line No.");
          if WhseItemEntryRelation.FindSet then begin
            WhseItemTrkgLine.SetCurrentkey("Source ID","Source Type","Source Subtype");
            WhseItemTrkgLine.SetRange("Source ID","No.");
            WhseItemTrkgLine.SetRange("Source Type",SourceType);
            WhseItemTrkgLine.SetRange("Source Subtype",0);
            WhseItemTrkgLine.SetRange("Source Ref. No.","Line No.");
            WhseItemTrkgLine.DeleteAll;
            WhseItemTrkgLine.SetCurrentkey("Serial No.","Lot No.");
            repeat
              WhseItemTrkgLine.SetRange("Serial No.",WhseItemEntryRelation."Serial No.");
              WhseItemTrkgLine.SetRange("Lot No.",WhseItemEntryRelation."Lot No.");
              ItemLedgEntry.Get(WhseItemEntryRelation."Item Entry No.");
              QtyHandledBase := RegisteredPutAwayQtyBase(PostedWhseReceiptLine,WhseItemEntryRelation);

              if not WhseItemTrkgLine.FindFirst then begin
                WhseItemTrkgLine.Init;
                WhseItemTrkgLine."Entry No." := EntryNo;
                EntryNo := EntryNo + 1;

                WhseItemTrkgLine."Item No." := ItemLedgEntry."Item No.";
                WhseItemTrkgLine."Location Code" := ItemLedgEntry."Location Code";
                WhseItemTrkgLine.Description := ItemLedgEntry.Description;
                WhseItemTrkgLine."Source Type" := WhseItemEntryRelation."Source Type";
                WhseItemTrkgLine."Source Subtype" := WhseItemEntryRelation."Source Subtype";
                WhseItemTrkgLine."Source ID" := WhseItemEntryRelation."Source ID";
                WhseItemTrkgLine."Source Batch Name" := WhseItemEntryRelation."Source Batch Name";
                WhseItemTrkgLine."Source Prod. Order Line" := WhseItemEntryRelation."Source Prod. Order Line";
                WhseItemTrkgLine."Source Ref. No." := WhseItemEntryRelation."Source Ref. No.";
                WhseItemTrkgLine."Serial No." := WhseItemEntryRelation."Serial No.";
                WhseItemTrkgLine."Lot No." := WhseItemEntryRelation."Lot No.";
                WhseItemTrkgLine."Qty. per Unit of Measure" := ItemLedgEntry."Qty. per Unit of Measure";
                WhseItemTrkgLine."Warranty Date" := ItemLedgEntry."Warranty Date";
                WhseItemTrkgLine."Expiration Date" := ItemLedgEntry."Expiration Date";
                WhseItemTrkgLine."Quantity Handled (Base)" := QtyHandledBase;
                WhseItemTrkgLine."Qty. Registered (Base)" := QtyHandledBase;
                WhseItemTrkgLine.Validate("Quantity (Base)",ItemLedgEntry.Quantity);
                WhseItemTrkgLine.Insert;
              end else begin
                WhseItemTrkgLine.Validate("Quantity (Base)",WhseItemTrkgLine."Quantity (Base)" + ItemLedgEntry.Quantity);
                WhseItemTrkgLine."Quantity Handled (Base)" += QtyHandledBase;
                WhseItemTrkgLine."Qty. Registered (Base)" += QtyHandledBase;
                WhseItemTrkgLine.Modify;
              end;
            until WhseItemEntryRelation.Next = 0;
          end;
        end;
    end;

    local procedure RegisteredPutAwayQtyBase(PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";WhseItemEntryRelation: Record "Whse. Item Entry Relation"): Decimal
    var
        RegisteredWhseActivityLine: Record "Registered Whse. Activity Line";
    begin
        with PostedWhseReceiptLine do begin
          RegisteredWhseActivityLine.Reset;
          RegisteredWhseActivityLine.SetCurrentkey(
            "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.",
            "Whse. Document No.","Serial No.","Lot No.","Action Type");
          RegisteredWhseActivityLine.SetRange("Source Type","Source Type");
          RegisteredWhseActivityLine.SetRange("Source Subtype","Source Subtype");
          RegisteredWhseActivityLine.SetRange("Source No.","Source No.");
          RegisteredWhseActivityLine.SetRange("Source Line No.","Source Line No.");
          RegisteredWhseActivityLine.SetRange("Whse. Document No.","No.");
          RegisteredWhseActivityLine.SetRange("Serial No.",WhseItemEntryRelation."Serial No.");
          RegisteredWhseActivityLine.SetRange("Lot No.",WhseItemEntryRelation."Lot No.");
          RegisteredWhseActivityLine.SetRange("Action Type",RegisteredWhseActivityLine."action type"::Take);
          RegisteredWhseActivityLine.CalcSums("Qty. (Base)");
        end;

        exit(RegisteredWhseActivityLine."Qty. (Base)");
    end;


    procedure ItemTrkgIsManagedByWhse(Type: Integer;Subtype: Integer;ID: Code[20];ProdOrderLine: Integer;RefNo: Integer;LocationCode: Code[10];ItemNo: Code[20]): Boolean
    var
        WhseShipmentLine: Record "Warehouse Shipment Line";
        WhseWkshLine: Record "Whse. Worksheet Line";
        WhseActivLine: Record "Warehouse Activity Line";
        WhseWkshTemplate: Record "Whse. Worksheet Template";
        Location: Record Location;
        SNRequired: Boolean;
        LNRequired: Boolean;
    begin
        if not (Type in [Database::"Sales Line",
                         Database::"Purchase Line",
                         Database::"Transfer Line",
                         Database::"Assembly Header",
                         Database::"Assembly Line",
                         Database::"Prod. Order Line",
                         Database::"Prod. Order Component"])
        then
          exit(false);

        if not (Location.RequirePicking(LocationCode) or Location.RequirePutaway(LocationCode)) then
          exit(false);

        CheckWhseItemTrkgSetup(ItemNo,SNRequired,LNRequired,false);
        if not (SNRequired or LNRequired) then
          exit(false);

        WhseShipmentLine.SetCurrentkey(
          "Source Type","Source Subtype","Source No.","Source Line No.");
        WhseShipmentLine.SetRange("Source Type",Type);
        WhseShipmentLine.SetRange("Source Subtype",Subtype);
        WhseShipmentLine.SetRange("Source No.",ID);
        WhseShipmentLine.SetRange("Source Line No.",RefNo);
        if not WhseShipmentLine.IsEmpty then
          exit(true);

        WhseWkshLine.SetCurrentkey(
          "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
        WhseWkshLine.SetRange("Source Type",Type);
        WhseWkshLine.SetRange("Source Subtype",Subtype);
        WhseWkshLine.SetRange("Source No.",ID);
        if Type in [Database::"Prod. Order Component",Database::"Prod. Order Line"] then begin
          WhseWkshLine.SetRange("Source Line No.",ProdOrderLine);
          WhseWkshLine.SetRange("Source Subline No.",RefNo);
        end else
          WhseWkshLine.SetRange("Source Line No.",RefNo);
        if WhseWkshLine.FindFirst then
          if WhseWkshTemplate.Get(WhseWkshLine."Worksheet Template Name") then
            if WhseWkshTemplate.Type = WhseWkshTemplate.Type::Pick then
              exit(true);

        WhseActivLine.SetCurrentkey(
          "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
        WhseActivLine.SetRange("Source Type",Type);
        WhseActivLine.SetRange("Source Subtype",Subtype);
        WhseActivLine.SetRange("Source No.",ID);
        if Type in [Database::"Prod. Order Component",Database::"Prod. Order Line"] then begin
          WhseActivLine.SetRange("Source Line No.",ProdOrderLine);
          WhseActivLine.SetRange("Source Subline No.",RefNo);
        end else
          WhseActivLine.SetRange("Source Line No.",RefNo);
        if WhseActivLine.FindFirst then
          if WhseActivLine."Activity Type" in [WhseActivLine."activity type"::Pick,
                                               WhseActivLine."activity type"::"Invt. Put-away",
                                               WhseActivLine."activity type"::"Invt. Pick"]
          then
            exit(true);

        exit(false);
    end;


    procedure CheckWhseItemTrkgSetup(ItemNo: Code[20];var SNRequired: Boolean;var LNRequired: Boolean;ShowError: Boolean)
    var
        ItemTrackingCode: Record "Item Tracking Code";
        Item: Record Item;
    begin
        SNRequired := false;
        LNRequired := false;
        if Item."No." <> ItemNo then
          Item.Get(ItemNo);
        if Item."Item Tracking Code" <> '' then begin
          if ItemTrackingCode.Code <> Item."Item Tracking Code" then
            ItemTrackingCode.Get(Item."Item Tracking Code");
          SNRequired := ItemTrackingCode."SN Warehouse Tracking";
          LNRequired := ItemTrackingCode."Lot Warehouse Tracking";
        end;
        if not (SNRequired or LNRequired) and ShowError then
          Error(Text005,Item.FieldCaption("No."),ItemNo);
    end;


    procedure SetGlobalParameters(SourceSpecification2: Record "Tracking Specification" temporary;var TempTrackingSpecification2: Record "Tracking Specification" temporary;DueDate2: Date)
    begin
        SourceSpecification := SourceSpecification2;
        DueDate := DueDate2;
        if TempTrackingSpecification2.FindSet then
          repeat
            TempTrackingSpecification := TempTrackingSpecification2;
            TempTrackingSpecification.Insert;
          until TempTrackingSpecification2.Next = 0;
    end;


    procedure AdjustQuantityRounding(NonDistrQuantity: Decimal;var QtyToBeHandled: Decimal;NonDistrQuantityBase: Decimal;QtyToBeHandledBase: Decimal)
    var
        FloatingFactor: Decimal;
    begin
        // Used by CU80/90 for handling rounding differences during invoicing

        FloatingFactor := QtyToBeHandledBase / NonDistrQuantityBase;

        if FloatingFactor < 1 then
          QtyToBeHandled := ROUND(FloatingFactor * NonDistrQuantity,0.00001)
        else
          QtyToBeHandled := NonDistrQuantity;
    end;


    procedure SynchronizeItemTracking(FromRowID: Text[250];ToRowID: Text[250];DialogText: Text[250])
    var
        ReservEntry1: Record "Reservation Entry";
        ReservMgt: Codeunit "Reservation Management";
    begin
        // Used for syncronizing between orders linked via Drop Shipment
        ReservEntry1.SetPointer(FromRowID);
        ReservMgt.SetPointerFilter(ReservEntry1);
        SynchronizeItemTracking2(ReservEntry1,ToRowID,DialogText);
    end;

    local procedure SynchronizeItemTracking2(var FromReservEntry: Record "Reservation Entry";ToRowID: Text[250];DialogText: Text[250])
    var
        ReservEntry2: Record "Reservation Entry";
        TempTrkgSpec1: Record "Tracking Specification" temporary;
        TempTrkgSpec2: Record "Tracking Specification" temporary;
        TempTrkgSpec3: Record "Tracking Specification" temporary;
        TempSourceSpec: Record "Tracking Specification" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ReservMgt: Codeunit "Reservation Management";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ItemTrackingLines: Page "Item Tracking Lines";
        AvailabilityDate: Date;
        LastEntryNo: Integer;
        SignFactor1: Integer;
        SignFactor2: Integer;
        SecondSourceRowID: Text[250];
    begin
        // Used for synchronizing between orders linked via Drop Shipment and for
        // synchronizing between invt. pick/put-away and parent line.
        ReservEntry2.SetPointer(ToRowID);
        SignFactor1 := CreateReservEntry.SignFactor(FromReservEntry);
        SignFactor2 := CreateReservEntry.SignFactor(ReservEntry2);
        ReservMgt.SetPointerFilter(ReservEntry2);

        if ReservEntry2.IsEmpty then begin
          if FromReservEntry.IsEmpty then
            exit;
          if DialogText <> '' then
            if not Confirm(DialogText) then begin
              Message(Text006);
              exit;
            end;
          CopyItemTracking3(FromReservEntry,ToRowID,SignFactor1 <> SignFactor2,false);

          // Copy to inbound part of transfer.
          if (FromReservEntry."Source Type" = Database::"Transfer Line") and
             (FromReservEntry."Source Subtype" = 0)
          then begin
            SecondSourceRowID :=
              ItemTrackingMgt.ComposeRowID(FromReservEntry."Source Type",
                1,FromReservEntry."Source ID",
                FromReservEntry."Source Batch Name",FromReservEntry."Source Prod. Order Line",
                FromReservEntry."Source Ref. No.");
            if ToRowID <> SecondSourceRowID then // Avoid copying to the line itself
              CopyItemTracking(ToRowID,SecondSourceRowID,true);
          end;
        end else begin
          if (FromReservEntry."Source Type" = Database::"Transfer Line") and
             (FromReservEntry."Source Subtype" = 0)
          then
            SynchronizeItemTrkgTransfer(ReservEntry2);    // synchronize transfer

          if SumUpItemTracking(ReservEntry2,TempTrkgSpec2,false,true) then
            TempSourceSpec := TempTrkgSpec2 // TempSourceSpec is used for conveying source information to Form6510.
          else
            TempSourceSpec.TransferFields(ReservEntry2);

          if ReservEntry2."Quantity (Base)" > 0 then
            AvailabilityDate := ReservEntry2."Expected Receipt Date"
          else
            AvailabilityDate := ReservEntry2."Shipment Date";

          SumUpItemTracking(FromReservEntry,TempTrkgSpec1,false,true);

          TempTrkgSpec1.Reset;
          TempTrkgSpec2.Reset;
          TempTrkgSpec1.SetCurrentkey("Lot No.","Serial No.");
          TempTrkgSpec2.SetCurrentkey("Lot No.","Serial No.");
          if TempTrkgSpec1.FindSet then
            repeat
              TempTrkgSpec2.SetRange("Lot No.",TempTrkgSpec1."Lot No.");
              TempTrkgSpec2.SetRange("Serial No.",TempTrkgSpec1."Serial No.");
              if TempTrkgSpec2.FindFirst then begin
                if TempTrkgSpec2."Quantity (Base)" * SignFactor2 <> TempTrkgSpec1."Quantity (Base)" * SignFactor1 then begin
                  TempTrkgSpec3 := TempTrkgSpec2;
                  TempTrkgSpec3.Validate("Quantity (Base)",
                    (TempTrkgSpec1."Quantity (Base)" * SignFactor1 - TempTrkgSpec2."Quantity (Base)" * SignFactor2));
                  TempTrkgSpec3."Entry No." := LastEntryNo + 1;
                  TempTrkgSpec3.Insert;
                end;
                TempTrkgSpec2.Delete;
              end else begin
                TempTrkgSpec3 := TempTrkgSpec1;
                TempTrkgSpec3.Validate("Quantity (Base)",TempTrkgSpec1."Quantity (Base)" * SignFactor1);
                TempTrkgSpec3."Entry No." := LastEntryNo + 1;
                TempTrkgSpec3.Insert;
              end;
              LastEntryNo := TempTrkgSpec3."Entry No.";
              TempTrkgSpec1.Delete;
            until TempTrkgSpec1.Next = 0;

          TempTrkgSpec2.Reset;

          if TempTrkgSpec2.FindFirst then
            repeat
              TempTrkgSpec3 := TempTrkgSpec2;
              TempTrkgSpec3.Validate("Quantity (Base)",-TempTrkgSpec2."Quantity (Base)" * SignFactor2);
              TempTrkgSpec3."Entry No." := LastEntryNo + 1;
              TempTrkgSpec3.Insert;
              LastEntryNo := TempTrkgSpec3."Entry No.";
            until TempTrkgSpec2.Next = 0;

          TempTrkgSpec3.Reset;

          if not TempTrkgSpec3.IsEmpty then begin
            if DialogText <> '' then
              if not Confirm(DialogText) then begin
                Message(Text006);
                exit;
              end;
            TempSourceSpec."Quantity (Base)" := ReservMgt.GetSourceRecordValue(ReservEntry2,false,1);
            if TempTrkgSpec3."Source Type" = Database::"Transfer Line" then begin
              TempTrkgSpec3.ModifyAll("Location Code",ReservEntry2."Location Code");
              ItemTrackingLines.SetFormRunMode(4);
            end else
              if FromReservEntry."Source Type" <> ReservEntry2."Source Type" then // If different it is drop shipment
                ItemTrackingLines.SetFormRunMode(3);
            ItemTrackingLines.RegisterItemTrackingLines(TempSourceSpec,AvailabilityDate,TempTrkgSpec3);
          end;
        end;
    end;


    procedure SetRegistering(Registering2: Boolean)
    begin
        Registering := Registering2;
    end;

    local procedure ModifyTemp337SetIfTransfer(var TempReservEntry: Record "Reservation Entry" temporary)
    var
        TransLine: Record "Transfer Line";
    begin
        if TempReservEntry."Source Type" = Database::"Transfer Line" then begin
          TransLine.Get(TempReservEntry."Source ID",TempReservEntry."Source Ref. No.");
          TempReservEntry.ModifyAll("Reservation Status",TempReservEntry."reservation status"::Surplus);
          if TempReservEntry."Source Subtype" = 0 then begin
            TempReservEntry.ModifyAll("Location Code",TransLine."Transfer-from Code");
            TempReservEntry.ModifyAll("Expected Receipt Date",0D);
            TempReservEntry.ModifyAll("Shipment Date",TransLine."Shipment Date");
          end else begin
            TempReservEntry.ModifyAll("Location Code",TransLine."Transfer-to Code");
            TempReservEntry.ModifyAll("Expected Receipt Date",TransLine."Receipt Date");
            TempReservEntry.ModifyAll("Shipment Date",0D);
          end;
        end;
    end;


    procedure SynchronizeWhseItemTracking(var TempTrackingSpecification: Record "Tracking Specification" temporary;RegPickNo: Code[20];Deletion: Boolean)
    var
        SourceSpec: Record "Tracking Specification";
        ReservEntry: Record "Reservation Entry";
        RegisteredWhseActLine: Record "Registered Whse. Activity Line";
        ItemTrackingLines: Page "Item Tracking Lines";
        Qty: Decimal;
        ZeroQtyToHandle: Boolean;
    begin
        if TempTrackingSpecification.FindSet then
          repeat
            if TempTrackingSpecification.Correction then begin
              if IsPick then begin
                ZeroQtyToHandle := false;
                Qty := -TempTrackingSpecification."Qty. to Handle (Base)";
                if RegPickNo <> '' then begin
                  RegisteredWhseActLine.SetCurrentkey(
                    "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.",
                    "Whse. Document No.","Serial No.","Lot No.","Action Type");
                  RegisteredWhseActLine.SetRange("Activity Type",RegisteredWhseActLine."activity type"::Pick);
                  RegisteredWhseActLine.SetRange("Source No.",TempTrackingSpecification."Source ID");
                  RegisteredWhseActLine.SetRange("Source Line No.",TempTrackingSpecification."Source Ref. No.");
                  RegisteredWhseActLine.SetRange("Source Type",TempTrackingSpecification."Source Type");
                  RegisteredWhseActLine.SetRange("Source Subtype",TempTrackingSpecification."Source Subtype");
                  RegisteredWhseActLine.SetRange("Lot No.",TempTrackingSpecification."Lot No.");
                  RegisteredWhseActLine.SetRange("Serial No.",TempTrackingSpecification."Serial No.");
                  RegisteredWhseActLine.SetFilter("No.",'<> %1',RegPickNo);

                  if not RegisteredWhseActLine.FindFirst then
                    ZeroQtyToHandle := true
                  else
                    if RegisteredWhseActLine."Whse. Document Type" = RegisteredWhseActLine."whse. document type"::Shipment then begin
                      ZeroQtyToHandle := true;
                      Qty := -(TempTrackingSpecification."Qty. to Handle (Base)" + CalcQtyBaseRegistered(RegisteredWhseActLine));
                    end;
                end;

                ReservEntry.SetCurrentkey(
                  "Source ID","Source Ref. No.","Source Type","Source Subtype",
                  "Source Batch Name","Source Prod. Order Line");

                ReservEntry.SetRange("Source ID",TempTrackingSpecification."Source ID");
                ReservEntry.SetRange("Source Ref. No.",TempTrackingSpecification."Source Ref. No.");
                ReservEntry.SetRange("Source Type",TempTrackingSpecification."Source Type");
                ReservEntry.SetRange("Source Subtype",TempTrackingSpecification."Source Subtype");
                ReservEntry.SetRange("Source Batch Name",'');
                ReservEntry.SetRange("Source Prod. Order Line",TempTrackingSpecification."Source Prod. Order Line");
                ReservEntry.SetRange("Lot No.",TempTrackingSpecification."Lot No.");
                ReservEntry.SetRange("Serial No.",TempTrackingSpecification."Serial No.");

                if ReservEntry.FindSet(true) then
                  repeat
                    if ZeroQtyToHandle then begin
                      ReservEntry."Qty. to Handle (Base)" := 0;
                      ReservEntry."Qty. to Invoice (Base)" := 0;
                      ReservEntry.Modify;
                    end;
                  until ReservEntry.Next = 0;

                if ReservEntry.FindSet(true) then
                  repeat
                    if RegPickNo <> '' then begin
                      ReservEntry."Qty. to Handle (Base)" += Qty;
                      ReservEntry."Qty. to Invoice (Base)" += Qty;
                    end else
                      if not Deletion then begin
                        ReservEntry."Qty. to Handle (Base)" := Qty;
                        ReservEntry."Qty. to Invoice (Base)" := Qty;
                      end;
                    if Abs(ReservEntry."Qty. to Handle (Base)") > Abs(ReservEntry."Quantity (Base)") then begin
                      Qty := ReservEntry."Qty. to Handle (Base)" - ReservEntry."Quantity (Base)";
                      ReservEntry."Qty. to Handle (Base)" := ReservEntry."Quantity (Base)";
                      ReservEntry."Qty. to Invoice (Base)" := ReservEntry."Quantity (Base)";
                    end else
                      Qty := 0;
                    ReservEntry.Modify;
                  until (ReservEntry.Next = 0) or (Qty = 0);
              end;
              TempTrackingSpecification.Delete;
            end;
          until TempTrackingSpecification.Next = 0;

        if TempTrackingSpecification.FindSet then
          repeat
            TempTrackingSpecification.SetRange("Source ID",TempTrackingSpecification."Source ID");
            TempTrackingSpecification.SetRange("Source Type",TempTrackingSpecification."Source Type");
            TempTrackingSpecification.SetRange("Source Subtype",TempTrackingSpecification."Source Subtype");
            TempTrackingSpecification.SetRange("Source Prod. Order Line",TempTrackingSpecification."Source Prod. Order Line");
            TempTrackingSpecification.SetRange("Source Ref. No.",TempTrackingSpecification."Source Ref. No.");
            SourceSpec := TempTrackingSpecification;
            TempTrackingSpecification.CalcSums("Qty. to Handle (Base)");
            SourceSpec."Quantity (Base)" :=
              TempTrackingSpecification."Qty. to Handle (Base)" +
              Abs(ItemTrkgQtyPostedOnSource(SourceSpec));
            Clear(ItemTrackingLines);
            ItemTrackingLines.SetCalledFromSynchWhseItemTrkg(true);
            ItemTrackingLines.SetPick(IsPick);
            ItemTrackingLines.RegisterItemTrackingLines(SourceSpec,SourceSpec."Creation Date",TempTrackingSpecification);
            TempTrackingSpecification.SetRange("Source ID");
            TempTrackingSpecification.SetRange("Source Type");
            TempTrackingSpecification.SetRange("Source Subtype");
            TempTrackingSpecification.SetRange("Source Prod. Order Line");
            TempTrackingSpecification.SetRange("Source Ref. No.");
          until TempTrackingSpecification.Next = 0;
    end;

    local procedure CheckWhseItemTrkg(var TempWhseItemTrkgLine: Record "Whse. Item Tracking Line";WhseWkshLine: Record "Whse. Worksheet Line")
    var
        SourceItemTrkgLine: Record "Reservation Entry";
        WhseItemTrackingLine: Record "Whse. Item Tracking Line";
        EntryNo: Integer;
    begin
        with WhseWkshLine do begin
          if WhseItemTrackingLine.FindLast then
            EntryNo := WhseItemTrackingLine."Entry No.";

          SourceItemTrkgLine.SetCurrentkey(
            "Source ID","Source Ref. No.","Source Type","Source Subtype",
            "Source Batch Name","Source Prod. Order Line");
          SourceItemTrkgLine.SetRange("Source ID","Source No.");
          SourceItemTrkgLine.SetRange("Source Type","Source Type");
          SourceItemTrkgLine.SetRange("Source Subtype","Source Subtype");
          SourceItemTrkgLine.SetRange("Source Batch Name",'');
          if "Source Type" = Database::"Prod. Order Component" then begin
            SourceItemTrkgLine.SetRange("Source Ref. No.","Source Subline No.");
            SourceItemTrkgLine.SetRange("Source Prod. Order Line","Source Line No.");
          end else begin
            SourceItemTrkgLine.SetRange("Source Ref. No.","Source Line No.");
            SourceItemTrkgLine.SetRange("Source Prod. Order Line",0);
          end;
          if SourceItemTrkgLine.FindSet then
            repeat
              if SourceItemTrkgLine.TrackingExists then begin
                TempWhseItemTrkgLine.SetCurrentkey(
                  "Source ID","Source Type","Source Subtype","Source Batch Name","Source Prod. Order Line","Source Ref. No.");
                TempWhseItemTrkgLine.SetRange("Source Type","Source Type");
                TempWhseItemTrkgLine.SetRange("Source Subtype","Source Subtype");
                TempWhseItemTrkgLine.SetRange("Source ID","Source No.");
                TempWhseItemTrkgLine.SetRange("Serial No.",SourceItemTrkgLine."Serial No.");
                TempWhseItemTrkgLine.SetRange("Lot No.",SourceItemTrkgLine."Lot No.");
                if "Source Type" = Database::"Prod. Order Component" then begin
                  TempWhseItemTrkgLine.SetRange("Source Prod. Order Line","Source Line No.");
                  TempWhseItemTrkgLine.SetRange("Source Ref. No.","Source Subline No.");
                end else begin
                  TempWhseItemTrkgLine.SetRange("Source Ref. No.","Source Line No.");
                  TempWhseItemTrkgLine.SetRange("Source Prod. Order Line",0);
                end;

                if TempWhseItemTrkgLine.FindFirst then
                  TempWhseItemTrkgLine.Delete
                else begin
                  WhseItemTrackingLine.Init;
                  EntryNo += 1;
                  WhseItemTrackingLine."Entry No." := EntryNo;
                  WhseItemTrackingLine."Item No." := SourceItemTrkgLine."Item No.";
                  WhseItemTrackingLine."Variant Code" := SourceItemTrkgLine."Variant Code";
                  WhseItemTrackingLine."Location Code" := SourceItemTrkgLine."Location Code";
                  WhseItemTrackingLine.Description := SourceItemTrkgLine.Description;
                  WhseItemTrackingLine."Qty. per Unit of Measure" := SourceItemTrkgLine."Qty. per Unit of Measure";
                  WhseItemTrackingLine."Source Type" := "Source Type";
                  WhseItemTrackingLine."Source Subtype" := "Source Subtype";
                  WhseItemTrackingLine."Source ID" := "Source No.";
                  if "Source Type" = Database::"Prod. Order Component" then begin
                    WhseItemTrackingLine."Source Prod. Order Line" := "Source Line No.";
                    WhseItemTrackingLine."Source Ref. No." := "Source Subline No.";
                  end else begin
                    WhseItemTrackingLine."Source Prod. Order Line" := 0;
                    WhseItemTrackingLine."Source Ref. No." := "Source Line No.";
                  end;
                  WhseItemTrackingLine."Serial No." := SourceItemTrkgLine."Serial No.";
                  WhseItemTrackingLine."Lot No." := SourceItemTrkgLine."Lot No.";
                  WhseItemTrackingLine."Warranty Date" := SourceItemTrkgLine."Warranty Date";
                  WhseItemTrackingLine."Expiration Date" := SourceItemTrkgLine."Expiration Date";
                  WhseItemTrackingLine."Quantity (Base)" := -SourceItemTrkgLine."Quantity (Base)";
                  if "Qty. (Base)" = "Qty. to Handle (Base)" then
                    WhseItemTrackingLine."Qty. to Handle (Base)" := WhseItemTrackingLine."Quantity (Base)";
                  WhseItemTrackingLine."Qty. to Handle" :=
                    ROUND(WhseItemTrackingLine."Qty. to Handle (Base)" / WhseItemTrackingLine."Qty. per Unit of Measure",0.00001);
                  WhseItemTrackingLine.Insert;
                end;
              end;
            until SourceItemTrkgLine.Next = 0;

          TempWhseItemTrkgLine.Reset;
          if TempWhseItemTrkgLine.FindSet then
            repeat
              if TempWhseItemTrkgLine.TrackingExists and (TempWhseItemTrkgLine."Quantity Handled (Base)" = 0) then begin
                WhseItemTrackingLine.Get(TempWhseItemTrkgLine."Entry No.");
                WhseItemTrackingLine.Delete;
              end;
            until TempWhseItemTrkgLine.Next = 0;
        end;
    end;


    procedure CopyLotNoInformation(LotNoInfo: Record "Lot No. Information";NewLotNo: Code[20])
    var
        NewLotNoInfo: Record "Lot No. Information";
        CommentType: Option " ","Serial No.","Lot No.";
    begin
        if NewLotNoInfo.Get(LotNoInfo."Item No.",LotNoInfo."Variant Code",NewLotNo) then begin
          if not Confirm(text008,false,LotNoInfo.TableCaption,LotNoInfo.FieldCaption("Lot No."),NewLotNo) then
            Error('');
          NewLotNoInfo.TransferFields(LotNoInfo,false);
          NewLotNoInfo.Modify;
        end else begin
          NewLotNoInfo := LotNoInfo;
          NewLotNoInfo."Lot No." := NewLotNo;
          NewLotNoInfo.Insert;
        end;

        CopyInfoComment(
          Commenttype::"Lot No.",
          LotNoInfo."Item No.",
          LotNoInfo."Variant Code",
          LotNoInfo."Lot No.",
          NewLotNo);
    end;


    procedure CopySerialNoInformation(SerialNoInfo: Record "Serial No. Information";NewSerialNo: Code[20])
    var
        NewSerialNoInfo: Record "Serial No. Information";
        CommentType: Option " ","Serial No.","Lot No.";
    begin
        if NewSerialNoInfo.Get(SerialNoInfo."Item No.",SerialNoInfo."Variant Code",NewSerialNo) then begin
          if not Confirm(text008,false,SerialNoInfo.TableCaption,SerialNoInfo.FieldCaption("Serial No."),NewSerialNo) then
            Error('');
          NewSerialNoInfo.TransferFields(SerialNoInfo,false);
          NewSerialNoInfo.Modify;
        end else begin
          NewSerialNoInfo := SerialNoInfo;
          NewSerialNoInfo."Serial No." := NewSerialNo;
          NewSerialNoInfo.Insert;
        end;

        CopyInfoComment(
          Commenttype::"Serial No.",
          SerialNoInfo."Item No.",
          SerialNoInfo."Variant Code",
          SerialNoInfo."Serial No.",
          NewSerialNo);
    end;

    local procedure CopyInfoComment(InfoType: Option " ","Serial No.","Lot No.";ItemNo: Code[20];VariantCode: Code[10];SerialLotNo: Code[20];NewSerialLotNo: Code[20])
    var
        ItemTrackingComment: Record "Item Tracking Comment";
        ItemTrackingComment1: Record "Item Tracking Comment";
    begin
        if SerialLotNo = NewSerialLotNo then
          exit;

        ItemTrackingComment1.SetRange(Type,InfoType);
        ItemTrackingComment1.SetRange("Item No.",ItemNo);
        ItemTrackingComment1.SetRange("Variant Code",VariantCode);
        ItemTrackingComment1.SetRange("Serial/Lot No.",NewSerialLotNo);

        if not ItemTrackingComment1.IsEmpty then
          ItemTrackingComment1.DeleteAll;

        ItemTrackingComment.SetRange(Type,InfoType);
        ItemTrackingComment.SetRange("Item No.",ItemNo);
        ItemTrackingComment.SetRange("Variant Code",VariantCode);
        ItemTrackingComment.SetRange("Serial/Lot No.",SerialLotNo);

        if ItemTrackingComment.IsEmpty then
          exit;

        if ItemTrackingComment.FindSet then begin
          repeat
            ItemTrackingComment1 := ItemTrackingComment;
            ItemTrackingComment1."Serial/Lot No." := NewSerialLotNo;
            ItemTrackingComment1.Insert;
          until ItemTrackingComment.Next = 0
        end;
    end;

    local procedure GetLotSNDataSet(ItemNo: Code[20];Variant: Code[20];LotNo: Code[20];SerialNo: Code[20];var ItemLedgEntry: Record "Item Ledger Entry"): Boolean
    begin
        ItemLedgEntry.Reset;
        ItemLedgEntry.SetCurrentkey("Item No.",Open,"Variant Code",Positive,"Lot No.","Serial No.");

        ItemLedgEntry.SetRange("Item No.",ItemNo);
        ItemLedgEntry.SetRange(Open,true);
        ItemLedgEntry.SetRange("Variant Code",Variant);
        if LotNo <> '' then
          ItemLedgEntry.SetRange("Lot No.",LotNo)
        else
          if SerialNo <> '' then
            ItemLedgEntry.SetRange("Serial No.",SerialNo);
        ItemLedgEntry.SetRange(Positive,true);

        if not ItemLedgEntry.IsEmpty then
          exit(ItemLedgEntry.FindLast);

        ItemLedgEntry.SetRange(Open);
        exit(ItemLedgEntry.FindLast);
    end;


    procedure ExistingExpirationDate(ItemNo: Code[20];Variant: Code[20];LotNo: Code[20];SerialNo: Code[20];TestMultiple: Boolean;var EntriesExist: Boolean) ExpDate: Date
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemTracingMgt: Codeunit "Item Tracing Mgt.";
    begin
        if not GetLotSNDataSet(ItemNo,Variant,LotNo,SerialNo,ItemLedgEntry) then begin
          EntriesExist := false;
          exit;
        end;

        EntriesExist := true;
        ExpDate := ItemLedgEntry."Expiration Date";

        if TestMultiple and ItemTracingMgt.SpecificTracking(ItemNo,SerialNo,LotNo) then begin
          ItemLedgEntry.SetFilter("Expiration Date",'<>%1',ItemLedgEntry."Expiration Date");
          ItemLedgEntry.SetRange(Open,true);
          if not ItemLedgEntry.IsEmpty then
            Error(Text007,LotNo);
        end;
    end;


    procedure ExistingExpirationDateAndQty(ItemNo: Code[20];Variant: Code[20];LotNo: Code[20];SerialNo: Code[20];var SumOfEntries: Decimal) ExpDate: Date
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        SumOfEntries := 0;
        if not GetLotSNDataSet(ItemNo,Variant,LotNo,SerialNo,ItemLedgEntry) then
          exit;

        ExpDate := ItemLedgEntry."Expiration Date";
        if ItemLedgEntry.FindSet then
          repeat
            SumOfEntries += ItemLedgEntry."Remaining Quantity";
          until ItemLedgEntry.Next = 0;
    end;


    procedure ExistingWarrantyDate(ItemNo: Code[20];Variant: Code[20];LotNo: Code[20];SerialNo: Code[20];var EntriesExist: Boolean) WarDate: Date
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        if not GetLotSNDataSet(ItemNo,Variant,LotNo,SerialNo,ItemLedgEntry) then
          exit;

        EntriesExist := true;
        WarDate := ItemLedgEntry."Warranty Date";
    end;


    procedure WhseExistingExpirationDate(ItemNo: Code[20];VariantCode: Code[20];Location: Record Location;LotNo: Code[20];SerialNo: Code[20];var EntriesExist: Boolean) ExpDate: Date
    var
        WhseEntry: Record "Warehouse Entry";
        SumOfEntries: Decimal;
    begin
        ExpDate := 0D;
        SumOfEntries := 0;

        if Location."Adjustment Bin Code" = '' then
          exit;

        with WhseEntry do begin
          Reset;
          SetCurrentkey("Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code","Lot No.","Serial No.");
          SetRange("Item No.",ItemNo);
          SetRange("Bin Code",Location."Adjustment Bin Code");
          SetRange("Location Code",Location.Code);
          SetRange("Variant Code",VariantCode);
          if LotNo <> '' then
            SetRange("Lot No.",LotNo)
          else
            if SerialNo <> '' then
              SetRange("Serial No.",SerialNo);
          if IsEmpty then
            exit;

          if FindSet then
            repeat
              SumOfEntries += "Qty. (Base)";
              if ("Expiration Date" <> 0D) and (("Expiration Date" < ExpDate) or (ExpDate = 0D)) then
                ExpDate := "Expiration Date";
            until Next = 0;
        end;

        EntriesExist := SumOfEntries < 0;
    end;

    local procedure WhseExistingWarrantyDate(ItemNo: Code[20];VariantCode: Code[20];Location: Record Location;LotNo: Code[20];SerialNo: Code[20];var EntriesExist: Boolean) WarDate: Date
    var
        WhseEntry: Record "Warehouse Entry";
        SumOfEntries: Decimal;
    begin
        WarDate := 0D;
        SumOfEntries := 0;

        if Location."Adjustment Bin Code" = '' then
          exit;

        with WhseEntry do begin
          Reset;
          SetCurrentkey("Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code","Lot No.","Serial No.");
          SetRange("Item No.",ItemNo);
          SetRange("Bin Code",Location."Adjustment Bin Code");
          SetRange("Location Code",Location.Code);
          SetRange("Variant Code",VariantCode);
          if LotNo <> '' then
            SetRange("Lot No.",LotNo)
          else
            if SerialNo <> '' then
              SetRange("Serial No.",SerialNo);
          if IsEmpty then
            exit;

          if FindSet then
            repeat
              SumOfEntries += "Qty. (Base)";
              if ("Warranty Date" <> 0D) and (("Warranty Date" < WarDate) or (WarDate = 0D)) then
                WarDate := "Warranty Date";
            until Next = 0;
        end;

        EntriesExist := SumOfEntries < 0;
    end;


    procedure GetWhseExpirationDate(ItemNo: Code[20];VariantCode: Code[20];Location: Record Location;LotNo: Code[20];SerialNo: Code[20];var ExpDate: Date): Boolean
    var
        EntriesExist: Boolean;
    begin
        ExpDate := ExistingExpirationDate(ItemNo,VariantCode,LotNo,SerialNo,false,EntriesExist);
        if EntriesExist then
          exit(true);

        ExpDate := WhseExistingExpirationDate(ItemNo,VariantCode,Location,LotNo,SerialNo,EntriesExist);
        if EntriesExist then
          exit(true);

        ExpDate := 0D;
        exit(false);
    end;


    procedure GetWhseWarrantyDate(ItemNo: Code[20];VariantCode: Code[20];Location: Record Location;LotNo: Code[20];SerialNo: Code[20];var Wardate: Date): Boolean
    var
        EntriesExist: Boolean;
    begin
        Wardate := ExistingWarrantyDate(ItemNo,VariantCode,LotNo,SerialNo,EntriesExist);
        if EntriesExist then
          exit(true);

        Wardate := WhseExistingWarrantyDate(ItemNo,VariantCode,Location,LotNo,SerialNo,EntriesExist);
        if EntriesExist then
          exit(true);

        Wardate := 0D;
        exit(false);
    end;


    procedure SumNewLotOnTrackingSpec(var TempTrackingSpecification: Record "Tracking Specification" temporary): Decimal
    var
        TempTrackingSpecification2: Record "Tracking Specification";
        SumLot: Decimal;
    begin
        SumLot := 0;
        TempTrackingSpecification2 := TempTrackingSpecification;
        TempTrackingSpecification.SetRange("New Lot No.",TempTrackingSpecification."New Lot No.");
        if TempTrackingSpecification.FindSet then
          repeat
            SumLot += TempTrackingSpecification."Quantity (Base)";
          until TempTrackingSpecification.Next = 0;
        TempTrackingSpecification := TempTrackingSpecification2;
        exit(SumLot);
    end;


    procedure TestExpDateOnTrackingSpec(var TempTrackingSpecification: Record "Tracking Specification" temporary)
    begin
        if (TempTrackingSpecification."Lot No." = '') or (TempTrackingSpecification."Serial No." = '') then
          exit;
        TempTrackingSpecification.SetRange("Lot No.",TempTrackingSpecification."Lot No.");
        TempTrackingSpecification.SetFilter("Expiration Date",'<>%1',TempTrackingSpecification."Expiration Date");
        if not TempTrackingSpecification.IsEmpty then
          Error(Text007,TempTrackingSpecification."Lot No.");
        TempTrackingSpecification.SetRange("Lot No.");
        TempTrackingSpecification.SetRange("Expiration Date");
    end;


    procedure TestExpDateOnTrackingSpecNew(var TempTrackingSpecification: Record "Tracking Specification" temporary)
    begin
        if TempTrackingSpecification."New Lot No." = '' then
          exit;
        TempTrackingSpecification.SetRange("New Lot No.",TempTrackingSpecification."New Lot No.");
        TempTrackingSpecification.SetFilter("New Expiration Date",'<>%1',TempTrackingSpecification."New Expiration Date");
        if not TempTrackingSpecification.IsEmpty then
          Error(Text007,TempTrackingSpecification."New Lot No.");
        TempTrackingSpecification.SetRange("New Lot No.");
        TempTrackingSpecification.SetRange("New Expiration Date");
    end;


    procedure ItemTrackingOption(LotNo: Code[20];SerialNo: Code[20]) OptionValue: Integer
    begin
        if LotNo <> '' then
          OptionValue := 1;

        if SerialNo <> '' then begin
          if LotNo <> '' then
            OptionValue := 2
          else
            OptionValue := 3;
        end;
    end;

    local procedure CalcQtyBaseRegistered(var RegisteredWhseActivityLine: Record "Registered Whse. Activity Line"): Decimal
    var
        RegisteredWhseActivityLineForCalcBaseQty: Record "Registered Whse. Activity Line";
    begin
        RegisteredWhseActivityLineForCalcBaseQty.CopyFilters(RegisteredWhseActivityLine);
        with RegisteredWhseActivityLineForCalcBaseQty do begin
          SetRange("Action Type","action type"::Place);
          CalcSums("Qty. (Base)");
          exit("Qty. (Base)");
        end;
    end;


    procedure CopyItemLedgEntryTrkgToSalesLn(var ItemLedgEntryBuf: Record "Item Ledger Entry" temporary;ToSalesLine: Record "Sales Line";FillExactCostRevLink: Boolean;var MissingExCostRevLink: Boolean;FromPricesInclVAT: Boolean;ToPricesInclVAT: Boolean;FromShptOrRcpt: Boolean)
    var
        TempReservEntry: Record "Reservation Entry" temporary;
        ReservEntry: Record "Reservation Entry";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        ReservMgt: Codeunit "Reservation Management";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        TotalCostLCY: Decimal;
        ItemLedgEntryQty: Decimal;
        SignFactor: Integer;
        LinkThisEntry: Boolean;
        EntriesExist: Boolean;
    begin
        if (ToSalesLine.Type <> ToSalesLine.Type::Item) or
           (ToSalesLine.Quantity = 0)
        then
          exit;

        if FillExactCostRevLink then
          FillExactCostRevLink := not ToSalesLine.IsShipment;

        with ItemLedgEntryBuf do
          if FindSet then begin
            if Quantity / ToSalesLine.Quantity < 0 then
              SignFactor := 1
            else
              SignFactor := -1;
            if ToSalesLine."Document Type" in
               [ToSalesLine."document type"::"Return Order",ToSalesLine."document type"::"Credit Memo"]
            then
              SignFactor := -SignFactor;

            ReservMgt.SetSalesLine(ToSalesLine);
            ReservMgt.DeleteReservEntries(true,0);

            repeat
              LinkThisEntry := "Entry No." > 0;
              ReservEntry.Init;
              ReservEntry."Item No." := "Item No.";
              ReservEntry."Location Code" := "Location Code";
              ReservEntry."Serial No." := "Serial No.";
              ReservEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
              ReservEntry."Lot No." := "Lot No.";
              ReservEntry."Variant Code" := "Variant Code";
              ReservEntry."Source Type" := Database::"Sales Line";
              ReservEntry."Source Subtype" := ToSalesLine."Document Type";
              ReservEntry."Source ID" := ToSalesLine."Document No.";
              ReservEntry."Source Ref. No." := ToSalesLine."Line No.";
              if ToSalesLine."Document Type" in
                 [ToSalesLine."document type"::Order,ToSalesLine."document type"::"Return Order"]
              then
                ReservEntry."Reservation Status" := ReservEntry."reservation status"::Surplus
              else
                ReservEntry."Reservation Status" := ReservEntry."reservation status"::Prospect;
              ReservEntry."Quantity Invoiced (Base)" := 0;
              if FillExactCostRevLink then
                ReservEntry.Validate("Quantity (Base)","Shipped Qty. Not Returned" * SignFactor)
              else
                ReservEntry.Validate("Quantity (Base)",Quantity * SignFactor);
              ReservEntry.Positive := (ReservEntry."Quantity (Base)" > 0);
              ReservEntry."Entry No." := 0;
              if ReservEntry.Positive then begin
                ReservEntry."Warranty Date" := "Warranty Date";
                ReservEntry."Expiration Date" :=
                  ExistingExpirationDate("Item No.","Variant Code","Lot No.","Serial No.",false,EntriesExist);
                ReservEntry."Expected Receipt Date" := ToSalesLine."Shipment Date"
              end else
                ReservEntry."Shipment Date" := ToSalesLine."Shipment Date";

              if FillExactCostRevLink then begin
                if LinkThisEntry then begin
                  ReservEntry."Appl.-from Item Entry" := "Entry No.";
                  if not MissingExCostRevLink then begin
                    CalcFields("Cost Amount (Actual)","Cost Amount (Expected)");
                    TotalCostLCY :=
                      TotalCostLCY + "Cost Amount (Expected)" + "Cost Amount (Actual)";
                    ItemLedgEntryQty := ItemLedgEntryQty - Quantity;
                  end;
                end else
                  MissingExCostRevLink := true;
              end;

              ReservEntry.Description := ToSalesLine.Description;
              ReservEntry."Creation Date" := WorkDate;
              ReservEntry."Created By" := UserId;
              ReservEntry.UpdateItemTracking;
              ReservEntry.Insert;
              TempReservEntry := ReservEntry;
              TempReservEntry.Insert;
            until Next = 0;
            ReservEngineMgt.UpdateOrderTracking(TempReservEntry);

            if FillExactCostRevLink and not MissingExCostRevLink then begin
              ToSalesLine.Validate(
                "Unit Cost (LCY)",
                Abs(TotalCostLCY / ItemLedgEntryQty) * ToSalesLine."Qty. per Unit of Measure");
              if not FromShptOrRcpt then
                CopyDocMgt.CalculateRevSalesLineAmount(
                  ToSalesLine,ItemLedgEntryQty,FromPricesInclVAT,ToPricesInclVAT);

              ToSalesLine.Modify;
            end;
          end;
    end;


    procedure CopyItemLedgEntryTrkgToPurchLn(var ItemLedgEntryBuf: Record "Item Ledger Entry";ToPurchLine: Record "Purchase Line";FillExactCostRevLink: Boolean;var MissingExCostRevLink: Boolean;FromPricesInclVAT: Boolean;ToPricesInclVAT: Boolean;FromShptOrRcpt: Boolean)
    var
        ReservEntry: Record "Reservation Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        ReservMgt: Codeunit "Reservation Management";
        TotalCostLCY: Decimal;
        ItemLedgEntryQty: Decimal;
        SignFactor: Integer;
        LinkThisEntry: Boolean;
        EntriesExist: Boolean;
    begin
        if (ToPurchLine.Type <> ToPurchLine.Type::Item) or
           (ToPurchLine.Quantity = 0)
        then
          exit;

        if FillExactCostRevLink then
          FillExactCostRevLink := ToPurchLine.Signed(ToPurchLine."Quantity (Base)") < 0;

        if FillExactCostRevLink then
          if (ToPurchLine."Document Type" in [ToPurchLine."document type"::Invoice,ToPurchLine."document type"::"Credit Memo"]) and
             (ToPurchLine."Job No." <> '')
          then
            FillExactCostRevLink := false;

        with ItemLedgEntryBuf do
          if FindSet then begin
            if Quantity / ToPurchLine.Quantity > 0 then
              SignFactor := 1
            else
              SignFactor := -1;
            if ToPurchLine."Document Type" in
               [ToPurchLine."document type"::"Return Order",ToPurchLine."document type"::"Credit Memo"]
            then
              SignFactor := -SignFactor;

            if ToPurchLine."Expected Receipt Date" = 0D then
              ToPurchLine."Expected Receipt Date" := WorkDate;
            ToPurchLine."Outstanding Qty. (Base)" := ToPurchLine."Quantity (Base)";
            ReservMgt.SetPurchLine(ToPurchLine);
            ReservMgt.DeleteReservEntries(true,0);

            repeat
              LinkThisEntry := "Entry No." > 0;
              ReservEntry.Init;
              ReservEntry."Item No." := "Item No.";
              ReservEntry."Location Code" := "Location Code";
              ReservEntry."Serial No." := "Serial No.";
              ReservEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
              ReservEntry."Lot No." := "Lot No.";
              ReservEntry."Variant Code" := "Variant Code";
              ReservEntry."Source Type" := Database::"Purchase Line";
              ReservEntry."Source Subtype" := ToPurchLine."Document Type";
              ReservEntry."Source ID" := ToPurchLine."Document No.";
              ReservEntry."Source Ref. No." := ToPurchLine."Line No.";
              if ToPurchLine."Document Type" in
                 [ToPurchLine."document type"::Order,ToPurchLine."document type"::"Return Order"]
              then
                ReservEntry."Reservation Status" := ReservEntry."reservation status"::Surplus
              else
                ReservEntry."Reservation Status" := ReservEntry."reservation status"::Prospect;
              ReservEntry."Quantity Invoiced (Base)" := 0;
              if LinkThisEntry and ("Lot No." = '') then
                // The check for Lot No = '' is to avoid changing the remaining quantity for partly sold Lots
                // because this will cause undefined quantities in the item tracking
                "Remaining Quantity" := Quantity;
              if ToPurchLine."Job No." = '' then
                ReservEntry.Validate("Quantity (Base)","Remaining Quantity" * SignFactor)
              else begin
                ItemLedgEntry.Get("Entry No.");
                ReservEntry.Validate("Quantity (Base)",Abs(ItemLedgEntry.Quantity) * SignFactor);
              end;
              ReservEntry.Positive := (ReservEntry."Quantity (Base)" > 0);
              ReservEntry."Entry No." := 0;
              if ReservEntry.Positive then begin
                ReservEntry."Warranty Date" := "Warranty Date";
                ReservEntry."Expiration Date" :=
                  ExistingExpirationDate("Item No.","Variant Code","Lot No.","Serial No.",false,EntriesExist);
                ReservEntry."Expected Receipt Date" := ToPurchLine."Expected Receipt Date"
              end else
                ReservEntry."Shipment Date" := ToPurchLine."Expected Receipt Date";

              if FillExactCostRevLink then begin
                if LinkThisEntry then begin
                  ReservEntry."Appl.-to Item Entry" := "Entry No.";
                  if not MissingExCostRevLink then begin
                    CalcFields("Cost Amount (Actual)","Cost Amount (Expected)");
                    TotalCostLCY :=
                      TotalCostLCY + "Cost Amount (Expected)" + "Cost Amount (Actual)";
                    ItemLedgEntryQty := ItemLedgEntryQty - Quantity;
                  end;
                end else
                  MissingExCostRevLink := true;
              end;

              ReservEntry.Description := ToPurchLine.Description;
              ReservEntry."Creation Date" := WorkDate;
              ReservEntry."Created By" := UserId;
              ReservEntry.UpdateItemTracking;
              ReservEntry.Insert;

              if FillExactCostRevLink and not LinkThisEntry then
                MissingExCostRevLink := true;
            until Next = 0;

            if FillExactCostRevLink and not MissingExCostRevLink then begin
              ToPurchLine.Validate(
                "Unit Cost (LCY)",
                Abs(TotalCostLCY / ItemLedgEntryQty) * ToPurchLine."Qty. per Unit of Measure");
              if not FromShptOrRcpt then
                CopyDocMgt.CalculateRevPurchLineAmount(
                  ToPurchLine,ItemLedgEntryQty,FromPricesInclVAT,ToPricesInclVAT);

              ToPurchLine.Modify;
            end;
          end;
    end;


    procedure SynchronizeWhseActivItemTrkg(WhseActivLine: Record "Warehouse Activity Line")
    var
        TempTrackingSpec: Record "Tracking Specification" temporary;
        TempReservEntry: Record "Reservation Entry" temporary;
        ReservEntry: Record "Reservation Entry";
        ReservEntryBindingCheck: Record "Reservation Entry";
        ATOSalesLine: Record "Sales Line";
        AsmHeader: Record "Assembly Header";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ReservMgt: Codeunit "Reservation Management";
        SignFactor: Integer;
        ToRowID: Text[250];
        IsTransferReceipt: Boolean;
        IsATOPosting: Boolean;
        IsBindingOrderToOrder: Boolean;
    begin
        // Used for carrying the item tracking from the invt. pick/put-away to the parent line.
        with WhseActivLine do begin
          Reset;
          SetSourceFilter;
          SetRange("Assemble to Order","Assemble to Order");
          if FindSet then begin
            // Transfer receipt needs special treatment:
            IsTransferReceipt := ("Source Type" = Database::"Transfer Line") and ("Source Subtype" = 1);
            IsATOPosting := ("Source Type" = Database::"Sales Line") and "Assemble to Order";
            if ("Source Type" in [Database::"Prod. Order Line",Database::"Prod. Order Component"]) or IsTransferReceipt then
              ToRowID :=
                ItemTrackingMgt.ComposeRowID(
                  "Source Type","Source Subtype","Source No.",'',"Source Line No.","Source Subline No.")
            else begin
              if IsATOPosting then begin
                ATOSalesLine.Get("Source Subtype","Source No.","Source Line No.");
                ATOSalesLine.AsmToOrderExists(AsmHeader);
                ToRowID :=
                  ItemTrackingMgt.ComposeRowID(
                    Database::"Assembly Header",AsmHeader."Document Type",AsmHeader."No.",'',0,0);
              end else
                ToRowID :=
                  ItemTrackingMgt.ComposeRowID(
                    "Source Type","Source Subtype","Source No.",'',"Source Subline No.","Source Line No.");
            end;
            TempReservEntry.SetPointer(ToRowID);
            SignFactor := WhseActivitySignFactor(WhseActivLine);
            ReservEntryBindingCheck.SetPointer(ToRowID);
            ReservMgt.SetPointerFilter(ReservEntryBindingCheck);
            repeat
              if TrackingExists then begin
                TempReservEntry."Entry No." += 1;
                if SignFactor > 0 then
                  TempReservEntry.Positive := true
                else
                  TempReservEntry.Positive := false;
                TempReservEntry."Item No." := "Item No.";
                TempReservEntry."Location Code" := "Location Code";
                TempReservEntry.Description := Description;
                TempReservEntry."Variant Code" := "Variant Code";
                TempReservEntry."Quantity (Base)" := "Qty. Outstanding (Base)" * SignFactor;
                TempReservEntry.Quantity := "Qty. Outstanding" * SignFactor;
                TempReservEntry."Qty. to Handle (Base)" := "Qty. to Handle (Base)" * SignFactor;
                TempReservEntry."Qty. to Invoice (Base)" := "Qty. to Handle (Base)" * SignFactor;
                TempReservEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                TempReservEntry."Lot No." := "Lot No.";
                TempReservEntry."Serial No." := "Serial No.";
                TempReservEntry."Expiration Date" := "Expiration Date";
                TempReservEntry.Insert;

                if not IsBindingOrderToOrder then begin
                  ReservEntryBindingCheck.SetRange("Lot No.","Lot No.");
                  ReservEntryBindingCheck.SetRange("Serial No.","Serial No.");
                  ReservEntryBindingCheck.SetRange(Binding,ReservEntryBindingCheck.Binding::"Order-to-Order");
                  IsBindingOrderToOrder := not ReservEntryBindingCheck.IsEmpty;
                end;
              end;
            until Next = 0;

            if TempReservEntry.IsEmpty then
              exit;
          end;
        end;

        SumUpItemTracking(TempReservEntry,TempTrackingSpec,false,true);
        // Item Tracking cannot be changed on transfer receipt and on binding order-to-order
        if not IsTransferReceipt and not IsBindingOrderToOrder then
          SynchronizeItemTracking2(TempReservEntry,ToRowID,'');
        ReservEntry.SetPointer(ToRowID);
        ReservMgt.SetPointerFilter(ReservEntry);

        if IsTransferReceipt then
          ReservEntry.SetRange("Source Ref. No.");

        if ReservEntry.FindSet then
          repeat
            TempTrackingSpec.SetRange("Lot No.",ReservEntry."Lot No.");
            TempTrackingSpec.SetRange("Serial No.",ReservEntry."Serial No.");
            if TempTrackingSpec.FindFirst then begin
              if Abs(TempTrackingSpec."Qty. to Handle (Base)") > Abs(ReservEntry."Quantity (Base)") then
                ReservEntry.Validate("Qty. to Handle (Base)",ReservEntry."Quantity (Base)")
              else
                ReservEntry.Validate("Qty. to Handle (Base)",TempTrackingSpec."Qty. to Handle (Base)");

              if Abs(TempTrackingSpec."Qty. to Invoice (Base)") > Abs(ReservEntry."Quantity (Base)") then
                ReservEntry.Validate("Qty. to Invoice (Base)",ReservEntry."Quantity (Base)")
              else
                ReservEntry.Validate("Qty. to Invoice (Base)",TempTrackingSpec."Qty. to Invoice (Base)");

              TempTrackingSpec."Qty. to Handle (Base)" -= ReservEntry."Qty. to Handle (Base)";
              TempTrackingSpec."Qty. to Invoice (Base)" -= ReservEntry."Qty. to Invoice (Base)";
              TempTrackingSpec.Modify;

              with WhseActivLine do begin
                Reset;
                SetSourceFilter;
                SetRange("Lot No.",ReservEntry."Lot No.");
                SetRange("Serial No.",ReservEntry."Serial No.");
                if FindFirst then
                  ReservEntry."Expiration Date" := "Expiration Date";
              end;

              ReservEntry.Modify;
            end else begin
              if IsTransferReceipt then begin
                ReservEntry.Validate("Qty. to Handle (Base)",0);
                ReservEntry.Validate("Qty. to Invoice (Base)",0);
                ReservEntry.Modify;
              end;
            end;
          until ReservEntry.Next = 0;

        TempTrackingSpec.Reset;
        TempTrackingSpec.CalcSums("Qty. to Handle (Base)","Qty. to Invoice (Base)");
        if (TempTrackingSpec."Qty. to Handle (Base)" <> 0) or (TempTrackingSpec."Qty. to Invoice (Base)" <> 0) then
          Error(Text002);
    end;

    local procedure WhseActivitySignFactor(WhseActivityLine: Record "Warehouse Activity Line"): Integer
    begin
        if WhseActivityLine."Activity Type" = WhseActivityLine."activity type"::"Invt. Pick" then begin
          if WhseActivityLine."Assemble to Order" then
            exit(1);
          exit(-1);
        end;
        if WhseActivityLine."Activity Type" = WhseActivityLine."activity type"::"Invt. Put-away" then
          exit(1);

        Error(Text011,WhseActivityLine.FieldCaption("Activity Type"),WhseActivityLine."Activity Type");
    end;


    procedure RetrieveAppliedExpirationDate(var TempItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemApplnEntry: Record "Item Application Entry";
    begin
        with TempItemLedgEntry do begin
          if Positive then
            exit;

          ItemApplnEntry.Reset;
          ItemApplnEntry.SetCurrentkey("Outbound Item Entry No.","Item Ledger Entry No.","Cost Application");
          ItemApplnEntry.SetRange("Outbound Item Entry No.","Entry No.");
          ItemApplnEntry.SetRange("Item Ledger Entry No.","Entry No.");
          if ItemApplnEntry.FindFirst then begin
            ItemLedgEntry.Get(ItemApplnEntry."Inbound Item Entry No.");
            "Expiration Date" := ItemLedgEntry."Expiration Date";
          end;
        end;
    end;

    local procedure ItemTrkgQtyPostedOnSource(SourceTrackingSpec: Record "Tracking Specification") Qty: Decimal
    var
        TrackingSpecification: Record "Tracking Specification";
        ReservEntry: Record "Reservation Entry";
        TransferLine: Record "Transfer Line";
    begin
        with SourceTrackingSpec do begin
          TrackingSpecification.SetCurrentkey(
            "Source ID","Source Type","Source Subtype",
            "Source Batch Name","Source Prod. Order Line","Source Ref. No.");

          TrackingSpecification.SetRange("Source ID","Source ID");
          TrackingSpecification.SetRange("Source Type","Source Type");
          TrackingSpecification.SetRange("Source Subtype","Source Subtype");
          TrackingSpecification.SetRange("Source Batch Name","Source Batch Name");
          TrackingSpecification.SetRange("Source Prod. Order Line","Source Prod. Order Line");
          TrackingSpecification.SetRange("Source Ref. No.","Source Ref. No.");
          if not TrackingSpecification.IsEmpty then begin
            TrackingSpecification.FindSet;
            repeat
              Qty += TrackingSpecification."Quantity (Base)";
            until TrackingSpecification.Next = 0;
          end;

          ReservEntry.SetRange("Source ID","Source ID");
          ReservEntry.SetRange("Source Ref. No.","Source Ref. No.");
          ReservEntry.SetRange("Source Type","Source Type");
          ReservEntry.SetRange("Source Subtype","Source Subtype");
          ReservEntry.SetRange("Source Batch Name",'');
          ReservEntry.SetRange("Source Prod. Order Line","Source Prod. Order Line");
          if not ReservEntry.IsEmpty then begin
            ReservEntry.FindSet;
            repeat
              Qty += ReservEntry."Qty. to Handle (Base)";
            until ReservEntry.Next = 0;
          end;
          if "Source Type" = Database::"Transfer Line" then begin
            TransferLine.Get("Source ID","Source Ref. No.");
            Qty -= TransferLine."Qty. Shipped (Base)";
          end;
        end;
    end;

    local procedure SynchronizeItemTrkgTransfer(var ToReservEntry: Record "Reservation Entry")
    var
        FromReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        QtyToHandleBase: Decimal;
        QtyToInvoiceBase: Decimal;
        QtyBase: Decimal;
    begin
        FromReservEntry.Copy(ToReservEntry);
        FromReservEntry.SetRange("Source Subtype",0);
        if ToReservEntry.FindSet then
          repeat
            TempReservEntry := ToReservEntry;
            TempReservEntry.Insert;
          until ToReservEntry.Next = 0;

        TempReservEntry.SetCurrentkey(
          "Item No.","Variant Code","Location Code","Item Tracking","Reservation Status","Lot No.","Serial No.");
        if TempReservEntry.Find('-') then
          repeat
            FromReservEntry.SetRange("Lot No.",TempReservEntry."Lot No.");
            FromReservEntry.SetRange("Serial No.",TempReservEntry."Serial No.");

            QtyToHandleBase := 0;
            QtyToInvoiceBase := 0;
            QtyBase := 0;
            if FromReservEntry.Find('-') then
              // due to Order Tracking there can be more than 1 record
              repeat
                QtyToHandleBase += FromReservEntry."Qty. to Handle (Base)";
                QtyToInvoiceBase += FromReservEntry."Qty. to Invoice (Base)";
                QtyBase += FromReservEntry."Quantity (Base)";
              until FromReservEntry.Next = 0;

            TempReservEntry.SetRange("Lot No.",TempReservEntry."Lot No.");
            TempReservEntry.SetRange("Serial No.",TempReservEntry."Serial No.");
            repeat
              // remove already synchronized qty (can be also more than 1 record)
              QtyToHandleBase += TempReservEntry."Qty. to Handle (Base)";
              QtyToInvoiceBase += TempReservEntry."Qty. to Invoice (Base)";
              QtyBase += TempReservEntry."Quantity (Base)";
              TempReservEntry.Delete;
            until TempReservEntry.Next = 0;
            TempReservEntry.SetRange("Lot No.");
            TempReservEntry.SetRange("Serial No.");

            if QtyToHandleBase <> 0 then begin
              // remaining qty will be added to the last record
              ToReservEntry := TempReservEntry;
              if QtyBase <> 0 then begin
                ToReservEntry."Qty. to Handle (Base)" := -QtyToHandleBase;
                ToReservEntry."Qty. to Invoice (Base)" := -QtyToInvoiceBase;
              end else begin
                ToReservEntry."Qty. to Handle (Base)" -= QtyToHandleBase;
                ToReservEntry."Qty. to Invoice (Base)" -= QtyToInvoiceBase;
              end;
              ToReservEntry.Modify;
            end;
          until TempReservEntry.Next = 0;
    end;


    procedure InitCollectItemTrkgInformation()
    begin
        TempGlobalWhseItemTrkgLine.DeleteAll;
    end;


    procedure CollectItemTrkgInfWhseJnlLine(WhseJnlLine: Record "Warehouse Journal Line")
    var
        WhseItemTrkgLinLocal: Record "Whse. Item Tracking Line";
    begin
        Clear(WhseItemTrkgLinLocal);
        WhseItemTrkgLinLocal.SetCurrentkey(
          "Source ID",
          "Source Type",
          "Source Subtype",
          "Source Batch Name",
          "Source Prod. Order Line",
          "Source Ref. No.",
          "Location Code");
        WhseItemTrkgLinLocal.SetRange("Source ID",WhseJnlLine."Journal Batch Name");
        WhseItemTrkgLinLocal.SetRange("Source Type",Database::"Warehouse Journal Line");
        WhseItemTrkgLinLocal.SetRange("Source Batch Name",WhseJnlLine."Journal Template Name");
        WhseItemTrkgLinLocal.SetRange("Source Ref. No.",WhseJnlLine."Line No.");
        WhseItemTrkgLinLocal.SetRange("Location Code",WhseJnlLine."Location Code");
        WhseItemTrkgLinLocal.SetRange("Item No.",WhseJnlLine."Item No.");
        WhseItemTrkgLinLocal.SetRange("Variant Code",WhseJnlLine."Variant Code");
        WhseItemTrkgLinLocal.SetRange("Qty. per Unit of Measure",WhseJnlLine."Qty. per Unit of Measure");

        if WhseItemTrkgLinLocal.FindSet then
          repeat
            Clear(TempGlobalWhseItemTrkgLine);
            TempGlobalWhseItemTrkgLine := WhseItemTrkgLinLocal;
            if TempGlobalWhseItemTrkgLine.Insert then;
          until WhseItemTrkgLinLocal.Next = 0;
    end;


    procedure CheckItemTrkgInfBeforePost()
    var
        TempItemLotInfo: Record "Lot No. Information" temporary;
        CheckExpDate: Date;
        ErrorFound: Boolean;
        EndLoop: Boolean;
        ErrMsgTxt: Text[160];
    begin
        // Check for different expiration dates within one Lot no.
        if TempGlobalWhseItemTrkgLine.Find('-') then begin
          TempItemLotInfo.DeleteAll;
          repeat
            if TempGlobalWhseItemTrkgLine."New Lot No." <> '' then begin
              Clear(TempItemLotInfo);
              TempItemLotInfo."Item No." := TempGlobalWhseItemTrkgLine."Item No.";
              TempItemLotInfo."Variant Code" := TempGlobalWhseItemTrkgLine."Variant Code";
              TempItemLotInfo."Lot No." := TempGlobalWhseItemTrkgLine."New Lot No.";
              if TempItemLotInfo.Insert then;
            end;
          until TempGlobalWhseItemTrkgLine.Next = 0;

          if TempItemLotInfo.Find('-') then
            repeat
              ErrorFound := false;
              EndLoop := false;
              if TempGlobalWhseItemTrkgLine.Find('-') then begin
                CheckExpDate := 0D;
                repeat
                  if (TempGlobalWhseItemTrkgLine."Item No." = TempItemLotInfo."Item No.") and
                     (TempGlobalWhseItemTrkgLine."Variant Code" = TempItemLotInfo."Variant Code") and
                     (TempGlobalWhseItemTrkgLine."New Lot No." = TempItemLotInfo."Lot No.")
                  then begin
                    if CheckExpDate = 0D then
                      CheckExpDate := TempGlobalWhseItemTrkgLine."New Expiration Date"
                    else
                      if TempGlobalWhseItemTrkgLine."New Expiration Date" <> CheckExpDate then begin
                        ErrorFound := true;
                        ErrMsgTxt :=
                          StrSubstNo(Text012,
                            TempGlobalWhseItemTrkgLine."Lot No.",
                            TempGlobalWhseItemTrkgLine."New Expiration Date",
                            CheckExpDate);
                      end;
                  end;
                  if not ErrorFound then
                    if TempGlobalWhseItemTrkgLine.Next = 0 then
                      EndLoop := true;
                until EndLoop or ErrorFound;
              end;
            until (TempItemLotInfo.Next = 0) or ErrorFound;
          if ErrorFound then
            Error(ErrMsgTxt);
        end;
    end;


    procedure SetPick(IsPick2: Boolean)
    begin
        IsPick := IsPick2;
    end;


    procedure StrictExpirationPosting(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
    begin
        Item.Get(ItemNo);
        if Item."Item Tracking Code" = '' then
          exit(false);
        ItemTrackingCode.Get(Item."Item Tracking Code");
        exit(ItemTrackingCode."Strict Expiration Posting");
    end;


    procedure WhseItemTrkgLineExists(SourceId: Code[20];SourceType: Integer;SourceSubtype: Option "0","1","2","3","4","5","6","7","8","9","10";SourceBatchName: Code[10];SourceProdOrderLine: Integer;SourceRefNo: Integer;LocationCode: Code[10];SerialNo: Code[20];LotNo: Code[20]): Boolean
    var
        WhseItemTrkgLine: Record "Whse. Item Tracking Line";
    begin
        with WhseItemTrkgLine do begin
          SetCurrentkey(
            "Source ID","Source Type","Source Subtype","Source Batch Name",
            "Source Prod. Order Line","Source Ref. No.","Location Code");
          SetRange("Source ID",SourceId);
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubtype);
          SetRange("Source Batch Name",SourceBatchName);
          SetRange("Source Prod. Order Line",SourceProdOrderLine);
          SetRange("Source Ref. No.",SourceRefNo);
          SetRange("Location Code",LocationCode);
          if SerialNo <> '' then
            SetRange("Serial No.",SerialNo);
          if LotNo <> '' then
            SetRange("Lot No.",LotNo);
          exit(not IsEmpty);
        end;
    end;

    local procedure SetWhseSerialLotNo(var DestNo: Code[20];SourceNo: Code[20];NoRequired: Boolean)
    begin
        if NoRequired then
          DestNo := SourceNo;
    end;

    local procedure InsertProspectReservEntryFromItemEntryRelationAndSourceData(var ItemEntryRelation: Record "Item Entry Relation";SourceSubtype: Option;SourceID: Code[20];SourceRefNo: Integer)
    var
        TrackingSpecification: Record "Tracking Specification";
        ReservEntry: Record "Reservation Entry";
        QtyBase: Decimal;
    begin
        if not ItemEntryRelation.FindSet then
          exit;

        repeat
          TrackingSpecification.Get(ItemEntryRelation."Item Entry No.");
          QtyBase := TrackingSpecification."Quantity (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
          if QtyBase <> 0 then
            with ReservEntry do begin
              Init;
              TransferFields(TrackingSpecification);
              "Source Subtype" := SourceSubtype;
              "Source ID" := SourceID;
              "Source Ref. No." := SourceRefNo;
              "Reservation Status" := "reservation status"::Prospect;
              "Quantity Invoiced (Base)" := 0;
              Validate("Quantity (Base)",QtyBase);
              Positive := ("Quantity (Base)" > 0);
              "Entry No." := 0;
              "Item Tracking" := ItemTrackingOption("Lot No.","Serial No.");
              Insert;
            end;
        until ItemEntryRelation.Next = 0;
    end;


    procedure UpdateQuantities(WhseWorksheetLine: Record "Whse. Worksheet Line";var TotalWhseItemTrackingLine: Record "Whse. Item Tracking Line";var SourceQuantityArray: array [2] of Decimal;var UndefinedQtyArray: array [2] of Decimal;SourceType: Integer): Boolean
    begin
        SourceQuantityArray[1] := Abs(WhseWorksheetLine."Qty. (Base)");
        SourceQuantityArray[2] := Abs(WhseWorksheetLine."Qty. to Handle (Base)");
        exit(CalculateSums(WhseWorksheetLine,TotalWhseItemTrackingLine,SourceQuantityArray,UndefinedQtyArray,SourceType));
    end;


    procedure CalculateSums(WhseWorksheetLine: Record "Whse. Worksheet Line";var TotalWhseItemTrackingLine: Record "Whse. Item Tracking Line";SourceQuantityArray: array [2] of Decimal;var UndefinedQtyArray: array [2] of Decimal;SourceType: Integer): Boolean
    begin
        with TotalWhseItemTrackingLine do begin
          SetCurrentkey(
            "Source ID","Source Type","Source Subtype","Source Batch Name",
            "Source Prod. Order Line","Source Ref. No.");
          SetRange("Source Type",SourceType);
          SetRange("Location Code",WhseWorksheetLine."Location Code");

          case SourceType of
            Database::"Posted Whse. Receipt Line",
            Database::"Warehouse Shipment Line",
            Database::"Whse. Internal Put-away Line",
            Database::"Whse. Internal Pick Line",
            Database::"Assembly Line",
            Database::"Internal Movement Line":
              begin
                SetRange("Source ID",WhseWorksheetLine."Whse. Document No.");
                SetRange("Source Ref. No.",WhseWorksheetLine."Whse. Document Line No.");
              end;
            Database::"Prod. Order Component":
              begin
                SetRange("Source Subtype",WhseWorksheetLine."Source Subtype");
                SetRange("Source ID",WhseWorksheetLine."Source No.");
                SetRange("Source Prod. Order Line",WhseWorksheetLine."Source Line No.");
                SetRange("Source Ref. No.",WhseWorksheetLine."Source Subline No.");
              end;
            Database::"Whse. Worksheet Line",
            Database::"Warehouse Journal Line":
              begin
                SetRange("Source Batch Name",WhseWorksheetLine."Worksheet Template Name");
                SetRange("Source ID",WhseWorksheetLine.Name);
                SetRange("Source Ref. No.",WhseWorksheetLine."Line No.");
              end;
          end;
          CalcSums("Quantity (Base)","Qty. to Handle (Base)");
        end;
        exit(UpdateUndefinedQty(TotalWhseItemTrackingLine,SourceQuantityArray,UndefinedQtyArray));
    end;


    procedure UpdateUndefinedQty(TotalWhseItemTrackingLine: Record "Whse. Item Tracking Line";SourceQuantityArray: array [2] of Decimal;var UndefinedQtyArray: array [2] of Decimal): Boolean
    begin
        UndefinedQtyArray[1] := SourceQuantityArray[1] - TotalWhseItemTrackingLine."Quantity (Base)";
        UndefinedQtyArray[2] := SourceQuantityArray[2] - TotalWhseItemTrackingLine."Qty. to Handle (Base)";
        exit(not (Abs(SourceQuantityArray[1]) < Abs(TotalWhseItemTrackingLine."Quantity (Base)")));
    end;


    procedure DeleteInvoiceSpecFromHeader(SourceType: Integer;SourceSubtype: Option;SourceID: Code[20])
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        TrackingSpecification.SetRange("Source Type",SourceType);
        TrackingSpecification.SetRange("Source Subtype",SourceSubtype);
        TrackingSpecification.SetRange("Source ID",SourceID);
        TrackingSpecification.SetRange("Source Batch Name",'');
        TrackingSpecification.SetRange("Source Prod. Order Line",0);
        TrackingSpecification.DeleteAll;
    end;


    procedure DeleteInvoiceSpecFromLine(SourceType: Integer;SourceSubtype: Option;SourceID: Code[20];SourceRefNo: Integer)
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        TrackingSpecification.SetRange("Source Type",SourceType);
        TrackingSpecification.SetRange("Source Subtype",SourceSubtype);
        TrackingSpecification.SetRange("Source ID",SourceID);
        TrackingSpecification.SetRange("Source Batch Name",'');
        TrackingSpecification.SetRange("Source Prod. Order Line",0);
        TrackingSpecification.SetRange("Source Ref. No.",SourceRefNo);
        TrackingSpecification.DeleteAll;
    end;


    procedure CallPostedItemTrackingForm(Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer): Boolean
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
    begin
        // Used when calling Item Tracking from Posted Shipments/Receipts:

        RetrieveILEFromShptRcpt(TempItemLedgEntry,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo);
        if not TempItemLedgEntry.IsEmpty then begin
          Page.RunModal(Page::"Posted Item Tracking Lines",TempItemLedgEntry);
          exit(true);
        end;
        exit(false);
    end;


    procedure CallPostedItemTrackingForm2(Type: Integer;Subtype: Integer;ID: Code[20];RefNo: Integer): Boolean
    var
        ItemEntryRelation: Record "Item Entry Relation";
        ItemLedgEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        SignFactor: Integer;
    begin
        // Used when calling Item Tracking from Posted Whse Activity Lines:

        case Type of
          Database::"Sales Line":
            Type := Database::"Sales Shipment Line";
          Database::"Purchase Line":
            Type := Database::"Purch. Rcpt. Line";
          Database::"Prod. Order Component":
            ;
          Database::"Transfer Line":
            if Subtype = 0 then
              Type := Database::"Transfer Shipment Line"
            else
              Type := Database::"Transfer Receipt Line";
        end;

        ItemEntryRelation.SetCurrentkey("Order No.","Order Line No.");
        ItemEntryRelation.SetRange("Source Type",Type);
        ItemEntryRelation.SetRange("Order No.",ID);
        ItemEntryRelation.SetRange("Order Line No.",RefNo);
        if ItemEntryRelation.FindSet then begin
          SignFactor := TableSignFactor(Type);
          repeat
            ItemLedgEntry.Get(ItemEntryRelation."Item Entry No.");
            TempItemLedgEntry := ItemLedgEntry;
            AddTempRecordToSet(TempItemLedgEntry,SignFactor);
          until ItemEntryRelation.Next = 0;
          Page.RunModal(Page::"Posted Item Tracking Lines",TempItemLedgEntry);
          exit(true);
        end;
        exit(false);
    end;


    procedure CallPostedItemTrackingForm3(InvoiceRowID: Text[100]): Boolean
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
    begin
        // Used when calling Item Tracking from invoiced documents:

        RetrieveILEFromPostedInv(TempItemLedgEntry,InvoiceRowID);
        if not TempItemLedgEntry.IsEmpty then begin
          Page.RunModal(Page::"Posted Item Tracking Lines",TempItemLedgEntry);
          exit(true);
        end;
        exit(false);
    end;


    procedure CallPostedItemTrackingForm4(Type: Integer;ID: Code[20];ProdOrderLine: Integer;RefNo: Integer): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        Window: Dialog;
    begin
        // Used when calling Item Tracking from finished prod. order and component:
        Window.Open(Text004);
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
            if (ItemLedgEntry."Serial No." <> '') or (ItemLedgEntry."Lot No." <> '') then begin
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


    procedure CallItemTrackingEntryForm(SourceType: Option " ",Customer,Vendor,Item;SourceNo: Code[20];ItemNo: Code[20];VariantCode: Code[20];SerialNo: Code[20];LotNo: Code[20];LocationCode: Code[10])
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        Item: Record Item;
        Window: Dialog;
    begin
        // Used when calling Item Tracking from Item, Stockkeeping Unit, Customer, Vendor and information card:
        Window.Open(Text004);

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
            if (ItemLedgEntry."Serial No." <> '') or (ItemLedgEntry."Lot No." <> '') then begin
              TempItemLedgEntry := ItemLedgEntry;
              TempItemLedgEntry.Insert;
            end
          until ItemLedgEntry.Next = 0;
        Window.Close;
        Page.RunModal(Page::"Item Tracking Entries",TempItemLedgEntry);
    end;

    local procedure RetrieveILEFromShptRcpt(var TempItemLedgEntry: Record "Item Ledger Entry" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer)
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

    local procedure RetrieveILEFromPostedInv(var TempItemLedgEntry: Record "Item Ledger Entry" temporary;InvoiceRowID: Text[250])
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


    procedure CollectItemTrkgPerPstdDocLine(var TempItemLedgEntry: Record "Item Ledger Entry" temporary;var ItemLedgEntry: Record "Item Ledger Entry")
    begin
        TempItemLedgEntry.Reset;
        TempItemLedgEntry.DeleteAll;

        if ItemLedgEntry.FindSet then
          repeat
            TempItemLedgEntry := ItemLedgEntry;
            AddTempRecordToSet(TempItemLedgEntry,1);
          until ItemLedgEntry.Next = 0;

        TempItemLedgEntry.Reset;
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

    local procedure AddTempRecordToSet(var TempItemLedgEntry: Record "Item Ledger Entry" temporary;SignFactor: Integer)
    var
        TempItemLedgEntry2: Record "Item Ledger Entry" temporary;
    begin
        if SignFactor <> 1 then begin
          TempItemLedgEntry.Quantity *= SignFactor;
          TempItemLedgEntry."Remaining Quantity" *= SignFactor;
          TempItemLedgEntry."Invoiced Quantity" *= SignFactor;
        end;
        RetrieveAppliedExpirationDate(TempItemLedgEntry);
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
}

