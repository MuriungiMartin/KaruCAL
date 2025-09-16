#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5985 "Serv-Item Tracking Rsrv. Mgt."
{
    Permissions = TableData "Value Entry Relation"=ri;

    trigger OnRun()
    begin
    end;

    var
        ReserveServLine: Codeunit "Service Line-Reserve";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        Text001: label 'The %1 does not match the quantity defined in item tracking.';


    procedure CheckTrackingSpecification(ServHeader: Record "Service Header";var ServLine: Record "Service Line")
    var
        ServLineToCheck: Record "Service Line";
        ReservationEntry: Record "Reservation Entry";
        ItemTrackingCode: Record "Item Tracking Code";
        Item: Record Item;
        ItemJnlLine: Record "Item Journal Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ErrorFieldCaption: Text[250];
        SignFactor: Integer;
        ServLineQtyHandled: Decimal;
        ServLineQtyToHandle: Decimal;
        TrackingQtyHandled: Decimal;
        TrackingQtyToHandle: Decimal;
        Inbound: Boolean;
        SNRequired: Boolean;
        LotRequired: Boolean;
        SNInfoRequired: Boolean;
        LotInfoReguired: Boolean;
        CheckServLine: Boolean;
    begin
        // if a SalesLine is posted with ItemTracking then the whole quantity of
        // the regarding SalesLine has to be post with Item-Tracking

        if ServHeader."Document Type" <> ServHeader."document type"::Order then
          exit;

        TrackingQtyToHandle := 0;
        TrackingQtyHandled := 0;

        ServLineToCheck.Copy(ServLine);
        ServLineToCheck.SetRange("Document Type",ServLine."Document Type");
        ServLineToCheck.SetRange("Document No.",ServLine."Document No.");
        ServLineToCheck.SetRange(Type,ServLineToCheck.Type::Item);
        ServLineToCheck.SetFilter("Quantity Shipped",'<>%1',0);
        ErrorFieldCaption := ServLineToCheck.FieldCaption("Qty. to Ship");

        if ServLineToCheck.FindSet then begin
          ReservationEntry."Source Type" := Database::"Service Line";
          ReservationEntry."Source Subtype" := ServHeader."Document Type";
          SignFactor := CreateReservEntry.SignFactor(ReservationEntry);
          repeat
            // Only Item where no SerialNo or LotNo is required
            ServLineToCheck.TestField(Type,ServLineToCheck.Type::Item);
            ServLineToCheck.TestField("No.");
            Item.Get(ServLineToCheck."No.");
            if Item."Item Tracking Code" <> '' then begin
              Inbound := (ServLineToCheck.Quantity * SignFactor) > 0;
              ItemTrackingCode.Code := Item."Item Tracking Code";
              ItemTrackingMgt.GetItemTrackingSettings(ItemTrackingCode,
                ItemJnlLine."entry type"::Sale,
                Inbound,
                SNRequired,
                LotRequired,
                SNInfoRequired,
                LotInfoReguired);
              CheckServLine := (SNRequired = false) and (LotRequired = false);
              if CheckServLine then
                CheckServLine := GetTrackingQuantities(ServLineToCheck,0,TrackingQtyToHandle,TrackingQtyHandled);
            end else
              CheckServLine := false;

            TrackingQtyToHandle := 0;
            TrackingQtyHandled := 0;

            if CheckServLine then begin
              GetTrackingQuantities(ServLineToCheck,1,TrackingQtyToHandle,TrackingQtyHandled);
              TrackingQtyToHandle := TrackingQtyToHandle * SignFactor;
              TrackingQtyHandled := TrackingQtyHandled * SignFactor;
              ServLineQtyToHandle := ServLineToCheck."Qty. to Ship (Base)";
              ServLineQtyHandled := ServLineToCheck."Qty. Shipped (Base)";
              if ((TrackingQtyHandled + TrackingQtyToHandle) <> (ServLineQtyHandled + ServLineQtyToHandle)) or
                 (TrackingQtyToHandle <> ServLineQtyToHandle)
              then
                Error(StrSubstNo(Text001,ErrorFieldCaption));
            end;
          until ServLineToCheck.Next = 0;
        end;
    end;

    local procedure GetTrackingQuantities(ServLine: Record "Service Line";FunctionType: Option CheckTrackingExists,GetQty;var TrackingQtyToHandle: Decimal;var TrackingQtyHandled: Decimal): Boolean
    var
        TrackingSpecification: Record "Tracking Specification";
        ReservEntry: Record "Reservation Entry";
    begin
        with TrackingSpecification do begin
          SetCurrentkey("Source ID","Source Type","Source Subtype","Source Batch Name",
            "Source Prod. Order Line","Source Ref. No.");
          SetRange("Source Type",Database::"Service Line");
          SetRange("Source Subtype",ServLine."Document Type");
          SetRange("Source ID",ServLine."Document No.");
          SetRange("Source Batch Name",'');
          SetRange("Source Prod. Order Line",0);
          SetRange("Source Ref. No.",ServLine."Line No.");
        end;
        with ReservEntry do begin
          SetCurrentkey(
            "Source ID","Source Ref. No.","Source Type","Source Subtype",
            "Source Batch Name","Source Prod. Order Line");
          SetRange("Source ID",ServLine."Document No.");
          SetRange("Source Ref. No.",ServLine."Line No.");
          SetRange("Source Type",Database::"Service Line");
          SetRange("Source Subtype",ServLine."Document Type");
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
              TrackingSpecification.CalcSums("Quantity Handled (Base)");
              TrackingQtyHandled := TrackingSpecification."Quantity Handled (Base)";
              if ReservEntry.FindSet then
                repeat
                  if ReservEntry.TrackingExists then
                    TrackingQtyToHandle := TrackingQtyToHandle + ReservEntry."Qty. to Handle (Base)";
                until ReservEntry.Next = 0;
            end;
        end;
    end;


    procedure SaveInvoiceSpecification(var TempInvoicingSpecification: Record "Tracking Specification" temporary;var TempTrackingSpecification: Record "Tracking Specification")
    begin
        TempInvoicingSpecification.Reset;
        if TempInvoicingSpecification.Find('-') then begin
          repeat
            TempInvoicingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
            TempTrackingSpecification := TempInvoicingSpecification;
            TempTrackingSpecification."Buffer Status" := TempTrackingSpecification."buffer status"::Modify;
            TempTrackingSpecification.Insert;
          until TempInvoicingSpecification.Next = 0;
          TempInvoicingSpecification.DeleteAll;
        end;
    end;


    procedure InsertTrackingSpecification(var ServHeader: Record "Service Header";var TempTrackingSpecification: Record "Tracking Specification")
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        TempTrackingSpecification.Reset;
        if TempTrackingSpecification.Find('-') then begin
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
        end;

        ReserveServLine.UpdateItemTrackingAfterPosting(ServHeader);
    end;


    procedure InsertTempHandlngSpecification(SrcType: Integer;var ServLine: Record "Service Line";var TempHandlingSpecification: Record "Tracking Specification";var TempTrackingSpecification: Record "Tracking Specification";var TempTrackingSpecificationInv: Record "Tracking Specification";QtyToInvoiceNonZero: Boolean)
    begin
        with ServLine do begin
          if TempHandlingSpecification.Find('-') then
            repeat
              TempTrackingSpecification := TempHandlingSpecification;
              TempTrackingSpecification."Source Type" := SrcType;
              TempTrackingSpecification."Source Subtype" := "Document Type";
              TempTrackingSpecification."Source ID" := "Document No.";
              TempTrackingSpecification."Source Batch Name" := '';
              TempTrackingSpecification."Source Prod. Order Line" := 0;
              TempTrackingSpecification."Source Ref. No." := "Line No.";
              if TempTrackingSpecification.Insert then;
              if QtyToInvoiceNonZero then begin
                TempTrackingSpecificationInv := TempTrackingSpecification;
                if TempTrackingSpecificationInv.Insert then;
              end;
            until TempHandlingSpecification.Next = 0;
        end;
    end;


    procedure RetrieveInvoiceSpecification(var ServLine: Record "Service Line";var TempInvoicingSpecification: Record "Tracking Specification";Consume: Boolean) Ok: Boolean
    begin
        Ok := ReserveServLine.RetrieveInvoiceSpecification(ServLine,TempInvoicingSpecification,Consume);
    end;


    procedure DeleteInvoiceSpecFromHeader(var ServHeader: Record "Service Header")
    begin
        ReserveServLine.DeleteInvoiceSpecFromHeader(ServHeader);
    end;


    procedure InsertShptEntryRelation(var ServiceShptLine: Record "Service Shipment Line";var TempHandlingSpecification: Record "Tracking Specification";var TempTrackingSpecificationInv: Record "Tracking Specification";ItemLedgShptEntryNo: Integer): Integer
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        TempTrackingSpecificationInv.Reset;
        if TempTrackingSpecificationInv.Find('-') then begin
          repeat
            TempHandlingSpecification := TempTrackingSpecificationInv;
            if TempHandlingSpecification.Insert then;
          until TempTrackingSpecificationInv.Next = 0;
          TempTrackingSpecificationInv.DeleteAll;
        end;

        TempHandlingSpecification.Reset;
        if TempHandlingSpecification.Find('-') then begin
          repeat
            ItemEntryRelation.Init;
            ItemEntryRelation."Item Entry No." := TempHandlingSpecification."Entry No.";
            ItemEntryRelation."Serial No." := TempHandlingSpecification."Serial No.";
            ItemEntryRelation."Lot No." := TempHandlingSpecification."Lot No.";
            ItemEntryRelation.TransferFieldsServShptLine(ServiceShptLine);
            ItemEntryRelation.Insert;
          until TempHandlingSpecification.Next = 0;
          TempHandlingSpecification.DeleteAll;
          exit(0);
        end;
        exit(ItemLedgShptEntryNo);
    end;


    procedure InsertValueEntryRelation(var TempValueEntryRelation: Record "Value Entry Relation")
    var
        ValueEntryRelation: Record "Value Entry Relation";
    begin
        TempValueEntryRelation.Reset;
        if TempValueEntryRelation.Find('-') then begin
          repeat
            ValueEntryRelation := TempValueEntryRelation;
            ValueEntryRelation.Insert;
          until TempValueEntryRelation.Next = 0;
          TempValueEntryRelation.DeleteAll;
        end;
    end;


    procedure TransServLineToItemJnlLine(var ServiceLine: Record "Service Line";var ItemJnlLine: Record "Item Journal Line";QtyToBeShippedBase: Decimal;var CheckApplFromItemEntry: Boolean)
    begin
        ReserveServLine.TransServLineToItemJnlLine(ServiceLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry);
    end;


    procedure TransferReservToItemJnlLine(var ServiceLine: Record "Service Line";var ItemJnlLine: Record "Item Journal Line";QtyToBeShippedBase: Decimal;var CheckApplFromItemEntry: Boolean)
    begin
        if QtyToBeShippedBase = 0 then
          exit;
        Clear(ReserveServLine);
        ReserveServLine.TransServLineToItemJnlLine(
          ServiceLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry)
    end;


    procedure SplitWhseJnlLine(var TempWhseJnlLine: Record "Warehouse Journal Line";var TempWhseJnlLine2: Record "Warehouse Journal Line";var TempTrackingSpecification: Record "Tracking Specification";ToTransfer: Boolean)
    begin
        ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine,TempWhseJnlLine2,TempTrackingSpecification,ToTransfer);
    end;


    procedure AdjustQuantityRounding(RemQtyToBeInvoiced: Decimal;QtyToBeInvoiced: Decimal;RemQtyToBeInvoicedBase: Decimal;QtyToBeInvoicedBase: Decimal)
    begin
        ItemTrackingMgt.AdjustQuantityRounding(
          RemQtyToBeInvoiced,QtyToBeInvoiced,
          RemQtyToBeInvoicedBase,QtyToBeInvoicedBase);
    end;
}

