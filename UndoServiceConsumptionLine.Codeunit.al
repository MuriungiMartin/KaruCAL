#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5819 "Undo Service Consumption Line"
{
    Permissions = TableData "Item Ledger Entry"=m,
                  TableData "Item Application Entry"=rmd,
                  TableData "Reservation Worksheet Log"=imd,
                  TableData "Service Line"=imd,
                  TableData "Service Ledger Entry"=rimd,
                  TableData "Warranty Ledger Entry"=im,
                  TableData "Service Shipment Line"=imd,
                  TableData "Item Entry Relation"=ri;
    TableNo = "Service Shipment Line";

    trigger OnRun()
    begin
        if not Find('-') then
          exit;

        if not HideDialog then
          if not Confirm(Text000) then
            exit;

        LockTable;
        ServShptLine.Copy(Rec);
        Code;
        Rec := ServShptLine;
    end;

    var
        ServShptHeader: Record "Service Shipment Header";
        ServShptLine: Record "Service Shipment Line";
        TempGlobalItemLedgEntry: Record "Item Ledger Entry" temporary;
        TempGlobalItemEntryRelation: Record "Item Entry Relation" temporary;
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        TempTrkgItemLedgEntry2: Record "Item Ledger Entry" temporary;
        InvtSetup: Record "Inventory Setup";
        SourceCodeSetup: Record "Source Code Setup";
        DummyItemJnlLine: Record "Item Journal Line";
        TempWhseJnlLine: Record "Warehouse Journal Line" temporary;
        WhseUndoQty: Codeunit "Whse. Undo Quantity";
        UndoPostingMgt: Codeunit "Undo Posting Management";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        Text000: label 'Do you want to undo consumption of the selected shipment line(s)?';
        Text001: label 'Undo quantity consumed posting...';
        Text002: label 'There is not enough space to insert correction lines.';
        InvtAdjmt: Codeunit "Inventory Adjustment";
        TrackingSpecificationExists: Boolean;
        HideDialog: Boolean;
        Text003: label 'Checking lines...';
        Text004: label 'You cannot undo consumption on the line because it has been already posted to Jobs.';
        Text005: label 'You cannot undo consumption because the original service order %1 is already closed.';
        NextLineNo: Integer;


    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    local procedure "Code"()
    var
        Window: Dialog;
        ItemShptEntryNo: Integer;
    begin
        with ServShptLine do begin
          Clear(ItemJnlPostLine);
          SetRange(Correction,false);
          Find('-');
          repeat
            if not HideDialog then
              Window.Open(Text003);
            CheckServShptLine(ServShptLine);
          until Next = 0;

          Find('-');
          repeat
            if Quantity <> "Qty. Shipped Not Invoiced" then begin
              TempGlobalItemLedgEntry.Reset;
              if not TempGlobalItemLedgEntry.IsEmpty then
                TempGlobalItemLedgEntry.DeleteAll;
              TempGlobalItemEntryRelation.Reset;
              if not TempGlobalItemEntryRelation.IsEmpty then
                TempGlobalItemEntryRelation.DeleteAll;

              if not HideDialog then
                Window.Open(Text001);

              if Type = Type::Item then begin
                CollectItemLedgerEntries(ServShptLine,TempTrkgItemLedgEntry);
                ItemShptEntryNo := PostItemJnlLine(ServShptLine,"Item Shpt. Entry No.",
                    Quantity,"Quantity (Base)",
                    Quantity,"Quantity (Base)",
                    DummyItemJnlLine."entry type"::"Positive Adjmt.");
              end;
              if Type = Type::Resource then
                PostResourceJnlLine(ServShptLine);
              if Type in [Type::Cost,Type::"G/L Account"] then
                PostGenJnlLine(ServShptLine);
              InsertCorrectiveShipmentLine(ServShptLine,ItemShptEntryNo);
              ReverseCnsmServLedgEntries(ServShptLine);
              if Type in [Type::Item,Type::Resource] then
                InsertNewWarrantyEntry(ServShptLine);
              UpdateOrderLine(ServShptLine);
              UpdateServShptLine(ServShptLine);
            end;
          until Next = 0;
          InvtSetup.Get;
          if InvtSetup."Automatic Cost Adjustment" <>
             InvtSetup."automatic cost adjustment"::Never
          then begin
            ServShptHeader.Get("Document No.");
            InvtAdjmt.SetProperties(true,InvtSetup."Automatic Cost Posting");
            InvtAdjmt.MakeMultiLevelAdjmt;
          end;
          WhseUndoQty.PostTempWhseJnlLine(TempWhseJnlLine);
        end;
    end;

    local procedure CheckServShptLine(var ServShptLine: Record "Service Shipment Line")
    var
        ServLine: Record "Service Line";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ServiceLedgerEntry: Record "Service Ledger Entry";
    begin
        with ServShptLine do begin
          TestField("Quantity Invoiced",0);
          TestField("Quantity Consumed");
          TestField("Qty. Shipped Not Invoiced",Quantity - "Quantity Consumed");

          // Check if there was consumption posted to jobs
          ServiceLedgerEntry.Reset;
          ServiceLedgerEntry.SetRange("Document No.","Document No.");
          ServiceLedgerEntry.SetRange("Posting Date","Posting Date");
          ServiceLedgerEntry.SetRange("Document Line No.","Line No.");
          ServiceLedgerEntry.SetRange("Service Order No.","Order No.");
          ServiceLedgerEntry.SetRange("Job Posted",true);
          if not ServiceLedgerEntry.IsEmpty then
            Error(Text004);

          if not ServLine.Get(ServLine."document type"::Order,"Order No.","Order Line No.") then
            Error(Text005,"Order No.");
          UndoPostingMgt.TestServShptLine(ServShptLine);
          if Type = Type::Item then begin
            UndoPostingMgt.CollectItemLedgEntries(TempItemLedgEntry,Database::"Service Shipment Line",
              "Document No.","Line No.","Quantity (Base)","Item Shpt. Entry No.");
            UndoPostingMgt.CheckItemLedgEntries(TempItemLedgEntry,"Line No.");
          end;
        end;
    end;

    local procedure CollectItemLedgerEntries(var ServShptLine: Record "Service Shipment Line";var TempItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        FromItemLedgEntry: Record "Item Ledger Entry";
        TempTrackingSpecToTest: Record "Tracking Specification" temporary;
    begin
        ServShptLine.FilterPstdDocLnItemLedgEntries(FromItemLedgEntry);
        ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempItemLedgEntry,FromItemLedgEntry);
        ItemTrackingDocMgt.RetrieveDocumentItemTracking(TempTrackingSpecToTest,
          ServShptLine."Document No.",Database::"Service Shipment Header",0);   // 0 - no doctype
        TrackingSpecificationExists := (TempTrackingSpecToTest.Count <> 0);
    end;

    local procedure PostItemJnlLine(ServShptLine: Record "Service Shipment Line";ItemEntryNo: Integer;QtyToShip: Decimal;QtyToShipBase: Decimal;QtyToConsume: Decimal;QtyToConsumeBase: Decimal;EntryType: Integer): Integer
    var
        ItemJnlLine: Record "Item Journal Line";
        ServiceLine: Record "Service Line";
        SignFactor: Integer;
    begin
        SourceCodeSetup.Get;
        ServShptHeader.Get(ServShptLine."Document No.");

        with ItemJnlLine do begin
          Init;
          "Entry Type" := EntryType;
          "Document Line No." :=
            ServShptLine."Line No." + GetCorrectiveShptLineNoStep(ServShptLine."Document No.",ServShptLine."Line No.");

          CopyDocumentFields("document type"::"Service Shipment",ServShptHeader."No.",'',SourceCodeSetup."Service Management",'');

          CopyFromServShptHeader(ServShptHeader);
          CopyFromServShptLineUndo(ServShptLine);

          Quantity := QtyToShip;
          "Quantity (Base)" := QtyToShipBase;
          "Invoiced Quantity" := QtyToConsume;
          "Invoiced Qty. (Base)" := QtyToConsumeBase;

          Validate("Applies-from Entry",ItemEntryNo);

          WhseUndoQty.InsertTempWhseJnlLine(ItemJnlLine,
            Database::"Service Line",ServiceLine."document type"::Order,ServShptHeader."Order No.",ServShptLine."Order Line No.",
            TempWhseJnlLine."reference document"::"Posted Shipment",TempWhseJnlLine,NextLineNo);

          if not TrackingSpecificationExists then begin
            ItemJnlPostLine.SetServUndoConsumption(true);
            ItemJnlPostLine.RunWithCheck(ItemJnlLine);
            exit("Item Shpt. Entry No.");
          end;

          TempTrkgItemLedgEntry.Reset;
          if QtyToConsume <> 0 then begin
            SignFactor := 1;
            TempTrkgItemLedgEntry2.DeleteAll;
            TempTrkgItemLedgEntry.Reset;
            if TempTrkgItemLedgEntry.FindFirst then
              repeat
                TempTrkgItemLedgEntry2 := TempTrkgItemLedgEntry;
                TempTrkgItemLedgEntry2.Insert;
              until TempTrkgItemLedgEntry.Next = 0;
            InsertNewReservationEntries(ServShptLine,EntryType,SignFactor);
            PostItemJnlLineWithIT(ServShptLine,QtyToShip,QtyToShipBase,QtyToConsume,QtyToConsumeBase,SignFactor,EntryType);
          end;
          exit(0); // "Item Shpt. Entry No."
        end;
    end;

    local procedure PostResourceJnlLine(ServiceShptLine: Record "Service Shipment Line")
    var
        ResJnlLine: Record "Res. Journal Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
    begin
        SourceCodeSetup.Get;
        ServShptHeader.Get(ServiceShptLine."Document No.");

        with ResJnlLine do begin
          Init;
          CopyDocumentFields(ServiceShptLine."Document No.",'',SourceCodeSetup."Service Management",ServShptHeader."No. Series");

          CopyFromServShptHeader(ServShptHeader);
          CopyFromServShptLine(ServiceShptLine);
          "Source Type" := "source type"::Customer;
          "Source No." := ServShptHeader."Customer No.";

          Quantity := -ServiceShptLine."Quantity Consumed";
          "Unit Cost" := ServiceShptLine."Unit Cost (LCY)";
          "Total Cost" := ServiceShptLine."Unit Cost (LCY)" * Quantity;
          "Unit Price" := 0;
          "Total Price" := 0;
          ResJnlPostLine.RunWithCheck(ResJnlLine);
        end;
    end;

    local procedure PostItemJnlLineWithIT(var ServShptLine: Record "Service Shipment Line";QtyToShip: Decimal;QtyToShipBase: Decimal;QtyToConsume: Decimal;QtyToConsumeBase: Decimal;SignFactor: Integer;EntryType: Integer)
    var
        ItemJnlLine: Record "Item Journal Line";
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
    begin
        with ItemJnlLine do begin
          Init;
          "Entry Type" := EntryType;
          "Document Line No." :=
            ServShptLine."Line No." + GetCorrectiveShptLineNoStep(ServShptLine."Document No.",ServShptLine."Line No.");

          CopyDocumentFields(
            "document type"::"Service Shipment",ServShptLine."Document No.",'',SourceCodeSetup."Service Management",'');

          CopyFromServShptHeader(ServShptHeader);
          CopyFromServShptLineUndo(ServShptLine);

          "Source Type" := "source type"::Customer;
          "Source No." := ServShptHeader."Customer No.";
          "Derived from Blanket Order" := false;
          "Item Shpt. Entry No." := 0;
          Correction := true;

          SignFactor := 1;
          Quantity := SignFactor * QtyToShip;
          "Invoiced Quantity" := SignFactor * QtyToConsume;
          "Quantity (Base)" := SignFactor * QtyToShipBase;
          "Invoiced Qty. (Base)" := SignFactor * QtyToConsumeBase;
          "Unit Cost" := ServShptLine."Unit Cost";

          ItemTrackingMgt.AdjustQuantityRounding(QtyToShip,Quantity,QtyToShipBase,"Quantity (Base)");

          QtyToShip -= Quantity;
          QtyToShipBase -= "Quantity (Base)";
          if QtyToConsume <> 0 then begin
            QtyToConsume -= Quantity;
            QtyToConsumeBase -= "Quantity (Base)";
          end;
          UndoPostingMgt.CollectItemLedgEntries(TempItemLedgerEntry,Database::"Service Shipment Line",
            ServShptLine."Document No.",ServShptLine."Line No.",ServShptLine."Quantity (Base)",
            ServShptLine."Item Shpt. Entry No.");
          UndoPostingMgt.PostItemJnlLineAppliedToList(ItemJnlLine,TempItemLedgerEntry,
            ServShptLine.Quantity,ServShptLine."Quantity (Base)",TempGlobalItemLedgEntry,TempGlobalItemEntryRelation);
        end;
    end;

    local procedure PostGenJnlLine(ServiceShptLine: Record "Service Shipment Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        ServiceCost: Record "Service Cost";
        GeneralPostingSetup: Record "General Posting Setup";
        ServiceLine: Record "Service Line";
        CustomerPostingGroup: Record "Customer Posting Group";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        SourceCodeSetup.Get;
        with GenJnlLine do begin
          ServShptHeader.Get(ServiceShptLine."Document No.");
          ServiceLine.Get(ServiceLine."document type"::Order,ServiceShptLine."Order No.",ServiceShptLine."Order Line No.");
          InitNewLine(
            ServiceShptLine."Posting Date",ServShptHeader."Document Date",ServiceShptLine.Description,
            ServiceShptLine."Shortcut Dimension 1 Code",ServiceShptLine."Shortcut Dimension 2 Code",
            ServiceShptLine."Dimension Set ID",ServShptHeader."Reason Code");

          CopyDocumentFields(0,ServiceShptLine."Document No.",'',ServShptHeader."Source Code",ServShptHeader."No. Series");

          "Account Type" := "account type"::"G/L Account";
          if ServiceLine.Type = ServiceLine.Type::"G/L Account" then
            "Account No." := ServiceLine."No."
          else begin
            ServiceCost.Get(ServiceLine."No.");
            "Account No." := ServiceCost."Account No.";
          end;
          "Bal. Account Type" := "bal. account type"::"G/L Account";
          if ServiceLine.Type in [ServiceLine.Type::Cost,ServiceLine.Type::"G/L Account"] then begin
            GeneralPostingSetup.Get(ServiceLine."Gen. Bus. Posting Group",ServiceLine."Gen. Prod. Posting Group");
            GeneralPostingSetup.TestField("Sales Line Disc. Account");
            "Bal. Account No." := GeneralPostingSetup."Sales Line Disc. Account";
          end else begin
            CustomerPostingGroup.Get(ServShptHeader."Customer Posting Group");
            "Bal. Account No." := CustomerPostingGroup."Receivables Account";
          end;
          "Currency Code" := ServiceShptLine."Currency Code";
          Amount := ServiceShptLine."Quantity Consumed" * ServiceShptLine."Unit Price";
          "Source Currency Code" := ServiceShptLine."Currency Code";
          "Source Currency Amount" := Amount;
          if "Currency Code" = '' then
            "Currency Factor" := 1
          else
            Validate("Currency Factor",ServShptHeader."Currency Factor");
          "Job No." := ServiceLine."Job No.";
          "Source Type" := "source type"::Customer;
          "Source No." := ServiceShptLine."Bill-to Customer No.";
          "System-Created Entry" := true;

          GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;
    end;

    local procedure InsertNewReservationEntries(var ServShptLine: Record "Service Shipment Line";EntryType: Integer;SignFactor: Integer)
    var
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        ReserveEngineMgt: Codeunit "Reservation Engine Mgt.";
    begin
        with TempTrkgItemLedgEntry2 do begin
          SignFactor := -SignFactor;
          if FindSet then
            repeat
              ReservEntry.Init;
              ReservEntry."Item No." := "Item No.";
              ReservEntry."Location Code" := "Location Code";
              ReservEntry."Serial No." := "Serial No.";
              ReservEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
              ReservEntry."Lot No." := "Lot No.";
              ReservEntry."Variant Code" := "Variant Code";
              ReservEntry."Source ID" := '';
              ReservEntry."Source Type" := Database::"Item Journal Line";
              ReservEntry."Source Subtype" := EntryType;
              ReservEntry."Source Ref. No." := 0;
              ReservEntry."Appl.-from Item Entry" := "Entry No.";
              if EntryType = DummyItemJnlLine."entry type"::"Positive Adjmt." then
                ReservEntry."Reservation Status" := ReservEntry."reservation status"::Surplus
              else
                ReservEntry."Reservation Status" := ReservEntry."reservation status"::Prospect;
              ReservEntry."Quantity Invoiced (Base)" := 0;
              ReservEntry.Validate("Quantity (Base)",-Quantity);
              ReservEntry.Positive := ReservEntry."Quantity (Base)" > 0;
              ReservEntry."Entry No." := 0;
              if ReservEntry.Positive then begin
                ReservEntry."Warranty Date" := "Warranty Date";
                ReservEntry."Expiration Date" := "Expiration Date";
                ReservEntry."Expected Receipt Date" := ServShptLine."Posting Date"
              end else
                ReservEntry."Shipment Date" := ServShptLine."Posting Date";
              ReservEntry.Description := ServShptLine.Description;
              ReservEntry."Creation Date" := WorkDate;
              ReservEntry."Created By" := UserId;
              ReservEntry.UpdateItemTracking;
              ReservEntry."Appl.-to Item Entry" := "Entry No.";
              ReservEntry.Insert;
              TempReservEntry := ReservEntry;
              TempReservEntry.Insert;
            until Next = 0;
          ReserveEngineMgt.UpdateOrderTracking(TempReservEntry);
        end;
    end;

    local procedure InsertNewTrackSpecifications(var CurrentServShptLine: Record "Service Shipment Line";Balancing: Boolean)
    var
        TempSSLItemLedgEntry: Record "Item Ledger Entry" temporary;
    begin
        // replace in tracking specification old item entry relation for a new one, and adjust qtys
        TempTrkgItemLedgEntry.Reset;
        if TempTrkgItemLedgEntry.FindFirst then begin
          TempSSLItemLedgEntry.Reset;
          TempSSLItemLedgEntry.DeleteAll;
          CollectItemLedgerEntries(CurrentServShptLine,TempSSLItemLedgEntry);
          if TempSSLItemLedgEntry.FindFirst then
            repeat
              InsertOneNewTrackSpec(TempTrkgItemLedgEntry."Entry No.",TempSSLItemLedgEntry."Entry No.",Balancing);

              // collect/add another value entry relation, for the future new line
              TempGlobalItemEntryRelation."Item Entry No." := TempSSLItemLedgEntry."Entry No.";
              TempGlobalItemEntryRelation."Serial No." := TempSSLItemLedgEntry."Serial No.";
              TempGlobalItemEntryRelation."Lot No." := TempSSLItemLedgEntry."Lot No.";
              if TempGlobalItemEntryRelation.Insert then;

              TempSSLItemLedgEntry.Next;
            until TempTrkgItemLedgEntry.Next = 0;
        end;
    end;

    local procedure InsertOneNewTrackSpec(OldItemShptEntryNo: Integer;NewItemShptEntryNo: Integer;Balancing: Boolean)
    var
        TrackingSpecification: Record "Tracking Specification";
        NewTrackingSpecification: Record "Tracking Specification";
        NewEntryNo: Integer;
    begin
        with TrackingSpecification do begin
          Reset;
          SetRange("Item Ledger Entry No.",OldItemShptEntryNo);
          if FindFirst then begin
            NewTrackingSpecification.LockTable;
            NewTrackingSpecification.Reset;
            if NewTrackingSpecification.FindLast then
              NewEntryNo := NewTrackingSpecification."Entry No." + 1
            else
              NewEntryNo := 1;
            NewTrackingSpecification.Init;
            NewTrackingSpecification := TrackingSpecification;
            NewTrackingSpecification."Entry No." := NewEntryNo;
            NewTrackingSpecification."Item Ledger Entry No." := NewItemShptEntryNo;
            if Balancing then begin
              NewTrackingSpecification."Quantity (Base)" := -"Quantity (Base)";
              NewTrackingSpecification."Quantity Handled (Base)" := -"Quantity (Base)";
              NewTrackingSpecification."Quantity Invoiced (Base)" := -"Quantity (Base)";
            end else begin
              NewTrackingSpecification."Quantity (Base)" := "Quantity (Base)";
              NewTrackingSpecification."Quantity Handled (Base)" := "Quantity (Base)";
              NewTrackingSpecification."Quantity Invoiced (Base)" := 0;
            end;
            NewTrackingSpecification.Validate("Quantity (Base)");
            NewTrackingSpecification.Insert;
          end;
        end;
    end;

    local procedure InsertNewWarrantyEntry(var ServShptLine: Record "Service Shipment Line")
    var
        WarrantyLedgEntry: Record "Warranty Ledger Entry";
        NewWarrantyLedgEntry: Record "Warranty Ledger Entry";
        ServLedgEntriesPost: Codeunit "ServLedgEntries-Post";
        ServLedgEntryNo: Integer;
        WarrantyLedgEntryNo: Integer;
    begin
        WarrantyLedgEntry.LockTable;
        if WarrantyLedgEntry.Get(ServShptLine."Appl.-to Warranty Entry") then begin
          ServLedgEntriesPost.InitServiceRegister(ServLedgEntryNo,WarrantyLedgEntryNo);
          WarrantyLedgEntry.Open := false;
          WarrantyLedgEntry.Modify;
          NewWarrantyLedgEntry := WarrantyLedgEntry;
          NewWarrantyLedgEntry."Entry No." := WarrantyLedgEntryNo;
          InvertWarrantyLedgEntry(NewWarrantyLedgEntry);
          NewWarrantyLedgEntry.Insert;
          ServLedgEntriesPost.FinishServiceRegister(ServLedgEntryNo,WarrantyLedgEntryNo);
        end;
    end;

    local procedure InvertWarrantyLedgEntry(var WarrantyLedgEntry: Record "Warranty Ledger Entry")
    begin
        with WarrantyLedgEntry do begin
          Amount := -Amount;
          Quantity := -Quantity;
        end;
    end;

    local procedure GetCorrectiveShptLineNoStep(DocumentNo: Code[20];LineNo: Integer) LineSpacing: Integer
    var
        TestServShptLine: Record "Service Shipment Line";
    begin
        TestServShptLine.SetRange("Document No.",DocumentNo);
        TestServShptLine."Document No." := DocumentNo;
        TestServShptLine."Line No." := LineNo;
        TestServShptLine.Find('=');

        if TestServShptLine.Find('>') then begin
          LineSpacing := (TestServShptLine."Line No." - LineNo) DIV 2;
          if LineSpacing = 0 then
            Error(Text002);
        end else
          LineSpacing := 10000;
    end;

    local procedure InsertCorrectiveShipmentLine(OldServShptLine: Record "Service Shipment Line";ItemShptEntryNo: Integer)
    var
        NewServShptLine: Record "Service Shipment Line";
        LineSpacing: Integer;
    begin
        with OldServShptLine do begin
          LineSpacing := GetCorrectiveShptLineNoStep("Document No.","Line No.");
          NewServShptLine.Reset;
          NewServShptLine.Init;
          NewServShptLine.Copy(OldServShptLine);
          NewServShptLine."Line No." := "Line No." + LineSpacing;
          NewServShptLine."Item Shpt. Entry No." := ItemShptEntryNo;
          NewServShptLine."Appl.-to Service Entry" := "Appl.-to Service Entry";
          NewServShptLine.Quantity := -Quantity;
          NewServShptLine."Quantity (Base)" := -"Quantity (Base)";
          NewServShptLine."Qty. Shipped Not Invoiced" := 0;
          NewServShptLine."Qty. Shipped Not Invd. (Base)" := 0;
          NewServShptLine."Quantity Consumed" := NewServShptLine.Quantity;
          NewServShptLine."Qty. Consumed (Base)" := NewServShptLine."Quantity (Base)";
          NewServShptLine.Correction := true;
          NewServShptLine.Insert;

          UpdateItemJnlLine(NewServShptLine,ItemShptEntryNo);
          if Type = Type::Item then begin
            InsertNewTrackSpecifications(NewServShptLine,true);
            InsertItemEntryRelation(TempGlobalItemEntryRelation,NewServShptLine);
          end;
        end;
    end;

    local procedure UpdateOrderLine(ServShptLine: Record "Service Shipment Line")
    var
        ServLine: Record "Service Line";
    begin
        with ServShptLine do begin
          ServLine.Get(ServLine."document type"::Order,"Order No.","Order Line No.");
          UndoPostingMgt.UpdateServLineCnsm(ServLine,"Quantity Consumed","Qty. Consumed (Base)",TempGlobalItemLedgEntry);
        end;
    end;

    local procedure UpdateServShptLine(var PassedServShptLine: Record "Service Shipment Line")
    begin
        with PassedServShptLine do begin
          "Quantity Consumed" := Quantity;
          "Qty. Consumed (Base)" := "Quantity (Base)";
          "Qty. Shipped Not Invoiced" := 0;
          "Qty. Shipped Not Invd. (Base)" := 0;
          Correction := true;
          Modify;
        end;
    end;

    local procedure InsertItemEntryRelation(var TempItemEntryRelation: Record "Item Entry Relation" temporary;NewServShptLine: Record "Service Shipment Line")
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        if TempItemEntryRelation.Find('-') then
          repeat
            ItemEntryRelation := TempItemEntryRelation;
            ItemEntryRelation.TransferFieldsServShptLine(NewServShptLine);
            ItemEntryRelation.Insert;
          until TempItemEntryRelation.Next = 0;
        TempItemEntryRelation.DeleteAll;
    end;

    local procedure ReverseCnsmServLedgEntries(ServShptLine: Record "Service Shipment Line")
    var
        ServLine: Record "Service Line";
        ServLedgEntry: Record "Service Ledger Entry";
        NewServLedgEntryTemp: Record "Service Ledger Entry" temporary;
        ServLedgEntriesPost: Codeunit "ServLedgEntries-Post";
        ServLedgEntryNo: Integer;
        WarrantyLedgEntryNo: Integer;
    begin
        ServLedgEntry.LockTable;
        ServLedgEntry.Reset;
        ServLine.Get(ServLine."document type"::Order,ServShptLine."Order No.",ServShptLine."Order Line No.");
        ServLedgEntry.SetCurrentkey("Entry Type","Document Type","Document No.","Document Line No.");
        ServLedgEntry.SetFilter("Entry Type",'%1|%2',ServLedgEntry."entry type"::Consume,ServLedgEntry."entry type"::Usage);
        ServLedgEntry.SetRange("Document Type",ServLedgEntry."document type"::Shipment);
        ServLedgEntry.SetRange("Document No.",ServShptLine."Document No.");
        ServLedgEntry.SetRange("Document Line No.",ServShptLine."Line No.");
        if ServLedgEntry.Find('-') then begin
          ServLedgEntriesPost.InitServiceRegister(ServLedgEntryNo,WarrantyLedgEntryNo);
          repeat
            NewServLedgEntryTemp.Copy(ServLedgEntry);
            InvertServLedgEntry(NewServLedgEntryTemp);
            NewServLedgEntryTemp."Entry No." := ServLedgEntryNo;
            NewServLedgEntryTemp.Insert;
            ServLedgEntryNo += 1;
          until ServLedgEntry.Next = 0;

          with NewServLedgEntryTemp do begin
            Reset;
            if FindSet then
              repeat
                ServLedgEntry.Init;
                ServLedgEntry.Copy(NewServLedgEntryTemp);
                ServLedgEntry.Insert;
              until Next = 0;
            DeleteAll;
          end;

          ServLedgEntriesPost.FinishServiceRegister(ServLedgEntryNo,WarrantyLedgEntryNo);
        end;
    end;

    local procedure InvertServLedgEntry(var ServLedgEntry: Record "Service Ledger Entry")
    begin
        with ServLedgEntry do begin
          Amount := -Amount;
          "Amount (LCY)" := -"Amount (LCY)";
          "Cost Amount" := -"Cost Amount";
          "Contract Disc. Amount" := -"Contract Disc. Amount";
          "Discount Amount" := -"Discount Amount";
          "Charged Qty." := -"Charged Qty.";
          Quantity := -Quantity;
        end;
    end;

    local procedure UpdateItemJnlLine(NewServShptLine: Record "Service Shipment Line";ItemShptEntryNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        if ItemLedgEntry.Get(ItemShptEntryNo) then begin
          ItemLedgEntry."Document Line No." := NewServShptLine."Line No.";
          ItemLedgEntry.Modify;
        end;
    end;
}

